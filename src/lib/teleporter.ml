type pos = int * int

type direction =
  | Up
  | Down
  | Left
  | Right
    
let generate_directions (direction: direction) : direction = 
  match direction with 
    |Up -> Up
    |Down -> Down
    |Right -> Right
    |Left -> Left

