module Stack (
  input clk,rst,
  input push,
  input pop,
  input  reg  [10:0] stack_in,
  output wire [10:0] stack_out
);

  reg  [3:0]  ptr;
  reg  [10:0] stack[15:0];
  wire [3:0]  index;
  
  assign index     = ptr + 1;
  assign stack_out = stack[ptr[3:0]];  

  always @ (posedge clk) begin
    if(rst)
      ptr <= 4'b1111;
    else if (push) begin
      stack[index[3:0]] <= stack_in;
      ptr <= ptr + 1;
    end
    else if (pop)
      ptr <= ptr - 1;
  end
  
endmodule