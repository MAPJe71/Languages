entity ent1 is
end entity ent1;

architecture rtl of ent1 is
	component compo1 is
	end component compo1;

    component reset_controller is
	end component reset_controller;

begin

	compo1_inst : compo1

	rst_controller_inst : component reset_controller


proc1: process (reset_reset_n, clk_clk)
    begin
    end process;

    led_block: block
    begin
    end block;

doing_so_inst_4c : entity work.doing_so port map (
    );

end architecture rtl; -- of ent1
