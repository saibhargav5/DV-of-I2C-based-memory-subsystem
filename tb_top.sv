import my_pkg::*;

interface INTF;
    logic clk;
    logic reset_n;
    logic Master_en;
    logic R_W_en;
    address_t Mem_Addr;
    byte_t Data;
    byte_t data_out;
    logic done;
    logic [2:0] S;
    logic MSBIn,LSBIn;
endinterface //INTF



class Random_Data;

virtual INTF in;
rand bit MSB;
rand bit LSB;
static int pass, fail;

logic [7:0] T;

constraint msb_range {MSB == 1;}
constraint lsb_range {LSB == 0;}


function new(virtual INTF in);
this.in = in;
endfunction


task write_run();
Load_SR();
Right_SF();
LEFT_SF();
ROTATE_RT();
ROTATE_LT();
AR_RT();
AR_LT();
endtask

task read_run();
RIGHT_GOODMODEL(); 
LEFT_GOODMODEL();
RR_GOODMODEL();
LR_GOODMODEL();
ASR_GOODMODEL();
ASL_GOODMODEL();
endtask


task Load_SR();
in.reset_n = 0;
repeat(1) @(negedge in.clk); 
in.Data = $urandom_range(10,255);
in.reset_n = 1;
in.S = 3'd1;
T= Goodmodel(in.Data,in.S,in.MSBIn,in.LSBIn,1);
@(negedge in.clk);
endtask

task Right_SF();
@(negedge in.clk);
in.MSBIn = 1; in.LSBIn = 0; in.S = 3'd2;
@(negedge in.clk);
in.S = 3'd0;
@(negedge in.clk);
in.Master_en = 1;
in.Mem_Addr = $urandom_range(7,100);
in.R_W_en = 0;
@(posedge in.clk) in.Master_en = 0;
repeat(23) @(posedge in.clk);
@(negedge in.clk);
 endtask

task LEFT_SF();
in.MSBIn = 1; in.LSBIn = 0; in.S = 3'd3;
@(negedge in.clk);
in.S = 3'd0;
@(negedge in.clk);
in.Master_en = 1;
in.Mem_Addr = in.Mem_Addr + 1;
in.R_W_en = 0;
@(posedge in.clk) in.Master_en = 0;
repeat(23) @(posedge in.clk);
@(negedge in.clk);
endtask


task ROTATE_RT();
in.MSBIn = 1; in.LSBIn = 0; in.S = 3'd4;
@(negedge in.clk);
in.S = 3'd0;
@(negedge in.clk);
in.Master_en = 1;
in.Mem_Addr = in.Mem_Addr + 1;
in.R_W_en = 0;
@(posedge in.clk) in.Master_en = 0;
repeat(23) @(posedge in.clk);
@(negedge in.clk);
endtask



task ROTATE_LT();
in.MSBIn = 1; in.LSBIn = 0; in.S = 3'd5;
@(negedge in.clk);
in.S = 3'd0;
@(negedge in.clk);
in.Master_en = 1;
in.Mem_Addr = in.Mem_Addr + 1;
in.R_W_en = 0;
@(posedge in.clk) in.Master_en = 0;
repeat(23) @(posedge in.clk);
@(negedge in.clk);
endtask





task AR_RT();
in.MSBIn = 1; in.LSBIn = 0; in.S = 3'd6;
@(negedge in.clk);
in.S = 3'd0;
@(negedge in.clk);
in.Master_en = 1;
in.Mem_Addr = in.Mem_Addr + 1;
in.R_W_en = 0;
@(posedge in.clk) in.Master_en = 0;
repeat(23) @(posedge in.clk);
@(negedge in.clk);
endtask


task AR_LT();
in.MSBIn = 1; in.LSBIn = 0; in.S = 3'd7;
@(negedge in.clk);
in.S = 3'd0;
@(negedge in.clk);
in.Master_en = 1;
in.Mem_Addr = in.Mem_Addr + 1;
in.R_W_en = 0;
@(posedge in.clk) in.Master_en = 0;
repeat(23) @(posedge in.clk);
endtask







task RIGHT_GOODMODEL();
repeat(1) @(negedge in.clk); 
    in.Master_en = 1;
    in.Mem_Addr = in.Mem_Addr - 5;
    in.R_W_en = 1;
 @(posedge in.clk) in.Master_en = 0;   
 repeat(13)@(posedge in.clk);
