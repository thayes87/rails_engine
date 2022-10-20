require 'rails_helper'

describe "Merchants API" do
  context "GET /api/v1/merchants" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(3)

      merchants[:data].each do |merchant|

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
  
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it "can find all merchants that match a search term" do
      merchant1 = create(:merchant, name: "Wal-Mart")
      merchant2 = create(:merchant, name: "K-Mart")
      merchant3 = create(:merchant, name: "Target")

      search_criteria = "mart"
      get "/api/v1/merchants/find_all?name=#{search_criteria}"

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchants[:data].first[:id]).to eq("#{merchant2.id}")
      expect(merchants[:data].last[:id]).to eq("#{merchant1.id}")

      expect(merchants[:data].first[:attributes][:name]).to eq(merchant2.name)
      expect(merchants[:data].last[:attributes][:name]).to eq(merchant1.name)
    end

    it 'can return and empty array when no merchant matches the search criteria' do
      merchant1 = create(:merchant, name: "Wal-Mart")
      merchant2 = create(:merchant, name: "K-Mart")
      merchant3 = create(:merchant, name: "Target")

      search_criteria = "Kroger"
      get "/api/v1/merchants/find_all?name=#{search_criteria}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data]).to eq([])
    end
  end
  
  context "POST /api/v1/merchants" do
    it "can get a merchant by its id" do
      id = create(:merchant).id
    
      get "/api/v1/merchants/#{id}"
    
      merchant = JSON.parse(response.body, symbolize_names: true)
    
      expect(response).to be_successful

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq("#{id}")

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end
end