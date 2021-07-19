library verilog;
use verilog.vl_types.all;
entity Ram is
    port(
        clk             : in     vl_logic;
        en              : in     vl_logic;
        addr            : in     vl_logic_vector(6 downto 0);
        data            : in     vl_logic_vector(7 downto 0);
        ram_out         : out    vl_logic_vector(7 downto 0)
    );
end Ram;
