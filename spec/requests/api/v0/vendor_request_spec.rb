require 'rails_helper'

RSpec.describe 'Vendor API', type: :request do
  before(:each) do
    @market1 = create(:market)
    @vendor1 = create(:vendor)

    @mv1 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor1.id)
    @mv2 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor1.id)
    @mv3 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor1.id)
  end

  describe 'GET /api/v0/vendors/:id' do
    it 'returns a vendor when a valid id is passed in' do

      get "/api/v0/vendors/#{@vendor1.id}"

      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(vendor).to be_a(Hash)

      expect(vendor[:data]).to have_key(:id)
      expect(vendor[:data][:id]).to be_a(String)
      expect(vendor[:data]).to have_key(:type)
      expect(vendor[:data][:type]).to eq('vendor')
      expect(vendor[:data]).to have_key(:attributes)
      expect(vendor[:data][:attributes]).to be_a(Hash)
      expect(vendor[:data][:attributes]).to have_key(:name)
      expect(vendor[:data][:attributes][:name]).to be_a(String)
      expect(vendor[:data][:attributes]).to have_key(:description)
      expect(vendor[:data][:attributes][:description]).to be_a(String)
      expect(vendor[:data][:attributes]).to have_key(:contact_name)
      expect(vendor[:data][:attributes][:contact_name]).to be_a(String)
      expect(vendor[:data][:attributes]).to have_key(:contact_phone)
      expect(vendor[:data][:attributes][:contact_phone]).to be_a(String)
      expect(vendor[:data][:attributes]).to have_key(:credit_accepted)
      expect(vendor[:data][:attributes][:name]).to eq(@vendor1.name)
    end

    it 'returns an error when an invalid id is passed in' do
      id = 123123123123123

      get "/api/v0/vendors/#{id}"

      expect(response).to have_http_status(404)

      vendor_error_response = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor_error_response).to be_a(Hash)
    end
  end
end