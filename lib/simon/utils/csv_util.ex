defmodule Simon.Utils.CSVUtil do
  @moduledoc false

  alias NimbleCSV.RFC4180, as: CSV

  def get_column_name(file) do
    file
    |> File.stream!()
    |> CSV.to_line_stream()
    |> Enum.fetch!(0)
    |> String.split(",")
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, val} end)
  end

  def csv_row_to_table_record(file) do
    column_name = get_column_name(file)

    file
    |> File.stream!()
    |> CSV.parse_stream(skip_header: true)
    |> Enum.map(fn row ->
      row
      |> Enum.with_index()
      |> Map.new(fn {val, num} -> {Map.get(column_name, num), val} end)
    end)
  end

  def get_column(rows) do
    rows
    |> Enum.at(0)
    |> Map.keys()
  end
end
