//==============================================================================
//Description: ALU_normal_test -> it is responsible for the normal test case 
//==============================================================================
class ALU_normal_test extends ALU_base_test;
`uvm_component_utils(ALU_normal_test)
//==============================================
//Description: declare the components
//==============================================
ALU_Normal_Sequence norm_sequ;
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_normal_test",uvm_component parent = null);
super.new(name,parent);
endfunction:new
//==============================================
//Description: declare extern methods
//==============================================
extern virtual function void build_phase(uvm_phase phase);  //Note: no need to put virtual on the implementation
extern task reset_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);
endclass:ALU_normal_test
//==============================================================================
function void ALU_normal_test::build_phase(uvm_phase phase);
super.build_phase(phase);
norm_sequ = ALU_Normal_Sequence::type_id::create("norm_sequ",this);
endfunction:build_phase

task ALU_normal_test::reset_phase(uvm_phase phase);  //test it comment and check reset phase execution
super.reset_phase(phase);
endtask:reset_phase
   
task ALU_normal_test::main_phase(uvm_phase phase);
super.main_phase(phase);
phase.raise_objection(this);
norm_sequ.start(env.ag.ALU_seqr);
#10ns;
phase.drop_objection(this);
endtask:main_phase


