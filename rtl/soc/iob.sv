module iob
  /* verilator lint_off VARHIDDEN */
  #(parameter depth=256,
    parameter memfile = "")
   /* verilator lint_on VARHIDDEN */   
  (
   input 	  clk, 
   input 	  rst,
   
   //core d interface
   input [ 31:0]  core__d_addr,
   input [ 31:0]  core__d_wdata,
   input 	  core__d_ren,
   input [ 3:0]   core__d_wen,
   input [ 10:0]  core__d_req_tag, 
   
   output 	  d__core_accept,
   output 	  d__core_val,
   output 	  d__core_error,
   output [ 31:0] d__core_rdata,
   output [ 10:0] d__core_resp_tag,

   //core i interface   
   input [ 31:0]  core__i_addr,
   input 	  core__i_ren,
   
   output 	  i__core_accept,
   output 	  i__core_val,
   output 	  i__core_error,
   output [ 31:0] i__core_rdata,
   output [ 31:0] i__core_pc
   );
   
   // external interface FIXME
   /*
    input axi__iob_rdata
    input axi__iob_rval,
    input axi__iob_wack,
    output iob__axi_ren,
    output iob__axi_wen,
    output iob__axi_addr,
    output iob__axi_wdata,    
    */

//-------------------------------------------------------------
// Instruction interface
//-------------------------------------------------------------
   reg [31:0] 	  i_pc_q;
   reg 		  i_ack_q;   

   always @ (posedge clk or posedge rst)
     if (rst) begin
	i_pc_q  <= 32'b0;
	i_ack_q <= 1'b0;	
     end
     else begin
	i_pc_q  <= core__i_addr;
	i_ack_q <= core__i_ren;	
     end

   assign i__core_accept = 1'b1;
   assign i__core_val    = i_ack_q;
   assign i__core_error  = 1'b0;
   assign i__core_pc     = i_pc_q;
   
   
//-------------------------------------------------------------
// Data interface
//-------------------------------------------------------------
   reg [10:0] d_tag_q;
   reg 	      d_ack_q;   
   
   always @ (posedge clk or posedge rst)
     if (rst) begin
	d_tag_q    <= 11'b0;
	d_ack_q    <= 1'b0;	
     end
     else if (core__d_ren | (|core__d_wen)) begin
	d_tag_q    <= core__d_req_tag;
	d_ack_q    <= 1'b1;	
     end
     else
       d_ack_q    <= 1'b0;


   assign d__core_accept   = d_ack_q;
   assign d__core_val      = d_ack_q;
   assign d__core_error    = 1'b0;
   assign d__core_resp_tag = d_tag_q;
   
   
   

ram
     #(.depth   (depth),
       .memfile (memfile))
ram (

     // Inputs
     .clka   (clk),
     .addra  (core__i_addr[$clog2(depth)+1:2]),
     .clkb   (clk),
     .addrb  (core__d_addr[$clog2(depth)+1:2]),
     .wenb   (core__d_wen),
     .renb   (core__d_ren),
     .dinb   (core__d_wdata),
     // Outputs
     .douta  (i__core_rdata), 
     .doutb  (d__core_rdata)
     );
   
   
   
endmodule
