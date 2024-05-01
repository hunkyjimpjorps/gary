//// Functional, extendible arrays, provided by Erlang's 
//// [`array`](https://www.erlang.org/doc/man/array) module. Arrays can have fixed size,
//// or can grow automatically as needed ("extensible"). A default value is used for entries
//// that have not been explicitly set.
//// 
//// Erlang arrays are 0-indexed.  
//// The maximum index for a fixed-size array of size `n` is `n - 1`.
//// There is no maximum index for a extensible array; the array resizes to fit as necessary.
//// Negative indices aren't supported.
//// 
//// Erlang doesn't distinguish between an unset entry and a entry that's been explicitly set 
//// to the array's defined default value, which can cause issues when using functions that
//// drop unset entries like `sparse_map` or `sparse_to_list`.  Use a type like `Option(t)` to 
//// ensure that you can't accidentally cause this kind of collision.
//// 
//// See the Erlang docs for more information and caveats.
//// 

import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import internal/array_bindings.{type ErlangArray, Default}

pub type ArrayError {
  IndexOutOfRange
  BadSize
}

// create arrays

/// Creates a new, extensible sparse array with a default value of `default` for any indices
/// without an assigned value.
pub fn create(default default: t) -> ErlangArray(t) {
  array_bindings.new([#(Default, default)])
}

/// Creates a new, fixed-size sparse array of size `size` with a default value of `default` 
/// for any indices without an assigned value.  Returns a `BadSize` error if `size` is negative.
pub fn create_fixed_size(
  size size: Int,
  default default: t,
) -> Result(ErlangArray(t), ArrayError) {
  use <- bool.guard(size < 0, Error(BadSize))
  Ok(array_bindings.new_with_size(size, [#(Default, default)]))
}

/// Converts a list to an extensible sparse array, assigning list members to indices 
/// starting at an index of 0.
pub fn from_list(from list: List(t), default default: t) -> ErlangArray(t) {
  array_bindings.from_list(list, default)
}

/// Converts a dict with integer keys representing array indices to an extensible sparse array.  
/// Returns `IndexOutOfRange` if any of the keys are negative.
pub fn from_dict(
  from dict: Dict(Int, t),
  default default: t,
) -> Result(ErlangArray(t), ArrayError) {
  use <- bool.guard(
    list.any(dict.keys(dict), fn(k) { k < 0 }),
    Error(IndexOutOfRange),
  )
  dict
  |> dict.to_list
  |> array_bindings.from_orddict(default)
  |> Ok()
}

// create other types from arrays
/// Converts the array's values to a list, in order from index 0 to the maximum,
/// including the default value for any keys between 0 and
/// the maximum that don't have values.
pub fn to_list(array: ErlangArray(t)) -> List(t) {
  array_bindings.to_list(array)
}

/// Converts the array to a dict with integer keys, including the default value for any keys 
/// between 0 and the maximum that don't have values.
pub fn to_dict(array: ErlangArray(t)) -> Dict(Int, t) {
  array
  |> array_bindings.to_orddict()
  |> dict.from_list
}

/// Converts the array's values to a list, in order from lowest to highest index,
/// omitting default values.
pub fn to_list_without_defaults(array: ErlangArray(t)) -> List(t) {
  array_bindings.sparse_to_list(array)
}

/// Converts the array to a dict with integer keys, omitting default values.
pub fn to_dict_without_defaults(array: ErlangArray(t)) -> Dict(Int, t) {
  array
  |> array_bindings.sparse_to_orddict()
  |> dict.from_list
}

// modify array content
/// Returns a new array with `item` assigned to index `index`. 
/// Returns `Error(IndexOutOfRange)` if the index is negative,
/// or if it exceeds the size of a fixed-size array.
pub fn set(
  into array: ErlangArray(t),
  at index: Int,
  put item: t,
) -> Result(ErlangArray(t), ArrayError) {
  use <- bool.guard(index <= 0, Error(IndexOutOfRange))
  use <- bool.guard(
    is_fixed_size(array) && index >= get_size(array),
    Error(IndexOutOfRange),
  )
  Ok(array_bindings.set(index, item, array))
}

/// Returns a new array where the value at index `index` has been set to the array's default.  
/// Returns `Error(IndexOutOfRange)` if the index is negative, or if it exceeds the 
/// size of a fixed-size array.
pub fn drop(
  from array: ErlangArray(t),
  at index: Int,
) -> Result(ErlangArray(t), ArrayError) {
  use <- bool.guard(index <= 0, Error(IndexOutOfRange))
  use <- bool.guard(
    is_fixed_size(array) && index >= get_size(array),
    Error(IndexOutOfRange),
  )
  Ok(array_bindings.reset(index, array))
}

// higher-order array functions

/// Returns a new array that applies `function` to each array element, including default elements
/// within the current size of the array.
pub fn map(
  over array: ErlangArray(a),
  with function: fn(Int, a) -> b,
) -> ErlangArray(b) {
  array_bindings.map(function, array)
}

pub fn sparse_map(
  over array: ErlangArray(a),
  with function: fn(Int, a) -> b,
) -> ErlangArray(b) {
  array_bindings.sparse_map(function, array)
}

pub fn fold(
  over array: ErlangArray(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.foldl(function, initial, array)
}

pub fn fold_right(
  over array: ErlangArray(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.foldr(function, initial, array)
}

pub fn sparse_fold(
  over array: ErlangArray(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.sparse_foldl(function, initial, array)
}

pub fn sparse_fold_right(
  over array: ErlangArray(a),
  from initial: b,
  with function: fn(Int, a, b) -> b,
) -> b {
  array_bindings.sparse_foldr(function, initial, array)
}

// get array info
pub fn get(from array: ErlangArray(t), at index: Int) -> Result(t, ArrayError) {
  use <- bool.guard(index <= 0, Error(IndexOutOfRange))
  use <- bool.guard(
    is_fixed_size(array) && index >= get_size(array),
    Error(IndexOutOfRange),
  )
  Ok(array_bindings.get(index, array))
}

pub fn get_size(array: ErlangArray(t)) -> Int {
  array_bindings.size(array)
}

pub fn get_count(array: ErlangArray(t)) -> Int {
  sparse_fold(array, 0, fn(_, _, acc) { acc + 1 })
}

pub fn get_default(array: ErlangArray(t)) -> t {
  array_bindings.default(array)
}

pub fn is_fixed_size(array: ErlangArray(t)) -> Bool {
  array_bindings.is_fix(array)
}

// change the array's properties
pub fn make_fixed(array: ErlangArray(t)) -> ErlangArray(t) {
  array_bindings.fix(array)
}

pub fn make_extensible(array: ErlangArray(t)) -> ErlangArray(t) {
  array_bindings.relax(array)
}

pub fn resize_to_fit(array: ErlangArray(t)) -> ErlangArray(t) {
  array_bindings.resize(array)
}

pub fn set_size(
  array: ErlangArray(t),
  size: Int,
) -> Result(ErlangArray(t), ArrayError) {
  use <- bool.guard(size < 0, Error(BadSize))
  Ok(array_bindings.resize_to(size, array))
}
