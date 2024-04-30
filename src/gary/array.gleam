import gleam/dict.{type Dict}
import internal/array_bindings.{type ErlangArray, Default}

pub type Array(t) =
  ErlangArray(t)

// create arrays
pub fn create(default: t) -> Array(t) {
  array_bindings.new([#(Default, default)])
}

pub fn create_fixed_size(size: Int, default: t) -> Array(t) {
  array_bindings.new_with_size(size, [#(Default, default)])
}

// create other types from arrays
pub fn create_from_list(list: List(t), default: t) -> Array(t) {
  array_bindings.from_list(list, default)
}

pub fn create_from_dict(dict: Dict(Int, t), default: t) -> Array(t) {
  dict
  |> dict.to_list
  |> array_bindings.from_orddict(default)
}

// modify array content

// higher-order array functions

// get array info
pub fn is_fixed_size(array: Array(t)) -> Bool {
  array_bindings.is_fix(array)
}

pub fn get_size(array: Array(t)) -> Int {
  array_bindings.size(array)
}

pub fn get_default(array: Array(t)) -> t {
  array_bindings.default(array)
}

// change the array's properties
pub fn fix_size(array: Array(t)) -> Array(t) {
  array_bindings.fix(array)
}

pub fn relax_size(array: Array(t)) -> Array(t) {
  array_bindings.relax(array)
}

pub fn set_size(array: Array(t), size: Int) -> Array(t) {
  array_bindings.resize(size, array)
}
