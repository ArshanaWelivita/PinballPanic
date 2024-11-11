open Core

(* Type representing a position on the grid *)
type pos = int * int

(* Type representing orientation *)
type orientationTunnel =
  | Vertical    (* corresponds to '||' *)
  | Horizontal  (* corresponds to '=' *)

(* Type representing direction *)
type direction =
  | Up
  | Down
  | Left
  | Right

val tunnel_orientation_to_string : orientationTunnel -> string 

(* Type that maps the input direction to the output direction *)
type direction_map = (direction, direction) Map.Poly.t

(* Function to generate direction mappings based on a tunnel's orientation *)
val generate_directions : orientationTunnel -> direction_map