require IEx

case Bank.Services.Transaction.call(%{"account_id" => 1234, "amount" => 10.0, "paymethod" => "C"}) do
  {:ok, results} -> IEx.pry()
  {:error, step, reason, results} -> IEx.pry()
end
