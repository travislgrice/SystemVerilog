module State_Machine(clock, state);
    input logic clock;
    output logic unsigned [1:0] state;
    // state values
    enum {a, b, c, d} current_state, next_state;
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
        current_state <= next_state;
        state = current_state;
    end
endmodule: State_Machine;
