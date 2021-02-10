`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/* The always_latch construct is identical to the always_comb procedure for     */
/* modeling latched logic behavior. For example:                                */
/*                                                                              */
/*     always_latch                                                             */
/*         if(ck) q <= d;                                                       */
//////////////////////////////////////////////////////////////////////////////////
module Sandbox;

    // Sample module with always_latch construct
    module Latch_Logic(d, ck, q);
        input logic ck;
        input logic d;
        output logic q;
        always_latch
            if(ck) q <= d;
    endmodule: Latch_Logic
    
    // Test signals
    logic D, clk, Q;
    
    // Clock generation
    always begin
        #10;
        clk = ~clk;
    end
    
    // Instantiate the latch module.
    Latch_Logic latch_logic_test(.d(D), .ck(clk), .q(Q));
    
    //////////////////////////////////////////////////////////////////////////////////
    /* Q goes high at 110ns, stays high for 100ns and goes low at 210ns             */
    //////////////////////////////////////////////////////////////////////////////////
    initial begin
        clk = 1'b0;
        #100;
        D = 1'b1;
        #100;
        D = 1'b0;
        #100;
        $finish;
    end
    
endmodule: Sandbox
