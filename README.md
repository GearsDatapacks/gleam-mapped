# Mapped

[![Package Version](https://img.shields.io/hexpm/v/mapped)](https://hex.pm/packages/mapped)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/mapped/)

An implementation of a Bidirectional Map (BiMap) in pure Gleam.

```sh
gleam add mapped@1
```
```gleam
import mapped

pub fn main() {
  let numbers_to_words = mapped.from_list([
    #(1, "one")
    #(2, "two")
    #(3, "three")
    #(4, "four")
    #(5, "five")
  ])
  
  let assert Ok(word) = mapped.get_by_left(4) // -> "four"
  let assert Ok(number) = mapped.get_by_right("three") // -> 3
}
```

Further documentation can be found at <https://hexdocs.pm/mapped>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
