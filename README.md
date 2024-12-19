# PinballPanic

Authors: Arshana Welivita and Kenneth Elsman

# Overview:

Pinball Panic is a memory game inspired by Lumionisity's Pinball Recall.
Given a starting position and an assortment of grid objects that will disappear after a short amount of time, your goal is to find the
correct ending location of the ball.

## How to play:

The following is an example sample grid of size 3 x 3 which shows the indices related to each cell in the form [row, col].

 <img width="160" alt="Screenshot 2024-11-11 at 2 25 41 PM" src="https://github.com/user-attachments/assets/8e2b5c0e-fa72-4029-a4ea-46d0607a6be6">

The 'E' indicates starting position and trajectory of the ball.
The bumpers ( ╲ and ╱ ) deflect the ball at a 90 degree angle (changes the trajectory in a perpendicular direction).
An example grid can be seen as follows: 

<img width="200" alt="Screenshot 2024-12-18 at 1 48 43 PM" src="https://github.com/user-attachments/assets/57cb0abd-ae07-468e-84a2-67d96f58ab31" />

After a few seconds, the bumpers in the grid will disappear, and the user will be prompted to enter the ball's ending location. In this case, the answer is '2 4' where the answer is given in the form 'row col' separated by a space. So the user would enter "2 4" to move on to the next round. If the user enters the correct answer, they will need to press 'c' to move onto the next level, otherwise they are presented with a "GAME OVER".

To execute the game on the command line, use: dune exec _build/default/src/bin/pinball_panic.exe

To execute the server implementation of the game, use: dune exec src/server/pinball_server.exe

### Note Regarding Testing:

Despite countless hours attempting to debug our simulate_ball_path_post_generation function (used for testing purposes). The function doesn't always work as intended for levels 8+. We postulate it is due to some of the activated_bumper and directional_bumper interactions. Note that this function is only used for testing purposes, and so there is no corresponding bug that can be found in either the command-line implementation, nor the server implementation. Furthermore, this is the reason why Grid.ml might lack some code coverage.

### Example Run of Command Line Game:

<img width="1078" alt="Screenshot 2024-12-18 at 1 31 53 PM" src="https://github.com/user-attachments/assets/8c997322-967b-4d18-bc47-5d80d0266e81" />

<img width="901" alt="Screenshot 2024-12-18 at 1 34 53 PM" src="https://github.com/user-attachments/assets/c6521286-776d-4244-8003-bce8a7aac2bf" />

<img width="904" alt="Screenshot 2024-12-18 at 1 35 21 PM" src="https://github.com/user-attachments/assets/64ebc448-7652-492c-923f-c9104684150c" />

<img width="904" alt="Screenshot 2024-12-18 at 1 35 34 PM" src="https://github.com/user-attachments/assets/f474cc3a-6ecc-4b09-b409-d5f9525499b7" />

**List of CLI Commands:**

- s : to start a new game
- q or Ctrl-C : to quit
- c : to move onto a harder level

### Example Run of Server Game:

<img width="1132" alt="Screenshot 2024-12-18 at 1 43 40 PM" src="https://github.com/user-attachments/assets/44cffe56-aa5e-402e-aba4-5e520ecab1ed" />

<img width="1258" alt="Screenshot 2024-12-18 at 1 44 24 PM" src="https://github.com/user-attachments/assets/41768d99-660b-4e94-90f3-76980eb83bd6" />

<img width="1258" alt="Screenshot 2024-12-18 at 1 44 47 PM" src="https://github.com/user-attachments/assets/8e37a9d3-f9ed-4d88-bc02-edd570a1fc8a" />

<img width="1258" alt="Screenshot 2024-12-18 at 1 45 12 PM" src="https://github.com/user-attachments/assets/54ced4e0-7d08-4232-b79c-63c3b1108b13" />

<img width="1258" alt="Screenshot 2024-12-18 at 1 45 28 PM" src="https://github.com/user-attachments/assets/be66065b-891a-402f-bf16-089d9b253687" />

