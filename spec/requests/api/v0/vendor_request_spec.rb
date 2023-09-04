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

  describe 'POST /api/v0/vendors' do
    it 'creates a new vendor, *happy path*' do
      vendor_params = ({
          name: "Hayes Hot Sauce",
          description: "Locally made hot sauce",
          contact_name: "Thomas Hayes",
          contact_phone: "2532278489",
          credit_accepted: true
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)

        expect(response).to be_successful

        new_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(new_vendor).to be_a(Hash)
        expect(new_vendor[:id]).to be_a(String)
        expect(new_vendor[:type]).to eq('vendor')
        expect(new_vendor[:attributes]).to be_a(Hash)
        expect(new_vendor[:attributes][:name]).to eq(vendor_params[:name])
        expect(new_vendor[:attributes][:description]).to eq(vendor_params[:description])
        expect(new_vendor[:attributes][:contact_name]).to eq(vendor_params[:contact_name])
        expect(new_vendor[:attributes][:contact_phone]).to eq(vendor_params[:contact_phone])
        expect(new_vendor[:attributes][:credit_accepted]).to eq(vendor_params[:credit_accepted])
    end

    it 'returns an error when a required field is missing' do
      vendor_params = ({
          # name: "Hayes Hot Sauce",
          description: "Locally made hot sauce",
          contact_name: "Thomas Hayes",
          # contact_phone: "2532278489",
          credit_accepted: true
        })
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)
        expect(response.status).to eq(400)
        not_created = JSON.parse(response.body, symbolize_names: true)
        expect(not_created).to be_a(Hash)
        expect(not_created[:errors]).to be_a(Array)
        expect(not_created[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end
  end

  describe 'PATCH /api/v0/vendors/:id' do 
    it 'updates a vendor, *happy path*' do
      vendor_params = ({
          name: "Hayes Hot Sauce",
          description: "Locally made hot sauce",
          contact_name: "Thomas Hayes",
          contact_phone: "2532278489",
          credit_accepted: true
        })
        headers = {"CONTENT_TYPE" => "application/json"}  

        id = @vendor1.id
        vendor_params = ( {name: "Buzzy Bees", description: "Local honey and wax products" })

        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)

        updated_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(response).to be_successful
        expect(updated_vendor).to be_a(Hash)
        expect(updated_vendor[:id]).to be_a(String)
        expect(updated_vendor[:type]).to eq('vendor')
        expect(updated_vendor[:attributes]).to be_a(Hash)
        expect(updated_vendor[:attributes][:name]).to eq(vendor_params[:name])
        expect(updated_vendor[:attributes][:description]).to eq(vendor_params[:description])
        expect(updated_vendor[:attributes][:contact_name]).to eq(@vendor1.contact_name)
        expect(updated_vendor[:attributes][:contact_phone]).to eq(@vendor1.contact_phone)
        expect(updated_vendor[:attributes][:credit_accepted]).to eq(@vendor1.credit_accepted)
    end

    it 'returns an error when an invalid id is used' do
      id = 123123123123123
      vendor_params = ({ name: "Buzzy Bees", description: "Local honey and wax products" })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response.status).to eq(404)
      
      not_found = JSON.parse(response.body, symbolize_names: true)[:errors].first

      expect(not_found[:detail]).to eq("Couldn't find Vendor with 'id'=123123123123123")
    end

    it 'returns an error when validation fails' do
      valid_vendor = create(:vendor)

      id = valid_vendor.id
      vendor_params = { contact_name: "", credit_accepted: false }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      # require 'pry'; binding.pry
      expect(error_response[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank")

    end
  end
end