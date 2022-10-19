require 'rails_helper'

describe "Merchants API" do
  context "GET /api/v1/merchant/id:/items" do
    it "returns all items for a single merchant" do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      item3 = create(:item)

      get "/api/v1/merchants/#{merchant1.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)
      expect(items[:data].first[:attributes][:name]).to eq(item1.name)
      expect(items[:data].first[:attributes][:description]).to eq(item1.description)
      expect(items[:data].first[:attributes][:unit_price]).to eq(item1.unit_price )
    end
  end
end