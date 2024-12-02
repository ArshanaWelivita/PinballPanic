open Core
open Grid_cell
(* open Lwt.Syntax *)

(* Game state information *)
let current_level = ref 1

(* Render the HTML grid based on a grid data structure *)
let render_grid (grid : Grid.grid) : string =
  (* Convert a row to an HTML string *)
  let row_to_html (row : grid_cell array) =
    Array.map row ~f:(fun cell ->
      match cell.cell_type with
      | Empty -> "<td class='empty'>-</td>"
      | Bumper { direction = _; orientation } ->
          let symbol = match orientation with
            | DownRight -> "╲"
            | UpRight -> "╱"
            | _ -> "/"
          in
          "<td class='bumper'>" ^ symbol ^ "</td>"
      | Entry { direction = Down } -> "<td class='entry'>E</td>"
      | _ -> "<td class='unknown'>?</td>"
    )
    |> Array.to_list
    |> String.concat ~sep:"\n"
  in
  (* Convert the entire grid to an HTML table *)
  Array.map grid ~f:(fun row -> "<tr>\n" ^ row_to_html row ^ "\n</tr>")
  |> Array.to_list
  |> String.concat ~sep:"\n"

(* Generate a new level and return it as a Dream HTML response *)
let generate_level _ =
  let (grid, _, _, _) = Grid.generate_grid !current_level in
  (* Generate grid HTML *)
  let grid_html = render_grid grid in
  Lwt.return ("<div id='grid-container'>" ^ grid_html ^ "</div>")

(* Render the main page, displays and hides grid when new level starts *)
let render_main_page () =
  "<!DOCTYPE html><html><head><title>Pinball Panic</title><script>function startNewLevel() { fetch('/generate-level').then(response => response.text()).then(html => {const container = document.getElementById('grid-container'); container.innerHTML = html; setTimeout(() => {container.innerHTML = '<h2>Prepare your answer!</h2>';}, 3000);}).catch(err => console.error('Error fetching grid:', err));}</script></head><body><h1>Welcome to Pinball Panic</h1><h2>Level " ^ string_of_int !current_level ^ "</h2><div id='grid-container'></div><button onclick=\"startNewLevel()\">Start New Level</button></body></html>"

(* Handle answer submission *)
let submit_answer_handler request =
  (* let* body = Dream.body request in *)
  let is_correct = (* TODO: Replace this with logic to validate the answer *) true in
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
