`ifndef ULTRA_CORE_MONITOR__SV
`define ULTRA_CORE_MONITOR__SV

  class ultra_core_monitor extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(ultra_core_monitor)

    // Variables
    ultra_core_seq_item ultra_core_seq_item_h;

    // Interface
    virtual ultra_core_intf vintf;

    // Analysis Port
    uvm_analysis_port #(ultra_core_seq_item) mon_port;

    // Tasks and Functions

    extern function new(string name = "ultra_core_monitor", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task mon_task();
    
  endclass

  function ultra_core_monitor::new(string name = "ultra_core_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void ultra_core_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ultra_core_intf)::get(this, "", "vintf", vintf)) begin
      `uvm_fatal(get_type_name(), "[ULTRA_CORE] Couldn't get vintf, did you set it?")
    end
    mon_port = new("mon_port", this);
  endfunction

  task ultra_core_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    mon_task();
  endtask

  task ultra_core_monitor::mon_task();
    ultra_core_seq_item_h = ultra_core_seq_item::type_id::create("ultra_core_seq_item_h");
    forever begin
      @(posedge vintf.clk);
      ultra_core_seq_item_h.we     = vintf.we;
      ultra_core_seq_item_h.addr   = vintf.addr;
      ultra_core_seq_item_h.wdata  = vintf.wdata;
      ultra_core_seq_item_h.rdata  = vintf.rdata;
      mon_port.write(ultra_core_seq_item_h);
      `uvm_info(get_full_name(), "[ULTRA_CORE] Written Sequence Item from Monitor", UVM_LOW)
    end
  endtask

`endif

//End of ultra_core_monitor
