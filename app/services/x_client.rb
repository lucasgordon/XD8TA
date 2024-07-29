require 'json'
require 'typhoeus'
require 'simple_oauth'

class XClient
  BASE_URL = "https://api.twitter.com/2/users/"

  def initialize(user)
    @user = user
  end

  def fetch_user_information(user)
    @username = user.x_username
    fields = "user.fields=created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    url = "https://api.twitter.com/2/users/by/username/#{@username}?#{fields}"
    data = fetch_twitter_data(url, {})

    if data['data']
      user.update!(
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
    end
  end

  def fetch_private_metrics
    url = "#{BASE_URL}#{@x_id}/tweets?max_results=30" +
    "&tweet.fields=id,text,attachments,author_id,context_annotations,conversation_id,non_public_metrics,created_at,entities,geo,in_reply_to_user_id,lang,possibly_sensitive,public_metrics,referenced_tweets,source,withheld" +
    "&expansions=attachments.poll_ids,attachments.media_keys,author_id,referenced_tweets.id,referenced_tweets.id.author_id,in_reply_to_user_id"
    data = fetch_twitter_data(url, {})
    save_metrics(data)
  end

  def fetch_public_metrics
    url = "#{BASE_URL}#{@x_id}/tweets?max_results=30" +
    "&tweet.fields=id,text,attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,in_reply_to_user_id,lang,possibly_sensitive,public_metrics,referenced_tweets,source,withheld" +
    "&expansions=attachments.poll_ids,attachments.media_keys,author_id,referenced_tweets.id,referenced_tweets.id.author_id,in_reply_to_user_id"
    data = fetch_twitter_data(url, {})
    save_metrics(data)
  end

  def save_metrics(data)
    if data['data'] && !data['data'].empty?

      data['data'].each do |tweet|
        next if tweet['text'].include? "RT @"

        post = Post.find_or_create_by(post_id: tweet['id'], user_id: @user.id) do |p|
          p.text = tweet['text']
          p.retweet_count = tweet['public_metrics']['retweet_count']
          p.reply_count = tweet['public_metrics']['reply_count']
          p.like_count = tweet['public_metrics']['like_count']
          p.quote_count = tweet['public_metrics']['quote_count']
          p.bookmark_count = tweet['public_metrics']['bookmark_count'] || 0
          p.impression_count = tweet['public_metrics']['impression_count'] || 0
          p.post_created_at = tweet['created_at']
          p.lang = tweet['lang']
          p.in_reply_to_user_id = tweet['in_reply_to_user_id']
          p.url = "https://x.com/#{@user.x_username}/status/#{tweet['id']}"

          if tweet['non_public_metrics']
            p.engagements = tweet['non_public_metrics']['engagements'] || 0
            p.user_profile_clicks = tweet['non_public_metrics']['user_profile_clicks'] || 0
          else
            p.engagements = 0
            p.user_profile_clicks = 0
          end
        end

        # Create PostMention records if any
        if tweet['entities'] && tweet['entities']['mentions']
          tweet['entities']['mentions'].each do |mention|
            post.post_mentions.find_or_create_by(mentioned_user_id: mention['id']) do |pm|
              pm.mentioned_username = mention['username']
              pm.start_location = mention['start']
              pm.end_location = mention['end']
            end
          end
        end

        # Create EntitiesAnnotation records if any
        if tweet['entities'] && tweet['entities']['annotations']
          tweet['entities']['annotations'].each do |annotation|
            post.entities_annotations.find_or_create_by(normalized_text: annotation['normalized_text']) do |ea|
              ea.start_location = annotation['start']
              ea.end_location = annotation['end']
              ea.probability = annotation['probability']
              ea.annotation_type = annotation['type']
            end
          end
          end

        # Create ContextAnnotationDomain records if any
        if tweet['context_annotations']
          tweet['context_annotations'].each do |context|
            entity = context['entity']
            if entity
              post.context_annotation_domains.find_or_create_by(entity_name: entity['name']) do |cad|
                cad.domain_name = context['domain']['name']
                cad.domain_description = context['domain']['description']
                cad.entity_description = entity['description']
              end
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
