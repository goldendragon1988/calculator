require 'rails_helper'

RSpec.describe MortgageCalculator, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:property_price) }
    it { should validate_presence_of(:down_payment) }
    it { should validate_presence_of(:annual_interest_rate) }
    it { should validate_presence_of(:amortization_period) }
    it { should validate_presence_of(:payment_frequency) }

    it { should validate_numericality_of(:property_price).is_greater_than(0) }
    it { should validate_numericality_of(:down_payment).is_greater_than(0) }
    it { should validate_numericality_of(:annual_interest_rate).is_greater_than(0) }
    it { should validate_numericality_of(:amortization_period).is_greater_than(0) }

    it { should validate_inclusion_of(:payment_frequency).in_array(MortgageCalculator::PAYMENT_FREQUENCY) }
    it { should validate_inclusion_of(:amortization_period).in_array((5..30).step(5).to_a) }
  end

  describe 'custom validations' do
    let(:calculator) do
      MortgageCalculator.new(property_price: 100_000, down_payment: 5000, annual_interest_rate: 5, amortization_period: 25,
                             payment_frequency: 'monthly')
    end

    it 'should add error if down payment is greater than property price' do
      calculator.down_payment = 100_001
      calculator.valid?
      expect(calculator.errors[:down_payment]).to include("can't be greater than or equal to the property price")
    end

    it 'should add error if down payment is equal to the property price' do
      calculator.down_payment = 100_000
      calculator.valid?
      expect(calculator.errors[:down_payment]).to include("can't be greater than or equal to the property price")
    end

    it 'should add error if down payment is less than 5% of property price' do
      calculator.down_payment = 1000
      calculator.valid?
      expect(calculator.errors[:down_payment]).to include("can't be less than 5% of property price")
    end
  end
end
