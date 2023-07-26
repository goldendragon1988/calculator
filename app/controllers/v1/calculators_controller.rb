class V1::CalculatorsController < ApiController
  def calculate
    @calculator = MortgageCalculator.new(calculator_params)

    if @calculator.valid?
      render json: { amount: @calculator.calculate }
    else
      render json: { errors: @calculator.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def calculator_params
    params.permit(:property_price, :down_payment, :annual_interest_rate, :amortization_period, :payment_frequency)
  end
end
