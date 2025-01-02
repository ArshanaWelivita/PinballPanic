# PinballPanic

Authors: Arshana Welivita and Kenneth Elsman

# Overview:

Pinball Panic is a memory game inspired by Lumionisity's Pinball Recall.
Given a starting position and an assortment of grid objects your goal is to find the correct ending location of the ball.

## How to play:

[WARNING: OUTDATED] 
To execute the game on the command line, use: dune exec _build/default/src/bin/pinball_panic.exe

To execute the server implementation of the game, use: dune exec src/server/pinball_server.exe

# Technical

### Grid Generation

The grid will be generated dynamically where we randomly place the first grid object within the grid and build the ball's path based off that object and place the following grid objects accordingly. This ensures that the grid we generate is viable and that the ball interacts with each of the grid objects before it exits the grid. This also ensures that the path the ball takes is feasible and we ensure that an interaction between grid objects doesn't cause infinite bounces so the ball never leaves the grid. The number of grid objects and their types will be pre-determined.

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

### OCaml Library Use

- **Core** 
  - We will use Core to help build the grid library and its associated different grid objects that can be contained in the grid's cells. 
- **Dream**
  - We will use this library to develop the web-version of this game. This will still utilize the grid library and all the features of the grid, but instead of a command line interactive game, it will be a web application.
- **Bisect**
  - We will use this to check our testing coverage of our game when we build our test library to test the functionality and edge cases of the game to ensure that it runs correctly.
 