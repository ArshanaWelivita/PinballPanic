open Core

(* Type representing a position on the grid *)
type pos = int * int

type is_active = bool

(* Type representing orientation *)
type orientation =
  | DownRight  (* corresponds to '⧅' *)
  | UpRight    (* corresponds to '⧄' *)

(* Type representing direction *)
type direction =
  | Up
  | Down
  | Left
  | Right

(* Type that maps the input direction to the output direction *)
type direction_map = (direction, direction) Map.Poly.t

(* Function to generate direction mappings based on a bumper's orientation *)
val generate_directions : orientation -> direction_map


