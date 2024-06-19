defmodule Bank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :balance, :decimal
    field :account_id, :integer, virtual: true

    has_many :transfers, Bank.Transfers.Transfer

    timestamps()
  end

  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, [:id, :balance, :account_id])
    |> validate_required([:balance])
    |> validate_required([:id])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint([:id], name: :accounts_pkey)
  end
end
