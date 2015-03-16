json.array!(@product_targets) do |product_target|
  json.extract! product_target, :id, :product, :minqty, :price, :priceLessPrevious, :order
  json.url product_target_url(product_target, format: :json)
end
