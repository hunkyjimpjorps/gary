import gleam/erlang/atom
import gleam/io
import internal/array_bindings

pub fn main() {
  array_bindings.new([
    #(array_bindings.Size, 100),
    #(array_bindings.Default, -99),
  ])
  |> array_bindings.set(55, 1, _)
  |> io.debug()
}
