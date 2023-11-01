defmodule SimonWeb.MemberLive.FormComponent do
  use SimonWeb, :live_component

  alias Ecto
  alias Simon.HumanResources.Member
  alias Simon.HumanResources.Service.RegisterNewMember

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.form
        :let={f}
        for={@form}
        id="member-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="mb-4 grid gap-4 sm:grid-cols-2">
          <.input field={f[:name]} type="text" label="이름" />
          <.input field={f[:phone_number]} type="tel" label="전화번호" />
          <.input field={f[:birthday]} type="date" label="생년월일" />
        </div>
        <.button phx-disable-with="Saving...">등록</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{member: member} = assigns, socket) do
    changeset = Member.registration_changeset(member)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"member" => member_params}, socket) do
    changeset =
      socket.assigns.member
      |> Member.registration_changeset(member_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"member" => member_params}, socket) do
    save_member(socket, socket.assigns.action, member_params)
  end

  defp save_member(socket, :new, member_params) do
    case RegisterNewMember.call(member_params) do
      {:ok, member} ->
        notify_parent({:saved, member})

        {:noreply,
         socket
         |> put_flash(:info, "직원 등록이 완료되었습니다.")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
