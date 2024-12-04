import gleam/dict.{type Dict}

pub opaque type BiMap(left, right) {
  BiMap(left_to_right: Dict(left, right), right_to_left: Dict(right, left))
}

pub fn new() -> BiMap(left, right) {
  BiMap(dict.new(), dict.new())
}
