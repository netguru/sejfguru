defmodule SejfguruWeb.AuthController do
  use SejfguruWeb, :controller

  plug Ueberauth
  plug :ensure_proper_domain when action in [:callback]

  alias Sejfguru.Accounts
  alias SejfguruWeb.Guardian

  def callback(%{assigns: %{ueberauth_auth: %{info: info, uid: uid}}} = conn, _params) do
    user_attrs =
      info
      |> Map.take([:first_name, :last_name, :email, :image])
      |> Map.put(:google_uid, uid)

    case Accounts.upsert_user(user_attrs) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Successfully authenticated #{user.first_name}")
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/login")
    end
  end

  defp ensure_proper_domain(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    domain_from_callback = auth.extra.raw_info.user["hd"]
    domain_from_config   = elem(Application.get_env(:ueberauth, Ueberauth)[:providers][:google], 1)[:hd]

    if domain_from_callback !== domain_from_config do
      authentication_failure(conn)
    else
      conn
    end
  end

  defp ensure_proper_domain(%{assigns: %{ueberauth_failure: _fails}} = conn, _params), do: authentication_failure(conn)

  defp authentication_failure(conn) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/login")
    |> halt()
  end
end
