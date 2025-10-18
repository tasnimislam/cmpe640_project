-- tb_mux2to1.vhd
-- Manual stimulus testbench (prints D0, D1, S0, S1, Y)
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux2to1 is
end tb_mux2to1;

architecture sim of tb_mux2to1 is
  signal D_0 : std_logic := '0';
  signal D_1 : std_logic := '1';
  signal S0  : std_logic := '0';
  signal S1  : std_logic := '0';
  signal Y   : std_logic;
begin
  --------------------------------------------------------------------
  -- DUT instantiation
  --------------------------------------------------------------------
  UUT: entity work.mux2to1
    port map(
      D_0 => D_0,
      D_1 => D_1,
      S0  => S0,
      S1  => S1,
      Y   => Y
    );

  --------------------------------------------------------------------
  -- Manual stimulus (no loops)
  --------------------------------------------------------------------
  stim: process
  begin
    report "=== TB START (printing D0, D1, S0, S1, Y) ===";

    -- Case 1
    D_0 <= '0'; D_1 <= '1';
    S0 <= '0'; S1 <= '0';
    wait for 20 ns;
    report "D0=" & std_logic'image(D_0) &
           "  D1=" & std_logic'image(D_1) &
           "  S0=" & std_logic'image(S0) &
           "  S1=" & std_logic'image(S1) &
           "  --> Y=" & std_logic'image(Y);

    -- Case 2
    S0 <= '1'; S1 <= '0';
    wait for 20 ns;
    report "D0=" & std_logic'image(D_0) &
           "  D1=" & std_logic'image(D_1) &
           "  S0=" & std_logic'image(S0) &
           "  S1=" & std_logic'image(S1) &
           "  --> Y=" & std_logic'image(Y);

    -- Case 3
    S0 <= '0'; S1 <= '1';
    wait for 20 ns;
    report "D0=" & std_logic'image(D_0) &
           "  D1=" & std_logic'image(D_1) &
           "  S0=" & std_logic'image(S0) &
           "  S1=" & std_logic'image(S1) &
           "  --> Y=" & std_logic'image(Y);

    -- Case 4
    S0 <= '1'; S1 <= '1';
    wait for 20 ns;
    report "D0=" & std_logic'image(D_0) &
           "  D1=" & std_logic'image(D_1) &
           "  S0=" & std_logic'image(S0) &
           "  S1=" & std_logic'image(S1) &
           "  --> Y=" & std_logic'image(Y);

    report "=== TB DONE ===";
    wait;
  end process;

end architecture sim;
