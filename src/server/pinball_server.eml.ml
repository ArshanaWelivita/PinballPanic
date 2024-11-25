open Core
open Grid_cell


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
let render_main_page () : string =
    {|
      <!DOCTYPE html>
      <html>
      <head>
        <title>Pinball Panic</title>
        <style>
          /* styles for the grid and containers */
          .pinballgrid td { border: 1px solid black; width: 30px; height: 30px; text-align: center; }
          .empty { background-color: white; }
          .bumper { background-color: yellow; }
        </style>
      </head>
      
      <body>
        <h1>Pinball Panic</h1>
        <div id="game-area">
          <!-- Placeholder for grid -->
          <div id="grid-container"></div>
        </div>
        <button onclick="startNewLevel()">Start New Level</button>
        <script>
          function startNewLevel() {
            fetch('/generate-level')
              .then(response => response.text())
              .then(html => {
                document.getElementById('grid-container').innerHTML = html;
              });
          }
        </script>
      </body>
      </html>
    |}

(* Dream Routes *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html (render_main_page ()));
         Dream.get "/generate-level" (fun _ -> Dream.html (generate_level ()));
       ]