import gleam/string.{to_graphemes}
import gleeunit
import gleeunit/should
import string_balancer.{build_delimiter_map, is_balanced}

pub fn main() {
  gleeunit.main()
}

pub fn balancer_test() {
  should.equal(
    is_balanced(to_graphemes("abcd"), [], build_delimiter_map()),
    True,
  )
  should.equal(
    is_balanced(to_graphemes("abcd]"), [], build_delimiter_map()),
    False,
  )
  should.equal(
    is_balanced(to_graphemes("{abcd"), [], build_delimiter_map()),
    False,
  )
  should.equal(
    is_balanced(
      to_graphemes("$(abc[de]fg{hi}jk)%//"),
      [],
      build_delimiter_map(),
    ),
    True,
  )
  should.equal(
    is_balanced(to_graphemes("{ab(cd}ef)"), [], build_delimiter_map()),
    False,
  )
}
