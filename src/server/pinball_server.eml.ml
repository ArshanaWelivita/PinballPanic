open Core
open Grid_cell
(* open Lwt.Syntax *)

(* Game state information *)
let current_level = ref 1
type answer = {x : int ref; y : int ref}
let current_answer = { x = ref 0; y = ref 0}

(* Render the HTML grid based on a grid data structure *)
let render_grid (grid : Grid.grid) : string =
  let num_cols = Array.length grid.(0) in

  (* Generate column headers *)
  let col_headers =
    let header_cells = Array.init num_cols ~f:(fun i -> Printf.sprintf "<th>%d</th>" i) in
    "<tr><th></th>" ^ String.concat ~sep:"" (Array.to_list header_cells) ^ "</tr>\n"
  in

  (* Generate rows with row numbers *)
  let rows =
    Array.mapi grid ~f:(fun i row ->
      let row_cells =
        Array.map row ~f:(fun cell ->
          match to_string cell with 
          | "Entry" -> "<td class='entry'>E</td>"
          | "Exit" -> "<td class='exit'> </td>"
          | "Empty" -> "<td class='empty'> </td>"
          | "InBallPath" -> "<td class='empty'> </td>"
          | "Bumper" -> "<td class='bumper'>" ^ (get_bumper_orientation_string cell.cell_type) ^ "</td>"
          | "Tunnel" -> "<td class='tunnel'>" ^ (get_tunnel_orientation_string cell.cell_type) ^ "</td>"
          | "Teleporter" -> "<td class='teleporter'>*</td>"
          (* 
          | "ActivatedBumper" *)
          | _ -> failwith "Error: there shouldn't be any other grid cell type string within the grid other than the ones matched above."
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

(* Generate a new level and return it as a Dream HTML response *)
let generate_level _ =
  let (grid, _, end_pos, _) = Grid.generate_grid !current_level in
  (* Store answer for later *)
  (current_answer.x) := snd end_pos;
  (current_answer.y) := fst end_pos;
  (* Generate grid HTML *)
  let grid_html = render_grid grid in
  Lwt.return ("<div id='grid-container'>" ^ grid_html ^ "</div>")

(* Render the main page, displays and hides grid when new level starts *)
let render_main_page () =
  let html_template = In_channel.read_all "./server_templates/main_page.html" in
  let current_level_str = string_of_int !current_level in
  String.substr_replace_all html_template ~pattern:"{{current_level}}" ~with_:current_level_str


(* Handle answer submission*)
let submit_answer_handler request =
  (* Log for debugging *)
  Dream.log "Query parameters: x=%s, y=%s"
    (Option.value ~default:"missing" (Dream.query request "x"))
    (Option.value ~default:"missing" (Dream.query request "y"));
  Dream.log "Correct answer: x=%i, y=%i"
    (!(current_answer.x))
    (!(current_answer.y));
  (* Extract the "x" and "y" query parameters *)
  match (Dream.query request "x", Dream.query request "y") with
  | (Some x_value, Some y_value) -> (
      try
        (* Convert query values to integers *)
        let x = int_of_string x_value in
        let y = int_of_string y_value in
        (* Validate the answer *)
        let is_correct = x = !(current_answer.x) && y = !(current_answer.y) in
        if is_correct then (
          if !current_level < 13 then (
            incr current_level;
            Dream.redirect request "/"
          ) else
            Dream.html "<h1>Congratulations! You completed all levels!</h1>"
        ) else
          Dream.html "<h1>Incorrect! Game Over!</h1>"
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
         Dream.get "/" (fun _ -> Dream.html (render_main_page ()));
         Dream.get "/generate-level" (fun _ -> let%lwt grid_html = generate_level () in Dream.html grid_html);
         Dream.get "/submit-answer" submit_answer_handler ;
       ]
