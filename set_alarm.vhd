----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:26 01/04/2019 
-- Design Name: 
-- Module Name:    set_alarm - Behavioral 
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
-- arithme+tic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity set_alarm is
port(clk: in  STD_LOGIC;
     rst : in  STD_LOGIC;
	  activate_set: in  STD_LOGIC;
	  set_time_mm : out STD_LOGIC_VECTOR (7 downto 0);
     set_time_ss : out  STD_LOGIC_VECTOR (7 downto 0);
	  plus_imp : in  STD_LOGIC;
	  minus_imp : in  STD_LOGIC);
end set_alarm;

architecture Behavioral of set_alarm is

begin
--activate_set<='1';
set:process(rst,clk)
variable x1: std_logic_vector(3 downto 0):="0000";
variable x2: std_logic_vector(3 downto 0):="0000";
variable y1: std_logic_vector(3 downto 0):="0000";
variable y2: std_logic_vector(3 downto 0):="0000";
begin
if rising_edge(clk) then
set_time_mm<=x1 & x2;
set_time_ss<=y1 & y2;
if(rst='1') then 
		x1:="0000";
		x2:="0000";
		y1:="0001";
		y2:="0001";
end if;
if(activate_set='1') then
	if(plus_imp='1') then
	 if(x1="0101" and x2="1001" and y1="0101" and y2="1001")then
		x1:="0000";
		x2:="0000";
		y1:="0000";
		y2:="0000";
	 elsif(x2="1001" and y1="0101" and y2="1001") then
		x1:=x1+1;
		x2:="0000";
		y1:="0000";
		y2:="0000";
	 elsif(y1="0101" and y2="1001") then
	  x2:=x2+1;
	  y1:="0000";
	  y2:="0000";
	 elsif(y2="1001") then
	 y1:=y1+1;
	 y2:="0000";
	 else
		y2:=y2+1;
	 end if;
	elsif(minus_imp='1') then
	 if(x1="0000" and x2="0000" and y1="0000" and y2="0000")then
		x1:="0101";
		x2:="1001";
		y1:="0101";
		y2:="1001";
	 elsif(x2="0000" and y1="0000" and y2="0000") then
		x1:=x1-1;
		x2:="1001";
		y1:="0101";
		y2:="1001";
	 elsif(y1="0000" and y2="0000") then
	  x2:=x2-1;
	  y1:="0101";
	  y2:="1001";
	 elsif(y2="0000") then
	 y1:=y1-1;
	 y2:="1001";
	 else
		y2:=y2-1;
	 end if;
	end if;
end if;
end if;
end process;

end Behavioral;

