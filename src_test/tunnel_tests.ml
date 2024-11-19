open Ounit2

let test _ =
  assert_equal true true

let series =
  "Tunnel tests" >::: [ "filler test" >:: test ]