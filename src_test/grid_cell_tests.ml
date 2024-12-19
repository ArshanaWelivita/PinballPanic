open OUnit2
open Grid_cell

(* Test: to_string function *)
let test_to_string _ =
  let entry_cell = { position = (0, 0); cell_type = Entry { direction = Down } } in
  let exit_cell = { position = (1, 1); cell_type = Exit { direction = Up } } in
  let empty_cell = { position = (2, 2); cell_type = Empty } in
  let in_ball_path_cell = { position = (2, 3); cell_type = InBallPath } in
  let bumper_cell = { position = (3, 3); cell_type = Bumper { orientation = DownRight; direction = Down } } in
  let directional_bumper_cell = { position = (3, 3); cell_type = DirectionalBumper { orientation = DownRight; direction = Down } } in
  let activated_bumper_cell = { position = (8, 3); cell_type = ActivatedBumper { orientation = DownRight; direction = Down; is_active = false; revisit = 0 } } in
  let tunnel_cell = { position = (4, 4); cell_type = Tunnel { orientation = Vertical; direction = Down } } in
  let teleporter_cell = { position = (5, 5); cell_type = Teleporter { orientation = None; direction = Left } } in

  let teleporter_marker = { position = (0, 1); cell_type = TeleporterLevelMarker } in
  let bumper_marker = { position = (3, 2); cell_type = BumperLevelMarker } in
  let activated_bumper_marker = { position = (3, 6); cell_type = ActivatedBumperLevelMarker } in
  let directional_bumper_marker = { position = (3, 7); cell_type = DirectionalBumperLevelMarker } in
  let tunnel_marker = { position = (4, 3); cell_type = TunnelLevelMarker } in

  assert_equal (to_string entry_cell) "Entry";
  assert_equal (to_string exit_cell) "Exit";
  assert_equal (to_string in_ball_path_cell) "InBallPath";
  assert_equal (to_string empty_cell) "Empty";
  assert_equal (to_string bumper_cell) "Bumper";
  assert_equal (to_string directional_bumper_cell) "DirectionalBumper";
  assert_equal (to_string activated_bumper_cell) "ActivatedBumper";
  assert_equal (to_string tunnel_cell) "Tunnel";
  assert_equal (to_string teleporter_cell) "Teleporter";
  assert_equal (to_string teleporter_marker) "TeleporterLevelMarker";
  assert_equal (to_string bumper_marker) "BumperLevelMarker";
  assert_equal (to_string activated_bumper_marker) "ActivatedBumperLevelMarker";
  assert_equal (to_string directional_bumper_marker) "DirectionalBumperLevelMarker";
  assert_equal (to_string tunnel_marker) "TunnelLevelMarker";

  assert_bool "Should return true" (is_activated_bumper_marker activated_bumper_marker.cell_type)

(* Test: get_bumper_orientation_string function *)
let test_get_bumper_orientation_string _ =
  let bumper_down_right = Bumper { orientation = DownRight; direction = Down } in
  let bumper_up_right = Bumper { orientation = UpRight; direction = Up } in
  let invalid_bumper = Empty in

  assert_equal (get_bumper_orientation_string bumper_down_right) "⟍";
  assert_equal (get_bumper_orientation_string bumper_up_right) "⟋";
  assert_raises (Failure "Error: bumper can only have orientation DownRight or UpRight.") 
    (fun () -> get_bumper_orientation_string invalid_bumper)

(* Test: get_activated_bumper_orientation_string function *)
let test_get_activated_bumper_orientation_string _ =
  let bumper_down_right = ActivatedBumper { orientation = DownRight; direction = Down; is_active = true; revisit = 2 } in
  let bumper_up_right = ActivatedBumper { orientation = UpRight; direction = Up; is_active = false; revisit = 1 } in
  let invalid_bumper = Empty in

  assert_equal (get_activated_bumper_orientation_string bumper_down_right) "⧅";
  assert_equal (get_activated_bumper_orientation_string bumper_up_right) "⧄";
  assert_raises (Failure "Error: activated bumper can only have orientation DownRight or UpRight.") 
    (fun () -> get_activated_bumper_orientation_string invalid_bumper)

(* Test: get_directional_bumper_orientation_string function *)
let test_get_directional_bumper_orientation_string _ =
  let bumper_down_right = DirectionalBumper { orientation = DownRight; direction = Down } in
  let bumper_up_right = DirectionalBumper { orientation = UpRight; direction = Up } in
  let invalid_bumper = Empty in

  assert_equal (get_directional_bumper_orientation_string bumper_down_right) "◹";
  assert_equal (get_directional_bumper_orientation_string bumper_up_right) "◸";
  assert_raises (Failure "Error: directional bumper can only have orientation DownRight or UpRight.") 
    (fun () -> get_directional_bumper_orientation_string invalid_bumper)


