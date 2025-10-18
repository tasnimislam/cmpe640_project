library IEEE;
use IEEE.std_logic_1164.all;

entity Dlatch32 is
  port(
    d    : in  std_logic_vector(31 downto 0);
    clk  : in  std_logic;
    q    : out std_logic_vector(31 downto 0);
    qbar : out std_logic_vector(31 downto 0)
  );
end Dlatch32;

architecture structural of Dlatch32 is

  component Dlatch
    port(
      d    : in  std_logic;
      clk  : in  std_logic;
      q    : out std_logic;
      qbar : out std_logic
    );
  end component;

begin
  -- Instantiate 32 single-bit latches
  gen_latches : for i in 31 downto 0 generate
    bit_latch : Dlatch
      port map(
        d    => d(i),
        clk  => clk,
        q    => q(i),
        qbar => qbar(i)
      );
  end generate gen_latches;

end structural;
