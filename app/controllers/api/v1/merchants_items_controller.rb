class Api::V1::MerchantsItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    render json: ItemSerializer.new(items)
  end
end