defmodule Exfile.TruncateProcessor do
  @behaviour Exfile.Processor

  alias Exfile.LocalFile

  def call(file, [max_length], _opts) do
    {:ok, f} = LocalFile.open(file)
    everything = IO.binread(f, :all) |> IO.chardata_to_string
    {head, _tail} = String.split_at(everything, String.to_integer(max_length))
    {:ok, truncated_io} = File.open(head, [:ram, :binary])
    {:ok, %LocalFile{io: truncated_io, meta: file.meta}}
  end
end
