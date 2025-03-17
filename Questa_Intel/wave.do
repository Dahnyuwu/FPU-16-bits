onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gray60 /FPU_TB/I0/I0/clk
add wave -noupdate -color Salmon /FPU_TB/I0/I0/rst
add wave -noupdate -color {Medium Slate Blue} /FPU_TB/I0/I0/start
add wave -noupdate -radix hexadecimal /FPU_TB/I0/data
add wave -noupdate -color Cyan /FPU_TB/I0/I0/state
add wave -noupdate -color Plum /FPU_TB/I0/I0/ready
add wave -noupdate -color Red /FPU_TB/I0/I0/error
add wave -noupdate /FPU_TB/I0/I0/op
add wave -noupdate -expand -group A -radix binary /FPU_TB/I0/I0/sa
add wave -noupdate -expand -group A -radix binary /FPU_TB/I0/I0/ea
add wave -noupdate -expand -group A -radix binary /FPU_TB/I0/I0/ma
add wave -noupdate -expand -group B -radix binary /FPU_TB/I0/I0/sb
add wave -noupdate -expand -group B -radix binary /FPU_TB/I0/I0/eb
add wave -noupdate -expand -group B -radix binary /FPU_TB/I0/I0/mb
add wave -noupdate -expand -group Out -radix binary /FPU_TB/I0/I0/st
add wave -noupdate -expand -group Out -radix binary /FPU_TB/I0/I0/et
add wave -noupdate -expand -group Out -radix binary /FPU_TB/I0/I0/mt
add wave -noupdate -expand -group Shift /FPU_TB/I0/I0/temp
add wave -noupdate -expand -group Registros -radix hexadecimal /FPU_TB/I0/RA/out
add wave -noupdate -expand -group Registros -radix hexadecimal /FPU_TB/I0/RB/out
add wave -noupdate -expand -group Registros /FPU_TB/I0/RO/out
add wave -noupdate -expand -group Registros -radix binary /FPU_TB/I0/RR/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2027 ns} 0} {{Cursor 2} {474 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 222
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {1260 ns}
