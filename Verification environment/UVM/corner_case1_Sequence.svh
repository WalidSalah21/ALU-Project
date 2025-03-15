//==================================================================================================
/*Description: We will randomize number of transactions inside them we will set ALU_en = 1 and rst_n =0  
and send the same transaction more than one time to DUT for the same operation.*/
//==================================================================================================
class corner_case1_sequence extends uvm_sequence#(ALU_Trans);
`uvm_object_utils(corner_case1_sequence)
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "corner_case1_sequence");
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
endclass:corner_case1_sequence
//==============================================
//Description: body() method is responsible for sending the corner case scenario to the DUT
//==============================================
task corner_case1_sequence::body();
int same_trans_num = $urandom_range(1,20);       //randomize the number of transactions to be sent with the same data
int operation_trans_num = $urandom_range(20,50); //randomize the number of operations to be sent with different opperation
int trans_ID =0; 

repeat(operation_trans_num) begin
    `uvm_do_with(trans, {rst_n == 1; ALU_en ==1;}) 
    repeat(same_trans_num) begin  //send the same transaction more than one time to DUT for the same operation
    start_item(trans);  
    finish_item(trans); 
    trans_ID++;
    end
    `uvm_info(get_type_name(),$sformatf("(corner_case1) Send Data To Driver with ID => [%0d]",--trans_ID),UVM_HIGH);    
end
    `uvm_info(get_type_name(),$sformatf("(corner_case1) finish to Send [%0d] Data transactions To Driver",--trans_ID),UVM_NONE);
endtask:body



