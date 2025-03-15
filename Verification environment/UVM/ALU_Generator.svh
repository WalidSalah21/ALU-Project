class ALU_Sequencer extends uvm_sequencer#(ALU_Trans);
`uvm_component_utils(ALU_Sequencer)
//================================================================
//Description: declare consturctor
//================================================================
function new (string name="ALU_Generator",uvm_component parent=null);
super.new(name,parent);
endfunction:new
//================================================================
endclass:ALU_Sequencer