module memory( 
    input logic clk,
    input logic reset_n,
    input [7:0] data_write,
    input [6:0] address,
    input  wr_en,
     output logic [7:0] data_final
   );


logic [8-1:0]  RAM [2**7-1:0] ;

always_ff @( posedge clk or negedge reset_n ) begin 
        if(reset_n==1'b0) RAM <= '{default:'0};
        else if(~wr_en) RAM[address] <= data_write;
end


always_comb begin : Read_block
    if(wr_en) data_final = RAM[address];
end

endmodule
