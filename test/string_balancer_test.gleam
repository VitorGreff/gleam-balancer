import gleam/string.{to_graphemes}
import gleeunit
import gleeunit/should
import string_balancer.{is_balanced}

pub fn main() {
  gleeunit.main()
}

pub fn balancer_test() {
  should.equal(is_balanced(to_graphemes("abcd")), True)
  should.equal(is_balanced(to_graphemes("abcd]")), False)
  should.equal(is_balanced(to_graphemes("{abcd")), False)
  should.equal(is_balanced(to_graphemes("$(abc[de]fg{hi}jk)%//")), True)
  should.equal(is_balanced(to_graphemes("{ab(cd}ef)")), False)
}
