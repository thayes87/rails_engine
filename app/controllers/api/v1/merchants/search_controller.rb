class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchants = Merchant.find_merchant_by_name(merchant_params)
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