class ALU_Monitor_Output extends uvm_monitor;
`uvm_component_utils(ALU_Monitor_Output)
//======================================
//declare interface
//======================================
virtual ALU_Interface intf;
//======================================
//declare mailboxs
//======================================
uvm_analysis_port #(ALU_Trans) mon_out_port;
//======================================
//class properties
//======================================
ALU_Trans trans;
bit [1:0] counter = 0;  //this counter to solve the problem of the multiple consequitive transactions with ALU_en = 1 [env problem for sampling the correctdata] 
//======================================
//declare constructor
//======================================
function new (string name = "ALU_Monitor_Output",uvm_component parent =null);
super.new(name,parent);
mon_out_port = new("mon_out_port",this);
endfunction:new
//======================================
//external methods 
//======================================
extern virtual function void build_phase(uvm_phase phase);
extern virtual task reset_phase (uvm_phase phase);
extern virtual task main_phase (uvm_phase phase);
endclass:ALU_Monitor_Output

//======================================
//class methods
//======================================
function void ALU_Monitor_Output::build_phase(uvm_phase phase);
super.build_phase(phase);
//=======================================================
if(!uvm_config_db#(virtual ALU_Interface)::get(this,"","agent2mon_out",intf))
`uvm_fatal(get_full_name(),"Error on interface connectivity");
endfunction:build_phase

task  ALU_Monitor_Output::reset_phase(uvm_phase phase);
int trans_ID =0;
super.reset_phase(phase);
trans =ALU_Trans::type_id::create("trans");
   forever begin
   `uvm_info(get_type_name(),$sformatf("wait reset transaction form DUT"),UVM_NONE);
   @(posedge intf.clk iff (!intf.rst_n))
   `uvm_info(get_type_name(),$sformatf("Get reset transaction form DUT"),UVM_LOW);
   trans.C = intf.C;
   trans.error_flag = intf.error_flag;
   mon_out_port.write(trans);
   `uvm_info(get_type_name(),$sformatf("send reset transaction to coverage collector and checker with trans_ID -->[%0d]",trans_ID),UVM_LOW);
   trans_ID++;
   end
`uvm_info(get_type_name(),$sformatf("***finish send reset transaction to coverage collector and checker***"),UVM_NONE);
endtask:reset_phase

task ALU_Monitor_Output::main_phase(uvm_phase phase);
int trans_ID =0;
trans =ALU_Trans::type_id::create("trans");
super.main_phase(phase);
		forever begin
      `uvm_info(get_type_name(),$sformatf("wait data transaction form DUT with trans_ID -->[%0d]",trans_ID),UVM_LOW);
		@(posedge intf.clk iff (intf.ALU_en || !intf.rst_n  || (counter == 2))) 
		//using the fork join to solve the problem of the multiple consequitive transactions with ALU_en = 1 [env problem for sampling the correctdata]
		fork
			begin
				if(intf.ALU_en && intf.rst_n) begin
				#0	counter += 1;
				end
			    else if (!intf.rst_n) counter = 0; 
			end
			begin
				if (counter == 2 || !intf.rst_n)begin
                     trans =ALU_Trans::type_id::create("trans");
							trans.C = intf.C;
							trans.error_flag = intf.error_flag;
							mon_out_port.write(trans);
                     `uvm_info(get_type_name(),$sformatf("send data to checker and coverage collector with trans_ID -->[%0d]",trans_ID),UVM_LOW);
							trans_ID++;
							if(!intf.rst_n) counter = 0;
							else counter -= 1;
						 
				end
				else if(intf.ALU_en)begin
					#0
					if (counter == 1)begin
							@(posedge intf.clk);
								if (!intf.rst_n) begin
                           trans =ALU_Trans::type_id::create("trans");
									trans.C = intf.C;
									trans.error_flag = intf.error_flag;
		      					mon_out_port.write(trans);
                           `uvm_info(get_type_name(),$sformatf("send data to checker and coverage collector with trans_ID counter == 2-->[%0d]",trans_ID),UVM_LOW);
									trans_ID++;
									counter = 0;
								end
								else if(intf.ALU_en) counter += 1;
								else counter -= 1;
                        trans =ALU_Trans::type_id::create("trans");
								trans.C = intf.C;
								trans.error_flag = intf.error_flag;
		      				mon_out_port.write(trans);
                        `uvm_info(get_type_name(),$sformatf("send data to checker and coverage collector with trans_ID counter == 2-->[%0d]",trans_ID),UVM_LOW);
								trans_ID++; 
					end
				      
				end
			end
		join
	 end 
`uvm_info(get_type_name(),$sformatf("***finish send data transaction to coverage collector and checker***"),UVM_NONE);
endtask:main_phase
