class ApprovalsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_store, only: [:create]
  before_action :set_supply, only: [:submitted_item, :save]

  def approval_index
    if can? :manage , :all
      @submitted_supplies = Supply.where.not(:approval_status => "NOT SENT").order("updated_at DESC")
    #if store manager
    elsif can? :manage, Store
      @submitted_supplies = Supply.where(:store => current_store).where.not(:approval_status => "NOT SENT").order("updated_at DESC")
    end
  end

  def submitted_item
  end

  def save
    @supply = update_attributes(supply_params)
    redirect_to users_path
  end


  def commit
    if params[:commit] == 'Save'
      redirect_to users_path
    elsif params[:commit] == 'Save and Approve'
      redirect_to pharm_items_path
    else
      redirect_to marketers_path
    end
  end


  private

  def set_supply
    @supply = Supply.find(params[:id])
  end


end
