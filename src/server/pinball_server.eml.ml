open Core
open Grid_cell
(* open Lwt.Syntax *)

(* Game state information *)
let current_level = ref 1
type answer = {col : int ref; row : int ref}
let current_answer = { col = ref 0; row = ref 0}

(* Render the HTML grid based on a grid data structure *)
let render_grid (grid : Grid.grid) : string =
  let num_cols = Array.length grid.(0) in
  let num_rows = Array.length grid in

  (* Check if a cell is part of the grid's perimeter *)
  let is_on_perimeter i j =
    i = 0 || i = num_rows - 1 || j = 0 || j = num_cols - 1
  in

  (* Generate column headers *)
  let col_headers =
    let header_cells = Array.init num_cols ~f:(fun i -> Printf.sprintf "<th>%d</th>" i) in
    "<tr><th></th>" ^ String.concat ~sep:"" (Array.to_list header_cells) ^ "</tr>\n"
  in

  (* Check if entrance and exit are in the same position *)

  (* Generate rows with row numbers *)
  let rows =
    Array.mapi grid ~f:(fun i row ->
      let row_cells =
        Array.mapi row ~f:(fun j cell ->
          let cell_class =
            if is_on_perimeter i j then "outer-square" else "regular-square"
          in
          match to_string cell with
          | "Entry" -> "<td class='entry'>E</td>"
          | "Exit" -> "<td class='" ^ cell_class ^ "'></td>"
          | "Empty" -> "<td class='" ^ cell_class ^ "'></td>"
          | "InBallPath" -> "<td class='path'></td>"
          | "Bumper" -> "<td class='bumper dynamic'>" ^ (get_bumper_orientation_string cell.cell_type) ^ "</td>"
          | "ActivatedBumper" -> "<td class='activatedBumper dynamic'>" ^ (get_activated_bumper_orientation_string cell.cell_type) ^ "</td>"
          | "Tunnel" -> "<td class='tunnel dynamic'>" ^ (get_tunnel_orientation_string cell.cell_type) ^ "</td>"
          | "Teleporter" -> "<td class='teleporter dynamic'>*</td>"
          | _ -> failwith "Unexpected grid cell type."
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
  (* Check if grid is revealed *)
  (* let revealed = 
    match Dream.query request "revealed" with
    | Some "true" -> true
    | _ -> false
  in *)
  let (grid, _, end_pos, _) = Grid.generate_grid !current_level in
  (* Store answer for later *)
  (current_answer.col) := snd end_pos;
  (current_answer.row) := fst end_pos;
  (* Generate grid HTML *)
  let grid_html = render_grid grid in
  Dream.html ("<div id='grid-container'>" ^ grid_html ^ "</div>")

(* Render the main page, displays and hides grid when new level starts *)
let render_main_page () =
  let html_template = In_channel.read_all "src/server/server_templates/main_page.html" in
  let current_level_str = string_of_int !current_level in
  String.substr_replace_all html_template ~pattern:"{{current_level}}" ~with_:current_level_str

(* Handle answer submission*)
let submit_answer_handler request =
  (* Log for debugging *)
  Dream.log "Query parameters: col=%s, row=%s"
    (Option.value ~default:"missing" (Dream.query request "col"))
    (Option.value ~default:"missing" (Dream.query request "row"));
  Dream.log "Correct answer: col=%i, row=%i"
    (!(current_answer.col))
    (!(current_answer.row));
  (* Extract the "col" and "row" query parameters *)
  match (Dream.query request "col", Dream.query request "row") with
  | (Some col_value, Some row_value) -> (
      try
        (* Convert query values to integers *)
        let col = int_of_string col_value in
        let row = int_of_string row_value in
        (* Validate the answer *)
        let is_correct = col = !(current_answer.col) && row = !(current_answer.row) in
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
         Dream.get "/generate-level" generate_level;
         Dream.get "/submit-answer" submit_answer_handler;
       ]
