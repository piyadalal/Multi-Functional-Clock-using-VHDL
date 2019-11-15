--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:32:41 01/12/2019
-- Design Name:   
-- Module Name:   /nas/ei/home/ge69hic/skeleton/tb_dat_time.vhd
-- Project Name:  Projlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dat_time
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
 
ENTITY tb_dat_time IS
END tb_dat_time;
 
ARCHITECTURE behavior OF tb_dat_time IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dat_time
    PORT(
         en_1 : IN  std_logic;
         reset : IN  std_logic;
         de_set : IN  std_logic;
         de_day : IN  std_logic_vector(5 downto 0);
         de_month : IN  std_logic_vector(4 downto 0);
         de_year : IN  std_logic_vector(7 downto 0);
         de_hour : IN  std_logic_vector(5 downto 0);
         de_min : IN  std_logic_vector(6 downto 0);
         de_dow : IN  std_logic_vector(2 downto 0);
         valid : OUT  std_logic;
         dow : OUT  std_logic_vector(2 downto 0);
         day : OUT  std_logic_vector(5 downto 0);
         month : OUT  std_logic_vector(4 downto 0);
         year : OUT  std_logic_vector(7 downto 0);
         hour : OUT  std_logic_vector(5 downto 0);
         minute : OUT  std_logic_vector(6 downto 0);
         second : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal en_1 : std_logic := '0';
   signal reset : std_logic := '0';
   signal de_set : std_logic := '0';
   signal de_day : std_logic_vector(5 downto 0) := (others => '0');
   signal de_month : std_logic_vector(4 downto 0) := (others => '0');
   signal de_year : std_logic_vector(7 downto 0) := (others => '0');
   signal de_hour : std_logic_vector(5 downto 0) := (others => '0');
   signal de_min : std_logic_vector(6 downto 0) := (others => '0');
   signal de_dow : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal valid : std_logic;
   signal dow : std_logic_vector(2 downto 0);
   signal day : std_logic_vector(5 downto 0);
   signal month : std_logic_vector(4 downto 0);
   signal year : std_logic_vector(7 downto 0);
   signal hour : std_logic_vector(5 downto 0);
   signal minute : std_logic_vector(6 downto 0);
   signal second : std_logic_vector(6 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dat_time PORT MAP (
          en_1 => en_1,
          reset => reset,
          de_set => de_set,
          de_day => de_day,
          de_month => de_month,
          de_year => de_year,
          de_hour => de_hour,
          de_min => de_min,
          de_dow => de_dow,
          valid => valid,
          dow => dow,
          day => day,
          month => month,
          year => year,
          hour => hour,
          minute => minute,
          second => second
        );

   -- Clock process definitions
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for <clock>_period*10;

       en_1 <= '1': 
reset <= '0': 
de_set<= '0': 
de_day <= "x010001": 
de_dow <= "x110": 
de_month <= "x00001": 
de_year <= "x00011001": 
de_hour<= "x000001": 
de_min<="x0110101":

      wait;
   end process;

END;
