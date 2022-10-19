class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update
    item = Item.find(params[:id])
    merchant = Merchant.find_by(id: item_params[:merchant_id])
    if merchant.present? || item_params[:merchant_id].nil?
      updated_item = Item.update(params[:id], item_params)
      render json: ItemSerializer.new(updated_item) 
    else
      render status: 404
    end
  end

  def destroy 
    item = Item.find(params[:id])
    item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end