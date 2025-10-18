library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1 is 
    port(
        D_0   : in std_logic;
        D_1   : in std_logic;
        S0  : in std_logic;
        S1  : in std_logic;
        Y  : out std_logic);
end mux2to1;

architecture structural of mux2to1 is 

component and2
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

component or2
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

for and2_1, and2_2: and2 use entity work.and2(structural);
for or2_1: or2 use entity work.or2(structural);


signal temp1, temp2, B_not: std_logic;

begin

    and2_1: and2 port map (S1, D_1, temp1);
    and2_2: and2 port map (S0, D_0, temp2);
    or2_1: or2 port map (temp1, temp2, Y);

end structural;
