class ReportsController < ApplicationController
  before_action :authenticate_user!

  def drugs
    @role_store_count,@role_store_names = Store.get_user_roles(current_store)
  end
end
