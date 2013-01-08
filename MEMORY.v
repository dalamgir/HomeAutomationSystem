module MEMORY (i_address, i_enable, data_out, data_in, address, load, store, clock);
  
  parameter word_size = 32;                   				/* 	An instruction size is 32 bits */
  parameter memory_size = 1048575;           		 		/* 	Size of the memory is 2^32 = 4294967296 bits = 0.5 GB 
																Therefore, the memory size is approximately 512 MB. However,
																the student version of ModelSim is non compliant with a memory
																of such a size and hence we had to resort to keeping the memory
																size at 2^20 - 1 = 1048575 or approximately 0.125 MB */
  
  output reg [word_size-1:0] data_out;
  
  input [word_size-1:0] data_in;
  input [word_size-1:0] address;
  input load, store, clock;
  input [19:0] i_address;
  
  input i_enable;
  
  reg [word_size-1:0] Memory [memory_size:0];
  
  initial begin
	
	
	  Memory[0] <= 32'b00_1001_11111_0000_0000_0000_0000_00001; 			/* load immediate - load 1 to register 31 	*/
      Memory[1] <= 32'b00_1001_00000_0000_0000_0000_0000_00000; 			/* load immediate - load 0 to register 0	*/
      Memory[2] <= 32'b00_1001_00011_000000000000000000001; 				/* power register 3 is being set to 1 		*/
      Memory[3] <= 32'b00_1001_00100_000000000000000000001; 				/* power register 4 is being set to 1		*/
      Memory[4] <= 32'b00_1001_00110_000000000000000000001; 				/* power register 6 is being set to 1		*/
      Memory[5] <= 32'b00_1001_01001_000000000000000000001; 				/* power register 9 is being set to 1		*/
      Memory[6] <= 32'b00_1001_01110_000000000000000000001; 				/* power register 14 is being set to 1		*/
     
	 //load initial data for HT
      Memory[7] <= 32'b00_1001_11101_000000000000000000011;
      //*28
      Memory[8] <= 32'b00_0111_00001_11101_0000000000000000;//lw
        //Register 1 is the state for home theatre
      Memory[9] <= 32'b00_1001_11110_00000_0000000000010101;
      Memory[10]<= 32'b00_0111_00010_11110_0000000000000000; //lw
      //finish
       //*40

       //load initial data for GD
      Memory[11] <=32'b00_1001_11110_00000_0000000000000001;
      Memory[12] <=32'b00_0111_00101_11110_0000000000000000;
       //finish *48

       //load initial data for TS
      Memory[13] <=32'b00_1001_11110_00000_0000000000100001;
      Memory[14] <=32'b00_0111_00111_11110_0000000000000000;
       //Register 7 is the state for temp
       //finish *56

       //load initial data for HS
      Memory[15] <=32'b00_1001_11101_00000_00000_00000000001;
        // writing to register 10 - state register
      Memory[16] <=32'b00_0111_01010_11101_00000_00000000000; //lw
       //Register 10 is the state for home security
      Memory[17] <=32'b00_1001_01011_00000_00000_00000000101; //Register 11 is the PIN
       // Load PIN from reg 30 - to 11
      //Memory[18] <=32'b00_0111_01011_11110_00000_00000000000; //Register 11 is the PIN
       //finish *72

       //load initial data for USB
      Memory[18] <= 32'b00_1001_11110_00000_00000_00000000001;
      Memory[19] <= 32'b00_0111_01111_11110_00000_00000000000;
      Memory[20] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; // Jump back to itself infite loop
      //*84
       
	   /***************************************** Home theater************************************************/

       Memory[32'd1028096] <= 32'b01_00000_00011_00000000000000011100;
       //check status - beq power register (3), zero register
       // loads the state of home theatre system - NOT AN INSTRUCTION - play, pause, rew, ff, etc.
       // need to decide bit format
       // state is stored as the offset of a load immediate instruction,
       // so anything modifying state will have to write the whole instruction into Memory
       // writing to register 1 - state register
       Memory[32'd1028097] <= 32'b00_1001_00001_11101_0000000000000000;
//Register 1 is the state for home theatre
       //Register 29 is Current State of video
       //Register 30 is Current State of volume
       // same procedure for volume register - register 2 - loads state into register
       Memory[32'd1028098] <= 32'b00_1001_00010_11110_0000000000000000;

             //Power Up agian the systenm
      Memory[32'd1028099] <= 32'b00_1001_00011_000000000000000000001; 
//Store in register 3
      Memory[32'd1028100] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; //Jump back to os
/*Jump back to OS: 32'b00_1010_00000_00000_0000_0000_0001_0100; */
       //Increment volume
      Memory[32'd1028101] <= 32'b00_0001_11111_00010_11110_00000000000; //incrementing volume register by 1
      Memory[32'd1028102] <= 32'b00_0111_00010_11110_00000_00000000000;
      //Now store in register 30
      Memory[32'd1028103] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; //Jump back to os

      //Decrement volume
      Memory[32'd1028104] <= 32'b00_0010_11111_00010_11101_00000000000; //decrements volume register by 1
      Memory[32'd1028105] <= 32'b00_0111_00001_11101_00000_00000000000;
      //Now store in register 30
      Memory[32'd1028106] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      //Change states
      Memory[32'd1028107] <= 32'b00_1001_00001_000000000000000000001; //Play
      Memory[32'd1028108] <= 32'b00_0111_00001_11101_00000_00000000000;
      //Now store in register 29
      /*Jump back to OS: 32'b00_1010_00000_00000_0000_0000_0001_0100; */
      Memory[32'd1028109] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; // Jump back to os

      Memory[32'd1028110] <= 32'b00_1001_00001_000000000000000000010; //Pause
      Memory[32'd1028111] <= 32'b00_0111_00001_11101_00000_0000000000;
      //Now store in register 29
      Memory[32'd1028112] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;  //Jump back to os

      Memory[32'd1028113] <= 32'b00_1001_00001_000000000000000000011; //Stop
      Memory[32'd1028114] <= 32'b00_0111_00001_11101_00000_0000000000;
      //Now store in register 29
      Memory[32'd1028115] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      Memory[32'd1028116] <= 32'b00_1001_00001_000000000000000000100;
      //Fast Forward
      Memory[32'd1028117] <= 32'b00_0111_00001_11101_00000_0000000000;
      //Now store in register 29
      Memory[32'd1028118] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;  //Jump back to os

      Memory[32'd1028119] <= 32'b00_1001_00001_000000000000000000101; //Rewind
      Memory[32'd1028120] <= 32'b00_0111_00001_11101_00000_0000000000;
      //Now store in register 29
      Memory[32'd1028121] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; //Jump back to os

      Memory[32'd1028200] <= 32'b00_1001_00011_000000000000000000000;//Turn off (register 3)
      Memory[32'd1028204] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; //Jump back to os
      //*1028204

      /***************************************** Garage Door ************************************************/
      
      /*needs to change*/
      Memory[32'd749568] <= 32'b01_00000_00100_0000_0000_0000_0001_0100;
      // check status - beq power register (4), zero register
      // loads the state of the garage door - NOT AN INSTRUCTION - open, close

      // writing to register 5 - state register
      Memory[32'd749569] <= 32'b00_1001_00101_11101_0000000000000000;
      //Register 5 is the state for garage door

      //Checking if this is first run
      Memory[32'd749570] <= 32'b00_0111_00100_11111_00000_0000000000;
      //Store in register 4
      Memory[32'd749571] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; //Jump back to os


      Memory[32'd749572] <= 32'b00_0111_00101_00000_00000_00000000000;//Open Door
      Memory[32'd749573] <= 32'b00_0111_11101_00101_00000_00000000000;							
      //Now store in register 29
      Memory[32'd749574] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      Memory[32'd749575] <= 32'b00_1001_00101_000000000000000000000; //Close Door
      Memory[32'd749676] <= 32'b00_0111_11101_00101_00000_00000000000;
      //Now store in register 29
      Memory[32'd749677] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      Memory[32'd749678] <= 32'b00_1001_00010_000000000000000000000; //Turn off (register 4)
      Memory[32'd749679] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os
//*749612
      /***************************************** Thermostat ************************************************/

      Memory[32'd458752] <= 32'b01_00000_00110_0000_0000_0001_0100;
      // check status - beq power register (6), zero register
      // loads the state of the thermostat - NOT AN INSTRUCTION - raise, lower, autoset

      // writing to register 7 - state register
      Memory[32'd458753] <= 32'b00_1001_00111_11101_0000000000000000;
      //Register 7 is the state for temp

      //Checking if this is first run
      Memory[32'd458754] <= 32'b00_0111_00110_00001_00000_00000000000;
      //Store in register 6
      Memory[32'd458755] <= 32'b00_1010_00000_00000_0000_0000_0001_0100; //Jump back to os

      //Increment temp
      Memory[32'd458756] <= 32'b00_0001_11111_00111_11101_00000000000;
      //incrementing temp register by 1
      Memory[32'd458757] <= 32'b00_0111_00111_11101_00000_00000000000;
      //Now store in register 29
      Memory[32'd458758] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      //Decrement temp
      Memory[32'd458759] <= 32'b00_0010_11111_00111_11101_00000000000;
      //decrements temp register by 1
      Memory[32'd458760] <= 32'b00_0111_00111_11101_00000_00000000000;
      //Now store in register 29
      Memory[32'd458761] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      //Autoset temp
      Memory[32'd458762] <= 32'b00_1001_01000_000000000000001000100;
      //Autoset temp to 68 degrees (register 8)

      Memory[32'd458763] <= 32'b00_0111_11101_01000_00000_00000000000;
      //Now store in register 29
      Memory[32'd458764] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      Memory[32'd458765] <= 32'b00_1001_00110_000000000000000000000; //Turn off (register 6)
      Memory[32'd458766] <= 32'b00_1010_00000_00000_0000_0000_0001_0100;//Jump back to os

      //*458808
 /***************************************** Home Security ************************************************/

      //check status - beq power register (9), zero register
      // loads the state of the security - NOT AN INSTRUCTION - lock, unlock, alarm
      Memory[32'd229376] <= 32'b00_0111_01010_11111_0000000000000000;
      // writing to register 10 - state register 29
      Memory[32'd229377] <= 32'b00_0111_11101_01010_0000000000000000;

      // Load PIN from reg 30 - Register 11 is the PIN
      Memory[32'd229378] <= 32'b00_0111_11110_01011_0000000000000000;

      //Checking if this is first run
    //  Memory[32'd229379] <= 32'b00_0111_01001_11111_0000000000000000;
      //Store in register 9

      //Jump back to os
      Memory[32'd229379] <= 32'b00_1010_0000000000000000000010100;


      //Lock
      // Load PIN from reg 30 - Register 12 is the PIN
	  Memory[32'd229380] <= 32'b00_1001_11110_00000_00000_00000000101;
	  
      Memory[32'd229381] <= 32'b00_0111_01100_11110_0000000000000000;

      //Compare inputted PIN to stored one, if true go to 32d229384
      Memory[32'd229382] <= 32'b01_01100_01011_00111000000000001000;

      //Go back to retry (32d229381)
      Memory[32'd229383] <= 32'b00_1010_00000000111000000000000100;

      //Place 1 in reg 10
      Memory[32'd229384] <= 32'b00_0111_01010_11111_0000000000000000;

      //Lock System
      Memory[32'd229385] <= 32'b00_0111_01101_00000_00000_00000_000000;
			
      //Jump back to OS
      Memory[32'd229386] <= 32'b00_1010_00000_00000_00000_000000_10100;
	

      //Unlock
      // Load PIN from reg 30 - Register 12 is the PIN
	  
//      Memory[32'd229387] <= 32'b00_0111_01100_11110_0000000000000000;
		Memory [32'd229387] <= 32'b00_1001_01100_000000000000000000101;
      //Compare inputted PIN to stored one, if true go to 32d229390
      Memory[32'd229388] <= 32'b01_01100_01011_00111000000000001110;

      //Go back to retry (32d229387)
      Memory[32'd229389] <= 32'b00_1010_00000000111000000000001011;

      //Place 0 in reg 10
      Memory[32'd229390] <= 32'b00_0111_01010_00000_0000000000000000;
      //Unlock System
      Memory[32'd229391] <= 32'b00_0111_11101_01010_0000000000000000;
      //Place 0 in Reg 13
      Memory[32'd229392] <= 32'b00_0111_01101_00000_0000000000000000;
      //Make system shutoff alarm
      Memory[32'd229393] <= 32'b00_0111_11101_01101_0000000000000000;
      //Jump back to OS
      Memory[32'd229394] <= 32'b00_1010_0000000000000000000010100;


      //Alarm
      //Place 1 in reg 13
      Memory[32'd229395] <= 32'b00_0111_01101_11111_0000000000000000;
      //Make system give alarm
      Memory[32'd229396] <= 32'b00_0111_11101_01101_0000000000000000;
      //Go back to retry (32d229387)
      Memory[32'd229397] <= 32'b00_00000000111000000000001011;
      //Jump back to OS
      Memory[32'd229398] <= 32'b00_1010_0000000000000000000010100;

       /***************************************** USB ************************************************/

      Memory[32'd57344] <= 32'b01_00000_01110_00000000000000010100;
      //check status - beq power register (14), zero register
      // loads the state of the security - NOT AN INSTRUCTION - dump

      //Checking if this is first run
      Memory[32'd57345] <= 32'b00_0111_01110_11111_0000000000000000;
      //Store in register 14
      Memory[32'd57346] <= 32'b00_1010_0000000000000000000010100;					/* Jump back to operating system		*/

	  /* Interrupt - Dump Status registers */
	  
      Memory[32'd57347] <= 32'b00_0111_11101_00011_0000000000000000;				/* Dump Status Registers to Register 29	*/
      Memory[32'd57348] <= 32'b00_0111_11101_00100_0000000000000000;				/* Status Registers are R23 - R29		*/
      Memory[32'd57349] <= 32'b00_0111_11101_00110_0000000000000000;
      Memory[32'd57350] <= 32'b00_0111_11101_01001_0000000000000000;
      Memory[32'd57351] <= 32'b00_0111_11101_01110_0000000000000000;
	  Memory[32'd57352] <= 32'b00_1001_01110_000000000000000000000;
      Memory[32'd57353] <= 32'b00_1010_00000_000000000000000010100;					/* Jump back to operating system		*/
						   
	
  end
	
  integer trigger = 1;
  integer startup = 1;
  
  always @ (posedge clock or load or store )
    if (i_enable && trigger == 1) 
	begin
		if (store) Memory[i_address] <= data_in;
		
		else if (load) 
		begin 
			data_out <= Memory[i_address]; 
			trigger = 0; 
		end
	end
	
	else if (i_enable == 0 && (startup || trigger == 0))
	begin
		if (store) Memory[address] <= data_in;
    
		else if (load)   
		begin
			data_out <= Memory[address];
			trigger = 1;
		end
	end
	
endmodule
  
  