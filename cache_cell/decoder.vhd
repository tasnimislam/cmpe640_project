library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    Port (
        enable : in STD_LOGIC;
        A0     : in STD_LOGIC;
        A1     : in STD_LOGIC;
        Y0     : out STD_LOGIC;
        Y1     : out STD_LOGIC;
        Y2     : out STD_LOGIC;
        Y3     : out STD_LOGIC
    );
end decoder;

architecture structural of decoder is

    -- Declare component inverter
    component inverter
        Port (
            input  : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

    -- Declare component and2
    component and2
        Port (
            input1 : in  STD_LOGIC;
            input2 : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

    -- Declare component and3
    component and3
        Port (
            input1 : in  STD_LOGIC;
            input2 : in  STD_LOGIC;
            input3 : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

    -- Internal signals for inverted inputs
    signal invert_A0 : STD_LOGIC;
    signal invert_A1 : STD_LOGIC;

begin

    -- Instantiate inverters
    invert_A0_here: inverter port map (input => A0, output => invert_A0);
    invert_A1_here: inverter port map (input => A1, output => invert_A1);

    -- Instantiate AND3 gates
    Y0_here: and3 port map (input1 => enable, input2 => invert_A0, input3 => invert_A1, output => Y0);
    Y1_here: and3 port map (input1 => enable, input2 => invert_A0, input3 => A1,        output => Y1);
    Y2_here: and3 port map (input1 => enable, input2 => A0,        input3 => invert_A1, output => Y2);
    Y3_here: and3 port map (input1 => enable, input2 => A0,        input3 => A1,        output => Y3);

end structural;

