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
  | Entry of {direction : direction}
  | Exit of {direction : direction}
  | Empty 
  | InBallPath 
  | Bumper of {orientation: orientation; direction : direction;} 
  | Tunnel of {orientation: orientation; direction : direction;} 
  | Teleporter of {orientation: orientation; direction: direction}
  | ActivatedBumper of {orientation: orientation; direction : direction; is_active : bool;} 
  | DirectionalBumper of {orientation: orientation; direction: direction}
  | BumperLevelMarker
  | TunnelLevelMarker
  | ActivatedBumperLevelMarker
  | TeleporterLevelMarker
  | DirectionalBumperLevelMarker

(* Type to represent each cell in the generated n x n grid for the game and it contains the cell info (is there a grid object, is it 
accessible, is it empty, etc.) *)
type grid_cell = {
    position: pos; (* reletive position of the cell in the grid *)
    cell_type: grid_cell_type; (* the type of grid cell *)
}

let orientation_to_string (orientation : orientation) : string =
  match orientation with
  | DownRight -> "DownRight"
  | UpRight -> "UpRight"
  | Vertical -> "Vertical"
  | Horizontal -> "Horizontal"
  | None -> "None"

let compare_grid_cell_type (a: grid_cell) (b: grid_cell_type) : bool =
  match (a.cell_type, b) with
  | Empty, Empty -> true
  | InBallPath, InBallPath -> true
  | Teleporter t1, Teleporter t2 -> 
      t1.orientation = t2.orientation (*t1.direction = t2.direction && *)
  | Bumper b1, Bumper b2 -> 
      b1.orientation = b2.orientation && b1.direction = b2.direction
  | ActivatedBumper ab1, ActivatedBumper ab2 -> 
      ab1.orientation = ab2.orientation &&
      ab1.direction = ab2.direction &&
      ab1.is_active = ab2.is_active
  | Tunnel t1, Tunnel t2 -> 
      t1.orientation = t2.orientation && t1.direction = t2.direction
  | Entry { direction = d1 }, Entry { direction = d2 } -> 
    d1 = d2
  | Exit { direction = d1 }, Exit { direction = d2 } -> 
      d1 = d2
  |_, _ -> false

let tunnel_direction_to_direction (dir: Tunnel.direction) : direction =
  match dir with
  | Tunnel.Up -> Up
  | Tunnel.Down -> Down
  | Tunnel.Left -> Left
  | Tunnel.Right -> Right

let direction_to_tunnel_direction (dir: direction) : Tunnel.direction =
  match dir with
  | Up -> Tunnel.Up
  | Down -> Tunnel.Down
  | Left -> Tunnel.Left
  | Right -> Tunnel.Right

let direction_to_bumper_direction (dir: direction) : Bumper.direction =
  match dir with
  | Up -> Bumper.Up
  | Down -> Bumper.Down
  | Left -> Bumper.Left
  | Right -> Bumper.Right

let direction_to_activated_bumper_direction (dir: direction) : Activated_bumper.direction =
  match dir with
  | Up -> Activated_bumper.Up
  | Down -> Activated_bumper.Down
  | Left -> Activated_bumper.Left
  | Right -> Activated_bumper.Right

let direction_to_directional_bumper_direction (dir: direction) : Directional_bumper.direction =
  match dir with
  | Up -> Directional_bumper.Up
  | Down -> Directional_bumper.Down
  | Left -> Directional_bumper.Left
  | Right -> Directional_bumper.Right

let orientation_to_tunnel_orientation (orientation: orientation) : Tunnel.orientationTunnel =
  match orientation with
  | Vertical -> Tunnel.Vertical
  | Horizontal -> Tunnel.Horizontal
  | _ -> failwith "Wrong orientation for the tunnel grid object type."

let orientation_to_bumper_orientation (orientation: orientation) : Bumper.orientation =
  match orientation with
  | UpRight -> Bumper.UpRight
  | DownRight -> Bumper.DownRight
  | _ -> failwith "Wrong orientation for the bumper grid object type."

