defmodule Shopbird.Router do
  use Shopbird.Web, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated, handler: Shopbird.AuthController
  end

  scope "/", Shopbird do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index

    get "/registration", RegistrationController, :new
    post "/registration", RegistrationController, :create
  end

  scope "/auth", Shopbird do
    pipe_through [:browser, :browser_auth]

    # This must come up the top since there is a variable route
    get "/logout", AuthController, :delete
    delete "/logout", AuthController, :delete

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/products", Shopbird do
    pipe_through [:browser, :browser_auth, :authenticated]
    resources "/", ProductController
  end

end
