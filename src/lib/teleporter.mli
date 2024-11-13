(*** kenneth add explanation why we cant define more studd and this needs to be handled in grid mli *)

(* Type representing a position on the grid *)
type pos = int * int

(* Type representing direction *)
type teleporterDirection =
  | Up
  | Down
  | Left
  | Right
    
(* Function to generate the output direction of the ball based on a ball's initial direction
when it enters the teleporter. Specifically the direction is conserved. *)
val generate_directions : teleporterDirection -> teleporterDirection 