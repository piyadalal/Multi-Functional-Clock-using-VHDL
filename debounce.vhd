library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity debounce is
    Port ( clk : in  std_logic;
			  reset: in std_logic;
           d_in : in  std_logic;
           d_out : out  std_logic;
			  imp : out std_logic);
end debounce;

architecture Behavioral of debounce is

signal counter: integer range 0 to 128;
signal d: std_logic := '0';

begin
	d_out <= d;

	counter_gen : process(clk)
	begin
		if rising_edge(clk) then
			imp <= '0';
			
			if reset='1' then
				-- Reset
				d <= '0';
				counter <= 0;
			elsif d=d_in then
				-- No change
				counter <= 0;
			else
				-- Signal changed
				if counter=128 then
					-- Signal is long enough stable -> change
					d <= d_in;
					if d='0' then
						imp <= '1';
					end if;
				else
					-- Wait till signal is stable
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;
		
end Behavioral;

