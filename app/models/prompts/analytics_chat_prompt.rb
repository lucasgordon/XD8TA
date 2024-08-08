require 'json'

module Prompts
  class AnalyticsChatPrompt
    def initialize(analytic_chat)
      @analytic_chat = analytic_chat
      @message_history = analytic_chat.messages
      @username = get_username(@analytic_chat)
      @posts = Post.where(x_username: @username)
    end

    def get_username(analytic_chat)
      analytic_chat.x_username
    end

    def system_prompt
      <<~SYSTEM_PROMPT
        Format your response using markdown. You are analyzing a series of post metrics for a user on X (formerly Twitter). The user would like to know the following about
        Twitter / X post data for #{@username}.

        The user will ask you follow on questions and you are to respond in maximum 3 sentences using information given to you from the user's post analytics as evidence and your own conclusions.
        You are allowed to draw your own analyses from the data. You can also draw conclusions like "Why do you think the post was successful?"

        Speak in a normal conversational tone. DO NOT prefix your response with "based on the data provided" or similar preambles. Just get right into your answer.

        BE concise. Offer examples. Draw thoughtful conclusions.

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
