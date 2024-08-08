class RemoveUniqueIndexFromAnalyticType < ActiveRecord::Migration[7.1]
  def change
    remove_index :analytics_chats, name: "index_analytics_chats_on_analytic", unique: true
  end
end
