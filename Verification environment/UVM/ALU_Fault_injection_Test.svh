//======================================================================================
//Description: ALU_corner_case1_test -> it is responsible for the Fault injection test case 
//======================================================================================
class ALU_fault_injection_test extends ALU_base_test;
`uvm_component_utils(ALU_fault_injection_test)
//==============================================
//Description: declare the components
//==============================================
ALU_fault_injection fault_injection_sequ;
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_fault_injection_test",uvm_component parent = null);
super.new(name,parent);
endfunction:new
//==============================================
//Description: declare extern methods
//==============================================
extern virtual function void build_phase(uvm_phase phase);  //Note: no need to put virtual on the implementation
extern task reset_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);
endclass:ALU_fault_injection_test
//==============================================================================
function void ALU_fault_injection_test::build_phase(uvm_phase phase);
super.build_phase(phase);
fault_injection_sequ = ALU_fault_injection::type_id::create("fault_injection_sequ",this);
endfunction:build_phase

task ALU_fault_injection_test::reset_phase(uvm_phase phase);  //test it comment and check reset phase execution
super.reset_phase(phase);
endtask:reset_phase
   
task ALU_fault_injection_test::main_phase(uvm_phase phase);
super.main_phase(phase);
phase.raise_objection(this);
fault_injection_sequ.start(env.ag.ALU_seqr);
#10ns;
phase.drop_objection(this);
endtask:main_phase





