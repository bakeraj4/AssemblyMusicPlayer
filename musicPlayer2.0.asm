.data
	file: .asciiz "sampleMusic.txt"
	buff: .asciiz " "
	numOfNotesBuff: .ascii "   "#right now it has lenght of 3 b/c thats how
			#many characters in the syscall in readNumNotes has.
	numOfNotes:.word 0
.text
main:
	jal openFile#open
	jal readNumNotes#get the number of notes
	jal playNotes#play the remainging lines
	j closeFile#close

openFile:
	li $v0, 13#syscall 13 open file
	la $a0, file#file name
	li $a1, 0#0 for read
	li $a2,0
	syscall
	move $s0,$v0#file description
	jr $ra
readNumNotes:
	#gets number of notes
	li $v0, 14#syscall 14 read from file
	move $a0,$s0#the file description
	la $a1, numOfNotesBuff#the buffer
	li $a2,3#number of chars to read
	syscall
	move $s0,$a0#file description

	la $t4,numOfNotesBuff
		
	#convert the buffer's chars to int
	li $t0, 0
	la $t1,numOfNotes
	#get the ascii value and sum of ()*100
	lb $t2,($t4)
	li $t3,100
	sub $t2,$t2,48
	mult $t2,$t3
	mflo $t2
	add $t0,$t0,$t2
	#get the ascii value and sum of num()*10#num=the size of char
	lb $t2,1($t4)
	li $t3,10
	sub $t2,$t2,48
	mult $t2,$t3
	mflo $t2
	add $t0,$t0,$t2
	#get the ascii value and sum of num*2()*1#num=the size of char
	lb $t2,2($t4)
	li $t3,1
	sub $t2,$t2,48
	mult $t2,$t3
	mflo $t2
	add $t0,$t0,$t2
	sw $t0,($t1)
	
	jr $ra
	
playNotes:
	li $t5,0
	la $t2, numOfNotes
	lw $t4,($t2)

	playContinue:
	#get the note
	li $v0, 14#syscall 14 read from file
	move $a0,$s0#the file description
	la $a1, buff#the buffer
	li $a2,1#number of chars to read
	syscall
	move $s0,$a0#file description
	
	#figures out which note is going to be played
	la $t2,buff
	lb $t0,($t2)
	li $t1,61
	beq $t0,68,noteD
	beq $t0,69,noteE
	beq $t0,70,noteF
	beq $t0,71,noteG
	beq $t0,65,noteA
	beq $t0,66,noteB
	beq $t0,67,noteC
	#else play C#
	b noteSetUpDone
	
	noteD:
		add $t1,$t1,1
		b noteSetUpDone
	noteE:
		add $t1,$t1,3
		b noteSetUpDone	
	noteF:
		add $t1,$t1,4
		b noteSetUpDone
	noteG:
		add $t1,$t1,6
		b noteSetUpDone	
	noteA:
		add $t1,$t1,8
		b noteSetUpDone
	noteB:
		add $t1,$t1,10
		b noteSetUpDone	
	noteC:
		add $t1,$t1,11
		b noteSetUpDone
	noteSetUpDone:
	
	#play the sound
	move $a0,$t1#pitch
	li $a1,100#time
	li $a2,37#32#31#29#instumanets
	li $a3,100#volume
	li $v0,33#syscall to beep with pause
	syscall
	
	#increment counter
	add $t5,$t5,1
	
	#checks that the counter is less than the number of notes
	bne $t5,$t4, notDone
	jr $ra
	notDone:
	b playContinue
		
closeFile:
	li $v0, 16
	move $a0,$s0
	syscall
	j done

done:
	li $v0,10
	syscall
