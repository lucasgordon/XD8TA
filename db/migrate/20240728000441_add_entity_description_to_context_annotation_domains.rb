class AddEntityDescriptionToContextAnnotationDomains < ActiveRecord::Migration[7.1]
  def change
    add_column :context_annotation_domains, :entity_description, :string
  end
end
