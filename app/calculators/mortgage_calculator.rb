# frozen_string_literal: true

# Calculator for mortgage
class MortgageCalculator
  include ActiveModel::Model

  PAYMENT_FREQUENCY = %w[accelerated_bi_weekly bi_weekly monthly].freeze

  attr_accessor :property_price, :down_payment, :annual_interest_rate, :amortization_period, :payment_frequency

  validates :property_price, :down_payment, :annual_interest_rate, :amortization_period, :payment_frequency,
            presence: true
  validates :property_price, :annual_interest_rate, :amortization_period,
            numericality: { greater_than: 0 }
  validates :down_payment, numericality: { in: 5..35 }
  validates :payment_frequency, inclusion: { in: PAYMENT_FREQUENCY }
  validates :amortization_period, inclusion: { in: (5..30).step(5).to_a }

  def calculate
    calculate_mortgage.round(2) if valid?
  end

  private

  def calculate_mortgage
    return calculate_payment(26) if payment_frequency == 'accelerated_bi_weekly'

    monthly_payment = calculate_payment

    payment_frequency == 'monthly' ? monthly_payment : monthly_payment / 2.0
  end

  def calculate_payment(payments_in_year = 12)
    loan_amount = BigDecimal(property_price - (property_price * down_payment / 100))
    rate = annual_interest_rate.to_d / 100 / payments_in_year
    term = amortization_period * payments_in_year

    loan_amount * (rate * (1 + rate)**term) / ((1 + rate)**term - 1)
  end
end
