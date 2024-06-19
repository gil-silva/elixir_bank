defmodule Bank.Accounts.AccountTest do
  use Bank.DataCase, async: true
  alias Bank.Accounts.Account

  test "account_id cannot be blank" do
    changeset = Account.changeset(%Account{}, %{balance: 100.0})
    assert %{id: ["can't be blank"]} = errors_on(changeset)
  end

  test "balance cannot be blank" do
    changeset = Account.changeset(%Account{}, %{id: 1234})
    assert %{balance: ["can't be blank"]} = errors_on(changeset)
  end

  test "balance cannot be negative" do
    changeset = Account.changeset(%Account{}, %{id: 1234, balance: -1.0})
    assert %{balance: ["must be greater than or equal to 0"]} = errors_on(changeset)
  end

  test "account_id is unique" do
    {:ok, first_account} = Repo.insert(Account.changeset(%Account{}, %{id: 1234, balance: 10.0}))

    {:error, changeset} =
      Repo.insert(Account.changeset(%Account{}, %{id: first_account.id, balance: 20.0}))

    assert changeset.errors == [
             id:
               {"has already been taken",
                [{:constraint, :unique}, {:constraint_name, "accounts_pkey"}]}
           ]

    refute changeset.valid?
  end
end
