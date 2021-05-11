onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib registers_ila_opt

do {wave.do}

view wave
view structure
view signals

do {registers_ila.udo}

run -all

quit -force
