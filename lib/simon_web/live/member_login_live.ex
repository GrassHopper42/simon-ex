defmodule SimonWeb.MemberLoginLive do
  use SimonWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center h-full max-w-sm mx-auto">
      <.header class="text-center">
        로그인
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
        <.input field={@form[:phone_number]} type="tel" label="전화번호" required />
        <.input field={@form[:password]} type="password" label="비밀번호" required />

        <:actions>
          <.button phx-disable-with="로그인 중" class="w-full">
            로그인 <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    <.flash_group flash={@flash} />
    """
  end

  def mount(_params, _session, socket) do
    phone_number = live_flash(socket.assigns.flash, :phone_number)
    form = to_form(%{"phone_number" => phone_number}, as: "member")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form], layout: false}
  end
end
