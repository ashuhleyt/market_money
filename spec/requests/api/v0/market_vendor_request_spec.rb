require 'rails_helper'

RSpec.describe 'Market API', type: :request do
  before(:each) do
    @market1 = create(:market)
    @vendor1 = create(:vendor)
    @vendor2 = create(:vendor)
    @vendor3 = create(:vendor)
    @vendor4 = create(:vendor)

    @market_vendor1 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor1.id)
    @market_vendor2 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor2.id)
    @market_vendor3 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor3.id)
    @market_vendor4 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor4.id)
  end

  describe 'GET /api/v0/markets/:id/vendors' do
    it 'returns all vendors for a market' do
      get "/api/v0/markets/#{@market1.id}/vendors"

      expect(response).to be_successful

      vendors = JSON.parse(response.body, symbolize_names: true)[:data]
      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)
        expect(vendor[:type]).to eq('vendor')

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to eq(true).or eq(false)
      end
    end
  end
end