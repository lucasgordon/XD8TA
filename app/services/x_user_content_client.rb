require 'json'
require 'typhoeus'
require 'simple_oauth'

class XUserContentClient
  BASE_URL = "https://api.twitter.com/2/users/"

  def initialize(user)
    @user_id = user.id
    if user.x_id.nil?
      @x_id = find_user_x_id(user)
      user.update!(x_id: @x_id)
    else
      @x_id = user.x_id
    end
  end

  def find_user_x_id(user)
    @username = user.x_username
    url = "https://api.twitter.com/2/users/by/username/#{@username}"
    data = fetch_twitter_data(url, {})
    data['data']['id']
  end

  def fetch_and_save_tweets
    url = "#{BASE_URL}#{@x_id}/tweets?max_results=100&tweet.fields=public_metrics,created_at,text"
    data = fetch_twitter_data(url, {})

    if data['data'] && !data['data'].empty?
      data['data'].each do |tweet|

        next if tweet['text'].include? "RT @"

        Post.create!(
          post_id: tweet['id'],
          text: tweet['text'],
          retweet_count: tweet['public_metrics']['retweet_count'],
          reply_count: tweet['public_metrics']['reply_count'],
          like_count: tweet['public_metrics']['like_count'],
          quote_count: tweet['public_metrics']['quote_count'],
          bookmark_count: tweet['public_metrics']['bookmark_count'] || 0,
          impression_count: tweet['public_metrics']['impression_count'] || 0,
          post_created_at: tweet['created_at'],
          user_id: @user_id,
        )
      end
    end
  end

  def test_fetch_tweets
    url = "#{BASE_URL}#{@x_id}/tweets?max_results=5" +
      "&tweet.fields=id,text,attachments,author_id,non_public_metrics,organic_metrics,created_at,geo,in_reply_to_user_id,lang,public_metrics"
    data = fetch_twitter_data(url, {})
    debugger
  end

  private

  def oauth_header(url, method, params)
    SimpleOAuth::Header.new(method, url, params, {
      consumer_key: ENV["CONSUMER_KEY"],
      consumer_secret: ENV["CONSUMER_SECRET"],
      token: ENV["ACCESS_TOKEN"],
      token_secret: ENV["ACCESS_SECRET_TOKEN"]
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
