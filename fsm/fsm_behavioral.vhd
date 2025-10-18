-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fsm_behavioral is
  generic (ClockFrequencyHz: integer);
  Port(
    Clk: in std_logic;
    nRst: in std_logic; --Negative Reset

    START: in std_logic;
    BUSY: out std_logic;
    CUT: in std_logic;
    RD_WR_bar: in std_logic

  );
end fsm;

architecture rtl of fsm_behavioral is

  -- Definition inverter
  component inverter

  port (
    input    : in  std_logic;
    output   : out std_logic);
  end component;
  
  component and2

  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
  end component;
  
  component and3
  Port ( input1 : in  STD_LOGIC;
         input2 : in  STD_LOGIC;
         input3 : in  STD_LOGIC;
         output : out STD_LOGIC);
  end component;

  -- Enumerated type declaration and state signal declaration
  type t_State is (IDLE,
		  READ_HIT, DLY_0, BUSY_DE,
                  WRITE_HIT, DLY_1, 
                  READ_MISS, DLY_2,
                  WRITE_MISS, DLY_3,
                  DONE
                  );
  signal State: t_State;
  
  signal invert_BUSY: STD_LOGIC;
  signal READ_HIT_LOGIC: STD_LOGIC;
  signal WRITE_HIT_LOGIC: STD_LOGIC;
  signal READ_MISS_LOGIC: STD_LOGIC;
  signal WRITE_MISS_LOGIC: STD_LOGIC;
  
  signal invert_START: STD_LOGIC;
  signal invert_CUT: STD_LOGIC;
  signal invert_RD_WR_bar: STD_LOGIC;
  
  signal READ_HIT_LOGIC_AND_START: STD_LOGIC;
  signal WRITE_HIT_LOGIC_AND_START: STD_LOGIC;
  

begin
  invert_my_busy: inverter port map(input=> START, output=> invert_BUSY);
  invert_my_start: inverter port map(input=> START, output=> invert_START);
  invert_my_cut: inverter port map(input=> CUT, output=> invert_CUT);
  invert_my_rd_wr: inverter port map(input=> RD_WR_bar, output=> invert_RD_WR_bar);
  
  BUSY<= START;
  start_1_cut_1_rdwr_1: and3 port map(input1=> START, input2=> CUT, input3=> RD_WR_bar, output=> READ_HIT_LOGIC);
  start_1_cut_1_rdwr_0: and3 port map(input1=> START, input2=> CUT, input3=> invert_RD_WR_bar, output=> WRITE_HIT_LOGIC);
  start_1_cut_0_rdwr_1: and3 port map(input1=> START, input2=> invert_CUT, input3=> RD_WR_bar, output=> READ_MISS_LOGIC);
  start_1_cut_0_rdwr_0: and3 port map(input1=> START, input2=> invert_CUT, input3=> invert_RD_WR_bar, output=> WRITE_MISS_LOGIC);
    
  process(Clk)
  begin
    if rising_edge(Clk) then
      if nRst = '0' then
        -- Reset values
        
        -- When everything is done, go to IDLE
        -- (It can be either IDLE or DONE)
        if (START='0') then
          State<=IDLE;
        end if;



      else
        Case State is
          When IDLE=>
            State <= DONE;

            if READ_HIT_LOGIC='1' then
              State <= READ_HIT;
            end if;

            if WRITE_HIT_LOGIC='1' then
              State <= WRITE_HIT;
            end if;

            if READ_MISS_LOGIC='1' then
              State <= READ_MISS;
            end if;

            if WRITE_MISS_LOGIC='1' then
              State <= WRITE_MISS;
            end if;


          -- Read Hit
          When READ_HIT =>
            State <= DLY_0;
          When DLY_0 =>
            State <= BUSY_DE;
          When BUSY_DE =>
            
            BUSY<= invert_BUSY;
            State <= DONE;

          -- Write Hit
          When WRITE_HIT =>
            State <= DLY_1;
          When DLY_1 =>
            State <= DONE;

          -- Read Miss
          When READ_MISS =>
            State <= DLY_2;
          When DLY_2 =>
            State <= DONE;

          -- Write Miss
          When WRITE_MISS =>
            STATE <= DLY_3;
          When DLY_3 =>
            STATE <= DONE;
          When DONE =>
            State <= IDLE;
        end case;


      end if;
    end if;
  end process;
  
end;


