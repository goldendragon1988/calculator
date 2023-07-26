require 'swagger_helper'

describe 'Calculators' do
  path '/api/v1/calculate' do
    post 'calculate' do
      tags 'Calculators'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          property_price: { type: :number },
          down_payment: { type: :number },
          annual_interest_rate: { type: :number },
          amortization_period: { type: :number },
          payment_frequency: { type: :string, enum: %w[accelerated_bi_weekly bi_weekly monthly] }
        }
      }

      response '200', 'returns the mortgage payment' do
        let(:params) do
          {
            property_price: 100_000,
            down_payment: 20,
            annual_interest_rate: 2.5,
            amortization_period: 25,
            payment_frequency: 'monthly'
          }
        end
        run_test!
      end

      response '422', 'returns error message' do
        let(:params) do
          {
            property_price: 100_000,
            down_payment: 20,
            annual_interest_rate: 2.5,
            amortization_period: 40,
            payment_frequency: 'monthly'
          }
        end
        run_test!
      end
    end
  end
end
