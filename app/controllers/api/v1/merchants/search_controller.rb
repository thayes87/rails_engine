class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchants = Merchant.where('name ILIKE ?', "%#{merchant_params[:name]}%").order(:name)
    if merchants.blank?
      render json: MerchantSerializer.no_result
    else
      render json: MerchantSerializer.new(merchants), each_serializer: MerchantSerializer
    end
  end

  private 

  def merchant_params
    params.permit(:name)
  end
end