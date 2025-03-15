//==================================================================================================
/*Description: We will test all possible fault injection scenarios with small discription 
                        for each transaction randomization.*/
//==================================================================================================
class ALU_fault_injection extends uvm_sequence#(ALU_Trans);
`uvm_object_utils(ALU_fault_injection)
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_fault_injection");
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
endclass:ALU_fault_injection
//==============================================
//Description: body() method is responsible for sending the fault injection scenario to the DUT
//==============================================
task ALU_fault_injection::body();
int trans_ID = 0;
//================================================================================
//send the non permitted values to DUT in case a_en = 1 and b_en = 0 [a_op = 7]
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;a_op == 7;a_en == 1; b_en == 0;} ) 
`uvm_info(get_type_name(),$sformatf("(fault_injection) Send Data To Driver with ID => [%0d] case a_en = 1 and b_en = 0 [a_op = 7]",trans_ID),UVM_MEDIUM);  
trans_ID++;
//================================================================================
//send the non permitted values to DUT in case a_en = 0 and b_en = 0 [a_op = 7] and check the output equal the previous value 
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;a_op == 7;a_en == 0; b_en == 0;})
`uvm_info(get_type_name(),$sformatf("(fault_injection) Send Data To Driver with ID => [%0d][a_op = 7] and check the output equal the previous value",trans_ID),UVM_MEDIUM);  
trans_ID++;
//================================================================================
//send the non permitted values to DUT in case a_en = 0 and b_en = 1 [b_op = 3]
repeat(2) begin
`uvm_do_with(trans,{rst_n == 1; ALU_en ==1;b_op == 3 ;a_en == 0; b_en == 1;})
`uvm_info(get_type_name(),$sformatf("(fault_injection) Send Data To Driver with ID => [%0d] case a_en = 0 and b_en = 1 [b_op = 3]",trans_ID),UVM_MEDIUM);  
trans_ID++;
end
endtask:body

