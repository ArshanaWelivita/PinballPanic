open Grid_cell
open Core

(* Type representing the actual pinball game grid *)
type grid = grid_cell array array 

(* Type representing a position as a tuple of integers where it is used to find the position in the grid *)
type pos = int * int

(* Function to retrieve the game settings for a specified level.
   - grid size (int)
   - minimum grid objects (int)
   - maximum grid objects (int)
   - list of grid object types allowed for that level (grid_cell_type list)
 *)
val get_level_settings : int -> int * int * int * (grid_cell_type list)

(* Function to get the grid size (n x n) given the current level.
   Returns grid size n for a square grid 
*)
val get_grid_size : int -> int

(* Function to check if the position is outside the grid bounds.
   - row (int)
   - col (int)
   - grid size (int) 
   Returns true if outside grid, else it returns false.
*)
val out_of_bounds_check : pos -> int -> bool

(* Function to check if the position is within the grid bounds.
   - row (int)
   - col (int)
   - grid size (int)
   Returns true if it is within grid, else it returns false.
*)
val is_within_actual_grid : int -> int -> int -> bool 

(* Function to get a specific cell from the grid given the row and col indices 
   of its position in the grid.
   - row (int)
   - col (int)
   Returns the associated cell in the grid (grid_cell) at that specified grid position.
*)
val get_cell : grid -> int -> int -> grid_cell

(* Function to calculate the next position based off the current position and direction of the ball.
   - current ball position (pos)
   - current ball direction (direction)
   Returns new ball position (pos).
*)
val move : pos -> direction -> pos

