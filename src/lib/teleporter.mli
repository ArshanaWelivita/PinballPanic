(* Note: we cannot define more information here because the teleporter has no knowledge
the location of the other teleporter and vice-versa. Implementation of the teleportation
mechanics will occur in the grid.ml and grid.mli files. *)

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