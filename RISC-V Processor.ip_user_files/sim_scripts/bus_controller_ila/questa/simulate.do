onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib bus_controller_ila_opt

do {wave.do}

view wave
view structure
view signals

do {bus_controller_ila.udo}

run -all

quit -force
