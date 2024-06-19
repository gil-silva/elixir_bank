defmodule Bank.Transfers.TransferTest do
  use Bank.DataCase, async: true
  alias Bank.Transfers.Transfer

  test "description cannot be blank" do
    changeset = Transfer.changeset(%{amount: 100.0})
    assert %{description: ["can't be blank"]} = errors_on(changeset)
  end

  test "amount cannot be blank" do
    changeset = Transfer.changeset(%{description: "test"})
    assert %{amount: ["can't be blank"]} = errors_on(changeset)
  end

  test "fee_amount cannot be blank" do
    changeset = Transfer.changeset(%{description: "test"})
    assert %{fee_amount: ["can't be blank"]} = errors_on(changeset)
  end
end
