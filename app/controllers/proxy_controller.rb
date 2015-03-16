class ProxyController < ApplicationController
  
  around_filter :shopify_session

  def product_targets
    set_product()
    set_product_targets()

    render :layout => false
  end

  def set_product

      @product_id = params['product_id']

      if (@product_id)
        @product = ShopifyAPI::Product.find(@product_id)

      else
        redirect_to '/'

      end
  end

  def set_product_targets

      product_targets = ProductTarget.where(product: @product_id).all

      if product_targets.empty?

        #insert default product target based on product details from shopify
        product_target = ProductTarget.new do |pt|
          pt.product = @product.id
          pt.minqty = 0
          pt.price = @product.variants[0].price
          pt.priceLessPrevious = 0.00
          pt.order = 1
        end

        product_target.save()

        product_targets = ProductTarget.where(product: @product_id).all

      end

      @product_targets = product_targets;

  end  

end
