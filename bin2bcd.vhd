----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:15:24 01/10/2019 
-- Design Name: 
-- Module Name:    bin2bcd - Behavioral 
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

entity bin2bcd is
    Port ( binary_min : in  STD_LOGIC_VECTOR (7 downto 0);
	        binary_sec: in  STD_LOGIC_VECTOR (7 downto 0);
	        clk: in std_logic;
           bcd_min : out  STD_LOGIC_VECTOR (7 downto 0);
			  bcd_sec : out  STD_LOGIC_VECTOR (7 downto 0));
end bin2bcd;

architecture Behavioral of bin2bcd is

begin

convert_min:process(clk)
variable i : integer:=0;
variable bcd1 : std_logic_vector(11 downto 0) := (others => '0');
variable bint : std_logic_vector(7 downto 0) := binary_min;
begin
i:=0;
bcd1:="000000000000";
bint:=binary_min;
for i in 0 to 7 loop  
bcd1(11 downto 1) := bcd1(10 downto 0);  
bcd1(0) := bint(7);
bint(7 downto 1) := bint(6 downto 0);
bint(0) :='0';
if(i < 7 and bcd1(3 downto 0) > "0100") then 
bcd1(3 downto 0) := bcd1(3 downto 0) + "0011";
end if;
if(i < 7 and bcd1(7 downto 4) > "0100") then 
bcd1(7 downto 4) := bcd1(7 downto 4) + "0011";
end if;
if(i < 7 and bcd1(11 downto 8) > "0100") then  
bcd1(11 downto 8) := bcd1(11 downto 8) + "0011";
end if;
end loop;
bcd_min<=bcd1(7 downto 0);

end process;
convert_sec:process(clk)
variable j: integer:=0;
variable bcd2 : std_logic_vector(11 downto 0) := (others => '0');
variable bint1 : std_logic_vector(7 downto 0) := binary_sec;
begin
j:=0;
bcd2:="000000000000";
bint1:=binary_sec;
for j in 0 to 7 loop  
bcd2(11 downto 1) := bcd2(10 downto 0);  
bcd2(0) := bint1(7);
bint1(7 downto 1) := bint1(6 downto 0);
bint1(0) :='0';


if(j < 7 and bcd2(3 downto 0) > "0100") then 
bcd2(3 downto 0) := bcd2(3 downto 0) + "0011";
end if;

if(j < 7 and bcd2(7 downto 4) > "0100") then 
bcd2(7 downto 4) := bcd2(7 downto 4) + "0011";
end if;

if(j < 7 and bcd2(11 downto 8) > "0100") then  
bcd2(11 downto 8) := bcd2(11 downto 8) + "0011";
end if;
end loop;
bcd_sec<=bcd2(7 downto 0);
end process;
end Behavioral;

