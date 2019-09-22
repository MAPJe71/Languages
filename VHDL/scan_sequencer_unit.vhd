------------------------------------------------------------------------------
-- Filename:          scan_sequencer_unit.vhd
-- Version:           1.00.a
-- Description:       Scan sequencer unit.
-- Date:              Gen 29 2006 (by Quadrelli Manrico)
-- VHDL-Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
-- 	active low signals:                    "*_n"
-- 	clock signals:                         "clk", "clk_div#", "clk_#x"
-- 	reset signals:                         "rst", "rst_n"
-- 	generics:                              "C_*"
-- 	user defined types:                    "*_TYPE"
-- 	state machine next state:              "*_ns"
-- 	state machine current state:           "*_cs"
-- 	combinatorial signals:                 "*_com"
-- 	pipelined or register delay signals:   "*_d#"
-- 	counter signals:                       "*cnt*"
-- 	clock enable signals:                  "*_ce"
-- 	internal version of output port:       "*_i"
-- 	device pins:                           "*_pin"
-- 	ports:                                 "- Names begin with Uppercase"
-- 	processes:                             "*_PROCESS"
-- 	component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity scan_sequencer_unit is
	port
	(
		CLK : in  std_logic;
		RST : in  std_logic;
		-- Stati interni
		STBY       : in  std_logic;
		SYNC_CLAMP : in  std_logic;
		OPER       : in  std_logic;
		SCAN       : in  std_logic;
		EOSC       : inout std_logic;  -- END_OF_SYNC_CLAMP
		-- Clock per il CCD
		PHI11 : inout std_logic;
		PHI22 : inout std_logic;
		PHIR1 : out std_logic;
		PHIR2 : out std_logic;
		PHITG : inout std_logic;
		-- Clock per l'ADC
		CLPOB    : inout std_logic;
		INPUTCLP : inout std_logic;
		SHP      : out std_logic;
		SHD      : out std_logic;
		SYSCLK   : inout std_logic;
		-- Trasmissione dati CCD
		CCD_DIN : in std_logic_vector(11 downto 0);
		CCD_RDY : out std_logic;
		CCD_DTX : out std_logic_vector(9 downto 0);
		-- Registro del Filtro
		REG_RDY : out std_logic;
		REG_DTX : out std_logic_vector(9 downto 0);
		-- BUS Interno
		DATA  : in std_logic_vector(9 downto 0);
		ADD   : in std_logic_vector(3 downto 0);
		R_W_n : in std_logic;
		STB   : in std_logic;
		-- I/O
		HV     : in std_logic_vector(3 downto 0);
		EN_12V : out std_logic;
		MR_SW  : out std_logic
	);
end entity scan_sequencer_unit;

