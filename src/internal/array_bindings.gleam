import gleam/dynamic
import gleam/erlang/atom

pub type ErlangArray(t)

pub type ArrayOption {
  Default
  Fixed
  Size
}

// create arrays
@external(erlang, "array", "new")
pub fn new(options: List(#(ArrayOption, t))) -> ErlangArray(t)

@external(erlang, "array", "new")
pub fn new_with_size(
  size: Int,
  options: List(#(ArrayOption, t)),
) -> ErlangArray(t)

@external(erlang, "array", "from_list")
pub fn from_list(list: List(t), default: t) -> ErlangArray(t)

@external(erlang, "array", "from_orddict")
pub fn from_orddict(list: List(#(Int, t)), default: t) -> ErlangArray(t)

// create other types from arrays
@external(erlang, "array", "to_list")
pub fn to_list(array: ErlangArray(t)) -> List(t)

@external(erlang, "array", "to_orddict")
pub fn to_orddict(array: ErlangArray(t)) -> List(#(Int, t))

// modify array content
@external(erlang, "array", "get")
pub fn get(index: Int, array: ErlangArray(t)) -> t

@external(erlang, "array", "set")
pub fn set(index: Int, value: t, array: ErlangArray(t)) -> ErlangArray(t)

@external(erlang, "array", "reset")
pub fn reset(index: Int, array: ErlangArray(t)) -> ErlangArray(t)

// higher-order array functions
@external(erlang, "array", "map")
pub fn map(f: fn(Int, a) -> b, array: ErlangArray(a)) -> ErlangArray(b)

@external(erlang, "array", "sparse_map")
pub fn sparse_map(f: fn(Int, a) -> b, array: ErlangArray(a)) -> ErlangArray(b)

@external(erlang, "array", "foldr")
pub fn foldr(f: fn(Int, a, b) -> b, acc: b, array: ErlangArray(a)) -> b

@external(erlang, "array", "sparse_foldr")
pub fn sparse_foldr(f: fn(Int, a, b) -> b, acc: b, array: ErlangArray(a)) -> b

@external(erlang, "array", "foldl")
pub fn foldl(f: fn(Int, a, b) -> b, acc: b, array: ErlangArray(a)) -> b

@external(erlang, "array", "sparse_foldl")
pub fn sparse_foldl(f: fn(Int, a, b) -> b, acc: b, array: ErlangArray(a)) -> b

// get array info
@external(erlang, "array", "default")
pub fn default(array: ErlangArray(t)) -> t

@external(erlang, "array", "size")
pub fn size(array: ErlangArray(t)) -> Int

@external(erlang, "array", "is_fix")
pub fn is_fix(array: ErlangArray(t)) -> Bool

// change the array's properties
@external(erlang, "array", "fix")
pub fn fix(array: ErlangArray(t)) -> ErlangArray(t)

@external(erlang, "array", "relax")
pub fn relax(array: ErlangArray(t)) -> ErlangArray(t)

@external(erlang, "array", "resize")
pub fn resize(size: Int, array: ErlangArray(t)) -> ErlangArray(t)
