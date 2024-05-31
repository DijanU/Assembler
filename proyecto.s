/*****************************************************************************
* Autor: David Dominguez, Gabriel Bran, Luis Padilla
* Fecha: 31/05/2024
*
* Descripción:
* Este programa configura los pines PA0, PA1, PA4, PA8 y PA9 del puerto GPIOA
* como salidas en un microcontrolador STM32. Luego, se ejecuta un ciclo
* infinito donde se encienden y apagan estos pines de forma secuencial,
* creando un patrón de luces específico, que dan la señal al display.
*
* Elementos utilizados:
* R0: Apunta a la dirección base del puerto GPIOA y al registro RCC_AHB1ENR.
* R1: Almacena el valor del registro GPIOA_MODER y GPIOA_ODR. Se utiliza como registro temporal.
* R2: Se utiliza como máscara para habilitar los bits correspondientes. También como registro temporal.
* R3: Se utiliza como contador en la rutina de retardo.
* RCC_AHB1ENR: Registro de habilitación de reloj para el bus AHB1, utilizado para habilitar el reloj del puerto GPIOA.
* GPIOA_BASE: Dirección base del puerto GPIOA.
* GPIOA_MODER: Registro de modo de configuración de pines del puerto GPIOA.
* GPIOA_ODR: Registro de datos de salida del puerto GPIOA.
* GPIOA_MODER_PA0_OUT, GPIOA_MODER_PA1_OUT, GPIOA_MODER_PA4_OUT, GPIOA_MODER_PA8_OUT, GPIOA_MODER_PA9_OUT: Máscaras de bits para configurar los pines correspondientes en modo salida.
* GPIOA_ODR_PA0, GPIOA_ODR_PA1, GPIOA_ODR_PA4, GPIOA_ODR_PA8, GPIOA_ODR_PA9: Máscaras de bits para establecer el valor de salida de los pines correspondientes.
* DELAY_COUNT: Valor utilizado para ajustar el tiempo de retardo en la rutina de retardo.
*
*****************************************************************************/

.equ RCC_AHB1ENR, 0x40023830  // Dirección del registro RCC AHB1ENR
.equ GPIOA_BASE, 0x40020000   // Dirección base del puerto GPIOA
.equ GPIOA_MODER, 0x00        // Desplazamiento del registro MODER
.equ GPIOA_ODR, 0x14          // Desplazamiento del registro ODR

.equ GPIOA_MODER_PA0_OUT, 0x01 << (2 * 0)  // PA0 configurado en modo salida
.equ GPIOA_MODER_PA1_OUT, 0x01 << (2 * 1)  // PA1 configurado en modo salida
.equ GPIOA_MODER_PA4_OUT, 0x01 << (2 * 4)  // PA4 configurado en modo salida
.equ GPIOA_MODER_PA8_OUT, (1 << 16)        // PA8 configurado en modo salida
.equ GPIOA_MODER_PA9_OUT, (1 << 18)        // PA9 configurado en modo salida

.equ GPIOA_ODR_PA0, 0x01 << 0  // PA0 output
.equ GPIOA_ODR_PA1, 0x01 << 1  // PA1 output
.equ GPIOA_ODR_PA4, 0x01 << 4  // PA4 output
.equ GPIOA_ODR_PA8, 0x01 << 8  // PA8 output
.equ GPIOA_ODR_PA9, 0x01 << 9  // PA9 output

.equ DELAY_COUNT, 4500000        // Aproximadamente 1.5 segundos de retardo (ajustar según la velocidad del reloj)

.global _main
_main:

    // Habilitar el reloj para GPIOA
    LDR R0, =RCC_AHB1ENR        // Carga en R0 la dirección del registro RCC AHB1ENR
    LDR R1, [R0]                // Carga en R1 el contenido del registro RCC AHB1ENR
    MOV R2, #0x01               // Mueve el valor hexadecimal 0x01 a R2
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0]                // Almacena el valor de R1 en la dirección de memoria apuntada por R0

    // Configurar PA0, PA1, PA9, PA8, PA9 en modo salida
    LDR R0, =GPIOA_BASE         // Carga en R0 la dirección base del puerto GPIOA
    LDR R1, [R0, #GPIOA_MODER]  // Carga en R1 el contenido del registro MODER del puerto GPIOA

    LDR R2, =GPIOA_MODER_PA0_OUT | GPIOA_MODER_PA1_OUT | GPIOA_MODER_PA4_OUT | GPIOA_MODER_PA8_OUT | GPIOA_MODER_PA9_OUT  // Carga en R2 el valor de configuración para los pines PA0, PA1, PA4, PA8, PA9
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_MODER]  // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_MODER

    // Setear PA0, PA1, PA4, PA8, PA9 a 1
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA4 | GPIOA_ODR_PA8 | GPIOA_ODR_PA9  // Carga en R2 el valor para setear los pines PA0, PA1, PA4, PA8, PA9
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR

