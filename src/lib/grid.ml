open Core 
open Bumper

type pos = int * int

let level_bounce_settings = [
  (1, (3, 1, 1));
  (2, (4, 1, 2));
  (3, (4, 2, 3));
  (4, (4, 3, 4));
  (5, (5, 4, 5));
  (6, (5, 5, 6));
  (7, (6, 6, 8));
  (8, (7, 7, 9));
  (9, (7, 8, 10));
  (10, (8, 9, 12)) 
]

let compare_pos (p1 : pos) (p2 : pos) : bool =
  let (x1, y1) = p1 in
  let (x2, y2) = p2 in
  x1 = x2 && y1 = y2

let compare_orientation (o1: orientation) (o2: orientation) : bool = 
  String.compare (Bumper.orientation_to_string o1) (Bumper.orientation_to_string o2) = 0

let get_level_settings (level: int) : int * int * int =
  List.Assoc.find_exn level_bounce_settings ~equal:Int.equal level

let get_grid_size (level: int) : int = 
  let grid_size, _, _ = get_level_settings level in
  grid_size
  
let out_of_bounds_check (row, col : pos) (grid_size: int) : bool = 
  if row < 1 || col < 1 || row >= grid_size || col >= grid_size then true else false 

let move (row, col : pos) (direction: direction) : pos =
  match direction with
  | Up -> (row - 1, col)
  | Down -> (row + 1, col)
  | Left -> (row, col - 1)
  | Right -> (row, col + 1)

(* let rec trace_ball (pos: pos) (direction: direction) (grid: int array array) (grid_size: int) : pos =
  if out_of_bounds_check pos grid_size then pos  (* Ball exits the grid here *)
  else
    let (row, col) = pos in
    match grid.(row).(col) with
    | 1 ->  (* Ball hits a bumper *)
      let orientation = random_orientation () in
      let direction_map = generate_directions orientation in
      let next_direction = Map.find_exn direction_map direction in
      trace_ball (move pos next_direction) next_direction grid grid_size
    | _ ->  (* Ball moves in the current direction *)
      trace_ball (move pos direction) direction grid grid_size

  

let rec place_bumpers (row: int) (col: int) (bumpers_left: int) (grid_size: int) (grid: int array array) : bool =
  if bumpers_left = 0 then true
  else
    let valid_positions = [(row + 1, col); (row - 1, col); (row, col + 1); (row, col - 1)]
                        |> List.filter ~f:(fun (r, c) -> r >= 1 && r <= grid_size && c >= 1 && c <= grid_size && grid.(r).(c) = 0) in
    let shuffled_positions = List.permute valid_positions in
    List.exists shuffled_positions ~f:(fun (new_row, new_col) ->
      grid.(new_row).(new_col) <- 1;
      let placed = place_bumpers new_row new_col (bumpers_left - 1) grid_size grid in
      if placed then true
      else (
        grid.(new_row).(new_col) <- 0;
        false
      )) *)

(* let check_answer (correct_pos : pos) (answer : string) : bool =
  match String.split ~on:',' answer with
  | [row_str; col_str] -> 
    let row = Int.of_string row_str in
    let col = Int.of_string col_str in
    (row, col) = correct_pos
  | _ -> false *)
(* 
let rec generate_grid (level: int) : int array array * pos * pos * direction =
  let (grid_size, min_bounces, max_bounces) = get_level_settings level in
  let grid = Array.make_matrix ~dimx:(grid_size + 2) ~dimy:(grid_size + 2) 0 in

  let bumper_count = Random.int_incl min_bounces max_bounces in
  let start_row = Random.int_incl 1 grid_size in
  let start_col = Random.int_incl 1 grid_size in
  grid.(start_row).(start_col) <- 1; 

  let is_viable = place_bumpers start_row start_col (bumper_count - 1) grid_size grid in

  if is_viable then
    let possible_entries = [
      ((0, Random.int_incl 1 grid_size), Down);               (* Entry from the top *)
      ((grid_size + 1, Random.int_incl 1 grid_size), Up);     (* Entry from the bottom *)
      ((Random.int_incl 1 grid_size, 0), Right);              (* Entry from the left *)
      ((Random.int_incl 1 grid_size, grid_size + 1), Left);   (* Entry from the right *)
    ] in

    let (entry_pos, initial_direction) = List.random_element_exn possible_entries in
    
    let exit_pos = trace_ball entry_pos initial_direction grid grid_size in
    (grid, entry_pos, exit_pos, initial_direction)
  else
    generate_grid level
 *)

 (* let update_direction (direction: direction) (orientation: orientation) : direction =
  let direction_map = generate_directions orientation in
  Map.find_exn direction_map direction *)

