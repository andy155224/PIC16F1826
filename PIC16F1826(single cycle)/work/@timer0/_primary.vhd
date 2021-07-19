library verilog;
use verilog.vl_types.all;
entity Timer0 is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        RA4             : in     vl_logic;
        OPTION_REG_in   : in     vl_logic_vector(7 downto 0);
        TMRFLAG         : out    vl_logic
    );
end Timer0;
