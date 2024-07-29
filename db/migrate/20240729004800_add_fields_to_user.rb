class AddFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :protected, :boolean
    add_column :users, :verified, :boolean
    add_column :users, :pinned_tweet_id, :string
    add_column :users, :profile_image_url, :string
    add_column :users, :followers_count, :integer
    add_column :users, :following_count, :integer
    add_column :users, :tweet_count, :integer
    add_column :users, :listed_count, :integer
    add_column :users, :like_count, :integer
    add_column :users, :description, :text
    add_column :users, :location, :string
    add_column :users, :x_account_created_at, :string
  end
end
