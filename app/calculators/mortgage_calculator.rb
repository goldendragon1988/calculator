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
    monthly_payment = calculate_monthly_mortgage

    return (monthly_payment * 13) / 26.0 if payment_frequency == 'accelerated_bi_weekly'
    return (monthly_payment * 12) / 26.0 if payment_frequency == 'bi_weekly'

    monthly_payment
  end

  def calculate_monthly_mortgage
    loan_amount = BigDecimal(property_price - (property_price * down_payment / 100))
    monthly_rate = annual_interest_rate.to_d / 100.0 / 12.0
    term = amortization_period * 12

    loan_amount * (monthly_rate * (1 + monthly_rate)**term) / ((1 + monthly_rate)**term - 1)
  end
end
