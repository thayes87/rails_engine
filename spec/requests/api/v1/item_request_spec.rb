require 'rails_helper'

describe "Items API" do
  context "GET /api/v1/items" do
    it "sends a list of items" do
      create_list(:item, 3)
      get '/api/v1/items'
      
      expect(response).to be_successful
      
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)

      items[:data].each do |item|

        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)
  
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it "can get an item by its id" do
      id = create(:item).id
    
      get "/api/v1/items/#{id}"
    
      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to eq("#{id}")

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    end 
  end
end