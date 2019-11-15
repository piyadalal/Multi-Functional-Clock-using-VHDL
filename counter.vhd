----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:52:49 12/18/2018 
-- Design Name: 
-- Module Name:    counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is 
        
             port(clk2: in  std_logic;
                  activate_counter: in std_logic;
                  timecount: out std_logic_vector(7 downto 0));
        
             end counter;
        
architecture behavioral of counter is  
signal temp: std_logic_vector(7 downto 0);
begin
counter:process(clk2)
variable i: integer:=0;
begin 
if activate_counter='1' then				 
	if rising_edge(clk2) then
		for i in 0 to 59 loop
			temp <= temp + 1;						 
		end loop;
	end if;  
end if;
end process; 
timecount <= temp;
end Behavioral;

