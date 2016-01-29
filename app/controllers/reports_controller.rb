class ReportsController < ApplicationController
  before_action :authenticate_user!

  def drugs
    @item_classes = ItemClass.includes(:sub_classes).all
    @chart_data = []
    @item_classes.each do |item|
      @chart_data << {:item => item.sub_classes.pluck(:name).map { |x| x.gsub("'", "") }, :y => item.sub_classes.try(:count), :name => item.name.gsub("'", "")}
    end

    @pharm_items = PharmItem.includes(:brands).all

    @brand_data = []
    @pharm_items.each do |p|
      @brand_data << {:item => p.brands.pluck(:name).map { |x| x.gsub("'", "") }, :y => p.brands.try(:count), :name => p.name.gsub("'", "")}
    end

  end

  def stores
    @role_store_count,@role_store_names = Store.get_user_roles(current_store)
  end
end