defmodule SimonWeb.RouteAssigns do
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    {:cont, socket |> attach_hook(:active_route, :handle_params, &set_active_route/3)}
  end

  defp set_active_route(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end
end
