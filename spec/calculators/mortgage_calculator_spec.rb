require 'rails_helper'

RSpec.describe MortgageCalculator, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:property_price) }
    it { should validate_presence_of(:down_payment) }
    it { should validate_presence_of(:annual_interest_rate) }
    it { should validate_presence_of(:amortization_period) }
    it { should validate_presence_of(:payment_frequency) }

    it { should validate_numericality_of(:property_price).is_greater_than(0) }
    it { should validate_numericality_of(:down_payment).is_in(5..35) }
    it { should validate_numericality_of(:annual_interest_rate).is_greater_than(0) }
    it { should validate_numericality_of(:amortization_period).is_greater_than(0) }

    it { should validate_inclusion_of(:payment_frequency).in_array(MortgageCalculator::PAYMENT_FREQUENCY) }
    it { should validate_inclusion_of(:amortization_period).in_array((5..30).step(5).to_a) }
  end

  describe '#calculate' do
    let(:calculator) do
      MortgageCalculator.new(property_price: 100_000,
                             down_payment: 10,
                             annual_interest_rate: 5,
                             amortization_period: 25,
                             payment_frequency: 'monthly')
    end

    context 'when payment frequency is monthly' do
      it 'should return monthly payment' do
        amount = calculator.calculate
        expect(amount).to eq(526.13)
      end
    end

    context 'when payment frequency is bi-weekly' do
      it 'should return bi-weekly payment' do
        calculator.payment_frequency = 'bi_weekly'
        amount = calculator.calculate
        expect(amount).to eq(263.07)
      end
    end

    context 'when payment frequency is accelerated bi-weekly' do
      it 'should return accelerated bi-weekly payment' do
        calculator.payment_frequency = 'accelerated_bi_weekly'
        amount = calculator.calculate
        expect(amount).to eq(242.69)
      end
    end
  end
end
