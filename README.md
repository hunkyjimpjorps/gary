# gary

A Gleam interface to Erlang's `array` module, for sparse, efficiently-implemented functional arrays. 🐝

[![Package Version](https://img.shields.io/hexpm/v/gary)](https://hex.pm/packages/gary)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gary/)

```sh
gleam add gary
```

```gleam
import gary/array

pub fn main() {
  list.range(1, 10)
      |> array.from_list(default: -99)
      |> array.drop(at: 5)
      |> result.map(array.map(_, fn(_, v) { 2 * v }))
      |> result.map(array.to_list)
  // = Ok([2, 4, 6, 8, 10, -198, 14, 16, 18, 20])
}
```

Further documentation can be found at <https://hexdocs.pm/gary>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
