open Core
open Grid_cell

let round_num = ref 1
(* let round_num = 7 <- used for debugging purposes *)

let arrow_of_direction (initial_direction : direction) : string = match initial_direction with 
  | Up -> "↑🟢"
  | Down -> "↓🟢"
  | Left -> "←🟢"
  | Right -> "→🟢"
;; 

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
      | 3 -> printf " %s " (arrow_of_direction Down) 
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
  print_endline ("The following is an example sample grid of size 3 x 3 which shows the indices related to each cell in the form [row, col].");
  display_indices_grid ();
  print_endline ("Consider the following example case, the entry and exit positions are marked by arrows.");
  display_sample_grid ();
  print_endline 
  ("The above example has entry position at [0, 2] and a bumper at position at [2, 2]. This means the ball starts from the entry position, bounces
off the bumper in a perpendicular direction and then exits the grid at position [2, 4]. In order to pass to the next level, you need to correctly
identify the exit position of the ball from the grid where it is given in the form [row, col]. In the actual game, the grid will only be 
displayed for a couple seconds, so be speedy when determining the end position. Good luck!\n")


let display_grid_for_game (grid_size: int) (grid: grid_cell array array ) : unit =
  (* let arrow = arrow_of_direction initial_direction in <- will implement the arrow for entry later *)
  let full_size = grid_size + 1 in
  printf "   ";
  for j = 0 to full_size do
    printf "  %d  " j
  done;
  Out_channel.newline stdout;

  for i = 0 to full_size do
    printf "%d  " i;
    for j = 0 to Array.length grid.(i) - 1 do
      match to_string grid.(i).(j) with
      | "Entry" -> printf "  E  "
      | "Exit" -> printf "  -  "
      | "Empty" -> printf "  -  "
      | "InBallPath" -> printf "  -  "
      | "Bumper" -> printf "  %s  " (get_bumper_orientation_string grid.(i).(j).cell_type)
      | "Tunnel" -> printf "  %s  " (get_tunnel_orientation_string grid.(i).(j).cell_type)
      | "Teleporter" -> printf "  ★  "
      | _ -> failwith "Invalid grid cell type."
    done;
    Out_channel.newline stdout
  done

(* Function to handle each type of input command *)
let handle_command command =
  (* Function to handle a round of PinballPanic *)
  let handle_round () =
    (* Print grid in terminal along with level name *)
    print_endline ("Level " ^ Int.to_string !round_num);

    let (grid, _, correct_exit_pos, _) = Grid.generate_grid !round_num in
    let grid_size = Grid.get_grid_size !round_num in 
    
    (* Display the grid with grid objects *)
    display_grid_for_game grid_size grid;

    (* Print ending grid with label end positions *)
    print_endline "Enter your answer as [row, col]: ";
    let answer = In_channel.input_line_exn In_channel.stdin in
    print_endline ("Answer received: " ^ answer);
    let correct_answer = Printf.sprintf "[%d, %d]" (fst correct_exit_pos) (snd correct_exit_pos) in

    match String.equal answer correct_answer with
      | true ->
      (* case 1: correct *)
        print_endline "Correct! Enter 'c' to continue to the next round.";
        (* increment round number *)
        round_num := !round_num + 1;
      | false ->
        (* case 2: incorrect *)
        print_endline ("Incorrect! The correct answer was: " ^ correct_answer);
        print_endline ("GAME OVER!");
        exit 0;
        (* print_endline "Enter 's' to play again"; *)
  in
  match command with
    | "s" ->
      print_endline "Starting the game, pay attention...";
      handle_round ()
    | "c" -> 
      print_endline "Continuing to the next round, get ready...";
      handle_round ()
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

(* Used for debugging purposes
let display_grid_check () =
  let (grid, entry_pos, _, _) = Grid.generate_grid round_num in
  let grid_size = Grid.get_grid_size round_num in 
  printf "grid size: %d " grid_size;
  Out_channel.newline stdout;
  printf "entry pos: %d %d" (fst entry_pos) (snd entry_pos);
  Out_channel.newline stdout;

  (* Print each cell's value in the grid *)
  for i = 0 to Array.length grid - 1 do
    for j = 0 to Array.length grid.(i) - 1 do
      match to_string grid.(i).(j) with 
      | "Entry" -> printf "  E  " 
      | "Exit" -> printf "  X  " 
      | "Empty" -> printf "  -  " 
      | "InBallPath" -> printf "  -  " 
      | "Bumper" -> printf "  %s  " (get_bumper_orientation_string grid.(i).(j).cell_type)
      | "Tunnel" -> printf "  %s  " (get_tunnel_orientation_string grid.(i).(j).cell_type)
      | "Teleporter" -> printf "  ★  "
      (* 
      | "Teleporter"
      | "ActivatedBumper" *)
      | _ -> failwith "Error: there shouldn't be any other grid cell type string within the grid other than the ones matched above."
    done;
    Out_channel.newline stdout  (* New line after each row *)
  done     *)

(* Entry point for the game *)
let () = 
  display_sample_grid_game ();
  (* display_grid_check (); <- used for debugging purposes *)
  main_loop ()
