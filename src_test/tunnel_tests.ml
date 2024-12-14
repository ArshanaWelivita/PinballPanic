open OUnit2
open Core
open Grid_cell


let tunnel_test_passthrough _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = Tunnel {direction = Down; orientation = Vertical}};

  let orientation_check =
    match grid.(1).(2).cell_type with
    | Tunnel { orientation; _ } -> Tunnel.tunnel_orientation_to_string (orientation_to_tunnel_orientation orientation)
    | _ -> "NotATunnel"
  in
  assert_equal orientation_check "Vertical" 
    ~msg:"Expected 'Vertical' orientation for the tunnel at (1, 2)";

  let answer = (4, 2) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let tunnel_test_bounce_off _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = Tunnel {direction = Down; orientation = Horizontal}};

  let orientation_check =
    match grid.(1).(2).cell_type with
    | Tunnel { orientation; _ } -> Tunnel.tunnel_orientation_to_string (orientation_to_tunnel_orientation orientation)
    | _ -> "NotATunnel"
  in
  assert_equal orientation_check "Horizontal" 
    ~msg:"Expected 'Horizontal' orientation for the tunnel at (1, 2)";

  let answer = (0, 2) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let tunnel_test_multiple _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = Tunnel {direction = Down; orientation = Vertical}};
  grid.(2).(2) <- {position = (2, 2); cell_type = Bumper {direction = Down; orientation = DownRight}};
  grid.(2).(3) <- {position = (2, 3); cell_type = Tunnel {direction = Up; orientation = Vertical}};

  let answer = (0, 2) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let series =
  "Tunnel tests" >::: [ 
    "Pass through tunnel test" >:: tunnel_test_passthrough;
    "Bounce off tunnel test" >:: tunnel_test_bounce_off;
    "multiple tunnels test" >:: tunnel_test_multiple;
  ]