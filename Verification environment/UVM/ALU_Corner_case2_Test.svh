//======================================================================================
//Description: ALU_corner_case2_test -> it is responsible for the corner case2 test case 
//======================================================================================
class ALU_corner_case2_test extends ALU_base_test;
`uvm_component_utils(ALU_corner_case2_test)
//==============================================
//Description: declare the components
//==============================================
corner_case2_sequence corner_case2_sequ;
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_corner_case2_test",uvm_component parent = null);
super.new(name,parent);
endfunction:new
//==============================================
//Description: declare extern methods
//==============================================
extern virtual function void build_phase(uvm_phase phase);  //Note: no need to put virtual on the implementation
extern task reset_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);
endclass:ALU_corner_case2_test
//==============================================================================
function void ALU_corner_case2_test::build_phase(uvm_phase phase);
super.build_phase(phase);
corner_case2_sequ = corner_case2_sequence::type_id::create("corner_case2_sequ",this);
endfunction:build_phase

task ALU_corner_case2_test::reset_phase(uvm_phase phase);  //test it comment and check reset phase execution
super.reset_phase(phase);
endtask:reset_phase
   
task ALU_corner_case2_test::main_phase(uvm_phase phase);
super.main_phase(phase);
phase.raise_objection(this);
corner_case2_sequ.start(env.ag.ALU_seqr);
#10ns;
phase.drop_objection(this);
endtask:main_phase



