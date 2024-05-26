module ShiftRegister (
    Q, clk, Clear, D, S, MSBIn, LSBIn
);
    parameter nBits = 8;

    output [nBits-1:0] Q;
    input clk;
    input Clear;
    input [nBits-1:0] D;
    input [$clog2(nBits)-1:0] S;
    input MSBIn;
    input LSBIn;

    wire [7:0] Y;

    // This generate construct is used to generate required MUX's at elaboration time
    genvar i;
    Mux8to1 MuxFirst(.Y(Y[0]), .V({1'b0, Q[1], Q[7], Q[1], LSBIn, Q[1], D[0], Q[0]}), .S(S));
    generate
        for(i = 0; i < (nBits-2); i = i + 1) begin:Mux
            Mux8to1 m (.Y(Y[i+1]), .V({Q[i], Q[i+2], Q[i], Q[i+2], Q[i], Q[i+2], D[i+1], Q[i+1]}), .S(S));
        end
    endgenerate
    Mux8to1 MuxLast(.Y(Y[7]), .V({Q[6], Q[7], Q[6], Q[0], Q[6], MSBIn, D[7], Q[7]}), .S(S));

    // This generate construct is used to generate required DFF's at elaboration time
    genvar j;
    generate
        for(j = 0; j < (nBits); j = j + 1) begin:Dff
            DFF FF0(.Q(Q[j]), .Clock(clk), .Clear(Clear), .D(Y[j]));
        end
    endgenerate
endmodule
