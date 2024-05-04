import gleam/dict.{has_key}
import gleam/io
import gleam/string
import stack

pub fn main() {
  let delimiters = build_delimiter_map()
  let tokens = lexer("[adawdas(]")
  let s = stack.Stack([])

  io.debug(is_balanced(delimiters, tokens, s))
}

fn build_delimiter_map() -> dict.Dict(String, String) {
  dict.new()
  |> dict.insert("(", ")")
  |> dict.insert("[", "]")
  |> dict.insert("{", "}")
}

fn is_balanced(
  delimiters: dict.Dict(String, String),
  tokens: List(String),
  s: stack.Stack(String),
) -> Bool {
  case tokens {
    [] -> stack.stack_len(s) == 0
    [h, ..t] ->
      case dict.has_key(delimiters, h) {
        True -> is_balanced(delimiters, t, stack.push(s, h))
        False -> is_balanced(delimiters, t, s)
      }
  }
}

fn lexer(s: String) -> List(String) {
  string.to_graphemes(s)
}
