open Core

type pos = int * int

type orientation =
| TopRight
| TopLeft
| BottomLeft
| BottomRight

let orientation_to_string (orientation : orientation) : string =
  match orientation with
  | TopRight -> "TopRight"
  | TopLeft -> "TopLeft"
  | BottomLeft -> "BottomLeft"
  | BottomRight -> "BottomRight"

type direction =
  | Up
  | Down
  | Left
  | Right

type direction_map = (direction, direction) Map.Poly.t

let generate_directions orientation : direction_map =
  match orientation with
    | TopRight -> (* ◹ *)
      Map.Poly.of_alist_exn [
        (Right, Down);
        (Up, Left);
        (Left, Left);
        (Down, Down);
      ]
    | TopLeft -> (* ◸ *)
      Map.Poly.of_alist_exn [
        (Right, Right);
        (Down, Down);
        (Left, Down);
        (Up, Right);
      ]
    | BottomRight -> (* ◿ *)
      Map.Poly.of_alist_exn [
        (Right, Up);
        (Up, Up);
        (Left, Left);
        (Down, Left);
      ]
    | BottomLeft -> (* ◺ *)
      Map.Poly.of_alist_exn [
        (Right, Right);
        (Down, Right);
        (Left, Up);
        (Up, Up);
      ]
