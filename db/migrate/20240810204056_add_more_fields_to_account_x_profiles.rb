class AddMoreFieldsToAccountXProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :account_x_profiles, :pinned_tweet_id, :string
    add_column :account_x_profiles, :followers_count, :bigint
    add_column :account_x_profiles, :following_count, :bigint
    add_column :account_x_profiles, :tweet_count, :bigint
    add_column :account_x_profiles, :listed_count, :bigint
    add_column :account_x_profiles, :like_count, :bigint
    add_column :account_x_profiles, :description, :text
    add_column :account_x_profiles, :location, :string
    add_column :account_x_profiles, :x_account_created_at, :string
    end

  end
