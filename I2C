module I2C(input bit clk,
	   input logic Reset,
	   input logic [7:0] Din,
	   input logic [6:0] Addr,
	   input logic RW_en,
	   input logic Ack_addr,
	   input logic Ack_data,
	   input logic Start,
	   input logic Stop,
	   inout logic SDA,
	   output logic SCL);

enum {  IDLE = 0,
	START = 1,
	ADDR = 2,
	WRITE = 3,
	READ = 4,
	ACK_ADDR = 5,
	DATA = 6,
	ACK_DATA = 7,
	STOP = 8} State_bit;

enum logic [8:0] { 	Idle = 9'd1 << IDLE,
		   	Start = 9'd1 << START,
			Addr = 9'd1 << ADDR,
			Write = 9'd1 << WRITE,
			Read = 9'd1 << READ,
			Ack_addr = 9'd1 << ACK_ADDR,
			Data = 9'd1 << DATA,
			Ack_data = 9'd1 << ACK_DATA,
			Stop = 9'd1 << STOP} state,next_state;



always_ff @(posedge clk)
begin
  if(!Reset)
  state <= Idle;
  else 
  state <= next_state;
end

always_comb
begin
next_state = state;
unique case(1'b1)
  Idle    : if(Reset)
            next_state = Idle;
            else 
            next_state = Start;
  Start   : if(Reset)
            next_state = Idle;
            else
            next_state = Addr;
  Addr    : if(Reset)
            next_state = Idle;
            else if(count_addr !=0)
            next_state = Addr;
            else if(count_addr == 0 && RW_en == 0)
            next_state = Write;
            else if(count_addr == 0 && RW_en == 1)
            next_state = Read;
  Write   : next_state = Ack_addr;
  Read    : next_state = Ack_addr;
  Ack_addr: next_state = Data;
  Data    : if(count_data != 0)
            next_state = Data;
            else
            next_state = Ack_data;
  Ack_data: next_state = Stop;
  Stop    : if(Reset)
            next_state = Idle;
            else
            next_state = Start;
  
endcase
end


always_comb
begin
next_state = state;
unique case(1'b1)
  Idle      : begin SDA = 1; SCL = 1; end   
  Start     : begin SDA = 0; SCL = 1; end
  Addr      : begin SDA = 0; SCL = 0; end
  Write     : begin SDA = 0; SCL = 0; end
  Read      : begin SDA = 0; SCL = 0; end
  Ack_addr  : begin SDA = 0; SCL = 0; end
  Data      : begin SDA = 0; SCL = 0; end
  Ack_data  : begin SDA = 0; SCL = 0; end
  Stop      : begin SDA = 1; SCL = 1; end
endcase
end


endmodule
