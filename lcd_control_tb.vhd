--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:03:57 12/04/2018
-- Design Name:   
-- Module Name:   /nas/ei/home/ge34med/Documents/icdesign/skeleton/lcd_control_tb.vhd
-- Project Name:  Projlab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd_control
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
use STD.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

use WORK.ddram_package.all;

ENTITY lcd_control_tb IS
END lcd_control_tb;
 
ARCHITECTURE behavior OF lcd_control_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd_control
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         state : IN  std_logic_vector(2 downto 0);
         dcf_valid : IN  std_logic;
         time_hh : in STD_LOGIC_VECTOR(7 downto 0);
			   time_mm : in STD_LOGIC_VECTOR(7 downto 0);
			   time_ss : in STD_LOGIC_VECTOR(7 downto 0);
			   year : in STD_LOGIC_VECTOR(7 downto 0);
			   month : in STD_LOGIC_VECTOR(7 downto 0);
			   day : in STD_LOGIC_VECTOR(7 downto 0);
			   day_of_the_week : in STD_LOGIC_VECTOR (2 downto 0);
			   alarm_hh : in STD_LOGIC_VECTOR(7 downto 0);
			   alarm_mm : in STD_LOGIC_VECTOR(7 downto 0);
           alarm_state : in  STD_LOGIC_VECTOR(1 downto 0);
           time_switch_time_1 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_time_2 : in  STD_LOGIC_VECTOR (15 downto 0);
           time_switch_state : in  STD_LOGIC;
           countdown_timer_time : in  STD_LOGIC_VECTOR (15 downto 0);
           countdown_state : in  STD_LOGIC;
           stop_watch_time : in  STD_LOGIC_VECTOR (31 downto 0);
          stop_watch_state : in  STD_LOGIC;
         lcd_en : OUT  std_logic;
         lcd_rw : OUT  std_logic;
         lcd_rs : OUT  std_logic;
         lcd_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
    component display is
    Port (  clk : in std_logic;
            reset : in std_logic;
            lcd_en : in std_logic;
            lcd_rs : in std_logic;
            lcd_data : in std_logic_vector(7 downto 0);
            ddram : out ddram_x_y;
            finished : out std_logic
            );
    end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal state : std_logic_vector(2 downto 0) := "000";
   signal dcf_valid : std_logic := '1';
	 signal time_hh : STD_LOGIC_VECTOR(7 downto 0):=(others => '0');
	 signal time_mm : STD_LOGIC_VECTOR(7 downto 0):=(others => '0');
			  signal time_ss : STD_LOGIC_VECTOR(7 downto 0):=(others => '0');
			  signal year : STD_LOGIC_VECTOR(7 downto 0):="00011000";
			  signal month : STD_LOGIC_VECTOR(7 downto 0):="00000101";
			  signal day : STD_LOGIC_VECTOR(7 downto 0):="00101000";
			  signal day_of_the_week : STD_LOGIC_VECTOR (2 downto 0):="010";
			  signal alarm_hh : STD_LOGIC_VECTOR(7 downto 0):="00100001";
			  signal alarm_mm : STD_LOGIC_VECTOR(7 downto 0):=(others => '0');
           signal alarm_state : STD_LOGIC_VECTOR(1 downto 0):=(others => '0');
           signal time_switch_time_1 : STD_LOGIC_VECTOR (15 downto 0):=(others => '0');
           signal time_switch_time_2 : STD_LOGIC_VECTOR (15 downto 0):=(others => '0');
           signal time_switch_state : STD_LOGIC := '0';
           signal countdown_timer_time : STD_LOGIC_VECTOR (15 downto 0):=(others => '0');
           signal countdown_state : STD_LOGIC := '0';
           signal stop_watch_time : STD_LOGIC_VECTOR (31 downto 0):=(others => '0');
           signal stop_watch_state : STD_LOGIC := '0';

 	--Outputs
   signal lcd_en : std_logic;
   signal lcd_rw : std_logic;
   signal lcd_rs : std_logic;
   signal lcd_data : std_logic_vector(7 downto 0);
   signal ddram : ddram_x_y;
   signal finished : std_logic;
   
   signal current_character : character := 'i';

   -- Clock period definitions
   constant clk_period : time := 2 ns;
   file file_RESULTS : text;
 
