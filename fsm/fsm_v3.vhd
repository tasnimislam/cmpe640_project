library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
  generic (
    ClockFrequencyHz : integer := 50_000_000  -- (optional/unused here)
  );
  port (
    Clk       : in  std_logic;
    nRst      : in  std_logic;   -- Active-low reset
    START     : in  std_logic;
    CUT       : in  std_logic;   -- 1 = hit path, 0 = miss path (per your naming)
    RD_WR_bar : in  std_logic;   -- 1 = Read, 0 = Write
    BUSY      : out std_logic;
    
    READ_HIT  : out std_logic;
    WRITE_HIT : out std_logic;
    READ_MISS : out std_logic;
    WRITE_MISS: out std_logic
  );
end fsm;

architecture rtl of fsm is

  type t_State is (
    IDLE,
    BUSY_DE,
    DONE
  );

  signal State : t_State := IDLE;

  -- Per-state cycle counters (registered)
  signal READ_HIT_CNT   : natural := 0;
  signal READ_MISS_CNT  : natural := 0;
  signal WRITE_HIT_CNT  : natural := 0;
  signal WRITE_MISS_CNT : natural := 0;

  -- Registered BUSY
  signal busy_r : std_logic := '0';

begin
  BUSY <= busy_r;

  process (Clk, nRst)
  begin
    if nRst = '0' then
      -- Asynchronous reset
      State           <= IDLE;
      busy_r          <= '0';
      READ_HIT_CNT    <= 0;
      READ_MISS_CNT   <= 0;
      WRITE_HIT_CNT   <= 0;
      WRITE_MISS_CNT  <= 0;

    elsif rising_edge(Clk) then
      case State is

        when IDLE =>
          busy_r <= '0';

          -- Clear counters while idle
          READ_HIT_CNT    <= 0;
          READ_MISS_CNT   <= 0;
          WRITE_HIT_CNT   <= 0;
          WRITE_MISS_CNT  <= 0;

          if START = '1' then
            busy_r <= '1';
            if CUT = '1' then              -- hit path
              if RD_WR_bar = '1' then
                State <= READ_HIT;
              else
                State <= WRITE_HIT;
              end if;
            else                           -- miss path
              if RD_WR_bar = '1' then
                State <= READ_MISS;
              else
                State <= WRITE_MISS;
              end if;
            end if;
          end if;

        -- READ_HIT lasts 2 cycles total (as in your original)
        when READ_HIT =>
          READ_HIT_CNT <= READ_HIT_CNT + 1;
          if READ_HIT_CNT = 0 then        -- 0->1 (2 cycles incl. entry)
            State <= BUSY_DE;
          end if;

        when BUSY_DE =>
          busy_r <= '0';
          State  <= DONE;

        -- WRITE_HIT lasts 3 cycles total (match original threshold = 3)
        when WRITE_HIT =>
          WRITE_HIT_CNT <= WRITE_HIT_CNT + 1;
          if WRITE_HIT_CNT = 1 then       -- 0,1,2 -> 3 cycles
            State <= DONE;
          end if;

        -- READ_MISS lasts 19 cycles total (match original threshold = 19)
        when READ_MISS =>
          READ_MISS_CNT <= READ_MISS_CNT + 1;
          if READ_MISS_CNT = 17 then      -- 0..18 -> 19 cycles
            State <= DONE;
          end if;

        -- WRITE_MISS lasts 3 cycles total (match original threshold = 3)
        when WRITE_MISS =>
          WRITE_MISS_CNT <= WRITE_MISS_CNT + 1;
          if WRITE_MISS_CNT = 1 then      -- 0,1,2 -> 3 cycles
            State <= DONE;
          end if;

        when DONE =>
          busy_r <= '0';
          State  <= IDLE;

      end case;
    end if;
  end process;

end;

