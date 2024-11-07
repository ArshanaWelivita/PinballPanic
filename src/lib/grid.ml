open Core 

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

module type Grid = sig
  val n : int
  val entry_pos : pos
  val out_of_bounds_check : pos -> bool
  val generate_grid : int -> int array array * pos
end

module PinballGrid : Grid = struct
  let n = 3 
  let entry_pos = (0, 0) 
  
  let get_level_settings (level: int) : int * int * int =
    List.Assoc.find_exn level_bounce_settings ~equal:Int.equal level
  
  let out_of_bounds_check (row, col : pos) : bool = 
    if row < 1 || col < 1 || row > n || col > n then true else false 

  let rec place_bumpers_in_grid (row: int) (bumpers_left: int) (grid_size : int) (grid: int array array) : unit = 
    if row >= grid_size || bumpers_left <= 0 then ()
    else
      let bumper_count = min bumpers_left (grid_size / 2) in
      let positions = List.init grid_size ~f:Fn.id |> List.permute in
      let selected_positions = List.take positions bumper_count in
      List.iter selected_positions ~f:(fun col -> grid.(row).(col) <- 1);
      place_bumpers_in_grid (row + 1) (bumpers_left - bumper_count) grid_size grid
  
  let check_answer (correct_pos : pos) (answer : string) : bool =
    match String.split ~on:',' answer with
    | [row_str; col_str] -> 
      (try 
        let row = Int.of_string row_str in
        let col = Int.of_string col_str in
        let check_pos : pos = (row, col) in
          check_pos = correct_pos
      with _ -> false)
    | _ -> false
  
  let generate_grid (level: int) : int array array * pos =
    let (grid_size, min_bounces, max_bounces) = get_level_settings level in
    let grid = Array.make_matrix ~dimx:grid_size ~dimy:grid_size 0 in

    let bumper_count = Random.int_incl min_bounces max_bounces in
    place_bumpers_in_grid 0 bumper_count grid_size grid;

    let exit_pos : pos = (grid_size, grid_size) in (grid, exit_pos)
end