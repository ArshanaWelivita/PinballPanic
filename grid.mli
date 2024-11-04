(* Functor for the grid where we have module type for every single object inside the grid (rn only implementing bumpers)
This is all for the command-line ascii implementation

Module type: grid
- type n (row and col are the same as it is a square sized grid)
- type entry_pos (where the ball starts initially in grid where it is outside the grid bounds )
(grid extension start at 0,0 where the actual grid bounds starts at (1,1) so all row cols have an offset of index 1 where
 there is an blank row/col perimeter axes of the grid so that we don't need to do negative numbers for the entry position
 so our generated grid is going to be 1 larger than the actual size of the grid)
 - have a hard-coded number of bounces for every level and have the 

 - function: out_of_bounds_check(current ball position)
        - checks if any part of the [row, col] index is greater than n or < 1 which tells us that the ball has exited the grid 
        - we can use this to compare the actual end position with the user input end position to decide whether they succeeded and moved to next level or game over/highest level reached

- function: check_if_ball_touches_half_bumpers() --> helper function for random generation of grid
        - keep track of how many bumpers the ball touches 
        - use Core.random to generate the initial bumper position and generate the grid from that position onwards

for testing, have an idea of a game player and testing the grid-size, and the bounces alone 
- function: randomization function to actually 

Functor out of grid module type (all the way at the end - not priority right now)

--> for future, may need ball type to show the visual movement of the ball through the grid

Module type: bumper
- needs position and orientation as the input
- type position (which row-col it is in the entire grid)
- type orientation (down_right = '╲' and up_right = '╱')
- function: generate_directions(user input direction)
    - create a map of all possible input and output directions which is returned to the grid module
*)