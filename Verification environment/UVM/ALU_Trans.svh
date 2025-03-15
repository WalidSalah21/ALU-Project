class ALU_Trans extends uvm_sequence_item;
`uvm_object_utils(ALU_Trans) 
//==========================================
//declare transaction constructor
//==========================================
function new(string name = "ALU_Trans");
super.new(name);
endfunction:new
//==========================================
//declare transaction variables
//==========================================
rand  logic signed [WIDTH-1:0] A,B;   //input data
rand  logic                  rst_n;   //reset signal 
rand  logic                 ALU_en;   //enable signal
randc logic        [2:0]      a_op;   //operation for A
randc logic        [1:0]      b_op;   //operation for B
rand  logic              a_en,b_en;   //enable signal for A and B
logic signed [WIDTH:0]           C;   //output data
logic                   error_flag;   //error flag

//==========================================
//Description: extern Methods
//==========================================
extern virtual function string convert2string();
extern virtual function void   do_print(uvm_printer printer);
extern virtual function bit    do_compare(uvm_object rhs, uvm_comparer comparer);
extern virtual function void   do_copy(uvm_object rhs);
//==============================================================================
//Description: Constraint block for general porpose
//==============================================================================
constraint operations {
                     soft a_op inside {[0:6]};
                     soft (!a_en && b_en) -> b_op inside {[0:2]};
                     soft A inside {[-15:15]};
                     soft B inside {[-15:15]};
                     soft ALU_en dist {1:=2,0:=2};
                     }
endclass:ALU_Trans

//==========================================
//Description: extern methods
//==========================================
function string ALU_Trans::convert2string();
string str;
str = super.convert2string();
$sformat(str,"%s A:%5b ,B:%5b ,ALU_en:%0d ,a_op:%0d ,b_op:%0d ,a_en:%1b ,b_en:%1b ,C:%5b,Error_Flag:%0d"
              ,str,A,B,ALU_en,a_op,b_op,a_en,b_en,C,error_flag);
return str;
endfunction:convert2string
//==========================================
function void ALU_Trans::do_print(uvm_printer printer);
super.do_print(printer);
$display(convert2string());
endfunction:do_print
//==========================================
function bit  ALU_Trans::do_compare(uvm_object rhs, uvm_comparer comparer);
ALU_Trans rhs_;
if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("[trans_compare]", "Error in casting");
    return 0;
end
return(super.do_compare(rhs_,comparer) && (C == rhs_.C) && (error_flag == rhs_.error_flag));  //compare the output values
endfunction:do_compare
//==========================================
function void  ALU_Trans::do_copy(uvm_object rhs);
ALU_Trans rhs_;
if(!$cast(rhs_,rhs))  `uvm_fatal("trans_copy", "Error in casting");
super.do_copy(rhs_);
A = rhs_.A;
B = rhs_.B;
rst_n = rhs_.rst_n;
ALU_en = rhs_.ALU_en;
a_op = rhs_.a_op;
b_op = rhs_.b_op;
a_en = rhs_.a_en;
b_en = rhs_.b_en;
C = rhs_.C;
error_flag = rhs_.error_flag;
endfunction:do_copy
//==========================================







