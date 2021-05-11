onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib button_device_ila_opt

do {wave.do}

view wave
view structure
view signals

do {button_device_ila.udo}

run -all

quit -force