<img width="1258" alt="Screenshot 2024-12-18 at 1 46 17 PM" src="https://github.com/user-attachments/assets/ddd0e1e4-a01c-4f61-99d9-6aebc36bb240" />

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

A grid object represents the type of object that the ball can interact with in the grid where it can be a bumper, tunnel, activated bumper, directional bumper or teleporter. This ensures that each level has a specified number of grid objects with specific types for each level ensuring that the ball interacts with each of them before exiting the grid. As the levels increase in difficulty we will introduce harder grid objects and build up to a combination of grid objects in the hardest levels. We also made the harder levels more difficult by incorporating additional grid objects that don't interact with the ball to make it more difficult for the user to determine which grid objects the ball actually interacts with to make it harder to discern its ball path and ultimately find the correct exit position. 

Level 1  - 3 x 3 grid with 1 grid object (type: bumper) with 0 extra grid objects 

Level 2  - 4 x 4 grid with 1-2 grid object (type: bumper) with 0 extra grid objects 

Level 3  - 4 x 4 grid with 2-3 grid object (type: bumper, tunnel) with 0 extra grid objects 

Level 4  - 4 x 4 grid with 3-4 grid object (type: bumper, tunnel) with 0 extra grid objects 

Level 5  - 5 x 5 grid with 4-5 grid object (type: bumper, teleporter) with 0 extra grid objects 

Level 6  - 5 x 5 grid with 5-6 grid object (type: bumper, teleporter) with 0 extra grid objects 

Level 7  - 6 x 6 grid with 6-8 grid object (type: bumper, teleporter, tunnel) with 0 extra grid objects 

Level 8  - 6 x 6 grid with 6-8 grid object (type: bumper, activated bumper) with 0 extra grid objects 

Level 9  - 7 x 7 grid with 7-9 grid object (type: bumper, tunnel, activated bumper) with 1 extra grid objects 

Level 10  - 7 x 7 grid with 7-9 grid object (type: bumper, directional bumper, activated bumper) with 2 extra grid objects 

Level 11  - 7 x 7 grid with 7-9 grid object (type: bumper, teleporter, activated bumper) with 2 extra grid objects 

Level 12  - 7 x 7 grid with 8-10 grid object (type: tunnel, teleporter, activated bumper) with 3 extra grid objects 

Level 13 - 8 x 8 grid with 9-12 grid object (type: teleporter, tunnel, directional bumper) with 3 extra grid objects 

Level 14 - 8 x 8 grid with 9-12 grid object (type: bumper, teleporter, activated bumper, directional bumper) with 3 extra grid objects 

Level 15 - 8 x 8 grid with 9-12 grid object (type: bumper, teleporter, tunnel, activated bumper) with 4 extra grid objects 

Level 16 - 10 x 10 grid with 10-12 grid object (type: bumper, teleporter, tunnel, activated bumper, directional bumper) with 5 extra grid objects 

### OCaml Library Use

- **Core** 
  - We will use Core to help build the grid library and its associated different grid objects that can be contained in the grid's cells. 
- **Dream**
  - We will use this library to develop the web-version of this game. This will still utilize the grid library and all the features of the grid, but instead of a command line interactive game, it will be a web application.
- **Bisect**
  - We will use this to check our testing coverage of our game when we build our test library to test the functionality and edge cases of the game to ensure that it runs correctly.
 
 ### Generalization:
 We couldn't think of any possible ways to generalize the game as it depends on the dynamic generation of the grid where each grid object interaction is pre-defined, so it would be hard to create an abstract implementation where the user defines the interaction of each grid object as then the user would have to provide the functions that define these grid object interactions which defy the purpose of a functor. Instead of generalizing, we increased the number of levels steadily, increasing the difficulty such that the higher levels have enormous grids with large numbers of objects with combinations of interactions between various grid objects. We also improved it such that it places random grid objects within the grid that don't interact with the ball to throw the user off, making it more difficult for the player to discern the ball's path. 
