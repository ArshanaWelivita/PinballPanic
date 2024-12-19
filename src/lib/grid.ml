open Core 
open Grid_cell

type grid = grid_cell array array 

type pos = int * int

type level_settings = {
  grid_size: int;
  min_objects: int;
  max_objects: int;
  grid_object_types: grid_cell_type list;
  teleporter_objects: int;
  activated_bumper_objects: int;
  num_extra_objects: int;
}

let level_bounce_settings = [
  (1, { grid_size = 3; min_objects = 1; max_objects = 1; grid_object_types = [BumperLevelMarker]; teleporter_objects = 0; activated_bumper_objects = 0; num_extra_objects = 0 });
  (2, { grid_size = 4; min_objects = 1; max_objects = 2; grid_object_types = [BumperLevelMarker]; teleporter_objects = 0; activated_bumper_objects = 0; num_extra_objects = 0 });
  (3, { grid_size = 4; min_objects = 2; max_objects = 3; grid_object_types = [BumperLevelMarker; TunnelLevelMarker]; teleporter_objects = 0; activated_bumper_objects = 0; num_extra_objects = 0 });
  (4, { grid_size = 4; min_objects = 3; max_objects = 4; grid_object_types = [BumperLevelMarker; TunnelLevelMarker]; teleporter_objects = 0; activated_bumper_objects = 0; num_extra_objects = 0 });
  (5, { grid_size = 5; min_objects = 4; max_objects = 5; grid_object_types = [BumperLevelMarker; TeleporterLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 0; num_extra_objects = 0 });
  (6, { grid_size = 5; min_objects = 5; max_objects = 6; grid_object_types = [BumperLevelMarker; TeleporterLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 0; num_extra_objects = 0 });
  (7, { grid_size = 6; min_objects = 6; max_objects = 8; grid_object_types = [BumperLevelMarker; TunnelLevelMarker; TeleporterLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 0; num_extra_objects = 0 });
  (8, { grid_size = 6; min_objects = 6; max_objects = 8; grid_object_types = [BumperLevelMarker; ActivatedBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 1; num_extra_objects = 0 });
  (9, { grid_size = 7; min_objects = 7; max_objects = 9; grid_object_types = [BumperLevelMarker; TunnelLevelMarker; ActivatedBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 1; num_extra_objects = 1 });
  (10, { grid_size = 7; min_objects = 7; max_objects = 9; grid_object_types = [BumperLevelMarker; DirectionalBumperLevelMarker; ActivatedBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 1; num_extra_objects = 2 });
  (11, { grid_size = 7; min_objects = 7; max_objects = 9; grid_object_types = [BumperLevelMarker; TeleporterLevelMarker; ActivatedBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 1; num_extra_objects = 2 });
  (12, { grid_size = 7; min_objects = 7; max_objects = 9; grid_object_types = [TeleporterLevelMarker; TunnelLevelMarker; ActivatedBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 1; num_extra_objects = 3 });
  (13, { grid_size = 8; min_objects = 7; max_objects = 9; grid_object_types = [TeleporterLevelMarker; TunnelLevelMarker; DirectionalBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 0; num_extra_objects = 3 });
  (14, { grid_size = 8; min_objects = 8; max_objects = 10; grid_object_types = [BumperLevelMarker; TeleporterLevelMarker; ActivatedBumperLevelMarker; DirectionalBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 1; num_extra_objects = 3 });
  (15, { grid_size = 8; min_objects = 9; max_objects = 12; grid_object_types = [BumperLevelMarker; TeleporterLevelMarker; TunnelLevelMarker; ActivatedBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 2; num_extra_objects = 4 });
  (16, { grid_size = 10; min_objects = 10; max_objects = 12; grid_object_types = [BumperLevelMarker; TeleporterLevelMarker; TunnelLevelMarker; ActivatedBumperLevelMarker; DirectionalBumperLevelMarker]; teleporter_objects = 1; activated_bumper_objects = 2; num_extra_objects = 5 });
]

let get_level_settings (level: int) : level_settings =
  List.Assoc.find_exn level_bounce_settings ~equal:Int.equal level

let get_grid_size (level: int) : int = 
  let level_settings = get_level_settings level in 
  level_settings.grid_size

let out_of_bounds_check (row, col : pos) (grid_size: int) : bool = 
  if row < 0 || col < 0 || row > grid_size + 1 || col > grid_size + 1 then true else false 

let is_within_actual_grid (row: int) (col: int) (grid_size: int) : bool =
  if row >= 1 && row <= grid_size && col >= 1 && col <= grid_size then true else false

let get_cell (grid: grid) (row: int) (col: int) : grid_cell = 
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

let string_of_orientation (orientation : orientation) : string =
  match orientation with
  | UpRight -> "UpRight"
  | DownRight -> "DownRight"
  | Vertical -> "Vertical"
  | Horizontal -> "Horizontal"
  | None -> "None"

let string_of_direction (dir: direction) : string = 
  match dir with 
    |Up -> "Up"
    |Down -> "Down"
    |Left -> "Left"
    |Right -> "Right"

let random_orientation_for_bumper () : orientation =
  List.random_element_exn [DownRight; UpRight] 

let random_orientation_for_tunnel () : orientation =
  List.random_element_exn [Vertical; Horizontal] 

let get_grid_cell_type (grid_object_marker: grid_cell_type) (initial_direction: direction) : grid_cell_type = 
  match grid_object_marker with
  | TunnelLevelMarker -> (* Make a tunnel grid object *)
      let initial_orientation = random_orientation_for_tunnel () in 
      Tunnel { orientation = initial_orientation; direction = (initial_direction) }
  | BumperLevelMarker -> (* Make a bumper grid object *)
      let initial_orientation = random_orientation_for_bumper () in 
      Bumper { orientation = initial_orientation; direction = (initial_direction) }
  | ActivatedBumperLevelMarker -> (* Make an activated bumper grid object *)
      let initial_orientation = random_orientation_for_bumper () in 
      ActivatedBumper { orientation = initial_orientation; direction = (initial_direction); is_active = false; revisit = 0 }
  | TeleporterLevelMarker -> (* Make a teleporter grid object *)
      Teleporter {orientation = None; direction = initial_direction}
  | DirectionalBumperLevelMarker -> (* Make a directional bumper grid object *)
    let initial_orientation = random_orientation_for_bumper () in 
    DirectionalBumper { orientation = initial_orientation; direction = (initial_direction) }
  | _ -> failwith "Wrong grid object placed. Need to regenerate grid." (* There is no other grid object type so that interacts with the ball so need to regenerate grid. *)

let get_potential_second_teleporter_positions (grid: grid) (grid_size: int) (excluded_row: int) (excluded_col: int) : (int * int) list =
  (* Generates every single position in the grid as a (row, col) list *)
  List.init grid_size ~f:(fun row -> 
    List.init grid_size ~f:(fun col -> (row, col))) 
  |> List.concat  
  (* Filters the position list to get viable positions to place the second teleporter object *)
  |> List.filter ~f:(fun (row, col) -> 
      (row <> excluded_row && col <> excluded_col (* Makes sure it is not in the same row or column as the first teleporter object *)
        && row <> 0 && col <> 0 && row <> grid_size + 1 && col <> grid_size + 1 (* Makes sure it's within the grid *)
        && compare_grid_cell_type grid.(row).(col) Empty)) (* Make sure that the cell type is Empty so it can contain a grid object *)

let place_second_teleporter_in_grid (grid: grid) (first_grid_pos: pos) (grid_size: int) (teleporer_dir: direction) : bool = 
  let potential_positions = get_potential_second_teleporter_positions grid grid_size (fst first_grid_pos) (snd first_grid_pos) in
  (* The grid is filled with grid objects/inaccessible positions and there's no space to place a second teleporter. Returns false as no second teleporter placed in grid *)
  if List.is_empty potential_positions 
  then false 
  else
    (* Chooses a random position from the potential positions and places second teleporter in the position in the grid *)
    let pos = List.nth_exn potential_positions (Random.int (List.length potential_positions)) in 
    grid.(fst pos).(snd pos) <- {position= pos; cell_type= (Teleporter {orientation = None; direction = teleporer_dir})};
    true (* Second teleporter placed in grid so returns true *)

let place_initial_grid_object_helper (grid: grid) (row: int) (col: int) (initial_grid_cell: grid_cell_type) (orientation: orientation) : pos * orientation = 
  let pos = (row, col) in
  let grid_cell = {position = pos; cell_type = initial_grid_cell} in
  grid.(row).(col) <- grid_cell; 
  (pos, orientation)

let generate_and_place_initial_grid_object (grid: grid) (entry_pos: pos) (direction: direction) (grid_size: int) (new_grid_cell_type : grid_cell_type) : pos * orientation =
  let (entry_row, entry_col) = entry_pos in 
  let initial_grid_cell = get_grid_cell_type new_grid_cell_type direction in 
  (* Gets the position and orientation of the initial grid object based on the entry direction of the ball and the grid object type *)
  let grid_cell_object_pos, orientation =
    (* Gets the orientation of the grid object *)
    let orientation = match initial_grid_cell with
      | Bumper { orientation = o; _ } -> o
      | Tunnel { orientation = o; _ } -> o
      | Teleporter { orientation = o; _} -> o
      | ActivatedBumper { orientation = o; _ } -> o 
      | DirectionalBumper {orientation = o; _} -> o
      | _ -> failwith "Unexpected grid cell type" 
    in
    (* Uses the entry direction of ball into the grid to generate the initial grid object position and orientation *)
    match direction with
    | Left -> let col = Random.int_incl 1 grid_size in
              place_initial_grid_object_helper grid entry_row col initial_grid_cell orientation
    | Right -> let col = Random.int_incl 1 grid_size in
              place_initial_grid_object_helper grid entry_row col initial_grid_cell orientation
    | Up -> let row = Random.int_incl 1 grid_size in
            place_initial_grid_object_helper grid row entry_col initial_grid_cell orientation
    | Down -> let row = Random.int_incl 1 grid_size in
            place_initial_grid_object_helper grid row entry_col initial_grid_cell orientation
  in

  (* printf "Initial grid object placed position: %d %d\n" (fst grid_cell_object_pos) (snd grid_cell_object_pos); <- used for de-bugging purposes *)

  (* Checks if the specified grid object is a teleporter and returns the position and orientation of the placed initial grid object *)
  if (compare_grid_cell_type grid.(fst grid_cell_object_pos).(snd grid_cell_object_pos) (Teleporter {orientation = None; direction = direction})) then 
    begin
      (* Places the second teleporter object in the grid and returns the position and orientation of the first teleporter object *)
      if place_second_teleporter_in_grid grid grid_cell_object_pos grid_size direction
      then (grid_cell_object_pos, orientation)
      else failwith "No space in grid to add the second teleporter object"
    end
  (* else if (compare_grid_cell_type grid.(fst grid_cell_object_pos).(snd grid_cell_object_pos) grid.(fst grid_cell_object_pos).(snd grid_cell_object_pos) (ActivatedBumper {orientation; direction; is_active = false})) then
    begin
      grid.(fst grid_cell_object_pos).(snd grid_cell_object_pos) <- {position = grid_cell_object_pos; cell_type = ActivatedBumper {orientation = orientation; direction = direction; is_active = true; revisit = 0}};
      (grid_cell_object_pos, orientation)
    end *)
  else
    (grid_cell_object_pos, orientation) 

  

let rec collect_positions_along_path (grid: grid) (start_pos: pos) (direction: direction) (grid_size: int) : pos list =
  let (row, col) = start_pos in
  (* Out of the bounds of the grid so doesn't append that specific cell position and returns the current list of valid positions *)
  if not (is_within_actual_grid row col grid_size) then 
    [] 
  else 
    (* Checks if the current grid cell in this path can hold a new grid object *)
    let current_grid_cell = get_cell grid row col in
      match current_grid_cell.cell_type with
      | Empty -> start_pos :: collect_positions_along_path grid (move start_pos direction) direction grid_size (* Add current position if empty and continue along the path *)
      | _ -> [] (* Can't place a grid object in that cell since it has another grid object/in the ball path and returns the current list of valid positions upto that point *)

let place_random_grid_element_along_path (grid: grid) (start_pos: pos) (direction: direction) (grid_size: int) (orientation: orientation) 
  (new_grid_cell_type: grid_cell_type) : bool =
  let potential_positions = collect_positions_along_path grid start_pos direction grid_size in
  match potential_positions with 
    |[] -> false (* There aren't any valid positions in the ball's future path so we return false as we didn't place a grid object *)
    | _ -> let new_grid_object_pos = List.random_element_exn potential_positions in 
            match new_grid_object_pos with
              | (row, col) -> 
                (* Create the new grid object cell *)
                let updated_cell = 
                  match new_grid_cell_type with
                  | Bumper _ -> Bumper { orientation = orientation; direction = direction}
                  | Tunnel _ -> Tunnel { orientation = orientation; direction = direction}
                  | ActivatedBumper _ -> ActivatedBumper { orientation = orientation; direction = direction; is_active = false; revisit = 0}
                  | DirectionalBumper _ -> DirectionalBumper { orientation = orientation; direction = direction}
                  | Teleporter _ -> if place_second_teleporter_in_grid grid new_grid_object_pos grid_size direction
                                    then Teleporter {orientation = None; direction = direction;}
                                    else failwith "There is no space in the grid to add the second teleporter object in the pair."
                  | _ -> failwith "Grid cell type is not defined can't be placed in the grid."
                in
                (* Place the grid object in the specified position in the grid *)
                grid.(row).(col) <- {position = (row, col); cell_type = updated_cell}; 
                true (* Successfully placed the grid object in the grid *)

let move_to_second_teleporter_position (grid: grid) (first_teleporter_pos: pos) (dir: direction): pos = 
  (* Helper function to find the teleporter grid object positions within the grid *)
  let rec find_teleporter (grid: grid) (row: int) (col: int) : pos =
    if row >= (Array.length grid - 1) then
      failwith "Second teleporter wasn't placed in the grid." (* End of grid, no second teleporter found *)
    else if col >= (Array.length grid.(row) - 1) then
      find_teleporter grid (row + 1) 0 (* Move to the next row *)
    else if not (compare_pos (row, col) first_teleporter_pos) && (compare_grid_cell_type grid.(row).(col) (Teleporter {orientation = None; direction = dir})) then
      (row, col) (* Found the second teleporter position *)
    else
      find_teleporter grid row (col + 1) (* Continue to the next column in the same row *)
  in
  find_teleporter grid 1 1

let determine_new_ball_direction (current_grid_cell: grid_cell) (direction: direction) (grid: grid) : direction = match current_grid_cell.cell_type with 
  (* Depending on the type of grid object and its orientation, determines the direction that the ball will bounce off in for its future path *)
  | Tunnel { orientation; _ } -> let direction_map = Tunnel.generate_directions (orientation_to_tunnel_orientation orientation) in 
                                  Map.find_exn direction_map (direction_to_tunnel_direction direction)
                                  |> tunnel_direction_to_direction
  | Bumper { orientation; _ } -> let direction_map = Bumper.generate_directions (orientation_to_bumper_orientation orientation) in
                                  Map.find_exn direction_map (direction_to_bumper_direction direction)
                                  |> bumper_direction_to_direction
  | DirectionalBumper { orientation; _ } -> let direction_map = Directional_bumper.generate_directions (orientation_to_directional_bumper_orientation orientation) in
                                  Map.find_exn direction_map (direction_to_directional_bumper_direction direction)
                                  |> directional_bumper_direction_to_direction
  | Teleporter _ -> direction (* no change as direction is preserved *)
  | InBallPath -> direction (* no change as there is no grid object in this cell *)
  | ActivatedBumper { orientation; direction = dir; is_active; revisit } -> 
      if is_active then 
        let direction_map = Activated_bumper.generate_directions (orientation_to_activated_bumper_orientation orientation) in
        let new_direction = Map.find_exn direction_map (direction_to_activated_bumper_direction direction)
          |> activated_bumper_direction_to_direction 
        in  
        (* Replace the bumper in the grid *)
        grid.(fst current_grid_cell.position).(snd current_grid_cell.position) <- { current_grid_cell with cell_type = ActivatedBumper { orientation; direction = dir; is_active; revisit = revisit + 1 }};
        new_direction
      else 
        (* Update the grid to mark the bumper as active *)
        let position = current_grid_cell.position in
        let first_pos, second_pos = fst position, snd position in
        grid.(first_pos).(second_pos) <- { current_grid_cell with cell_type = 
        ActivatedBumper { orientation; direction; is_active = true; revisit = 0}};
        direction
  | Entry _ -> direction (* no change as direction is preserved *) 
  | Exit _ -> direction (* no change as direction is preserved *)                                 
  | _ -> failwith "Grid cell type doesn't have directions."

let randomly_choose_next_grid_object_marker (teleporter_objects: int) (grid_object_types: grid_cell_type list) (activated_bumper_objects: int) : grid_cell_type =
  (* Randomly chooses between all types *)
  if teleporter_objects <> 0 && activated_bumper_objects <> 0 then 
    List.random_element_exn grid_object_types 
  else 
    (* Randomly chooses between all types except teleporters *)
    if activated_bumper_objects <> 0 && teleporter_objects = 0 then
      let filtered_objects = List.filter grid_object_types ~f:(fun obj -> not (is_teleporter_marker obj)) in
      List.random_element_exn filtered_objects
      (* Randomly chooses between all types except activated bumpers *)
    else if activated_bumper_objects = 0 && teleporter_objects <> 0 then
      let filtered_objects = List.filter grid_object_types ~f:(fun obj -> not (is_activated_bumper_marker obj)) in
      List.random_element_exn filtered_objects
    else
      (* Randomly chooses between all types except teleporters and activated bumpers *)
      let filtered_objects = List.filter grid_object_types 
          ~f:(fun obj -> not (is_activated_bumper_marker obj) && not (is_teleporter_marker obj)) in
      List.random_element_exn filtered_objects

let get_grid_object_marker_orientation (next_grid_object_marker: grid_cell_type) : orientation = match next_grid_object_marker with 
  | BumperLevelMarker -> random_orientation_for_bumper () 
  | TunnelLevelMarker -> random_orientation_for_tunnel ()
  | TeleporterLevelMarker -> None
  | ActivatedBumperLevelMarker -> random_orientation_for_bumper () 
  | DirectionalBumperLevelMarker -> random_orientation_for_bumper () 
  | _ -> failwith "Invalid grid object marker"

let generate_next_grid_object (teleporter_objects: int) (grid_object_types: grid_cell_type list) (new_direction: direction) (activated_bumper_objects: int) : grid_cell_type * orientation * grid_cell_type = 
    (* Chooses the next grid object randomly out of the list of potential grid objects for that level *)
    let next_grid_object_marker = randomly_choose_next_grid_object_marker teleporter_objects grid_object_types activated_bumper_objects in 
    (* Randomly sets the orientation for that randomly picked grid object *)
    let next_orientation = get_grid_object_marker_orientation next_grid_object_marker in 
    (* Generates the grid object with all its properties ready to be placed in the grid *)
    let next_grid_cell_type = get_grid_cell_type next_grid_object_marker new_direction in 

    (next_grid_cell_type, next_orientation, next_grid_object_marker)

let rec simulate_ball_path (grid: grid) (pos: pos) (direction: direction) (objects_left: int) (grid_size: int) (orientation: orientation) (bounce_limit: int)
  (visited: (pos * direction) Set.Poly.t) (grid_object_types : grid_cell_type list) (teleporter_objects: int) (activated_bumper_objects: int) : (pos * direction, string) result  =
  (* printf "Ball position: %d %d | Direction: %s | Objects left: %d | Bounce limit: %d\n"
  (fst pos) (snd pos) (string_of_direction direction) objects_left bounce_limit; <- used for debugging by printing current position of the ball*)

  (* Check if the ball is out of bounds *)
  if out_of_bounds_check pos grid_size then
    begin
      (* printf "Out of bounds at position %d %d, returning.\n" (fst pos) (snd pos); <- used for debugging *)
      Ok (pos, direction)  
    end
  (* Check if a loop is detected and returns an invalid grid position *)
  else if Set.mem visited (pos, direction) && not (is_activated_bumper grid.(fst pos).(snd pos)) then
    begin
      (* printf "Loop detected at position %d %d, stopping.\n" (fst pos) (snd pos); <- used for debugging *)
      Error ("Loop detected")
    end
  else
    begin
      let visited = 
        if is_activated_bumper grid.(fst pos).(snd pos) then
          visited  (* Allow revisiting activated bumpers *)
        else
          Set.add visited (pos, direction) (* Adds the position and direction as visited to prevent loops *)
      in

      let (row, col) = pos in
      let current_grid_cell = get_cell grid row col in 

      (* Check if the current cell contains a grid object *)
      if not (compare_grid_cell_type current_grid_cell Empty) && not (compare_grid_cell_type current_grid_cell InBallPath) then
        begin
          (* printf "Grid Object: %s encountered at %d %d, orientation: %s\n" (to_string current_grid_cell) row col (string_of_orientation orientation); (*<- used for debugging*)
           *)
          (* Determine new direction based on orientation of the grid object placed in that grid cell *)
          let new_direction = determine_new_ball_direction current_grid_cell direction grid in 
          (* printf "New direction after bounce: %s\n" (string_of_direction new_direction); <- used for debugging purposes *)
          
          (* Determines ball's next position in the grid based on interaction with the grid object *)
          let next_pos =
            if compare_grid_cell_type current_grid_cell (Teleporter {orientation = None; direction = direction}) then
              move (move_to_second_teleporter_position grid pos new_direction) new_direction
            else
              move pos new_direction  
          in

          (* Check if number of grid objects left is 0. If so, it follows the ball's path without placing new grid objects until it exits the grid *)
          if objects_left = 0 then
            begin
            (* printf "No grid objects left; following path until exit.\n"; <- used for debugging purposes *)
              (* Checks if the ball's next position after interaction with grid object is out of bounds *)
              if out_of_bounds_check next_pos grid_size then
                begin
                  (* printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
                  printf "end pos: %d %d" (fst pos) (snd pos); <- used for debugging purposes *)
                  Ok (pos, direction)
                end
              else
              (* Continues ball's path simulation in the new direction without placing a new grid object *)
              simulate_ball_path grid next_pos new_direction 0 grid_size orientation bounce_limit visited grid_object_types teleporter_objects activated_bumper_objects
            end
          else
          (* Place a new grid object if there are still available grid objects left to be placed *)
            begin
              (* printf "Placing grid object along path from position %d %d\n" (fst next_pos) (snd next_pos); (*<- used for debugging purposes *)  *)
              (* Gets the properties of the next grid object *)
              let next_grid_object, next_orientation, next_grid_object_marker = generate_next_grid_object teleporter_objects grid_object_types new_direction activated_bumper_objects in

              (* Places the grid object in the future path of the ball in the grid *)
              if not (place_random_grid_element_along_path grid next_pos new_direction grid_size next_orientation next_grid_object) 
              then Error ("No viable positions to place grid object") (* There are no viable positions to place this grid object, so returns invalid position so grid can be regenerated for this level *)
              (* Continue ball's path simulation in the new direction with one less grid object as it was successfully placed in the ball's future path *)      
              else if is_teleporter_marker next_grid_object_marker then 
                simulate_ball_path grid next_pos new_direction (objects_left - 1) grid_size next_orientation (bounce_limit - 1) visited grid_object_types (teleporter_objects - 1) activated_bumper_objects
              else if is_activated_bumper_marker next_grid_object_marker then 
                simulate_ball_path grid next_pos new_direction (objects_left - 1) grid_size next_orientation (bounce_limit - 1) visited grid_object_types teleporter_objects (activated_bumper_objects - 1)
              else 
                simulate_ball_path grid next_pos new_direction (objects_left - 1) grid_size next_orientation (bounce_limit - 1) visited grid_object_types teleporter_objects activated_bumper_objects
              (* printf "Next grid object orientation: %s\n" (string_of_orientation next_orientation); <- used for debugging purposes *)
            end
        end
      else 
        begin
          (* Move in the current direction if no grid object is encountered and marks the current position as InBallPath *)
            grid.(fst pos).(snd pos) <- {position = pos; cell_type = InBallPath };
            let next_pos = move pos direction in

            (* Checks if the next position of the ball is out of bounds of the grid *)
            if out_of_bounds_check next_pos grid_size then
              begin
                (* printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos); <- used for debugging purposes  *)
                if compare_grid_cell_type grid.(fst pos).(snd pos) (Teleporter {orientation = None; direction = direction}) then Ok (next_pos, direction) else Ok (pos, direction)
              end
            else
              begin
                (* printf "No grid object encountered, continuing straight from position %d %d\n" row col; <- used for debugging purposes  *)
                (* Continues moving through the grid in the current direction of the ball *)
                simulate_ball_path grid next_pos direction objects_left grid_size orientation bounce_limit visited grid_object_types teleporter_objects activated_bumper_objects
              end
        end
    end

let mark_in_ball_path (grid: grid) (entry_pos: pos) (direction: direction) (first_object_pos: pos) (grid_size: int) : unit =
  (* Helper function to traverse the path of the ball from start position to grid object and mark the cells in the path as InBallPath *)
  let rec traverse (current_pos: pos) (current_direction: direction) : unit =
    (* Stop when we reach the first object or go out of bounds *)
    if compare_pos current_pos first_object_pos || out_of_bounds_check current_pos grid_size then
      ()
    else
      begin
      grid.(fst current_pos).(snd current_pos) <- { (grid.(fst current_pos).(snd current_pos)) with cell_type = InBallPath }; (* Mark the current cell as InBallPath *)
      traverse (move current_pos current_direction) current_direction (* Move to the next position *)
      end
  in
  traverse (move entry_pos direction) direction

let randomly_choose_entry_position (grid_size: int) : pos * direction = 
  (* List of potential entry points and directions *)
  let possible_entries = [
    ((0, Random.int_incl 1 grid_size), Down);               
    ((grid_size + 1, Random.int_incl 1 grid_size), Up);    
    ((Random.int_incl 1 grid_size, 0), Right);              
    ((Random.int_incl 1 grid_size, grid_size + 1), Left);   
  ] in
  List.random_element_exn possible_entries

let get_exit_position_and_direction (grid: grid) (first_grid_object_pos: pos) (initial_direction: direction) (object_count: int) (grid_size: int) 
  (first_orientation: orientation) (bounce_limit: int) (visited: (pos * direction) Set.Poly.t) (grid_object_types : grid_cell_type list) (teleporter_objects: int)
  (activated_bumper_objects: int) : (pos * direction, string) result = 
  (* Makes sure that we only place one teleporter pair in every level of the game and dynamically places grid objects as we randomly generate the ball's path 
  through grid *)
  if compare_grid_cell_type grid.(fst first_grid_object_pos).(snd first_grid_object_pos) (Teleporter {orientation = None; direction = initial_direction})
  then simulate_ball_path grid first_grid_object_pos initial_direction (object_count - 1) grid_size first_orientation bounce_limit visited grid_object_types 0 activated_bumper_objects
  else simulate_ball_path grid first_grid_object_pos initial_direction (object_count - 1) grid_size first_orientation bounce_limit visited grid_object_types teleporter_objects activated_bumper_objects

let count_objects_in_grid (grid: grid) : int = 
  (* Goes through the grid and counts the number of grid objects placed *)
  Array.fold grid ~init:0 ~f:(fun acc row ->
    acc + Array.fold row ~init:0 ~f:(fun acc cell ->
      match cell.cell_type with
      | Bumper _ | Tunnel _ | Teleporter _ | ActivatedBumper _ | DirectionalBumper _ -> acc + 1
      | _ -> acc
    )
  ) 

let get_empty_grid_cell_positions_outside_ball_path (grid : grid) : pos list =
  (* Iterate through the grid and collect empty positions *)
  let size = Array.length grid - 2 in
  Array.foldi grid ~init:[] ~f:(fun i acc row ->
    Array.foldi row ~init:acc ~f:(fun j acc cell ->
      match cell.cell_type with
      | Empty -> 
        if is_within_actual_grid i j size then (i, j) :: acc
        else acc
      | _ -> acc
    )
  )

let place_extra_grid_objects_at_random_positions (grid : grid) (num_extra_objects : int) : grid =
  (* Get all valid empty positions outside the ball path *)
  let empty_positions = get_empty_grid_cell_positions_outside_ball_path grid in

  (* Teleporters should not be in the list of viable additional grid cell types *)
  let object_types = [
    Bumper {direction = Up; orientation = UpRight};
    Bumper {direction = Up; orientation = DownRight};
    Tunnel {direction = Up; orientation = Vertical};
    Tunnel {direction = Up; orientation = Horizontal};
    DirectionalBumper {direction = Up; orientation = UpRight};
    DirectionalBumper {direction = Up; orientation = DownRight}
    ] in

  (* Randomize and take the first num_objects positions *)
  let selected_positions = 
    List.take (List.permute empty_positions) num_extra_objects
  in

  if num_extra_objects > 0 then
    (* Create a new grid with the specified object type at the selected positions *)
    Array.mapi grid ~f:(fun i row ->
      Array.mapi row ~f:(fun j cell ->
        if List.exists selected_positions ~f:(fun (x, y) -> x = i && y = j) then
          { cell with cell_type = List.random_element_exn object_types }
        else
          cell
      )
    )
  else grid

let get_revisit_count_for_active_bumpers (grid : grid) : int list =
  let size = Array.length grid - 2 in

  (* Helper function to find the revisit counts of all active bumpers *)
  let rec find_revisit_counts (i: int) (j: int) (acc: int list) : int list =
    if i >= size then acc 
    else if j >= size then find_revisit_counts (i + 1) 0 acc 
    else
      match grid.(i).(j).cell_type with
      | ActivatedBumper { is_active = true; revisit; _ } -> find_revisit_counts i (j + 1) (revisit :: acc) 
      | _ -> find_revisit_counts i (j + 1) acc 
  in
  find_revisit_counts 0 0 [] 

let rec compare_activated_bumper_level_grid_object_types (object_types: grid_cell_type list) : bool = match object_types with
  |[] -> false
  |fst_type::rest -> match fst_type with 
                      | ActivatedBumperLevelMarker -> true 
                      | _ -> compare_activated_bumper_level_grid_object_types rest


let rec generate_grid (level: int) : grid * pos * pos * direction =
  (* Get the level settings and generate the initial grid where all cells are initialized to Empty *)
  let level_settings = get_level_settings level in
  let grid = Array.init (level_settings.grid_size + 2) ~f:(fun x -> Array.init (level_settings.grid_size + 2) 
                ~f:(fun y -> { position = (x,y); cell_type = Empty })) in

  let object_count = Random.int_incl level_settings.min_objects level_settings.max_objects in

  (* Choose a random entry point and initial direction, and mark the entry position of the ball in the grid *)
  let (entry_pos, initial_direction) = randomly_choose_entry_position level_settings.grid_size in
  grid.(fst entry_pos).(snd entry_pos) <- { position = entry_pos; cell_type = Entry {direction = initial_direction} };

  (* Choose the first grid object randomly from a list of viable grid objects for that level and then place it in the grid *)
  let initial_grid_object_marker = List.random_element_exn level_settings.grid_object_types in 
  let (first_grid_object_pos, first_orientation) = generate_and_place_initial_grid_object grid entry_pos initial_direction level_settings.grid_size initial_grid_object_marker in

  (* Mark all the grid cells in the path from the entry position to the first grid object position as InBallPath *)
  mark_in_ball_path grid entry_pos initial_direction first_grid_object_pos level_settings.grid_size;

  (* Run the ball path simulation to place grid objects along the ball's path and then get its exit position and direction based off the generated ball path *)  
  match get_exit_position_and_direction grid first_grid_object_pos initial_direction object_count level_settings.grid_size 
  first_orientation 10 Set.Poly.empty level_settings.grid_object_types level_settings.teleporter_objects level_settings.activated_bumper_objects with
  
  |Error _ -> generate_grid level (* Handle the error by regenerating the grid for this level *)
  |Ok (exit_pos, exit_direction) ->
    begin 
    grid.(fst exit_pos).(snd exit_pos) <- { position = exit_pos; cell_type = Exit {direction = exit_direction} }; (* Marks the exit position of the ball in the grid *)

    (* Counts the grid objects placed in the grid *)
    let objects_placed = count_objects_in_grid grid in 

    (* Check if the number of grid objects placed meets the minimum requirement. If not, it regenerates the grid for that level *)
    if objects_placed >= object_count then
      let num_extra_objects = level_settings.num_extra_objects in
      let updated_grid = place_extra_grid_objects_at_random_positions grid num_extra_objects in (* Add extra grid objects if needed *)

      if compare_activated_bumper_level_grid_object_types level_settings.grid_object_types then  
        let revisit_counts = get_revisit_count_for_active_bumpers updated_grid in 

        if List.for_all revisit_counts ~f:(fun revisit_count -> revisit_count >= 1)
        then (updated_grid, entry_pos, exit_pos, initial_direction) (* If all active bumpers have been revisited, return the updated grid *)
        else generate_grid level (* If no active bumper has been revisited, regenerate the grid *)
      else 
        (updated_grid, entry_pos, exit_pos, initial_direction) (* Return the viable grid and the ball's properties (entry position, exit position and entry direction) *)
    else
      generate_grid level
    end

let rec simulate_ball_path_post_generation (grid : grid) (pos: pos) (direction: direction) (grid_size : int) (visited_activated_bumpers: (pos Set.Poly.t)) : pos * direction =
  (* Check if the ball is out of bounds *)
  printf "Ball pos: %d %d\n" (fst pos) (snd pos); 
  if out_of_bounds_check pos grid_size then
    begin
      (* printf "Out of bounds at position %d %d, returning.\n" (fst pos) (snd pos); <- used for debugging purposes *)
      (pos, direction)  
    end
  else
      begin
        (* Check if the current cell contains an object and then determines how ball interacts with grid object *)
        let (row, col) = pos in
        let current_grid_cell = grid.(row).(col) in 
        if not (compare_grid_cell_type current_grid_cell Empty) then
          (* Check if object is an inactive version of an activated bumper*)
          match current_grid_cell.cell_type with 
          | ActivatedBumper _ ->
            if Set.mem visited_activated_bumpers current_grid_cell.position then
              begin
                let new_direction = determine_new_ball_direction current_grid_cell direction grid in
                let next_pos = move pos new_direction in
                simulate_ball_path_post_generation grid next_pos new_direction grid_size visited_activated_bumpers
              end
            else
              begin
                let updated_visited_activated_bumpers = Set.add visited_activated_bumpers current_grid_cell.position in
                let next_pos = move pos direction in
                simulate_ball_path_post_generation grid next_pos direction grid_size updated_visited_activated_bumpers
              end
          | _ -> 
            begin
              (* Determine new direction based on interaction with grid object *)
              let new_direction = determine_new_ball_direction current_grid_cell direction grid in 
              (* printf "New direction after grid object interaction: %s\n" (string_of_direction new_direction); <- used for debugging purposes *)
    
              let next_pos =
                if compare_grid_cell_type current_grid_cell (Teleporter {orientation = None; direction = direction}) then
                  move (move_to_second_teleporter_position grid pos new_direction) new_direction
                else
                  move pos new_direction
              in
    
              begin

                  if out_of_bounds_check next_pos grid_size then
                    begin
                      (pos, direction)
                    end
                  else
                    simulate_ball_path_post_generation grid next_pos new_direction grid_size visited_activated_bumpers (* Continue in the path *)
              end
            end
        else
          begin
          (* Move in the current direction if no object is encountered *)
            let next_pos = move pos direction in
            if out_of_bounds_check next_pos grid_size then
              begin
                (pos, direction)
              end
            else
              begin
                simulate_ball_path_post_generation grid next_pos direction grid_size visited_activated_bumpers
              end
          end
      end 