class ALU_Driver extends uvm_driver #(ALU_Trans);
`uvm_component_utils(ALU_Driver)
//=================================
//declare the constructor
//=================================
function new(string name, uvm_component parent);
super.new(name,parent);
endfunction:new
//=================================
//declare the interface
//=================================
virtual ALU_Interface intf;
//=================================
//declare the transaction
//================================
ALU_Trans  trans;
//=================================
//uvm methods
//=================================
extern virtual function void build_phase(uvm_phase phase);
extern virtual task reset_phase(uvm_phase phase);
extern virtual task main_phase(uvm_phase phase);
extern virtual task sampling_task();
endclass:ALU_Driver
//class methods
function void ALU_Driver::build_phase(uvm_phase phase);
super.build_phase(phase);
//=======================================================
if(!uvm_config_db#(virtual ALU_Interface)::get(this,"","agent2drv",intf))
`uvm_fatal(get_full_name(),"Error on interface connectivity");
endfunction:build_phase
//=================================
task ALU_Driver::reset_phase(uvm_phase phase);
super.reset_phase(phase);
`uvm_info(get_type_name(),$sformatf("wait reset transaction from sequence"),UVM_NONE);
 sampling_task();
`uvm_info(get_full_name(),$sformatf("***finish send reset transaction to DUT***"),UVM_NONE);
endtask:reset_phase
//=================================
task ALU_Driver::main_phase(uvm_phase phase);
super.main_phase(phase);
`uvm_info(get_type_name(),$sformatf("Wait data transaction from sequence"),UVM_NONE);
 sampling_task();
`uvm_info(get_type_name(),$sformatf("***finish send transaction to DUT from main***"),UVM_NONE);
endtask:main_phase
//=================================
task ALU_Driver::sampling_task();
int trans_ID =0;
forever begin
  seq_item_port.get_next_item(trans);
  `uvm_info(get_type_name(),$sformatf("get transaction number [%0d] from sequence with values:%s",trans_ID,trans.convert2string()),UVM_MEDIUM);
  @(posedge intf.clk)
 		intf.cb.rst_n  <= trans.rst_n;  //observe
 		intf.cb.A      <= trans.A;
 		intf.cb.B      <= trans.B;
 		intf.cb.ALU_en <= trans.ALU_en;
 		intf.cb.a_op   <= trans.a_op;
 		intf.cb.b_op   <= trans.b_op;
 		intf.cb.a_en   <= trans.a_en;
 		intf.cb.b_en   <= trans.b_en;
  seq_item_port.item_done();
  trans_ID++;
  end
endtask

