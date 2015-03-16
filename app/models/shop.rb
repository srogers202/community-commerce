class Shop < ActiveRecord::Base
   def self.store(session)
     shop = Shop.new(domain: session.url, token: session.token)
     shop.save!
     shop.id
   end

   def self.retrieve(id)
     if shop = Shop.where(id: id).first
       ShopifyAPI::Session.new(shop.domain, shop.token)
     end
   end
 end