//==================================================================================================
/*Description: Randomize the transaction. (In this sequence, we will randomize transactions to maximize the number 
of possible input values combinations, thereby achieving higher record coverage)*/ 
//==================================================================================================
class ALU_Normal_Sequence extends uvm_sequence#(ALU_Trans);
`uvm_object_utils(ALU_Normal_Sequence)
//==============================================
//Description: declare the constructor
//==============================================
function new(string name = "ALU_Normal_Sequence");
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
endclass:ALU_Normal_Sequence
//==============================================
//Description: body() method is responsible for sending the normal scenario to the DUT
task ALU_Normal_Sequence::body();
int trans_ID =0; 
repeat(1000) begin
   `uvm_do_with(trans, {rst_n == 1; ALU_en ==1; A dist {-15:=3,0:=3,15:=3,[-14:-1]:/10,[1:14]:/10};
                                                B dist {-15:=3,0:=3,15:=3,[-14:-1]:/10,[1:14]:/10};}) 
   `uvm_info(get_type_name(),$sformatf("(Normal_senario) Send Data To Driver with ID => [%0d]",trans_ID),UVM_MEDIUM);
    trans_ID++;
end
   `uvm_info(get_type_name(),$sformatf("(Normal_senario) ***finish to Send [%0d] Data transactions To Driver***",--trans_ID),UVM_NONE);
endtask:body


