//=========================================================================================================================
//Description: ALU_normal_test -> it is responsible for test all scenarios on one time to test that the ALU is working fine 
//=========================================================================================================================
class ALU_ALL_Test extends ALU_base_test;
`uvm_component_utils(ALU_ALL_Test)
//==============================================
//Description: declare the components
//==============================================
ALU_Normal_Sequence   norm_sequ;
directed_sequence     direct_sequ;
corner_case1_sequence corner_case1_sequ;
corner_case2_sequence corner_case2_sequ;
ALU_fault_injection   fault_injection_sequ;
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_ALL_Test",uvm_component parent = null);
super.new(name,parent);
endfunction:new
//==============================================
//Description: declare extern methods
//==============================================
extern virtual function void build_phase(uvm_phase phase);  //Note: no need to put virtual on the implementation
extern task reset_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);
endclass:ALU_ALL_Test
//==============================================================================
function void ALU_ALL_Test::build_phase(uvm_phase phase);
super.build_phase(phase);
norm_sequ            = ALU_Normal_Sequence::type_id::create("norm_sequ",this);
direct_sequ          = directed_sequence::type_id::create("direct_sequ",this);
corner_case1_sequ    = corner_case1_sequence::type_id::create("corner_case1_sequ",this);
corner_case2_sequ    = corner_case2_sequence::type_id::create("corner_case2_sequ",this);
fault_injection_sequ = ALU_fault_injection::type_id::create("fault_injection_sequ",this);
endfunction:build_phase

task ALU_ALL_Test::reset_phase(uvm_phase phase);  //test it comment and check reset phase execution
super.reset_phase(phase);
endtask:reset_phase
   
task ALU_ALL_Test::main_phase(uvm_phase phase);
super.main_phase(phase);
phase.raise_objection(this);
norm_sequ.start(env.ag.ALU_seqr);
direct_sequ.start(env.ag.ALU_seqr);
corner_case1_sequ.start(env.ag.ALU_seqr);
corner_case2_sequ.start(env.ag.ALU_seqr);
fault_injection_sequ.start(env.ag.ALU_seqr);
#1000ns;
phase.drop_objection(this);
endtask:main_phase


