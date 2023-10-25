defmodule SimonWeb.Layouts do
  @moduledoc false
  use SimonWeb, :html
  import SimonWeb.LayoutComponents

  embed_templates "layouts/*"
end
