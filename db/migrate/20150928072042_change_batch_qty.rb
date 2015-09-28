class ChangeBatchQty < ActiveRecord::Migration
  def change
    change_column :batches , :qty , :decimal
  end
end
