defmodule BankWeb.TransferJSON do
  def create(%{transfer: transfer}) do
    %{
      id: transfer.id,
      amount: Decimal.to_float(transfer.amount),
      fee_amount: Decimal.to_float(transfer.fee_amount),
      original_balance: Decimal.to_float(transfer.original_balance),
      result_balance: Decimal.to_float(transfer.result_balance),
      description: transfer.description,
      account_id: transfer.account_id
    }
  end
end
