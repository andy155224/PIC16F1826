onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TOP LEVEL INPUTS}

add wave -noupdate -format Logic    /TestBench/U_Cpu/clk
add wave -noupdate -format Logic    /TestBench/rst

#add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/U_Ram/ram[10]
#add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/U_Ram/ram[11]
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/w_out
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/pc_in
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/pc_out
add wave -noupdate -format Literal -radix hex        /TestBench/U_Cpu/ir_out
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/ram_out
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/intCon
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/addrToRam
add wave -noupdate -format Logic /TestBench/U_Cpu/interrupt2Cpu
add wave -noupdate -format Logic /TestBench/U_Cpu/haveInterrupt
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/ps
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/determinInterrupt
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/op

add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/U_Ram/ram
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/INTF
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/IOCIF
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/TMR0IF
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/T1/OPTION_REG
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/T1/ram_out
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/TMR_in
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/ns
add wave -noupdate -format Literal -radix unsigned   /TestBench/U_Cpu/T1/TMR0
add wave -noupdate -format Logic -radix binary   /TestBench/U_Cpu/T1/Sync2
add wave -noupdate -format Logic -radix binary   /TestBench/U_Cpu/T1/PSA_out
add wave -noupdate -format Logic -radix unsigned   /TestBench/U_Cpu/T1/PSA
#add wave -noupdate -format Logic -radix binary   /TestBench/U_Cpu/T1/PS
#add wave -noupdate -format Logic -radix binary   /TestBench/U_Cpu/T1/Prescaler
#add wave -noupdate -format Literal -radix unsign    /TestBench/U_Cpu/dd
add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/interrupt_in
#add wave -noupdate -format Literal -radix binary     /TestBench/U_Cpu/TMR0IF


#add wave -noupdate -format Literal -radix unsigned  /test_FileName/test_Signal
# -radix後接型態 十進位 decimal, 1bit logic, 十六進位 hex, 二進位 binary, 正整數 unsigned

