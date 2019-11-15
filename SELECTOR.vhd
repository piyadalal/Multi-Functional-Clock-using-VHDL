----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:06 12/07/2018 
-- Design Name: 
-- Module Name:    SELECTOR - Behavioral 
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

entity SELECTOR is
    Port ( state : in  STD_LOGIC_VECTOR (2 downto 0);
           ctime : in  STD_LOGIC_VECTOR (23 downto 0);
           date : in  STD_LOGIC_VECTOR (23 downto 0);
			  day : in STD_LOGIC_VECTOR (2 downto 0);
           alarm_time : in  STD_LOGIC_VECTOR (15 downto 0);
           alarm_state : in  STD_LOGIC_VECTOR (1 downto 0);
           time_switch_time_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_time_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_state : in  STD_LOGIC;
           countdown_timer_time : in  STD_LOGIC_VECTOR (15 downto 0);
           countdown_state : in  STD_LOGIC;
           stop_watch_time : in  STD_LOGIC_VECTOR (31 downto 0);
           stop_watch_state : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (56 downto 0));
end SELECTOR;

architecture Behavioral of SELECTOR is

begin
process(state,ctime,date,alarm_time,alarm_state,time_switch_state,countdown_timer_time,countdown_state,stop_watch_time,stop_watch_state,day,time_switch_time_1,time_switch_time_2)
begin
case state is
when "000" => --Default
	output(23 downto 0) <= ctime;
	output(56 downto 24) <= (others => '0');
when "001" => --Date
	output(23 downto 0) <= ctime;
	output (47 downto 24) <= date;
	output(50 downto 48) <= day;
	output(56 downto 51) <= (others => '0');
when "010" => --Alarm
	output(23 downto 0) <= ctime;
	output(39 downto 24) <= alarm_time;
	output(56 downto 40) <= (others => '0');
when "011"  => --Time Switch
	output(15 downto 0) <= time_switch_time_1;
	output(31 downto 16) <= time_switch_time_2;
	output(32) <= time_switch_state;
	output(56 downto 33) <= (others => '0');
when "100" => 
  	output(15 downto 0) <= time_switch_time_1;
	output(31 downto 16) <= time_switch_time_2;
	output(32) <= time_switch_state;
	output(56 downto 33) <= (others => '0');
when "101" => --Countdown timer
	output(23 downto 0) <= ctime;
	output(39 downto 24) <= countdown_timer_time;
	output(40) <= countdown_state;
	output(56 downto 41) <= (others => '0');
when "110" => --Stop Watch
	output(23 downto 0) <= ctime;
	output(55 downto 24) <= stop_watch_time;
	output(56) <= stop_watch_state;
when others =>
	output(23 downto 0) <= ctime;
	output(56 downto 24) <= (others => '0');
end case;
end process;

end Behavioral;

