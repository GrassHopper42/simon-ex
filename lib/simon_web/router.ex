defmodule SimonWeb.Router do
  use SimonWeb, :router

  import PhoenixStorybook.Router
  import SimonWeb.MemberAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimonWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_member
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", SimonWeb do
    pipe_through :browser

    live_storybook("/storybook", backend_module: SimonWeb.Storybook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimonWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:simon, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SimonWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SimonWeb do
    pipe_through [:browser, :redirect_if_member_is_authenticated]

    live_session :redirect_if_member_is_authenticated,
      on_mount: [{SimonWeb.MemberAuth, :redirect_if_member_is_authenticated}] do
      live "/members/register", MemberRegistrationLive, :new
      live "/", MemberLoginLive, :new
      live "/members/reset_password", MemberForgotPasswordLive, :new
      live "/members/reset_password/:token", MemberResetPasswordLive, :edit
    end

    post "/members/log_in", MemberSessionController, :create
  end

  scope "/", SimonWeb do
    pipe_through [:browser, :require_authenticated_member]

    live_session :require_authenticated_member,
      on_mount: [{SimonWeb.MemberAuth, :ensure_authenticated}] do
      live "/members/settings", MemberSettingsLive, :edit
      live "/members/settings/confirm_email/:token", MemberSettingsLive, :confirm_email
    end
  end

  scope "/", SimonWeb do
    pipe_through [:browser]

    delete "/members/log_out", MemberSessionController, :delete

    live_session :current_member,
      on_mount: [{SimonWeb.MemberAuth, :mount_current_member}, SimonWeb.RouteAssigns] do
      live "/members/confirm/:token", MemberConfirmationLive, :edit
      live "/members/confirm", MemberConfirmationInstructionsLive, :new

      live "/products", ProductLive.Index, :index
      live "/products/new", ProductLive.Index, :new
      live "/products/:id/edit", ProductLive.Index, :edit

      live "/products/:id", ProductLive.Show, :show
      live "/products/:id/show/edit", ProductLive.Show, :edit

      live "/categories", CategoryLive.Index, :index
      live "/categories/new", CategoryLive.Index, :new
      live "/categories/:id/edit", CategoryLive.Index, :edit

      live "/categories/:id", CategoryLive.Show, :show
      live "/categories/:id/show/edit", CategoryLive.Show, :edit
    end
  end
end
