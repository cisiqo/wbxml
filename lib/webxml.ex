defmodule Wbxml do
  @moduledoc """
  Documentation for `Wbxml`.
  """

  def encode(xml) do
    {element, []} =
      xml
      |> String.to_charlist()
      |> :xmerl_scan.string()

    Wbxml.Parse.encode(element) |> List.to_string()
  end

  def decode(bytes) do
    Wbxml.Parse.decode(bytes)
  end
end
