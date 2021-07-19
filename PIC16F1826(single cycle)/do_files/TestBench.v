
module TestBench ();
  reg clk;
  reg rst;
  wire [7:0] w_out;
  reg INTF,IOCIF,RA4;
  Cpu U_Cpu(
  .clk(clk),
  .rst(rst),
  .INT_in(INTF),
  .IOC_in(IOCIF),
  .RA4(RA4),
  .w_out(w_out)
  
  );
  
  always #1 clk=~clk;
  
  initial begin
	INTF=0;IOCIF=0;RA4=0;//RA4 pin = T0CKI 
    clk=0;
    rst=1;
    #10
    rst=0;
	
	
    #10000
    $stop;
  end 
endmodule