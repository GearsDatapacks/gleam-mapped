import gleam/list
import gleeunit
import gleeunit/should
import mapped

pub fn main() {
  gleeunit.main()
}

pub fn new_test() {
  mapped.new()
  |> mapped.size
  |> should.equal(0)

  mapped.new()
  |> mapped.to_list
  |> should.equal([])
}

fn n_size_map(n) {
  list.range(1, n)
  |> list.map(fn(n) { #(n, n) })
  |> mapped.from_list
}

pub fn size_test() {
  mapped.new()
  |> mapped.size
  |> should.equal(0)

  n_size_map(10)
  |> mapped.size
  |> should.equal(10)
}

pub fn from_list_test() {
  let list = [#(1, 2), #(2, 3), #(3, 4)]
  list
  |> mapped.from_list
  |> mapped.size
  |> should.equal(3)

  list
  |> mapped.from_list
  |> should.equal(mapped.from_list(list))
}
