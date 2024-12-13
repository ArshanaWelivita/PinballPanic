open Core

type pos = int * int
type is_active = bool

type orientation =
  | DownRight  (* corresponds to '⧅' *)
  | UpRight    (* corresponds to '⧄' *)

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

(* let is_it_active (ball_pos: pos) (activated_bumper_pos: pos) : bool =
  true *)