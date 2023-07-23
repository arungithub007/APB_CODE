onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/intf/clk
add wave -noupdate /tb_top/intf/rst_n
add wave -noupdate /tb_top/intf/paddr
add wave -noupdate /tb_top/intf/pwrite
add wave -noupdate /tb_top/intf/psel
add wave -noupdate /tb_top/intf/penable
add wave -noupdate /tb_top/intf/pwdata
add wave -noupdate /tb_top/intf/prdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {110 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {263 ns}
