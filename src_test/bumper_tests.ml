open OUnit2

let test _ =
  assert_equal true true

let series =
  "Bumper tests" >::: [ "filler test" >:: test ]