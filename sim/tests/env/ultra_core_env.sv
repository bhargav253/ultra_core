`ifndef ULTRA_CORE_ENV__SV
`define ULTRA_CORE_ENV__SV

  class ultra_core_env extends uvm_env;

    // Factory Registration
    `uvm_component_utils(ultra_core_env)

    // Environment Variables
    bit is_scoreboard_enable = 1;
    bit is_coverage_enable = 1;

    // Declare UVC
    ultra_core_agent_cfg agnt_cfg;
    ultra_core_agent agnth;
    ultra_core_sb sbh;
    ultra_core_cov covh;

    extern function new (string name = "ultra_core_env", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
  endclass

  function ultra_core_env::new(string name = "ultra_core_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void ultra_core_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "[ULTRA_CORE] Starting Build Phase", UVM_LOW)
    agnt_cfg = ultra_core_agent_cfg::type_id::create("agnt_cfg");
    uvm_config_db #(ultra_core_agent_cfg)::set(this, "*", "agnt_cfg", agnt_cfg);
    agnth = ultra_core_agent::type_id::create("agnth", this);
    if(is_scoreboard_enable) begin
      sbh = ultra_core_sb::type_id::create("sbh", this);
    end
    if(is_coverage_enable) begin
      covh = ultra_core_cov::type_id::create("covh", this);
    end
    `uvm_info(get_full_name(), "[ULTRA_CORE] Ending Build Phase", UVM_LOW)
  endfunction

  function void ultra_core_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(), "[ULTRA_CORE] Starting Connect Phase", UVM_LOW)
    if(is_scoreboard_enable) begin
      agnth.monh.mon_port.connect(sbh.sb_fifo.analysis_export);
    end
    if(is_coverage_enable) begin
      agnth.monh.mon_port.connect(covh.analysis_export);
    end
    `uvm_info(get_full_name(), "[ULTRA_CORE] Ending Connect Phase", UVM_LOW)
  endfunction

`endif

//End of ultra_core_env
