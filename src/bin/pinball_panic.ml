open Core

let round_num = 1

(* Function to handle each type of input command *)
let handle_command command =
  (* Function to handle a round of PinballPanic *)
  let handle_round (round_num : int) =
    (* Print grid in terminal along with level name *)
    print_endline ("Level " ^ Int.to_string round_num);

    (* Remove grid with bumpers *)

    (* Print ending grid with label end positions *)
    print_endline "Enter your answer: ";
    let answer = In_channel.input_line_exn In_channel.stdin in
    print_endline ("Answer received: " ^ answer);
    (* check if answer is correct *)
    let correct_answer = "TODO" in (* Fetch correct answer*)

    match String.equal answer correct_answer with
      | true ->
      (* case 1: correct *)
        print_endline "Correct! Enter 'c' to continue to the next round.";
        (* TODO: increment round number *)
      | false ->
        (* case 2: incorrect *)
        print_endline ("Incorrect! The correct answer was: " ^ correct_answer);
        print_endline "Enter 's' to play again";
  in

  match command with
    | "s" ->
      let round_num = 1 in
      print_endline "Starting the game, pay attention...";
      handle_round round_num
    | "c" -> 
      print_endline "Continuing to the next round, get ready...";
      handle_round round_num
    | "q" -> 
      print_endline "See you next time!";
      exit 0
    | _ -> 
      print_endline "Invalid command, please try again."

(* Main loop to read and parse user input *)
let rec main_loop () =
  print_endline "Enter 's' to start the game: ";
  match In_channel.input_line In_channel.stdin with
    | None -> print_endline "Error reading input"; main_loop ()
    | Some command -> handle_command command; main_loop ()

(* Entry point for the game *)
let () = main_loop ()
