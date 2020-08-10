-- https://community.notepad-plus-plus.org/topic/19517/add-vhdl-to-functionlist-xml-and-interpret-port-map-as-class

rst_controller_inst:rst_controller 
port map (
	reset_in0      => reset_reset_n_ports_inv,
	clk            => clk_clk,
	reset_out      => rst_controller_reset_out_reset 
);


rst_controller_inst2:rst_controller2
port map (
	reset_in0      => reset_reset_n_ports_inv,
	clk            => clk_clk,
	clk2           => clk_clk2,
	reset_out      => rst_controller_reset_out_reset 
);
