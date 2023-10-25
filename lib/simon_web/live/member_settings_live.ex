defmodule SimonWeb.MemberSettingsLive do
  use SimonWeb, :live_view

  alias Simon.HumanResources

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account phone_number address and password settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@phone_number_form}
          id="phone_number_form"
          phx-submit="update_phone_number"
          phx-change="validate_phone_number"
        >
          <.input field={@phone_number_form[:phone_number]} type="tel" label="phone_number" required />
          <.input
            field={@phone_number_form[:current_password]}
            name="current_password"
            id="current_password_for_phone_number"
            type="password"
            label="Current password"
            value={@phone_number_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change phone_number</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/members/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <.input
            field={@password_form[:phone_number]}
            type="hidden"
            id="hidden_member_phone_number"
            value={@current_phone_number}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case HumanResources.update_member_phone_number(socket.assigns.current_member, token) do
        :ok ->
          put_flash(socket, :info, "phone_number changed successfully.")

        :error ->
          put_flash(socket, :error, "phone_number change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/members/settings")}
  end

  def mount(_params, _session, socket) do
    member = socket.assigns.current_member
    phone_number_changeset = HumanResources.change_member_phone_number(member)
    password_changeset = HumanResources.change_member_password(member)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:phone_number_form_current_password, nil)
      |> assign(:current_phone_number, member.phone_number)
      |> assign(:phone_number_form, to_form(phone_number_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "member" => member_params} = params

    password_form =
      socket.assigns.current_member
      |> HumanResources.change_member_password(member_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "member" => member_params} = params
    member = socket.assigns.current_member

    case HumanResources.update_member_password(member, password, member_params) do
      {:ok, member} ->
        password_form =
          member
          |> HumanResources.change_member_password(member_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
