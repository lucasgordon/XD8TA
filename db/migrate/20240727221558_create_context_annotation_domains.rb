class CreateContextAnnotationDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :context_annotation_domains do |t|
      t.references :post, null: false, foreign_key: true
      t.string :domain_name
      t.string :domain_description
      t.string :entity_name

      t.timestamps
    end
  end
end
