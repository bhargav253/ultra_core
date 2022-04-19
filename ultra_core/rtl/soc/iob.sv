module iob
  /* verilator lint_off VARHIDDEN */
  #(parameter depth       = 4096,
    parameter UART_START  = 32'h10000000,
    parameter UART_STOP   = 32'h10000004,
    parameter GPIO_START  = 32'h10000004,
    parameter GPIO_STOP   = 32'h10000008,
    parameter MEM_START   = 32'h00000000,
    parameter MEM_STOP    = 32'h00001000,
    parameter memfile = "")
   /* verilator lint_on VARHIDDEN */   
   (
    input 		 clk, 
    input 		 rst_n,
   
    //core d interface
    input [ 31:0] 	 core__d_addr,
    input [ 31:0] 	 core__d_wdata,
    input 		 core__d_ren,
    input [ 3:0] 	 core__d_wen,
    input [ 10:0] 	 core__d_req_tag, 
   
    output logic 	 d__core_accept,
    output logic 	 d__core_val,
    output logic 	 d__core_error,
    output logic [ 31:0] d__core_rdata,
    output logic [ 10:0] d__core_resp_tag,

    //core i interface   
    input [ 31:0] 	 core__i_addr,
    input 		 core__i_ren,
   
    output logic 	 i__core_accept,
    output logic 	 i__core_val,
    output logic 	 i__core_error,
    output logic [ 31:0] i__core_rdata,
    output logic [ 31:0] i__core_pc,

   //uart interface
    output logic 	 iob__mio_val,
    output logic 	 iob__mio_port, 
    output logic [31:0]  iob__mio_wdata,
    input 		 mio__iob_done
    
   );

   localparam PORT_GPIO = 0;
   localparam PORT_UART = 1;      
   
   typedef enum   logic [2:0] {
			       DEC_IDLE  = 3'd0,
			       DEC_MEMW  = 3'd1,
			       DEC_MEMR  = 3'd2,			       
			       DEC_UART  = 3'd3,
			       DEC_GPIO  = 3'd4,
			       DEC_ERRW  = 3'd5,
			       DEC_ERRR  = 3'd6
			       } decode_t;

   decode_t       d_mem_decode,d_mem_rsp_st_q,d_mem_rsp_st;   
   logic 	  d_mio_wait,d_mem_no_wait;   
   logic 	  d_mem_wen,d_mem_ren,d_mio_psh,d_mio_port;
   logic [31:0]   d_mem_wdata,i_mem_rdata,d_mem_rdata;   
   logic [31:0]   i_pc_q;
   logic 	  i_ack_q;   
   logic [10:0]   d_tag_q;
   
//-------------------------------------------------------------
// Instruction interface
//-------------------------------------------------------------         
   
   always @ (posedge clk)
     if (!rst_n) begin
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
   assign i__core_rdata  = i_mem_rdata;   
   
