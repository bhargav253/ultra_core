`ifndef ULTRA_CORE_AGENT__SV
`define ULTRA_CORE_AGENT__SV

  class ultra_core_agent extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(ultra_core_agent)

    // Agent config
    ultra_core_agent_cfg agnt_cfg;

    // UVCs
    ultra_core_driver     drvh;
    ultra_core_monitor    monh;
    ultra_core_sequencer  seqrh;

    // Tasks and Functions
    extern function new(string name = "ultra_core_agent", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    // extern virtual task run_phase(uvm_phase);
  endclass

  function ultra_core_agent::new(string name = "ultra_core_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void ultra_core_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "[ULTRA_CORE] Starting Build Phase", UVM_LOW)
    
    // agnt_cfg = ultra_core_agent_cfg::type_id::create("agnt_cfg");
    if(!uvm_config_db#(ultra_core_agent_cfg)::get(this, "", "agnt_cfg", agnt_cfg)) begin
      `uvm_fatal(get_type_name(), "[ULTRA_CORE] Couldn't get agnt_cfg, did you set it?")
    end

    // Build UVC
    monh = ultra_core_monitor::type_id::create("monh", this);
    if(agnt_cfg.is_active == UVM_ACTIVE) begin
      drvh = ultra_core_driver::type_id::create("drvh", this);
      seqrh = ultra_core_sequencer::type_id::create("seqrh", this);
    end
    `uvm_info(get_full_name(), "[ULTRA_CORE] Ending Build Phase", UVM_LOW)
  endfunction

  function void ultra_core_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "[ULTRA_CORE] Starting Connect Phase", UVM_LOW)
    if(agnt_cfg.is_active == UVM_ACTIVE) begin
      drvh.seq_item_port.connect(seqrh.seq_item_export);
    end
    `uvm_info(get_full_name(), "[ULTRA_CORE] Ending Connect Phase", UVM_LOW)
  endfunction

`endif

//End of ultra_core_agent
