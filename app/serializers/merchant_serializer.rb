class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.no_result
    {
      "data": [
      ]
    }
  end
end