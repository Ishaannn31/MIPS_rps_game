# vim:sw=2 syntax=asm
.data

# Memory layout of the Configuration
# |   eca  |   tape   |  tape_len  |  rule  |  skip  | column |
# | 1 word |  1 word  |   1 byte   | 1 byte | 1 byte | 1 byte |
configuration:
  .word 1       # eca
  .word 836531  # tape
  .byte 20      # tape_len
  .byte 122     # rule
  .byte 5       # skip
  .byte 7       # column
  
.text
  .globl main

# Example main program that steps the ECA 10 times
main:
  li $s0 10
  la $a0 configuration
  jal simulate_loop
  j terminate

simulate_loop: # One loop iteration
  beqz $s0 terminate
  subi $s0 $s0 1
  la $a0 configuration
  jal play_game_once
  j simulate_loop
  
terminate:
  li $v0 10
  syscall
