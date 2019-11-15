--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:45:17 01/17/2019
-- Design Name:   
-- Module Name:   /nas/ei/home/ga83cuk/projectlab/New Folder/skeleton/alarmtb.vhd
-- Project Name:  Projlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alarmclock
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alarmtb IS
END alarmtb;
 
ARCHITECTURE behavior OF alarmtb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alarmclock
    PORT(
         mode_fsm : IN  std_logic;
         time_mm : IN  std_logic_vector(7 downto 0);
         time_ss : IN  std_logic_vector(7 downto 0);
         action_long : IN  std_logic;
         action_imp : IN  std_logic;
         plus_imp : IN  std_logic;
         minus_imp : IN  std_logic;
         mode : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
			clk1 : IN  std_logic;
			clk2 : IN  std_logic;
         bcd_mm : OUT  std_logic_vector(7 downto 0);
         bcd_ss : OUT  std_logic_vector(7 downto 0);
         led_alarm_act : OUT  std_logic;
         led_alarm_ring : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal mode_fsm : std_logic := '0';
   signal time_mm : std_logic_vector(7 downto 0) := (others => '0');
   signal time_ss : std_logic_vector(7 downto 0) := (others => '0');
   signal action_long : std_logic := '0';
   signal action_imp : std_logic := '0';
   signal plus_imp : std_logic := '0';
   signal minus_imp : std_logic := '0';
   signal mode : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
	signal clk1 : std_logic := '0';
	signal clk2 : std_logic := '0';

 	--Outputs
   signal bcd_mm : std_logic_vector(7 downto 0);
   signal bcd_ss : std_logic_vector(7 downto 0);
   signal led_alarm_act : std_logic;
   signal led_alarm_ring : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alarmclock PORT MAP (
          mode_fsm => mode_fsm,
          time_mm => time_mm,
          time_ss => time_ss,
          action_long => action_long,
          action_imp => action_imp,
          plus_imp => plus_imp,
          minus_imp => minus_imp,
          mode => mode,
          rst => rst,
          clk => clk,
			 clk1 => clk1,
			 clk2 => clk2,
          bcd_mm => bcd_mm,
          bcd_ss => bcd_ss,
          led_alarm_act => led_alarm_act,
          led_alarm_ring => led_alarm_ring
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
      mode_fsm<='1' ;
		
		plus_imp<='1' after 100 ns, '0' after 210 ns;
		action_imp<='1' after 200 ns;
		--minus_imp<='1' after 500 ns;
		--action_imp<='1' after 500 ns;
		--mode<='1' after 200 ns;
		time_mm<="00000000" after 100 ns;
		time_ss<="00000001" after 100 ns;
		
		action_long<='1' after 500 ns;
      wait;
   end process;

END;
