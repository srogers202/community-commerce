class ProductTargetsController < ApplicationController

  before_filter :set_product_id
  before_action :set_product_target, only: [:show, :edit, :update, :destroy]
  around_filter :shopify_session
  before_action :load_shopify_vars

  def default_url_options
    {:product_id => @product_id}
  end

  # GET /product_targets
  # GET /product_targets.json
  def index
    set_orders()
    set_product_expiration()
    set_product_targets()
    @next_order = @product_targets.length + 1
  end

  # GET /product_targets/1
  # GET /product_targets/1.json
  def show
  end

  # GET /product_targets/new
  def new
    @next_order = 1
    
    if (params['next_order'])
      @next_order = params['next_order']
    end

    @product_target = ProductTarget.new
  end

  # GET /product_targets/1/edit
  def edit
    @next_order = @product_target.order
  end

  # POST /product_targets
  # POST /product_targets.json
  def create
    @product_target = ProductTarget.new(product_target_params)
    @product_target.shop = @shop.id

    respond_to do |format|
      if @product_target.save
        format.html { redirect_to @product_target, notice: 'Product target was successfully created.' }
        format.json { render :show, status: :created, location: @product_target }
      else
        format.html { render :new }
        format.json { render json: @product_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_targets/1
  # PATCH/PUT /product_targets/1.json
  def update
    respond_to do |format|
      if @product_target.update(product_target_params)
        format.html { redirect_to @product_target, notice: 'Product target was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_target }
      else
        format.html { render :edit }
        format.json { render json: @product_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_targets/1
  # DELETE /product_targets/1.json
  def destroy
    @product_target.destroy
    respond_to do |format|
      format.html { redirect_to product_targets_url, notice: 'Product target was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #manually process refunds
  def process_refunds
    set_orders()
    ProductTarget.adjustPrice(@shop.id)
    product = ShopifyAPI::Product.find(@product_id)
    current_price = product.variants[0].price

    @orders.each do |order|

      order.line_items.each do |li|
        
        if (li.fulfillment_status != 'fulfilled')

          # capture payment
          ShopifyAPI::Transaction.create({"kind"=>"capture", "order_id" => order.id })

          if (li.product_id == @product.id && li.fulfillment_status != "fulfilled")
            
            # apply refund
            qty = li.quantity.to_i
            refund_amount = li.price.to_f - current_price.to_f

            puts refund_amount

            if (refund_amount > 0)
              total_refund = refund_amount * qty

              puts total_refund

              ShopifyAPI::Transaction.create({"amount"=>total_refund, "kind"=>"refund", "order_id" => order.id })

            end

            # fulfill li
            f = ShopifyAPI::Fulfillment.new(:order_id => order.id, :line_items =>[ { "id" => li.id } ] )
            f.save
          end

        end
        
      end

    end

    respond_to do |format|
      format.html { redirect_to product_targets_url, notice: 'Refunds successfully created' }
      format.json { head :no_content }
    end
  end

  private

    def set_orders

      total_orders = ShopifyAPI::Order.find(:all, :params => {:order => "created_at DESC" })
      @orders ||= []
      @purchased_count = 0

      total_orders.each do |o|
        product_in_order = false

        o.line_items.each do |li|
          if (li.product_id == @product.id)
            product_in_order = true
            @purchased_count += li.quantity

          end

        end

        if (product_in_order)
          @orders.push(o)
        end

      end

      ProductTarget.adjustPrice(@shop.id)
    end

    def set_product_targets

      product_targets = ProductTarget.where(product: @product.id, shop: @shop.id).all

      if product_targets.empty?

        #insert default product target based on product details from shopify
        product_target = ProductTarget.new do |pt|
          pt.shop = @shop.id
          pt.product = @product.id
          pt.minqty = 0
          pt.price = @product.variants[0].price
          pt.priceLessPrevious = 0.00
          pt.order = 1
          pt.refunded = true
        end

        product_target.save()

        product_targets = ProductTarget.where(product: @product_id, shop: @shop.id).all

      end

      @product_targets = product_targets;

    end

    def set_product_expiration

      product_expirations = ProductExpiration.where(product: @product.id, shop: @shop.id).all

      if product_expirations.empty?

        #insert default product target based on product details from shopify
        product_exp = ProductExpiration.new do |pe|
          pe.shop = @shop.id
          pe.product = @product.id
          pe.complete = false
        end

        product_exp.save()

        product_expirations = ProductExpiration.where(product: @product.id, shop: @shop.id).all

      end

      @product_expiration = product_expirations.first;

    end  

    def load_shopify_vars
      if @product_id
        @shop = ShopifyAPI::Shop.current
        @product = ShopifyAPI::Product.find(@product_id)

        if (@product)
          #product exists on shopify
        else
          redirect_to '/'
        end

      else 
        redirect_to '/'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product_target
      @product_target = ProductTarget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_target_params
      params.require(:product_target).permit(:product, :minqty, :price, :priceLessPrevious, :order)
    end

    def set_product_id
      @product_id = params['product_id']
    end

end
