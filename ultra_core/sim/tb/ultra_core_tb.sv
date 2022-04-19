`ifndef ULTRA_CORE_TB__SV
 `define ULTRA_CORE_TB__SV

 `timescale 1ns/1ps
 `include "uvm_macros.svh"

module ultra_core_tb;
   import ultra_core_test_pkg::*;
   import uvm_pkg::*;

   logic clk,rst_n,uart_tx,gpio_out;

   ultra_core DUT (
		   .clk(clk),
		   .rst_n(rst_n),
		   .UART_TX(uart_tx),
		   .GPIO_O(gpio_out)
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
      //run_test();
      #100000 $finish;              
   end
endmodule

`endif

//End of ultra_core_tb
