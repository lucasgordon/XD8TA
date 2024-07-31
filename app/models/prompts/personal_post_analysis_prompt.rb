require 'json'

module Prompts
  class PersonalPostAnalysisPrompt
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

    def system_prompt_generator(analytic_title)
      case analytic_title
      when "top_overall"
        system_prompt_preambale + top_overall_post_preamble
      when "worst_overall"
        system_prompt_preambale + worst_overall_post
      end
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

    def system_prompt_preambale
      <<~SYSTEM_PROMPT
        You are analyzing a series of post metrics for a user on X (formerly Twitter). You are speaking with #{@user.x_username} who's full name
        is #{@user.name} (but only address the user by their first name) Respond in maximum three sentences. Draw specific analyses with
        examples and evidence. You are to analyze the information provided to you. Offer insightful conclusions and draw assumptions.

        Format your response using markdown. Your response will be displayed to the user on a website card.

        The topic the user would you like to analyze is:
      SYSTEM_PROMPT
    end

    def top_overall_post_preamble
      <<~SYSTEM_PROMPT
        Which posts performed the best in terms of impressions, likes, retweets, bookmarks, and replies? Which posts were close? Why did
        these posts perform so well?
      SYSTEM_PROMPT
    end

    def worst_overall_post
    <<~SYSTEM_PROMPT
        Which posts performed the worst in terms of impressions, likes, retweets, bookmarks, and replies? Which posts were close? Why did
        these posts perform so bad?
      SYSTEM_PROMPT
    end
  end
end
