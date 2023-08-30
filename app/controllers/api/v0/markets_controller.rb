class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show 
    market = Market.find(params[:id])

    render json: MarketSerializer.new(market)  # Use the serializer here

  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Market not found' }, status: :not_found
  end
end 