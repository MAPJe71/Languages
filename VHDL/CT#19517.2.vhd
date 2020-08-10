doing_so_inst_1:doing_so
    generic MAP(
        CLK_FREQ        => 10,
        SCL_FREQ        => 4
    )
    PORT map(
        Reset_s         => Reset_s,
        Clk_4MHz        => Clk_4MHz,
        Signal_in       => sig_internal,
        Signal_out      => sig_out,
        Signal_open     => open
    );

doing_so_inst_2: doing_so                   -- this comments this inst
    PORT map(                               -- this comments this port map
        Reset_s         => Reset_s,
        Clk_4MHz        => Clk_100MHz,
        Signal_in       => sig_internal,
        Signal_out      => open,
        Signal_open     => open             -- this comments this port
    );

doing_so_inst_3: doing_so generic map(72, 10) port map(Reset_s, Clk_120MHz, sig_internal, sig_out2, open);

doing_so_inst_4 : entity work.doing_so port map (
        Reset_s         => Reset_s,
        Clk_4MHz        => Clk_100MHz,
        Signal_in       => sig_internal,
        Signal_out      => open,
        Signal_open     => open                 -- this comments this port
    );

-- additional

doing_so_inst_1b:doing_so                           -- comment
    generic MAP(                                    -- comment
        CLK_FREQ        => 10,                      -- comment
        SCL_FREQ        => 4                        -- comment
    )                                               -- comment
    PORT map(                                       -- comment
        Reset_s         => Reset_s,                 -- comment
        Clk_4MHz        => Clk_4MHz,                -- comment
        Signal_in       => sig_internal,            -- comment
        Signal_out      => sig_out,                 -- comment
        Signal_open     => open                     -- comment
    );

doing_so_inst_1d
:
doing_so
    generic MAP
    (
        CLK_FREQ
        =>
        10
    ,
        SCL_FREQ
        =>
        4
    )
    PORT map
    (
        Reset_s
        =>
        Reset_s
    ,
        Clk_4MHz
        =>
        Clk_4MHz
    ,
        Signal_in
        =>
        sig_internal
    ,
        Signal_out
        =>
        sig_out
    ,
        Signal_open
        =>
        open
    )
    ;

doing_so_inst_1e                                    -- comment
:                                                   -- comment
doing_so                                            -- comment
    generic MAP                                     -- comment
    (                                               -- comment
        CLK_FREQ                                    -- comment
        =>                                          -- comment
        10                                          -- comment
    ,                                               -- comment
        SCL_FREQ                                    -- comment
        =>                                          -- comment
        4                                           -- comment
    )                                               -- comment
    PORT map                                        -- comment
    (                                               -- comment
        Reset_s                                     -- comment
        =>                                          -- comment
        Reset_s                                     -- comment
    ,                                               -- comment
        Clk_4MHz                                    -- comment
        =>                                          -- comment
        Clk_4MHz                                    -- comment
    ,                                               -- comment
        Signal_in                                   -- comment
        =>                                          -- comment
        sig_internal                                -- comment
    ,                                               -- comment
        Signal_out                                  -- comment
        =>                                          -- comment
        sig_out                                     -- comment
    ,                                               -- comment
        Signal_open                                 -- comment
        =>                                          -- comment
        open                                        -- comment
    )                                               -- comment
    ;                                               -- comment

doing_so_inst_1f : doing_so                         -- comment
    generic MAP                                     -- comment
    (                                               -- comment
        CLK_FREQ    => 10                           -- comment
    ,                                               -- comment
        SCL_FREQ    => 4                            -- comment
    )                                               -- comment
    PORT map                                        -- comment
    (                                               -- comment
        Reset_s     => Reset_s                      -- comment
    ,                                               -- comment
        Clk_4MHz    => Clk_4MHz                     -- comment
    ,                                               -- comment
        Signal_in   => sig_internal                 -- comment
    ,                                               -- comment
        Signal_out  => sig_out                      -- comment
    ,                                               -- comment
        Signal_open => open                         -- comment
    )                                               -- comment
    ;                                               -- comment

doing_so_inst_2b : doing_so                         -- comment
    PORT map(                                       -- comment
        Reset_s         => Reset_s,                 -- comment
        Clk_4MHz        => Clk_100MHz,              -- comment
        Signal_in       => sig_internal,            -- comment
        Signal_out      => open,                    -- comment
        Signal_open     => open                     -- comment
    );

doing_so_inst_2c : doing_so
    PORT map (
        Reset_s         => Reset_s,
        Clk_4MHz        => Clk_100MHz,
        Signal_in       => sig_internal,
        Signal_out      => open,
        Signal_open     => open
    );

doing_so_inst_4b : entity work.doing_so port map (  -- comment
        Reset_s         => Reset_s,                 -- comment
        Clk_4MHz        => Clk_100MHz,              -- comment
        Signal_in       => sig_internal,            -- comment
        Signal_out      => open,                    -- comment
        Signal_open     => open                     -- comment
    );

doing_so_inst_4c : entity work.doing_so port map (
        Reset_s         => Reset_s,
        Clk_4MHz        => Clk_100MHz,
        Signal_in       => sig_internal,
        Signal_out      => open,
        Signal_open     => open
    );

