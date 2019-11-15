----------------------------------------------------------------------------------
--
-- Create Date:    16:40:58 11/28/2018
-- The command sender module
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops
library work;
use WORK.decoder.all;


entity lcd_sender is
    Port ( clk 		: in STD_LOGIC;
			  reset 		: in STD_LOGIC;
			  data 		: in  STD_LOGIC_VECTOR (63 downto 0);
           new_data  : in  STD_LOGIC;
			  lcd_en 	: out  STD_LOGIC;
           lcd_rw 	: out  STD_LOGIC;
           lcd_rs 	: out  STD_LOGIC;
           lcd_data 	: out  STD_LOGIC_VECTOR (7 downto 0);
           ready 		: out  STD_LOGIC);
end lcd_sender;

architecture Behavioral of lcd_sender is


type state_type is (initState,turnOnDisplay,setEntryMode,idle,
                    start1,start2,start3,setFunction,clearDisplay,
                    setAddr,sendData,waitState,returnHome);

signal state : state_type;
signal nextState : state_type;

signal counter : integer; --Count time elapsed since last command
signal toWait : integer; --Time to wait until next command.

signal lcdPosX : integer;
signal lcdPosY : integer;

constant shortDelay : integer := 1; --100us
constant longDelay : integer := 20; --2ms
constant reallyLongDelay : integer := 100;--20ms
constant signalLength : integer := 0;

--COMMANDS
constant cmdClearDisplay : std_logic_vector := "00000001"; --execution time 1.52ms
constant cmdReturnHome : std_logic_vector := "00000011";	--execution time 1-52ms
constant cmdSetEntryMode : std_logic_vector := "00000110"; --38us Increment DDRAM, no display shift
constant cmdDisplayOn : std_logic_vector := "00001100"; --Turn on display, no cursor.
constant cmdFunctionSet : std_logic_vector := "00111000"; --Set function: 8bit 2line 5x8 font


begin


