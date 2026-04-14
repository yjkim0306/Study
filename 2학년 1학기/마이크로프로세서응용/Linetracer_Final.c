#include "msp.h"
#include "Clock.h"
#include <stdio.h>

#define LED_RED 1
#define LED_GREEN (LED_RED << 1)
#define LED_BLUE (LED_RED << 2)

void led_init(){
    P2->SEL0 &= ~0x07;
    P2->SEL1 &= ~0x07;

    P2->DIR |= 0x07;

    P2->OUT &= ~0x07;
}

void turn_on_led(int color){
    P2->OUT &= ~0x07;
    P2->OUT |= color;
}

void turn_off_led(){
    P2->OUT &= ~0x07;
}

void systick_init(void){
    SysTick -> LOAD = 0x00FFFFFF;
    SysTick -> CTRL = 0x00000005;
}

void systick_wait1ms(){
    SysTick -> LOAD = 0xBB80;
    SysTick -> VAL = 0;
    while((SysTick->CTRL & 0x00010000)==0) {};
}

void systick_wait3s(){
    int i;
    int count = 3000;

    for(i = 0; i < count; i++){
        systick_wait1ms();
    }
}

void pwm_init34(uint16_t period, uint16_t duty3, uint16_t duty4){
    TIMER_A0 -> CCR[0] = period;

    TIMER_A0 -> EX0 = 0x0000;

    TIMER_A0 -> CCTL[3] = 0x0040;
    TIMER_A0 -> CCR[3] = duty3;
    TIMER_A0 -> CCTL[4] = 0x0040;
    TIMER_A0 -> CCR[4] = duty4;

    TIMER_A0 -> CTL = 0x02F0;

    P2 -> DIR |= 0xC0;
    P2 -> SEL0 |= 0xC0;
    P2 -> SEL1 &= ~0xC0;
}

void sensor_init(){
    P5->SEL0 &= ~0x08;
    P5->SEL1 &= ~0x08;
    P5->DIR |= 0x08;
    P5->OUT &= ~0x08;

    P9->SEL0 &= ~0x04;
    P9->SEL1 &= ~0x04;
    P9->DIR |= 0x04;
    P9->OUT &= ~0x04;

    P7->SEL0 &= ~0xFF;
    P7->SEL1 &= ~0xFF;
    P7->DIR &= ~0xFF;
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

    pwm_init34(7500, 0, 0);
}

void timer_A3_capture_init(){
    P10 -> SEL0 |= 0x30;
    P10 -> SEL1 &= ~0x30;
    P10 -> DIR &= ~0x30;

    TIMER_A3 -> CTL &= ~0x0030;
    TIMER_A3 -> CTL = 0x0200;

    TIMER_A3 -> CCTL[0] = 0x4910;
    TIMER_A3 -> CCTL[1] = 0x4910;
    TIMER_A3 -> EX0 &= ~0x0007;

    NVIC -> IP[3] = (NVIC -> IP[3]&0x0000FFFF) | 0x404000000;
    NVIC -> ISER[0] = 0x0000C000;
    TIMER_A3 -> CTL |= 0x0024;
}

uint16_t first_left;
uint16_t first_right;

uint16_t period_left;
uint16_t period_right;

uint32_t left_count;
uint32_t right_count;

void TA3_0_IRQHandler(void){
    TIMER_A3 -> CCTL[0] &= ~0x0001;
    period_right = TIMER_A3 -> CCR[0] - first_right;
    first_right = TIMER_A3 -> CCR[0];
    right_count ++;
}

void TA3_N_IRQHandler(void){
    TIMER_A3 -> CCTL[1] &= ~0x0001;
    period_left = TIMER_A3 -> CCR[1] - first_left;
    first_left = TIMER_A3 -> CCR[1];
    left_count++;
}

uint32_t get_left_rpm(){
    return 2000000/period_left;
}


void move(uint16_t leftDuty, uint16_t rightDuty){
    P3 -> OUT |= 0xC0;
    TIMER_A0 -> CCR[3] = leftDuty;
    TIMER_A0 -> CCR[4] = rightDuty;
}

void left_forward(){
    P5 -> OUT &= ~0x10;
}

void left_backward(){
    P5 -> OUT |= 0x10;
}

void right_forward(){
    P5 -> OUT &= ~0x20;
}

void right_backward(){
    P5 -> OUT |= 0x20;
}

void (*TimerA2Task)(void);

