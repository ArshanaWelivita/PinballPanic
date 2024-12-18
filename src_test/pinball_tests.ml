open OUnit2

module Pinball_tests =
  struct
  
  let filler_test _ =
    assert_equal true true

  let series =
    "General tests" >::: [
      "Filler test" >:: filler_test;
    ]

end

let series =
  "Pinball tests" >:::
  [ Pinball_tests.series
  ; Bumper_tests.series
  ; Tunnel_tests.series
  ; Teleporter_tests.series
  ; Activated_bumper_tests.series
  ; Directional_bumper_tests.series
  ; Grid_cell_tests.series
  ]

let () = run_test_tt_main series