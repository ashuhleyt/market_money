class Api::V0::VendorsController < ApplicationController 
  def index 
    market = Market.find(params[:market_id])
 
    vendors = market.vendors

    render json: VendorSerializer.new(vendors)

  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Couldnt find Market with 'id'=123123123123" }, status: :not_found
  end
end