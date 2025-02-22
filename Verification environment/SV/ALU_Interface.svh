interface ALU_Interface#(WIDTH = 5)(input bit clk);
	//==============================================
	//Description: Interface signals
	//==============================================
	logic          rst_n;
    logic signed [WIDTH-1:0]  A,B;
    logic        ALU_en,a_en,b_en;
	logic [2:0]  a_op;              // set of operations for A  
    logic [1:0]  b_op;
	logic signed [WIDTH :0]  C;
	logic error_flag;
	
    //==============================================
    //Description: Clocking block
	//==============================================
    clocking cb @(posedge clk);
		default input #1ns output #1ns ; //this direction related to the testbench
		output A,B;
	    output ALU_en,a_en,b_en,rst_n;
		output a_op,b_op;
		input  C;
	endclocking:cb
///////////////////////////////////////////////
//==============================================
//Description: internal signals
//==============================================
logic [1:0] OP_Ctrl;            //to Select which operation to perform
assign OP_Ctrl = {b_en,a_en};  //concatenating the control signals
assign antecedent = (ALU_en && (A == -16 || B == -16 ||(OP_Ctrl == 'b01 && a_op ==3'd7) ||(OP_Ctrl == 'b10 && b_op ==2'd3)));
//==============================================
//Description: Assertions and Covergroups
/*Note: The assertions and covergroups are used to check the correctness of the design
and i dpn't write all the combinations of the operations because it will be a lot of code.
I test all this cases in the testbench on the golden model comparison and the function coverage*/
//==============================================
AESS1:assert property  (@(rst_n) (!rst_n) |-> (C ==0));  //to check the reset
COVER1:cover  property (@(rst_n) (!rst_n) |-> (C ==0));
AESS2:assert property (@(posedge clk) disable iff(!rst_n) !ALU_en |=> (C == $past(C))); //to check the stability of the output when the ALU_en is disabled
COVER2:cover  property (@(posedge clk) disable iff(!rst_n) !ALU_en |=> (C == $past(C)));
AESS3:assert property (@(posedge clk) disable iff(!rst_n) (antecedent |=> error_flag)); //to check the error flag
COVER3:cover property (@(posedge clk) disable iff(!rst_n) (antecedent |=> error_flag));


endinterface: ALU_Interface