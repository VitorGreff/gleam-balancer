import gleam/list

pub type Stack(a) {
  Stack(elements: List(a))
}

pub fn push(stack: Stack(a), element: a) -> Stack(a) {
  case stack {
    Stack(elements) -> Stack(list.append(elements, [element]))
  }
}

pub fn pop(stack: Stack(a)) -> Result(Stack(a), String) {
  case stack {
    Stack([]) -> Error("Empty Stack")
    Stack([_, ..tail]) -> Ok(Stack(elements: tail))
  }
}

pub fn peek(stack: Stack(a)) -> Result(a, String) {
  case stack {
    Stack([x]) -> Ok(x)
    Stack([]) -> Error("Empty Stack")
    Stack([_, ..t]) -> peek(Stack(t))
  }
}

pub fn stack_len(stack: Stack(a)) -> Int {
  case stack {
    Stack(elements) -> acc_len(elements, 0)
  }
}

fn acc_len(items: List(a), acc: Int) -> Int {
  case items {
    [] -> acc
    [_, ..t] -> acc_len(t, acc + 1)
  }
}
