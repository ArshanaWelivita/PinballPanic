open Core 
open Grid_cell

type grid = grid_cell array array 
type pos = int * int

(* type orientation =
  | Bumper_orientation of Bumper.orientation
  | Tunnel_orientation of Tunnel.orientationTunnel *)

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


(* let is_activated_bumper_active (ball_pos: pos) (bumper_pos: pos) : bool = 
  false (* will implement this later when doing the activated bumper feature in week 3 of implementation *)
   *)
let string_of_orientation (orientation : orientation) : string =
  match orientation with
  | UpRight -> "UpRight"
  | DownRight -> "DownRight"
  | Vertical -> "Vertical"
  | Horizontal -> "Horizontal"

let string_of_direction (dir: direction) : string = 
  match dir with 
    |Up -> "Up"
    |Down -> "Down"
    |Left -> "Left"
    |Right -> "Right"

let get_initial_grid_cell_type (initial_grid_object_marker: grid_cell_type) (initial_direction: Grid_cell.direction) = 
  match initial_grid_object_marker with
  | TunnelLevelMarker -> 
      let initial_orientation = List.random_element_exn [Vertical; Horizontal] 
      in
      Tunnel { orientation = initial_orientation; direction = (initial_direction) }
  | BumperLevelMarker -> 
      let initial_orientation = List.random_element_exn [DownRight; UpRight] 
      in
      Bumper { orientation = initial_orientation; direction = (initial_direction) }
  | ActivatedBumperLevelMarker -> 
      let initial_orientation = List.random_element_exn [DownRight; UpRight] 
      in
      ActivatedBumper { orientation = initial_orientation; direction = (initial_direction); is_active = false }
  | Teleporter -> Teleporter
  | _ -> failwith "Wrong grid object placed. Need to regenerate grid."


let place_initial_grid_object (grid: grid) (entry_pos: pos) (direction: direction) (grid_size: int) (new_grid_cell_type : grid_cell_type) : pos * orientation =
  let (entry_row, entry_col) = entry_pos in
  let grid_cell_object_pos, orientation =
    let initial_grid_cell = get_initial_grid_cell_type new_grid_cell_type direction in
    let orientation = match initial_grid_cell with
      | Bumper { orientation = o; _ } -> o
      | Tunnel { orientation = o; _ } -> o
      (* | ActivatedBumper { orientation = o; _ } -> o *)
      | _ -> failwith "Unexpected grid cell type"
    in
    match direction with
    | Left -> let col = Random.int_incl 1 grid_size in
              let pos = (entry_row, col) in
              let grid_cell = {position= pos; cell_type= initial_grid_cell} in
              grid.(entry_row).(col) <- grid_cell; 
              (pos, orientation);
    | Right -> let col = Random.int_incl 1 grid_size in
                let pos = (entry_row, col) in
                let grid_cell = {position= pos; cell_type= initial_grid_cell} in
                grid.(entry_row).(col) <- grid_cell; 
                (pos, orientation)
    | Up -> let row = Random.int_incl 1 grid_size in
            let pos = (row, entry_col) in
            let grid_cell = {position= pos; cell_type= initial_grid_cell} in
            grid.(row).(entry_col) <- grid_cell;  
            (pos, orientation)  
    | Down -> let row = Random.int_incl 1 grid_size in
              let pos = (row, entry_col) in
              let grid_cell = {position= pos; cell_type= initial_grid_cell} in
              grid.(row).(entry_col) <- grid_cell; 
              (pos, orientation)  
  in
  printf "Initial grid object placed position: %d %d\n" (fst grid_cell_object_pos) (snd grid_cell_object_pos);
  (grid_cell_object_pos, orientation) 

(* let convert_activated_to_regular_bumper (bumper_pos: pos) (grid: grid) : bool =
  false  implement this later in week 3 when we do activated bumper stuff *)

let orientation_for_direction (*(direction: direction)*) () : orientation =
  (* match direction with
  | Up | Right -> UpRight (*  ╱ is upright *)
  | Down | Left -> DownRight  ╲ is downright *)
  List.random_element_exn [DownRight; UpRight]

let orientation_for_tunnel_direction () : orientation =
  List.random_element_exn [Vertical; Horizontal]

