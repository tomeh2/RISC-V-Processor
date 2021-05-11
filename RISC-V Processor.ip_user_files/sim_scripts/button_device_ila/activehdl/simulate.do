onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+button_device_ila -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.button_device_ila xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {button_device_ila.udo}

run -all

endsim

quit -force
