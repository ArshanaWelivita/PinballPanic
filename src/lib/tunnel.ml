open Core

type pos = int * int

type orientationTunnel =
  | Vertical
  | Horizontal

let tunnel_orientation_to_string (orientation : orientationTunnel) : string =
  match orientation with
  | Vertical -> "Vertical"
  | Horizontal -> "Horizontal"

type direction =
  | Up
  | Down
  | Left
  | Right

type direction_map = (direction, direction) Map.Poly.t

let generate_directions (orientation : orientationTunnel) : direction_map =
  match orientation with
    | Vertical ->
      Map.Poly.of_alist_exn [
        (Right, Left);
        (Up, Up);
        (Left, Right);
        (Down, Down);
      ]
    | Horizontal ->
      Map.Poly.of_alist_exn [
        (Right, Right);
        (Down, Up);
        (Left, Left);
        (Up, Down);
      ]
