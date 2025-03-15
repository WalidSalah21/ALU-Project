class Golden_Model extends uvm_component;
`uvm_component_utils(Golden_Model)
//======================================
//declare mailboxes
//======================================
uvm_analysis_imp #(ALU_Trans , Golden_Model) mon_inp2g_model;
uvm_analysis_port #(ALU_Trans) g_model2chk;
//======================================
//declare constructor
//======================================
function new(string name ="Golden_Model",uvm_component parent =null);
super.new(name,parent);
mon_inp2g_model = new("mon_inp2g_model",this);
g_model2chk     = new("g_model2chk",this);
endfunction:new
//======================================
//declare transaction here
//======================================
ALU_Trans                 trans;
logic  signed [WIDTH:0]   Previous_C;  //to store the last value of C
bit           [1:0]       OP_Ctrl;     //to store the control of the operation
//======================================
//External Methods
//======================================
extern  function void Model(ALU_Trans transaction);
extern virtual function void write (ALU_Trans transaction);
endclass: Golden_Model
//======================================
//function to write the transaction
//======================================
 function void Golden_Model::write(ALU_Trans transaction);
    trans =ALU_Trans::type_id::create("trans",this);  
		Model(transaction); //clone the transaction to the local transaction
	 	Previous_C=trans.C;
        g_model2chk.write(trans);
        `uvm_info(get_full_name(),$sformatf("Send data to checker the result of the operation"),UVM_NONE);
endfunction:write
// ======================================
// task to Calculate the operation
// ======================================
function void Golden_Model::Model(ALU_Trans transaction);
OP_Ctrl ={transaction.b_en,transaction.a_en};  //to store the control of the operation for use it on the case statement
if(!transaction.rst_n)begin:reset_case
trans.C = '0;
trans.error_flag = '0;
end
else if(transaction.ALU_en) begin
    if((transaction.A == -16 || transaction.B == -16 ||(OP_Ctrl == 'b01 && transaction.a_op ==3'd7) ||(OP_Ctrl == 'b10 && transaction.b_op ==2'd3)))begin
        trans.error_flag = 1;
    end
    else begin:incase_operation
     trans.error_flag = 0;
    end  
    //////////////////////////////////
case(OP_Ctrl)
0:begin:no_operation
	trans.C =Previous_C;
end
1:begin:a_en_operation
case(transaction.a_op)
		    'b000:begin:ADD_op
                trans.C = transaction.A + transaction.B;
            end
            'b001:begin:SUB_op
                trans.C = transaction.A - transaction.B;
            end
            'b010:begin:XOR_op     
                trans.C = transaction.A ^ transaction.B;
            end
            'b011,'b100:begin:AND_op
                trans.C = transaction.A & transaction.B;
            end
            'b101:begin:OR_op
                trans.C = transaction.A | transaction.B;
            end
            'b110:begin:XNOR_op
                trans.C = transaction.A ~^ transaction.B;
            end
            default:begin:illegal_Operation_CaseOP7
                trans.C = Previous_C; // Assign an illegal value
            end
endcase
end
2:begin:b_en_operation
case(transaction.b_op)
            'b00:
            begin:NAND_op
                trans.C = ~(transaction.A & transaction.B);
            end
            'b01,'b10:
            begin:ADD_op
                trans.C = transaction.A + transaction.B;
            end
            'b11:
            begin:illegal_Operation_CaseOP3
                trans.C = Previous_C; // Assign an illegal value
            end
endcase
end
3:begin:ab_en_operation
            case(transaction.b_op) 
            'b00:
            begin:XOR_op
                trans.C = transaction.A ^ transaction.B;
            end
            'b01:
            begin:XNOR_op
                trans.C = transaction.A ~^ transaction.B;
            end
            'b10:
            begin:SUB1_From_A
                trans.C = transaction.A - 1;
            end
            'b11:
            begin:ADD2_To_B
                trans.C = transaction.B + 2; 
            end
            endcase
          end

endcase
end
else begin:incase_no_operation
trans.C =Previous_C;
end
endfunction:Model