let place_initial_bumper (grid: int array array) (entry_pos: pos) (direction: direction) (grid_size: int) : pos * orientation =
  let (entry_row, entry_col) = entry_pos in
  let bumper_pos, orientation =
    match direction with
    | Left -> let col = Random.int_incl 0 (grid_size - 1) in
              let pos = (entry_row - 1, col) in
              grid.(entry_row - 1).(col) <- -1;  (* Place bumper with value 1 *)
              (pos, UpRight)
    | Right -> let col = Random.int_incl 0 (grid_size - 1) in
               let pos = (entry_row - 1, col) in
               grid.(entry_row - 1).(col) <- 1;  (* Place bumper with value 1 *)
               (pos, DownRight)
    | Up -> let row = Random.int_incl 0 (grid_size - 1) in
            let pos = (row, entry_col - 1) in
            grid.(row).(entry_col - 1) <- -1;  (* Place bumper with value -1 *)
            (pos, UpRight)  (* Assign UpRight orientation *)
    | Down -> let row = Random.int_incl 0 (grid_size - 1) in
              let pos = (row, entry_col - 1) in
              grid.(row).(entry_col - 1) <- -1;  (* Place bumper with value -1 *)
              (pos, DownRight)  (* Assign UpRight orientation *)
  in
  (bumper_pos, orientation)  (* Return the bumper position and orientation *)

 (* let rec simulate_ball_path (grid: int array array) (pos: pos) (direction: direction) (bumpers_left: int) (grid_size: int) (orientation: orientation) : pos =
  if out_of_bounds_check pos grid_size || bumpers_left <= 0 then
    pos  (* Ball has exited the grid or no bumpers left to place *)
  else
    (* Determine the next direction based on the current bumper's orientation *)
    let direction_map = generate_directions orientation in
    let new_direction = Map.find_exn direction_map direction in

    (* Move to the next position based on the updated direction *)
    let next_pos = move pos new_direction in

    (* Choose a position for the bumper in the same row or column as next_pos based on new_direction *)
    let (bumper_row, bumper_col) =
      match new_direction with
      | Left | Right ->  (* Place the bumper in the same row *)
          (fst next_pos, Random.int_incl 0 (grid_size - 1))
      | Up | Down ->  (* Place the bumper in the same column *)
          (Random.int_incl 0 (grid_size - 1), snd next_pos)
    in

    (* Place the bumper at the calculated position if it’s within bounds and unoccupied *)
    if not (out_of_bounds_check (bumper_row, bumper_col) grid_size) && grid.(bumper_row).(bumper_col) = 0 then
      grid.(bumper_row).(bumper_col) <- if compare_orientation orientation DownRight then 1 else -1;

    (* Alternate orientation for the next bumper *)
    let next_orientation = if bumpers_left mod 2 = 0 then DownRight else UpRight in

    (* Continue the path simulation *)
    simulate_ball_path grid next_pos new_direction (bumpers_left - 1) grid_size next_orientation *)

let orientation_for_direction (direction: direction) : orientation =
  match direction with
  | Up | Right -> UpRight
  | Down | Left -> DownRight

(* Recursively simulate the ball's path and place bumpers *)
let rec simulate_ball_path (grid: int array array) (pos: pos) (direction: direction) (bumpers_left: int) (grid_size: int) (orientation: orientation) (visited: (pos * direction) Set.Poly.t) (bounce_limit: int) : pos =
  if out_of_bounds_check pos grid_size || bumpers_left <= 0 then
    pos  (* Ball has exited the grid or stopped due to limits *)
  else if Set.mem visited (pos, direction) then
    (0, 0)  (* Ball revisited a position and direction, break the cycle *)
  else
    let visited = Set.add visited (pos, direction) in

    (* Determine the next direction based on the current bumper's orientation *)
    let direction_map = generate_directions orientation in
    let new_direction = Map.find_exn direction_map direction in
    let next_pos = move pos new_direction in

    (* Choose a position for the bumper in the same row or column as next_pos based on new_direction *)
    let (bumper_row, bumper_col) =
      match new_direction with
      | Left | Right ->  (* Place the bumper in the same row *)
          (fst next_pos, Random.int_incl 0 (grid_size - 1))
      | Up | Down ->  (* Place the bumper in the same column *)
          (Random.int_incl 0 (grid_size - 1), snd next_pos)
    in

    (* Place the bumper at the calculated position if it’s within bounds and unoccupied *)
    if not (out_of_bounds_check (bumper_row, bumper_col) grid_size) && grid.(bumper_row).(bumper_col) = 0 then
      grid.(bumper_row).(bumper_col) <- if compare_orientation orientation DownRight then 1 else -1;

    (* Alternate orientation for the next bumper *)
    let next_orientation = orientation_for_direction new_direction in 

    (* Continue the path simulation *)
    simulate_ball_path grid next_pos new_direction (bumpers_left - 1) grid_size next_orientation visited (bounce_limit - 1)

let rec generate_grid level =
  let (grid_size, min_bounces, max_bounces) = get_level_settings level in
  let grid = Array.make_matrix ~dimx:(grid_size + 2) ~dimy:(grid_size + 2) 0 in

  let bumper_count = Random.int_incl min_bounces max_bounces in

  (* Choose a random entry point and initial direction *)
  let possible_entries = [
    ((0, Random.int_incl 1 grid_size), Down);               (* Entry from the top *)
    ((grid_size + 1, Random.int_incl 1 grid_size), Up);     (* Entry from the bottom *)
    ((Random.int_incl 1 grid_size, 0), Right);              (* Entry from the left *)
    ((Random.int_incl 1 grid_size, grid_size + 1), Left);   (* Entry from the right *)
  ] in
  let (entry_pos, initial_direction) = List.random_element_exn possible_entries in
  let (first_bumper_pos, first_orientation) = place_initial_bumper grid entry_pos initial_direction grid_size in

  let bounce_limit = 10 in
  let visited = Set.Poly.empty in

  (* Run the simulation to place bumpers along the ball's path *)
  let exit_pos = simulate_ball_path grid first_bumper_pos initial_direction (bumper_count - 1) grid_size first_orientation visited bounce_limit in
  
  if compare_pos exit_pos (0, 0) then generate_grid level 
  else
    (* Count the bumpers placed on the grid *)
    let bumpers_placed = Array.fold grid ~init:0 ~f:(fun acc row ->
      acc + Array.count row ~f:((=) 1)) in

    (* Check if the number of bumpers placed meets the minimum requirement *)
    if bumpers_placed = bumper_count then
      (grid, entry_pos, exit_pos, initial_direction)  (* Return the viable grid *)
    else
      generate_grid level

