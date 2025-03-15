//==============================================================================
//Description: declare the ALU_base_sequence class responsible for the reset case
//==============================================================================
class ALU_base_sequence extends uvm_sequence#(ALU_Trans);
`uvm_object_utils(ALU_base_sequence)
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_base_sequence");
super.new(name);
endfunction:new
//==============================================
//Description: declare the class properties
//==============================================
ALU_Trans trans;
//==============================================
//Description: declare the extern methods
//==============================================
extern task body();
endclass:ALU_base_sequence
//==============================================
//Description: body() method is responsible for sending the reset scenario to the DUT
task ALU_base_sequence::body();
`uvm_do_with(trans, {rst_n == 0;})  
`uvm_info(get_type_name(),$sformatf("(Reset_senario) Send [rst_n = 0] Data To Driver"),UVM_NONE); 
`uvm_do_with(trans, {rst_n == 1;})  
`uvm_info(get_type_name(),$sformatf("(Reset_senario) Send [rst_n = 1] Data To Driver"),UVM_NONE); 
endtask:body

