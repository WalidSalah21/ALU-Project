//==============================================================================
//Description: ALU_base_test -> it is responsible for the reset test case
//==============================================================================
class ALU_base_test extends uvm_test;
`uvm_component_utils(ALU_base_test)
//==============================================
//Description: declare the components
//==============================================
ALU_ENV env;
ALU_base_sequence rst_seq;
//==============================================
//Description: declare the virtual interface
//==============================================
virtual ALU_Interface intf;
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_base_test",uvm_component parent = null);
super.new(name,parent);
endfunction:new
//==============================================
//Description: declare extern methods
//==============================================
extern virtual function void build_phase(uvm_phase phase);  //Note: no need to put virtual on the implementation
extern task reset_phase(uvm_phase phase);
endclass:ALU_base_test

function void ALU_base_test::build_phase(uvm_phase phase);
super.build_phase(phase);
env = ALU_ENV::type_id::create("env",this);
rst_seq = ALU_base_sequence::type_id::create("rst_seq");
//=======================================================
if(!uvm_config_db#(virtual ALU_Interface)::get(this,"","top2test",intf))begin
`uvm_fatal(get_full_name(),"Error on interface connectivity");
end
//=======================================================
uvm_config_db#(virtual ALU_Interface)::set(this,"env","test2env",intf);
endfunction:build_phase

task ALU_base_test::reset_phase(uvm_phase phase);
super.reset_phase(phase);
phase.raise_objection(this);
rst_seq.start(env.ag.ALU_seqr);
#10ns;
phase.drop_objection(this);
endtask:reset_phase



