//======================================================================================
//Description: ALU_directed_test_test -> it is responsible for the directed test case 
//======================================================================================
class ALU_directed_test_test extends ALU_base_test;
`uvm_component_utils(ALU_directed_test_test)
//==============================================
//Description: declare the components
//==============================================
directed_sequence direct_sequ;
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_directed_test_test",uvm_component parent = null);
super.new(name,parent);
endfunction:new
//==============================================
//Description: declare extern methods
//==============================================
extern virtual function void build_phase(uvm_phase phase);  //Note: no need to put virtual on the implementation
extern task reset_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);
endclass:ALU_directed_test_test
//==============================================================================
function void ALU_directed_test_test::build_phase(uvm_phase phase);
super.build_phase(phase);
direct_sequ = directed_sequence::type_id::create("direct_sequ",this);
endfunction:build_phase

task ALU_directed_test_test::reset_phase(uvm_phase phase);  //test it comment and check reset phase execution
super.reset_phase(phase);
endtask:reset_phase
   
task ALU_directed_test_test::main_phase(uvm_phase phase);
super.main_phase(phase);
phase.raise_objection(this);
direct_sequ.start(env.ag.ALU_seqr);
#10ns;
phase.drop_objection(this);
endtask:main_phase





