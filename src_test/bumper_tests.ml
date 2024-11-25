open OUnit2
open Core
open Grid_cell


let simple_bumper_test_one _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(1).(2) <- {position = (1, 2); cell_type = Bumper {direction = Down; orientation = DownRight}};

  let answer = (1, 4) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true
  
let simple_bumper_test_two _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 
      ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(2).(2) <- {position = (2, 2); cell_type = Bumper {direction = Down; orientation = UpRight}};

  let answer = (2, 0) in

  let (exit_pos, _) = (Grid.simulate_ball_path_post_generation grid (0, 2) Down 3) in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos answer) true

let series =
  "Bumper tests" >::: [ 
    "simple test one" >:: simple_bumper_test_one;
    "simple test two" >:: simple_bumper_test_two
   ]