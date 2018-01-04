defmodule SejfguruWeb.AuthOptionalPipeline do
  use Guardian.Plug.Pipeline, otp_app: :sejfguru

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource, allow_blank: true
end
