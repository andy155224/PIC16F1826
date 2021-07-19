library verilog;
use verilog.vl_types.all;
entity Cpu is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        INT_in          : in     vl_logic;
        IOC_in          : in     vl_logic;
        RA4             : in     vl_logic;
        w_out           : out    vl_logic_vector(7 downto 0)
    );
end Cpu;
