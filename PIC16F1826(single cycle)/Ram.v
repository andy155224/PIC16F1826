module Ram(
	input clk,
	input en,
	input reg [6:0] addr,
	input reg [7:0] data,
  output wire [7:0] ram_out
);

	reg [7:0] ram[127:0];
	
	always @ (posedge clk) begin
		if (en)
			ram[addr] <= data;
	end
	
	assign ram_out = ram[addr];
	//assign ram_out = 8'b00001000;
endmodule
