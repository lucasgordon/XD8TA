class AddTypeToAnalyticsChat < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_chats, :type, :string
  end
end
