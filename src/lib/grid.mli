open Grid_cell
open Core

(* Type representing the actual pinball game grid *)
type grid = grid_cell array array 

(* Type representing a position as a tuple of integers where it is used to find the position in the grid *)
type pos = int * int

(* Type representing the settings for a level of the grid as a record type *)
type level_settings = {
  grid_size: int;
  min_objects: int;
  max_objects: int;
  grid_object_types: grid_cell_type list;
  teleporter_objects: int;
  activated_bumper_objects: int;
}

(* Function to retrieve the game settings for a specified level.
   - grid size (int)
   - minimum grid objects (int)
   - maximum grid objects (int)
   - list of grid object types allowed for that level (grid_cell_type list)
   - number of teleporter objects in each level (there can only be 1 teleporter pair per level otherwise the player won't be able to tell which teleporter the ball 
   will exit from when if there are multiple possible exits)
 *)
val get_level_settings : int -> level_settings

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

(* Function that convert the activated bumper to an ordinary bumper if the activated bumper is now active.
   Calls the is_activated_bumper_active to check the state of the activated bumper.
   - activated bumper position (pos)
   - current pinball grid (grid)
   Returns true if the bumper is converted and false otherwise. 
   If the activated bumper is active, changes the bumper to an ordinary one, modifies the grid and returns true as the bumper 
   at that position is now ordinary. Otherwise, it returns false as the activated bumper is still not activated. 
val convert_activated_to_regular_bumper : pos -> grid -> bool  *)

(* Function that randomly selects the orientation of the next grid object that is of type bumper (normal bumper, activated bumper).
   Returns randomly generated next grid object orientation (orientation).
*)
val random_orientation_for_bumper : unit -> orientation

(* Function that randomly selects the orientation of the next grid object that is of type tunnel.
   Returns randomly generated next grid object orientation (orientation).
*)
val random_orientation_for_tunnel : unit -> orientation

(* Function that takes a grid cell object marker and converts it to an actual grid object cell type by marking its properties 
   (e.g. orientation, direction). This will then be used to create a grid cell object directly and place it in the grid. 
   - grid cell type marker (grid_cell_type)
   - direction (direction)
   Returns the new grid cell type with its defined properties.
*)
val get_grid_cell_type : grid_cell_type -> direction -> grid_cell_type

(* Function that goes through all positions in the grid and identifies all potential positions to place the second teleporter object in a teleporter pair. 
   It makes sure that these potential positions are within the bounds of the grid and are not in the same row/col of the first placed 
   teleporter object such that it covers a wider proportion (more likely it is further from the first teleporter object position) of the grid.
   - grid (grid)
   - grid size (int)
   - first teleporter object row (int)
   - first teleporter object column (int)
   Returns a list of (row, col) potential positions in the grid where the second teleporter can be placed.
*)
val get_potential_second_teleporter_positions : grid -> int -> int -> int -> (int * int) list

(* Function to place the second teleporter object in grid after randomly selecting its position from a list of potential 
   positions generated by get_potential_second_teleporter_positions helper method. 
   - grid (grid)
   - first teleporter object position (pos)
   - grid size (int)
   - teleporter direction (direction)
   Returns true if the second teleporter object was placed successfully in the grid. If by chance, there are no potential positions
   in the grid to place the second teleporter object, it returns false. 
*)
val place_second_teleporter_in_grid : grid -> pos -> int -> direction -> bool

(* Helper function to place the initial grid cell object into the grid given the row and col indices and all the properties of the 
   grid object.
   - grid (grid)
   - row (int)
   - col (int)
   - initial grid cell type (grid_cell_type)
   - orientation of grid cell object (orientation)
   Returns the position and orientation of the placed grid cell object in the grid.
*)
val place_initial_grid_object_helper : grid -> int -> int -> grid_cell_type -> orientation -> pos * orientation

(* Function to place an initial grid object in the grid at a randomly generated position along the entry path and direction of the ball into the grid
   with a orientation given the grid object type.
   - initial pinball game grid (grid)
   - entry position (pos)
   - entry direction (direction)
   - grid size (int)
   - new grid cell type (grid_cell_type)
   Returns the initial grid object position and orientation (pos * orientation). 
   It directly modifies that position in the grid so the modified grid does not need to be returned.
*)
val generate_and_place_initial_grid_object : grid -> pos -> direction -> int -> grid_cell_type -> pos * orientation

(* Function to get a list of positions ahead of the current path of the ball which can be used to randomly select the position of 
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
   Returns true/false. Directly modifies the grid in the function and returns true if it was able to place a grid object and false if not.
*)
val place_random_grid_element_along_path : grid -> pos -> direction -> int -> orientation -> grid_cell_type -> bool

(* Function which determines the new position of the ball in the grid if it goes through the first teleporter object such that it enters the grid 
   again through the second teleporter position making sure that the ball's original direction is preserved. It moves one extra cell out of 
   second teleporter exit position to ensure there is no infinite change in ball position between the two teleporter objects. 
   - current pinball grid (grid)
   - first teleporter position (pos)
   - original direction of ball (direction)
   Returns the position of the ball where it enters the grid again after it has exited through the second teleporter object.
*)
val move_to_second_teleporter_position : grid -> pos -> direction -> pos

