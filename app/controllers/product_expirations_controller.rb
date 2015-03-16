class ProductExpirationsController < ApplicationController
  before_action :set_product_expiration, only: [:show, :edit, :update, :destroy]

  # GET /product_expirations
  # GET /product_expirations.json
  def index
    @product_expirations = ProductExpiration.all
  end

  # GET /product_expirations/1
  # GET /product_expirations/1.json
  def show
  end

  # GET /product_expirations/new
  def new
    @product_expiration = ProductExpiration.new
  end

  # GET /product_expirations/1/edit
  def edit
  end

  # POST /product_expirations
  # POST /product_expirations.json
  def create
    @product_expiration = ProductExpiration.new(product_expiration_params)

    respond_to do |format|
      if @product_expiration.save
        format.html { redirect_to @product_expiration, notice: 'Product expiration was successfully created.' }
        format.json { render :show, status: :created, location: @product_expiration }
      else
        format.html { render :new }
        format.json { render json: @product_expiration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_expirations/1
  # PATCH/PUT /product_expirations/1.json
  def update
    respond_to do |format|
      if @product_expiration.update(product_expiration_params)
        format.html { redirect_to @product_expiration, notice: 'Product expiration was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_expiration }
      else
        format.html { render :edit }
        format.json { render json: @product_expiration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_expirations/1
  # DELETE /product_expirations/1.json
  def destroy
    @product_expiration.destroy
    respond_to do |format|
      format.html { redirect_to product_expirations_url, notice: 'Product expiration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_expiration
      @product_expiration = ProductExpiration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_expiration_params
      params.require(:product_expiration).permit(:shop, :product, :expiration, :complete)
    end
end
