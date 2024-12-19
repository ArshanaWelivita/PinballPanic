open OUnit2
open Core
open Grid_cell


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

let random_grid_test_level_seven _ =
  let (grid, entry_pos, exit_pos, initial_direction) = Grid.generate_grid 7 in
  let (computed_exit_pos, _) = Grid.simulate_ball_path_post_generation grid entry_pos initial_direction (Grid.get_grid_size 7) Core.Set.Poly.empty in
    
  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst computed_exit_pos) (snd computed_exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos computed_exit_pos) true


let display_grid (grid_size: int) (grid: grid_cell array array) : unit =
  print_endline "";
  printf "   ";
  for j = 0 to grid_size + 1 do
    printf "  %d  " j
  done;
  Out_channel.newline stdout;

  for i = 0 to grid_size + 1 do
    printf "%d  " i;
    for j = 0 to Array.length grid.(i) - 1 do
      match Grid_cell.to_string grid.(i).(j) with
      | "Entry" -> printf "  E  "
      | "Exit" -> printf "  -  "
      | "Empty" -> printf "  -  "
      | "InBallPath" -> printf "  -  "
      | "Bumper" -> printf "  %s  " (Grid_cell.get_bumper_orientation_string grid.(i).(j).cell_type)
      | "Tunnel" -> printf "  %s  " (Grid_cell.get_tunnel_orientation_string grid.(i).(j).cell_type)
      | "Teleporter" -> printf "  ★  "
      | "ActivatedBumper" -> printf "  %s  " (Grid_cell.get_activated_bumper_orientation_string grid.(i).(j).cell_type)
      | "DirectionalBumper" -> printf "  %s  " (Grid_cell.get_directional_bumper_orientation_string grid.(i).(j).cell_type)
      | _ -> failwith "Invalid grid cell type."
    done;
    Out_channel.newline stdout
  done
    
let random_grid_test_level_eight _ =
  let (grid, entry_pos, exit_pos, initial_direction) = Grid.generate_grid 9 in
  let (computed_exit_pos, _) = Grid.simulate_ball_path_post_generation grid entry_pos initial_direction (Grid.get_grid_size 7) Core.Set.Poly.empty in
  
  let grid_size = Array.length grid.(1) - 2 in 
  display_grid grid_size grid;

  printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst computed_exit_pos) (snd computed_exit_pos);
  assert_equal (Grid.compare_pos exit_pos computed_exit_pos) true


let random_grid_test_level_sixteen _ =
  let (grid, entry_pos, exit_pos, initial_direction) = Grid.generate_grid 16 in
  let (computed_exit_pos, _) = Grid.simulate_ball_path_post_generation grid entry_pos initial_direction (Grid.get_grid_size 7) Core.Set.Poly.empty in
    
  (* printf "Ball position: %d %d" (fst exit_pos) (snd exit_pos);
  printf "Ball position: %d %d" (fst computed_exit_pos) (snd computed_exit_pos); *)
  assert_equal (Grid.compare_pos exit_pos computed_exit_pos) true

let series =
  "Grid Tests" >::: [
    "random_level_one_test" >:: random_grid_test_level_one;
    "random_level_four_test" >:: random_grid_test_level_four;
    "random_level_seven_test" >:: random_grid_test_level_seven;
    "random_level_eight_test" >:: random_grid_test_level_eight;
    "random_level_sixteen_test" >:: random_grid_test_level_sixteen;
  ]