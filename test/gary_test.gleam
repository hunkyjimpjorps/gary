import gary/array
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// round trip from a list
pub fn list_to_array_to_list_test() {
  let list = list.range(1, 10)
  should.equal(
    list,
    list
      |> array.from_list(default: 0)
      |> array.to_list(),
  )
}

// comparing dict to manual insertion
pub fn dict_to_array_vs_set_test() {
  let dict =
    [#(1, Some(1)), #(3, Some(3))]
    |> dict.from_list

  should.equal(
    array.create(default: None)
      |> array.set(at: 1, put: Some(1))
      |> result.map(array.set(_, at: 3, put: Some(3))),
    dict
      |> array.from_dict(None)
      |> Ok(),
  )
}

// catch trying to access a negative index
pub fn set_negative_index_test() {
  should.be_error(
    array.create_fixed_size(size: 10, default: None)
    |> result.try(array.set(_, at: -1, put: Some(1))),
  )
}

// catch trying to access an index past the limit of a fixed size array
pub fn set_too_high_index_test() {
  should.be_error(
    array.create_fixed_size(size: 10, default: None)
    |> result.try(array.set(_, 11, Some(1))),
  )
}

// a fixed-size array is not structurally equal to a relaxed array
pub fn fixed_array_is_not_relaxed_array_test() {
  should.not_equal(
    Ok(array.create(default: None)),
    array.create_fixed_size(size: 1, default: None),
  )
}

// a fixed-sized array that's been shrunk to fit and relaxed is equal to a relaxed array
pub fn relaxed_minimized_empty_array_is_empty_array_test() {
  should.equal(
    Ok(array.create(default: None)),
    array.create_fixed_size(size: 1, default: None)
      |> result.map(array.resize_to_fit)
      |> result.map(array.make_extensible),
  )
}

// size of a sparse relaxed array is 1 plus the index of the highest non-default entry
pub fn size_test() {
  should.equal(
    array.create(default: None)
      |> array.set(at: 10, put: Some(1))
      |> result.map(array.get_size),
    Ok(11),
  )
}

// size of a sparse fixed array is its defined size 
pub fn fixed_size_test() {
  should.equal(
    array.create_fixed_size(size: 10, default: None)
      |> result.map(array.get_size),
    Ok(10),
  )
}

// count of a sparse array is the number of non-default entries
pub fn count_test() {
  should.equal(
    array.create(default: None)
      |> array.set(at: 10, put: Some(1))
      |> result.try(array.set(_, at: 20, put: Some(2)))
      |> result.try(array.set(_, at: 30, put: Some(3)))
      |> result.map(array.get_count),
    Ok(3),
  )
}

// higher-order functions 
pub fn map_test() {
  should.equal(
    list.range(1, 10)
      |> array.from_list(default: -99)
      |> array.drop(at: 5)
      |> result.map(array.map(_, fn(_, v) { 2 * v }))
      |> result.map(array.to_list),
    Ok([2, 4, 6, 8, 10, -198, 14, 16, 18, 20]),
  )
}

// sparse_map doesn't transform defaults
pub fn sparse_map_test() {
  should.equal(
    list.range(1, 10)
      |> array.from_list(default: -99)
      |> array.drop(at: 5)
      |> result.map(array.sparse_map(_, fn(_, v) { 2 * v }))
      |> result.map(array.to_list),
    Ok([2, 4, 6, 8, 10, -99, 14, 16, 18, 20]),
  )
}
