//==================================================================================================
/*Description:the next transactions are to increase the code coverage of the ALU module .*/
//==================================================================================================
class directed_sequence extends uvm_sequence#(ALU_Trans);
`uvm_object_utils(directed_sequence)
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "directed_sequence");
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
endclass:directed_sequence
//==============================================
//Description: body() method is responsible for sending the directed scenario to the DUT
//==============================================
task directed_sequence::body();
int trans_ID = 0;
//================================================================================
//send the non permitted values to DUT in case input values = -16 and repeat to increase code coverage cases with difference operations
repeat(10) begin
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;A == -16 ; B == -16;}) 
`uvm_info(get_type_name(),$sformatf("(fault_injection) Send Data To Driver with ID => [%0d] with A == -16 , B == -16 and ALU_en ==1",trans_ID),UVM_MEDIUM);  
trans_ID++;
end
`uvm_info(get_type_name(),$sformatf("(fault_injection) finish to Send Data To Driver equal [%0d] transactions in case input values = -16",--trans_ID),UVM_LOW);  
//================================================================================
//send the non permitted values to DUT in case input value of A  = -16
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;A == -16;}) 
`uvm_info(get_type_name(),$sformatf("(fault_injection) finish to Send Data To Driver transaction case input value of A  = -16 only"),UVM_LOW);  
trans_ID++;
//================================================================================
//send the non permitted values to DUT in case input value of B  = -16 to increase conditional code coverage
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;B == -16;})
`uvm_info(get_type_name(),$sformatf("(fault_injection) finish to Send Data To Driver  transaction case input value of B  = -16 only",trans_ID),UVM_LOW);  
trans_ID++;
//================================================================================
//send the non permitted values to DUT in case a_en = 1 and b_en = 0 and both input values = -16 to get the error flag
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;A == -16 ; B == -16;a_op == 0;a_en == 1; b_en == 0;})
`uvm_info(get_type_name(),$sformatf("(fault_injection) finish to Send Data To Driver transaction case a_en = 1 and b_en = 0 and both input values = -16 to get the error "),UVM_LOW);  
//================================================================================
endtask:body



