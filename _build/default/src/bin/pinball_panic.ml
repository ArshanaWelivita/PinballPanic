open Core

(* Function to handle each type of input command *)
let handle_command command =
  match command with
    | "s" ->
      let round = 1 in
      print_endline "Starting the game, pay attention...";
    | "c" -> 
      print_endline "Continuing to the next round, get ready...";

    | "q" -> 
      print_endline "See you next time!";
      exit 0
    | _ -> 
      print_endline "Invalid command. Please try again."

let handle_round round =
  (* Print grid in terminal along with level name *)

  (* Remove grid with bumpers *)

  (* Print ending grid with label end positions *)
  print_endline "Enter your answer: ";
  let answer = In_channel.input_line_exn In_channel.stdin in
  print_endline ("Answer received: " ^ answer);
  (* check if answer is correct *)
  let correct_answer = "b" in (* Fetch correct answer*)

  match answer with
  (* case 1: correct *)
  print_endline "Correct! Enter 'c' to continue to the next round.";
  (* case 2: incorrect *)
  print_endline ("Incorrect! The correct answer was: " ^ correct_answer);
  print_endline "Enter 's' to play again";

(* Main loop to read and parse user input *)
let rec main_loop () =
  print_endline "Enter 's' to start the game: ";
  match In_channel.input_line In_channel.stdin with
    | None -> print_endline "Error reading input"; main_loop ()
    | Some command -> handle_command command; main_loop ()

(* Entry point for the game *)
let () = main_loop ()
