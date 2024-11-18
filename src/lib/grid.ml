open Core 
open Grid_cell

type grid = grid_cell array array 
type pos = int * int

let level_bounce_settings = [
  (1, (3, 1, 1, [BumperLevelMarker]));
  (2, (4, 1, 2, [BumperLevelMarker]));
  (3, (4, 2, 3, [BumperLevelMarker; TunnelLevelMarker]));
  (4, (4, 3, 4, [BumperLevelMarker; TunnelLevelMarker]));
  (5, (5, 4, 5, [BumperLevelMarker; Teleporter]));
  (6, (5, 5, 6, [BumperLevelMarker; Teleporter]));
  (7, (6, 6, 8, [BumperLevelMarker; ActivatedBumperLevelMarker]));
  (8, (7, 7, 9, [BumperLevelMarker; TunnelLevelMarker; ActivatedBumperLevelMarker]));
  (9, (7, 8, 10, [BumperLevelMarker; Teleporter; ActivatedBumperLevelMarker]));
  (10, (8, 9, 12, [BumperLevelMarker; Teleporter; TunnelLevelMarker; ActivatedBumperLevelMarker]))
]

let get_level_settings (level: int) : int * int * int * (grid_cell_type list) =
  List.Assoc.find_exn level_bounce_settings ~equal:Int.equal level

let get_grid_size (level: int) : int = 
  let grid_size, _, _ , _ = get_level_settings level in 
  grid_size

let out_of_bounds_check (row, col : pos) (grid_size: int) : bool = 
  if row < 0 || col < 0 || row > grid_size + 1 || col > grid_size + 1 then true else false 

let is_within_actual_grid (row: int) (col: int) (grid_size: int) : bool =
  if row >= 1 && row <= grid_size && col >= 1 && col <= grid_size then true else false

let get_cell  (grid: grid) (row: int) (col: int) : grid_cell = 
  grid.(row).(col)

let move (row, col : pos) (direction: direction) : pos =
  match direction with
  | Up -> (row - 1, col)
  | Down -> (row + 1, col)
  | Left -> (row, col - 1)
  | Right -> (row, col + 1) 

let compare_pos (p1 : pos) (p2 : pos) : bool =
  let (x1, y1) = p1 in
  let (x2, y2) = p2 in
  x1 = x2 && y1 = y2

let compare_orientation (o1: orientation) (o2: orientation) : bool = 
  String.compare (orientation_to_string o1) (orientation_to_string o2) = 0


let is_activated_bumper_active (ball_pos: pos) (bumper_pos: pos) : bool = 
  false (* will implement this later when doing the activated bumper feature in week 3 of implementation *)
  
let string_of_orientation (orientation : orientation) : string =
  match orientation with
  | UpRight -> "UpRight"
  | DownRight -> "DownRight"

let string_of_direction (dir: direction) : string = 
  match dir with 
    |Up -> "Up"
    |Down -> "Down"
    |Left -> "Left"
    |Right -> "Right"

let place_initial_grid_object (grid: int array array) (entry_pos: pos) (direction: direction) (grid_size: int) (grid_cell_type : grid_cell_type) : pos * orientation =
  let (entry_row, entry_col) = entry_pos in
  let grid_cell_object_pos, orientation =
    match direction with
    | Left -> let col = Random.int_incl 1 grid_size in
              let pos = (entry_row, col) in
              let grid_cell of {position: pos; cell_type: grid_cell_type} in
              grid.(entry_row).(col) <- grid_cell;  
              (pos, UpRight)
    | Right -> let col = Random.int_incl 1 grid_size in
                let pos = (entry_row, col) in
                grid.(entry_row).(col) <- cell_type;  
                (pos, DownRight)
    | Up -> let row = Random.int_incl 1 grid_size in
            let pos = (row, entry_col) in
            grid.(row).(entry_col) <- cell_type;  
            (pos, UpRight)  
    | Down -> let row = Random.int_incl 1 grid_size in
              let pos = (row, entry_col) in
              grid.(row).(entry_col) <- cell_type;  
              (pos, DownRight)  
  in
  (grid_cell_object_pos, orientation) 

