----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:00:28 12/17/2018 
-- Design Name: 
-- Module Name:    alarmclock - Behavioral 
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
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alarmclock is
    Port ( mode_fsm : in  STD_LOGIC;
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_long : in  STD_LOGIC;
           action_imp : in  STD_LOGIC;
           plus_imp : in  STD_LOGIC;
           minus_imp : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  clk1: in  STD_LOGIC;
			  clk2: in std_logic;
--			  set_time_mm : out STD_LOGIC_VECTOR (7 downto 0);
--     set_time_ss : out  STD_LOGIC_VECTOR (7 downto 0);
			  bcd_mm : out  STD_LOGIC_VECTOR (7 downto 0);
           bcd_ss : out  STD_LOGIC_VECTOR (7 downto 0);
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC;
			  lcd_z:out std_logic;
			  alarm_ring: out std_logic);
end alarmclock;

architecture structure of alarmclock is
signal time_count: std_logic_vector(7 downto 0);
signal set_time_mm: std_logic_vector(7 downto 0);
signal set_time_ss: std_logic_vector(7 downto 0);
signal activate_set,activate_counter: std_logic;
component counter
 port(clk2: in  std_logic;
      activate_counter: in std_logic;
      timecount: out std_logic_vector(7 downto 0));
end component;
component operate_alarm
Port ( mode_fsm : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
           action_imp : in  STD_LOGIC;
           action_long : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  clk1: in  STD_LOGIC;
           rst : in  STD_LOGIC;
           set_time_mm : in  STD_LOGIC_VECTOR (7 downto 0);
           set_time_ss : in  STD_LOGIC_VECTOR (7 downto 0);
			  time_count: in  STD_LOGIC_VECTOR (7 downto 0);
			  activate_counter: out std_logic;
			  activate_set: out std_logic;
           led_alarm_act : out  STD_LOGIC;
           led_alarm_ring : out  STD_LOGIC;
			  lcd_z:out std_logic;
			  alarm_ring: out std_logic);
			  --plus_imp : in  STD_LOGIC;
			  --minus_imp : in  STD_LOGIC);
			  
end component;
component set_alarm
port(clk: in  STD_LOGIC;
     rst : in  STD_LOGIC;
	  activate_set: in  STD_LOGIC;
	  set_time_mm : out STD_LOGIC_VECTOR (7 downto 0);
     set_time_ss : out  STD_LOGIC_VECTOR (7 downto 0);
	  plus_imp : in  STD_LOGIC;
	  minus_imp : in  STD_LOGIC);
end component;
--component bin2bcd
--Port ( binary_min : in  STD_LOGIC_VECTOR (7 downto 0);
--	        binary_sec: in  STD_LOGIC_VECTOR (7 downto 0);
--	        clk: in std_logic;
--           bcd_min : out  STD_LOGIC_VECTOR (7 downto 0);
--			  bcd_sec : out  STD_LOGIC_VECTOR (7 downto 0));
--end component;
begin
bcd_mm<=set_time_mm;
bcd_ss<=set_time_ss;
counter1: counter
port map(clk2, activate_counter, time_count);
operate_alarm1: operate_alarm
port map(mode_fsm, mode, time_mm, time_ss, action_imp, action_long, clk,clk1, rst, set_time_mm, set_time_ss, time_count,activate_counter,activate_set, led_alarm_act, led_alarm_ring,lcd_z,alarm_ring);

set_alarm1: set_alarm
port map(clk, rst,activate_set, set_time_mm, set_time_ss, plus_imp, minus_imp);
--bin2bcd1: bin2bcd
--port map(set_time_mm, set_time_ss, clk, bcd_mm, bcd_ss);	


end structure;


