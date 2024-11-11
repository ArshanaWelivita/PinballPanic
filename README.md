# PinballPanic

Authors:

Arshana Welivita and Kenneth Elsman

Overview:

Pinball Panic is a memory game inspired by Lumionisity's Pinball Recall.
Given a starting position and an assortment of bumpers that will disappear after a short amount of time, your goal is to find the
correct ending location of the ball.

How to play:

The following is an example sample grid of size 3 x 3 which shows the indices related to each cell in the form [row, col].

 <img width="160" alt="Screenshot 2024-11-11 at 2 25 41 PM" src="https://github.com/user-attachments/assets/8e2b5c0e-fa72-4029-a4ea-46d0607a6be6">

The arrow ( ->🟢 ) indicates starting position and trajectory of the ball.
The bumpers ( ╲ and ╱ ) deflect the ball at a 90 degree angle (changes the trajectory in a perpendicular direction).
An example grid can be seen as follows: 

<img width="202" alt="Screenshot 2024-11-11 at 2 23 59 PM" src="https://github.com/user-attachments/assets/7eb41bad-2995-46e7-a0b1-18bc9fc723fb">

After a few seconds, the bumpers in the grid will disappear, and the user will be prompted to enter the ball's ending location. In this case, the answer is [2, 4] where the answer is given in the form [row, col]. So the user would enter "[2, 4]" to move on to the next round. If the user enters the correct answer, they will need to press 'c' to move onto the next level, otherwise they are presented with a "GAME OVER".

Commands:

run ppanic (to run the application)
!r (to start a new game)
!q (to quit)
!a _ (to submit an answer)
!c (to continue after completing a level)

Mock Use:

TODO


# Technical

Grid Generation:

Grids will be randomly generated and checked for degeneracy. Grid generation considers randomly selects the position and orientation of a given numnber of bumpers (given by the level number).
For a grid of size n x n and k bumpers, the grid is degerate if the following condition holds:
  - the number of bumpers the ball interacts with is <= k/2

Level Progression:

Level 1 - 3 x 3 grid with 1 bumper
Level 2 - 4 x 4 grid with 2 bumpers
Level 3 - 5 x 5 grid with 3 bumpers
Level 4 - 5 x 5 grid with 4 bumpers
Level 5 - 6 x 6 grid with 4 bumpers
...
Level 10 - 9 x 9 grid with 9 bumpers

Libraries:

- Dream
- Core

# Implementation Plan:

Week 1 - November 13th:
1. Add complex features to .mli files
  - Activated Bumper
  - Tunnel
  - Teleporter
2. Change grid int values to types (make it a more abstract implementation)

Week 2:
1. Implement advanced features in grid generation
  - Tunnel
  - Teleporter
2. Start on web app

Week 3
1. Activated bumper feature implementation 
2. Add grid.ml tests
3. Finish web app

Week 4:
1. Code cleanup
2. Add more testing
3. Search for edge cases
