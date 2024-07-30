class CreateAnalyticsChats < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_chats do |t|
      t.references :analytic, null: false, foreign_key: true
      t.string :user_prompt
      t.string :prompt_temperature
      t.string :agent_response
      t.timestamps
    end
  end
end
