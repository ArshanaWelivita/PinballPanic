open OUnit2
(* open Core *)


let random_grid_test_level_one _ =
  let (grid, entry_pos, exit_pos, initial_direction) = Grid.generate_grid 1 in
  let (computed_exit_pos, _) = Grid.simulate_ball_path_post_generation grid entry_pos initial_direction (Grid.get_grid_size 1) Core.Set.Poly.empty in

  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst computed_exit_pos) (snd computed_exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos computed_exit_pos) true

let random_grid_test_level_four _ =
  let (grid, entry_pos, exit_pos, initial_direction) = Grid.generate_grid 4 in
  let (computed_exit_pos, _) = Grid.simulate_ball_path_post_generation grid entry_pos initial_direction (Grid.get_grid_size 4) Core.Set.Poly.empty in
  
  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst computed_exit_pos) (snd computed_exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos computed_exit_pos) true

(* let random_grid_test_level_seven _ =
  let (grid, entry_pos, exit_pos, initial_direction) = Grid.generate_grid 7 in
  let (computed_exit_pos, _) = Grid.simulate_ball_path_post_generation grid entry_pos initial_direction (Grid.get_grid_size 7) Core.Set.Poly.empty in
    
  printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst computed_exit_pos) (snd computed_exit_pos);
  assert_equal (Grid.compare_pos exit_pos computed_exit_pos) true *)

let series =
  "Grid Tests" >::: [
    "random_level_one_test" >:: random_grid_test_level_one;
    "random_level_four_test" >:: random_grid_test_level_four
    (* "random_level_seven_test" >:: random_grid_test_level_seven *)
  ]