class CreatePublicAnalytics < ActiveRecord::Migration[7.1]
  def change
    create_table :public_analytics do |t|
      t.string :x_username
      t.integer :x_id
      t.text :popular_tweet

      t.timestamps
    end
    add_index :public_analytics, :x_id
    add_foreign_key :public_analytics, :posts, column: :x_id
  end
end
