class MortgageCalculator
  include ActiveModel::Model

  PAYMENT_FREQUENCY = %w[weekly bi-weekly monthly]

  attr_accessor :property_price, :down_payment, :annual_interest_rate, :amortization_period, :payment_frequency

  validates :property_price, :down_payment, :annual_interest_rate, :amortization_period, :payment_frequency,
            presence: true
  validates :property_price, :down_payment, :annual_interest_rate, :amortization_period,
            numericality: { greater_than: 0 }
  validates :payment_frequency, inclusion: { in: PAYMENT_FREQUENCY }
  validates :amortization_period, inclusion: { in: (5..30).step(5).to_a }
  validate :down_payment_price_check, if: -> { down_payment.present? && property_price.present? }

  def calculate
    calculate_mortgage unless valid?
  end

  private

  def calculate_mortgage; end

  def down_payment_price_check
    messages = []
    messages << "can't be greater than or equal to the property price" if down_payment >= property_price
    messages << "can't be less than 5% of property price" if down_payment < (property_price * 0.05)

    return if messages.empty?

    errors.add(:down_payment, messages.join(', '))
  end
end
