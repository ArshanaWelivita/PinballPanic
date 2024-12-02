open Core
open Grid_cell
(* open Lwt.Syntax *)

(* Game state information *)
let current_level = ref 1
type answer = {x : int ref; y : int ref}
let current_answer = { x = ref 0; y = ref 0}

(* Render the HTML grid based on a grid data structure *)
let render_grid (grid : Grid.grid) : string =
  (* Convert a row to an HTML string *)
  let row_to_html (row : grid_cell array) =
    Array.map row ~f:(fun cell ->
      match to_string cell with 
        | "Entry" -> "  E  " 
        | "Exit" -> "  X  " 
        | "Empty" -> "  -  " 
        | "InBallPath" -> "  -  " 
        | "Bumper" -> get_bumper_orientation_string cell.cell_type
        | "Tunnel" -> get_tunnel_orientation_string cell.cell_type
        (* 
        | "Teleporter"
        | "ActivatedBumper" *)
        | _ -> failwith "Error: there shouldn't be any other grid cell type string within the grid other than the ones matched above."
    )
    |> Array.to_list
    |> String.concat ~sep:"\n"
  in
  (* Convert the entire grid to an HTML table *)
  Array.map grid ~f:(fun row -> "<br>\n" ^ row_to_html row ^ "\n</br>")
  |> Array.to_list
  |> String.concat ~sep:"\n"

(* Generate a new level and return it as a Dream HTML response *)
let generate_level _ =
  let (grid, _, end_pos, _) = Grid.generate_grid !current_level in
  (* Store answer for later *)
  (current_answer.x) := fst end_pos;
  (current_answer.y) := snd end_pos;
  (* Generate grid HTML *)
  let grid_html = render_grid grid in
  Lwt.return ("<div id='grid-container'>" ^ grid_html ^ "</div>")

(* Render the main page, displays and hides grid when new level starts *)
let render_main_page () =
  In_channel.read_all "./server_templates/main_page.html"

(* Handle answer submission *)
let submit_answer_handler request =
  (* let* body = Dream.body request in *)
  let is_correct = (* TODO: fetch user input answer *)
    ((!(current_answer.x) = 4) && (!(current_answer.y) = 4))
  in
  if is_correct then (
    if !current_level < 10 then (
      incr current_level;
      Dream.redirect request "/"
    ) else
      Dream.html "<h1>Congratulations! You completed all levels!</h1>"
  ) else
    Dream.html "<h1>Incorrect! Game Over!</h1>"

(* Dream Routes *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (render_main_page ()));
         Dream.get "/generate-level" (fun _ -> let%lwt grid_html = generate_level () in Dream.html grid_html);
         Dream.post "/submit-answer" submit_answer_handler;
       ]
