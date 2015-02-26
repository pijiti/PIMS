class CreateTablePharmItemSubClass < ActiveRecord::Migration
  def change
    create_table :pharm_items_sub_classes do |t|
    	 t.integer :pharm_item_id
       t.integer :sub_class_id
    end
  end
end
