--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:07:43 01/12/2019
-- Design Name:   
-- Module Name:   /nas/ei/home/ge69hic/skeleton/tb_DCF77.vhd
-- Project Name:  Projlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DCF77
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
USE ieee.numeric_std.ALL;
 
ENTITY tb_DCF77 IS
END tb_DCF77;
 
ARCHITECTURE behavior OF tb_DCF77 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT DCF77
    GENERIC ( 
        fclk : integer
        );
    PORT(
         clk : IN  std_logic;
         dcf : IN  std_logic;
         dcf_sec0  : OUT  std_logic;
         bitsout   : OUT  std_logic_vector(58 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal dcf : std_logic := '0';

 	--Outputs
   signal dcf_sec0  : std_logic;
   signal bitsout   : std_logic_vector(58 downto 0);

 	procedure DCF77Send( signal dcf77bits : in std_logic_vector(59 downto 0); 
						      signal sig       : out std_logic
                       ) is
	begin
      for i in 0 to 58 loop
         sig <= '1';
         wait for 100 sec;
         if dcf77bits(i)='1' then
            wait for 100 sec;
            sig <= '0';
            wait for 800 sec;
         else
            sig <= '0';
            wait for 900 sec;
         end if;
      end loop;
      wait for 1000 sec; -- Sekunde 59
	end procedure;

	signal dcf77bits :  std_logic_vector(59 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DCF77  GENERIC MAP (
          fclk => 50000         -- f¸r Simulation: 50kHz
        )
        PORT MAP (
          clk        => clk,
          dcf        => dcf,
          dcf_sec0   => dcf_sec0,
          bitsout    => bitsout
        );

   clk <= not clk after 10 us;  -- f¸r Simulation: 50kHz
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 1000 ms;	
      dcf77bits <= x"818181081818181"; -- 15 Hex-Zahlen = 60 Bit     
      DCF77Send(dcf77bits, dcf);      

      dcf77bits <= x"123456789abcdef"; -- 15 Hex-Zahlen = 60 Bit     
      DCF77Send(dcf77bits, dcf);      

      dcf77bits <= x"55aa55aa55aa55a"; -- 15 Hex-Zahlen = 60 Bit
      DCF77Send(dcf77bits, dcf);      

      dcf77bits <= x"773388773388773"; -- 15 Hex-Zahlen      
      DCF77Send(dcf77bits, dcf);      
      wait;
   end process;

END;

 
