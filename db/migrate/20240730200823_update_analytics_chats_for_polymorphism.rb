class UpdateAnalyticsChatsForPolymorphism < ActiveRecord::Migration[7.1]
  def change
    remove_index :analytics_chats, name: 'index_analytics_chats_on_analytic_id'

    add_column :analytics_chats, :analytic_type, :string
    add_index :analytics_chats, [:analytic_id, :analytic_type], unique: true, name: 'index_analytics_chats_on_analytic'
  end
end
