# PinballPanic

Authors:

Arshana Welivita and Kenneth Elsman

Overview:

Pinball Panic is a memory game inspired by Lumionisity's Pinball Recall.
Given a starting position and an assortment of bumpers that will disappear after a short amount of time, your goal is to find the
correct ending location of the ball.

How to play:

The arrow ( -> ) indicates starting position and trajectory.
The bumpers ( ╲ and ╱ ) deflect the ball at a 90 degree angle.

'-> [ ] [╲] [ ] [ ]'

  '[ ] [ ] [ ] [ ]'
  
  '[ ] [╲] [ ] [╱]'
  
  '[ ] [ ] [ ] [ ]'

After 3 seconds, the bumpers in the grid will disappear. And the user will be prompted to enter the ball's ending location.

   'a   b   c   d'
   
'A [ ] [ ] [ ] [ ] AA'

'B [ ] [ ] [ ] [ ] BB'

'C [ ] [ ] [ ] [ ] CC'

'D [ ] [ ] [ ] [ ] DD'

 'aa  bb  cc  dd'

In this case, the answer is "d". So the user would enter "!a d" to move on to the next round.
If the user enters the correct answer, they will move on to a harder level, otherwise they are presented with a "GAME OVER".

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

Implementation Plan:

Week 1 - November 13th:
Add complex features to .mli files
- Activated Bumper
- Tunnel
- Teleporter
Change grid int values to types

Week 2:
Implement advanced features in grid generation
- Tunnel
- Teleporter
Start on web app

Week 3
Activated bumper feature implementation 
Add grid.ml tests
Finish web app

Week 4:
Code cleanup
Add more testing
Search for edge cases

Libraries:

- Dream
- Core
