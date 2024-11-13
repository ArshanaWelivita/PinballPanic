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

(* Type that maps the input direction to the output direction *)
type direction_map = (direction, direction) Map.Poly.t

(* Function to convert the tunnel to a string for printing purposes in the actual game *)
val tunnel_orientation_to_string : orientationTunnel -> string 

(* Function to generate direction mappings based on a tunnel's orientation *)
val generate_directions : orientationTunnel -> direction_map