(* 

let orientation_for_direction (direction: direction) : orientation =
  match direction with
  | Up | Right -> UpRight (*  ╱ is upright *)
  | Down | Left -> DownRight (*  ╲ is downright*)

let rec collect_positions_along_path (grid: int array array) (start_pos: pos) (direction: direction) (grid_size: int) : pos list =
  let (row, col) = start_pos in
  if not (is_within_actual_grid row col grid_size) then 
    []
  else if grid.(row).(col) = 0 then
    (* Add current position if unoccupied and continue along the path *)
    start_pos :: collect_positions_along_path grid (move start_pos direction) direction grid_size
  else
    []  (* Stop if the cell has a bumper *)
  
let place_random_bumper_along_path (grid: int array array) (start_pos: pos) (direction: direction) (grid_size: int) (orientation: orientation) : unit =
  let potential_positions = collect_positions_along_path grid start_pos direction grid_size in
  match List.random_element potential_positions with
  | Some (row, col) ->
      grid.(row).(col) <- if compare_orientation orientation DownRight then 1 else -1
  | None -> ()  (* No valid position found, do nothing *)

        
let rec simulate_ball_path (grid: int array array) (pos: pos) (direction: direction) 
      (bumpers_left: int) (grid_size: int) (orientation: orientation) 
      (visited: (pos * direction) Set.Poly.t) (bounce_limit: int) : pos =
  (* Print the current position of the ball *)
  (* printf "Ball position: %d %d | Direction: %s | Bumpers left: %d | Bounce limit: %d\n"
  (fst pos) (snd pos) (string_of_direction direction) bumpers_left bounce_limit; *)

  (* Check if the ball is out of bounds *)
  if out_of_bounds_check pos grid_size then
    begin
    (* printf "Out of bounds at position %d %d, returning.\n" (fst pos) (snd pos); *)
    pos  (* Ball has exited the grid *)
    end
  else if bumpers_left = -1 then  
    pos  (* Stopping if bumpers are exhausted *)
  else if Set.mem visited (pos, direction) then
    begin
    (* printf "Loop detected at position %d %d, stopping.\n" (fst pos) (snd pos); *)
    (-1, -1)  (* Stop if a loop is detected *)
    end
  else
    begin
    let visited = Set.add visited (pos, direction) in

    (* Check if the current cell contains a bumper *)
    let (row, col) = pos in
    if grid.(row).(col) = 1 || grid.(row).(col) = -1 then
      begin
      (* Bounce off the bumper *)
      printf "Bumper encountered at %d %d, orientation: %s\n" row col (string_of_orientation orientation);

      (* Determine new direction based on orientation *)
      let direction_map = generate_directions orientation in
      let new_direction = Map.find_exn direction_map direction in
      (* printf "New direction after bounce: %s\n" (string_of_direction new_direction); *)

      let next_pos = move pos new_direction in

      (* Check if bumpers_left is 0: Follow the path without placing new bumpers *)
      if bumpers_left = 0 then
        begin
        (* printf "No bumpers left; following path until exit.\n"; *)
        if out_of_bounds_check next_pos grid_size then
          begin
          (* printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
          printf "end pos: %d %d" (fst pos) (snd pos); *)
          pos
          end
        else
        (* Continue path simulation in the new direction without placing a new bumper *)
        simulate_ball_path grid next_pos new_direction 0 grid_size orientation visited bounce_limit
        end
      else
      (* Place a bumper if bumpers_left > 0 *)
        begin
        (* Place a bumper randomly along the new direction *)
        (* printf "Placing bumper along path from position %d %d\n" (fst next_pos) (snd next_pos); *)
        (* Set the new orientation for the next bumper placement *)
        let next_orientation = orientation_for_direction new_direction in
        place_random_bumper_along_path grid next_pos new_direction grid_size next_orientation;

        (* printf "Next bumper orientation: %s\n" (string_of_orientation next_orientation); *)

        (* Continue path simulation in the new direction with one less bumper *)
        simulate_ball_path grid next_pos new_direction (bumpers_left - 1) grid_size next_orientation visited (bounce_limit - 1)
        end
      end
      else
      begin
      (* Move in the current direction if no bumper is encountered *)
      let next_pos = move pos direction in
      if out_of_bounds_check next_pos grid_size then
        begin
        (* printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos); *)
        pos
        end
      else
        begin
          (* printf "No bumper encountered, continuing straight from position %d %d\n" row col; *)
          simulate_ball_path grid next_pos direction bumpers_left grid_size orientation visited bounce_limit
        end
      end
  end

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
  grid.(fst entry_pos).(snd entry_pos) <- 3;

  let (_, first_orientation) = place_initial_bumper grid entry_pos initial_direction grid_size in

  let bounce_limit = 10 in
  let visited = Set.Poly.empty in

  (* Run the simulation to place bumpers along the ball's path *)
  let exit_pos = simulate_ball_path grid entry_pos initial_direction (bumper_count - 1) grid_size first_orientation visited bounce_limit in
  grid.(fst exit_pos).(snd exit_pos) <- 2;
  if compare_pos exit_pos (-1, -1) then generate_grid level 
  else 
    (* Count the bumpers placed on the grid *)
    let bumpers_placed = Array.fold grid ~init:0 ~f:(fun acc row ->
      acc + Array.count row ~f:(fun x -> x = 1 || x = -1)) in

    (* Check if the number of bumpers placed meets the minimum requirement *)
    if bumpers_placed = bumper_count then
      (grid, entry_pos, exit_pos, initial_direction)  (* Return the viable grid *)
    else
      generate_grid level
 *)
