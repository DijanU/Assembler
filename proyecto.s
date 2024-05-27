.equ RCC_AHB1ENR, 0x40023830  // Dirección del registro RCC AHB1ENR
.equ GPIOA_BASE, 0x40020000   // Dirección base del puerto GPIOA
.equ GPIOA_MODER, 0x00        // Desplazamiento del registro MODER
.equ GPIOA_ODR, 0x14          // Desplazamiento del registro ODR

.equ GPIOA_MODER_PA0_OUT, 0x01 << (2 * 0)  // PA0 configurado en modo salida
.equ GPIOA_MODER_PA1_OUT, 0x01 << (2 * 1)  // PA1 configurado en modo salida
.equ GPIOA_MODER_PA2_OUT, 0x01 << (2 * 2)  // PA2 configurado en modo salida
.equ GPIOA_MODER_PA3_OUT, 0x01 << (2 * 3)  // PA3 configurado en modo salida
.equ GPIOA_MODER_PA4_OUT, 0x01 << (2 * 4)  // PA4 configurado en modo salida

.equ GPIOA_ODR_PA0, 0x01 << 0  // PA0 output 
.equ GPIOA_ODR_PA1, 0x01 << 1  // PA1 output 
.equ GPIOA_ODR_PA2, 0x01 << 2  // PA2 output 
.equ GPIOA_ODR_PA3, 0x01 << 3  // PA3 output 
.equ GPIOA_ODR_PA4, 0x01 << 4  // PA4 output 

.equ    DELAY_COUNT, 4500000        // Aproximadamente 1.5 segundos de retardo (ajustar según la velocidad del reloj)

.global _start
_start:

    // Habilitar el reloj para GPIOA
    LDR R0, =RCC_AHB1ENR
    LDR R1, [R0]
    ORR R1, R1, #0x01
    STR R1, [R0]

    // Configurar PA0, PA1, PA2, PA3, PA4 en modo salida
    LDR R0, =GPIOA_BASE
    LDR R1, [R0, #GPIOA_MODER]
    ORR R1, R1, #(GPIOA_MODER_PA0_OUT | GPIOA_MODER_PA1_OUT | GPIOA_MODER_PA2_OUT | GPIOA_MODER_PA3_OUT | GPIOA_MODER_PA4_OUT)
    STR R1, [R0, #GPIOA_MODER]

    // Setear PA0, PA1, PA2, PA3, PA4 a 1
    LDR R1, [R0, #GPIOA_ODR]
    ORR R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3 | GPIOA_ODR_PA4)
    STR R1, [R0, #GPIOA_ODR]



loop:

    // Estado 1: PA0=1, PA1=1, PA2=0, PA3=1, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    BIC R1, R1, #(GPIOA_ODR_PA2)  // Clear PA2
    ORR R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA3 | GPIOA_ODR_PA4)  // Set PA0, PA1, PA3, PA4
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 2: PA0=1, PA1=0, PA2=1, PA3=1, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    ORR R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3 | GPIOA_ODR_PA4)  // Set PA0, PA2, PA3, PA4
    BIC R1, R1, #(GPIOA_ODR_PA1)  // Clear PA1
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 3: PA0=0, PA1=0, PA2=0, PA3=1, PA4=0
    LDR R1, [R0, #GPIOA_ODR]
    BIC R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA4)  // Clear PA0, PA1, PA2, PA4
    ORR R1, R1, #(GPIOA_ODR_PA3)  // Set PA3
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 4: PA0=1, PA1=1, PA2=1, PA3=1, PA4=0
    LDR R1, [R0, #GPIOA_ODR]
    BIC R1, R1, #(GPIOA_ODR_PA4)  // Clear PA4
    ORR R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3 )  // Set PA0, PA1, PA2, PA3
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 5: PA0=0, PA1=1, PA2=1, PA3=1, PA4=0
    LDR R1, [R0, #GPIOA_ODR]
    BIC R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA4)  // Clear PA0, PA4
    ORR R1, R1, #(GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3 )  // Set PA1, PA2, PA3
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 6: PA0=0, PA1=0, PA2=0, PA3=0, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    BIC R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA2 | GPIOA_ODR_PA3)  // Clear PA0, PA1, PA2, PA3
    ORR R1, R1, #(GPIOA_ODR_PA4)  // Set PA4
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    // Estado 7: PA0=1, PA1=0, PA2=1, PA3=0, PA4=1
    LDR R1, [R0, #GPIOA_ODR]
    BIC R1, R1, #(GPIOA_ODR_PA1 | GPIOA_ODR_PA3)  // Clear PA1, PA3
    ORR R1, R1, #(GPIOA_ODR_PA0 | GPIOA_ODR_PA2 | GPIOA_ODR_PA4 )  // Set PA0, PA2, PA4
    STR R1, [R0, #GPIOA_ODR]
    BL delay

    B loop

// Rutina de retardo
delay:
    ldr r3, =DELAY_COUNT
delay_loop:
    subs r3, r3, #1
    bne delay_loop
    bx lr

end:
	SWI	0
.section .data

    .align
    .end