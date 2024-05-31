# vim:sw=2 syntax=asm
.data
win: .asciiz "W"
lose: .asciiz "L"
tie: .asciiz "T"

.text
  .globl play_game_once

# Play the game once, that is
# (1) compute two moves (RPS) for the two computer players
# (2) Print (W)in (L)oss or (T)ie, whether the first player wins, looses or ties.
#
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, only print either character 'W', 'L', or 'T' to stdout
play_game_once:
  subu $sp, $sp, 8 #making space in stack
  sw $ra, 0($sp) #storing return address
  
  jal gen_byte #func call
  move $t3, $v0 #moving random output
  sw $t3, 4($sp)
  jal gen_byte
  move $t4, $v0
  lw $t3, 4($sp)
  # below are conditions to check result of player 1
play1:  beq $t3, 1, checkRes1
        j play2
       
checkRes1: 
       beq $t4, 0, result1
       beq $t4, 2, result2
       beq $t4, 1, result3

play2: beq $t3, 0, checkRes2
       j play3
checkRes2:         
       beq $t4, 2, result1
       beq $t4, 1, result2
       beq $t4, 0, result3
       
play3: beq $t3, 2, checkRes3
checkRes3:     
       beq $t4, 1, result1  
       beq $t4, 0, result2
       beq $t4, 2, result3     
       
       #printing result
       
result1: 
       li $v0, 4
       la $a0, win
       syscall
       
      j end 
       
result2:
       li $v0, 4
       la $a0, lose
       syscall 
       
    j end
result3:
       li $v0, 4
       la $a0, tie
       syscall
       
end:	lw $ra, 0($sp)
       addu $sp, $sp, 4 #restoring stack
       jr $ra          
       
              
  
  

