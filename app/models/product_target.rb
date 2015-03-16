class ProductTarget < ActiveRecord::Base

    def self.adjustPrices

      shops = Shop.all

      shops.each do |shop|
        self.adjustPrice(shop.id)
      end #shop.each

    end #method - adjustPrices

    def self.adjustPrice(shop)
      shop_session = Shop.retrieve(shop)

      # Retrieve all product targets for a shop
      product_targets = ProductTarget.where(shop: shop).all

      product_targets.each do |pt|

        product = ShopifyAPI::Product.find(pt.product)
        purchased_count = self.purchaseCount(product.id)

        if (!pt.refunded && pt.minqty <= purchased_count)
          
          #update prices
          product.variants.each do |v|
            comp_price = v.price
            v.price = pt.price
            v.compare_price = comp_price
          end
          product.save

        end #if not refunded and purchase count met
      end #product_targets.each

    end #adjustPrice

    def self.purchaseCount(product_id)
      total_orders = ShopifyAPI::Order.find(:all, :params => {:order => "created_at DESC" })
      purchased_count = 0

      total_orders.each do |o|

        o.line_items.each do |li|
          if (li.product_id == product_id)
            purchased_count += li.quantity
          end
        end #orders.each
      end #total_orders.each

      purchased_count # return
    end #method - purchaseCount
end
