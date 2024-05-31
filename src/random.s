# vim:sw=2 syntax=asm
.data
binary_string: .asciiz ""   # Buffer to store binary string
.text
  .globl gen_byte, gen_bit

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Compute the next valid byte (00, 01, 10) and put into $v0
#  If 11 would be returned, produce two new bits until valid
#
gen_byte:
  subu $sp, $sp, 4 #here we reduce stack to store return address
  sw $ra, 0($sp) #we store here return address
 
getRandomBit:  
	jal gen_bit #func called to get rand bit
	move $s6, $v0#we move value to t0
        jal gen_bit   #again calling function
        move $s7, $v0 #moving value

check1:
        and $t2, $s6, $s7 #using and bitwise op so that if both are 1 then t2 will be 1
        beq $t2, 1, throwAway #comparing with 1. if both 1 then throwaway
        mul $s6, $s6, 2 #binary to decimal
        mul $s7, $s7, 1 #binary to decimal
        add  $s6, $s6, $s7 #addition
        move $v0, $s6
        j end
        
throwAway:  #this func gen another ran bit if we get 11 in check
         jal gen_bit
         move $s6, $v0
         jal gen_bit
         move $s7, $v0
         j check1        
       
end:     lw $ra, 0($sp) #loading address
         addu $sp, $sp , 4 #restoring stack
         jr $ra
         

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value: 
#  Look at the field {eca} and use the associated random number generator to generate one bit.
#  Put the computed bit into $v0
#
gen_bit:
  subu $sp, $sp, 8
  sw $ra, 0($sp)
  sw $a0, 4($sp)
  lw $s3, 0($a0) #eca
  move $t3, $s3
  lb $s4, 10($a0) #skip
  lb $s5, 11($a0)
if:
  beqz $t3, genNormalBit
nochmalBitte:
  jal simulate_automaton
 
  subiu $s4, $s4, 1
  bge $s4, 1, nochmalBitte
  lw $t4, 4($a0)
  move $t7, $t4
  move $t5, $s5
  lb $t6, 8($a0)
  subiu $t6, $t6, 1
  subu $t5, $t6, $t5
  srlv $t7, $t7, $t5
  andi $v0, $t7, 1
  lw $ra, 0($sp)
  lw $a0, 4($sp)
  addu $sp, $sp, 8
  jr $ra 
  
genNormalBit:  
  li $v0, 40 #here we set the seed
  la $a1, 4($a0) #we have our seed in tape at memomry address
  syscall 
  
  li $v0, 41 #we now call randNum gen 
  li $a0, 0 #ran gen with id 0
  syscall
  
  andi $v0, $a0, 1 #getting least signi bit
  lw $ra, 0($sp)
  lw $a0, 4($sp)
  addu $sp, $sp, 8  
  jr $ra