void TimerA2_Init(void(*task)(void), uint16_t period){
    TimerA2Task = task;
    TIMER_A2->CTL = 0x0280;
    TIMER_A2->CCTL[0] = 0x0010;
    TIMER_A2->CCR[0] = (period-1);
    NVIC -> IP[3] = (NVIC->IP[3]&0xFFFFFF00)|0x00000040;
    NVIC -> ISER[0] = 0x00001000;
    TIMER_A2->EX0 = 0x0005;
    TIMER_A2->CTL |= 0x0014;
}

void TA2_0_IRQHandler(void){
    TIMER_A2->CCTL[0] &= ~0x0001;
    (*TimerA2Task)();
}


void main(void)
{
    Clock_Init48MHz();
    timer_A3_capture_init();
    led_init();
    sensor_init();
    motor_init();
    systick_init();
    int sensor0=0;
    int sensor1=0;
    int sensor2=0;
    int sensor3=0;
    int sensor4=0;
    int sensor5=0;
    int sensor6=0;
    int sensor7=0;


    int first_goal = 0;
    int second_goal = 0;
    int third_goal = 0;
    int fourth_goal = 0;
    int fifth_goal = 0;
    int sixth_goal = 0;
    int speed = 1000;
    int initial_speed = speed;
    int turn_speed = 2000;

    while(1){
        //Turn on IR LEDs
        P5->OUT |= 0x08;
        P9->OUT |= 0x04;

        //Make P7.0-P7.7 as output
        P7->DIR = 0xFF;
        //Charges a capacitor
        P7->OUT = 0xFF;
        //Wait for fully charged
        Clock_Delay1us(10);
        //Make P7.0-P7.7 as input
        P7->DIR = 0x00;
        //Wait for a while
        Clock_Delay1us(1000);

        //Read each sensor
        sensor0 = P7->IN & 0x01;
        sensor1 = P7->IN & 0x02;
        sensor2 = P7->IN & 0x04;
        sensor3 = P7->IN & 0x08;
        sensor4 = P7->IN & 0x10;
        sensor5 = P7->IN & 0x20;
        sensor6 = P7->IN & 0x40;
        sensor7 = P7->IN & 0x80;

        printf("%d %d %d %d %d %d %d %d\n", sensor0, sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7);

        //first goal
        if(sensor0 && sensor7 && !sensor5 && !sensor2 && !first_goal){
            first_goal = 1;
            move(0, 0);
            systick_wait3s();
        }

        //second goal
        if(sensor3 && sensor4 && sensor1 && sensor6 && !second_goal && first_goal){
            second_goal = 1;
            int count = 0;
            while(count<3){
                //move forward
                left_forward();
                right_forward();
                move(speed, speed);
                int i;
                for(i = 0; i < 1000; i++){
                    systick_wait1ms();
                }

                //move backward
                left_backward();
                right_backward();
                move(speed, speed);
                for(i = 0; i < 1000; i++){
                    systick_wait1ms();
                }
                count++;
            }
        }

        //third goal
        if(!third_goal &&  sensor3 && sensor4 && sensor0 && !sensor1 && !sensor2 && !sensor5 && second_goal){
            turn_on_led(LED_RED);
            third_goal = 1;
            left_forward();
            right_forward();
            while(speed > 500){
                int i;
                move(speed, speed);
                for(i=0; i<5; i++){
                    systick_wait1ms();
                }
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
                speed -= 1;
            }
            int i;
            for(i=0; i<600; i++){
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
            }
            speed = initial_speed;
            move(speed, speed);
            turn_off_led();
        }

        //fourth goal
        if(!fourth_goal && sensor3 && sensor4 && sensor7 && !sensor6 && !sensor2 && third_goal){
            turn_on_led(LED_BLUE);
            fourth_goal = 1;
            left_forward();
            right_forward();
            while(speed < 1500){
                int i;
                move(speed, speed);
                for(i=0; i<2; i++){
                    systick_wait1ms();
                }
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
                speed += 2;
            }
            int i;
            for(i=0; i<500; i++){
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
            }
            speed = initial_speed;
            move(speed, speed);
            turn_off_led();
        }

        //fifth goal
        if(sensor3 && sensor4 && sensor6 && !sensor5 && !sensor2 && !fifth_goal && fourth_goal){
            fifth_goal = 1;
            int i;
            //6500
            left_count = 0;
            while(left_count < 650){
                left_backward();
                right_forward();
                move(turn_speed, turn_speed);
            }

            left_forward();
            right_forward();
            move(speed, speed);
            for(i=0; i<300; i++){
                systick_wait1ms();
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
            }

            left_count = 0;
            while(left_count < 750){
                left_forward();
                right_backward();
                move(turn_speed, turn_speed);
            }

            if(sensor5){
               left_backward();
               right_forward();
               move(speed, speed);
               int i;
               for(i=0; i<20; i++){
                   systick_wait1ms();
               }
           } else if(sensor2){
               left_forward();
               right_backward();
               move(speed, speed);
               int i;
               for(i=0; i<20; i++){
                    systick_wait1ms();
                }
           }
            //6300

            left_count = 0;
            right_count = 0;
            while(right_count < 750){
                left_backward();
                right_forward();
                move(turn_speed, turn_speed);
            }

            left_forward();
            right_forward();
            move(speed, speed);
        }

       //sixth goal
        if(sensor3 && sensor4 && sensor1 && !sensor2 && !sensor6 && !sixth_goal && fifth_goal){
            sixth_goal = 1;
            turn_on_led(LED_GREEN);
            int i;
            for(i=0; i<600; i++){
                systick_wait1ms();
                move(speed, speed);
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
            }
            turn_off_led();
            left_count = 0;
            while(left_count<300){
                left_backward();
                right_forward();
                move(turn_speed, turn_speed);
            }
            for(i=0; i<600; i++){
                systick_wait1ms();
                left_forward();
                right_forward();
                move(speed, speed);
                //Turn on IR LEDs
                P5->OUT |= 0x08;
                P9->OUT |= 0x04;

                //Make P7.0-P7.7 as output
                P7->DIR = 0xFF;
                //Charges a capacitor
                P7->OUT = 0xFF;
                //Wait for fully charged
                Clock_Delay1us(10);
                //Make P7.0-P7.7 as input
                P7->DIR = 0x00;
                //Wait for a while
                Clock_Delay1us(1000);

                //Read each sensor
                sensor0 = P7->IN & 0x01;
                sensor1 = P7->IN & 0x02;
                sensor2 = P7->IN & 0x04;
                sensor3 = P7->IN & 0x08;
                sensor4 = P7->IN & 0x10;
                sensor5 = P7->IN & 0x20;
                sensor6 = P7->IN & 0x40;
                sensor7 = P7->IN & 0x80;
                if(sensor3 && sensor4){
                    if(sensor5 && sensor6 && sensor7 && !first_goal){
                        left_backward();
                        right_forward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                        left_forward();
                        right_backward();
                        move(speed, speed);
                        int i;
                        for(i=0; i<400; i++){
                            systick_wait1ms();
                        }
                    } else {
                        left_forward();
                        right_forward();
                        move(speed, speed);
                        systick_wait1ms();
                    }
                } else if(sensor5){
                    left_backward();
                    right_forward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                        systick_wait1ms();
                    }
                } else if(sensor2){
                    left_forward();
                    right_backward();
                    move(speed, speed);
                    int i;
                    for(i=0; i<20; i++){
                         systick_wait1ms();
                     }
                }
            }
            left_count = 0;
            while(left_count<300){
                left_backward();
                right_forward();
                move(turn_speed, turn_speed);
            }
            left_forward();
            right_forward();
            move(speed, speed);
        }

        //seventh goal
         if(sensor2 && sensor5 && sensor1 && sensor6 && !sensor7 && !sensor0 && sixth_goal){
             move(0, 0);
             break;
         }

        //eighth goal
         if(sensor3 && sensor4){
             if(sensor5 && sensor6 && sensor7 && !first_goal){
                 left_backward();
                 right_forward();
                 move(speed, speed);
                 int i;
                 for(i=0; i<400; i++){
                     systick_wait1ms();
                 }
             } else if(sensor2 && sensor1 && sensor0 && !first_goal){
                 left_forward();
                 right_backward();
                 move(speed, speed);
                 int i;
                 for(i=0; i<400; i++){
                     systick_wait1ms();
                 }
             } else {
                 left_forward();
                 right_forward();
                 move(speed, speed);
                 systick_wait1ms();
             }
         } else if(sensor5){
             left_backward();
             right_forward();
             move(speed, speed);
             int i;
             for(i=0; i<20; i++){
                 systick_wait1ms();
             }
         } else if(sensor2){
             left_forward();
             right_backward();
             move(speed, speed);
             int i;
             for(i=0; i<20; i++){
                  systick_wait1ms();
              }
         }

        P5->OUT &= ~0x08;
        P9->OUT &= ~0x04;

        Clock_Delay1ms(10);
    }
}
