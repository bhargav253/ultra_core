`ifndef ULTRA_CORE_COV__SV
`define ULTRA_CORE_COV__SV

  class ultra_core_cov extends uvm_subscriber#(ultra_core_seq_item);
    
    // Factory Registration
    `uvm_component_utils(ultra_core_cov)

    extern function new(string name = "ultra_core_cov", uvm_component parent = null);
    extern virtual function void write(ultra_core_seq_item t);
  endclass

  function ultra_core_cov::new(string name = "ultra_core_cov", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void ultra_core_cov::write(ultra_core_seq_item t);
    `uvm_info(get_full_name(), "[ULTRA_CORE] Received item in Subscriber", UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("\n[ULTRA_CORE] Packet Data:\n\twe: %0d,\n\taddr: %0d,\n\twdata: %0d,\n\trdata: %0d", 
      t.we, t.addr, t.wdata, t.rdata), UVM_LOW)
  endfunction

`endif

//End of ultra_core_cov