let rec collect_positions_along_path (grid: grid) (start_pos: pos) (direction: direction) (grid_size: int) : pos list =
  let (row, col) = start_pos in
  if not (is_within_actual_grid row col grid_size) then 
    []
  else 
    let current_grid_cell = grid.(row).(col) in
    (* if compare_grid_cell_type current_grid_cell Empty then
      (* Add current position if empty and continue along the path *)
      start_pos :: collect_positions_along_path grid (move start_pos direction) direction grid_size
    else   *)
      match current_grid_cell.cell_type with
      | Empty -> start_pos :: collect_positions_along_path grid (move start_pos direction) direction grid_size (* Add current position if empty and continue along the path *)
      | _ -> []
      (* | InBallPath -> []  (* Stop if the ball's path is encountered *)
      | Bumper _ -> []  (* Stop if a bumper is encountered *)
      | Tunnel _ -> []  (* Stop if a tunnel is encountered *)
      | Teleporter -> []  (* Stop if a teleporter is encountered *)
      | ActivatedBumper _ -> []  (* Stop if an activated bumper is encountered where it is active -> need to adjust this case when i look at activated bumper functionality *) 
      | BumperLevelMarker -> failwith "The grid needs to be regenerated as this grid object marker needs to be replaced with the actual grid object."
      | TunnelLevelMarker -> failwith "The grid needs to be regenerated as this grid object marker needs to be replaced with the actual grid object."
      | ActivatedBumperLevelMarker -> failwith "The grid needs to be regenerated as this grid object marker needs to be replaced with the actual grid object." *)

let place_random_grid_element_along_path (grid: grid) (start_pos: pos) (direction: direction) (grid_size: int) (orientation: orientation) (new_grid_cell_type: grid_cell_type) : unit =
  let potential_positions = collect_positions_along_path grid start_pos direction grid_size in
  match List.random_element potential_positions with
  | Some (row, col) -> 
    let updated_cell = 
      match new_grid_cell_type with
      | Bumper _ -> 
                    Bumper {
                      orientation = orientation; 
                      direction = direction
                    }
      | Tunnel _ -> Tunnel {
                      orientation = orientation; 
                      direction = direction
                    }
      | ActivatedBumper _ -> ActivatedBumper {
                      orientation = orientation; 
                      direction = direction;
                      is_active = true
                    } 
      | Teleporter -> Teleporter
      | _ -> failwith "Grid cell type is not defined can't be placed in the grid."
    in
    (* Place the updated cell in the grid *)
    grid.(row).(col) <- {position = (row, col); cell_type = updated_cell}; (* Successfully placed the grid object in the grid *)
  | None -> ()  (* No valid position found, so can't place anything in this path *)

let rec simulate_ball_path (grid: grid) (pos: pos) (direction: direction) 
  (objects_left: int) (grid_size: int) (orientation: orientation) (bounce_limit: int)
  (visited: (pos * direction) Set.Poly.t) (grid_object_types : grid_cell_type list) : pos * direction =
  (* Print the current position of the ball *)
  printf "Ball position: %d %d | Direction: %s | Objects left: %d | Bounce limit: %d\n"
  (fst pos) (snd pos) (string_of_direction direction) objects_left bounce_limit;

  (* Check if the ball is out of bounds *)
  if out_of_bounds_check pos grid_size then
    begin
      printf "Out of bounds at position %d %d, returning.\n" (fst pos) (snd pos);
      (pos, direction)  (* Ball has exited the grid *)
    end
  else if objects_left = -1 then  
    (pos, direction)  (* Stopping if grid objects are exhausted *)
  else if Set.mem visited (pos, direction) then
    begin
      printf "Loop detected at position %d %d, stopping.\n" (fst pos) (snd pos);
      ((-1, -1), Down) (* Stop if a loop is detected *)
    end
  else
    begin
      let visited = Set.add visited (pos, direction) in

      (* Check if the current cell contains a bumper *)
      let (row, col) = pos in
      let current_grid_cell = grid.(row).(col) in 
      if not (compare_grid_cell_type current_grid_cell Empty) && not (compare_grid_cell_type current_grid_cell InBallPath) then
        begin
          (* Bounce off the grid object *)
          printf "Grid Object: %s encountered at %d %d, orientation: %s\n" (to_string current_grid_cell) row col (string_of_orientation orientation);
          
          (* Determine new direction based on orientation *)
          let new_direction = match current_grid_cell.cell_type with 
            | Tunnel { orientation; _ } -> let direction_map = Tunnel.generate_directions (orientation_to_tunnel_orientation orientation) in 
                                           Map.find_exn direction_map (direction_to_tunnel_direction direction)
                                           |> tunnel_direction_to_direction
            | Bumper { orientation; _ } -> let direction_map = Bumper.generate_directions (orientation_to_bumper_orientation orientation) in
                                           Map.find_exn direction_map (direction_to_bumper_direction direction)
                                           |> bumper_direction_to_direction
            (* | ActivatedBumper { orientation; _ } -> let direction_map = Activated_bumper.generate_directions orientation in
                                                    Map.find_exn direction_map (direction_to_bumper_direction direction)
                                                    |> bumper_direction_to_direction *)
            | Entry _ -> direction
            (* | Exit _ -> direction                                         *)
            | _ -> failwith "Grid cell type doesn't have directions."
          in 
          printf "New direction after bounce: %s\n" (string_of_direction new_direction);

          let next_pos = move pos new_direction in

          (* Check if bumpers_left is 0: Follow the path without placing new bumpers *)
          if objects_left = 0 then
            begin
            (* printf "No bumpers left; following path until exit.\n"; *)
              if out_of_bounds_check next_pos grid_size then
                begin
                  printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
                  printf "end pos: %d %d" (fst pos) (snd pos);
                  (pos, direction)
                end
              else
              (* Continue path simulation in the new direction without placing a new bumper *)
              simulate_ball_path grid next_pos new_direction 0 grid_size orientation bounce_limit visited grid_object_types
            end
          else
          (* Place a bumper if bumpers_left > 0 *)
            begin
              (* Place a bumper randomly along the new direction *)
              (* printf "Placing bumper along path from position %d %d\n" (fst next_pos) (snd next_pos); *)
              (* Set the new orientation for the next bumper placement *)
              let next_grid_object_marker = List.random_element_exn grid_object_types in 
              let next_orientation = match next_grid_object_marker with 
                | BumperLevelMarker -> orientation_for_direction () 
                | TunnelLevelMarker -> orientation_for_tunnel_direction ()
                | _ -> failwith "Invalid grid object marker"
              in 
              let next_grid_object = get_initial_grid_cell_type next_grid_object_marker new_direction in 
              place_random_grid_element_along_path grid next_pos new_direction grid_size next_orientation next_grid_object;
              (* printf "Next bumper orientation: %s\n" (string_of_orientation next_orientation); *)

              (* Continue path simulation in the new direction with one less bumper *)
              simulate_ball_path grid next_pos new_direction (objects_left - 1) grid_size next_orientation (bounce_limit - 1) visited grid_object_types
            end
        end
      else
        begin
        (* Move in the current direction if no bumper is encountered *)
          let next_pos = move pos direction in
          if out_of_bounds_check next_pos grid_size then
            begin
              printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
              (pos, direction)
            end
          else
            begin
              printf "No bumper encountered, continuing straight from position %d %d\n" row col;
              simulate_ball_path grid next_pos direction objects_left grid_size orientation bounce_limit visited grid_object_types
            end
        end
    end

    (* let rec simulate_ball_path 
    (grid: grid) (pos: pos) (direction: direction) 
    (objects_left: int) (grid_size: int) (orientation: orientation) 
    (bounce_limit: int) (visited: (pos * direction) Set.Poly.t) 
    (grid_object_types : grid_cell_type list) : pos * direction =
  
  (* Print the current position of the ball *)
  printf "Ball position: %d %d | Direction: %s | Objects left: %d | Bounce limit: %d\n"
    (fst pos) (snd pos) (string_of_direction direction) objects_left bounce_limit;

  (* Check if the ball is out of bounds *)
  if out_of_bounds_check pos grid_size then
    begin
      printf "Out of bounds at position %d %d, returning.\n" (fst pos) (snd pos);
      (pos, direction)  (* Ball has exited the grid *)
    end
  else if objects_left = -1 then  
    (pos, direction)  (* Stopping if grid objects are exhausted *)
  else if Set.mem visited (pos, direction) then
    begin
      printf "Loop detected at position %d %d, stopping.\n" (fst pos) (snd pos);
      ((-1, -1), Down) (* Stop if a loop is detected *)
    end
  else
    begin
      let visited = Set.add visited (pos, direction) in

      (* Check if the current cell contains a grid object *)
      let (row, col) = pos in
      let current_grid_cell = grid.(row).(col) in 
      
      (* If there's an object to interact with *)
      if not (compare_grid_cell_type current_grid_cell Empty) && 
         not (compare_grid_cell_type current_grid_cell InBallPath) then
        begin
          (* Bounce off the grid object *)
          printf "Grid Object: %s encountered at %d %d, orientation: %s\n" 
            (to_string current_grid_cell) row col (string_of_orientation orientation);

          (* Determine new direction based on grid object type *)
          let new_direction = match current_grid_cell.cell_type with 
            | Tunnel { orientation; _ } -> 
              let direction_map = Tunnel.generate_directions (orientation_to_tunnel_orientation orientation) in 
              Map.find_exn direction_map (direction_to_tunnel_direction direction)
              |> tunnel_direction_to_direction
            | Bumper { orientation; _ } -> 
              let direction_map = Bumper.generate_directions (orientation_to_bumper_orientation orientation) in
              Map.find_exn direction_map (direction_to_bumper_direction direction)
              |> bumper_direction_to_direction
            | Entry _ -> direction  (* Entry has no effect on direction *)
            | _ -> failwith "Grid cell type doesn't have directions."
          in 
          
          printf "New direction after bounce: %s\n" (string_of_direction new_direction);
          let next_pos = move pos new_direction in

          (* If no grid objects are left, just continue moving in the current direction *)
          if objects_left = 0 then
            begin
              if out_of_bounds_check next_pos grid_size then
                begin
                  printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
                  (pos, direction)
                end
              else
                (* Continue simulation without placing new grid object *)
                simulate_ball_path grid next_pos new_direction 0 grid_size orientation bounce_limit visited grid_object_types
            end
          else
            begin
              (* Place a grid object if bumpers or tunnels are left *)
              let next_grid_object_marker = List.random_element_exn grid_object_types in 
              let next_orientation = match next_grid_object_marker with 
                | BumperLevelMarker -> orientation_for_direction () 
                | TunnelLevelMarker -> orientation_for_tunnel_direction ()
                | _ -> failwith "Invalid grid object marker"
              in 
              let next_grid_object = get_initial_grid_cell_type next_grid_object_marker new_direction in 
              place_random_grid_element_along_path grid next_pos new_direction grid_size next_orientation next_grid_object;
              
              (* Continue simulation after placing a new object, decrement objects_left *)
              simulate_ball_path grid next_pos new_direction (objects_left - 1) grid_size next_orientation (bounce_limit - 1) visited grid_object_types
            end
        end
      else
        begin
          (* No grid object encountered, just move in the current direction *)
          let next_pos = move pos direction in
          if out_of_bounds_check next_pos grid_size then
            begin
              printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
              (pos, direction)
            end
          else
            begin
              printf "No bumper encountered, continuing straight from position %d %d\n" row col;
              simulate_ball_path grid next_pos direction objects_left grid_size orientation bounce_limit visited grid_object_types
            end
        end
    end *)

let rec generate_grid (level: int) : grid * pos * pos * direction =
  let (grid_size, min_objects, max_objects, grid_object_types) = get_level_settings level in
  let grid = Array.init (grid_size + 2) ~f:(fun x -> Array.init (grid_size + 2) 
                ~f:(fun y -> { position = (x,y); cell_type = Empty })) in

  let object_count = Random.int_incl min_objects max_objects in

  (* Choose a random entry point and initial direction *)
  let possible_entries = [
    ((0, Random.int_incl 1 grid_size), Grid_cell.Down);               (* Entry from the top *)
    ((grid_size + 1, Random.int_incl 1 grid_size), Grid_cell.Up);     (* Entry from the bottom *)
    ((Random.int_incl 1 grid_size, 0), Grid_cell.Right);              (* Entry from the left *)
    ((Random.int_incl 1 grid_size, grid_size + 1), Grid_cell.Left);   (* Entry from the right *)
  ] in
  let (entry_pos, initial_direction) = List.random_element_exn possible_entries in
  grid.(fst entry_pos).(snd entry_pos) <- { position = entry_pos; cell_type = Entry {direction = initial_direction} };

  (* Choose the first grid object randomly from a list of viable grid objects for that level and then place it in the grid *)
  let initial_grid_object_marker = List.random_element_exn grid_object_types in 
  (* let initial_grid_cell_type = get_initial_grid_cell_type initial_grid_object_marker initial_direction in *)
  let (first_grid_object_pos, first_orientation) = place_initial_grid_object grid entry_pos initial_direction grid_size initial_grid_object_marker in

  let bounce_limit = 10 in
  let visited = Set.Poly.empty in

  (* Run the simulation to place grid objects along the ball's path and then get its exit position and direction based off the generated ball path *)
  let (exit_pos, exit_direction) = simulate_ball_path grid first_grid_object_pos initial_direction (object_count - 1) grid_size first_orientation bounce_limit visited grid_object_types in
  grid.(fst exit_pos).(snd exit_pos) <- { position = exit_pos; cell_type = Exit {direction = exit_direction} };

  (* If loop detected, regenerates grid for that level *)
  if compare_pos exit_pos (-1, -1) then generate_grid level 
  else 
    (* Count the grid objects placed on the grid *)
    let objects_placed =
      Array.fold grid ~init:0 ~f:(fun acc row ->
        acc + Array.fold row ~init:0 ~f:(fun acc cell ->
          match cell.cell_type with
          | Bumper _ | Tunnel _ | Teleporter | ActivatedBumper _ -> acc + 1
          | _ -> acc
        )
    ) in 

    (* Check if the number of grid objects placed meets the minimum requirement *)
    if objects_placed = object_count then
       (* Return the viable grid and the ball's properties (entry direction and position, and exit position) *)
      (grid, entry_pos, exit_pos, initial_direction) 
    else
      generate_grid level

let rec simulate_ball_path_post_generation (grid : grid) (pos: pos) (direction: direction) (grid_size : int) : pos * direction =
  (* Check if the ball is out of bounds *)
  if out_of_bounds_check pos grid_size then
    begin
      (* printf "Out of bounds at position %d %d, returning.\n" (fst pos) (snd pos); *)
      (pos, direction)  (* Ball has exited the grid *)
    end
  else
      begin
        (* Check if the current cell contains an object *)
        let (row, col) = pos in
        let current_grid_cell = grid.(row).(col) in 
        if not (compare_grid_cell_type current_grid_cell Empty) then
          begin
            (* Bounce off the grid object *)

            (* Determine new direction based on orientation *)
            let new_direction = match current_grid_cell.cell_type with 
              | Tunnel { orientation; _ } -> let direction_map = Tunnel.generate_directions (orientation_to_tunnel_orientation orientation) in 
                                             Map.find_exn direction_map (direction_to_tunnel_direction direction)
                                             |> tunnel_direction_to_direction
              | Bumper { orientation; _ } -> let direction_map = Bumper.generate_directions (orientation_to_bumper_orientation orientation) in
                                             Map.find_exn direction_map (direction_to_bumper_direction direction)
                                             |> bumper_direction_to_direction
              (* | ActivatedBumper { orientation; _ } -> let direction_map = Activated_bumper.generate_directions orientation in
                                                      Map.find_exn direction_map (direction_to_bumper_direction direction)
                                                      |> bumper_direction_to_direction *)
              | Entry _ -> direction
              | Exit _ -> direction                                        
              | _ -> failwith "Grid cell type doesn't have directions."
            in 
            (* printf "New direction after bounce: %s\n" (string_of_direction new_direction); *)
  
            let next_pos = move pos new_direction in
  
            (* Check if bumpers_left is 0: Follow the path without placing new bumpers *)
            begin
              (* printf "No bumpers left; following path until exit.\n"; *)
                if out_of_bounds_check next_pos grid_size then
                  begin
                    (* printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos);
                    printf "end pos: %d %d" (fst pos) (snd pos); *)
                    (pos, direction)
                  end
                else
                  (* Continue path simulation in the new direction without placing a new bumper *)
                  simulate_ball_path_post_generation grid next_pos new_direction grid_size 
            end
          end
        else
          begin
          (* Move in the current direction if no object is encountered *)
            let next_pos = move pos direction in
            if out_of_bounds_check next_pos grid_size then
              begin
                (* printf "Next position %d %d is out of bounds, stopping.\n" (fst next_pos) (snd next_pos); *)
                (pos, direction)
              end
            else
              begin
                (* printf "No object encountered, continuing straight from position %d %d\n" row col; *)
                simulate_ball_path_post_generation grid next_pos direction grid_size
              end
          end
      end