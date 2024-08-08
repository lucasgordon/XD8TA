class AddXUsernameAndXIdToAnalyticsChats < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_chats, :x_username, :string
    add_column :analytics_chats, :x_id, :integer
  end
end
