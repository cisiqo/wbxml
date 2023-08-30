defmodule Wbxml.GlobalTokens do
  @moduledoc """
  Global tokens for `Wbxml`.
  """
  @switch_page 0x00
  @end_i 0x01
  @entity 0x02
  @str_i 0x03
  @literal 0x04
  @ext_i_0 0x40
  @ext_i_1 0x41
  @ext_i_2 0x42
  @pi 0x43
  @literal_c 0x44
  @ext_t_0 0x80
  @ext_t_1 0x81
  @ext_t_2 0x82
  @str_t 0x83
  @literal_a 0x84
  @ext_0 0xC0
  @ext_1 0xC1
  @ext_2 0xC2
  @opaque_i 0xC3
  @literal_ac 0xC4

  defmacro switch_page, do: @switch_page
  defmacro end_i, do: @end_i
  defmacro entity, do: @entity
  defmacro str_i, do: @str_i
  defmacro literal, do: @literal
  defmacro ext_i_0, do: @ext_i_0
  defmacro ext_i_1, do: @ext_i_1
  defmacro ext_i_2, do: @ext_i_2
  defmacro pi, do: @pi
  defmacro literal_c, do: @literal_c
  defmacro ext_t_0, do: @ext_t_0
  defmacro ext_t_1, do: @ext_t_1
  defmacro ext_t_2, do: @ext_t_2
  defmacro str_t, do: @str_t
  defmacro literal_a, do: @literal_a
  defmacro ext_0, do: @ext_0
  defmacro ext_1, do: @ext_1
  defmacro ext_2, do: @ext_2
  defmacro opaque_i, do: @opaque_i
  defmacro literal_ac, do: @literal_ac

  defmacro unused_array,
    do: [
      @entity,
      @ext_0,
      @ext_1,
      @ext_2,
      @ext_i_0,
      @ext_i_1,
      @ext_i_2,
      @ext_t_0,
      @ext_t_1,
      @ext_t_2,
      @literal,
      @literal_a,
      @literal_ac,
      @literal_c,
      @pi,
      @str_t
    ]
end
