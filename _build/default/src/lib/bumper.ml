open Core

type pos = int * int

type orientation =
  | DownRight
  | UpRight

type direction =
  | Up
  | Down
  | Left
  | Right

type direction_map = (direction, direction) Map.Poly.t

let generate_directions orientation : direction_map =
  match orientation with
    | DownRight ->
      Map.Poly.of_alist_exn [
        (Right, Down);
        (Up, Left);
        (Left, Up);
        (Down, Right);
      ]
    | UpRight ->
      Map.Poly.of_alist_exn [
        (Right, Up);
        (Down, Left);
        (Left, Down);
        (Up, Right);
      ]