(* Function to compare two positions to see if they're pointing to the same position. *)
val compare_pos : pos -> pos -> bool

(* Function to compare two orientations of two grid cell objects to see if they have the same orientation. *)
val compare_orientation : orientation -> orientation -> bool

(* Function to check if the activated bumper grid object is activated and returns true/false.
   - ball position (pos)
   - activated bumper position (pos)
   Calls the is_it_active function in activated_bumper.mli and checks if the positions are the same. 
   Checks the is_active boolean type in activated_bumper.mli bumper directly and returns its boolean value.
*)
(* val is_activated_bumper_active : pos -> pos -> bool  *)

(* Function to convert the orientation of a grid object to string.
   - orientation of grid object (orientation)
   Returns the string value of the orientation.
*)
val string_of_orientation : orientation -> string 

(* Function to convert the direction of a grid object to string.
   - direction of grid object (direction)
   Returns the string value of the direction.
*)
val string_of_direction : direction -> string

(* Function to place an initial grid object on the grid at a specified position and orientation.
   - initial pinball game grid (grid)
   - entry position (pos)
   - entry direction (direction)
   - grid size (int)
   Returns the initial grid object position and orientation (pos * orientation). 
   It directly modifies that position in the grid so the modified grid does not need to be returned.
*)
val place_initial_grid_object : grid -> pos -> direction -> int -> grid_cell_type -> pos * orientation

(* Function that convert the activated bumper to an ordinary bumper if the activated bumper is now active.
   Calls the is_activated_bumper_active to check the state of the activated bumper.
   - activated bumper position (pos)
   - current pinball grid (grid)
   Returns true if the bumper is converted and false otherwise. 
   If the activated bumper is active, changes the bumper to an ordinary one, modifies the grid and returns true as the bumper 
   at that position is now ordinary. Otherwise, it returns false as the activated bumper is still not activated. 
*)
(* val convert_activated_to_regular_bumper : pos -> grid -> bool  *)

(* Function that given the direction the ball is moving in, it randomly selects the orientation of the next grid object.
   - ball direction (direction)
   Returns randomly generated next grid object orientation (orientation).
*)
val orientation_for_direction : (*direction ->*) unit -> orientation

(* Function to get a list of positions ahead of the current path of the ball which can be used to randomly select the position
   where the next grid object is placed.
   - current pinball game grid (grid)
   - ball position in grid (pos)
   - ball direction (direction)
   - grid size (int)
   Returns a list of possible positions for the next grid object to be placed that doesn't affect the previously placed 
   objects or the overall path of the ball. It checks the grid_cell_types of each cell and only returns the positions of the
   cells which have type Empty. 
*)
val collect_positions_along_path : grid -> pos -> direction -> int -> pos list

(* Function to place a grid element randomly in the next eligible position in the ball's path determined 
   by collect_positions_along_path.
   - current pinball grid (grid)
   - current ball position (pos)
   - current ball direction (direction)
   - grid size (int)
   - orientation of the new grid object (orientation) -> this orientation is created from orientation_for_direction function which
   uses the current ball position to determine the next grid object's orientation
   - grid object type (grid_cell_type) - the type of grid object that should be placed in the grid
   Returns true/false.
   Directly modifies the grid in the function and returns true if it was able to place a grid object and false if not.
*)
val place_random_grid_element_along_path : grid -> pos -> direction -> int -> orientation -> grid_cell_type -> unit

(* Function that simulates the ball's path through the grid and places the grid objects dynamically based on the ball's position. 
This function is recursive so it will continue simulating the ball's path and placing the grid objects until it either goes out of bounds 
of the grid, case of infinite bounces between two grid objects or there is a loop detected (keeps visiting the same positions in the grid) and never exits. 
This function also calls place_random_grid_element_along_path as a helper function to place the next grid object in the balls path and continues to simulate
the ball's movement. The function will also return an invalid position if the collect_positions_along_path was not able to place a grid object as that would 
change the affect the accuracy of the grid generated.
   - current pinball grid (grid)
   - current ball position (pos)
   - current ball direction (direction)
   - grid size (int)
   - number of grid objects left to add to the graph (int)
   - orientation of the next grid object (orientation)
   - bounce limit (int) which is used to prevent infinite bounces between two grid objects
   and returns an invalid position to stop generating this ball's path
   - set of visited positions ((pos * direction) Set.Poly.t) which is used to keep track of whether the ball is going in a loop
   Returns the exit position of the ball from the grid. This position could either be a valid exit position or be invalid to represent
   that this simulation was unsuccessful.
*)
val simulate_ball_path : grid -> pos -> direction -> int -> int -> orientation -> int -> (pos * direction) Set.Poly.t -> grid_cell_type list -> pos * direction 

(* Function that takes the level from the pinball_panic.ml file and then creates the specific grid for that level using the 
   specified settings in the get_level_settings function. This function is also recursive and will continue generating grids until it 
   finds a valid grid. 
   This function creates the grid and randomly selects the entry position of the ball from various directions of the grid. It then calls
   the place_initial_grid_object function to place the initial grid object based on the entry position of the ball. It then calls simulate_ball_path
   to generate the rest of the grid dynamically given the entry position and first grid object position. It also gives a maximum number of bounces limit
   which is 10 as a variable into this function.
   A grid is not valid if the exit position returned by the simulate_ball_path function is invalid. Similarly, if the number of grid objects 
   placed in the grid does not meet the minimum required for that level, the grid is not valid. 
   - level (int)
   Returns a viable, valid pinball panic game grid that doesn't cause loops, has no infinite bounces, has a valid exit position and meets
   all the requirements for that specific level. This grid will then be given the the pinball_panic.ml game and then it will generate the grid to be printed
   on the command line.
*)
val generate_grid : int -> grid * pos * pos * direction

(* Function that simulates the ball path post-grid generation. Used for testing purposes. 
   Inputs:
   - Valid pinball panic game grid that doesn't cause loops, has no infinite bounces, and has a valid exit position
   - Starting position of the ball
   - Starting direction of the ball
   - Grid size
   Returns:
   - Tuple of ending position and direction of the ball
*)
val simulate_ball_path_post_generation : grid -> pos -> direction -> int -> pos * direction

val orientation_for_tunnel_direction :(*(direction: direction)*) unit -> orientation