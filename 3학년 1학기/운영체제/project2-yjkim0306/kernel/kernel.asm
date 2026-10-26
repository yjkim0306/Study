
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8c010113          	addi	sp,sp,-1856 # 800088c0 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a

  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63));
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc637>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e2a78793          	addi	a5,a5,-470 # 80000eae <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	6dc020ef          	jal	800027f6 <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	7b4000ef          	jal	800008da <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f05a                	sd	s6,32(sp)
    80000186:	ec5e                	sd	s7,24(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8b2a                	mv	s6,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000192:	00010517          	auipc	a0,0x10
    80000196:	72e50513          	addi	a0,a0,1838 # 800108c0 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00010497          	auipc	s1,0x10
    800001a2:	72248493          	addi	s1,s1,1826 # 800108c0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00010917          	auipc	s2,0x10
    800001aa:	7b290913          	addi	s2,s2,1970 # 80010958 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	75c010ef          	jal	8000191a <myproc>
    800001c2:	3c4020ef          	jal	80002586 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	030020ef          	jal	800021fc <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00010717          	auipc	a4,0x10
    800001e2:	6e270713          	addi	a4,a4,1762 # 800108c0 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04da8663          	beq	s5,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	855a                	mv	a0,s6
    80000210:	59a020ef          	jal	800027aa <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fa8b63          	beq	s5,a5,80000276 <consoleread+0x100>
    80000224:	7aa2                	ld	s5,40(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	00010517          	auipc	a0,0x10
    8000022c:	69850513          	addi	a0,a0,1688 # 800108c0 <cons>
    80000230:	28d000ef          	jal	80000cbc <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7b02                	ld	s6,32(sp)
    80000244:	6be2                	ld	s7,24(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0179fa63          	bgeu	s3,s7,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	00010717          	auipc	a4,0x10
    80000252:	70f72523          	sw	a5,1802(a4) # 80010958 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00010517          	auipc	a0,0x10
    80000268:	65c50513          	addi	a0,a0,1628 # 800108c0 <cons>
    8000026c:	251000ef          	jal	80000cbc <release>
  return target - n;
    80000270:	413b853b          	subw	a0,s7,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	6e4000ef          	jal	8000096e <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	6d6000ef          	jal	8000096e <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	6ce000ef          	jal	8000096e <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	6c8000ef          	jal	8000096e <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	1101                	addi	sp,sp,-32
    800002ae:	ec06                	sd	ra,24(sp)
    800002b0:	e822                	sd	s0,16(sp)
    800002b2:	e426                	sd	s1,8(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00010517          	auipc	a0,0x10
    800002bc:	60850513          	addi	a0,a0,1544 # 800108c0 <cons>
    800002c0:	169000ef          	jal	80000c28 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48d63          	beq	s1,a5,80000360 <consoleintr+0xb4>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48263          	beq	s1,a5,800003b4 <consoleintr+0x108>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49363          	bne	s1,a5,800003dc <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800002da:	568020ef          	jal	80002842 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002de:	00010517          	auipc	a0,0x10
    800002e2:	5e250513          	addi	a0,a0,1506 # 800108c0 <cons>
    800002e6:	1d7000ef          	jal	80000cbc <release>
}
    800002ea:	60e2                	ld	ra,24(sp)
    800002ec:	6442                	ld	s0,16(sp)
    800002ee:	64a2                	ld	s1,8(sp)
    800002f0:	6105                	addi	sp,sp,32
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0af48e63          	beq	s1,a5,800003b4 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	00010717          	auipc	a4,0x10
    80000300:	5c470713          	addi	a4,a4,1476 # 800108c0 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48563          	beq	s1,a5,800003e2 <consoleintr+0x136>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	00010717          	auipc	a4,0x10
    80000326:	59e70713          	addi	a4,a4,1438 # 800108c0 <cons>
    8000032a:	0a072683          	lw	a3,160(a4)
    8000032e:	0016879b          	addiw	a5,a3,1
    80000332:	863e                	mv	a2,a5
    80000334:	0af72023          	sw	a5,160(a4)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	9736                	add	a4,a4,a3
    8000033e:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	ff648713          	addi	a4,s1,-10
    80000346:	c371                	beqz	a4,8000040a <consoleintr+0x15e>
    80000348:	14f1                	addi	s1,s1,-4
    8000034a:	c0e1                	beqz	s1,8000040a <consoleintr+0x15e>
    8000034c:	00010717          	auipc	a4,0x10
    80000350:	60c72703          	lw	a4,1548(a4) # 80010958 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00010717          	auipc	a4,0x10
    80000366:	55e70713          	addi	a4,a4,1374 # 800108c0 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00010497          	auipc	s1,0x10
    80000376:	54e48493          	addi	s1,s1,1358 # 800108c0 <cons>
    while(cons.e != cons.w &&
    8000037a:	4929                	li	s2,10
    8000037c:	02f70863          	beq	a4,a5,800003ac <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000380:	37fd                	addiw	a5,a5,-1
    80000382:	07f7f713          	andi	a4,a5,127
    80000386:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000388:	01874703          	lbu	a4,24(a4)
    8000038c:	03270263          	beq	a4,s2,800003b0 <consoleintr+0x104>
      cons.e--;
    80000390:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000394:	10000513          	li	a0,256
    80000398:	ee3ff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    8000039c:	0a04a783          	lw	a5,160(s1)
    800003a0:	09c4a703          	lw	a4,156(s1)
    800003a4:	fcf71ee3          	bne	a4,a5,80000380 <consoleintr+0xd4>
    800003a8:	6902                	ld	s2,0(sp)
    800003aa:	bf15                	j	800002de <consoleintr+0x32>
    800003ac:	6902                	ld	s2,0(sp)
    800003ae:	bf05                	j	800002de <consoleintr+0x32>
    800003b0:	6902                	ld	s2,0(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b4:	00010717          	auipc	a4,0x10
    800003b8:	50c70713          	addi	a4,a4,1292 # 800108c0 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00010717          	auipc	a4,0x10
    800003ce:	58f72b23          	sw	a5,1430(a4) # 80010960 <cons+0xa0>
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	ea5ff0ef          	jal	8000027a <consputc>
    800003da:	b711                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	f00481e3          	beqz	s1,800002de <consoleintr+0x32>
    800003e0:	bf31                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003e2:	4529                	li	a0,10
    800003e4:	e97ff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e8:	00010797          	auipc	a5,0x10
    800003ec:	4d878793          	addi	a5,a5,1240 # 800108c0 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00010797          	auipc	a5,0x10
    8000040e:	54c7a923          	sw	a2,1362(a5) # 8001095c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00010517          	auipc	a0,0x10
    80000416:	54650513          	addi	a0,a0,1350 # 80010958 <cons+0x98>
    8000041a:	62f010ef          	jal	80002248 <wakeup>
    8000041e:	b5c1                	j	800002de <consoleintr+0x32>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00008597          	auipc	a1,0x8
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80008000 <etext>
    80000430:	00010517          	auipc	a0,0x10
    80000434:	49050513          	addi	a0,a0,1168 # 800108c0 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00021797          	auipc	a5,0x21
    80000444:	bf078793          	addi	a5,a5,-1040 # 80021030 <devsw>
    80000448:	00000717          	auipc	a4,0x0
    8000044c:	d2e70713          	addi	a4,a4,-722 # 80000176 <consoleread>
    80000450:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000452:	00000717          	auipc	a4,0x0
    80000456:	c8270713          	addi	a4,a4,-894 # 800000d4 <consolewrite>
    8000045a:	ef98                	sd	a4,24(a5)
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f04a                	sd	s2,32(sp)
    8000046c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046e:	c219                	beqz	a2,80000474 <printint+0x10>
    80000470:	08054163          	bltz	a0,800004f2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000474:	4301                	li	t1,0

  i = 0;
    80000476:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000047a:	86ca                	mv	a3,s2
  i = 0;
    8000047c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00008817          	auipc	a6,0x8
    80000482:	2e280813          	addi	a6,a6,738 # 80008760 <digits>
    80000486:	88ba                	mv	a7,a4
    80000488:	0017061b          	addiw	a2,a4,1
    8000048c:	8732                	mv	a4,a2
    8000048e:	02b577b3          	remu	a5,a0,a1
    80000492:	97c2                	add	a5,a5,a6
    80000494:	0007c783          	lbu	a5,0(a5)
    80000498:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000049c:	87aa                	mv	a5,a0
    8000049e:	02b55533          	divu	a0,a0,a1
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	feb7f1e3          	bgeu	a5,a1,80000486 <printint+0x22>

  if(sign)
    800004a8:	00030c63          	beqz	t1,800004c0 <printint+0x5c>
    buf[i++] = '-';
    800004ac:	fe060793          	addi	a5,a2,-32
    800004b0:	00878633          	add	a2,a5,s0
    800004b4:	02d00793          	li	a5,45
    800004b8:	fef60423          	sb	a5,-24(a2)
    800004bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800004c0:	02e05463          	blez	a4,800004e8 <printint+0x84>
    800004c4:	f426                	sd	s1,40(sp)
    800004c6:	377d                	addiw	a4,a4,-1
    800004c8:	00e904b3          	add	s1,s2,a4
    800004cc:	197d                	addi	s2,s2,-1
    800004ce:	993a                	add	s2,s2,a4
    800004d0:	1702                	slli	a4,a4,0x20
    800004d2:	9301                	srli	a4,a4,0x20
    800004d4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004d8:	0004c503          	lbu	a0,0(s1)
    800004dc:	d9fff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x74>
    800004e6:	74a2                	ld	s1,40(sp)
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4305                	li	t1,1
    x = -xx;
    800004f8:	bfbd                	j	80000476 <printint+0x12>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	f0ca                	sd	s2,96(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	892a                	mv	s2,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	00008797          	auipc	a5,0x8
    8000051c:	37c7a783          	lw	a5,892(a5) # 80008894 <panicking>
    80000520:	cf9d                	beqz	a5,8000055e <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	00094503          	lbu	a0,0(s2)
    8000052e:	22050663          	beqz	a0,8000075a <printf+0x260>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	ecce                	sd	s3,88(sp)
    80000536:	e8d2                	sd	s4,80(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	fc5e                	sd	s7,56(sp)
    8000053e:	f862                	sd	s8,48(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4a01                	li	s4,0
    if(cx != '%'){
    80000546:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000054a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000054e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000552:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000556:	4b29                	li	s6,10
    if(c0 == 'd'){
    80000558:	06400b93          	li	s7,100
    8000055c:	a015                	j	80000580 <printf+0x86>
    acquire(&pr.lock);
    8000055e:	00010517          	auipc	a0,0x10
    80000562:	40a50513          	addi	a0,a0,1034 # 80010968 <pr>
    80000566:	6c2000ef          	jal	80000c28 <acquire>
    8000056a:	bf65                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056c:	d0fff0ef          	jal	8000027a <consputc>
      continue;
    80000570:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	2485                	addiw	s1,s1,1
    80000574:	8a26                	mv	s4,s1
    80000576:	94ca                	add	s1,s1,s2
    80000578:	0004c503          	lbu	a0,0(s1)
    8000057c:	1c050663          	beqz	a0,80000748 <printf+0x24e>
    if(cx != '%'){
    80000580:	ff3516e3          	bne	a0,s3,8000056c <printf+0x72>
    i++;
    80000584:	001a079b          	addiw	a5,s4,1
    80000588:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058a:	00f90733          	add	a4,s2,a5
    8000058e:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000592:	200a8963          	beqz	s5,800007a4 <printf+0x2aa>
    80000596:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059a:	1e068c63          	beqz	a3,80000792 <printf+0x298>
    if(c0 == 'd'){
    8000059e:	037a8863          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800005a2:	f94a8713          	addi	a4,s5,-108
    800005a6:	00173713          	seqz	a4,a4
    800005aa:	f9c68613          	addi	a2,a3,-100
    800005ae:	ee05                	bnez	a2,800005e6 <printf+0xec>
    800005b0:	cb1d                	beqz	a4,800005e6 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	85da                	mv	a1,s6
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	ea1ff0ef          	jal	80000464 <printint>
      i += 1;
    800005c8:	002a049b          	addiw	s1,s4,2
    800005cc:	b75d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	85da                	mv	a1,s6
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e85ff0ef          	jal	80000464 <printint>
    800005e4:	b779                	j	80000572 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800005e6:	97ca                	add	a5,a5,s2
    800005e8:	8636                	mv	a2,a3
    800005ea:	0027c683          	lbu	a3,2(a5)
    800005ee:	a2c9                	j	800007b0 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005f0:	f8843783          	ld	a5,-120(s0)
    800005f4:	00878713          	addi	a4,a5,8
    800005f8:	f8e43423          	sd	a4,-120(s0)
    800005fc:	4605                	li	a2,1
    800005fe:	45a9                	li	a1,10
    80000600:	6388                	ld	a0,0(a5)
    80000602:	e63ff0ef          	jal	80000464 <printint>
      i += 2;
    80000606:	003a049b          	addiw	s1,s4,3
    8000060a:	b7a5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000060c:	f8843783          	ld	a5,-120(s0)
    80000610:	00878713          	addi	a4,a5,8
    80000614:	f8e43423          	sd	a4,-120(s0)
    80000618:	4601                	li	a2,0
    8000061a:	85da                	mv	a1,s6
    8000061c:	0007e503          	lwu	a0,0(a5)
    80000620:	e45ff0ef          	jal	80000464 <printint>
    80000624:	b7b9                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4601                	li	a2,0
    80000634:	85da                	mv	a1,s6
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2dff0ef          	jal	80000464 <printint>
      i += 1;
    8000063c:	002a049b          	addiw	s1,s4,2
    80000640:	bf0d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45a9                	li	a1,10
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e11ff0ef          	jal	80000464 <printint>
      i += 2;
    80000658:	003a049b          	addiw	s1,s4,3
    8000065c:	bf19                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4601                	li	a2,0
    8000066c:	45c1                	li	a1,16
    8000066e:	0007e503          	lwu	a0,0(a5)
    80000672:	df3ff0ef          	jal	80000464 <printint>
    80000676:	bdf5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	45c1                	li	a1,16
    80000686:	6388                	ld	a0,0(a5)
    80000688:	dddff0ef          	jal	80000464 <printint>
      i += 1;
    8000068c:	002a049b          	addiw	s1,s4,2
    80000690:	b5cd                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45c1                	li	a1,16
    800006a2:	6388                	ld	a0,0(a5)
    800006a4:	dc1ff0ef          	jal	80000464 <printint>
      i += 2;
    800006a8:	003a049b          	addiw	s1,s4,3
    800006ac:	b5d9                	j	80000572 <printf+0x78>
    800006ae:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c0:	03000513          	li	a0,48
    800006c4:	bb7ff0ef          	jal	8000027a <consputc>
  consputc('x');
    800006c8:	07800513          	li	a0,120
    800006cc:	bafff0ef          	jal	8000027a <consputc>
    800006d0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	00008c97          	auipc	s9,0x8
    800006d6:	08ec8c93          	addi	s9,s9,142 # 80008760 <digits>
    800006da:	03cad793          	srli	a5,s5,0x3c
    800006de:	97e6                	add	a5,a5,s9
    800006e0:	0007c503          	lbu	a0,0(a5)
    800006e4:	b97ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e8:	0a92                	slli	s5,s5,0x4
    800006ea:	3a7d                	addiw	s4,s4,-1
    800006ec:	fe0a17e3          	bnez	s4,800006da <printf+0x1e0>
    800006f0:	7ca2                	ld	s9,40(sp)
    800006f2:	b541                	j	80000572 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	4388                	lw	a0,0(a5)
    80000702:	b79ff0ef          	jal	8000027a <consputc>
    80000706:	b5b5                	j	80000572 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80000708:	f8843783          	ld	a5,-120(s0)
    8000070c:	00878713          	addi	a4,a5,8
    80000710:	f8e43423          	sd	a4,-120(s0)
    80000714:	0007ba03          	ld	s4,0(a5)
    80000718:	000a0d63          	beqz	s4,80000732 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000071c:	000a4503          	lbu	a0,0(s4)
    80000720:	e40509e3          	beqz	a0,80000572 <printf+0x78>
        consputc(*s);
    80000724:	b57ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    80000728:	0a05                	addi	s4,s4,1
    8000072a:	000a4503          	lbu	a0,0(s4)
    8000072e:	f97d                	bnez	a0,80000724 <printf+0x22a>
    80000730:	b589                	j	80000572 <printf+0x78>
        s = "(null)";
    80000732:	00008a17          	auipc	s4,0x8
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7dd                	j	80000724 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80000740:	8556                	mv	a0,s5
    80000742:	b39ff0ef          	jal	8000027a <consputc>
    80000746:	b535                	j	80000572 <printf+0x78>
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000075a:	00008797          	auipc	a5,0x8
    8000075e:	13a7a783          	lw	a5,314(a5) # 80008894 <panicking>
    80000762:	c38d                	beqz	a5,80000784 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80000764:	4501                	li	a0,0
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7d02                	ld	s10,32(sp)
    80000780:	6de2                	ld	s11,24(sp)
    80000782:	bfe1                	j	8000075a <printf+0x260>
    release(&pr.lock);
    80000784:	00010517          	auipc	a0,0x10
    80000788:	1e450513          	addi	a0,a0,484 # 80010968 <pr>
    8000078c:	530000ef          	jal	80000cbc <release>
  return 0;
    80000790:	bfd1                	j	80000764 <printf+0x26a>
    if(c0 == 'd'){
    80000792:	e37a8ee3          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80000796:	f94a8713          	addi	a4,s5,-108
    8000079a:	00173713          	seqz	a4,a4
    8000079e:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007a0:	4781                	li	a5,0
    800007a2:	a00d                	j	800007c4 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a4:	f94a8713          	addi	a4,s5,-108
    800007a8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007ac:	8656                	mv	a2,s5
    800007ae:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007b0:	f9460793          	addi	a5,a2,-108
    800007b4:	0017b793          	seqz	a5,a5
    800007b8:	8ff9                	and	a5,a5,a4
    800007ba:	f9c68593          	addi	a1,a3,-100
    800007be:	e199                	bnez	a1,800007c4 <printf+0x2ca>
    800007c0:	e20798e3          	bnez	a5,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800007c4:	e58a84e3          	beq	s5,s8,8000060c <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800007c8:	f8b60593          	addi	a1,a2,-117
    800007cc:	e199                	bnez	a1,800007d2 <printf+0x2d8>
    800007ce:	e4071ce3          	bnez	a4,80000626 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800007d2:	f8b68593          	addi	a1,a3,-117
    800007d6:	e199                	bnez	a1,800007dc <printf+0x2e2>
    800007d8:	e60795e3          	bnez	a5,80000642 <printf+0x148>
    } else if(c0 == 'x'){
    800007dc:	e9aa81e3          	beq	s5,s10,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800007e0:	f8860613          	addi	a2,a2,-120
    800007e4:	e219                	bnez	a2,800007ea <printf+0x2f0>
    800007e6:	e80719e3          	bnez	a4,80000678 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800007ea:	f8868693          	addi	a3,a3,-120
    800007ee:	e299                	bnez	a3,800007f4 <printf+0x2fa>
    800007f0:	ea0791e3          	bnez	a5,80000692 <printf+0x198>
    } else if(c0 == 'p'){
    800007f4:	ebba8de3          	beq	s5,s11,800006ae <printf+0x1b4>
    } else if(c0 == 'c'){
    800007f8:	06300793          	li	a5,99
    800007fc:	eefa8ce3          	beq	s5,a5,800006f4 <printf+0x1fa>
    } else if(c0 == 's'){
    80000800:	07300793          	li	a5,115
    80000804:	f0fa82e3          	beq	s5,a5,80000708 <printf+0x20e>
    } else if(c0 == '%'){
    80000808:	02500793          	li	a5,37
    8000080c:	f2fa8ae3          	beq	s5,a5,80000740 <printf+0x246>
    } else if(c0 == 0){
    80000810:	f60a80e3          	beqz	s5,80000770 <printf+0x276>
      consputc('%');
    80000814:	02500513          	li	a0,37
    80000818:	a63ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    8000081c:	8556                	mv	a0,s5
    8000081e:	a5dff0ef          	jal	8000027a <consputc>
    80000822:	bb81                	j	80000572 <printf+0x78>

0000000080000824 <panic>:

void
panic(char *s)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	e04a                	sd	s2,0(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	892a                	mv	s2,a0
  panicking = 1;
    80000832:	4485                	li	s1,1
    80000834:	00008797          	auipc	a5,0x8
    80000838:	0697a023          	sw	s1,96(a5) # 80008894 <panicking>
  printf("panic: ");
    8000083c:	00007517          	auipc	a0,0x7
    80000840:	7dc50513          	addi	a0,a0,2012 # 80008018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00007517          	auipc	a0,0x7
    8000084e:	7d650513          	addi	a0,a0,2006 # 80008020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	00008797          	auipc	a5,0x8
    8000085a:	0297ad23          	sw	s1,58(a5) # 80008890 <panicked>
  for(;;)
    8000085e:	a001                	j	8000085e <panic+0x3a>

0000000080000860 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000868:	00007597          	auipc	a1,0x7
    8000086c:	7c058593          	addi	a1,a1,1984 # 80008028 <etext+0x28>
    80000870:	00010517          	auipc	a0,0x10
    80000874:	0f850513          	addi	a0,a0,248 # 80010968 <pr>
    80000878:	326000ef          	jal	80000b9e <initlock>
}
    8000087c:	60a2                	ld	ra,8(sp)
    8000087e:	6402                	ld	s0,0(sp)
    80000880:	0141                	addi	sp,sp,16
    80000882:	8082                	ret

0000000080000884 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000088c:	100007b7          	lui	a5,0x10000
    80000890:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000894:	10000737          	lui	a4,0x10000
    80000898:	f8000693          	li	a3,-128
    8000089c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008a0:	468d                	li	a3,3
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008aa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008ae:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008b2:	8732                	mv	a4,a2
    800008b4:	461d                	li	a2,7
    800008b6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ba:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008be:	00007597          	auipc	a1,0x7
    800008c2:	77258593          	addi	a1,a1,1906 # 80008030 <etext+0x30>
    800008c6:	00010517          	auipc	a0,0x10
    800008ca:	0ba50513          	addi	a0,a0,186 # 80010980 <tx_lock>
    800008ce:	2d0000ef          	jal	80000b9e <initlock>
}
    800008d2:	60a2                	ld	ra,8(sp)
    800008d4:	6402                	ld	s0,0(sp)
    800008d6:	0141                	addi	sp,sp,16
    800008d8:	8082                	ret

00000000800008da <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008da:	715d                	addi	sp,sp,-80
    800008dc:	e486                	sd	ra,72(sp)
    800008de:	e0a2                	sd	s0,64(sp)
    800008e0:	fc26                	sd	s1,56(sp)
    800008e2:	ec56                	sd	s5,24(sp)
    800008e4:	0880                	addi	s0,sp,80
    800008e6:	8aaa                	mv	s5,a0
    800008e8:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008ea:	00010517          	auipc	a0,0x10
    800008ee:	09650513          	addi	a0,a0,150 # 80010980 <tx_lock>
    800008f2:	336000ef          	jal	80000c28 <acquire>

  int i = 0;
  while(i < n){
    800008f6:	06905063          	blez	s1,80000956 <uartwrite+0x7c>
    800008fa:	f84a                	sd	s2,48(sp)
    800008fc:	f44e                	sd	s3,40(sp)
    800008fe:	f052                	sd	s4,32(sp)
    80000900:	e85a                	sd	s6,16(sp)
    80000902:	e45e                	sd	s7,8(sp)
    80000904:	8a56                	mv	s4,s5
    80000906:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000908:	00008497          	auipc	s1,0x8
    8000090c:	f9448493          	addi	s1,s1,-108 # 8000889c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00010997          	auipc	s3,0x10
    80000914:	07098993          	addi	s3,s3,112 # 80010980 <tx_lock>
    80000918:	00008917          	auipc	s2,0x8
    8000091c:	f8090913          	addi	s2,s2,-128 # 80008898 <tx_chan>
    }

    WriteReg(THR, buf[i]);
    80000920:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000924:	4b05                	li	s6,1
    80000926:	a005                	j	80000946 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000928:	85ce                	mv	a1,s3
    8000092a:	854a                	mv	a0,s2
    8000092c:	0d1010ef          	jal	800021fc <sleep>
    while(tx_busy != 0){
    80000930:	409c                	lw	a5,0(s1)
    80000932:	fbfd                	bnez	a5,80000928 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000934:	000a4783          	lbu	a5,0(s4)
    80000938:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000093c:	0164a023          	sw	s6,0(s1)
  while(i < n){
    80000940:	0a05                	addi	s4,s4,1
    80000942:	015a0563          	beq	s4,s5,8000094c <uartwrite+0x72>
    while(tx_busy != 0){
    80000946:	409c                	lw	a5,0(s1)
    80000948:	f3e5                	bnez	a5,80000928 <uartwrite+0x4e>
    8000094a:	b7ed                	j	80000934 <uartwrite+0x5a>
    8000094c:	7942                	ld	s2,48(sp)
    8000094e:	79a2                	ld	s3,40(sp)
    80000950:	7a02                	ld	s4,32(sp)
    80000952:	6b42                	ld	s6,16(sp)
    80000954:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000956:	00010517          	auipc	a0,0x10
    8000095a:	02a50513          	addi	a0,a0,42 # 80010980 <tx_lock>
    8000095e:	35e000ef          	jal	80000cbc <release>
}
    80000962:	60a6                	ld	ra,72(sp)
    80000964:	6406                	ld	s0,64(sp)
    80000966:	74e2                	ld	s1,56(sp)
    80000968:	6ae2                	ld	s5,24(sp)
    8000096a:	6161                	addi	sp,sp,80
    8000096c:	8082                	ret

000000008000096e <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
    80000978:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000097a:	00008797          	auipc	a5,0x8
    8000097e:	f1a7a783          	lw	a5,-230(a5) # 80008894 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00008797          	auipc	a5,0x8
    80000988:	f0c7a783          	lw	a5,-244(a5) # 80008890 <panicked>
    8000098c:	ef85                	bnez	a5,800009c4 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000098e:	10000737          	lui	a4,0x10000
    80000992:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000994:	00074783          	lbu	a5,0(a4)
    80000998:	0207f793          	andi	a5,a5,32
    8000099c:	dfe5                	beqz	a5,80000994 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000099e:	0ff4f513          	zext.b	a0,s1
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800009aa:	00008797          	auipc	a5,0x8
    800009ae:	eea7a783          	lw	a5,-278(a5) # 80008894 <panicking>
    800009b2:	cb91                	beqz	a5,800009c6 <uartputc_sync+0x58>
    pop_off();
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    push_off();
    800009be:	226000ef          	jal	80000be4 <push_off>
    800009c2:	b7c9                	j	80000984 <uartputc_sync+0x16>
    for(;;)
    800009c4:	a001                	j	800009c4 <uartputc_sync+0x56>
    pop_off();
    800009c6:	2a6000ef          	jal	80000c6c <pop_off>
}
    800009ca:	b7ed                	j	800009b4 <uartputc_sync+0x46>

00000000800009cc <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800009d4:	100007b7          	lui	a5,0x10000
    800009d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009dc:	8b85                	andi	a5,a5,1
    800009de:	cb89                	beqz	a5,800009f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009e8:	60a2                	ld	ra,8(sp)
    800009ea:	6402                	ld	s0,0(sp)
    800009ec:	0141                	addi	sp,sp,16
    800009ee:	8082                	ret
    return -1;
    800009f0:	557d                	li	a0,-1
    800009f2:	bfdd                	j	800009e8 <uartgetc+0x1c>

00000000800009f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a06:	00010517          	auipc	a0,0x10
    80000a0a:	f7a50513          	addi	a0,a0,-134 # 80010980 <tx_lock>
    80000a0e:	21a000ef          	jal	80000c28 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000a12:	100007b7          	lui	a5,0x10000
    80000a16:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1a:	0207f793          	andi	a5,a5,32
    80000a1e:	ef99                	bnez	a5,80000a3c <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a20:	00010517          	auipc	a0,0x10
    80000a24:	f6050513          	addi	a0,a0,-160 # 80010980 <tx_lock>
    80000a28:	294000ef          	jal	80000cbc <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	f9fff0ef          	jal	800009cc <uartgetc>
    if(c == -1)
    80000a32:	02950063          	beq	a0,s1,80000a52 <uartintr+0x5e>
      break;
    consoleintr(c);
    80000a36:	877ff0ef          	jal	800002ac <consoleintr>
  while(1){
    80000a3a:	bfd5                	j	80000a2e <uartintr+0x3a>
    tx_busy = 0;
    80000a3c:	00008797          	auipc	a5,0x8
    80000a40:	e607a023          	sw	zero,-416(a5) # 8000889c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00008517          	auipc	a0,0x8
    80000a48:	e5450513          	addi	a0,a0,-428 # 80008898 <tx_chan>
    80000a4c:	7fc010ef          	jal	80002248 <wakeup>
    80000a50:	bfc1                	j	80000a20 <uartintr+0x2c>
  }
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	00021797          	auipc	a5,0x21
    80000a6c:	76078793          	addi	a5,a5,1888 # 800221c8 <end>
    80000a70:	00f53733          	sltu	a4,a0,a5
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	17fd                	addi	a5,a5,-1
    80000a7a:	00a7b7b3          	sltu	a5,a5,a0
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	ef95                	bnez	a5,80000abc <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	eb95                	bnez	a5,80000abc <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	26a000ef          	jal	80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a92:	00010917          	auipc	s2,0x10
    80000a96:	f0690913          	addi	s2,s2,-250 # 80010998 <kmem>
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	18c000ef          	jal	80000c28 <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	210000ef          	jal	80000cbc <release>
}
    80000ab0:	60e2                	ld	ra,24(sp)
    80000ab2:	6442                	ld	s0,16(sp)
    80000ab4:	64a2                	ld	s1,8(sp)
    80000ab6:	6902                	ld	s2,0(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    panic("kfree");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80008038 <etext+0x38>
    80000ac4:	d61ff0ef          	jal	80000824 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e263          	bltu	a1,s1,80000b06 <freerange+0x3e>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	f67ff0ef          	jal	80000a5c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afa:	94ce                	add	s1,s1,s3
    80000afc:	fe997be3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b00:	6942                	ld	s2,16(sp)
    80000b02:	69a2                	ld	s3,8(sp)
    80000b04:	6a02                	ld	s4,0(sp)
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6145                	addi	sp,sp,48
    80000b0e:	8082                	ret

0000000080000b10 <kinit>:
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b18:	00007597          	auipc	a1,0x7
    80000b1c:	52858593          	addi	a1,a1,1320 # 80008040 <etext+0x40>
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	e7850513          	addi	a0,a0,-392 # 80010998 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00021517          	auipc	a0,0x21
    80000b34:	69850513          	addi	a0,a0,1688 # 800221c8 <end>
    80000b38:	f91ff0ef          	jal	80000ac8 <freerange>
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret

0000000080000b44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b4e:	00010517          	auipc	a0,0x10
    80000b52:	e4a50513          	addi	a0,a0,-438 # 80010998 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00010497          	auipc	s1,0x10
    80000b5e:	e564b483          	ld	s1,-426(s1) # 800109b0 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00010717          	auipc	a4,0x10
    80000b6a:	e4f73523          	sd	a5,-438(a4) # 800109b0 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00010517          	auipc	a0,0x10
    80000b72:	e2a50513          	addi	a0,a0,-470 # 80010998 <kmem>
    80000b76:	146000ef          	jal	80000cbc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7a:	6605                	lui	a2,0x1
    80000b7c:	4595                	li	a1,5
    80000b7e:	8526                	mv	a0,s1
    80000b80:	178000ef          	jal	80000cf8 <memset>
  return (void*)r;
}
    80000b84:	8526                	mv	a0,s1
    80000b86:	60e2                	ld	ra,24(sp)
    80000b88:	6442                	ld	s0,16(sp)
    80000b8a:	64a2                	ld	s1,8(sp)
    80000b8c:	6105                	addi	sp,sp,32
    80000b8e:	8082                	ret
  release(&kmem.lock);
    80000b90:	00010517          	auipc	a0,0x10
    80000b94:	e0850513          	addi	a0,a0,-504 # 80010998 <kmem>
    80000b98:	124000ef          	jal	80000cbc <release>
  if(r)
    80000b9c:	b7e5                	j	80000b84 <kalloc+0x40>

0000000080000b9e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b9e:	1141                	addi	sp,sp,-16
    80000ba0:	e406                	sd	ra,8(sp)
    80000ba2:	e022                	sd	s0,0(sp)
    80000ba4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ba8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bac:	00053823          	sd	zero,16(a0)
}
    80000bb0:	60a2                	ld	ra,8(sp)
    80000bb2:	6402                	ld	s0,0(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	411c                	lw	a5,0(a0)
    80000bba:	e399                	bnez	a5,80000bc0 <holding+0x8>
    80000bbc:	4501                	li	a0,0
  return r;
}
    80000bbe:	8082                	ret
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bca:	691c                	ld	a5,16(a0)
    80000bcc:	84be                	mv	s1,a5
    80000bce:	52d000ef          	jal	800018fa <mycpu>
    80000bd2:	40a48533          	sub	a0,s1,a0
    80000bd6:	00153513          	seqz	a0,a0
}
    80000bda:	60e2                	ld	ra,24(sp)
    80000bdc:	6442                	ld	s0,16(sp)
    80000bde:	64a2                	ld	s1,8(sp)
    80000be0:	6105                	addi	sp,sp,32
    80000be2:	8082                	ret

0000000080000be4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bee:	100027f3          	csrr	a5,sstatus
    80000bf2:	84be                	mv	s1,a5
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bfe:	4fd000ef          	jal	800018fa <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	4f5000ef          	jal	800018fa <mycpu>
    80000c0a:	5d3c                	lw	a5,120(a0)
    80000c0c:	2785                	addiw	a5,a5,1
    80000c0e:	dd3c                	sw	a5,120(a0)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    mycpu()->intena = old;
    80000c1a:	4e1000ef          	jal	800018fa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c1e:	0014d793          	srli	a5,s1,0x1
    80000c22:	8b85                	andi	a5,a5,1
    80000c24:	dd7c                	sw	a5,124(a0)
    80000c26:	b7c5                	j	80000c06 <push_off+0x22>

0000000080000c28 <acquire>:
{
    80000c28:	1101                	addi	sp,sp,-32
    80000c2a:	ec06                	sd	ra,24(sp)
    80000c2c:	e822                	sd	s0,16(sp)
    80000c2e:	e426                	sd	s1,8(sp)
    80000c30:	1000                	addi	s0,sp,32
    80000c32:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c34:	fb1ff0ef          	jal	80000be4 <push_off>
  if(holding(lk))
    80000c38:	8526                	mv	a0,s1
    80000c3a:	f7fff0ef          	jal	80000bb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e105                	bnez	a0,80000c60 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x1a>
  __sync_synchronize();
    80000c4c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c50:	4ab000ef          	jal	800018fa <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	3e850513          	addi	a0,a0,1000 # 80008048 <etext+0x48>
    80000c68:	bbdff0ef          	jal	80000824 <panic>

0000000080000c6c <pop_off>:

void
pop_off(void)
{
    80000c6c:	1141                	addi	sp,sp,-16
    80000c6e:	e406                	sd	ra,8(sp)
    80000c70:	e022                	sd	s0,0(sp)
    80000c72:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c74:	487000ef          	jal	800018fa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7e:	e39d                	bnez	a5,80000ca4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c80:	5d3c                	lw	a5,120(a0)
    80000c82:	02f05763          	blez	a5,80000cb0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c86:	37fd                	addiw	a5,a5,-1
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb89                	bnez	a5,80000c9c <pop_off+0x30>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80008050 <etext+0x50>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3b850513          	addi	a0,a0,952 # 80008068 <etext+0x68>
    80000cb8:	b6dff0ef          	jal	80000824 <panic>

0000000080000cbc <release>:
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
    80000cc6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc8:	ef1ff0ef          	jal	80000bb8 <holding>
    80000ccc:	c105                	beqz	a0,80000cec <release+0x30>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cd6:	0310000f          	fence	rw,w
    80000cda:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cde:	f8fff0ef          	jal	80000c6c <pop_off>
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret
    panic("release");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	38450513          	addi	a0,a0,900 # 80008070 <etext+0x70>
    80000cf4:	b31ff0ef          	jal	80000824 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e406                	sd	ra,8(sp)
    80000cfc:	e022                	sd	s0,0(sp)
    80000cfe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1e>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x14>
  }
  return dst;
}
    80000d16:	60a2                	ld	ra,8(sp)
    80000d18:	6402                	ld	s0,0(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e406                	sd	ra,8(sp)
    80000d22:	e022                	sd	s0,0(sp)
    80000d24:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d26:	c61d                	beqz	a2,80000d54 <memcmp+0x36>
    80000d28:	1602                	slli	a2,a2,0x20
    80000d2a:	9201                	srli	a2,a2,0x20
    80000d2c:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x12>
  }

  return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x2e>
      return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	60a2                	ld	ra,8(sp)
    80000d4e:	6402                	ld	s0,0(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  return 0;
    80000d54:	4501                	li	a0,0
    80000d56:	bfdd                	j	80000d4c <memcmp+0x2e>

0000000080000d58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d60:	c205                	beqz	a2,80000d80 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d62:	02a5e363          	bltu	a1,a0,80000d88 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d66:	1602                	slli	a2,a2,0x20
    80000d68:	9201                	srli	a2,a2,0x20
    80000d6a:	00c587b3          	add	a5,a1,a2
{
    80000d6e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d70:	0585                	addi	a1,a1,1
    80000d72:	0705                	addi	a4,a4,1
    80000d74:	fff5c683          	lbu	a3,-1(a1)
    80000d78:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d7c:	feb79ae3          	bne	a5,a1,80000d70 <memmove+0x18>

  return dst;
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
  if(s < d && s + n > d){
    80000d88:	02061693          	slli	a3,a2,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	00d58733          	add	a4,a1,a3
    80000d92:	fce57ae3          	bgeu	a0,a4,80000d66 <memmove+0xe>
    d += n;
    80000d96:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d98:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d9c:	1782                	slli	a5,a5,0x20
    80000d9e:	9381                	srli	a5,a5,0x20
    80000da0:	fff7c793          	not	a5,a5
    80000da4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da6:	177d                	addi	a4,a4,-1
    80000da8:	16fd                	addi	a3,a3,-1
    80000daa:	00074603          	lbu	a2,0(a4)
    80000dae:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000db2:	fee79ae3          	bne	a5,a4,80000da6 <memmove+0x4e>
    80000db6:	b7e9                	j	80000d80 <memmove+0x28>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	f99ff0ef          	jal	80000d58 <memmove>
}
    80000dc4:	60a2                	ld	ra,8(sp)
    80000dc6:	6402                	ld	s0,0(sp)
    80000dc8:	0141                	addi	sp,sp,16
    80000dca:	8082                	ret

0000000080000dcc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dcc:	1141                	addi	sp,sp,-16
    80000dce:	e406                	sd	ra,8(sp)
    80000dd0:	e022                	sd	s0,0(sp)
    80000dd2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd4:	ce11                	beqz	a2,80000df0 <strncmp+0x24>
    80000dd6:	00054783          	lbu	a5,0(a0)
    80000dda:	cf89                	beqz	a5,80000df4 <strncmp+0x28>
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	00f71a63          	bne	a4,a5,80000df4 <strncmp+0x28>
    n--, p++, q++;
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	0505                	addi	a0,a0,1
    80000de8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dea:	f675                	bnez	a2,80000dd6 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dec:	4501                	li	a0,0
    80000dee:	a801                	j	80000dfe <strncmp+0x32>
    80000df0:	4501                	li	a0,0
    80000df2:	a031                	j	80000dfe <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000df4:	00054503          	lbu	a0,0(a0)
    80000df8:	0005c783          	lbu	a5,0(a1)
    80000dfc:	9d1d                	subw	a0,a0,a5
}
    80000dfe:	60a2                	ld	ra,8(sp)
    80000e00:	6402                	ld	s0,0(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e406                	sd	ra,8(sp)
    80000e0a:	e022                	sd	s0,0(sp)
    80000e0c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e0e:	87aa                	mv	a5,a0
    80000e10:	a011                	j	80000e14 <strncpy+0xe>
    80000e12:	8636                	mv	a2,a3
    80000e14:	02c05863          	blez	a2,80000e44 <strncpy+0x3e>
    80000e18:	fff6069b          	addiw	a3,a2,-1
    80000e1c:	8836                	mv	a6,a3
    80000e1e:	0785                	addi	a5,a5,1
    80000e20:	0005c703          	lbu	a4,0(a1)
    80000e24:	fee78fa3          	sb	a4,-1(a5)
    80000e28:	0585                	addi	a1,a1,1
    80000e2a:	f765                	bnez	a4,80000e12 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e2c:	873e                	mv	a4,a5
    80000e2e:	01005b63          	blez	a6,80000e44 <strncpy+0x3e>
    80000e32:	9fb1                	addw	a5,a5,a2
    80000e34:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e36:	0705                	addi	a4,a4,1
    80000e38:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e3c:	40e786bb          	subw	a3,a5,a4
    80000e40:	fed04be3          	bgtz	a3,80000e36 <strncpy+0x30>
  return os;
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2e>
    80000e58:	fff6069b          	addiw	a3,a2,-1
    80000e5c:	1682                	slli	a3,a3,0x20
    80000e5e:	9281                	srli	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x2a>
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	60a2                	ld	ra,8(sp)
    80000e7c:	6402                	ld	s0,0(sp)
    80000e7e:	0141                	addi	sp,sp,16
    80000e80:	8082                	ret

0000000080000e82 <strlen>:

int
strlen(const char *s)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8a:	00054783          	lbu	a5,0(a0)
    80000e8e:	cf91                	beqz	a5,80000eaa <strlen+0x28>
    80000e90:	00150793          	addi	a5,a0,1
    80000e94:	86be                	mv	a3,a5
    80000e96:	0785                	addi	a5,a5,1
    80000e98:	fff7c703          	lbu	a4,-1(a5)
    80000e9c:	ff65                	bnez	a4,80000e94 <strlen+0x12>
    80000e9e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000ea2:	60a2                	ld	ra,8(sp)
    80000ea4:	6402                	ld	s0,0(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eaa:	4501                	li	a0,0
    80000eac:	bfdd                	j	80000ea2 <strlen+0x20>

0000000080000eae <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e406                	sd	ra,8(sp)
    80000eb2:	e022                	sd	s0,0(sp)
    80000eb4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb6:	231000ef          	jal	800018e6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	9e670713          	addi	a4,a4,-1562 # 800088a0 <started>
  if(cpuid() == 0){
    80000ec2:	c51d                	beqz	a0,80000ef0 <main+0x42>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x16>
      ;
    __sync_synchronize();
    80000eca:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ece:	219000ef          	jal	800018e6 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1c450513          	addi	a0,a0,452 # 80008098 <etext+0x98>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	399010ef          	jal	80002a7c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	4b1040ef          	jal	80005b98 <plicinithart>
  }

  scheduler();
    80000eec:	176010ef          	jal	80002062 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	18050513          	addi	a0,a0,384 # 80008078 <etext+0x78>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	17c50513          	addi	a0,a0,380 # 80008080 <etext+0x80>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	16850513          	addi	a0,a0,360 # 80008078 <etext+0x78>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2cc000ef          	jal	800011ec <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	115000ef          	jal	8000183c <procinit>
    trapinit();      // trap vectors
    80000f2c:	32d010ef          	jal	80002a58 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	34d010ef          	jal	80002a7c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	44b040ef          	jal	80005b7e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	461040ef          	jal	80005b98 <plicinithart>
    binit();         // buffer cache
    80000f3c:	28a020ef          	jal	800031c6 <binit>
    iinit();         // inode table
    80000f40:	7dc020ef          	jal	8000371c <iinit>
    fileinit();      // file table
    80000f44:	708030ef          	jal	8000464c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	541040ef          	jal	80005c88 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	5eb000ef          	jal	80001d36 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	94f72523          	sw	a5,-1718(a4) # 800088a0 <started>
    80000f5e:	b779                	j	80000eec <main+0x3e>

0000000080000f60 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f60:	1141                	addi	sp,sp,-16
    80000f62:	e406                	sd	ra,8(sp)
    80000f64:	e022                	sd	s0,0(sp)
    80000f66:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f68:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f6c:	00008797          	auipc	a5,0x8
    80000f70:	93c7b783          	ld	a5,-1732(a5) # 800088a8 <kernel_pagetable>
    80000f74:	83b1                	srli	a5,a5,0xc
    80000f76:	577d                	li	a4,-1
    80000f78:	177e                	slli	a4,a4,0x3f
    80000f7a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f7c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f80:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f84:	60a2                	ld	ra,8(sp)
    80000f86:	6402                	ld	s0,0(sp)
    80000f88:	0141                	addi	sp,sp,16
    80000f8a:	8082                	ret

0000000080000f8c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f8c:	7139                	addi	sp,sp,-64
    80000f8e:	fc06                	sd	ra,56(sp)
    80000f90:	f822                	sd	s0,48(sp)
    80000f92:	f426                	sd	s1,40(sp)
    80000f94:	f04a                	sd	s2,32(sp)
    80000f96:	ec4e                	sd	s3,24(sp)
    80000f98:	e852                	sd	s4,16(sp)
    80000f9a:	e456                	sd	s5,8(sp)
    80000f9c:	e05a                	sd	s6,0(sp)
    80000f9e:	0080                	addi	s0,sp,64
    80000fa0:	84aa                	mv	s1,a0
    80000fa2:	89ae                	mv	s3,a1
    80000fa4:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000fa6:	57fd                	li	a5,-1
    80000fa8:	83e9                	srli	a5,a5,0x1a
    80000faa:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fac:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000fae:	04b7e263          	bltu	a5,a1,80000ff2 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fb2:	0149d933          	srl	s2,s3,s4
    80000fb6:	1ff97913          	andi	s2,s2,511
    80000fba:	090e                	slli	s2,s2,0x3
    80000fbc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fbe:	00093483          	ld	s1,0(s2)
    80000fc2:	0014f793          	andi	a5,s1,1
    80000fc6:	cf85                	beqz	a5,80000ffe <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fc8:	80a9                	srli	s1,s1,0xa
    80000fca:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fcc:	3a5d                	addiw	s4,s4,-9
    80000fce:	ff5a12e3          	bne	s4,s5,80000fb2 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fd2:	00c9d513          	srli	a0,s3,0xc
    80000fd6:	1ff57513          	andi	a0,a0,511
    80000fda:	050e                	slli	a0,a0,0x3
    80000fdc:	9526                	add	a0,a0,s1
}
    80000fde:	70e2                	ld	ra,56(sp)
    80000fe0:	7442                	ld	s0,48(sp)
    80000fe2:	74a2                	ld	s1,40(sp)
    80000fe4:	7902                	ld	s2,32(sp)
    80000fe6:	69e2                	ld	s3,24(sp)
    80000fe8:	6a42                	ld	s4,16(sp)
    80000fea:	6aa2                	ld	s5,8(sp)
    80000fec:	6b02                	ld	s6,0(sp)
    80000fee:	6121                	addi	sp,sp,64
    80000ff0:	8082                	ret
    panic("walk");
    80000ff2:	00007517          	auipc	a0,0x7
    80000ff6:	0be50513          	addi	a0,a0,190 # 800080b0 <etext+0xb0>
    80000ffa:	82bff0ef          	jal	80000824 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ffe:	020b0263          	beqz	s6,80001022 <walk+0x96>
    80001002:	b43ff0ef          	jal	80000b44 <kalloc>
    80001006:	84aa                	mv	s1,a0
    80001008:	d979                	beqz	a0,80000fde <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000100a:	6605                	lui	a2,0x1
    8000100c:	4581                	li	a1,0
    8000100e:	cebff0ef          	jal	80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001012:	00c4d793          	srli	a5,s1,0xc
    80001016:	07aa                	slli	a5,a5,0xa
    80001018:	0017e793          	ori	a5,a5,1
    8000101c:	00f93023          	sd	a5,0(s2)
    80001020:	b775                	j	80000fcc <walk+0x40>
        return 0;
    80001022:	4501                	li	a0,0
    80001024:	bf6d                	j	80000fde <walk+0x52>

0000000080001026 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001026:	57fd                	li	a5,-1
    80001028:	83e9                	srli	a5,a5,0x1a
    8000102a:	00b7f463          	bgeu	a5,a1,80001032 <walkaddr+0xc>
    return 0;
    8000102e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001030:	8082                	ret
{
    80001032:	1141                	addi	sp,sp,-16
    80001034:	e406                	sd	ra,8(sp)
    80001036:	e022                	sd	s0,0(sp)
    80001038:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000103a:	4601                	li	a2,0
    8000103c:	f51ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    80001040:	c901                	beqz	a0,80001050 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80001042:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001044:	0117f693          	andi	a3,a5,17
    80001048:	4745                	li	a4,17
    return 0;
    8000104a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000104c:	00e68663          	beq	a3,a4,80001058 <walkaddr+0x32>
}
    80001050:	60a2                	ld	ra,8(sp)
    80001052:	6402                	ld	s0,0(sp)
    80001054:	0141                	addi	sp,sp,16
    80001056:	8082                	ret
  pa = PTE2PA(*pte);
    80001058:	83a9                	srli	a5,a5,0xa
    8000105a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000105e:	bfcd                	j	80001050 <walkaddr+0x2a>

0000000080001060 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001060:	715d                	addi	sp,sp,-80
    80001062:	e486                	sd	ra,72(sp)
    80001064:	e0a2                	sd	s0,64(sp)
    80001066:	fc26                	sd	s1,56(sp)
    80001068:	f84a                	sd	s2,48(sp)
    8000106a:	f44e                	sd	s3,40(sp)
    8000106c:	f052                	sd	s4,32(sp)
    8000106e:	ec56                	sd	s5,24(sp)
    80001070:	e85a                	sd	s6,16(sp)
    80001072:	e45e                	sd	s7,8(sp)
    80001074:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001076:	03459793          	slli	a5,a1,0x34
    8000107a:	eba1                	bnez	a5,800010ca <mappages+0x6a>
    8000107c:	8a2a                	mv	s4,a0
    8000107e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001080:	03461793          	slli	a5,a2,0x34
    80001084:	eba9                	bnez	a5,800010d6 <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    80001086:	ce31                	beqz	a2,800010e2 <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001088:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000108c:	80060613          	addi	a2,a2,-2048
    80001090:	00b60933          	add	s2,a2,a1
  a = va;
    80001094:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001096:	4b05                	li	s6,1
    80001098:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000109c:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000109e:	865a                	mv	a2,s6
    800010a0:	85a6                	mv	a1,s1
    800010a2:	8552                	mv	a0,s4
    800010a4:	ee9ff0ef          	jal	80000f8c <walk>
    800010a8:	c929                	beqz	a0,800010fa <mappages+0x9a>
    if(*pte & PTE_V)
    800010aa:	611c                	ld	a5,0(a0)
    800010ac:	8b85                	andi	a5,a5,1
    800010ae:	e3a1                	bnez	a5,800010ee <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010b0:	013487b3          	add	a5,s1,s3
    800010b4:	83b1                	srli	a5,a5,0xc
    800010b6:	07aa                	slli	a5,a5,0xa
    800010b8:	0157e7b3          	or	a5,a5,s5
    800010bc:	0017e793          	ori	a5,a5,1
    800010c0:	e11c                	sd	a5,0(a0)
    if(a == last)
    800010c2:	05248863          	beq	s1,s2,80001112 <mappages+0xb2>
    a += PGSIZE;
    800010c6:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c8:	bfd9                	j	8000109e <mappages+0x3e>
    panic("mappages: va not aligned");
    800010ca:	00007517          	auipc	a0,0x7
    800010ce:	fee50513          	addi	a0,a0,-18 # 800080b8 <etext+0xb8>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800010d6:	00007517          	auipc	a0,0x7
    800010da:	00250513          	addi	a0,a0,2 # 800080d8 <etext+0xd8>
    800010de:	f46ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800010e2:	00007517          	auipc	a0,0x7
    800010e6:	01650513          	addi	a0,a0,22 # 800080f8 <etext+0xf8>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	01a50513          	addi	a0,a0,26 # 80008108 <etext+0x108>
    800010f6:	f2eff0ef          	jal	80000824 <panic>
      return -1;
    800010fa:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010fc:	60a6                	ld	ra,72(sp)
    800010fe:	6406                	ld	s0,64(sp)
    80001100:	74e2                	ld	s1,56(sp)
    80001102:	7942                	ld	s2,48(sp)
    80001104:	79a2                	ld	s3,40(sp)
    80001106:	7a02                	ld	s4,32(sp)
    80001108:	6ae2                	ld	s5,24(sp)
    8000110a:	6b42                	ld	s6,16(sp)
    8000110c:	6ba2                	ld	s7,8(sp)
    8000110e:	6161                	addi	sp,sp,80
    80001110:	8082                	ret
  return 0;
    80001112:	4501                	li	a0,0
    80001114:	b7e5                	j	800010fc <mappages+0x9c>

0000000080001116 <kvmmap>:
{
    80001116:	1141                	addi	sp,sp,-16
    80001118:	e406                	sd	ra,8(sp)
    8000111a:	e022                	sd	s0,0(sp)
    8000111c:	0800                	addi	s0,sp,16
    8000111e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001120:	86b2                	mv	a3,a2
    80001122:	863e                	mv	a2,a5
    80001124:	f3dff0ef          	jal	80001060 <mappages>
    80001128:	e509                	bnez	a0,80001132 <kvmmap+0x1c>
}
    8000112a:	60a2                	ld	ra,8(sp)
    8000112c:	6402                	ld	s0,0(sp)
    8000112e:	0141                	addi	sp,sp,16
    80001130:	8082                	ret
    panic("kvmmap");
    80001132:	00007517          	auipc	a0,0x7
    80001136:	fe650513          	addi	a0,a0,-26 # 80008118 <etext+0x118>
    8000113a:	eeaff0ef          	jal	80000824 <panic>

000000008000113e <kvmmake>:
{
    8000113e:	1101                	addi	sp,sp,-32
    80001140:	ec06                	sd	ra,24(sp)
    80001142:	e822                	sd	s0,16(sp)
    80001144:	e426                	sd	s1,8(sp)
    80001146:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001148:	9fdff0ef          	jal	80000b44 <kalloc>
    8000114c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000114e:	6605                	lui	a2,0x1
    80001150:	4581                	li	a1,0
    80001152:	ba7ff0ef          	jal	80000cf8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001156:	4719                	li	a4,6
    80001158:	6685                	lui	a3,0x1
    8000115a:	10000637          	lui	a2,0x10000
    8000115e:	85b2                	mv	a1,a2
    80001160:	8526                	mv	a0,s1
    80001162:	fb5ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001166:	4719                	li	a4,6
    80001168:	6685                	lui	a3,0x1
    8000116a:	10001637          	lui	a2,0x10001
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	fa5ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001176:	4719                	li	a4,6
    80001178:	040006b7          	lui	a3,0x4000
    8000117c:	0c000637          	lui	a2,0xc000
    80001180:	85b2                	mv	a1,a2
    80001182:	8526                	mv	a0,s1
    80001184:	f93ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001188:	4729                	li	a4,10
    8000118a:	80007697          	auipc	a3,0x80007
    8000118e:	e7668693          	addi	a3,a3,-394 # 8000 <_entry-0x7fff8000>
    80001192:	4605                	li	a2,1
    80001194:	067e                	slli	a2,a2,0x1f
    80001196:	85b2                	mv	a1,a2
    80001198:	8526                	mv	a0,s1
    8000119a:	f7dff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119e:	4719                	li	a4,6
    800011a0:	00007697          	auipc	a3,0x7
    800011a4:	e6068693          	addi	a3,a3,-416 # 80008000 <etext>
    800011a8:	47c5                	li	a5,17
    800011aa:	07ee                	slli	a5,a5,0x1b
    800011ac:	40d786b3          	sub	a3,a5,a3
    800011b0:	00007617          	auipc	a2,0x7
    800011b4:	e5060613          	addi	a2,a2,-432 # 80008000 <etext>
    800011b8:	85b2                	mv	a1,a2
    800011ba:	8526                	mv	a0,s1
    800011bc:	f5bff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	4729                	li	a4,10
    800011c2:	6685                	lui	a3,0x1
    800011c4:	00006617          	auipc	a2,0x6
    800011c8:	e3c60613          	addi	a2,a2,-452 # 80007000 <_trampoline>
    800011cc:	040005b7          	lui	a1,0x4000
    800011d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d2:	05b2                	slli	a1,a1,0xc
    800011d4:	8526                	mv	a0,s1
    800011d6:	f41ff0ef          	jal	80001116 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011da:	8526                	mv	a0,s1
    800011dc:	5c8000ef          	jal	800017a4 <proc_mapstacks>
}
    800011e0:	8526                	mv	a0,s1
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <kvminit>:
{
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e406                	sd	ra,8(sp)
    800011f0:	e022                	sd	s0,0(sp)
    800011f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011f4:	f4bff0ef          	jal	8000113e <kvmmake>
    800011f8:	00007797          	auipc	a5,0x7
    800011fc:	6aa7b823          	sd	a0,1712(a5) # 800088a8 <kernel_pagetable>
}
    80001200:	60a2                	ld	ra,8(sp)
    80001202:	6402                	ld	s0,0(sp)
    80001204:	0141                	addi	sp,sp,16
    80001206:	8082                	ret

0000000080001208 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001212:	933ff0ef          	jal	80000b44 <kalloc>
    80001216:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001218:	c509                	beqz	a0,80001222 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	adbff0ef          	jal	80000cf8 <memset>
  return pagetable;
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000122e:	7139                	addi	sp,sp,-64
    80001230:	fc06                	sd	ra,56(sp)
    80001232:	f822                	sd	s0,48(sp)
    80001234:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001236:	03459793          	slli	a5,a1,0x34
    8000123a:	e38d                	bnez	a5,8000125c <uvmunmap+0x2e>
    8000123c:	f04a                	sd	s2,32(sp)
    8000123e:	ec4e                	sd	s3,24(sp)
    80001240:	e852                	sd	s4,16(sp)
    80001242:	e456                	sd	s5,8(sp)
    80001244:	e05a                	sd	s6,0(sp)
    80001246:	8a2a                	mv	s4,a0
    80001248:	892e                	mv	s2,a1
    8000124a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124c:	0632                	slli	a2,a2,0xc
    8000124e:	00b609b3          	add	s3,a2,a1
    80001252:	6b05                	lui	s6,0x1
    80001254:	0535f963          	bgeu	a1,s3,800012a6 <uvmunmap+0x78>
    80001258:	f426                	sd	s1,40(sp)
    8000125a:	a015                	j	8000127e <uvmunmap+0x50>
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001268:	00007517          	auipc	a0,0x7
    8000126c:	eb850513          	addi	a0,a0,-328 # 80008120 <etext+0x120>
    80001270:	db4ff0ef          	jal	80000824 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001274:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001278:	995a                	add	s2,s2,s6
    8000127a:	03397563          	bgeu	s2,s3,800012a4 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000127e:	4601                	li	a2,0
    80001280:	85ca                	mv	a1,s2
    80001282:	8552                	mv	a0,s4
    80001284:	d09ff0ef          	jal	80000f8c <walk>
    80001288:	84aa                	mv	s1,a0
    8000128a:	d57d                	beqz	a0,80001278 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000128c:	611c                	ld	a5,0(a0)
    8000128e:	0017f713          	andi	a4,a5,1
    80001292:	d37d                	beqz	a4,80001278 <uvmunmap+0x4a>
    if(do_free){
    80001294:	fe0a80e3          	beqz	s5,80001274 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001298:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000129a:	00c79513          	slli	a0,a5,0xc
    8000129e:	fbeff0ef          	jal	80000a5c <kfree>
    800012a2:	bfc9                	j	80001274 <uvmunmap+0x46>
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	7902                	ld	s2,32(sp)
    800012a8:	69e2                	ld	s3,24(sp)
    800012aa:	6a42                	ld	s4,16(sp)
    800012ac:	6aa2                	ld	s5,8(sp)
    800012ae:	6b02                	ld	s6,0(sp)
  }
}
    800012b0:	70e2                	ld	ra,56(sp)
    800012b2:	7442                	ld	s0,48(sp)
    800012b4:	6121                	addi	sp,sp,64
    800012b6:	8082                	ret

00000000800012b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012b8:	1101                	addi	sp,sp,-32
    800012ba:	ec06                	sd	ra,24(sp)
    800012bc:	e822                	sd	s0,16(sp)
    800012be:	e426                	sd	s1,8(sp)
    800012c0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012c4:	00b67d63          	bgeu	a2,a1,800012de <uvmdealloc+0x26>
    800012c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012ca:	6785                	lui	a5,0x1
    800012cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ce:	00f60733          	add	a4,a2,a5
    800012d2:	76fd                	lui	a3,0xfffff
    800012d4:	8f75                	and	a4,a4,a3
    800012d6:	97ae                	add	a5,a5,a1
    800012d8:	8ff5                	and	a5,a5,a3
    800012da:	00f76863          	bltu	a4,a5,800012ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012de:	8526                	mv	a0,s1
    800012e0:	60e2                	ld	ra,24(sp)
    800012e2:	6442                	ld	s0,16(sp)
    800012e4:	64a2                	ld	s1,8(sp)
    800012e6:	6105                	addi	sp,sp,32
    800012e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ea:	8f99                	sub	a5,a5,a4
    800012ec:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012ee:	4685                	li	a3,1
    800012f0:	0007861b          	sext.w	a2,a5
    800012f4:	85ba                	mv	a1,a4
    800012f6:	f39ff0ef          	jal	8000122e <uvmunmap>
    800012fa:	b7d5                	j	800012de <uvmdealloc+0x26>

00000000800012fc <uvmalloc>:
  if(newsz < oldsz)
    800012fc:	0ab66163          	bltu	a2,a1,8000139e <uvmalloc+0xa2>
{
    80001300:	715d                	addi	sp,sp,-80
    80001302:	e486                	sd	ra,72(sp)
    80001304:	e0a2                	sd	s0,64(sp)
    80001306:	f84a                	sd	s2,48(sp)
    80001308:	f052                	sd	s4,32(sp)
    8000130a:	ec56                	sd	s5,24(sp)
    8000130c:	e45e                	sd	s7,8(sp)
    8000130e:	0880                	addi	s0,sp,80
    80001310:	8aaa                	mv	s5,a0
    80001312:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001314:	6785                	lui	a5,0x1
    80001316:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001318:	95be                	add	a1,a1,a5
    8000131a:	77fd                	lui	a5,0xfffff
    8000131c:	00f5f933          	and	s2,a1,a5
    80001320:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001322:	08c97063          	bgeu	s2,a2,800013a2 <uvmalloc+0xa6>
    80001326:	fc26                	sd	s1,56(sp)
    80001328:	f44e                	sd	s3,40(sp)
    8000132a:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    8000132c:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000132e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001332:	813ff0ef          	jal	80000b44 <kalloc>
    80001336:	84aa                	mv	s1,a0
    if(mem == 0){
    80001338:	c50d                	beqz	a0,80001362 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    8000133a:	864e                	mv	a2,s3
    8000133c:	4581                	li	a1,0
    8000133e:	9bbff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001342:	875a                	mv	a4,s6
    80001344:	86a6                	mv	a3,s1
    80001346:	864e                	mv	a2,s3
    80001348:	85ca                	mv	a1,s2
    8000134a:	8556                	mv	a0,s5
    8000134c:	d15ff0ef          	jal	80001060 <mappages>
    80001350:	e915                	bnez	a0,80001384 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001352:	994e                	add	s2,s2,s3
    80001354:	fd496fe3          	bltu	s2,s4,80001332 <uvmalloc+0x36>
  return newsz;
    80001358:	8552                	mv	a0,s4
    8000135a:	74e2                	ld	s1,56(sp)
    8000135c:	79a2                	ld	s3,40(sp)
    8000135e:	6b42                	ld	s6,16(sp)
    80001360:	a811                	j	80001374 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001362:	865e                	mv	a2,s7
    80001364:	85ca                	mv	a1,s2
    80001366:	8556                	mv	a0,s5
    80001368:	f51ff0ef          	jal	800012b8 <uvmdealloc>
      return 0;
    8000136c:	4501                	li	a0,0
    8000136e:	74e2                	ld	s1,56(sp)
    80001370:	79a2                	ld	s3,40(sp)
    80001372:	6b42                	ld	s6,16(sp)
}
    80001374:	60a6                	ld	ra,72(sp)
    80001376:	6406                	ld	s0,64(sp)
    80001378:	7942                	ld	s2,48(sp)
    8000137a:	7a02                	ld	s4,32(sp)
    8000137c:	6ae2                	ld	s5,24(sp)
    8000137e:	6ba2                	ld	s7,8(sp)
    80001380:	6161                	addi	sp,sp,80
    80001382:	8082                	ret
      kfree(mem);
    80001384:	8526                	mv	a0,s1
    80001386:	ed6ff0ef          	jal	80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000138a:	865e                	mv	a2,s7
    8000138c:	85ca                	mv	a1,s2
    8000138e:	8556                	mv	a0,s5
    80001390:	f29ff0ef          	jal	800012b8 <uvmdealloc>
      return 0;
    80001394:	4501                	li	a0,0
    80001396:	74e2                	ld	s1,56(sp)
    80001398:	79a2                	ld	s3,40(sp)
    8000139a:	6b42                	ld	s6,16(sp)
    8000139c:	bfe1                	j	80001374 <uvmalloc+0x78>
    return oldsz;
    8000139e:	852e                	mv	a0,a1
}
    800013a0:	8082                	ret
  return newsz;
    800013a2:	8532                	mv	a0,a2
    800013a4:	bfc1                	j	80001374 <uvmalloc+0x78>

00000000800013a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013a6:	7179                	addi	sp,sp,-48
    800013a8:	f406                	sd	ra,40(sp)
    800013aa:	f022                	sd	s0,32(sp)
    800013ac:	ec26                	sd	s1,24(sp)
    800013ae:	e84a                	sd	s2,16(sp)
    800013b0:	e44e                	sd	s3,8(sp)
    800013b2:	1800                	addi	s0,sp,48
    800013b4:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013b6:	84aa                	mv	s1,a0
    800013b8:	6905                	lui	s2,0x1
    800013ba:	992a                	add	s2,s2,a0
    800013bc:	a811                	j	800013d0 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800013be:	00007517          	auipc	a0,0x7
    800013c2:	d7a50513          	addi	a0,a0,-646 # 80008138 <etext+0x138>
    800013c6:	c5eff0ef          	jal	80000824 <panic>
  for(int i = 0; i < 512; i++){
    800013ca:	04a1                	addi	s1,s1,8
    800013cc:	03248163          	beq	s1,s2,800013ee <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013d0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d2:	0017f713          	andi	a4,a5,1
    800013d6:	db75                	beqz	a4,800013ca <freewalk+0x24>
    800013d8:	00e7f713          	andi	a4,a5,14
    800013dc:	f36d                	bnez	a4,800013be <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013de:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013e0:	00c79513          	slli	a0,a5,0xc
    800013e4:	fc3ff0ef          	jal	800013a6 <freewalk>
      pagetable[i] = 0;
    800013e8:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ec:	bff9                	j	800013ca <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800013ee:	854e                	mv	a0,s3
    800013f0:	e6cff0ef          	jal	80000a5c <kfree>
}
    800013f4:	70a2                	ld	ra,40(sp)
    800013f6:	7402                	ld	s0,32(sp)
    800013f8:	64e2                	ld	s1,24(sp)
    800013fa:	6942                	ld	s2,16(sp)
    800013fc:	69a2                	ld	s3,8(sp)
    800013fe:	6145                	addi	sp,sp,48
    80001400:	8082                	ret

0000000080001402 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001402:	1101                	addi	sp,sp,-32
    80001404:	ec06                	sd	ra,24(sp)
    80001406:	e822                	sd	s0,16(sp)
    80001408:	e426                	sd	s1,8(sp)
    8000140a:	1000                	addi	s0,sp,32
    8000140c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000140e:	e989                	bnez	a1,80001420 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001410:	8526                	mv	a0,s1
    80001412:	f95ff0ef          	jal	800013a6 <freewalk>
}
    80001416:	60e2                	ld	ra,24(sp)
    80001418:	6442                	ld	s0,16(sp)
    8000141a:	64a2                	ld	s1,8(sp)
    8000141c:	6105                	addi	sp,sp,32
    8000141e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001420:	6785                	lui	a5,0x1
    80001422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001424:	95be                	add	a1,a1,a5
    80001426:	4685                	li	a3,1
    80001428:	00c5d613          	srli	a2,a1,0xc
    8000142c:	4581                	li	a1,0
    8000142e:	e01ff0ef          	jal	8000122e <uvmunmap>
    80001432:	bff9                	j	80001410 <uvmfree+0xe>

0000000080001434 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001434:	ca59                	beqz	a2,800014ca <uvmcopy+0x96>
{
    80001436:	715d                	addi	sp,sp,-80
    80001438:	e486                	sd	ra,72(sp)
    8000143a:	e0a2                	sd	s0,64(sp)
    8000143c:	fc26                	sd	s1,56(sp)
    8000143e:	f84a                	sd	s2,48(sp)
    80001440:	f44e                	sd	s3,40(sp)
    80001442:	f052                	sd	s4,32(sp)
    80001444:	ec56                	sd	s5,24(sp)
    80001446:	e85a                	sd	s6,16(sp)
    80001448:	e45e                	sd	s7,8(sp)
    8000144a:	0880                	addi	s0,sp,80
    8000144c:	8b2a                	mv	s6,a0
    8000144e:	8bae                	mv	s7,a1
    80001450:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001452:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001454:	6a05                	lui	s4,0x1
    80001456:	a021                	j	8000145e <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    80001458:	94d2                	add	s1,s1,s4
    8000145a:	0554fc63          	bgeu	s1,s5,800014b2 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    8000145e:	4601                	li	a2,0
    80001460:	85a6                	mv	a1,s1
    80001462:	855a                	mv	a0,s6
    80001464:	b29ff0ef          	jal	80000f8c <walk>
    80001468:	d965                	beqz	a0,80001458 <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    8000146a:	00053983          	ld	s3,0(a0)
    8000146e:	0019f793          	andi	a5,s3,1
    80001472:	d3fd                	beqz	a5,80001458 <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    80001474:	ed0ff0ef          	jal	80000b44 <kalloc>
    80001478:	892a                	mv	s2,a0
    8000147a:	c11d                	beqz	a0,800014a0 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000147c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001480:	8652                	mv	a2,s4
    80001482:	05b2                	slli	a1,a1,0xc
    80001484:	8d5ff0ef          	jal	80000d58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001488:	3ff9f713          	andi	a4,s3,1023
    8000148c:	86ca                	mv	a3,s2
    8000148e:	8652                	mv	a2,s4
    80001490:	85a6                	mv	a1,s1
    80001492:	855e                	mv	a0,s7
    80001494:	bcdff0ef          	jal	80001060 <mappages>
    80001498:	d161                	beqz	a0,80001458 <uvmcopy+0x24>
      kfree(mem);
    8000149a:	854a                	mv	a0,s2
    8000149c:	dc0ff0ef          	jal	80000a5c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014a0:	4685                	li	a3,1
    800014a2:	00c4d613          	srli	a2,s1,0xc
    800014a6:	4581                	li	a1,0
    800014a8:	855e                	mv	a0,s7
    800014aa:	d85ff0ef          	jal	8000122e <uvmunmap>
  return -1;
    800014ae:	557d                	li	a0,-1
    800014b0:	a011                	j	800014b4 <uvmcopy+0x80>
  return 0;
    800014b2:	4501                	li	a0,0
}
    800014b4:	60a6                	ld	ra,72(sp)
    800014b6:	6406                	ld	s0,64(sp)
    800014b8:	74e2                	ld	s1,56(sp)
    800014ba:	7942                	ld	s2,48(sp)
    800014bc:	79a2                	ld	s3,40(sp)
    800014be:	7a02                	ld	s4,32(sp)
    800014c0:	6ae2                	ld	s5,24(sp)
    800014c2:	6b42                	ld	s6,16(sp)
    800014c4:	6ba2                	ld	s7,8(sp)
    800014c6:	6161                	addi	sp,sp,80
    800014c8:	8082                	ret
  return 0;
    800014ca:	4501                	li	a0,0
}
    800014cc:	8082                	ret

00000000800014ce <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014ce:	1141                	addi	sp,sp,-16
    800014d0:	e406                	sd	ra,8(sp)
    800014d2:	e022                	sd	s0,0(sp)
    800014d4:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800014d6:	4601                	li	a2,0
    800014d8:	ab5ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    800014dc:	c901                	beqz	a0,800014ec <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014de:	611c                	ld	a5,0(a0)
    800014e0:	9bbd                	andi	a5,a5,-17
    800014e2:	e11c                	sd	a5,0(a0)
}
    800014e4:	60a2                	ld	ra,8(sp)
    800014e6:	6402                	ld	s0,0(sp)
    800014e8:	0141                	addi	sp,sp,16
    800014ea:	8082                	ret
    panic("uvmclear");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	c5c50513          	addi	a0,a0,-932 # 80008148 <etext+0x148>
    800014f4:	b30ff0ef          	jal	80000824 <panic>

00000000800014f8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800014f8:	cac5                	beqz	a3,800015a8 <copyinstr+0xb0>
{
    800014fa:	715d                	addi	sp,sp,-80
    800014fc:	e486                	sd	ra,72(sp)
    800014fe:	e0a2                	sd	s0,64(sp)
    80001500:	fc26                	sd	s1,56(sp)
    80001502:	f84a                	sd	s2,48(sp)
    80001504:	f44e                	sd	s3,40(sp)
    80001506:	f052                	sd	s4,32(sp)
    80001508:	ec56                	sd	s5,24(sp)
    8000150a:	e85a                	sd	s6,16(sp)
    8000150c:	e45e                	sd	s7,8(sp)
    8000150e:	0880                	addi	s0,sp,80
    80001510:	8aaa                	mv	s5,a0
    80001512:	84ae                	mv	s1,a1
    80001514:	8bb2                	mv	s7,a2
    80001516:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001518:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000151a:	6a05                	lui	s4,0x1
    8000151c:	a82d                	j	80001556 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000151e:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001522:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001524:	0017c793          	xori	a5,a5,1
    80001528:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000152c:	60a6                	ld	ra,72(sp)
    8000152e:	6406                	ld	s0,64(sp)
    80001530:	74e2                	ld	s1,56(sp)
    80001532:	7942                	ld	s2,48(sp)
    80001534:	79a2                	ld	s3,40(sp)
    80001536:	7a02                	ld	s4,32(sp)
    80001538:	6ae2                	ld	s5,24(sp)
    8000153a:	6b42                	ld	s6,16(sp)
    8000153c:	6ba2                	ld	s7,8(sp)
    8000153e:	6161                	addi	sp,sp,80
    80001540:	8082                	ret
    80001542:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001546:	9726                	add	a4,a4,s1
      --max;
    80001548:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    8000154c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001550:	04e58463          	beq	a1,a4,80001598 <copyinstr+0xa0>
{
    80001554:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001556:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000155a:	85ca                	mv	a1,s2
    8000155c:	8556                	mv	a0,s5
    8000155e:	ac9ff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0)
    80001562:	cd0d                	beqz	a0,8000159c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001564:	417906b3          	sub	a3,s2,s7
    80001568:	96d2                	add	a3,a3,s4
    if(n > max)
    8000156a:	00d9f363          	bgeu	s3,a3,80001570 <copyinstr+0x78>
    8000156e:	86ce                	mv	a3,s3
    while(n > 0){
    80001570:	ca85                	beqz	a3,800015a0 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80001572:	01750633          	add	a2,a0,s7
    80001576:	41260633          	sub	a2,a2,s2
    8000157a:	87a6                	mv	a5,s1
      if(*p == '\0'){
    8000157c:	8e05                	sub	a2,a2,s1
    while(n > 0){
    8000157e:	96a6                	add	a3,a3,s1
    80001580:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001582:	00f60733          	add	a4,a2,a5
    80001586:	00074703          	lbu	a4,0(a4)
    8000158a:	db51                	beqz	a4,8000151e <copyinstr+0x26>
        *dst = *p;
    8000158c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001590:	0785                	addi	a5,a5,1
    while(n > 0){
    80001592:	fed797e3          	bne	a5,a3,80001580 <copyinstr+0x88>
    80001596:	b775                	j	80001542 <copyinstr+0x4a>
    80001598:	4781                	li	a5,0
    8000159a:	b769                	j	80001524 <copyinstr+0x2c>
      return -1;
    8000159c:	557d                	li	a0,-1
    8000159e:	b779                	j	8000152c <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800015a0:	6b85                	lui	s7,0x1
    800015a2:	9bca                	add	s7,s7,s2
    800015a4:	87a6                	mv	a5,s1
    800015a6:	b77d                	j	80001554 <copyinstr+0x5c>
  int got_null = 0;
    800015a8:	4781                	li	a5,0
  if(got_null){
    800015aa:	0017c793          	xori	a5,a5,1
    800015ae:	40f0053b          	negw	a0,a5
}
    800015b2:	8082                	ret

00000000800015b4 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800015b4:	1141                	addi	sp,sp,-16
    800015b6:	e406                	sd	ra,8(sp)
    800015b8:	e022                	sd	s0,0(sp)
    800015ba:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800015bc:	4601                	li	a2,0
    800015be:	9cfff0ef          	jal	80000f8c <walk>
  if (pte == 0) {
    800015c2:	c119                	beqz	a0,800015c8 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    800015c4:	6108                	ld	a0,0(a0)
    800015c6:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800015c8:	60a2                	ld	ra,8(sp)
    800015ca:	6402                	ld	s0,0(sp)
    800015cc:	0141                	addi	sp,sp,16
    800015ce:	8082                	ret

00000000800015d0 <vmfault>:
{
    800015d0:	7179                	addi	sp,sp,-48
    800015d2:	f406                	sd	ra,40(sp)
    800015d4:	f022                	sd	s0,32(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	1800                	addi	s0,sp,48
    800015dc:	89aa                	mv	s3,a0
    800015de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015e0:	33a000ef          	jal	8000191a <myproc>
  if (va >= p->mm->sz)
    800015e4:	653c                	ld	a5,72(a0)
    800015e6:	679c                	ld	a5,8(a5)
    800015e8:	00f96a63          	bltu	s2,a5,800015fc <vmfault+0x2c>
    return 0;
    800015ec:	4981                	li	s3,0
}
    800015ee:	854e                	mv	a0,s3
    800015f0:	70a2                	ld	ra,40(sp)
    800015f2:	7402                	ld	s0,32(sp)
    800015f4:	6942                	ld	s2,16(sp)
    800015f6:	69a2                	ld	s3,8(sp)
    800015f8:	6145                	addi	sp,sp,48
    800015fa:	8082                	ret
    800015fc:	ec26                	sd	s1,24(sp)
    800015fe:	e052                	sd	s4,0(sp)
    80001600:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80001602:	77fd                	lui	a5,0xfffff
    80001604:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80001608:	85d2                	mv	a1,s4
    8000160a:	854e                	mv	a0,s3
    8000160c:	fa9ff0ef          	jal	800015b4 <ismapped>
    return 0;
    80001610:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001612:	c501                	beqz	a0,8000161a <vmfault+0x4a>
    80001614:	64e2                	ld	s1,24(sp)
    80001616:	6a02                	ld	s4,0(sp)
    80001618:	bfd9                	j	800015ee <vmfault+0x1e>
  mem = (uint64) kalloc();
    8000161a:	d2aff0ef          	jal	80000b44 <kalloc>
    8000161e:	892a                	mv	s2,a0
  if(mem == 0)
    80001620:	c90d                	beqz	a0,80001652 <vmfault+0x82>
  mem = (uint64) kalloc();
    80001622:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001624:	6605                	lui	a2,0x1
    80001626:	4581                	li	a1,0
    80001628:	ed0ff0ef          	jal	80000cf8 <memset>
  if (mappages(p->mm->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000162c:	64bc                	ld	a5,72(s1)
    8000162e:	4759                	li	a4,22
    80001630:	86ca                	mv	a3,s2
    80001632:	6605                	lui	a2,0x1
    80001634:	85d2                	mv	a1,s4
    80001636:	6388                	ld	a0,0(a5)
    80001638:	a29ff0ef          	jal	80001060 <mappages>
    8000163c:	e501                	bnez	a0,80001644 <vmfault+0x74>
    8000163e:	64e2                	ld	s1,24(sp)
    80001640:	6a02                	ld	s4,0(sp)
    80001642:	b775                	j	800015ee <vmfault+0x1e>
    kfree((void *)mem);
    80001644:	854a                	mv	a0,s2
    80001646:	c16ff0ef          	jal	80000a5c <kfree>
    return 0;
    8000164a:	4981                	li	s3,0
    8000164c:	64e2                	ld	s1,24(sp)
    8000164e:	6a02                	ld	s4,0(sp)
    80001650:	bf79                	j	800015ee <vmfault+0x1e>
    80001652:	64e2                	ld	s1,24(sp)
    80001654:	6a02                	ld	s4,0(sp)
    80001656:	bf61                	j	800015ee <vmfault+0x1e>

0000000080001658 <copyout>:
  while(len > 0){
    80001658:	cad1                	beqz	a3,800016ec <copyout+0x94>
{
    8000165a:	711d                	addi	sp,sp,-96
    8000165c:	ec86                	sd	ra,88(sp)
    8000165e:	e8a2                	sd	s0,80(sp)
    80001660:	e4a6                	sd	s1,72(sp)
    80001662:	e0ca                	sd	s2,64(sp)
    80001664:	fc4e                	sd	s3,56(sp)
    80001666:	f852                	sd	s4,48(sp)
    80001668:	f456                	sd	s5,40(sp)
    8000166a:	f05a                	sd	s6,32(sp)
    8000166c:	ec5e                	sd	s7,24(sp)
    8000166e:	e862                	sd	s8,16(sp)
    80001670:	e466                	sd	s9,8(sp)
    80001672:	e06a                	sd	s10,0(sp)
    80001674:	1080                	addi	s0,sp,96
    80001676:	8baa                	mv	s7,a0
    80001678:	8a2e                	mv	s4,a1
    8000167a:	8b32                	mv	s6,a2
    8000167c:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000167e:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80001680:	5cfd                	li	s9,-1
    80001682:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001686:	6c05                	lui	s8,0x1
    80001688:	a005                	j	800016a8 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000168a:	409a0533          	sub	a0,s4,s1
    8000168e:	0009061b          	sext.w	a2,s2
    80001692:	85da                	mv	a1,s6
    80001694:	954e                	add	a0,a0,s3
    80001696:	ec2ff0ef          	jal	80000d58 <memmove>
    len -= n;
    8000169a:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000169e:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    800016a0:	01848a33          	add	s4,s1,s8
  while(len > 0){
    800016a4:	040a8263          	beqz	s5,800016e8 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    800016a8:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    800016ac:	049ce263          	bltu	s9,s1,800016f0 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    800016b0:	85a6                	mv	a1,s1
    800016b2:	855e                	mv	a0,s7
    800016b4:	973ff0ef          	jal	80001026 <walkaddr>
    800016b8:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800016ba:	e901                	bnez	a0,800016ca <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800016bc:	4601                	li	a2,0
    800016be:	85a6                	mv	a1,s1
    800016c0:	855e                	mv	a0,s7
    800016c2:	f0fff0ef          	jal	800015d0 <vmfault>
    800016c6:	89aa                	mv	s3,a0
    800016c8:	c139                	beqz	a0,8000170e <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    800016ca:	4601                	li	a2,0
    800016cc:	85a6                	mv	a1,s1
    800016ce:	855e                	mv	a0,s7
    800016d0:	8bdff0ef          	jal	80000f8c <walk>
    if((*pte & PTE_W) == 0)
    800016d4:	611c                	ld	a5,0(a0)
    800016d6:	8b91                	andi	a5,a5,4
    800016d8:	cf8d                	beqz	a5,80001712 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016da:	41448933          	sub	s2,s1,s4
    800016de:	9962                	add	s2,s2,s8
    if(n > len)
    800016e0:	fb2af5e3          	bgeu	s5,s2,8000168a <copyout+0x32>
    800016e4:	8956                	mv	s2,s5
    800016e6:	b755                	j	8000168a <copyout+0x32>
  return 0;
    800016e8:	4501                	li	a0,0
    800016ea:	a021                	j	800016f2 <copyout+0x9a>
    800016ec:	4501                	li	a0,0
}
    800016ee:	8082                	ret
      return -1;
    800016f0:	557d                	li	a0,-1
}
    800016f2:	60e6                	ld	ra,88(sp)
    800016f4:	6446                	ld	s0,80(sp)
    800016f6:	64a6                	ld	s1,72(sp)
    800016f8:	6906                	ld	s2,64(sp)
    800016fa:	79e2                	ld	s3,56(sp)
    800016fc:	7a42                	ld	s4,48(sp)
    800016fe:	7aa2                	ld	s5,40(sp)
    80001700:	7b02                	ld	s6,32(sp)
    80001702:	6be2                	ld	s7,24(sp)
    80001704:	6c42                	ld	s8,16(sp)
    80001706:	6ca2                	ld	s9,8(sp)
    80001708:	6d02                	ld	s10,0(sp)
    8000170a:	6125                	addi	sp,sp,96
    8000170c:	8082                	ret
        return -1;
    8000170e:	557d                	li	a0,-1
    80001710:	b7cd                	j	800016f2 <copyout+0x9a>
      return -1;
    80001712:	557d                	li	a0,-1
    80001714:	bff9                	j	800016f2 <copyout+0x9a>

0000000080001716 <copyin>:
  while(len > 0){
    80001716:	c6c9                	beqz	a3,800017a0 <copyin+0x8a>
{
    80001718:	715d                	addi	sp,sp,-80
    8000171a:	e486                	sd	ra,72(sp)
    8000171c:	e0a2                	sd	s0,64(sp)
    8000171e:	fc26                	sd	s1,56(sp)
    80001720:	f84a                	sd	s2,48(sp)
    80001722:	f44e                	sd	s3,40(sp)
    80001724:	f052                	sd	s4,32(sp)
    80001726:	ec56                	sd	s5,24(sp)
    80001728:	e85a                	sd	s6,16(sp)
    8000172a:	e45e                	sd	s7,8(sp)
    8000172c:	e062                	sd	s8,0(sp)
    8000172e:	0880                	addi	s0,sp,80
    80001730:	8baa                	mv	s7,a0
    80001732:	8aae                	mv	s5,a1
    80001734:	8932                	mv	s2,a2
    80001736:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001738:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    8000173a:	6b05                	lui	s6,0x1
    8000173c:	a035                	j	80001768 <copyin+0x52>
    8000173e:	412984b3          	sub	s1,s3,s2
    80001742:	94da                	add	s1,s1,s6
    if(n > len)
    80001744:	009a7363          	bgeu	s4,s1,8000174a <copyin+0x34>
    80001748:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000174a:	413905b3          	sub	a1,s2,s3
    8000174e:	0004861b          	sext.w	a2,s1
    80001752:	95aa                	add	a1,a1,a0
    80001754:	8556                	mv	a0,s5
    80001756:	e02ff0ef          	jal	80000d58 <memmove>
    len -= n;
    8000175a:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000175e:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001760:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001764:	020a0163          	beqz	s4,80001786 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001768:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000176c:	85ce                	mv	a1,s3
    8000176e:	855e                	mv	a0,s7
    80001770:	8b7ff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0) {
    80001774:	f569                	bnez	a0,8000173e <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001776:	4601                	li	a2,0
    80001778:	85ce                	mv	a1,s3
    8000177a:	855e                	mv	a0,s7
    8000177c:	e55ff0ef          	jal	800015d0 <vmfault>
    80001780:	fd5d                	bnez	a0,8000173e <copyin+0x28>
        return -1;
    80001782:	557d                	li	a0,-1
    80001784:	a011                	j	80001788 <copyin+0x72>
  return 0;
    80001786:	4501                	li	a0,0
}
    80001788:	60a6                	ld	ra,72(sp)
    8000178a:	6406                	ld	s0,64(sp)
    8000178c:	74e2                	ld	s1,56(sp)
    8000178e:	7942                	ld	s2,48(sp)
    80001790:	79a2                	ld	s3,40(sp)
    80001792:	7a02                	ld	s4,32(sp)
    80001794:	6ae2                	ld	s5,24(sp)
    80001796:	6b42                	ld	s6,16(sp)
    80001798:	6ba2                	ld	s7,8(sp)
    8000179a:	6c02                	ld	s8,0(sp)
    8000179c:	6161                	addi	sp,sp,80
    8000179e:	8082                	ret
  return 0;
    800017a0:	4501                	li	a0,0
}
    800017a2:	8082                	ret

00000000800017a4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a4:	715d                	addi	sp,sp,-80
    800017a6:	e486                	sd	ra,72(sp)
    800017a8:	e0a2                	sd	s0,64(sp)
    800017aa:	fc26                	sd	s1,56(sp)
    800017ac:	f84a                	sd	s2,48(sp)
    800017ae:	f44e                	sd	s3,40(sp)
    800017b0:	f052                	sd	s4,32(sp)
    800017b2:	ec56                	sd	s5,24(sp)
    800017b4:	e85a                	sd	s6,16(sp)
    800017b6:	e45e                	sd	s7,8(sp)
    800017b8:	e062                	sd	s8,0(sp)
    800017ba:	0880                	addi	s0,sp,80
    800017bc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017be:	0000f497          	auipc	s1,0xf
    800017c2:	62a48493          	addi	s1,s1,1578 # 80010de8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017c6:	8c26                	mv	s8,s1
    800017c8:	aaaab7b7          	lui	a5,0xaaaab
    800017cc:	aab78793          	addi	a5,a5,-1365 # ffffffffaaaaaaab <end+0xffffffff2aa888e3>
    800017d0:	02079993          	slli	s3,a5,0x20
    800017d4:	99be                	add	s3,s3,a5
    800017d6:	04000937          	lui	s2,0x4000
    800017da:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800017dc:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017de:	4b99                	li	s7,6
    800017e0:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e2:	00015a97          	auipc	s5,0x15
    800017e6:	606a8a93          	addi	s5,s5,1542 # 80016de8 <tickslock>
    char *pa = kalloc();
    800017ea:	b5aff0ef          	jal	80000b44 <kalloc>
    800017ee:	862a                	mv	a2,a0
    if(pa == 0)
    800017f0:	c121                	beqz	a0,80001830 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017f2:	418485b3          	sub	a1,s1,s8
    800017f6:	859d                	srai	a1,a1,0x7
    800017f8:	033585b3          	mul	a1,a1,s3
    800017fc:	05b6                	slli	a1,a1,0xd
    800017fe:	6789                	lui	a5,0x2
    80001800:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001802:	875e                	mv	a4,s7
    80001804:	86da                	mv	a3,s6
    80001806:	40b905b3          	sub	a1,s2,a1
    8000180a:	8552                	mv	a0,s4
    8000180c:	90bff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001810:	18048493          	addi	s1,s1,384
    80001814:	fd549be3          	bne	s1,s5,800017ea <proc_mapstacks+0x46>
  }
}
    80001818:	60a6                	ld	ra,72(sp)
    8000181a:	6406                	ld	s0,64(sp)
    8000181c:	74e2                	ld	s1,56(sp)
    8000181e:	7942                	ld	s2,48(sp)
    80001820:	79a2                	ld	s3,40(sp)
    80001822:	7a02                	ld	s4,32(sp)
    80001824:	6ae2                	ld	s5,24(sp)
    80001826:	6b42                	ld	s6,16(sp)
    80001828:	6ba2                	ld	s7,8(sp)
    8000182a:	6c02                	ld	s8,0(sp)
    8000182c:	6161                	addi	sp,sp,80
    8000182e:	8082                	ret
      panic("kalloc");
    80001830:	00007517          	auipc	a0,0x7
    80001834:	92850513          	addi	a0,a0,-1752 # 80008158 <etext+0x158>
    80001838:	fedfe0ef          	jal	80000824 <panic>

000000008000183c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000183c:	7139                	addi	sp,sp,-64
    8000183e:	fc06                	sd	ra,56(sp)
    80001840:	f822                	sd	s0,48(sp)
    80001842:	f426                	sd	s1,40(sp)
    80001844:	f04a                	sd	s2,32(sp)
    80001846:	ec4e                	sd	s3,24(sp)
    80001848:	e852                	sd	s4,16(sp)
    8000184a:	e456                	sd	s5,8(sp)
    8000184c:	e05a                	sd	s6,0(sp)
    8000184e:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001850:	00007597          	auipc	a1,0x7
    80001854:	91058593          	addi	a1,a1,-1776 # 80008160 <etext+0x160>
    80001858:	0000f517          	auipc	a0,0xf
    8000185c:	16050513          	addi	a0,a0,352 # 800109b8 <pid_lock>
    80001860:	b3eff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001864:	00007597          	auipc	a1,0x7
    80001868:	90458593          	addi	a1,a1,-1788 # 80008168 <etext+0x168>
    8000186c:	0000f517          	auipc	a0,0xf
    80001870:	16450513          	addi	a0,a0,356 # 800109d0 <wait_lock>
    80001874:	b2aff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001878:	0000f497          	auipc	s1,0xf
    8000187c:	57048493          	addi	s1,s1,1392 # 80010de8 <proc>
      initlock(&p->lock, "proc");
    80001880:	00007b17          	auipc	s6,0x7
    80001884:	8f8b0b13          	addi	s6,s6,-1800 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001888:	8aa6                	mv	s5,s1
    8000188a:	aaaab7b7          	lui	a5,0xaaaab
    8000188e:	aab78793          	addi	a5,a5,-1365 # ffffffffaaaaaaab <end+0xffffffff2aa888e3>
    80001892:	02079993          	slli	s3,a5,0x20
    80001896:	99be                	add	s3,s3,a5
    80001898:	04000937          	lui	s2,0x4000
    8000189c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000189e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	00015a17          	auipc	s4,0x15
    800018a4:	548a0a13          	addi	s4,s4,1352 # 80016de8 <tickslock>
      initlock(&p->lock, "proc");
    800018a8:	85da                	mv	a1,s6
    800018aa:	8526                	mv	a0,s1
    800018ac:	af2ff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800018b0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018b4:	415487b3          	sub	a5,s1,s5
    800018b8:	879d                	srai	a5,a5,0x7
    800018ba:	033787b3          	mul	a5,a5,s3
    800018be:	07b6                	slli	a5,a5,0xd
    800018c0:	6709                	lui	a4,0x2
    800018c2:	9fb9                	addw	a5,a5,a4
    800018c4:	40f907b3          	sub	a5,s2,a5
    800018c8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ca:	18048493          	addi	s1,s1,384
    800018ce:	fd449de3          	bne	s1,s4,800018a8 <procinit+0x6c>
  }
}
    800018d2:	70e2                	ld	ra,56(sp)
    800018d4:	7442                	ld	s0,48(sp)
    800018d6:	74a2                	ld	s1,40(sp)
    800018d8:	7902                	ld	s2,32(sp)
    800018da:	69e2                	ld	s3,24(sp)
    800018dc:	6a42                	ld	s4,16(sp)
    800018de:	6aa2                	ld	s5,8(sp)
    800018e0:	6b02                	ld	s6,0(sp)
    800018e2:	6121                	addi	sp,sp,64
    800018e4:	8082                	ret

00000000800018e6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018e6:	1141                	addi	sp,sp,-16
    800018e8:	e406                	sd	ra,8(sp)
    800018ea:	e022                	sd	s0,0(sp)
    800018ec:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ee:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018f0:	2501                	sext.w	a0,a0
    800018f2:	60a2                	ld	ra,8(sp)
    800018f4:	6402                	ld	s0,0(sp)
    800018f6:	0141                	addi	sp,sp,16
    800018f8:	8082                	ret

00000000800018fa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018fa:	1141                	addi	sp,sp,-16
    800018fc:	e406                	sd	ra,8(sp)
    800018fe:	e022                	sd	s0,0(sp)
    80001900:	0800                	addi	s0,sp,16
    80001902:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001904:	2781                	sext.w	a5,a5
    80001906:	079e                	slli	a5,a5,0x7
  return c;
}
    80001908:	0000f517          	auipc	a0,0xf
    8000190c:	0e050513          	addi	a0,a0,224 # 800109e8 <cpus>
    80001910:	953e                	add	a0,a0,a5
    80001912:	60a2                	ld	ra,8(sp)
    80001914:	6402                	ld	s0,0(sp)
    80001916:	0141                	addi	sp,sp,16
    80001918:	8082                	ret

000000008000191a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000191a:	1101                	addi	sp,sp,-32
    8000191c:	ec06                	sd	ra,24(sp)
    8000191e:	e822                	sd	s0,16(sp)
    80001920:	e426                	sd	s1,8(sp)
    80001922:	1000                	addi	s0,sp,32
  push_off();
    80001924:	ac0ff0ef          	jal	80000be4 <push_off>
    80001928:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000192a:	2781                	sext.w	a5,a5
    8000192c:	079e                	slli	a5,a5,0x7
    8000192e:	0000f717          	auipc	a4,0xf
    80001932:	08a70713          	addi	a4,a4,138 # 800109b8 <pid_lock>
    80001936:	97ba                	add	a5,a5,a4
    80001938:	7b9c                	ld	a5,48(a5)
    8000193a:	84be                	mv	s1,a5
  pop_off();
    8000193c:	b30ff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001940:	8526                	mv	a0,s1
    80001942:	60e2                	ld	ra,24(sp)
    80001944:	6442                	ld	s0,16(sp)
    80001946:	64a2                	ld	s1,8(sp)
    80001948:	6105                	addi	sp,sp,32
    8000194a:	8082                	ret

000000008000194c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000194c:	7179                	addi	sp,sp,-48
    8000194e:	f406                	sd	ra,40(sp)
    80001950:	f022                	sd	s0,32(sp)
    80001952:	ec26                	sd	s1,24(sp)
    80001954:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001956:	fc5ff0ef          	jal	8000191a <myproc>
    8000195a:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000195c:	b60ff0ef          	jal	80000cbc <release>

  if (first) {
    80001960:	00007797          	auipc	a5,0x7
    80001964:	f207a783          	lw	a5,-224(a5) # 80008880 <first.1>
    80001968:	cf95                	beqz	a5,800019a4 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000196a:	4505                	li	a0,1
    8000196c:	26c020ef          	jal	80003bd8 <fsinit>

    first = 0;
    80001970:	00007797          	auipc	a5,0x7
    80001974:	f007a823          	sw	zero,-240(a5) # 80008880 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001978:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    8000197c:	00007797          	auipc	a5,0x7
    80001980:	80478793          	addi	a5,a5,-2044 # 80008180 <etext+0x180>
    80001984:	fcf43823          	sd	a5,-48(s0)
    80001988:	fc043c23          	sd	zero,-40(s0)
    8000198c:	fd040593          	addi	a1,s0,-48
    80001990:	853e                	mv	a0,a5
    80001992:	3d4030ef          	jal	80004d66 <kexec>
    80001996:	68bc                	ld	a5,80(s1)
    80001998:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000199a:	68bc                	ld	a5,80(s1)
    8000199c:	7bb8                	ld	a4,112(a5)
    8000199e:	57fd                	li	a5,-1
    800019a0:	02f70e63          	beq	a4,a5,800019dc <forkret+0x90>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019a4:	0f4010ef          	jal	80002a98 <prepare_return>
  uint64 satp = MAKE_SATP(p->mm->pagetable);
    800019a8:	64bc                	ld	a5,72(s1)
    800019aa:	6388                	ld	a0,0(a5)
    800019ac:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019ae:	04000737          	lui	a4,0x4000
    800019b2:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019b4:	0732                	slli	a4,a4,0xc
    800019b6:	00005797          	auipc	a5,0x5
    800019ba:	6de78793          	addi	a5,a5,1758 # 80007094 <userret>
    800019be:	00005697          	auipc	a3,0x5
    800019c2:	64268693          	addi	a3,a3,1602 # 80007000 <_trampoline>
    800019c6:	8f95                	sub	a5,a5,a3
    800019c8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019ca:	577d                	li	a4,-1
    800019cc:	177e                	slli	a4,a4,0x3f
    800019ce:	8d59                	or	a0,a0,a4
    800019d0:	9782                	jalr	a5
}
    800019d2:	70a2                	ld	ra,40(sp)
    800019d4:	7402                	ld	s0,32(sp)
    800019d6:	64e2                	ld	s1,24(sp)
    800019d8:	6145                	addi	sp,sp,48
    800019da:	8082                	ret
      panic("exec");
    800019dc:	00006517          	auipc	a0,0x6
    800019e0:	7ac50513          	addi	a0,a0,1964 # 80008188 <etext+0x188>
    800019e4:	e41fe0ef          	jal	80000824 <panic>

00000000800019e8 <allocpid>:
{
    800019e8:	1101                	addi	sp,sp,-32
    800019ea:	ec06                	sd	ra,24(sp)
    800019ec:	e822                	sd	s0,16(sp)
    800019ee:	e426                	sd	s1,8(sp)
    800019f0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019f2:	0000f517          	auipc	a0,0xf
    800019f6:	fc650513          	addi	a0,a0,-58 # 800109b8 <pid_lock>
    800019fa:	a2eff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    800019fe:	00007797          	auipc	a5,0x7
    80001a02:	e8678793          	addi	a5,a5,-378 # 80008884 <nextpid>
    80001a06:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a08:	0014871b          	addiw	a4,s1,1
    80001a0c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a0e:	0000f517          	auipc	a0,0xf
    80001a12:	faa50513          	addi	a0,a0,-86 # 800109b8 <pid_lock>
    80001a16:	aa6ff0ef          	jal	80000cbc <release>
}
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	60e2                	ld	ra,24(sp)
    80001a1e:	6442                	ld	s0,16(sp)
    80001a20:	64a2                	ld	s1,8(sp)
    80001a22:	6105                	addi	sp,sp,32
    80001a24:	8082                	ret

0000000080001a26 <mm_alloc>:
{
    80001a26:	1101                	addi	sp,sp,-32
    80001a28:	ec06                	sd	ra,24(sp)
    80001a2a:	e822                	sd	s0,16(sp)
    80001a2c:	e426                	sd	s1,8(sp)
    80001a2e:	1000                	addi	s0,sp,32
  struct mm_struct *mm = (struct mm_struct *)kalloc();
    80001a30:	914ff0ef          	jal	80000b44 <kalloc>
    80001a34:	84aa                	mv	s1,a0
  if (mm == 0)
    80001a36:	cd11                	beqz	a0,80001a52 <mm_alloc+0x2c>
  mm->pagetable = 0;
    80001a38:	00053023          	sd	zero,0(a0)
  mm->sz = 0;
    80001a3c:	00053423          	sd	zero,8(a0)
  mm->refcount = 1;
    80001a40:	4785                	li	a5,1
    80001a42:	c91c                	sw	a5,16(a0)
  initlock(&mm->lock, "mm");
    80001a44:	00006597          	auipc	a1,0x6
    80001a48:	74c58593          	addi	a1,a1,1868 # 80008190 <etext+0x190>
    80001a4c:	0561                	addi	a0,a0,24
    80001a4e:	950ff0ef          	jal	80000b9e <initlock>
}
    80001a52:	8526                	mv	a0,s1
    80001a54:	60e2                	ld	ra,24(sp)
    80001a56:	6442                	ld	s0,16(sp)
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	6105                	addi	sp,sp,32
    80001a5c:	8082                	ret

0000000080001a5e <mm_get>:
{
    80001a5e:	1101                	addi	sp,sp,-32
    80001a60:	ec06                	sd	ra,24(sp)
    80001a62:	e822                	sd	s0,16(sp)
    80001a64:	e426                	sd	s1,8(sp)
    80001a66:	e04a                	sd	s2,0(sp)
    80001a68:	1000                	addi	s0,sp,32
    80001a6a:	84aa                	mv	s1,a0
  acquire(&mm->lock);
    80001a6c:	01850913          	addi	s2,a0,24
    80001a70:	854a                	mv	a0,s2
    80001a72:	9b6ff0ef          	jal	80000c28 <acquire>
  mm->refcount++;
    80001a76:	489c                	lw	a5,16(s1)
    80001a78:	2785                	addiw	a5,a5,1
    80001a7a:	c89c                	sw	a5,16(s1)
  release(&mm->lock);
    80001a7c:	854a                	mv	a0,s2
    80001a7e:	a3eff0ef          	jal	80000cbc <release>
}
    80001a82:	60e2                	ld	ra,24(sp)
    80001a84:	6442                	ld	s0,16(sp)
    80001a86:	64a2                	ld	s1,8(sp)
    80001a88:	6902                	ld	s2,0(sp)
    80001a8a:	6105                	addi	sp,sp,32
    80001a8c:	8082                	ret

0000000080001a8e <find_free_tf_va>:
{
    80001a8e:	1141                	addi	sp,sp,-16
    80001a90:	e406                	sd	ra,8(sp)
    80001a92:	e022                	sd	s0,0(sp)
    80001a94:	0800                	addi	s0,sp,16
    80001a96:	862a                	mv	a2,a0
    80001a98:	02000537          	lui	a0,0x2000
    80001a9c:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001a9e:	0536                	slli	a0,a0,0xd
    for(p = proc; p < &proc[NPROC]; p++) {
    80001aa0:	00015697          	auipc	a3,0x15
    80001aa4:	34868693          	addi	a3,a3,840 # 80016de8 <tickslock>
  for(int i = 0; i < NTHREAD; i++) {
    80001aa8:	787d                	lui	a6,0xfffff
    80001aaa:	020005b7          	lui	a1,0x2000
    80001aae:	15ed                	addi	a1,a1,-5 # 1fffffb <_entry-0x7e000005>
    80001ab0:	05b6                	slli	a1,a1,0xd
    80001ab2:	a01d                	j	80001ad8 <find_free_tf_va+0x4a>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ab4:	18078793          	addi	a5,a5,384
    80001ab8:	02d78663          	beq	a5,a3,80001ae4 <find_free_tf_va+0x56>
      if(p->state != UNUSED && p->mm != 0 && p->mm->pagetable == pagetable && p->tf_va == va) {
    80001abc:	4f98                	lw	a4,24(a5)
    80001abe:	db7d                	beqz	a4,80001ab4 <find_free_tf_va+0x26>
    80001ac0:	67b8                	ld	a4,72(a5)
    80001ac2:	db6d                	beqz	a4,80001ab4 <find_free_tf_va+0x26>
    80001ac4:	6318                	ld	a4,0(a4)
    80001ac6:	fec717e3          	bne	a4,a2,80001ab4 <find_free_tf_va+0x26>
    80001aca:	1707b703          	ld	a4,368(a5)
    80001ace:	fea713e3          	bne	a4,a0,80001ab4 <find_free_tf_va+0x26>
  for(int i = 0; i < NTHREAD; i++) {
    80001ad2:	9542                	add	a0,a0,a6
    80001ad4:	00b50763          	beq	a0,a1,80001ae2 <find_free_tf_va+0x54>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ad8:	0000f797          	auipc	a5,0xf
    80001adc:	31078793          	addi	a5,a5,784 # 80010de8 <proc>
    80001ae0:	bff1                	j	80001abc <find_free_tf_va+0x2e>
  return 0;
    80001ae2:	4501                	li	a0,0
}
    80001ae4:	60a2                	ld	ra,8(sp)
    80001ae6:	6402                	ld	s0,0(sp)
    80001ae8:	0141                	addi	sp,sp,16
    80001aea:	8082                	ret

0000000080001aec <proc_pagetable>:
{
    80001aec:	1101                	addi	sp,sp,-32
    80001aee:	ec06                	sd	ra,24(sp)
    80001af0:	e822                	sd	s0,16(sp)
    80001af2:	e426                	sd	s1,8(sp)
    80001af4:	e04a                	sd	s2,0(sp)
    80001af6:	1000                	addi	s0,sp,32
    80001af8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001afa:	f0eff0ef          	jal	80001208 <uvmcreate>
    80001afe:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b00:	c131                	beqz	a0,80001b44 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b02:	4729                	li	a4,10
    80001b04:	00005697          	auipc	a3,0x5
    80001b08:	4fc68693          	addi	a3,a3,1276 # 80007000 <_trampoline>
    80001b0c:	6605                	lui	a2,0x1
    80001b0e:	040005b7          	lui	a1,0x4000
    80001b12:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b14:	05b2                	slli	a1,a1,0xc
    80001b16:	d4aff0ef          	jal	80001060 <mappages>
    80001b1a:	02054c63          	bltz	a0,80001b52 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b1e:	4719                	li	a4,6
    80001b20:	05093683          	ld	a3,80(s2)
    80001b24:	6605                	lui	a2,0x1
    80001b26:	020005b7          	lui	a1,0x2000
    80001b2a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b2c:	05b6                	slli	a1,a1,0xd
    80001b2e:	8526                	mv	a0,s1
    80001b30:	d30ff0ef          	jal	80001060 <mappages>
    80001b34:	02054563          	bltz	a0,80001b5e <proc_pagetable+0x72>
  p->tf_va = TRAPFRAME;
    80001b38:	020007b7          	lui	a5,0x2000
    80001b3c:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001b3e:	07b6                	slli	a5,a5,0xd
    80001b40:	16f93823          	sd	a5,368(s2)
}
    80001b44:	8526                	mv	a0,s1
    80001b46:	60e2                	ld	ra,24(sp)
    80001b48:	6442                	ld	s0,16(sp)
    80001b4a:	64a2                	ld	s1,8(sp)
    80001b4c:	6902                	ld	s2,0(sp)
    80001b4e:	6105                	addi	sp,sp,32
    80001b50:	8082                	ret
    uvmfree(pagetable, 0);
    80001b52:	4581                	li	a1,0
    80001b54:	8526                	mv	a0,s1
    80001b56:	8adff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001b5a:	4481                	li	s1,0
    80001b5c:	b7e5                	j	80001b44 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b5e:	4681                	li	a3,0
    80001b60:	4605                	li	a2,1
    80001b62:	040005b7          	lui	a1,0x4000
    80001b66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b68:	05b2                	slli	a1,a1,0xc
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	ec2ff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80001b70:	4581                	li	a1,0
    80001b72:	8526                	mv	a0,s1
    80001b74:	88fff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001b78:	4481                	li	s1,0
    80001b7a:	b7e9                	j	80001b44 <proc_pagetable+0x58>

0000000080001b7c <proc_freepagetable>:
{
    80001b7c:	1101                	addi	sp,sp,-32
    80001b7e:	ec06                	sd	ra,24(sp)
    80001b80:	e822                	sd	s0,16(sp)
    80001b82:	e426                	sd	s1,8(sp)
    80001b84:	e04a                	sd	s2,0(sp)
    80001b86:	1000                	addi	s0,sp,32
    80001b88:	84aa                	mv	s1,a0
    80001b8a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b8c:	4681                	li	a3,0
    80001b8e:	4605                	li	a2,1
    80001b90:	040005b7          	lui	a1,0x4000
    80001b94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b96:	05b2                	slli	a1,a1,0xc
    80001b98:	e96ff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b9c:	4681                	li	a3,0
    80001b9e:	4605                	li	a2,1
    80001ba0:	020005b7          	lui	a1,0x2000
    80001ba4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ba6:	05b6                	slli	a1,a1,0xd
    80001ba8:	8526                	mv	a0,s1
    80001baa:	e84ff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80001bae:	85ca                	mv	a1,s2
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	851ff0ef          	jal	80001402 <uvmfree>
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6902                	ld	s2,0(sp)
    80001bbe:	6105                	addi	sp,sp,32
    80001bc0:	8082                	ret

0000000080001bc2 <mm_put>:
{
    80001bc2:	7179                	addi	sp,sp,-48
    80001bc4:	f406                	sd	ra,40(sp)
    80001bc6:	f022                	sd	s0,32(sp)
    80001bc8:	ec26                	sd	s1,24(sp)
    80001bca:	e84a                	sd	s2,16(sp)
    80001bcc:	1800                	addi	s0,sp,48
    80001bce:	84aa                	mv	s1,a0
  acquire(&mm->lock);
    80001bd0:	01850913          	addi	s2,a0,24
    80001bd4:	854a                	mv	a0,s2
    80001bd6:	852ff0ef          	jal	80000c28 <acquire>
  mm->refcount--;
    80001bda:	489c                	lw	a5,16(s1)
    80001bdc:	37fd                	addiw	a5,a5,-1
    80001bde:	c89c                	sw	a5,16(s1)
  if (mm->refcount == 0) {
    80001be0:	eb8d                	bnez	a5,80001c12 <mm_put+0x50>
    80001be2:	e44e                	sd	s3,8(sp)
    80001be4:	e052                	sd	s4,0(sp)
    pagetable_t pagetable = mm->pagetable;
    80001be6:	0004b983          	ld	s3,0(s1)
    uint64 sz = mm->sz;
    80001bea:	649c                	ld	a5,8(s1)
    80001bec:	8a3e                	mv	s4,a5
    release(&mm->lock);
    80001bee:	854a                	mv	a0,s2
    80001bf0:	8ccff0ef          	jal	80000cbc <release>
    proc_freepagetable(pagetable, sz);
    80001bf4:	85d2                	mv	a1,s4
    80001bf6:	854e                	mv	a0,s3
    80001bf8:	f85ff0ef          	jal	80001b7c <proc_freepagetable>
    kfree((void *)mm);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	e5ffe0ef          	jal	80000a5c <kfree>
    80001c02:	69a2                	ld	s3,8(sp)
    80001c04:	6a02                	ld	s4,0(sp)
}
    80001c06:	70a2                	ld	ra,40(sp)
    80001c08:	7402                	ld	s0,32(sp)
    80001c0a:	64e2                	ld	s1,24(sp)
    80001c0c:	6942                	ld	s2,16(sp)
    80001c0e:	6145                	addi	sp,sp,48
    80001c10:	8082                	ret
    release(&mm->lock);
    80001c12:	854a                	mv	a0,s2
    80001c14:	8a8ff0ef          	jal	80000cbc <release>
}
    80001c18:	b7fd                	j	80001c06 <mm_put+0x44>

0000000080001c1a <freeproc>:
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84aa                	mv	s1,a0
  if (p->trapframe) {
    80001c26:	693c                	ld	a5,80(a0)
    80001c28:	c79d                	beqz	a5,80001c56 <freeproc+0x3c>
    if(p->tf_va != 0 && p->tf_va != TRAPFRAME && p-> mm != 0 && p->mm->pagetable != 0) {
    80001c2a:	17053583          	ld	a1,368(a0)
    80001c2e:	cd99                	beqz	a1,80001c4c <freeproc+0x32>
    80001c30:	fe0007b7          	lui	a5,0xfe000
    80001c34:	0785                	addi	a5,a5,1 # fffffffffe000001 <end+0xffffffff7dfdde39>
    80001c36:	07b6                	slli	a5,a5,0xd
    80001c38:	97ae                	add	a5,a5,a1
    80001c3a:	cb89                	beqz	a5,80001c4c <freeproc+0x32>
    80001c3c:	653c                	ld	a5,72(a0)
    80001c3e:	c799                	beqz	a5,80001c4c <freeproc+0x32>
    80001c40:	6388                	ld	a0,0(a5)
    80001c42:	c509                	beqz	a0,80001c4c <freeproc+0x32>
      uvmunmap(p->mm->pagetable, p->tf_va, 1, 0);
    80001c44:	4681                	li	a3,0
    80001c46:	4605                	li	a2,1
    80001c48:	de6ff0ef          	jal	8000122e <uvmunmap>
    kfree((void *)p->trapframe);
    80001c4c:	68a8                	ld	a0,80(s1)
    80001c4e:	e0ffe0ef          	jal	80000a5c <kfree>
    p->trapframe = 0;
    80001c52:	0404b823          	sd	zero,80(s1)
  p->tf_va = 0;
    80001c56:	1604b823          	sd	zero,368(s1)
  if (p->mm) {
    80001c5a:	64a8                	ld	a0,72(s1)
    80001c5c:	c509                	beqz	a0,80001c66 <freeproc+0x4c>
    mm_put(p->mm);
    80001c5e:	f65ff0ef          	jal	80001bc2 <mm_put>
    p->mm = 0;
    80001c62:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c66:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c6a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c6e:	14048823          	sb	zero,336(s1)
  p->chan = 0;
    80001c72:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c76:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c7a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c7e:	0004ac23          	sw	zero,24(s1)
  p->group_leader = 0;
    80001c82:	1604b023          	sd	zero,352(s1)
  p->tgid = 0;
    80001c86:	1604a423          	sw	zero,360(s1)
  p->ustack = 0;
    80001c8a:	1604bc23          	sd	zero,376(s1)
}
    80001c8e:	60e2                	ld	ra,24(sp)
    80001c90:	6442                	ld	s0,16(sp)
    80001c92:	64a2                	ld	s1,8(sp)
    80001c94:	6105                	addi	sp,sp,32
    80001c96:	8082                	ret

0000000080001c98 <allocproc>:
{
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	e04a                	sd	s2,0(sp)
    80001ca2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ca4:	0000f497          	auipc	s1,0xf
    80001ca8:	14448493          	addi	s1,s1,324 # 80010de8 <proc>
    80001cac:	00015917          	auipc	s2,0x15
    80001cb0:	13c90913          	addi	s2,s2,316 # 80016de8 <tickslock>
    acquire(&p->lock);
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	f73fe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001cba:	4c9c                	lw	a5,24(s1)
    80001cbc:	cb91                	beqz	a5,80001cd0 <allocproc+0x38>
      release(&p->lock);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	ffdfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cc4:	18048493          	addi	s1,s1,384
    80001cc8:	ff2496e3          	bne	s1,s2,80001cb4 <allocproc+0x1c>
  return 0;
    80001ccc:	4481                	li	s1,0
    80001cce:	a0a9                	j	80001d18 <allocproc+0x80>
  p->pid = allocpid();
    80001cd0:	d19ff0ef          	jal	800019e8 <allocpid>
    80001cd4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cd6:	4785                	li	a5,1
    80001cd8:	cc9c                	sw	a5,24(s1)
  p->mm = 0;
    80001cda:	0404b423          	sd	zero,72(s1)
  p->group_leader = p;
    80001cde:	1694b023          	sd	s1,352(s1)
  p->tgid = p->pid;
    80001ce2:	16a4a423          	sw	a0,360(s1)
  p->tf_va = 0;
    80001ce6:	1604b823          	sd	zero,368(s1)
  p->ustack = 0;
    80001cea:	1604bc23          	sd	zero,376(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cee:	e57fe0ef          	jal	80000b44 <kalloc>
    80001cf2:	892a                	mv	s2,a0
    80001cf4:	e8a8                	sd	a0,80(s1)
    80001cf6:	c905                	beqz	a0,80001d26 <allocproc+0x8e>
  memset(&p->context, 0, sizeof(p->context));
    80001cf8:	07000613          	li	a2,112
    80001cfc:	4581                	li	a1,0
    80001cfe:	05848513          	addi	a0,s1,88
    80001d02:	ff7fe0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001d06:	00000797          	auipc	a5,0x0
    80001d0a:	c4678793          	addi	a5,a5,-954 # 8000194c <forkret>
    80001d0e:	ecbc                	sd	a5,88(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d10:	60bc                	ld	a5,64(s1)
    80001d12:	6705                	lui	a4,0x1
    80001d14:	97ba                	add	a5,a5,a4
    80001d16:	f0bc                	sd	a5,96(s1)
}
    80001d18:	8526                	mv	a0,s1
    80001d1a:	60e2                	ld	ra,24(sp)
    80001d1c:	6442                	ld	s0,16(sp)
    80001d1e:	64a2                	ld	s1,8(sp)
    80001d20:	6902                	ld	s2,0(sp)
    80001d22:	6105                	addi	sp,sp,32
    80001d24:	8082                	ret
    freeproc(p);
    80001d26:	8526                	mv	a0,s1
    80001d28:	ef3ff0ef          	jal	80001c1a <freeproc>
    release(&p->lock);
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	f8ffe0ef          	jal	80000cbc <release>
    return 0;
    80001d32:	84ca                	mv	s1,s2
    80001d34:	b7d5                	j	80001d18 <allocproc+0x80>

0000000080001d36 <userinit>:
{
    80001d36:	1101                	addi	sp,sp,-32
    80001d38:	ec06                	sd	ra,24(sp)
    80001d3a:	e822                	sd	s0,16(sp)
    80001d3c:	e426                	sd	s1,8(sp)
    80001d3e:	e04a                	sd	s2,0(sp)
    80001d40:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d42:	f57ff0ef          	jal	80001c98 <allocproc>
    80001d46:	84aa                	mv	s1,a0
  initproc = p;
    80001d48:	00007797          	auipc	a5,0x7
    80001d4c:	b6a7b423          	sd	a0,-1176(a5) # 800088b0 <initproc>
  if ((p->mm = mm_alloc()) == 0)
    80001d50:	cd7ff0ef          	jal	80001a26 <mm_alloc>
    80001d54:	e4a8                	sd	a0,72(s1)
    80001d56:	cd15                	beqz	a0,80001d92 <userinit+0x5c>
    80001d58:	892a                	mv	s2,a0
  if ((p->mm->pagetable = proc_pagetable(p)) == 0)
    80001d5a:	8526                	mv	a0,s1
    80001d5c:	d91ff0ef          	jal	80001aec <proc_pagetable>
    80001d60:	00a93023          	sd	a0,0(s2)
    80001d64:	cd0d                	beqz	a0,80001d9e <userinit+0x68>
  p->mm->sz = 0;
    80001d66:	64bc                	ld	a5,72(s1)
    80001d68:	0007b423          	sd	zero,8(a5)
  p->cwd = namei("/");
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	46450513          	addi	a0,a0,1124 # 800081d0 <etext+0x1d0>
    80001d74:	39e020ef          	jal	80004112 <namei>
    80001d78:	14a4b423          	sd	a0,328(s1)
  p->state = RUNNABLE;
    80001d7c:	478d                	li	a5,3
    80001d7e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d80:	8526                	mv	a0,s1
    80001d82:	f3bfe0ef          	jal	80000cbc <release>
}
    80001d86:	60e2                	ld	ra,24(sp)
    80001d88:	6442                	ld	s0,16(sp)
    80001d8a:	64a2                	ld	s1,8(sp)
    80001d8c:	6902                	ld	s2,0(sp)
    80001d8e:	6105                	addi	sp,sp,32
    80001d90:	8082                	ret
    panic("userinit: mm_alloc");
    80001d92:	00006517          	auipc	a0,0x6
    80001d96:	40650513          	addi	a0,a0,1030 # 80008198 <etext+0x198>
    80001d9a:	a8bfe0ef          	jal	80000824 <panic>
    panic("userinit: proc_pagetable");
    80001d9e:	00006517          	auipc	a0,0x6
    80001da2:	41250513          	addi	a0,a0,1042 # 800081b0 <etext+0x1b0>
    80001da6:	a7ffe0ef          	jal	80000824 <panic>

0000000080001daa <growproc>:
{
    80001daa:	7179                	addi	sp,sp,-48
    80001dac:	f406                	sd	ra,40(sp)
    80001dae:	f022                	sd	s0,32(sp)
    80001db0:	ec26                	sd	s1,24(sp)
    80001db2:	e84a                	sd	s2,16(sp)
    80001db4:	e44e                	sd	s3,8(sp)
    80001db6:	1800                	addi	s0,sp,48
    80001db8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dba:	b61ff0ef          	jal	8000191a <myproc>
  struct mm_struct *mm = p->mm;
    80001dbe:	04853903          	ld	s2,72(a0)
  acquire(&mm->lock);
    80001dc2:	01890993          	addi	s3,s2,24
    80001dc6:	854e                	mv	a0,s3
    80001dc8:	e61fe0ef          	jal	80000c28 <acquire>
  sz = mm->sz;
    80001dcc:	00893583          	ld	a1,8(s2)
  if (n > 0) {
    80001dd0:	04905863          	blez	s1,80001e20 <growproc+0x76>
    if (sz + n > USERTOP) {
    80001dd4:	00b48633          	add	a2,s1,a1
    80001dd8:	020007b7          	lui	a5,0x2000
    80001ddc:	17ed                	addi	a5,a5,-5 # 1fffffb <_entry-0x7e000005>
    80001dde:	07b6                	slli	a5,a5,0xd
    80001de0:	02c7e663          	bltu	a5,a2,80001e0c <growproc+0x62>
    if ((sz = uvmalloc(mm->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001de4:	4691                	li	a3,4
    80001de6:	00093503          	ld	a0,0(s2)
    80001dea:	d12ff0ef          	jal	800012fc <uvmalloc>
    80001dee:	85aa                	mv	a1,a0
    80001df0:	c11d                	beqz	a0,80001e16 <growproc+0x6c>
  mm->sz = sz;
    80001df2:	00b93423          	sd	a1,8(s2)
  release(&mm->lock);
    80001df6:	854e                	mv	a0,s3
    80001df8:	ec5fe0ef          	jal	80000cbc <release>
  return 0;
    80001dfc:	4501                	li	a0,0
}
    80001dfe:	70a2                	ld	ra,40(sp)
    80001e00:	7402                	ld	s0,32(sp)
    80001e02:	64e2                	ld	s1,24(sp)
    80001e04:	6942                	ld	s2,16(sp)
    80001e06:	69a2                	ld	s3,8(sp)
    80001e08:	6145                	addi	sp,sp,48
    80001e0a:	8082                	ret
      release(&mm->lock);
    80001e0c:	854e                	mv	a0,s3
    80001e0e:	eaffe0ef          	jal	80000cbc <release>
      return -1;
    80001e12:	557d                	li	a0,-1
    80001e14:	b7ed                	j	80001dfe <growproc+0x54>
      release(&mm->lock);
    80001e16:	854e                	mv	a0,s3
    80001e18:	ea5fe0ef          	jal	80000cbc <release>
      return -1;
    80001e1c:	557d                	li	a0,-1
    80001e1e:	b7c5                	j	80001dfe <growproc+0x54>
  } else if (n < 0) {
    80001e20:	fc04d9e3          	bgez	s1,80001df2 <growproc+0x48>
    sz = uvmdealloc(mm->pagetable, sz, sz + n);
    80001e24:	00b48633          	add	a2,s1,a1
    80001e28:	00093503          	ld	a0,0(s2)
    80001e2c:	c8cff0ef          	jal	800012b8 <uvmdealloc>
    80001e30:	85aa                	mv	a1,a0
    80001e32:	b7c1                	j	80001df2 <growproc+0x48>

0000000080001e34 <kclone>:
{
    80001e34:	715d                	addi	sp,sp,-80
    80001e36:	e486                	sd	ra,72(sp)
    80001e38:	e0a2                	sd	s0,64(sp)
    80001e3a:	fc26                	sd	s1,56(sp)
    80001e3c:	f84a                	sd	s2,48(sp)
    80001e3e:	f052                	sd	s4,32(sp)
    80001e40:	ec56                	sd	s5,24(sp)
    80001e42:	e85a                	sd	s6,16(sp)
    80001e44:	e45e                	sd	s7,8(sp)
    80001e46:	0880                	addi	s0,sp,80
    80001e48:	8b2a                	mv	s6,a0
    80001e4a:	8bae                	mv	s7,a1
    80001e4c:	8a32                	mv	s4,a2
    80001e4e:	8936                	mv	s2,a3
    80001e50:	84ba                	mv	s1,a4
  struct proc *p = myproc();
    80001e52:	ac9ff0ef          	jal	8000191a <myproc>
    80001e56:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001e58:	e41ff0ef          	jal	80001c98 <allocproc>
    80001e5c:	20050163          	beqz	a0,8000205e <kclone+0x22a>
    80001e60:	f44e                	sd	s3,40(sp)
    80001e62:	89aa                	mv	s3,a0
  if (flags & CLONE_VM) {
    80001e64:	1004f493          	andi	s1,s1,256
    80001e68:	0e048463          	beqz	s1,80001f50 <kclone+0x11c>
    np->mm = p->mm;
    80001e6c:	048ab503          	ld	a0,72(s5)
    80001e70:	04a9b423          	sd	a0,72(s3)
    mm_get(np->mm);
    80001e74:	bebff0ef          	jal	80001a5e <mm_get>
    np->group_leader = p->group_leader;
    80001e78:	160ab783          	ld	a5,352(s5)
    80001e7c:	16f9b023          	sd	a5,352(s3)
    np->tgid = p->tgid;
    80001e80:	168aa783          	lw	a5,360(s5)
    80001e84:	16f9a423          	sw	a5,360(s3)
    acquire(&p->mm->lock);
    80001e88:	048ab503          	ld	a0,72(s5)
    80001e8c:	0561                	addi	a0,a0,24
    80001e8e:	d9bfe0ef          	jal	80000c28 <acquire>
    np->tf_va = find_free_tf_va(np->mm->pagetable);
    80001e92:	0489b483          	ld	s1,72(s3)
    80001e96:	6088                	ld	a0,0(s1)
    80001e98:	bf7ff0ef          	jal	80001a8e <find_free_tf_va>
    80001e9c:	85aa                	mv	a1,a0
    80001e9e:	16a9b823          	sd	a0,368(s3)
    if(np->tf_va == 0) {
    80001ea2:	c93d                	beqz	a0,80001f18 <kclone+0xe4>
    if(mappages(np->mm->pagetable, np->tf_va, PGSIZE, (uint64)np->trapframe, PTE_R | PTE_W) < 0) {
    80001ea4:	4719                	li	a4,6
    80001ea6:	0509b683          	ld	a3,80(s3)
    80001eaa:	6605                	lui	a2,0x1
    80001eac:	6088                	ld	a0,0(s1)
    80001eae:	9b2ff0ef          	jal	80001060 <mappages>
    80001eb2:	08054163          	bltz	a0,80001f34 <kclone+0x100>
    release(&p->mm->lock);
    80001eb6:	048ab503          	ld	a0,72(s5)
    80001eba:	0561                	addi	a0,a0,24
    80001ebc:	e01fe0ef          	jal	80000cbc <release>
    *(np->trapframe) = *(p->trapframe);
    80001ec0:	050ab683          	ld	a3,80(s5)
    80001ec4:	87b6                	mv	a5,a3
    80001ec6:	0509b703          	ld	a4,80(s3)
    80001eca:	12068693          	addi	a3,a3,288
    80001ece:	6388                	ld	a0,0(a5)
    80001ed0:	678c                	ld	a1,8(a5)
    80001ed2:	6b90                	ld	a2,16(a5)
    80001ed4:	e308                	sd	a0,0(a4)
    80001ed6:	e70c                	sd	a1,8(a4)
    80001ed8:	eb10                	sd	a2,16(a4)
    80001eda:	6f90                	ld	a2,24(a5)
    80001edc:	ef10                	sd	a2,24(a4)
    80001ede:	02078793          	addi	a5,a5,32
    80001ee2:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001ee6:	fed794e3          	bne	a5,a3,80001ece <kclone+0x9a>
    np->trapframe->a0 = arg;
    80001eea:	0509b783          	ld	a5,80(s3)
    80001eee:	0777b823          	sd	s7,112(a5)
    np->trapframe->epc = fn;
    80001ef2:	0509b783          	ld	a5,80(s3)
    80001ef6:	0167bc23          	sd	s6,24(a5)
    np->trapframe->sp = stack + n_pages * PGSIZE;
    80001efa:	0509b703          	ld	a4,80(s3)
    80001efe:	00c9179b          	slliw	a5,s2,0xc
    80001f02:	97d2                	add	a5,a5,s4
    80001f04:	fb1c                	sd	a5,48(a4)
    np->ustack = (void*)stack;
    80001f06:	1749bc23          	sd	s4,376(s3)
  for (i = 0; i < NOFILE; i++)
    80001f0a:	0c8a8493          	addi	s1,s5,200
    80001f0e:	0c898913          	addi	s2,s3,200
    80001f12:	148a8a13          	addi	s4,s5,328
    80001f16:	a87d                	j	80001fd4 <kclone+0x1a0>
      release(&p->mm->lock);
    80001f18:	048ab503          	ld	a0,72(s5)
    80001f1c:	0561                	addi	a0,a0,24
    80001f1e:	d9ffe0ef          	jal	80000cbc <release>
      freeproc(np);
    80001f22:	854e                	mv	a0,s3
    80001f24:	cf7ff0ef          	jal	80001c1a <freeproc>
      release(&np->lock);
    80001f28:	854e                	mv	a0,s3
    80001f2a:	d93fe0ef          	jal	80000cbc <release>
      return -1;
    80001f2e:	54fd                	li	s1,-1
    80001f30:	79a2                	ld	s3,40(sp)
    80001f32:	a211                	j	80002036 <kclone+0x202>
      release(&p->mm->lock);
    80001f34:	048ab503          	ld	a0,72(s5)
    80001f38:	0561                	addi	a0,a0,24
    80001f3a:	d83fe0ef          	jal	80000cbc <release>
      freeproc(np);
    80001f3e:	854e                	mv	a0,s3
    80001f40:	cdbff0ef          	jal	80001c1a <freeproc>
      release(&np->lock);
    80001f44:	854e                	mv	a0,s3
    80001f46:	d77fe0ef          	jal	80000cbc <release>
      return -1;
    80001f4a:	54fd                	li	s1,-1
    80001f4c:	79a2                	ld	s3,40(sp)
    80001f4e:	a0e5                	j	80002036 <kclone+0x202>
    if ((np->mm = mm_alloc()) == 0)
    80001f50:	ad7ff0ef          	jal	80001a26 <mm_alloc>
    80001f54:	84aa                	mv	s1,a0
    80001f56:	04a9b423          	sd	a0,72(s3)
    80001f5a:	0e050963          	beqz	a0,8000204c <kclone+0x218>
    if ((np->mm->pagetable = proc_pagetable(np)) == 0)
    80001f5e:	854e                	mv	a0,s3
    80001f60:	b8dff0ef          	jal	80001aec <proc_pagetable>
    80001f64:	e088                	sd	a0,0(s1)
    80001f66:	0e050363          	beqz	a0,8000204c <kclone+0x218>
    if (uvmcopy(p->mm->pagetable, np->mm->pagetable, p->mm->sz) < 0)
    80001f6a:	048ab783          	ld	a5,72(s5)
    80001f6e:	0489b703          	ld	a4,72(s3)
    80001f72:	6790                	ld	a2,8(a5)
    80001f74:	630c                	ld	a1,0(a4)
    80001f76:	6388                	ld	a0,0(a5)
    80001f78:	cbcff0ef          	jal	80001434 <uvmcopy>
    80001f7c:	0c054863          	bltz	a0,8000204c <kclone+0x218>
    np->mm->sz = p->mm->sz;
    80001f80:	0489b783          	ld	a5,72(s3)
    80001f84:	048ab703          	ld	a4,72(s5)
    80001f88:	6718                	ld	a4,8(a4)
    80001f8a:	e798                	sd	a4,8(a5)
    np->group_leader = np;
    80001f8c:	1739b023          	sd	s3,352(s3)
    np->tgid         = np->pid;
    80001f90:	0309a783          	lw	a5,48(s3)
    80001f94:	16f9a423          	sw	a5,360(s3)
    *(np->trapframe) = *(p->trapframe);
    80001f98:	050ab683          	ld	a3,80(s5)
    80001f9c:	87b6                	mv	a5,a3
    80001f9e:	0509b703          	ld	a4,80(s3)
    80001fa2:	12068693          	addi	a3,a3,288
    80001fa6:	6388                	ld	a0,0(a5)
    80001fa8:	678c                	ld	a1,8(a5)
    80001faa:	6b90                	ld	a2,16(a5)
    80001fac:	e308                	sd	a0,0(a4)
    80001fae:	e70c                	sd	a1,8(a4)
    80001fb0:	eb10                	sd	a2,16(a4)
    80001fb2:	6f90                	ld	a2,24(a5)
    80001fb4:	ef10                	sd	a2,24(a4)
    80001fb6:	02078793          	addi	a5,a5,32
    80001fba:	02070713          	addi	a4,a4,32
    80001fbe:	fed794e3          	bne	a5,a3,80001fa6 <kclone+0x172>
    np->trapframe->a0 = 0;     // child's clone() returns 0
    80001fc2:	0509b783          	ld	a5,80(s3)
    80001fc6:	0607b823          	sd	zero,112(a5)
    80001fca:	b781                	j	80001f0a <kclone+0xd6>
  for (i = 0; i < NOFILE; i++)
    80001fcc:	04a1                	addi	s1,s1,8
    80001fce:	0921                	addi	s2,s2,8
    80001fd0:	01448963          	beq	s1,s4,80001fe2 <kclone+0x1ae>
    if (p->ofile[i])
    80001fd4:	6088                	ld	a0,0(s1)
    80001fd6:	d97d                	beqz	a0,80001fcc <kclone+0x198>
      np->ofile[i] = filedup(p->ofile[i]);
    80001fd8:	6f6020ef          	jal	800046ce <filedup>
    80001fdc:	00a93023          	sd	a0,0(s2)
    80001fe0:	b7f5                	j	80001fcc <kclone+0x198>
  np->cwd = idup(p->cwd);
    80001fe2:	148ab503          	ld	a0,328(s5)
    80001fe6:	0c9010ef          	jal	800038ae <idup>
    80001fea:	14a9b423          	sd	a0,328(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001fee:	4641                	li	a2,16
    80001ff0:	150a8593          	addi	a1,s5,336
    80001ff4:	15098513          	addi	a0,s3,336
    80001ff8:	e55fe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001ffc:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80002000:	854e                	mv	a0,s3
    80002002:	cbbfe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80002006:	0000f517          	auipc	a0,0xf
    8000200a:	9ca50513          	addi	a0,a0,-1590 # 800109d0 <wait_lock>
    8000200e:	c1bfe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80002012:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002016:	0000f517          	auipc	a0,0xf
    8000201a:	9ba50513          	addi	a0,a0,-1606 # 800109d0 <wait_lock>
    8000201e:	c9ffe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80002022:	854e                	mv	a0,s3
    80002024:	c05fe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80002028:	478d                	li	a5,3
    8000202a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000202e:	854e                	mv	a0,s3
    80002030:	c8dfe0ef          	jal	80000cbc <release>
  return pid;
    80002034:	79a2                	ld	s3,40(sp)
}
    80002036:	8526                	mv	a0,s1
    80002038:	60a6                	ld	ra,72(sp)
    8000203a:	6406                	ld	s0,64(sp)
    8000203c:	74e2                	ld	s1,56(sp)
    8000203e:	7942                	ld	s2,48(sp)
    80002040:	7a02                	ld	s4,32(sp)
    80002042:	6ae2                	ld	s5,24(sp)
    80002044:	6b42                	ld	s6,16(sp)
    80002046:	6ba2                	ld	s7,8(sp)
    80002048:	6161                	addi	sp,sp,80
    8000204a:	8082                	ret
  freeproc(np);
    8000204c:	854e                	mv	a0,s3
    8000204e:	bcdff0ef          	jal	80001c1a <freeproc>
  release(&np->lock);
    80002052:	854e                	mv	a0,s3
    80002054:	c69fe0ef          	jal	80000cbc <release>
  return -1;
    80002058:	54fd                	li	s1,-1
    8000205a:	79a2                	ld	s3,40(sp)
    8000205c:	bfe9                	j	80002036 <kclone+0x202>
    return -1;
    8000205e:	54fd                	li	s1,-1
    80002060:	bfd9                	j	80002036 <kclone+0x202>

0000000080002062 <scheduler>:
{
    80002062:	715d                	addi	sp,sp,-80
    80002064:	e486                	sd	ra,72(sp)
    80002066:	e0a2                	sd	s0,64(sp)
    80002068:	fc26                	sd	s1,56(sp)
    8000206a:	f84a                	sd	s2,48(sp)
    8000206c:	f44e                	sd	s3,40(sp)
    8000206e:	f052                	sd	s4,32(sp)
    80002070:	ec56                	sd	s5,24(sp)
    80002072:	e85a                	sd	s6,16(sp)
    80002074:	e45e                	sd	s7,8(sp)
    80002076:	e062                	sd	s8,0(sp)
    80002078:	0880                	addi	s0,sp,80
    8000207a:	8792                	mv	a5,tp
  int id = r_tp();
    8000207c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000207e:	00779b13          	slli	s6,a5,0x7
    80002082:	0000f717          	auipc	a4,0xf
    80002086:	93670713          	addi	a4,a4,-1738 # 800109b8 <pid_lock>
    8000208a:	975a                	add	a4,a4,s6
    8000208c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002090:	0000f717          	auipc	a4,0xf
    80002094:	96070713          	addi	a4,a4,-1696 # 800109f0 <cpus+0x8>
    80002098:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000209a:	4c11                	li	s8,4
        c->proc = p;
    8000209c:	079e                	slli	a5,a5,0x7
    8000209e:	0000fa17          	auipc	s4,0xf
    800020a2:	91aa0a13          	addi	s4,s4,-1766 # 800109b8 <pid_lock>
    800020a6:	9a3e                	add	s4,s4,a5
        found = 1;
    800020a8:	4b85                	li	s7,1
    800020aa:	a83d                	j	800020e8 <scheduler+0x86>
      release(&p->lock);
    800020ac:	8526                	mv	a0,s1
    800020ae:	c0ffe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800020b2:	18048493          	addi	s1,s1,384
    800020b6:	03248563          	beq	s1,s2,800020e0 <scheduler+0x7e>
      acquire(&p->lock);
    800020ba:	8526                	mv	a0,s1
    800020bc:	b6dfe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    800020c0:	4c9c                	lw	a5,24(s1)
    800020c2:	ff3795e3          	bne	a5,s3,800020ac <scheduler+0x4a>
        p->state = RUNNING;
    800020c6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800020ca:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800020ce:	05848593          	addi	a1,s1,88
    800020d2:	855a                	mv	a0,s6
    800020d4:	11b000ef          	jal	800029ee <swtch>
        c->proc = 0;
    800020d8:	020a3823          	sd	zero,48(s4)
        found = 1;
    800020dc:	8ade                	mv	s5,s7
    800020de:	b7f9                	j	800020ac <scheduler+0x4a>
    if(found == 0) {
    800020e0:	000a9463          	bnez	s5,800020e8 <scheduler+0x86>
      asm volatile("wfi");
    800020e4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020ec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020f0:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800020f8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020fa:	10079073          	csrw	sstatus,a5
    int found = 0;
    800020fe:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002100:	0000f497          	auipc	s1,0xf
    80002104:	ce848493          	addi	s1,s1,-792 # 80010de8 <proc>
      if(p->state == RUNNABLE) {
    80002108:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000210a:	00015917          	auipc	s2,0x15
    8000210e:	cde90913          	addi	s2,s2,-802 # 80016de8 <tickslock>
    80002112:	b765                	j	800020ba <scheduler+0x58>

0000000080002114 <sched>:
{
    80002114:	7179                	addi	sp,sp,-48
    80002116:	f406                	sd	ra,40(sp)
    80002118:	f022                	sd	s0,32(sp)
    8000211a:	ec26                	sd	s1,24(sp)
    8000211c:	e84a                	sd	s2,16(sp)
    8000211e:	e44e                	sd	s3,8(sp)
    80002120:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002122:	ff8ff0ef          	jal	8000191a <myproc>
    80002126:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002128:	a91fe0ef          	jal	80000bb8 <holding>
    8000212c:	c935                	beqz	a0,800021a0 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000212e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002130:	2781                	sext.w	a5,a5
    80002132:	079e                	slli	a5,a5,0x7
    80002134:	0000f717          	auipc	a4,0xf
    80002138:	88470713          	addi	a4,a4,-1916 # 800109b8 <pid_lock>
    8000213c:	97ba                	add	a5,a5,a4
    8000213e:	0a87a703          	lw	a4,168(a5)
    80002142:	4785                	li	a5,1
    80002144:	06f71463          	bne	a4,a5,800021ac <sched+0x98>
  if(p->state == RUNNING)
    80002148:	4c98                	lw	a4,24(s1)
    8000214a:	4791                	li	a5,4
    8000214c:	06f70663          	beq	a4,a5,800021b8 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002150:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002154:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002156:	e7bd                	bnez	a5,800021c4 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002158:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000215a:	0000f917          	auipc	s2,0xf
    8000215e:	85e90913          	addi	s2,s2,-1954 # 800109b8 <pid_lock>
    80002162:	2781                	sext.w	a5,a5
    80002164:	079e                	slli	a5,a5,0x7
    80002166:	97ca                	add	a5,a5,s2
    80002168:	0ac7a983          	lw	s3,172(a5)
    8000216c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000216e:	2781                	sext.w	a5,a5
    80002170:	079e                	slli	a5,a5,0x7
    80002172:	07a1                	addi	a5,a5,8
    80002174:	0000f597          	auipc	a1,0xf
    80002178:	87458593          	addi	a1,a1,-1932 # 800109e8 <cpus>
    8000217c:	95be                	add	a1,a1,a5
    8000217e:	05848513          	addi	a0,s1,88
    80002182:	06d000ef          	jal	800029ee <swtch>
    80002186:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002188:	2781                	sext.w	a5,a5
    8000218a:	079e                	slli	a5,a5,0x7
    8000218c:	993e                	add	s2,s2,a5
    8000218e:	0b392623          	sw	s3,172(s2)
}
    80002192:	70a2                	ld	ra,40(sp)
    80002194:	7402                	ld	s0,32(sp)
    80002196:	64e2                	ld	s1,24(sp)
    80002198:	6942                	ld	s2,16(sp)
    8000219a:	69a2                	ld	s3,8(sp)
    8000219c:	6145                	addi	sp,sp,48
    8000219e:	8082                	ret
    panic("sched p->lock");
    800021a0:	00006517          	auipc	a0,0x6
    800021a4:	03850513          	addi	a0,a0,56 # 800081d8 <etext+0x1d8>
    800021a8:	e7cfe0ef          	jal	80000824 <panic>
    panic("sched locks");
    800021ac:	00006517          	auipc	a0,0x6
    800021b0:	03c50513          	addi	a0,a0,60 # 800081e8 <etext+0x1e8>
    800021b4:	e70fe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    800021b8:	00006517          	auipc	a0,0x6
    800021bc:	04050513          	addi	a0,a0,64 # 800081f8 <etext+0x1f8>
    800021c0:	e64fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    800021c4:	00006517          	auipc	a0,0x6
    800021c8:	04450513          	addi	a0,a0,68 # 80008208 <etext+0x208>
    800021cc:	e58fe0ef          	jal	80000824 <panic>

00000000800021d0 <yield>:
{
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	e426                	sd	s1,8(sp)
    800021d8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021da:	f40ff0ef          	jal	8000191a <myproc>
    800021de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021e0:	a49fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    800021e4:	478d                	li	a5,3
    800021e6:	cc9c                	sw	a5,24(s1)
  sched();
    800021e8:	f2dff0ef          	jal	80002114 <sched>
  release(&p->lock);
    800021ec:	8526                	mv	a0,s1
    800021ee:	acffe0ef          	jal	80000cbc <release>
}
    800021f2:	60e2                	ld	ra,24(sp)
    800021f4:	6442                	ld	s0,16(sp)
    800021f6:	64a2                	ld	s1,8(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret

00000000800021fc <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800021fc:	7179                	addi	sp,sp,-48
    800021fe:	f406                	sd	ra,40(sp)
    80002200:	f022                	sd	s0,32(sp)
    80002202:	ec26                	sd	s1,24(sp)
    80002204:	e84a                	sd	s2,16(sp)
    80002206:	e44e                	sd	s3,8(sp)
    80002208:	1800                	addi	s0,sp,48
    8000220a:	89aa                	mv	s3,a0
    8000220c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000220e:	f0cff0ef          	jal	8000191a <myproc>
    80002212:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002214:	a15fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80002218:	854a                	mv	a0,s2
    8000221a:	aa3fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    8000221e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002222:	4789                	li	a5,2
    80002224:	cc9c                	sw	a5,24(s1)

  sched();
    80002226:	eefff0ef          	jal	80002114 <sched>

  // Tidy up.
  p->chan = 0;
    8000222a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000222e:	8526                	mv	a0,s1
    80002230:	a8dfe0ef          	jal	80000cbc <release>
  acquire(lk);
    80002234:	854a                	mv	a0,s2
    80002236:	9f3fe0ef          	jal	80000c28 <acquire>
}
    8000223a:	70a2                	ld	ra,40(sp)
    8000223c:	7402                	ld	s0,32(sp)
    8000223e:	64e2                	ld	s1,24(sp)
    80002240:	6942                	ld	s2,16(sp)
    80002242:	69a2                	ld	s3,8(sp)
    80002244:	6145                	addi	sp,sp,48
    80002246:	8082                	ret

0000000080002248 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002248:	7139                	addi	sp,sp,-64
    8000224a:	fc06                	sd	ra,56(sp)
    8000224c:	f822                	sd	s0,48(sp)
    8000224e:	f426                	sd	s1,40(sp)
    80002250:	f04a                	sd	s2,32(sp)
    80002252:	ec4e                	sd	s3,24(sp)
    80002254:	e852                	sd	s4,16(sp)
    80002256:	e456                	sd	s5,8(sp)
    80002258:	0080                	addi	s0,sp,64
    8000225a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000225c:	0000f497          	auipc	s1,0xf
    80002260:	b8c48493          	addi	s1,s1,-1140 # 80010de8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002264:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002266:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002268:	00015917          	auipc	s2,0x15
    8000226c:	b8090913          	addi	s2,s2,-1152 # 80016de8 <tickslock>
    80002270:	a801                	j	80002280 <wakeup+0x38>
      }
      release(&p->lock);
    80002272:	8526                	mv	a0,s1
    80002274:	a49fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002278:	18048493          	addi	s1,s1,384
    8000227c:	03248263          	beq	s1,s2,800022a0 <wakeup+0x58>
    if(p != myproc()){
    80002280:	e9aff0ef          	jal	8000191a <myproc>
    80002284:	fe950ae3          	beq	a0,s1,80002278 <wakeup+0x30>
      acquire(&p->lock);
    80002288:	8526                	mv	a0,s1
    8000228a:	99ffe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000228e:	4c9c                	lw	a5,24(s1)
    80002290:	ff3791e3          	bne	a5,s3,80002272 <wakeup+0x2a>
    80002294:	709c                	ld	a5,32(s1)
    80002296:	fd479ee3          	bne	a5,s4,80002272 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000229a:	0154ac23          	sw	s5,24(s1)
    8000229e:	bfd1                	j	80002272 <wakeup+0x2a>
    }
  }
}
    800022a0:	70e2                	ld	ra,56(sp)
    800022a2:	7442                	ld	s0,48(sp)
    800022a4:	74a2                	ld	s1,40(sp)
    800022a6:	7902                	ld	s2,32(sp)
    800022a8:	69e2                	ld	s3,24(sp)
    800022aa:	6a42                	ld	s4,16(sp)
    800022ac:	6aa2                	ld	s5,8(sp)
    800022ae:	6121                	addi	sp,sp,64
    800022b0:	8082                	ret

00000000800022b2 <reparent>:
{
    800022b2:	7179                	addi	sp,sp,-48
    800022b4:	f406                	sd	ra,40(sp)
    800022b6:	f022                	sd	s0,32(sp)
    800022b8:	ec26                	sd	s1,24(sp)
    800022ba:	e84a                	sd	s2,16(sp)
    800022bc:	e44e                	sd	s3,8(sp)
    800022be:	e052                	sd	s4,0(sp)
    800022c0:	1800                	addi	s0,sp,48
    800022c2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022c4:	0000f497          	auipc	s1,0xf
    800022c8:	b2448493          	addi	s1,s1,-1244 # 80010de8 <proc>
      pp->parent = initproc;
    800022cc:	00006a17          	auipc	s4,0x6
    800022d0:	5e4a0a13          	addi	s4,s4,1508 # 800088b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022d4:	00015997          	auipc	s3,0x15
    800022d8:	b1498993          	addi	s3,s3,-1260 # 80016de8 <tickslock>
    800022dc:	a029                	j	800022e6 <reparent+0x34>
    800022de:	18048493          	addi	s1,s1,384
    800022e2:	01348b63          	beq	s1,s3,800022f8 <reparent+0x46>
    if(pp->parent == p){
    800022e6:	7c9c                	ld	a5,56(s1)
    800022e8:	ff279be3          	bne	a5,s2,800022de <reparent+0x2c>
      pp->parent = initproc;
    800022ec:	000a3503          	ld	a0,0(s4)
    800022f0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800022f2:	f57ff0ef          	jal	80002248 <wakeup>
    800022f6:	b7e5                	j	800022de <reparent+0x2c>
}
    800022f8:	70a2                	ld	ra,40(sp)
    800022fa:	7402                	ld	s0,32(sp)
    800022fc:	64e2                	ld	s1,24(sp)
    800022fe:	6942                	ld	s2,16(sp)
    80002300:	69a2                	ld	s3,8(sp)
    80002302:	6a02                	ld	s4,0(sp)
    80002304:	6145                	addi	sp,sp,48
    80002306:	8082                	ret

0000000080002308 <kexit>:
{
    80002308:	7139                	addi	sp,sp,-64
    8000230a:	fc06                	sd	ra,56(sp)
    8000230c:	f822                	sd	s0,48(sp)
    8000230e:	e852                	sd	s4,16(sp)
    80002310:	0080                	addi	s0,sp,64
    80002312:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002314:	e06ff0ef          	jal	8000191a <myproc>
  if(p == initproc)
    80002318:	00006797          	auipc	a5,0x6
    8000231c:	5987b783          	ld	a5,1432(a5) # 800088b0 <initproc>
    80002320:	02a78163          	beq	a5,a0,80002342 <kexit+0x3a>
    80002324:	f426                	sd	s1,40(sp)
    80002326:	f04a                	sd	s2,32(sp)
    80002328:	ec4e                	sd	s3,24(sp)
    8000232a:	e456                	sd	s5,8(sp)
    8000232c:	e05a                	sd	s6,0(sp)
    8000232e:	892a                	mv	s2,a0
  if(p == p->group_leader) {
    80002330:	16053783          	ld	a5,352(a0)
    80002334:	02a78263          	beq	a5,a0,80002358 <kexit+0x50>
  for(int fd = 0; fd < NOFILE; fd++){
    80002338:	0c890493          	addi	s1,s2,200
    8000233c:	14890993          	addi	s3,s2,328
    80002340:	a8fd                	j	8000243e <kexit+0x136>
    80002342:	f426                	sd	s1,40(sp)
    80002344:	f04a                	sd	s2,32(sp)
    80002346:	ec4e                	sd	s3,24(sp)
    80002348:	e456                	sd	s5,8(sp)
    8000234a:	e05a                	sd	s6,0(sp)
    panic("init exiting");
    8000234c:	00006517          	auipc	a0,0x6
    80002350:	ed450513          	addi	a0,a0,-300 # 80008220 <etext+0x220>
    80002354:	cd0fe0ef          	jal	80000824 <panic>
    acquire(&wait_lock);
    80002358:	0000e517          	auipc	a0,0xe
    8000235c:	67850513          	addi	a0,a0,1656 # 800109d0 <wait_lock>
    80002360:	8c9fe0ef          	jal	80000c28 <acquire>
    for(struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002364:	0000f497          	auipc	s1,0xf
    80002368:	a8448493          	addi	s1,s1,-1404 # 80010de8 <proc>
        pp->killed = 1;
    8000236c:	4b05                	li	s6,1
        if(pp->state == SLEEPING) pp->state = RUNNABLE;
    8000236e:	4a89                	li	s5,2
    for(struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002370:	00015997          	auipc	s3,0x15
    80002374:	a7898993          	addi	s3,s3,-1416 # 80016de8 <tickslock>
    80002378:	a801                	j	80002388 <kexit+0x80>
        release(&pp->lock);
    8000237a:	8526                	mv	a0,s1
    8000237c:	941fe0ef          	jal	80000cbc <release>
    for(struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002380:	18048493          	addi	s1,s1,384
    80002384:	03348363          	beq	s1,s3,800023aa <kexit+0xa2>
      if(pp->group_leader == p && pp != p) {
    80002388:	1604b783          	ld	a5,352(s1)
    8000238c:	ff279ae3          	bne	a5,s2,80002380 <kexit+0x78>
    80002390:	fe9908e3          	beq	s2,s1,80002380 <kexit+0x78>
        acquire(&pp->lock);
    80002394:	8526                	mv	a0,s1
    80002396:	893fe0ef          	jal	80000c28 <acquire>
        pp->killed = 1;
    8000239a:	0364a423          	sw	s6,40(s1)
        if(pp->state == SLEEPING) pp->state = RUNNABLE;
    8000239e:	4c9c                	lw	a5,24(s1)
    800023a0:	fd579de3          	bne	a5,s5,8000237a <kexit+0x72>
    800023a4:	478d                	li	a5,3
    800023a6:	cc9c                	sw	a5,24(s1)
    800023a8:	bfc9                	j	8000237a <kexit+0x72>
    for(struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    800023aa:	0000f497          	auipc	s1,0xf
    800023ae:	a3e48493          	addi	s1,s1,-1474 # 80010de8 <proc>
        if(pp->state == ZOMBIE) freeproc(pp);
    800023b2:	4b15                	li	s6,5
          acquire(&wait_lock);
    800023b4:	0000e997          	auipc	s3,0xe
    800023b8:	61c98993          	addi	s3,s3,1564 # 800109d0 <wait_lock>
    for(struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    800023bc:	00015a97          	auipc	s5,0x15
    800023c0:	a2ca8a93          	addi	s5,s5,-1492 # 80016de8 <tickslock>
    800023c4:	a811                	j	800023d8 <kexit+0xd0>
        if(pp->state == ZOMBIE) freeproc(pp);
    800023c6:	05678e63          	beq	a5,s6,80002422 <kexit+0x11a>
        release(&pp->lock);
    800023ca:	8526                	mv	a0,s1
    800023cc:	8f1fe0ef          	jal	80000cbc <release>
    for(struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    800023d0:	18048493          	addi	s1,s1,384
    800023d4:	05548b63          	beq	s1,s5,8000242a <kexit+0x122>
      if(pp->group_leader == p && pp != p) {
    800023d8:	1604b783          	ld	a5,352(s1)
    800023dc:	ff279ae3          	bne	a5,s2,800023d0 <kexit+0xc8>
    800023e0:	fe9908e3          	beq	s2,s1,800023d0 <kexit+0xc8>
        acquire(&pp->lock);
    800023e4:	8526                	mv	a0,s1
    800023e6:	843fe0ef          	jal	80000c28 <acquire>
        while(pp->state != ZOMBIE && pp->state != UNUSED && pp->group_leader == p) {
    800023ea:	4c9c                	lw	a5,24(s1)
    800023ec:	ffb78713          	addi	a4,a5,-5
    800023f0:	db79                	beqz	a4,800023c6 <kexit+0xbe>
    800023f2:	dbf1                	beqz	a5,800023c6 <kexit+0xbe>
    800023f4:	1604b783          	ld	a5,352(s1)
    800023f8:	fd2799e3          	bne	a5,s2,800023ca <kexit+0xc2>
          release(&pp->lock);
    800023fc:	8526                	mv	a0,s1
    800023fe:	8bffe0ef          	jal	80000cbc <release>
          acquire(&wait_lock);
    80002402:	854e                	mv	a0,s3
    80002404:	825fe0ef          	jal	80000c28 <acquire>
          sleep(p, &wait_lock);
    80002408:	85ce                	mv	a1,s3
    8000240a:	854a                	mv	a0,s2
    8000240c:	df1ff0ef          	jal	800021fc <sleep>
          acquire(&pp->lock);
    80002410:	8526                	mv	a0,s1
    80002412:	817fe0ef          	jal	80000c28 <acquire>
        while(pp->state != ZOMBIE && pp->state != UNUSED && pp->group_leader == p) {
    80002416:	4c9c                	lw	a5,24(s1)
    80002418:	ffb78713          	addi	a4,a5,-5
    8000241c:	d74d                	beqz	a4,800023c6 <kexit+0xbe>
    8000241e:	fbf9                	bnez	a5,800023f4 <kexit+0xec>
    80002420:	b75d                	j	800023c6 <kexit+0xbe>
        if(pp->state == ZOMBIE) freeproc(pp);
    80002422:	8526                	mv	a0,s1
    80002424:	ff6ff0ef          	jal	80001c1a <freeproc>
    80002428:	b74d                	j	800023ca <kexit+0xc2>
    release(&wait_lock);
    8000242a:	0000e517          	auipc	a0,0xe
    8000242e:	5a650513          	addi	a0,a0,1446 # 800109d0 <wait_lock>
    80002432:	88bfe0ef          	jal	80000cbc <release>
    80002436:	b709                	j	80002338 <kexit+0x30>
  for(int fd = 0; fd < NOFILE; fd++){
    80002438:	04a1                	addi	s1,s1,8
    8000243a:	01348963          	beq	s1,s3,8000244c <kexit+0x144>
    if(p->ofile[fd]){
    8000243e:	6088                	ld	a0,0(s1)
    80002440:	dd65                	beqz	a0,80002438 <kexit+0x130>
      fileclose(f);
    80002442:	2d2020ef          	jal	80004714 <fileclose>
      p->ofile[fd] = 0;
    80002446:	0004b023          	sd	zero,0(s1)
    8000244a:	b7fd                	j	80002438 <kexit+0x130>
  begin_op();
    8000244c:	6a5010ef          	jal	800042f0 <begin_op>
  iput(p->cwd);
    80002450:	14893503          	ld	a0,328(s2)
    80002454:	612010ef          	jal	80003a66 <iput>
  end_op();
    80002458:	709010ef          	jal	80004360 <end_op>
  p->cwd = 0;
    8000245c:	14093423          	sd	zero,328(s2)
  acquire(&wait_lock);
    80002460:	0000e517          	auipc	a0,0xe
    80002464:	57050513          	addi	a0,a0,1392 # 800109d0 <wait_lock>
    80002468:	fc0fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    8000246c:	854a                	mv	a0,s2
    8000246e:	e45ff0ef          	jal	800022b2 <reparent>
  wakeup(p->parent);
    80002472:	03893503          	ld	a0,56(s2)
    80002476:	dd3ff0ef          	jal	80002248 <wakeup>
  if (p->group_leader != p)
    8000247a:	16093503          	ld	a0,352(s2)
    8000247e:	01250463          	beq	a0,s2,80002486 <kexit+0x17e>
    wakeup(p->group_leader);
    80002482:	dc7ff0ef          	jal	80002248 <wakeup>
  acquire(&p->lock);
    80002486:	854a                	mv	a0,s2
    80002488:	fa0fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    8000248c:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    80002490:	4795                	li	a5,5
    80002492:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80002496:	0000e517          	auipc	a0,0xe
    8000249a:	53a50513          	addi	a0,a0,1338 # 800109d0 <wait_lock>
    8000249e:	81ffe0ef          	jal	80000cbc <release>
  sched();
    800024a2:	c73ff0ef          	jal	80002114 <sched>
  panic("zombie exit");
    800024a6:	00006517          	auipc	a0,0x6
    800024aa:	d8a50513          	addi	a0,a0,-630 # 80008230 <etext+0x230>
    800024ae:	b76fe0ef          	jal	80000824 <panic>

00000000800024b2 <kkill>:
// Kill the process containing pid.
// In the original xv6 this is one task;
// with thread groups it should be the whole group.
int
kkill(int pid)
{
    800024b2:	7139                	addi	sp,sp,-64
    800024b4:	fc06                	sd	ra,56(sp)
    800024b6:	f822                	sd	s0,48(sp)
    800024b8:	f426                	sd	s1,40(sp)
    800024ba:	f04a                	sd	s2,32(sp)
    800024bc:	ec4e                	sd	s3,24(sp)
    800024be:	e852                	sd	s4,16(sp)
    800024c0:	e456                	sd	s5,8(sp)
    800024c2:	e05a                	sd	s6,0(sp)
    800024c4:	0080                	addi	s0,sp,64
    800024c6:	892a                	mv	s2,a0
  struct proc *p;
  int target_tgid = -1;

  for(p = proc; p < &proc[NPROC]; p++){
    800024c8:	0000f497          	auipc	s1,0xf
    800024cc:	92048493          	addi	s1,s1,-1760 # 80010de8 <proc>
    800024d0:	00015997          	auipc	s3,0x15
    800024d4:	91898993          	addi	s3,s3,-1768 # 80016de8 <tickslock>
    acquire(&p->lock);
    800024d8:	8526                	mv	a0,s1
    800024da:	f4efe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    800024de:	589c                	lw	a5,48(s1)
    800024e0:	01278b63          	beq	a5,s2,800024f6 <kkill+0x44>
      target_tgid = p->tgid;
      release(&p->lock);
      break;
    }
    release(&p->lock);
    800024e4:	8526                	mv	a0,s1
    800024e6:	fd6fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024ea:	18048493          	addi	s1,s1,384
    800024ee:	ff3495e3          	bne	s1,s3,800024d8 <kkill+0x26>
  }

  if (target_tgid == -1) return -1;
    800024f2:	597d                	li	s2,-1
    800024f4:	a8a1                	j	8000254c <kkill+0x9a>
      target_tgid = p->tgid;
    800024f6:	1684a903          	lw	s2,360(s1)
      release(&p->lock);
    800024fa:	8526                	mv	a0,s1
    800024fc:	fc0fe0ef          	jal	80000cbc <release>
  if (target_tgid == -1) return -1;
    80002500:	57fd                	li	a5,-1
    80002502:	04f90563          	beq	s2,a5,8000254c <kkill+0x9a>

  for(p = proc; p < &proc[NPROC]; p++){
    80002506:	0000f497          	auipc	s1,0xf
    8000250a:	8e248493          	addi	s1,s1,-1822 # 80010de8 <proc>
    acquire(&p->lock);
    if(p->tgid == target_tgid){
      p->killed = 1;
    8000250e:	4a85                	li	s5,1
      if(p->state == SLEEPING) p->state = RUNNABLE;
    80002510:	4a09                	li	s4,2
    80002512:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++){
    80002514:	00015997          	auipc	s3,0x15
    80002518:	8d498993          	addi	s3,s3,-1836 # 80016de8 <tickslock>
    8000251c:	a801                	j	8000252c <kkill+0x7a>
    }
    release(&p->lock);
    8000251e:	8526                	mv	a0,s1
    80002520:	f9cfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002524:	18048493          	addi	s1,s1,384
    80002528:	03348163          	beq	s1,s3,8000254a <kkill+0x98>
    acquire(&p->lock);
    8000252c:	8526                	mv	a0,s1
    8000252e:	efafe0ef          	jal	80000c28 <acquire>
    if(p->tgid == target_tgid){
    80002532:	1684a783          	lw	a5,360(s1)
    80002536:	ff2794e3          	bne	a5,s2,8000251e <kkill+0x6c>
      p->killed = 1;
    8000253a:	0354a423          	sw	s5,40(s1)
      if(p->state == SLEEPING) p->state = RUNNABLE;
    8000253e:	4c9c                	lw	a5,24(s1)
    80002540:	fd479fe3          	bne	a5,s4,8000251e <kkill+0x6c>
    80002544:	0164ac23          	sw	s6,24(s1)
    80002548:	bfd9                	j	8000251e <kkill+0x6c>
  }
  return 0;
    8000254a:	4901                	li	s2,0
}
    8000254c:	854a                	mv	a0,s2
    8000254e:	70e2                	ld	ra,56(sp)
    80002550:	7442                	ld	s0,48(sp)
    80002552:	74a2                	ld	s1,40(sp)
    80002554:	7902                	ld	s2,32(sp)
    80002556:	69e2                	ld	s3,24(sp)
    80002558:	6a42                	ld	s4,16(sp)
    8000255a:	6aa2                	ld	s5,8(sp)
    8000255c:	6b02                	ld	s6,0(sp)
    8000255e:	6121                	addi	sp,sp,64
    80002560:	8082                	ret

0000000080002562 <setkilled>:

void
setkilled(struct proc *p)
{
    80002562:	1101                	addi	sp,sp,-32
    80002564:	ec06                	sd	ra,24(sp)
    80002566:	e822                	sd	s0,16(sp)
    80002568:	e426                	sd	s1,8(sp)
    8000256a:	1000                	addi	s0,sp,32
    8000256c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000256e:	ebafe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002572:	4785                	li	a5,1
    80002574:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002576:	8526                	mv	a0,s1
    80002578:	f44fe0ef          	jal	80000cbc <release>
}
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret

0000000080002586 <killed>:

int
killed(struct proc *p)
{
    80002586:	1101                	addi	sp,sp,-32
    80002588:	ec06                	sd	ra,24(sp)
    8000258a:	e822                	sd	s0,16(sp)
    8000258c:	e426                	sd	s1,8(sp)
    8000258e:	e04a                	sd	s2,0(sp)
    80002590:	1000                	addi	s0,sp,32
    80002592:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002594:	e94fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    80002598:	549c                	lw	a5,40(s1)
    8000259a:	893e                	mv	s2,a5
  release(&p->lock);
    8000259c:	8526                	mv	a0,s1
    8000259e:	f1efe0ef          	jal	80000cbc <release>
  return k;
}
    800025a2:	854a                	mv	a0,s2
    800025a4:	60e2                	ld	ra,24(sp)
    800025a6:	6442                	ld	s0,16(sp)
    800025a8:	64a2                	ld	s1,8(sp)
    800025aa:	6902                	ld	s2,0(sp)
    800025ac:	6105                	addi	sp,sp,32
    800025ae:	8082                	ret

00000000800025b0 <kjoin>:
{
    800025b0:	7139                	addi	sp,sp,-64
    800025b2:	fc06                	sd	ra,56(sp)
    800025b4:	f822                	sd	s0,48(sp)
    800025b6:	f426                	sd	s1,40(sp)
    800025b8:	f04a                	sd	s2,32(sp)
    800025ba:	ec4e                	sd	s3,24(sp)
    800025bc:	e852                	sd	s4,16(sp)
    800025be:	e456                	sd	s5,8(sp)
    800025c0:	e05a                	sd	s6,0(sp)
    800025c2:	0080                	addi	s0,sp,64
    800025c4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800025c6:	b54ff0ef          	jal	8000191a <myproc>
    800025ca:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800025cc:	0000e517          	auipc	a0,0xe
    800025d0:	40450513          	addi	a0,a0,1028 # 800109d0 <wait_lock>
    800025d4:	e54fe0ef          	jal	80000c28 <acquire>
      if(pp->state == ZOMBIE) {
    800025d8:	4a15                	li	s4,5
      havekids = 1;
    800025da:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++) {
    800025dc:	00015997          	auipc	s3,0x15
    800025e0:	80c98993          	addi	s3,s3,-2036 # 80016de8 <tickslock>
    havekids = 0;
    800025e4:	4681                	li	a3,0
    for(pp = proc; pp < &proc[NPROC]; pp++) {
    800025e6:	0000f497          	auipc	s1,0xf
    800025ea:	80248493          	addi	s1,s1,-2046 # 80010de8 <proc>
    800025ee:	a0b5                	j	8000265a <kjoin+0xaa>
        pid = pp->pid;
    800025f0:	0304a983          	lw	s3,48(s1)
        if(stack_addr != 0 && copyout(p->mm->pagetable, stack_addr, (char *)&pp->ustack, sizeof(pp->ustack)) < 0) {
    800025f4:	85da                	mv	a1,s6
    800025f6:	000b0c63          	beqz	s6,8000260e <kjoin+0x5e>
    800025fa:	04893783          	ld	a5,72(s2)
    800025fe:	46a1                	li	a3,8
    80002600:	17848613          	addi	a2,s1,376
    80002604:	6388                	ld	a0,0(a5)
    80002606:	852ff0ef          	jal	80001658 <copyout>
    8000260a:	02054963          	bltz	a0,8000263c <kjoin+0x8c>
        freeproc(pp);
    8000260e:	8526                	mv	a0,s1
    80002610:	e0aff0ef          	jal	80001c1a <freeproc>
        release(&pp->lock);
    80002614:	8526                	mv	a0,s1
    80002616:	ea6fe0ef          	jal	80000cbc <release>
        release(&wait_lock);
    8000261a:	0000e517          	auipc	a0,0xe
    8000261e:	3b650513          	addi	a0,a0,950 # 800109d0 <wait_lock>
    80002622:	e9afe0ef          	jal	80000cbc <release>
}
    80002626:	854e                	mv	a0,s3
    80002628:	70e2                	ld	ra,56(sp)
    8000262a:	7442                	ld	s0,48(sp)
    8000262c:	74a2                	ld	s1,40(sp)
    8000262e:	7902                	ld	s2,32(sp)
    80002630:	69e2                	ld	s3,24(sp)
    80002632:	6a42                	ld	s4,16(sp)
    80002634:	6aa2                	ld	s5,8(sp)
    80002636:	6b02                	ld	s6,0(sp)
    80002638:	6121                	addi	sp,sp,64
    8000263a:	8082                	ret
          release(&pp->lock);
    8000263c:	8526                	mv	a0,s1
    8000263e:	e7efe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    80002642:	0000e517          	auipc	a0,0xe
    80002646:	38e50513          	addi	a0,a0,910 # 800109d0 <wait_lock>
    8000264a:	e72fe0ef          	jal	80000cbc <release>
          return -1;
    8000264e:	59fd                	li	s3,-1
    80002650:	bfd9                	j	80002626 <kjoin+0x76>
    for(pp = proc; pp < &proc[NPROC]; pp++) {
    80002652:	18048493          	addi	s1,s1,384
    80002656:	03348563          	beq	s1,s3,80002680 <kjoin+0xd0>
      if(pp->group_leader != p->group_leader || pp == p) continue;
    8000265a:	1604b703          	ld	a4,352(s1)
    8000265e:	16093783          	ld	a5,352(s2)
    80002662:	fef718e3          	bne	a4,a5,80002652 <kjoin+0xa2>
    80002666:	fe9906e3          	beq	s2,s1,80002652 <kjoin+0xa2>
      acquire(&pp->lock);
    8000266a:	8526                	mv	a0,s1
    8000266c:	dbcfe0ef          	jal	80000c28 <acquire>
      if(pp->state == ZOMBIE) {
    80002670:	4c9c                	lw	a5,24(s1)
    80002672:	f7478fe3          	beq	a5,s4,800025f0 <kjoin+0x40>
      release(&pp->lock);
    80002676:	8526                	mv	a0,s1
    80002678:	e44fe0ef          	jal	80000cbc <release>
      havekids = 1;
    8000267c:	86d6                	mv	a3,s5
    8000267e:	bfd1                	j	80002652 <kjoin+0xa2>
    if(!havekids || killed(p)) {
    80002680:	ce91                	beqz	a3,8000269c <kjoin+0xec>
    80002682:	854a                	mv	a0,s2
    80002684:	f03ff0ef          	jal	80002586 <killed>
    80002688:	e911                	bnez	a0,8000269c <kjoin+0xec>
    sleep(p->group_leader, &wait_lock);
    8000268a:	0000e597          	auipc	a1,0xe
    8000268e:	34658593          	addi	a1,a1,838 # 800109d0 <wait_lock>
    80002692:	16093503          	ld	a0,352(s2)
    80002696:	b67ff0ef          	jal	800021fc <sleep>
    havekids = 0;
    8000269a:	b7a9                	j	800025e4 <kjoin+0x34>
      release(&wait_lock);
    8000269c:	0000e517          	auipc	a0,0xe
    800026a0:	33450513          	addi	a0,a0,820 # 800109d0 <wait_lock>
    800026a4:	e18fe0ef          	jal	80000cbc <release>
      return -1;
    800026a8:	59fd                	li	s3,-1
    800026aa:	bfb5                	j	80002626 <kjoin+0x76>

00000000800026ac <kwait>:
{
    800026ac:	715d                	addi	sp,sp,-80
    800026ae:	e486                	sd	ra,72(sp)
    800026b0:	e0a2                	sd	s0,64(sp)
    800026b2:	fc26                	sd	s1,56(sp)
    800026b4:	f84a                	sd	s2,48(sp)
    800026b6:	f44e                	sd	s3,40(sp)
    800026b8:	f052                	sd	s4,32(sp)
    800026ba:	ec56                	sd	s5,24(sp)
    800026bc:	e85a                	sd	s6,16(sp)
    800026be:	e45e                	sd	s7,8(sp)
    800026c0:	0880                	addi	s0,sp,80
    800026c2:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800026c4:	a56ff0ef          	jal	8000191a <myproc>
    800026c8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800026ca:	0000e517          	auipc	a0,0xe
    800026ce:	30650513          	addi	a0,a0,774 # 800109d0 <wait_lock>
    800026d2:	d56fe0ef          	jal	80000c28 <acquire>
      if(pp->state == ZOMBIE){
    800026d6:	4a15                	li	s4,5
      havekids = 1;
    800026d8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800026da:	00014997          	auipc	s3,0x14
    800026de:	70e98993          	addi	s3,s3,1806 # 80016de8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800026e2:	0000eb17          	auipc	s6,0xe
    800026e6:	2eeb0b13          	addi	s6,s6,750 # 800109d0 <wait_lock>
    800026ea:	a055                	j	8000278e <kwait+0xe2>
        pid = pp->pid;
    800026ec:	0304a983          	lw	s3,48(s1)
        if(addr != 0 && copyout(p->mm->pagetable, addr,
    800026f0:	85de                	mv	a1,s7
    800026f2:	000b8c63          	beqz	s7,8000270a <kwait+0x5e>
    800026f6:	04893783          	ld	a5,72(s2)
    800026fa:	4691                	li	a3,4
    800026fc:	02c48613          	addi	a2,s1,44
    80002700:	6388                	ld	a0,0(a5)
    80002702:	f57fe0ef          	jal	80001658 <copyout>
    80002706:	02054a63          	bltz	a0,8000273a <kwait+0x8e>
        freeproc(pp);
    8000270a:	8526                	mv	a0,s1
    8000270c:	d0eff0ef          	jal	80001c1a <freeproc>
        release(&pp->lock);
    80002710:	8526                	mv	a0,s1
    80002712:	daafe0ef          	jal	80000cbc <release>
        release(&wait_lock);
    80002716:	0000e517          	auipc	a0,0xe
    8000271a:	2ba50513          	addi	a0,a0,698 # 800109d0 <wait_lock>
    8000271e:	d9efe0ef          	jal	80000cbc <release>
}
    80002722:	854e                	mv	a0,s3
    80002724:	60a6                	ld	ra,72(sp)
    80002726:	6406                	ld	s0,64(sp)
    80002728:	74e2                	ld	s1,56(sp)
    8000272a:	7942                	ld	s2,48(sp)
    8000272c:	79a2                	ld	s3,40(sp)
    8000272e:	7a02                	ld	s4,32(sp)
    80002730:	6ae2                	ld	s5,24(sp)
    80002732:	6b42                	ld	s6,16(sp)
    80002734:	6ba2                	ld	s7,8(sp)
    80002736:	6161                	addi	sp,sp,80
    80002738:	8082                	ret
          release(&pp->lock);
    8000273a:	8526                	mv	a0,s1
    8000273c:	d80fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    80002740:	0000e517          	auipc	a0,0xe
    80002744:	29050513          	addi	a0,a0,656 # 800109d0 <wait_lock>
    80002748:	d74fe0ef          	jal	80000cbc <release>
          return -1;
    8000274c:	59fd                	li	s3,-1
    8000274e:	bfd1                	j	80002722 <kwait+0x76>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002750:	18048493          	addi	s1,s1,384
    80002754:	03348463          	beq	s1,s3,8000277c <kwait+0xd0>
      if (pp->parent != p || pp->group_leader != pp) continue;
    80002758:	7c9c                	ld	a5,56(s1)
    8000275a:	ff279be3          	bne	a5,s2,80002750 <kwait+0xa4>
    8000275e:	1604b783          	ld	a5,352(s1)
    80002762:	fe9797e3          	bne	a5,s1,80002750 <kwait+0xa4>
      acquire(&pp->lock);
    80002766:	8526                	mv	a0,s1
    80002768:	cc0fe0ef          	jal	80000c28 <acquire>
      if(pp->state == ZOMBIE){
    8000276c:	4c9c                	lw	a5,24(s1)
    8000276e:	f7478fe3          	beq	a5,s4,800026ec <kwait+0x40>
      release(&pp->lock);
    80002772:	8526                	mv	a0,s1
    80002774:	d48fe0ef          	jal	80000cbc <release>
      havekids = 1;
    80002778:	8756                	mv	a4,s5
    8000277a:	bfd9                	j	80002750 <kwait+0xa4>
    if(!havekids || killed(p)){
    8000277c:	cf19                	beqz	a4,8000279a <kwait+0xee>
    8000277e:	854a                	mv	a0,s2
    80002780:	e07ff0ef          	jal	80002586 <killed>
    80002784:	e919                	bnez	a0,8000279a <kwait+0xee>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002786:	85da                	mv	a1,s6
    80002788:	854a                	mv	a0,s2
    8000278a:	a73ff0ef          	jal	800021fc <sleep>
    havekids = 0;
    8000278e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002790:	0000e497          	auipc	s1,0xe
    80002794:	65848493          	addi	s1,s1,1624 # 80010de8 <proc>
    80002798:	b7c1                	j	80002758 <kwait+0xac>
      release(&wait_lock);
    8000279a:	0000e517          	auipc	a0,0xe
    8000279e:	23650513          	addi	a0,a0,566 # 800109d0 <wait_lock>
    800027a2:	d1afe0ef          	jal	80000cbc <release>
      return -1;
    800027a6:	59fd                	li	s3,-1
    800027a8:	bfad                	j	80002722 <kwait+0x76>

00000000800027aa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800027aa:	7179                	addi	sp,sp,-48
    800027ac:	f406                	sd	ra,40(sp)
    800027ae:	f022                	sd	s0,32(sp)
    800027b0:	ec26                	sd	s1,24(sp)
    800027b2:	e84a                	sd	s2,16(sp)
    800027b4:	e44e                	sd	s3,8(sp)
    800027b6:	e052                	sd	s4,0(sp)
    800027b8:	1800                	addi	s0,sp,48
    800027ba:	84aa                	mv	s1,a0
    800027bc:	8a2e                	mv	s4,a1
    800027be:	89b2                	mv	s3,a2
    800027c0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800027c2:	958ff0ef          	jal	8000191a <myproc>
  if(user_dst){
    800027c6:	c085                	beqz	s1,800027e6 <either_copyout+0x3c>
    return copyout(p->mm->pagetable, dst, src, len);
    800027c8:	653c                	ld	a5,72(a0)
    800027ca:	86ca                	mv	a3,s2
    800027cc:	864e                	mv	a2,s3
    800027ce:	85d2                	mv	a1,s4
    800027d0:	6388                	ld	a0,0(a5)
    800027d2:	e87fe0ef          	jal	80001658 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800027d6:	70a2                	ld	ra,40(sp)
    800027d8:	7402                	ld	s0,32(sp)
    800027da:	64e2                	ld	s1,24(sp)
    800027dc:	6942                	ld	s2,16(sp)
    800027de:	69a2                	ld	s3,8(sp)
    800027e0:	6a02                	ld	s4,0(sp)
    800027e2:	6145                	addi	sp,sp,48
    800027e4:	8082                	ret
    memmove((char *)dst, src, len);
    800027e6:	0009061b          	sext.w	a2,s2
    800027ea:	85ce                	mv	a1,s3
    800027ec:	8552                	mv	a0,s4
    800027ee:	d6afe0ef          	jal	80000d58 <memmove>
    return 0;
    800027f2:	8526                	mv	a0,s1
    800027f4:	b7cd                	j	800027d6 <either_copyout+0x2c>

00000000800027f6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800027f6:	7179                	addi	sp,sp,-48
    800027f8:	f406                	sd	ra,40(sp)
    800027fa:	f022                	sd	s0,32(sp)
    800027fc:	ec26                	sd	s1,24(sp)
    800027fe:	e84a                	sd	s2,16(sp)
    80002800:	e44e                	sd	s3,8(sp)
    80002802:	e052                	sd	s4,0(sp)
    80002804:	1800                	addi	s0,sp,48
    80002806:	8a2a                	mv	s4,a0
    80002808:	84ae                	mv	s1,a1
    8000280a:	89b2                	mv	s3,a2
    8000280c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000280e:	90cff0ef          	jal	8000191a <myproc>
  if(user_src){
    80002812:	c085                	beqz	s1,80002832 <either_copyin+0x3c>
    return copyin(p->mm->pagetable, dst, src, len);
    80002814:	653c                	ld	a5,72(a0)
    80002816:	86ca                	mv	a3,s2
    80002818:	864e                	mv	a2,s3
    8000281a:	85d2                	mv	a1,s4
    8000281c:	6388                	ld	a0,0(a5)
    8000281e:	ef9fe0ef          	jal	80001716 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002822:	70a2                	ld	ra,40(sp)
    80002824:	7402                	ld	s0,32(sp)
    80002826:	64e2                	ld	s1,24(sp)
    80002828:	6942                	ld	s2,16(sp)
    8000282a:	69a2                	ld	s3,8(sp)
    8000282c:	6a02                	ld	s4,0(sp)
    8000282e:	6145                	addi	sp,sp,48
    80002830:	8082                	ret
    memmove(dst, (char*)src, len);
    80002832:	0009061b          	sext.w	a2,s2
    80002836:	85ce                	mv	a1,s3
    80002838:	8552                	mv	a0,s4
    8000283a:	d1efe0ef          	jal	80000d58 <memmove>
    return 0;
    8000283e:	8526                	mv	a0,s1
    80002840:	b7cd                	j	80002822 <either_copyin+0x2c>

0000000080002842 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002842:	715d                	addi	sp,sp,-80
    80002844:	e486                	sd	ra,72(sp)
    80002846:	e0a2                	sd	s0,64(sp)
    80002848:	fc26                	sd	s1,56(sp)
    8000284a:	f84a                	sd	s2,48(sp)
    8000284c:	f44e                	sd	s3,40(sp)
    8000284e:	f052                	sd	s4,32(sp)
    80002850:	ec56                	sd	s5,24(sp)
    80002852:	e85a                	sd	s6,16(sp)
    80002854:	e45e                	sd	s7,8(sp)
    80002856:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002858:	00006517          	auipc	a0,0x6
    8000285c:	82050513          	addi	a0,a0,-2016 # 80008078 <etext+0x78>
    80002860:	c9bfd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002864:	0000e497          	auipc	s1,0xe
    80002868:	6d448493          	addi	s1,s1,1748 # 80010f38 <proc+0x150>
    8000286c:	00014917          	auipc	s2,0x14
    80002870:	6cc90913          	addi	s2,s2,1740 # 80016f38 <bcache+0x138>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002874:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002876:	00006997          	auipc	s3,0x6
    8000287a:	9ca98993          	addi	s3,s3,-1590 # 80008240 <etext+0x240>
    printf("%d (tgid=%d tf_va=%lx) %s %s",
    8000287e:	00006a97          	auipc	s5,0x6
    80002882:	9caa8a93          	addi	s5,s5,-1590 # 80008248 <etext+0x248>
           p->pid, p->tgid, p->tf_va, state, p->name);
    printf("\n");
    80002886:	00005a17          	auipc	s4,0x5
    8000288a:	7f2a0a13          	addi	s4,s4,2034 # 80008078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000288e:	00006b97          	auipc	s7,0x6
    80002892:	eeab8b93          	addi	s7,s7,-278 # 80008778 <states.0>
    80002896:	a839                	j	800028b4 <procdump+0x72>
    printf("%d (tgid=%d tf_va=%lx) %s %s",
    80002898:	7394                	ld	a3,32(a5)
    8000289a:	4f90                	lw	a2,24(a5)
    8000289c:	ee07a583          	lw	a1,-288(a5)
    800028a0:	8556                	mv	a0,s5
    800028a2:	c59fd0ef          	jal	800004fa <printf>
    printf("\n");
    800028a6:	8552                	mv	a0,s4
    800028a8:	c53fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800028ac:	18048493          	addi	s1,s1,384
    800028b0:	03248263          	beq	s1,s2,800028d4 <procdump+0x92>
    if(p->state == UNUSED)
    800028b4:	87a6                	mv	a5,s1
    800028b6:	ec84a683          	lw	a3,-312(s1)
    800028ba:	daed                	beqz	a3,800028ac <procdump+0x6a>
      state = "???";
    800028bc:	874e                	mv	a4,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028be:	fcdb6de3          	bltu	s6,a3,80002898 <procdump+0x56>
    800028c2:	02069713          	slli	a4,a3,0x20
    800028c6:	01d75693          	srli	a3,a4,0x1d
    800028ca:	96de                	add	a3,a3,s7
    800028cc:	6298                	ld	a4,0(a3)
    800028ce:	f769                	bnez	a4,80002898 <procdump+0x56>
      state = "???";
    800028d0:	874e                	mv	a4,s3
    800028d2:	b7d9                	j	80002898 <procdump+0x56>
  }
}
    800028d4:	60a6                	ld	ra,72(sp)
    800028d6:	6406                	ld	s0,64(sp)
    800028d8:	74e2                	ld	s1,56(sp)
    800028da:	7942                	ld	s2,48(sp)
    800028dc:	79a2                	ld	s3,40(sp)
    800028de:	7a02                	ld	s4,32(sp)
    800028e0:	6ae2                	ld	s5,24(sp)
    800028e2:	6b42                	ld	s6,16(sp)
    800028e4:	6ba2                	ld	s7,8(sp)
    800028e6:	6161                	addi	sp,sp,80
    800028e8:	8082                	ret

00000000800028ea <drain_siblings>:

void
drain_siblings(struct proc *p)
{
    800028ea:	7139                	addi	sp,sp,-64
    800028ec:	fc06                	sd	ra,56(sp)
    800028ee:	f822                	sd	s0,48(sp)
    800028f0:	f426                	sd	s1,40(sp)
    800028f2:	f04a                	sd	s2,32(sp)
    800028f4:	ec4e                	sd	s3,24(sp)
    800028f6:	e852                	sd	s4,16(sp)
    800028f8:	e456                	sd	s5,8(sp)
    800028fa:	e05a                	sd	s6,0(sp)
    800028fc:	0080                	addi	s0,sp,64
    800028fe:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002900:	0000e517          	auipc	a0,0xe
    80002904:	0d050513          	addi	a0,a0,208 # 800109d0 <wait_lock>
    80002908:	b20fe0ef          	jal	80000c28 <acquire>
  for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    8000290c:	0000e497          	auipc	s1,0xe
    80002910:	4dc48493          	addi	s1,s1,1244 # 80010de8 <proc>
    if (pp->group_leader == p && pp != p) {
      acquire(&pp->lock);
      pp->killed = 1;
    80002914:	4a85                	li	s5,1
      if (pp->state == SLEEPING) pp->state = RUNNABLE;
    80002916:	4a09                	li	s4,2
    80002918:	4b0d                	li	s6,3
  for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    8000291a:	00014997          	auipc	s3,0x14
    8000291e:	4ce98993          	addi	s3,s3,1230 # 80016de8 <tickslock>
    80002922:	a801                	j	80002932 <drain_siblings+0x48>
      release(&pp->lock);
    80002924:	8526                	mv	a0,s1
    80002926:	b96fe0ef          	jal	80000cbc <release>
  for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    8000292a:	18048493          	addi	s1,s1,384
    8000292e:	03348363          	beq	s1,s3,80002954 <drain_siblings+0x6a>
    if (pp->group_leader == p && pp != p) {
    80002932:	1604b783          	ld	a5,352(s1)
    80002936:	ff279ae3          	bne	a5,s2,8000292a <drain_siblings+0x40>
    8000293a:	fe9908e3          	beq	s2,s1,8000292a <drain_siblings+0x40>
      acquire(&pp->lock);
    8000293e:	8526                	mv	a0,s1
    80002940:	ae8fe0ef          	jal	80000c28 <acquire>
      pp->killed = 1;
    80002944:	0354a423          	sw	s5,40(s1)
      if (pp->state == SLEEPING) pp->state = RUNNABLE;
    80002948:	4c9c                	lw	a5,24(s1)
    8000294a:	fd479de3          	bne	a5,s4,80002924 <drain_siblings+0x3a>
    8000294e:	0164ac23          	sw	s6,24(s1)
    80002952:	bfc9                	j	80002924 <drain_siblings+0x3a>
    }
  }
  for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002954:	0000e497          	auipc	s1,0xe
    80002958:	49448493          	addi	s1,s1,1172 # 80010de8 <proc>
      while (pp->state != ZOMBIE && pp->state != UNUSED && pp->group_leader == p) {
        release(&pp->lock);
        sleep(p, &wait_lock);
        acquire(&pp->lock);
      }
      if (pp->state == ZOMBIE) {
    8000295c:	4a95                	li	s5,5
        sleep(p, &wait_lock);
    8000295e:	0000ea17          	auipc	s4,0xe
    80002962:	072a0a13          	addi	s4,s4,114 # 800109d0 <wait_lock>
  for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    80002966:	00014997          	auipc	s3,0x14
    8000296a:	48298993          	addi	s3,s3,1154 # 80016de8 <tickslock>
    8000296e:	a811                	j	80002982 <drain_siblings+0x98>
      if (pp->state == ZOMBIE) {
    80002970:	05578b63          	beq	a5,s5,800029c6 <drain_siblings+0xdc>
        freeproc(pp);
      }
      release(&pp->lock);
    80002974:	8526                	mv	a0,s1
    80002976:	b46fe0ef          	jal	80000cbc <release>
  for (struct proc *pp = proc; pp < &proc[NPROC]; pp++) {
    8000297a:	18048493          	addi	s1,s1,384
    8000297e:	05348863          	beq	s1,s3,800029ce <drain_siblings+0xe4>
    if (pp->group_leader == p && pp != p) {
    80002982:	1604b783          	ld	a5,352(s1)
    80002986:	ff279ae3          	bne	a5,s2,8000297a <drain_siblings+0x90>
    8000298a:	fe9908e3          	beq	s2,s1,8000297a <drain_siblings+0x90>
      acquire(&pp->lock);
    8000298e:	8526                	mv	a0,s1
    80002990:	a98fe0ef          	jal	80000c28 <acquire>
      while (pp->state != ZOMBIE && pp->state != UNUSED && pp->group_leader == p) {
    80002994:	4c9c                	lw	a5,24(s1)
    80002996:	ffb78713          	addi	a4,a5,-5
    8000299a:	db79                	beqz	a4,80002970 <drain_siblings+0x86>
    8000299c:	dbf1                	beqz	a5,80002970 <drain_siblings+0x86>
    8000299e:	1604b783          	ld	a5,352(s1)
    800029a2:	fd2799e3          	bne	a5,s2,80002974 <drain_siblings+0x8a>
        release(&pp->lock);
    800029a6:	8526                	mv	a0,s1
    800029a8:	b14fe0ef          	jal	80000cbc <release>
        sleep(p, &wait_lock);
    800029ac:	85d2                	mv	a1,s4
    800029ae:	854a                	mv	a0,s2
    800029b0:	84dff0ef          	jal	800021fc <sleep>
        acquire(&pp->lock);
    800029b4:	8526                	mv	a0,s1
    800029b6:	a72fe0ef          	jal	80000c28 <acquire>
      while (pp->state != ZOMBIE && pp->state != UNUSED && pp->group_leader == p) {
    800029ba:	4c9c                	lw	a5,24(s1)
    800029bc:	ffb78713          	addi	a4,a5,-5
    800029c0:	db45                	beqz	a4,80002970 <drain_siblings+0x86>
    800029c2:	fff1                	bnez	a5,8000299e <drain_siblings+0xb4>
    800029c4:	b775                	j	80002970 <drain_siblings+0x86>
        freeproc(pp);
    800029c6:	8526                	mv	a0,s1
    800029c8:	a52ff0ef          	jal	80001c1a <freeproc>
    800029cc:	b765                	j	80002974 <drain_siblings+0x8a>
    }
  }
  release(&wait_lock);
    800029ce:	0000e517          	auipc	a0,0xe
    800029d2:	00250513          	addi	a0,a0,2 # 800109d0 <wait_lock>
    800029d6:	ae6fe0ef          	jal	80000cbc <release>
}
    800029da:	70e2                	ld	ra,56(sp)
    800029dc:	7442                	ld	s0,48(sp)
    800029de:	74a2                	ld	s1,40(sp)
    800029e0:	7902                	ld	s2,32(sp)
    800029e2:	69e2                	ld	s3,24(sp)
    800029e4:	6a42                	ld	s4,16(sp)
    800029e6:	6aa2                	ld	s5,8(sp)
    800029e8:	6b02                	ld	s6,0(sp)
    800029ea:	6121                	addi	sp,sp,64
    800029ec:	8082                	ret

00000000800029ee <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    800029ee:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800029f2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800029f6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800029f8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800029fa:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800029fe:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002a02:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002a06:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002a0a:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002a0e:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002a12:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002a16:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002a1a:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002a1e:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002a22:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002a26:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002a2a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002a2c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002a2e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002a32:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002a36:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002a3a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002a3e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002a42:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002a46:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002a4a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002a4e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002a52:	0685bd83          	ld	s11,104(a1)

        ret
    80002a56:	8082                	ret

0000000080002a58 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a58:	1141                	addi	sp,sp,-16
    80002a5a:	e406                	sd	ra,8(sp)
    80002a5c:	e022                	sd	s0,0(sp)
    80002a5e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a60:	00006597          	auipc	a1,0x6
    80002a64:	83858593          	addi	a1,a1,-1992 # 80008298 <etext+0x298>
    80002a68:	00014517          	auipc	a0,0x14
    80002a6c:	38050513          	addi	a0,a0,896 # 80016de8 <tickslock>
    80002a70:	92efe0ef          	jal	80000b9e <initlock>
}
    80002a74:	60a2                	ld	ra,8(sp)
    80002a76:	6402                	ld	s0,0(sp)
    80002a78:	0141                	addi	sp,sp,16
    80002a7a:	8082                	ret

0000000080002a7c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a7c:	1141                	addi	sp,sp,-16
    80002a7e:	e406                	sd	ra,8(sp)
    80002a80:	e022                	sd	s0,0(sp)
    80002a82:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a84:	00003797          	auipc	a5,0x3
    80002a88:	09c78793          	addi	a5,a5,156 # 80005b20 <kernelvec>
    80002a8c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a90:	60a2                	ld	ra,8(sp)
    80002a92:	6402                	ld	s0,0(sp)
    80002a94:	0141                	addi	sp,sp,16
    80002a96:	8082                	ret

0000000080002a98 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002a98:	1141                	addi	sp,sp,-16
    80002a9a:	e406                	sd	ra,8(sp)
    80002a9c:	e022                	sd	s0,0(sp)
    80002a9e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002aa0:	e7bfe0ef          	jal	8000191a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002aa8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aaa:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002aae:	04000737          	lui	a4,0x4000
    80002ab2:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002ab4:	0732                	slli	a4,a4,0xc
    80002ab6:	00004797          	auipc	a5,0x4
    80002aba:	54a78793          	addi	a5,a5,1354 # 80007000 <_trampoline>
    80002abe:	00004697          	auipc	a3,0x4
    80002ac2:	54268693          	addi	a3,a3,1346 # 80007000 <_trampoline>
    80002ac6:	8f95                	sub	a5,a5,a3
    80002ac8:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002aca:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ace:	693c                	ld	a5,80(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ad0:	18002773          	csrr	a4,satp
    80002ad4:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002ad6:	6938                	ld	a4,80(a0)
    80002ad8:	613c                	ld	a5,64(a0)
    80002ada:	6685                	lui	a3,0x1
    80002adc:	97b6                	add	a5,a5,a3
    80002ade:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002ae0:	693c                	ld	a5,80(a0)
    80002ae2:	00000717          	auipc	a4,0x0
    80002ae6:	10470713          	addi	a4,a4,260 # 80002be6 <usertrap>
    80002aea:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002aec:	693c                	ld	a5,80(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002aee:	8712                	mv	a4,tp
    80002af0:	f398                	sd	a4,32(a5)
  asm volatile("csrw sscratch, %0" : : "r" (x));
    80002af2:	17053783          	ld	a5,368(a0)
    80002af6:	14079073          	csrw	sscratch,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002afa:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002afe:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b02:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b06:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b0a:	693c                	ld	a5,80(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b0c:	6f9c                	ld	a5,24(a5)
    80002b0e:	14179073          	csrw	sepc,a5
}
    80002b12:	60a2                	ld	ra,8(sp)
    80002b14:	6402                	ld	s0,0(sp)
    80002b16:	0141                	addi	sp,sp,16
    80002b18:	8082                	ret

0000000080002b1a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b1a:	1141                	addi	sp,sp,-16
    80002b1c:	e406                	sd	ra,8(sp)
    80002b1e:	e022                	sd	s0,0(sp)
    80002b20:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80002b22:	dc5fe0ef          	jal	800018e6 <cpuid>
    80002b26:	cd11                	beqz	a0,80002b42 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002b28:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002b2c:	000f4737          	lui	a4,0xf4
    80002b30:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002b34:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002b36:	14d79073          	csrw	stimecmp,a5
}
    80002b3a:	60a2                	ld	ra,8(sp)
    80002b3c:	6402                	ld	s0,0(sp)
    80002b3e:	0141                	addi	sp,sp,16
    80002b40:	8082                	ret
    acquire(&tickslock);
    80002b42:	00014517          	auipc	a0,0x14
    80002b46:	2a650513          	addi	a0,a0,678 # 80016de8 <tickslock>
    80002b4a:	8defe0ef          	jal	80000c28 <acquire>
    ticks++;
    80002b4e:	00006717          	auipc	a4,0x6
    80002b52:	d6a70713          	addi	a4,a4,-662 # 800088b8 <ticks>
    80002b56:	431c                	lw	a5,0(a4)
    80002b58:	2785                	addiw	a5,a5,1
    80002b5a:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002b5c:	853a                	mv	a0,a4
    80002b5e:	eeaff0ef          	jal	80002248 <wakeup>
    release(&tickslock);
    80002b62:	00014517          	auipc	a0,0x14
    80002b66:	28650513          	addi	a0,a0,646 # 80016de8 <tickslock>
    80002b6a:	952fe0ef          	jal	80000cbc <release>
    80002b6e:	bf6d                	j	80002b28 <clockintr+0xe>

0000000080002b70 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b70:	1101                	addi	sp,sp,-32
    80002b72:	ec06                	sd	ra,24(sp)
    80002b74:	e822                	sd	s0,16(sp)
    80002b76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b78:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002b7c:	57fd                	li	a5,-1
    80002b7e:	17fe                	slli	a5,a5,0x3f
    80002b80:	07a5                	addi	a5,a5,9
    80002b82:	00f70c63          	beq	a4,a5,80002b9a <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002b86:	57fd                	li	a5,-1
    80002b88:	17fe                	slli	a5,a5,0x3f
    80002b8a:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002b8c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002b8e:	04f70863          	beq	a4,a5,80002bde <devintr+0x6e>
  }
}
    80002b92:	60e2                	ld	ra,24(sp)
    80002b94:	6442                	ld	s0,16(sp)
    80002b96:	6105                	addi	sp,sp,32
    80002b98:	8082                	ret
    80002b9a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002b9c:	030030ef          	jal	80005bcc <plic_claim>
    80002ba0:	872a                	mv	a4,a0
    80002ba2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002ba4:	47a9                	li	a5,10
    80002ba6:	00f50963          	beq	a0,a5,80002bb8 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80002baa:	4785                	li	a5,1
    80002bac:	00f50963          	beq	a0,a5,80002bbe <devintr+0x4e>
    return 1;
    80002bb0:	4505                	li	a0,1
    } else if(irq){
    80002bb2:	eb09                	bnez	a4,80002bc4 <devintr+0x54>
    80002bb4:	64a2                	ld	s1,8(sp)
    80002bb6:	bff1                	j	80002b92 <devintr+0x22>
      uartintr();
    80002bb8:	e3dfd0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002bbc:	a819                	j	80002bd2 <devintr+0x62>
      virtio_disk_intr();
    80002bbe:	4a4030ef          	jal	80006062 <virtio_disk_intr>
    if(irq)
    80002bc2:	a801                	j	80002bd2 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002bc4:	85ba                	mv	a1,a4
    80002bc6:	00005517          	auipc	a0,0x5
    80002bca:	6da50513          	addi	a0,a0,1754 # 800082a0 <etext+0x2a0>
    80002bce:	92dfd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	018030ef          	jal	80005bec <plic_complete>
    return 1;
    80002bd8:	4505                	li	a0,1
    80002bda:	64a2                	ld	s1,8(sp)
    80002bdc:	bf5d                	j	80002b92 <devintr+0x22>
    clockintr();
    80002bde:	f3dff0ef          	jal	80002b1a <clockintr>
    return 2;
    80002be2:	4509                	li	a0,2
    80002be4:	b77d                	j	80002b92 <devintr+0x22>

0000000080002be6 <usertrap>:
{
    80002be6:	1101                	addi	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	e04a                	sd	s2,0(sp)
    80002bf0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bf2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002bf6:	1007f793          	andi	a5,a5,256
    80002bfa:	eba5                	bnez	a5,80002c6a <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bfc:	00003797          	auipc	a5,0x3
    80002c00:	f2478793          	addi	a5,a5,-220 # 80005b20 <kernelvec>
    80002c04:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c08:	d13fe0ef          	jal	8000191a <myproc>
    80002c0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c0e:	693c                	ld	a5,80(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c10:	14102773          	csrr	a4,sepc
    80002c14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c1a:	47a1                	li	a5,8
    80002c1c:	04f70d63          	beq	a4,a5,80002c76 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80002c20:	f51ff0ef          	jal	80002b70 <devintr>
    80002c24:	892a                	mv	s2,a0
    80002c26:	e955                	bnez	a0,80002cda <usertrap+0xf4>
    80002c28:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002c2c:	47bd                	li	a5,15
    80002c2e:	08f70963          	beq	a4,a5,80002cc0 <usertrap+0xda>
    80002c32:	14202773          	csrr	a4,scause
    80002c36:	47b5                	li	a5,13
    80002c38:	08f70463          	beq	a4,a5,80002cc0 <usertrap+0xda>
    80002c3c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002c40:	5890                	lw	a2,48(s1)
    80002c42:	00005517          	auipc	a0,0x5
    80002c46:	69e50513          	addi	a0,a0,1694 # 800082e0 <etext+0x2e0>
    80002c4a:	8b1fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c4e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c52:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002c56:	00005517          	auipc	a0,0x5
    80002c5a:	6ba50513          	addi	a0,a0,1722 # 80008310 <etext+0x310>
    80002c5e:	89dfd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002c62:	8526                	mv	a0,s1
    80002c64:	8ffff0ef          	jal	80002562 <setkilled>
    80002c68:	a035                	j	80002c94 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002c6a:	00005517          	auipc	a0,0x5
    80002c6e:	65650513          	addi	a0,a0,1622 # 800082c0 <etext+0x2c0>
    80002c72:	bb3fd0ef          	jal	80000824 <panic>
    if(killed(p))
    80002c76:	911ff0ef          	jal	80002586 <killed>
    80002c7a:	ed1d                	bnez	a0,80002cb8 <usertrap+0xd2>
    p->trapframe->epc += 4;
    80002c7c:	68b8                	ld	a4,80(s1)
    80002c7e:	6f1c                	ld	a5,24(a4)
    80002c80:	0791                	addi	a5,a5,4
    80002c82:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c8c:	10079073          	csrw	sstatus,a5
    syscall();
    80002c90:	248000ef          	jal	80002ed8 <syscall>
  if(killed(p))
    80002c94:	8526                	mv	a0,s1
    80002c96:	8f1ff0ef          	jal	80002586 <killed>
    80002c9a:	e529                	bnez	a0,80002ce4 <usertrap+0xfe>
  prepare_return();
    80002c9c:	dfdff0ef          	jal	80002a98 <prepare_return>
  uint64 satp = MAKE_SATP(p->mm->pagetable);
    80002ca0:	64bc                	ld	a5,72(s1)
    80002ca2:	6388                	ld	a0,0(a5)
    80002ca4:	8131                	srli	a0,a0,0xc
    80002ca6:	57fd                	li	a5,-1
    80002ca8:	17fe                	slli	a5,a5,0x3f
    80002caa:	8d5d                	or	a0,a0,a5
}
    80002cac:	60e2                	ld	ra,24(sp)
    80002cae:	6442                	ld	s0,16(sp)
    80002cb0:	64a2                	ld	s1,8(sp)
    80002cb2:	6902                	ld	s2,0(sp)
    80002cb4:	6105                	addi	sp,sp,32
    80002cb6:	8082                	ret
      kexit(-1);
    80002cb8:	557d                	li	a0,-1
    80002cba:	e4eff0ef          	jal	80002308 <kexit>
    80002cbe:	bf7d                	j	80002c7c <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cc0:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cc4:	14202673          	csrr	a2,scause
            vmfault(p->mm->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002cc8:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002cca:	64bc                	ld	a5,72(s1)
    80002ccc:	00163613          	seqz	a2,a2
    80002cd0:	6388                	ld	a0,0(a5)
    80002cd2:	8fffe0ef          	jal	800015d0 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002cd6:	fd5d                	bnez	a0,80002c94 <usertrap+0xae>
    80002cd8:	b795                	j	80002c3c <usertrap+0x56>
  if(killed(p))
    80002cda:	8526                	mv	a0,s1
    80002cdc:	8abff0ef          	jal	80002586 <killed>
    80002ce0:	c511                	beqz	a0,80002cec <usertrap+0x106>
    80002ce2:	a011                	j	80002ce6 <usertrap+0x100>
    80002ce4:	4901                	li	s2,0
    kexit(-1);
    80002ce6:	557d                	li	a0,-1
    80002ce8:	e20ff0ef          	jal	80002308 <kexit>
  if(which_dev == 2)
    80002cec:	4789                	li	a5,2
    80002cee:	faf917e3          	bne	s2,a5,80002c9c <usertrap+0xb6>
    yield();
    80002cf2:	cdeff0ef          	jal	800021d0 <yield>
    80002cf6:	b75d                	j	80002c9c <usertrap+0xb6>

0000000080002cf8 <kerneltrap>:
{
    80002cf8:	7179                	addi	sp,sp,-48
    80002cfa:	f406                	sd	ra,40(sp)
    80002cfc:	f022                	sd	s0,32(sp)
    80002cfe:	ec26                	sd	s1,24(sp)
    80002d00:	e84a                	sd	s2,16(sp)
    80002d02:	e44e                	sd	s3,8(sp)
    80002d04:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d06:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d0a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d0e:	142027f3          	csrr	a5,scause
    80002d12:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80002d14:	1004f793          	andi	a5,s1,256
    80002d18:	c795                	beqz	a5,80002d44 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d1a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d1e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d20:	eb85                	bnez	a5,80002d50 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80002d22:	e4fff0ef          	jal	80002b70 <devintr>
    80002d26:	c91d                	beqz	a0,80002d5c <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80002d28:	4789                	li	a5,2
    80002d2a:	04f50a63          	beq	a0,a5,80002d7e <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d2e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d32:	10049073          	csrw	sstatus,s1
}
    80002d36:	70a2                	ld	ra,40(sp)
    80002d38:	7402                	ld	s0,32(sp)
    80002d3a:	64e2                	ld	s1,24(sp)
    80002d3c:	6942                	ld	s2,16(sp)
    80002d3e:	69a2                	ld	s3,8(sp)
    80002d40:	6145                	addi	sp,sp,48
    80002d42:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d44:	00005517          	auipc	a0,0x5
    80002d48:	5f450513          	addi	a0,a0,1524 # 80008338 <etext+0x338>
    80002d4c:	ad9fd0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002d50:	00005517          	auipc	a0,0x5
    80002d54:	61050513          	addi	a0,a0,1552 # 80008360 <etext+0x360>
    80002d58:	acdfd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d5c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d60:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002d64:	85ce                	mv	a1,s3
    80002d66:	00005517          	auipc	a0,0x5
    80002d6a:	61a50513          	addi	a0,a0,1562 # 80008380 <etext+0x380>
    80002d6e:	f8cfd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002d72:	00005517          	auipc	a0,0x5
    80002d76:	63650513          	addi	a0,a0,1590 # 800083a8 <etext+0x3a8>
    80002d7a:	aabfd0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002d7e:	b9dfe0ef          	jal	8000191a <myproc>
    80002d82:	d555                	beqz	a0,80002d2e <kerneltrap+0x36>
    yield();
    80002d84:	c4cff0ef          	jal	800021d0 <yield>
    80002d88:	b75d                	j	80002d2e <kerneltrap+0x36>

0000000080002d8a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d8a:	1101                	addi	sp,sp,-32
    80002d8c:	ec06                	sd	ra,24(sp)
    80002d8e:	e822                	sd	s0,16(sp)
    80002d90:	e426                	sd	s1,8(sp)
    80002d92:	1000                	addi	s0,sp,32
    80002d94:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d96:	b85fe0ef          	jal	8000191a <myproc>
  switch (n) {
    80002d9a:	4795                	li	a5,5
    80002d9c:	0497e163          	bltu	a5,s1,80002dde <argraw+0x54>
    80002da0:	048a                	slli	s1,s1,0x2
    80002da2:	00006717          	auipc	a4,0x6
    80002da6:	a0670713          	addi	a4,a4,-1530 # 800087a8 <states.0+0x30>
    80002daa:	94ba                	add	s1,s1,a4
    80002dac:	409c                	lw	a5,0(s1)
    80002dae:	97ba                	add	a5,a5,a4
    80002db0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002db2:	693c                	ld	a5,80(a0)
    80002db4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002db6:	60e2                	ld	ra,24(sp)
    80002db8:	6442                	ld	s0,16(sp)
    80002dba:	64a2                	ld	s1,8(sp)
    80002dbc:	6105                	addi	sp,sp,32
    80002dbe:	8082                	ret
    return p->trapframe->a1;
    80002dc0:	693c                	ld	a5,80(a0)
    80002dc2:	7fa8                	ld	a0,120(a5)
    80002dc4:	bfcd                	j	80002db6 <argraw+0x2c>
    return p->trapframe->a2;
    80002dc6:	693c                	ld	a5,80(a0)
    80002dc8:	63c8                	ld	a0,128(a5)
    80002dca:	b7f5                	j	80002db6 <argraw+0x2c>
    return p->trapframe->a3;
    80002dcc:	693c                	ld	a5,80(a0)
    80002dce:	67c8                	ld	a0,136(a5)
    80002dd0:	b7dd                	j	80002db6 <argraw+0x2c>
    return p->trapframe->a4;
    80002dd2:	693c                	ld	a5,80(a0)
    80002dd4:	6bc8                	ld	a0,144(a5)
    80002dd6:	b7c5                	j	80002db6 <argraw+0x2c>
    return p->trapframe->a5;
    80002dd8:	693c                	ld	a5,80(a0)
    80002dda:	6fc8                	ld	a0,152(a5)
    80002ddc:	bfe9                	j	80002db6 <argraw+0x2c>
  panic("argraw");
    80002dde:	00005517          	auipc	a0,0x5
    80002de2:	5da50513          	addi	a0,a0,1498 # 800083b8 <etext+0x3b8>
    80002de6:	a3ffd0ef          	jal	80000824 <panic>

0000000080002dea <fetchaddr>:
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	e04a                	sd	s2,0(sp)
    80002df4:	1000                	addi	s0,sp,32
    80002df6:	84aa                	mv	s1,a0
    80002df8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002dfa:	b21fe0ef          	jal	8000191a <myproc>
  if(addr >= p->mm->sz || addr+sizeof(uint64) > p->mm->sz) // both tests needed, in case of overflow
    80002dfe:	6538                	ld	a4,72(a0)
    80002e00:	671c                	ld	a5,8(a4)
    80002e02:	02f4f663          	bgeu	s1,a5,80002e2e <fetchaddr+0x44>
    80002e06:	00848693          	addi	a3,s1,8
    80002e0a:	02d7e463          	bltu	a5,a3,80002e32 <fetchaddr+0x48>
  if(copyin(p->mm->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e0e:	46a1                	li	a3,8
    80002e10:	8626                	mv	a2,s1
    80002e12:	85ca                	mv	a1,s2
    80002e14:	6308                	ld	a0,0(a4)
    80002e16:	901fe0ef          	jal	80001716 <copyin>
    80002e1a:	00a03533          	snez	a0,a0
    80002e1e:	40a0053b          	negw	a0,a0
}
    80002e22:	60e2                	ld	ra,24(sp)
    80002e24:	6442                	ld	s0,16(sp)
    80002e26:	64a2                	ld	s1,8(sp)
    80002e28:	6902                	ld	s2,0(sp)
    80002e2a:	6105                	addi	sp,sp,32
    80002e2c:	8082                	ret
    return -1;
    80002e2e:	557d                	li	a0,-1
    80002e30:	bfcd                	j	80002e22 <fetchaddr+0x38>
    80002e32:	557d                	li	a0,-1
    80002e34:	b7fd                	j	80002e22 <fetchaddr+0x38>

0000000080002e36 <fetchstr>:
{
    80002e36:	7179                	addi	sp,sp,-48
    80002e38:	f406                	sd	ra,40(sp)
    80002e3a:	f022                	sd	s0,32(sp)
    80002e3c:	ec26                	sd	s1,24(sp)
    80002e3e:	e84a                	sd	s2,16(sp)
    80002e40:	e44e                	sd	s3,8(sp)
    80002e42:	1800                	addi	s0,sp,48
    80002e44:	89aa                	mv	s3,a0
    80002e46:	84ae                	mv	s1,a1
    80002e48:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002e4a:	ad1fe0ef          	jal	8000191a <myproc>
  if(copyinstr(p->mm->pagetable, buf, addr, max) < 0)
    80002e4e:	653c                	ld	a5,72(a0)
    80002e50:	86ca                	mv	a3,s2
    80002e52:	864e                	mv	a2,s3
    80002e54:	85a6                	mv	a1,s1
    80002e56:	6388                	ld	a0,0(a5)
    80002e58:	ea0fe0ef          	jal	800014f8 <copyinstr>
    80002e5c:	00054c63          	bltz	a0,80002e74 <fetchstr+0x3e>
  return strlen(buf);
    80002e60:	8526                	mv	a0,s1
    80002e62:	820fe0ef          	jal	80000e82 <strlen>
}
    80002e66:	70a2                	ld	ra,40(sp)
    80002e68:	7402                	ld	s0,32(sp)
    80002e6a:	64e2                	ld	s1,24(sp)
    80002e6c:	6942                	ld	s2,16(sp)
    80002e6e:	69a2                	ld	s3,8(sp)
    80002e70:	6145                	addi	sp,sp,48
    80002e72:	8082                	ret
    return -1;
    80002e74:	557d                	li	a0,-1
    80002e76:	bfc5                	j	80002e66 <fetchstr+0x30>

0000000080002e78 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002e78:	1101                	addi	sp,sp,-32
    80002e7a:	ec06                	sd	ra,24(sp)
    80002e7c:	e822                	sd	s0,16(sp)
    80002e7e:	e426                	sd	s1,8(sp)
    80002e80:	1000                	addi	s0,sp,32
    80002e82:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e84:	f07ff0ef          	jal	80002d8a <argraw>
    80002e88:	c088                	sw	a0,0(s1)
}
    80002e8a:	60e2                	ld	ra,24(sp)
    80002e8c:	6442                	ld	s0,16(sp)
    80002e8e:	64a2                	ld	s1,8(sp)
    80002e90:	6105                	addi	sp,sp,32
    80002e92:	8082                	ret

0000000080002e94 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	1000                	addi	s0,sp,32
    80002e9e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ea0:	eebff0ef          	jal	80002d8a <argraw>
    80002ea4:	e088                	sd	a0,0(s1)
}
    80002ea6:	60e2                	ld	ra,24(sp)
    80002ea8:	6442                	ld	s0,16(sp)
    80002eaa:	64a2                	ld	s1,8(sp)
    80002eac:	6105                	addi	sp,sp,32
    80002eae:	8082                	ret

0000000080002eb0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002eb0:	1101                	addi	sp,sp,-32
    80002eb2:	ec06                	sd	ra,24(sp)
    80002eb4:	e822                	sd	s0,16(sp)
    80002eb6:	e426                	sd	s1,8(sp)
    80002eb8:	e04a                	sd	s2,0(sp)
    80002eba:	1000                	addi	s0,sp,32
    80002ebc:	892e                	mv	s2,a1
    80002ebe:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002ec0:	ecbff0ef          	jal	80002d8a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002ec4:	8626                	mv	a2,s1
    80002ec6:	85ca                	mv	a1,s2
    80002ec8:	f6fff0ef          	jal	80002e36 <fetchstr>
}
    80002ecc:	60e2                	ld	ra,24(sp)
    80002ece:	6442                	ld	s0,16(sp)
    80002ed0:	64a2                	ld	s1,8(sp)
    80002ed2:	6902                	ld	s2,0(sp)
    80002ed4:	6105                	addi	sp,sp,32
    80002ed6:	8082                	ret

0000000080002ed8 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002ed8:	1101                	addi	sp,sp,-32
    80002eda:	ec06                	sd	ra,24(sp)
    80002edc:	e822                	sd	s0,16(sp)
    80002ede:	e426                	sd	s1,8(sp)
    80002ee0:	e04a                	sd	s2,0(sp)
    80002ee2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ee4:	a37fe0ef          	jal	8000191a <myproc>
    80002ee8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002eea:	05053903          	ld	s2,80(a0)
    80002eee:	0a893783          	ld	a5,168(s2)
    80002ef2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ef6:	37fd                	addiw	a5,a5,-1
    80002ef8:	4755                	li	a4,21
    80002efa:	00f76f63          	bltu	a4,a5,80002f18 <syscall+0x40>
    80002efe:	00369713          	slli	a4,a3,0x3
    80002f02:	00006797          	auipc	a5,0x6
    80002f06:	8be78793          	addi	a5,a5,-1858 # 800087c0 <syscalls>
    80002f0a:	97ba                	add	a5,a5,a4
    80002f0c:	639c                	ld	a5,0(a5)
    80002f0e:	c789                	beqz	a5,80002f18 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002f10:	9782                	jalr	a5
    80002f12:	06a93823          	sd	a0,112(s2)
    80002f16:	a829                	j	80002f30 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f18:	15048613          	addi	a2,s1,336
    80002f1c:	588c                	lw	a1,48(s1)
    80002f1e:	00005517          	auipc	a0,0x5
    80002f22:	4a250513          	addi	a0,a0,1186 # 800083c0 <etext+0x3c0>
    80002f26:	dd4fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f2a:	68bc                	ld	a5,80(s1)
    80002f2c:	577d                	li	a4,-1
    80002f2e:	fbb8                	sd	a4,112(a5)
  }
}
    80002f30:	60e2                	ld	ra,24(sp)
    80002f32:	6442                	ld	s0,16(sp)
    80002f34:	64a2                	ld	s1,8(sp)
    80002f36:	6902                	ld	s2,0(sp)
    80002f38:	6105                	addi	sp,sp,32
    80002f3a:	8082                	ret

0000000080002f3c <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002f3c:	1101                	addi	sp,sp,-32
    80002f3e:	ec06                	sd	ra,24(sp)
    80002f40:	e822                	sd	s0,16(sp)
    80002f42:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002f44:	fec40593          	addi	a1,s0,-20
    80002f48:	4501                	li	a0,0
    80002f4a:	f2fff0ef          	jal	80002e78 <argint>
  kexit(n);
    80002f4e:	fec42503          	lw	a0,-20(s0)
    80002f52:	bb6ff0ef          	jal	80002308 <kexit>
  return 0;  // not reached
}
    80002f56:	4501                	li	a0,0
    80002f58:	60e2                	ld	ra,24(sp)
    80002f5a:	6442                	ld	s0,16(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret

0000000080002f60 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f60:	1141                	addi	sp,sp,-16
    80002f62:	e406                	sd	ra,8(sp)
    80002f64:	e022                	sd	s0,0(sp)
    80002f66:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002f68:	9b3fe0ef          	jal	8000191a <myproc>
}
    80002f6c:	5908                	lw	a0,48(a0)
    80002f6e:	60a2                	ld	ra,8(sp)
    80002f70:	6402                	ld	s0,0(sp)
    80002f72:	0141                	addi	sp,sp,16
    80002f74:	8082                	ret

0000000080002f76 <sys_clone>:

uint64
sys_clone(void)
{
    80002f76:	7179                	addi	sp,sp,-48
    80002f78:	f406                	sd	ra,40(sp)
    80002f7a:	f022                	sd	s0,32(sp)
    80002f7c:	1800                	addi	s0,sp,48
  uint64 fn, arg, stack;
  int n_pages, flags;

  argaddr(0, &fn);
    80002f7e:	fe840593          	addi	a1,s0,-24
    80002f82:	4501                	li	a0,0
    80002f84:	f11ff0ef          	jal	80002e94 <argaddr>
  argaddr(1, &arg);
    80002f88:	fe040593          	addi	a1,s0,-32
    80002f8c:	4505                	li	a0,1
    80002f8e:	f07ff0ef          	jal	80002e94 <argaddr>
  argaddr(2, &stack);
    80002f92:	fd840593          	addi	a1,s0,-40
    80002f96:	4509                	li	a0,2
    80002f98:	efdff0ef          	jal	80002e94 <argaddr>
  argint (3, &n_pages);
    80002f9c:	fd440593          	addi	a1,s0,-44
    80002fa0:	450d                	li	a0,3
    80002fa2:	ed7ff0ef          	jal	80002e78 <argint>
  argint (4, &flags);
    80002fa6:	fd040593          	addi	a1,s0,-48
    80002faa:	4511                	li	a0,4
    80002fac:	ecdff0ef          	jal	80002e78 <argint>

  return kclone(fn, arg, stack, n_pages, flags);
    80002fb0:	fd042703          	lw	a4,-48(s0)
    80002fb4:	fd442683          	lw	a3,-44(s0)
    80002fb8:	fd843603          	ld	a2,-40(s0)
    80002fbc:	fe043583          	ld	a1,-32(s0)
    80002fc0:	fe843503          	ld	a0,-24(s0)
    80002fc4:	e71fe0ef          	jal	80001e34 <kclone>
}
    80002fc8:	70a2                	ld	ra,40(sp)
    80002fca:	7402                	ld	s0,32(sp)
    80002fcc:	6145                	addi	sp,sp,48
    80002fce:	8082                	ret

0000000080002fd0 <sys_join>:

uint64
sys_join(void)
{
    80002fd0:	1101                	addi	sp,sp,-32
    80002fd2:	ec06                	sd	ra,24(sp)
    80002fd4:	e822                	sd	s0,16(sp)
    80002fd6:	1000                	addi	s0,sp,32
  uint64 stack_addr;
  argaddr(0, &stack_addr);
    80002fd8:	fe840593          	addi	a1,s0,-24
    80002fdc:	4501                	li	a0,0
    80002fde:	eb7ff0ef          	jal	80002e94 <argaddr>
  return kjoin(stack_addr);
    80002fe2:	fe843503          	ld	a0,-24(s0)
    80002fe6:	dcaff0ef          	jal	800025b0 <kjoin>
}
    80002fea:	60e2                	ld	ra,24(sp)
    80002fec:	6442                	ld	s0,16(sp)
    80002fee:	6105                	addi	sp,sp,32
    80002ff0:	8082                	ret

0000000080002ff2 <sys_wait>:

uint64
sys_wait(void)
{
    80002ff2:	1101                	addi	sp,sp,-32
    80002ff4:	ec06                	sd	ra,24(sp)
    80002ff6:	e822                	sd	s0,16(sp)
    80002ff8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002ffa:	fe840593          	addi	a1,s0,-24
    80002ffe:	4501                	li	a0,0
    80003000:	e95ff0ef          	jal	80002e94 <argaddr>
  return kwait(p);
    80003004:	fe843503          	ld	a0,-24(s0)
    80003008:	ea4ff0ef          	jal	800026ac <kwait>
}
    8000300c:	60e2                	ld	ra,24(sp)
    8000300e:	6442                	ld	s0,16(sp)
    80003010:	6105                	addi	sp,sp,32
    80003012:	8082                	ret

0000000080003014 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003014:	7139                	addi	sp,sp,-64
    80003016:	fc06                	sd	ra,56(sp)
    80003018:	f822                	sd	s0,48(sp)
    8000301a:	f426                	sd	s1,40(sp)
    8000301c:	f04a                	sd	s2,32(sp)
    8000301e:	ec4e                	sd	s3,24(sp)
    80003020:	0080                	addi	s0,sp,64
  uint64 addr;
  int t;
  int n;
  struct proc *p = myproc();
    80003022:	8f9fe0ef          	jal	8000191a <myproc>
  struct mm_struct *mm = p->mm;
    80003026:	6524                	ld	s1,72(a0)

  argint(0, &n);
    80003028:	fc840593          	addi	a1,s0,-56
    8000302c:	4501                	li	a0,0
    8000302e:	e4bff0ef          	jal	80002e78 <argint>
  argint(1, &t);
    80003032:	fcc40593          	addi	a1,s0,-52
    80003036:	4505                	li	a0,1
    80003038:	e41ff0ef          	jal	80002e78 <argint>

  if(t == SBRK_EAGER || n < 0) {
    8000303c:	fcc42703          	lw	a4,-52(s0)
    80003040:	4785                	li	a5,1
    80003042:	00f70663          	beq	a4,a5,8000304e <sys_sbrk+0x3a>
    80003046:	fc842783          	lw	a5,-56(s0)
    8000304a:	0207da63          	bgez	a5,8000307e <sys_sbrk+0x6a>
    acquire(&mm->lock);
    8000304e:	01848993          	addi	s3,s1,24
    80003052:	854e                	mv	a0,s3
    80003054:	bd5fd0ef          	jal	80000c28 <acquire>
    addr = mm->sz;
    80003058:	0084b903          	ld	s2,8(s1)
    release(&mm->lock);
    8000305c:	854e                	mv	a0,s3
    8000305e:	c5ffd0ef          	jal	80000cbc <release>
    if(growproc(n) < 0) {
    80003062:	fc842503          	lw	a0,-56(s0)
    80003066:	d45fe0ef          	jal	80001daa <growproc>
    8000306a:	04054c63          	bltz	a0,800030c2 <sys_sbrk+0xae>
    }
    mm->sz += n;
    release(&mm->lock);
  }
  return addr;
}
    8000306e:	854a                	mv	a0,s2
    80003070:	70e2                	ld	ra,56(sp)
    80003072:	7442                	ld	s0,48(sp)
    80003074:	74a2                	ld	s1,40(sp)
    80003076:	7902                	ld	s2,32(sp)
    80003078:	69e2                	ld	s3,24(sp)
    8000307a:	6121                	addi	sp,sp,64
    8000307c:	8082                	ret
    acquire(&mm->lock);
    8000307e:	01848793          	addi	a5,s1,24
    80003082:	89be                	mv	s3,a5
    80003084:	853e                	mv	a0,a5
    80003086:	ba3fd0ef          	jal	80000c28 <acquire>
    addr = mm->sz;
    8000308a:	0084b903          	ld	s2,8(s1)
    if(addr + n < addr) {
    8000308e:	fc842783          	lw	a5,-56(s0)
    80003092:	97ca                	add	a5,a5,s2
    80003094:	0127ed63          	bltu	a5,s2,800030ae <sys_sbrk+0x9a>
    if(addr + n > USERTOP) {
    80003098:	02000737          	lui	a4,0x2000
    8000309c:	176d                	addi	a4,a4,-5 # 1fffffb <_entry-0x7e000005>
    8000309e:	0736                	slli	a4,a4,0xd
    800030a0:	00f76c63          	bltu	a4,a5,800030b8 <sys_sbrk+0xa4>
    mm->sz += n;
    800030a4:	e49c                	sd	a5,8(s1)
    release(&mm->lock);
    800030a6:	854e                	mv	a0,s3
    800030a8:	c15fd0ef          	jal	80000cbc <release>
    800030ac:	b7c9                	j	8000306e <sys_sbrk+0x5a>
      release(&mm->lock);
    800030ae:	854e                	mv	a0,s3
    800030b0:	c0dfd0ef          	jal	80000cbc <release>
      return -1;
    800030b4:	597d                	li	s2,-1
    800030b6:	bf65                	j	8000306e <sys_sbrk+0x5a>
      release(&mm->lock);
    800030b8:	854e                	mv	a0,s3
    800030ba:	c03fd0ef          	jal	80000cbc <release>
      return -1;
    800030be:	597d                	li	s2,-1
    800030c0:	b77d                	j	8000306e <sys_sbrk+0x5a>
      return -1;
    800030c2:	597d                	li	s2,-1
    800030c4:	b76d                	j	8000306e <sys_sbrk+0x5a>

00000000800030c6 <sys_pause>:

uint64
sys_pause(void)
{
    800030c6:	7139                	addi	sp,sp,-64
    800030c8:	fc06                	sd	ra,56(sp)
    800030ca:	f822                	sd	s0,48(sp)
    800030cc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800030ce:	fcc40593          	addi	a1,s0,-52
    800030d2:	4501                	li	a0,0
    800030d4:	da5ff0ef          	jal	80002e78 <argint>
  if(n < 0)
    800030d8:	fcc42783          	lw	a5,-52(s0)
    800030dc:	0607c863          	bltz	a5,8000314c <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800030e0:	00014517          	auipc	a0,0x14
    800030e4:	d0850513          	addi	a0,a0,-760 # 80016de8 <tickslock>
    800030e8:	b41fd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    800030ec:	fcc42783          	lw	a5,-52(s0)
    800030f0:	c3b9                	beqz	a5,80003136 <sys_pause+0x70>
    800030f2:	f426                	sd	s1,40(sp)
    800030f4:	f04a                	sd	s2,32(sp)
    800030f6:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    800030f8:	00005997          	auipc	s3,0x5
    800030fc:	7c09a983          	lw	s3,1984(s3) # 800088b8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003100:	00014917          	auipc	s2,0x14
    80003104:	ce890913          	addi	s2,s2,-792 # 80016de8 <tickslock>
    80003108:	00005497          	auipc	s1,0x5
    8000310c:	7b048493          	addi	s1,s1,1968 # 800088b8 <ticks>
    if(killed(myproc())){
    80003110:	80bfe0ef          	jal	8000191a <myproc>
    80003114:	c72ff0ef          	jal	80002586 <killed>
    80003118:	ed0d                	bnez	a0,80003152 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    8000311a:	85ca                	mv	a1,s2
    8000311c:	8526                	mv	a0,s1
    8000311e:	8deff0ef          	jal	800021fc <sleep>
  while(ticks - ticks0 < n){
    80003122:	409c                	lw	a5,0(s1)
    80003124:	413787bb          	subw	a5,a5,s3
    80003128:	fcc42703          	lw	a4,-52(s0)
    8000312c:	fee7e2e3          	bltu	a5,a4,80003110 <sys_pause+0x4a>
    80003130:	74a2                	ld	s1,40(sp)
    80003132:	7902                	ld	s2,32(sp)
    80003134:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003136:	00014517          	auipc	a0,0x14
    8000313a:	cb250513          	addi	a0,a0,-846 # 80016de8 <tickslock>
    8000313e:	b7ffd0ef          	jal	80000cbc <release>
  return 0;
    80003142:	4501                	li	a0,0
}
    80003144:	70e2                	ld	ra,56(sp)
    80003146:	7442                	ld	s0,48(sp)
    80003148:	6121                	addi	sp,sp,64
    8000314a:	8082                	ret
    n = 0;
    8000314c:	fc042623          	sw	zero,-52(s0)
    80003150:	bf41                	j	800030e0 <sys_pause+0x1a>
      release(&tickslock);
    80003152:	00014517          	auipc	a0,0x14
    80003156:	c9650513          	addi	a0,a0,-874 # 80016de8 <tickslock>
    8000315a:	b63fd0ef          	jal	80000cbc <release>
      return -1;
    8000315e:	557d                	li	a0,-1
    80003160:	74a2                	ld	s1,40(sp)
    80003162:	7902                	ld	s2,32(sp)
    80003164:	69e2                	ld	s3,24(sp)
    80003166:	bff9                	j	80003144 <sys_pause+0x7e>

0000000080003168 <sys_kill>:

uint64
sys_kill(void)
{
    80003168:	1101                	addi	sp,sp,-32
    8000316a:	ec06                	sd	ra,24(sp)
    8000316c:	e822                	sd	s0,16(sp)
    8000316e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003170:	fec40593          	addi	a1,s0,-20
    80003174:	4501                	li	a0,0
    80003176:	d03ff0ef          	jal	80002e78 <argint>
  return kkill(pid);
    8000317a:	fec42503          	lw	a0,-20(s0)
    8000317e:	b34ff0ef          	jal	800024b2 <kkill>
}
    80003182:	60e2                	ld	ra,24(sp)
    80003184:	6442                	ld	s0,16(sp)
    80003186:	6105                	addi	sp,sp,32
    80003188:	8082                	ret

000000008000318a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003194:	00014517          	auipc	a0,0x14
    80003198:	c5450513          	addi	a0,a0,-940 # 80016de8 <tickslock>
    8000319c:	a8dfd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    800031a0:	00005797          	auipc	a5,0x5
    800031a4:	7187a783          	lw	a5,1816(a5) # 800088b8 <ticks>
    800031a8:	84be                	mv	s1,a5
  release(&tickslock);
    800031aa:	00014517          	auipc	a0,0x14
    800031ae:	c3e50513          	addi	a0,a0,-962 # 80016de8 <tickslock>
    800031b2:	b0bfd0ef          	jal	80000cbc <release>
  return xticks;
}
    800031b6:	02049513          	slli	a0,s1,0x20
    800031ba:	9101                	srli	a0,a0,0x20
    800031bc:	60e2                	ld	ra,24(sp)
    800031be:	6442                	ld	s0,16(sp)
    800031c0:	64a2                	ld	s1,8(sp)
    800031c2:	6105                	addi	sp,sp,32
    800031c4:	8082                	ret

00000000800031c6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800031c6:	7179                	addi	sp,sp,-48
    800031c8:	f406                	sd	ra,40(sp)
    800031ca:	f022                	sd	s0,32(sp)
    800031cc:	ec26                	sd	s1,24(sp)
    800031ce:	e84a                	sd	s2,16(sp)
    800031d0:	e44e                	sd	s3,8(sp)
    800031d2:	e052                	sd	s4,0(sp)
    800031d4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800031d6:	00005597          	auipc	a1,0x5
    800031da:	20a58593          	addi	a1,a1,522 # 800083e0 <etext+0x3e0>
    800031de:	00014517          	auipc	a0,0x14
    800031e2:	c2250513          	addi	a0,a0,-990 # 80016e00 <bcache>
    800031e6:	9b9fd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800031ea:	0001c797          	auipc	a5,0x1c
    800031ee:	c1678793          	addi	a5,a5,-1002 # 8001ee00 <bcache+0x8000>
    800031f2:	0001c717          	auipc	a4,0x1c
    800031f6:	e7670713          	addi	a4,a4,-394 # 8001f068 <bcache+0x8268>
    800031fa:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800031fe:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003202:	00014497          	auipc	s1,0x14
    80003206:	c1648493          	addi	s1,s1,-1002 # 80016e18 <bcache+0x18>
    b->next = bcache.head.next;
    8000320a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000320c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000320e:	00005a17          	auipc	s4,0x5
    80003212:	1daa0a13          	addi	s4,s4,474 # 800083e8 <etext+0x3e8>
    b->next = bcache.head.next;
    80003216:	2b893783          	ld	a5,696(s2)
    8000321a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000321c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003220:	85d2                	mv	a1,s4
    80003222:	01048513          	addi	a0,s1,16
    80003226:	328010ef          	jal	8000454e <initsleeplock>
    bcache.head.next->prev = b;
    8000322a:	2b893783          	ld	a5,696(s2)
    8000322e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003230:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003234:	45848493          	addi	s1,s1,1112
    80003238:	fd349fe3          	bne	s1,s3,80003216 <binit+0x50>
  }
}
    8000323c:	70a2                	ld	ra,40(sp)
    8000323e:	7402                	ld	s0,32(sp)
    80003240:	64e2                	ld	s1,24(sp)
    80003242:	6942                	ld	s2,16(sp)
    80003244:	69a2                	ld	s3,8(sp)
    80003246:	6a02                	ld	s4,0(sp)
    80003248:	6145                	addi	sp,sp,48
    8000324a:	8082                	ret

000000008000324c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000324c:	7179                	addi	sp,sp,-48
    8000324e:	f406                	sd	ra,40(sp)
    80003250:	f022                	sd	s0,32(sp)
    80003252:	ec26                	sd	s1,24(sp)
    80003254:	e84a                	sd	s2,16(sp)
    80003256:	e44e                	sd	s3,8(sp)
    80003258:	1800                	addi	s0,sp,48
    8000325a:	892a                	mv	s2,a0
    8000325c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000325e:	00014517          	auipc	a0,0x14
    80003262:	ba250513          	addi	a0,a0,-1118 # 80016e00 <bcache>
    80003266:	9c3fd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000326a:	0001c497          	auipc	s1,0x1c
    8000326e:	e4e4b483          	ld	s1,-434(s1) # 8001f0b8 <bcache+0x82b8>
    80003272:	0001c797          	auipc	a5,0x1c
    80003276:	df678793          	addi	a5,a5,-522 # 8001f068 <bcache+0x8268>
    8000327a:	02f48b63          	beq	s1,a5,800032b0 <bread+0x64>
    8000327e:	873e                	mv	a4,a5
    80003280:	a021                	j	80003288 <bread+0x3c>
    80003282:	68a4                	ld	s1,80(s1)
    80003284:	02e48663          	beq	s1,a4,800032b0 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003288:	449c                	lw	a5,8(s1)
    8000328a:	ff279ce3          	bne	a5,s2,80003282 <bread+0x36>
    8000328e:	44dc                	lw	a5,12(s1)
    80003290:	ff3799e3          	bne	a5,s3,80003282 <bread+0x36>
      b->refcnt++;
    80003294:	40bc                	lw	a5,64(s1)
    80003296:	2785                	addiw	a5,a5,1
    80003298:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000329a:	00014517          	auipc	a0,0x14
    8000329e:	b6650513          	addi	a0,a0,-1178 # 80016e00 <bcache>
    800032a2:	a1bfd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    800032a6:	01048513          	addi	a0,s1,16
    800032aa:	2da010ef          	jal	80004584 <acquiresleep>
      return b;
    800032ae:	a889                	j	80003300 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032b0:	0001c497          	auipc	s1,0x1c
    800032b4:	e004b483          	ld	s1,-512(s1) # 8001f0b0 <bcache+0x82b0>
    800032b8:	0001c797          	auipc	a5,0x1c
    800032bc:	db078793          	addi	a5,a5,-592 # 8001f068 <bcache+0x8268>
    800032c0:	00f48863          	beq	s1,a5,800032d0 <bread+0x84>
    800032c4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800032c6:	40bc                	lw	a5,64(s1)
    800032c8:	cb91                	beqz	a5,800032dc <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032ca:	64a4                	ld	s1,72(s1)
    800032cc:	fee49de3          	bne	s1,a4,800032c6 <bread+0x7a>
  panic("bget: no buffers");
    800032d0:	00005517          	auipc	a0,0x5
    800032d4:	12050513          	addi	a0,a0,288 # 800083f0 <etext+0x3f0>
    800032d8:	d4cfd0ef          	jal	80000824 <panic>
      b->dev = dev;
    800032dc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800032e0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800032e4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800032e8:	4785                	li	a5,1
    800032ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032ec:	00014517          	auipc	a0,0x14
    800032f0:	b1450513          	addi	a0,a0,-1260 # 80016e00 <bcache>
    800032f4:	9c9fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    800032f8:	01048513          	addi	a0,s1,16
    800032fc:	288010ef          	jal	80004584 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003300:	409c                	lw	a5,0(s1)
    80003302:	cb89                	beqz	a5,80003314 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003304:	8526                	mv	a0,s1
    80003306:	70a2                	ld	ra,40(sp)
    80003308:	7402                	ld	s0,32(sp)
    8000330a:	64e2                	ld	s1,24(sp)
    8000330c:	6942                	ld	s2,16(sp)
    8000330e:	69a2                	ld	s3,8(sp)
    80003310:	6145                	addi	sp,sp,48
    80003312:	8082                	ret
    virtio_disk_rw(b, 0);
    80003314:	4581                	li	a1,0
    80003316:	8526                	mv	a0,s1
    80003318:	339020ef          	jal	80005e50 <virtio_disk_rw>
    b->valid = 1;
    8000331c:	4785                	li	a5,1
    8000331e:	c09c                	sw	a5,0(s1)
  return b;
    80003320:	b7d5                	j	80003304 <bread+0xb8>

0000000080003322 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003322:	1101                	addi	sp,sp,-32
    80003324:	ec06                	sd	ra,24(sp)
    80003326:	e822                	sd	s0,16(sp)
    80003328:	e426                	sd	s1,8(sp)
    8000332a:	1000                	addi	s0,sp,32
    8000332c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000332e:	0541                	addi	a0,a0,16
    80003330:	2d2010ef          	jal	80004602 <holdingsleep>
    80003334:	c911                	beqz	a0,80003348 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003336:	4585                	li	a1,1
    80003338:	8526                	mv	a0,s1
    8000333a:	317020ef          	jal	80005e50 <virtio_disk_rw>
}
    8000333e:	60e2                	ld	ra,24(sp)
    80003340:	6442                	ld	s0,16(sp)
    80003342:	64a2                	ld	s1,8(sp)
    80003344:	6105                	addi	sp,sp,32
    80003346:	8082                	ret
    panic("bwrite");
    80003348:	00005517          	auipc	a0,0x5
    8000334c:	0c050513          	addi	a0,a0,192 # 80008408 <etext+0x408>
    80003350:	cd4fd0ef          	jal	80000824 <panic>

0000000080003354 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003354:	1101                	addi	sp,sp,-32
    80003356:	ec06                	sd	ra,24(sp)
    80003358:	e822                	sd	s0,16(sp)
    8000335a:	e426                	sd	s1,8(sp)
    8000335c:	e04a                	sd	s2,0(sp)
    8000335e:	1000                	addi	s0,sp,32
    80003360:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003362:	01050913          	addi	s2,a0,16
    80003366:	854a                	mv	a0,s2
    80003368:	29a010ef          	jal	80004602 <holdingsleep>
    8000336c:	c125                	beqz	a0,800033cc <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000336e:	854a                	mv	a0,s2
    80003370:	25a010ef          	jal	800045ca <releasesleep>

  acquire(&bcache.lock);
    80003374:	00014517          	auipc	a0,0x14
    80003378:	a8c50513          	addi	a0,a0,-1396 # 80016e00 <bcache>
    8000337c:	8adfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80003380:	40bc                	lw	a5,64(s1)
    80003382:	37fd                	addiw	a5,a5,-1
    80003384:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003386:	e79d                	bnez	a5,800033b4 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003388:	68b8                	ld	a4,80(s1)
    8000338a:	64bc                	ld	a5,72(s1)
    8000338c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000338e:	68b8                	ld	a4,80(s1)
    80003390:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003392:	0001c797          	auipc	a5,0x1c
    80003396:	a6e78793          	addi	a5,a5,-1426 # 8001ee00 <bcache+0x8000>
    8000339a:	2b87b703          	ld	a4,696(a5)
    8000339e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800033a0:	0001c717          	auipc	a4,0x1c
    800033a4:	cc870713          	addi	a4,a4,-824 # 8001f068 <bcache+0x8268>
    800033a8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800033aa:	2b87b703          	ld	a4,696(a5)
    800033ae:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800033b0:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800033b4:	00014517          	auipc	a0,0x14
    800033b8:	a4c50513          	addi	a0,a0,-1460 # 80016e00 <bcache>
    800033bc:	901fd0ef          	jal	80000cbc <release>
}
    800033c0:	60e2                	ld	ra,24(sp)
    800033c2:	6442                	ld	s0,16(sp)
    800033c4:	64a2                	ld	s1,8(sp)
    800033c6:	6902                	ld	s2,0(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret
    panic("brelse");
    800033cc:	00005517          	auipc	a0,0x5
    800033d0:	04450513          	addi	a0,a0,68 # 80008410 <etext+0x410>
    800033d4:	c50fd0ef          	jal	80000824 <panic>

00000000800033d8 <bpin>:

void
bpin(struct buf *b) {
    800033d8:	1101                	addi	sp,sp,-32
    800033da:	ec06                	sd	ra,24(sp)
    800033dc:	e822                	sd	s0,16(sp)
    800033de:	e426                	sd	s1,8(sp)
    800033e0:	1000                	addi	s0,sp,32
    800033e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800033e4:	00014517          	auipc	a0,0x14
    800033e8:	a1c50513          	addi	a0,a0,-1508 # 80016e00 <bcache>
    800033ec:	83dfd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    800033f0:	40bc                	lw	a5,64(s1)
    800033f2:	2785                	addiw	a5,a5,1
    800033f4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800033f6:	00014517          	auipc	a0,0x14
    800033fa:	a0a50513          	addi	a0,a0,-1526 # 80016e00 <bcache>
    800033fe:	8bffd0ef          	jal	80000cbc <release>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6105                	addi	sp,sp,32
    8000340a:	8082                	ret

000000008000340c <bunpin>:

void
bunpin(struct buf *b) {
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	1000                	addi	s0,sp,32
    80003416:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003418:	00014517          	auipc	a0,0x14
    8000341c:	9e850513          	addi	a0,a0,-1560 # 80016e00 <bcache>
    80003420:	809fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80003424:	40bc                	lw	a5,64(s1)
    80003426:	37fd                	addiw	a5,a5,-1
    80003428:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000342a:	00014517          	auipc	a0,0x14
    8000342e:	9d650513          	addi	a0,a0,-1578 # 80016e00 <bcache>
    80003432:	88bfd0ef          	jal	80000cbc <release>
}
    80003436:	60e2                	ld	ra,24(sp)
    80003438:	6442                	ld	s0,16(sp)
    8000343a:	64a2                	ld	s1,8(sp)
    8000343c:	6105                	addi	sp,sp,32
    8000343e:	8082                	ret

0000000080003440 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003440:	1101                	addi	sp,sp,-32
    80003442:	ec06                	sd	ra,24(sp)
    80003444:	e822                	sd	s0,16(sp)
    80003446:	e426                	sd	s1,8(sp)
    80003448:	e04a                	sd	s2,0(sp)
    8000344a:	1000                	addi	s0,sp,32
    8000344c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000344e:	00d5d79b          	srliw	a5,a1,0xd
    80003452:	0001c597          	auipc	a1,0x1c
    80003456:	08a5a583          	lw	a1,138(a1) # 8001f4dc <sb+0x1c>
    8000345a:	9dbd                	addw	a1,a1,a5
    8000345c:	df1ff0ef          	jal	8000324c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003460:	0074f713          	andi	a4,s1,7
    80003464:	4785                	li	a5,1
    80003466:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000346a:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000346c:	90d9                	srli	s1,s1,0x36
    8000346e:	00950733          	add	a4,a0,s1
    80003472:	05874703          	lbu	a4,88(a4)
    80003476:	00e7f6b3          	and	a3,a5,a4
    8000347a:	c29d                	beqz	a3,800034a0 <bfree+0x60>
    8000347c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000347e:	94aa                	add	s1,s1,a0
    80003480:	fff7c793          	not	a5,a5
    80003484:	8f7d                	and	a4,a4,a5
    80003486:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000348a:	000010ef          	jal	8000448a <log_write>
  brelse(bp);
    8000348e:	854a                	mv	a0,s2
    80003490:	ec5ff0ef          	jal	80003354 <brelse>
}
    80003494:	60e2                	ld	ra,24(sp)
    80003496:	6442                	ld	s0,16(sp)
    80003498:	64a2                	ld	s1,8(sp)
    8000349a:	6902                	ld	s2,0(sp)
    8000349c:	6105                	addi	sp,sp,32
    8000349e:	8082                	ret
    panic("freeing free block");
    800034a0:	00005517          	auipc	a0,0x5
    800034a4:	f7850513          	addi	a0,a0,-136 # 80008418 <etext+0x418>
    800034a8:	b7cfd0ef          	jal	80000824 <panic>

00000000800034ac <balloc>:
{
    800034ac:	715d                	addi	sp,sp,-80
    800034ae:	e486                	sd	ra,72(sp)
    800034b0:	e0a2                	sd	s0,64(sp)
    800034b2:	fc26                	sd	s1,56(sp)
    800034b4:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800034b6:	0001c797          	auipc	a5,0x1c
    800034ba:	00e7a783          	lw	a5,14(a5) # 8001f4c4 <sb+0x4>
    800034be:	0e078263          	beqz	a5,800035a2 <balloc+0xf6>
    800034c2:	f84a                	sd	s2,48(sp)
    800034c4:	f44e                	sd	s3,40(sp)
    800034c6:	f052                	sd	s4,32(sp)
    800034c8:	ec56                	sd	s5,24(sp)
    800034ca:	e85a                	sd	s6,16(sp)
    800034cc:	e45e                	sd	s7,8(sp)
    800034ce:	e062                	sd	s8,0(sp)
    800034d0:	8baa                	mv	s7,a0
    800034d2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800034d4:	0001cb17          	auipc	s6,0x1c
    800034d8:	fecb0b13          	addi	s6,s6,-20 # 8001f4c0 <sb>
      m = 1 << (bi % 8);
    800034dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800034e0:	6c09                	lui	s8,0x2
    800034e2:	a09d                	j	80003548 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800034e4:	97ca                	add	a5,a5,s2
    800034e6:	8e55                	or	a2,a2,a3
    800034e8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800034ec:	854a                	mv	a0,s2
    800034ee:	79d000ef          	jal	8000448a <log_write>
        brelse(bp);
    800034f2:	854a                	mv	a0,s2
    800034f4:	e61ff0ef          	jal	80003354 <brelse>
  bp = bread(dev, bno);
    800034f8:	85a6                	mv	a1,s1
    800034fa:	855e                	mv	a0,s7
    800034fc:	d51ff0ef          	jal	8000324c <bread>
    80003500:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003502:	40000613          	li	a2,1024
    80003506:	4581                	li	a1,0
    80003508:	05850513          	addi	a0,a0,88
    8000350c:	fecfd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80003510:	854a                	mv	a0,s2
    80003512:	779000ef          	jal	8000448a <log_write>
  brelse(bp);
    80003516:	854a                	mv	a0,s2
    80003518:	e3dff0ef          	jal	80003354 <brelse>
}
    8000351c:	7942                	ld	s2,48(sp)
    8000351e:	79a2                	ld	s3,40(sp)
    80003520:	7a02                	ld	s4,32(sp)
    80003522:	6ae2                	ld	s5,24(sp)
    80003524:	6b42                	ld	s6,16(sp)
    80003526:	6ba2                	ld	s7,8(sp)
    80003528:	6c02                	ld	s8,0(sp)
}
    8000352a:	8526                	mv	a0,s1
    8000352c:	60a6                	ld	ra,72(sp)
    8000352e:	6406                	ld	s0,64(sp)
    80003530:	74e2                	ld	s1,56(sp)
    80003532:	6161                	addi	sp,sp,80
    80003534:	8082                	ret
    brelse(bp);
    80003536:	854a                	mv	a0,s2
    80003538:	e1dff0ef          	jal	80003354 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000353c:	015c0abb          	addw	s5,s8,s5
    80003540:	004b2783          	lw	a5,4(s6)
    80003544:	04faf863          	bgeu	s5,a5,80003594 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003548:	40dad59b          	sraiw	a1,s5,0xd
    8000354c:	01cb2783          	lw	a5,28(s6)
    80003550:	9dbd                	addw	a1,a1,a5
    80003552:	855e                	mv	a0,s7
    80003554:	cf9ff0ef          	jal	8000324c <bread>
    80003558:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000355a:	004b2503          	lw	a0,4(s6)
    8000355e:	84d6                	mv	s1,s5
    80003560:	4701                	li	a4,0
    80003562:	fca4fae3          	bgeu	s1,a0,80003536 <balloc+0x8a>
      m = 1 << (bi % 8);
    80003566:	00777693          	andi	a3,a4,7
    8000356a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000356e:	41f7579b          	sraiw	a5,a4,0x1f
    80003572:	01d7d79b          	srliw	a5,a5,0x1d
    80003576:	9fb9                	addw	a5,a5,a4
    80003578:	4037d79b          	sraiw	a5,a5,0x3
    8000357c:	00f90633          	add	a2,s2,a5
    80003580:	05864603          	lbu	a2,88(a2)
    80003584:	00c6f5b3          	and	a1,a3,a2
    80003588:	ddb1                	beqz	a1,800034e4 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000358a:	2705                	addiw	a4,a4,1
    8000358c:	2485                	addiw	s1,s1,1
    8000358e:	fd471ae3          	bne	a4,s4,80003562 <balloc+0xb6>
    80003592:	b755                	j	80003536 <balloc+0x8a>
    80003594:	7942                	ld	s2,48(sp)
    80003596:	79a2                	ld	s3,40(sp)
    80003598:	7a02                	ld	s4,32(sp)
    8000359a:	6ae2                	ld	s5,24(sp)
    8000359c:	6b42                	ld	s6,16(sp)
    8000359e:	6ba2                	ld	s7,8(sp)
    800035a0:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800035a2:	00005517          	auipc	a0,0x5
    800035a6:	e8e50513          	addi	a0,a0,-370 # 80008430 <etext+0x430>
    800035aa:	f51fc0ef          	jal	800004fa <printf>
  return 0;
    800035ae:	4481                	li	s1,0
    800035b0:	bfad                	j	8000352a <balloc+0x7e>

00000000800035b2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800035b2:	7179                	addi	sp,sp,-48
    800035b4:	f406                	sd	ra,40(sp)
    800035b6:	f022                	sd	s0,32(sp)
    800035b8:	ec26                	sd	s1,24(sp)
    800035ba:	e84a                	sd	s2,16(sp)
    800035bc:	e44e                	sd	s3,8(sp)
    800035be:	1800                	addi	s0,sp,48
    800035c0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800035c2:	47ad                	li	a5,11
    800035c4:	02b7e363          	bltu	a5,a1,800035ea <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800035c8:	02059793          	slli	a5,a1,0x20
    800035cc:	01e7d593          	srli	a1,a5,0x1e
    800035d0:	00b509b3          	add	s3,a0,a1
    800035d4:	0509a483          	lw	s1,80(s3)
    800035d8:	e0b5                	bnez	s1,8000363c <bmap+0x8a>
      addr = balloc(ip->dev);
    800035da:	4108                	lw	a0,0(a0)
    800035dc:	ed1ff0ef          	jal	800034ac <balloc>
    800035e0:	84aa                	mv	s1,a0
      if(addr == 0)
    800035e2:	cd29                	beqz	a0,8000363c <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800035e4:	04a9a823          	sw	a0,80(s3)
    800035e8:	a891                	j	8000363c <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800035ea:	ff45879b          	addiw	a5,a1,-12
    800035ee:	873e                	mv	a4,a5
    800035f0:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800035f2:	0ff00793          	li	a5,255
    800035f6:	06e7e763          	bltu	a5,a4,80003664 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800035fa:	08052483          	lw	s1,128(a0)
    800035fe:	e891                	bnez	s1,80003612 <bmap+0x60>
      addr = balloc(ip->dev);
    80003600:	4108                	lw	a0,0(a0)
    80003602:	eabff0ef          	jal	800034ac <balloc>
    80003606:	84aa                	mv	s1,a0
      if(addr == 0)
    80003608:	c915                	beqz	a0,8000363c <bmap+0x8a>
    8000360a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000360c:	08a92023          	sw	a0,128(s2)
    80003610:	a011                	j	80003614 <bmap+0x62>
    80003612:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003614:	85a6                	mv	a1,s1
    80003616:	00092503          	lw	a0,0(s2)
    8000361a:	c33ff0ef          	jal	8000324c <bread>
    8000361e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003620:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003624:	02099713          	slli	a4,s3,0x20
    80003628:	01e75593          	srli	a1,a4,0x1e
    8000362c:	97ae                	add	a5,a5,a1
    8000362e:	89be                	mv	s3,a5
    80003630:	4384                	lw	s1,0(a5)
    80003632:	cc89                	beqz	s1,8000364c <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003634:	8552                	mv	a0,s4
    80003636:	d1fff0ef          	jal	80003354 <brelse>
    return addr;
    8000363a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000363c:	8526                	mv	a0,s1
    8000363e:	70a2                	ld	ra,40(sp)
    80003640:	7402                	ld	s0,32(sp)
    80003642:	64e2                	ld	s1,24(sp)
    80003644:	6942                	ld	s2,16(sp)
    80003646:	69a2                	ld	s3,8(sp)
    80003648:	6145                	addi	sp,sp,48
    8000364a:	8082                	ret
      addr = balloc(ip->dev);
    8000364c:	00092503          	lw	a0,0(s2)
    80003650:	e5dff0ef          	jal	800034ac <balloc>
    80003654:	84aa                	mv	s1,a0
      if(addr){
    80003656:	dd79                	beqz	a0,80003634 <bmap+0x82>
        a[bn] = addr;
    80003658:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000365c:	8552                	mv	a0,s4
    8000365e:	62d000ef          	jal	8000448a <log_write>
    80003662:	bfc9                	j	80003634 <bmap+0x82>
    80003664:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003666:	00005517          	auipc	a0,0x5
    8000366a:	de250513          	addi	a0,a0,-542 # 80008448 <etext+0x448>
    8000366e:	9b6fd0ef          	jal	80000824 <panic>

0000000080003672 <iget>:
{
    80003672:	7179                	addi	sp,sp,-48
    80003674:	f406                	sd	ra,40(sp)
    80003676:	f022                	sd	s0,32(sp)
    80003678:	ec26                	sd	s1,24(sp)
    8000367a:	e84a                	sd	s2,16(sp)
    8000367c:	e44e                	sd	s3,8(sp)
    8000367e:	e052                	sd	s4,0(sp)
    80003680:	1800                	addi	s0,sp,48
    80003682:	892a                	mv	s2,a0
    80003684:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003686:	0001c517          	auipc	a0,0x1c
    8000368a:	e5a50513          	addi	a0,a0,-422 # 8001f4e0 <itable>
    8000368e:	d9afd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80003692:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003694:	0001c497          	auipc	s1,0x1c
    80003698:	e6448493          	addi	s1,s1,-412 # 8001f4f8 <itable+0x18>
    8000369c:	0001e697          	auipc	a3,0x1e
    800036a0:	8ec68693          	addi	a3,a3,-1812 # 80020f88 <log>
    800036a4:	a809                	j	800036b6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036a6:	e781                	bnez	a5,800036ae <iget+0x3c>
    800036a8:	00099363          	bnez	s3,800036ae <iget+0x3c>
      empty = ip;
    800036ac:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800036ae:	08848493          	addi	s1,s1,136
    800036b2:	02d48563          	beq	s1,a3,800036dc <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800036b6:	449c                	lw	a5,8(s1)
    800036b8:	fef057e3          	blez	a5,800036a6 <iget+0x34>
    800036bc:	4098                	lw	a4,0(s1)
    800036be:	ff2718e3          	bne	a4,s2,800036ae <iget+0x3c>
    800036c2:	40d8                	lw	a4,4(s1)
    800036c4:	ff4715e3          	bne	a4,s4,800036ae <iget+0x3c>
      ip->ref++;
    800036c8:	2785                	addiw	a5,a5,1
    800036ca:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800036cc:	0001c517          	auipc	a0,0x1c
    800036d0:	e1450513          	addi	a0,a0,-492 # 8001f4e0 <itable>
    800036d4:	de8fd0ef          	jal	80000cbc <release>
      return ip;
    800036d8:	89a6                	mv	s3,s1
    800036da:	a015                	j	800036fe <iget+0x8c>
  if(empty == 0)
    800036dc:	02098a63          	beqz	s3,80003710 <iget+0x9e>
  ip->dev = dev;
    800036e0:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800036e4:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    800036e8:	4785                	li	a5,1
    800036ea:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800036ee:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    800036f2:	0001c517          	auipc	a0,0x1c
    800036f6:	dee50513          	addi	a0,a0,-530 # 8001f4e0 <itable>
    800036fa:	dc2fd0ef          	jal	80000cbc <release>
}
    800036fe:	854e                	mv	a0,s3
    80003700:	70a2                	ld	ra,40(sp)
    80003702:	7402                	ld	s0,32(sp)
    80003704:	64e2                	ld	s1,24(sp)
    80003706:	6942                	ld	s2,16(sp)
    80003708:	69a2                	ld	s3,8(sp)
    8000370a:	6a02                	ld	s4,0(sp)
    8000370c:	6145                	addi	sp,sp,48
    8000370e:	8082                	ret
    panic("iget: no inodes");
    80003710:	00005517          	auipc	a0,0x5
    80003714:	d5050513          	addi	a0,a0,-688 # 80008460 <etext+0x460>
    80003718:	90cfd0ef          	jal	80000824 <panic>

000000008000371c <iinit>:
{
    8000371c:	7179                	addi	sp,sp,-48
    8000371e:	f406                	sd	ra,40(sp)
    80003720:	f022                	sd	s0,32(sp)
    80003722:	ec26                	sd	s1,24(sp)
    80003724:	e84a                	sd	s2,16(sp)
    80003726:	e44e                	sd	s3,8(sp)
    80003728:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000372a:	00005597          	auipc	a1,0x5
    8000372e:	d4658593          	addi	a1,a1,-698 # 80008470 <etext+0x470>
    80003732:	0001c517          	auipc	a0,0x1c
    80003736:	dae50513          	addi	a0,a0,-594 # 8001f4e0 <itable>
    8000373a:	c64fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    8000373e:	0001c497          	auipc	s1,0x1c
    80003742:	dca48493          	addi	s1,s1,-566 # 8001f508 <itable+0x28>
    80003746:	0001e997          	auipc	s3,0x1e
    8000374a:	85298993          	addi	s3,s3,-1966 # 80020f98 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000374e:	00005917          	auipc	s2,0x5
    80003752:	d2a90913          	addi	s2,s2,-726 # 80008478 <etext+0x478>
    80003756:	85ca                	mv	a1,s2
    80003758:	8526                	mv	a0,s1
    8000375a:	5f5000ef          	jal	8000454e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000375e:	08848493          	addi	s1,s1,136
    80003762:	ff349ae3          	bne	s1,s3,80003756 <iinit+0x3a>
}
    80003766:	70a2                	ld	ra,40(sp)
    80003768:	7402                	ld	s0,32(sp)
    8000376a:	64e2                	ld	s1,24(sp)
    8000376c:	6942                	ld	s2,16(sp)
    8000376e:	69a2                	ld	s3,8(sp)
    80003770:	6145                	addi	sp,sp,48
    80003772:	8082                	ret

0000000080003774 <ialloc>:
{
    80003774:	7139                	addi	sp,sp,-64
    80003776:	fc06                	sd	ra,56(sp)
    80003778:	f822                	sd	s0,48(sp)
    8000377a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000377c:	0001c717          	auipc	a4,0x1c
    80003780:	d5072703          	lw	a4,-688(a4) # 8001f4cc <sb+0xc>
    80003784:	4785                	li	a5,1
    80003786:	06e7f063          	bgeu	a5,a4,800037e6 <ialloc+0x72>
    8000378a:	f426                	sd	s1,40(sp)
    8000378c:	f04a                	sd	s2,32(sp)
    8000378e:	ec4e                	sd	s3,24(sp)
    80003790:	e852                	sd	s4,16(sp)
    80003792:	e456                	sd	s5,8(sp)
    80003794:	e05a                	sd	s6,0(sp)
    80003796:	8aaa                	mv	s5,a0
    80003798:	8b2e                	mv	s6,a1
    8000379a:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000379c:	0001ca17          	auipc	s4,0x1c
    800037a0:	d24a0a13          	addi	s4,s4,-732 # 8001f4c0 <sb>
    800037a4:	00495593          	srli	a1,s2,0x4
    800037a8:	018a2783          	lw	a5,24(s4)
    800037ac:	9dbd                	addw	a1,a1,a5
    800037ae:	8556                	mv	a0,s5
    800037b0:	a9dff0ef          	jal	8000324c <bread>
    800037b4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800037b6:	05850993          	addi	s3,a0,88
    800037ba:	00f97793          	andi	a5,s2,15
    800037be:	079a                	slli	a5,a5,0x6
    800037c0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800037c2:	00099783          	lh	a5,0(s3)
    800037c6:	cb9d                	beqz	a5,800037fc <ialloc+0x88>
    brelse(bp);
    800037c8:	b8dff0ef          	jal	80003354 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800037cc:	0905                	addi	s2,s2,1
    800037ce:	00ca2703          	lw	a4,12(s4)
    800037d2:	0009079b          	sext.w	a5,s2
    800037d6:	fce7e7e3          	bltu	a5,a4,800037a4 <ialloc+0x30>
    800037da:	74a2                	ld	s1,40(sp)
    800037dc:	7902                	ld	s2,32(sp)
    800037de:	69e2                	ld	s3,24(sp)
    800037e0:	6a42                	ld	s4,16(sp)
    800037e2:	6aa2                	ld	s5,8(sp)
    800037e4:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800037e6:	00005517          	auipc	a0,0x5
    800037ea:	c9a50513          	addi	a0,a0,-870 # 80008480 <etext+0x480>
    800037ee:	d0dfc0ef          	jal	800004fa <printf>
  return 0;
    800037f2:	4501                	li	a0,0
}
    800037f4:	70e2                	ld	ra,56(sp)
    800037f6:	7442                	ld	s0,48(sp)
    800037f8:	6121                	addi	sp,sp,64
    800037fa:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800037fc:	04000613          	li	a2,64
    80003800:	4581                	li	a1,0
    80003802:	854e                	mv	a0,s3
    80003804:	cf4fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003808:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000380c:	8526                	mv	a0,s1
    8000380e:	47d000ef          	jal	8000448a <log_write>
      brelse(bp);
    80003812:	8526                	mv	a0,s1
    80003814:	b41ff0ef          	jal	80003354 <brelse>
      return iget(dev, inum);
    80003818:	0009059b          	sext.w	a1,s2
    8000381c:	8556                	mv	a0,s5
    8000381e:	e55ff0ef          	jal	80003672 <iget>
    80003822:	74a2                	ld	s1,40(sp)
    80003824:	7902                	ld	s2,32(sp)
    80003826:	69e2                	ld	s3,24(sp)
    80003828:	6a42                	ld	s4,16(sp)
    8000382a:	6aa2                	ld	s5,8(sp)
    8000382c:	6b02                	ld	s6,0(sp)
    8000382e:	b7d9                	j	800037f4 <ialloc+0x80>

0000000080003830 <iupdate>:
{
    80003830:	1101                	addi	sp,sp,-32
    80003832:	ec06                	sd	ra,24(sp)
    80003834:	e822                	sd	s0,16(sp)
    80003836:	e426                	sd	s1,8(sp)
    80003838:	e04a                	sd	s2,0(sp)
    8000383a:	1000                	addi	s0,sp,32
    8000383c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000383e:	415c                	lw	a5,4(a0)
    80003840:	0047d79b          	srliw	a5,a5,0x4
    80003844:	0001c597          	auipc	a1,0x1c
    80003848:	c945a583          	lw	a1,-876(a1) # 8001f4d8 <sb+0x18>
    8000384c:	9dbd                	addw	a1,a1,a5
    8000384e:	4108                	lw	a0,0(a0)
    80003850:	9fdff0ef          	jal	8000324c <bread>
    80003854:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003856:	05850793          	addi	a5,a0,88
    8000385a:	40d8                	lw	a4,4(s1)
    8000385c:	8b3d                	andi	a4,a4,15
    8000385e:	071a                	slli	a4,a4,0x6
    80003860:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003862:	04449703          	lh	a4,68(s1)
    80003866:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000386a:	04649703          	lh	a4,70(s1)
    8000386e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003872:	04849703          	lh	a4,72(s1)
    80003876:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000387a:	04a49703          	lh	a4,74(s1)
    8000387e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003882:	44f8                	lw	a4,76(s1)
    80003884:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003886:	03400613          	li	a2,52
    8000388a:	05048593          	addi	a1,s1,80
    8000388e:	00c78513          	addi	a0,a5,12
    80003892:	cc6fd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003896:	854a                	mv	a0,s2
    80003898:	3f3000ef          	jal	8000448a <log_write>
  brelse(bp);
    8000389c:	854a                	mv	a0,s2
    8000389e:	ab7ff0ef          	jal	80003354 <brelse>
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <idup>:
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	1000                	addi	s0,sp,32
    800038b8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800038ba:	0001c517          	auipc	a0,0x1c
    800038be:	c2650513          	addi	a0,a0,-986 # 8001f4e0 <itable>
    800038c2:	b66fd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    800038c6:	449c                	lw	a5,8(s1)
    800038c8:	2785                	addiw	a5,a5,1
    800038ca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800038cc:	0001c517          	auipc	a0,0x1c
    800038d0:	c1450513          	addi	a0,a0,-1004 # 8001f4e0 <itable>
    800038d4:	be8fd0ef          	jal	80000cbc <release>
}
    800038d8:	8526                	mv	a0,s1
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6105                	addi	sp,sp,32
    800038e2:	8082                	ret

00000000800038e4 <ilock>:
{
    800038e4:	1101                	addi	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800038ee:	cd19                	beqz	a0,8000390c <ilock+0x28>
    800038f0:	84aa                	mv	s1,a0
    800038f2:	451c                	lw	a5,8(a0)
    800038f4:	00f05c63          	blez	a5,8000390c <ilock+0x28>
  acquiresleep(&ip->lock);
    800038f8:	0541                	addi	a0,a0,16
    800038fa:	48b000ef          	jal	80004584 <acquiresleep>
  if(ip->valid == 0){
    800038fe:	40bc                	lw	a5,64(s1)
    80003900:	cf89                	beqz	a5,8000391a <ilock+0x36>
}
    80003902:	60e2                	ld	ra,24(sp)
    80003904:	6442                	ld	s0,16(sp)
    80003906:	64a2                	ld	s1,8(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret
    8000390c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000390e:	00005517          	auipc	a0,0x5
    80003912:	b8a50513          	addi	a0,a0,-1142 # 80008498 <etext+0x498>
    80003916:	f0ffc0ef          	jal	80000824 <panic>
    8000391a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000391c:	40dc                	lw	a5,4(s1)
    8000391e:	0047d79b          	srliw	a5,a5,0x4
    80003922:	0001c597          	auipc	a1,0x1c
    80003926:	bb65a583          	lw	a1,-1098(a1) # 8001f4d8 <sb+0x18>
    8000392a:	9dbd                	addw	a1,a1,a5
    8000392c:	4088                	lw	a0,0(s1)
    8000392e:	91fff0ef          	jal	8000324c <bread>
    80003932:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003934:	05850593          	addi	a1,a0,88
    80003938:	40dc                	lw	a5,4(s1)
    8000393a:	8bbd                	andi	a5,a5,15
    8000393c:	079a                	slli	a5,a5,0x6
    8000393e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003940:	00059783          	lh	a5,0(a1)
    80003944:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003948:	00259783          	lh	a5,2(a1)
    8000394c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003950:	00459783          	lh	a5,4(a1)
    80003954:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003958:	00659783          	lh	a5,6(a1)
    8000395c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003960:	459c                	lw	a5,8(a1)
    80003962:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003964:	03400613          	li	a2,52
    80003968:	05b1                	addi	a1,a1,12
    8000396a:	05048513          	addi	a0,s1,80
    8000396e:	beafd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    80003972:	854a                	mv	a0,s2
    80003974:	9e1ff0ef          	jal	80003354 <brelse>
    ip->valid = 1;
    80003978:	4785                	li	a5,1
    8000397a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000397c:	04449783          	lh	a5,68(s1)
    80003980:	c399                	beqz	a5,80003986 <ilock+0xa2>
    80003982:	6902                	ld	s2,0(sp)
    80003984:	bfbd                	j	80003902 <ilock+0x1e>
      panic("ilock: no type");
    80003986:	00005517          	auipc	a0,0x5
    8000398a:	b1a50513          	addi	a0,a0,-1254 # 800084a0 <etext+0x4a0>
    8000398e:	e97fc0ef          	jal	80000824 <panic>

0000000080003992 <iunlock>:
{
    80003992:	1101                	addi	sp,sp,-32
    80003994:	ec06                	sd	ra,24(sp)
    80003996:	e822                	sd	s0,16(sp)
    80003998:	e426                	sd	s1,8(sp)
    8000399a:	e04a                	sd	s2,0(sp)
    8000399c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000399e:	c505                	beqz	a0,800039c6 <iunlock+0x34>
    800039a0:	84aa                	mv	s1,a0
    800039a2:	01050913          	addi	s2,a0,16
    800039a6:	854a                	mv	a0,s2
    800039a8:	45b000ef          	jal	80004602 <holdingsleep>
    800039ac:	cd09                	beqz	a0,800039c6 <iunlock+0x34>
    800039ae:	449c                	lw	a5,8(s1)
    800039b0:	00f05b63          	blez	a5,800039c6 <iunlock+0x34>
  releasesleep(&ip->lock);
    800039b4:	854a                	mv	a0,s2
    800039b6:	415000ef          	jal	800045ca <releasesleep>
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6902                	ld	s2,0(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret
    panic("iunlock");
    800039c6:	00005517          	auipc	a0,0x5
    800039ca:	aea50513          	addi	a0,a0,-1302 # 800084b0 <etext+0x4b0>
    800039ce:	e57fc0ef          	jal	80000824 <panic>

00000000800039d2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800039d2:	7179                	addi	sp,sp,-48
    800039d4:	f406                	sd	ra,40(sp)
    800039d6:	f022                	sd	s0,32(sp)
    800039d8:	ec26                	sd	s1,24(sp)
    800039da:	e84a                	sd	s2,16(sp)
    800039dc:	e44e                	sd	s3,8(sp)
    800039de:	1800                	addi	s0,sp,48
    800039e0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800039e2:	05050493          	addi	s1,a0,80
    800039e6:	08050913          	addi	s2,a0,128
    800039ea:	a021                	j	800039f2 <itrunc+0x20>
    800039ec:	0491                	addi	s1,s1,4
    800039ee:	01248b63          	beq	s1,s2,80003a04 <itrunc+0x32>
    if(ip->addrs[i]){
    800039f2:	408c                	lw	a1,0(s1)
    800039f4:	dde5                	beqz	a1,800039ec <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800039f6:	0009a503          	lw	a0,0(s3)
    800039fa:	a47ff0ef          	jal	80003440 <bfree>
      ip->addrs[i] = 0;
    800039fe:	0004a023          	sw	zero,0(s1)
    80003a02:	b7ed                	j	800039ec <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003a04:	0809a583          	lw	a1,128(s3)
    80003a08:	ed89                	bnez	a1,80003a22 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003a0a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003a0e:	854e                	mv	a0,s3
    80003a10:	e21ff0ef          	jal	80003830 <iupdate>
}
    80003a14:	70a2                	ld	ra,40(sp)
    80003a16:	7402                	ld	s0,32(sp)
    80003a18:	64e2                	ld	s1,24(sp)
    80003a1a:	6942                	ld	s2,16(sp)
    80003a1c:	69a2                	ld	s3,8(sp)
    80003a1e:	6145                	addi	sp,sp,48
    80003a20:	8082                	ret
    80003a22:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a24:	0009a503          	lw	a0,0(s3)
    80003a28:	825ff0ef          	jal	8000324c <bread>
    80003a2c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003a2e:	05850493          	addi	s1,a0,88
    80003a32:	45850913          	addi	s2,a0,1112
    80003a36:	a021                	j	80003a3e <itrunc+0x6c>
    80003a38:	0491                	addi	s1,s1,4
    80003a3a:	01248963          	beq	s1,s2,80003a4c <itrunc+0x7a>
      if(a[j])
    80003a3e:	408c                	lw	a1,0(s1)
    80003a40:	dde5                	beqz	a1,80003a38 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003a42:	0009a503          	lw	a0,0(s3)
    80003a46:	9fbff0ef          	jal	80003440 <bfree>
    80003a4a:	b7fd                	j	80003a38 <itrunc+0x66>
    brelse(bp);
    80003a4c:	8552                	mv	a0,s4
    80003a4e:	907ff0ef          	jal	80003354 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003a52:	0809a583          	lw	a1,128(s3)
    80003a56:	0009a503          	lw	a0,0(s3)
    80003a5a:	9e7ff0ef          	jal	80003440 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003a5e:	0809a023          	sw	zero,128(s3)
    80003a62:	6a02                	ld	s4,0(sp)
    80003a64:	b75d                	j	80003a0a <itrunc+0x38>

0000000080003a66 <iput>:
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	e426                	sd	s1,8(sp)
    80003a6e:	1000                	addi	s0,sp,32
    80003a70:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a72:	0001c517          	auipc	a0,0x1c
    80003a76:	a6e50513          	addi	a0,a0,-1426 # 8001f4e0 <itable>
    80003a7a:	9aefd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a7e:	4498                	lw	a4,8(s1)
    80003a80:	4785                	li	a5,1
    80003a82:	02f70063          	beq	a4,a5,80003aa2 <iput+0x3c>
  ip->ref--;
    80003a86:	449c                	lw	a5,8(s1)
    80003a88:	37fd                	addiw	a5,a5,-1
    80003a8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a8c:	0001c517          	auipc	a0,0x1c
    80003a90:	a5450513          	addi	a0,a0,-1452 # 8001f4e0 <itable>
    80003a94:	a28fd0ef          	jal	80000cbc <release>
}
    80003a98:	60e2                	ld	ra,24(sp)
    80003a9a:	6442                	ld	s0,16(sp)
    80003a9c:	64a2                	ld	s1,8(sp)
    80003a9e:	6105                	addi	sp,sp,32
    80003aa0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003aa2:	40bc                	lw	a5,64(s1)
    80003aa4:	d3ed                	beqz	a5,80003a86 <iput+0x20>
    80003aa6:	04a49783          	lh	a5,74(s1)
    80003aaa:	fff1                	bnez	a5,80003a86 <iput+0x20>
    80003aac:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003aae:	01048793          	addi	a5,s1,16
    80003ab2:	893e                	mv	s2,a5
    80003ab4:	853e                	mv	a0,a5
    80003ab6:	2cf000ef          	jal	80004584 <acquiresleep>
    release(&itable.lock);
    80003aba:	0001c517          	auipc	a0,0x1c
    80003abe:	a2650513          	addi	a0,a0,-1498 # 8001f4e0 <itable>
    80003ac2:	9fafd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003ac6:	8526                	mv	a0,s1
    80003ac8:	f0bff0ef          	jal	800039d2 <itrunc>
    ip->type = 0;
    80003acc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	d5fff0ef          	jal	80003830 <iupdate>
    ip->valid = 0;
    80003ad6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ada:	854a                	mv	a0,s2
    80003adc:	2ef000ef          	jal	800045ca <releasesleep>
    acquire(&itable.lock);
    80003ae0:	0001c517          	auipc	a0,0x1c
    80003ae4:	a0050513          	addi	a0,a0,-1536 # 8001f4e0 <itable>
    80003ae8:	940fd0ef          	jal	80000c28 <acquire>
    80003aec:	6902                	ld	s2,0(sp)
    80003aee:	bf61                	j	80003a86 <iput+0x20>

0000000080003af0 <iunlockput>:
{
    80003af0:	1101                	addi	sp,sp,-32
    80003af2:	ec06                	sd	ra,24(sp)
    80003af4:	e822                	sd	s0,16(sp)
    80003af6:	e426                	sd	s1,8(sp)
    80003af8:	1000                	addi	s0,sp,32
    80003afa:	84aa                	mv	s1,a0
  iunlock(ip);
    80003afc:	e97ff0ef          	jal	80003992 <iunlock>
  iput(ip);
    80003b00:	8526                	mv	a0,s1
    80003b02:	f65ff0ef          	jal	80003a66 <iput>
}
    80003b06:	60e2                	ld	ra,24(sp)
    80003b08:	6442                	ld	s0,16(sp)
    80003b0a:	64a2                	ld	s1,8(sp)
    80003b0c:	6105                	addi	sp,sp,32
    80003b0e:	8082                	ret

0000000080003b10 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003b10:	0001c717          	auipc	a4,0x1c
    80003b14:	9bc72703          	lw	a4,-1604(a4) # 8001f4cc <sb+0xc>
    80003b18:	4785                	li	a5,1
    80003b1a:	0ae7fe63          	bgeu	a5,a4,80003bd6 <ireclaim+0xc6>
{
    80003b1e:	7139                	addi	sp,sp,-64
    80003b20:	fc06                	sd	ra,56(sp)
    80003b22:	f822                	sd	s0,48(sp)
    80003b24:	f426                	sd	s1,40(sp)
    80003b26:	f04a                	sd	s2,32(sp)
    80003b28:	ec4e                	sd	s3,24(sp)
    80003b2a:	e852                	sd	s4,16(sp)
    80003b2c:	e456                	sd	s5,8(sp)
    80003b2e:	e05a                	sd	s6,0(sp)
    80003b30:	0080                	addi	s0,sp,64
    80003b32:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003b34:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003b36:	0001ca17          	auipc	s4,0x1c
    80003b3a:	98aa0a13          	addi	s4,s4,-1654 # 8001f4c0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003b3e:	00005b17          	auipc	s6,0x5
    80003b42:	97ab0b13          	addi	s6,s6,-1670 # 800084b8 <etext+0x4b8>
    80003b46:	a099                	j	80003b8c <ireclaim+0x7c>
    80003b48:	85ce                	mv	a1,s3
    80003b4a:	855a                	mv	a0,s6
    80003b4c:	9affc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003b50:	85ce                	mv	a1,s3
    80003b52:	8556                	mv	a0,s5
    80003b54:	b1fff0ef          	jal	80003672 <iget>
    80003b58:	89aa                	mv	s3,a0
    brelse(bp);
    80003b5a:	854a                	mv	a0,s2
    80003b5c:	ff8ff0ef          	jal	80003354 <brelse>
    if (ip) {
    80003b60:	00098f63          	beqz	s3,80003b7e <ireclaim+0x6e>
      begin_op();
    80003b64:	78c000ef          	jal	800042f0 <begin_op>
      ilock(ip);
    80003b68:	854e                	mv	a0,s3
    80003b6a:	d7bff0ef          	jal	800038e4 <ilock>
      iunlock(ip);
    80003b6e:	854e                	mv	a0,s3
    80003b70:	e23ff0ef          	jal	80003992 <iunlock>
      iput(ip);
    80003b74:	854e                	mv	a0,s3
    80003b76:	ef1ff0ef          	jal	80003a66 <iput>
      end_op();
    80003b7a:	7e6000ef          	jal	80004360 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003b7e:	0485                	addi	s1,s1,1
    80003b80:	00ca2703          	lw	a4,12(s4)
    80003b84:	0004879b          	sext.w	a5,s1
    80003b88:	02e7fd63          	bgeu	a5,a4,80003bc2 <ireclaim+0xb2>
    80003b8c:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003b90:	0044d593          	srli	a1,s1,0x4
    80003b94:	018a2783          	lw	a5,24(s4)
    80003b98:	9dbd                	addw	a1,a1,a5
    80003b9a:	8556                	mv	a0,s5
    80003b9c:	eb0ff0ef          	jal	8000324c <bread>
    80003ba0:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003ba2:	05850793          	addi	a5,a0,88
    80003ba6:	00f9f713          	andi	a4,s3,15
    80003baa:	071a                	slli	a4,a4,0x6
    80003bac:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003bae:	00079703          	lh	a4,0(a5)
    80003bb2:	c701                	beqz	a4,80003bba <ireclaim+0xaa>
    80003bb4:	00679783          	lh	a5,6(a5)
    80003bb8:	dbc1                	beqz	a5,80003b48 <ireclaim+0x38>
    brelse(bp);
    80003bba:	854a                	mv	a0,s2
    80003bbc:	f98ff0ef          	jal	80003354 <brelse>
    if (ip) {
    80003bc0:	bf7d                	j	80003b7e <ireclaim+0x6e>
}
    80003bc2:	70e2                	ld	ra,56(sp)
    80003bc4:	7442                	ld	s0,48(sp)
    80003bc6:	74a2                	ld	s1,40(sp)
    80003bc8:	7902                	ld	s2,32(sp)
    80003bca:	69e2                	ld	s3,24(sp)
    80003bcc:	6a42                	ld	s4,16(sp)
    80003bce:	6aa2                	ld	s5,8(sp)
    80003bd0:	6b02                	ld	s6,0(sp)
    80003bd2:	6121                	addi	sp,sp,64
    80003bd4:	8082                	ret
    80003bd6:	8082                	ret

0000000080003bd8 <fsinit>:
fsinit(int dev) {
    80003bd8:	1101                	addi	sp,sp,-32
    80003bda:	ec06                	sd	ra,24(sp)
    80003bdc:	e822                	sd	s0,16(sp)
    80003bde:	e426                	sd	s1,8(sp)
    80003be0:	e04a                	sd	s2,0(sp)
    80003be2:	1000                	addi	s0,sp,32
    80003be4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003be6:	4585                	li	a1,1
    80003be8:	e64ff0ef          	jal	8000324c <bread>
    80003bec:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003bee:	02000613          	li	a2,32
    80003bf2:	05850593          	addi	a1,a0,88
    80003bf6:	0001c517          	auipc	a0,0x1c
    80003bfa:	8ca50513          	addi	a0,a0,-1846 # 8001f4c0 <sb>
    80003bfe:	95afd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80003c02:	8526                	mv	a0,s1
    80003c04:	f50ff0ef          	jal	80003354 <brelse>
  if(sb.magic != FSMAGIC)
    80003c08:	0001c717          	auipc	a4,0x1c
    80003c0c:	8b872703          	lw	a4,-1864(a4) # 8001f4c0 <sb>
    80003c10:	102037b7          	lui	a5,0x10203
    80003c14:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c18:	02f71263          	bne	a4,a5,80003c3c <fsinit+0x64>
  initlog(dev, &sb);
    80003c1c:	0001c597          	auipc	a1,0x1c
    80003c20:	8a458593          	addi	a1,a1,-1884 # 8001f4c0 <sb>
    80003c24:	854a                	mv	a0,s2
    80003c26:	648000ef          	jal	8000426e <initlog>
  ireclaim(dev);
    80003c2a:	854a                	mv	a0,s2
    80003c2c:	ee5ff0ef          	jal	80003b10 <ireclaim>
}
    80003c30:	60e2                	ld	ra,24(sp)
    80003c32:	6442                	ld	s0,16(sp)
    80003c34:	64a2                	ld	s1,8(sp)
    80003c36:	6902                	ld	s2,0(sp)
    80003c38:	6105                	addi	sp,sp,32
    80003c3a:	8082                	ret
    panic("invalid file system");
    80003c3c:	00005517          	auipc	a0,0x5
    80003c40:	89c50513          	addi	a0,a0,-1892 # 800084d8 <etext+0x4d8>
    80003c44:	be1fc0ef          	jal	80000824 <panic>

0000000080003c48 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003c48:	1141                	addi	sp,sp,-16
    80003c4a:	e406                	sd	ra,8(sp)
    80003c4c:	e022                	sd	s0,0(sp)
    80003c4e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003c50:	411c                	lw	a5,0(a0)
    80003c52:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003c54:	415c                	lw	a5,4(a0)
    80003c56:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003c58:	04451783          	lh	a5,68(a0)
    80003c5c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003c60:	04a51783          	lh	a5,74(a0)
    80003c64:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003c68:	04c56783          	lwu	a5,76(a0)
    80003c6c:	e99c                	sd	a5,16(a1)
}
    80003c6e:	60a2                	ld	ra,8(sp)
    80003c70:	6402                	ld	s0,0(sp)
    80003c72:	0141                	addi	sp,sp,16
    80003c74:	8082                	ret

0000000080003c76 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c76:	457c                	lw	a5,76(a0)
    80003c78:	0ed7e663          	bltu	a5,a3,80003d64 <readi+0xee>
{
    80003c7c:	7159                	addi	sp,sp,-112
    80003c7e:	f486                	sd	ra,104(sp)
    80003c80:	f0a2                	sd	s0,96(sp)
    80003c82:	eca6                	sd	s1,88(sp)
    80003c84:	e0d2                	sd	s4,64(sp)
    80003c86:	fc56                	sd	s5,56(sp)
    80003c88:	f85a                	sd	s6,48(sp)
    80003c8a:	f45e                	sd	s7,40(sp)
    80003c8c:	1880                	addi	s0,sp,112
    80003c8e:	8b2a                	mv	s6,a0
    80003c90:	8bae                	mv	s7,a1
    80003c92:	8a32                	mv	s4,a2
    80003c94:	84b6                	mv	s1,a3
    80003c96:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003c98:	9f35                	addw	a4,a4,a3
    return 0;
    80003c9a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003c9c:	0ad76b63          	bltu	a4,a3,80003d52 <readi+0xdc>
    80003ca0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003ca2:	00e7f463          	bgeu	a5,a4,80003caa <readi+0x34>
    n = ip->size - off;
    80003ca6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003caa:	080a8b63          	beqz	s5,80003d40 <readi+0xca>
    80003cae:	e8ca                	sd	s2,80(sp)
    80003cb0:	f062                	sd	s8,32(sp)
    80003cb2:	ec66                	sd	s9,24(sp)
    80003cb4:	e86a                	sd	s10,16(sp)
    80003cb6:	e46e                	sd	s11,8(sp)
    80003cb8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003cbe:	5c7d                	li	s8,-1
    80003cc0:	a80d                	j	80003cf2 <readi+0x7c>
    80003cc2:	020d1d93          	slli	s11,s10,0x20
    80003cc6:	020ddd93          	srli	s11,s11,0x20
    80003cca:	05890613          	addi	a2,s2,88
    80003cce:	86ee                	mv	a3,s11
    80003cd0:	963e                	add	a2,a2,a5
    80003cd2:	85d2                	mv	a1,s4
    80003cd4:	855e                	mv	a0,s7
    80003cd6:	ad5fe0ef          	jal	800027aa <either_copyout>
    80003cda:	05850363          	beq	a0,s8,80003d20 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003cde:	854a                	mv	a0,s2
    80003ce0:	e74ff0ef          	jal	80003354 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ce4:	013d09bb          	addw	s3,s10,s3
    80003ce8:	009d04bb          	addw	s1,s10,s1
    80003cec:	9a6e                	add	s4,s4,s11
    80003cee:	0559f363          	bgeu	s3,s5,80003d34 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003cf2:	00a4d59b          	srliw	a1,s1,0xa
    80003cf6:	855a                	mv	a0,s6
    80003cf8:	8bbff0ef          	jal	800035b2 <bmap>
    80003cfc:	85aa                	mv	a1,a0
    if(addr == 0)
    80003cfe:	c139                	beqz	a0,80003d44 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003d00:	000b2503          	lw	a0,0(s6)
    80003d04:	d48ff0ef          	jal	8000324c <bread>
    80003d08:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d0a:	3ff4f793          	andi	a5,s1,1023
    80003d0e:	40fc873b          	subw	a4,s9,a5
    80003d12:	413a86bb          	subw	a3,s5,s3
    80003d16:	8d3a                	mv	s10,a4
    80003d18:	fae6f5e3          	bgeu	a3,a4,80003cc2 <readi+0x4c>
    80003d1c:	8d36                	mv	s10,a3
    80003d1e:	b755                	j	80003cc2 <readi+0x4c>
      brelse(bp);
    80003d20:	854a                	mv	a0,s2
    80003d22:	e32ff0ef          	jal	80003354 <brelse>
      tot = -1;
    80003d26:	59fd                	li	s3,-1
      break;
    80003d28:	6946                	ld	s2,80(sp)
    80003d2a:	7c02                	ld	s8,32(sp)
    80003d2c:	6ce2                	ld	s9,24(sp)
    80003d2e:	6d42                	ld	s10,16(sp)
    80003d30:	6da2                	ld	s11,8(sp)
    80003d32:	a831                	j	80003d4e <readi+0xd8>
    80003d34:	6946                	ld	s2,80(sp)
    80003d36:	7c02                	ld	s8,32(sp)
    80003d38:	6ce2                	ld	s9,24(sp)
    80003d3a:	6d42                	ld	s10,16(sp)
    80003d3c:	6da2                	ld	s11,8(sp)
    80003d3e:	a801                	j	80003d4e <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d40:	89d6                	mv	s3,s5
    80003d42:	a031                	j	80003d4e <readi+0xd8>
    80003d44:	6946                	ld	s2,80(sp)
    80003d46:	7c02                	ld	s8,32(sp)
    80003d48:	6ce2                	ld	s9,24(sp)
    80003d4a:	6d42                	ld	s10,16(sp)
    80003d4c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003d4e:	854e                	mv	a0,s3
    80003d50:	69a6                	ld	s3,72(sp)
}
    80003d52:	70a6                	ld	ra,104(sp)
    80003d54:	7406                	ld	s0,96(sp)
    80003d56:	64e6                	ld	s1,88(sp)
    80003d58:	6a06                	ld	s4,64(sp)
    80003d5a:	7ae2                	ld	s5,56(sp)
    80003d5c:	7b42                	ld	s6,48(sp)
    80003d5e:	7ba2                	ld	s7,40(sp)
    80003d60:	6165                	addi	sp,sp,112
    80003d62:	8082                	ret
    return 0;
    80003d64:	4501                	li	a0,0
}
    80003d66:	8082                	ret

0000000080003d68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d68:	457c                	lw	a5,76(a0)
    80003d6a:	0ed7eb63          	bltu	a5,a3,80003e60 <writei+0xf8>
{
    80003d6e:	7159                	addi	sp,sp,-112
    80003d70:	f486                	sd	ra,104(sp)
    80003d72:	f0a2                	sd	s0,96(sp)
    80003d74:	e8ca                	sd	s2,80(sp)
    80003d76:	e0d2                	sd	s4,64(sp)
    80003d78:	fc56                	sd	s5,56(sp)
    80003d7a:	f85a                	sd	s6,48(sp)
    80003d7c:	f45e                	sd	s7,40(sp)
    80003d7e:	1880                	addi	s0,sp,112
    80003d80:	8aaa                	mv	s5,a0
    80003d82:	8bae                	mv	s7,a1
    80003d84:	8a32                	mv	s4,a2
    80003d86:	8936                	mv	s2,a3
    80003d88:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d8a:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003d8e:	00043737          	lui	a4,0x43
    80003d92:	0cf76963          	bltu	a4,a5,80003e64 <writei+0xfc>
    80003d96:	0cd7e763          	bltu	a5,a3,80003e64 <writei+0xfc>
    80003d9a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d9c:	0a0b0a63          	beqz	s6,80003e50 <writei+0xe8>
    80003da0:	eca6                	sd	s1,88(sp)
    80003da2:	f062                	sd	s8,32(sp)
    80003da4:	ec66                	sd	s9,24(sp)
    80003da6:	e86a                	sd	s10,16(sp)
    80003da8:	e46e                	sd	s11,8(sp)
    80003daa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003dac:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003db0:	5c7d                	li	s8,-1
    80003db2:	a825                	j	80003dea <writei+0x82>
    80003db4:	020d1d93          	slli	s11,s10,0x20
    80003db8:	020ddd93          	srli	s11,s11,0x20
    80003dbc:	05848513          	addi	a0,s1,88
    80003dc0:	86ee                	mv	a3,s11
    80003dc2:	8652                	mv	a2,s4
    80003dc4:	85de                	mv	a1,s7
    80003dc6:	953e                	add	a0,a0,a5
    80003dc8:	a2ffe0ef          	jal	800027f6 <either_copyin>
    80003dcc:	05850663          	beq	a0,s8,80003e18 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003dd0:	8526                	mv	a0,s1
    80003dd2:	6b8000ef          	jal	8000448a <log_write>
    brelse(bp);
    80003dd6:	8526                	mv	a0,s1
    80003dd8:	d7cff0ef          	jal	80003354 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ddc:	013d09bb          	addw	s3,s10,s3
    80003de0:	012d093b          	addw	s2,s10,s2
    80003de4:	9a6e                	add	s4,s4,s11
    80003de6:	0369fc63          	bgeu	s3,s6,80003e1e <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003dea:	00a9559b          	srliw	a1,s2,0xa
    80003dee:	8556                	mv	a0,s5
    80003df0:	fc2ff0ef          	jal	800035b2 <bmap>
    80003df4:	85aa                	mv	a1,a0
    if(addr == 0)
    80003df6:	c505                	beqz	a0,80003e1e <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003df8:	000aa503          	lw	a0,0(s5)
    80003dfc:	c50ff0ef          	jal	8000324c <bread>
    80003e00:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e02:	3ff97793          	andi	a5,s2,1023
    80003e06:	40fc873b          	subw	a4,s9,a5
    80003e0a:	413b06bb          	subw	a3,s6,s3
    80003e0e:	8d3a                	mv	s10,a4
    80003e10:	fae6f2e3          	bgeu	a3,a4,80003db4 <writei+0x4c>
    80003e14:	8d36                	mv	s10,a3
    80003e16:	bf79                	j	80003db4 <writei+0x4c>
      brelse(bp);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	d3aff0ef          	jal	80003354 <brelse>
  }

  if(off > ip->size)
    80003e1e:	04caa783          	lw	a5,76(s5)
    80003e22:	0327f963          	bgeu	a5,s2,80003e54 <writei+0xec>
    ip->size = off;
    80003e26:	052aa623          	sw	s2,76(s5)
    80003e2a:	64e6                	ld	s1,88(sp)
    80003e2c:	7c02                	ld	s8,32(sp)
    80003e2e:	6ce2                	ld	s9,24(sp)
    80003e30:	6d42                	ld	s10,16(sp)
    80003e32:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003e34:	8556                	mv	a0,s5
    80003e36:	9fbff0ef          	jal	80003830 <iupdate>

  return tot;
    80003e3a:	854e                	mv	a0,s3
    80003e3c:	69a6                	ld	s3,72(sp)
}
    80003e3e:	70a6                	ld	ra,104(sp)
    80003e40:	7406                	ld	s0,96(sp)
    80003e42:	6946                	ld	s2,80(sp)
    80003e44:	6a06                	ld	s4,64(sp)
    80003e46:	7ae2                	ld	s5,56(sp)
    80003e48:	7b42                	ld	s6,48(sp)
    80003e4a:	7ba2                	ld	s7,40(sp)
    80003e4c:	6165                	addi	sp,sp,112
    80003e4e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e50:	89da                	mv	s3,s6
    80003e52:	b7cd                	j	80003e34 <writei+0xcc>
    80003e54:	64e6                	ld	s1,88(sp)
    80003e56:	7c02                	ld	s8,32(sp)
    80003e58:	6ce2                	ld	s9,24(sp)
    80003e5a:	6d42                	ld	s10,16(sp)
    80003e5c:	6da2                	ld	s11,8(sp)
    80003e5e:	bfd9                	j	80003e34 <writei+0xcc>
    return -1;
    80003e60:	557d                	li	a0,-1
}
    80003e62:	8082                	ret
    return -1;
    80003e64:	557d                	li	a0,-1
    80003e66:	bfe1                	j	80003e3e <writei+0xd6>

0000000080003e68 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003e68:	1141                	addi	sp,sp,-16
    80003e6a:	e406                	sd	ra,8(sp)
    80003e6c:	e022                	sd	s0,0(sp)
    80003e6e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003e70:	4639                	li	a2,14
    80003e72:	f5bfc0ef          	jal	80000dcc <strncmp>
}
    80003e76:	60a2                	ld	ra,8(sp)
    80003e78:	6402                	ld	s0,0(sp)
    80003e7a:	0141                	addi	sp,sp,16
    80003e7c:	8082                	ret

0000000080003e7e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003e7e:	711d                	addi	sp,sp,-96
    80003e80:	ec86                	sd	ra,88(sp)
    80003e82:	e8a2                	sd	s0,80(sp)
    80003e84:	e4a6                	sd	s1,72(sp)
    80003e86:	e0ca                	sd	s2,64(sp)
    80003e88:	fc4e                	sd	s3,56(sp)
    80003e8a:	f852                	sd	s4,48(sp)
    80003e8c:	f456                	sd	s5,40(sp)
    80003e8e:	f05a                	sd	s6,32(sp)
    80003e90:	ec5e                	sd	s7,24(sp)
    80003e92:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003e94:	04451703          	lh	a4,68(a0)
    80003e98:	4785                	li	a5,1
    80003e9a:	00f71f63          	bne	a4,a5,80003eb8 <dirlookup+0x3a>
    80003e9e:	892a                	mv	s2,a0
    80003ea0:	8aae                	mv	s5,a1
    80003ea2:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ea4:	457c                	lw	a5,76(a0)
    80003ea6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ea8:	fa040a13          	addi	s4,s0,-96
    80003eac:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003eae:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003eb2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003eb4:	e39d                	bnez	a5,80003eda <dirlookup+0x5c>
    80003eb6:	a8b9                	j	80003f14 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003eb8:	00004517          	auipc	a0,0x4
    80003ebc:	63850513          	addi	a0,a0,1592 # 800084f0 <etext+0x4f0>
    80003ec0:	965fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80003ec4:	00004517          	auipc	a0,0x4
    80003ec8:	64450513          	addi	a0,a0,1604 # 80008508 <etext+0x508>
    80003ecc:	959fc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ed0:	24c1                	addiw	s1,s1,16
    80003ed2:	04c92783          	lw	a5,76(s2)
    80003ed6:	02f4fe63          	bgeu	s1,a5,80003f12 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eda:	874e                	mv	a4,s3
    80003edc:	86a6                	mv	a3,s1
    80003ede:	8652                	mv	a2,s4
    80003ee0:	4581                	li	a1,0
    80003ee2:	854a                	mv	a0,s2
    80003ee4:	d93ff0ef          	jal	80003c76 <readi>
    80003ee8:	fd351ee3          	bne	a0,s3,80003ec4 <dirlookup+0x46>
    if(de.inum == 0)
    80003eec:	fa045783          	lhu	a5,-96(s0)
    80003ef0:	d3e5                	beqz	a5,80003ed0 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003ef2:	85da                	mv	a1,s6
    80003ef4:	8556                	mv	a0,s5
    80003ef6:	f73ff0ef          	jal	80003e68 <namecmp>
    80003efa:	f979                	bnez	a0,80003ed0 <dirlookup+0x52>
      if(poff)
    80003efc:	000b8463          	beqz	s7,80003f04 <dirlookup+0x86>
        *poff = off;
    80003f00:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003f04:	fa045583          	lhu	a1,-96(s0)
    80003f08:	00092503          	lw	a0,0(s2)
    80003f0c:	f66ff0ef          	jal	80003672 <iget>
    80003f10:	a011                	j	80003f14 <dirlookup+0x96>
  return 0;
    80003f12:	4501                	li	a0,0
}
    80003f14:	60e6                	ld	ra,88(sp)
    80003f16:	6446                	ld	s0,80(sp)
    80003f18:	64a6                	ld	s1,72(sp)
    80003f1a:	6906                	ld	s2,64(sp)
    80003f1c:	79e2                	ld	s3,56(sp)
    80003f1e:	7a42                	ld	s4,48(sp)
    80003f20:	7aa2                	ld	s5,40(sp)
    80003f22:	7b02                	ld	s6,32(sp)
    80003f24:	6be2                	ld	s7,24(sp)
    80003f26:	6125                	addi	sp,sp,96
    80003f28:	8082                	ret

0000000080003f2a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003f2a:	711d                	addi	sp,sp,-96
    80003f2c:	ec86                	sd	ra,88(sp)
    80003f2e:	e8a2                	sd	s0,80(sp)
    80003f30:	e4a6                	sd	s1,72(sp)
    80003f32:	e0ca                	sd	s2,64(sp)
    80003f34:	fc4e                	sd	s3,56(sp)
    80003f36:	f852                	sd	s4,48(sp)
    80003f38:	f456                	sd	s5,40(sp)
    80003f3a:	f05a                	sd	s6,32(sp)
    80003f3c:	ec5e                	sd	s7,24(sp)
    80003f3e:	e862                	sd	s8,16(sp)
    80003f40:	e466                	sd	s9,8(sp)
    80003f42:	e06a                	sd	s10,0(sp)
    80003f44:	1080                	addi	s0,sp,96
    80003f46:	84aa                	mv	s1,a0
    80003f48:	8b2e                	mv	s6,a1
    80003f4a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003f4c:	00054703          	lbu	a4,0(a0)
    80003f50:	02f00793          	li	a5,47
    80003f54:	00f70f63          	beq	a4,a5,80003f72 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003f58:	9c3fd0ef          	jal	8000191a <myproc>
    80003f5c:	14853503          	ld	a0,328(a0)
    80003f60:	94fff0ef          	jal	800038ae <idup>
    80003f64:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003f66:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003f6a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003f6c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003f6e:	4b85                	li	s7,1
    80003f70:	a879                	j	8000400e <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003f72:	4585                	li	a1,1
    80003f74:	852e                	mv	a0,a1
    80003f76:	efcff0ef          	jal	80003672 <iget>
    80003f7a:	8a2a                	mv	s4,a0
    80003f7c:	b7ed                	j	80003f66 <namex+0x3c>
      iunlockput(ip);
    80003f7e:	8552                	mv	a0,s4
    80003f80:	b71ff0ef          	jal	80003af0 <iunlockput>
      return 0;
    80003f84:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003f86:	8552                	mv	a0,s4
    80003f88:	60e6                	ld	ra,88(sp)
    80003f8a:	6446                	ld	s0,80(sp)
    80003f8c:	64a6                	ld	s1,72(sp)
    80003f8e:	6906                	ld	s2,64(sp)
    80003f90:	79e2                	ld	s3,56(sp)
    80003f92:	7a42                	ld	s4,48(sp)
    80003f94:	7aa2                	ld	s5,40(sp)
    80003f96:	7b02                	ld	s6,32(sp)
    80003f98:	6be2                	ld	s7,24(sp)
    80003f9a:	6c42                	ld	s8,16(sp)
    80003f9c:	6ca2                	ld	s9,8(sp)
    80003f9e:	6d02                	ld	s10,0(sp)
    80003fa0:	6125                	addi	sp,sp,96
    80003fa2:	8082                	ret
      iunlock(ip);
    80003fa4:	8552                	mv	a0,s4
    80003fa6:	9edff0ef          	jal	80003992 <iunlock>
      return ip;
    80003faa:	bff1                	j	80003f86 <namex+0x5c>
      iunlockput(ip);
    80003fac:	8552                	mv	a0,s4
    80003fae:	b43ff0ef          	jal	80003af0 <iunlockput>
      return 0;
    80003fb2:	8a4a                	mv	s4,s2
    80003fb4:	bfc9                	j	80003f86 <namex+0x5c>
  len = path - s;
    80003fb6:	40990633          	sub	a2,s2,s1
    80003fba:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003fbe:	09ac5463          	bge	s8,s10,80004046 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003fc2:	8666                	mv	a2,s9
    80003fc4:	85a6                	mv	a1,s1
    80003fc6:	8556                	mv	a0,s5
    80003fc8:	d91fc0ef          	jal	80000d58 <memmove>
    80003fcc:	84ca                	mv	s1,s2
  while(*path == '/')
    80003fce:	0004c783          	lbu	a5,0(s1)
    80003fd2:	01379763          	bne	a5,s3,80003fe0 <namex+0xb6>
    path++;
    80003fd6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003fd8:	0004c783          	lbu	a5,0(s1)
    80003fdc:	ff378de3          	beq	a5,s3,80003fd6 <namex+0xac>
    ilock(ip);
    80003fe0:	8552                	mv	a0,s4
    80003fe2:	903ff0ef          	jal	800038e4 <ilock>
    if(ip->type != T_DIR){
    80003fe6:	044a1783          	lh	a5,68(s4)
    80003fea:	f9779ae3          	bne	a5,s7,80003f7e <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003fee:	000b0563          	beqz	s6,80003ff8 <namex+0xce>
    80003ff2:	0004c783          	lbu	a5,0(s1)
    80003ff6:	d7dd                	beqz	a5,80003fa4 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ff8:	4601                	li	a2,0
    80003ffa:	85d6                	mv	a1,s5
    80003ffc:	8552                	mv	a0,s4
    80003ffe:	e81ff0ef          	jal	80003e7e <dirlookup>
    80004002:	892a                	mv	s2,a0
    80004004:	d545                	beqz	a0,80003fac <namex+0x82>
    iunlockput(ip);
    80004006:	8552                	mv	a0,s4
    80004008:	ae9ff0ef          	jal	80003af0 <iunlockput>
    ip = next;
    8000400c:	8a4a                	mv	s4,s2
  while(*path == '/')
    8000400e:	0004c783          	lbu	a5,0(s1)
    80004012:	01379763          	bne	a5,s3,80004020 <namex+0xf6>
    path++;
    80004016:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004018:	0004c783          	lbu	a5,0(s1)
    8000401c:	ff378de3          	beq	a5,s3,80004016 <namex+0xec>
  if(*path == 0)
    80004020:	cf8d                	beqz	a5,8000405a <namex+0x130>
  while(*path != '/' && *path != 0)
    80004022:	0004c783          	lbu	a5,0(s1)
    80004026:	fd178713          	addi	a4,a5,-47
    8000402a:	cb19                	beqz	a4,80004040 <namex+0x116>
    8000402c:	cb91                	beqz	a5,80004040 <namex+0x116>
    8000402e:	8926                	mv	s2,s1
    path++;
    80004030:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80004032:	00094783          	lbu	a5,0(s2)
    80004036:	fd178713          	addi	a4,a5,-47
    8000403a:	df35                	beqz	a4,80003fb6 <namex+0x8c>
    8000403c:	fbf5                	bnez	a5,80004030 <namex+0x106>
    8000403e:	bfa5                	j	80003fb6 <namex+0x8c>
    80004040:	8926                	mv	s2,s1
  len = path - s;
    80004042:	4d01                	li	s10,0
    80004044:	4601                	li	a2,0
    memmove(name, s, len);
    80004046:	2601                	sext.w	a2,a2
    80004048:	85a6                	mv	a1,s1
    8000404a:	8556                	mv	a0,s5
    8000404c:	d0dfc0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80004050:	9d56                	add	s10,s10,s5
    80004052:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdce38>
    80004056:	84ca                	mv	s1,s2
    80004058:	bf9d                	j	80003fce <namex+0xa4>
  if(nameiparent){
    8000405a:	f20b06e3          	beqz	s6,80003f86 <namex+0x5c>
    iput(ip);
    8000405e:	8552                	mv	a0,s4
    80004060:	a07ff0ef          	jal	80003a66 <iput>
    return 0;
    80004064:	4a01                	li	s4,0
    80004066:	b705                	j	80003f86 <namex+0x5c>

0000000080004068 <dirlink>:
{
    80004068:	715d                	addi	sp,sp,-80
    8000406a:	e486                	sd	ra,72(sp)
    8000406c:	e0a2                	sd	s0,64(sp)
    8000406e:	f84a                	sd	s2,48(sp)
    80004070:	ec56                	sd	s5,24(sp)
    80004072:	e85a                	sd	s6,16(sp)
    80004074:	0880                	addi	s0,sp,80
    80004076:	892a                	mv	s2,a0
    80004078:	8aae                	mv	s5,a1
    8000407a:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000407c:	4601                	li	a2,0
    8000407e:	e01ff0ef          	jal	80003e7e <dirlookup>
    80004082:	ed1d                	bnez	a0,800040c0 <dirlink+0x58>
    80004084:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004086:	04c92483          	lw	s1,76(s2)
    8000408a:	c4b9                	beqz	s1,800040d8 <dirlink+0x70>
    8000408c:	f44e                	sd	s3,40(sp)
    8000408e:	f052                	sd	s4,32(sp)
    80004090:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004092:	fb040a13          	addi	s4,s0,-80
    80004096:	49c1                	li	s3,16
    80004098:	874e                	mv	a4,s3
    8000409a:	86a6                	mv	a3,s1
    8000409c:	8652                	mv	a2,s4
    8000409e:	4581                	li	a1,0
    800040a0:	854a                	mv	a0,s2
    800040a2:	bd5ff0ef          	jal	80003c76 <readi>
    800040a6:	03351163          	bne	a0,s3,800040c8 <dirlink+0x60>
    if(de.inum == 0)
    800040aa:	fb045783          	lhu	a5,-80(s0)
    800040ae:	c39d                	beqz	a5,800040d4 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040b0:	24c1                	addiw	s1,s1,16
    800040b2:	04c92783          	lw	a5,76(s2)
    800040b6:	fef4e1e3          	bltu	s1,a5,80004098 <dirlink+0x30>
    800040ba:	79a2                	ld	s3,40(sp)
    800040bc:	7a02                	ld	s4,32(sp)
    800040be:	a829                	j	800040d8 <dirlink+0x70>
    iput(ip);
    800040c0:	9a7ff0ef          	jal	80003a66 <iput>
    return -1;
    800040c4:	557d                	li	a0,-1
    800040c6:	a83d                	j	80004104 <dirlink+0x9c>
      panic("dirlink read");
    800040c8:	00004517          	auipc	a0,0x4
    800040cc:	45050513          	addi	a0,a0,1104 # 80008518 <etext+0x518>
    800040d0:	f54fc0ef          	jal	80000824 <panic>
    800040d4:	79a2                	ld	s3,40(sp)
    800040d6:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800040d8:	4639                	li	a2,14
    800040da:	85d6                	mv	a1,s5
    800040dc:	fb240513          	addi	a0,s0,-78
    800040e0:	d27fc0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    800040e4:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040e8:	4741                	li	a4,16
    800040ea:	86a6                	mv	a3,s1
    800040ec:	fb040613          	addi	a2,s0,-80
    800040f0:	4581                	li	a1,0
    800040f2:	854a                	mv	a0,s2
    800040f4:	c75ff0ef          	jal	80003d68 <writei>
    800040f8:	1541                	addi	a0,a0,-16
    800040fa:	00a03533          	snez	a0,a0
    800040fe:	40a0053b          	negw	a0,a0
    80004102:	74e2                	ld	s1,56(sp)
}
    80004104:	60a6                	ld	ra,72(sp)
    80004106:	6406                	ld	s0,64(sp)
    80004108:	7942                	ld	s2,48(sp)
    8000410a:	6ae2                	ld	s5,24(sp)
    8000410c:	6b42                	ld	s6,16(sp)
    8000410e:	6161                	addi	sp,sp,80
    80004110:	8082                	ret

0000000080004112 <namei>:

struct inode*
namei(char *path)
{
    80004112:	1101                	addi	sp,sp,-32
    80004114:	ec06                	sd	ra,24(sp)
    80004116:	e822                	sd	s0,16(sp)
    80004118:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000411a:	fe040613          	addi	a2,s0,-32
    8000411e:	4581                	li	a1,0
    80004120:	e0bff0ef          	jal	80003f2a <namex>
}
    80004124:	60e2                	ld	ra,24(sp)
    80004126:	6442                	ld	s0,16(sp)
    80004128:	6105                	addi	sp,sp,32
    8000412a:	8082                	ret

000000008000412c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000412c:	1141                	addi	sp,sp,-16
    8000412e:	e406                	sd	ra,8(sp)
    80004130:	e022                	sd	s0,0(sp)
    80004132:	0800                	addi	s0,sp,16
    80004134:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004136:	4585                	li	a1,1
    80004138:	df3ff0ef          	jal	80003f2a <namex>
}
    8000413c:	60a2                	ld	ra,8(sp)
    8000413e:	6402                	ld	s0,0(sp)
    80004140:	0141                	addi	sp,sp,16
    80004142:	8082                	ret

0000000080004144 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004144:	1101                	addi	sp,sp,-32
    80004146:	ec06                	sd	ra,24(sp)
    80004148:	e822                	sd	s0,16(sp)
    8000414a:	e426                	sd	s1,8(sp)
    8000414c:	e04a                	sd	s2,0(sp)
    8000414e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004150:	0001d917          	auipc	s2,0x1d
    80004154:	e3890913          	addi	s2,s2,-456 # 80020f88 <log>
    80004158:	01892583          	lw	a1,24(s2)
    8000415c:	02492503          	lw	a0,36(s2)
    80004160:	8ecff0ef          	jal	8000324c <bread>
    80004164:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004166:	02892603          	lw	a2,40(s2)
    8000416a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000416c:	00c05f63          	blez	a2,8000418a <write_head+0x46>
    80004170:	0001d717          	auipc	a4,0x1d
    80004174:	e4470713          	addi	a4,a4,-444 # 80020fb4 <log+0x2c>
    80004178:	87aa                	mv	a5,a0
    8000417a:	060a                	slli	a2,a2,0x2
    8000417c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000417e:	4314                	lw	a3,0(a4)
    80004180:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004182:	0711                	addi	a4,a4,4
    80004184:	0791                	addi	a5,a5,4
    80004186:	fec79ce3          	bne	a5,a2,8000417e <write_head+0x3a>
  }
  bwrite(buf);
    8000418a:	8526                	mv	a0,s1
    8000418c:	996ff0ef          	jal	80003322 <bwrite>
  brelse(buf);
    80004190:	8526                	mv	a0,s1
    80004192:	9c2ff0ef          	jal	80003354 <brelse>
}
    80004196:	60e2                	ld	ra,24(sp)
    80004198:	6442                	ld	s0,16(sp)
    8000419a:	64a2                	ld	s1,8(sp)
    8000419c:	6902                	ld	s2,0(sp)
    8000419e:	6105                	addi	sp,sp,32
    800041a0:	8082                	ret

00000000800041a2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800041a2:	0001d797          	auipc	a5,0x1d
    800041a6:	e0e7a783          	lw	a5,-498(a5) # 80020fb0 <log+0x28>
    800041aa:	0cf05163          	blez	a5,8000426c <install_trans+0xca>
{
    800041ae:	715d                	addi	sp,sp,-80
    800041b0:	e486                	sd	ra,72(sp)
    800041b2:	e0a2                	sd	s0,64(sp)
    800041b4:	fc26                	sd	s1,56(sp)
    800041b6:	f84a                	sd	s2,48(sp)
    800041b8:	f44e                	sd	s3,40(sp)
    800041ba:	f052                	sd	s4,32(sp)
    800041bc:	ec56                	sd	s5,24(sp)
    800041be:	e85a                	sd	s6,16(sp)
    800041c0:	e45e                	sd	s7,8(sp)
    800041c2:	e062                	sd	s8,0(sp)
    800041c4:	0880                	addi	s0,sp,80
    800041c6:	8b2a                	mv	s6,a0
    800041c8:	0001da97          	auipc	s5,0x1d
    800041cc:	deca8a93          	addi	s5,s5,-532 # 80020fb4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041d0:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800041d2:	00004c17          	auipc	s8,0x4
    800041d6:	356c0c13          	addi	s8,s8,854 # 80008528 <etext+0x528>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800041da:	0001da17          	auipc	s4,0x1d
    800041de:	daea0a13          	addi	s4,s4,-594 # 80020f88 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800041e2:	40000b93          	li	s7,1024
    800041e6:	a025                	j	8000420e <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800041e8:	000aa603          	lw	a2,0(s5)
    800041ec:	85ce                	mv	a1,s3
    800041ee:	8562                	mv	a0,s8
    800041f0:	b0afc0ef          	jal	800004fa <printf>
    800041f4:	a839                	j	80004212 <install_trans+0x70>
    brelse(lbuf);
    800041f6:	854a                	mv	a0,s2
    800041f8:	95cff0ef          	jal	80003354 <brelse>
    brelse(dbuf);
    800041fc:	8526                	mv	a0,s1
    800041fe:	956ff0ef          	jal	80003354 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004202:	2985                	addiw	s3,s3,1
    80004204:	0a91                	addi	s5,s5,4
    80004206:	028a2783          	lw	a5,40(s4)
    8000420a:	04f9d563          	bge	s3,a5,80004254 <install_trans+0xb2>
    if(recovering) {
    8000420e:	fc0b1de3          	bnez	s6,800041e8 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004212:	018a2583          	lw	a1,24(s4)
    80004216:	013585bb          	addw	a1,a1,s3
    8000421a:	2585                	addiw	a1,a1,1
    8000421c:	024a2503          	lw	a0,36(s4)
    80004220:	82cff0ef          	jal	8000324c <bread>
    80004224:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004226:	000aa583          	lw	a1,0(s5)
    8000422a:	024a2503          	lw	a0,36(s4)
    8000422e:	81eff0ef          	jal	8000324c <bread>
    80004232:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004234:	865e                	mv	a2,s7
    80004236:	05890593          	addi	a1,s2,88
    8000423a:	05850513          	addi	a0,a0,88
    8000423e:	b1bfc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004242:	8526                	mv	a0,s1
    80004244:	8deff0ef          	jal	80003322 <bwrite>
    if(recovering == 0)
    80004248:	fa0b17e3          	bnez	s6,800041f6 <install_trans+0x54>
      bunpin(dbuf);
    8000424c:	8526                	mv	a0,s1
    8000424e:	9beff0ef          	jal	8000340c <bunpin>
    80004252:	b755                	j	800041f6 <install_trans+0x54>
}
    80004254:	60a6                	ld	ra,72(sp)
    80004256:	6406                	ld	s0,64(sp)
    80004258:	74e2                	ld	s1,56(sp)
    8000425a:	7942                	ld	s2,48(sp)
    8000425c:	79a2                	ld	s3,40(sp)
    8000425e:	7a02                	ld	s4,32(sp)
    80004260:	6ae2                	ld	s5,24(sp)
    80004262:	6b42                	ld	s6,16(sp)
    80004264:	6ba2                	ld	s7,8(sp)
    80004266:	6c02                	ld	s8,0(sp)
    80004268:	6161                	addi	sp,sp,80
    8000426a:	8082                	ret
    8000426c:	8082                	ret

000000008000426e <initlog>:
{
    8000426e:	7179                	addi	sp,sp,-48
    80004270:	f406                	sd	ra,40(sp)
    80004272:	f022                	sd	s0,32(sp)
    80004274:	ec26                	sd	s1,24(sp)
    80004276:	e84a                	sd	s2,16(sp)
    80004278:	e44e                	sd	s3,8(sp)
    8000427a:	1800                	addi	s0,sp,48
    8000427c:	84aa                	mv	s1,a0
    8000427e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004280:	0001d917          	auipc	s2,0x1d
    80004284:	d0890913          	addi	s2,s2,-760 # 80020f88 <log>
    80004288:	00004597          	auipc	a1,0x4
    8000428c:	2c058593          	addi	a1,a1,704 # 80008548 <etext+0x548>
    80004290:	854a                	mv	a0,s2
    80004292:	90dfc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80004296:	0149a583          	lw	a1,20(s3)
    8000429a:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    8000429e:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    800042a2:	8526                	mv	a0,s1
    800042a4:	fa9fe0ef          	jal	8000324c <bread>
  log.lh.n = lh->n;
    800042a8:	4d30                	lw	a2,88(a0)
    800042aa:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    800042ae:	00c05f63          	blez	a2,800042cc <initlog+0x5e>
    800042b2:	87aa                	mv	a5,a0
    800042b4:	0001d717          	auipc	a4,0x1d
    800042b8:	d0070713          	addi	a4,a4,-768 # 80020fb4 <log+0x2c>
    800042bc:	060a                	slli	a2,a2,0x2
    800042be:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800042c0:	4ff4                	lw	a3,92(a5)
    800042c2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800042c4:	0791                	addi	a5,a5,4
    800042c6:	0711                	addi	a4,a4,4
    800042c8:	fec79ce3          	bne	a5,a2,800042c0 <initlog+0x52>
  brelse(buf);
    800042cc:	888ff0ef          	jal	80003354 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800042d0:	4505                	li	a0,1
    800042d2:	ed1ff0ef          	jal	800041a2 <install_trans>
  log.lh.n = 0;
    800042d6:	0001d797          	auipc	a5,0x1d
    800042da:	cc07ad23          	sw	zero,-806(a5) # 80020fb0 <log+0x28>
  write_head(); // clear the log
    800042de:	e67ff0ef          	jal	80004144 <write_head>
}
    800042e2:	70a2                	ld	ra,40(sp)
    800042e4:	7402                	ld	s0,32(sp)
    800042e6:	64e2                	ld	s1,24(sp)
    800042e8:	6942                	ld	s2,16(sp)
    800042ea:	69a2                	ld	s3,8(sp)
    800042ec:	6145                	addi	sp,sp,48
    800042ee:	8082                	ret

00000000800042f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800042f0:	1101                	addi	sp,sp,-32
    800042f2:	ec06                	sd	ra,24(sp)
    800042f4:	e822                	sd	s0,16(sp)
    800042f6:	e426                	sd	s1,8(sp)
    800042f8:	e04a                	sd	s2,0(sp)
    800042fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800042fc:	0001d517          	auipc	a0,0x1d
    80004300:	c8c50513          	addi	a0,a0,-884 # 80020f88 <log>
    80004304:	925fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80004308:	0001d497          	auipc	s1,0x1d
    8000430c:	c8048493          	addi	s1,s1,-896 # 80020f88 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004310:	4979                	li	s2,30
    80004312:	a029                	j	8000431c <begin_op+0x2c>
      sleep(&log, &log.lock);
    80004314:	85a6                	mv	a1,s1
    80004316:	8526                	mv	a0,s1
    80004318:	ee5fd0ef          	jal	800021fc <sleep>
    if(log.committing){
    8000431c:	509c                	lw	a5,32(s1)
    8000431e:	fbfd                	bnez	a5,80004314 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004320:	4cd8                	lw	a4,28(s1)
    80004322:	2705                	addiw	a4,a4,1
    80004324:	0027179b          	slliw	a5,a4,0x2
    80004328:	9fb9                	addw	a5,a5,a4
    8000432a:	0017979b          	slliw	a5,a5,0x1
    8000432e:	5494                	lw	a3,40(s1)
    80004330:	9fb5                	addw	a5,a5,a3
    80004332:	00f95763          	bge	s2,a5,80004340 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004336:	85a6                	mv	a1,s1
    80004338:	8526                	mv	a0,s1
    8000433a:	ec3fd0ef          	jal	800021fc <sleep>
    8000433e:	bff9                	j	8000431c <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004340:	0001d797          	auipc	a5,0x1d
    80004344:	c6e7a223          	sw	a4,-924(a5) # 80020fa4 <log+0x1c>
      release(&log.lock);
    80004348:	0001d517          	auipc	a0,0x1d
    8000434c:	c4050513          	addi	a0,a0,-960 # 80020f88 <log>
    80004350:	96dfc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80004354:	60e2                	ld	ra,24(sp)
    80004356:	6442                	ld	s0,16(sp)
    80004358:	64a2                	ld	s1,8(sp)
    8000435a:	6902                	ld	s2,0(sp)
    8000435c:	6105                	addi	sp,sp,32
    8000435e:	8082                	ret

0000000080004360 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004360:	7139                	addi	sp,sp,-64
    80004362:	fc06                	sd	ra,56(sp)
    80004364:	f822                	sd	s0,48(sp)
    80004366:	f426                	sd	s1,40(sp)
    80004368:	f04a                	sd	s2,32(sp)
    8000436a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000436c:	0001d497          	auipc	s1,0x1d
    80004370:	c1c48493          	addi	s1,s1,-996 # 80020f88 <log>
    80004374:	8526                	mv	a0,s1
    80004376:	8b3fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    8000437a:	4cdc                	lw	a5,28(s1)
    8000437c:	37fd                	addiw	a5,a5,-1
    8000437e:	893e                	mv	s2,a5
    80004380:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80004382:	509c                	lw	a5,32(s1)
    80004384:	e7b1                	bnez	a5,800043d0 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80004386:	04091e63          	bnez	s2,800043e2 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    8000438a:	0001d497          	auipc	s1,0x1d
    8000438e:	bfe48493          	addi	s1,s1,-1026 # 80020f88 <log>
    80004392:	4785                	li	a5,1
    80004394:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004396:	8526                	mv	a0,s1
    80004398:	925fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000439c:	549c                	lw	a5,40(s1)
    8000439e:	06f04463          	bgtz	a5,80004406 <end_op+0xa6>
    acquire(&log.lock);
    800043a2:	0001d517          	auipc	a0,0x1d
    800043a6:	be650513          	addi	a0,a0,-1050 # 80020f88 <log>
    800043aa:	87ffc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    800043ae:	0001d797          	auipc	a5,0x1d
    800043b2:	be07ad23          	sw	zero,-1030(a5) # 80020fa8 <log+0x20>
    wakeup(&log);
    800043b6:	0001d517          	auipc	a0,0x1d
    800043ba:	bd250513          	addi	a0,a0,-1070 # 80020f88 <log>
    800043be:	e8bfd0ef          	jal	80002248 <wakeup>
    release(&log.lock);
    800043c2:	0001d517          	auipc	a0,0x1d
    800043c6:	bc650513          	addi	a0,a0,-1082 # 80020f88 <log>
    800043ca:	8f3fc0ef          	jal	80000cbc <release>
}
    800043ce:	a035                	j	800043fa <end_op+0x9a>
    800043d0:	ec4e                	sd	s3,24(sp)
    800043d2:	e852                	sd	s4,16(sp)
    800043d4:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800043d6:	00004517          	auipc	a0,0x4
    800043da:	17a50513          	addi	a0,a0,378 # 80008550 <etext+0x550>
    800043de:	c46fc0ef          	jal	80000824 <panic>
    wakeup(&log);
    800043e2:	0001d517          	auipc	a0,0x1d
    800043e6:	ba650513          	addi	a0,a0,-1114 # 80020f88 <log>
    800043ea:	e5ffd0ef          	jal	80002248 <wakeup>
  release(&log.lock);
    800043ee:	0001d517          	auipc	a0,0x1d
    800043f2:	b9a50513          	addi	a0,a0,-1126 # 80020f88 <log>
    800043f6:	8c7fc0ef          	jal	80000cbc <release>
}
    800043fa:	70e2                	ld	ra,56(sp)
    800043fc:	7442                	ld	s0,48(sp)
    800043fe:	74a2                	ld	s1,40(sp)
    80004400:	7902                	ld	s2,32(sp)
    80004402:	6121                	addi	sp,sp,64
    80004404:	8082                	ret
    80004406:	ec4e                	sd	s3,24(sp)
    80004408:	e852                	sd	s4,16(sp)
    8000440a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000440c:	0001da97          	auipc	s5,0x1d
    80004410:	ba8a8a93          	addi	s5,s5,-1112 # 80020fb4 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004414:	0001da17          	auipc	s4,0x1d
    80004418:	b74a0a13          	addi	s4,s4,-1164 # 80020f88 <log>
    8000441c:	018a2583          	lw	a1,24(s4)
    80004420:	012585bb          	addw	a1,a1,s2
    80004424:	2585                	addiw	a1,a1,1
    80004426:	024a2503          	lw	a0,36(s4)
    8000442a:	e23fe0ef          	jal	8000324c <bread>
    8000442e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004430:	000aa583          	lw	a1,0(s5)
    80004434:	024a2503          	lw	a0,36(s4)
    80004438:	e15fe0ef          	jal	8000324c <bread>
    8000443c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000443e:	40000613          	li	a2,1024
    80004442:	05850593          	addi	a1,a0,88
    80004446:	05848513          	addi	a0,s1,88
    8000444a:	90ffc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    8000444e:	8526                	mv	a0,s1
    80004450:	ed3fe0ef          	jal	80003322 <bwrite>
    brelse(from);
    80004454:	854e                	mv	a0,s3
    80004456:	efffe0ef          	jal	80003354 <brelse>
    brelse(to);
    8000445a:	8526                	mv	a0,s1
    8000445c:	ef9fe0ef          	jal	80003354 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004460:	2905                	addiw	s2,s2,1
    80004462:	0a91                	addi	s5,s5,4
    80004464:	028a2783          	lw	a5,40(s4)
    80004468:	faf94ae3          	blt	s2,a5,8000441c <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000446c:	cd9ff0ef          	jal	80004144 <write_head>
    install_trans(0); // Now install writes to home locations
    80004470:	4501                	li	a0,0
    80004472:	d31ff0ef          	jal	800041a2 <install_trans>
    log.lh.n = 0;
    80004476:	0001d797          	auipc	a5,0x1d
    8000447a:	b207ad23          	sw	zero,-1222(a5) # 80020fb0 <log+0x28>
    write_head();    // Erase the transaction from the log
    8000447e:	cc7ff0ef          	jal	80004144 <write_head>
    80004482:	69e2                	ld	s3,24(sp)
    80004484:	6a42                	ld	s4,16(sp)
    80004486:	6aa2                	ld	s5,8(sp)
    80004488:	bf29                	j	800043a2 <end_op+0x42>

000000008000448a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000448a:	1101                	addi	sp,sp,-32
    8000448c:	ec06                	sd	ra,24(sp)
    8000448e:	e822                	sd	s0,16(sp)
    80004490:	e426                	sd	s1,8(sp)
    80004492:	1000                	addi	s0,sp,32
    80004494:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004496:	0001d517          	auipc	a0,0x1d
    8000449a:	af250513          	addi	a0,a0,-1294 # 80020f88 <log>
    8000449e:	f8afc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800044a2:	0001d617          	auipc	a2,0x1d
    800044a6:	b0e62603          	lw	a2,-1266(a2) # 80020fb0 <log+0x28>
    800044aa:	47f5                	li	a5,29
    800044ac:	04c7cd63          	blt	a5,a2,80004506 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800044b0:	0001d797          	auipc	a5,0x1d
    800044b4:	af47a783          	lw	a5,-1292(a5) # 80020fa4 <log+0x1c>
    800044b8:	04f05d63          	blez	a5,80004512 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800044bc:	4781                	li	a5,0
    800044be:	06c05063          	blez	a2,8000451e <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044c2:	44cc                	lw	a1,12(s1)
    800044c4:	0001d717          	auipc	a4,0x1d
    800044c8:	af070713          	addi	a4,a4,-1296 # 80020fb4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800044cc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044ce:	4314                	lw	a3,0(a4)
    800044d0:	04b68763          	beq	a3,a1,8000451e <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800044d4:	2785                	addiw	a5,a5,1
    800044d6:	0711                	addi	a4,a4,4
    800044d8:	fef61be3          	bne	a2,a5,800044ce <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800044dc:	060a                	slli	a2,a2,0x2
    800044de:	02060613          	addi	a2,a2,32
    800044e2:	0001d797          	auipc	a5,0x1d
    800044e6:	aa678793          	addi	a5,a5,-1370 # 80020f88 <log>
    800044ea:	97b2                	add	a5,a5,a2
    800044ec:	44d8                	lw	a4,12(s1)
    800044ee:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800044f0:	8526                	mv	a0,s1
    800044f2:	ee7fe0ef          	jal	800033d8 <bpin>
    log.lh.n++;
    800044f6:	0001d717          	auipc	a4,0x1d
    800044fa:	a9270713          	addi	a4,a4,-1390 # 80020f88 <log>
    800044fe:	571c                	lw	a5,40(a4)
    80004500:	2785                	addiw	a5,a5,1
    80004502:	d71c                	sw	a5,40(a4)
    80004504:	a815                	j	80004538 <log_write+0xae>
    panic("too big a transaction");
    80004506:	00004517          	auipc	a0,0x4
    8000450a:	05a50513          	addi	a0,a0,90 # 80008560 <etext+0x560>
    8000450e:	b16fc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80004512:	00004517          	auipc	a0,0x4
    80004516:	06650513          	addi	a0,a0,102 # 80008578 <etext+0x578>
    8000451a:	b0afc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    8000451e:	00279693          	slli	a3,a5,0x2
    80004522:	02068693          	addi	a3,a3,32
    80004526:	0001d717          	auipc	a4,0x1d
    8000452a:	a6270713          	addi	a4,a4,-1438 # 80020f88 <log>
    8000452e:	9736                	add	a4,a4,a3
    80004530:	44d4                	lw	a3,12(s1)
    80004532:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004534:	faf60ee3          	beq	a2,a5,800044f0 <log_write+0x66>
  }
  release(&log.lock);
    80004538:	0001d517          	auipc	a0,0x1d
    8000453c:	a5050513          	addi	a0,a0,-1456 # 80020f88 <log>
    80004540:	f7cfc0ef          	jal	80000cbc <release>
}
    80004544:	60e2                	ld	ra,24(sp)
    80004546:	6442                	ld	s0,16(sp)
    80004548:	64a2                	ld	s1,8(sp)
    8000454a:	6105                	addi	sp,sp,32
    8000454c:	8082                	ret

000000008000454e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000454e:	1101                	addi	sp,sp,-32
    80004550:	ec06                	sd	ra,24(sp)
    80004552:	e822                	sd	s0,16(sp)
    80004554:	e426                	sd	s1,8(sp)
    80004556:	e04a                	sd	s2,0(sp)
    80004558:	1000                	addi	s0,sp,32
    8000455a:	84aa                	mv	s1,a0
    8000455c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000455e:	00004597          	auipc	a1,0x4
    80004562:	03a58593          	addi	a1,a1,58 # 80008598 <etext+0x598>
    80004566:	0521                	addi	a0,a0,8
    80004568:	e36fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    8000456c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004570:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004574:	0204a423          	sw	zero,40(s1)
}
    80004578:	60e2                	ld	ra,24(sp)
    8000457a:	6442                	ld	s0,16(sp)
    8000457c:	64a2                	ld	s1,8(sp)
    8000457e:	6902                	ld	s2,0(sp)
    80004580:	6105                	addi	sp,sp,32
    80004582:	8082                	ret

0000000080004584 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004584:	1101                	addi	sp,sp,-32
    80004586:	ec06                	sd	ra,24(sp)
    80004588:	e822                	sd	s0,16(sp)
    8000458a:	e426                	sd	s1,8(sp)
    8000458c:	e04a                	sd	s2,0(sp)
    8000458e:	1000                	addi	s0,sp,32
    80004590:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004592:	00850913          	addi	s2,a0,8
    80004596:	854a                	mv	a0,s2
    80004598:	e90fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    8000459c:	409c                	lw	a5,0(s1)
    8000459e:	c799                	beqz	a5,800045ac <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800045a0:	85ca                	mv	a1,s2
    800045a2:	8526                	mv	a0,s1
    800045a4:	c59fd0ef          	jal	800021fc <sleep>
  while (lk->locked) {
    800045a8:	409c                	lw	a5,0(s1)
    800045aa:	fbfd                	bnez	a5,800045a0 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800045ac:	4785                	li	a5,1
    800045ae:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800045b0:	b6afd0ef          	jal	8000191a <myproc>
    800045b4:	591c                	lw	a5,48(a0)
    800045b6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800045b8:	854a                	mv	a0,s2
    800045ba:	f02fc0ef          	jal	80000cbc <release>
}
    800045be:	60e2                	ld	ra,24(sp)
    800045c0:	6442                	ld	s0,16(sp)
    800045c2:	64a2                	ld	s1,8(sp)
    800045c4:	6902                	ld	s2,0(sp)
    800045c6:	6105                	addi	sp,sp,32
    800045c8:	8082                	ret

00000000800045ca <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800045ca:	1101                	addi	sp,sp,-32
    800045cc:	ec06                	sd	ra,24(sp)
    800045ce:	e822                	sd	s0,16(sp)
    800045d0:	e426                	sd	s1,8(sp)
    800045d2:	e04a                	sd	s2,0(sp)
    800045d4:	1000                	addi	s0,sp,32
    800045d6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800045d8:	00850913          	addi	s2,a0,8
    800045dc:	854a                	mv	a0,s2
    800045de:	e4afc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    800045e2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045e6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800045ea:	8526                	mv	a0,s1
    800045ec:	c5dfd0ef          	jal	80002248 <wakeup>
  release(&lk->lk);
    800045f0:	854a                	mv	a0,s2
    800045f2:	ecafc0ef          	jal	80000cbc <release>
}
    800045f6:	60e2                	ld	ra,24(sp)
    800045f8:	6442                	ld	s0,16(sp)
    800045fa:	64a2                	ld	s1,8(sp)
    800045fc:	6902                	ld	s2,0(sp)
    800045fe:	6105                	addi	sp,sp,32
    80004600:	8082                	ret

0000000080004602 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004602:	7179                	addi	sp,sp,-48
    80004604:	f406                	sd	ra,40(sp)
    80004606:	f022                	sd	s0,32(sp)
    80004608:	ec26                	sd	s1,24(sp)
    8000460a:	e84a                	sd	s2,16(sp)
    8000460c:	1800                	addi	s0,sp,48
    8000460e:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80004610:	00850913          	addi	s2,a0,8
    80004614:	854a                	mv	a0,s2
    80004616:	e12fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000461a:	409c                	lw	a5,0(s1)
    8000461c:	ef81                	bnez	a5,80004634 <holdingsleep+0x32>
    8000461e:	4481                	li	s1,0
  release(&lk->lk);
    80004620:	854a                	mv	a0,s2
    80004622:	e9afc0ef          	jal	80000cbc <release>
  return r;
}
    80004626:	8526                	mv	a0,s1
    80004628:	70a2                	ld	ra,40(sp)
    8000462a:	7402                	ld	s0,32(sp)
    8000462c:	64e2                	ld	s1,24(sp)
    8000462e:	6942                	ld	s2,16(sp)
    80004630:	6145                	addi	sp,sp,48
    80004632:	8082                	ret
    80004634:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004636:	0284a983          	lw	s3,40(s1)
    8000463a:	ae0fd0ef          	jal	8000191a <myproc>
    8000463e:	5904                	lw	s1,48(a0)
    80004640:	413484b3          	sub	s1,s1,s3
    80004644:	0014b493          	seqz	s1,s1
    80004648:	69a2                	ld	s3,8(sp)
    8000464a:	bfd9                	j	80004620 <holdingsleep+0x1e>

000000008000464c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000464c:	1141                	addi	sp,sp,-16
    8000464e:	e406                	sd	ra,8(sp)
    80004650:	e022                	sd	s0,0(sp)
    80004652:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004654:	00004597          	auipc	a1,0x4
    80004658:	f5458593          	addi	a1,a1,-172 # 800085a8 <etext+0x5a8>
    8000465c:	0001d517          	auipc	a0,0x1d
    80004660:	a7450513          	addi	a0,a0,-1420 # 800210d0 <ftable>
    80004664:	d3afc0ef          	jal	80000b9e <initlock>
}
    80004668:	60a2                	ld	ra,8(sp)
    8000466a:	6402                	ld	s0,0(sp)
    8000466c:	0141                	addi	sp,sp,16
    8000466e:	8082                	ret

0000000080004670 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004670:	1101                	addi	sp,sp,-32
    80004672:	ec06                	sd	ra,24(sp)
    80004674:	e822                	sd	s0,16(sp)
    80004676:	e426                	sd	s1,8(sp)
    80004678:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000467a:	0001d517          	auipc	a0,0x1d
    8000467e:	a5650513          	addi	a0,a0,-1450 # 800210d0 <ftable>
    80004682:	da6fc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004686:	0001d497          	auipc	s1,0x1d
    8000468a:	a6248493          	addi	s1,s1,-1438 # 800210e8 <ftable+0x18>
    8000468e:	0001e717          	auipc	a4,0x1e
    80004692:	9fa70713          	addi	a4,a4,-1542 # 80022088 <disk>
    if(f->ref == 0){
    80004696:	40dc                	lw	a5,4(s1)
    80004698:	cf89                	beqz	a5,800046b2 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000469a:	02848493          	addi	s1,s1,40
    8000469e:	fee49ce3          	bne	s1,a4,80004696 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800046a2:	0001d517          	auipc	a0,0x1d
    800046a6:	a2e50513          	addi	a0,a0,-1490 # 800210d0 <ftable>
    800046aa:	e12fc0ef          	jal	80000cbc <release>
  return 0;
    800046ae:	4481                	li	s1,0
    800046b0:	a809                	j	800046c2 <filealloc+0x52>
      f->ref = 1;
    800046b2:	4785                	li	a5,1
    800046b4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800046b6:	0001d517          	auipc	a0,0x1d
    800046ba:	a1a50513          	addi	a0,a0,-1510 # 800210d0 <ftable>
    800046be:	dfefc0ef          	jal	80000cbc <release>
}
    800046c2:	8526                	mv	a0,s1
    800046c4:	60e2                	ld	ra,24(sp)
    800046c6:	6442                	ld	s0,16(sp)
    800046c8:	64a2                	ld	s1,8(sp)
    800046ca:	6105                	addi	sp,sp,32
    800046cc:	8082                	ret

00000000800046ce <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800046ce:	1101                	addi	sp,sp,-32
    800046d0:	ec06                	sd	ra,24(sp)
    800046d2:	e822                	sd	s0,16(sp)
    800046d4:	e426                	sd	s1,8(sp)
    800046d6:	1000                	addi	s0,sp,32
    800046d8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800046da:	0001d517          	auipc	a0,0x1d
    800046de:	9f650513          	addi	a0,a0,-1546 # 800210d0 <ftable>
    800046e2:	d46fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    800046e6:	40dc                	lw	a5,4(s1)
    800046e8:	02f05063          	blez	a5,80004708 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800046ec:	2785                	addiw	a5,a5,1
    800046ee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800046f0:	0001d517          	auipc	a0,0x1d
    800046f4:	9e050513          	addi	a0,a0,-1568 # 800210d0 <ftable>
    800046f8:	dc4fc0ef          	jal	80000cbc <release>
  return f;
}
    800046fc:	8526                	mv	a0,s1
    800046fe:	60e2                	ld	ra,24(sp)
    80004700:	6442                	ld	s0,16(sp)
    80004702:	64a2                	ld	s1,8(sp)
    80004704:	6105                	addi	sp,sp,32
    80004706:	8082                	ret
    panic("filedup");
    80004708:	00004517          	auipc	a0,0x4
    8000470c:	ea850513          	addi	a0,a0,-344 # 800085b0 <etext+0x5b0>
    80004710:	914fc0ef          	jal	80000824 <panic>

0000000080004714 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004714:	7139                	addi	sp,sp,-64
    80004716:	fc06                	sd	ra,56(sp)
    80004718:	f822                	sd	s0,48(sp)
    8000471a:	f426                	sd	s1,40(sp)
    8000471c:	0080                	addi	s0,sp,64
    8000471e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004720:	0001d517          	auipc	a0,0x1d
    80004724:	9b050513          	addi	a0,a0,-1616 # 800210d0 <ftable>
    80004728:	d00fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    8000472c:	40dc                	lw	a5,4(s1)
    8000472e:	04f05a63          	blez	a5,80004782 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004732:	37fd                	addiw	a5,a5,-1
    80004734:	c0dc                	sw	a5,4(s1)
    80004736:	06f04063          	bgtz	a5,80004796 <fileclose+0x82>
    8000473a:	f04a                	sd	s2,32(sp)
    8000473c:	ec4e                	sd	s3,24(sp)
    8000473e:	e852                	sd	s4,16(sp)
    80004740:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004742:	0004a903          	lw	s2,0(s1)
    80004746:	0094c783          	lbu	a5,9(s1)
    8000474a:	89be                	mv	s3,a5
    8000474c:	689c                	ld	a5,16(s1)
    8000474e:	8a3e                	mv	s4,a5
    80004750:	6c9c                	ld	a5,24(s1)
    80004752:	8abe                	mv	s5,a5
  f->ref = 0;
    80004754:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004758:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000475c:	0001d517          	auipc	a0,0x1d
    80004760:	97450513          	addi	a0,a0,-1676 # 800210d0 <ftable>
    80004764:	d58fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    80004768:	4785                	li	a5,1
    8000476a:	04f90163          	beq	s2,a5,800047ac <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000476e:	ffe9079b          	addiw	a5,s2,-2
    80004772:	4705                	li	a4,1
    80004774:	04f77563          	bgeu	a4,a5,800047be <fileclose+0xaa>
    80004778:	7902                	ld	s2,32(sp)
    8000477a:	69e2                	ld	s3,24(sp)
    8000477c:	6a42                	ld	s4,16(sp)
    8000477e:	6aa2                	ld	s5,8(sp)
    80004780:	a00d                	j	800047a2 <fileclose+0x8e>
    80004782:	f04a                	sd	s2,32(sp)
    80004784:	ec4e                	sd	s3,24(sp)
    80004786:	e852                	sd	s4,16(sp)
    80004788:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000478a:	00004517          	auipc	a0,0x4
    8000478e:	e2e50513          	addi	a0,a0,-466 # 800085b8 <etext+0x5b8>
    80004792:	892fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004796:	0001d517          	auipc	a0,0x1d
    8000479a:	93a50513          	addi	a0,a0,-1734 # 800210d0 <ftable>
    8000479e:	d1efc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800047a2:	70e2                	ld	ra,56(sp)
    800047a4:	7442                	ld	s0,48(sp)
    800047a6:	74a2                	ld	s1,40(sp)
    800047a8:	6121                	addi	sp,sp,64
    800047aa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800047ac:	85ce                	mv	a1,s3
    800047ae:	8552                	mv	a0,s4
    800047b0:	34a000ef          	jal	80004afa <pipeclose>
    800047b4:	7902                	ld	s2,32(sp)
    800047b6:	69e2                	ld	s3,24(sp)
    800047b8:	6a42                	ld	s4,16(sp)
    800047ba:	6aa2                	ld	s5,8(sp)
    800047bc:	b7dd                	j	800047a2 <fileclose+0x8e>
    begin_op();
    800047be:	b33ff0ef          	jal	800042f0 <begin_op>
    iput(ff.ip);
    800047c2:	8556                	mv	a0,s5
    800047c4:	aa2ff0ef          	jal	80003a66 <iput>
    end_op();
    800047c8:	b99ff0ef          	jal	80004360 <end_op>
    800047cc:	7902                	ld	s2,32(sp)
    800047ce:	69e2                	ld	s3,24(sp)
    800047d0:	6a42                	ld	s4,16(sp)
    800047d2:	6aa2                	ld	s5,8(sp)
    800047d4:	b7f9                	j	800047a2 <fileclose+0x8e>

00000000800047d6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800047d6:	715d                	addi	sp,sp,-80
    800047d8:	e486                	sd	ra,72(sp)
    800047da:	e0a2                	sd	s0,64(sp)
    800047dc:	fc26                	sd	s1,56(sp)
    800047de:	f052                	sd	s4,32(sp)
    800047e0:	0880                	addi	s0,sp,80
    800047e2:	84aa                	mv	s1,a0
    800047e4:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800047e6:	934fd0ef          	jal	8000191a <myproc>
  struct stat st;

  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800047ea:	409c                	lw	a5,0(s1)
    800047ec:	37f9                	addiw	a5,a5,-2
    800047ee:	4705                	li	a4,1
    800047f0:	04f76363          	bltu	a4,a5,80004836 <filestat+0x60>
    800047f4:	f84a                	sd	s2,48(sp)
    800047f6:	f44e                	sd	s3,40(sp)
    800047f8:	89aa                	mv	s3,a0
    ilock(f->ip);
    800047fa:	6c88                	ld	a0,24(s1)
    800047fc:	8e8ff0ef          	jal	800038e4 <ilock>
    stati(f->ip, &st);
    80004800:	fb840913          	addi	s2,s0,-72
    80004804:	85ca                	mv	a1,s2
    80004806:	6c88                	ld	a0,24(s1)
    80004808:	c40ff0ef          	jal	80003c48 <stati>
    iunlock(f->ip);
    8000480c:	6c88                	ld	a0,24(s1)
    8000480e:	984ff0ef          	jal	80003992 <iunlock>
    if(copyout(p->mm->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004812:	0489b783          	ld	a5,72(s3)
    80004816:	46e1                	li	a3,24
    80004818:	864a                	mv	a2,s2
    8000481a:	85d2                	mv	a1,s4
    8000481c:	6388                	ld	a0,0(a5)
    8000481e:	e3bfc0ef          	jal	80001658 <copyout>
    80004822:	41f5551b          	sraiw	a0,a0,0x1f
    80004826:	7942                	ld	s2,48(sp)
    80004828:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000482a:	60a6                	ld	ra,72(sp)
    8000482c:	6406                	ld	s0,64(sp)
    8000482e:	74e2                	ld	s1,56(sp)
    80004830:	7a02                	ld	s4,32(sp)
    80004832:	6161                	addi	sp,sp,80
    80004834:	8082                	ret
  return -1;
    80004836:	557d                	li	a0,-1
    80004838:	bfcd                	j	8000482a <filestat+0x54>

000000008000483a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000483a:	7179                	addi	sp,sp,-48
    8000483c:	f406                	sd	ra,40(sp)
    8000483e:	f022                	sd	s0,32(sp)
    80004840:	e84a                	sd	s2,16(sp)
    80004842:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004844:	00854783          	lbu	a5,8(a0)
    80004848:	cfd1                	beqz	a5,800048e4 <fileread+0xaa>
    8000484a:	ec26                	sd	s1,24(sp)
    8000484c:	e44e                	sd	s3,8(sp)
    8000484e:	84aa                	mv	s1,a0
    80004850:	892e                	mv	s2,a1
    80004852:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004854:	411c                	lw	a5,0(a0)
    80004856:	4705                	li	a4,1
    80004858:	04e78363          	beq	a5,a4,8000489e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000485c:	470d                	li	a4,3
    8000485e:	04e78763          	beq	a5,a4,800048ac <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004862:	4709                	li	a4,2
    80004864:	06e79a63          	bne	a5,a4,800048d8 <fileread+0x9e>
    ilock(f->ip);
    80004868:	6d08                	ld	a0,24(a0)
    8000486a:	87aff0ef          	jal	800038e4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000486e:	874e                	mv	a4,s3
    80004870:	5094                	lw	a3,32(s1)
    80004872:	864a                	mv	a2,s2
    80004874:	4585                	li	a1,1
    80004876:	6c88                	ld	a0,24(s1)
    80004878:	bfeff0ef          	jal	80003c76 <readi>
    8000487c:	892a                	mv	s2,a0
    8000487e:	00a05563          	blez	a0,80004888 <fileread+0x4e>
      f->off += r;
    80004882:	509c                	lw	a5,32(s1)
    80004884:	9fa9                	addw	a5,a5,a0
    80004886:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004888:	6c88                	ld	a0,24(s1)
    8000488a:	908ff0ef          	jal	80003992 <iunlock>
    8000488e:	64e2                	ld	s1,24(sp)
    80004890:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004892:	854a                	mv	a0,s2
    80004894:	70a2                	ld	ra,40(sp)
    80004896:	7402                	ld	s0,32(sp)
    80004898:	6942                	ld	s2,16(sp)
    8000489a:	6145                	addi	sp,sp,48
    8000489c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000489e:	6908                	ld	a0,16(a0)
    800048a0:	3b2000ef          	jal	80004c52 <piperead>
    800048a4:	892a                	mv	s2,a0
    800048a6:	64e2                	ld	s1,24(sp)
    800048a8:	69a2                	ld	s3,8(sp)
    800048aa:	b7e5                	j	80004892 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800048ac:	02451783          	lh	a5,36(a0)
    800048b0:	03079693          	slli	a3,a5,0x30
    800048b4:	92c1                	srli	a3,a3,0x30
    800048b6:	4725                	li	a4,9
    800048b8:	02d76963          	bltu	a4,a3,800048ea <fileread+0xb0>
    800048bc:	0792                	slli	a5,a5,0x4
    800048be:	0001c717          	auipc	a4,0x1c
    800048c2:	77270713          	addi	a4,a4,1906 # 80021030 <devsw>
    800048c6:	97ba                	add	a5,a5,a4
    800048c8:	639c                	ld	a5,0(a5)
    800048ca:	c78d                	beqz	a5,800048f4 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    800048cc:	4505                	li	a0,1
    800048ce:	9782                	jalr	a5
    800048d0:	892a                	mv	s2,a0
    800048d2:	64e2                	ld	s1,24(sp)
    800048d4:	69a2                	ld	s3,8(sp)
    800048d6:	bf75                	j	80004892 <fileread+0x58>
    panic("fileread");
    800048d8:	00004517          	auipc	a0,0x4
    800048dc:	cf050513          	addi	a0,a0,-784 # 800085c8 <etext+0x5c8>
    800048e0:	f45fb0ef          	jal	80000824 <panic>
    return -1;
    800048e4:	57fd                	li	a5,-1
    800048e6:	893e                	mv	s2,a5
    800048e8:	b76d                	j	80004892 <fileread+0x58>
      return -1;
    800048ea:	57fd                	li	a5,-1
    800048ec:	893e                	mv	s2,a5
    800048ee:	64e2                	ld	s1,24(sp)
    800048f0:	69a2                	ld	s3,8(sp)
    800048f2:	b745                	j	80004892 <fileread+0x58>
    800048f4:	57fd                	li	a5,-1
    800048f6:	893e                	mv	s2,a5
    800048f8:	64e2                	ld	s1,24(sp)
    800048fa:	69a2                	ld	s3,8(sp)
    800048fc:	bf59                	j	80004892 <fileread+0x58>

00000000800048fe <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800048fe:	00954783          	lbu	a5,9(a0)
    80004902:	10078f63          	beqz	a5,80004a20 <filewrite+0x122>
{
    80004906:	711d                	addi	sp,sp,-96
    80004908:	ec86                	sd	ra,88(sp)
    8000490a:	e8a2                	sd	s0,80(sp)
    8000490c:	e0ca                	sd	s2,64(sp)
    8000490e:	f456                	sd	s5,40(sp)
    80004910:	f05a                	sd	s6,32(sp)
    80004912:	1080                	addi	s0,sp,96
    80004914:	892a                	mv	s2,a0
    80004916:	8b2e                	mv	s6,a1
    80004918:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000491a:	411c                	lw	a5,0(a0)
    8000491c:	4705                	li	a4,1
    8000491e:	02e78a63          	beq	a5,a4,80004952 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004922:	470d                	li	a4,3
    80004924:	02e78b63          	beq	a5,a4,8000495a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004928:	4709                	li	a4,2
    8000492a:	0ce79f63          	bne	a5,a4,80004a08 <filewrite+0x10a>
    8000492e:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004930:	0ac05a63          	blez	a2,800049e4 <filewrite+0xe6>
    80004934:	e4a6                	sd	s1,72(sp)
    80004936:	fc4e                	sd	s3,56(sp)
    80004938:	ec5e                	sd	s7,24(sp)
    8000493a:	e862                	sd	s8,16(sp)
    8000493c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000493e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004940:	6b85                	lui	s7,0x1
    80004942:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004946:	6785                	lui	a5,0x1
    80004948:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000494c:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000494e:	4c05                	li	s8,1
    80004950:	a8ad                	j	800049ca <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004952:	6908                	ld	a0,16(a0)
    80004954:	204000ef          	jal	80004b58 <pipewrite>
    80004958:	a04d                	j	800049fa <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000495a:	02451783          	lh	a5,36(a0)
    8000495e:	03079693          	slli	a3,a5,0x30
    80004962:	92c1                	srli	a3,a3,0x30
    80004964:	4725                	li	a4,9
    80004966:	0ad76f63          	bltu	a4,a3,80004a24 <filewrite+0x126>
    8000496a:	0792                	slli	a5,a5,0x4
    8000496c:	0001c717          	auipc	a4,0x1c
    80004970:	6c470713          	addi	a4,a4,1732 # 80021030 <devsw>
    80004974:	97ba                	add	a5,a5,a4
    80004976:	679c                	ld	a5,8(a5)
    80004978:	cbc5                	beqz	a5,80004a28 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    8000497a:	4505                	li	a0,1
    8000497c:	9782                	jalr	a5
    8000497e:	a8b5                	j	800049fa <filewrite+0xfc>
      if(n1 > max)
    80004980:	2981                	sext.w	s3,s3
      begin_op();
    80004982:	96fff0ef          	jal	800042f0 <begin_op>
      ilock(f->ip);
    80004986:	01893503          	ld	a0,24(s2)
    8000498a:	f5bfe0ef          	jal	800038e4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000498e:	874e                	mv	a4,s3
    80004990:	02092683          	lw	a3,32(s2)
    80004994:	016a0633          	add	a2,s4,s6
    80004998:	85e2                	mv	a1,s8
    8000499a:	01893503          	ld	a0,24(s2)
    8000499e:	bcaff0ef          	jal	80003d68 <writei>
    800049a2:	84aa                	mv	s1,a0
    800049a4:	00a05763          	blez	a0,800049b2 <filewrite+0xb4>
        f->off += r;
    800049a8:	02092783          	lw	a5,32(s2)
    800049ac:	9fa9                	addw	a5,a5,a0
    800049ae:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800049b2:	01893503          	ld	a0,24(s2)
    800049b6:	fddfe0ef          	jal	80003992 <iunlock>
      end_op();
    800049ba:	9a7ff0ef          	jal	80004360 <end_op>

      if(r != n1){
    800049be:	02999563          	bne	s3,s1,800049e8 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800049c2:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800049c6:	015a5963          	bge	s4,s5,800049d8 <filewrite+0xda>
      int n1 = n - i;
    800049ca:	414a87bb          	subw	a5,s5,s4
    800049ce:	89be                	mv	s3,a5
      if(n1 > max)
    800049d0:	fafbd8e3          	bge	s7,a5,80004980 <filewrite+0x82>
    800049d4:	89e6                	mv	s3,s9
    800049d6:	b76d                	j	80004980 <filewrite+0x82>
    800049d8:	64a6                	ld	s1,72(sp)
    800049da:	79e2                	ld	s3,56(sp)
    800049dc:	6be2                	ld	s7,24(sp)
    800049de:	6c42                	ld	s8,16(sp)
    800049e0:	6ca2                	ld	s9,8(sp)
    800049e2:	a801                	j	800049f2 <filewrite+0xf4>
    int i = 0;
    800049e4:	4a01                	li	s4,0
    800049e6:	a031                	j	800049f2 <filewrite+0xf4>
    800049e8:	64a6                	ld	s1,72(sp)
    800049ea:	79e2                	ld	s3,56(sp)
    800049ec:	6be2                	ld	s7,24(sp)
    800049ee:	6c42                	ld	s8,16(sp)
    800049f0:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800049f2:	034a9d63          	bne	s5,s4,80004a2c <filewrite+0x12e>
    800049f6:	8556                	mv	a0,s5
    800049f8:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800049fa:	60e6                	ld	ra,88(sp)
    800049fc:	6446                	ld	s0,80(sp)
    800049fe:	6906                	ld	s2,64(sp)
    80004a00:	7aa2                	ld	s5,40(sp)
    80004a02:	7b02                	ld	s6,32(sp)
    80004a04:	6125                	addi	sp,sp,96
    80004a06:	8082                	ret
    80004a08:	e4a6                	sd	s1,72(sp)
    80004a0a:	fc4e                	sd	s3,56(sp)
    80004a0c:	f852                	sd	s4,48(sp)
    80004a0e:	ec5e                	sd	s7,24(sp)
    80004a10:	e862                	sd	s8,16(sp)
    80004a12:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004a14:	00004517          	auipc	a0,0x4
    80004a18:	bc450513          	addi	a0,a0,-1084 # 800085d8 <etext+0x5d8>
    80004a1c:	e09fb0ef          	jal	80000824 <panic>
    return -1;
    80004a20:	557d                	li	a0,-1
}
    80004a22:	8082                	ret
      return -1;
    80004a24:	557d                	li	a0,-1
    80004a26:	bfd1                	j	800049fa <filewrite+0xfc>
    80004a28:	557d                	li	a0,-1
    80004a2a:	bfc1                	j	800049fa <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004a2c:	557d                	li	a0,-1
    80004a2e:	7a42                	ld	s4,48(sp)
    80004a30:	b7e9                	j	800049fa <filewrite+0xfc>

0000000080004a32 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a32:	7179                	addi	sp,sp,-48
    80004a34:	f406                	sd	ra,40(sp)
    80004a36:	f022                	sd	s0,32(sp)
    80004a38:	ec26                	sd	s1,24(sp)
    80004a3a:	e052                	sd	s4,0(sp)
    80004a3c:	1800                	addi	s0,sp,48
    80004a3e:	84aa                	mv	s1,a0
    80004a40:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004a42:	0005b023          	sd	zero,0(a1)
    80004a46:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004a4a:	c27ff0ef          	jal	80004670 <filealloc>
    80004a4e:	e088                	sd	a0,0(s1)
    80004a50:	c549                	beqz	a0,80004ada <pipealloc+0xa8>
    80004a52:	c1fff0ef          	jal	80004670 <filealloc>
    80004a56:	00aa3023          	sd	a0,0(s4)
    80004a5a:	cd25                	beqz	a0,80004ad2 <pipealloc+0xa0>
    80004a5c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a5e:	8e6fc0ef          	jal	80000b44 <kalloc>
    80004a62:	892a                	mv	s2,a0
    80004a64:	c12d                	beqz	a0,80004ac6 <pipealloc+0x94>
    80004a66:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004a68:	4985                	li	s3,1
    80004a6a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a6e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a72:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a76:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a7a:	00004597          	auipc	a1,0x4
    80004a7e:	b6e58593          	addi	a1,a1,-1170 # 800085e8 <etext+0x5e8>
    80004a82:	91cfc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004a86:	609c                	ld	a5,0(s1)
    80004a88:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a8c:	609c                	ld	a5,0(s1)
    80004a8e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a92:	609c                	ld	a5,0(s1)
    80004a94:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a98:	609c                	ld	a5,0(s1)
    80004a9a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a9e:	000a3783          	ld	a5,0(s4)
    80004aa2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004aa6:	000a3783          	ld	a5,0(s4)
    80004aaa:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004aae:	000a3783          	ld	a5,0(s4)
    80004ab2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ab6:	000a3783          	ld	a5,0(s4)
    80004aba:	0127b823          	sd	s2,16(a5)
  return 0;
    80004abe:	4501                	li	a0,0
    80004ac0:	6942                	ld	s2,16(sp)
    80004ac2:	69a2                	ld	s3,8(sp)
    80004ac4:	a01d                	j	80004aea <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ac6:	6088                	ld	a0,0(s1)
    80004ac8:	c119                	beqz	a0,80004ace <pipealloc+0x9c>
    80004aca:	6942                	ld	s2,16(sp)
    80004acc:	a029                	j	80004ad6 <pipealloc+0xa4>
    80004ace:	6942                	ld	s2,16(sp)
    80004ad0:	a029                	j	80004ada <pipealloc+0xa8>
    80004ad2:	6088                	ld	a0,0(s1)
    80004ad4:	c10d                	beqz	a0,80004af6 <pipealloc+0xc4>
    fileclose(*f0);
    80004ad6:	c3fff0ef          	jal	80004714 <fileclose>
  if(*f1)
    80004ada:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ade:	557d                	li	a0,-1
  if(*f1)
    80004ae0:	c789                	beqz	a5,80004aea <pipealloc+0xb8>
    fileclose(*f1);
    80004ae2:	853e                	mv	a0,a5
    80004ae4:	c31ff0ef          	jal	80004714 <fileclose>
  return -1;
    80004ae8:	557d                	li	a0,-1
}
    80004aea:	70a2                	ld	ra,40(sp)
    80004aec:	7402                	ld	s0,32(sp)
    80004aee:	64e2                	ld	s1,24(sp)
    80004af0:	6a02                	ld	s4,0(sp)
    80004af2:	6145                	addi	sp,sp,48
    80004af4:	8082                	ret
  return -1;
    80004af6:	557d                	li	a0,-1
    80004af8:	bfcd                	j	80004aea <pipealloc+0xb8>

0000000080004afa <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004afa:	1101                	addi	sp,sp,-32
    80004afc:	ec06                	sd	ra,24(sp)
    80004afe:	e822                	sd	s0,16(sp)
    80004b00:	e426                	sd	s1,8(sp)
    80004b02:	e04a                	sd	s2,0(sp)
    80004b04:	1000                	addi	s0,sp,32
    80004b06:	84aa                	mv	s1,a0
    80004b08:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b0a:	91efc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004b0e:	02090763          	beqz	s2,80004b3c <pipeclose+0x42>
    pi->writeopen = 0;
    80004b12:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b16:	21848513          	addi	a0,s1,536
    80004b1a:	f2efd0ef          	jal	80002248 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b1e:	2204a783          	lw	a5,544(s1)
    80004b22:	e781                	bnez	a5,80004b2a <pipeclose+0x30>
    80004b24:	2244a783          	lw	a5,548(s1)
    80004b28:	c38d                	beqz	a5,80004b4a <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	990fc0ef          	jal	80000cbc <release>
}
    80004b30:	60e2                	ld	ra,24(sp)
    80004b32:	6442                	ld	s0,16(sp)
    80004b34:	64a2                	ld	s1,8(sp)
    80004b36:	6902                	ld	s2,0(sp)
    80004b38:	6105                	addi	sp,sp,32
    80004b3a:	8082                	ret
    pi->readopen = 0;
    80004b3c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004b40:	21c48513          	addi	a0,s1,540
    80004b44:	f04fd0ef          	jal	80002248 <wakeup>
    80004b48:	bfd9                	j	80004b1e <pipeclose+0x24>
    release(&pi->lock);
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	970fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004b50:	8526                	mv	a0,s1
    80004b52:	f0bfb0ef          	jal	80000a5c <kfree>
    80004b56:	bfe9                	j	80004b30 <pipeclose+0x36>

0000000080004b58 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b58:	7159                	addi	sp,sp,-112
    80004b5a:	f486                	sd	ra,104(sp)
    80004b5c:	f0a2                	sd	s0,96(sp)
    80004b5e:	eca6                	sd	s1,88(sp)
    80004b60:	e8ca                	sd	s2,80(sp)
    80004b62:	e4ce                	sd	s3,72(sp)
    80004b64:	e0d2                	sd	s4,64(sp)
    80004b66:	fc56                	sd	s5,56(sp)
    80004b68:	1880                	addi	s0,sp,112
    80004b6a:	84aa                	mv	s1,a0
    80004b6c:	8aae                	mv	s5,a1
    80004b6e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004b70:	dabfc0ef          	jal	8000191a <myproc>
    80004b74:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b76:	8526                	mv	a0,s1
    80004b78:	8b0fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    80004b7c:	0d405363          	blez	s4,80004c42 <pipewrite+0xea>
    80004b80:	f85a                	sd	s6,48(sp)
    80004b82:	f45e                	sd	s7,40(sp)
    80004b84:	f062                	sd	s8,32(sp)
    80004b86:	ec66                	sd	s9,24(sp)
    80004b88:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004b8a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->mm->pagetable, &ch, addr + i, 1) == -1)
    80004b8c:	f9f40c13          	addi	s8,s0,-97
    80004b90:	4b85                	li	s7,1
    80004b92:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b94:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b98:	21c48c93          	addi	s9,s1,540
    80004b9c:	a82d                	j	80004bd6 <pipewrite+0x7e>
      release(&pi->lock);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	91cfc0ef          	jal	80000cbc <release>
      return -1;
    80004ba4:	597d                	li	s2,-1
    80004ba6:	7b42                	ld	s6,48(sp)
    80004ba8:	7ba2                	ld	s7,40(sp)
    80004baa:	7c02                	ld	s8,32(sp)
    80004bac:	6ce2                	ld	s9,24(sp)
    80004bae:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004bb0:	854a                	mv	a0,s2
    80004bb2:	70a6                	ld	ra,104(sp)
    80004bb4:	7406                	ld	s0,96(sp)
    80004bb6:	64e6                	ld	s1,88(sp)
    80004bb8:	6946                	ld	s2,80(sp)
    80004bba:	69a6                	ld	s3,72(sp)
    80004bbc:	6a06                	ld	s4,64(sp)
    80004bbe:	7ae2                	ld	s5,56(sp)
    80004bc0:	6165                	addi	sp,sp,112
    80004bc2:	8082                	ret
      wakeup(&pi->nread);
    80004bc4:	856a                	mv	a0,s10
    80004bc6:	e82fd0ef          	jal	80002248 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004bca:	85a6                	mv	a1,s1
    80004bcc:	8566                	mv	a0,s9
    80004bce:	e2efd0ef          	jal	800021fc <sleep>
  while(i < n){
    80004bd2:	05495b63          	bge	s2,s4,80004c28 <pipewrite+0xd0>
    if(pi->readopen == 0 || killed(pr)){
    80004bd6:	2204a783          	lw	a5,544(s1)
    80004bda:	d3f1                	beqz	a5,80004b9e <pipewrite+0x46>
    80004bdc:	854e                	mv	a0,s3
    80004bde:	9a9fd0ef          	jal	80002586 <killed>
    80004be2:	fd55                	bnez	a0,80004b9e <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004be4:	2184a783          	lw	a5,536(s1)
    80004be8:	21c4a703          	lw	a4,540(s1)
    80004bec:	2007879b          	addiw	a5,a5,512
    80004bf0:	fcf70ae3          	beq	a4,a5,80004bc4 <pipewrite+0x6c>
      if(copyin(pr->mm->pagetable, &ch, addr + i, 1) == -1)
    80004bf4:	0489b783          	ld	a5,72(s3)
    80004bf8:	86de                	mv	a3,s7
    80004bfa:	01590633          	add	a2,s2,s5
    80004bfe:	85e2                	mv	a1,s8
    80004c00:	6388                	ld	a0,0(a5)
    80004c02:	b15fc0ef          	jal	80001716 <copyin>
    80004c06:	05650063          	beq	a0,s6,80004c46 <pipewrite+0xee>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c0a:	21c4a783          	lw	a5,540(s1)
    80004c0e:	0017871b          	addiw	a4,a5,1
    80004c12:	20e4ae23          	sw	a4,540(s1)
    80004c16:	1ff7f793          	andi	a5,a5,511
    80004c1a:	97a6                	add	a5,a5,s1
    80004c1c:	f9f44703          	lbu	a4,-97(s0)
    80004c20:	00e78c23          	sb	a4,24(a5)
      i++;
    80004c24:	2905                	addiw	s2,s2,1
    80004c26:	b775                	j	80004bd2 <pipewrite+0x7a>
    80004c28:	7b42                	ld	s6,48(sp)
    80004c2a:	7ba2                	ld	s7,40(sp)
    80004c2c:	7c02                	ld	s8,32(sp)
    80004c2e:	6ce2                	ld	s9,24(sp)
    80004c30:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004c32:	21848513          	addi	a0,s1,536
    80004c36:	e12fd0ef          	jal	80002248 <wakeup>
  release(&pi->lock);
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	880fc0ef          	jal	80000cbc <release>
  return i;
    80004c40:	bf85                	j	80004bb0 <pipewrite+0x58>
  int i = 0;
    80004c42:	4901                	li	s2,0
    80004c44:	b7fd                	j	80004c32 <pipewrite+0xda>
    80004c46:	7b42                	ld	s6,48(sp)
    80004c48:	7ba2                	ld	s7,40(sp)
    80004c4a:	7c02                	ld	s8,32(sp)
    80004c4c:	6ce2                	ld	s9,24(sp)
    80004c4e:	6d42                	ld	s10,16(sp)
    80004c50:	b7cd                	j	80004c32 <pipewrite+0xda>

0000000080004c52 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c52:	711d                	addi	sp,sp,-96
    80004c54:	ec86                	sd	ra,88(sp)
    80004c56:	e8a2                	sd	s0,80(sp)
    80004c58:	e4a6                	sd	s1,72(sp)
    80004c5a:	e0ca                	sd	s2,64(sp)
    80004c5c:	fc4e                	sd	s3,56(sp)
    80004c5e:	f852                	sd	s4,48(sp)
    80004c60:	f456                	sd	s5,40(sp)
    80004c62:	1080                	addi	s0,sp,96
    80004c64:	84aa                	mv	s1,a0
    80004c66:	892e                	mv	s2,a1
    80004c68:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c6a:	cb1fc0ef          	jal	8000191a <myproc>
    80004c6e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c70:	8526                	mv	a0,s1
    80004c72:	fb7fb0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c76:	2184a703          	lw	a4,536(s1)
    80004c7a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c7e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c82:	02f71763          	bne	a4,a5,80004cb0 <piperead+0x5e>
    80004c86:	2244a783          	lw	a5,548(s1)
    80004c8a:	cf85                	beqz	a5,80004cc2 <piperead+0x70>
    if(killed(pr)){
    80004c8c:	8552                	mv	a0,s4
    80004c8e:	8f9fd0ef          	jal	80002586 <killed>
    80004c92:	e11d                	bnez	a0,80004cb8 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c94:	85a6                	mv	a1,s1
    80004c96:	854e                	mv	a0,s3
    80004c98:	d64fd0ef          	jal	800021fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c9c:	2184a703          	lw	a4,536(s1)
    80004ca0:	21c4a783          	lw	a5,540(s1)
    80004ca4:	fef701e3          	beq	a4,a5,80004c86 <piperead+0x34>
    80004ca8:	f05a                	sd	s6,32(sp)
    80004caa:	ec5e                	sd	s7,24(sp)
    80004cac:	e862                	sd	s8,16(sp)
    80004cae:	a829                	j	80004cc8 <piperead+0x76>
    80004cb0:	f05a                	sd	s6,32(sp)
    80004cb2:	ec5e                	sd	s7,24(sp)
    80004cb4:	e862                	sd	s8,16(sp)
    80004cb6:	a809                	j	80004cc8 <piperead+0x76>
      release(&pi->lock);
    80004cb8:	8526                	mv	a0,s1
    80004cba:	802fc0ef          	jal	80000cbc <release>
      return -1;
    80004cbe:	59fd                	li	s3,-1
    80004cc0:	a0ad                	j	80004d2a <piperead+0xd8>
    80004cc2:	f05a                	sd	s6,32(sp)
    80004cc4:	ec5e                	sd	s7,24(sp)
    80004cc6:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cc8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->mm->pagetable, addr + i, &ch, 1) == -1) {
    80004cca:	faf40c13          	addi	s8,s0,-81
    80004cce:	4b85                	li	s7,1
    80004cd0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cd2:	05505263          	blez	s5,80004d16 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004cd6:	2184a783          	lw	a5,536(s1)
    80004cda:	21c4a703          	lw	a4,540(s1)
    80004cde:	02f70c63          	beq	a4,a5,80004d16 <piperead+0xc4>
    ch = pi->data[pi->nread % PIPESIZE];
    80004ce2:	1ff7f793          	andi	a5,a5,511
    80004ce6:	97a6                	add	a5,a5,s1
    80004ce8:	0187c783          	lbu	a5,24(a5)
    80004cec:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->mm->pagetable, addr + i, &ch, 1) == -1) {
    80004cf0:	048a3783          	ld	a5,72(s4)
    80004cf4:	86de                	mv	a3,s7
    80004cf6:	8662                	mv	a2,s8
    80004cf8:	85ca                	mv	a1,s2
    80004cfa:	6388                	ld	a0,0(a5)
    80004cfc:	95dfc0ef          	jal	80001658 <copyout>
    80004d00:	03650f63          	beq	a0,s6,80004d3e <piperead+0xec>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004d04:	2184a783          	lw	a5,536(s1)
    80004d08:	2785                	addiw	a5,a5,1
    80004d0a:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d0e:	2985                	addiw	s3,s3,1
    80004d10:	0905                	addi	s2,s2,1
    80004d12:	fd3a92e3          	bne	s5,s3,80004cd6 <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d16:	21c48513          	addi	a0,s1,540
    80004d1a:	d2efd0ef          	jal	80002248 <wakeup>
  release(&pi->lock);
    80004d1e:	8526                	mv	a0,s1
    80004d20:	f9dfb0ef          	jal	80000cbc <release>
    80004d24:	7b02                	ld	s6,32(sp)
    80004d26:	6be2                	ld	s7,24(sp)
    80004d28:	6c42                	ld	s8,16(sp)
  return i;
}
    80004d2a:	854e                	mv	a0,s3
    80004d2c:	60e6                	ld	ra,88(sp)
    80004d2e:	6446                	ld	s0,80(sp)
    80004d30:	64a6                	ld	s1,72(sp)
    80004d32:	6906                	ld	s2,64(sp)
    80004d34:	79e2                	ld	s3,56(sp)
    80004d36:	7a42                	ld	s4,48(sp)
    80004d38:	7aa2                	ld	s5,40(sp)
    80004d3a:	6125                	addi	sp,sp,96
    80004d3c:	8082                	ret
      if(i == 0)
    80004d3e:	fc099ce3          	bnez	s3,80004d16 <piperead+0xc4>
        i = -1;
    80004d42:	89aa                	mv	s3,a0
    80004d44:	bfc9                	j	80004d16 <piperead+0xc4>

0000000080004d46 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
extern void drain_siblings(struct proc *p);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004d46:	1141                	addi	sp,sp,-16
    80004d48:	e406                	sd	ra,8(sp)
    80004d4a:	e022                	sd	s0,0(sp)
    80004d4c:	0800                	addi	s0,sp,16
    80004d4e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004d50:	0035151b          	slliw	a0,a0,0x3
    80004d54:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004d56:	8b89                	andi	a5,a5,2
    80004d58:	c399                	beqz	a5,80004d5e <flags2perm+0x18>
      perm |= PTE_W;
    80004d5a:	00456513          	ori	a0,a0,4
    return perm;
}
    80004d5e:	60a2                	ld	ra,8(sp)
    80004d60:	6402                	ld	s0,0(sp)
    80004d62:	0141                	addi	sp,sp,16
    80004d64:	8082                	ret

0000000080004d66 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004d66:	de010113          	addi	sp,sp,-544
    80004d6a:	20113c23          	sd	ra,536(sp)
    80004d6e:	20813823          	sd	s0,528(sp)
    80004d72:	21213023          	sd	s2,512(sp)
    80004d76:	1400                	addi	s0,sp,544
    80004d78:	892a                	mv	s2,a0
    80004d7a:	dea43823          	sd	a0,-528(s0)
    80004d7e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d82:	b99fc0ef          	jal	8000191a <myproc>

  if(p != p->group_leader) {
    80004d86:	16053783          	ld	a5,352(a0)
    80004d8a:	32a79963          	bne	a5,a0,800050bc <kexec+0x356>
    80004d8e:	20913423          	sd	s1,520(sp)
    80004d92:	fbd2                	sd	s4,496(sp)
    80004d94:	84aa                	mv	s1,a0
    return -1;
  }

  drain_siblings(p);
    80004d96:	b55fd0ef          	jal	800028ea <drain_siblings>

  begin_op();
    80004d9a:	d56ff0ef          	jal	800042f0 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004d9e:	854a                	mv	a0,s2
    80004da0:	b72ff0ef          	jal	80004112 <namei>
    80004da4:	8a2a                	mv	s4,a0
    80004da6:	c931                	beqz	a0,80004dfa <kexec+0x94>
    end_op();
    return -1;
  }
  ilock(ip);
    80004da8:	b3dfe0ef          	jal	800038e4 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004dac:	04000713          	li	a4,64
    80004db0:	4681                	li	a3,0
    80004db2:	e5040613          	addi	a2,s0,-432
    80004db6:	4581                	li	a1,0
    80004db8:	8552                	mv	a0,s4
    80004dba:	ebdfe0ef          	jal	80003c76 <readi>
    80004dbe:	04000793          	li	a5,64
    80004dc2:	00f51a63          	bne	a0,a5,80004dd6 <kexec+0x70>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004dc6:	e5042703          	lw	a4,-432(s0)
    80004dca:	464c47b7          	lui	a5,0x464c4
    80004dce:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004dd2:	02f70b63          	beq	a4,a5,80004e08 <kexec+0xa2>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004dd6:	8552                	mv	a0,s4
    80004dd8:	d19fe0ef          	jal	80003af0 <iunlockput>
    end_op();
    80004ddc:	d84ff0ef          	jal	80004360 <end_op>
  }
  return -1;
    80004de0:	557d                	li	a0,-1
    80004de2:	20813483          	ld	s1,520(sp)
    80004de6:	7a5e                	ld	s4,496(sp)
}
    80004de8:	21813083          	ld	ra,536(sp)
    80004dec:	21013403          	ld	s0,528(sp)
    80004df0:	20013903          	ld	s2,512(sp)
    80004df4:	22010113          	addi	sp,sp,544
    80004df8:	8082                	ret
    end_op();
    80004dfa:	d66ff0ef          	jal	80004360 <end_op>
    return -1;
    80004dfe:	557d                	li	a0,-1
    80004e00:	20813483          	ld	s1,520(sp)
    80004e04:	7a5e                	ld	s4,496(sp)
    80004e06:	b7cd                	j	80004de8 <kexec+0x82>
    80004e08:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	ce1fc0ef          	jal	80001aec <proc_pagetable>
    80004e10:	8b2a                	mv	s6,a0
    80004e12:	2a050363          	beqz	a0,800050b8 <kexec+0x352>
    80004e16:	ffce                	sd	s3,504(sp)
    80004e18:	f7d6                	sd	s5,488(sp)
    80004e1a:	efde                	sd	s7,472(sp)
    80004e1c:	ebe2                	sd	s8,464(sp)
    80004e1e:	e7e6                	sd	s9,456(sp)
    80004e20:	e3ea                	sd	s10,448(sp)
    80004e22:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e24:	e8845783          	lhu	a5,-376(s0)
    80004e28:	0e078963          	beqz	a5,80004f1a <kexec+0x1b4>
    80004e2c:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e30:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e32:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e34:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004e38:	6c85                	lui	s9,0x1
    80004e3a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004e3e:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004e42:	6a85                	lui	s5,0x1
    80004e44:	a085                	j	80004ea4 <kexec+0x13e>
      panic("loadseg: address should exist");
    80004e46:	00003517          	auipc	a0,0x3
    80004e4a:	7aa50513          	addi	a0,a0,1962 # 800085f0 <etext+0x5f0>
    80004e4e:	9d7fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    80004e52:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e54:	874a                	mv	a4,s2
    80004e56:	009b86bb          	addw	a3,s7,s1
    80004e5a:	4581                	li	a1,0
    80004e5c:	8552                	mv	a0,s4
    80004e5e:	e19fe0ef          	jal	80003c76 <readi>
    80004e62:	26a91163          	bne	s2,a0,800050c4 <kexec+0x35e>
  for(i = 0; i < sz; i += PGSIZE){
    80004e66:	009a84bb          	addw	s1,s5,s1
    80004e6a:	0334f263          	bgeu	s1,s3,80004e8e <kexec+0x128>
    pa = walkaddr(pagetable, va + i);
    80004e6e:	02049593          	slli	a1,s1,0x20
    80004e72:	9181                	srli	a1,a1,0x20
    80004e74:	95e2                	add	a1,a1,s8
    80004e76:	855a                	mv	a0,s6
    80004e78:	9aefc0ef          	jal	80001026 <walkaddr>
    80004e7c:	862a                	mv	a2,a0
    if(pa == 0)
    80004e7e:	d561                	beqz	a0,80004e46 <kexec+0xe0>
    if(sz - i < PGSIZE)
    80004e80:	409987bb          	subw	a5,s3,s1
    80004e84:	893e                	mv	s2,a5
    80004e86:	fcfcf6e3          	bgeu	s9,a5,80004e52 <kexec+0xec>
    80004e8a:	8956                	mv	s2,s5
    80004e8c:	b7d9                	j	80004e52 <kexec+0xec>
    sz = sz1;
    80004e8e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e92:	2d05                	addiw	s10,s10,1
    80004e94:	e0843783          	ld	a5,-504(s0)
    80004e98:	0387869b          	addiw	a3,a5,56
    80004e9c:	e8845783          	lhu	a5,-376(s0)
    80004ea0:	06fd5e63          	bge	s10,a5,80004f1c <kexec+0x1b6>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ea4:	e0d43423          	sd	a3,-504(s0)
    80004ea8:	876e                	mv	a4,s11
    80004eaa:	e1840613          	addi	a2,s0,-488
    80004eae:	4581                	li	a1,0
    80004eb0:	8552                	mv	a0,s4
    80004eb2:	dc5fe0ef          	jal	80003c76 <readi>
    80004eb6:	21b51563          	bne	a0,s11,800050c0 <kexec+0x35a>
    if(ph.type != ELF_PROG_LOAD)
    80004eba:	e1842783          	lw	a5,-488(s0)
    80004ebe:	4705                	li	a4,1
    80004ec0:	fce799e3          	bne	a5,a4,80004e92 <kexec+0x12c>
    if(ph.memsz < ph.filesz)
    80004ec4:	e4043483          	ld	s1,-448(s0)
    80004ec8:	e3843783          	ld	a5,-456(s0)
    80004ecc:	20f4ea63          	bltu	s1,a5,800050e0 <kexec+0x37a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ed0:	e2843783          	ld	a5,-472(s0)
    80004ed4:	94be                	add	s1,s1,a5
    80004ed6:	20f4e863          	bltu	s1,a5,800050e6 <kexec+0x380>
    if(ph.vaddr % PGSIZE != 0)
    80004eda:	de843703          	ld	a4,-536(s0)
    80004ede:	8ff9                	and	a5,a5,a4
    80004ee0:	20079663          	bnez	a5,800050ec <kexec+0x386>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004ee4:	e1c42503          	lw	a0,-484(s0)
    80004ee8:	e5fff0ef          	jal	80004d46 <flags2perm>
    80004eec:	86aa                	mv	a3,a0
    80004eee:	8626                	mv	a2,s1
    80004ef0:	85ca                	mv	a1,s2
    80004ef2:	855a                	mv	a0,s6
    80004ef4:	c08fc0ef          	jal	800012fc <uvmalloc>
    80004ef8:	dea43c23          	sd	a0,-520(s0)
    80004efc:	1e050b63          	beqz	a0,800050f2 <kexec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f00:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f04:	00098863          	beqz	s3,80004f14 <kexec+0x1ae>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f08:	e2843c03          	ld	s8,-472(s0)
    80004f0c:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f10:	4481                	li	s1,0
    80004f12:	bfb1                	j	80004e6e <kexec+0x108>
    sz = sz1;
    80004f14:	df843903          	ld	s2,-520(s0)
    80004f18:	bfad                	j	80004e92 <kexec+0x12c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f1a:	4901                	li	s2,0
  iunlockput(ip);
    80004f1c:	8552                	mv	a0,s4
    80004f1e:	bd3fe0ef          	jal	80003af0 <iunlockput>
  end_op();
    80004f22:	c3eff0ef          	jal	80004360 <end_op>
  p = myproc();
    80004f26:	9f5fc0ef          	jal	8000191a <myproc>
    80004f2a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->mm->sz;
    80004f2c:	653c                	ld	a5,72(a0)
    80004f2e:	0087bd03          	ld	s10,8(a5)
  sz = PGROUNDUP(sz);
    80004f32:	6985                	lui	s3,0x1
    80004f34:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004f36:	99ca                	add	s3,s3,s2
    80004f38:	77fd                	lui	a5,0xfffff
    80004f3a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004f3e:	4691                	li	a3,4
    80004f40:	6609                	lui	a2,0x2
    80004f42:	964e                	add	a2,a2,s3
    80004f44:	85ce                	mv	a1,s3
    80004f46:	855a                	mv	a0,s6
    80004f48:	bb4fc0ef          	jal	800012fc <uvmalloc>
    80004f4c:	8a2a                	mv	s4,a0
    80004f4e:	e115                	bnez	a0,80004f72 <kexec+0x20c>
    proc_freepagetable(pagetable, sz);
    80004f50:	85ce                	mv	a1,s3
    80004f52:	855a                	mv	a0,s6
    80004f54:	c29fc0ef          	jal	80001b7c <proc_freepagetable>
  return -1;
    80004f58:	557d                	li	a0,-1
    80004f5a:	20813483          	ld	s1,520(sp)
    80004f5e:	79fe                	ld	s3,504(sp)
    80004f60:	7a5e                	ld	s4,496(sp)
    80004f62:	7abe                	ld	s5,488(sp)
    80004f64:	7b1e                	ld	s6,480(sp)
    80004f66:	6bfe                	ld	s7,472(sp)
    80004f68:	6c5e                	ld	s8,464(sp)
    80004f6a:	6cbe                	ld	s9,456(sp)
    80004f6c:	6d1e                	ld	s10,448(sp)
    80004f6e:	7dfa                	ld	s11,440(sp)
    80004f70:	bda5                	j	80004de8 <kexec+0x82>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004f72:	75f9                	lui	a1,0xffffe
    80004f74:	95aa                	add	a1,a1,a0
    80004f76:	855a                	mv	a0,s6
    80004f78:	d56fc0ef          	jal	800014ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004f7c:	800a0b93          	addi	s7,s4,-2048
    80004f80:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80004f84:	e0043783          	ld	a5,-512(s0)
    80004f88:	6388                	ld	a0,0(a5)
  sp = sz;
    80004f8a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004f8c:	4481                	li	s1,0
    ustack[argc] = sp;
    80004f8e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004f92:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004f96:	cd21                	beqz	a0,80004fee <kexec+0x288>
    sp -= strlen(argv[argc]) + 1;
    80004f98:	eebfb0ef          	jal	80000e82 <strlen>
    80004f9c:	0015079b          	addiw	a5,a0,1
    80004fa0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004fa4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004fa8:	15796863          	bltu	s2,s7,800050f8 <kexec+0x392>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004fac:	e0043d83          	ld	s11,-512(s0)
    80004fb0:	000db983          	ld	s3,0(s11)
    80004fb4:	854e                	mv	a0,s3
    80004fb6:	ecdfb0ef          	jal	80000e82 <strlen>
    80004fba:	0015069b          	addiw	a3,a0,1
    80004fbe:	864e                	mv	a2,s3
    80004fc0:	85ca                	mv	a1,s2
    80004fc2:	855a                	mv	a0,s6
    80004fc4:	e94fc0ef          	jal	80001658 <copyout>
    80004fc8:	12054a63          	bltz	a0,800050fc <kexec+0x396>
    ustack[argc] = sp;
    80004fcc:	00349793          	slli	a5,s1,0x3
    80004fd0:	97e6                	add	a5,a5,s9
    80004fd2:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdce38>
  for(argc = 0; argv[argc]; argc++) {
    80004fd6:	0485                	addi	s1,s1,1
    80004fd8:	008d8793          	addi	a5,s11,8
    80004fdc:	e0f43023          	sd	a5,-512(s0)
    80004fe0:	008db503          	ld	a0,8(s11)
    80004fe4:	c509                	beqz	a0,80004fee <kexec+0x288>
    if(argc >= MAXARG)
    80004fe6:	fb8499e3          	bne	s1,s8,80004f98 <kexec+0x232>
  sz = sz1;
    80004fea:	89d2                	mv	s3,s4
    80004fec:	b795                	j	80004f50 <kexec+0x1ea>
  ustack[argc] = 0;
    80004fee:	00349793          	slli	a5,s1,0x3
    80004ff2:	f9078793          	addi	a5,a5,-112
    80004ff6:	97a2                	add	a5,a5,s0
    80004ff8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004ffc:	00349693          	slli	a3,s1,0x3
    80005000:	06a1                	addi	a3,a3,8
    80005002:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005006:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000500a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000500c:	f57962e3          	bltu	s2,s7,80004f50 <kexec+0x1ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005010:	e9040613          	addi	a2,s0,-368
    80005014:	85ca                	mv	a1,s2
    80005016:	855a                	mv	a0,s6
    80005018:	e40fc0ef          	jal	80001658 <copyout>
    8000501c:	f2054ae3          	bltz	a0,80004f50 <kexec+0x1ea>
  p->trapframe->a1 = sp;
    80005020:	050ab783          	ld	a5,80(s5) # 1050 <_entry-0x7fffefb0>
    80005024:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005028:	df043783          	ld	a5,-528(s0)
    8000502c:	0007c703          	lbu	a4,0(a5)
    80005030:	cf11                	beqz	a4,8000504c <kexec+0x2e6>
    80005032:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005034:	02f00693          	li	a3,47
    80005038:	a029                	j	80005042 <kexec+0x2dc>
  for(last=s=path; *s; s++)
    8000503a:	0785                	addi	a5,a5,1
    8000503c:	fff7c703          	lbu	a4,-1(a5)
    80005040:	c711                	beqz	a4,8000504c <kexec+0x2e6>
    if(*s == '/')
    80005042:	fed71ce3          	bne	a4,a3,8000503a <kexec+0x2d4>
      last = s+1;
    80005046:	def43823          	sd	a5,-528(s0)
    8000504a:	bfc5                	j	8000503a <kexec+0x2d4>
  safestrcpy(p->name, last, sizeof(p->name));
    8000504c:	4641                	li	a2,16
    8000504e:	df043583          	ld	a1,-528(s0)
    80005052:	150a8513          	addi	a0,s5,336
    80005056:	df7fb0ef          	jal	80000e4c <safestrcpy>
  acquire(&p->mm->lock);
    8000505a:	048ab503          	ld	a0,72(s5)
    8000505e:	0561                	addi	a0,a0,24
    80005060:	bc9fb0ef          	jal	80000c28 <acquire>
  oldpagetable = p->mm->pagetable;
    80005064:	048ab783          	ld	a5,72(s5)
    80005068:	0007b983          	ld	s3,0(a5)
  p->mm->pagetable = pagetable;
    8000506c:	0167b023          	sd	s6,0(a5)
  p->mm->sz = sz;
    80005070:	048ab783          	ld	a5,72(s5)
    80005074:	0147b423          	sd	s4,8(a5)
  release(&p->mm->lock);
    80005078:	048ab503          	ld	a0,72(s5)
    8000507c:	0561                	addi	a0,a0,24
    8000507e:	c3ffb0ef          	jal	80000cbc <release>
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80005082:	050ab783          	ld	a5,80(s5)
    80005086:	e6843703          	ld	a4,-408(s0)
    8000508a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000508c:	050ab783          	ld	a5,80(s5)
    80005090:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005094:	85ea                	mv	a1,s10
    80005096:	854e                	mv	a0,s3
    80005098:	ae5fc0ef          	jal	80001b7c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000509c:	0004851b          	sext.w	a0,s1
    800050a0:	20813483          	ld	s1,520(sp)
    800050a4:	79fe                	ld	s3,504(sp)
    800050a6:	7a5e                	ld	s4,496(sp)
    800050a8:	7abe                	ld	s5,488(sp)
    800050aa:	7b1e                	ld	s6,480(sp)
    800050ac:	6bfe                	ld	s7,472(sp)
    800050ae:	6c5e                	ld	s8,464(sp)
    800050b0:	6cbe                	ld	s9,456(sp)
    800050b2:	6d1e                	ld	s10,448(sp)
    800050b4:	7dfa                	ld	s11,440(sp)
    800050b6:	bb0d                	j	80004de8 <kexec+0x82>
    800050b8:	7b1e                	ld	s6,480(sp)
    800050ba:	bb31                	j	80004dd6 <kexec+0x70>
    return -1;
    800050bc:	557d                	li	a0,-1
    800050be:	b32d                	j	80004de8 <kexec+0x82>
    800050c0:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800050c4:	df843583          	ld	a1,-520(s0)
    800050c8:	855a                	mv	a0,s6
    800050ca:	ab3fc0ef          	jal	80001b7c <proc_freepagetable>
  if(ip){
    800050ce:	79fe                	ld	s3,504(sp)
    800050d0:	7abe                	ld	s5,488(sp)
    800050d2:	7b1e                	ld	s6,480(sp)
    800050d4:	6bfe                	ld	s7,472(sp)
    800050d6:	6c5e                	ld	s8,464(sp)
    800050d8:	6cbe                	ld	s9,456(sp)
    800050da:	6d1e                	ld	s10,448(sp)
    800050dc:	7dfa                	ld	s11,440(sp)
    800050de:	b9e5                	j	80004dd6 <kexec+0x70>
    800050e0:	df243c23          	sd	s2,-520(s0)
    800050e4:	b7c5                	j	800050c4 <kexec+0x35e>
    800050e6:	df243c23          	sd	s2,-520(s0)
    800050ea:	bfe9                	j	800050c4 <kexec+0x35e>
    800050ec:	df243c23          	sd	s2,-520(s0)
    800050f0:	bfd1                	j	800050c4 <kexec+0x35e>
    800050f2:	df243c23          	sd	s2,-520(s0)
    800050f6:	b7f9                	j	800050c4 <kexec+0x35e>
  sz = sz1;
    800050f8:	89d2                	mv	s3,s4
    800050fa:	bd99                	j	80004f50 <kexec+0x1ea>
    800050fc:	89d2                	mv	s3,s4
    800050fe:	bd89                	j	80004f50 <kexec+0x1ea>

0000000080005100 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005100:	7179                	addi	sp,sp,-48
    80005102:	f406                	sd	ra,40(sp)
    80005104:	f022                	sd	s0,32(sp)
    80005106:	ec26                	sd	s1,24(sp)
    80005108:	e84a                	sd	s2,16(sp)
    8000510a:	1800                	addi	s0,sp,48
    8000510c:	892e                	mv	s2,a1
    8000510e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005110:	fdc40593          	addi	a1,s0,-36
    80005114:	d65fd0ef          	jal	80002e78 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005118:	fdc42703          	lw	a4,-36(s0)
    8000511c:	47bd                	li	a5,15
    8000511e:	02e7ea63          	bltu	a5,a4,80005152 <argfd+0x52>
    80005122:	ff8fc0ef          	jal	8000191a <myproc>
    80005126:	fdc42703          	lw	a4,-36(s0)
    8000512a:	00371793          	slli	a5,a4,0x3
    8000512e:	0c078793          	addi	a5,a5,192
    80005132:	953e                	add	a0,a0,a5
    80005134:	651c                	ld	a5,8(a0)
    80005136:	c385                	beqz	a5,80005156 <argfd+0x56>
    return -1;
  if(pfd)
    80005138:	00090463          	beqz	s2,80005140 <argfd+0x40>
    *pfd = fd;
    8000513c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005140:	4501                	li	a0,0
  if(pf)
    80005142:	c091                	beqz	s1,80005146 <argfd+0x46>
    *pf = f;
    80005144:	e09c                	sd	a5,0(s1)
}
    80005146:	70a2                	ld	ra,40(sp)
    80005148:	7402                	ld	s0,32(sp)
    8000514a:	64e2                	ld	s1,24(sp)
    8000514c:	6942                	ld	s2,16(sp)
    8000514e:	6145                	addi	sp,sp,48
    80005150:	8082                	ret
    return -1;
    80005152:	557d                	li	a0,-1
    80005154:	bfcd                	j	80005146 <argfd+0x46>
    80005156:	557d                	li	a0,-1
    80005158:	b7fd                	j	80005146 <argfd+0x46>

000000008000515a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000515a:	1101                	addi	sp,sp,-32
    8000515c:	ec06                	sd	ra,24(sp)
    8000515e:	e822                	sd	s0,16(sp)
    80005160:	e426                	sd	s1,8(sp)
    80005162:	1000                	addi	s0,sp,32
    80005164:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005166:	fb4fc0ef          	jal	8000191a <myproc>
    8000516a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000516c:	0c850793          	addi	a5,a0,200
    80005170:	4501                	li	a0,0
    80005172:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005174:	6398                	ld	a4,0(a5)
    80005176:	cb19                	beqz	a4,8000518c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80005178:	2505                	addiw	a0,a0,1
    8000517a:	07a1                	addi	a5,a5,8
    8000517c:	fed51ce3          	bne	a0,a3,80005174 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005180:	557d                	li	a0,-1
}
    80005182:	60e2                	ld	ra,24(sp)
    80005184:	6442                	ld	s0,16(sp)
    80005186:	64a2                	ld	s1,8(sp)
    80005188:	6105                	addi	sp,sp,32
    8000518a:	8082                	ret
      p->ofile[fd] = f;
    8000518c:	00351793          	slli	a5,a0,0x3
    80005190:	0c078793          	addi	a5,a5,192
    80005194:	963e                	add	a2,a2,a5
    80005196:	e604                	sd	s1,8(a2)
      return fd;
    80005198:	b7ed                	j	80005182 <fdalloc+0x28>

000000008000519a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000519a:	715d                	addi	sp,sp,-80
    8000519c:	e486                	sd	ra,72(sp)
    8000519e:	e0a2                	sd	s0,64(sp)
    800051a0:	fc26                	sd	s1,56(sp)
    800051a2:	f84a                	sd	s2,48(sp)
    800051a4:	f44e                	sd	s3,40(sp)
    800051a6:	f052                	sd	s4,32(sp)
    800051a8:	ec56                	sd	s5,24(sp)
    800051aa:	e85a                	sd	s6,16(sp)
    800051ac:	0880                	addi	s0,sp,80
    800051ae:	892e                	mv	s2,a1
    800051b0:	8a2e                	mv	s4,a1
    800051b2:	8ab2                	mv	s5,a2
    800051b4:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800051b6:	fb040593          	addi	a1,s0,-80
    800051ba:	f73fe0ef          	jal	8000412c <nameiparent>
    800051be:	84aa                	mv	s1,a0
    800051c0:	10050763          	beqz	a0,800052ce <create+0x134>
    return 0;

  ilock(dp);
    800051c4:	f20fe0ef          	jal	800038e4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800051c8:	4601                	li	a2,0
    800051ca:	fb040593          	addi	a1,s0,-80
    800051ce:	8526                	mv	a0,s1
    800051d0:	caffe0ef          	jal	80003e7e <dirlookup>
    800051d4:	89aa                	mv	s3,a0
    800051d6:	c131                	beqz	a0,8000521a <create+0x80>
    iunlockput(dp);
    800051d8:	8526                	mv	a0,s1
    800051da:	917fe0ef          	jal	80003af0 <iunlockput>
    ilock(ip);
    800051de:	854e                	mv	a0,s3
    800051e0:	f04fe0ef          	jal	800038e4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800051e4:	4789                	li	a5,2
    800051e6:	02f91563          	bne	s2,a5,80005210 <create+0x76>
    800051ea:	0449d783          	lhu	a5,68(s3)
    800051ee:	37f9                	addiw	a5,a5,-2
    800051f0:	17c2                	slli	a5,a5,0x30
    800051f2:	93c1                	srli	a5,a5,0x30
    800051f4:	4705                	li	a4,1
    800051f6:	00f76d63          	bltu	a4,a5,80005210 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800051fa:	854e                	mv	a0,s3
    800051fc:	60a6                	ld	ra,72(sp)
    800051fe:	6406                	ld	s0,64(sp)
    80005200:	74e2                	ld	s1,56(sp)
    80005202:	7942                	ld	s2,48(sp)
    80005204:	79a2                	ld	s3,40(sp)
    80005206:	7a02                	ld	s4,32(sp)
    80005208:	6ae2                	ld	s5,24(sp)
    8000520a:	6b42                	ld	s6,16(sp)
    8000520c:	6161                	addi	sp,sp,80
    8000520e:	8082                	ret
    iunlockput(ip);
    80005210:	854e                	mv	a0,s3
    80005212:	8dffe0ef          	jal	80003af0 <iunlockput>
    return 0;
    80005216:	4981                	li	s3,0
    80005218:	b7cd                	j	800051fa <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000521a:	85ca                	mv	a1,s2
    8000521c:	4088                	lw	a0,0(s1)
    8000521e:	d56fe0ef          	jal	80003774 <ialloc>
    80005222:	892a                	mv	s2,a0
    80005224:	cd15                	beqz	a0,80005260 <create+0xc6>
  ilock(ip);
    80005226:	ebefe0ef          	jal	800038e4 <ilock>
  ip->major = major;
    8000522a:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    8000522e:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005232:	4785                	li	a5,1
    80005234:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005238:	854a                	mv	a0,s2
    8000523a:	df6fe0ef          	jal	80003830 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000523e:	4705                	li	a4,1
    80005240:	02ea0463          	beq	s4,a4,80005268 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005244:	00492603          	lw	a2,4(s2)
    80005248:	fb040593          	addi	a1,s0,-80
    8000524c:	8526                	mv	a0,s1
    8000524e:	e1bfe0ef          	jal	80004068 <dirlink>
    80005252:	06054263          	bltz	a0,800052b6 <create+0x11c>
  iunlockput(dp);
    80005256:	8526                	mv	a0,s1
    80005258:	899fe0ef          	jal	80003af0 <iunlockput>
  return ip;
    8000525c:	89ca                	mv	s3,s2
    8000525e:	bf71                	j	800051fa <create+0x60>
    iunlockput(dp);
    80005260:	8526                	mv	a0,s1
    80005262:	88ffe0ef          	jal	80003af0 <iunlockput>
    return 0;
    80005266:	bf51                	j	800051fa <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005268:	00492603          	lw	a2,4(s2)
    8000526c:	00003597          	auipc	a1,0x3
    80005270:	3a458593          	addi	a1,a1,932 # 80008610 <etext+0x610>
    80005274:	854a                	mv	a0,s2
    80005276:	df3fe0ef          	jal	80004068 <dirlink>
    8000527a:	02054e63          	bltz	a0,800052b6 <create+0x11c>
    8000527e:	40d0                	lw	a2,4(s1)
    80005280:	00003597          	auipc	a1,0x3
    80005284:	39858593          	addi	a1,a1,920 # 80008618 <etext+0x618>
    80005288:	854a                	mv	a0,s2
    8000528a:	ddffe0ef          	jal	80004068 <dirlink>
    8000528e:	02054463          	bltz	a0,800052b6 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005292:	00492603          	lw	a2,4(s2)
    80005296:	fb040593          	addi	a1,s0,-80
    8000529a:	8526                	mv	a0,s1
    8000529c:	dcdfe0ef          	jal	80004068 <dirlink>
    800052a0:	00054b63          	bltz	a0,800052b6 <create+0x11c>
    dp->nlink++;  // for ".."
    800052a4:	04a4d783          	lhu	a5,74(s1)
    800052a8:	2785                	addiw	a5,a5,1
    800052aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052ae:	8526                	mv	a0,s1
    800052b0:	d80fe0ef          	jal	80003830 <iupdate>
    800052b4:	b74d                	j	80005256 <create+0xbc>
  ip->nlink = 0;
    800052b6:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    800052ba:	854a                	mv	a0,s2
    800052bc:	d74fe0ef          	jal	80003830 <iupdate>
  iunlockput(ip);
    800052c0:	854a                	mv	a0,s2
    800052c2:	82ffe0ef          	jal	80003af0 <iunlockput>
  iunlockput(dp);
    800052c6:	8526                	mv	a0,s1
    800052c8:	829fe0ef          	jal	80003af0 <iunlockput>
  return 0;
    800052cc:	b73d                	j	800051fa <create+0x60>
    return 0;
    800052ce:	89aa                	mv	s3,a0
    800052d0:	b72d                	j	800051fa <create+0x60>

00000000800052d2 <sys_dup>:
{
    800052d2:	7179                	addi	sp,sp,-48
    800052d4:	f406                	sd	ra,40(sp)
    800052d6:	f022                	sd	s0,32(sp)
    800052d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052da:	fd840613          	addi	a2,s0,-40
    800052de:	4581                	li	a1,0
    800052e0:	4501                	li	a0,0
    800052e2:	e1fff0ef          	jal	80005100 <argfd>
    return -1;
    800052e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052e8:	02054363          	bltz	a0,8000530e <sys_dup+0x3c>
    800052ec:	ec26                	sd	s1,24(sp)
    800052ee:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800052f0:	fd843483          	ld	s1,-40(s0)
    800052f4:	8526                	mv	a0,s1
    800052f6:	e65ff0ef          	jal	8000515a <fdalloc>
    800052fa:	892a                	mv	s2,a0
    return -1;
    800052fc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052fe:	00054d63          	bltz	a0,80005318 <sys_dup+0x46>
  filedup(f);
    80005302:	8526                	mv	a0,s1
    80005304:	bcaff0ef          	jal	800046ce <filedup>
  return fd;
    80005308:	87ca                	mv	a5,s2
    8000530a:	64e2                	ld	s1,24(sp)
    8000530c:	6942                	ld	s2,16(sp)
}
    8000530e:	853e                	mv	a0,a5
    80005310:	70a2                	ld	ra,40(sp)
    80005312:	7402                	ld	s0,32(sp)
    80005314:	6145                	addi	sp,sp,48
    80005316:	8082                	ret
    80005318:	64e2                	ld	s1,24(sp)
    8000531a:	6942                	ld	s2,16(sp)
    8000531c:	bfcd                	j	8000530e <sys_dup+0x3c>

000000008000531e <sys_read>:
{
    8000531e:	7179                	addi	sp,sp,-48
    80005320:	f406                	sd	ra,40(sp)
    80005322:	f022                	sd	s0,32(sp)
    80005324:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005326:	fd840593          	addi	a1,s0,-40
    8000532a:	4505                	li	a0,1
    8000532c:	b69fd0ef          	jal	80002e94 <argaddr>
  argint(2, &n);
    80005330:	fe440593          	addi	a1,s0,-28
    80005334:	4509                	li	a0,2
    80005336:	b43fd0ef          	jal	80002e78 <argint>
  if(argfd(0, 0, &f) < 0)
    8000533a:	fe840613          	addi	a2,s0,-24
    8000533e:	4581                	li	a1,0
    80005340:	4501                	li	a0,0
    80005342:	dbfff0ef          	jal	80005100 <argfd>
    80005346:	87aa                	mv	a5,a0
    return -1;
    80005348:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000534a:	0007ca63          	bltz	a5,8000535e <sys_read+0x40>
  return fileread(f, p, n);
    8000534e:	fe442603          	lw	a2,-28(s0)
    80005352:	fd843583          	ld	a1,-40(s0)
    80005356:	fe843503          	ld	a0,-24(s0)
    8000535a:	ce0ff0ef          	jal	8000483a <fileread>
}
    8000535e:	70a2                	ld	ra,40(sp)
    80005360:	7402                	ld	s0,32(sp)
    80005362:	6145                	addi	sp,sp,48
    80005364:	8082                	ret

0000000080005366 <sys_write>:
{
    80005366:	7179                	addi	sp,sp,-48
    80005368:	f406                	sd	ra,40(sp)
    8000536a:	f022                	sd	s0,32(sp)
    8000536c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000536e:	fd840593          	addi	a1,s0,-40
    80005372:	4505                	li	a0,1
    80005374:	b21fd0ef          	jal	80002e94 <argaddr>
  argint(2, &n);
    80005378:	fe440593          	addi	a1,s0,-28
    8000537c:	4509                	li	a0,2
    8000537e:	afbfd0ef          	jal	80002e78 <argint>
  if(argfd(0, 0, &f) < 0)
    80005382:	fe840613          	addi	a2,s0,-24
    80005386:	4581                	li	a1,0
    80005388:	4501                	li	a0,0
    8000538a:	d77ff0ef          	jal	80005100 <argfd>
    8000538e:	87aa                	mv	a5,a0
    return -1;
    80005390:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005392:	0007ca63          	bltz	a5,800053a6 <sys_write+0x40>
  return filewrite(f, p, n);
    80005396:	fe442603          	lw	a2,-28(s0)
    8000539a:	fd843583          	ld	a1,-40(s0)
    8000539e:	fe843503          	ld	a0,-24(s0)
    800053a2:	d5cff0ef          	jal	800048fe <filewrite>
}
    800053a6:	70a2                	ld	ra,40(sp)
    800053a8:	7402                	ld	s0,32(sp)
    800053aa:	6145                	addi	sp,sp,48
    800053ac:	8082                	ret

00000000800053ae <sys_close>:
{
    800053ae:	1101                	addi	sp,sp,-32
    800053b0:	ec06                	sd	ra,24(sp)
    800053b2:	e822                	sd	s0,16(sp)
    800053b4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053b6:	fe040613          	addi	a2,s0,-32
    800053ba:	fec40593          	addi	a1,s0,-20
    800053be:	4501                	li	a0,0
    800053c0:	d41ff0ef          	jal	80005100 <argfd>
    return -1;
    800053c4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053c6:	02054163          	bltz	a0,800053e8 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800053ca:	d50fc0ef          	jal	8000191a <myproc>
    800053ce:	fec42783          	lw	a5,-20(s0)
    800053d2:	078e                	slli	a5,a5,0x3
    800053d4:	0c078793          	addi	a5,a5,192
    800053d8:	953e                	add	a0,a0,a5
    800053da:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800053de:	fe043503          	ld	a0,-32(s0)
    800053e2:	b32ff0ef          	jal	80004714 <fileclose>
  return 0;
    800053e6:	4781                	li	a5,0
}
    800053e8:	853e                	mv	a0,a5
    800053ea:	60e2                	ld	ra,24(sp)
    800053ec:	6442                	ld	s0,16(sp)
    800053ee:	6105                	addi	sp,sp,32
    800053f0:	8082                	ret

00000000800053f2 <sys_fstat>:
{
    800053f2:	1101                	addi	sp,sp,-32
    800053f4:	ec06                	sd	ra,24(sp)
    800053f6:	e822                	sd	s0,16(sp)
    800053f8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800053fa:	fe040593          	addi	a1,s0,-32
    800053fe:	4505                	li	a0,1
    80005400:	a95fd0ef          	jal	80002e94 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005404:	fe840613          	addi	a2,s0,-24
    80005408:	4581                	li	a1,0
    8000540a:	4501                	li	a0,0
    8000540c:	cf5ff0ef          	jal	80005100 <argfd>
    80005410:	87aa                	mv	a5,a0
    return -1;
    80005412:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005414:	0007c863          	bltz	a5,80005424 <sys_fstat+0x32>
  return filestat(f, st);
    80005418:	fe043583          	ld	a1,-32(s0)
    8000541c:	fe843503          	ld	a0,-24(s0)
    80005420:	bb6ff0ef          	jal	800047d6 <filestat>
}
    80005424:	60e2                	ld	ra,24(sp)
    80005426:	6442                	ld	s0,16(sp)
    80005428:	6105                	addi	sp,sp,32
    8000542a:	8082                	ret

000000008000542c <sys_link>:
{
    8000542c:	7169                	addi	sp,sp,-304
    8000542e:	f606                	sd	ra,296(sp)
    80005430:	f222                	sd	s0,288(sp)
    80005432:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005434:	08000613          	li	a2,128
    80005438:	ed040593          	addi	a1,s0,-304
    8000543c:	4501                	li	a0,0
    8000543e:	a73fd0ef          	jal	80002eb0 <argstr>
    return -1;
    80005442:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005444:	0c054e63          	bltz	a0,80005520 <sys_link+0xf4>
    80005448:	08000613          	li	a2,128
    8000544c:	f5040593          	addi	a1,s0,-176
    80005450:	4505                	li	a0,1
    80005452:	a5ffd0ef          	jal	80002eb0 <argstr>
    return -1;
    80005456:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005458:	0c054463          	bltz	a0,80005520 <sys_link+0xf4>
    8000545c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000545e:	e93fe0ef          	jal	800042f0 <begin_op>
  if((ip = namei(old)) == 0){
    80005462:	ed040513          	addi	a0,s0,-304
    80005466:	cadfe0ef          	jal	80004112 <namei>
    8000546a:	84aa                	mv	s1,a0
    8000546c:	c53d                	beqz	a0,800054da <sys_link+0xae>
  ilock(ip);
    8000546e:	c76fe0ef          	jal	800038e4 <ilock>
  if(ip->type == T_DIR){
    80005472:	04449703          	lh	a4,68(s1)
    80005476:	4785                	li	a5,1
    80005478:	06f70663          	beq	a4,a5,800054e4 <sys_link+0xb8>
    8000547c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000547e:	04a4d783          	lhu	a5,74(s1)
    80005482:	2785                	addiw	a5,a5,1
    80005484:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005488:	8526                	mv	a0,s1
    8000548a:	ba6fe0ef          	jal	80003830 <iupdate>
  iunlock(ip);
    8000548e:	8526                	mv	a0,s1
    80005490:	d02fe0ef          	jal	80003992 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005494:	fd040593          	addi	a1,s0,-48
    80005498:	f5040513          	addi	a0,s0,-176
    8000549c:	c91fe0ef          	jal	8000412c <nameiparent>
    800054a0:	892a                	mv	s2,a0
    800054a2:	cd21                	beqz	a0,800054fa <sys_link+0xce>
  ilock(dp);
    800054a4:	c40fe0ef          	jal	800038e4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054a8:	854a                	mv	a0,s2
    800054aa:	00092703          	lw	a4,0(s2)
    800054ae:	409c                	lw	a5,0(s1)
    800054b0:	04f71263          	bne	a4,a5,800054f4 <sys_link+0xc8>
    800054b4:	40d0                	lw	a2,4(s1)
    800054b6:	fd040593          	addi	a1,s0,-48
    800054ba:	baffe0ef          	jal	80004068 <dirlink>
    800054be:	02054b63          	bltz	a0,800054f4 <sys_link+0xc8>
  iunlockput(dp);
    800054c2:	854a                	mv	a0,s2
    800054c4:	e2cfe0ef          	jal	80003af0 <iunlockput>
  iput(ip);
    800054c8:	8526                	mv	a0,s1
    800054ca:	d9cfe0ef          	jal	80003a66 <iput>
  end_op();
    800054ce:	e93fe0ef          	jal	80004360 <end_op>
  return 0;
    800054d2:	4781                	li	a5,0
    800054d4:	64f2                	ld	s1,280(sp)
    800054d6:	6952                	ld	s2,272(sp)
    800054d8:	a0a1                	j	80005520 <sys_link+0xf4>
    end_op();
    800054da:	e87fe0ef          	jal	80004360 <end_op>
    return -1;
    800054de:	57fd                	li	a5,-1
    800054e0:	64f2                	ld	s1,280(sp)
    800054e2:	a83d                	j	80005520 <sys_link+0xf4>
    iunlockput(ip);
    800054e4:	8526                	mv	a0,s1
    800054e6:	e0afe0ef          	jal	80003af0 <iunlockput>
    end_op();
    800054ea:	e77fe0ef          	jal	80004360 <end_op>
    return -1;
    800054ee:	57fd                	li	a5,-1
    800054f0:	64f2                	ld	s1,280(sp)
    800054f2:	a03d                	j	80005520 <sys_link+0xf4>
    iunlockput(dp);
    800054f4:	854a                	mv	a0,s2
    800054f6:	dfafe0ef          	jal	80003af0 <iunlockput>
  ilock(ip);
    800054fa:	8526                	mv	a0,s1
    800054fc:	be8fe0ef          	jal	800038e4 <ilock>
  ip->nlink--;
    80005500:	04a4d783          	lhu	a5,74(s1)
    80005504:	37fd                	addiw	a5,a5,-1
    80005506:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000550a:	8526                	mv	a0,s1
    8000550c:	b24fe0ef          	jal	80003830 <iupdate>
  iunlockput(ip);
    80005510:	8526                	mv	a0,s1
    80005512:	ddefe0ef          	jal	80003af0 <iunlockput>
  end_op();
    80005516:	e4bfe0ef          	jal	80004360 <end_op>
  return -1;
    8000551a:	57fd                	li	a5,-1
    8000551c:	64f2                	ld	s1,280(sp)
    8000551e:	6952                	ld	s2,272(sp)
}
    80005520:	853e                	mv	a0,a5
    80005522:	70b2                	ld	ra,296(sp)
    80005524:	7412                	ld	s0,288(sp)
    80005526:	6155                	addi	sp,sp,304
    80005528:	8082                	ret

000000008000552a <sys_unlink>:
{
    8000552a:	7151                	addi	sp,sp,-240
    8000552c:	f586                	sd	ra,232(sp)
    8000552e:	f1a2                	sd	s0,224(sp)
    80005530:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005532:	08000613          	li	a2,128
    80005536:	f3040593          	addi	a1,s0,-208
    8000553a:	4501                	li	a0,0
    8000553c:	975fd0ef          	jal	80002eb0 <argstr>
    80005540:	14054d63          	bltz	a0,8000569a <sys_unlink+0x170>
    80005544:	eda6                	sd	s1,216(sp)
  begin_op();
    80005546:	dabfe0ef          	jal	800042f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000554a:	fb040593          	addi	a1,s0,-80
    8000554e:	f3040513          	addi	a0,s0,-208
    80005552:	bdbfe0ef          	jal	8000412c <nameiparent>
    80005556:	84aa                	mv	s1,a0
    80005558:	c955                	beqz	a0,8000560c <sys_unlink+0xe2>
  ilock(dp);
    8000555a:	b8afe0ef          	jal	800038e4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000555e:	00003597          	auipc	a1,0x3
    80005562:	0b258593          	addi	a1,a1,178 # 80008610 <etext+0x610>
    80005566:	fb040513          	addi	a0,s0,-80
    8000556a:	8fffe0ef          	jal	80003e68 <namecmp>
    8000556e:	10050b63          	beqz	a0,80005684 <sys_unlink+0x15a>
    80005572:	00003597          	auipc	a1,0x3
    80005576:	0a658593          	addi	a1,a1,166 # 80008618 <etext+0x618>
    8000557a:	fb040513          	addi	a0,s0,-80
    8000557e:	8ebfe0ef          	jal	80003e68 <namecmp>
    80005582:	10050163          	beqz	a0,80005684 <sys_unlink+0x15a>
    80005586:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005588:	f2c40613          	addi	a2,s0,-212
    8000558c:	fb040593          	addi	a1,s0,-80
    80005590:	8526                	mv	a0,s1
    80005592:	8edfe0ef          	jal	80003e7e <dirlookup>
    80005596:	892a                	mv	s2,a0
    80005598:	0e050563          	beqz	a0,80005682 <sys_unlink+0x158>
    8000559c:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000559e:	b46fe0ef          	jal	800038e4 <ilock>
  if(ip->nlink < 1)
    800055a2:	04a91783          	lh	a5,74(s2)
    800055a6:	06f05863          	blez	a5,80005616 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055aa:	04491703          	lh	a4,68(s2)
    800055ae:	4785                	li	a5,1
    800055b0:	06f70963          	beq	a4,a5,80005622 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800055b4:	fc040993          	addi	s3,s0,-64
    800055b8:	4641                	li	a2,16
    800055ba:	4581                	li	a1,0
    800055bc:	854e                	mv	a0,s3
    800055be:	f3afb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055c2:	4741                	li	a4,16
    800055c4:	f2c42683          	lw	a3,-212(s0)
    800055c8:	864e                	mv	a2,s3
    800055ca:	4581                	li	a1,0
    800055cc:	8526                	mv	a0,s1
    800055ce:	f9afe0ef          	jal	80003d68 <writei>
    800055d2:	47c1                	li	a5,16
    800055d4:	08f51863          	bne	a0,a5,80005664 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800055d8:	04491703          	lh	a4,68(s2)
    800055dc:	4785                	li	a5,1
    800055de:	08f70963          	beq	a4,a5,80005670 <sys_unlink+0x146>
  iunlockput(dp);
    800055e2:	8526                	mv	a0,s1
    800055e4:	d0cfe0ef          	jal	80003af0 <iunlockput>
  ip->nlink--;
    800055e8:	04a95783          	lhu	a5,74(s2)
    800055ec:	37fd                	addiw	a5,a5,-1
    800055ee:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055f2:	854a                	mv	a0,s2
    800055f4:	a3cfe0ef          	jal	80003830 <iupdate>
  iunlockput(ip);
    800055f8:	854a                	mv	a0,s2
    800055fa:	cf6fe0ef          	jal	80003af0 <iunlockput>
  end_op();
    800055fe:	d63fe0ef          	jal	80004360 <end_op>
  return 0;
    80005602:	4501                	li	a0,0
    80005604:	64ee                	ld	s1,216(sp)
    80005606:	694e                	ld	s2,208(sp)
    80005608:	69ae                	ld	s3,200(sp)
    8000560a:	a061                	j	80005692 <sys_unlink+0x168>
    end_op();
    8000560c:	d55fe0ef          	jal	80004360 <end_op>
    return -1;
    80005610:	557d                	li	a0,-1
    80005612:	64ee                	ld	s1,216(sp)
    80005614:	a8bd                	j	80005692 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80005616:	00003517          	auipc	a0,0x3
    8000561a:	00a50513          	addi	a0,a0,10 # 80008620 <etext+0x620>
    8000561e:	a06fb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005622:	04c92703          	lw	a4,76(s2)
    80005626:	02000793          	li	a5,32
    8000562a:	f8e7f5e3          	bgeu	a5,a4,800055b4 <sys_unlink+0x8a>
    8000562e:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005630:	4741                	li	a4,16
    80005632:	86ce                	mv	a3,s3
    80005634:	f1840613          	addi	a2,s0,-232
    80005638:	4581                	li	a1,0
    8000563a:	854a                	mv	a0,s2
    8000563c:	e3afe0ef          	jal	80003c76 <readi>
    80005640:	47c1                	li	a5,16
    80005642:	00f51b63          	bne	a0,a5,80005658 <sys_unlink+0x12e>
    if(de.inum != 0)
    80005646:	f1845783          	lhu	a5,-232(s0)
    8000564a:	ebb1                	bnez	a5,8000569e <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000564c:	29c1                	addiw	s3,s3,16
    8000564e:	04c92783          	lw	a5,76(s2)
    80005652:	fcf9efe3          	bltu	s3,a5,80005630 <sys_unlink+0x106>
    80005656:	bfb9                	j	800055b4 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005658:	00003517          	auipc	a0,0x3
    8000565c:	fe050513          	addi	a0,a0,-32 # 80008638 <etext+0x638>
    80005660:	9c4fb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80005664:	00003517          	auipc	a0,0x3
    80005668:	fec50513          	addi	a0,a0,-20 # 80008650 <etext+0x650>
    8000566c:	9b8fb0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005670:	04a4d783          	lhu	a5,74(s1)
    80005674:	37fd                	addiw	a5,a5,-1
    80005676:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000567a:	8526                	mv	a0,s1
    8000567c:	9b4fe0ef          	jal	80003830 <iupdate>
    80005680:	b78d                	j	800055e2 <sys_unlink+0xb8>
    80005682:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005684:	8526                	mv	a0,s1
    80005686:	c6afe0ef          	jal	80003af0 <iunlockput>
  end_op();
    8000568a:	cd7fe0ef          	jal	80004360 <end_op>
  return -1;
    8000568e:	557d                	li	a0,-1
    80005690:	64ee                	ld	s1,216(sp)
}
    80005692:	70ae                	ld	ra,232(sp)
    80005694:	740e                	ld	s0,224(sp)
    80005696:	616d                	addi	sp,sp,240
    80005698:	8082                	ret
    return -1;
    8000569a:	557d                	li	a0,-1
    8000569c:	bfdd                	j	80005692 <sys_unlink+0x168>
    iunlockput(ip);
    8000569e:	854a                	mv	a0,s2
    800056a0:	c50fe0ef          	jal	80003af0 <iunlockput>
    goto bad;
    800056a4:	694e                	ld	s2,208(sp)
    800056a6:	69ae                	ld	s3,200(sp)
    800056a8:	bff1                	j	80005684 <sys_unlink+0x15a>

00000000800056aa <sys_open>:

uint64
sys_open(void)
{
    800056aa:	7131                	addi	sp,sp,-192
    800056ac:	fd06                	sd	ra,184(sp)
    800056ae:	f922                	sd	s0,176(sp)
    800056b0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800056b2:	f4c40593          	addi	a1,s0,-180
    800056b6:	4505                	li	a0,1
    800056b8:	fc0fd0ef          	jal	80002e78 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800056bc:	08000613          	li	a2,128
    800056c0:	f5040593          	addi	a1,s0,-176
    800056c4:	4501                	li	a0,0
    800056c6:	feafd0ef          	jal	80002eb0 <argstr>
    800056ca:	87aa                	mv	a5,a0
    return -1;
    800056cc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800056ce:	0a07c363          	bltz	a5,80005774 <sys_open+0xca>
    800056d2:	f526                	sd	s1,168(sp)

  begin_op();
    800056d4:	c1dfe0ef          	jal	800042f0 <begin_op>

  if(omode & O_CREATE){
    800056d8:	f4c42783          	lw	a5,-180(s0)
    800056dc:	2007f793          	andi	a5,a5,512
    800056e0:	c3dd                	beqz	a5,80005786 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800056e2:	4681                	li	a3,0
    800056e4:	4601                	li	a2,0
    800056e6:	4589                	li	a1,2
    800056e8:	f5040513          	addi	a0,s0,-176
    800056ec:	aafff0ef          	jal	8000519a <create>
    800056f0:	84aa                	mv	s1,a0
    if(ip == 0){
    800056f2:	c549                	beqz	a0,8000577c <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056f4:	04449703          	lh	a4,68(s1)
    800056f8:	478d                	li	a5,3
    800056fa:	00f71763          	bne	a4,a5,80005708 <sys_open+0x5e>
    800056fe:	0464d703          	lhu	a4,70(s1)
    80005702:	47a5                	li	a5,9
    80005704:	0ae7ee63          	bltu	a5,a4,800057c0 <sys_open+0x116>
    80005708:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000570a:	f67fe0ef          	jal	80004670 <filealloc>
    8000570e:	892a                	mv	s2,a0
    80005710:	c561                	beqz	a0,800057d8 <sys_open+0x12e>
    80005712:	ed4e                	sd	s3,152(sp)
    80005714:	a47ff0ef          	jal	8000515a <fdalloc>
    80005718:	89aa                	mv	s3,a0
    8000571a:	0a054b63          	bltz	a0,800057d0 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000571e:	04449703          	lh	a4,68(s1)
    80005722:	478d                	li	a5,3
    80005724:	0cf70363          	beq	a4,a5,800057ea <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005728:	4789                	li	a5,2
    8000572a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000572e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005732:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005736:	f4c42783          	lw	a5,-180(s0)
    8000573a:	0017f713          	andi	a4,a5,1
    8000573e:	00174713          	xori	a4,a4,1
    80005742:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005746:	0037f713          	andi	a4,a5,3
    8000574a:	00e03733          	snez	a4,a4
    8000574e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005752:	4007f793          	andi	a5,a5,1024
    80005756:	c791                	beqz	a5,80005762 <sys_open+0xb8>
    80005758:	04449703          	lh	a4,68(s1)
    8000575c:	4789                	li	a5,2
    8000575e:	08f70d63          	beq	a4,a5,800057f8 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005762:	8526                	mv	a0,s1
    80005764:	a2efe0ef          	jal	80003992 <iunlock>
  end_op();
    80005768:	bf9fe0ef          	jal	80004360 <end_op>

  return fd;
    8000576c:	854e                	mv	a0,s3
    8000576e:	74aa                	ld	s1,168(sp)
    80005770:	790a                	ld	s2,160(sp)
    80005772:	69ea                	ld	s3,152(sp)
}
    80005774:	70ea                	ld	ra,184(sp)
    80005776:	744a                	ld	s0,176(sp)
    80005778:	6129                	addi	sp,sp,192
    8000577a:	8082                	ret
      end_op();
    8000577c:	be5fe0ef          	jal	80004360 <end_op>
      return -1;
    80005780:	557d                	li	a0,-1
    80005782:	74aa                	ld	s1,168(sp)
    80005784:	bfc5                	j	80005774 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005786:	f5040513          	addi	a0,s0,-176
    8000578a:	989fe0ef          	jal	80004112 <namei>
    8000578e:	84aa                	mv	s1,a0
    80005790:	c11d                	beqz	a0,800057b6 <sys_open+0x10c>
    ilock(ip);
    80005792:	952fe0ef          	jal	800038e4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005796:	04449703          	lh	a4,68(s1)
    8000579a:	4785                	li	a5,1
    8000579c:	f4f71ce3          	bne	a4,a5,800056f4 <sys_open+0x4a>
    800057a0:	f4c42783          	lw	a5,-180(s0)
    800057a4:	d3b5                	beqz	a5,80005708 <sys_open+0x5e>
      iunlockput(ip);
    800057a6:	8526                	mv	a0,s1
    800057a8:	b48fe0ef          	jal	80003af0 <iunlockput>
      end_op();
    800057ac:	bb5fe0ef          	jal	80004360 <end_op>
      return -1;
    800057b0:	557d                	li	a0,-1
    800057b2:	74aa                	ld	s1,168(sp)
    800057b4:	b7c1                	j	80005774 <sys_open+0xca>
      end_op();
    800057b6:	babfe0ef          	jal	80004360 <end_op>
      return -1;
    800057ba:	557d                	li	a0,-1
    800057bc:	74aa                	ld	s1,168(sp)
    800057be:	bf5d                	j	80005774 <sys_open+0xca>
    iunlockput(ip);
    800057c0:	8526                	mv	a0,s1
    800057c2:	b2efe0ef          	jal	80003af0 <iunlockput>
    end_op();
    800057c6:	b9bfe0ef          	jal	80004360 <end_op>
    return -1;
    800057ca:	557d                	li	a0,-1
    800057cc:	74aa                	ld	s1,168(sp)
    800057ce:	b75d                	j	80005774 <sys_open+0xca>
      fileclose(f);
    800057d0:	854a                	mv	a0,s2
    800057d2:	f43fe0ef          	jal	80004714 <fileclose>
    800057d6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800057d8:	8526                	mv	a0,s1
    800057da:	b16fe0ef          	jal	80003af0 <iunlockput>
    end_op();
    800057de:	b83fe0ef          	jal	80004360 <end_op>
    return -1;
    800057e2:	557d                	li	a0,-1
    800057e4:	74aa                	ld	s1,168(sp)
    800057e6:	790a                	ld	s2,160(sp)
    800057e8:	b771                	j	80005774 <sys_open+0xca>
    f->type = FD_DEVICE;
    800057ea:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800057ee:	04649783          	lh	a5,70(s1)
    800057f2:	02f91223          	sh	a5,36(s2)
    800057f6:	bf35                	j	80005732 <sys_open+0x88>
    itrunc(ip);
    800057f8:	8526                	mv	a0,s1
    800057fa:	9d8fe0ef          	jal	800039d2 <itrunc>
    800057fe:	b795                	j	80005762 <sys_open+0xb8>

0000000080005800 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005800:	7175                	addi	sp,sp,-144
    80005802:	e506                	sd	ra,136(sp)
    80005804:	e122                	sd	s0,128(sp)
    80005806:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005808:	ae9fe0ef          	jal	800042f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000580c:	08000613          	li	a2,128
    80005810:	f7040593          	addi	a1,s0,-144
    80005814:	4501                	li	a0,0
    80005816:	e9afd0ef          	jal	80002eb0 <argstr>
    8000581a:	02054363          	bltz	a0,80005840 <sys_mkdir+0x40>
    8000581e:	4681                	li	a3,0
    80005820:	4601                	li	a2,0
    80005822:	4585                	li	a1,1
    80005824:	f7040513          	addi	a0,s0,-144
    80005828:	973ff0ef          	jal	8000519a <create>
    8000582c:	c911                	beqz	a0,80005840 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000582e:	ac2fe0ef          	jal	80003af0 <iunlockput>
  end_op();
    80005832:	b2ffe0ef          	jal	80004360 <end_op>
  return 0;
    80005836:	4501                	li	a0,0
}
    80005838:	60aa                	ld	ra,136(sp)
    8000583a:	640a                	ld	s0,128(sp)
    8000583c:	6149                	addi	sp,sp,144
    8000583e:	8082                	ret
    end_op();
    80005840:	b21fe0ef          	jal	80004360 <end_op>
    return -1;
    80005844:	557d                	li	a0,-1
    80005846:	bfcd                	j	80005838 <sys_mkdir+0x38>

0000000080005848 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005848:	7135                	addi	sp,sp,-160
    8000584a:	ed06                	sd	ra,152(sp)
    8000584c:	e922                	sd	s0,144(sp)
    8000584e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005850:	aa1fe0ef          	jal	800042f0 <begin_op>
  argint(1, &major);
    80005854:	f6c40593          	addi	a1,s0,-148
    80005858:	4505                	li	a0,1
    8000585a:	e1efd0ef          	jal	80002e78 <argint>
  argint(2, &minor);
    8000585e:	f6840593          	addi	a1,s0,-152
    80005862:	4509                	li	a0,2
    80005864:	e14fd0ef          	jal	80002e78 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005868:	08000613          	li	a2,128
    8000586c:	f7040593          	addi	a1,s0,-144
    80005870:	4501                	li	a0,0
    80005872:	e3efd0ef          	jal	80002eb0 <argstr>
    80005876:	02054563          	bltz	a0,800058a0 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000587a:	f6841683          	lh	a3,-152(s0)
    8000587e:	f6c41603          	lh	a2,-148(s0)
    80005882:	458d                	li	a1,3
    80005884:	f7040513          	addi	a0,s0,-144
    80005888:	913ff0ef          	jal	8000519a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000588c:	c911                	beqz	a0,800058a0 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000588e:	a62fe0ef          	jal	80003af0 <iunlockput>
  end_op();
    80005892:	acffe0ef          	jal	80004360 <end_op>
  return 0;
    80005896:	4501                	li	a0,0
}
    80005898:	60ea                	ld	ra,152(sp)
    8000589a:	644a                	ld	s0,144(sp)
    8000589c:	610d                	addi	sp,sp,160
    8000589e:	8082                	ret
    end_op();
    800058a0:	ac1fe0ef          	jal	80004360 <end_op>
    return -1;
    800058a4:	557d                	li	a0,-1
    800058a6:	bfcd                	j	80005898 <sys_mknod+0x50>

00000000800058a8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800058a8:	7135                	addi	sp,sp,-160
    800058aa:	ed06                	sd	ra,152(sp)
    800058ac:	e922                	sd	s0,144(sp)
    800058ae:	e14a                	sd	s2,128(sp)
    800058b0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058b2:	868fc0ef          	jal	8000191a <myproc>
    800058b6:	892a                	mv	s2,a0

  begin_op();
    800058b8:	a39fe0ef          	jal	800042f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800058bc:	08000613          	li	a2,128
    800058c0:	f6040593          	addi	a1,s0,-160
    800058c4:	4501                	li	a0,0
    800058c6:	deafd0ef          	jal	80002eb0 <argstr>
    800058ca:	04054363          	bltz	a0,80005910 <sys_chdir+0x68>
    800058ce:	e526                	sd	s1,136(sp)
    800058d0:	f6040513          	addi	a0,s0,-160
    800058d4:	83ffe0ef          	jal	80004112 <namei>
    800058d8:	84aa                	mv	s1,a0
    800058da:	c915                	beqz	a0,8000590e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800058dc:	808fe0ef          	jal	800038e4 <ilock>
  if(ip->type != T_DIR){
    800058e0:	04449703          	lh	a4,68(s1)
    800058e4:	4785                	li	a5,1
    800058e6:	02f71963          	bne	a4,a5,80005918 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800058ea:	8526                	mv	a0,s1
    800058ec:	8a6fe0ef          	jal	80003992 <iunlock>
  iput(p->cwd);
    800058f0:	14893503          	ld	a0,328(s2)
    800058f4:	972fe0ef          	jal	80003a66 <iput>
  end_op();
    800058f8:	a69fe0ef          	jal	80004360 <end_op>
  p->cwd = ip;
    800058fc:	14993423          	sd	s1,328(s2)
  return 0;
    80005900:	4501                	li	a0,0
    80005902:	64aa                	ld	s1,136(sp)
}
    80005904:	60ea                	ld	ra,152(sp)
    80005906:	644a                	ld	s0,144(sp)
    80005908:	690a                	ld	s2,128(sp)
    8000590a:	610d                	addi	sp,sp,160
    8000590c:	8082                	ret
    8000590e:	64aa                	ld	s1,136(sp)
    end_op();
    80005910:	a51fe0ef          	jal	80004360 <end_op>
    return -1;
    80005914:	557d                	li	a0,-1
    80005916:	b7fd                	j	80005904 <sys_chdir+0x5c>
    iunlockput(ip);
    80005918:	8526                	mv	a0,s1
    8000591a:	9d6fe0ef          	jal	80003af0 <iunlockput>
    end_op();
    8000591e:	a43fe0ef          	jal	80004360 <end_op>
    return -1;
    80005922:	557d                	li	a0,-1
    80005924:	64aa                	ld	s1,136(sp)
    80005926:	bff9                	j	80005904 <sys_chdir+0x5c>

0000000080005928 <sys_exec>:

uint64
sys_exec(void)
{
    80005928:	7105                	addi	sp,sp,-480
    8000592a:	ef86                	sd	ra,472(sp)
    8000592c:	eba2                	sd	s0,464(sp)
    8000592e:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005930:	e2840593          	addi	a1,s0,-472
    80005934:	4505                	li	a0,1
    80005936:	d5efd0ef          	jal	80002e94 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000593a:	08000613          	li	a2,128
    8000593e:	f3040593          	addi	a1,s0,-208
    80005942:	4501                	li	a0,0
    80005944:	d6cfd0ef          	jal	80002eb0 <argstr>
    80005948:	87aa                	mv	a5,a0
    return -1;
    8000594a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000594c:	0e07c063          	bltz	a5,80005a2c <sys_exec+0x104>
    80005950:	e7a6                	sd	s1,456(sp)
    80005952:	e3ca                	sd	s2,448(sp)
    80005954:	ff4e                	sd	s3,440(sp)
    80005956:	fb52                	sd	s4,432(sp)
    80005958:	f756                	sd	s5,424(sp)
    8000595a:	f35a                	sd	s6,416(sp)
    8000595c:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000595e:	e3040a13          	addi	s4,s0,-464
    80005962:	10000613          	li	a2,256
    80005966:	4581                	li	a1,0
    80005968:	8552                	mv	a0,s4
    8000596a:	b8efb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000596e:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005970:	89d2                	mv	s3,s4
    80005972:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005974:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005978:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000597a:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000597e:	00391513          	slli	a0,s2,0x3
    80005982:	85d6                	mv	a1,s5
    80005984:	e2843783          	ld	a5,-472(s0)
    80005988:	953e                	add	a0,a0,a5
    8000598a:	c60fd0ef          	jal	80002dea <fetchaddr>
    8000598e:	02054663          	bltz	a0,800059ba <sys_exec+0x92>
    if(uarg == 0){
    80005992:	e2043783          	ld	a5,-480(s0)
    80005996:	c7a1                	beqz	a5,800059de <sys_exec+0xb6>
    argv[i] = kalloc();
    80005998:	9acfb0ef          	jal	80000b44 <kalloc>
    8000599c:	85aa                	mv	a1,a0
    8000599e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800059a2:	cd01                	beqz	a0,800059ba <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800059a4:	865a                	mv	a2,s6
    800059a6:	e2043503          	ld	a0,-480(s0)
    800059aa:	c8cfd0ef          	jal	80002e36 <fetchstr>
    800059ae:	00054663          	bltz	a0,800059ba <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800059b2:	0905                	addi	s2,s2,1
    800059b4:	09a1                	addi	s3,s3,8
    800059b6:	fd7914e3          	bne	s2,s7,8000597e <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059ba:	100a0a13          	addi	s4,s4,256
    800059be:	6088                	ld	a0,0(s1)
    800059c0:	cd31                	beqz	a0,80005a1c <sys_exec+0xf4>
    kfree(argv[i]);
    800059c2:	89afb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059c6:	04a1                	addi	s1,s1,8
    800059c8:	ff449be3          	bne	s1,s4,800059be <sys_exec+0x96>
  return -1;
    800059cc:	557d                	li	a0,-1
    800059ce:	64be                	ld	s1,456(sp)
    800059d0:	691e                	ld	s2,448(sp)
    800059d2:	79fa                	ld	s3,440(sp)
    800059d4:	7a5a                	ld	s4,432(sp)
    800059d6:	7aba                	ld	s5,424(sp)
    800059d8:	7b1a                	ld	s6,416(sp)
    800059da:	6bfa                	ld	s7,408(sp)
    800059dc:	a881                	j	80005a2c <sys_exec+0x104>
      argv[i] = 0;
    800059de:	0009079b          	sext.w	a5,s2
    800059e2:	e3040593          	addi	a1,s0,-464
    800059e6:	078e                	slli	a5,a5,0x3
    800059e8:	97ae                	add	a5,a5,a1
    800059ea:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800059ee:	f3040513          	addi	a0,s0,-208
    800059f2:	b74ff0ef          	jal	80004d66 <kexec>
    800059f6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059f8:	100a0a13          	addi	s4,s4,256
    800059fc:	6088                	ld	a0,0(s1)
    800059fe:	c511                	beqz	a0,80005a0a <sys_exec+0xe2>
    kfree(argv[i]);
    80005a00:	85cfb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a04:	04a1                	addi	s1,s1,8
    80005a06:	ff449be3          	bne	s1,s4,800059fc <sys_exec+0xd4>
  return ret;
    80005a0a:	854a                	mv	a0,s2
    80005a0c:	64be                	ld	s1,456(sp)
    80005a0e:	691e                	ld	s2,448(sp)
    80005a10:	79fa                	ld	s3,440(sp)
    80005a12:	7a5a                	ld	s4,432(sp)
    80005a14:	7aba                	ld	s5,424(sp)
    80005a16:	7b1a                	ld	s6,416(sp)
    80005a18:	6bfa                	ld	s7,408(sp)
    80005a1a:	a809                	j	80005a2c <sys_exec+0x104>
  return -1;
    80005a1c:	557d                	li	a0,-1
    80005a1e:	64be                	ld	s1,456(sp)
    80005a20:	691e                	ld	s2,448(sp)
    80005a22:	79fa                	ld	s3,440(sp)
    80005a24:	7a5a                	ld	s4,432(sp)
    80005a26:	7aba                	ld	s5,424(sp)
    80005a28:	7b1a                	ld	s6,416(sp)
    80005a2a:	6bfa                	ld	s7,408(sp)
}
    80005a2c:	60fe                	ld	ra,472(sp)
    80005a2e:	645e                	ld	s0,464(sp)
    80005a30:	613d                	addi	sp,sp,480
    80005a32:	8082                	ret

0000000080005a34 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005a34:	7139                	addi	sp,sp,-64
    80005a36:	fc06                	sd	ra,56(sp)
    80005a38:	f822                	sd	s0,48(sp)
    80005a3a:	f426                	sd	s1,40(sp)
    80005a3c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005a3e:	eddfb0ef          	jal	8000191a <myproc>
    80005a42:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005a44:	fd840593          	addi	a1,s0,-40
    80005a48:	4501                	li	a0,0
    80005a4a:	c4afd0ef          	jal	80002e94 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005a4e:	fc840593          	addi	a1,s0,-56
    80005a52:	fd040513          	addi	a0,s0,-48
    80005a56:	fddfe0ef          	jal	80004a32 <pipealloc>
    return -1;
    80005a5a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a5c:	0a054963          	bltz	a0,80005b0e <sys_pipe+0xda>
  fd0 = -1;
    80005a60:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a64:	fd043503          	ld	a0,-48(s0)
    80005a68:	ef2ff0ef          	jal	8000515a <fdalloc>
    80005a6c:	fca42223          	sw	a0,-60(s0)
    80005a70:	08054663          	bltz	a0,80005afc <sys_pipe+0xc8>
    80005a74:	fc843503          	ld	a0,-56(s0)
    80005a78:	ee2ff0ef          	jal	8000515a <fdalloc>
    80005a7c:	fca42023          	sw	a0,-64(s0)
    80005a80:	06054463          	bltz	a0,80005ae8 <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->mm->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a84:	64bc                	ld	a5,72(s1)
    80005a86:	4691                	li	a3,4
    80005a88:	fc440613          	addi	a2,s0,-60
    80005a8c:	fd843583          	ld	a1,-40(s0)
    80005a90:	6388                	ld	a0,0(a5)
    80005a92:	bc7fb0ef          	jal	80001658 <copyout>
    80005a96:	00054f63          	bltz	a0,80005ab4 <sys_pipe+0x80>
     copyout(p->mm->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a9a:	64bc                	ld	a5,72(s1)
    80005a9c:	4691                	li	a3,4
    80005a9e:	fc040613          	addi	a2,s0,-64
    80005aa2:	fd843583          	ld	a1,-40(s0)
    80005aa6:	95b6                	add	a1,a1,a3
    80005aa8:	6388                	ld	a0,0(a5)
    80005aaa:	baffb0ef          	jal	80001658 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005aae:	4781                	li	a5,0
  if(copyout(p->mm->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ab0:	04055f63          	bgez	a0,80005b0e <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    80005ab4:	fc442783          	lw	a5,-60(s0)
    80005ab8:	078e                	slli	a5,a5,0x3
    80005aba:	0c078793          	addi	a5,a5,192
    80005abe:	97a6                	add	a5,a5,s1
    80005ac0:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005ac4:	fc042783          	lw	a5,-64(s0)
    80005ac8:	078e                	slli	a5,a5,0x3
    80005aca:	0c078793          	addi	a5,a5,192
    80005ace:	94be                	add	s1,s1,a5
    80005ad0:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005ad4:	fd043503          	ld	a0,-48(s0)
    80005ad8:	c3dfe0ef          	jal	80004714 <fileclose>
    fileclose(wf);
    80005adc:	fc843503          	ld	a0,-56(s0)
    80005ae0:	c35fe0ef          	jal	80004714 <fileclose>
    return -1;
    80005ae4:	57fd                	li	a5,-1
    80005ae6:	a025                	j	80005b0e <sys_pipe+0xda>
    if(fd0 >= 0)
    80005ae8:	fc442783          	lw	a5,-60(s0)
    80005aec:	0007c863          	bltz	a5,80005afc <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    80005af0:	078e                	slli	a5,a5,0x3
    80005af2:	0c078793          	addi	a5,a5,192
    80005af6:	97a6                	add	a5,a5,s1
    80005af8:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005afc:	fd043503          	ld	a0,-48(s0)
    80005b00:	c15fe0ef          	jal	80004714 <fileclose>
    fileclose(wf);
    80005b04:	fc843503          	ld	a0,-56(s0)
    80005b08:	c0dfe0ef          	jal	80004714 <fileclose>
    return -1;
    80005b0c:	57fd                	li	a5,-1
}
    80005b0e:	853e                	mv	a0,a5
    80005b10:	70e2                	ld	ra,56(sp)
    80005b12:	7442                	ld	s0,48(sp)
    80005b14:	74a2                	ld	s1,40(sp)
    80005b16:	6121                	addi	sp,sp,64
    80005b18:	8082                	ret
    80005b1a:	0000                	unimp
    80005b1c:	0000                	unimp
	...

0000000080005b20 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005b20:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005b22:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005b24:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005b26:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005b28:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005b2a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005b2c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005b2e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005b30:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005b32:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005b34:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005b36:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005b38:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005b3a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005b3c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005b3e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005b40:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005b42:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005b44:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005b46:	9b2fd0ef          	jal	80002cf8 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005b4a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005b4c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005b4e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005b50:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005b52:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005b54:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005b56:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005b58:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005b5a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005b5c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005b5e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005b60:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005b62:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005b64:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005b66:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005b68:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005b6a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005b6c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005b6e:	10200073          	sret
    80005b72:	00000013          	nop
    80005b76:	00000013          	nop
    80005b7a:	00000013          	nop

0000000080005b7e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005b7e:	1141                	addi	sp,sp,-16
    80005b80:	e406                	sd	ra,8(sp)
    80005b82:	e022                	sd	s0,0(sp)
    80005b84:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005b86:	0c000737          	lui	a4,0xc000
    80005b8a:	4785                	li	a5,1
    80005b8c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005b8e:	c35c                	sw	a5,4(a4)
}
    80005b90:	60a2                	ld	ra,8(sp)
    80005b92:	6402                	ld	s0,0(sp)
    80005b94:	0141                	addi	sp,sp,16
    80005b96:	8082                	ret

0000000080005b98 <plicinithart>:

void
plicinithart(void)
{
    80005b98:	1141                	addi	sp,sp,-16
    80005b9a:	e406                	sd	ra,8(sp)
    80005b9c:	e022                	sd	s0,0(sp)
    80005b9e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ba0:	d47fb0ef          	jal	800018e6 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005ba4:	0085171b          	slliw	a4,a0,0x8
    80005ba8:	0c0027b7          	lui	a5,0xc002
    80005bac:	97ba                	add	a5,a5,a4
    80005bae:	40200713          	li	a4,1026
    80005bb2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005bb6:	00d5151b          	slliw	a0,a0,0xd
    80005bba:	0c2017b7          	lui	a5,0xc201
    80005bbe:	97aa                	add	a5,a5,a0
    80005bc0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005bc4:	60a2                	ld	ra,8(sp)
    80005bc6:	6402                	ld	s0,0(sp)
    80005bc8:	0141                	addi	sp,sp,16
    80005bca:	8082                	ret

0000000080005bcc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005bcc:	1141                	addi	sp,sp,-16
    80005bce:	e406                	sd	ra,8(sp)
    80005bd0:	e022                	sd	s0,0(sp)
    80005bd2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bd4:	d13fb0ef          	jal	800018e6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005bd8:	00d5151b          	slliw	a0,a0,0xd
    80005bdc:	0c2017b7          	lui	a5,0xc201
    80005be0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005be2:	43c8                	lw	a0,4(a5)
    80005be4:	60a2                	ld	ra,8(sp)
    80005be6:	6402                	ld	s0,0(sp)
    80005be8:	0141                	addi	sp,sp,16
    80005bea:	8082                	ret

0000000080005bec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005bec:	1101                	addi	sp,sp,-32
    80005bee:	ec06                	sd	ra,24(sp)
    80005bf0:	e822                	sd	s0,16(sp)
    80005bf2:	e426                	sd	s1,8(sp)
    80005bf4:	1000                	addi	s0,sp,32
    80005bf6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005bf8:	ceffb0ef          	jal	800018e6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005bfc:	00d5179b          	slliw	a5,a0,0xd
    80005c00:	0c201737          	lui	a4,0xc201
    80005c04:	97ba                	add	a5,a5,a4
    80005c06:	c3c4                	sw	s1,4(a5)
}
    80005c08:	60e2                	ld	ra,24(sp)
    80005c0a:	6442                	ld	s0,16(sp)
    80005c0c:	64a2                	ld	s1,8(sp)
    80005c0e:	6105                	addi	sp,sp,32
    80005c10:	8082                	ret

0000000080005c12 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005c12:	1141                	addi	sp,sp,-16
    80005c14:	e406                	sd	ra,8(sp)
    80005c16:	e022                	sd	s0,0(sp)
    80005c18:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005c1a:	479d                	li	a5,7
    80005c1c:	04a7ca63          	blt	a5,a0,80005c70 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005c20:	0001c797          	auipc	a5,0x1c
    80005c24:	46878793          	addi	a5,a5,1128 # 80022088 <disk>
    80005c28:	97aa                	add	a5,a5,a0
    80005c2a:	0187c783          	lbu	a5,24(a5)
    80005c2e:	e7b9                	bnez	a5,80005c7c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005c30:	00451693          	slli	a3,a0,0x4
    80005c34:	0001c797          	auipc	a5,0x1c
    80005c38:	45478793          	addi	a5,a5,1108 # 80022088 <disk>
    80005c3c:	6398                	ld	a4,0(a5)
    80005c3e:	9736                	add	a4,a4,a3
    80005c40:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005c44:	6398                	ld	a4,0(a5)
    80005c46:	9736                	add	a4,a4,a3
    80005c48:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005c4c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005c50:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005c54:	97aa                	add	a5,a5,a0
    80005c56:	4705                	li	a4,1
    80005c58:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005c5c:	0001c517          	auipc	a0,0x1c
    80005c60:	44450513          	addi	a0,a0,1092 # 800220a0 <disk+0x18>
    80005c64:	de4fc0ef          	jal	80002248 <wakeup>
}
    80005c68:	60a2                	ld	ra,8(sp)
    80005c6a:	6402                	ld	s0,0(sp)
    80005c6c:	0141                	addi	sp,sp,16
    80005c6e:	8082                	ret
    panic("free_desc 1");
    80005c70:	00003517          	auipc	a0,0x3
    80005c74:	9f050513          	addi	a0,a0,-1552 # 80008660 <etext+0x660>
    80005c78:	badfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    80005c7c:	00003517          	auipc	a0,0x3
    80005c80:	9f450513          	addi	a0,a0,-1548 # 80008670 <etext+0x670>
    80005c84:	ba1fa0ef          	jal	80000824 <panic>

0000000080005c88 <virtio_disk_init>:
{
    80005c88:	1101                	addi	sp,sp,-32
    80005c8a:	ec06                	sd	ra,24(sp)
    80005c8c:	e822                	sd	s0,16(sp)
    80005c8e:	e426                	sd	s1,8(sp)
    80005c90:	e04a                	sd	s2,0(sp)
    80005c92:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005c94:	00003597          	auipc	a1,0x3
    80005c98:	9ec58593          	addi	a1,a1,-1556 # 80008680 <etext+0x680>
    80005c9c:	0001c517          	auipc	a0,0x1c
    80005ca0:	51450513          	addi	a0,a0,1300 # 800221b0 <disk+0x128>
    80005ca4:	efbfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ca8:	100017b7          	lui	a5,0x10001
    80005cac:	4398                	lw	a4,0(a5)
    80005cae:	2701                	sext.w	a4,a4
    80005cb0:	747277b7          	lui	a5,0x74727
    80005cb4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005cb8:	14f71863          	bne	a4,a5,80005e08 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005cbc:	100017b7          	lui	a5,0x10001
    80005cc0:	43dc                	lw	a5,4(a5)
    80005cc2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005cc4:	4709                	li	a4,2
    80005cc6:	14e79163          	bne	a5,a4,80005e08 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cca:	100017b7          	lui	a5,0x10001
    80005cce:	479c                	lw	a5,8(a5)
    80005cd0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005cd2:	12e79b63          	bne	a5,a4,80005e08 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005cd6:	100017b7          	lui	a5,0x10001
    80005cda:	47d8                	lw	a4,12(a5)
    80005cdc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cde:	554d47b7          	lui	a5,0x554d4
    80005ce2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005ce6:	12f71163          	bne	a4,a5,80005e08 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cea:	100017b7          	lui	a5,0x10001
    80005cee:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cf2:	4705                	li	a4,1
    80005cf4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cf6:	470d                	li	a4,3
    80005cf8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005cfa:	10001737          	lui	a4,0x10001
    80005cfe:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005d00:	c7ffe6b7          	lui	a3,0xc7ffe
    80005d04:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc597>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005d08:	8f75                	and	a4,a4,a3
    80005d0a:	100016b7          	lui	a3,0x10001
    80005d0e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d10:	472d                	li	a4,11
    80005d12:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d14:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005d18:	439c                	lw	a5,0(a5)
    80005d1a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005d1e:	8ba1                	andi	a5,a5,8
    80005d20:	0e078a63          	beqz	a5,80005e14 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d24:	100017b7          	lui	a5,0x10001
    80005d28:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005d2c:	43fc                	lw	a5,68(a5)
    80005d2e:	2781                	sext.w	a5,a5
    80005d30:	0e079863          	bnez	a5,80005e20 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d34:	100017b7          	lui	a5,0x10001
    80005d38:	5bdc                	lw	a5,52(a5)
    80005d3a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d3c:	0e078863          	beqz	a5,80005e2c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005d40:	471d                	li	a4,7
    80005d42:	0ef77b63          	bgeu	a4,a5,80005e38 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005d46:	dfffa0ef          	jal	80000b44 <kalloc>
    80005d4a:	0001c497          	auipc	s1,0x1c
    80005d4e:	33e48493          	addi	s1,s1,830 # 80022088 <disk>
    80005d52:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005d54:	df1fa0ef          	jal	80000b44 <kalloc>
    80005d58:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005d5a:	debfa0ef          	jal	80000b44 <kalloc>
    80005d5e:	87aa                	mv	a5,a0
    80005d60:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005d62:	6088                	ld	a0,0(s1)
    80005d64:	0e050063          	beqz	a0,80005e44 <virtio_disk_init+0x1bc>
    80005d68:	0001c717          	auipc	a4,0x1c
    80005d6c:	32873703          	ld	a4,808(a4) # 80022090 <disk+0x8>
    80005d70:	cb71                	beqz	a4,80005e44 <virtio_disk_init+0x1bc>
    80005d72:	cbe9                	beqz	a5,80005e44 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005d74:	6605                	lui	a2,0x1
    80005d76:	4581                	li	a1,0
    80005d78:	f81fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005d7c:	0001c497          	auipc	s1,0x1c
    80005d80:	30c48493          	addi	s1,s1,780 # 80022088 <disk>
    80005d84:	6605                	lui	a2,0x1
    80005d86:	4581                	li	a1,0
    80005d88:	6488                	ld	a0,8(s1)
    80005d8a:	f6ffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005d8e:	6605                	lui	a2,0x1
    80005d90:	4581                	li	a1,0
    80005d92:	6888                	ld	a0,16(s1)
    80005d94:	f65fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d98:	100017b7          	lui	a5,0x10001
    80005d9c:	4721                	li	a4,8
    80005d9e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005da0:	4098                	lw	a4,0(s1)
    80005da2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005da6:	40d8                	lw	a4,4(s1)
    80005da8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005dac:	649c                	ld	a5,8(s1)
    80005dae:	0007869b          	sext.w	a3,a5
    80005db2:	10001737          	lui	a4,0x10001
    80005db6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005dba:	9781                	srai	a5,a5,0x20
    80005dbc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005dc0:	689c                	ld	a5,16(s1)
    80005dc2:	0007869b          	sext.w	a3,a5
    80005dc6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005dca:	9781                	srai	a5,a5,0x20
    80005dcc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005dd0:	4785                	li	a5,1
    80005dd2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005dd4:	00f48c23          	sb	a5,24(s1)
    80005dd8:	00f48ca3          	sb	a5,25(s1)
    80005ddc:	00f48d23          	sb	a5,26(s1)
    80005de0:	00f48da3          	sb	a5,27(s1)
    80005de4:	00f48e23          	sb	a5,28(s1)
    80005de8:	00f48ea3          	sb	a5,29(s1)
    80005dec:	00f48f23          	sb	a5,30(s1)
    80005df0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005df4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df8:	07272823          	sw	s2,112(a4)
}
    80005dfc:	60e2                	ld	ra,24(sp)
    80005dfe:	6442                	ld	s0,16(sp)
    80005e00:	64a2                	ld	s1,8(sp)
    80005e02:	6902                	ld	s2,0(sp)
    80005e04:	6105                	addi	sp,sp,32
    80005e06:	8082                	ret
    panic("could not find virtio disk");
    80005e08:	00003517          	auipc	a0,0x3
    80005e0c:	88850513          	addi	a0,a0,-1912 # 80008690 <etext+0x690>
    80005e10:	a15fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005e14:	00003517          	auipc	a0,0x3
    80005e18:	89c50513          	addi	a0,a0,-1892 # 800086b0 <etext+0x6b0>
    80005e1c:	a09fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005e20:	00003517          	auipc	a0,0x3
    80005e24:	8b050513          	addi	a0,a0,-1872 # 800086d0 <etext+0x6d0>
    80005e28:	9fdfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    80005e2c:	00003517          	auipc	a0,0x3
    80005e30:	8c450513          	addi	a0,a0,-1852 # 800086f0 <etext+0x6f0>
    80005e34:	9f1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005e38:	00003517          	auipc	a0,0x3
    80005e3c:	8d850513          	addi	a0,a0,-1832 # 80008710 <etext+0x710>
    80005e40:	9e5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005e44:	00003517          	auipc	a0,0x3
    80005e48:	8ec50513          	addi	a0,a0,-1812 # 80008730 <etext+0x730>
    80005e4c:	9d9fa0ef          	jal	80000824 <panic>

0000000080005e50 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005e50:	711d                	addi	sp,sp,-96
    80005e52:	ec86                	sd	ra,88(sp)
    80005e54:	e8a2                	sd	s0,80(sp)
    80005e56:	e4a6                	sd	s1,72(sp)
    80005e58:	e0ca                	sd	s2,64(sp)
    80005e5a:	fc4e                	sd	s3,56(sp)
    80005e5c:	f852                	sd	s4,48(sp)
    80005e5e:	f456                	sd	s5,40(sp)
    80005e60:	f05a                	sd	s6,32(sp)
    80005e62:	ec5e                	sd	s7,24(sp)
    80005e64:	e862                	sd	s8,16(sp)
    80005e66:	1080                	addi	s0,sp,96
    80005e68:	89aa                	mv	s3,a0
    80005e6a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005e6c:	00c52b83          	lw	s7,12(a0)
    80005e70:	001b9b9b          	slliw	s7,s7,0x1
    80005e74:	1b82                	slli	s7,s7,0x20
    80005e76:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005e7a:	0001c517          	auipc	a0,0x1c
    80005e7e:	33650513          	addi	a0,a0,822 # 800221b0 <disk+0x128>
    80005e82:	da7fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005e86:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005e88:	0001ca97          	auipc	s5,0x1c
    80005e8c:	200a8a93          	addi	s5,s5,512 # 80022088 <disk>
  for(int i = 0; i < 3; i++){
    80005e90:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005e92:	5c7d                	li	s8,-1
    80005e94:	a095                	j	80005ef8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005e96:	00fa8733          	add	a4,s5,a5
    80005e9a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005e9e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005ea0:	0207c563          	bltz	a5,80005eca <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005ea4:	2905                	addiw	s2,s2,1
    80005ea6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005ea8:	05490c63          	beq	s2,s4,80005f00 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005eac:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005eae:	0001c717          	auipc	a4,0x1c
    80005eb2:	1da70713          	addi	a4,a4,474 # 80022088 <disk>
    80005eb6:	4781                	li	a5,0
    if(disk.free[i]){
    80005eb8:	01874683          	lbu	a3,24(a4)
    80005ebc:	fee9                	bnez	a3,80005e96 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005ebe:	2785                	addiw	a5,a5,1
    80005ec0:	0705                	addi	a4,a4,1
    80005ec2:	fe979be3          	bne	a5,s1,80005eb8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005ec6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005eca:	01205d63          	blez	s2,80005ee4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005ece:	fa042503          	lw	a0,-96(s0)
    80005ed2:	d41ff0ef          	jal	80005c12 <free_desc>
      for(int j = 0; j < i; j++)
    80005ed6:	4785                	li	a5,1
    80005ed8:	0127d663          	bge	a5,s2,80005ee4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005edc:	fa442503          	lw	a0,-92(s0)
    80005ee0:	d33ff0ef          	jal	80005c12 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ee4:	0001c597          	auipc	a1,0x1c
    80005ee8:	2cc58593          	addi	a1,a1,716 # 800221b0 <disk+0x128>
    80005eec:	0001c517          	auipc	a0,0x1c
    80005ef0:	1b450513          	addi	a0,a0,436 # 800220a0 <disk+0x18>
    80005ef4:	b08fc0ef          	jal	800021fc <sleep>
  for(int i = 0; i < 3; i++){
    80005ef8:	fa040613          	addi	a2,s0,-96
    80005efc:	4901                	li	s2,0
    80005efe:	b77d                	j	80005eac <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f00:	fa042503          	lw	a0,-96(s0)
    80005f04:	00451693          	slli	a3,a0,0x4

  if(write)
    80005f08:	0001c797          	auipc	a5,0x1c
    80005f0c:	18078793          	addi	a5,a5,384 # 80022088 <disk>
    80005f10:	00451713          	slli	a4,a0,0x4
    80005f14:	0a070713          	addi	a4,a4,160
    80005f18:	973e                	add	a4,a4,a5
    80005f1a:	01603633          	snez	a2,s6
    80005f1e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005f20:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005f24:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f28:	6398                	ld	a4,0(a5)
    80005f2a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f2c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005f30:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f32:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005f34:	6390                	ld	a2,0(a5)
    80005f36:	00d60833          	add	a6,a2,a3
    80005f3a:	4741                	li	a4,16
    80005f3c:	00e82423          	sw	a4,8(a6) # fffffffffffff008 <end+0xffffffff7ffdce40>
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005f40:	4585                	li	a1,1
    80005f42:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005f46:	fa442703          	lw	a4,-92(s0)
    80005f4a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005f4e:	0712                	slli	a4,a4,0x4
    80005f50:	963a                	add	a2,a2,a4
    80005f52:	05898813          	addi	a6,s3,88
    80005f56:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005f5a:	0007b883          	ld	a7,0(a5)
    80005f5e:	9746                	add	a4,a4,a7
    80005f60:	40000613          	li	a2,1024
    80005f64:	c710                	sw	a2,8(a4)
  if(write)
    80005f66:	001b3613          	seqz	a2,s6
    80005f6a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005f6e:	8e4d                	or	a2,a2,a1
    80005f70:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005f74:	fa842603          	lw	a2,-88(s0)
    80005f78:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005f7c:	00451813          	slli	a6,a0,0x4
    80005f80:	02080813          	addi	a6,a6,32
    80005f84:	983e                	add	a6,a6,a5
    80005f86:	577d                	li	a4,-1
    80005f88:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005f8c:	0612                	slli	a2,a2,0x4
    80005f8e:	98b2                	add	a7,a7,a2
    80005f90:	03068713          	addi	a4,a3,48
    80005f94:	973e                	add	a4,a4,a5
    80005f96:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005f9a:	6398                	ld	a4,0(a5)
    80005f9c:	9732                	add	a4,a4,a2
    80005f9e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005fa0:	4689                	li	a3,2
    80005fa2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005fa6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005faa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005fae:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005fb2:	6794                	ld	a3,8(a5)
    80005fb4:	0026d703          	lhu	a4,2(a3)
    80005fb8:	8b1d                	andi	a4,a4,7
    80005fba:	0706                	slli	a4,a4,0x1
    80005fbc:	96ba                	add	a3,a3,a4
    80005fbe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005fc2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005fc6:	6798                	ld	a4,8(a5)
    80005fc8:	00275783          	lhu	a5,2(a4)
    80005fcc:	2785                	addiw	a5,a5,1
    80005fce:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005fd2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005fd6:	100017b7          	lui	a5,0x10001
    80005fda:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005fde:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005fe2:	0001c917          	auipc	s2,0x1c
    80005fe6:	1ce90913          	addi	s2,s2,462 # 800221b0 <disk+0x128>
  while(b->disk == 1) {
    80005fea:	84ae                	mv	s1,a1
    80005fec:	00b79a63          	bne	a5,a1,80006000 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005ff0:	85ca                	mv	a1,s2
    80005ff2:	854e                	mv	a0,s3
    80005ff4:	a08fc0ef          	jal	800021fc <sleep>
  while(b->disk == 1) {
    80005ff8:	0049a783          	lw	a5,4(s3)
    80005ffc:	fe978ae3          	beq	a5,s1,80005ff0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80006000:	fa042903          	lw	s2,-96(s0)
    80006004:	00491713          	slli	a4,s2,0x4
    80006008:	02070713          	addi	a4,a4,32
    8000600c:	0001c797          	auipc	a5,0x1c
    80006010:	07c78793          	addi	a5,a5,124 # 80022088 <disk>
    80006014:	97ba                	add	a5,a5,a4
    80006016:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000601a:	0001c997          	auipc	s3,0x1c
    8000601e:	06e98993          	addi	s3,s3,110 # 80022088 <disk>
    80006022:	00491713          	slli	a4,s2,0x4
    80006026:	0009b783          	ld	a5,0(s3)
    8000602a:	97ba                	add	a5,a5,a4
    8000602c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006030:	854a                	mv	a0,s2
    80006032:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006036:	bddff0ef          	jal	80005c12 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000603a:	8885                	andi	s1,s1,1
    8000603c:	f0fd                	bnez	s1,80006022 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000603e:	0001c517          	auipc	a0,0x1c
    80006042:	17250513          	addi	a0,a0,370 # 800221b0 <disk+0x128>
    80006046:	c77fa0ef          	jal	80000cbc <release>
}
    8000604a:	60e6                	ld	ra,88(sp)
    8000604c:	6446                	ld	s0,80(sp)
    8000604e:	64a6                	ld	s1,72(sp)
    80006050:	6906                	ld	s2,64(sp)
    80006052:	79e2                	ld	s3,56(sp)
    80006054:	7a42                	ld	s4,48(sp)
    80006056:	7aa2                	ld	s5,40(sp)
    80006058:	7b02                	ld	s6,32(sp)
    8000605a:	6be2                	ld	s7,24(sp)
    8000605c:	6c42                	ld	s8,16(sp)
    8000605e:	6125                	addi	sp,sp,96
    80006060:	8082                	ret

0000000080006062 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006062:	1101                	addi	sp,sp,-32
    80006064:	ec06                	sd	ra,24(sp)
    80006066:	e822                	sd	s0,16(sp)
    80006068:	e426                	sd	s1,8(sp)
    8000606a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000606c:	0001c497          	auipc	s1,0x1c
    80006070:	01c48493          	addi	s1,s1,28 # 80022088 <disk>
    80006074:	0001c517          	auipc	a0,0x1c
    80006078:	13c50513          	addi	a0,a0,316 # 800221b0 <disk+0x128>
    8000607c:	badfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006080:	100017b7          	lui	a5,0x10001
    80006084:	53bc                	lw	a5,96(a5)
    80006086:	8b8d                	andi	a5,a5,3
    80006088:	10001737          	lui	a4,0x10001
    8000608c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000608e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006092:	689c                	ld	a5,16(s1)
    80006094:	0204d703          	lhu	a4,32(s1)
    80006098:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000609c:	04f70863          	beq	a4,a5,800060ec <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800060a0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800060a4:	6898                	ld	a4,16(s1)
    800060a6:	0204d783          	lhu	a5,32(s1)
    800060aa:	8b9d                	andi	a5,a5,7
    800060ac:	078e                	slli	a5,a5,0x3
    800060ae:	97ba                	add	a5,a5,a4
    800060b0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800060b2:	00479713          	slli	a4,a5,0x4
    800060b6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    800060ba:	9726                	add	a4,a4,s1
    800060bc:	01074703          	lbu	a4,16(a4)
    800060c0:	e329                	bnez	a4,80006102 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800060c2:	0792                	slli	a5,a5,0x4
    800060c4:	02078793          	addi	a5,a5,32
    800060c8:	97a6                	add	a5,a5,s1
    800060ca:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800060cc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800060d0:	978fc0ef          	jal	80002248 <wakeup>

    disk.used_idx += 1;
    800060d4:	0204d783          	lhu	a5,32(s1)
    800060d8:	2785                	addiw	a5,a5,1
    800060da:	17c2                	slli	a5,a5,0x30
    800060dc:	93c1                	srli	a5,a5,0x30
    800060de:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800060e2:	6898                	ld	a4,16(s1)
    800060e4:	00275703          	lhu	a4,2(a4)
    800060e8:	faf71ce3          	bne	a4,a5,800060a0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800060ec:	0001c517          	auipc	a0,0x1c
    800060f0:	0c450513          	addi	a0,a0,196 # 800221b0 <disk+0x128>
    800060f4:	bc9fa0ef          	jal	80000cbc <release>
}
    800060f8:	60e2                	ld	ra,24(sp)
    800060fa:	6442                	ld	s0,16(sp)
    800060fc:	64a2                	ld	s1,8(sp)
    800060fe:	6105                	addi	sp,sp,32
    80006100:	8082                	ret
      panic("virtio_disk_intr status");
    80006102:	00002517          	auipc	a0,0x2
    80006106:	64650513          	addi	a0,a0,1606 # 80008748 <etext+0x748>
    8000610a:	f1afa0ef          	jal	80000824 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	12000073          	sfence.vma
    8000708a:	18031073          	csrw	satp,t1
    8000708e:	12000073          	sfence.vma
    80007092:	9282                	jalr	t0

0000000080007094 <userret>:
    80007094:	12000073          	sfence.vma
    80007098:	18051073          	csrw	satp,a0
    8000709c:	12000073          	sfence.vma
    800070a0:	14002573          	csrr	a0,sscratch
    800070a4:	02853083          	ld	ra,40(a0)
    800070a8:	03053103          	ld	sp,48(a0)
    800070ac:	03853183          	ld	gp,56(a0)
    800070b0:	04053203          	ld	tp,64(a0)
    800070b4:	04853283          	ld	t0,72(a0)
    800070b8:	05053303          	ld	t1,80(a0)
    800070bc:	05853383          	ld	t2,88(a0)
    800070c0:	7120                	ld	s0,96(a0)
    800070c2:	7524                	ld	s1,104(a0)
    800070c4:	7d2c                	ld	a1,120(a0)
    800070c6:	6150                	ld	a2,128(a0)
    800070c8:	6554                	ld	a3,136(a0)
    800070ca:	6958                	ld	a4,144(a0)
    800070cc:	6d5c                	ld	a5,152(a0)
    800070ce:	0a053803          	ld	a6,160(a0)
    800070d2:	0a853883          	ld	a7,168(a0)
    800070d6:	0b053903          	ld	s2,176(a0)
    800070da:	0b853983          	ld	s3,184(a0)
    800070de:	0c053a03          	ld	s4,192(a0)
    800070e2:	0c853a83          	ld	s5,200(a0)
    800070e6:	0d053b03          	ld	s6,208(a0)
    800070ea:	0d853b83          	ld	s7,216(a0)
    800070ee:	0e053c03          	ld	s8,224(a0)
    800070f2:	0e853c83          	ld	s9,232(a0)
    800070f6:	0f053d03          	ld	s10,240(a0)
    800070fa:	0f853d83          	ld	s11,248(a0)
    800070fe:	10053e03          	ld	t3,256(a0)
    80007102:	10853e83          	ld	t4,264(a0)
    80007106:	11053f03          	ld	t5,272(a0)
    8000710a:	11853f83          	ld	t6,280(a0)
    8000710e:	7928                	ld	a0,112(a0)
    80007110:	10200073          	sret
	...
