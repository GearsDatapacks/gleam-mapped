import gleam/dict
import gleam/list
import gleam/pair
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

pub fn get_by_left_test() {
  mapped.new()
  |> mapped.insert("Hello", "world")
  |> mapped.get_by_left("Hello")
  |> should.be_ok
  |> should.equal("world")

  mapped.new()
  |> mapped.insert("Goodbye", "world")
  |> mapped.get_by_left("Hello")
  |> should.be_error
}

pub fn get_by_right_test() {
  mapped.new()
  |> mapped.insert("one", 1)
  |> mapped.get_by_right(1)
  |> should.be_ok
  |> should.equal("one")

  mapped.new()
  |> mapped.insert(1, "two")
  |> mapped.get_by_right("four")
  |> should.be_error
}

pub fn insert_test() {
  mapped.new()
  |> mapped.insert("wibble", 1)
  |> mapped.insert("wobble", 2)
  |> mapped.insert("wubble", 3)
  |> should.equal(
    mapped.from_list([#("wibble", 1), #("wobble", 2), #("wubble", 3)]),
  )

  mapped.new()
  |> mapped.insert("wibble", 1)
  |> mapped.insert("wobble", 2)
  |> mapped.insert("wubble", 2)
  |> should.equal(mapped.from_list([#("wibble", 1), #("wubble", 2)]))
}

pub fn delete_by_left_test() {
  mapped.from_list([#("wibble", 1), #("wobble", 2), #("wubble", 3)])
  |> mapped.delete_by_left("wobble")
  |> should.equal(mapped.from_list([#("wibble", 1), #("wubble", 3)]))
}

pub fn delete_by_right_test() {
  mapped.from_list([#("wibble", 1), #("wobble", 2), #("wubble", 3)])
  |> mapped.delete_by_right(3)
  |> should.equal(mapped.from_list([#("wibble", 1), #("wobble", 2)]))
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

  [#(1, 2), #(3, 2)]
  |> mapped.from_list
  |> should.equal(mapped.from_list([#(3, 2)]))
}

pub fn from_dict_test() {
  let list = [#("one", 1), #("two", 2), #("three", 3)]
  list
  |> dict.from_list
  |> mapped.from_dict
  |> mapped.size
  |> should.equal(3)

  list
  |> dict.from_list
  |> mapped.from_dict
  |> mapped.left_to_right
  |> should.equal(dict.from_list(list))

  list
  |> dict.from_list
  |> mapped.from_dict
  |> mapped.right_to_left
  |> should.equal(dict.from_list(list.map(list, pair.swap)))
}

pub fn has_left_test() {
  mapped.from_list([#("wibble", 1), #("wobble", 4)])
  |> mapped.has_left("wibble")
  |> should.be_true
  mapped.from_list([#("wibble", 1), #("wobble", 4)])
  |> mapped.has_left("wubble")
  |> should.be_false
}

pub fn has_right_test() {
  mapped.from_list([#("wibble", 1), #("wobble", 4)])
  |> mapped.has_right(4)
  |> should.be_true
  mapped.from_list([#("wibble", 1), #("wobble", 4)])
  |> mapped.has_right(3)
  |> should.be_false
}

pub fn fold_test() {
  mapped.from_list([#(1, 2), #(3, 4), #(5, 6)])
  |> mapped.fold(0, fn(sum, a, b) { sum + a * b })
  |> should.equal(44)
}

pub fn filter_test() {
  mapped.from_list([#(1, 5), #(3, 4), #(8, 6), #(9, 2)])
  |> mapped.filter(fn(a, b) { a % 2 == 1 && b % 2 == 0 })
  |> should.equal(mapped.from_list([#(3, 4), #(9, 2)]))
}

pub fn inspect_test() {
  mapped.from_list([#(1, 2), #(3, 4), #(5, 6)])
  |> mapped.inspect
  |> should.equal("{ 1 <> 2, 3 <> 4, 5 <> 6 }")
}
