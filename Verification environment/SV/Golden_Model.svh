class Golden_Model;
//======================================
//declare your mailbox here
//======================================
mailbox #(ALU_Trans) Agent2G_Model_mb,G_model2chk_mb;
//======================================
//declare transaction here
//======================================
ALU_Trans                 trans;
logic  signed [WIDTH:0]   Previous_C;  //to store the last value of C
bit           [1:0]       OP_Ctrl;     //to store the control of the operation
//======================================
//External Methods
//======================================
    extern function new(mailbox #(ALU_Trans) Agent2G_Model_mb,G_model2chk_mb);
	extern task G_Model_run();
	extern task Model(ALU_Trans transaction);
endclass:Golden_Model
//======================================
//New function
//======================================
function Golden_Model::new(mailbox #(ALU_Trans) Agent2G_Model_mb,G_model2chk_mb);
    this.Agent2G_Model_mb = Agent2G_Model_mb;
    this.G_model2chk_mb = G_model2chk_mb;
endfunction:new
//======================================
//task to monitor the output
//======================================
task Golden_Model::G_Model_run();
int trans_ID =0;
    forever begin
		Agent2G_Model_mb.get(trans);
        $display("[Golden_Model] get data from Agent with trans_ID -->[%0d],[%p]",trans_ID,trans);
		Model(trans);
        $display("[Golden_Model] Expected trans.C -->[%0d] ,trans_ID -->[%0d]",trans.C,trans_ID);
        G_model2chk_mb.put(trans);
		Previous_C=trans.C;
        $display("[Golden_Model] Send data to checker with trans_ID -->[%0d]",trans_ID);
        trans_ID++;
	end 
endtask:G_Model_run
//======================================
//task to Calculate the operation
//======================================
task Golden_Model::Model(ALU_Trans transaction);
  trans = new();
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



endtask:Model