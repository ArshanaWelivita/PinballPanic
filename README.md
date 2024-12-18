# PinballPanic

Authors: Arshana Welivita and Kenneth Elsman

# Overview:

Pinball Panic is a memory game inspired by Lumionisity's Pinball Recall.
Given a starting position and an assortment of bumpers that will disappear after a short amount of time, your goal is to find the
correct ending location of the ball.

## How to play:

The following is an example sample grid of size 3 x 3 which shows the indices related to each cell in the form [row, col].

 <img width="160" alt="Screenshot 2024-11-11 at 2 25 41 PM" src="https://github.com/user-attachments/assets/8e2b5c0e-fa72-4029-a4ea-46d0607a6be6">

The 'E' indicates starting position and trajectory of the ball.
The bumpers ( ╲ and ╱ ) deflect the ball at a 90 degree angle (changes the trajectory in a perpendicular direction).
An example grid can be seen as follows: 

<img width="202" alt="Screenshot 2024-11-11 at 2 23 59 PM" src="https://github.com/user-attachments/assets/7eb41bad-2995-46e7-a0b1-18bc9fc723fb">

After a few seconds, the bumpers in the grid will disappear, and the user will be prompted to enter the ball's ending location. In this case, the answer is '2 4' where the answer is given in the form 'row col' separated by a space. So the user would enter "2 4" to move on to the next round. If the user enters the correct answer, they will need to press 'c' to move onto the next level, otherwise they are presented with a "GAME OVER".

To execute the game on the command line, use: dune exec _build/default/src/bin/pinball_panic.exe

To execute the server implementation of the game, use: dune exec src/server/pinball_server.exe

### Example Run of Command Line Game:

**List of CLI Commands:**

- s : to start a new game
- q or Ctrl-C : to quit
- c : to move onto a harder level

<img width="1030" alt="Screenshot 2024-11-11 at 2 42 24 PM" src="https://github.com/user-attachments/assets/8b736015-b043-4df8-b74e-5a04f72fc24e">

<img width="1030" alt="Screenshot 2024-11-11 at 2 42 44 PM" src="https://github.com/user-attachments/assets/817cd05b-9add-46df-9cd1-3a93f7f27ea4">

<img width="1030" alt="Screenshot 2024-11-11 at 2 42 57 PM" src="https://github.com/user-attachments/assets/d0121615-f25e-4b19-bf3b-9c4d8726f3ea">

<img width="1030" alt="Screenshot 2024-11-11 at 2 43 17 PM" src="https://github.com/user-attachments/assets/d4d26608-fb22-441d-8377-f383d34c7827">

### Example Run of Server Game:

# Technical

### Grid Generation

The grid will be generated dynamically where we randomly place the first grid object within the grid and build the ball's path based off that object and place the following grid objects accordingly. This ensures that the grid we generate is viable and that the ball interacts with each of the grid objects before it exits the grid. This also ensures that the path the ball takes is feasible and we ensure that an interaction between grid objects doesn't cause infinite bounces so the ball never leaves the grid. The number of grid objects and their types will be pre-determined and we explain this in the level progression section.

### Advanced Features

1. **Activated bumpers:**
These bumpers allow for the ball to pass through ONCE, before it materializes into a regular bumper.
Below are the unactivated versions of the bumpers what will be shown in the grid:

  - ⧄ - unactivated version of ╱ bumper
  - ⧅ - unactivated version of ╲ bumper

2. **Tunnels:**
The orientation is either horizontal or vertical. The ball will be able to pass through in one direction, but will bounce off and reverse direction if it is hit from the side.
These are the characters for the tunnels:
  - 𝄁 - vertical orientation 
  - = - horizontal orientation 

3. **Teleporter:**
Teleporters preserve the direction of the ball, but changes its location. There will always be a maximum of one teleporter pair per grid. Each teleporter can act as an entry or exit location so it can always enter/exit from either teleporter in the pair. 
  - ★ - entry/exit location character of teleporter

4. **Directional Bumper:**
Directional bumpers allow for the ball to pass through in 2 directions (retains the original direction of the ball) and acts like a normal bumper in the other two directions.
  - ◸ - directional version of ╱ bumper where it passes through if the ball is going to the right or going down and bounces otherwise
  - ◹ - directional version of ╲ bumper where it passes through if the ball is going to the left or going down and bounces otherwise

### Level Progression

A grid object represents the type of object that the ball can interact with in the grid where it can be a bumper, tunnel, activated bumper or teleporter. This ensures that each level has a specified number of grid objects with specific types for each level ensuring that the ball interacts with each of them before exiting the grid. As the levels increase in difficulty we will introduce harder grid objects and build up to a combination of grid objects in the hardest levels. 

Level 1  - 3 x 3 grid with 1 grid object (type: bumper)

Level 2  - 4 x 4 grid with 1-2 grid object (type: bumper)

Level 3  - 4 x 4 grid with 2-3 grid object (type: bumper, tunnel)

Level 4  - 4 x 4 grid with 3-4 grid object (type: bumper, tunnel)

Level 5  - 5 x 5 grid with 4-5 grid object (type: bumper, teleporter)

Level 6  - 5 x 5 grid with 5-6 grid object (type: bumper, teleporter)

Level 7  - 6 x 6 grid with 6-8 grid object (type: bumper, teleporter, tunnel)

Level 8  - 6 x 6 grid with 6-8 grid object (type: bumper, activated bumper)

Level 9  - 7 x 7 grid with 7-9 grid object (type: bumper, tunnel, activated bumper)

Level 10  - 7 x 7 grid with 7-9 grid object (type: bumper, teleporter, activated bumper)

Level 11  - 7 x 7 grid with 7-9 grid object (type: tunnel, teleporter, activated bumper)

Level 12  - 7 x 7 grid with 8-10 grid object (type: bumper, teleporter, activated bumper)

Level 13 - 8 x 8 grid with 9-12 grid object (type: bumper, teleporter, tunnel, activated bumper)

### OCaml Library Use

- **Core** 
  - We will use Core to help build the grid library and its associated different grid objects that can be contained in the grid's cells. 
- **Dream**
  - We will use this library to develop the web-version of this game. This will still utilize the grid library and all the features of the grid, but instead of a command line interactive game, it will be a web application.
- **Bisect**
  - We will use this to check our testing coverage of our game when we build our test library to test the functionality and edge cases of the game to ensure that it runs correctly.
 
 ### Generalization:
 We couldn't think of any possible ways to generalize the game as it depends on the dynamic generation of the grid where each grid object interaction is pre-defined, so it would be hard to create an abstract implementation where the user defines the interaction of each grid object as then the user would have to provide the functions that define these grid object interactions which defy the purpose of a functor. Instead of generalizing, we increased the number of levels steadily, increasing the difficulty such that the higher levels have enormous grids with large numbers of objects with combinations of interactions between various grid objects. We also improved it such that it places random grid objects within the grid that don't interact with the ball to throw the user off, making it more difficult for the player to discern the ball's path. 
