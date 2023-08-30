defmodule Wbxml.Queue do
  require Logger
  import Bitwise

  def put(input) do
    queue =
      input
      |> String.to_charlist()
      |> :queue.from_list()

    Logger.debug("Array byte count: #{:queue.len(queue)}")
    queue
  end

  def get(queue) do
    case :queue.out(queue) do
      {{:value, v}, q} ->
        Logger.debug("Dequeued byte: #{v}")
        {v, q}

      {:empty, _q} ->
        raise "Queue is empty"
    end
  end

  def check_continuation_bit(byteval) do
    continuationBitmask = 0x80
    band(continuationBitmask, byteval) != 0
  end

  def dequeue_multibyte_int(queue, iReturn \\ 0) do
    iReturn = iReturn <<< 7

    if :queue.len(queue) != 0 do
      {singleByte, queue} = get(queue)
      iReturn = iReturn + band(singleByte, 0x7F)

      case check_continuation_bit(singleByte) do
        true -> dequeue_multibyte_int(queue, iReturn)
        false -> {iReturn, queue}
      end
    else
      raise "DeQueue is empty"
    end
  end

  def dequeue_string(queue, len \\ 0) do
    chars = []

    if len != 0 do
      range(queue, chars, len)
    else
      while(queue, chars)
    end
  end

  defp while(queue, chars) do
    {singleByte, queue} = get(queue)

    if singleByte != 0x00 do
      while(queue, chars ++ [singleByte])
    else
      {chars, queue}
    end
  end

  defp range(queue, chars, len) do
    if :queue.len(queue) != 0 do
      {singleByte, queue} = get(queue)
      range(queue, chars ++ [singleByte], len - 1)
    else
      {chars, queue}
    end
  end
end
