class AddStoreIdToReturns < ActiveRecord::Migration
  def change
    add_reference :returns, :store, index: true
  end
end