let orientation_to_directional_bumper_orientation (orientation: orientation) : Directional_bumper.orientation =
  match orientation with
  | UpRight -> Directional_bumper.UpRight
  | DownRight -> Directional_bumper.DownRight
  | _ -> failwith "Wrong orientation for the bumper grid object type."

let orientation_to_activated_bumper_orientation (orientation: orientation) : Activated_bumper.orientation = 
  match orientation with
  | UpRight -> Activated_bumper.UpRight
  | DownRight -> Activated_bumper.DownRight
  | _ -> failwith "Wrong orientation for the activated bumper grid object type."

let bumper_direction_to_direction (dir: Bumper.direction) : direction =
  match dir with
  | Bumper.Up -> Up
  | Bumper.Down -> Down
  | Bumper.Left -> Left
  | Bumper.Right -> Right

let activated_bumper_direction_to_direction (dir: Activated_bumper.direction) : direction =
  match dir with
  | Activated_bumper.Up -> Up
  | Activated_bumper.Down -> Down
  | Activated_bumper.Left -> Left
  | Activated_bumper.Right -> Right

let directional_bumper_direction_to_direction (dir: Directional_bumper.direction) : direction =
  match dir with
  | Directional_bumper.Up -> Up
  | Directional_bumper.Down -> Down
  | Directional_bumper.Left -> Left
  | Directional_bumper.Right -> Right
  
let to_string (cell: grid_cell) : string = match cell.cell_type with 
  | Entry _ -> "Entry"
  | Exit _ -> "Exit"
  | Empty -> "Empty" 
  | InBallPath -> "InBallPath"
  | Bumper _ -> "Bumper"
  | Tunnel _ -> "Tunnel"
  | Teleporter _ -> "Teleporter"
  | ActivatedBumper _ -> "ActivatedBumper"
  | DirectionalBumper _ -> "DirectionalBumper"
  | BumperLevelMarker -> "BumperLevelMarker"
  | TunnelLevelMarker -> "TunnelLevelMarker"
  | ActivatedBumperLevelMarker -> "ActivatedBumperLevelMarker"
  | TeleporterLevelMarker -> "TeleporterLevelMarker"
  | DirectionalBumperLevelMarker -> "DirectionalBumperLevelMarker"

let get_bumper_orientation_string (b: grid_cell_type) : string = match b with 
  | Bumper {orientation = DownRight; _} -> "⟍"
  | Bumper {orientation = UpRight; _} -> "⟋"
  | _ -> failwith "Error: bumper can only have orientation DownRight or UpRight."

let get_activated_bumper_orientation_string (b: grid_cell_type) : string = match b with 
  | ActivatedBumper {orientation = DownRight; _} -> "⧅"
  | ActivatedBumper {orientation = UpRight; _} -> "⧄"
  | _ -> failwith "Error: activated bumper can only have orientation DownRight or UpRight."

let get_directional_bumper_orientation_string (b: grid_cell_type) : string = match b with 
| DirectionalBumper {orientation = DownRight; _} -> "◹"
| DirectionalBumper {orientation = UpRight; _} -> "◸"
| _ -> failwith "Error: activated bumper can only have orientation DownRight or UpRight."

let get_tunnel_orientation_string (b: grid_cell_type) : string = match b with 
  | Tunnel {orientation = Vertical; _} -> "𝄁"
  | Tunnel {orientation = Horizontal; _} -> "="
  | _ -> failwith "Error: bumper can only have orientation DownRight or UpRight."

let is_teleporter_marker (cell_type: grid_cell_type) : bool = match cell_type with 
  | TeleporterLevelMarker -> true
  | _ -> false

let is_activated_bumper (cell: grid_cell) : bool = match cell.cell_type with 
  | ActivatedBumper {is_active = true; _ } -> true
  | _ -> false

let is_activated_bumper_marker (cell_type: grid_cell_type) : bool = match cell_type with 
  | ActivatedBumperLevelMarker -> true
  | _ -> false