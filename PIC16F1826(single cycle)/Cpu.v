///////////////////////////////////////Version_1.1.1///////////////////////////////////////
//modify day 2021/06/01 
//aim:
//last time modifier : Dino
//About modified content : In Version.txt
//
//
//Achieved:Instruction Set,Interrupt;
//
//created by Tsai
//			 Lee
///////////////////////////////////////////////////////////////////////////////////////////

module Cpu (
  input  clk,rst,
  input  INT_in,IOC_in,//interrupt_get from testbench
  input  RA4,
  output reg [7:0] w_out
); 
  
//////DataLine//////
  reg  [10:0] pc_in;
  reg  [10:0] pc_out;
  wire [10:0] stack_out;
  wire [13:0] rom_out;
  reg  [13:0] ir_out;
  wire [7:0]  ram_out;
  reg  [7:0]  muxAlu_out;
  reg  [7:0]  alu_out;
  reg  [7:0]  dataBus_out;
  reg  [7:0]  portB_out;
  wire [2:0]  selBsfBcfBit;
  wire [10:0] wChange;
  wire [10:0] kChange;
  reg  [7:0]  intCon;
  reg  [6:0]  addrToRam;
  reg  [7:0]  OPTION_REG;
  
////////////////////
  
////ControlLine////
  reg [2:0] ns;
  reg [2:0] ps;
  reg loadPc;
  reg [2:0] determinInterrupt;
  reg [2:0] selPc;
  reg push;
  reg pop;
  reg loadIr;
  reg rstIr;
  reg ramEn;
  reg selAlu;
  reg [4:0] op;
  reg loadW;
  reg selBus;
  reg loadPortB;
  reg interrupt_in; //decide whether change intcon
  wire TMR_in;
  wire interrupt2Cpu;
  wire haveInterrupt;
///////////////////
 reg [2:0]dd;
