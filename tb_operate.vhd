--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:23:19 01/10/2019
-- Design Name:   
-- Module Name:   C:/Users/Aysa/Desktop/submit/skeleton/tb_operate.vhd
-- Project Name:  Projlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: operate_alarm
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
 
ENTITY tb_operate IS
END tb_operate;
 
ARCHITECTURE behavior OF tb_operate IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT operate_alarm
    PORT(
         mode_fsm : IN  std_logic;
         mode : IN  std_logic;
         time_mm : IN  std_logic_vector(7 downto 0);
         time_ss : IN  std_logic_vector(7 downto 0);
         action_imp : IN  std_logic;
         action_long : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         set_time_mm : IN  std_logic_vector(7 downto 0);
         set_time_ss : IN  std_logic_vector(7 downto 0);
         time_count : IN  std_logic_vector(7 downto 0);
         activate_counter : OUT  std_logic;
         activate_set : OUT  std_logic;
         led_alarm_act : OUT  std_logic;
         led_alarm_ring : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal mode_fsm : std_logic := '0';
   signal mode : std_logic := '0';
   signal time_mm : std_logic_vector(7 downto 0) := (others => '0');
   signal time_ss : std_logic_vector(7 downto 0) := (others => '0');
   signal action_imp : std_logic := '0';
   signal action_long : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal set_time_mm : std_logic_vector(7 downto 0) := (others => '0');
   signal set_time_ss : std_logic_vector(7 downto 0) := (others => '0');
   signal time_count : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal activate_counter : std_logic;
   signal activate_set : std_logic;
   signal led_alarm_act : std_logic;
   signal led_alarm_ring : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: operate_alarm PORT MAP (
          mode_fsm => mode_fsm,
          mode => mode,
          time_mm => time_mm,
          time_ss => time_ss,
          action_imp => action_imp,
          action_long => action_long,
          clk => clk,
          rst => rst,
          set_time_mm => set_time_mm,
          set_time_ss => set_time_ss,
          time_count => time_count,
          activate_counter => activate_counter,
          activate_set => activate_set,
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
     
		
      -- insert stimulus here 
       mode_fsm<='1';
		action_imp<='1';
      wait for clk_period/2;
      mode<='0'
		set_time_mm<="00000000";
		set_time_ss<="00000000";
		time_mm<="00000000";
		time_ss<="00000000";
		action_imp<='0';
		wait for clk_period/2;
		action_imp<='1';
		time_count<="00000001";
		wait for clk_period/2;
		action_imp<='0';
		time_count<="00111100";
		wait for clk_period/2;
      wait;
   end process;

END;
