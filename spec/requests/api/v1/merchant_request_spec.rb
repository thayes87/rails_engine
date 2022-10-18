require 'rails_helper'

describe "Merchants API" do
  context "GET /api/v1/merchants" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)
      
      get '/api/v1/merchants'
  
      expect(response).to be_successful
    end
  end
end