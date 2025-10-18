-- Testbench for 8-bit D Latch
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Dlatch8 is
end tb_Dlatch8;

architecture behavior of tb_Dlatch8 is

  -- DUT component
  component Dlatch8
    port(
      d    : in  std_logic_vector(7 downto 0);
      clk  : in  std_logic;
      q    : out std_logic_vector(7 downto 0);
      qbar : out std_logic_vector(7 downto 0)
    );
  end component;

  -- Signals
  signal d_tb    : std_logic_vector(7 downto 0) := (others => '0');
  signal clk_tb  : std_logic := '0';
  signal q_tb    : std_logic_vector(7 downto 0);
  signal qbar_tb : std_logic_vector(7 downto 0);

begin

  -- Instantiate DUT
  uut: Dlatch8
    port map(
      d    => d_tb,
      clk  => clk_tb,
      q    => q_tb,
      qbar => qbar_tb
    );

  -- Clock generation process: toggles every 10 ns
  clk_process : process
  begin
    while true loop
      clk_tb <= '0';
      wait for 10 ns;
      clk_tb <= '1';
      wait for 10 ns;
    end loop;
  end process;

  -- Stimulus process
  stim_proc : process
  begin
    -- Initial input
    d_tb <= "00000000";
    wait for 25 ns;

    -- Change data while latch is open
    d_tb <= "10101010";
    wait for 30 ns;

    -- Change again
    d_tb <= "01010101";
    wait for 40 ns;

    -- Another change
    d_tb <= "11110000";
    wait for 40 ns;

    -- One more
    d_tb <= "00001111";
    wait for 40 ns;

    -- End simulation
    wait for 50 ns;
    std.env.finish;
  end process;

end behavior;

