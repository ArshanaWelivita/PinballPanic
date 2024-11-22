open OUnit2
open Core
open Grid_cell


let tunnel_test_passthrough _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = Tunnel {direction = Tunnel.Down; orientation = Tunnel.Vertical}};

  let answer = (4, 2) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let tunnel_test_bounce_off _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = Tunnel {direction = Tunnel.Down; orientation = Tunnel.Horizontal}};

  let answer = (0, 2) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let series =
  "Tunnel tests" >::: [ 
    "Pass through tunnel test" >:: tunnel_test_passthrough;
    "Bounce off tunnel test" >:: tunnel_test_bounce_off
  ]