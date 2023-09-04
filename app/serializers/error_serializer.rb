class ErrorSerializer
  def self.invalid_market_id
    {
      errors: "Couldnt find Market with 'id'=123123123123"
    }
  end

  def self.invalid_vendor_id
    {
     "errors": [
         {
             "detail": "Couldn't find Vendor with 'id'=123123123123"
         }
      ]
    }
  end

  def self.invalid_vendor_params
    {
     "errors": [
         {
             "detail": "Validation failed: Contact name can't be blank, Contact phone can't be blank"
         }
     ]
 }
  end
end