BEGIN
  file_open(file_RESULTS, "testlog_lcd_controller.txt", write_mode);
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd_control PORT MAP (
          clk => clk,
          reset => reset,
          state => state,
          dcf_valid => dcf_valid,
          time_hh => time_hh,
			    time_mm => time_mm,
			    time_ss => time_ss,
			    year => year,
			    month => month,
			    day => day,
			    day_of_the_week => day_of_the_week,
			    alarm_hh => alarm_hh,
			    alarm_mm => alarm_mm,
          alarm_state => alarm_state,
          time_switch_time_1 => time_switch_time_1,
          time_switch_time_2 => time_switch_time_2,
          time_switch_state => time_switch_state,
          countdown_timer_time => countdown_timer_time,
          countdown_state => countdown_state,
          stop_watch_time => stop_watch_time,
          stop_watch_state => stop_watch_state,
          lcd_en => lcd_en,
          lcd_rw => lcd_rw,
          lcd_rs => lcd_rs,
          lcd_data => lcd_data
        );
        
  display_model : display port map (clk => clk,
            reset => reset,
            lcd_en => lcd_en,
            lcd_rs => lcd_rs,
            lcd_data => lcd_data,
            ddram => ddram,
            finished => finished
                       );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

  --Test stuff
   reset <= '1' after 0 ns, '0' after 10 ns;
   alarm_state <= "01" after 3500ns, "11" after 4000ns, "10" after 7000 ns;  
   state <= "001" after 2500 ns, "010" after 3000 ns, "011" after 3500ns, 
   "100" after 5000ns, "101" after 5500 ns, "110" after 6400 ns;
   
   time_hh <= "00010010" after 50 ns;
   time_mm <= "00100011" after 70 ns;
   time_switch_state <= '1' after 5300 ns;
   stop_watch_state <= '1' after 7000 ns;
   countdown_state <= '1' after 5900 ns;
   dcf_valid <= '0' after 8000 ns;
   
   
   --Print process;
   process(clk)
     
     variable v_OLINE     : line;
     begin
       if(rising_edge(clk) and finished = '1') then
        write(v_OLINE,string'("____________________________________________________________"));
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,"new frame at " &time'image(now));
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("The current inputs to the display control module is"));
        writeline(file_RESULTS,v_OLINE);
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("Current State:"));
        case state is 
        when "000" => write(v_OLINE,string'("Time only"));
        when "001" => write(v_OLINE,string'("Time & date"));
        when "010" => write(v_OLINE,string'("Alarm"));
        when "011" => write(v_OLINE,string'("Time switch on time"));
        when "100" => write(v_OLINE,string'("Time switch off time"));
        when "101" => write(v_OLINE,string'("Countdown timer"));
        when "110" => write(v_OLINE,string'("Stopwatch"));
        when others => 
        write(v_OLINE,string'("INVALID STATE"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("Time:"));
        write(v_OLINE,to_integer(unsigned(time_hh(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(time_hh(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,to_integer(unsigned(time_mm(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(time_mm(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,to_integer(unsigned(time_ss(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(time_ss(3 downto 0))));
        write(v_OLINE,string'(" Alarm:"));
        write(v_OLINE,to_integer(unsigned(alarm_hh(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(alarm_hh(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,to_integer(unsigned(alarm_mm(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(alarm_mm(3 downto 0))));
        write(v_OLINE,string'(":"));
        write(v_OLINE,string'("Date:"));
        write(v_OLINE,to_integer(unsigned(day(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(day(3 downto 0))));
        write(v_OLINE,string'("/"));
        write(v_OLINE,to_integer(unsigned(month(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(month(3 downto 0))));
        write(v_OLINE,string'("/"));
        write(v_OLINE,to_integer(unsigned(year(7 downto 4))));
        write(v_OLINE,to_integer(unsigned(year(3 downto 0))));
        write(v_OLINE,string'("-"));
        write(v_OLINE,string'(" -- "));
        case day_of_the_week is
        when "001" => write(v_OLINE,string'("Monday"));
          when "010" => write(v_OLINE,string'("Tuesday"));
            when "011" => write(v_OLINE,string'("Wednsday"));
              when "100" => write(v_OLINE,string'("Thursday"));
                when "101" => write(v_OLINE,string'("Friday"));
                when "110" => write(v_OLINE,string'("Saturday"));
                  when "111" => write(v_OLINE,string'("Sunday"));
                when others => write(v_OLINE,string'("invalid weekday"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("Alarm is "));
        case alarm_State is
        when "01" => write(v_OLINE,string'("Active"));
        when "10" => write(v_OLINE,string'("Snooze"));
        when "11" => write(v_OLINE,string'("Snooze"));
        when "00" => write(v_OLINE,string'("Inactive"));
        when others => write(v_OLINE,string'("invalid weekday"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        
        write(v_OLINE,string'("Time Switch is "));
        case time_switch_state is
        when '1' => write(v_OLINE,string'("Active"));
        when others => write(v_OLINE,string'("Inactive"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("Countdown is "));
        case countdown_state is
        when '1' => write(v_OLINE,string'("On"));
        when others => write(v_OLINE,string'("Off"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("Stopwatch is "));
        case stop_watch_state is
        when '1' => write(v_OLINE,string'("showing lap time"));
        when others => write(v_OLINE,string'("not showing lap time"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        
        write(v_OLINE,string'("DCF is "));
        case dcf_valid is
        when '1' => write(v_OLINE,string'("valid"));
        when others => write(v_OLINE,string'("not valid"));
        end case;
        writeline(file_RESULTS,v_OLINE);
        writeline(file_RESULTS,v_OLINE);
        write(v_OLINE,string'("And the display is showing"));
        writeline(file_RESULTS,v_OLINE);
        
        for y in 0 to 3 loop
        for x in 0 to 19 loop
        write(v_OLINE,"|" & ddram(x,y) & "|");
      end loop;
      writeline(file_RESULTS,v_OLINE);
      end loop;
      write(v_OLINE,string'("____________________________________________________________"));
      writeline(file_RESULTS,v_OLINE);
      write(v_OLINE,lf & lf & lf & lf);
      writeline(file_RESULTS,v_OLINE);
     end if;
   end process;
      
  process(lcd_data)
    begin
    if(lcd_rs = '1') then
    case lcd_data is
        when "01000001" => current_character <= 'A';
				when "01000010" => current_character <= 'B';
				when "01000011" => current_character <= 'C';
				when "01000100" => current_character <= 'D';
				when "01000101" => current_character <= 'E';
				when "01000110" => current_character <= 'F';
				when "01000111" => current_character <= 'G';
				when "01001000" => current_character <= 'H';
				when "01001001" => current_character <= 'I';
				when "01001010" => current_character <= 'J';
				when "01001011" => current_character <= 'K';
				when "01001100" => current_character <= 'L';
				when "01001101" => current_character <= 'M';
				when "01001110" => current_character <= 'N';
				when "01001111" => current_character <= 'O';
				when "01010000" => current_character <= 'P';
				when "01010001" => current_character <= 'Q';
				when "01010010" => current_character <= 'R';
				when "01010011" => current_character <= 'S';
				when "01010100" => current_character <= 'T';
				when "01010101" => current_character <= 'U';
				when "01010110" => current_character <= 'V';
				when "01010111" => current_character <= 'W';
				when "01011000" => current_character <= 'X';
				when "01011001" => current_character <= 'Y';
				when "01011010" => current_character <= 'Z';
				when "01100001" => current_character <= 'a';
				when "01100010" => current_character <= 'b';
				when "01100011" => current_character <= 'c';
				when "01100100" => current_character <= 'd';
				when "01100101" => current_character <= 'e';
				when "01100110" => current_character <= 'f';
				when "01100111" => current_character <= 'g';
				when "01101000" => current_character <= 'h';
				when "01101001" => current_character <= 'i';
				when "01101010" => current_character <= 'j';
				when "01101011" => current_character <= 'k';
				when "01101100" => current_character <= 'l';
				when "01101101" => current_character <= 'm';
				when "01101110" => current_character <= 'n';
				when "01101111" => current_character <= 'o';
				when "01110000" => current_character <= 'p';
				when "01110001" => current_character <= 'q';
				when "01110010" => current_character <= 'r';
				when "01110011" => current_character <= 's';
				when "01110100" => current_character <= 't';
				when "01110101" => current_character <= 'u';
				when "01110110" => current_character <= 'v';
				when "01110111" => current_character <= 'w';
				when "01111000" => current_character <= 'x';
				when "01111001" => current_character <= 'y';
				when "01111010" => current_character <= 'z';
				when "00101111" => current_character <= '/';
				when "00111010" => current_character <= ':';
				when "00101110" => current_character <= '.';
				when "00101010" => current_character <= '*';
				when "00010000" => current_character <= ' ';
				when "00110000" => current_character <= '0';
				when "00110001" => current_character <= '1';
				when "00110010" => current_character <= '2';
				when "00110011" => current_character <= '3';
				when "00110100" => current_character <= '4';
				when "00110101" => current_character <= '5';
				when "00110110" => current_character <= '6';
				when "00110111" => current_character <= '7';
				when "00111000" => current_character <= '8';
				when "00111001" => current_character <= '9';
				when others => current_character <= '?';
		end case;
		end if;
  end process;
   
   
END;
