class RenameTypeInEntitiesAnnotations < ActiveRecord::Migration[7.1]
  def change
    rename_column :entities_annotations, :type, :annotation_type
  end
end