(* Function which determines how the ball interacts with a grid cell object and determines which direction the ball will move in next after this interaction.
   It will use the grid object orientation and ball's intial direction mainly to determine the new direction.
   - grid cell which contains the grid object (grid cell)
   - initial direction of ball (direction)
   Returns the new direction of the ball after this interaction.
*)
val determine_new_ball_direction : grid_cell -> direction -> grid -> direction

(* Function that randomly selects the marker for the next grid object to be placed in the grid based on the list of grid object types
   specific for each level.
   - number of teleporters (int) used to determine if the teleporter pair was already placed in the grid or not as we can only have
      one teleporter pair in the grid regardless of level.
   - list of grid object types (grid cell type list)
   - number of activated bumper objects (int) - we have at most 2 per level in higher levels and 1 per level in lower levels
   Returns the grid cell type that was randomly selected that will decide the type of the next grid object.
*)
val randomly_choose_next_grid_object_marker : int -> grid_cell_type list -> int -> grid_cell_type

(* Function which randomly generates the orientation for the grid object depending on its type. 
   - type of grid object (grid_cell_type)
   Returns the randomly generated orientation of this object
*)
val get_grid_object_marker_orientation : grid_cell_type -> orientation

(* Function which generates the next grid object with its properties defined so that it can be placed directly in the grid.
   - number of teleporter objects (int)
   - list of grid object types (grid_cell_type list)
   - direction of new grid object (direction)
   - number of activated bumper objects (int)
   Returns the new defined grid cell type with its properties, the orientation of this next grid object and the marker type for the grid object
*)
val generate_next_grid_object : int -> grid_cell_type list -> direction -> int -> grid_cell_type * orientation * grid_cell_type

(* Function that simulates the ball's path through the grid and places the grid objects dynamically based on the ball's position. 
This function is recursive so it will continue simulating the ball's path and placing the grid objects until it either goes out of bounds 
of the grid, case of infinite bounces between two grid objects or there is a loop detected (keeps visiting the same positions in the grid) and never exits. 
This function also calls place_random_grid_element_along_path as a helper function to place the next grid object in the balls path and continues to simulate
the ball's movement. The function will also return an invalid position if the collect_positions_along_path was not able to place a grid object as that would 
change the affect the accuracy of the grid generated.
   - current pinball grid (grid)
   - current ball position (pos)
   - current ball direction (direction)
   - grid objects left to place (int)
   - grid size (int)
   - orientation of the next grid object (orientation)
   - bounce limit (int) which is used to prevent infinite bounces between two grid objects
   and returns an invalid position to stop generating this ball's path
   - set of visited positions ((pos * direction) Set.Poly.t) which is used to keep track of whether the ball is going in a loop
   - list of grid object types for that level so that we can randomly select from a list of grid cell object types specified for a level
   - number of teleporter objects placed (int) makes sure that we only place 1 teleporter pair in the grid when needed
   - number of activated bumper objects placed (int) to make sure we don't have too many activated bumper objects in the grid
   Returns the exit position and direction of the ball from the grid. This position could either be a valid exit position which is returned as Ok ...
   or be invalid which is returned as Error ... to represent that this simulation was unsuccessful. It uses a result type to accomplish this Ok/Error handling.
*)
val simulate_ball_path : grid -> pos -> direction -> int -> int -> orientation -> int -> (pos * direction) Set.Poly.t -> grid_cell_type list -> int -> int -> (pos * direction, string) result

(* Function to mark all the cells that the ball visited on its path from the entry position to the first placed grid object in the 
   grid to have a grid cell type of InBallPath.
   - current pinball grid (grid)
   - entry position of ball into the grid (pos)
   - entry direction of ball into grid (direction)
   - position of the first grid object in the ball's path (pos)
   - grid size (int)
   - Returns nothing. Just ensures that all the cells are marked InBallPath.
*)
val mark_in_ball_path : grid -> pos -> direction -> pos -> int -> unit

(* Randomly chooses from a list of potential entry positions and directions where the ball is going to enter the grid.
   - grid size (int)
   Returns the randomly selected entry position and direction of ball.
*)
val randomly_choose_entry_position : int -> pos * direction

(* Function to run simulate_ball_path to determine the exit position and direction of the ball. Takes in the parameters to call simulate_ball_path.
   The position returned can be invalid as well which is then used to determine whether the grid needs to be regenerated later on in generate_grid.
   - current pinball grid (grid)
   - current ball position (pos)
   - current ball direction (direction)
   - grid objects left to place (int)
   - grid size (int)
   - orientation of the next grid object (orientation)
   - bounce limit (int) which is used to prevent infinite bounces between two grid objects
   and returns an invalid position to stop generating this ball's path
   - set of visited positions ((pos * direction) Set.Poly.t) which is used to keep track of whether the ball is going in a loop
   - list of grid object types for that level so that we can randomly select from a list of grid cell object types specified for a level
   - number of teleporter objects placed (int) makes sure that we only place 1 teleporter pair in the grid when needed
   Returns the ball exit position and direction as determined by simulate_ball_path. Uses a result type so returns Error if there was an error generating path 
   or Ok ... with the ball exit position and direction.
*)
val get_exit_position_and_direction : grid -> pos -> direction -> int -> int -> orientation -> int -> (pos * direction) Core.Set.Poly.t -> grid_cell_type list -> int -> int -> (pos * direction, string) result

(* Goes through all the cells in the grid and counts the number of grid cell objects placed. 
   - final pinball grid (grid)
   Returns the count of grid cell objects placed in grid.    
*)
val count_objects_in_grid : grid -> int

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