--State register.
process(clk,reset)
begin
	if(clk='1' and clk'event) then
	if(reset='1') then
		counter <= 0;
		state<=initState;
	elsif(state = idle) then
	  state <= nextState;
	elsif(lcdPosX = 16 and lcdPosY = 3 and state = sendData) then
	  state <= idle;
	elsif(counter>=toWait) then
		state<=nextState;
		counter<=0;
	elsif(counter=signalLength) then
		state<=waitState;
		counter <= counter + 1;
	else
		counter <= counter + 1;
	end if;
	end if;
end process;


lcd_rw <= '0';


--Synchronous output.
process(clk,reset)
begin
if(clk='1' and clk'event) then
	if(reset='1') then
		toWait <= 0;
		lcdPosX <= 7;
		lcdPosY <= 0;
		nextState <= initState;
	else
		case state is
		when initState =>
		nextState <= start1;
		toWait <= 500;

		when turnOnDisplay =>
		nextState <= clearDisplay;
		toWait <= longDelay;

		when setEntryMode =>
		nextState <= returnHome;
		toWait <= longDelay;

		when setFunction =>
		nextState <= turnOnDisplay;
		toWait <= longDelay;

		when start1 =>
		nextState <= start2;
		toWait <= reallyLongDelay;

		when start2 =>
		nextState <= start3;
		toWait <= reallyLongDelay;

		when start3 =>
		toWait <= reallyLongDelay;
		nextState <=setFunction;

		when clearDisplay =>
		toWait <= longDelay;
		nextState <= setEntryMode;

		when setAddr =>
		toWait <= shortDelay;
    nextState <= sendData;
		when sendData =>
		toWait <= shortDelay;
		if lcdPosX=16 and lcdPosY=3 then
		nextState <= idle;
		else
		nextState <= sendData;
		end if;

      --JUMPS
    if lcdPosX=12 and lcdPosY =0 then
          lcdPosX <= 0; lcdPosY <= 2;
          nextState <= setAddr;
    elsif lcdPosX = 0 and lcdPosY = 2 then
          lcdPosX <= 3; lcdPosY <= 2;
          nextState <= setAddr;
    elsif lcdPosX = 13 and lcdPosY = 2 then
          lcdPosX <= 19;
          nextState <= setAddr;
    elsif lcdPosX = 19 and lcdPosY = 2 then
          lcdPosX <= 0; lcdPosY <= 1;
    elsif lcdPosX = 0 and lcdPosY = 1 then
          lcdPosX <= 5; lcdPosY <= 1;
          nextState <= setAddr;
    elsif lcdPosX = 12 and lcdPosY = 1 then
          lcdPosX <= 15;
          nextState <= setAddr;
    elsif lcdPosX = 19 and lcdPosY = 1 then
          lcdPosX <= 0;
          lcdPosY <= 3;
          nextState <= setAddr;
    elsif lcdPosX = 16 and lcdPosY = 3 then
          lcdPosX <= 7;
          lcdPosY <= 0;
    else
			    lcdPosX <= lcdPosX + 1;
    end if;

		when idle =>
		lcdPosX <= 7;
		lcdPosY <= 0;
		if new_data='1' then
			ready <= '0';
			nextState <= setAddr;
		else
		ready <= '1';
		nextState<=idle;
		end if;

		when returnHome =>
		toWait <= longDelay;
		lcdPosX <= 7;
		lcdPosY <= 0;
		nextState <= idle;
		when others =>
		end case;
	end if;
end if;
end process;

--Moore output
process(state,lcdPosX,lcdPosY)
	begin
	lcd_en <= '0';
	lcd_rs <= '0';
	lcd_data <= "00000000";
		case state is
		when initState =>
		when turnOnDisplay =>
		lcd_data <= cmdDisplayOn;
		lcd_rs <= '0';
		lcd_en <= '1';
		when setEntryMode =>
		lcd_data <= cmdSetEntryMode;
		lcd_rs <= '0';
		lcd_en <= '1';
		when setFunction =>
		lcd_data <= cmdFunctionSet;
		lcd_rs <= '0';
		lcd_en <= '1';
		when start1 =>
		lcd_data <= cmdFunctionSet;
		lcd_rs <= '0';
		lcd_en <= '1';
		when start2 =>
		lcd_data <= cmdFunctionSet;
		lcd_rs <= '0';
		lcd_en <= '1';
		when start3 =>
		lcd_data <= cmdFunctionSet;
		lcd_rs <= '0';
		lcd_en <= '1';
		when clearDisplay =>
		lcd_data <= cmdClearDisplay;
		lcd_rs <= '0';
		lcd_en <= '1';
		when setAddr =>
    lcd_rs <='0';
		lcd_en <='1';
    if lcdPosY = 0 then
	  lcd_data<=std_logic_vector(to_unsigned(lcdPosX,8));
    elsif lcdPosY = 1 then
    lcd_data<=std_logic_vector(x"40"+to_unsigned(lcdPosX,8));
    elsif lcdPosY = 2 then
    lcd_data<=std_logic_vector(x"14"+to_unsigned(lcdPosX,8));
    else
    lcd_data<=std_logic_vector(x"54"+to_unsigned(lcdPosX,8));
    end if;
	 lcd_data(7) <= '1';
		when sendData =>
		lcd_rs <='1';
		lcd_en <='1';
		lcd_data<= getChar(lcdPosX,lcdPosY,data);
		when waitState =>
		lcd_rs <='0';
		lcd_en<='0';
		lcd_data<="00000000";
		when idle =>
		lcd_rs <='0';
		lcd_en<='0';
		lcd_data<="00000000";
		when returnHome =>
		lcd_data <= cmdReturnHome;
		lcd_rs <= '0';
		lcd_en <= '1';
		when others =>
		lcd_data<="00001100";
		end case;
end process;


end Behavioral;
