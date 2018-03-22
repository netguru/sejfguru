defmodule SejfguruWeb.Router do
  use SejfguruWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_optional_auth do
    plug SejfguruWeb.AuthOptionalPipeline
    plug SejfguruWeb.Plugs.CurrentUser
  end

  pipeline :browser_required_auth do
    plug SejfguruWeb.AuthRequiredPipeline
    plug SejfguruWeb.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SejfguruWeb do
    pipe_through [:browser, :browser_optional_auth]

    get "/", PageController, :index
    get "/auth", AuthController, :request
    get "/auth-callback", AuthController, :callback
  end

  scope "/", SejfguruWeb do
    pipe_through [:browser, :browser_required_auth]

    get "/bookings/:asset_id", BookingController, :index
    post "/bookings", BookingController, :create
    get "/protected", PageController, :protected
  end
end
