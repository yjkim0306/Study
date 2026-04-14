#include "msp.h"
#include "Clock.h"
#include <stdio.h>

void led_init(){
    P2->SEL0 &= ~0x07;
    P2->SEL1 &= ~0x07;

    P2->DIR |= 0x07;

    P2->OUT &= ~0x07;
}

void motor_init(void){
    P3->SEL0 &= ~0xC0;
    P3->SEL1 &= ~0xC0;
    P3->DIR |= 0xC0;
    P3->OUT &= ~0xC0;

    P5->SEL0 &= ~0x30;
    P5->SEL1 &= ~0x30;
    P5->DIR |= 0x30;
    P5->OUT &= ~0x30;

    P2->SEL0 &= ~0xC0;
    P2->SEL1 &= ~0xC0;
    P2->DIR |= 0xC0;
    P2->OUT &= ~0xC0;
}

void sensor_init(){
    P5->SEL0 &= ~0x08;
    P5->SEL1 &= ~0x08;
    P5->DIR |= 0x08;
    P5->OUT &= ~0x08;

    P9->SEL0 &= ~0x08;
    P9->SEL1 &= ~0x04;
    P9->DIR |= 0x04;
    P9->OUT &= ~0x04;

    P7->SEL0 &= ~0xFF;
    P7->SEL1 &= ~0xFF;
    P7->DIR &= ~0xFF;
}

void main(void)
{
    Clock_Init48MHz();
    led_init();
    sensor_init();
    motor_init();
    int speed = 8000;
    int sensor0=0;
    int sensor1=0;
    int sensor2=0;
    int sensor3=0;
    int sensor4=0;
    int sensor5=0;
    int sensor6=0;
    int sensor7=0;



    while(1){
        printf("%d %d\n", sensor3, sensor4);
        P5->OUT |= 0x08;
        P9->OUT |= 0x04;

        P7->DIR = 0xFF;
        P7->OUT = 0xFF;

        Clock_Delay1us(10);

        P7->DIR = 0x00;

        Clock_Delay1us(1000);

        sensor0 = P7->IN & 0x00;
        sensor1 = P7->IN & 0x02;
        sensor2 = P7->IN & 0x04;
        sensor3 = P7->IN & 0x08;
        sensor4 = P7->IN & 0x10;
        sensor5 = P7->IN & 0x20;
        sensor6 = P7->IN & 0x40;
        sensor7 = P7->IN & 0x80;


        if(sensor3 && sensor4){
            if(sensor1 && sensor2 && sensor5 && sensor6){
                P2->OUT &= ~0xC0;
            } else if(!sensor1 && !sensor2 && !sensor5 && !sensor6 && !sensor0 && !sensor7 ){
                P5->OUT &= ~0x30;
                P2->OUT |= 0xC0;
                P3->OUT |= 0xC0;
                Clock_Delay1us(speed);
                P2->OUT &= ~0xC0;
                Clock_Delay1us(10000-speed);
            }
        }


        P5->OUT &= ~0x08;
        P9->OUT &= ~0x04;

        Clock_Delay1ms(10);
    }
}
