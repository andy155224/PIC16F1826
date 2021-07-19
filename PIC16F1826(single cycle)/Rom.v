module Rom(Rom_addr_in,Rom_data_out);

//---------
    output [13:0] Rom_data_out;
    input [10:0] Rom_addr_in; 
//---------
    
    reg   [13:0] data;
    wire  [13:0] Rom_data_out;
    
    always @(Rom_addr_in)
        begin
            case (Rom_addr_in)
                11'h0 : data = 14'h2805;
                11'h1 : data = 14'h3400;
                11'h2 : data = 14'h3400;
                11'h4 : data = 14'h2817;
                11'h5 : data = 14'h0103;
                11'h6 : data = 14'h018B;
                11'h7 : data = 14'h0195;
                11'h8 : data = 14'h01A5;
                11'h9 : data = 14'h3003;
                11'ha : data = 14'h3008;
                11'hb : data = 14'h0095;
                11'hc : data = 14'h3014;
                11'hd : data = 14'h0815;
                11'he : data = 14'h07A5;
                11'hf : data = 14'h00A5;
                11'h10 : data = 14'h178B;
                11'h11 : data = 14'h168B;
                11'h12 : data = 14'h3003;
                11'h13 : data = 14'h3004;
                11'h14 : data = 14'h3005;
                11'h15 : data = 14'h3006;
                11'h16 : data = 14'h2816;
                11'h17 : data = 14'h3001;
                11'h18 : data = 14'h00A4;
                11'h19 : data = 14'h3002;
                11'h1a : data = 14'h00A3;
                11'h1b : data = 14'h3003;
                11'h1c : data = 14'h00A2;
                11'h1d : data = 14'h3004;
                11'h1e : data = 14'h00A1;
                11'h1f : data = 14'h3005;
                11'h20 : data = 14'h00A0;
                11'h21 : data = 14'h110B;
                11'h22 : data = 14'h0009;
                default: data = 14'h0;  
            endcase
        end

     assign Rom_data_out = data;

endmodule


