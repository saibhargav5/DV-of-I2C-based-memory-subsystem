module Mux8to1 (
    Y, V, S
);
    parameter SELECT_BITS = 3;
    localparam INPUT_BITS = 2 ** SELECT_BITS;

    output Y;
    input [INPUT_BITS-1:0] V;
    input [SELECT_BITS-1:0] S;

    assign Y = V[S];
endmodule