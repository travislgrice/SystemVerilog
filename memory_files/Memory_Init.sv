`timescale 1ns / 1ps
/* First time working with a memory file. 
   See IEEE 1800-2017 Page 645 
   Chapter 21.4 Loading memory array data from a file. */
module Memory_Init;
    logic [7:0] main_memory [0:1023];
    initial begin
        $readmemh("host_memory.mem", main_memory);
        $display(main_memory[100]);                // just prints 100  
    end
endmodule: Memory_Init
