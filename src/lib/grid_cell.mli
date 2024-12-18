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
  | ActivatedBumper of {orientation: orientation; direction : direction; is_active : bool; revisit : int} 
  (* directional bumper which bounces ball in specific direction depending on the ball's original direction *)
  | DirectionalBumper of {orientation: orientation; direction : direction;} 
  (* used for marking the bumpers in the level settings since we don't want to initialize it with a direction 
  or orientation *)
  | BumperLevelMarker 
  (* used for marking the tunnels in the level settings since we don't want to initialize it with a direction 
  or orientation *)
  | TunnelLevelMarker
  (* used for marking the activated bumpers in the level settings since we don't want to initialize it with a direction, 
  orientation or activation status *)
  | ActivatedBumperLevelMarker
  (* used for marking the teleporters in the level settings since we don't want to initialize it with a direction *)
  | TeleporterLevelMarker
  (* used for marking the directional bumpers in the level settings since we don't want to initialize it with a direction
  or orientation *)
  | DirectionalBumperLevelMarker

(* Type to represent each cell in the generated n x n grid for the game and it contains the cell info (is there a grid object, is it 
accessible, is it empty, etc.) *)
type grid_cell = {
    position: pos; (* relative position of the cell in the grid *)
    cell_type: grid_cell_type; (* the type of grid cell *)
}

(* Function to convert the orientation to a string value *)
val orientation_to_string : orientation -> string 

(* Function to compare the cell type of a grid_cell and a grid_cell_type object *)
val compare_grid_cell_type : grid_cell -> grid_cell_type -> bool

(* Function to convert a tunnel object's direction to a normal direction *)
val tunnel_direction_to_direction : Tunnel.direction -> direction 

(* Function to convert a normal direction to a tunnel object's direction *)
val direction_to_tunnel_direction : direction -> Tunnel.direction 

(* Function to convert a normal direction to a bumper object's direction *)
val direction_to_bumper_direction : direction -> Bumper.direction 

(* Function to convert a normal direction to an directional bumper object's direction *)
val direction_to_directional_bumper_direction : direction -> Directional_bumper.direction 

(* Function to convert a normal direction to an activated bumper object's direction *)
val direction_to_activated_bumper_direction : direction -> Activated_bumper.direction 

(* Function to convert a normal orientation to a tunnel object's orientation *)
val orientation_to_tunnel_orientation : orientation -> Tunnel.orientationTunnel 

(* Function to convert a normal orientation to a bumper object's orientation *)
val orientation_to_bumper_orientation : orientation -> Bumper.orientation

(* Function to convert a normal orientation to a directional bumper object's orientation *)
val orientation_to_directional_bumper_orientation : orientation -> Directional_bumper.orientation

(* Function to convert a normal orientation to an activated bumper object's orientation *)
val orientation_to_activated_bumper_orientation : orientation -> Activated_bumper.orientation

(* Function to convert a bumper object's direction to a normal direction *)
val bumper_direction_to_direction : Bumper.direction -> direction 

(* Function to convert a grid cell object to its string representation *)
val to_string : grid_cell -> string

(* Function to convert a bumper's orientation to its string representation *)
val get_bumper_orientation_string : grid_cell_type -> string

(* Function to convert a tunnel's orientation to its string representation *)
val get_tunnel_orientation_string : grid_cell_type -> string

(* Function to check if a given grid_cell_type is a teleporter_marker *)
val is_teleporter_marker : grid_cell_type -> bool

val activated_bumper_direction_to_direction : Activated_bumper.direction -> direction 

val directional_bumper_direction_to_direction : Directional_bumper.direction -> direction

val get_activated_bumper_orientation_string : grid_cell_type -> string

val get_directional_bumper_orientation_string : grid_cell_type -> string

val is_activated_bumper : grid_cell -> bool

val is_activated_bumper_marker : grid_cell_type -> bool