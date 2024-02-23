defmodule SimonWeb.PartyLive.FormComponent do
  @moduledoc false

  use SimonWeb, :live_component

  alias Ecto
  alias Simon.Relationship.Party
  alias Simon.Relationship.Service.RegisterNewParty

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
        id="party-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="mb-4 grid gap-4 sm:grid-cols-2">
          <.radio_fieldset
            field={f[:type]}
            options={[%{label: "기업", value: "organization"}, %{label: "개인", value: "person"}]}
            checked_value={@form.params["type"] || "organization"}
          />
          <%= if @form.params["type"] == "person" do %>
            <.input field={f[:name]} type="text" label="이름" required />
          <% else %>
            <.input field={f[:name]} type="text" label="상호" required />
            <.input
              field={f[:tax_id]}
              type="text"
              inputmode="numeric"
              pattern="[0-9]*"
              label="사업자등록번호"
              placeholder="-없이 입력해주세요"
              minlength="10"
              maxlength="10"
              required
            />
          <% end %>
          <.input field={f[:address]} type="text" label="주소" />
          <.input field={f[:memo]} type="textarea" label="메모" />
        </div>
        <.button phx-disable-with="Saving...">등록</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{party: party} = assigns, socket) do
    changeset = Party.changeset(party)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"party" => party_params}, socket) do
    changeset =
      socket.assigns.party
      |> Party.changeset(party_params)
      |> Map.put(:action, :validate)

    :logger.debug("Assigns: #{inspect(socket)}")

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"party" => party_params}, socket) do
    save_member(socket, socket.assigns.action, party_params)
  end

  defp save_member(socket, :new, party_params) do
    case RegisterNewParty.call(party_params) do
      {:ok, party} ->
        notify_parent({:saved, party})

        {:noreply,
         socket
         |> put_flash(:info, "거래처 등록이 완료되었습니다.")
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
