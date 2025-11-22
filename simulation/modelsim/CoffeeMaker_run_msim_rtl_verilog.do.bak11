transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/LED_Animation.sv}
vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/CoffeeFSM.sv}
vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/ClockDivider.sv}
vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/DisplayDecoder.sv}
vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/CoffeeController.sv}
vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/Debounce.sv}

vlog -sv -work work +incdir+C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025 {C:/Users/irola/OneDrive/Escritorio/ProyectoArqui2025/CoffeeFSM_tb2.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  CoffeeFSM_tb2

add wave *
view structure
view signals
run -all
