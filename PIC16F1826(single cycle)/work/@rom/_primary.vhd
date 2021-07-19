library verilog;
use verilog.vl_types.all;
entity Rom is
    port(
        Rom_addr_in     : in     vl_logic_vector(10 downto 0);
        Rom_data_out    : out    vl_logic_vector(13 downto 0)
    );
end Rom;
