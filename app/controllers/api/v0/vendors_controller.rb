class Api::V0::VendorsController < ApplicationController 
  def index 
    market = Market.find(params[:market_id])
 
    vendors = market.vendors

    render json: VendorSerializer.new(vendors)

  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Couldnt find Market with 'id'=123123123123" }, status: :not_found
  end

  def show
  vendor = Vendor.find(params[:id])
  
  render json: VendorSerializer.new(vendor)
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.invalid_vendor_id, status: :not_found
  end

  def create
    vendor = Vendor.create!(vendor_params)

    render json: VendorSerializer.new(vendor)
  rescue ActiveRecord::RecordInvalid
    render json: ErrorSerializer.invalid_vendor_params, status: :bad_request
  end

  private
  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end