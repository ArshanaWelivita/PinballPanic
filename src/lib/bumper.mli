(* 
Module type: bumper
- needs position and orientation as the input
- type position (which row-col it is in the entire grid)
- type orientation (down_right = '╲' and up_right = '╱')
- function: generate_directions(user input direction)
    - create a map of all possible input and output directions which is returned to the grid module
*)

open Core


type pos = int * int

type orientation = char

val generate_directions : orientation -> Map.t (* TODO: fix *)

