import gleam/dict.{type Dict}
import gleam/list

pub opaque type BiMap(left, right) {
  BiMap(left_to_right: Dict(left, right), right_to_left: Dict(right, left))
}

// Foundation Functions

/// Creates an empty map.
/// 
pub fn new() -> BiMap(left, right) {
  BiMap(dict.new(), dict.new())
}

/// Returns the number of entries in the map. Runs in O(1) time.
/// 
pub fn size(of map: BiMap(left, right)) -> Int {
  dict.size(map.left_to_right)
}

// Modifying maps

/// Returns the right value associated with this left value, if it exists.
/// 
pub fn get_by_left(
  from map: BiMap(left, right),
  get key: left,
) -> Result(right, Nil) {
  dict.get(map.left_to_right, key)
}

/// Returns the left value associated with this right value, if it exists.
/// 
pub fn get_by_right(
  from map: BiMap(left, right),
  get key: right,
) -> Result(left, Nil) {
  dict.get(map.right_to_left, key)
}

/// Creates a new map from the given map, with all the same entries except for
/// the one with the given left value, if it exists.
/// 
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

/// Creates a new map from the given map, with all the same entries except for
/// the one with the given left value, if it exists.
/// 
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

/// Creates a new map from the given map, with all the same entries with an extra
/// entry containing the left and right values provided.
/// 
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

// Conversion Functions

/// Creates a map from a list of tuples containing a left and right value.
pub fn from_list(list: List(#(left, right))) -> BiMap(left, right) {
  use map, #(left, right) <- list.fold(list, new())
  insert(map, left, right)
}

/// Converts a map into a list of tuples containing the right and left values
/// of each entry.
/// 
/// The order of the resulting list is not guaranteed.
/// 
pub fn to_list(map: BiMap(left, right)) -> List(#(left, right)) {
  dict.to_list(map.left_to_right)
}

/// Creates a map from a given dict, mapping the values of the dict
/// to the keys as well
pub fn from_dict(dict: Dict(left, right)) -> BiMap(left, right) {
  let right_to_left =
    dict.fold(dict, dict.new(), fn(ltr, left, right) {
      dict.insert(ltr, right, left)
    })
  BiMap(left_to_right: dict, right_to_left:)
}

/// Creates a dict mapping the left values of the given map to te right values.
/// 
pub fn left_to_right(map: BiMap(left, right)) -> Dict(left, right) {
  map.left_to_right
}

/// Creates a dict mapping the right values of the given map to te left values.
/// 
pub fn right_to_left(map: BiMap(left, right)) -> Dict(right, left) {
  map.right_to_left
}

// Working with left and right sides

/// Returns whether the map contains an entry with the given left value.
/// 
pub fn has_left(map: BiMap(left, right), key: left) -> Bool {
  dict.has_key(map.left_to_right, key)
}

/// Returns whether the map contains an entry with the given right value.
/// 
pub fn has_right(map: BiMap(left, right), key: right) -> Bool {
  dict.has_key(map.right_to_left, key)
}

/// Returns a list containing the left values of the given map.
/// 
/// The order of the resulting list is not guaranteed.
/// 
pub fn left_values(map: BiMap(left, right)) -> List(left) {
  dict.keys(map.left_to_right)
}

/// Returns a list containing the right values of the given map.
/// 
/// The order of the resulting list is not guaranteed.
/// 
pub fn right_values(map: BiMap(left, right)) -> List(right) {
  dict.keys(map.right_to_left)
}

// Iterating functions

/// Iterates over the given map, folding the left and right values into a single value.
/// 
pub fn fold(
  over map: BiMap(left, right),
  from initial: acc,
  with callback: fn(acc, left, right) -> acc,
) -> acc {
  dict.fold(map.left_to_right, initial, callback)
}

/// Runs a function for each left-right pair in the map, discarding the result.
pub fn each(
  in map: BiMap(left, right),
  run callback: fn(left, right) -> a,
) -> Nil {
  dict.each(map.left_to_right, callback)
}

/// Creates a new map from the given map, including only left-right pairs for which
/// the given function returns true.
/// 
pub fn filter(
  in map: BiMap(left, right),
  keeping predicate: fn(left, right) -> Bool,
) -> BiMap(left, right) {
  use map, left, right <- fold(map, new())
  case predicate(left, right) {
    True -> insert(map, left, right)
    False -> map
  }
}
