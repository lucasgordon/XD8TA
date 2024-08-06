class RemoveAnalyticIdAndAnalyticTypeFromAnalyticsChats < ActiveRecord::Migration[7.1]
  def change
    remove_column :analytics_chats, :analytic_id, :integer
    remove_column :analytics_chats, :analytic_type, :string
  end
end
