library IEEE;
use IEEE.std_logic_1164.all;

entity DECODER is 
	port (
		BIN_VALUE : in  std_logic_vector (2 downto 0);
		ONE_HOT   : out std_logic_vector (7 downto 0)
	);
end entity DECODER;

architecture DECODER_BODY of DECODER is
begin
	DECODE : process (BIN_VALUE)
	begin 
		case BIN_VALUE is
			when "000"  => ONE_HOT <= "00000001";
			when "001"  => ONE_HOT <= "00000010";
			when "010"  => ONE_HOT <= "00000100";
			when "011"  => ONE_HOT <= "00001000";
			when "100"  => ONE_HOT <= "00010000";
			when "101"  => ONE_HOT <= "00100000";
			when "110"  => ONE_HOT <= "01000000";
			when others => ONE_HOT <= "10000000";
		end case;
	end process;
end architecture;

