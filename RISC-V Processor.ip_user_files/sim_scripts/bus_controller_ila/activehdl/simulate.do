onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+bus_controller_ila -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.bus_controller_ila xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {bus_controller_ila.udo}

run -all

endsim

quit -force