loop:

    // Estado 1: PA0=1, PA1=1, PA4=0, PA8=1, PA9=1
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    MOV R2, #GPIOA_ODR_PA4      // Mueve el valor de GPIOA_ODR_PA4 a R2
    BIC R1, R1, R2              // Realiza una operación AND bit a bit entre R1 y el complemento de R2, almacenando el resultado en R1
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA8 | GPIOA_ODR_PA9  // Carga en R2 el valor para setear los pines PA0, PA1, PA8, PA9
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR
    BL delay                    // Llama a la subrutina delay

    // Estado 2: PA0=1, PA1=0, PA4=1, PA8=1, PA9=1
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA4 | GPIOA_ODR_PA8 | GPIOA_ODR_PA9  // Carga en R2 el valor para setear los pines PA0, PA4, PA8, PA9
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    MOV R2, #GPIOA_ODR_PA1      // Mueve el valor de GPIOA_ODR_PA1 a R2
    BIC R1, R1, R2              // Realiza una operación AND bit a bit entre R1 y el complemento de R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR
    BL delay                    // Llama a la subrutina delay

    // Estado 3: PA0=0, PA1=0, PA4=0, PA8=1, PA9=0
    // Estado 3: PA0=0, PA1=0, PA4=0, PA8=1, PA9=0
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA4 | GPIOA_ODR_PA9  // Carga en R2 el valor para setear los pines PA0, PA1, PA4, PA9
    BIC R1, R1, R2              // Realiza una operación AND bit a bit entre R1 y el complemento de R2, almacenando el resultado en R1
    LDR R2, =GPIOA_ODR_PA8      // Carga en R2 el valor para setear el pin PA8
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR
    BL delay                    // Llama a la subrutina delay

    // Estado 4: PA0=1, PA1=1, PA4=1, PA8=1, PA9=0
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    LDR R2, =GPIOA_ODR_PA9      // Carga en R2 el valor para setear el pin PA9
    LDR R2, [R2]                // Carga el contenido de la dirección apuntada por R2 en R2
    BIC R1, R1, R2              // Realiza una operación AND bit a bit entre R1 y el complemento de R2, almacenando el resultado en R1
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA4 | GPIOA_ODR_PA8  // Carga en R2 el valor para setear los pines PA0, PA1, PA4, PA8
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR
    BL delay                    // Llama a la subrutina delay

    // Estado 5: PA0=0, PA1=1, PA4=1, PA8=1, PA9=0
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA9  // Carga en R2 el valor para setear los pines PA0, PA9
    BIC R1, R1, R2              // Realiza una operación AND bit a bit entre R1 y el complemento de R2, almacenando el resultado en R1
    LDR R2, =GPIOA_ODR_PA1 | GPIOA_ODR_PA4 | GPIOA_ODR_PA8  // Carga en R2 el valor para setear los pines PA1, PA4, PA8
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR
    BL delay                    // Llama a la subrutina delay

    // Estado 6: PA0=0, PA1=0, PA4=0, PA8=0, PA9=1
    LDR R1, [R0, #GPIOA_ODR]    // Carga en R1 el contenido del registro ODR del puerto GPIOA
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA1 | GPIOA_ODR_PA4 | GPIOA_ODR_PA8  // Carga en R2 el valor para setear los pines PA0, PA1, PA4, PA8
    BIC R1, R1, R2              // Realiza una operación AND bit a bit entre R1 y el complemento de R2, almacenando el resultado en R1
    LDR R2, =GPIOA_ODR_PA9      // Carga en R2 el valor para setear el pin PA9
    ORR R1, R1, R2              // Realiza una operación OR bit a bit entre R1 y R2, almacenando el resultado en R1
    STR R1, [R0, #GPIOA_ODR]    // Almacena el valor de R1 en la dirección de memoria apuntada por R0, con un desplazamiento indicado por GPIOA_ODR
    BL delay                    // Llama a la subrutina delay


    // Estado 7: PA0=1, PA1=0, PA4=1, PA8=0, PA9=1
    LDR R1, [R0, #GPIOA_ODR]
    LDR R2, =GPIOA_ODR_PA1 | GPIOA_ODR_PA8
    BIC R1, R1, R2  // Clear PA1, PA8
    LDR R2, =GPIOA_ODR_PA0 | GPIOA_ODR_PA4 | GPIOA_ODR_PA9
    ORR R1, R1, R2  // Set PA0, PA4, PA9
    STR R1, [R0, #GPIOA_ODR]
    BL delay              // Llama a la subrutina delay

    B loop                      // Salta a la etiqueta loop para repetir el bucle

// Rutina de retardo
delay:
    LDR R3, =DELAY_COUNT        // Carga en R3 el valor de la constante DELAY_COUNT
delay_loop:
    SUB R3, R3, #1              // Resta 1 al contenido de R3 y almacena el resultado en R3
    CMP R3, #0                  // Compara el contenido de R3 con 0
    BNE delay_loop              // Salta a delay_loop si el resultado de la comparación no es igual a cero
    BX LR                       // Retorna de la subrutina y salta de vuelta al código que la llamó

end:
    SWI 0                       // Llamada al sistema para finalizar el programa
.section .data

    GPIOA_MODER_PA8_OUT: .word  0x10000  // Configuración del pin PA8 como salida
    GPIOA_MODER_PA9_OUT: .word  0x40000  // Configuración del pin PA9 como salida

    .align
    .end
