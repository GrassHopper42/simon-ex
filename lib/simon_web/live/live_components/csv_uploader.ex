defmodule SimonWeb.CsvUploader do
  @moduledoc false

  use SimonWeb, :live_component

  alias Simon.Utils.CSVUtil

  @impl true
  def render(assigns) do
    ~H"""
    <form
      id="csv-uploader"
      phx-submit="upload_csv"
      phx-change="parse"
      class="flex items-center justify-center w-full"
    >
      <div
        phx-drop-target={@uploads.csv.ref}
        class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
      >
        <div class="flex flex-col items-center justify-center pt-5 pb-6">
          <svg
            class="w-8 h-8 mb-4 text-gray-500 dark:text-gray-400"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 20 16"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
            />
          </svg>
          <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
            <span class="font-semibold">클릭해서 업로드</span>하거나 파일을 위에 드래그앤드롭하세요
          </p>
          <p class="text-xs text-gray-500 dark:text-gray-400">CSV 파일만 가능합니다.</p>
        </div>
        <.live_file_input upload={@uploads.csv} accept=".csv" />
      </div>
      <button type="submit">업로드</button>
    </form>
    """
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)
    }
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end
end
