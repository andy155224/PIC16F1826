module Timer0(input clock,input reset,input RA4,input [7:0] OPTION_REG_in,output TMRFLAG);
//input clock means fosc in pic sheet

reg [7:0] TMR0;//which is 8-bit register
reg TMR0CS_out;
reg PSA_out;
reg overflow;
reg PS_choose;
reg [7:0] data_in;//store data to ram 
wire [7:0] ram_out;
wire T0CKI;
reg [7:0] Prescaler;
reg [7:0] OPTION_REG;
reg [7:0] ram_addr;

assign T0CKI = RA4;
//Ram U_Ram (.clk(clock),.en(1'b0),.addr(ram_addr),.data(data_in),.ram_out(ram_out));//get option_reg and never store data

assign PS = OPTION_REG[2:0];
assign PSA = OPTION_REG[3];
assign TMR0CS = OPTION_REG[5];
assign TMRFLAG = overflow;
assign Sync2 = clock && PSA_out;

always@(PSA or TMR0CS_out or PS_choose)begin
  if(PSA)PSA_out = TMR0CS_out;
  else if(!PSA)PSA_out = PS_choose;

end

always @ (*) begin
	if(reset)begin
	  
	  OPTION_REG <= 8'b00000000;
	end
    else if(OPTION_REG_in!==8'bx)OPTION_REG <= OPTION_REG_in;//to make sure option reg !=xxxxxxxx 

  end
  
always@ (PS or posedge clock) begin
  case(PS)
    3'b000 : PS_choose = Prescaler[0];
    3'b001 : PS_choose = Prescaler[1];
    3'b010 : PS_choose = Prescaler[2];
    3'b011 : PS_choose = Prescaler[3];
    3'b100 : PS_choose = Prescaler[4];
    3'b101 : PS_choose = Prescaler[5];
    3'b110 : PS_choose = Prescaler[6];
    3'b111 : PS_choose = Prescaler[7];
	default : PS_choose = Prescaler[0];
   endcase
end
always@(posedge clock)begin
  if(reset)begin
    PS_choose = 0;
    TMR0 = 8'b0;
    Prescaler = 8'b0;
	overflow = 0;
  end
  ram_addr = 7'b0001011;//request OPTION_REG in no time
end
always@(*)begin
  if(TMR0CS)TMR0CS_out = T0CKI;//??
  else if(!TMR0CS)TMR0CS_out = clock;//clock means instruction clock
end
/*always@(TMR0_int)begin
  TMR0 = TMR0_int;
  Prescaler = 8'b0;
  overflow = 0;
end*/
always@(TMR0CS_out)begin
  Prescaler = Prescaler + TMR0CS_out;
  
  
end
always@(Sync2)begin
  TMR0 =TMR0 + Sync2;
  
  if(TMR0 == 0) 
    overflow = 1;//which means overflow;
  
  
end





endmodule