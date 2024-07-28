class CreatePostMentions < ActiveRecord::Migration[7.1]
  def change
    create_table :post_mentions do |t|
      t.string :mentioned_user_id
      t.string :mentioned_username
      t.references :post, null: false, foreign_key: true
      t.integer :start_location
      t.integer :end_location

      t.timestamps
    end
  end
end
