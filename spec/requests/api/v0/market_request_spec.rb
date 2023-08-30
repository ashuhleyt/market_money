require 'rails_helper'

RSpec.describe 'Market API', type: :request do
  before(:each) do
    @market_collection = create_list(:market, 10)

    @vendors = create_list(:vendor, 8).pluck(:id)

    @market_collection.each do |market|
      ids = @vendors.sample(4)
      MarketVendor.create!(market_id: market.id, vendor_id: ids[0])
      MarketVendor.create!(market_id: market.id, vendor_id: ids[1])
      MarketVendor.create!(market_id: market.id, vendor_id: ids[2])
      MarketVendor.create!(market_id: market.id, vendor_id: ids[3])
    end
  end

  describe 'GET /api/v0/markets' do
    it 'returns all markets' do
      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      expect(markets).to be_a(Hash)
      expect(markets).to have_key(:data)
      expect(markets[:data]).to be_an(Array)

      expect(markets[:data].count).to eq(10)

      markets[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)
      
        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")
  
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_a(String)
        
        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_a(String)
      end
    end

    it 'returns an attribute for vendor count' do 
      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      markets[:data].each do |market|
        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)
        expect(market[:attributes][:vendor_count]).to eq(4)
      end
    end
  end

  describe 'GET /api/v0/markets/:id' do 
    it 'returns a single market as well as attributes including vendor count *happy path*' do
      id = create(:market).id

      get "/api/v0/markets/#{id}"
      market = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(market).to be_a(Hash)
      expect(market).to have_key(:data)

      expect(market[:data]).to be_a(Hash)
      expect(market[:data]).to have_key(:id)  
      expect(market[:data][:id]).to be_a(String)

      expect(market[:data]).to have_key(:type)
      expect(market[:data][:type]).to eq("market")

      expect(market[:data]).to have_key(:attributes)
      expect(market[:data][:attributes]).to be_a(Hash)

      expect(market[:data][:attributes]).to have_key(:name)
      expect(market[:data][:attributes][:name]).to be_a(String)
      
      expect(market[:data][:attributes]).to have_key(:street)
      expect(market[:data][:attributes][:street]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:city)
      expect(market[:data][:attributes][:city]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:county)
      expect(market[:data][:attributes][:county]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:state)
      expect(market[:data][:attributes][:state]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:zip)
      expect(market[:data][:attributes][:zip]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:lat)
      expect(market[:data][:attributes][:lat]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:lon)
      expect(market[:data][:attributes][:lon]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:vendor_count)
      expect(market[:data][:attributes][:vendor_count]).to be_an(Integer)
    end

    it 'returns a 404 if market does not exist' do
      get "/api/v0/markets/0"

      error_response = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(404)
      expect(error_response[:error]).to eq("Market not found")
    end
  end
end