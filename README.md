# MIPS_rps_game

Rock Paper Scissors in MIPS Assembly

This project implements a Rock Paper Scissors game using MIPS assembly language. The game features two computer players who generate moves randomly and determine the winner of each round. Additionally, the project includes a cellular automaton to generate randomness.
Project Structure

The project is divided into several MIPS assembly files, each handling different aspects of the game's functionality:
Files

    •automaton.s:
        Implements the cellular automaton used to generate randomness.
        Functions:
            simulate_automaton: Simulates one step of the cellular automaton.

    •main.s:
        Contains the main program logic to run the game.
        Functions:
            main: Initializes and runs the game for a specified number of rounds.
            simulate_loop: Loops through each round of the game.

    •random.s:
        Handles random number generation.
        Functions:
            gen_byte: Generates a random byte.
            gen_bit: Generates a random bit.

    •rps.s:
        Implements the logic for playing a single round of Rock Paper Scissors.
        Functions:
            play_game_once: Computes moves for both players and prints the result (Win, Lose, Tie).

Cellular Automaton

The cellular automaton (CA) is used to generate randomness in the game. It updates the tape based on a specified rule and can be configured with different parameters for varied behavior.
Configuration

The configuration for the automaton and game is stored in memory and includes:

    eca: Flag to determine if the CA is used.
    tape: The seed for the random number generator.
    tape_len: Length of the tape.
    rule: Transition rule of the CA.
    skip: Number of times to simulate the automaton.
    column: The column to read the bit from.

Example Configuration

```assembly

.data
configuration:
  .word 1       # eca
  .word 836531  # tape
  .byte 20      # tape_len
  .byte 122     # rule
  .byte 5       # skip
  .byte 7       # column
```
How to Run

To run this project, you will need the MARS MIPS simulator. Follow these steps:

    Clone the repository.
    Open MARS Simulator: Download and start the MARS simulator.
    Load the Assembly Files: Load main.s, automaton.s, random.s, and rps.s into the MARS simulator.
    Run the Program: Assemble and run the main.s file to start the game simulation.

Function Descriptions:

•simulate_automaton:
 Simulates one step of the cellular automaton. This function updates the tape based on the provided rule and configuration.

•print_tape:
 Prints the current state of the tape for visualization.
 
•gen_byte:
 Generates a random byte, ensuring the generated byte is valid for the game (i.e., not '11').
 
•gen_bit:
 Generates a random bit using either the cellular automaton or a direct random number generator based on the configuration.

•play_game_once:
 Plays one round of Rock Paper Scissors, generating moves for two players and determining the result. Prints W for Win, L for Lose, and T for Tie.

Acknowledgments:

This project was inspired by the need to understand MIPS assembly programming and random number generation techniques using cellular automata.

    

            
