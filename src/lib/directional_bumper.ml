open Core

type pos = int * int

type orientation =
  | DownRight
  | UpRight

let orientation_to_string (orientation : orientation) : string =
  match orientation with
  | DownRight -> "DownRight"
  | UpRight -> "UpRight"

type direction =
  | Up
  | Down
  | Left
  | Right

type direction_map = (direction, direction) Map.Poly.t

let generate_directions orientation : direction_map =
  match orientation with
    | DownRight -> (* ◹ *)
      Map.Poly.of_alist_exn [
        (Right, Down);
        (Up, Left);
        (Left, Left);
        (Down, Down);
      ]
    | UpRight -> (* ◸ *)
      Map.Poly.of_alist_exn [
        (Right, Right);
        (Down, Down);
        (Left, Down);
        (Up, Right);
      ]