//-------------------------------------------------------------
// Data interface
//-------------------------------------------------------------

   always_comb begin
      if((core__d_addr >= UART_START) && (core__d_addr < UART_STOP) && (|core__d_wen))
	d_mem_decode = DEC_UART;
      else if((core__d_addr >= GPIO_START) && (core__d_addr < GPIO_STOP) && (|core__d_wen))
	d_mem_decode = DEC_GPIO;
      else if((core__d_addr >= MEM_START) && (core__d_addr  < MEM_STOP) && core__d_ren)
	d_mem_decode = DEC_MEMR;
      else if((core__d_addr >= MEM_START) && (core__d_addr  < MEM_STOP) && (|core__d_wen))
	d_mem_decode = DEC_MEMW;      
      else if(core__d_ren)
	d_mem_decode = DEC_ERRR;
      else if(core__d_wen)
	d_mem_decode = DEC_ERRW;
      else
	d_mem_decode = DEC_IDLE;	
   end   

   always_comb begin
      d_mem_wen   = '0;
      d_mem_ren   = '0;
      d_mio_psh   = '0;
      d_mio_port  = PORT_GPIO;      
      d_mem_wdata = core__d_wdata;
      
      case(d_mem_decode)
	DEC_MEMW,DEC_MEMR : begin
	   d_mem_wen = core__d_wen;
	   d_mem_ren = core__d_ren;	 
	end
	DEC_UART : begin
	   d_mio_psh  = core__d_wen & (d_mem_rsp_st_q == DEC_IDLE);
	   d_mio_port = PORT_UART;	   
	end
	DEC_GPIO : begin
	   d_mio_psh = core__d_wen & (d_mem_rsp_st_q == DEC_IDLE);
	   d_mio_port = PORT_GPIO;
	end
      endcase      
   end
   
   always @ (posedge clk)
     if (!rst_n) 
       d_tag_q    <= '0;
     else if (core__d_ren | (|core__d_wen))
       d_tag_q <= core__d_req_tag;

   
   always @ (posedge clk)
     if (!rst_n) 
       d_mem_rsp_st_q <= DEC_IDLE;	
     else begin
	if(d_mem_decode == DEC_UART)
          d_mem_rsp_st_q <= (core__d_ren | (|core__d_wen)) & !d_mem_no_wait & !d__core_accept ? d_mem_decode : d_mem_rsp_st;
	else
          d_mem_rsp_st_q <= (core__d_ren | (|core__d_wen)) & !d_mem_no_wait ? d_mem_decode : d_mem_rsp_st;	  
     end

   always_comb begin
      d_mem_rsp_st = d_mem_rsp_st_q;      
      case(d_mem_rsp_st)
	DEC_MEMR  : d_mem_rsp_st = (core__d_ren | (|core__d_wen)) & !d_mem_no_wait & !d__core_accept  ? d_mem_decode :  DEC_IDLE;	
	DEC_UART  : d_mem_rsp_st = mio__iob_done ? DEC_IDLE : DEC_UART;
	default   : d_mem_rsp_st = DEC_IDLE;	
      endcase // case (d_mem_decode)
   end

   assign d_mem_no_wait = (d_mem_rsp_st_q == DEC_IDLE) & !((d_mem_decode == DEC_UART | (d_mem_decode == DEC_MEMR)));   
   
   always_comb begin
      d__core_rdata    = '0;
      d__core_resp_tag = core__d_req_tag;
      d__core_accept   = '0;
      d__core_val      = '0;
      d__core_error    = '0;	   	         

      if(d_mem_no_wait) begin
	 case(d_mem_decode)
	   DEC_MEMW,DEC_GPIO : begin
	      d__core_resp_tag = core__d_req_tag;	      
	      d__core_accept   = '1;
	      d__core_error    = '0;	   
	   end
	   DEC_MEMR : begin
	      d__core_accept   = '1;	      
	   end
	   DEC_ERRR : begin
	      d__core_rdata    = '0;
	      d__core_resp_tag = core__d_req_tag;	      
	      d__core_accept   = '1;
	      d__core_val      = '1;
	      d__core_error    = '1;	   	   
	   end	   
	   DEC_IDLE : begin
	      d__core_accept   = '0;
	      d__core_val      = '0;
	      d__core_error    = '0;
	   end
	   default : begin
	      d__core_rdata    = '0;
	      d__core_resp_tag = core__d_req_tag;	      
	      d__core_accept   = '1;
	      d__core_error    = '1;	   	   
	   end
	 endcase
      end // if (d_mem_no_wait)
      else begin
	 case(d_mem_rsp_st_q)
	   DEC_MEMR : begin
	      d__core_rdata    = d_mem_rdata;
	      d__core_resp_tag = d_tag_q;	      	      
	      d__core_val      = '1;
	      d__core_error    = '0;
	   end
	   DEC_UART : begin
	      d__core_resp_tag = d_tag_q;
	      d__core_accept   = mio__iob_done;
	      d__core_error    = '0;
	   end
	   DEC_IDLE : begin
	      d__core_accept   = (d_mem_decode == DEC_MEMR);
	      d__core_val      = '0;
	      d__core_error    = '0;
	   end	   
	   // ERR
	   default : begin
	      d__core_rdata  = '0;
	      d__core_accept = '1;
	      d__core_val    = '0;
	      d__core_error  = '1;	   	   
	   end
	 endcase	 
      end      
   end // always_comb   
      
   assign iob__mio_val   = d_mio_psh;
   assign iob__mio_port  = d_mio_port;   
   assign iob__mio_wdata = d_mem_wdata;   

   
   /*
    rom AUTO_TEMPLATE (
    .dout (mem_rdata),
    .addr (mem_raddr),
    );
    */
   
   rom
     u_rom (/*AUTOINST*/);
   
   
   /*
    ram AUTO_TEMPLATE (
    .din      (mem_wdata),
    .waddr    (mem_waddr),
    .wen      (mem_wen),
    .dout     (mem_rdata),
    .raddr    (mem_raddr),
    .ren      (mem_ren),
    );
    */
   
   
   ram
     u_ram (/*AUTOINST*/);
   
   
   
endmodule

// Local variables:
// verilog-library-directories:(". ../lib/.")
// verilog-auto-sense-defines-constant:t
// verilog-auto-inst-vector:t
// verilog-auto-inst-dot-name:t
// End:
