import gleam/dict.{type Dict, get, has_key, insert, values}
import gleam/io
import gleam/list.{append, length}
import gleam/string.{to_graphemes}

pub fn main() {
  to_graphemes("adawdas]")
  |> is_balanced()
  |> io.debug
}

pub fn is_balanced(tokens: List(String)) -> Bool {
  compute_string(tokens, [], build_delimiter_map())
}

fn build_delimiter_map() -> dict.Dict(String, String) {
  dict.new()
  |> insert("(", ")")
  |> insert("[", "]")
  |> insert("{", "}")
}

fn compute_string(
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
          |> compute_string(t, _, delimiters)
        False ->
          case is_within_values(values(delimiters), h) {
            True ->
              case stack {
                [] -> False
                [top, ..rest] ->
                  case get(delimiters, top) {
                    Ok(end_delimiter) ->
                      case end_delimiter == h {
                        True -> compute_string(t, rest, delimiters)
                        False -> False
                      }
                    Error(_) -> False
                  }
              }
            False -> compute_string(t, stack, delimiters)
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
