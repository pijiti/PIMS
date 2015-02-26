class CreateSubClasses < ActiveRecord::Migration
  def change
    create_table :sub_classes do |t|
      t.string :name
      t.text :description
      t.references :item_class, index: true

      t.timestamps
    end
  end
end
