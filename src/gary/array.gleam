import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}
import internal/array_bindings.{
  type ArrayOption, type ErlangArray, Default, Fixed, Size,
}

pub opaque type Array(t) {
  Array(array: ErlangArray(t), size: Option(Int), default: t)
}

// create arrays
pub fn create(default: t) -> Array(t) {
  array_bindings.new([#(Default, default)])
  |> Array(size: None, default: default)
}

pub fn create_fixed_size(size: Int, default: t) -> Array(t) {
  array_bindings.new_with_size(size, [#(Default, default)])
  |> Array(size: Some(size), default: default)
}

// create other types from arrays
pub fn create_from_list(list: List(t), default: t) -> Array(t) {
  array_bindings.from_list(list, default)
  |> Array(size: None, default: default)
}

pub fn create_from_dict(dict: Dict(Int, t), default: t) -> Array(t) {
  dict
  |> dict.to_list
  |> array_bindings.from_orddict(default)
  |> Array(size: None, default: default)
}
// modify array content

// higher-order array functions

// get array info

// change the array's properties
