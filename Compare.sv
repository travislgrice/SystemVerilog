`timescale 1ns / 1ps

/* On each enable assertion, this (currently) 4-bit counter 
   increments the output by 1 and when the output reaches 15 
   wraps the value back to zero.*/
module Compare(left, right, result);
    input logic [9:0] left, right;
    output logic result;
    assign result = (left == right);
endmodule: Compare
