`timescale 1ns / 1ps

module State_Machine_Testbench;

    module State_Machine(clock, state);
        input logic clock;
        output logic unsigned [1:0] state;
        
        enum {a, b, c, d} current_state, next_state;
        // state values
        
        // state table
        always_comb begin
            case(current_state)
                a : next_state = b;
                b : next_state = c;
                c : next_state = d;
                d : next_state = a;
                default : next_state = current_state;
            endcase
        end
        
        always_ff @(posedge clock) begin
            $write("current_state = %s at %0tps. ", current_state.name(), $time);
            current_state <= next_state;
            state = current_state;
            $display("next_state = %s\n", next_state.name());
        end
        
    endmodule: State_Machine;
    
    // Start of initialization and testing
    logic clock = 1'b1;
    
    // this variable is for monitoring the internal state via waveform
    logic unsigned [1:0] state;                      
    
    State_Machine state_machine(.clock(clock), .state(state));
    
    // Generate clock stimulus
    always begin
        #10;
        clock = ~clock;
    end
    
    // Generate clock stimulus for 10 clock periods
    initial begin
        for (int i = 0; i < 10; i++) begin
            $write("i = %0d. ", i);
            #20;
        end
        $finish;
    end

endmodule: State_Machine_Testbench
