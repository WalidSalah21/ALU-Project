class ALU_Trans;
//==========================================
//declare transaction variables
//==========================================
rand  logic signed [WIDTH-1:0] A,B;
rand  logic                  rst_n;    
rand  logic                 ALU_en;
randc logic        [2:0]      a_op;
randc logic        [1:0]      b_op;
rand  logic              a_en,b_en;
logic signed [WIDTH:0]           C;
logic                   error_flag;
//==========================================
//Description: Methods
//==========================================
function void display(string component="",int trans_ID = 0);
$display("(at time %0t) trans_ID [%0d] -->In Component: [%s]-->the Values are :[RST:%0b A:%5b ,B:%5b ,ALU_en:%0d ,a_op:%0d ,b_op:%0d ,a_en:%1b ,b_en:%1b ,C:%5b,Error_Flag:%0d]"
                                                           ,$time,trans_ID,component,rst_n,A,B,ALU_en,a_op,b_op,a_en,b_en,C,error_flag);
endfunction:display

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