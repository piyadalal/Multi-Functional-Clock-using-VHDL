----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:44:02 12/06/2018 
-- Design Name: 
-- Module Name:    comparer - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparer is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input_data : in  STD_LOGIC_VECTOR (63 downto 0);
           output_data : out  STD_LOGIC_VECTOR (63 downto 0);
           new_data : out  STD_LOGIC;
           ready : in  STD_LOGIC);
end comparer;

architecture Behavioral of comparer is
signal data_buffer : std_logic_vector(63 downto 0);
begin
output_data <= data_buffer;
process(clk,reset)
begin
if(clk='1' and clk'event) then
	if(reset='1') then
		data_buffer <= (others => '1');
		--new_data <= '0';
	elsif ready='1' then
		if input_data/=data_buffer then
		data_buffer <= input_data;
		new_data <= '1';
		end if;
	else
		new_data <= '0';
	end if;
end if;
end process;

end Behavioral;

