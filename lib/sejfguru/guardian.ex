defmodule Sejfguru.Guardian do
  use Guardian, otp_app: :sejfguru

  alias Sejfguru.Accounts

  def subject_for_token(user = %Accounts.User{}, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => id} = _claims), do: {:ok, Accounts.get_user!(id)}
  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}
end
