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

(* let is_it_active (ball_pos: pos) (activated_bumper_pos: pos) : bool =
  true *)