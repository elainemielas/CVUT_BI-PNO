library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity TB_KITT is
end entity TB_KITT;

architecture TB_KITT_BODY of TB_KITT is

	component KITT
		port (
		   CLK   : in std_logic;
			INPUT : in std_logic_vector (7 downto 0);
			BTN0  : in std_logic; 
			BTN1  : in std_logic; 
			BTN2  : in std_logic; 
			BTN3  : in std_logic;
			SEG   : out  STD_LOGIC_VECTOR (6 downto 0);    -- 7 segmentu displeje
			DP_K  : out  STD_LOGIC;                        -- desetinna tecka
			DIG   : out  STD_LOGIC_VECTOR (3 downto 0)     -- 4 cifry displeje
		);
	end component; 
	
	
	signal T_INPUT : std_logic_vector (7 downto 0);
	signal T_BTN0, T_BTN1, T_BTN2, T_BTN3, T_DP_K, T_CLK : std_logic;
	signal T_SEG : std_logic_vector (6 downto 0);
	signal T_DIG : std_logic_vector (3 downto 0);

begin

	UUT : KITT port map (INPUT => T_INPUT, BTN0 => T_BTN0, BTN1 => T_BTN1, BTN2 => T_BTN2, BTN3 => T_BTN3, 
							   SEG => T_SEG, DP_K => T_DP_K, DIG => T_DIG, CLK => T_CLK);
	
	
	NECO : process
	begin
		T_CLK <= '0';
		wait for 10 ns;
		T_CLK <= '1';
		wait for 10 ns;
	end process;
		
	
	
	TEST : process
	begin
		T_INPUT <= (others => '0');
		T_BTN0 <= '1';
		T_BTN1 <= '0'; 
		T_BTN2 <= '0'; 
		T_BTN3 <= '0'; 
		wait for 100 ns;
		T_BTN0 <= '0';
		wait for 100 ns;
		
		for I in 1 to 4 loop
			T_INPUT <= conv_std_logic_vector(-I*8,8);
			T_BTN1 <= '1';
			wait for 100 ns;
			T_BTN1 <= '0';
			wait for 100 ns;
		end loop;
		
		wait;
	end process;
	
end architecture;