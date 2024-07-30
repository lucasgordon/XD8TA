class CreateAnalytics < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics do |t|
      t.references :user, null: false, foreign_key: true
      t.string :best_post
      t.string :worst_post
      t.string :most_liked_post
      t.string :most_replied_post
      t.string :future_post_ideas
      t.string :who_user_converses_with_most
      t.string :what_user_posts_about_most
      t.string :what_time_has_best_engagement
      t.string :what_topics_have_best_engagement
      t.string :what_topics_have_worst_engagement
      t.string :what_time_has_worst_engagement
      t.string :what_entities_in_which_order_have_best_engagement
      t.timestamps
    end
  end
end
