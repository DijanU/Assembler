.equ RCC_AHB1ENR, 0x40023830  // Dirección del registro RCC AHB1ENR
.equ GPIOA_BASE, 0x40020000   // Dirección base del puerto GPIOA
.equ GPIOA_MODER, 0x00        // Desplazamiento del registro MODER
.equ GPIOA_ODR, 0x14          // Desplazamiento del registro ODR

.equ GPIOA_MODER_PA0_OUT, 0x01 << (2 * 0)  // PA0 configurado en modo salida
.equ GPIOA_MODER_PA1_OUT, 0x01 << (2 * 1)  // PA1 configurado en modo salida
.equ GPIOA_MODER_PA2_OUT, 0x01 << (2 * 4)  // PA2 configurado en modo salida
.equ GPIOA_MODER_PA3_OUT, (1 << 16)  // PA3 configurado en modo salida
.equ GPIOA_MODER_PA4_OUT, (1 << 18)  // PA4 configurado en modo salida

.equ GPIOA_ODR_PA0, 0x01 << 0  // PA0 output
.equ GPIOA_ODR_PA1, 0x01 << 1  // PA1 output
.equ GPIOA_ODR_PA2, 0x01 << 4  // PA2 output
.equ GPIOA_ODR_PA3, 0x01 << 8  // PA3 output
.equ GPIOA_ODR_PA4, 0x01 << 9  // PA4 output

.equ DELAY_COUNT, 4500000        // Aproximadamente 1.5 segundos de retardo (ajustar según la velocidad del reloj)

.global _main
_main:

    // Habilitar el reloj para GPIOA
    LDR R0, =RCC_AHB1ENR
    LDR R1, [R0]
    MOV R2, #0x01
    ORR R1, R1, R2
    STR R1, [R0]

    // Configurar PA0, PA1, PA2, PA3, PA4 en modo salida
    LDR R0, =GPIOA_BASE
    LDR R1, [R0, #GPIOA_MODER]

    LDR R2, =GPIOA_MODER_PA0_OUT | GPIOA_MODER_PA1_OUT | GPIOA_MODER_PA2_OUT | GPIOA_MODER_PA3_OUT | GPIOA_MODER_PA4_OUT
    ORR R1, R1, R2
    STR R1, [R0, #GPIOA_MODER]

    // Setear PA0, PA1, PA2, PA3, PA4 a 1
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3 | GPIOA_ODR_PA4
    ORR R1, R1, R2
    STR R1, [R0, #GPIOA_ODR]

loop:

    // Estado 1: PA0=1, PA1=1, PA2=0, PA3=1, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    MOV R2, #GPIOA_ODR_PA2
    BIC R1, R1, R2  // Clear PA2
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA3 | GPIOA_ODR_PA4
    ORR R1, R1, R2  // Set PA0, PA1, PA3, PA4
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 2: PA0=1, PA1=0, PA2=1, PA3=1, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3 | GPIOA_ODR_PA4
    ORR R1, R1, R2  // Set PA0, PA2, PA3, PA4
    MOV R2, #GPIOA_ODR_PA1
    BIC R1, R1, R2  // Clear PA1
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 3: PA0=0, PA1=0, PA2=0, PA3=1, PA4=0 NO SE APAGA EL 0 ni el 4
    // Estado 3: PA0=0, PA1=0, PA2=0, PA3=1, PA4=0
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA4
    BIC R1, R1, R2  // Clear PA0, PA1, PA2, PA4
    LDR R2, =GPIOA_ODR_PA3
    ORR R1, R1, R2  // Set PA3
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 4: PA0=1, PA1=1, PA2=1, PA3=1, PA4=0
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA4
    LDR R2, [R2]
    BIC R1, R1, R2  // Clear PA4
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3
    ORR R1, R1, R2  // Set PA0, PA1, PA2, PA3
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 5: PA0=0, PA1=1, PA2=1, PA3=1, PA4=0
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA4
    BIC R1, R1, R2  // Clear PA0, PA4
    LDR R2, =GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3
    ORR R1, R1, R2  // Set PA1, PA2, PA3
    STR R1, [R0, #GPIOA_ODR]
    BL delay


    // Estado 6: PA0=0, PA1=0, PA2=0, PA3=0, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3
    BIC R1, R1, R2  // Clear PA0, PA1, PA2, PA3
    LDR R2, =GPIOA_ODR_PA4
    ORR R1, R1, R2  // Set PA4
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 7: PA0=1, PA1=0, PA2=1, PA3=0, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA1 | GPIOA_ODR_PA3
    BIC R1, R1, R2  // Clear PA1, PA3
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA2 | GPIOA_ODR_PA4
    ORR R1, R1, R2  // Set PA0, PA2, PA4
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    B loop

// Rutina de retardo
delay:
    LDR R3, =DELAY_COUNT
delay_loop:
    SUB R3, R3, #1
    CMP R3, #0
    BNE delay_loop
    BX LR

end:
    SWI 0
.section .data

	GPIOA_MODER_PA3_OUT: .word  0x10000
	GPIOA_MODER_PA4_OUT: .word  0x40000


    .align
    .end
