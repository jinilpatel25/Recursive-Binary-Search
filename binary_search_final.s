.include "address_map_arm.s"

binary_search:
	sub sp,sp,#28; // creating stack
	str r0,[sp,#0];//storing array pointer location
	str r1,[sp,#4];//storing key
	str r2,[sp,#8];//storing start index
	str r3,[sp,#12];//storing end index
	str r8,[sp,#16];//storing value of numcalls 
	str lr,[sp,#20]; // storing lr
	sub r1,r3,r2;//performs end index - start index
	lsr r1,r1,#1;//performing (end index - start index)/2
	add r2,r2,r1;// r2 stores value of middle index
	str r2,[sp,#24]; //stores the middleIndex
	add r8,r8,#1;//numcalls++

	ldr r3,[sp,#8]; //loading value of start index in r2
	ldr r4,[sp,#12]; //loading value of end index in r3
	cmp r3,r4; // comparing start index and end index
	bgt path1;
	ldr r1,[sp,#4];//loading value of key
	lsl r5,r2,#2;
	add r5,r5,r3;
	ldr r6,[r5,#0]; //extracts the element at middle index
	cmp r6,r1;//compares if numbers[middleindex]==key
	beq Found; // equal branch
	cmp r6,r1;
	bgt GreaterThan;//branch if middle element greater than key
	cmp r6,r1;
	blt LessThan;//branch if middle element is less than key
	b RETURN;

	path1:
	mov r12,#-1; // to return -1 
	b RETURN; //returns the value
	
	Found:
	mov r12,r2;//assigns keyIndex==middleIndex
	b MakeNegative;// to make the current index element -numcall
	b RETURN;//returns the value

	MakeNegative:
	mov r7,#0;
	sub r9,r7,r8;//performs 0-numcalls
	str r9,[r5,#0];// replaces the middle index element with -numcalls
	
	GreaterThan:
	ldr r10,[sp,#24];//loads the middle index
	sub r3,r10,#1;//subtracts 1 from middle index and makes it end index
	b MakeNegative;// to make the current index element -numcall
	bl binary_search;//recursive call to binary_search
	mov r12,r0; // stores the return value of sub calls 

	LessThan:
	ldr r10,[sp,#24];//loads the value of middle index
	add r2,r10,#1;//adds 1 to middle index and makes it start index
	b MakeNegative;// to make the current index element -numcall
	bl binary_search;
	mov r12,r0;

	RETURN:
	mov r0,r12; //assigns r0 the position where the key is found
	ldr lr,[sp,#20];//restores the address
	pc = lr;//restores the pc
	add sp,sp,#28; restores sp;
