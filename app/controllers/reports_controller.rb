class ReportsController < ApplicationController
  before_action :authenticate_user!

  def drugs
    @item_classes = ItemClass.includes(:sub_classes).all
  end

  def stores
    @role_store_count,@role_store_names = Store.get_user_roles(current_store)
  end
end
