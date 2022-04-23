`ifndef ULTRA_CORE_TB__SV
 `define ULTRA_CORE_TB__SV

 `timescale 1ns/1ps
 `include "uvm_macros.svh"

module ultra_core_tb;
   import ultra_core_test_pkg::*;
   import uvm_pkg::*;

   logic clk,rst_n;   
   logic [3:0] GPIO_O;
   logic       UART_TX;   

   //ultra_core_intf intf(.clk(clk));

   ultra_core DUT (
		   .clk(clk),
		   .rst_n(rst_n),
		   .GPIO_O(GPIO_O),
		   .UART_TX(UART_TX)
		   );

   initial begin
      clk = 0;
      forever begin
         #10 clk = ~clk;
      end
   end

   initial begin
      rst_n = '0;
      #100 rst_n = '1;
   end
   
   initial begin
      //uvm_config_db #(virtual ultra_core_intf)::set(null, "*", "vintf", intf);
      //run_test();
      #100000 $finish;              
   end
endmodule

`endif

//End of ultra_core_tb
