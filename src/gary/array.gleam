import gleam/dict.{type Dict}
import internal/array_bindings.{type ErlangArray, Default}

pub type Array(t) =
  ErlangArray(t)

// create arrays
pub fn create(default: t) -> Array(t) {
  array_bindings.new([#(Default, default)])
}

pub fn create_fixed_size(size size: Int, default default: t) -> Array(t) {
  array_bindings.new_with_size(size, [#(Default, default)])
}

pub fn create_from_list(from list: List(t), default default: t) -> Array(t) {
  array_bindings.from_list(list, default)
}

pub fn create_from_dict(from dict: Dict(Int, t), default default: t) -> Array(t) {
  dict
  |> dict.to_list
  |> array_bindings.from_orddict(default)
}

// create other types from arrays
pub fn to_list(array: Array(t)) -> List(t) {
  array_bindings.to_list(array)
}

pub fn to_dict(array: Array(t)) -> Dict(Int, t) {
  array
  |> array_bindings.to_orddict()
  |> dict.from_list
}

// modify array content
pub fn set(into array: Array(t), at index: Int, put item: t) -> Array(t) {
  array_bindings.set(index, item, array)
}

pub fn drop(from array: Array(t), at index: Int) -> Array(t) {
  array_bindings.reset(index, array)
}

// higher-order array functions

pub fn map(over array: Array(a), with function: fn(Int, a) -> b) -> Array(b) {
  array_bindings.map(function, array)
}

pub fn sparse_map(
  over array: Array(a),
  with function: fn(Int, a) -> b,
) -> Array(b) {
  array_bindings.sparse_map(function, array)
}

pub fn fold(
  over array: Array(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.foldl(function, initial, array)
}

pub fn fold_right(
  over array: Array(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.foldr(function, initial, array)
}

pub fn sparse_fold(
  over array: Array(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.sparse_foldl(function, initial, array)
}

pub fn sparse_fold_right(
  over array: Array(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.sparse_foldr(function, initial, array)
}

// get array info
pub fn get(from array: Array(t), at index: Int) -> t {
  array_bindings.get(index, array)
}

pub fn get_size(array: Array(t)) -> Int {
  array_bindings.size(array)
}

pub fn get_default(array: Array(t)) -> t {
  array_bindings.default(array)
}

pub fn is_fixed_size(array: Array(t)) -> Bool {
  array_bindings.is_fix(array)
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
