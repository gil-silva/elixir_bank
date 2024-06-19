defmodule Bank.Services.Transaction do
  alias Ecto.Multi
  alias Bank.Accounts.Account
  alias Bank.Transfers
  alias Transfers.Transfer
  alias Bank.Accounts
  alias Bank.Services.Paymethod
  alias AmountValidator

  @moduledoc """
  This module orchestrates financial transactions between accounts,
  ensuring balances are verified and transfers are executed atomically.
  """

  @doc """
  Initiates a financial transaction.

  ## Parameters

  - `account_id`: ID of the account initiating the transaction.
  - `amount`: Amount to transfer.
  - `paymethod`: Payment method used for the transaction.

  ## Returns

  - `{:ok, transfer}`: Successfully completed transfer.
  - `{:error, reason, step, results}`: Failed transaction with error details.
  """
  def call(%{"account_id" => account_id, "amount" => amount, "paymethod" => paymethod}) do
    case process_transaction(account_id, amount, paymethod) do
      {:ok, result} ->
        {:ok, result}

      {:error, reason, step, results} ->
        {:error, reason, step, results}
    end
  end

  defp process_transaction(account_id, amount, paymethod) do
    Multi.new()
    |> fetch_account_in_multi(account_id)
    |> verify_balance_in_multi(amount, paymethod)
    |> Multi.update(:withdraw_from_account_step, &withdraw_from_account(&1, paymethod))
    |> Multi.insert(:create_transfer_step, &create_transfer(&1, paymethod))
    |> Bank.Repo.transaction()
    |> handle_transfer()
  end

  defp fetch_account_in_multi(multi, account_id) do
    Multi.run(
      multi,
      :fetch_account_step,
      fn _repo, _ ->
        case Accounts.get(%{"id" => account_id}) do
          {:ok, account} -> {:ok, account}
          error -> error
        end
      end
    )
  end

  defp verify_balance_in_multi(multi, amount, paymethod) do
    Multi.run(
      multi,
      :verify_balance_step,
      fn _repo, %{fetch_account_step: account} ->
        amount_with_fee = Paymethod.apply_fee(amount, paymethod)

        if Decimal.compare(account.balance, amount_with_fee) == :lt do
          {:error, :balance_too_low}
        else
          {:ok, amount}
        end
      end
    )
  end

  defp withdraw_from_account(changes, paymethod) do
    %{
      fetch_account_step: account,
      verify_balance_step: amount
    } = changes

    amount_with_fee = Paymethod.apply_fee(amount, paymethod)

    Account.changeset(account, %{balance: Decimal.sub(account.balance, amount_with_fee)})
  end

  defp create_transfer(changes, paymethod) do
    %{
      fetch_account_step: original_account,
      verify_balance_step: amount,
      withdraw_from_account_step: result_account
    } = changes

    result_balance = Decimal.round(result_account.balance, 2)

    Transfer.changeset(%{
      description:
        "Transferred: R$ #{Decimal.round(amount, 2)}, Remaining: R$ #{Decimal.round(result_balance, 2)}",
      account_id: result_account.id,
      amount: Decimal.round(amount, 2),
      fee_amount: Decimal.round(Paymethod.fee_amount(amount, paymethod), 2),
      original_balance: Decimal.round(original_account.balance, 2),
      result_balance: Decimal.round(result_account.balance, 2)
    })
  end

  defp handle_transfer({:ok, steps}) do
    %{create_transfer_step: transfer} = steps
    {:ok, transfer}
  end

  defp handle_transfer({:error, reason, step, results}) do
    {:error, reason, step, results}
  end
end
