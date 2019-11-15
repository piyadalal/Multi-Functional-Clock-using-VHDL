library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops
use WORK.ddram_package.all;
 

--Behavioural model of the display
entity display is
    Port (  clk : in std_logic;
            reset : in std_logic;
            lcd_en : in std_logic;
            lcd_rs : in std_logic;
            lcd_data : in std_logic_vector(7 downto 0);
            ddram : out ddram_x_y;
            finished : out std_logic
            );
end display;

architecture Behavioral of display is
signal x,y : integer ; --current ddram address
begin
process(clk,reset)
  variable n : integer;
  variable current_character : character;
  begin
    if(clk='1' and clk'event) then
      if(reset = '1') then
      for x in 0 to 19 loop
        for y in 0 to 3 loop
        ddram(x,y)<= ' '; --Reset, fill with blanks
      end loop;
      end loop;
      x <= 0;
      y <= 0;
      finished <= '0';
      else
        finished <= '0';
        if(lcd_en = '1') then --Valid data
          if(lcd_rs = '0') then --set addr
            n := to_integer(unsigned(lcd_data(6 downto 0)));
            if(n > 16#53#) then
              x <= n - 16#54#;
              y <= 3;
          elsif (n > 16#3F#) then
              x <= n - 16#40#;
              y <= 1;
          elsif (n > 16#13#) then
              x <= n - 16#14#;
              y <= 2;
          else
              x <= n;
              y <= 0; 
          end if;
        else 
        case lcd_data is
        when "01000001" => current_character := 'A';
				when "01000010" => current_character := 'B';
				when "01000011" => current_character := 'C';
				when "01000100" => current_character := 'D';
				when "01000101" => current_character := 'E';
				when "01000110" => current_character := 'F';
				when "01000111" => current_character := 'G';
				when "01001000" => current_character := 'H';
				when "01001001" => current_character := 'I';
				when "01001010" => current_character := 'J';
				when "01001011" => current_character := 'K';
				when "01001100" => current_character := 'L';
				when "01001101" => current_character := 'M';
				when "01001110" => current_character := 'N';
				when "01001111" => current_character := 'O';
				when "01010000" => current_character := 'P';
				when "01010001" => current_character := 'Q';
				when "01010010" => current_character := 'R';
				when "01010011" => current_character := 'S';
				when "01010100" => current_character := 'T';
				when "01010101" => current_character := 'U';
				when "01010110" => current_character := 'V';
				when "01010111" => current_character := 'W';
				when "01011000" => current_character := 'X';
				when "01011001" => current_character := 'Y';
				when "01011010" => current_character := 'Z';
				when "01100001" => current_character := 'a';
				when "01100010" => current_character := 'b';
				when "01100011" => current_character := 'c';
				when "01100100" => current_character := 'd';
				when "01100101" => current_character := 'e';
				when "01100110" => current_character := 'f';
				when "01100111" => current_character := 'g';
				when "01101000" => current_character := 'h';
				when "01101001" => current_character := 'i';
				when "01101010" => current_character := 'j';
				when "01101011" => current_character := 'k';
				when "01101100" => current_character := 'l';
				when "01101101" => current_character := 'm';
				when "01101110" => current_character := 'n';
				when "01101111" => current_character := 'o';
				when "01110000" => current_character := 'p';
				when "01110001" => current_character := 'q';
				when "01110010" => current_character := 'r';
				when "01110011" => current_character := 's';
				when "01110100" => current_character := 't';
				when "01110101" => current_character := 'u';
				when "01110110" => current_character := 'v';
				when "01110111" => current_character := 'w';
				when "01111000" => current_character := 'x';
				when "01111001" => current_character := 'y';
				when "01111010" => current_character := 'z';
				when "00101111" => current_character := '/';
				when "00111010" => current_character := ':';
				when "00101110" => current_character := '.';
				when "00101010" => current_character := '*';
				when "00010000" => current_character := ' ';
				when "00110000" => current_character := '0';
				when "00110001" => current_character := '1';
				when "00110010" => current_character := '2';
				when "00110011" => current_character := '3';
				when "00110100" => current_character := '4';
				when "00110101" => current_character := '5';
				when "00110110" => current_character := '6';
				when "00110111" => current_character := '7';
				when "00111000" => current_character := '8';
				when "00111001" => current_character := '9';
				when others => current_character := '?';
		    end case;
		    ddram(x,y) <= current_character;
		    if(x=16 and y =3) then
		      finished <= '1';
		      else
		      finished <= '0';
		      end if;
		    if(x=19) then
		       x <= 0;
		       case y is
		         when 0 => y <= 2;
		         when 1 => y <= 3;
		         when 2 => y <= 1;
		         when 3 => y <= 0;
		         when others => y <= 0;
		      end case;
		    else
		      x <= x + 1;
		    end if;
        end if;
      end if;
      end if;
    end if;
  end process;
  
end Behavioral;