@(negedge in.clk);
  T= Goodmodel(in.Data,3'd2,1,0,1);
endtask

task LEFT_GOODMODEL();

repeat(1) @(negedge in.clk); 
    in.Master_en = 1;
    in.Mem_Addr = in.Mem_Addr + 1;
    in.R_W_en = 1;
    @(posedge in.clk) in.Master_en = 0;
 repeat(13)@(posedge in.clk);
  @(negedge in.clk);
  T= Goodmodel(in.Data,3'd3,1,0,1);
endtask


task RR_GOODMODEL();

repeat(1) @(negedge in.clk); 
    in.Master_en = 1;
    in.Mem_Addr = in.Mem_Addr + 1;
    in.R_W_en = 1;
    @(posedge in.clk) in.Master_en = 0;
 repeat(13)@(posedge in.clk);
  @(negedge in.clk);
  T= Goodmodel(in.Data,3'd4,1,0,1);
endtask



task LR_GOODMODEL();

repeat(1) @(negedge in.clk); 
    in.Master_en = 1;
    in.Mem_Addr = in.Mem_Addr + 1;
    in.R_W_en = 1;
    @(posedge in.clk) in.Master_en = 0;
 repeat(13)@(posedge in.clk);
  @(negedge in.clk);
  T= Goodmodel(in.Data,3'd5,1,0,1);
endtask



task ASR_GOODMODEL();

repeat(1) @(negedge in.clk); 
    in.Master_en = 1;
    in.Mem_Addr = in.Mem_Addr + 1;
    in.R_W_en = 1;
 @(posedge in.clk) in.Master_en = 0;
 repeat(13)@(posedge in.clk);
  @(negedge in.clk);
  T= Goodmodel(in.Data,3'd6,1,0,1);
endtask




task ASL_GOODMODEL();

repeat(1) @(negedge in.clk); 
    in.Master_en = 1;
    in.Mem_Addr = in.Mem_Addr + 1;
    in.R_W_en = 1;
 @(posedge in.clk) in.Master_en = 0;
 repeat(13)@(posedge in.clk);
  T= Goodmodel(in.Data,3'd7,1,0,1);
 repeat(1) @(negedge in.clk);
endtask




function static logic [7:0] Goodmodel(input logic [7:0] D1,input logic [2:0] Select,input logic MSB,LSB,input bit Clear);
     
    parameter N=8 ;
    if(~Clear) Goodmodel = 0;
    else begin
		case (Select)
		3'b000:	Goodmodel = Goodmodel;
		3'b001: Goodmodel = D1;
		3'b010: Goodmodel = {MSB,Goodmodel[N-1:1]};       
		3'b011:	Goodmodel = {Goodmodel[N-2:0],LSB};
		3'b100:	Goodmodel = {Goodmodel[0],Goodmodel[N-1:1]};
		3'b101:	Goodmodel = {Goodmodel[N-2:0],Goodmodel[N-1]};
		3'b110:	Goodmodel = {Goodmodel[N-1],Goodmodel[N-1:1]};
		3'b111:	Goodmodel = {Goodmodel[N-2:0],1'b0};
		endcase
    end

    if(in.done==1) begin
	if (in.data_out !== Goodmodel && Select !== 1)
		begin
        fail++; 
	    	$display("failed at time: %0t, DATA = %h, MSBIn = %b, LSBIn = %b, Select = %d, ExpectedOutput = %h, DesignOutput = %h", $time,in.Data, MSB, LSB, Select, Goodmodel, in.data_out);
    end else if(Select !==1 )begin 
      pass++;
      // $display("Passed at time: %0t, DATA = %h, MSBIn = %b, LSBIn = %b, Select = %d, ExpectedOutput = %h, DesignOutput = %h", $time,in.Data, MSB, LSB, Select, Goodmodel, in.data_out);
      end
    end

endfunction



endclass 




module top;

parameter TRUE_T = 1'b1;
parameter FALSE_T = 1'b0;
parameter CLOCK_CYCLE_T = 4; 
parameter CLOCK_WIDTH_T = CLOCK_CYCLE_T/2;
parameter IDLE_CLOCKS_T = 2;


INTF in();
I2C_top MAIN(in.clk,in.reset_n,in.Master_en,in.R_W_en,in.Mem_Addr,in.Data,in.data_out,in.done,in.S,in.MSBIn,in.LSBIn);
       
Random_Data WD;
 

initial begin 
        in.clk = 0; 
    forever #CLOCK_WIDTH_T in.clk = ~in.clk;
end



 initial begin 
   WD = new(in);
   repeat($urandom_range(100,1000)) begin
   WD.write_run();
   WD.read_run();
   end

    $display("\t********* REPORT *********\nTOTAL TEST CASES %2d \nTOTAL TEST CASES PASSED %2d\nTOTAL TEST CASES FAILED%2d",WD.pass+WD.fail,WD.pass,WD.fail);
   #100 $finish;
 end

endmodule

























