class ChangeIntegerToBigInt < ActiveRecord::Migration[7.1]
  def change
    # Change columns in analytics_chats
    change_column :analytics_chats, :x_id, :bigint

    # Change columns in entities_annotations
    change_column :entities_annotations, :start_location, :bigint
    change_column :entities_annotations, :end_location, :bigint

    # Change columns in post_mentions
    change_column :post_mentions, :start_location, :bigint
    change_column :post_mentions, :end_location, :bigint

    # Change columns in posts
    change_column :posts, :retweet_count, :bigint
    change_column :posts, :reply_count, :bigint
    change_column :posts, :like_count, :bigint
    change_column :posts, :quote_count, :bigint
    change_column :posts, :bookmark_count, :bigint
    change_column :posts, :impression_count, :bigint
    change_column :posts, :user_id, :bigint
    change_column :posts, :user_profile_clicks, :bigint
    change_column :posts, :engagements, :bigint
    change_column :posts, :x_id, :bigint

    # Change columns in public_analytics
    change_column :public_analytics, :x_id, :bigint

    # Change columns in users
    change_column :users, :x_id, :bigint
    change_column :users, :followers_count, :bigint
    change_column :users, :following_count, :bigint
    change_column :users, :tweet_count, :bigint
    change_column :users, :listed_count, :bigint
    change_column :users, :like_count, :bigint
  end
end
