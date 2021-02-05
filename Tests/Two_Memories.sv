`timescale 1ns / 1ps

module Memory #(
type T = reg,
parameter data_width = 8,
parameter size = 1024)();
    T [data_width-1:0] memory [0:size-1];
    typedef logic unsigned [$clog2(size)-1:0] Address;
    typedef logic unsigned [data_width-1:0] Data;
    function int unsigned get_data_width();
        return data_width;
    endfunction: get_data_width
    function int unsigned get_size();
        return size;
    endfunction: get_size
    task write(input Address address, input Data data);
        memory[address] = data;
    endtask: write
    task read(input Address address, output Data data);
        assign data = memory[address];
    endtask: read
endmodule: Memory

module Test;
    localparam four_gigs     = 33'd4294967296;
    localparam sixty_four_MB = 27'd67108864;
    logic unsigned [7:0] from_host;
    logic unsigned [7:0] from_controller;
    
    Memory#(.size(four_gigs))     host_memory();
    Memory#(.size(sixty_four_MB)) controller_memory();

    initial begin
    
        for (int unsigned address = 0; address < 51200; address++) begin
            host_memory.write(.address(address), .data($urandom_range(255)));
        end
        
        for (int unsigned address = 0; address < 51200; address++) begin
            host_memory.read(.address(address), .data(from_host));
            controller_memory.write(.address(address), .data(from_host));
        end
        
        for (int unsigned address = 0; address < 51200; address++) begin
            controller_memory.read(.address(address), .data(from_controller));
            host_memory.write(.address(address + 51200), .data(from_controller));
        end
        
        for (int unsigned address1 = 0, address2 = 51200; address1 < 51200; address1++, address2++) begin
            host_memory.read(.address(address1), .data(from_host));
            host_memory.read(.address(address2), .data(from_controller));
            assert(from_host == from_controller);
        end
        
    end
endmodule: Test
