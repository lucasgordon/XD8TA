require 'json'

module Prompts
  class AnalyticsChatPrompt
    def initialize(analytic_chat)
      @analytic_chat = analytic_chat
      @message_history = analytic_chat.messages
      @username = get_username(@analytic_chat)
      @posts = Post.where(x_username: @username)
      @account_information = AccountXProfile.find_by(x_username: @username)
    end

    def get_username(analytic_chat)
      analytic_chat.x_username
    end

    def system_prompt
      <<~SYSTEM_PROMPT
        Format your response using markdown.

        You are an expert at X / Twitter analytics. Your job is to analyze a user's post data and provide insights based on the data provided. Your
        insights should help debug why a user's post is not performing well or why it is performing well. You are highly analytical, so use evidence from your data where relevant.
        Compare and contrast to other post data from the same user to strengthen your analysis.

        The account you are analyzing is #{@username}.

        Here is information about the account:
        #{user_account_information}

        The user will ask you follow on questions and you are to respond in maximum 5 sentences using information given to you from the user's post analytics as evidence and your own conclusions.
        You are allowed to draw your own analyses from the data. You can also draw conclusions like "Why do you think the post was successful?"

        Speak in a normal conversational tone. DO NOT prefix your response with "based on the data provided" or similar preambles. Just get right into your answer.

        BE concise. Offer examples. Draw thoughtful conclusions. When responding, use the username of the user in your response in third-person.

        The data of post information:

        #{user_post_analytics}

        The history of the chat conversations so far is:

        #{chat_history}

      SYSTEM_PROMPT
    end

    def chat_history
      history_array = @message_history.map do |message|
        {
          user_prompt: message.user_prompt,
          agent_response: message.agent_response,
          created_at: message.created_at
        }
      end
      JSON.pretty_generate(history_array)
    end

    def user_account_information
      {
        "Username" => @username,
        "X ID" => @account_information.x_id,
        "Followers Count" => @account_information.followers_count,
        "Following Count" => @account_information.following_count,
        "Tweet Count" => @account_information.tweet_count,
        "Listed Count" => @account_information.listed_count,
        "Like Count" => @account_information.like_count,
        "Account bio" => @account_information.description,
        "Where the user lives" => @account_information.location,
        "X Account Created At" => @account_information.x_account_created_at,
        "Pinned tweet ID" => @account_information.pinned_tweet_id
    }.to_s
    end

    def user_post_analytics
      posts_details = @posts.map do |post|
        {
          "Text" => post.text,
          "Retweet Count" => post.retweet_count,
          "Reply Count" => post.reply_count,
          "Like Count" => post.like_count,
          "Quote Count" => post.quote_count,
          "Bookmark Count" => post.bookmark_count,
          "Impression Count" => post.impression_count,
          "Post Created At" => post.post_created_at,
          "Language" => post.lang,
          "User Profile Clicks" => post.user_profile_clicks,
          # "Engagements" => post.engagements,
          # "Annotations" => format_annotations(post),
          # "Mentions" => format_mentions(post)
        }
      end

      prompt_hash = {
        "username" => @username,
        "posts" => posts_details
      }

      JSON.pretty_generate(prompt_hash)
    end


    private

    def format_annotations(post)
      post.context_annotation_domains.map do |domain|
        {
          "Domain" => domain.domain_name,
          "Description" => domain.domain_description,
          "Entity" => domain.entity_name,
          "Entity Description" => domain.entity_description
        }
      end
    end

    def format_mentions(post)
      post.post_mentions.map do |mention|
        {
          "Mentioned User ID" => mention.mentioned_user_id,
          "Mentioned Username" => mention.mentioned_username
        }
      end
    end
  end
end
