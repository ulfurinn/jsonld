defmodule UlfNet.JSONLD.Loader do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec load(String.t(), JSON.LD.Options.t()) ::
          {:ok, JSON.LD.DocumentLoader.RemoteDocument.t()} | {:error, any}
  def load(url, opts) do
    case :ets.lookup(__MODULE__, url) do
      [{^url, document}] ->
        {:ok, document}

      _ ->
        case JSON.LD.DocumentLoader.Default.load(url, opts) do
          {:ok, document} ->
            :ets.insert(__MODULE__, {url, document})
            {:ok, document}

          error ->
            error
        end
    end
  end

  def cache(url, document) do
    :ets.insert(
      __MODULE__,
      {url,
       %JSON.LD.DocumentLoader.RemoteDocument{
         context_url: nil,
         document_url: url,
         document: document
       }}
    )
  end

  def init(_) do
    table =
      :ets.new(__MODULE__, [
        :named_table,
        :public,
        read_concurrency: true,
        write_concurrency: true
      ])

    {:ok, table}
  end
end
