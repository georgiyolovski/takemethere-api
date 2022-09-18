defmodule TakeMeThereWeb.Router do
  use TakeMeThereWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug(TakeMeThereWeb.Plugs.Auth)
  end

  scope "/api", TakeMeThereWeb do
    pipe_through :api

    get "/health", HealthController, :status
    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
    post "/auth/register/google", AuthController, :google_register
    post "/auth/login/google", AuthController, :google_login
  end

  scope "/api", TakeMeThereWeb do
    pipe_through [:api, :authenticated]

    get "/locations", LocationsController, :list
    post "/search_sessions", SearchSessionsController, :create
    get "/search_sessions/:id", SearchSessionsController, :get
    get "/search_sessions/:search_session/flights", FlightsController, :get_prices
    get "/search_sessions/:search_session/places", PlacesController, :get_places
    get "/search_sessions/:search_session/hotels", HotelsController, :get_hotels
    get "/booking_url", FlightsController, :get_booking_url
    get "/hotels/booking_url", HotelsController, :get_booking_url
    get "/trips", TripsController, :get
    get "/trips/:id", TripsController, :get_trip
    post "/trips", TripsController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TakeMeThereWeb.Telemetry
    end
  end
end
