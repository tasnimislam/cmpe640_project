-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fsm is
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

architecture rtl of fsm is

  -- Enumerated type declaration and state signal declaration
  type t_State is (IDLE,
		  READ_HIT, DLY_0, BUSY_DE,
                  WRITE_HIT, DLY_1, 
                  READ_MISS, DLY_2,
                  WRITE_MISS, DLY_3,
                  DONE
                  );
  signal State: t_State;

begin
  process(Clk)
  begin
    if rising_edge(Clk) then
      if nRst = '0' then
        -- Reset values
        
        -- When everything is done, go to IDLE
        -- (It can be either IDLE or DONE)
        if (START='0') then
          State<=IDLE;
            BUSY<= '0';
        end if;



      else
        Case State is
          When IDLE=>
            State <= DONE;

            if (START='1' and CUT='1' and RD_WR_bar='1') then
              BUSY <= '1';
              State <= READ_HIT;
            end if;

            if (START='1' and CUT='1' and RD_WR_bar='0') then
              BUSY <= '1';
              State <= WRITE_HIT;
            end if;

            if (START='1' and CUT='0' and RD_WR_bar='1') then
              BUSY <= '1';
              State <= READ_MISS;
            end if;

            if (START='1' and CUT='0' and RD_WR_bar='0') then
              BUSY <= '1';
              State <= WRITE_MISS;
            end if;


          -- Read Hit
          When READ_HIT =>
            State <= DLY_0;
          When DLY_0 =>
            State <= BUSY_DE;
          When BUSY_DE =>
            BUSY <= '0';
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


