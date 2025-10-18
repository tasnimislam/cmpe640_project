-- ============================================================
-- File : tb_fsm.vhd
-- Desc : Testbench for 'fsm' (drives all 4 cases, prints BUSY cycles)
-- ============================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ---------- Testbench entity (empty) ----------
entity tb_fsm is
end entity tb_fsm;

-- ---------- Testbench architecture ----------
architecture sim of tb_fsm is
  -- DUT ports/signals
  signal Clk        : std_logic := '0';
  signal nRst       : std_logic := '0';  -- start in reset (active-low)
  signal START      : std_logic := '0';
  signal CUT        : std_logic := '0';
  signal RD_WR_bar  : std_logic := '1';
  signal BUSY       : std_logic;

  constant TCLK     : time := 10 ns;     -- 100 MHz

begin
  -- Clock generator
  clk_gen : process
  begin
    while true loop
      Clk <= '0'; wait for TCLK/2;
      Clk <= '1'; wait for TCLK/2;
    end loop;
  end process clk_gen;

  -- DUT instantiation (make sure fsm.vhd is compiled first)
  DUT : entity work.fsm(rtl)
    generic map (
      ClockFrequencyHz => 50_000_000
    )
    port map (
      Clk       => Clk,
      nRst      => nRst,
      START     => START,
      CUT       => CUT,
      RD_WR_bar => RD_WR_bar,
      BUSY      => BUSY
    );

  -- Stimulus
  stim : process
    -- Pretty logger
    procedure log(msg : in string) is
    begin
      report "[" & integer'image(integer(now/1 ns)) & " ns] " & msg severity note;
    end procedure;

    -- Run one operation and count BUSY cycles
    procedure run_op(cut_val : in std_logic; rdwr_val : in std_logic; name : in string) is
      variable busy_cycles : natural := 0;
    begin
      CUT        <= cut_val;
      RD_WR_bar  <= rdwr_val;

      -- Align to rising edge and pulse START for 1 clock
      wait until rising_edge(Clk);
      START <= '1';
      wait until rising_edge(Clk);
      START <= '0';
      log("START " & name & " issued");

      -- If BUSY not yet high, wait until it asserts on a rising edge
      if BUSY = '0' then
        wait until rising_edge(Clk) and BUSY = '1';
      end if;

      -- Count BUSY high cycles
      while BUSY = '1' loop
        busy_cycles := busy_cycles + 1;
        wait until rising_edge(Clk);
      end loop;

      log(name & " completed. BUSY high cycles = " & integer'image(busy_cycles));
      wait for 3*TCLK; -- small gap
    end procedure;
  begin
    log("==== TB start ====");

    -- Hold reset low for a few clocks, then release
    nRst <= '0';
    wait for 5*TCLK;
    wait until rising_edge(Clk);
    nRst <= '1';
    log("Released reset");

    -- Idle settle
    START <= '0';
    CUT   <= '0';
    RD_WR_bar <= '1';
    wait for 3*TCLK;

    -- 1) READ-HIT  (CUT=1, RD_WR_bar=1)
    run_op('1', '1', "READ_HIT");

    -- 2) WRITE-HIT (CUT=1, RD_WR_bar=0)
    run_op('1', '0', "WRITE_HIT");

    -- 3) READ-MISS (CUT=0, RD_WR_bar=1)
    run_op('0', '1', "READ_MISS");

    -- 4) WRITE-MISS (CUT=0, RD_WR_bar=0)
    run_op('0', '0', "WRITE_MISS");

    log("==== TB done ====");
    wait for 10*TCLK;
    std.env.stop;     -- VHDL-2008 clean stop
    wait;
  end process stim;

end architecture sim;

