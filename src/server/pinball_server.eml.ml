open Core
open Grid_cell

(* Game state information *)
let current_level = ref 1

(* Render the HTML grid based on a grid data structure *)
let render_grid (grid : Grid.grid) : string =
  (* Convert a row to an HTML string *)
  let row_to_html (row : grid_cell array) =
    Array.map row ~f:(fun cell ->
      match cell.cell_type with
      | Empty -> "<td class='empty'>*</td>"
      | Bumper { direction = _; orientation } ->
          let symbol = match orientation with
            | DownRight -> "╲"
            | UpRight -> "╱"
            | _ -> failwith "Bumper can only be downright or upright in orientation."
          in
          "<td class='bumper'>" ^ symbol ^ "</td>"
      | Entry { direction = Down } -> "<td class='entry'>o</td>"
      | _ -> "<td class='unknown'>?</td>"
    )
    |> Array.to_list
    |> String.concat
  in
  (* Convert the entire grid to an HTML table *)
  Array.map grid ~f:(fun row -> "<tr>" ^ row_to_html row ^ "</tr>")
  |> Array.to_list
  |> String.concat

(* Generate new level and return it as a string *)
let generate_level _ =
  let grid = Array.init 5 ~f:(fun x -> Array.init 5 ~f:(fun y -> { position = (x,y); cell_type = Empty })) in
  grid.(0).(2) <- {position = (0, 2); cell_type = Entry {direction = Down}};
  grid.(2).(2) <- {position = (2, 2); cell_type = Bumper {direction = Down; orientation = UpRight}};
  (* let grid = Grid.create_test_grid () in *)
  let grid_html = render_grid grid in
  ("<div id='grid-container'>" ^ grid_html ^ "</div>"
    ^ "<script>setTimeout(function() { document.getElementById('grid-container').innerHTML = ''; }, 3000);</script>")

(* Main page render *)
let render_main_page () =
  Printf.sprintf
    {|
    <!DOCTYPE html>
    <html>
    <head>
      <title>Pinball Panic</title>
      <script>
        function startNewLevel() {
          fetch('/generate-level')
            .then(response => response.text())
            .then(function(html) {
              document.getElementById('grid-container').innerHTML = html;
            });
        }
      </script>
    </head>
    <body>
      <h1>Welcome to Pinball Panic</h1>
      <h2>Level %d</h2>
      <div id='grid-container'></div>
      <button onclick='startNewLevel()'>Start New Level</button>
      <form action='/submit-answer' method='POST'>
        <label for='answer'>Your Answer:</label>
        <input type='text' id='answer' name='answer' required />
        <button type='submit'>Submit</button>
      </form>
    </body>
    </html>
    |}
    !current_level

let submit_answer_handler request =
  let body = Dream.body request in
  let is_correct = (* TODO: Replace this with logic to validate the answer *) true in
  if is_correct then (
    (* Check if there is a next level *)
    if !current_level < 10 then (
      incr current_level;
      Lwt.return (Dream.redirect request "/")
    ) else
      Lwt.return (Dream.html "<h1>Congratulations! You completed all levels!</h1>")
  ) else
    (* Incorrect answer, tell user the correct answer *)
    Lwt.return (Dream.html "<h1>Incorrect! The correct answer was ___</h1>")

(* Dream Routes *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (render_main_page ()));
         Dream.get "/generate-level" (fun _ -> Dream.html (generate_level ()));
         Dream.post "/submit-answer" submit_answer_handler;
       ]