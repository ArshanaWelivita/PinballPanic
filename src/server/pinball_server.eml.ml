open Grid
open Grid_cell
open Lwt.Syntax

let grid_cell id =
  <td class="cell <%s if String.(id = "00") then "selected" else ""%>" id="<%s id %>" onclick="changeSelectedCell(this)"/>

let table_row id = 
  <tr id="<%s id %>">
    (* TODO: Implement *)
  </tr>

let render _ =
  <html>
  <head>
    <script>
    let level_num = 1;
    function new_level {
      reset_grid();
    }

    (* Listen to user input, and check if answer is correct *)
    document.addEventListener('keydown', function(event) {
      let coords = getSelectedCellCoords();
      let row = parseInt(coords[0]);
      let col = parseInt(coords[1]);

      if (isCorrect(row, col)) {level += 1;}
      else {endGame(level, correct_answer);}
    })
    </script>
  </head>

  <body>
    <div class="container">
      <div class="grid">
        <table class="pinballgrid">
        (* TODO: create grid *)
        </table>
      </div>
      <div class="right-container">
        <div class="level-container">
          <%s! "Level:" level %>
    </div>
    <div class="new-game-container">
      <%s! new_game_area () %>
    </div> 
    </div>
  
    </div>
  </body>

  </html>

let parse_generate_level _ =
  (* TODO: function displays grid, disappears after 3 seconds and replaces with empty grid *)

let parse_input _ =
  (* TODO: use input parsing from pinball_panic.ml as inspiration *)


let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
     [
       Dream.get "/" (fun _ -> Dream.html (render ()));
       get_api "generate level" parse_generate_level;
       get_api "input" parse_input;
     ]