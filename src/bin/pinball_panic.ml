open Core
open Grid_cell

let round_num = ref 1

(* Return associated message given the level number *)
let get_level_message (level : int) : string = 
  match level with
  | 0 -> " "
  | 1 -> " "
  | 2 -> " "
  | 3 -> "Introducting tunnels this level! These objects will transport the ball straight through, or bounce off and reverse directions, all depending on the tunnel's orientation."
  | 4 -> " "
  | 5 -> "Uhoh! The next level has teleporters. which will teleport the ball to another location on the grid, preserving direction."
  | 6 -> " "
  | 7 -> " "
  | 8 -> "Watch out! This next level has activated bumpers! The ball will pass through them the first time, but will act like a regular bumper from then on."
  | 9 -> " "
  | 10 -> "New grid object alert! Directional bumpers can be passed through in 2 directions, but act like regular bumpers in the other two directions."
  | 11 -> " "
  | 12 -> " "
  | 13 -> "Pay attention! Things are starting to heat up, and the levels will only get harder!"
  | 14 -> " "
  | 15 -> " "
  | 16 -> "Last level! It's time to put all of your skills to the test! Good luck!"
  | _ -> failwith "Invalid level number."

let display_indices_grid () =
  let grid_size = 3 in
  
  (* Print top column labels *)
  printf "   ";  (* Padding for row labels *)
  for j = 0 to grid_size - 1 do
    printf "  %d   " j
  done;
  Out_channel.newline stdout;

  (* Display the grid with row and column indices *)
  for i = 0 to grid_size - 1 do
    (* Print left row label *)
    printf "%d  " i;

    (* Print the grid row with cell indices *)
    for j = 0 to grid_size - 1 do
      printf "[%d,%d] " i j
    done;

    Out_channel.newline stdout
  done;
  Out_channel.newline stdout

let display_sample_grid () =
  (* Define a sample 5x5 grid with a 3x3 actual grid (buffer rows and columns around) *)
  let grid = [|
    [|4; 4; 3; 4; 4|];
    [|4; 0; 0; 0; 4|];
    [|4; 0; 1; 0; 2|];
    [|4; 0; 0; 0; 4|];
    [|4; 4; 4; 4; 4|];
  |] in

  (* Print top column labels *)
  printf "     ";  
  for j = 0 to Array.length grid.(0) - 1 do
    printf "%d    " j
  done;
  Out_channel.newline stdout;

  (* Display the grid with row and column indices *)
  for i = 0 to Array.length grid - 1 do
    (* Print left row label *)
    printf "%d  " i;

    (* Print the grid row with values *)
    for j = 0 to Array.length grid.(i) - 1 do
      match grid.(i).(j) with
      | 3 -> printf "  E  "
      | 2 -> printf "  .  "
      | 1 -> printf "  ⟍  "   
      | -1 -> printf "  ⟋  " 
      | 0 -> printf "  -  "   
      | 4 -> printf "  .  "
      | _ -> printf "  -  "   
    done;

    Out_channel.newline stdout
  done;
  Out_channel.newline stdout

