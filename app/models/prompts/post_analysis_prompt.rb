require 'json'

module Prompts
  class PostAnalysisPrompt
    def initialize(user)
      @user = user
      @posts = user.posts.includes(:context_annotation_domains, :entities_annotations, :post_mentions)
                         .order(impression_count: :desc)
    end

    def user_prompt
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
          "Engagements" => post.engagements,
          "Annotations" => format_annotations(post),
          "Mentions" => format_mentions(post)
        }
      end

      prompt_hash = {
        "username" => @user.x_username,
        "posts" => posts_details
      }

      JSON.pretty_generate(prompt_hash)
    end

    def system_prompt
      <<~SYSTEM_PROMPT
        You are analyzing a series of post metrics for a user on X (formerly Twitter). These posts are sorted by
        the impressions, from highest to lowest.
      SYSTEM_PROMPT
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
