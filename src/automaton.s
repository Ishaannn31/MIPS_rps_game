# vim:sw=2 syntax=asm\
.data
rule: .space 32
combinations: .space 120
.text
  .globl simulate_automaton, print_tape

# Simulate one step of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, but updates the tape in memory location 4($a0)
simulate_automaton:
    li $t1, 0
    li $t8, 0
    li $t9, 0
    subu $sp, $sp, 4
    sw $ra, 0($sp)
     lb $t0, 9($a0) #rule
     la $s1, rule #array to store rule
     move $t1, $s1#base address of array
     lw $t9, 4($a0) #tape
     lb $t2, 8($a0) #tape length
     la $t8, combinations
     li $t3, 1 #counter
storeRule:
     andi $t4, $t0, 1 #LSB of rule
     sb $t4, ($t1) #storing in array
     srl $t0, $t0, 1
     addi $t1, $t1, 4 #shifting array forward by 1 byte
     addi $t3, $t3, 1 #counter
     blt $t3, 8, storeRule #until we get all bits
     

     li $t3, 1 #reset counter
     andi $t5, $t9, 1 #LSB
     mul $t5, $t5, 2 #binary to decimal
     srl $t9, $t9, 1 #shifting to get another LSb
     andi $t4, $t9, 1
     mul $t4, $t4, 4 #binary to decimal
     add $t4, $t5, $t4 
     lw $t9, 4($a0) #loading tape nochmal
firstComb:     
     srl $t9, $t9, 1
     addiu $t3, $t3, 1
     blt $t3, $t2, firstComb #until we get most significant bit
     andi $t5, $t9, 1
     mul $t5, $t5, 1 #binary to decimal
     add $t4, $t4, $t5
     sb $t4, ($t8) #storing first combination
     addiu $t8, $t8, 4 #shifting array forward
     li $t4, 0  
     lw $t9, 4($a0) #tape
     li $t3, 2 #reset counter
makeComb:
     andi $t4, $t9, 7 #combinations in between
     srl $t9, $t9, 1
     sb $t4, ($t8) #storing them
     addi $t8, $t8, 4 #shifting array
     addi $t3, $t3, 1
     blt $t3, $t2, makeComb #until we get all combinations in between
     li $t3, 2 #reset counter 
     lw $t9, 4($a0) #tape
       
     andi $t5, $t9, 1 #LSB
     mul $t5, $t5, 4 #binary to decimal
lastComb:
     srl $t9, $t9, 1 # last combination
     addiu $t3, $t3, 1
     blt $t3, $t2, lastComb
     andi $t6, $t9,1
     mul $t6, $t6, 1
     srl $t9, $t9, 1
     andi $t4, $t9, 1
     mul $t4, $t4, 2
     add $t4, $t5, $t4
     add $t4, $t4, $t6
     sb $t4, ($t8) #storing last combination
     li $t3, 0
     li $t7, 0
vergleich:
     move $t1, $s1 #base address of rule
     lb $t4, ($t8)   
     addiu $t8, $t8, -4
     addiu $t3, $t3, 1
     mul $t4, $t4, 4 #shifting memory address
     addu $t5, $t1, $t4
     lb $t6, ($t5)
     sll $t7, $t7, 1
     add $t7, $t7, $t6  
     blt $t3, $t2, vergleich
     sw $t7, 4($a0)
    lw $ra, 0($sp)
     addu $sp, $sp, 4
     jr $ra

# Print the tape of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return nothing, print the tape as follows:
#   Example:
#       tape: 42 (0b00101010)
#       tape_len: 8
#   Print:  
#       __X_X_X_
print_tape:
   lw $t0, 4($a0) #tape
   lb $t1, 8($a0) #tape_length
   
  
   li $t2, 0 #counter
   li $s1, 0
   
   
reverseTape:
      sll $s1, $s1, 1
      andi $t3, $t0, 1
      addu $s1, $s1, $t3
      srl $t0, $t0, 1
      addiu $t2, $t2, 1
      blt $t2, $t1, reverseTape
      li $t2, 0
         
deadAlive:
         andi $t4, $s1, 1       
         bgtz $t4, printX
         li $v0, 11
         la $a0, '_'
         syscall
         j shift
printX:  
        
         li $v0, 11
         la $a0, 'X'
         syscall
         
shift:   
         
         srl $s1, $s1, 1
         addiu $t2, $t2, 1
         blt $t2, $t1, deadAlive
         j end
         
end:    li $v0, 11
        la $a0, '\n'
        syscall
        jr $ra                                                            
                        
 
