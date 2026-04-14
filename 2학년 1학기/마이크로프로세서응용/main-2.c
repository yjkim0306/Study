#include "msp.h"
#include "Clock.h"
#include <stdio.h>
#define LED_RED 1
#define LED_GREEN (LED_RED << 1)
#define LED_BLUE (LED_RED << 2)

void led_init() {
    // Set P2 as GPIO
    P2->SEL0 &= ~0x07;
    P2->SEL1 &= ~0x07;

    // Input or Output
    // Current type is output
    P2->DIR |= 0x07;

    // Turn off LED
    P2->OUT &= ~0x07;
}

void turn_on_led(int color) {
    P2->OUT &= ~0x07;
    P2->OUT |= color;
}

void turn_off_led() {
    P2->OUT &= ~0x07;
}

void switch_init() {
    // Setup switch as GPIO
    P1->SEL0 &= ~0x12;
    P1->SEL1 &= ~0x12;

    // Setup switch as Input
    P1->DIR &= ~0x12;

    // Enable pull-up resistors
    P1->REN |= 0x12;

    // Now pull-up
    P1->OUT |= 0x12;
}

void main(void) {

    int sw1;

    // Clock initialization
    Clock_Init48MHz();

    // LED Initialization
    led_init();

    // Switch Initialization
    switch_init();

    int color = LED_RED;
    int count = 1;

    while(1) {
        sw1 = P1->IN & 0x02;
        if(!sw1){
            while(!sw1){
                turn_on_led(color);
                sw1 = P1->IN & 0x02;
            }
            turn_off_led();
            if(count==1){
                color = LED_GREEN;
                printf("red -> green\n");
                count++;
            } else if(count==2){
                color = LED_BLUE;
                printf("green -> blue\n");
                count++;
            } else if(count==3){
                color = LED_RED;
                printf("blue -> red\n");
                count = 1;
            }
        }

    }
}
