import gleam/dict.{get, has_key, insert, values}
import gleam/io
import gleam/string.{to_graphemes}
import stack.{peek, pop, push, stack_len}

pub fn main() {
  let delimiters = build_delimiter_map()
  let tokens = to_graphemes("[adawdas")
  let s = stack.Stack([])
  io.debug(is_balanced(delimiters, tokens, s))
}

fn build_delimiter_map() -> dict.Dict(String, String) {
  dict.new()
  |> insert("(", ")")
  |> insert("[", "]")
  |> insert("{", "}")
}

fn is_balanced(
  delimiters: dict.Dict(String, String),
  tokens: List(String),
  s: stack.Stack(String),
) -> Bool {
  case tokens {
    [] -> stack_len(s) == 0
    [h, ..t] -> {
      case has_key(delimiters, h) {
        // begin delimiter
        True -> {
          s
          |> push(h)
          |> is_balanced(delimiters, t, _)
        }
        False -> {
          case is_within_values(values(delimiters), h) {
            // end delimiter
            True -> {
              case pop(s) {
                Error(_) -> False
                Ok(new_stack) -> {
                  case peek(new_stack) {
                    Error(_) -> False
                    Ok(stack_top) -> {
                      case get(delimiters, stack_top) {
                        Ok(end_delimiter) -> {
                          case end_delimiter == h {
                            True -> {
                              is_balanced(delimiters, t, new_stack)
                            }
                            False -> {
                              False
                            }
                          }
                        }
                        Error(_) -> {
                          False
                        }
                      }
                    }
                  }
                }
              }
            }
            False -> {
              is_balanced(delimiters, t, s)
            }
          }
        }
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
