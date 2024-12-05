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
  | Vertical
  | Horizontal
  | None

(* Type to represent the grid object type of the cell and its functionality in the grid *)
type grid_cell_type = 
  (* entry position of the ball into the grid *)
  | Entry of {direction : direction}
  (* exit position of the ball out of the grid *)
  | Exit of {direction : direction}
  (* doesn't have a grid object in this cell *)
  | Empty 
  (* when generation grid objects, need to make sure we don't add a grid object in this position as it is in the path 
  of the ball which already has two grid objects in the same columm/row *)
  | InBallPath 
  (* ordinary bumper which bounces ball in perpendicular direction *)
  | Bumper of {orientation: orientation; direction : direction;} 
  (* goes directly through the tunnel if the ball direction is the same 
  orientation as the tunnel otherwise the ball bounces in the opposite direction of the path it was going in *)
  | Tunnel of {orientation: orientation ; direction : direction;} 
  (* it always exists as a pair (we always have 2 teleporter objects) and either teleporter can be used as an 
  entry/exit position where the direction the ball is moving in is preserved *)
  | Teleporter of {orientation: orientation; direction: direction}
  (* allow for the ball to pass through ONCE, before it materializes into a regular bumper and has the same
   functionality as a bumper *)
  | ActivatedBumper of {orientation: orientation; direction : direction; is_active : bool;} 
  (* used for marking the bumpers in the level settings since we don't want to initialize it with a direction 
  or orientation *)
  | BumperLevelMarker 
  (* used for marking the tunnels in the level settings since we don't want to initialize it with a direction 
  or orientation *)
  | TunnelLevelMarker
  (* used for marking the activated bumpers in the level settings since we don't want to initialize it with a direction, 
  orientation or activation status *)
  | ActivatedBumperLevelMarker
  | TeleporterLevelMarker

(* Type to represent each cell in the generated n x n grid for the game and it contains the cell info (is there a grid object, is it 
accessible, is it empty, etc.) *)
type grid_cell = {
    position: pos; (* relative position of the cell in the grid *)
    cell_type: grid_cell_type; (* the type of grid cell *)
}

(* Function to converts the orientation to a string value *)
val orientation_to_string : orientation -> string 

val compare_grid_cell_type : grid_cell -> grid_cell_type -> bool

val tunnel_direction_to_direction : Tunnel.direction -> direction 

val direction_to_tunnel_direction : direction -> Tunnel.direction 

val direction_to_bumper_direction : direction -> Bumper.direction 

val direction_to_activated_bumper_direction : direction -> Activated_bumper.direction 

val orientation_to_tunnel_orientation : orientation -> Tunnel.orientationTunnel 

val orientation_to_bumper_orientation : orientation -> Bumper.orientation

val orientation_to_activated_bumper_orientation : orientation -> Activated_bumper.orientation

val bumper_direction_to_direction : Bumper.direction -> direction 

val to_string : grid_cell -> string

val get_bumper_orientation_string : grid_cell_type -> string

val get_tunnel_orientation_string : grid_cell_type -> string

val is_teleporter_marker : grid_cell_type -> bool