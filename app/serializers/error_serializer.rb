class API::V0::ErrorSerializer
  def invalid_market_id
    {
      errors: "Couldnt find Market with 'id'=123123123123"
    }
  end
end