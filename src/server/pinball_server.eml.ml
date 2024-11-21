open Grid
open Grid_cell
open Lwt.Syntax


let render _ =
  <html>
  <head>
    (* <script>
    let level_num = 1;
    function new_level {
      reset_grid();
    }

    (* Add javascript timer here *)

    (* Listen to user input, and check if answer is correct *)

    </script> *)
  </head>

  <body>
    (* Div box for game name *)
    <div class="game name">
      <%s! "Pinball Panic" %>
    </div>

    (* Div box for the grid *)
    <div class="container">
      <div class="grid">
        <table class="pinballgrid">
        (* TODO: display grid *)
        </table>
      </div>
      <div class="right-container">
        <div class="level-container">
          <%s! "Level:" level %>
    </div>

    (* Button to start a new game *)
    <div class="new-game-container">
      <%s! new_game_area () %>
    </div> 

    (* Form to handle user inputted answer *)
    </div>
    <form>
      <label for="x coordinate">x:</label><br>
      <input type="text" id="x" name="x"><br>
      <label for="y coordinate">y:</label><br>
      <input type="text" id="x" name="x">
    </form>
    </div>

  </body>

  </html>

let parse_generate_level _ =
  (* TODO: function displays grid, disappears after 3 seconds and replaces with empty grid *)

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
     [
       (* TODO: handle different phases of the game *)
       Dream.get "/start" (fun _ -> Dream.html (render ()));
       get_api "generate level" parse_generate_level;
     ]