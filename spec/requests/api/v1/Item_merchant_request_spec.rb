require 'rails_helper'

describe "Items API" do
  context "GET /api/v1/items/id:/merchant" do
    it "returns the merchant for a given item" do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant_id: merchant1.id)

      get "/api/v1/items/#{item1.id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
      expect(merchant[:data][:id]).to eq("#{merchant1.id}")
    end
  end
end