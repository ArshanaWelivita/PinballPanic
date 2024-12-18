open OUnit2
open Core
open Grid_cell


let simple_activated_bumper_test_one _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = ActivatedBumper {direction = Down; orientation = DownRight; is_active = true}};
  grid.(2).(2) <- {position = (2, 2); cell_type = Tunnel {direction = Right; orientation = Horizontal}};

  let answer = (1, 0) in 

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3 Core.Set.Poly.empty) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst answer) (snd answer); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let series =
  "Activated bumper tests" >::: [ 
    "simple test one" >:: simple_activated_bumper_test_one
   ]