module ram
  /* verilator lint_off VARHIDDEN */
  #(parameter depth=256,
    parameter memfile = "")
   /* verilator lint_on VARHIDDEN */   
   (
    // i_port
   input wire 			  clka,
   input wire [$clog2(depth)-1:0] addra,
    
   output reg [31:0] 		  douta,
    // d_port
   input wire 			  clkb,
   input wire [$clog2(depth)-1:0] addrb,
   input wire [3:0] 		  wenb,
   input wire 			  renb,
   input wire [31:0] 		  dinb,    
    
   output reg [31:0] 		  doutb    
   );

   reg [31:0] 			  mem [depth-1:0] /* verilator public */; 

   always @(posedge clka)
     douta <= mem[addra];
      
   always @(posedge clkb) begin
      if (wenb[0]) mem[addrb][7:0]   <= dinb[7:0];
      if (wenb[1]) mem[addrb][15:8]  <= dinb[15:8];
      if (wenb[2]) mem[addrb][23:16] <= dinb[23:16];
      if (wenb[3]) mem[addrb][31:24] <= dinb[31:24];
      
      if (renb)
	doutb <= mem[addrb];      
   end

   initial
     if(|memfile) begin
	$display("Preloading %m from %s", memfile);
	$readmemh(memfile, mem);
     end
   
endmodule
