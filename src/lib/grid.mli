(* Functor for the grid where we have module type for every single object inside the grid (rn only implementing bumpers)
This is all for the command-line ascii implementation

Module type: grid
- type n (row and col are the same as it is a square sized grid)
- type entry_pos (where the ball starts initially in grid where it is outside the grid bounds )
(grid extension start at 0,0 where the actual grid bounds starts at (1,1) so all row cols have an offset of index 1 where
 there is an blank row/col perimeter axes of the grid so that we don't need to do negative numbers for the entry position
 so our generated grid is going to be 1 larger than the actual size of the grid)
 - have a set limit on the number of bumpers in each row is at most n/2 so we don't end up generating rows which are full of bumpers by accident
 - have a hard-coded number of bounces for every level and it is: 
    {   1: (3, 1, 1), 
        2: (4, 1, 2), 
        3: (4, 2, 3), 
        4: (4, 3, 4),
        5: (5, 4, 5),
        6: (5, 5, 6),
        7: (6, 6, 8),
        8: (7, 7, 9),
        9: (7, 8, 10),
        10: (8, 9, 12)
                        }
    - where it is organized like {level: (grid size, min bounces, max bounces)

 - function: out_of_bounds_check(current ball position)
        - checks if any part of the [row, col] index is greater than n or < 1 which tells us that the ball has exited the grid 
        - we can use this to compare the actual end position with the user input end position to decide whether they succeeded and moved to next level or game over/highest level reached

- function: generate_grid() 
        - use Core.random to generate the initial bumper position and generate the grid from that position onwards
        - when we generate the bumper, we determine the positional movement of the ball and generate another bumper within that same row using Core.random over a specified range of numbers 
        - check if the bumpers generated matches the range of min/max bumpers needed for each level
        - return the generated grid object to the main file and return a separate end position which determines where the ball exits 
        - depending on level of the game, get bumpers closer to min or max in the range where rule of thumb is after level 5 should always be > n/2

For testing, have an idea of a game player and testing the grid-size, and the bounces alone 
- function: randomization function to actually 

Make a functor from grid module type (all the way at the end - not priority right now)
--> for future, may need ball type to show the visual movement of the ball through the grid

*)
open Grid_cell

(* represents the actual pinball game grid *)
type grid = grid_cell array array 

(* Define a position as a tuple of integers *)
type pos = int * int

(* Function to fetch the specified grid size, minimum grid objects, maximum grid objects and grid object type list for a specific level depending on the level the user is in
   Returns the grid size, minimum grid objects,  maximum grid objects and list of grid object types for that level *)
val get_level_settings : int -> int * int * int * grid_cell_type list 

(* Function to fetch the grid size given the current level
   Returns grid size n for a square grid *)
val get_grid_size : int -> int

(* Function to check if the ball has gone outside the bounds of the grid and if it *)
val out_of_bounds_check : pos -> int -> bool

val get_cell : grid -> int -> int -> grid_cell

val move : pos -> Bumper.direction -> pos

val compare_pos : pos -> pos -> bool

val compare_orientation : Bumper.orientation -> Bumper.orientation -> bool

val is_activated_bumper_active : pos


val place_initial_bumper : grid_cell array array -> pos -> grid_cell.cell_type.direction -> int -> grid_cell pos * orientation

(* Function that convert the activated bumper to an ordinary bumper if the activated bumper is now active. So now at that position
   there would exist an ordinary bumper *)
val convert_activated_to_regular_bumper: pos -> grid

(*
val orientation_for_direction : direction -> orientation

val simulate_ball_path : int array array -> pos -> direction -> int -> int -> orientation -> (pos * direction) Set.Poly.t -> int -> pos

(* Function to generate a grid for a given level
   Returns a matrix (2D array) representing the grid with bumpers 
   and the exit position of the ball *)
val generate_grid : int -> int array array * pos * pos * Bumper.direction *)


| - - | <-
- - - - 
- - - -
- - - -