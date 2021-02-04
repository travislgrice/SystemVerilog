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

module Testbench();
    Memory#(.data_width(32), .size(1000)) memory();
    int unsigned data_in  = 32'h98798798;
    int unsigned data_out = 32'h00000000;
    int unsigned address  = 10'h34567;
    initial begin
        $display("memory.get_data_width() = %0d",memory.get_data_width());
        $display("memory.get_size() = %0d double words.", memory.get_size());
        $display("memory.get_size() = %0.3f kb", memory.get_size() * memory.get_data_width() / 8.0 / 1024.0);
        memory.write(.address(address), .data(data_in));
        memory.read(.address(address), .data(data_out));
        $display("data_in  = %h", data_in);
        $display("data_out = %h", data_out);
        assert(data_in == data_out);
    end
endmodule: Testbench
