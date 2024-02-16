defmodule SimonWeb.ProductLive.Import do
  use SimonWeb, :live_view

  alias Simon.Utils.CSVUtil

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:parsed_rows, [])
      |> assign(:valid_category_column, false)
      |> assign(:valid_name_column, false)
      |> assign(:valid_code_column, false)
      |> assign(:valid_price_column, false)
      |> assign(:valid_column, false)
      |> allow_upload(:csv,
        accept: ~w(.csv),
        max_entries: 1,
        auto_upload: true,
        progress: &handle_progress/3
      )
    }
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("import", %{"parsed_rows" => parsed_rows}, socket) do
    :logger.debug(parsed_rows)

    {:noreply, socket}
  end

  @impl true
  def handle_event("reset", _params, socket) do
    {:noreply, socket |> assign(:parsed_rows, [])}
  end

  defp handle_progress(:csv, entry, socket) do
    if entry.done? do
      parsed_rows =
        consume_uploaded_entries(socket, :csv, fn %{path: path}, _entry ->
          {:ok, CSVUtil.csv_row_to_table_record(path)}
        end)

      {
        :noreply,
        socket
        |> assign(:parsed_rows, parsed_rows |> Enum.at(0))
        |> validate_column()
      }
    else
      {:noreply, socket}
    end
  end

  @spec validate_column(any()) :: any()
  defp validate_column(socket) do
    socket
    |> assign(:columns, CSVUtil.get_column(socket.assigns.parsed_rows))
    |> validate_category_column()
    |> validate_name_column()
    |> validate_code_column()
    |> validate_price_column()
    |> valid_all_column?()
  end

  defp validate_category_column(socket) when socket.assigns.valid_column do
    socket.assigns.columns
    |> Enum.any?(fn {_, v} -> v == "category" end)
    |> case do
      true -> socket |> assign(:valid_category_column, true)
      false -> socket
    end
  end

  defp validate_category_column(socket), do: socket

  defp validate_name_column(socket) when socket.assigns.valid_column do
    socket.assigns.columns
    |> Enum.any?(fn {_, v} -> v == "name" end)
    |> case do
      true -> socket |> assign(:valid_name_column, true)
      false -> socket
    end
  end

  defp validate_name_column(socket), do: socket

  defp validate_code_column(socket) when socket.assigns.valid_column do
    socket.assigns.columns
    |> Enum.any?(fn {_, v} -> v == "code" end)
    |> case do
      true -> socket |> assign(:valid_code_column, true)
      false -> socket
    end
  end

  defp validate_price_column(socket) do
    socket.assigns.columns
    |> Enum.any?(fn {_, v} -> v == "price" end)
    |> case do
      true -> socket |> assign(:valid_price_column, true)
      false -> socket
    end
  end

  defp valid_all_column?(socket) do
    socket
    |> assign(
      :valid_column,
      socket.assigns.valid_category_column && socket.assigns.valid_name_column &&
        socket.assigns.valid_code_column && socket.assigns.valid_price_column
    )
  end
end
