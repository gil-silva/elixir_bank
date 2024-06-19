defmodule Bank.Services.AmountValidatorTest do
  use Bank.DataCase, async: true
  alias Bank.Services.AmountValidator

  describe "validate_and_parse_amount/1" do
    test "when the amount format is invalid, return a error" do
      amount = "invalid"

      {:error, message} = AmountValidator.validate_and_parse_amount(amount)

      assert message == :invalid_amount_format
    end

    test "when the amount is less than 0, return a error" do
      amount = "-0.01"

      {:error, message} = AmountValidator.validate_and_parse_amount(amount)

      assert message == :amount_must_be_positive
    end

    test "when the amount is 0, return a error" do
      amount = "0.0"

      {:error, message} = AmountValidator.validate_and_parse_amount(amount)

      assert message == :amount_must_be_positive
    end
  end
end
