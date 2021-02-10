`timescale 1ns / 1ps

// This module latches multiple bits
module Latches(set, clk, out);
    input logic [9:0] set;
    input logic clk;
    output logic [9:0] out;
    always_latch begin
        if (clk) begin
            out <= set;
        end else begin
            out <= out;
        end
    end
endmodule: Latches

// test the multiple latches
module Latches_Testbench;

    // define signals
    logic [9:0] set, out;
    logic clk;
    
    // instantiate latches
    Latches latches(.set(set), .out(out), .clk(clk));
    
    // generate clock
    initial begin
        clk = 1'b1;
        forever begin
            #10;
            clk = ~clk;
        end
    end
    
    // generate stimulus
    initial begin
        #100;
        // press each button and verify that it is latched.
        for (int i = 0; i < 10; i++) begin
            set[i] = 1'b1;
            #20;
            assert(out[i] == 1'b1) $info("Pass. Key %d latched", i); else $fatal("Fail.");
        end

        #100;
        // clear all the latches
        for (int i = 0; i < 10; i++) begin
            set[i] = 1'b0;
        end

        #100;
        // latch keys 02468 (even numbers)
        for (int i = 0; i < 10; i+=2) begin
            set[i] = 1'b1;
        end

        #100;
        assert(out == 341) $info("Correct sequence confirmed."); else $fatal("Failed to enter even digits.");
        #100;

        // clear all the latches
        for (int i = 0; i < 10; i++) begin
            set[i] = 1'b0;
        end
        #100;
        
        $finish;
    end
    
endmodule: Latches_Testbench
