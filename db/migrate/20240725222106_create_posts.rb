class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :post_id
      t.text :text
      t.integer :retweet_count
      t.integer :reply_count
      t.integer :like_count
      t.integer :quote_count
      t.integer :bookmark_count
      t.integer :impression_count
      t.datetime :post_created_at

      t.timestamps
    end
  end
end
