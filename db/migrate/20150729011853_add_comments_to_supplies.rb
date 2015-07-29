class AddCommentsToSupplies < ActiveRecord::Migration
  def change
    add_column :batches, :comments , :text
  end
end
