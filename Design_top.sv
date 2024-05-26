import my_pkg::*;

module I2C_top(
    input logic clk,
    input logic reset_n,
    input logic Master_en,
    input logic R_W_en,
    input address_t Mem_Addr,
    input byte_t Data,
    output byte_t data_out,
    output done,
    input [2:0] S,
    input MSBIn,
    input LSBIn
);
 wire SDA,SCL;
 wire ACKT;
 byte_t data_in;       // sending from memory ram . 
 byte_t  data_write;  // sending to memory ram .
 address_t address;     // sending to memory ram .
 wire wr_en;            // read write enable for memory ram 
 byte_t data_final;

 byte_t SR_out;

 I2C DUT (.clk(clk),.reset_n(reset_n),.Mem_Addr(Mem_Addr),.Data(SR_out),.Master_en(Master_en),.SDA(SDA),.SCL(SCL),.ACKT(ACKT),.R_W_en(R_W_en));
 
 Controller Dut1(.SDA(SDA),.SCL(SCL),.clk(clk),.reset_n(reset_n),.data_in(data_final),.data_out(data_out),.data_write(data_write),.address(address),.wr_en(wr_en),.done(done),.ACKT(ACKT));
 
 memory DUT2 (.clk(clk),.reset_n(reset_n),.data_write(data_write),.address(address),.wr_en(wr_en),.data_final(data_final));


ShiftRegister SR(.Q(SR_out), .clk(clk), .Clear(reset_n), .D(Data), .S(S), .MSBIn(MSBIn), .LSBIn(LSBIn));

endmodule