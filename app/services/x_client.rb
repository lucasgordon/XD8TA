require 'json'
require 'typhoeus'
require 'simple_oauth'

class XClient
  BASE_URL = "https://api.twitter.com/2/users/"

  def initialize(username:, user: nil)
    @user = user
    @x_username = username
    fetch_user_x_information(@x_username)
    @x_id = AccountXProfile.find_by(x_username: @x_username).x_id
  end

  def fetch_user_x_id(username)
    url = "https://api.twitter.com/2/users/by/username/#{username}"
    data = fetch_twitter_data(url, {})
    data['data']['id'] if data['data']
  end

  def fetch_user_x_information(username)
    fields = "user.fields=created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,verified_type,withheld"
    url = "https://api.twitter.com/2/users/by/username/#{username}?#{fields}"
    data = fetch_twitter_data(url, {})

    if data['data']
      AccountXProfile.find_or_create_by(x_username: username) do |profile|
        profile.x_id = data['data']['id']
        profile.verified = data['data']['verified']
        profile.profile_image_url = data['data']['profile_image_url'].gsub!(/_normal|_bigger|_mini/, '')
      end
    end
  end

  def fetch_user_information
    fields = "user.fields=created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    url = "https://api.twitter.com/2/users/by/username/#{@x_username}?#{fields}"
    data = fetch_twitter_data(url, {})

    if data['data']
      @user.update!(
        x_id: data['data']['id'],
        protected: data['data']['protected'],
        verified: data['data']['verified'],
        pinned_tweet_id: data['data']['pinned_tweet_id'],
        profile_image_url: data['data']['profile_image_url'].gsub!(/_normal|_bigger|_mini/, ''),
        followers_count: data['data']['public_metrics']['followers_count'],
        following_count: data['data']['public_metrics']['following_count'],
        tweet_count: data['data']['public_metrics']['tweet_count'],
        listed_count: data['data']['public_metrics']['listed_count'],
        like_count: data['data']['public_metrics']['like_count'],
        description: data['data']['description'],
        location: data['data']['location'],
        x_account_created_at: data['data']['created_at']
      )

      AccountXProfile.find_or_create_by(x_username: @user.x_username) do |profile|
        profile.x_id = data['data']['id']
        profile.verified = data['data']['verified']
        profile.profile_image_url = data['data']['profile_image_url'].gsub!(/_normal|_bigger|_mini/, '')
      end
    end
  end

  def fetch_public_metrics
    url = "#{BASE_URL}#{@x_id}/tweets?max_results=100" +
    "&tweet.fields=id,text,attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,in_reply_to_user_id,lang,possibly_sensitive,public_metrics,referenced_tweets,source,withheld" +
    "&expansions=attachments.poll_ids,attachments.media_keys,author_id,referenced_tweets.id,referenced_tweets.id.author_id,in_reply_to_user_id" +
    "&user.fields=username"
    data = fetch_twitter_data(url, {})
    save_metrics(data)
  end

  def save_metrics(data)
    if data['data'] && !data['data'].empty?
      data['data'].each do |tweet|
        next if tweet['text'].include? "RT @"

        post = Post.find_or_initialize_by(post_id: tweet['id'])
        post.text = tweet['text']
        post.x_username = @x_username
        post.x_id = tweet['author_id']
        post.retweet_count = tweet['public_metrics']['retweet_count']
        post.reply_count = tweet['public_metrics']['reply_count']
        post.like_count = tweet['public_metrics']['like_count']
        post.quote_count = tweet['public_metrics']['quote_count']
        post.bookmark_count = tweet['public_metrics']['bookmark_count'] || 0
        post.impression_count = tweet['public_metrics']['impression_count'] || 0
        post.post_created_at = tweet['created_at']
        post.lang = tweet['lang']
        post.in_reply_to_user_id = tweet['in_reply_to_user_id']
        post.url = "https://x.com/#{@x_username}/status/#{tweet['id']}"

        if tweet['non_public_metrics']
          post.engagements = tweet['non_public_metrics']['engagements'] || 0
          post.user_profile_clicks = tweet['non_public_metrics']['user_profile_clicks'] || 0
        else
          post.engagements = 0
          post.user_profile_clicks = 0
        end

        post.save

        # Create or update PostMention records
        if tweet['entities'] && tweet['entities']['mentions']
          tweet['entities']['mentions'].each do |mention|
            post_mention = post.post_mentions.find_or_initialize_by(mentioned_user_id: mention['id'])
            post_mention.mentioned_username = mention['username']
            post_mention.start_location = mention['start']
            post_mention.end_location = mention['end']
            post_mention.save
          end
        end

        # Create or update EntitiesAnnotation records
        if tweet['entities'] && tweet['entities']['annotations']
          tweet['entities']['annotations'].each do |annotation|
            entities_annotation = post.entities_annotations.find_or_initialize_by(normalized_text: annotation['normalized_text'])
            entities_annotation.start_location = annotation['start']
            entities_annotation.end_location = annotation['end']
            entities_annotation.probability = annotation['probability']
            entities_annotation.annotation_type = annotation['type']
            entities_annotation.save
          end
        end

        # Create or update ContextAnnotationDomain records
        if tweet['context_annotations']
          tweet['context_annotations'].each do |context|
            entity = context['entity']
            if entity
              context_annotation_domain = post.context_annotation_domains.find_or_initialize_by(entity_name: entity['name'])
              context_annotation_domain.domain_name = context['domain']['name']
              context_annotation_domain.domain_description = context['domain']['description']
              context_annotation_domain.entity_description = entity['description']
              context_annotation_domain.save
            end
          end
        end
      end
    end
  end

  private

  def oauth_header(url, method, params)
    SimpleOAuth::Header.new(method, url, params, {
      consumer_key: ENV['CONSUMER_KEY'],
      consumer_secret: ENV['CONSUMER_SECRET'],
      token: ENV['ACCESS_TOKEN'],
      token_secret: ENV['ACCESS_SECRET_TOKEN']
    }).to_s
  end

  def fetch_twitter_data(url, params)
    header = oauth_header(url, "GET", params)
    options = {
      method: 'get',
      headers: {
        "Authorization": header,
        "User-Agent": "v2TwitterAPIRuby"
      },
      params: params
    }
    request = Typhoeus::Request.new(url, options)
    response = request.run
    puts "HTTP Status: #{response.code}"  # Debugging output
    puts "Response Body: #{response.body.force_encoding('UTF-8')}"  # Debugging output with encoding fix
    JSON.parse(response.body)
  end
end
