class AddFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :lang, :string
    add_column :posts, :in_reply_to_user_id, :string
    add_column :posts, :user_profile_clicks, :integer
    add_column :posts, :engagements, :integer
  end
end
