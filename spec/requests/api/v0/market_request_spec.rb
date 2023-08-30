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
end