#line 1 "C:/Users/LENOVO/Desktop/Final Project/Code/MyProject.c"
unsigned int i;
unsigned int count1 = 3000;
unsigned int count2 = 4000;
unsigned int count3= 3000;
unsigned int count4= 4000;

unsigned int move1 = 500;
unsigned int move2 = 500;
unsigned int move3 = 500;
unsigned int move4 = 500;

unsigned int count11=2000;
unsigned int count22=3000;
unsigned int count33=2000;
unsigned int count44=3000;

unsigned int count111=1000;
unsigned int count222=2000;
unsigned int count333=1000;
unsigned int count444=2000;

unsigned char rcv ;
unsigned int duty_cycle;
unsigned int period;


void PWM_init(unsigned int dc, unsigned int p)
{
 duty_cycle = dc;
 period = p;


 T2CON = 0x07;
 CCP1CON = 0x0C;
 CCP2CON = 0x0C;
 PR2 = period;
 TRISC = 0x00;
 CCPR1L = (duty_cycle * period) / 100;
 CCPR2L = (duty_cycle * period) / 100;
}

void interrupt(void)
{


 if (INTCON&0x01)
 {
 PORTB=0x00;
 PORTD=0x00;
 }

 INTCON = INTCON & 0xFD;
}

void Delay500Us()
{
 for(i = 0; i < (8000000 * 0.5 / 1000000); i++);
}

void MoveXoneStep(unsigned int dir)
{


 if (dir == 1)
 PORTD = PORTD | 0x02;


 else
 PORTD = PORTD & 0xFD;



 PORTD= PORTD & 0xFE;
 Delay500Us();
 PORTD= PORTD & 0xFE;
 Delay500Us();
 PORTD= PORTD | 0x01;
 Delay500Us();

}

void MoveYoneStep(unsigned int dir)
{


 if (dir == 1)
 PORTB = PORTB | 0x02;


 else
 PORTB = PORTB & 0xFD;


 PORTB= PORTB & 0xFB;
 Delay500Us();
 PORTB= PORTB & 0xFB;
 Delay500Us();
 PORTB= PORTB | 0x04;
 Delay500Us();

}

 void moveXuntilHome()
 {


 while(!(PORTD | 0x08))
 {
 MoveXoneStep(0);
 }

 }

void moveYuntilHome()
 {


 while(!(PORTD | 0x04))
 {
 MoveXoneStep(0);
 }

 }



void main()
{

 TRISD = 0b00001100;
 TRISB = 0b00000001;
 INTCON=0x90;




 UART1_Init(9600);

 while(1)
 {
 if(UART1_Data_Ready())
 {
 rcv = UART1_Read();
 if (rcv == 'S')
 {
 while(count1!=0)
 {
 MoveXoneStep(0);
 count1--;

 }


 while(count2!=0)
 {
 MoveYoneStep(0);
 count2--;

 }

 while(count3!=0)
 {
 MoveXoneStep(1);
 count3--;
 }


 while(count4!=0)
 {
 MoveYoneStep(1);
 count4--;

 }

 while (move1!=0)
 {
 MoveXoneStep(0);
 move1--;
 }

 while (move2!=0)
 {
 MoveYoneStep(0);
 move2--;
 }


 while(count11!=0)
 {
 MoveXoneStep(0);
 count11--;

 }


 while(count22!=0)
 {
 MoveYoneStep(0);
 count22--;

 }

 while(count33!=0)
 {
 MoveXoneStep(1);
 count33--;
 }


 while(count44!=0)
 {
 MoveYoneStep(1);
 count44--;

 }

 while (move3!=0)
 {
 MoveXoneStep(0);
 move3--;
 }

 while (move4!=0)
 {
 MoveYoneStep(0);
 move4--;
 }

 while(count111!=0)
 {
 MoveXoneStep(0);
 count111--;

 }


 while(count222!=0)
 {
 MoveYoneStep(0);
 count222--;

 }

 while(count333!=0)
 {
 MoveXoneStep(1);
 count333--;
 }


 while(count444!=0)
 {
 MoveYoneStep(1);
 count444--;

 }

 }


 }
 }

}
