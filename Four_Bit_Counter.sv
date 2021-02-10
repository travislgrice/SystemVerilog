`timescale 1ns / 1ps

/* On each enable assertion, this (currently) 4-bit counter 
   increments the output by 1 and when the output reaches 15 
   wraps the value back to zero.*/
module Counter(enable, reset, out);
    input logic enable;
    input logic reset;
    output logic [3:0] out;
    initial begin
        out = 4'h0;
    end
    always @(posedge enable) begin
        out = reset ? 4'h0 : out + 1;
    end
    
    always @(posedge reset) begin
        out = 4'h0;
    end
endmodule: Counter

module Counter_Testbench;
    logic enable, reset;
    logic [3:0] out;
    Counter counter(.enable(enable), .reset(reset), .out(out));
    initial begin
        // reset, enable, hold, and reset again. pass.
        /* The simulation shows if enable is held high, the count increases,
           but does not continue to increase. Then the reset puts the count
           back at zero which is the correct behavior. pass. */
        reset = 1'b1;
        #20;
        reset = 1'b0;
        #20;
        enable = 1'b1;
        #100;
        enable = 1'b0;
        #20;
        reset = 1'b1;
        #100;
        reset = 1'b0;
        #100;
        
        // simultaneous enable and reset behavior - reset overrides enable. pass.
        for (int i = 0; i < 10; i++) begin
            enable = 1'b1;
            reset = 1'b1;
            #20;
            enable = 1'b0;
            reset = 1'b0;
            #20;
        end
        
        #100;
        
        // count up to 15 then wrap around. pass.
        reset = 1'b1; #100; reset = 1'b0;
        for (int i = 0; i < 17; i++) begin
            enable = 1'b1; #20; enable = 1'b0; #20;
        end
        #100;
        $finish;
    end
endmodule: Counter_Testbench
