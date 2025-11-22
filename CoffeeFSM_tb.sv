`timescale 1ns/1ps

module CoffeeFSM_tb;

    logic clk;
    logic reset;
    logic start;
    logic [1:0] coffee_sel;
    logic [2:0] state;
    logic done;

    // Señales para el clock dividido
    logic slow_clk;
    
    // Instanciar el mismo ClockDivider que usas en el diseño
    ClockDivider #(.DIV(50)) clk_div (  // DIV pequeño para simulación rápida
        .clk(clk),
        .reset(reset),
        .clk_out(slow_clk)
    );

    // La FSM conectada al slow_clk (como en tu diseño original)
    CoffeeFSM dut (
        .clk(slow_clk),  // Conectada al slow_clk
        .reset(reset),
        .start(start),
        .coffee_sel(coffee_sel),
        .state(state),
        .done(done)
    );

    // Generador de reloj principal (100MHz)
    always #5 clk = ~clk;

    task print_status;
        string state_name;
        case(dut.current)
            dut.IDLE:   state_name = "IDLE";
            dut.AGUA:   state_name = "AGUA";
            dut.CAFE:   state_name = "CAFE"; 
            dut.LECHE:  state_name = "LECHE";
            dut.AZUCAR: state_name = "AZUCAR";
            dut.CREMA:  state_name = "CREMA";
            dut.END:    state_name = "END";
            default:    state_name = "UNKNOWN";
        endcase
        $display("[%0t] state=%s (%0d) done=%0b sel=%b timer=%0d",
                 $time, state_name, dut.current, done, coffee_sel, dut.timer);
    endtask

    task make_coffee(input [1:0] sel);
    begin
        coffee_sel = sel;

        // Esperar a que esté en IDLE
        wait(dut.current == dut.IDLE);
        @(negedge slow_clk);  // Usar slow_clk para sincronización
        
        // Pulso de start (1 ciclo de slow_clk)
        start = 1;
        @(negedge slow_clk);
        start = 0;

        $display("\n--- Iniciando preparación sel=%b ---", sel);
        print_status();

        // Esperar a que termine TODO el proceso (vuelva a IDLE)
        wait(dut.current == dut.IDLE);
        
        $display("--- Preparación completada sel=%b ---", sel);
        print_status();
        
        // Esperar un poco antes de la siguiente prueba
        repeat(5) @(posedge slow_clk);
    end
    endtask

    initial begin
        $display("Iniciando simulación del CoffeeFSM...");
        clk = 0;
        reset = 1;
        start = 0;
        coffee_sel = 2'b00;

        // Aplicar reset
        $display("[%0t] Aplicando reset...", $time);
        repeat(10) @(posedge clk);
        reset = 0;
        repeat(5) @(posedge clk);

        $display("\n=== PRUEBA ESPRESSO (sel=00) ===");
        make_coffee(2'b00);

        $display("\n=== PRUEBA LATTE (sel=01) ===");
        make_coffee(2'b01);

        $display("\n=== PRUEBA CAPPUCCINO (sel=10) ===");
        make_coffee(2'b10);

        $display("\n=== TODAS LAS PRUEBAS COMPLETADAS ===");
        $display("Simulación terminada exitosamente.");
        $stop;
    end

    // Monitor para cambios de estado automático
    always @(dut.current) begin
        if ($time > 0) begin  // Evitar mensajes durante el reset inicial
            print_status();
        end
    end

endmodule
