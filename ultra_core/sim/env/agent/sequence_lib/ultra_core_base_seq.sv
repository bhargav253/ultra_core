`ifndef ULTRA_CORE_BASE_SEQ__SV
`define ULTRA_CORE_BASE_SEQ__SV

  class ultra_core_base_seq extends uvm_sequence#(ultra_core_seq_item);

    // Factory Registration
    `uvm_object_utils(ultra_core_base_seq)

    // Variables

    // Tasks and Functions
    extern function new(string name = "ultra_core_base_seq");
    extern virtual task body();

  endclass

  function ultra_core_base_seq::new(string name = "ultra_core_base_seq");
    super.new(name);
  endfunction

  task ultra_core_base_seq::body();
    
  endtask

`endif

//End of ultra_core_base_seq
