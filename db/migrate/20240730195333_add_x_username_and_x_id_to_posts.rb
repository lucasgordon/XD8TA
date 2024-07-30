class AddXUsernameAndXIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :x_username, :string
    add_column :posts, :x_id, :integer
  end
end
