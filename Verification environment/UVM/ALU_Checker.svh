`uvm_analysis_imp_decl(_mon)
`uvm_analysis_imp_decl(_gm)
class ALU_Checker extends uvm_scoreboard;
`uvm_component_utils(ALU_Checker)
//========================================
//declare mailboxs
//========================================
uvm_analysis_imp_gm #(ALU_Trans, ALU_Checker) g_model2chk;
uvm_analysis_imp_mon #(ALU_Trans, ALU_Checker) mon_out2chk;
//======================================
//declare constructor
//======================================
ALU_Trans g_model_trans,out_trans;
//======================================
//declare queue for the transactions
//======================================

ALU_Trans gm_q[$],mon_q[$];
//======================================
//declare constructor
//======================================
function new (string name = "ALU_Checker",uvm_component parent =null);
super.new(name,parent);
mon_out2chk =new("mon_out2chk",this);
g_model2chk =new("g_model2chk",this);
g_model_trans = ALU_Trans::type_id::create("g_model_trans");
out_trans     = ALU_Trans::type_id::create("out_trans");
endfunction:new
//======================================
//declare extern methods
//======================================
/*TODO:need to add objection and drop objection in each phase to receive the transactions 
from the monitor and the golden model on reset phase "phase ready to end"*/
extern virtual function void write_mon(ALU_Trans m_out_pkt);
extern virtual function void write_gm(ALU_Trans gm_pkt);
extern virtual function void check_phase(uvm_phase phase);
endclass:ALU_Checker
//======================================
//extern methods
//======================================
function void ALU_Checker::write_mon(ALU_Trans m_out_pkt);
out_trans = m_out_pkt;
mon_q.push_back(out_trans);
`uvm_info(get_type_name(),$sformatf("[Checker write_mon ]Checker task is started--------------------------------------"),UVM_NONE);
endfunction:write_mon
//======================================
function void ALU_Checker::write_gm(ALU_Trans gm_pkt);
g_model_trans = gm_pkt;
gm_q.push_back(g_model_trans);
`uvm_info(get_type_name(),$sformatf("[Checker write_gm ]Checker task is started--------------------------------------"),UVM_NONE);
endfunction:write_gm
//======================================
function void ALU_Checker::check_phase(uvm_phase phase);
int i = 0;
super.check_phase(phase);
phase.raise_objection(this);
`uvm_info(get_type_name(),$sformatf("[Checker phase]Checker task is started--------------------------------------"),UVM_NONE);
forever begin
if(mon_q.size() && gm_q.size())begin 
    if(mon_q[0].compare(gm_q[0]))begin
        `uvm_info(get_type_name(),$sformatf("[Checker phase]Transaction NO <%0d> Output is CORRECT Output_PKT.C =%0d,Model_PKT.C=%0d",i,mon_q[0].C,gm_q[0].C),UVM_MEDIUM);
        mon_q.delete(0);
        gm_q.delete(0);
    end
    else begin
        `uvm_error(get_type_name(),$sformatf("[Checker phase]****Transaction NO <%0d> Output is INCORRECT Output_PKT.C =%0d,Model_PKT.C=%0d*****",i,mon_q[0].C,gm_q[0].C));
        mon_q.delete(0);
        gm_q.delete(0);
    end
end
else begin
    break;
end
i++;
end
`uvm_info(get_type_name(),$sformatf("****Checker phase is finished****"),UVM_NONE);
phase.drop_objection(this);
endfunction:check_phase
