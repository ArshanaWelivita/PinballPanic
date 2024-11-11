# PinballPanic

Authors: Arshana Welivita and Kenneth Elsman

# Overview:

Pinball Panic is a memory game inspired by Lumionisity's Pinball Recall.
Given a starting position and an assortment of bumpers that will disappear after a short amount of time, your goal is to find the
correct ending location of the ball.

# How to play:

The following is an example sample grid of size 3 x 3 which shows the indices related to each cell in the form [row, col].

 <img width="160" alt="Screenshot 2024-11-11 at 2 25 41 PM" src="https://github.com/user-attachments/assets/8e2b5c0e-fa72-4029-a4ea-46d0607a6be6">

The arrow ( ->🟢 ) indicates starting position and trajectory of the ball.
The bumpers ( ╲ and ╱ ) deflect the ball at a 90 degree angle (changes the trajectory in a perpendicular direction).
An example grid can be seen as follows: 

<img width="202" alt="Screenshot 2024-11-11 at 2 23 59 PM" src="https://github.com/user-attachments/assets/7eb41bad-2995-46e7-a0b1-18bc9fc723fb">

After a few seconds, the bumpers in the grid will disappear, and the user will be prompted to enter the ball's ending location. In this case, the answer is [2, 4] where the answer is given in the form [row, col]. So the user would enter "[2, 4]" to move on to the next round. If the user enters the correct answer, they will need to press 'c' to move onto the next level, otherwise they are presented with a "GAME OVER".

To execute the game, use: dune exec _build/default/src/bin/pinball_panic.exe 

**List of CLI Commands:**

- s (to start a new game)
- q or Ctrl-C (to quit)
- c (to move onto a harder level)

# Mock Use

**Example Run:**

<img width="1030" alt="Screenshot 2024-11-11 at 2 42 24 PM" src="https://github.com/user-attachments/assets/8b736015-b043-4df8-b74e-5a04f72fc24e">

<img width="1030" alt="Screenshot 2024-11-11 at 2 42 44 PM" src="https://github.com/user-attachments/assets/817cd05b-9add-46df-9cd1-3a93f7f27ea4">

<img width="1030" alt="Screenshot 2024-11-11 at 2 42 57 PM" src="https://github.com/user-attachments/assets/d0121615-f25e-4b19-bf3b-9c4d8726f3ea">

<img width="1030" alt="Screenshot 2024-11-11 at 2 43 17 PM" src="https://github.com/user-attachments/assets/d4d26608-fb22-441d-8377-f383d34c7827">

**Advanced Features:**

1. Activated bumpers:
These bumpers allow for the ball to pass through ONCE, before it materializes into a regular bumper.
Below are the unactivated versions of the bumpers what will be shown in the grid:
⧄ ⧅

2. Tunnels:
The orientation is either horizontal or vertical. The ball will be able to pass through in one direction, but will bounce off and reverse direction if it is hit from the side.
These are the characters for the tunnels:
|| =

3. Teleporter:
Teleporters preserve the direction of the ball, but changes its location. There will always be a maximum of one teleporter pair per grid.

  - ★ = The entry location

  - ☆ = The exit location

# Technical

Grid Generation:

Grids will be randomly generated and checked for degeneracy. Grid generation considers randomly selects the position and orientation of a given numnber of bumpers (given by the level number).
For a grid of size n x n and k bumpers, the grid is degerate if the following condition holds:
  - the number of bumpers the ball interacts with is <= k/2

Level Progression: (Not including advanced features at the moment)

Level 1  - 3 x 3 grid with 1 bumper
Level 2  - 4 x 4 grid with 1-2 bumpers
Level 3  - 4 x 4 grid with 2-3 bumpers
Level 4  - 4 x 4 grid with 3-4 bumpers
Level 5  - 5 x 5 grid with 4-5 bumpers
Level 6  - 5 x 5 grid with 5-6 bumpers
Level 7  - 6 x 6 grid with 6-8 bumpers
Level 8  - 7 x 7 grid with 7-9 bumpers
Level 9  - 7 x 7 grid with 8-10 bumpers
Level 10 - 8 x 8 grid with 9-12 bumpers

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
