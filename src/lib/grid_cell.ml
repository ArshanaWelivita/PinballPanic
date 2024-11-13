(* represents the relative position of the cell in the grid *)
type pos = int * int

(* Type representing direction *)
type direction =
  | Up
  | Down
  | Left
  | Right

(* Type representing orientation *)
type orientation =
  | DownRight
  | UpRight

(* Type to represent the grid object type of the cell and its functionality in the grid *)
type grid_cell_type = 
  | Empty 
  | InBallPath 
  | Bumper of {orientation: orientation; direction : direction;} 
  | Tunnel of {orientation: orientation; direction : direction;} 
  | Teleporter 
  | ActivatedBumper of {orientation: orientation; direction : direction; is_active : bool;} 
  | BumperLevelMarker
  | TunnelLevelMarker
  | ActivatedBumperLevelMarker

(* Type to represent each cell in the generated n x n grid for the game and it contains the cell info (is there a grid object, is it 
accessible, is it empty, etc.) *)
type grid_cell = {
    position: pos; (* reletive position of the cell in the grid *)
    cell_type: grid_cell_type; (* the type of grid cell *)
}

