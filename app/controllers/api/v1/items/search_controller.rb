class Api::V1::Items::SearchController < ApplicationController
  before_action :qualify_params, :confirm_min, :confirm_max
  
  def show
    if item_params[:name].present?
      item = Item.find_by_name(item_params[:name])
    elsif item_params[:min_price].present? && item_params[:max_price].present?
      item = Item.find_by_min_max(item_params[:min_price], item_params[:max_price])
    elsif item_params[:min_price].present?
      item = Item.find_by_min(item_params[:min_price])
    elsif item_params[:max_price].present?
      item = Item.find_by_max(item_params[:max_price])
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
    if item_params[:name].present? && (item_params[:min_price].present? || item_params[:max_price].present?)
      render json: {"error": "Undefined Search" },status: 400
    end
  end

  def confirm_min
    if item_params[:min_price].to_f.negative?
      render json: {"error": "Number must be positive" }, status: 400
    end
  end

  def confirm_max
    if item_params[:max_price].to_f.negative?
      render json: {"error": "Number must be positive" }, status: 400
    end
  end
end
