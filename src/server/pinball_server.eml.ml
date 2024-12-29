open Core
open Grid_cell


(* Game state information *)
let remaining_time = ref 30 (* Initial time in seconds *)
let current_level = ref 1
type answer = {col : int ref; row : int ref}
let current_answer = { col = ref 0; row = ref 0}
let current_entry = { col = ref 0; row = ref 0}


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

let render_grid (grid : Grid.grid) : string =
  let n = Array.length grid.(0) in

  (* Helper function to check if a cell is part of the grid's perimeter *)
  let is_on_perimeter i j =
    i = 0 || i = n - 1 || j = 0 || j = n - 1
  in
  
  (* Generate column headers *)
  let col_headers =
    let header_cells = Array.init n ~f:(fun i -> Printf.sprintf "<th>%d</th>" i) in
    "<tr><th></th>" ^ String.concat ~sep:"" (Array.to_list header_cells) ^ "</tr>\n"
  in

  (* TODO: Fix bug with entry and exit being the same *)
  
  (* Generate rows with clickable cells for the border *)
  let rows =
    Array.mapi grid ~f:(fun i row ->
      let row_cells =
        Array.mapi row ~f:(fun j cell ->
          let onClick = Printf.sprintf "submitAnswer(%d, %d)" j i in
          match to_string cell with
          | "Entry" -> Printf.sprintf "<td class='entry' onclick='%s'>E</td>" onClick
          | "Exit" -> Printf.sprintf "<td class='exit' onclick='%s'></td>" onClick
          | "Empty" -> 
            if is_on_perimeter i j
            then Printf.sprintf "<td class='empty' onclick='%s'></td>" onClick
            else Printf.sprintf "<td class='empty'></td>"
          | "InBallPath" -> "<td class='path'></td>"
          | "Bumper" -> "<td class='bumper'>" ^ (get_bumper_orientation_string cell.cell_type) ^ "</td>"
          | "ActivatedBumper" -> "<td class='activatedBumper'>" ^ (get_activated_bumper_orientation_string cell.cell_type) ^ "</td>"
          | "Tunnel" -> "<td class='tunnel dynamic'>" ^ (get_tunnel_orientation_string cell.cell_type) ^ "</td>"
          | "DirectionalBumper" -> "<td class='directionalBumper'>" ^ (get_directional_bumper_orientation_string cell.cell_type) ^ "</td>"
          | "Teleporter" -> "<td class='teleporter'>*</td>"
          | _ -> Printf.sprintf "<td class='object'></td>"
        )
        |> Array.to_list
        |> String.concat
      in
      Printf.sprintf "<tr><th>%d</th>%s</tr>" i row_cells
    )
    |> Array.to_list
    |> String.concat ~sep:"\n"
  in
  
  (* Combine column headers and rows *)
  "<table class='grid'>\n" ^ col_headers ^ rows ^ "\n</table>"

(* Render the main page, this is where all of the gameplay will occur.
   This page will display and hide the grid when new level begins *)
let render_game_page () =
  let html_template = In_channel.read_all "src/server/server_templates/game_page.html" in
  let current_level_str = string_of_int !current_level in
  let level_message_str = get_level_message !current_level in
  let time_remaining_str = string_of_int !remaining_time in
  let (grid, entry_pos, end_pos, _) = Grid.generate_grid !current_level in
  let grid_html = render_grid grid in

  (* Store entrance and exit positions for later *)
  (current_answer.col) := snd end_pos;
  (current_answer.row) := fst end_pos;
  (current_entry.col) := snd entry_pos;
  (current_entry.row) := fst entry_pos;

  (* Generate HTML for level *)
  String.substr_replace_all
    (String.substr_replace_all 
      (String.substr_replace_all 
        (String.substr_replace_all 
          html_template
          ~pattern:"{{current_level}}" ~with_:current_level_str)
          ~pattern:"{{level_message}}" ~with_:level_message_str)
          ~pattern:"{{grid_html}}" ~with_:grid_html)
          ~pattern:"{{time_remaining}}" ~with_:time_remaining_str

(* Renders the welcome page *)
let render_welcome_page () =
  In_channel.read_all "src/server/server_templates/welcome_page.html"

(* Renders the rules page *)
let render_rules_page () =
  In_channel.read_all "src/server/server_templates/rules_page.html"

(* Handle answer submission*)
let submit_answer_handler request =
  (* Log statements for debugging purposes *)
  Dream.log "Query parameters: col=%s, row=%s"
    (Option.value ~default:"missing" (Dream.query request "x"))
    (Option.value ~default:"missing" (Dream.query request "y"));
  Dream.log "Correct answer: col=%i, row=%i"
    (!(current_answer.col))
    (!(current_answer.row));
  Dream.log "Remaining time: %i seconds"
    !remaining_time;
  (* Extract the "col" and "row" query parameters *)
  match (Dream.query request "x", Dream.query request "y") with
  | (Some x, Some y) -> (
      try
        (* Convert query values to integers *)
        let col = int_of_string x in
        let row = int_of_string y in
        (* Validate the answer *)
        let is_correct = col = !(current_answer.col) && row = !(current_answer.row) in
        if is_correct then (
          remaining_time := !remaining_time + 5; (* Add 5 seconds for correct answers *)
          incr current_level;
          let%lwt _ = Dream.html "<h1>Correct! Generating next level...</h1>" in
          (* let%lwt _ = Lwt_unix.sleep 2.0 in TODO: Briefly show the correct path *)
          Dream.redirect request "/generate-level"
        ) else (
          incr current_level;
          let%lwt _ = Dream.html "<h1>Incorrect! Generating next level...</h1>" in
          (* let%lwt _ = Lwt_unix.sleep 2.0 in TODO: Briefly show the correct path *)
          Dream.redirect request "/generate-level"
        )
      with Failure _ ->
        Dream.html "<h1>Invalid input! Please enter valid numbers for coordinates.</h1>")
  | _ ->
      (* Handle missing query parameters *)
      Dream.html "<h1>Bad Request: Missing query parameters 'x' or 'y'.</h1>"

(* Dream Routes *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun request -> Dream.redirect request "/welcome");  (* Redirect root to welcome page *)
         Dream.get "/welcome" (fun _ -> Dream.html (render_welcome_page ()));
         Dream.get "/rules-page" (fun _ -> Dream.html (render_rules_page ()));
         Dream.get "/generate-level" (fun _ -> Dream.html (render_game_page ()));
         Dream.get "/submit-answer" submit_answer_handler;
       ]
