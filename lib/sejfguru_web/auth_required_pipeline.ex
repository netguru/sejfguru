defmodule SejfguruWeb.AuthRequiredPipeline do
  use Guardian.Plug.Pipeline, otp_app: :sejfguru

  plug(Guardian.Plug.VerifySession)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