(* Displays sample grid and gives the game instruction. *)
let display_sample_grid_game () = 
  print_endline ("Welcome to Pinball Panic! 
This game consists of 16 levels.
Your goal is to correctly identify the coordinates of the ball's exit point by determining the path of the ball using the grid objects.
As you continue to answer correctly, the levels will increase in difficulty and introduce more types of grid objects.
");

  print_endline ("The following is an example sample grid of size 3 x 3 which shows the indices related to each cell in the form [row, col].");
  display_indices_grid ();
  print_endline ("Consider the following example case, the entry and exit positions are marked by arrows.");
  display_sample_grid ();
  print_endline 
  ("The above example has entry position at [0, 2] and a bumper at position at [2, 2]. 
This means the ball starts from the entry position, bounces off the bumper in a perpendicular direction and then exits the grid at position [2, 4]. 
In order to pass to the next level, you need to correctly identify the exit position of the ball from the grid where it is given in the form row col separated by space. 
In the actual game, the grid will only be displayed for a couple seconds, so be speedy when determining the end position. 
Good luck and have fun!\n")

(* Displays the grid *)
let display_grid (grid_size: int) (grid: grid_cell array array) (entry_exit_same: bool) : unit =
  printf "   ";
  for j = 0 to grid_size + 1 do
    printf "  %d  " j
  done;
  Out_channel.newline stdout;

  for i = 0 to grid_size + 1 do
    printf "%d  " i;
    for j = 0 to Array.length grid.(i) - 1 do
      match to_string grid.(i).(j) with
      | "Entry" -> printf "  E  "
      | "Exit" -> if entry_exit_same then printf "  E  " else printf "  -  "
      | "Empty" -> printf "  -  "
      | "InBallPath" -> printf "  -  "
      | "Bumper" -> printf "  %s  " (get_bumper_orientation_string grid.(i).(j).cell_type)
      | "Tunnel" -> printf "  %s  " (get_tunnel_orientation_string grid.(i).(j).cell_type)
      | "Teleporter" -> printf "  ★  "
      | "ActivatedBumper" -> printf "  %s  " (get_activated_bumper_orientation_string grid.(i).(j).cell_type)
      | "DirectionalBumper" -> printf "  %s  " (get_directional_bumper_orientation_string grid.(i).(j).cell_type)
      | _ -> failwith "Invalid grid cell type."
    done;
    Out_channel.newline stdout
  done

(* Display the grid with grid objects *)
let display_grid_with_grid_objects (entry_pos: pos) (correct_exit_pos: pos) (grid: grid_cell array array) (grid_size: int): unit = 
  if Grid.compare_pos entry_pos correct_exit_pos then 
    display_grid grid_size grid true
  else 
    display_grid grid_size grid false

(* Function to handle each type of input command *)
let handle_command command =
  (* Function to handle a round of PinballPanic *)
  let handle_round () =
    (* Print grid in terminal along with level name *)
    print_endline ("Level " ^ Int.to_string !round_num);

    begin
    (* Print the level-specific message *)
    let level_message = get_level_message !round_num in
    if String.(level_message <> " ") then print_endline level_message;

    let (grid, entry_pos, correct_exit_pos, _) = Grid.generate_grid !round_num in
    let grid_size = Grid.get_grid_size !round_num in 

    Out_channel.flush stdout;

    display_grid_with_grid_objects entry_pos correct_exit_pos grid grid_size;

    Out_channel.flush stdout;

    (* Wait for 5 seconds before clearing the terminal *)
    let () = Core_unix.sleep 5 in

    (* Clear the terminal screen after the 5-second wait *)
    ignore (Core_unix.system "clear");
    Out_channel.flush stdout;

    (* Replace all grid cell objects with Empty, skipping Entry *)
    for i = 0 to grid_size do
      for j = 0 to Array.length grid.(i) - 1 do
        (* Skip updating Entry cells *)
        match grid.(i).(j).cell_type with
        | Entry _ -> () (* Do nothing, preserve Entry *)
        | _ -> grid.(i).(j) <- { grid.(i).(j) with cell_type = Empty }
      done
    done;

    display_grid_with_grid_objects entry_pos correct_exit_pos grid grid_size; 

    (* Gets the user's input for the row col *)
    let parse_answer input =
      let trimmed = String.strip input in
      (* Quits the program *)
      if String.equal trimmed "q" then (
        exit 0;
      ) else (
        (* Gets the row and col input from the user in the form 'row col' where they are integers separated by a space and checks if 
          *)
        let parts = String.split ~on:' ' trimmed in
        match parts with
        | [row_str; col_str] -> (
            try
              let row = Int.of_string row_str in
              let col = Int.of_string col_str in
              Some (row, col)
            with Failure _ -> None)
        | _ -> None
      )
    in

    (* Repeatedly asks the user to enter 'row col input' until valid input is given *)
    let rec get_valid_answer () =
      print_endline "Enter your answer as 'row col', where they are two integers separated by a space:";
      match parse_answer (In_channel.input_line_exn In_channel.stdin) with
      | Some (row, col) -> (row, col)
      | None ->
          print_endline "Invalid input! Please enter two integers separated by a space.";
          get_valid_answer () (* Retry *)
    in

    (* Gets row col answer *)
    let (row, col) = get_valid_answer () in

    (* Check correctness *)
    let correct_row, correct_col = correct_exit_pos in
    if row = correct_row && col = correct_col then (
      (* Case 1: Correct answer *)
      print_endline "Correct! Enter 'c' to continue to the next round.";
      (* Increment round number *)
      round_num := !round_num + 1
    ) else (
      (* Case 2: Incorrect answer *)
      print_endline
        ("Incorrect! The correct answer was: "
        ^ Printf.sprintf "%d %d" correct_row correct_col);
      print_endline "GAME OVER!";
      exit 0
    )
    end
  in
  (* Checks and handles the commands *)
  match command with
    | "s" ->
      print_endline "Starting the game, pay attention...";
      handle_round ()
    | "c" -> 
      if !round_num <> 17 then (
        print_endline "Continuing to the next round, get ready...";
        handle_round ()
      )
      else (
        print_endline("You're a Pinball Panic Master! Good job on completing all the levels!"); 
        exit 0
      )
    | "q" -> 
      print_endline "See you next time!";
      exit 0
    | _ -> 
      print_endline "Invalid command, please try again."

(* Main loop to read and parse user input *)
let rec main_loop () =
  if !round_num = 1 then print_endline "Enter 's' to start the game: " else print_endline "";
  match In_channel.input_line In_channel.stdin with
    | None -> print_endline "Error reading input"; main_loop ()
    | Some command -> handle_command command; main_loop ()

(* Entry point for the game *)
let () = 
  display_sample_grid_game ();
  main_loop ()
