module DFF (
    Q, Clock, Clear, D
);
    output reg Q;
    input Clock;
    input Clear;    // Clear is active low
    input D;

    always_ff @(posedge Clock or negedge Clear) begin
        if (~Clear) Q <= '0;
        else        Q <= D;
    end
endmodule       