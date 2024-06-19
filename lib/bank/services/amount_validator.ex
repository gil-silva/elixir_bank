defmodule Bank.Services.AmountValidator do
  @moduledoc """
  This module provides functions for validating and parsing amounts.
  """

  @doc """
  Validates and parses an amount string.

  Returns:
    - `{:ok, amount}` if the amount is parsed successfully and greater than 0.
    - `{:error, :amount_must_be_positive}` if the amount is not greater than 0.
    - `{:error, :invalid_amount_format}` if the amount string format is invalid.
  """
  def validate_and_parse_amount(amount_str) do
    case Decimal.cast(amount_str) do
      {:ok, amount} ->
        if Decimal.compare(amount, Decimal.new("0.0")) == :gt do
          {:ok, amount}
        else
          {:error, :amount_must_be_positive}
        end

      :error ->
        {:error, :invalid_amount_format}
    end
  end
end
