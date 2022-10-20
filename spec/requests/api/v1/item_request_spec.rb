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

    it "can find a single item which matches a search term" do
      item1 = create(:item, name: "bike", description: "mountain")
      search_criteria = "bik"
      get "/api/v1/items/find?name=#{search_criteria}"

      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(item[:data][:id]).to eq("#{item1.id}")
      expect(item[:data][:attributes][:name]).to eq(item1.name)
      expect(item[:data][:attributes][:description]).to eq(item1.description)
      expect(item[:data][:attributes][:unit_price]).to eq(item1.unit_price)
      expect(item[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
    end
    
    it "can return an empty array when no item matches search criteria" do
      item1 = create(:item, name: "bike", description: "mountain")

      get "/api/v1/items/find?name=car"

      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(item[:data]).to eq({})
    end

    it 'can return the first object in the database in case-insensitive alphabetical order if multiple matches are found' do
      item1 = create(:item, name: "Turing")
      item2 = create(:item, name: "Ring World")

      get "/api/v1/items/find?name=ring"

      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(item[:data][:id]).to eq("#{item2.id}")
      expect(item[:data][:attributes][:name]).to eq(item2.name)
      expect(item[:data][:attributes][:description]).to eq(item2.description)
      expect(item[:data][:attributes][:unit_price]).to eq(item2.unit_price)
      expect(item[:data][:attributes][:merchant_id]).to eq(item2.merchant_id)
    end

    it 'allows the user to send one minimum price-related query parameters' do
      item1 = create(:item, name: "Turing", unit_price: 51.00)
      item2 = create(:item, name: "Ring World", unit_price: 4.99)

      get "/api/v1/items/find?min_price=4.99"
      
      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(item[:data][:id]).to eq("#{item2.id}")
      expect(item[:data][:attributes][:name]).to eq(item2.name)
      expect(item[:data][:attributes][:description]).to eq(item2.description)
      expect(item[:data][:attributes][:unit_price]).to eq(item2.unit_price)
      expect(item[:data][:attributes][:merchant_id]).to eq(item2.merchant_id)
    end

    it 'allows the user to send one maximum price-related query parameters' do
      item1 = create(:item, name: "Turing", unit_price: 51.00)
      item2 = create(:item, name: "Ring World", unit_price: 160.00)

      get "/api/v1/items/find?max_price=150"
      
      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(item[:data][:id]).to eq("#{item1.id}")
      expect(item[:data][:attributes][:name]).to eq(item1.name)
      expect(item[:data][:attributes][:description]).to eq(item1.description)
      expect(item[:data][:attributes][:unit_price]).to eq(item1.unit_price)
      expect(item[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
    end

    it 'allows the user to send one maximum and one minimum price-related query parameters' do
      item1 = create(:item, name: "Turing", unit_price: 51.00)
      item2 = create(:item, name: "Ring World", unit_price: 160.00)
      item3 = create(:item, name: "bike", unit_price: 75.55)
      item4 = create(:item, name: "car", unit_price: 5.00)

      get "/api/v1/items/find?max_price=150&min_price=50"
      
      item = JSON.parse(response.body, symbolize_names: true)
# require 'pry'; binding.pry
      expect(response).to be_successful
      expect(item[:data][:id]).to eq("#{item3.id}")
      expect(item[:data][:attributes][:name]).to eq(item3.name)
      expect(item[:data][:attributes][:description]).to eq(item3.description)
      expect(item[:data][:attributes][:unit_price]).to eq(item3.unit_price)
      expect(item[:data][:attributes][:merchant_id]).to eq(item3.merchant_id)
    end
  end

  context "POST /api/v1/items" do
    it "can create a new item" do
      merchant = create(:merchant)
      
      item_params = ({
                    name: "value1",
                    description: "value2",
                    unit_price: 100.99,
                    merchant_id: merchant.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end
  end

  context "PATCH /api/v1/items" do
    it "can update an existing item" do
      item = create(:item)
      previous_price = item.unit_price
      item_params = { unit_price: 78.99, merchant_id: item.merchant_id }
      
      headers = {"CONTENT_TYPE" => "application/json"}
    
      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: item.id)
    
      expect(response).to be_successful
      expect(item.unit_price).to_not eq(previous_price)
      expect(item.unit_price).to eq(78.99)
    end
  end

  context "DELETE /api/v1/items" do
    it "can destroy an item" do
      item = create(:item)
      
      expect(Item.count).to eq(1)
    
      delete "/api/v1/items/#{item.id}"
    
      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end