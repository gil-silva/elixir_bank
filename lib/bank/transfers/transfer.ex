defmodule Bank.Transfers.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field :amount, :decimal
    field :fee_amount, :decimal
    field :original_balance, :decimal
    field :result_balance, :decimal
    field :description, :string

    belongs_to :account, Bank.Accounts.Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [
      :description,
      :account_id,
      :amount,
      :fee_amount,
      :original_balance,
      :result_balance
    ])
    |> validate_required([:description, :amount, :fee_amount])
    |> unique_constraint([:account_id])
  end
end
