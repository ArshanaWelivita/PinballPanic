type pos = int * int

type grid_cell_type = 
  | Empty
  | InBallPath
  | Bumper of {orientation: Bumper.orientation}
  | Tunnel of {orientation: Tunnel.orientationTunnel}
  | Teleporter 
  | ActivatedBumper of {orientation: Activated_bumper.orientation; is_active : bool}

type grid_cell = {
  pos: pos;
  cell_type: grid_cell_type;
}