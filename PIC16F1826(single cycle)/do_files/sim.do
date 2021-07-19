vsim -voptargs=+acc work.TestBench
view structure wave signals

do wave.do

log -r *
run -all