(* Test: get_tunnel_orientation_string function *)
let test_get_tunnel_orientation_string _ =
  let tunnel_vertical = Tunnel { orientation = Vertical; direction = Down } in
  let tunnel_horizontal = Tunnel { orientation = Horizontal; direction = Left } in
  let invalid_tunnel = Empty in

  assert_equal (get_tunnel_orientation_string tunnel_vertical) "𝄁";
  assert_equal (get_tunnel_orientation_string tunnel_horizontal) "=";
  assert_raises (Failure "Error: tunnel can only have orientation DownRight or UpRight.") 
    (fun () -> get_tunnel_orientation_string invalid_tunnel)

(* Test: compare_grid_cell_type function *)
let test_compare_grid_cell_type _ =
  let cell1 = { position = (0, 0); cell_type = Bumper { orientation = DownRight; direction = Down } } in
  let cell2 = { position = (1, 1); cell_type = Bumper { orientation = DownRight; direction = Down } } in
  let cell3 = { position = (2, 2); cell_type = Tunnel { orientation = Vertical; direction = Left } } in
  let cell4 = { position = (1, 2); cell_type = Tunnel { orientation = Vertical; direction = Left } } in
  let cell5 = { position = (1, 3); cell_type = Entry { direction = Left } } in
  let cell6 = { position = (1, 4); cell_type = Entry { direction = Left } } in
  let cell7 = { position = (5, 4); cell_type = Exit { direction = Down } } in
  let cell8 = { position = (6, 4); cell_type = Exit { direction = Down } } in
  let cell9 = { position = (2, 4); cell_type = ActivatedBumper { direction = Down; orientation = DownRight; is_active = true; revisit = 1 } } in
  let cell10 = { position = (0, 6); cell_type = ActivatedBumper { direction = Down; orientation = DownRight; is_active = true; revisit = 1 } } in
  let cell11 = { position = (2, 2); cell_type = Teleporter { orientation = Vertical; direction = Up } } in
  let cell12 = { position = (1, 2); cell_type = Teleporter { orientation = Vertical; direction = Left } } in
  let empty_cell = { position = (3, 3); cell_type = Empty } in

  assert_equal (compare_grid_cell_type cell1 cell2.cell_type) true;
  assert_equal (compare_grid_cell_type cell1 cell3.cell_type) false;
  assert_equal (compare_grid_cell_type cell4 cell3.cell_type) true;
  assert_equal (compare_grid_cell_type cell1 empty_cell.cell_type) false;
  assert_equal (compare_grid_cell_type empty_cell empty_cell.cell_type) true;
  assert_equal (compare_grid_cell_type cell5 cell6.cell_type) true;
  assert_equal (compare_grid_cell_type cell7 cell8.cell_type) true;
  assert_equal (compare_grid_cell_type cell9 cell10.cell_type) true;
  assert_equal (compare_grid_cell_type cell11 cell12.cell_type) true

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
let test_orientation_error_cases _ =
  let invalid_orientation = Obj.magic "UpDown" in

  assert_raises
    (Failure "Wrong orientation for the bumper grid object type.")
    (fun () -> orientation_to_bumper_orientation invalid_orientation);

  assert_raises
    (Failure "Wrong orientation for the tunnel grid object type.")
    (fun () -> orientation_to_tunnel_orientation invalid_orientation);

  assert_raises
    (Failure "Wrong orientation for the activated bumper grid object type.")
    (fun () -> orientation_to_activated_bumper_orientation invalid_orientation);
  
  assert_raises
    (Failure "Wrong orientation for the directional bumper grid object type.")
    (fun () -> orientation_to_directional_bumper_orientation invalid_orientation)

let series =
  "Grid Cell Tests" >::: [
    "test_to_string" >:: test_to_string;
    "test_get_bumper_orientation_string" >:: test_get_bumper_orientation_string;
    "test_get_activated_bumper_orientation_string" >:: test_get_activated_bumper_orientation_string;
    "test_get_directional_bumper_orientation_string" >:: test_get_directional_bumper_orientation_string;
    "test_get_tunnel_orientation_string" >:: test_get_tunnel_orientation_string;
    "test_compare_grid_cell_type" >:: test_compare_grid_cell_type;
    "test_orientation_to_string" >:: test_orientation_to_string;
    "test_is_teleporter_marker" >:: test_is_teleporter_marker;
    "test_orientation_error_cases" >:: test_orientation_error_cases;
  ]
