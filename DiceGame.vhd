

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DiceGame is
    port(Rb, Reset, CLK: in std_logic;
    Sum: in integer range 2 to 12;
    Roll, Win, Lose: out std_logic);
end DiceGame;

architecture DiceBehave of DiceGame is

   signal State, NextState: integer range 0 to 5;
   signal Point: integer range 2 to 12;
   signal Sp: std_logic;

begin
   process(Rb, Reset, Sum, State)
      begin
         Sp <= '0'; Roll <= '0'; Win <= '0'; Lose <= '0';
      case State is
         when 0 => if Rb = '1' then NextState <= 1; end if;
         when 1 =>
            if Rb = '1' then Roll <= '1';
            elsif Sum =7 or Sum = 11 then NextState <= 2;
            elsif Sum =2 or Sum =3 or Sum =12 then NextState <=3;
            else Sp <= '1'; NextState <= 4;
            end if;
         when 2 => Win <='1';
            if Reset = '1' then NextState <= 0; end if;
         when 3 => Lose <= '1';
            if Reset = '1' then NextState <= 0; end if;
         when 4 => if Rb = '1' then NextState <= 5; end if;
         when 5 =>
              if Rb = '1' then Roll <= '1';
              elsif Sum = Point then NextState <= 2;
              elsif Sum = 7 then NextState <=3;
              else NextState <=4;
              end if;
        end case;
   end process;

process(CLK)
   begin
     if CLK'event and CLK = '1' then
     State <= NextState;
     if Sp = '1' then Point <= Sum; end if;
     end if;
end process;

end DiceBehave;
