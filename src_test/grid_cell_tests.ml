open OUnit2
open Grid_cell

(* Test: to_string function *)
let test_to_string _ =
  let entry_cell = { position = (0, 0); cell_type = Entry { direction = Down } } in
  let exit_cell = { position = (1, 1); cell_type = Exit { direction = Up } } in
  let empty_cell = { position = (2, 2); cell_type = Empty } in
  let bumper_cell = { position = (3, 3); cell_type = Bumper { orientation = DownRight; direction = Down } } in
  let tunnel_cell = { position = (4, 4); cell_type = Tunnel { orientation = Vertical; direction = Down } } in
  let teleporter_cell = { position = (5, 5); cell_type = Teleporter { orientation = None; direction = Left } } in

  let teleporter_marker = { position = (0, 1); cell_type = TeleporterLevelMarker } in
  let bumper_marker = { position = (3, 2); cell_type = BumperLevelMarker } in
  let tunnel_marker = { position = (4, 3); cell_type = TunnelLevelMarker } in

  assert_equal (to_string entry_cell) "Entry";
  assert_equal (to_string exit_cell) "Exit";
  assert_equal (to_string empty_cell) "Empty";
  assert_equal (to_string bumper_cell) "Bumper";
  assert_equal (to_string tunnel_cell) "Tunnel";
  assert_equal (to_string teleporter_cell) "Teleporter";
  assert_equal (to_string teleporter_marker) "TeleporterLevelMarker";
  assert_equal (to_string bumper_marker) "BumperLevelMarker";
  assert_equal (to_string tunnel_marker) "TunnelLevelMarker"

(* Test: get_bumper_orientation_string function *)
let test_get_bumper_orientation_string _ =
  let bumper_down_right = Bumper { orientation = DownRight; direction = Down } in
  let bumper_up_right = Bumper { orientation = UpRight; direction = Up } in
  let invalid_bumper = Empty in

  assert_equal (get_bumper_orientation_string bumper_down_right) "⟍";
  assert_equal (get_bumper_orientation_string bumper_up_right) "⟋";
  assert_raises (Failure "Error: bumper can only have orientation DownRight or UpRight.") 
    (fun () -> get_bumper_orientation_string invalid_bumper)

(* Test: get_tunnel_orientation_string function *)
let test_get_tunnel_orientation_string _ =
  let tunnel_vertical = Tunnel { orientation = Vertical; direction = Down } in
  let tunnel_horizontal = Tunnel { orientation = Horizontal; direction = Left } in
  let invalid_tunnel = Empty in

  assert_equal (get_tunnel_orientation_string tunnel_vertical) "𝄁";
  assert_equal (get_tunnel_orientation_string tunnel_horizontal) "=";
  assert_raises (Failure "Error: bumper can only have orientation DownRight or UpRight.") 
    (fun () -> get_tunnel_orientation_string invalid_tunnel)

(* Test: compare_grid_cell_type function *)
let test_compare_grid_cell_type _ =
  let cell1 = { position = (0, 0); cell_type = Bumper { orientation = DownRight; direction = Down } } in
  let cell2 = { position = (1, 1); cell_type = Bumper { orientation = DownRight; direction = Down } } in
  let cell3 = { position = (2, 2); cell_type = Tunnel { orientation = Vertical; direction = Left } } in
  let cell4 = { position = (1, 2); cell_type = Tunnel { orientation = Vertical; direction = Left } } in
  let cell5 = { position = (1, 3); cell_type = Entry { direction = Left } } in
  let cell6 = { position = (1, 4); cell_type = Entry { direction = Left } } in
  let empty_cell = { position = (3, 3); cell_type = Empty } in

  assert_equal (compare_grid_cell_type cell1 cell2.cell_type) true;
  assert_equal (compare_grid_cell_type cell1 cell3.cell_type) false;
  assert_equal (compare_grid_cell_type cell4 cell3.cell_type) true;
  assert_equal (compare_grid_cell_type cell1 empty_cell.cell_type) false;
  assert_equal (compare_grid_cell_type empty_cell empty_cell.cell_type) true;
  assert_equal (compare_grid_cell_type cell5 cell6.cell_type) true

(* Test: orientation_to_string function *)
let test_orientation_to_string _ =
  assert_equal (orientation_to_string DownRight) "DownRight";
  assert_equal (orientation_to_string UpRight) "UpRight";
  assert_equal (orientation_to_string Vertical) "Vertical";
  assert_equal (orientation_to_string Horizontal) "Horizontal";
  assert_equal (orientation_to_string None) "None"

(* Test: is_teleporter_marker function *)
let test_is_teleporter_marker _ =
  let teleporter_marker = TeleporterLevelMarker in
  let normal_marker = Empty in
  assert_equal (is_teleporter_marker teleporter_marker) true;
  assert_equal (is_teleporter_marker normal_marker) false

(* Test: orientation error cases *)
(* let test_orientation_error_cases _ =
  assert_raises (orientation_to_bumper_orientation UpDown);
  assert_raises (orientation_to_tunnel_orientation UpDown);
  assert_raises (orientation_to_activated_bumper_orientation UpDown) *)

let series =
  "Grid Cell Tests" >::: [
    "test_to_string" >:: test_to_string;
    "test_get_bumper_orientation_string" >:: test_get_bumper_orientation_string;
    "test_get_tunnel_orientation_string" >:: test_get_tunnel_orientation_string;
    "test_compare_grid_cell_type" >:: test_compare_grid_cell_type;
    "test_orientation_to_string" >:: test_orientation_to_string;
    "test_is_teleporter_marker" >:: test_is_teleporter_marker;
    (* "test_orientation_error_cases" >:: test_orientation_error_cases; *)
  ]
