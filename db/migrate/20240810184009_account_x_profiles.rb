class AccountXProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :account_x_profiles do |t|
      t.string "x_username"
      t.string "x_id"
      t.boolean "verified"
      t.string "profile_image_url"
      t.timestamps
    end

  end
end
