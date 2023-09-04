class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show 
    market = Market.find(params[:id])

    render json: MarketSerializer.new(market) 

  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.invalid_market_id, status: :not_found
  end 
end 