`ifndef ULTRA_CORE_SANITY_SEQ__SV
`define ULTRA_CORE_SANITY_SEQ__SV

  class ultra_core_sanity_seq extends ultra_core_base_seq;

    // Factory Registration
    `uvm_object_utils(ultra_core_sanity_seq)

    // Variables

    // Tasks and Functions

    extern function new(string name = "ultra_core_sanity_seq");
    extern virtual task body();
  endclass

  function ultra_core_sanity_seq::new(string name = "ultra_core_sanity_seq");
    super.new(name);
  endfunction

  task ultra_core_sanity_seq::body();
    super.body();
    `uvm_info(get_full_name(), "[ULTRA_CORE] Starting Sanity Sequence", UVM_LOW)
    repeat(17) begin
      `uvm_do_with(req, {we==1;})
    end
    // wait_for_item_done();
  endtask

`endif

//End of ultra_core_sanity_seq
