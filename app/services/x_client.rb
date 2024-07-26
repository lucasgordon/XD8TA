require 'json'
require 'typhoeus'
require 'simple_oauth'

class XClient
  BASE_URL = "https://api.twitter.com/2/users/"

  def initialize(user_id)
    @user_id = user_id
  end

  def fetch_and_save_tweets
    # Change max_results to 2 to only fetch the last two tweets
    url = "#{BASE_URL}#{@user_id}/tweets?max_results=5&tweet.fields=public_metrics,created_at"
    data = fetch_twitter_data(url, {})
    debugger

    if data['data'] && !data['data'].empty?
      data['data'].each do |tweet|
        debugger
        Post.create!(
          post_id: tweet['id'],
          text: tweet['text'],
          retweet_count: tweet['public_metrics']['retweet_count'],
          reply_count: tweet['public_metrics']['reply_count'],
          like_count: tweet['public_metrics']['like_count'],
          quote_count: tweet['public_metrics']['quote_count'],
          bookmark_count: tweet['public_metrics']['bookmark_count'] || 0,  # Assuming default value
          impression_count: tweet['public_metrics']['impression_count'] || 0,  # Assuming default value
          post_created_at: tweet['created_at'],
          user_id: 1, ## curent user not working
        )
      end
      "Last two tweets saved successfully."
    else
      "No tweets found or an error occurred."
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
