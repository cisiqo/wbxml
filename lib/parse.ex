defmodule Wbxml.Parse do
  @versionByte 0x03
  @publicIdentifierByte 0x01
  @characterSetByte 0x6A
  @stringTableLengthByte 0x00

  require Record
  require Logger
  import Bitwise
  use Wbxml.CodePage
  require Wbxml.GlobalTokens
  require Wbxml.Queue

  Record.defrecord(
    :xmlElement,
    Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  )

  Record.defrecord(
    :xmlText,
    Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  )

  Record.defrecord(
    :xmlAttribute,
    Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  )

  def decode(bytes) do
    bytes_queue = Wbxml.Queue.put(bytes)
    {version, bytes_queue} = Wbxml.Queue.get(bytes_queue)
    {public_id, bytes_queue} = Wbxml.Queue.dequeue_multibyte_int(bytes_queue)
    Logger.debug("Version: #{version}, Public Identifier: #{public_id}")

    {charset, bytes_queue} = Wbxml.Queue.dequeue_multibyte_int(bytes_queue)

    if charset != 0x6A do
      raise "ASWBXML only supports UTF-8 encoded XML."
    end

    {string_table_length, bytes_queue} = Wbxml.Queue.dequeue_multibyte_int(bytes_queue)

    if string_table_length != 0 do
      raise "WBXML data contains a string table."
    end

    element = decode_codepage(bytes_queue)
    xml = :xmerl.export_simple([element], :xmerl_xml, [{:prolog, ""}])
    :unicode.characters_to_binary(xml)
  end

  defp decode_codepage(queue, parent_nodes \\ [], current_node \\ nil, current_codepage \\ 0) do
    if :queue.len(queue) > 0 do
      {current_byte, queue} = Wbxml.Queue.dequeue_multibyte_int(queue)

      cond do
        current_byte == Wbxml.GlobalTokens.switch_page() ->
          {new_codepage, queue} = Wbxml.Queue.dequeue_multibyte_int(queue)

          if new_codepage > 0 and new_codepage < 25 do
            current_codepage = new_codepage
            decode_codepage(queue, parent_nodes, current_node, current_codepage)
          else
            raise "Unknown code page ID #{new_codepage} encountered in WBXML"
          end

        current_byte == Wbxml.GlobalTokens.end_i() ->
          if current_node != nil and length(parent_nodes) >= 1 do
            parent_nodes = Enum.drop(parent_nodes, -1)

            if parent_nodes == [] do
              current_node
            else
              parent_nodes = replace_child(parent_nodes, current_node)
              current_node = List.last(parent_nodes)

              decode_codepage(queue, parent_nodes, current_node, current_codepage)
            end
          else
            raise "END global token encountered out of sequence"
          end

        current_byte == Wbxml.GlobalTokens.opaque_i() ->
          {cdata_len, queue} = Wbxml.Queue.dequeue_multibyte_int(queue)
          {text, queue} = Wbxml.Queue.dequeue_string(queue, cdata_len)
          text_node = xmlText(value: text, type: :cdata)

          current_node_child = xmlElement(current_node, :content)
          new_node_child = current_node_child ++ [text_node]
          current_node = xmlElement(current_node, content: new_node_child)

          decode_codepage(queue, parent_nodes, current_node, current_codepage)

        current_byte == Wbxml.GlobalTokens.str_i() ->
          {text, queue} = Wbxml.Queue.dequeue_string(queue)
          text_node = xmlText(value: text)

          current_node_child = xmlElement(current_node, :content)
          new_node_child = current_node_child ++ [text_node]
          current_node = xmlElement(current_node, content: new_node_child)

          decode_codepage(queue, parent_nodes, current_node, current_codepage)

        Enum.member?(Wbxml.GlobalTokens.unused_array(), current_byte) ->
          raise "Encountered unknown global token: #{current_byte}"

        true ->
          has_attr = band(current_byte, 0x80) > 0
          has_content = band(current_byte, 0x40) > 0

          token = band(current_byte, 0x3F)

          if has_attr do
            raise "Token #{current_byte} has attributes."
          end

          tag =
            Wbxml.Parse.__codepage__()
            |> Enum.at(current_codepage)
            |> Wbxml.CodePage.get_tag(token)

          if tag == nil do
            raise "UNKNOWN TAG #{token}."
          end

          new_node = xmlElement(name: String.to_atom(tag))

          if has_content do
            parent_nodes = parent_nodes ++ [new_node]
            current_node = new_node
            decode_codepage(queue, parent_nodes, current_node, current_codepage)
          else
            parent_nodes = replace_child(parent_nodes, new_node)
            current_node = List.last(parent_nodes)
            decode_codepage(queue, parent_nodes, current_node, current_codepage)
          end
      end
    end
  end

  defp replace_child(parent_nodes, node) do
    element = List.last(parent_nodes)
    element_child = xmlElement(element, :content)
    element_child = element_child ++ [node]
    element = xmlElement(element, content: element_child)
    List.replace_at(parent_nodes, -1, element)
  end

  def encode(element) do
    charlists = []

    charlists =
      charlists ++
        [@versionByte, @publicIdentifierByte, @characterSetByte, @stringTableLengthByte]

    {node_charlists, _current_codepage, _default_codepage} = encode_node(element)
    charlists ++ node_charlists
  end

  defp encode_node(element, current_codepage \\ 0, default_codepage \\ -1) do
    charlists = []

    cond do
      Record.is_record(element, :xmlElement) ->
        content = xmlElement(element, :content)
        attributes = xmlElement(element, :attributes)
        name = xmlAttribute(element, :name) |> Atom.to_string()

        {prefix, local} =
          case xmlElement(element, :nsinfo) do
            [] -> {"", ""}
            {prefix, local} -> {List.to_string(prefix), List.to_string(local)}
          end

        {default_codepage, _codepage_xmlns} =
          if length(attributes) > 0 do
            encode_attrabutes(attributes)
          else
            {default_codepage, nil}
          end

        new_name =
          if local != "" do
            local
          else
            name
          end

        prefix =
          if prefix == "" and default_codepage == -1 do
            name
          else
            prefix
          end

        {type, current_codepage} =
          set_codepage_by_namespace(prefix, current_codepage, default_codepage)

        charlists =
          case type do
            false ->
              charlists

            true ->
              charlists = charlists ++ [Wbxml.GlobalTokens.switch_page()]
              charlists ++ [current_codepage]
          end

        token =
          Wbxml.Parse.__codepage__()
          |> Enum.at(current_codepage)
          |> Wbxml.CodePage.get_token(new_name)

        token = if length(content) > 0, do: bor(token, 0x40), else: token
        charlists = charlists ++ [token]

        if length(content) > 0 do
          {charlists, _current_codepage, _default_codepage} =
            List.foldl(content, {charlists, current_codepage, default_codepage}, fn node, acc ->
              {charlists, current_codepage, default_codepage} = acc

              {node_charlists, node_current_codepage, node_default_codepage} =
                encode_node(node, current_codepage, default_codepage)

              {charlists ++ node_charlists, node_current_codepage, node_default_codepage}
            end)

          {charlists ++ [Wbxml.GlobalTokens.end_i()], current_codepage, default_codepage}
        else
          {charlists, current_codepage, default_codepage}
        end

      Record.is_record(element, :xmlText) ->
        case xmlText(element, :type) do
          :text ->
            charlists = charlists ++ [Wbxml.GlobalTokens.str_i()]
            content = xmlText(element, :value)
            {charlists ++ content ++ [0x00], current_codepage, default_codepage}

          :cdata ->
            charlists = charlists ++ [Wbxml.GlobalTokens.opaque_i()]
            content = xmlText(element, :value)
            {charlists ++ encode_opaque(content), current_codepage, default_codepage}
        end
    end
  end

  defp encode_attrabutes(attributes) do
    [head | tail] = attributes
    value = xmlAttribute(head, :value)
    name = xmlAttribute(head, :name)

    {prefix, local} =
      case xmlAttribute(head, :nsinfo) do
        [] -> {"", ""}
        {prefix, local} -> {prefix, local}
      end

    codepage_index = index_codepage(Wbxml.Parse.__codepage__(), List.to_string(value))

    cond do
      String.upcase(Atom.to_string(name)) == "XMLNS" ->
        {codepage_index, nil}

      String.upcase(prefix) == "XMLNS" ->
        codepage_xmlns = local
        {nil, codepage_xmlns}

      true ->
        encode_attrabutes(tail)
    end
  end

  defp set_codepage_by_namespace(namespace, current_codepage, default_codepage) do
    if namespace == "" do
      case current_codepage do
        ^default_codepage ->
          {false, current_codepage}

        _ ->
          current_codepage = default_codepage
          {true, current_codepage}
      end
    else
      codepage_namespace =
        Wbxml.Parse.__codepage__()
        |> Enum.at(current_codepage)
        |> Map.get(:xmlns)

      if String.upcase(codepage_namespace) == String.upcase(namespace) do
        {false, current_codepage}
      else
        current_codepage = index_codepage(Wbxml.Parse.__codepage__(), namespace)
        {true, current_codepage}
      end
    end
  end

  defp index_codepage(list, namespace, i \\ 0) do
    codepage = Enum.at(list, i)

    if codepage == nil do
      raise "Unknown xmlns: #{namespace}"
    end

    if String.upcase(Map.get(codepage, :xmlns)) == String.upcase(namespace) do
      i
    else
      index_codepage(list, namespace, i + 1)
    end
  end

  defp encode_opaque(str) do
    charlists = String.to_charlist(str)
    (charlists |> length() |> encode_multi_byte_integer()) ++ charlists
  end

  defp encode_multi_byte_integer(i, charlists \\ []) do
    if i > 0 do
      add_byte = band(i, 0x7F)

      if length(charlists) > 0 do
        add_byte = bor(add_byte, 0x80)
        List.insert_at(charlists, 0, add_byte)
      else
        List.insert_at(charlists, 0, add_byte)
      end

      i = i >>> 7
      encode_multi_byte_integer(i, charlists)
    end

    charlists
  end
end
