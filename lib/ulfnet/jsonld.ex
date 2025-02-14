defmodule UlfNet.JSONLD do
  @moduledoc """
  Documentation for `UlfNet.JSONLD`.
  """

  defmacro __using__(_) do
    quote do
      import UlfNet.JSONLD, only: [vocab: 2]

      Module.register_attribute(__MODULE__, :vocab, accumulate: false)
      Module.register_attribute(__MODULE__, :field, accumulate: true)
    end
  end

  defmacro vocab(opts, do: block) do
    vocab0(opts, block)
  end

  defp vocab0(opts, block) do
    prelude =
      quote do
        Module.put_attribute(__MODULE__, :vocab, unquote(opts))

        try do
          import UlfNet.JSONLD
          unquote(block)
        after
          :ok
        end
      end

    postlude =
      quote unquote: false do
        vocab = Module.get_attribute(__MODULE__, :vocab)
        fields = Module.get_attribute(__MODULE__, :field)

        Enum.each(fields, fn {name, fqn} ->
          [ns, field] = String.split(fqn, ":")
          fqn_expanded = Keyword.fetch!(vocab, String.to_existing_atom(ns)) <> field

          def unquote(name)(document) do
            document[unquote(fqn_expanded)]
          end
        end)

        :ok
      end

    quote do
      unquote(prelude)
      unquote(postlude)
    end
  end

  defmacro field(name, fqn) do
    quote do
      UlfNet.JSONLD.__field__(__MODULE__, unquote(name), unquote(fqn))
    end
  end

  def __field__(mod, name, fqn) do
    Module.put_attribute(mod, :field, {name, fqn})
  end
end
