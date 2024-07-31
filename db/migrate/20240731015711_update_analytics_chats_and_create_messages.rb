class UpdateAnalyticsChatsAndCreateMessages < ActiveRecord::Migration[7.1]
  def change
    change_table :analytics_chats do |t|
      t.remove :agent_response
      t.remove :user_prompt
      t.references :user, null: false, foreign_key: true
    end

    create_table :messages do |t|
      t.references :analytics_chat, null: false, foreign_key: true
      t.string :agent_response
      t.string :user_prompt

      t.timestamps
    end
  end
end
