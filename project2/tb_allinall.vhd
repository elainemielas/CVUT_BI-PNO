library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity TB_ALLINALL is
end entity TB_ALLINALL;

architecture TB_ALLINALL_BODY of TB_ALLINALL is

	component ALLINALL is
		port (
				PS2_DATA  : in  std_logic;     -- serial PS2 input
				PS2_CLK   : in  std_logic;     -- serial PS2 clock
				CLK       : in  std_logic;     -- standard 50MHz clock
				RESET     : in  std_logic;
				JCHYBA    : out std_logic;    -- detekovano s 1 chybou
				SHODA     : out std_logic     -- detekovana uplna shoda
			);
	end component;
	
	
	signal T_PS2_DATA, T_PS2_CLK, T_CLK, T_RESET, T_JCHYBA, T_SHODA : std_logic;
	signal TS1, TS2, TS3, TS4 : std_logic_vector(7 downto 0); -- testove data

begin

	UUT : ALLINALL port map (PS2_DATA => T_PS2_DATA, PS2_CLK => T_PS2_CLK, RESET => T_RESET, 
									 JCHYBA => T_JCHYBA, SHODA => T_SHODA, CLK => T_CLK);
	
	-- hodiny
	HOD : process
	begin
		T_CLK <= '0';
		wait for 10 ns;
		T_CLK <= '1';
		wait for 10 ns;
	end process;
		
	RES : process
	begin
	T_RESET <= '1';
	wait for 100 ns;
	T_RESET <= '0';
	wait;
	end process;

	
	TESTOVANI : process
		procedure TEST (TS: in std_logic_vector(7 downto 0)) is
			begin
			T_PS2_DATA <= '1';
			T_PS2_CLK <= '1';
			--T_RESET <= '1';
			--wait for 100 ns;
			--T_RESET <= '0';
			wait for 20 us;
			-- pocatecni bit
			T_PS2_DATA <= '0';
			wait for 10 us;
			T_PS2_CLK <= '0';
			wait for 40 us;
			T_PS2_CLK <= '1';
			wait for 30 us;
			-- data bity
			for I in 0 to 7 loop
				T_PS2_DATA <= TS(I);
				wait for 10 us;
				T_PS2_CLK <= '0';
				wait for 40 us;
				T_PS2_CLK <= '1';
				wait for 30 us;
			end loop;
			-- paritni bit
			T_PS2_DATA <= '1';
			wait for 10 us;
			T_PS2_CLK <= '0';
			wait for 40 us;
			T_PS2_CLK <= '1';
			wait for 30 us;
			-- stop bit
			T_PS2_DATA <= '1';
			wait for 10 us;
			T_PS2_CLK <= '0';
			wait for 40 us;
			T_PS2_CLK <= '1';
			wait for 30 us;
			-- overujeme, jestli se nastavil KEY_PRESS
			--assert not T_KEY_PRESS'stable(100 us) report "chybne nastaven KEY_PRESS" severity error;
		end procedure;
	
	begin
	TS1 <= "00101011"; -- F
	TS2 <= "00111100"; -- U
	TS3 <= "01001011"; -- L
	TS4 <= "00111010"; -- M

-- vysilame KEY F
   TEST(TS1);
	wait for 1 ms;
-- vysilame KEY U
	TEST(TS2);
	wait for 1 ms;
-- vysilame KEY L
	TEST(TS3);
	wait for 1 ms;
-- vysilame KEY L
	TEST(TS3);
	wait for 5 ms;
	assert T_SHODA = '1' report "neni detekovana shoda" severity error;
	
-- vysilame KEY F
   TEST(TS1);
	wait for 1 ms;
-- vysilame KEY U
	TEST(TS2);
	wait for 1 ms;
-- vysilame KEY M
	TEST(TS4);
	wait for 1 ms;
-- vysilame KEY L
	TEST(TS3);
	wait for 5 ms;
	assert T_JCHYBA <= '1' report "neni detekovana jedna chyba" severity error;
	
	
	wait;
	end process;
	

end architecture;