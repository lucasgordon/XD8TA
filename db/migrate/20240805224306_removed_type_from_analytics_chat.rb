class RemovedTypeFromAnalyticsChat < ActiveRecord::Migration[7.1]
  def change
    remove_column :analytics_chats, :type, :string
    add_column :analytics_chats, :chat_type, :string
  end
end
