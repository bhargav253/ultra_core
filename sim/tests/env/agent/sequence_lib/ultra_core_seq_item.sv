`ifndef ULTRA_CORE_SEQ_ITEM__SV
`define ULTRA_CORE_SEQ_ITEM__SV

  class ultra_core_seq_item extends uvm_sequence_item;

    // Factory Registration
    `uvm_object_utils(ultra_core_seq_item)

    // Randomization Variables
    rand logic we;
    randc logic [3:0] addr;
    rand logic [7:0] wdata;
    logic [7:0] rdata;

    constraint dataRange {wdata inside{[0:15]};}

    extern function new(string name = "ultra_core_seq_item");
    
  endclass

  function ultra_core_seq_item::new(string name = "ultra_core_seq_item");
    super.new(name);
  endfunction

`endif

//End of ultra_core_seq_item
