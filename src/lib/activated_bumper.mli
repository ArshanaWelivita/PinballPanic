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

(* Function to check the ball's position and the activated bumper's position to check if the ball is at the 
  activated bumper's position and if so returns true as the bumper is now activated by the ball passing 
  through its position once. Otherwise returns false.
  It also correctly updates the is_active type which is used in grid.ml to check if the bumper is active or not.
*)
(* val is_it_active : pos -> pos -> bool  *)