architecture IMP of scan_sequencer_unit is
	
	signal CE_10MHz, CE_10MHz_D : std_logic;
	-- Segnal per lo Start of Scan (PHITG)
	signal SOS, ASS, SEQ_RUNNING : std_logic;
	signal START_OF_SOS, START_OF_SOS_D, END_OF_SOS, END_OF_SOS_D : std_logic;
	signal CE_SRL_EOSEQ, CE_SRL_PHITG : std_logic;
	signal CE_SRL_EOSC : std_logic;
	-- Segnali per gli Optical Black
	signal END_OF_INPUTCLP : std_logic;
	signal START_OF_OB, END_OF_OB, Q_END_OF_OB : std_logic;
	signal CE_SRL_OBSEQ : std_logic;
	-- Segnali per il ritardo del filtro e ADC
	signal CE_PXL : std_logic;
	signal START_OF_ADC_DLY, END_OF_DLY, Q_END_OF_DLY : std_logic;
	signal CE_SRL_ADC_DLY : std_logic;
	signal D_FILTER_DLY : std_logic;
	-- Segnali per il conteggio dei 5000 pixel
	signal START_OF_PXL, D_SRL_OF_PXL, CNT_DIV_25 : std_logic;
	signal CNT_X_10, Q_CNT_X_10, END_OF_PXL, Q_END_OF_PXL : std_logic;
	signal CE_SRL_DIV_25, CE_SRL_X_10_1, CE_SRL_X_10_2 : std_logic;
	signal RDY_BEFORE_DLY, RDY_BEFORE_DLY_MEM : std_logic;
	-- Segnali per i registri interni
	signal REG_FIF_RDY, REG_GEN_RDY : std_logic;
	signal REG_FIF_DTX, REG_GEN_DTX : std_logic_vector(9 downto 0);
	
	component SRL16E is
		generic
		(
			INIT : bit_vector := X"0000"
		);
		port
		(
			Q   : out std_logic;
			A0  : in std_logic;
			A1  : in std_logic;
			A2  : in std_logic;
			A3  : in std_logic;
			CE  : in std_logic;
			Clk : in std_logic;
			D   : in std_logic
		);
	end component SRL16E;
	
	component ccd_data_filter_unit is
		port
		(
			CLK      : in std_logic;
			RST      : in std_logic;
			CCD_DIN  : in std_logic_vector(11 downto 0);
			CE_10MHz : in std_logic;
			PXL_CLK  : in std_logic;
			DATA     : in std_logic_vector(9 downto 0);
			ADD      : in std_logic_vector(3 downto 0);
			R_W_n    : in std_logic;
			STB      : in std_logic;          
			CCD_DOUT : out std_logic_vector(9 downto 0);
			RDY      : out std_logic;
			REG_DOUT : out std_logic_vector(9 downto 0)
		);
	end component;
	
	component general_register is
		port
		(
			CLK      : in std_logic;
			RST      : in std_logic;
			HV       : in std_logic_vector(3 downto 0);
			STBY     : in std_logic;
			DATA     : in std_logic_vector(9 downto 0);
			ADD      : in std_logic_vector(3 downto 0);
			R_W_n    : in std_logic;
			STB      : in std_logic;    
			RDY      : inout std_logic;      
			EN_12V   : out std_logic;
			MR_SW    : out std_logic;
			ASS      : out std_logic;
			REG_DOUT : out std_logic_vector(9 downto 0)
		);
	end component;
	
