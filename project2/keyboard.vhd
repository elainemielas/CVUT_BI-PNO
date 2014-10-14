library ieee;
use ieee.std_logic_1164.all;

entity keyboard is 
   port (
		PS2_DATA  : in  std_logic;     -- serial PS2 input
      PS2_CLK   : in  std_logic;     -- serial PS2 clock
      KEY_F     : out std_logic;     -- high for one clock when key 'f' pressed
      KEY_U     : out std_logic;     -- high for one clock when key 'u' pressed
      KEY_L     : out std_logic;     -- high for one clock when key 'l' pressed
      KEY_PRESS : out std_logic;     -- high for one clock when any key pressed
      CLK       : in  std_logic;     -- standard 50MHz clock
      RESET     : in  std_logic
   );
end keyboard;

architecture keyboard_body of keyboard is
	component RECEIVER
		port (
			PS2_DATA  : in  std_logic;     -- serial PS2 input
			PS2_CLK   : in  std_logic;     -- serial PS2 clock
			CLK       : in  std_logic;     -- standard 50MHz clock
			RESET     : in  std_logic;
			SCAN_CODE : out std_logic_vector ( 7 downto 0 );
			NEW_SC    : out std_logic
			);
	end component;
	
	signal NEW_SC : std_logic;
	signal PS2_DATA1, PS2_DATA2, PS2_CLK1, PS2_CLK2 : std_logic;
	signal SC : std_logic_vector ( 7 downto 0 );
	
	type T_STATE is ( OK, IGNORE );
	signal STATE, NEXT_STATE : T_STATE;
	
begin


	PS2_PR : process ( CLK )
	begin 
		if CLK = '1' and CLK'event then
			PS2_DATA1 <= PS2_DATA;
			PS2_DATA2 <= PS2_DATA1;
			PS2_CLK1 <= PS2_CLK;
			PS2_CLK2 <= PS2_CLK1;
		end if;
	end process;			

	RECEIVER_COMPONENT : RECEIVER port map ( PS2_DATA2, PS2_CLK2, CLK, RESET, SC, NEW_SC );
	
	--NEW_SC_D <= NEW_SC when rising_edge(clk);
	
	TRANSPR : process ( STATE, SC, NEW_SC )
	begin
		case STATE is
			when OK		=> if NEW_SC = '1' and ( SC = "11110000" or SC = "11100000" ) then
									NEXT_STATE <= IGNORE;
								else
									NEXT_STATE <= OK;
								end if;
			when IGNORE	=>	if NEW_SC = '1' and ( SC = "11110000" or SC = "11100000" ) then
									NEXT_STATE <= IGNORE;
								elsif NEW_SC = '1' then
									NEXT_STATE <= OK;
								else 
									NEXT_STATE <= IGNORE;
								end if;
		end case;	
	end process;
	
	REGPR : process ( CLK )
	begin
		if CLK = '1' and CLK'event then
			if RESET = '1' then
				STATE <= OK;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	OUTPR : process ( STATE, SC, NEW_SC )
	begin
		case STATE is
			when OK 		=> if NEW_SC = '1' then
									case SC is 
										when "00101011" 	=>	KEY_F <= '1';
																	KEY_U <= '0';
																	KEY_L <= '0';
																	KEY_PRESS <= '1';																	
										when "00111100"	=> KEY_F <= '0';
																	KEY_U <= '1';
																	KEY_L <= '0';
																	KEY_PRESS <= '1';		
										when "01001011"	=> KEY_F <= '0';
																	KEY_U <= '0';
																	KEY_L <= '1';
																	KEY_PRESS <= '1';		
										when "11100000" | "11110000"	=> KEY_F <= '0';
																					KEY_U <= '0';
																					KEY_L <= '0';
																					KEY_PRESS <= '0';		
										when others 		=> KEY_F <= '0';
																	KEY_U <= '0';
																	KEY_L <= '0';
																	KEY_PRESS <= '1';		
									end case;
								else
									KEY_F <= '0';
									KEY_U <= '0';
									KEY_L <= '0';
									KEY_PRESS <= '0';	
								end if;
			when IGNORE => KEY_F <= '0';
								KEY_U <= '0';
								KEY_L <= '0';
								KEY_PRESS <= '0';		
		end case;
	end process;
	

end keyboard_BODY;

