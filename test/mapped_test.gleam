import gleam/dict
import gleam/list
import gleam/pair
import gleeunit
import mapped

pub fn main() {
  gleeunit.main()
}

pub fn new_test() {
  assert mapped.size(mapped.new()) == 0

  assert mapped.to_list(mapped.new()) == []
}

fn n_size_map(n) {
  list.range(1, n)
  |> list.map(fn(n) { #(n, n) })
  |> mapped.from_list
}

pub fn size_test() {
  assert mapped.size(mapped.new()) == 0

  assert mapped.size(n_size_map(10)) == 10
}

pub fn get_by_left_test() {
  let assert Ok(value) =
    mapped.new()
    |> mapped.insert("Hello", "world")
    |> mapped.get_by_left("Hello")
  assert value == "world"

  let assert Error(_) =
    mapped.new()
    |> mapped.insert("Goodbye", "world")
    |> mapped.get_by_left("Hello")
}

pub fn get_by_right_test() {
  let assert Ok(value) =
    mapped.new()
    |> mapped.insert("one", 1)
    |> mapped.get_by_right(1)
  assert value == "one"

  let assert Error(_) =
    mapped.new()
    |> mapped.insert(1, "two")
    |> mapped.get_by_right("four")
}

pub fn insert_test() {
  assert mapped.new()
    |> mapped.insert("wibble", 1)
    |> mapped.insert("wobble", 2)
    |> mapped.insert("wubble", 3)
    == mapped.from_list([#("wibble", 1), #("wobble", 2), #("wubble", 3)])

  assert mapped.new()
    |> mapped.insert("wibble", 1)
    |> mapped.insert("wobble", 2)
    |> mapped.insert("wubble", 2)
    == mapped.from_list([#("wibble", 1), #("wubble", 2)])
}

pub fn delete_by_left_test() {
  assert mapped.delete_by_left(
      mapped.from_list([#("wibble", 1), #("wobble", 2), #("wubble", 3)]),
      "wobble",
    )
    == mapped.from_list([#("wibble", 1), #("wubble", 3)])
}

pub fn delete_by_right_test() {
  assert mapped.delete_by_right(
      mapped.from_list([#("wibble", 1), #("wobble", 2), #("wubble", 3)]),
      3,
    )
    == mapped.from_list([#("wibble", 1), #("wobble", 2)])
}

pub fn from_list_test() {
  let list = [#(1, 2), #(2, 3), #(3, 4)]
  assert list
    |> mapped.from_list
    |> mapped.size
    == 3

  assert mapped.from_list(list) == mapped.from_list(list)

  assert mapped.from_list([#(1, 2), #(3, 2)]) == mapped.from_list([#(3, 2)])
}

pub fn from_dict_test() {
  let list = [#("one", 1), #("two", 2), #("three", 3)]
  assert list
    |> dict.from_list
    |> mapped.from_dict
    |> mapped.size
    == 3

  assert list
    |> dict.from_list
    |> mapped.from_dict
    |> mapped.left_to_right
    == dict.from_list(list)

  assert list
    |> dict.from_list
    |> mapped.from_dict
    |> mapped.right_to_left
    == dict.from_list(list.map(list, pair.swap))
}

pub fn has_left_test() {
  assert mapped.has_left(
    mapped.from_list([#("wibble", 1), #("wobble", 4)]),
    "wibble",
  )
  assert !mapped.has_left(
    mapped.from_list([#("wibble", 1), #("wobble", 4)]),
    "wubble",
  )
}

pub fn has_right_test() {
  assert mapped.has_right(mapped.from_list([#("wibble", 1), #("wobble", 4)]), 4)
  assert !mapped.has_right(
    mapped.from_list([#("wibble", 1), #("wobble", 4)]),
    3,
  )
}

pub fn fold_test() {
  assert mapped.fold(
      mapped.from_list([#(1, 2), #(3, 4), #(5, 6)]),
      0,
      fn(sum, a, b) { sum + a * b },
    )
    == 44
}

pub fn filter_test() {
  assert mapped.filter(
      mapped.from_list([#(1, 5), #(3, 4), #(8, 6), #(9, 2)]),
      fn(a, b) { a % 2 == 1 && b % 2 == 0 },
    )
    == mapped.from_list([#(3, 4), #(9, 2)])
}

pub fn inspect_test() {
  assert mapped.inspect(mapped.from_list([#(1, 2), #(3, 4), #(5, 6)]))
    == "{ 1 <> 2, 3 <> 4, 5 <> 6 }"
}
