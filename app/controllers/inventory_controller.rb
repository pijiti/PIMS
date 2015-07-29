class InventoryController < ApplicationController
  def index
    @inventories = Inventory.includes(:store , :brand).where(:store => current_store)
  end
end
