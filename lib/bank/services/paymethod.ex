defmodule Bank.Services.Paymethod do
  @permited_paymethods ["P", "D", "C"]
  @moduledoc """
  This module provides functions for validating paymethods and calculating fees.
  """

  @doc """
  Validates a payment method against the list of permitted paymethods.

  Returns:
    - `{:ok, :valid}` if the paymethod is valid.
    - `{:error, :invalid_paymethod}` if the paymethod is not valid.
  """
  def validate(paymethod) do
    case Enum.member?(@permited_paymethods, paymethod) do
      true -> {:ok, :valid}
      false -> {:error, :invalid_paymethod}
    end
  end

  @doc """
  Returns the fee for the 'X' paymethod.

  Example:
    iex> Bank.Services.Paymethod.fee_for_paymethod("P")
    #Decimal<0.0>

  """
  def fee_for_paymethod("P"), do: Decimal.from_float(0.0)
  def fee_for_paymethod("D"), do: Decimal.from_float(0.03)
  def fee_for_paymethod("C"), do: Decimal.from_float(0.05)
  def fee_for_paymethod(_), do: {:error, :invalid_paymethod}

  @doc """
  Calculates the total fee amount based on the given amount and paymethod.

  Example:
    iex> Bank.Services.Paymethod.fee_amount(100, "D")
    #Decimal<3.0>

  """
  def fee_amount(amount, paymethod) do
    Decimal.mult(amount, fee_for_paymethod(paymethod))
  end

  @doc """
  Applies the calculated fee to the original amount and returns the total amount including the fee.

  Example:
    iex> Bank.Services.Paymethod.apply_fee(100, "D")
    #Decimal<103.0>

  """
  def apply_fee(amount, paymethod) do
    total_fee = fee_amount(amount, paymethod)
    Decimal.add(amount, total_fee)
  end
end
