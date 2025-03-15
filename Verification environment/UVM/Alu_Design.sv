module ALU #(WIDTH = 5) (
    input  logic signed [WIDTH-1:0]  A,B,  // input data
    input  wire         clk,rst_n,         // clock and reset
    input               ALU_en,a_en,b_en,  // control signals
    input  logic [2:0]  a_op,              // set of operations for A  
    input  logic [1:0]  b_op,              // set of operations for B
    output logic signed [WIDTH :0]  C,
    output logic error_flag
);

//==========================================================================
// Internal signals declaration
wire [1:0] OP_Ctrl;            //to Select which operation to perform
logic      error_reg;          //to store the error flag
logic signed [WIDTH:0] C_reg;  //to store the output of the operation
//==========================================================================

assign OP_Ctrl = {b_en,a_en};  //concatenating the control signals

//==========================================================================
//sequential block to store the output of the operation
always @(posedge clk,negedge rst_n) begin
    if(!rst_n) begin
        C <= 'b0;
        error_flag <= '0;
    end
    else if (ALU_en) begin
        C <= C_reg;
        error_flag <= error_reg;
    end
end
//==========================================================================
//combinational block to perform the operation
// Note: All the logical operations are bitwise operations
always_comb begin
    case(OP_Ctrl)
       'b00:begin:no_operation
         C_reg = C;
             end 
       'b01:begin:a_en_operation
          case(a_op) 
            'b000:begin:ADD_op
                C_reg = A + B;
            end
            'b001:begin:SUB_op
                C_reg = A - B;
            end
            'b010:begin:XOR_op     
                C_reg = A ^ B;
            end
            'b011,'b100:begin:AND_op
                C_reg = A & B;
            end
            'b101:begin:OR_op
                C_reg = A | B;
            end
            'b110:begin:XNOR_op
                C_reg = A ~^ B;
            end
            default:begin:illegal_Operation_CaseOP7
                C_reg = C ; // Assign an illegal value
            end
          endcase
         end
       'b10:begin:b_en_operation
            case(b_op)
            'b00:
            begin:NAND_op
                C_reg = ~(A & B);
            end
            'b01,'b10:
            begin:ADD_op
                C_reg = A + B;
            end
            'b11:
            begin:illegal_Operation_CaseOP3
                C_reg = C ; // Assign an illegal value
            end
            endcase
         end
       'b11:begin:ab_en_operation
            case(b_op) 
            'b00:
            begin:XOR_op
                C_reg = A ^ B;
            end
            'b01:
            begin:XNOR_op
                C_reg = A ~^ B;
            end
            'b10:
            begin:SUB1_From_A
                C_reg = A - 1;
            end
            'b11:
            begin:ADD2_To_B
                C_reg = B + 2; 
            end
            endcase
          end
       endcase
end

always_comb begin
    if(A == -16 || B == -16 ||(OP_Ctrl == 'b01 && a_op ==3'd7) ||(OP_Ctrl == 'b10 && b_op ==2'd3)) begin
        error_reg = 'b1;
    end
    else begin
        error_reg = 'b0;
    end
end
endmodule