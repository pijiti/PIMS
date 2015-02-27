class CreatePharmItemSubClasses < ActiveRecord::Migration
  def change
    create_table :pharm_item_sub_classes do |t|
      t.references :pharm_item, index: true
      t.references :sub_class, index: true

      t.timestamps
    end
  end
end
