//==================================================================================================
/*Description: We will test add the maximum possible values on the two operand and subtract
                         the minmum possible values too.*/
//==================================================================================================
class corner_case2_sequence extends uvm_sequence#(ALU_Trans);
`uvm_object_utils(corner_case2_sequence)
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "corner_case2_sequence");
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
endclass:corner_case2_sequence
//==============================================
//Description: body() method is responsible for sending the corner case scenario to the DUT
//==============================================

task corner_case2_sequence::body();
int trans_ID = 0;
//=============================================
//add operation 
//=============================================
`uvm_do_with(trans, {rst_n == 1; ALU_en ==1; A == 15; B == 15;a_op ==0 ;a_en == 1; b_en == 0;}) //add the maximum possible values using a_op selector
`uvm_info(get_type_name(),$sformatf("(corner_case2) Send Data To Driver with ID => [%0d] to add the maximum possible values using a_op selector",trans_ID),UVM_MEDIUM);  
trans_ID++;
//==================
repeat(2) begin
`uvm_do_with(trans, {rst_n == 1; ALU_en ==1; A == 15; B == 15;b_op inside {1,2} ;a_en == 0; b_en == 1;}) //add the maximum possible values using b_op selector
`uvm_info(get_type_name(),$sformatf("(corner_case2) Send Data To Driver with ID => [%0d] to add the maximum possible values using b_op selector",trans_ID),UVM_MEDIUM);  
trans_ID++;
end
//=============================================
//sub operation 
//=============================================
`uvm_do_with(trans, {rst_n == 1; ALU_en ==1; A == -15; B == 15;a_op == 1;a_en == 1; b_en == 0;}) //sub to get the minimum possible values using a_op selector
`uvm_info(get_type_name(),$sformatf("(corner_case2) Send Data To Driver with ID => [%0d] to get the minimum possible values using a_op selector",trans_ID),UVM_MEDIUM);  
endtask:body




// //================================================================
// /*Description: Insert the non permitted values to DUT in all possible
//                cases on the operation of A_op and B_op.  */
// //================================================================
// task ALU_Generator::fault_injection();
// int trans_ID = 0;
// //================================================================================
// //send the non permitted values to DUT in case a_en = 1 and b_en = 0 [a_op = 7]
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;a_op == 7;a_en == 1; b_en == 0;});
// trans1.display("Generator_fault_injection",1);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver numberin case a_op-->[%0d]",trans_ID); 
// trans_ID++;
// //================================================================================
// //send the non permitted values to DUT in case a_en = 1 and b_en = 0 [a_op = 7]
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;a_op == 7;a_en == 0; b_en == 0;});
// trans1.display("Generator_fault_injection",1);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver numberin case a_op-->[%0d]",trans_ID); 
// trans_ID++;
// //================================================================================
// //send the non permitted values to DUT in case a_en = 0 and b_en = 1 [b_op = 3]
// repeat(2) begin
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;b_op == 3 ;a_en == 0; b_en == 1;});
// trans1.display("Generator_fault_injection",2);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case b_op-->[%0d]",trans_ID); 
// trans_ID++;
// end
// //==========================================================================================================
// //send the non permitted values to DUT in case input values = -16 and repeat to increase code coverage cases
// repeat(10)begin
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;A == -16 ; B == -16;});
// trans1.display("Generator_fault_injection",3);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
// trans_ID++;
// end
// //===================================================================================================
// //send the non permitted values to DUT in case input value of A  = -16 to increase conditional code coverage
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;A == -16;});
// trans1.display("Generator_fault_injection",3);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
// trans_ID++;

// //===================================================================================================
// //send the non permitted values to DUT in case input value of B  = -16 to increase conditional code coverage
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;B == -16;});
// trans1.display("Generator_fault_injection",3);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
// trans_ID++;
// //===================================================================================================
// //send the non permitted values to DUT in case a_en = 1 and b_en = 0 and both input values = -16 to get the error flag
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;A == -16 ; B == -16;a_op == 0;a_en == 1; b_en == 0;});
// trans1.display("Generator_fault_injection",3);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// $display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
// trans_ID++;
// endtask:fault_injection

// //===============================================================
// /*Description:This scenario for insert directed tests to hit 
//                 the remain values on the coverage collector */ 
// //================================================================
// task ALU_Generator::random_test(int rand_num_trans);
// int trans_ID = 0;
// //send normal transaction 
// repeat(rand_num_trans) begin
// trans1 = new();
// assert(trans1.randomize() with {rst_n == 1;});
// trans1.display("random_test",0);  //display the transaction
// gen2drv_mb.put(trans1);     //send the transaction to driver
// trans_ID++;
// $display("[ALU_Generator]Send normal transaction in random_test To Driver number-->[%0d]",trans_ID); 
// end
// endtask:random_test