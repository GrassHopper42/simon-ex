defmodule SimonWeb.MemberForgotPasswordLive do
  use SimonWeb, :live_view

  alias Simon.HumanResources

  def render(assigns) do
    ~H"""
    <div class="max-w-sm mx-auto">
      <.header class="text-center">
        Forgot your password?
        <:subtitle>We'll send a password reset link to your inbox</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_phone_number">
        <.input field={@form[:phone_number]} type="tel" placeholder="phone_number" required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Send password reset instructions
          </.button>
        </:actions>
      </.simple_form>
      <p class="mt-4 text-sm text-center">
        <.link href={~p"/members/register"}>Register</.link>
        | <.link href={~p"/members/log_in"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "member"))}
  end

  def handle_event("send_phone_number", %{"member" => %{"phone_number" => phone_number}}, socket) do
    if member = HumanResources.get_member_by_phone_number(phone_number) do
      HumanResources.deliver_member_reset_password_instructions(
        member,
        &url(~p"/members/reset_password/#{&1}")
      )
    end

    info =
      "If your phone_number is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
