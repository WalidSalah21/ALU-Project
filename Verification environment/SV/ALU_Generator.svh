class ALU_Generator;
//==========================================
//Description: declare Transaction
//==========================================
ALU_Trans trans1;
//==========================================
//Description: declare mailbox
//==========================================
mailbox #(ALU_Trans) gen2drv_mb;
//==========================================
//Description: declare external methods]
//==========================================
extern function new(mailbox #(ALU_Trans) gen2drv_mb);
extern task generator_run(int rand_num_trans,senarios senario);
extern task reset();
extern task normal_case1(int rand_num_trans);
extern task corner_case1(int operation_num_trans = 1);
extern task corner_case2();
extern task fault_injection();
extern task random_test(int rand_num_trans); 
endclass:ALU_Generator
//================================================================
            //Methods implementation//
//================================================================
//==========================================
//Description: Constructor
//==========================================
function ALU_Generator::new(mailbox #(ALU_Trans) gen2drv_mb);
this.gen2drv_mb = gen2drv_mb;
endfunction:new
//==========================================
//Description: Run the generator
//==========================================
task ALU_Generator::generator_run(int rand_num_trans,senarios senario);
case(senario)
Normal_senario1:begin:normal_senario1
    normal_case1(rand_num_trans);
    end   
Corner_case1:begin:corner_senario1
    corner_case1(5);
end
Corner_case2:begin:corner_senario2
    corner_case2();
end
fault_injection1:begin:fault_injection_senario
fault_injection();
end
all:begin:all_senario
   normal_case1(rand_num_trans);
  fault_injection();
   corner_case1(10);
   corner_case2();
   random_test(rand_num_trans);
end
endcase
endtask:generator_run

//==========================================
//Description: Reset the transaction
//==========================================
task ALU_Generator::reset();
trans1 = new();
assert(trans1.randomize() with {rst_n == 0;});
trans1.display("Generator_Reset_senario",0);  //display the transaction
gen2drv_mb.put(trans1);
$display("[ALU_Generator]Send Reset_senario [rst_n = 0] Data To Driver");                     
endtask:reset

//==========================================
/*Description: Randomize the transaction. (In this task, we will randomize transactions to maximize the number 
of possible input value combinations, thereby achieving higher record coverage) */
//==========================================
task ALU_Generator::normal_case1(int rand_num_trans);
int trans_ID;
reset();
repeat(rand_num_trans)begin
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1; A dist {-15:=3,0:=3,15:=3,[-14:-1]:/10,[1:14]:/10};
                                                        B dist {-15:=3,0:=3,15:=3,[-14:-1]:/10,[1:14]:/10};});
trans1.display("Generator_normal_case1",trans_ID);  //display the transaction
gen2drv_mb.put(trans1);                             //send the transaction to driver 
$display("[ALU_Generator]Send normal_case1 Data To Driver number-->[%0d]",trans_ID); 
trans_ID++;               
end
endtask:normal_case1
//================================================================
/*Description: Send to dut the same required operation more than one transaction with
                 random number with each operator. */
//================================================================
task ALU_Generator::corner_case1(int operation_num_trans = 1);
int trans_num = $urandom_range(1,20);
int trans_ID = 0;
repeat(operation_num_trans)begin
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;});
trans1.display("Generator_corner_case1",trans_ID);  //display the transaction
repeat(trans_num)begin
        gen2drv_mb.put(trans1);     //send the transaction to driver
        $display("[ALU_Generator]Send corner_case1 Data To Driver number-->[%0d]",trans_ID); 
        trans_ID++;
end
end
endtask:corner_case1

//================================================================
/*Description: test to add the  maximum possible values on the two operand 
               and subtract the minmum possible values too.   */
//================================================================
//add operation
task ALU_Generator::corner_case2();
int trans_ID = 0;
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1; A == 15; B == 15;a_op ==0 ;a_en == 1; b_en == 0;});
trans1.display("Generator_corner_case2",trans_ID);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send corner_case2 Data To Driver number-->[%0d]",trans_ID); 
trans_ID++;
//==========================================
//add operation
repeat(2)begin
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1; A == 15; B == 15;b_op inside {1,2} ;a_en == 0; b_en == 1;});
trans1.display("Generator_corner_case2",trans_ID);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send corner_case2 Data To Driver number-->[%0d]",trans_ID); 
trans_ID++;
end
//==========================================
//sub operation
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1; A == -15; B == 15;a_op == 1;a_en == 1; b_en == 0;});
trans1.display("Generator_corner_case2",trans_ID);  //display the transaction
gen2drv_mb.put(trans1);                             //send the transaction to driver
$display("[ALU_Generator]Send corner_case2 Data To Driver number-->[%0d]",trans_ID); 
endtask:corner_case2

//================================================================
/*Description: Insert the non permitted values to DUT in all possible
               cases on the operation of A_op and B_op.  */
//================================================================
task ALU_Generator::fault_injection();
int trans_ID = 0;
//================================================================================
//send the non permitted values to DUT in case a_en = 1 and b_en = 0 [a_op = 7]
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;a_op == 7;a_en == 1; b_en == 0;});
trans1.display("Generator_fault_injection",1);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver numberin case a_op-->[%0d]",trans_ID); 
trans_ID++;
//================================================================================
//send the non permitted values to DUT in case a_en = 1 and b_en = 0 [a_op = 7]
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;a_op == 7;a_en == 0; b_en == 0;});
trans1.display("Generator_fault_injection",1);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver numberin case a_op-->[%0d]",trans_ID); 
trans_ID++;
//================================================================================
//send the non permitted values to DUT in case a_en = 0 and b_en = 1 [b_op = 3]
repeat(2) begin
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;b_op == 3 ;a_en == 0; b_en == 1;});
trans1.display("Generator_fault_injection",2);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case b_op-->[%0d]",trans_ID); 
trans_ID++;
end
//==========================================================================================================
//send the non permitted values to DUT in case input values = -16 and repeat to increase code coverage cases
repeat(10)begin
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;A == -16 ; B == -16;});
trans1.display("Generator_fault_injection",3);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
trans_ID++;
end
//===================================================================================================
//send the non permitted values to DUT in case input value of A  = -16 to increase conditional code coverage
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;A == -16;});
trans1.display("Generator_fault_injection",3);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
trans_ID++;
//===================================================================================================
//send the non permitted values to DUT in case input value of B  = -16 to increase conditional code coverage
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;B == -16;});
trans1.display("Generator_fault_injection",3);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
trans_ID++;
//===================================================================================================
//send the non permitted values to DUT in case a_en = 1 and b_en = 0 and both input values = -16 to get the error flag
trans1 = new();
assert(trans1.randomize() with {rst_n == 1; ALU_en ==1;A == -16 ; B == -16;a_op == 0;a_en == 1; b_en == 0;});
trans1.display("Generator_fault_injection",3);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
$display("[ALU_Generator]Send normal transaction in fault_injection To Driver number in case input values = -16-->[%0d]",trans_ID); 
trans_ID++;
endtask:fault_injection

//===============================================================
/*Description:This scenario for insert directed tests to hit 
                the remain values on the coverage collector */ 
//================================================================
task ALU_Generator::random_test(int rand_num_trans);
int trans_ID = 0;
//send normal transaction 
repeat(rand_num_trans) begin
trans1 = new();
assert(trans1.randomize() with {rst_n == 1;});
trans1.display("random_test",0);  //display the transaction
gen2drv_mb.put(trans1);     //send the transaction to driver
trans_ID++;
$display("[ALU_Generator]Send normal transaction in random_test To Driver number-->[%0d]",trans_ID); 
end
endtask:random_test
//================================================================