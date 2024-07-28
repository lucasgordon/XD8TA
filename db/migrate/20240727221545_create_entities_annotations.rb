class CreateEntitiesAnnotations < ActiveRecord::Migration[7.1]
  def change
    create_table :entities_annotations do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :start_location
      t.integer :end_location
      t.string :probability
      t.string :type
      t.string :normalized_text

      t.timestamps
    end
  end
end
