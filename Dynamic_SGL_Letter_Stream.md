`timescale 1ns / 1ps

module Testbench();    

    byte unsigned memory1 [0:10'h3FF];
    
    byte unsigned memory2 [19'h50000:19'h5FFFF];
    byte unsigned memory3 [19'h60000:19'h6FFFF];
    
    int unsigned letter_count = 0;
    int unsigned non_letter_count = 0;
    
    longint unsigned i = 19'h50000;
    longint unsigned j = 19'h60000;
    
    int unsigned buffer_length_1 = 0;
    int unsigned number_of_data_blocks = 0;
    
    virtual class SGL_Descriptor;
        int unsigned l;
        function new(int unsigned length);
            l = length;
        endfunction: new
        function int unsigned length();
            return l;
        endfunction: length
    endclass: SGL_Descriptor
    
    class Data_Block_Descriptor extends SGL_Descriptor;
        local int unsigned l;
        local longint unsigned a;
        function new(int unsigned length, longint unsigned address);
            super.new(length);
            a = address;
        endfunction: new
        function longint unsigned address();
            return a;
        endfunction: address
    endclass: Data_Block_Descriptor
    
    class Bit_Bucket_Descriptor extends SGL_Descriptor;
        function new(int unsigned length);
            super.new(length);
        endfunction: new
    endclass: Bit_Bucket_Descriptor
    
    SGL_Descriptor descriptor;
    Data_Block_Descriptor data_block_descriptor;
    Bit_Bucket_Descriptor bit_bucket_descriptor;
    
    initial begin
        // test 1KB memory with address from 0 to 1023
        memory1[32] = 116;
        memory1[33] = 114;
        memory1[34] = 97;
        memory1[35] = 118;
        memory1[36] = 105;
        memory1[37] = 115;
        // for-loop prints "travis"
        for (int i = 32; i < 38; i++) begin
            $write("%c",memory1[i]);
        end
        
        //increase memory to support addresses from 50000h to 5FFFFh
        for (int unsigned i = 0; i < 100; i++) begin
            if (i % 10 == 0) begin
                $write("\n");
            end
            $write("%d ", memory2[i]);
        end
        $display("\n");
        
        //create another memory with addresses from 60000h to 6FFFFh
        //fill memory2 with random data
        for (int unsigned index = 19'h50000; index < 19'h60000; index++) begin
            byte unsigned random_byte = $urandom_range(.minval(0), .maxval(255));
            $display("memory2[%h]=%h", index, random_byte);
            memory2[index] = random_byte;
        end
        
        // show the data from 50000h to 5FFFFh
        for (int unsigned i = 19'h50000; i < 19'h60000; i++) begin
            if (i % 32 == 0) begin
                $write("\n");
            end
            $write("%d ", memory2[i]);
        end
        $display("\n");
        
        // print only upper and lower cased letters
        for (int unsigned i = 19'h50000; i < 19'h60000; i++) begin
            if (i % 32 == 0) begin
                $write("\n");
            end
            if ((memory2[i] >= 65 && memory2[i] <= 90) ||
                (memory2[i] >= 97 && memory2[i] <= 122)) begin
                $write("%d ", memory2[i]);
                buffer_length_1++;
            end else begin
                $write(" -- ");
            end
        end
        $display("\n");
        
        // Suppose a buffer is a range of addresses containing only letters...
        // Create a list of data block descriptors and bit bucket descriptors
        // that describe the entire letter buffer in memory2...
        
        // If the byte is a letter start to create a data_block_descriptor
        // else start to create a bit bucket descriptor

        i = 19'h50000;
        j = 19'h60000;
        while(i < j) begin
            while((memory2[i] >= 65 && memory2[i] <= 90) ||
                  (memory2[i] >= 97 && memory2[i] <= 122)) begin
                if (i >= j) break;
                letter_count++;
                i++;
            end
            if (letter_count > 0) begin
                data_block_descriptor = Data_Block_Descriptor::new(.length(letter_count), .address(i - letter_count));
                number_of_data_blocks++;
                descriptor = data_block_descriptor;
                letter_count = 0;
            end

            
            while((memory2[i] < 65 || (memory2[i] > 90 && memory2[i] < 97) || memory2[i] > 122)) begin
                if (i >= j) break;
                non_letter_count++;
                i++;
            end
            if (non_letter_count > 0) begin
                bit_bucket_descriptor = Bit_Bucket_Descriptor::new(.length(non_letter_count));
                descriptor = bit_bucket_descriptor;
                non_letter_count = 0;
            end
        end
        $display("End of descriptor creation.");
        $display("number_of_data_blocks = %d", number_of_data_blocks);
        $display("buffer_length_1 = %d", buffer_length_1);
        $display("\n");
        
        $finish;
    end
endmodule
