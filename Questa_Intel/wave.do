onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FPU_TB/I0/baudRateOut
add wave -noupdate /FPU_TB/I0/rst
add wave -noupdate -group Rx /FPU_TB/I0/I3/state
add wave -noupdate -group Rx /FPU_TB/I0/rx
add wave -noupdate -group Rx -radix binary /FPU_TB/I0/I4/out
add wave -noupdate -expand -group Data -radix hexadecimal /FPU_TB/DATA0
add wave -noupdate -expand -group Data -radix hexadecimal /FPU_TB/DATA1
add wave -noupdate -expand -group Data -radix hexadecimal /FPU_TB/DATA2
add wave -noupdate -expand -group Data -radix binary /FPU_TB/I0/RR/out
add wave -noupdate /FPU_TB/I0/rxFlag16
add wave -noupdate /FPU_TB/I0/IRx/cnt
add wave -noupdate /FPU_TB/I0/IRx2/cnt
add wave -noupdate /FPU_TB/I0/I0/start
add wave -noupdate /FPU_TB/I0/I0/state
add wave -noupdate /FPU_TB/I0/I2/tx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {639460 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 221
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1260 us}
