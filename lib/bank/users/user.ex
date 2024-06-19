defmodule Bank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :document, :string
    field :active, :boolean

    # timestamps()
  end

  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, [:id, :name, :email])
    |> validate_required([:name])
    |> validate_required([:id])
  end
end
