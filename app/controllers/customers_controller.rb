class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :generate_ephemeral_key]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new
    @stripe_customer = Stripe::Customer.create(
      description: "created from Rails app",
      source: {
        object: "card",
        number: customer_params[:cc_num],
        exp_month: customer_params[:cc_exp_mo],
        exp_year: customer_params[:cc_exp_yr],
      }
    )
    @customer.stripe_id = @stripe_customer.id

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def generate_ephemeral_key
    stripe_version = params['api_version']
    customer_id = @customer.stripe_id
    key = Stripe::EphemeralKey.create(
      {customer: customer_id},
      {stripe_version: stripe_version}
    )
    render json: key.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:cc_num, :cc_exp_mo, :cc_exp_yr)
    end
end
