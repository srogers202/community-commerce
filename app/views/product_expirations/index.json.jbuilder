json.array!(@product_expirations) do |product_expiration|
  json.extract! product_expiration, :id, :shop, :product, :expiration, :complete
  json.url product_expiration_url(product_expiration, format: :json)
end
