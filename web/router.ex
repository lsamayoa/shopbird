defmodule Shopbird.Router do
  use Shopbird.Web, :router

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

  scope "/", Shopbird do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/products", ProductController

    get "/registration", RegistrationController, :new
    post "/registration", RegistrationController, :create
  end

  scope "/auth", Shopbird do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    get "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Shopbird do
  #   pipe_through :api
  # end
end
