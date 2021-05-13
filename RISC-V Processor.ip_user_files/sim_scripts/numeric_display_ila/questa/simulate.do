onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib numeric_display_ila_opt

do {wave.do}

view wave
view structure
view signals

do {numeric_display_ila.udo}

run -all

quit -force