////////Op////////
  assign MOVLW  = (ir_out[13:8]==6'b11_0000);
  assign ADDLW  = (ir_out[13:8]==6'b11_1110);
  assign SUBLW  = (ir_out[13:8]==6'b11_1100);
  assign ANDLW  = (ir_out[13:8]==6'b11_1001);
  assign IORLW  = (ir_out[13:8]==6'b11_1000);
  assign XORLW  = (ir_out[13:8]==6'b11_1010);
  assign ADDWF  = (ir_out[13:8]==6'b00_0111);
  assign ANDWF  = (ir_out[13:8]==6'b00_0101);
  assign CLRF   = (ir_out[13:7]==7'b00_0001_1);
  assign CLRW   = (ir_out[13:2]==12'b00_0001_0000_00);
  assign COMF   = (ir_out[13:8]==6'b00_1001);
  assign DECF   = (ir_out[13:8]==6'b00_0011);
  assign GOTO   = (ir_out[13:11]==3'b10_1);
  assign INCF   = (ir_out[13:8]==6'b00_1010);
  assign IORWF  = (ir_out[13:8]=='b00_0100);
  assign MOVF   = (ir_out[13:8]==6'b00_1000);
  assign MOVWF  = (ir_out[13:7]==7'b00_0000_1);
  assign SUBWF  = (ir_out[13:8]==6'b00_0010);
  assign XORWF  = (ir_out[13:8]==6'b00_0110);
  assign DECFSZ = (ir_out[13:8]==6'b00_1011);
  assign INCFSZ = (ir_out[13:8]==6'b00_1111);
  assign BCF    = (ir_out[13:10]==4'b01_00);
  assign BSF    = (ir_out[13:10]==4'b01_01);
  assign BTFSC  = (ir_out[13:10]==4'b01_10);
  assign BTFSS  = (ir_out[13:10]==4'b01_11);
  assign ASRF   = (ir_out[13:8]==6'b11_0111);
  assign LSLF   = (ir_out[13:8]==6'b11_0101);
  assign LSRF   = (ir_out[13:8]==6'b11_0110);
  assign RLF    = (ir_out[13:8]==6'b00_1101);
  assign RRF    = (ir_out[13:8]==6'b00_1100);
  assign SWAPF  = (ir_out[13:8]==6'b00_1110);
  assign CALL   = (ir_out[13:11]==3'b10_0);
  assign RETURN = (ir_out==14'b00_0000_0000_1000);
  assign BRA    = (ir_out[13:9]==5'b11_001);
  assign BRW    = (ir_out==14'b00_0000_0000_1011);
  assign NOP    = (ir_out==14'b00_0000_0000_0000);
  assign RETFIE = (ir_out==14'b00_0000_0000_1001);
//////////////////

  assign selBsfBcfBit      = ir_out[9:7];
  assign wChange           = {3'b0,w_out} - 1;
  assign kChange           = {ir_out[8],ir_out[8],ir_out[8:0]} - 1;
  assign btfscSkipBit      = ram_out[ir_out[9:7]] == 0;
  assign btfssSkipBit      = ram_out[ir_out[9:7]] == 1;
  assign btfscBtfssSkipBit = (BTFSC & btfscSkipBit) | (BTFSS & btfssSkipBit);
  
  
  assign GIE    =   intCon[7];
  assign PEIE   =   intCon[6];
  assign TMR0IE =   intCon[5];
  assign INTE   =   intCon[4];
  assign IOCIE  =   intCon[3];
  
  always@(INT_in or IOC_in or TMR_in)begin
	if(INT_in)intCon[1] = 1;
	if(IOC_in)intCon[0] = 1;
	if(TMR_in)intCon[2] = 1;
	interrupt_in = 1;
  end
  assign TMR0IF =   intCon[2];
  assign INTF   =   intCon[1];
  assign IOCIF  =   intCon[0];
  
//////MuxPc//////
  always @ (*) begin
    case (selPc)
      0 : pc_in = pc_out + 1;
      1 : pc_in = ir_out[10:0];
      2 : pc_in = stack_out;
      3 : pc_in = pc_out + kChange;
      4 : pc_in = pc_out + wChange;
      5 : pc_in = 11'b000_0000_0100;
      default : pc_in = pc_out + 1;
    endcase
  end
/////////////////
  
///////Pc///////
  always @ (posedge clk) begin
    if (rst)
      pc_out <=0;
    else if (loadPc)
      pc_out <= pc_in;
  end
////////////////

///////Stack///////
  Stack U_Stack (.clk(clk),.rst(rst),.push(push),.pop(pop),.stack_in(pc_out),.stack_out(stack_out));
///////////////////



////////Rom////////
  Rom U_Rom (pc_out,rom_out);
///////////////////

//////Ir//////
  always @ (posedge clk) begin
    if (rstIr)
      ir_out <= 0;
    else if (loadIr)
      ir_out <= rom_out;
  end
//////////////

//////Ram//////
  Ram U_Ram (.clk(clk),.en(ramEn),.addr(addrToRam),.data(dataBus_out),.ram_out(ram_out));
///////////////

///////////////
Timer0 T1(.clock(clk),.reset(rst),.RA4(RA4),.OPTION_REG_in(OPTION_REG),.TMRFLAG(TMR_in));
///////////////
always @ (*) begin
case(determinInterrupt)
	0: addrToRam = ir_out[6:0];
	1: addrToRam = 7'b0001011;//??????INTCON ??????
	2: addrToRam = 7'b0001001;//????????????w_reg ??????
	3: addrToRam = 7'b0001010;//????????????pc??????
	4: addrToRam = 7'b0010101;//????????????pc??????
endcase
end


//////MuxAlu//////
  always @ (*) begin
    if (selAlu)
      muxAlu_out = ram_out;
    else
      muxAlu_out = ir_out[7:0];
  end
//////////////////

//////Alu//////
  always @ (*) begin
    case (op)
      0  : alu_out = muxAlu_out + w_out;
      1  : alu_out = muxAlu_out - w_out;
      2  : alu_out = muxAlu_out & w_out;
      3  : alu_out = muxAlu_out | w_out;
      4  : alu_out = muxAlu_out ^ w_out;
      5  : alu_out = muxAlu_out;
      6  : alu_out = muxAlu_out + 1;
      7  : alu_out = muxAlu_out - 1;
      8  : alu_out = 0;
      9  : alu_out = ~muxAlu_out;
      10 : alu_out = {muxAlu_out[7],muxAlu_out[7:1]};
      11 : alu_out = {muxAlu_out[6:0],1'b0};
      12 : alu_out = {1'b0,muxAlu_out[7:1]};
      13 : alu_out = {muxAlu_out[6:0],muxAlu_out[7]};
      14 : alu_out = {muxAlu_out[0],muxAlu_out[7:1]};
      15 : alu_out = {muxAlu_out[3:0],muxAlu_out[7:4]};
      16 : alu_out = BCF ? muxAlu_out & 8'hFE : muxAlu_out | 8'h01;
      17 : alu_out = BCF ? muxAlu_out & 8'hFD : muxAlu_out | 8'h02;
      18 : alu_out = BCF ? muxAlu_out & 8'hFB : muxAlu_out | 8'h04;
      19 : alu_out = BCF ? muxAlu_out & 8'hF7 : muxAlu_out | 8'h08;
      20 : alu_out = BCF ? muxAlu_out & 8'hEF : muxAlu_out | 8'h10;
      21 : alu_out = BCF ? muxAlu_out & 8'hDF : muxAlu_out | 8'h20;
      22 : alu_out = BCF ? muxAlu_out & 8'hBF : muxAlu_out | 8'h40;
      23 : alu_out = BCF ? muxAlu_out & 8'h7F : muxAlu_out | 8'h80;
	  24 : alu_out = muxAlu_out & 8'b01111111 | 8'b00000010; // for set GIE = 0 & set INTF = 1
	  25 : alu_out = muxAlu_out & 8'b01111111 | 8'b00000100; // for set GIE = 0 & set TMR0IF = 1
	  26 : alu_out = muxAlu_out & 8'b01111111 | 8'b00000001; // for set GIE = 0 & set IOCIF = 1
	  27 : alu_out = muxAlu_out | 8'b10000000; // for set GIE = 1
      default : alu_out = muxAlu_out + w_out;
    endcase
  end
  
  assign aluIsZero = (alu_out == 0);
  
///////////////

//////W//////
  always @ (posedge clk) begin
    if (loadW)
      w_out <= alu_out;
  end
/////////////

//////MuxBus//////
  always @ (*) begin
    if (selBus)
      dataBus_out = w_out;
    else
      dataBus_out = alu_out;
  end
//////////////////

//////PortB//////
  always @ (*) begin
    if (rst)
      portB_out = 0;
    else if (loadPortB)
      portB_out = dataBus_out;
  end
  
  assign addrPortB = (ir_out[6:0] == 7'h0d);
/////////////////

//////InterruptDetect//////
  assign INTOn   = INTE   & INTF; //???INTE INTF
  assign INCIOn  = IOCIE  & IOCIF; //???IOCIE IOCIF
  assign TMR0IOn = TMR0IE & TMR0IF; //???TMRIE TMR0IF
  assign PEIOn   = PEIE; //???&lowpriority device flag
  assign haveInterrupt =  (INTOn | INCIOn | TMR0IOn | PEIOn);
  assign interrupt2Cpu = (haveInterrupt& GIE);
  
  //always@(haveInterrupt,GIE) begin //remember to reset interrupt2Cpu when you ready to handle interrupt
    //if(!interrupt2Cpu)
      //interrupt2Cpu = (haveInterrupt & GIE);
 // end 
///////////////////////////

//////State//////
  always @ (posedge clk) begin
    if (rst)
      ps <= 0;
    else
      ps <= ns;
  end
/////////////////


////////IntCon/////////
  always @ (rst or determinInterrupt or ram_out) begin
	if(rst)begin
	  interrupt_in = 0;
	  intCon <= 8'b00000000;
	end
  
    else if(determinInterrupt == 1) begin//change when justice interrupt 
		/*intCon[3] = ram_out[3];
		intCon[4] = ram_out[4];
		intCon[5] = ram_out[5];
		intCon[6] = ram_out[6];
		intCon[7] = ram_out[7];*/
		if(ram_out!==8'bx && interrupt_in == 0)begin
		  intCon <= ram_out;
		  dd = 1;
		end
		else if(ram_out!==8'bx && interrupt_in == 1) begin
			intCon <= {ram_out[7] | intCon[7],ram_out[6:3],ram_out[2:0] | intCon[2:0]};//with "or" means programable
			
			dd=2;
		end
		interrupt_in <= 0;
	    //intCon <= ram_out;//intcon may change in other stage
	end

  
  end

///////////////////////
//////Controller//////
  always @ (*) begin
    loadPc    = 0;
    loadIr    = 0;
    loadW     = 0;
    selPc     = 0;
    selAlu    = 0;
    ramEn     = 0;
    selBus    = 0;
    loadPortB = 0;
    pop       = 0;
    push      = 0;
    rstIr     = 0;
    //interrupt2Cpu = 0;
	determinInterrupt = 0;
    case (ps)
      0 : begin 
        loadIr = 1;
        ns = 1;
		determinInterrupt = 1;
		    
		if (interrupt2Cpu) begin
		  push = 1;//put pc into stack 
		  ramEn = 1;
		  selBus = 0;
		  selAlu = 1;//for choose ram_out
		  if(INT_in)op = 24;//set GiE bit to be 0 and store into ram
		  if(IOC_in)op = 26;
		  if(TMR_in)op = 25;
		  ns = 6;
		end
      end
      1 : begin
        ns = 2;
		
		
      end
      2 : begin
        loadPc = 1;
        ns = 3;
      end
      3 : begin
        if (MOVLW | ADDLW | SUBLW | ANDLW | IORLW | XORLW) begin
          loadW  = 1;
          if (ADDLW)
            op = 0;
          else if (SUBLW)
            op = 1;
          else if (ANDLW)
            op = 2;
          else if (IORLW)
            op = 3;
          else if (XORLW)
            op = 4;
          else if (MOVLW)
            op = 5;
        end
        else if (ADDWF | SUBWF | ANDWF | IORWF | XORWF | MOVF | INCF | DECF | COMF | ASRF | LSLF | LSRF | RLF | RRF | SWAPF) begin
          selAlu = 1;
          if (ir_out[7])
            ramEn = 1;
          else
            loadW = 1;
          if (ADDWF)
            op = 0;
          else if (SUBWF)
            op = 1;
          else if (ANDWF)
            op = 2;
          else if (IORWF)
            op = 3;
          else if (XORWF)
            op = 4;
          else if (MOVF)
            op = 5;
          else if (INCF)
            op = 6;
          else if (DECF)
            op = 7;
          else if (COMF)
            op = 9;
          else if (ASRF)
            op = 10;
          else if (LSLF)
            op = 11;
          else if (LSRF)
            op = 12;
          else if (RLF)
            op = 13;
          else if (RRF)
            op = 14;
          else if (SWAPF)
            op = 15;
        end
        else if (CLRF | CLRW) begin
          op = 8;
          if (CLRF)
            ramEn = 1;
          else if (CLRW)
            loadW = 1;
        end
        else if (MOVWF) begin
          selBus = 1;
          if (addrPortB)
            loadPortB = 1;
          else
            ramEn = 1;
        end
        else if (BCF | BSF) begin
          ramEn  = 1;
          selAlu = 1;
          op = selBsfBcfBit + 16;
        end
        else if (GOTO | CALL | RETURN | BRA | BRW) begin
          loadPc = 1;
          if (GOTO)
            selPc = 1;
          else if (CALL) begin
            selPc = 1;
            push = 1;
          end
          else if (RETURN) begin
            selPc = 2;
            pop   = 1;
          end
          else if (BRA)
            selPc = 3;
          else if (BRW)
            selPc = 4;
        end
        else if (INCFSZ | DECFSZ) begin
          selAlu = 1;
          if (ir_out[7])
            ramEn = 1;
          else
            loadW = 1;
          if (aluIsZero)
            loadPc = 1;
          op = INCFSZ ? 6 : 7;
        end
        
        else if (NOP) begin
          //DoNothing//
        end
        ns = 4;
		if (RETFIE) begin
		  op = 5;										  //?????????w_q ?????????
		  loadW = 1;									  //?????????w_q ?????????
	      selAlu = 1;                                     //?????????w_q ?????????
	      determinInterrupt = 2;						  //???????????????ram???w_q?????????
	      ns = 7;//for set gie bit
		  pop = 1;
		  selPc = 2;
		  loadPc = 1;
		  intCon[7] = 1;
		  
        end
      end
      4 : begin
        ns = 5;
      end
      5 : begin
		//???????????????timer reg
		determinInterrupt = 4;
		OPTION_REG = ram_out;
		//
        ns = 0;
      end
	  6 : begin // for deal with interrupt
		ramEn = 1;                                    //?????????w_q ????????????
		selBus = 1;                                   //?????????w_q ????????????
		determinInterrupt = 2 ;//???w_q ????????????		  //?????????w_q ????????????
		ns = 0;
		selPc = 5;//pc is load with 0004H
		loadPc = 1;
		
	  end
	  7: begin  //?????????interrupt ??? ???GIEbit
	    ramEn = 1;                                    
		selBus = 0; 
		selAlu = 1;
		determinInterrupt = 1 ;
		op = 27;
		
		
		ns = 0;
	  end
	  
	  
	  
    endcase
  end
//////////////////////
endmodule