class Api::V1::Items::SearchController < ApplicationController
  before_action :qualify_params, :confirm_min, :confirm_max
  
  def show
    if item_params[:name].present?
      item = Item.where('name ILIKE ?', "%#{item_params[:name]}%").order(:name).first
    elsif item_params[:min_price].present? && item_params[:max_price].present?
      item = Item.where('unit_price >= ? and unit_price <= ?', item_params[:min_price], item_params[:max_price]).order('LOWER(name)').first
    elsif item_params[:min_price].present?
      item = Item.where('unit_price >= ?', item_params[:min_price]).order('LOWER(name)').first
    elsif item_params[:max_price].present?
      item = Item.where('unit_price <= ?', item_params[:max_price]).order('LOWER(name)').first
    end

    if item.blank?
      render json: ItemSerializer.no_result
    else
      render json: ItemSerializer.new(item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :min_price, :max_price)
  end

  def qualify_params
    if item_params[:name] && item_params[:min_price]
      render status: 400
    elsif item_params[:name] && item_params[:max_price]
      render status: 400
    end
  end

  def confirm_min
    if item_params[:min_price].to_f.negative?
      render json: {"error": "Min must be positive" }, status: 400
    end
  end

  def confirm_max
    if item_params[:max_price].to_f.negative?
      render json: {"error": "Max must be positive" }, status: 400
    end
  end
end
