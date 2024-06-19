defmodule Bank.Services.PaymethodTest do
  use Bank.DataCase, async: true
  alias Bank.Services.Paymethod

  describe "validate/1" do
    test "when the paymethod is invalid, return a error" do
      paymethod = "invalid"

      {:error, message} = Paymethod.validate(paymethod)

      assert message == :invalid_paymethod
    end

    test "when the paymethod is P, return success" do
      paymethod = "P"

      {:ok, result} = Paymethod.validate(paymethod)

      assert result == :valid
    end

    test "when the paymethod is C, return success" do
      paymethod = "C"

      {:ok, result} = Paymethod.validate(paymethod)

      assert result == :valid
    end

    test "when the paymethod is D, return success" do
      paymethod = "D"

      {:ok, result} = Paymethod.validate(paymethod)

      assert result == :valid
    end
  end
end
