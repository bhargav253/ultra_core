module ram
  /* verilator lint_off VARHIDDEN */
  #(parameter DEPTH=256)
   /* verilator lint_on VARHIDDEN */   
   (
    input wire 			   clk,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [3:0] 		   wen,
    input wire [31:0] 		   din, 

    input wire 			   ren,
    input wire [$clog2(DEPTH)-1:0] raddr, 
    output reg [31:0] 		   dout,    
   );

   reg [31:0] 			   mem [depth-1:0];   

   always @(posedge clk) begin
      if (wen[0]) mem[waddr][7:0]   <= din[7:0];
      if (wen[1]) mem[waddr][15:8]  <= din[15:8];
      if (wen[2]) mem[waddr][23:16] <= din[23:16];
      if (wen[3]) mem[waddr][31:24] <= din[31:24];
      
      if (ren)
	dout <= mem[raddr];      
   end
   
endmodule
