defmodule Bank.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add(:amount, :decimal, null: false)
      add(:fee_amount, :decimal, null: false)
      add(:original_balance, :decimal)
      add(:result_balance, :decimal)
      add(:description, :string)
      add(:account_id, references(:accounts))

      timestamps()
    end

    create unique_index(:accounts, [:id])
  end
end
