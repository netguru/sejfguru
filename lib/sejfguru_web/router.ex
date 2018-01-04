defmodule SejfguruWeb.Router do
  use SejfguruWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug SejfguruWeb.AuthOptionalPipeline
  end

  pipeline :browser_auth_required do
    plug SejfguruWeb.AuthRequiredPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SejfguruWeb do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    get "/auth", AuthController, :request
    get "/auth-callback", AuthController, :callback
  end

  scope "/", SejfguruWeb do
    pipe_through [:browser, :browser_auth_required]

    get "/protected", PageController, :protected
  end
end
