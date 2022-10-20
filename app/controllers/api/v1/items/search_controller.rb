class Api::V1::Items::SearchController < ApplicationController
  def show
    if item_params[:min_price].present?
      items = Item.where('unit_price >= ?', item_params[:min_price])
    else
      items = Item.all
    end
    
    item = items.where('name ILIKE ?', "%#{item_params[:name]}%").order(:name).limit(1)
    
    if item.blank?
      render json: []
    else 
      render json: ItemSerializer.new(item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :min_price)
  end
end
