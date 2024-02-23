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
      live "/login", MemberLoginLive, :new
      live "/members/register", MemberRegistrationLive, :new
      live "/members/reset_password", MemberForgotPasswordLive, :new
      live "/members/reset_password/:token", MemberResetPasswordLive, :edit
    end

    post "/login", MemberSessionController, :create
  end

  scope "/", SimonWeb do
    pipe_through [:browser, :require_authenticated_member]

    live_session :require_authenticated_member,
      on_mount: [{SimonWeb.MemberAuth, :ensure_authenticated}] do
      get "/", PageController, :home
      live "/members/settings", MemberSettingsLive, :edit
      live "/members/settings/confirm_email/:token", MemberSettingsLive, :confirm_email
    end
  end

  scope "/", SimonWeb do
    pipe_through [:browser]

    delete "/members/logout", MemberSessionController, :delete

    live_session :current_member,
      on_mount: [{SimonWeb.MemberAuth, :mount_current_member}, SimonWeb.RouteAssigns] do
      live "/members/confirm/:token", MemberConfirmationLive, :edit
      live "/members/confirm", MemberConfirmationInstructionsLive, :new

      live "/products", ProductLive.Index, :index
      live "/products/new", ProductLive.Index, :new
      live "/products/:id/edit", ProductLive.Index, :edit
      live "/products/import", ProductLive.Import

      live "/products/:id", ProductLive.Show, :show
      live "/products/:id/show/edit", ProductLive.Show, :edit

      live "/categories", CategoryLive.Index, :index
      live "/categories/new", CategoryLive.Index, :new
      live "/categories/:id/edit", CategoryLive.Index, :edit

      live "/categories/:id", CategoryLive.Show, :show
      live "/categories/:id/show/edit", CategoryLive.Show, :edit

      live "/bundles", BundleLive.Index, :index
      live "/bundles/new", BundleLive.Index, :new
      live "/bundles/:id/edit", BundleLive.Index, :edit

      live "/bundles/:id", BundleLive.Show, :show
      live "/bundles/:id/show/edit", BundleLive.Show, :edit

      live "/members", MemberLive.Index, :index
      live "/members/new", MemberLive.Index, :new

      live "/parties", PartyLive.Index, :index
      live "/parties/new", PartyLive.Index, :new
      live "/parties/:id/edit", PartyLive.Index, :edit

      live "/parties/:id", PartyLive.Show, :show
      live "/parties/:id/show/edit", PartyLive.Show, :show
    end
  end
end
