defmodule Bank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:balance, :decimal, null: false)

      timestamps()
    end

    create(
      constraint("accounts", "balance_cannot_be_negative",
        check: "balance >= 0",
        comment: "Account balance cannot be negative"
      )
    )
  end
end