begin
	
	-- Clock enable a 10MHz
	CE_10MHz_P : process (CLK)
	begin
		if (CLK'event and CLK = '0') then
			if (RST = '1') then
				CE_10MHz <= '1';
			else
				CE_10MHz <= (not CE_10MHz);
			end if;
		end if;
	end process CE_10MHz_P;
	
	-- Clock enable a 10MHz ritardato
	CE_10MHz_D_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			CE_10MHz_D <= CE_10MHz;
		end if;
	end process CE_10MHz_D_P;

	-- Clock enable a 10MHz ritardato
	CE_10MHz_D_P (process)
	begin
		if (CLK'event and CLK = '1') then
			CE_10MHz_D <= CE_10MHz;
		end if;
	end process CE_10MHz_D_P;
	
	----------------------------------------------------------------------------
	-- START OF SCAN
	----------------------------------------------------------------------------
	-- Segnale di SOS: esce quando arriva uno SCAN da E96 o sono in SYNC_CLAMP
	-- oppure sono in OPER ed ho ASS attivo.
	SOS <= SYNC_CLAMP or SCAN or (OPER and ASS);
	
	-- Conteggio del numero di SOS durante SYNC_CLAMP
	CE_SRL_EOSC <= (Q_END_OF_PXL or EOSC);
	
	Generator_END_OF_SYNC_CLAMP_I : SRL16E 
	generic map
	(
		INIT => X"0400"
	)
	port map
	(
		Q   => EOSC,
		A0  => '0',
		A1  => '1',
		A2  => '0',
		A3  => '1',
		CE  => CE_SRL_EOSC,
		Clk => CLK,
		D   => EOSC
	);
	
	-- Segnale di SEQ_RUNNING: identifica che lo scan del CCD è in corso
	SEQ_RUNNING_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') or (SOS = '0') or
				((SYNC_CLAMP = '1') and (Q_END_OF_PXL = '1')) or -- per SYNC_CLAMP
				((OPER = '1') and (ASS = '1') and (Q_END_OF_PXL = '1')) then -- per ASS
				SEQ_RUNNING <= '0';
			elsif (START_OF_SOS = '1') then
				SEQ_RUNNING <= '1';
			end if;
		end if;
	end process SEQ_RUNNING_P;
	
	----------------------------------------------------------------------------
	-- START SEQUENZA SEGNALI PER CCD
	----------------------------------------------------------------------------
	-- Processo per l'identificazione dell'istante in cui deve essere avviata
	-- la procedura di scansione del CCD in seguito alla ricezione di uno SOS
	START_OF_SOS_P : process (CLK)
	variable MY_VAR : std_logic_vector(1 downto 0);
	begin
		if (CLK'event and CLK = '0') then
			if (RST = '1') then
				START_OF_SOS <= '0';
			elsif (CE_10MHz = '1') then
				MY_VAR := SOS & START_OF_SOS;
				case MY_VAR is
					when "00" =>
						START_OF_SOS <= '0';
					when "10" =>
						if (SYSCLK = '0') and (SEQ_RUNNING = '0') then 
						--(PHI11 = '0') and (PHI22 = '0') and (SEQ_RUNNING = '0') then
							START_OF_SOS <= '1';
						else
							START_OF_SOS <= '0';
						end if;
					when "11" =>
						if (END_OF_SOS_D = '1') then
							START_OF_SOS <= '0';
						else
							START_OF_SOS <= '1';
						end if;
					when others =>
						START_OF_SOS <= '0';
				end case;
			end if;
		end if;
	end process START_OF_SOS_P;
	
	START_OF_SOS_D_P : process (CLK)
	begin
		if (CLK'event and CLK = '0') then
			if (CE_10MHz = '1') then
				START_OF_SOS_D <= START_OF_SOS;
			end if;
		end if;
	end process START_OF_SOS_D_P;
	
	-- Fine sequenza per la generazione del PHITG per il CCD
	CE_SRL_EOSEQ <= START_OF_SOS and (not CE_10MHz);
	
	Generator_END_OF_SOS_I : SRL16E 
	generic map
	(
		INIT => X"0001"
	)
	port map
	(
		Q   => END_OF_SOS,
		A0  => '1',
		A1  => '1',
		A2  => '1',
		A3  => '1',
		CE  => CE_SRL_EOSEQ,
		Clk => CLK,
		D   => END_OF_SOS
	);
	
	-- Ritardo di un colpo di clock a 10MHz
	END_OF_SOS_D_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				END_OF_SOS_D <= '0';
			elsif (CE_10MHz = '0') then
				END_OF_SOS_D <= END_OF_SOS;
			end if;
		end if;
	end process END_OF_SOS_D_P;
	
	----------------------------------------------------------------------------
	-- CLOCK ENABLE DEL PIXEL
	----------------------------------------------------------------------------
	CE_PXL <= (not CE_10MHz) and CE_10MHz_D and (PHI11) and (PHI22);
	
	----------------------------------------------------------------------------
	-- SEQUENZA DI OPTICAL BLACK PIXELS E CLAMP DUMMY
	----------------------------------------------------------------------------
	START_OF_OB_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				START_OF_OB <= '0';
			elsif (CE_10MHz = '0') then
				if (END_OF_SOS_D = '1') and (START_OF_OB = '0') then
					START_OF_OB <= '1';
				elsif (Q_END_OF_OB = '0') and (START_OF_OB = '1') then
					START_OF_OB <= '1';
				else
					START_OF_OB <= '0';
				end if;
			end if;
		end if;
	end process START_OF_OB_P;		
	
	CE_SRL_OBSEQ <= CE_PXL and START_OF_OB;
	
	Generator_DELAY_OB_I : SRL16E
	generic map
	(
		INIT => X"0001"
	)
	port map
	(
		Q   => END_OF_OB,
		A0  => '1',
		A1  => '1',
		A2  => '1',
		A3  => '1',
		CE  => CE_SRL_OBSEQ,
		Clk => CLK,
		D   => END_OF_OB
	);
	
	-- Ritardo di un colpo di clock a 5MHz
	Q_END_OF_OB_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') or (START_OF_OB = '0') then
				Q_END_OF_OB <= '0';
			elsif (CE_SRL_OBSEQ = '1') then
				Q_END_OF_OB <= END_OF_OB;
			end if;
		end if;
	end process Q_END_OF_OB_P;
	
	----------------------------------------------------------------------------
	-- RITARDO PER TENER CONTO DELLA PIPELINE DELL'ADC
	----------------------------------------------------------------------------
	START_OF_ADC_DLY <= END_OF_OB;
	CE_SRL_ADC_DLY <= CE_PXL and (not Q_END_OF_DLY);
	
	Generator_ADC_DLY_I : SRL16E
	generic map
	(
		INIT => X"0000"
	)
	port map
	(
		Q   => END_OF_DLY,
		A0  => '1',
		A1  => '0',
		A2  => '0',
		A3  => '1',
		CE  => CE_SRL_ADC_DLY,
		Clk => CLK,
		D   => START_OF_ADC_DLY
	);
	
	Q_END_OF_DLY_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (SOS = '0') or
				((SYNC_CLAMP = '1') and (Q_END_OF_PXL = '1')) or -- per SYNC_CLAMP 
				((OPER = '1') and (ASS = '1') and (Q_END_OF_PXL = '1')) then -- per ASS
				Q_END_OF_DLY <= '0';
			elsif (CE_SRL_ADC_DLY = '1') then
				Q_END_OF_DLY <= END_OF_DLY;
			end if;
		end if;
	end process Q_END_OF_DLY_P;
	
	----------------------------------------------------------------------------
	-- SEQUENZA DI 5000 PIXELS
	----------------------------------------------------------------------------	
	START_OF_PXL <= END_OF_DLY or (CNT_DIV_25 and (not END_OF_PXL)) or
		(CNT_DIV_25 and (not CNT_X_10) and (not END_OF_PXL)) or
		(CNT_DIV_25 and (not CNT_X_10) and END_OF_PXL); 
	
	CE_SRL_DIV_25 <= CE_PXL and (not Q_END_OF_PXL); 
	
	Generator_DIV_25_1_I : SRL16E
	generic map
	(
		INIT => X"0000"
	)
	port map
	(
		Q   => D_SRL_OF_PXL,
		A0  => '1',
		A1  => '1',
		A2  => '1',
		A3  => '1',
		CE  => CE_SRL_DIV_25,
		Clk => CLK,
		D   => START_OF_PXL
	);
	
	Generator_DIV_25_2_I : SRL16E
	generic map
	(
		INIT => X"0000"
	)
	port map
	(
		Q   => CNT_DIV_25,
		A0  => '0',
		A1  => '0',
		A2  => '0',
		A3  => '1',
		CE  => CE_SRL_DIV_25,
		Clk => CLK,
		D   => D_SRL_OF_PXL
	);
	
	CE_SRL_X_10_1 <= CE_SRL_DIV_25 and CNT_DIV_25;
	
	Generator_X_10_1_I : SRL16E
	generic map
	(
		INIT => X"0001"
	)
	port map
	(
		Q   => CNT_X_10,
		A0  => '1',
		A1  => '0',
		A2  => '0',
		A3  => '1',
		CE  => CE_SRL_X_10_1,
		Clk => CLK,
		D   => CNT_X_10
	);
	
	CNT_X_10_1_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (CE_SRL_DIV_25 = '1') then
				Q_CNT_X_10 <= CNT_X_10 and CNT_DIV_25;
			end if;
		end if;
	end process CNT_X_10_1_P;
	
	CE_SRL_X_10_2 <= CE_SRL_DIV_25 and Q_CNT_X_10;
	
	Generator_X_10_2_I : SRL16E
	generic map
	(
		INIT => X"0001"
	)
	port map
	(
		Q   => END_OF_PXL,
		A0  => '1',
		A1  => '0',
		A2  => '0',
		A3  => '1',
		CE  => CE_SRL_X_10_2,
		Clk => CLK,
		D   => END_OF_PXL
	);
	
	CNT_X_10_2_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (SOS = '0') or
				((SYNC_CLAMP = '1') and (Q_END_OF_PXL = '1')) or -- per SYNC_CLAMP
				((OPER = '1') and (ASS = '1') and (Q_END_OF_PXL = '1')) then -- per ASS
				Q_END_OF_PXL <= '0';
			elsif (CE_SRL_DIV_25 = '1') then
				Q_END_OF_PXL <= (END_OF_PXL and Q_CNT_X_10) or Q_END_OF_PXL;
			end if;
		end if;
	end process CNT_X_10_2_P;

	----------------------------------------------------------------------------
	-- RITARDO PER TENER CONTO DELLA PIPELINE DEL FILTRO
	----------------------------------------------------------------------------
	-- Ready per la trasmissione dei dati all'E96. Quando va a 1 devo inviare i
	-- due FLAG e poi i dati. Quando torna a zero devo inviare i due FLAG.
	RDY_BEFORE_DLY_MEM_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				RDY_BEFORE_DLY_MEM <= '0';
			elsif (CE_PXL = '1') then
				if (CNT_DIV_25 = '1') and
				   (CNT_X_10 = '1') and (END_OF_PXL = '1') then
					RDY_BEFORE_DLY_MEM <= '0';
				else
					RDY_BEFORE_DLY_MEM <= RDY_BEFORE_DLY_MEM or END_OF_DLY;
				end if;
			end if;
		end if;
	end process RDY_BEFORE_DLY_MEM_P;
	
	RDY_BEFORE_DLY <= RDY_BEFORE_DLY_MEM or END_OF_DLY;
	
	D_FILTER_DLY <= RDY_BEFORE_DLY and 
		(not SYNC_CLAMP) and -- per SYNC_CLAMP
		(not ASS) and (not OPER);  -- per ASS
	
	-- Gestendo i Bit A0-A3 si imposta il ritardo del filtro di Butterworth
	Generator_FILTER_DLY_I : SRL16E
	generic map
	(
		INIT => X"0000"
	)
	port map
	(
		Q   => CCD_RDY,
		A0  => '1',
		A1  => '0',
		A2  => '0',
		A3  => '0',
		CE  => CE_PXL,
		Clk => CLK,
		D   => D_FILTER_DLY
	);
	
	----------------------------------------------------------------------------
	-- CLOCK PER IL CCD
	----------------------------------------------------------------------------
	-- Generazione del PHITG
	CE_SRL_PHITG <= START_OF_SOS_D and (not CE_10MHz);
	
	Generator_PHITG_I : SRL16E
	generic map
	(
		INIT => X"7FFE"
	)
	port map
	(
		Q   => PHITG,
		A0  => '1',
		A1  => '1',
		A2  => '1',
		A3  => '1',
		CE  => CE_SRL_PHITG,
		Clk => CLK,
		D   => PHITG
	);
	
	-- Generazione del PHI11
	PHI11_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				PHI11 <= '0';
			elsif (CE_10MHz = '0') and (STBY = '0') and (START_OF_SOS_D = '0') then
				PHI11 <= not PHI11;
			end if;
		end if;
	end process PHI11_P;
	
	-- Generazione del PHI22
	PHI22_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				PHI22 <= '0';
			elsif (CE_10MHz = '0') and (STBY = '0') and (START_OF_SOS = '0') then
				PHI22 <= not PHI22;
			end if;
		end if;
	end process PHI22_P;
	
	-- Generazione del PHIR1
	PHIR1_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				PHIR1 <= '0';
			elsif (CE_10MHz = '0') and (CE_10MHz_D = '1') and (SYSCLK = '1') then
				PHIR1 <= '1';
			elsif (CE_10MHz = '1') and (CE_10MHz_D = '0') and (SYSCLK = '0') then
				PHIR1 <= '0';
			end if;
		end if;
	end process PHIR1_P;
	
	-- Generazione del PHIR2
	PHIR2_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				PHIR2 <= '0';
			elsif (CE_10MHz = '0') and (CE_10MHz_D = '1') and (SYSCLK = '1') then
				PHIR2 <= '1';
			elsif (CE_10MHz = '1') and (CE_10MHz_D = '0') and (SYSCLK = '0') then
				PHIR2 <= '0';
			end if;
		end if;
	end process PHIR2_P;	
	
	----------------------------------------------------------------------------
	-- CLOCK PER L'ADC
	----------------------------------------------------------------------------
	Generator_CLPOB_I : SRL16E
	generic map
	(
		INIT => X"0FFE"
	)
	port map
	(
		Q   => CLPOB,
		A0  => '1',
		A1  => '1',
		A2  => '1',
		A3  => '1',
		CE  => CE_SRL_OBSEQ,
		Clk => CLK,
		D   => CLPOB
	);
	
	Generator_END_OF_INPUTCLP_I : SRL16E
	generic map
	(
		INIT => X"1000"
	)
	port map
	(
		Q   => END_OF_INPUTCLP,
		A0  => '1',
		A1  => '1',
		A2  => '1',
		A3  => '1',
		CE  => CE_SRL_OBSEQ,
		Clk => CLK,
		D   => END_OF_INPUTCLP
	);
	
	INPUTCLP_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				INPUTCLP <= '0';
			elsif (CE_10MHz = '0') then
				if (END_OF_SOS = '1') then
					INPUTCLP <= '1';
				elsif (INPUTCLP = '1') then
					if (CE_PXL = '1') and (END_OF_INPUTCLP = '1') then
						INPUTCLP <= '0';
					else
						INPUTCLP <= '1';
					end if;
				end if;
			end if;
		end if;
	end process INPUTCLP_P;
	
	-- Generazione del SYSCLK
	SYSCLK_P : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (RST = '1') then
				SYSCLK <= '0';
			elsif (CE_10MHz = '0') and (STBY = '0') then
				SYSCLK <= not SYSCLK;
			end if;
		end if;
	end process SYSCLK_P;
	
	-- Generazione di SHP
	SHP_P : process (CLK)
	begin
		if (CLK'event and CLK = '0') then
			if (RST = '1') or (STBY = '1') then
				SHP <= '1';
			elsif (CE_10MHz = '0') and (CE_10MHz_D = '0') and (SYSCLK = '1') then
				SHP <= '0';
			elsif (CE_10MHz = '1') and (CE_10MHz_D = '1') and (SYSCLK = '1') then
				SHP <= '1';
			end if;
		end if;
	end process SHP_P;
	
	-- Generazione di SHD
	SHD_P : process (CLK)
	begin
		if (CLK'event and CLK = '0') then
			if (RST = '1') or (STBY = '1') then
				SHD <= '1';
			elsif (CE_10MHz = '0') and (CE_10MHz_D = '0') and (SYSCLK = '0') then
				SHD <= '0';
			elsif (CE_10MHz = '1') and (CE_10MHz_D = '1') and (SYSCLK = '0') then
				SHD <= '1';
			end if;
		end if;
	end process SHD_P;
	
	----------------------------------------------------------------------------
	-- Filtro per dati CCD
	----------------------------------------------------------------------------
	ccd_data_filter_unit_I: ccd_data_filter_unit
	port map
	(
		CLK      => CLK,
		RST      => RST,
		CCD_DIN  => CCD_DIN,
		CE_10MHz => CE_10MHz,
		PXL_CLK  => SYSCLK,
		CCD_DOUT => CCD_DTX,
		DATA     => DATA,
		ADD      => ADD,
		R_W_n    => R_W_n,
		STB      => STB,
		RDY      => REG_FIF_RDY,
		REG_DOUT => REG_FIF_DTX
	);
	
	----------------------------------------------------------------------------
	-- Altri registri interni
	----------------------------------------------------------------------------
	general_register_I: general_register
	port map
	(
		CLK      => CLK,
		RST      => RST,
		HV       => HV,
		STBY     => STBY,
		EN_12V   => EN_12V,
		MR_SW    => MR_SW,
		ASS      => ASS,
		DATA     => DATA,
		ADD      => ADD,
		R_W_n    => R_W_n,
		STB      => STB,
		RDY      => REG_GEN_RDY,
		REG_DOUT => REG_GEN_DTX
	);
	
	-- Selettore del registro da leggere
	mux_rdy_P : process (REG_FIF_RDY, REG_GEN_RDY, REG_GEN_DTX, REG_FIF_DTX)
	variable MY_VAR : std_logic_vector(1 downto 0);
	begin
		MY_VAR := REG_FIF_RDY & REG_GEN_RDY;
  	case (MY_VAR) is
			when "01" =>
				REG_RDY <= REG_GEN_RDY;
				REG_DTX <= REG_GEN_DTX;
			when "10" =>
				REG_RDY <= REG_FIF_RDY;
				REG_DTX <= REG_FIF_DTX;
			when others =>
				REG_RDY <= '0';
				REG_DTX <= (others => '0');
		end case;
	end process mux_rdy_P;
	
end IMP