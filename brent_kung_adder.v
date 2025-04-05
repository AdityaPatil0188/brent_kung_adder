`timescale 1ns / 1ps

module brent_kung_adder(
    input [31:0] a, 
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout
);

wire [31:0] c;
wire [31:0] g0, p0;
wire [15:0] g1, p1;
wire [7:0] g2, p2;
wire [3:0] g3, p3;
wire [1:0] g4, p4;
wire g5, p5;
wire [3:0] x;

assign c[0] = cin;
    and (x[0], a[0], b[0]);
    or (x[1], a[0], b[0]);
    and (x[2], c[0], x[1]);
    or #1(g0[0], x[2], x[0]); //assign g[0] = (a[0] & b[0]) | (c[0] & (a[0] | b[0]));
    
genvar z, i, j, k, l, m;

generate
    for (z = 0; z < 32; z = z + 1) begin: sum_loop
        xor #1(sum[z], a[z], b[z], c[z]);  //assign sum = a ^ b ^ c;
    end
endgenerate

generate

    for (i = 1; i < 32; i = i + 1) begin : slot1
        and #1(g0[i], a[i], b[i]); 
        xor #1(p0[i], a[i], b[i]);
    end
    assign c[1] = g0[0];
    
    for (j = 0; j < 16; j = j + 1) begin: slot2
        g2bits ga (g0[2*j+1:2*j], p0[2*j+1], g1[j]);
        p2bits pa (p0[2*j+1:2*j], p1[j]);
    end
    assign c[2] = g1[0];
    
    for (k = 0; k < 8; k = k + 1) begin: slot3
        g2bits gb (g1[2*k+1:2*k], p1[2*k+1], g2[k]);
        p2bits pb (p1[2*k+1:2*k], p2[k]);
        c_assign uut3 (g0[2], p0[2], c[2], c[3]);
    end
    assign c[4] = g2[0];
    
    for (l = 0; l < 4; l = l + 1) begin: slot4
        g2bits gc (g2[2*l+1:2*l], p2[2*l+1], g3[l]);
        p2bits pc (p2[2*l+1:2*l], p3[l]); 
    end
    assign c[8] = g3[0];
    c_assign uut41 (g0[4], p0[4], c[4], c[5]);
    c_assign uut42 (g1[2], p1[2], c[4], c[6]);
    
    for (m = 0; m < 2; m = m + 1) begin: slot5
        g2bits gd (g3[2*m+1:2*m], p3[2*m+1], g4[m]);
        p2bits pd (p3[2*m+1:2*m], p4[m]);    
    end
    assign c[16] = g4[0];
    c_assign uut51 (g0[6], p0[6], c[6], c[7]);
    c_assign uut52 (g0[8], p0[8], c[8], c[9]);
    c_assign uut53 (g1[4], p1[4], c[8], c[10]);
    c_assign uut54 (g2[2], p2[2], c[8], c[12]);

endgenerate

// slot6
g2bits ge (g4[1:0], p4[1], g5);
p2bits pe (p4[1:0], p5);
assign cout = g5;
c_assign uut61 (g0[10], p0[10], c[10], c[11]);
c_assign uut62 (g0[12], p0[12], c[12], c[13]);
c_assign uut63 (g1[6], p1[6], c[12], c[14]);
c_assign uut64 (g0[16], p0[16], c[16], c[17]);
c_assign uut65 (g1[8], p1[8], c[16], c[18]);
c_assign uut66 (g2[4], p2[4], c[16], c[20]);
c_assign uut67 (g3[2], p3[2], c[16], c[24]);

// slot7
c_assign uut71 (g0[14], p0[14], c[14], c[15]);
c_assign uut72 (g0[18], p0[18], c[18], c[19]);
c_assign uut73 (g0[20], p0[20], c[20], c[21]);
c_assign uut74 (g1[10], p1[10], c[20], c[22]);
c_assign uut75 (g0[24], p0[24], c[24], c[25]);
c_assign uut76 (g1[12], p1[12], c[24], c[26]);
c_assign uut77 (g2[6], p2[6], c[24], c[28]); 
   
// slot8
c_assign uut81 (g0[22], p0[22], c[22], c[23]);
c_assign uut82 (g0[26], p0[26], c[26], c[27]);
c_assign uut83 (g0[28], p0[28], c[28], c[29]);
c_assign uut84 (g1[14], p1[14], c[28], c[30]);
    
// slot9
c_assign uut91 (g0[30], p0[30], c[30], c[31]);

endmodule



module c_assign(
    input G, P, C,
    output co   
);
wire z;
    and (z, P, C);
    or #1(co, z, G);  //assign co = G | (P & C);
endmodule



module g2bits(
    input [1:0] g2,
    input p2,
    output g2o
);
wire y;
    and (y, g2[0], p2);
    or #1(g2o, g2[1], y);  //assign g2o = g2[1] | (g2[0] & p2);
endmodule



module p2bits(
    input [1:0] p2,
    output p2o
);
    and #1(p2o, p2[1], p2[0]);
endmodule
