library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.std_logic_arith.all;
use WORK.CONSCTANS.ALL;

entity COUNTER is
	port (
		CLK     : in std_logic;
		RESET   : in std_logic;
		UP      : in std_logic;
		CNT_OUT : out std_logic_vector (OUTPUT_WIDTH - 1 downto 0);
		TOP     : out std_logic;
		BOTTOM  : out std_logic
	);
end COUNTER;

architecture COUNTER_BODY of COUNTER is

	signal COUNTER_VALUE : std_logic_vector (COUNTER_WIDTH - 1 downto 0);

begin
	COUNT : process (CLK)
	begin
		if CLK = '1' and CLK'event then
			if RESET = '1' then
				COUNTER_VALUE <= conv_std_logic_vector (0, COUNTER_WIDTH);
			elsif UP = '1' then
				COUNTER_VALUE <= COUNTER_VALUE + 1;
			else
				COUNTER_VALUE <= COUNTER_VALUE - 1;
			end if;
		end if;
	end process;
	
	ASSIGN : process (COUNTER_VALUE)
	begin
		CNT_OUT <= COUNTER_VALUE (COUNTER_WIDTH - 1 downto COUNTER_WIDTH - OUTPUT_WIDTH);
	end process;
	
   -- kombinacni logika, ktera nastavuje TOP
   TOP_PROC : process(COUNTER_VALUE)
      variable auxTOP : std_logic;
   begin
      auxTOP := '1';
      for I in 0 to COUNTER_WIDTH-1 loop
         auxTOP := auxTOP and COUNTER_VALUE(I);
      end loop;
      TOP <= auxTOP after 10 ns;
   end process TOP_PROC;
 
   -- kombinacni logika, ktera nastavuje BOTTOM
   BOTTOM_PROC : process(COUNTER_VALUE)
      variable auxBOTTOM : std_logic;
   begin
      auxBOTTOM := '0';
      for I in 0 to COUNTER_WIDTH-1 loop
         auxBOTTOM := auxBOTTOM or COUNTER_VALUE(I);
      end loop;
      BOTTOM <= not auxBOTTOM after 10 ns;
   end process BOTTOM_PROC;

end COUNTER_BODY;

