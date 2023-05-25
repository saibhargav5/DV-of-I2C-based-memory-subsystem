module I2C(input bit clk,
		   input logic Reset,
//		   input logic [7:0] Din,
//		   input logic [6:0] Addr,
		   input logic RW_en,
		   input int count_addr,
		   input int count_data,
		   output logic SDA,
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

always_comb begin: set_nextstate
next_state = state;
unique case(1'b1)
  state[IDLE]    :  if(Reset)
					next_state = Idle;
					else 
					next_state = Start;
  state[START]   :  if(Reset)
					next_state = Idle;
					else
					next_state = Addr;
  state[ADDR]    :  if(Reset)
					next_state = Idle;
					else if(count_addr !=0)
					next_state = Addr;
					else if(count_addr == 0 && RW_en == 0)
					next_state = Write;
					else if(count_addr == 0 && RW_en == 1)
					next_state = Read;
  state[WRITE]   :  next_state = Ack_addr;
  state[READ]    :  next_state = Ack_addr;
  state[ACK_ADDR]:  next_state = Data;
  state[DATA]    :  if(count_data != 0)
					next_state = Data;
					else
					next_state = Ack_data;
  state[ACK_DATA]:  next_state = Stop;
  state[STOP]    :  if(Reset)
					next_state = Idle;
					else
					next_state = Start;
  
endcase
end: set_nextstate


always_comb begin: set_outputs
{SDA,SCL} = '0;
unique case(1'b1)
  state[IDLE]      : begin SDA = 1; SCL = 1; end   
  state[START]     : begin SDA = 0; SCL = 1; end
  state[ADDR]      : begin SDA = 0; SCL = 0; end
  state[WRITE]     : begin SDA = 0; SCL = 0; end
  state[READ]      : begin SDA = 0; SCL = 0; end
  state[ACK_ADDR]  : begin SDA = 0; SCL = 0; end
  state[DATA]      : begin SDA = 0; SCL = 0; end
  state[ACK_DATA]  : begin SDA = 0; SCL = 0; end 
  state[STOP]      : begin SDA = 1; SCL = 1; end
endcase
end: set_outputs


endmodule
