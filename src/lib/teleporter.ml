type pos = int * int

type teleporterDirection =
  | Up
  | Down
  | Left
  | Right
    
let generate_directions (direction: teleporterDirection) : teleporterDirection = 
  match direction with 
    |Up -> Up
    |Down -> Down
    |Right -> Right
    |Left -> Left