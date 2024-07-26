require 'oauth'
require 'json'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'

class XClient
  USER_TWEETS_URL = "https://api.twitter.com/2/tweets/search/recent"

  attr_reader :authorization_url
  attr_reader :consumer

  def initialize(user)
    @user = user
    @consumer_key = ENV["CONSUMER_KEY"]
    @consumer_secret = ENV["CONSUMER_SECRET"]
    @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret,
                                    site: 'https://api.twitter.com',
                                    authorize_path: '/oauth/authenticate',
                                    debug_output: false)
  end

  def get_request_token
    @consumer.get_request_token
  end

  def get_user_authorization(request_token)
    @authorization_url = request_token.authorize_url
  end

  def obtain_access_token(request_token, pin)
    hash = { oauth_token: request_token.token, oauth_token_secret: request_token.secret }
    request_token = OAuth::RequestToken.from_hash(@consumer, hash)
    request_token.get_access_token(oauth_verifier: pin)
  end

  def fetch_tweets
    query_params = {
      "query": "from:#{@user.x_username}",
      "tweet.fields": "created_at,public_metrics",
      "max_results": "100"
    }
    oauth_params = {
      consumer: @consumer,
      token: @access_token,
      request_uri: USER_TWEETS_URL,
      signature_method: 'HMAC-SHA1',
      scheme: 'header',
      oauth_version: '1.0a'  # Explicitly set the OAuth version here
    }
    options = {
      method: :get,
      headers: { "User-Agent": "v2TweetLookupRuby" },
      params: query_params
    }
    request = Typhoeus::Request.new(USER_TWEETS_URL, options)
    oauth_helper = OAuth::Client::Helper.new(request, oauth_params)
    request.options[:headers].merge!("Authorization" => oauth_helper.header) # Signs the request
    debugger
    response = request.run

    if response.code == 200
      save_tweets(JSON.parse(response.body))
    else
      puts "Error fetching tweets: #{response.body}"
    end
  end

  def save_tweets(data)
    return unless data['data']

    debugger

    data['data'].each do |tweet|
      Post.create(
        post_id: tweet['id'],
        text: tweet['text'],
        retweet_count: tweet['public_metrics']['retweet_count'],
        reply_count: tweet['public_metrics']['reply_count'],
        like_count: tweet['public_metrics']['like_count'],
        quote_count: tweet['public_metrics']['quote_count'],
        bookmark_count: tweet['public_metrics']['bookmark_count'],  # Assuming default value
        impression_count: tweet['public_metrics']['impression_count'],
        post_created_at: tweet['created_at'],
        user_id: @user.id
      )
    end
  end

  def perform_full_auth_and_fetch
    request_token = get_request_token
    pin = get_user_authorization(request_token)
    @access_token = obtain_access_token(request_token, pin)
    fetch_tweets
  end
end
