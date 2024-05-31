defmodule Simon.Meilisearch do
  @moduledoc """
  Meilisearch module
  """

  def search(index, query) do
    response =
      index_url(index)
      |> Kernel.<>("/search")
      |> post!(%{q: query})

    body = Jason.decode!(response.body)

    hits = body["hits"]
    processing_time = body["processingTimeMs"]

    :logger.info("Meilisearch search #{length(hits)} results")
    :logger.info("Meilisearch search took #{processing_time}ms")

    hits
  end

  def add_or_replace(index, documents, primary_key \\ "id") do
    response =
      document_url(index)
      |> Kernel.<>("?primaryKey=#{primary_key}")
      |> post!(documents)

    {:ok, response.status_code}
  end

  @spec add_or_update(String.t(), [map()], String.t()) :: {:ok, integer()} | {:error, any()}
  @spec add_or_update(String.t(), [map()]) :: {:ok, integer()} | {:error, any()}
  def add_or_update(index, documents, primary_key \\ "id") do
    response =
      document_url(index)
      |> Kernel.<>("?primaryKey=#{primary_key}")
      |> put!(documents)

    {:ok, response.status_code}
  end

  @spec delete(String.t(), [integer()]) :: {:ok, integer()} | {:error, any()}
  def delete(index, ids) do
    response =
      document_url(index)
      |> Kernel.<>("/delete-batch")
      |> post!(ids)

    {:ok, response.status_code}
  end

  defp post!(url, body) do
    HTTPoison.post!(url, encode!(body), headers())
  end

  defp put!(url, body) do
    HTTPoison.put!(url, encode!(body), headers())
  end

  defp document_url(index) do
    index_url(index)
    |> Kernel.<>("/documents")
  end

  defp index_url(index) do
    meilisearch_url()
    |> Kernel.<>("/indexes/#{index}")
  end

  defp meilisearch_url do
    Application.get_env(:simon, Simon.Meilisearch)[:url]
  end

  defp headers do
    [{"Content-Type", "application/json"}]
  end

  defp encode!(struct) do
    struct
    |> Jason.encode!()
  end
end
