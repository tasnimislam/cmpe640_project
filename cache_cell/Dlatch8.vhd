library IEEE;
use IEEE.std_logic_1164.all;

entity Dlatch8 is
  port(
    d    : in  std_logic_vector(7 downto 0);
    clk  : in  std_logic;
    q    : out std_logic_vector(7 downto 0);
    qbar : out std_logic_vector(7 downto 0)
  );
end Dlatch8;

architecture structural of Dlatch8 is

  component Dlatch
    port(
      d    : in  std_logic;
      clk  : in  std_logic;
      q    : out std_logic;
      qbar : out std_logic
    );
  end component;

begin
  -- Instantiate 8 single-bit latches
  gen_latches : for i in 7 downto 0 generate
    bit_latch : Dlatch
      port map(
        d    => d(i),
        clk  => clk,
        q    => q(i),
        qbar => qbar(i)
      );
  end generate gen_latches;

end structural;
