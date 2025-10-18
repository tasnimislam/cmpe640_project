-- tb_mux4to1.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux4to1 is
end tb_mux4to1;

architecture sim of tb_mux4to1 is

  -- DUT signals
  signal D0, D1, D2, D3 : std_logic := '0';
  signal S              : std_logic_vector(1 downto 0) := (others => '0');
  signal Y              : std_logic;

begin

  --------------------------------------------------------------------
  -- DUT instance
  --------------------------------------------------------------------
  UUT: entity work.mux4to1
    port map(
      D0 => D0,
      D1 => D1,
      D2 => D2,
      D3 => D3,
      S  => S,
      Y  => Y
    );

  --------------------------------------------------------------------
  -- Stimulus process
  --------------------------------------------------------------------
  stim_proc: process
  begin
    report "=== TB START ===";

    -- Fixed data pattern
    D0 <= '0';
    D1 <= '1';
    D2 <= '0';
    D3 <= '1';

    -- Iterate over all select combinations (00,01,10,11)
    for i in 0 to 3 loop
      S <= std_logic_vector(to_unsigned(i, 2));
      wait for 20 ns;

      report "S1=" & std_logic'image(S(1)) &
             "  S0=" & std_logic'image(S(0)) &
             "  D0=" & std_logic'image(D0) &
             "  D1=" & std_logic'image(D1) &
             "  D2=" & std_logic'image(D2) &
             "  D3=" & std_logic'image(D3) &
             "  -->  Y=" & std_logic'image(Y);
    end loop;

    -- Change data values and repeat
    report "=== Changing data pattern ===";
    D0 <= '1'; D1 <= '0'; D2 <= '1'; D3 <= '0';
    wait for 10 ns;

    for i in 0 to 3 loop
      S <= std_logic_vector(to_unsigned(i, 2));
      wait for 20 ns;

      report "S1=" & std_logic'image(S(1)) &
             "  S0=" & std_logic'image(S(0)) &
             "  D0=" & std_logic'image(D0) &
             "  D1=" & std_logic'image(D1) &
             "  D2=" & std_logic'image(D2) &
             "  D3=" & std_logic'image(D3) &
             "  -->  Y=" & std_logic'image(Y);
    end loop;

    report "=== TB DONE ===";
    wait;
  end process;

end architecture sim;
