require 'json'
require 'typhoeus'
require 'simple_oauth'
require 'date'

# OAuth credentials
consumer_key = ENV['CONSUMER_KEY']
consumer_secret = ENV['CONSUMER_SECRET']
access_token = ENV['ACCESS_TOKEN']
access_token_secret = ENV['ACCESS_SECRET_TOKEN']

# User ID
user_id = "1431612698836541440"

# Base URL for Twitter API v2
base_url = "https://api.twitter.com/2/users/#{user_id}"

# OAuth header generator
def oauth_header(url, method, params)
  SimpleOAuth::Header.new(method, url, params, {
    consumer_key: ENV['CONSUMER_KEY'],
    consumer_secret: ENV['CONSUMER_SECRET'],
    token: ENV['ACCESS_TOKEN'],
    token_secret: ENV['ACCESS_SECRET_TOKEN']
  }).to_s
end

# Function to fetch data from Twitter API
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
  JSON.parse(response.body)
end

# Collect dates from different activities
def collect_activity_dates(user_id)
  urls = {
    liked_tweets: "#{base_url}/liked_tweets?max_results=100&tweet.fields=created_at",
    tweets: "#{base_url}/tweets?max_results=100&tweet.fields=created_at",
    retweets: "#{base_url}/tweets?max_results=100&tweet.fields=created_at&exclude=retweets,replies",
    replies: "#{base_url}/tweets?max_results=100&tweet.fields=created_at&exclude=retweets",
    following: "#{base_url}/following?max_results=100&user.fields=created_at"
  }
  dates = []

  urls.each do |key, url|
    loop do
      data = fetch_twitter_data(url, {})
      data['data']&.each do |item|
        dates << item['created_at']
      end
      break unless data['meta']&.key?('next_token')
      url = "#{url}&pagination_token=#{data['meta']['next_token']}"
    end
  end

  dates
end

# Execute the function
activity_dates = collect_activity_dates(user_id)
puts activity_dates.sort
