

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GameTest is
   port(Rb, Reset: out std_logic;
   Sum: out integer range 2 to 12;
   CLK: inout std_logic;
   Roll, Win, Lose: in std_logic);
end GameTest;

architecture diceTest of GameTest is

signal Tstate, Tnext: integer range 0 to 3;
signal Trig1: std_logic;
type arr is array(0 to 11) of integer;
constant SumArray: arr:= (7, 11, 2, 4, 7, 5, 6, 7, 6, 8, 9, 6);

begin

CLK <= not CLK after 20 ns;

   process(Roll, Win, Lose, TState)
     variable i: natural;
       begin
         case Tstate is
           when 0 => Rb <= '1';
             Reset <= '0';
             if i >= 12 then Tnext <= 3;
             elsif Roll = '1' then
                Sum <= SumArray(i);
                i := i+1;
                Tnext <= 1;
             end if;
           when 1 => Rb <= '0'; Tnext <= 2;
           when 2 => Tnext <= 0;
               Trig1 <= not Trig1;
                 if(Win or Lose) = '1' then
                   Reset <= '1';
                   end if;  
           when 3 => null; --Stop state
         end case;
   end process;

process(CLK)
    begin
      if CLK = '1' and CLK'event then
         Tstate <= Tnext;
      end if;
end process;
end diceTest;
