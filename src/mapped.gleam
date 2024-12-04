import gleam/dict.{type Dict}
import gleam/list

pub opaque type BiMap(left, right) {
  BiMap(left_to_right: Dict(left, right), right_to_left: Dict(right, left))
}

pub fn new() -> BiMap(left, right) {
  BiMap(dict.new(), dict.new())
}

pub fn size(of map: BiMap(left, right)) -> Int {
  dict.size(map.left_to_right)
}

pub fn get_by_left(
  from map: BiMap(left, right),
  get key: left,
) -> Result(right, Nil) {
  dict.get(map.left_to_right, key)
}

pub fn get_by_right(
  from map: BiMap(left, right),
  get key: right,
) -> Result(left, Nil) {
  dict.get(map.right_to_left, key)
}

pub fn insert(
  map: BiMap(left, right),
  left: left,
  right: right,
) -> BiMap(left, right) {
  let map = map |> delete_by_left(left) |> delete_by_right(right)

  BiMap(
    left_to_right: dict.insert(map.left_to_right, left, right),
    right_to_left: dict.insert(map.right_to_left, right, left),
  )
}

pub fn from_list(list: List(#(left, right))) -> BiMap(left, right) {
  use map, #(left, right) <- list.fold(list, new())
  insert(map, left, right)
}

pub fn to_list(map: BiMap(left, right)) -> List(#(left, right)) {
  dict.to_list(map.left_to_right)
}

pub fn delete_by_left(
  from map: BiMap(left, right),
  remove key: left,
) -> BiMap(left, right) {
  case dict.get(map.left_to_right, key) {
    Ok(right_key) -> {
      BiMap(
        left_to_right: dict.delete(map.left_to_right, key),
        right_to_left: dict.delete(map.right_to_left, right_key),
      )
    }
    Error(_) -> map
  }
}

pub fn delete_by_right(
  from map: BiMap(left, right),
  remove key: right,
) -> BiMap(left, right) {
  case dict.get(map.right_to_left, key) {
    Ok(left_key) -> {
      BiMap(
        left_to_right: dict.delete(map.left_to_right, left_key),
        right_to_left: dict.delete(map.right_to_left, key),
      )
    }
    Error(_) -> map
  }
}
// FUNCTIONS TO IMPLEMENT
// contains_*
// *_values
// combine
// drop
// each
// filter
// fold
// is_empty
// map_*_values
// merge
// take
// upsert
