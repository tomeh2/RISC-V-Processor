onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+registers_ila -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.registers_ila xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {registers_ila.udo}

run -all

endsim

quit -force
