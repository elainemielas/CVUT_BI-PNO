library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AUTOMAT is
	port (
			KEY_F     : in std_logic;     -- high for one clock when key 'f' pressed
			KEY_U     : in std_logic;     -- high for one clock when key 'u' pressed
			KEY_L     : in std_logic;     -- high for one clock when key 'l' pressed
			KEY_PRESS : in std_logic;     -- high for one clock when any key pressed
			CLK       : in  std_logic;    -- standard 50MHz clock
			RESET     : in  std_logic;
			JCHYBA    : out std_logic;    -- detekovano s 1 chybou
			SHODA     : out std_logic     -- detekovana uplna shoda
		);
end AUTOMAT;

architecture AUTOMAT_BODY of AUTOMAT is
	signal STAV, DALSI_STAV : std_logic_vector(0 to 8); -- bit 0 = stav 1 a tak dale

begin

	PRECHODY : process (KEY_F, KEY_U, KEY_L, KEY_PRESS, STAV)
	begin
	
		DALSI_STAV <= STAV;
		case STAV is
		-- 1
		when "100000000" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2 
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,2
		when "110000000" => if KEY_F = '1' then DALSI_STAV <= "110000100"; -- 1,2,7
								  elsif KEY_U = '1' then DALSI_STAV <= "101001000"; -- 1,3,6
								  else DALSI_STAV <= "100001100"; -- 1,6,7
								  end if;
								  
		-- 1,6
		when "100001000" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,2,7
		when "110000100" => if KEY_F = '1' then DALSI_STAV <= "110000100"; -- 1,2,7
								  elsif KEY_U = '1' then DALSI_STAV <= "101001000"; -- 1,3,6
								  elsif KEY_L = '1' then DALSI_STAV <= "100001110"; -- 1,6,7,8
								  else DALSI_STAV <= "100001100"; -- 1,6,7
								  end if;
		-- 1,6,7
		when "100001100" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  elsif KEY_L = '1' then DALSI_STAV <= "100001010"; -- 1,6,8
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,3,6
		when "101001000" => if KEY_F = '1' then DALSI_STAV <= "110000010"; -- 1,2,8
								  elsif KEY_U = '1' then DALSI_STAV <= "100001110"; -- 1,6,7,8
								  elsif KEY_L = '1' then DALSI_STAV <= "100101000"; -- 1,4,6
								  else DALSI_STAV <= "100001010"; -- 1,6,8
								  end if;
		-- 1,6,7,8
		when "100001110" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  elsif KEY_L = '1' then DALSI_STAV <= "100001011"; -- 1,6,8,9
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,6,8
		when "100001010" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  elsif KEY_L = '1' then DALSI_STAV <= "100001001"; -- 1,6,9
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,4,6
		when "100101000" => if KEY_F = '1' then DALSI_STAV <= "110000001"; -- 1,2,9
								  elsif KEY_U = '1' then DALSI_STAV <= "100001101"; -- 1,6,7,9
								  elsif KEY_L = '1' then DALSI_STAV <= "100011000"; -- 1,5,6
								  else DALSI_STAV <= "100001001"; -- 1,6,9
								  end if;
		-- 1,2,8
		when "110000010" => if KEY_F = '1' then DALSI_STAV <= "110000100"; -- 1,2,7
								  elsif KEY_U = '1' then DALSI_STAV <= "101001000"; -- 1,3,6
								  elsif KEY_L = '1' then DALSI_STAV <= "100001101"; -- 1,6,7,9
								  else DALSI_STAV <= "100001100"; -- 1,6,7
								  end if;
	   -- 1,6,8,9
		when "100001011" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  elsif KEY_L = '1' then DALSI_STAV <= "100001001"; -- 1,6,9
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,6,9
		when "100001001" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,2,9
		when "110000001" => if KEY_F = '1' then DALSI_STAV <= "110000100"; -- 1,2,7
								  elsif KEY_U = '1' then DALSI_STAV <= "101001000"; -- 1,3,6
								  else DALSI_STAV <= "100001100"; -- 1,6,7
								  end if;
		-- 1,6,7,9
		when "100001101" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  elsif KEY_L = '1' then DALSI_STAV <= "100001010"; -- 1,6,8
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		-- 1,5,6
		when "100011000" => if KEY_F = '1' then DALSI_STAV <= "110000000"; -- 1,2
								  elsif KEY_U = '1' then DALSI_STAV <= "100001100"; -- 1,6,7
								  else DALSI_STAV <= "100001000"; -- 1,6
								  end if;
		when others => NULL;
		end case;
	end process;
	
	
	VYSTUPY : process (STAV)
	begin
		JCHYBA <= '0'; 
		SHODA <= '0';
	   if STAV(8) = '1' then JCHYBA <= '1';
		elsif STAV(4) = '1' then SHODA <= '1';
		end if;
	end process;
	
	REG : process (CLK)
	begin
		if CLK'event and CLK = '1' then
			if RESET = '1' then STAV <= "100000000"; -- reset
			elsif KEY_PRESS = '1' then STAV <= DALSI_STAV;
			else STAV <= STAV;
			end if;
		end if;
	end process;
	
end architecture;

