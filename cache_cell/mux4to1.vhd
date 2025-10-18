library IEEE;
use IEEE.std_logic_1164.all;

entity mux4to1 is
  port(
    D0  : in  std_logic;
    D1  : in  std_logic;
    D2  : in  std_logic;
    D3  : in  std_logic;
    S   : in  std_logic_vector(1 downto 0);  -- S(1)=MSB, S(0)=LSB
    Y   : out std_logic
  );
end mux4to1;

architecture structural of mux4to1 is
  component mux2to1_std
    port( A: in std_logic; B: in std_logic; Sel: in std_logic; Y: out std_logic );
  end component;

  signal y_lo, y_hi : std_logic;
begin
  -- Stage 1: pick between D0/D1 and D2/D3 using S(0)
  MUX01 : mux2to1_std port map(A => D0, B => D1, Sel => S(0), Y => y_lo);
  MUX23 : mux2to1_std port map(A => D2, B => D3, Sel => S(0), Y => y_hi);

  -- Stage 2: pick between the two results using S(1)
  MUXTOP: mux2to1_std port map(A => y_lo, B => y_hi, Sel => S(1), Y => Y);
end;
