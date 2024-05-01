# gary

A Gleam interface to Erlang's `array` module, for sparse, efficiently-implemented functional arrays. 🐝

[![Package Version](https://img.shields.io/hexpm/v/gary)](https://hex.pm/packages/gary)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gary/)

## When should I use `gary`?  When are other data types better?

Erlang arrays are $O(\log n)$ for both lookups and updates.  If you don't remember big-O notation, for the purposes of this explanation that essentially means "faster than $O(n)$ (linear time), but slower than $O(1)$ (constant time)".

Tuples are $O(1)$ for lookups, but $O(n)$ for updates -- you can lookup a tuple by its index without iterating over the tuple, but the entire tuple has to be copied to a new location in memory to update one of its values.  Tuples are faster when you're doing repeated random lookups on an unchanging set of values, but lose out to arrays when random updates are required.  

[`glearray`](https://hex.pm/packages/glearray)'s version of arrays are represented as a single tuple, so if you're solely doing lookups and don't need the sparse representation or dynamically resizeable arrays, `glearray` will likely be faster than `gary` .

Lists are $O(n)$ for both lookups and updates anywhere but the head of the list, since you need to iterate over the pairs of the linked list to find an arbitrary index within it.  Lists will be faster that arrays if you can ensure that you only ever operate at the head of the list, like in most traditional recursive algorithms.

## Example

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
