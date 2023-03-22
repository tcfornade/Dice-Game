library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
  Port ( clk: in std_logic;
        rst: in std_logic;
        btn: in std_logic_vector(2 downto 0); 
        led:out std_logic; 
        seg: out std_logic_vector(0 to 6);
        an: out std_logic_vector(3 downto 0);
        dp: out std_logic
        );
        
end test;

architecture Behavioral of test is
--declarare:
type states is (start, led_on, led_off, count);
signal current_state, next_state: states;

signal rb1, reset1, clk1, roll1, win1, lose1: std_logic;
signal sum1: integer range 2 to 12;
signal score : STD_LOGIC_VECTOR (15 downto 0);

component DiceGame is
    port(Rb, Reset, CLK: in std_logic;
    Sum: in integer range 2 to 12;
    Roll, Win, Lose: out std_logic);
end component DiceGame;

component GameTest is
   port(Rb, Reset: out std_logic;
   Sum: out integer range 2 to 12;
   CLK: inout std_logic;
   Roll, Win, Lose: in std_logic);
end component GameTest;

component driver7seg is
    Port ( clk : in STD_LOGIC; --100MHz board clock input
           Din : in STD_LOGIC_VECTOR (15 downto 0); --16 bit binary data for 4 displays
           an : out STD_LOGIC_VECTOR (3 downto 0); --anode outputs selecting individual displays 3 to 0
           seg : out STD_LOGIC_VECTOR (0 to 6); -- cathode outputs for selecting LED-s in each display
           dp_in : in STD_LOGIC_VECTOR (3 downto 0); --decimal point input values
           dp_out : out STD_LOGIC; --selected decimal point sent to cathodes
           rst : in STD_LOGIC); --global reset
end component driver7seg;


begin

Dice: DiceGame port map (Rb => rb1,
                         Reset => reset1,
                         CLK => clk1,
                         Sum => sum1,
                         Roll=>roll1,
                         Win=>win1,
                         Lose=>lose1);
DiceT: GameTest port map(Rb => rb1,
                         Reset => reset1,
                         CLK => clk1,
                         Roll => roll1,
                          Win=>win1,
                         Lose=>lose1);

u : driver7seg port map (clk => clk,
                         Din => score,
                         an => an,
                         seg => seg,
                         dp_in => "0000",
                         dp_out => dp,
                         rst => rst);

process (clk, rst)
begin
  if rst = '1' then
    current_state <= start;
  elsif rising_edge(clk) then
    current_state <= next_state;
  end if;    
end process;



--LED display
generate_led: process(clk, rst, win1, lose1)
begin
 if rst = '1' then
  if win1 = '1' then
   led <= '1';
   end if;
   elsif lose1 = '1' then led <= '0';
   end if;
end process;

--SSD Display
displaySum: process(clk, rst)
 variable unitati:integer range 0 to 9 := 0;
 variable zeci: integer range 0 to 2:=0;
 
 begin
   if rst = '1' then
      zeci := 0;
      unitati := 0;
   elsif rising_edge(clk) then
     if current_state = count then
        if unitati = 9 then
           unitati := 1;
            if zeci = 2 then
               zeci := 0;
            else unitati := unitati + 1;
            end if;
        else unitati := 0;
        end if;
    end if;
   end if;
  end process;
end Behavioral;
