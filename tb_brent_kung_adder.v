`timescale 1ns / 1ps

module tb_brent_kung_adder();
    reg [31:0] a;
    reg [31:0] b;
    reg cin;
    wire [31:0] sum;
    wire cout;
    wire err;
    integer file;
    integer i;

    brent_kung_adder uut (a, b, cin, sum, cout);

    initial begin
        
        file = $fopen("test_data.txt", "r");

        for (i = 0; i < 16; i = i + 1) begin
            $fscanf(file, "%h %h\n", a, b);
            cin = 1;
            #20; 
            cin = 0;
            #20; 
        end

        $fclose(file);
        $finish;
    end

endmodule
