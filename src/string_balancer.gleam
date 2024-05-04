import gleam/dict.{type Dict, get, has_key, insert, values}
import gleam/io
import gleam/list.{append, length}
import gleam/string.{to_graphemes}

pub fn main() {
  let delimiters = build_delimiter_map()
  let tokens = to_graphemes("[adawdas)]")
  let stack: List(String) = []
  io.debug(is_balanced(tokens, stack, delimiters))
}

pub fn build_delimiter_map() -> dict.Dict(String, String) {
  dict.new()
  |> insert("(", ")")
  |> insert("[", "]")
  |> insert("{", "}")
}

pub fn is_balanced(
  tokens: List(String),
  stack: List(String),
  delimiters: Dict(String, String),
) -> Bool {
  case tokens {
    [] -> length(stack) == 0
    [h, ..t] ->
      case has_key(delimiters, h) {
        True ->
          append([h], stack)
          |> is_balanced(t, _, delimiters)
        False ->
          case is_within_values(values(delimiters), h) {
            True ->
              case stack {
                [] -> False
                [top, ..rest] ->
                  case get(delimiters, top) {
                    Ok(end_delimiter) ->
                      case end_delimiter == h {
                        True -> is_balanced(t, rest, delimiters)
                        False -> False
                      }
                    Error(_) -> False
                  }
              }
            False -> is_balanced(t, stack, delimiters)
          }
      }
  }
}

fn is_within_values(delimiters: List(String), char: String) -> Bool {
  case delimiters {
    [h, ..] if h == char -> True
    [_, ..t] -> is_within_values(t, char)
    [] -> False
  }
}
