import my_pkg::*;

module I2C(
    output  SDA,
    output logic SCL,
    input logic clk,
    input logic reset_n,
    input logic Master_en,
    input logic R_W_en,
    input address_t Mem_Addr,
    input byte_t Data,
    input ACKT_t ACKT
  );



logic [7:0] s_data,s_addr;
int s_count,c_count;          

//SDA and SCL CHANGE VARIABLES 
logic scl_en,scl_chan;
logic sda_en,sda_chan;



enum  {   IDLE_B        = 0, 
          START1_B      = 1, 
          START2_B      = 2,
          ADDR_WR_B     = 3, 
          ADDR_ACK_B    = 4,
          WRITE_DATA_B  = 5,
          WRITE_ACK_B   = 6,  
          STOP1_B       = 7,
          STOP2_B       = 8 } state_bit;


enum logic [8:0]  { IDLE       = 9'd1<<IDLE_B, 
                    START1     = 9'd1<<START1_B, 
                    START2     = 9'd1<<START2_B,
                    ADDR_WR    = 9'd1<<ADDR_WR_B, 
                    ADDR_ACK   = 9'd1<<ADDR_ACK_B,
                    WRITE_DATA = 9'd1<<WRITE_DATA_B,
                    WRITE_ACK  = 9'd1<<WRITE_ACK_B,  
                    STOP1      = 9'd1<<STOP1_B,
                    STOP2      = 9'd1<<STOP2_B } State, Next;






always_ff @(posedge clk)
begin
if (~reset_n)
	State <= IDLE;
else
	State <= Next;
end




always_comb begin 
Next = State;
unique case(1'b1)
    State[IDLE_B] :       begin       
                          if(Master_en & reset_n)  begin  
                            s_data = '0;c_count= '0;
                            Next = START1; 
                          end else Next = IDLE;
                           end

    State[START1_B]:     Next = START2;

    State[START2_B]:     begin 
                          Next = ADDR_WR;
                          s_addr = {Mem_Addr,R_W_en};
                          s_data = Data;
                          c_count = 8;
                        end

   State[ADDR_WR_B]:        begin
                            if(s_count == 0) begin
                                Next = ADDR_ACK;
                                c_count = 0;
                            end
                            end

    State[ADDR_ACK_B]:      begin  
                             if(ACKT && ~R_W_en)  begin     
                                                       Next = WRITE_DATA;
                                                       c_count = 8;
                                                   end
                              else if(ACKT && R_W_en)    begin 
                                                              Next = STOP1;
                                                              c_count = 0;
                                                          end 
                                else Next = ADDR_ACK;
                           end

    State[WRITE_DATA_B]:    begin
                              if(s_count == 0) begin
                                Next = WRITE_ACK;
                                c_count = 0;
                              end
                            end 

    State[WRITE_ACK_B]:       if(ACKT)              Next = STOP1;

    State[STOP1_B] :          Next = STOP2;

    State[STOP2_B]:           Next = IDLE;

   endcase
end

assign SDA      = sda_en ? sda_chan : 'x;

assign SCL        = scl_en ? clk : scl_chan;



always_comb begin 
 
unique case(1'b1)
    State[IDLE_B]:        begin 
                          sda_en = 1;
                          sda_chan = 1;
                          scl_en = 0;
                          scl_chan = 1;
                          end    

    State[START1_B]:       begin sda_chan = 0;  end

    State[START2_B]:       begin scl_chan = 0;  end

    State[ADDR_WR_B]:     begin     
                            sda_en = 1;
                            scl_en = 1;
                            sda_chan = s_addr[s_count];
                          end


    State[ADDR_ACK_B]:   begin 
                         sda_en = 0;
                         end
                     

    State[WRITE_DATA_B]: begin     
                          sda_en = 1;
                          sda_chan = s_data[s_count];
                        end

    State[WRITE_ACK_B]: begin
                            sda_en = 0;
                        end

    State[STOP1_B]:     begin 
                          {scl_en,scl_chan,sda_en,sda_chan} = 4'b0110;
                        end

    State[STOP2_B]:          {sda_en,sda_chan} = '1;
   endcase
end

always_ff @(posedge clk) begin
    if (c_count != 0)
        s_count <= (s_count == 0) ? c_count - 1 : s_count - 1;
    else
        s_count <= 0;
end

//-------------------------------------------------Assertions------------------------------------------------


property idealtostart1;
  @(posedge clk) disable iff (!reset_n)
    (State == IDLE  && reset_n && Master_en) |-> (Next == START1);
endproperty

 a1: assert property (idealtostart1);

property start1tostart2;
  @(posedge clk) disable iff (!reset_n)
    (State == START1) |-> (Next == START2);
endproperty

 a2: assert property (start1tostart2);

property S2toADDWR;
  @(posedge clk) disable iff (!reset_n)
    (State == START2) |-> (Next == ADDR_WR);
endproperty

 a3: assert property (S2toADDWR);

 property ADDRWtoACK;
  @(posedge clk) disable iff (!reset_n)
    (State == ADDR_WR && s_count == 0) |-> Next == ADDR_ACK;
endproperty

 a4: assert property (ADDRWtoACK) else $info("ADDRWtoACK Failing");

property ACKtoWR;
  @(posedge clk) disable iff (!reset_n)
    (State == ADDR_ACK && ACKT && ~R_W_en) |-> Next == WRITE_DATA;
endproperty

 a5: assert property (ACKtoWR) else $info("ACKtoWR Failing");
    
 property WRtoACK;
  @(posedge clk) disable iff (!reset_n)
    (State == WRITE_DATA && s_count == 0) |-> Next == WRITE_ACK;
endproperty

 a6: assert property (WRtoACK) else $info("WRtoACK Failing");

 property ACKtoRD;
  @(posedge clk) disable iff (!reset_n)
    (State == ADDR_ACK && ACKT && R_W_en) |-> Next == STOP1;
endproperty

 a7: assert property (ACKtoRD) else $info("ACKtoRD Failing");

 property SP1toSP2;
  @(posedge clk) disable iff (!reset_n)
    (State == STOP1) |-> Next == STOP2;
endproperty

 a8: assert property (SP1toSP2) else $info("SP1toSP2 Failing");

 property SP2toIdle;
  @(posedge clk) disable iff (!reset_n)
    (State == STOP2 ) |-> Next == IDLE;
endproperty

 a9: assert property (SP2toIdle) else $info("SP2toIdle Failing");


 property WRacktoSP1;
  @(posedge clk) disable iff (!reset_n)
    (State == WRITE_ACK && ACKT ) |-> Next == STOP1;
endproperty

 a10: assert property (ACKtoRD) else $info("WRacktoSP1 Failing");

endmodule

