module ram
  /* verilator lint_off VARHIDDEN */
  #(parameter DEPTH=4096)
   /* verilator lint_on VARHIDDEN */   
   (
    input wire 			   clk,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [3:0] 		   wen,
    input wire [31:0] 		   wdata, 

    input wire 			   ren,
    input wire [$clog2(DEPTH)-1:0] raddr, 
    output reg [31:0] 		   rdata
   );

   reg [31:0] 			   mem [DEPTH-1:0];   

   always @(posedge clk) begin
      if (wen[0]) mem[waddr][7:0]   <= wdata[7:0];
      if (wen[1]) mem[waddr][15:8]  <= wdata[15:8];
      if (wen[2]) mem[waddr][23:16] <= wdata[23:16];
      if (wen[3]) mem[waddr][31:24] <= wdata[31:24];
      
      if (ren)
	rdata <= mem[raddr];      
   end
   
endmodule
