require 'stripe'

class Customer < ApplicationRecord
  def on_stripe
    Stripe::Customer.retrieve(stripe_id)
  end
end
