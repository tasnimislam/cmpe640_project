library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and3 is
  Port ( input1 : in  STD_LOGIC;
         input2 : in  STD_LOGIC;
         input3 : in  STD_LOGIC;
         output : out STD_LOGIC);
end and3;

architecture structural of and3 is
  -- Declare component and2
  component and2
    Port ( input1 : in  STD_LOGIC;
           input2 : in  STD_LOGIC;
           output : out STD_LOGIC);
  end component;

  signal w1 : STD_LOGIC;

begin
  -- First AND gate: a and b
  w1_here: and2 port map(input1 => input1, input2 => input2, output => w1);

  -- Second AND gate: (a and b) and c
  output_here: and2 port map(input1 => w1, input2 => input3, output => output);
end structural;

