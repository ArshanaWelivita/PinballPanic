open Core
open Bumper

let round_num = ref 1

let arrow_of_direction (initial_direction : direction) : string = match initial_direction with 
  | Up -> "↑"
  | Down -> "↓"
  | Left -> "←"
  | Right -> "→"
;;

let display_sample_grid () =
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

let display_grid_with_arrow_and_bumper grid_size entry_pos initial_direction bumper_positions =
  let (entry_row, entry_col) = entry_pos in
  let arrow = arrow_of_direction initial_direction in

  printf "%d %d" entry_row entry_col;
  Out_channel.newline stdout;

  (* Print the arrow if the entry position is from the top and display it above the column labels *)
  printf "    ";  
  for j = 0 to grid_size - 1 do
    if entry_row = 0 && j = entry_col - 1 then
      printf "   %s" arrow  (* Print entry arrow below the grid *)
    else
      printf "    "  (* Empty space for alignment *)
  done;
  Out_channel.newline stdout;

  printf "    ";  
  for j = 0 to grid_size - 1 do
      printf "   %d" j  (* Print column labels *)
  done;
  Out_channel.newline stdout;

  (* Display each row with left and right row labels and all bumpers *)
  for i = 0 to grid_size - 1 do
    (* Print left row label and arrow if entry is on the left *)
    if entry_col = 0 && i = entry_row - 1 then
      printf " %s  %d  " arrow i
    else
      printf "    %d  " i;

    (* Print each cell in the row *)
    for j = 0 to grid_size - 1 do
      if List.exists bumper_positions ~f:(fun (br, bc, btype) -> br = i && bc = j && btype = 1) then
        printf "/  "  
      else if List.exists bumper_positions ~f:(fun (br, bc, btype) -> br = i && bc = j && btype = -1) then
        printf "\\  "
      else
        printf "_   "  
    done;

    (* Print right row label and arrow if entry is on the right *)
    if entry_col = grid_size + 1 && i = entry_row - 1 then
      printf " %s" arrow;
    Out_channel.newline stdout
  done;

  (* Print the bottom row with the arrow if entry is at the bottom *)
  printf "    ";  
  for j = 0 to grid_size - 1 do
    if entry_row = grid_size + 1 && j = entry_col - 1 then
      printf "   %s" arrow  
    else
      printf "    "  
  done;
  Out_channel.newline stdout

(* Function to handle each type of input command *)
let handle_command command =
  (* Function to handle a round of PinballPanic *)
  let handle_round () =
    (* Print grid in terminal along with level name *)
    print_endline ("Level " ^ Int.to_string !round_num);

    let (grid, entry_pos, correct_exit_pos, initial_direction) = Grid.generate_grid !round_num in
    let grid_size = Grid.get_grid_size !round_num in 

    (* Collect bumper positions from the grid where value is 1 *)
    let bumper_positions = 
      Array.foldi grid ~init:[] ~f:(fun i acc row ->
        Array.foldi row ~init:acc ~f:(fun j acc cell ->
           (i, j, cell) :: acc))
    in

    (* Display the grid with entry arrow and bumper positions *)
    display_grid_with_arrow_and_bumper grid_size entry_pos initial_direction bumper_positions;

    (* Print the correct exit position after displaying the grid *)
    print_endline ("Exit Position: " ^ "(" ^ Int.to_string (fst correct_exit_pos) ^ ", " ^ Int.to_string (snd correct_exit_pos) ^ ")");

    (* Print ending grid with label end positions *)
    print_endline "Enter your answer as 'row,col': ";
    let answer = In_channel.input_line_exn In_channel.stdin in
    print_endline ("Answer received: " ^ answer);
    let correct_answer = Printf.sprintf "%d,%d" (fst correct_exit_pos) (snd correct_exit_pos) in


    match String.equal answer correct_answer with
      | true ->
      (* case 1: correct *)
        print_endline "Correct! Enter 'c' to continue to the next round.";
        (* increment round number *)
        round_num := !round_num + 1;
      | false ->
        (* case 2: incorrect *)
        print_endline ("Incorrect! The correct answer was: " ^ correct_answer);
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
  print_endline ("Example sample grid and the indices related to each row,col.");
  display_sample_grid ();

  print_endline "Enter 's' to start the game: ";
  match In_channel.input_line In_channel.stdin with
    | None -> print_endline "Error reading input"; main_loop ()
    | Some command -> handle_command command; main_loop ()

(* Entry point for the game *)
let () = main_loop ()
