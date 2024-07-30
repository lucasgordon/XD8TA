class RedesignAnalyticsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :analytics, :best_post, :string
    remove_column :analytics, :worst_post, :string
    remove_column :analytics, :most_liked_post, :string
    remove_column :analytics, :most_replied_post, :string
    remove_column :analytics, :future_post_ideas, :string
    remove_column :analytics, :who_user_converses_with_most, :string
    remove_column :analytics, :what_user_posts_about_most, :string
    remove_column :analytics, :what_time_has_best_engagement, :string
    remove_column :analytics, :what_topics_have_best_engagement, :string
    remove_column :analytics, :what_topics_have_worst_engagement, :string
    remove_column :analytics, :what_time_has_worst_engagement, :string
    remove_column :analytics, :what_entities_in_which_order_have_best_engagement, :string

    # Add new columns
    add_column :analytics, :title, :string
    add_column :analytics, :body, :string
  end
end
