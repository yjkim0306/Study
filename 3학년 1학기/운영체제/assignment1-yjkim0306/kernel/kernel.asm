
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	8c010113          	addi	sp,sp,-1856 # 800078c0 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc37>
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
    8000011a:	1c8020ef          	jal	800022e2 <either_copyin>
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
    80000192:	0000f517          	auipc	a0,0xf
    80000196:	72e50513          	addi	a0,a0,1838 # 8000f8c0 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	0000f497          	auipc	s1,0xf
    800001a2:	72248493          	addi	s1,s1,1826 # 8000f8c0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	0000f917          	auipc	s2,0xf
    800001aa:	7b290913          	addi	s2,s2,1970 # 8000f958 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	770010ef          	jal	8000192e <myproc>
    800001c2:	7b9010ef          	jal	8000217a <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	573010ef          	jal	80001f3e <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	0000f717          	auipc	a4,0xf
    800001e2:	6e270713          	addi	a4,a4,1762 # 8000f8c0 <cons>
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
    80000210:	088020ef          	jal	80002298 <either_copyout>
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
    80000228:	0000f517          	auipc	a0,0xf
    8000022c:	69850513          	addi	a0,a0,1688 # 8000f8c0 <cons>
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
    8000024e:	0000f717          	auipc	a4,0xf
    80000252:	70f72523          	sw	a5,1802(a4) # 8000f958 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	65c50513          	addi	a0,a0,1628 # 8000f8c0 <cons>
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
    800002b8:	0000f517          	auipc	a0,0xf
    800002bc:	60850513          	addi	a0,a0,1544 # 8000f8c0 <cons>
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
    800002da:	052020ef          	jal	8000232c <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002de:	0000f517          	auipc	a0,0xf
    800002e2:	5e250513          	addi	a0,a0,1506 # 8000f8c0 <cons>
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
    800002fc:	0000f717          	auipc	a4,0xf
    80000300:	5c470713          	addi	a4,a4,1476 # 8000f8c0 <cons>
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
    80000322:	0000f717          	auipc	a4,0xf
    80000326:	59e70713          	addi	a4,a4,1438 # 8000f8c0 <cons>
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
    8000034c:	0000f717          	auipc	a4,0xf
    80000350:	60c72703          	lw	a4,1548(a4) # 8000f958 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	0000f717          	auipc	a4,0xf
    80000366:	55e70713          	addi	a4,a4,1374 # 8000f8c0 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	0000f497          	auipc	s1,0xf
    80000376:	54e48493          	addi	s1,s1,1358 # 8000f8c0 <cons>
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
    800003b4:	0000f717          	auipc	a4,0xf
    800003b8:	50c70713          	addi	a4,a4,1292 # 8000f8c0 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	0000f717          	auipc	a4,0xf
    800003ce:	58f72b23          	sw	a5,1430(a4) # 8000f960 <cons+0xa0>
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
    800003e8:	0000f797          	auipc	a5,0xf
    800003ec:	4d878793          	addi	a5,a5,1240 # 8000f8c0 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	0000f797          	auipc	a5,0xf
    8000040e:	54c7a923          	sw	a2,1362(a5) # 8000f95c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	0000f517          	auipc	a0,0xf
    80000416:	54650513          	addi	a0,a0,1350 # 8000f958 <cons+0x98>
    8000041a:	371010ef          	jal	80001f8a <wakeup>
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
    80000428:	00007597          	auipc	a1,0x7
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80007000 <etext>
    80000430:	0000f517          	auipc	a0,0xf
    80000434:	49050513          	addi	a0,a0,1168 # 8000f8c0 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	0001f797          	auipc	a5,0x1f
    80000444:	5f078793          	addi	a5,a5,1520 # 8001fa30 <devsw>
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
    8000047e:	00007817          	auipc	a6,0x7
    80000482:	2b280813          	addi	a6,a6,690 # 80007730 <digits>
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
    80000518:	00007797          	auipc	a5,0x7
    8000051c:	37c7a783          	lw	a5,892(a5) # 80007894 <panicking>
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
    8000055e:	0000f517          	auipc	a0,0xf
    80000562:	40a50513          	addi	a0,a0,1034 # 8000f968 <pr>
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
    800006d2:	00007c97          	auipc	s9,0x7
    800006d6:	05ec8c93          	addi	s9,s9,94 # 80007730 <digits>
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
    80000732:	00007a17          	auipc	s4,0x7
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80007008 <etext+0x8>
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
    8000075a:	00007797          	auipc	a5,0x7
    8000075e:	13a7a783          	lw	a5,314(a5) # 80007894 <panicking>
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
    80000784:	0000f517          	auipc	a0,0xf
    80000788:	1e450513          	addi	a0,a0,484 # 8000f968 <pr>
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
    80000834:	00007797          	auipc	a5,0x7
    80000838:	0697a023          	sw	s1,96(a5) # 80007894 <panicking>
  printf("panic: ");
    8000083c:	00006517          	auipc	a0,0x6
    80000840:	7dc50513          	addi	a0,a0,2012 # 80007018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00006517          	auipc	a0,0x6
    8000084e:	7d650513          	addi	a0,a0,2006 # 80007020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	00007797          	auipc	a5,0x7
    8000085a:	0297ad23          	sw	s1,58(a5) # 80007890 <panicked>
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
    80000868:	00006597          	auipc	a1,0x6
    8000086c:	7c058593          	addi	a1,a1,1984 # 80007028 <etext+0x28>
    80000870:	0000f517          	auipc	a0,0xf
    80000874:	0f850513          	addi	a0,a0,248 # 8000f968 <pr>
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
    800008be:	00006597          	auipc	a1,0x6
    800008c2:	77258593          	addi	a1,a1,1906 # 80007030 <etext+0x30>
    800008c6:	0000f517          	auipc	a0,0xf
    800008ca:	0ba50513          	addi	a0,a0,186 # 8000f980 <tx_lock>
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
    800008ea:	0000f517          	auipc	a0,0xf
    800008ee:	09650513          	addi	a0,a0,150 # 8000f980 <tx_lock>
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
    80000908:	00007497          	auipc	s1,0x7
    8000090c:	f9448493          	addi	s1,s1,-108 # 8000789c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	0000f997          	auipc	s3,0xf
    80000914:	07098993          	addi	s3,s3,112 # 8000f980 <tx_lock>
    80000918:	00007917          	auipc	s2,0x7
    8000091c:	f8090913          	addi	s2,s2,-128 # 80007898 <tx_chan>
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
    8000092c:	612010ef          	jal	80001f3e <sleep>
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
    80000956:	0000f517          	auipc	a0,0xf
    8000095a:	02a50513          	addi	a0,a0,42 # 8000f980 <tx_lock>
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
    8000097a:	00007797          	auipc	a5,0x7
    8000097e:	f1a7a783          	lw	a5,-230(a5) # 80007894 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00007797          	auipc	a5,0x7
    80000988:	f0c7a783          	lw	a5,-244(a5) # 80007890 <panicked>
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
    800009aa:	00007797          	auipc	a5,0x7
    800009ae:	eea7a783          	lw	a5,-278(a5) # 80007894 <panicking>
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
    80000a06:	0000f517          	auipc	a0,0xf
    80000a0a:	f7a50513          	addi	a0,a0,-134 # 8000f980 <tx_lock>
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
    80000a20:	0000f517          	auipc	a0,0xf
    80000a24:	f6050513          	addi	a0,a0,-160 # 8000f980 <tx_lock>
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
    80000a3c:	00007797          	auipc	a5,0x7
    80000a40:	e607a023          	sw	zero,-416(a5) # 8000789c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00007517          	auipc	a0,0x7
    80000a48:	e5450513          	addi	a0,a0,-428 # 80007898 <tx_chan>
    80000a4c:	53e010ef          	jal	80001f8a <wakeup>
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
    80000a68:	00020797          	auipc	a5,0x20
    80000a6c:	16078793          	addi	a5,a5,352 # 80020bc8 <end>
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
    80000a92:	0000f917          	auipc	s2,0xf
    80000a96:	f0690913          	addi	s2,s2,-250 # 8000f998 <kmem>
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
    80000abc:	00006517          	auipc	a0,0x6
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80007038 <etext+0x38>
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
    80000b18:	00006597          	auipc	a1,0x6
    80000b1c:	52858593          	addi	a1,a1,1320 # 80007040 <etext+0x40>
    80000b20:	0000f517          	auipc	a0,0xf
    80000b24:	e7850513          	addi	a0,a0,-392 # 8000f998 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00020517          	auipc	a0,0x20
    80000b34:	09850513          	addi	a0,a0,152 # 80020bc8 <end>
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
    80000b4e:	0000f517          	auipc	a0,0xf
    80000b52:	e4a50513          	addi	a0,a0,-438 # 8000f998 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	0000f497          	auipc	s1,0xf
    80000b5e:	e564b483          	ld	s1,-426(s1) # 8000f9b0 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	0000f717          	auipc	a4,0xf
    80000b6a:	e4f73523          	sd	a5,-438(a4) # 8000f9b0 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	0000f517          	auipc	a0,0xf
    80000b72:	e2a50513          	addi	a0,a0,-470 # 8000f998 <kmem>
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
    80000b90:	0000f517          	auipc	a0,0xf
    80000b94:	e0850513          	addi	a0,a0,-504 # 8000f998 <kmem>
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
    80000bce:	541000ef          	jal	8000190e <mycpu>
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
    80000bfe:	511000ef          	jal	8000190e <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	509000ef          	jal	8000190e <mycpu>
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
    80000c1a:	4f5000ef          	jal	8000190e <mycpu>
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
    80000c50:	4bf000ef          	jal	8000190e <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00006517          	auipc	a0,0x6
    80000c64:	3e850513          	addi	a0,a0,1000 # 80007048 <etext+0x48>
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
    80000c74:	49b000ef          	jal	8000190e <mycpu>
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
    80000ca4:	00006517          	auipc	a0,0x6
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80007050 <etext+0x50>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00006517          	auipc	a0,0x6
    80000cb4:	3b850513          	addi	a0,a0,952 # 80007068 <etext+0x68>
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
    80000cec:	00006517          	auipc	a0,0x6
    80000cf0:	38450513          	addi	a0,a0,900 # 80007070 <etext+0x70>
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
    80000eb6:	245000ef          	jal	800018fa <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00007717          	auipc	a4,0x7
    80000ebe:	9e670713          	addi	a4,a4,-1562 # 800078a0 <started>
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
    80000ece:	22d000ef          	jal	800018fa <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00006517          	auipc	a0,0x6
    80000ed8:	1c450513          	addi	a0,a0,452 # 80007098 <etext+0x98>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	674010ef          	jal	80002558 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	6b0040ef          	jal	80005598 <plicinithart>
  }

  scheduler();
    80000eec:	6b9000ef          	jal	80001da4 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00006517          	auipc	a0,0x6
    80000efc:	18050513          	addi	a0,a0,384 # 80007078 <etext+0x78>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00006517          	auipc	a0,0x6
    80000f08:	17c50513          	addi	a0,a0,380 # 80007080 <etext+0x80>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00006517          	auipc	a0,0x6
    80000f14:	16850513          	addi	a0,a0,360 # 80007078 <etext+0x78>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2cc000ef          	jal	800011ec <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	11d000ef          	jal	80001844 <procinit>
    trapinit();      // trap vectors
    80000f2c:	608010ef          	jal	80002534 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	628010ef          	jal	80002558 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	64a040ef          	jal	8000557e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	660040ef          	jal	80005598 <plicinithart>
    binit();         // buffer cache
    80000f3c:	4d7010ef          	jal	80002c12 <binit>
    iinit();         // inode table
    80000f40:	228020ef          	jal	80003168 <iinit>
    fileinit();      // file table
    80000f44:	154030ef          	jal	80004098 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	740040ef          	jal	80005688 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	4ad000ef          	jal	80001bf8 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00007717          	auipc	a4,0x7
    80000f5a:	94f72523          	sw	a5,-1718(a4) # 800078a0 <started>
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
    80000f6c:	00007797          	auipc	a5,0x7
    80000f70:	93c7b783          	ld	a5,-1732(a5) # 800078a8 <kernel_pagetable>
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
    80000ff2:	00006517          	auipc	a0,0x6
    80000ff6:	0be50513          	addi	a0,a0,190 # 800070b0 <etext+0xb0>
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
    800010ca:	00006517          	auipc	a0,0x6
    800010ce:	fee50513          	addi	a0,a0,-18 # 800070b8 <etext+0xb8>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800010d6:	00006517          	auipc	a0,0x6
    800010da:	00250513          	addi	a0,a0,2 # 800070d8 <etext+0xd8>
    800010de:	f46ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800010e2:	00006517          	auipc	a0,0x6
    800010e6:	01650513          	addi	a0,a0,22 # 800070f8 <etext+0xf8>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800010ee:	00006517          	auipc	a0,0x6
    800010f2:	01a50513          	addi	a0,a0,26 # 80007108 <etext+0x108>
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
    80001132:	00006517          	auipc	a0,0x6
    80001136:	fe650513          	addi	a0,a0,-26 # 80007118 <etext+0x118>
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
    8000118a:	80006697          	auipc	a3,0x80006
    8000118e:	e7668693          	addi	a3,a3,-394 # 7000 <_entry-0x7fff9000>
    80001192:	4605                	li	a2,1
    80001194:	067e                	slli	a2,a2,0x1f
    80001196:	85b2                	mv	a1,a2
    80001198:	8526                	mv	a0,s1
    8000119a:	f7dff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119e:	4719                	li	a4,6
    800011a0:	00006697          	auipc	a3,0x6
    800011a4:	e6068693          	addi	a3,a3,-416 # 80007000 <etext>
    800011a8:	47c5                	li	a5,17
    800011aa:	07ee                	slli	a5,a5,0x1b
    800011ac:	40d786b3          	sub	a3,a5,a3
    800011b0:	00006617          	auipc	a2,0x6
    800011b4:	e5060613          	addi	a2,a2,-432 # 80007000 <etext>
    800011b8:	85b2                	mv	a1,a2
    800011ba:	8526                	mv	a0,s1
    800011bc:	f5bff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	4729                	li	a4,10
    800011c2:	6685                	lui	a3,0x1
    800011c4:	00005617          	auipc	a2,0x5
    800011c8:	e3c60613          	addi	a2,a2,-452 # 80006000 <_trampoline>
    800011cc:	040005b7          	lui	a1,0x4000
    800011d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d2:	05b2                	slli	a1,a1,0xc
    800011d4:	8526                	mv	a0,s1
    800011d6:	f41ff0ef          	jal	80001116 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011da:	8526                	mv	a0,s1
    800011dc:	5c4000ef          	jal	800017a0 <proc_mapstacks>
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
    800011f8:	00006797          	auipc	a5,0x6
    800011fc:	6aa7b823          	sd	a0,1712(a5) # 800078a8 <kernel_pagetable>
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
    80001268:	00006517          	auipc	a0,0x6
    8000126c:	eb850513          	addi	a0,a0,-328 # 80007120 <etext+0x120>
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
    800013be:	00006517          	auipc	a0,0x6
    800013c2:	d7a50513          	addi	a0,a0,-646 # 80007138 <etext+0x138>
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
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	c5c50513          	addi	a0,a0,-932 # 80007148 <etext+0x148>
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
    800015e0:	34e000ef          	jal	8000192e <myproc>
  if (va >= p->sz)
    800015e4:	653c                	ld	a5,72(a0)
    800015e6:	00f96a63          	bltu	s2,a5,800015fa <vmfault+0x2a>
    return 0;
    800015ea:	4981                	li	s3,0
}
    800015ec:	854e                	mv	a0,s3
    800015ee:	70a2                	ld	ra,40(sp)
    800015f0:	7402                	ld	s0,32(sp)
    800015f2:	6942                	ld	s2,16(sp)
    800015f4:	69a2                	ld	s3,8(sp)
    800015f6:	6145                	addi	sp,sp,48
    800015f8:	8082                	ret
    800015fa:	ec26                	sd	s1,24(sp)
    800015fc:	e052                	sd	s4,0(sp)
    800015fe:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80001600:	77fd                	lui	a5,0xfffff
    80001602:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80001606:	85d2                	mv	a1,s4
    80001608:	854e                	mv	a0,s3
    8000160a:	fabff0ef          	jal	800015b4 <ismapped>
    return 0;
    8000160e:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001610:	c501                	beqz	a0,80001618 <vmfault+0x48>
    80001612:	64e2                	ld	s1,24(sp)
    80001614:	6a02                	ld	s4,0(sp)
    80001616:	bfd9                	j	800015ec <vmfault+0x1c>
  mem = (uint64) kalloc();
    80001618:	d2cff0ef          	jal	80000b44 <kalloc>
    8000161c:	892a                	mv	s2,a0
  if(mem == 0)
    8000161e:	c905                	beqz	a0,8000164e <vmfault+0x7e>
  mem = (uint64) kalloc();
    80001620:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001622:	6605                	lui	a2,0x1
    80001624:	4581                	li	a1,0
    80001626:	ed2ff0ef          	jal	80000cf8 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000162a:	4759                	li	a4,22
    8000162c:	86ca                	mv	a3,s2
    8000162e:	6605                	lui	a2,0x1
    80001630:	85d2                	mv	a1,s4
    80001632:	68a8                	ld	a0,80(s1)
    80001634:	a2dff0ef          	jal	80001060 <mappages>
    80001638:	e501                	bnez	a0,80001640 <vmfault+0x70>
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6a02                	ld	s4,0(sp)
    8000163e:	b77d                	j	800015ec <vmfault+0x1c>
    kfree((void *)mem);
    80001640:	854a                	mv	a0,s2
    80001642:	c1aff0ef          	jal	80000a5c <kfree>
    return 0;
    80001646:	4981                	li	s3,0
    80001648:	64e2                	ld	s1,24(sp)
    8000164a:	6a02                	ld	s4,0(sp)
    8000164c:	b745                	j	800015ec <vmfault+0x1c>
    8000164e:	64e2                	ld	s1,24(sp)
    80001650:	6a02                	ld	s4,0(sp)
    80001652:	bf69                	j	800015ec <vmfault+0x1c>

0000000080001654 <copyout>:
  while(len > 0){
    80001654:	cad1                	beqz	a3,800016e8 <copyout+0x94>
{
    80001656:	711d                	addi	sp,sp,-96
    80001658:	ec86                	sd	ra,88(sp)
    8000165a:	e8a2                	sd	s0,80(sp)
    8000165c:	e4a6                	sd	s1,72(sp)
    8000165e:	e0ca                	sd	s2,64(sp)
    80001660:	fc4e                	sd	s3,56(sp)
    80001662:	f852                	sd	s4,48(sp)
    80001664:	f456                	sd	s5,40(sp)
    80001666:	f05a                	sd	s6,32(sp)
    80001668:	ec5e                	sd	s7,24(sp)
    8000166a:	e862                	sd	s8,16(sp)
    8000166c:	e466                	sd	s9,8(sp)
    8000166e:	e06a                	sd	s10,0(sp)
    80001670:	1080                	addi	s0,sp,96
    80001672:	8baa                	mv	s7,a0
    80001674:	8a2e                	mv	s4,a1
    80001676:	8b32                	mv	s6,a2
    80001678:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000167a:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    8000167c:	5cfd                	li	s9,-1
    8000167e:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001682:	6c05                	lui	s8,0x1
    80001684:	a005                	j	800016a4 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001686:	409a0533          	sub	a0,s4,s1
    8000168a:	0009061b          	sext.w	a2,s2
    8000168e:	85da                	mv	a1,s6
    80001690:	954e                	add	a0,a0,s3
    80001692:	ec6ff0ef          	jal	80000d58 <memmove>
    len -= n;
    80001696:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000169a:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000169c:	01848a33          	add	s4,s1,s8
  while(len > 0){
    800016a0:	040a8263          	beqz	s5,800016e4 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    800016a4:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    800016a8:	049ce263          	bltu	s9,s1,800016ec <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    800016ac:	85a6                	mv	a1,s1
    800016ae:	855e                	mv	a0,s7
    800016b0:	977ff0ef          	jal	80001026 <walkaddr>
    800016b4:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800016b6:	e901                	bnez	a0,800016c6 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800016b8:	4601                	li	a2,0
    800016ba:	85a6                	mv	a1,s1
    800016bc:	855e                	mv	a0,s7
    800016be:	f13ff0ef          	jal	800015d0 <vmfault>
    800016c2:	89aa                	mv	s3,a0
    800016c4:	c139                	beqz	a0,8000170a <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    800016c6:	4601                	li	a2,0
    800016c8:	85a6                	mv	a1,s1
    800016ca:	855e                	mv	a0,s7
    800016cc:	8c1ff0ef          	jal	80000f8c <walk>
    if((*pte & PTE_W) == 0)
    800016d0:	611c                	ld	a5,0(a0)
    800016d2:	8b91                	andi	a5,a5,4
    800016d4:	cf8d                	beqz	a5,8000170e <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016d6:	41448933          	sub	s2,s1,s4
    800016da:	9962                	add	s2,s2,s8
    if(n > len)
    800016dc:	fb2af5e3          	bgeu	s5,s2,80001686 <copyout+0x32>
    800016e0:	8956                	mv	s2,s5
    800016e2:	b755                	j	80001686 <copyout+0x32>
  return 0;
    800016e4:	4501                	li	a0,0
    800016e6:	a021                	j	800016ee <copyout+0x9a>
    800016e8:	4501                	li	a0,0
}
    800016ea:	8082                	ret
      return -1;
    800016ec:	557d                	li	a0,-1
}
    800016ee:	60e6                	ld	ra,88(sp)
    800016f0:	6446                	ld	s0,80(sp)
    800016f2:	64a6                	ld	s1,72(sp)
    800016f4:	6906                	ld	s2,64(sp)
    800016f6:	79e2                	ld	s3,56(sp)
    800016f8:	7a42                	ld	s4,48(sp)
    800016fa:	7aa2                	ld	s5,40(sp)
    800016fc:	7b02                	ld	s6,32(sp)
    800016fe:	6be2                	ld	s7,24(sp)
    80001700:	6c42                	ld	s8,16(sp)
    80001702:	6ca2                	ld	s9,8(sp)
    80001704:	6d02                	ld	s10,0(sp)
    80001706:	6125                	addi	sp,sp,96
    80001708:	8082                	ret
        return -1;
    8000170a:	557d                	li	a0,-1
    8000170c:	b7cd                	j	800016ee <copyout+0x9a>
      return -1;
    8000170e:	557d                	li	a0,-1
    80001710:	bff9                	j	800016ee <copyout+0x9a>

0000000080001712 <copyin>:
  while(len > 0){
    80001712:	c6c9                	beqz	a3,8000179c <copyin+0x8a>
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	e062                	sd	s8,0(sp)
    8000172a:	0880                	addi	s0,sp,80
    8000172c:	8baa                	mv	s7,a0
    8000172e:	8aae                	mv	s5,a1
    80001730:	8932                	mv	s2,a2
    80001732:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001734:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001736:	6b05                	lui	s6,0x1
    80001738:	a035                	j	80001764 <copyin+0x52>
    8000173a:	412984b3          	sub	s1,s3,s2
    8000173e:	94da                	add	s1,s1,s6
    if(n > len)
    80001740:	009a7363          	bgeu	s4,s1,80001746 <copyin+0x34>
    80001744:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001746:	413905b3          	sub	a1,s2,s3
    8000174a:	0004861b          	sext.w	a2,s1
    8000174e:	95aa                	add	a1,a1,a0
    80001750:	8556                	mv	a0,s5
    80001752:	e06ff0ef          	jal	80000d58 <memmove>
    len -= n;
    80001756:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000175a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000175c:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001760:	020a0163          	beqz	s4,80001782 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001764:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001768:	85ce                	mv	a1,s3
    8000176a:	855e                	mv	a0,s7
    8000176c:	8bbff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0) {
    80001770:	f569                	bnez	a0,8000173a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001772:	4601                	li	a2,0
    80001774:	85ce                	mv	a1,s3
    80001776:	855e                	mv	a0,s7
    80001778:	e59ff0ef          	jal	800015d0 <vmfault>
    8000177c:	fd5d                	bnez	a0,8000173a <copyin+0x28>
        return -1;
    8000177e:	557d                	li	a0,-1
    80001780:	a011                	j	80001784 <copyin+0x72>
  return 0;
    80001782:	4501                	li	a0,0
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret
  return 0;
    8000179c:	4501                	li	a0,0
}
    8000179e:	8082                	ret

00000000800017a0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a0:	715d                	addi	sp,sp,-80
    800017a2:	e486                	sd	ra,72(sp)
    800017a4:	e0a2                	sd	s0,64(sp)
    800017a6:	fc26                	sd	s1,56(sp)
    800017a8:	f84a                	sd	s2,48(sp)
    800017aa:	f44e                	sd	s3,40(sp)
    800017ac:	f052                	sd	s4,32(sp)
    800017ae:	ec56                	sd	s5,24(sp)
    800017b0:	e85a                	sd	s6,16(sp)
    800017b2:	e45e                	sd	s7,8(sp)
    800017b4:	e062                	sd	s8,0(sp)
    800017b6:	0880                	addi	s0,sp,80
    800017b8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	0000e497          	auipc	s1,0xe
    800017be:	62e48493          	addi	s1,s1,1582 # 8000fde8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017c2:	8c26                	mv	s8,s1
    800017c4:	000a57b7          	lui	a5,0xa5
    800017c8:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    800017cc:	07b2                	slli	a5,a5,0xc
    800017ce:	fa578793          	addi	a5,a5,-91
    800017d2:	4fa50937          	lui	s2,0x4fa50
    800017d6:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800017da:	1902                	slli	s2,s2,0x20
    800017dc:	993e                	add	s2,s2,a5
    800017de:	040009b7          	lui	s3,0x4000
    800017e2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017e4:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e6:	4b99                	li	s7,6
    800017e8:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ea:	00014a97          	auipc	s5,0x14
    800017ee:	ffea8a93          	addi	s5,s5,-2 # 800157e8 <tickslock>
    char *pa = kalloc();
    800017f2:	b52ff0ef          	jal	80000b44 <kalloc>
    800017f6:	862a                	mv	a2,a0
    if(pa == 0)
    800017f8:	c121                	beqz	a0,80001838 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    800017fa:	418485b3          	sub	a1,s1,s8
    800017fe:	858d                	srai	a1,a1,0x3
    80001800:	032585b3          	mul	a1,a1,s2
    80001804:	05b6                	slli	a1,a1,0xd
    80001806:	6789                	lui	a5,0x2
    80001808:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000180a:	875e                	mv	a4,s7
    8000180c:	86da                	mv	a3,s6
    8000180e:	40b985b3          	sub	a1,s3,a1
    80001812:	8552                	mv	a0,s4
    80001814:	903ff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001818:	16848493          	addi	s1,s1,360
    8000181c:	fd549be3          	bne	s1,s5,800017f2 <proc_mapstacks+0x52>
  }
}
    80001820:	60a6                	ld	ra,72(sp)
    80001822:	6406                	ld	s0,64(sp)
    80001824:	74e2                	ld	s1,56(sp)
    80001826:	7942                	ld	s2,48(sp)
    80001828:	79a2                	ld	s3,40(sp)
    8000182a:	7a02                	ld	s4,32(sp)
    8000182c:	6ae2                	ld	s5,24(sp)
    8000182e:	6b42                	ld	s6,16(sp)
    80001830:	6ba2                	ld	s7,8(sp)
    80001832:	6c02                	ld	s8,0(sp)
    80001834:	6161                	addi	sp,sp,80
    80001836:	8082                	ret
      panic("kalloc");
    80001838:	00006517          	auipc	a0,0x6
    8000183c:	92050513          	addi	a0,a0,-1760 # 80007158 <etext+0x158>
    80001840:	fe5fe0ef          	jal	80000824 <panic>

0000000080001844 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001844:	7139                	addi	sp,sp,-64
    80001846:	fc06                	sd	ra,56(sp)
    80001848:	f822                	sd	s0,48(sp)
    8000184a:	f426                	sd	s1,40(sp)
    8000184c:	f04a                	sd	s2,32(sp)
    8000184e:	ec4e                	sd	s3,24(sp)
    80001850:	e852                	sd	s4,16(sp)
    80001852:	e456                	sd	s5,8(sp)
    80001854:	e05a                	sd	s6,0(sp)
    80001856:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001858:	00006597          	auipc	a1,0x6
    8000185c:	90858593          	addi	a1,a1,-1784 # 80007160 <etext+0x160>
    80001860:	0000e517          	auipc	a0,0xe
    80001864:	15850513          	addi	a0,a0,344 # 8000f9b8 <pid_lock>
    80001868:	b36ff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000186c:	00006597          	auipc	a1,0x6
    80001870:	8fc58593          	addi	a1,a1,-1796 # 80007168 <etext+0x168>
    80001874:	0000e517          	auipc	a0,0xe
    80001878:	15c50513          	addi	a0,a0,348 # 8000f9d0 <wait_lock>
    8000187c:	b22ff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	0000e497          	auipc	s1,0xe
    80001884:	56848493          	addi	s1,s1,1384 # 8000fde8 <proc>
      initlock(&p->lock, "proc");
    80001888:	00006b17          	auipc	s6,0x6
    8000188c:	8f0b0b13          	addi	s6,s6,-1808 # 80007178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001890:	8aa6                	mv	s5,s1
    80001892:	000a57b7          	lui	a5,0xa5
    80001896:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    8000189a:	07b2                	slli	a5,a5,0xc
    8000189c:	fa578793          	addi	a5,a5,-91
    800018a0:	4fa50937          	lui	s2,0x4fa50
    800018a4:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800018a8:	1902                	slli	s2,s2,0x20
    800018aa:	993e                	add	s2,s2,a5
    800018ac:	040009b7          	lui	s3,0x4000
    800018b0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018b2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b4:	00014a17          	auipc	s4,0x14
    800018b8:	f34a0a13          	addi	s4,s4,-204 # 800157e8 <tickslock>
      initlock(&p->lock, "proc");
    800018bc:	85da                	mv	a1,s6
    800018be:	8526                	mv	a0,s1
    800018c0:	adeff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800018c4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018c8:	415487b3          	sub	a5,s1,s5
    800018cc:	878d                	srai	a5,a5,0x3
    800018ce:	032787b3          	mul	a5,a5,s2
    800018d2:	07b6                	slli	a5,a5,0xd
    800018d4:	6709                	lui	a4,0x2
    800018d6:	9fb9                	addw	a5,a5,a4
    800018d8:	40f987b3          	sub	a5,s3,a5
    800018dc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018de:	16848493          	addi	s1,s1,360
    800018e2:	fd449de3          	bne	s1,s4,800018bc <procinit+0x78>
  }
}
    800018e6:	70e2                	ld	ra,56(sp)
    800018e8:	7442                	ld	s0,48(sp)
    800018ea:	74a2                	ld	s1,40(sp)
    800018ec:	7902                	ld	s2,32(sp)
    800018ee:	69e2                	ld	s3,24(sp)
    800018f0:	6a42                	ld	s4,16(sp)
    800018f2:	6aa2                	ld	s5,8(sp)
    800018f4:	6b02                	ld	s6,0(sp)
    800018f6:	6121                	addi	sp,sp,64
    800018f8:	8082                	ret

00000000800018fa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018fa:	1141                	addi	sp,sp,-16
    800018fc:	e406                	sd	ra,8(sp)
    800018fe:	e022                	sd	s0,0(sp)
    80001900:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001902:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001904:	2501                	sext.w	a0,a0
    80001906:	60a2                	ld	ra,8(sp)
    80001908:	6402                	ld	s0,0(sp)
    8000190a:	0141                	addi	sp,sp,16
    8000190c:	8082                	ret

000000008000190e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000190e:	1141                	addi	sp,sp,-16
    80001910:	e406                	sd	ra,8(sp)
    80001912:	e022                	sd	s0,0(sp)
    80001914:	0800                	addi	s0,sp,16
    80001916:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001918:	2781                	sext.w	a5,a5
    8000191a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000191c:	0000e517          	auipc	a0,0xe
    80001920:	0cc50513          	addi	a0,a0,204 # 8000f9e8 <cpus>
    80001924:	953e                	add	a0,a0,a5
    80001926:	60a2                	ld	ra,8(sp)
    80001928:	6402                	ld	s0,0(sp)
    8000192a:	0141                	addi	sp,sp,16
    8000192c:	8082                	ret

000000008000192e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000192e:	1101                	addi	sp,sp,-32
    80001930:	ec06                	sd	ra,24(sp)
    80001932:	e822                	sd	s0,16(sp)
    80001934:	e426                	sd	s1,8(sp)
    80001936:	1000                	addi	s0,sp,32
  push_off();
    80001938:	aacff0ef          	jal	80000be4 <push_off>
    8000193c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000193e:	2781                	sext.w	a5,a5
    80001940:	079e                	slli	a5,a5,0x7
    80001942:	0000e717          	auipc	a4,0xe
    80001946:	07670713          	addi	a4,a4,118 # 8000f9b8 <pid_lock>
    8000194a:	97ba                	add	a5,a5,a4
    8000194c:	7b9c                	ld	a5,48(a5)
    8000194e:	84be                	mv	s1,a5
  pop_off();
    80001950:	b1cff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001954:	8526                	mv	a0,s1
    80001956:	60e2                	ld	ra,24(sp)
    80001958:	6442                	ld	s0,16(sp)
    8000195a:	64a2                	ld	s1,8(sp)
    8000195c:	6105                	addi	sp,sp,32
    8000195e:	8082                	ret

0000000080001960 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001960:	7179                	addi	sp,sp,-48
    80001962:	f406                	sd	ra,40(sp)
    80001964:	f022                	sd	s0,32(sp)
    80001966:	ec26                	sd	s1,24(sp)
    80001968:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000196a:	fc5ff0ef          	jal	8000192e <myproc>
    8000196e:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001970:	b4cff0ef          	jal	80000cbc <release>

  if (first) {
    80001974:	00006797          	auipc	a5,0x6
    80001978:	f0c7a783          	lw	a5,-244(a5) # 80007880 <first.2>
    8000197c:	cf95                	beqz	a5,800019b8 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000197e:	4505                	li	a0,1
    80001980:	4a5010ef          	jal	80003624 <fsinit>

    first = 0;
    80001984:	00006797          	auipc	a5,0x6
    80001988:	ee07ae23          	sw	zero,-260(a5) # 80007880 <first.2>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000198c:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001990:	00005797          	auipc	a5,0x5
    80001994:	7f078793          	addi	a5,a5,2032 # 80007180 <etext+0x180>
    80001998:	fcf43823          	sd	a5,-48(s0)
    8000199c:	fc043c23          	sd	zero,-40(s0)
    800019a0:	fd040593          	addi	a1,s0,-48
    800019a4:	853e                	mv	a0,a5
    800019a6:	607020ef          	jal	800047ac <kexec>
    800019aa:	6cbc                	ld	a5,88(s1)
    800019ac:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800019ae:	6cbc                	ld	a5,88(s1)
    800019b0:	7bb8                	ld	a4,112(a5)
    800019b2:	57fd                	li	a5,-1
    800019b4:	02f70d63          	beq	a4,a5,800019ee <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019b8:	3bd000ef          	jal	80002574 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019bc:	68a8                	ld	a0,80(s1)
    800019be:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019c0:	04000737          	lui	a4,0x4000
    800019c4:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019c6:	0732                	slli	a4,a4,0xc
    800019c8:	00004797          	auipc	a5,0x4
    800019cc:	6d478793          	addi	a5,a5,1748 # 8000609c <userret>
    800019d0:	00004697          	auipc	a3,0x4
    800019d4:	63068693          	addi	a3,a3,1584 # 80006000 <_trampoline>
    800019d8:	8f95                	sub	a5,a5,a3
    800019da:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019dc:	577d                	li	a4,-1
    800019de:	177e                	slli	a4,a4,0x3f
    800019e0:	8d59                	or	a0,a0,a4
    800019e2:	9782                	jalr	a5
}
    800019e4:	70a2                	ld	ra,40(sp)
    800019e6:	7402                	ld	s0,32(sp)
    800019e8:	64e2                	ld	s1,24(sp)
    800019ea:	6145                	addi	sp,sp,48
    800019ec:	8082                	ret
      panic("exec");
    800019ee:	00005517          	auipc	a0,0x5
    800019f2:	79a50513          	addi	a0,a0,1946 # 80007188 <etext+0x188>
    800019f6:	e2ffe0ef          	jal	80000824 <panic>

00000000800019fa <allocpid>:
{
    800019fa:	1101                	addi	sp,sp,-32
    800019fc:	ec06                	sd	ra,24(sp)
    800019fe:	e822                	sd	s0,16(sp)
    80001a00:	e426                	sd	s1,8(sp)
    80001a02:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a04:	0000e517          	auipc	a0,0xe
    80001a08:	fb450513          	addi	a0,a0,-76 # 8000f9b8 <pid_lock>
    80001a0c:	a1cff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001a10:	00006797          	auipc	a5,0x6
    80001a14:	e7478793          	addi	a5,a5,-396 # 80007884 <nextpid>
    80001a18:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a1a:	0014871b          	addiw	a4,s1,1
    80001a1e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a20:	0000e517          	auipc	a0,0xe
    80001a24:	f9850513          	addi	a0,a0,-104 # 8000f9b8 <pid_lock>
    80001a28:	a94ff0ef          	jal	80000cbc <release>
}
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	60e2                	ld	ra,24(sp)
    80001a30:	6442                	ld	s0,16(sp)
    80001a32:	64a2                	ld	s1,8(sp)
    80001a34:	6105                	addi	sp,sp,32
    80001a36:	8082                	ret

0000000080001a38 <proc_pagetable>:
{
    80001a38:	1101                	addi	sp,sp,-32
    80001a3a:	ec06                	sd	ra,24(sp)
    80001a3c:	e822                	sd	s0,16(sp)
    80001a3e:	e426                	sd	s1,8(sp)
    80001a40:	e04a                	sd	s2,0(sp)
    80001a42:	1000                	addi	s0,sp,32
    80001a44:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a46:	fc2ff0ef          	jal	80001208 <uvmcreate>
    80001a4a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a4c:	cd05                	beqz	a0,80001a84 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a4e:	4729                	li	a4,10
    80001a50:	00004697          	auipc	a3,0x4
    80001a54:	5b068693          	addi	a3,a3,1456 # 80006000 <_trampoline>
    80001a58:	6605                	lui	a2,0x1
    80001a5a:	040005b7          	lui	a1,0x4000
    80001a5e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a60:	05b2                	slli	a1,a1,0xc
    80001a62:	dfeff0ef          	jal	80001060 <mappages>
    80001a66:	02054663          	bltz	a0,80001a92 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a6a:	4719                	li	a4,6
    80001a6c:	05893683          	ld	a3,88(s2)
    80001a70:	6605                	lui	a2,0x1
    80001a72:	020005b7          	lui	a1,0x2000
    80001a76:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a78:	05b6                	slli	a1,a1,0xd
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	de4ff0ef          	jal	80001060 <mappages>
    80001a80:	00054f63          	bltz	a0,80001a9e <proc_pagetable+0x66>
}
    80001a84:	8526                	mv	a0,s1
    80001a86:	60e2                	ld	ra,24(sp)
    80001a88:	6442                	ld	s0,16(sp)
    80001a8a:	64a2                	ld	s1,8(sp)
    80001a8c:	6902                	ld	s2,0(sp)
    80001a8e:	6105                	addi	sp,sp,32
    80001a90:	8082                	ret
    uvmfree(pagetable, 0);
    80001a92:	4581                	li	a1,0
    80001a94:	8526                	mv	a0,s1
    80001a96:	96dff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001a9a:	4481                	li	s1,0
    80001a9c:	b7e5                	j	80001a84 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a9e:	4681                	li	a3,0
    80001aa0:	4605                	li	a2,1
    80001aa2:	040005b7          	lui	a1,0x4000
    80001aa6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aa8:	05b2                	slli	a1,a1,0xc
    80001aaa:	8526                	mv	a0,s1
    80001aac:	f82ff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80001ab0:	4581                	li	a1,0
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	94fff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001ab8:	4481                	li	s1,0
    80001aba:	b7e9                	j	80001a84 <proc_pagetable+0x4c>

0000000080001abc <proc_freepagetable>:
{
    80001abc:	1101                	addi	sp,sp,-32
    80001abe:	ec06                	sd	ra,24(sp)
    80001ac0:	e822                	sd	s0,16(sp)
    80001ac2:	e426                	sd	s1,8(sp)
    80001ac4:	e04a                	sd	s2,0(sp)
    80001ac6:	1000                	addi	s0,sp,32
    80001ac8:	84aa                	mv	s1,a0
    80001aca:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001acc:	4681                	li	a3,0
    80001ace:	4605                	li	a2,1
    80001ad0:	040005b7          	lui	a1,0x4000
    80001ad4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad6:	05b2                	slli	a1,a1,0xc
    80001ad8:	f56ff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001adc:	4681                	li	a3,0
    80001ade:	4605                	li	a2,1
    80001ae0:	020005b7          	lui	a1,0x2000
    80001ae4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ae6:	05b6                	slli	a1,a1,0xd
    80001ae8:	8526                	mv	a0,s1
    80001aea:	f44ff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80001aee:	85ca                	mv	a1,s2
    80001af0:	8526                	mv	a0,s1
    80001af2:	911ff0ef          	jal	80001402 <uvmfree>
}
    80001af6:	60e2                	ld	ra,24(sp)
    80001af8:	6442                	ld	s0,16(sp)
    80001afa:	64a2                	ld	s1,8(sp)
    80001afc:	6902                	ld	s2,0(sp)
    80001afe:	6105                	addi	sp,sp,32
    80001b00:	8082                	ret

0000000080001b02 <freeproc>:
{
    80001b02:	1101                	addi	sp,sp,-32
    80001b04:	ec06                	sd	ra,24(sp)
    80001b06:	e822                	sd	s0,16(sp)
    80001b08:	e426                	sd	s1,8(sp)
    80001b0a:	1000                	addi	s0,sp,32
    80001b0c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b0e:	6d28                	ld	a0,88(a0)
    80001b10:	c119                	beqz	a0,80001b16 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b12:	f4bfe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001b16:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b1a:	68a8                	ld	a0,80(s1)
    80001b1c:	c501                	beqz	a0,80001b24 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b1e:	64ac                	ld	a1,72(s1)
    80001b20:	f9dff0ef          	jal	80001abc <proc_freepagetable>
  p->pagetable = 0;
    80001b24:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b28:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b2c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b30:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b34:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b38:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b3c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b40:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b44:	0004ac23          	sw	zero,24(s1)
}
    80001b48:	60e2                	ld	ra,24(sp)
    80001b4a:	6442                	ld	s0,16(sp)
    80001b4c:	64a2                	ld	s1,8(sp)
    80001b4e:	6105                	addi	sp,sp,32
    80001b50:	8082                	ret

0000000080001b52 <allocproc>:
{
    80001b52:	1101                	addi	sp,sp,-32
    80001b54:	ec06                	sd	ra,24(sp)
    80001b56:	e822                	sd	s0,16(sp)
    80001b58:	e426                	sd	s1,8(sp)
    80001b5a:	e04a                	sd	s2,0(sp)
    80001b5c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b5e:	0000e497          	auipc	s1,0xe
    80001b62:	28a48493          	addi	s1,s1,650 # 8000fde8 <proc>
    80001b66:	00014917          	auipc	s2,0x14
    80001b6a:	c8290913          	addi	s2,s2,-894 # 800157e8 <tickslock>
    acquire(&p->lock);
    80001b6e:	8526                	mv	a0,s1
    80001b70:	8b8ff0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001b74:	4c9c                	lw	a5,24(s1)
    80001b76:	cb91                	beqz	a5,80001b8a <allocproc+0x38>
      release(&p->lock);
    80001b78:	8526                	mv	a0,s1
    80001b7a:	942ff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b7e:	16848493          	addi	s1,s1,360
    80001b82:	ff2496e3          	bne	s1,s2,80001b6e <allocproc+0x1c>
  return 0;
    80001b86:	4481                	li	s1,0
    80001b88:	a089                	j	80001bca <allocproc+0x78>
  p->pid = allocpid();
    80001b8a:	e71ff0ef          	jal	800019fa <allocpid>
    80001b8e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b90:	4785                	li	a5,1
    80001b92:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b94:	fb1fe0ef          	jal	80000b44 <kalloc>
    80001b98:	892a                	mv	s2,a0
    80001b9a:	eca8                	sd	a0,88(s1)
    80001b9c:	cd15                	beqz	a0,80001bd8 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	e99ff0ef          	jal	80001a38 <proc_pagetable>
    80001ba4:	892a                	mv	s2,a0
    80001ba6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001ba8:	c121                	beqz	a0,80001be8 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001baa:	07000613          	li	a2,112
    80001bae:	4581                	li	a1,0
    80001bb0:	06048513          	addi	a0,s1,96
    80001bb4:	944ff0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001bb8:	00000797          	auipc	a5,0x0
    80001bbc:	da878793          	addi	a5,a5,-600 # 80001960 <forkret>
    80001bc0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bc2:	60bc                	ld	a5,64(s1)
    80001bc4:	6705                	lui	a4,0x1
    80001bc6:	97ba                	add	a5,a5,a4
    80001bc8:	f4bc                	sd	a5,104(s1)
}
    80001bca:	8526                	mv	a0,s1
    80001bcc:	60e2                	ld	ra,24(sp)
    80001bce:	6442                	ld	s0,16(sp)
    80001bd0:	64a2                	ld	s1,8(sp)
    80001bd2:	6902                	ld	s2,0(sp)
    80001bd4:	6105                	addi	sp,sp,32
    80001bd6:	8082                	ret
    freeproc(p);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	f29ff0ef          	jal	80001b02 <freeproc>
    release(&p->lock);
    80001bde:	8526                	mv	a0,s1
    80001be0:	8dcff0ef          	jal	80000cbc <release>
    return 0;
    80001be4:	84ca                	mv	s1,s2
    80001be6:	b7d5                	j	80001bca <allocproc+0x78>
    freeproc(p);
    80001be8:	8526                	mv	a0,s1
    80001bea:	f19ff0ef          	jal	80001b02 <freeproc>
    release(&p->lock);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	8ccff0ef          	jal	80000cbc <release>
    return 0;
    80001bf4:	84ca                	mv	s1,s2
    80001bf6:	bfd1                	j	80001bca <allocproc+0x78>

0000000080001bf8 <userinit>:
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c02:	f51ff0ef          	jal	80001b52 <allocproc>
    80001c06:	84aa                	mv	s1,a0
  initproc = p;
    80001c08:	00006797          	auipc	a5,0x6
    80001c0c:	caa7b423          	sd	a0,-856(a5) # 800078b0 <initproc>
  p->cwd = namei("/");
    80001c10:	00005517          	auipc	a0,0x5
    80001c14:	58050513          	addi	a0,a0,1408 # 80007190 <etext+0x190>
    80001c18:	747010ef          	jal	80003b5e <namei>
    80001c1c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c20:	478d                	li	a5,3
    80001c22:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c24:	8526                	mv	a0,s1
    80001c26:	896ff0ef          	jal	80000cbc <release>
}
    80001c2a:	60e2                	ld	ra,24(sp)
    80001c2c:	6442                	ld	s0,16(sp)
    80001c2e:	64a2                	ld	s1,8(sp)
    80001c30:	6105                	addi	sp,sp,32
    80001c32:	8082                	ret

0000000080001c34 <growproc>:
{
    80001c34:	1101                	addi	sp,sp,-32
    80001c36:	ec06                	sd	ra,24(sp)
    80001c38:	e822                	sd	s0,16(sp)
    80001c3a:	e426                	sd	s1,8(sp)
    80001c3c:	e04a                	sd	s2,0(sp)
    80001c3e:	1000                	addi	s0,sp,32
    80001c40:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c42:	cedff0ef          	jal	8000192e <myproc>
    80001c46:	892a                	mv	s2,a0
  sz = p->sz;
    80001c48:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c4a:	02905963          	blez	s1,80001c7c <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001c4e:	00b48633          	add	a2,s1,a1
    80001c52:	020007b7          	lui	a5,0x2000
    80001c56:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c58:	07b6                	slli	a5,a5,0xd
    80001c5a:	02c7ea63          	bltu	a5,a2,80001c8e <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c5e:	4691                	li	a3,4
    80001c60:	6928                	ld	a0,80(a0)
    80001c62:	e9aff0ef          	jal	800012fc <uvmalloc>
    80001c66:	85aa                	mv	a1,a0
    80001c68:	c50d                	beqz	a0,80001c92 <growproc+0x5e>
  p->sz = sz;
    80001c6a:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c6e:	4501                	li	a0,0
}
    80001c70:	60e2                	ld	ra,24(sp)
    80001c72:	6442                	ld	s0,16(sp)
    80001c74:	64a2                	ld	s1,8(sp)
    80001c76:	6902                	ld	s2,0(sp)
    80001c78:	6105                	addi	sp,sp,32
    80001c7a:	8082                	ret
  } else if(n < 0){
    80001c7c:	fe04d7e3          	bgez	s1,80001c6a <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c80:	00b48633          	add	a2,s1,a1
    80001c84:	6928                	ld	a0,80(a0)
    80001c86:	e32ff0ef          	jal	800012b8 <uvmdealloc>
    80001c8a:	85aa                	mv	a1,a0
    80001c8c:	bff9                	j	80001c6a <growproc+0x36>
      return -1;
    80001c8e:	557d                	li	a0,-1
    80001c90:	b7c5                	j	80001c70 <growproc+0x3c>
      return -1;
    80001c92:	557d                	li	a0,-1
    80001c94:	bff1                	j	80001c70 <growproc+0x3c>

0000000080001c96 <kfork>:
{
    80001c96:	7139                	addi	sp,sp,-64
    80001c98:	fc06                	sd	ra,56(sp)
    80001c9a:	f822                	sd	s0,48(sp)
    80001c9c:	f426                	sd	s1,40(sp)
    80001c9e:	e456                	sd	s5,8(sp)
    80001ca0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001ca2:	c8dff0ef          	jal	8000192e <myproc>
    80001ca6:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001ca8:	eabff0ef          	jal	80001b52 <allocproc>
    80001cac:	0e050a63          	beqz	a0,80001da0 <kfork+0x10a>
    80001cb0:	e852                	sd	s4,16(sp)
    80001cb2:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001cb4:	048ab603          	ld	a2,72(s5)
    80001cb8:	692c                	ld	a1,80(a0)
    80001cba:	050ab503          	ld	a0,80(s5)
    80001cbe:	f76ff0ef          	jal	80001434 <uvmcopy>
    80001cc2:	04054863          	bltz	a0,80001d12 <kfork+0x7c>
    80001cc6:	f04a                	sd	s2,32(sp)
    80001cc8:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cca:	048ab783          	ld	a5,72(s5)
    80001cce:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cd2:	058ab683          	ld	a3,88(s5)
    80001cd6:	87b6                	mv	a5,a3
    80001cd8:	058a3703          	ld	a4,88(s4)
    80001cdc:	12068693          	addi	a3,a3,288
    80001ce0:	6388                	ld	a0,0(a5)
    80001ce2:	678c                	ld	a1,8(a5)
    80001ce4:	6b90                	ld	a2,16(a5)
    80001ce6:	e308                	sd	a0,0(a4)
    80001ce8:	e70c                	sd	a1,8(a4)
    80001cea:	eb10                	sd	a2,16(a4)
    80001cec:	6f90                	ld	a2,24(a5)
    80001cee:	ef10                	sd	a2,24(a4)
    80001cf0:	02078793          	addi	a5,a5,32
    80001cf4:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001cf8:	fed794e3          	bne	a5,a3,80001ce0 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001cfc:	058a3783          	ld	a5,88(s4)
    80001d00:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d04:	0d0a8493          	addi	s1,s5,208
    80001d08:	0d0a0913          	addi	s2,s4,208
    80001d0c:	150a8993          	addi	s3,s5,336
    80001d10:	a831                	j	80001d2c <kfork+0x96>
    freeproc(np);
    80001d12:	8552                	mv	a0,s4
    80001d14:	defff0ef          	jal	80001b02 <freeproc>
    release(&np->lock);
    80001d18:	8552                	mv	a0,s4
    80001d1a:	fa3fe0ef          	jal	80000cbc <release>
    return -1;
    80001d1e:	54fd                	li	s1,-1
    80001d20:	6a42                	ld	s4,16(sp)
    80001d22:	a885                	j	80001d92 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001d24:	04a1                	addi	s1,s1,8
    80001d26:	0921                	addi	s2,s2,8
    80001d28:	01348963          	beq	s1,s3,80001d3a <kfork+0xa4>
    if(p->ofile[i])
    80001d2c:	6088                	ld	a0,0(s1)
    80001d2e:	d97d                	beqz	a0,80001d24 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d30:	3ea020ef          	jal	8000411a <filedup>
    80001d34:	00a93023          	sd	a0,0(s2)
    80001d38:	b7f5                	j	80001d24 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d3a:	150ab503          	ld	a0,336(s5)
    80001d3e:	5bc010ef          	jal	800032fa <idup>
    80001d42:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d46:	4641                	li	a2,16
    80001d48:	158a8593          	addi	a1,s5,344
    80001d4c:	158a0513          	addi	a0,s4,344
    80001d50:	8fcff0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001d54:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d58:	8552                	mv	a0,s4
    80001d5a:	f63fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001d5e:	0000e517          	auipc	a0,0xe
    80001d62:	c7250513          	addi	a0,a0,-910 # 8000f9d0 <wait_lock>
    80001d66:	ec3fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001d6a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d6e:	0000e517          	auipc	a0,0xe
    80001d72:	c6250513          	addi	a0,a0,-926 # 8000f9d0 <wait_lock>
    80001d76:	f47fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001d7a:	8552                	mv	a0,s4
    80001d7c:	eadfe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001d80:	478d                	li	a5,3
    80001d82:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d86:	8552                	mv	a0,s4
    80001d88:	f35fe0ef          	jal	80000cbc <release>
  return pid;
    80001d8c:	7902                	ld	s2,32(sp)
    80001d8e:	69e2                	ld	s3,24(sp)
    80001d90:	6a42                	ld	s4,16(sp)
}
    80001d92:	8526                	mv	a0,s1
    80001d94:	70e2                	ld	ra,56(sp)
    80001d96:	7442                	ld	s0,48(sp)
    80001d98:	74a2                	ld	s1,40(sp)
    80001d9a:	6aa2                	ld	s5,8(sp)
    80001d9c:	6121                	addi	sp,sp,64
    80001d9e:	8082                	ret
    return -1;
    80001da0:	54fd                	li	s1,-1
    80001da2:	bfc5                	j	80001d92 <kfork+0xfc>

0000000080001da4 <scheduler>:
{
    80001da4:	715d                	addi	sp,sp,-80
    80001da6:	e486                	sd	ra,72(sp)
    80001da8:	e0a2                	sd	s0,64(sp)
    80001daa:	fc26                	sd	s1,56(sp)
    80001dac:	f84a                	sd	s2,48(sp)
    80001dae:	f44e                	sd	s3,40(sp)
    80001db0:	f052                	sd	s4,32(sp)
    80001db2:	ec56                	sd	s5,24(sp)
    80001db4:	e85a                	sd	s6,16(sp)
    80001db6:	e45e                	sd	s7,8(sp)
    80001db8:	e062                	sd	s8,0(sp)
    80001dba:	0880                	addi	s0,sp,80
    80001dbc:	8792                	mv	a5,tp
  int id = r_tp();
    80001dbe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001dc0:	00779b13          	slli	s6,a5,0x7
    80001dc4:	0000e717          	auipc	a4,0xe
    80001dc8:	bf470713          	addi	a4,a4,-1036 # 8000f9b8 <pid_lock>
    80001dcc:	975a                	add	a4,a4,s6
    80001dce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001dd2:	0000e717          	auipc	a4,0xe
    80001dd6:	c1e70713          	addi	a4,a4,-994 # 8000f9f0 <cpus+0x8>
    80001dda:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001ddc:	4c11                	li	s8,4
        c->proc = p;
    80001dde:	079e                	slli	a5,a5,0x7
    80001de0:	0000ea17          	auipc	s4,0xe
    80001de4:	bd8a0a13          	addi	s4,s4,-1064 # 8000f9b8 <pid_lock>
    80001de8:	9a3e                	add	s4,s4,a5
        found = 1;
    80001dea:	4b85                	li	s7,1
    80001dec:	a83d                	j	80001e2a <scheduler+0x86>
      release(&p->lock);
    80001dee:	8526                	mv	a0,s1
    80001df0:	ecdfe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001df4:	16848493          	addi	s1,s1,360
    80001df8:	03248563          	beq	s1,s2,80001e22 <scheduler+0x7e>
      acquire(&p->lock);
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	e2bfe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80001e02:	4c9c                	lw	a5,24(s1)
    80001e04:	ff3795e3          	bne	a5,s3,80001dee <scheduler+0x4a>
        p->state = RUNNING;
    80001e08:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001e0c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001e10:	06048593          	addi	a1,s1,96
    80001e14:	855a                	mv	a0,s6
    80001e16:	6b4000ef          	jal	800024ca <swtch>
        c->proc = 0;
    80001e1a:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e1e:	8ade                	mv	s5,s7
    80001e20:	b7f9                	j	80001dee <scheduler+0x4a>
    if(found == 0) {
    80001e22:	000a9463          	bnez	s5,80001e2a <scheduler+0x86>
      asm volatile("wfi");
    80001e26:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e2e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e32:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e36:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e3a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e3c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e40:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e42:	0000e497          	auipc	s1,0xe
    80001e46:	fa648493          	addi	s1,s1,-90 # 8000fde8 <proc>
      if(p->state == RUNNABLE) {
    80001e4a:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e4c:	00014917          	auipc	s2,0x14
    80001e50:	99c90913          	addi	s2,s2,-1636 # 800157e8 <tickslock>
    80001e54:	b765                	j	80001dfc <scheduler+0x58>

0000000080001e56 <sched>:
{
    80001e56:	7179                	addi	sp,sp,-48
    80001e58:	f406                	sd	ra,40(sp)
    80001e5a:	f022                	sd	s0,32(sp)
    80001e5c:	ec26                	sd	s1,24(sp)
    80001e5e:	e84a                	sd	s2,16(sp)
    80001e60:	e44e                	sd	s3,8(sp)
    80001e62:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e64:	acbff0ef          	jal	8000192e <myproc>
    80001e68:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e6a:	d4ffe0ef          	jal	80000bb8 <holding>
    80001e6e:	c935                	beqz	a0,80001ee2 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e70:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e72:	2781                	sext.w	a5,a5
    80001e74:	079e                	slli	a5,a5,0x7
    80001e76:	0000e717          	auipc	a4,0xe
    80001e7a:	b4270713          	addi	a4,a4,-1214 # 8000f9b8 <pid_lock>
    80001e7e:	97ba                	add	a5,a5,a4
    80001e80:	0a87a703          	lw	a4,168(a5)
    80001e84:	4785                	li	a5,1
    80001e86:	06f71463          	bne	a4,a5,80001eee <sched+0x98>
  if(p->state == RUNNING)
    80001e8a:	4c98                	lw	a4,24(s1)
    80001e8c:	4791                	li	a5,4
    80001e8e:	06f70663          	beq	a4,a5,80001efa <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e92:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e96:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e98:	e7bd                	bnez	a5,80001f06 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e9a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e9c:	0000e917          	auipc	s2,0xe
    80001ea0:	b1c90913          	addi	s2,s2,-1252 # 8000f9b8 <pid_lock>
    80001ea4:	2781                	sext.w	a5,a5
    80001ea6:	079e                	slli	a5,a5,0x7
    80001ea8:	97ca                	add	a5,a5,s2
    80001eaa:	0ac7a983          	lw	s3,172(a5)
    80001eae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001eb0:	2781                	sext.w	a5,a5
    80001eb2:	079e                	slli	a5,a5,0x7
    80001eb4:	07a1                	addi	a5,a5,8
    80001eb6:	0000e597          	auipc	a1,0xe
    80001eba:	b3258593          	addi	a1,a1,-1230 # 8000f9e8 <cpus>
    80001ebe:	95be                	add	a1,a1,a5
    80001ec0:	06048513          	addi	a0,s1,96
    80001ec4:	606000ef          	jal	800024ca <swtch>
    80001ec8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001eca:	2781                	sext.w	a5,a5
    80001ecc:	079e                	slli	a5,a5,0x7
    80001ece:	993e                	add	s2,s2,a5
    80001ed0:	0b392623          	sw	s3,172(s2)
}
    80001ed4:	70a2                	ld	ra,40(sp)
    80001ed6:	7402                	ld	s0,32(sp)
    80001ed8:	64e2                	ld	s1,24(sp)
    80001eda:	6942                	ld	s2,16(sp)
    80001edc:	69a2                	ld	s3,8(sp)
    80001ede:	6145                	addi	sp,sp,48
    80001ee0:	8082                	ret
    panic("sched p->lock");
    80001ee2:	00005517          	auipc	a0,0x5
    80001ee6:	2b650513          	addi	a0,a0,694 # 80007198 <etext+0x198>
    80001eea:	93bfe0ef          	jal	80000824 <panic>
    panic("sched locks");
    80001eee:	00005517          	auipc	a0,0x5
    80001ef2:	2ba50513          	addi	a0,a0,698 # 800071a8 <etext+0x1a8>
    80001ef6:	92ffe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    80001efa:	00005517          	auipc	a0,0x5
    80001efe:	2be50513          	addi	a0,a0,702 # 800071b8 <etext+0x1b8>
    80001f02:	923fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    80001f06:	00005517          	auipc	a0,0x5
    80001f0a:	2c250513          	addi	a0,a0,706 # 800071c8 <etext+0x1c8>
    80001f0e:	917fe0ef          	jal	80000824 <panic>

0000000080001f12 <yield>:
{
    80001f12:	1101                	addi	sp,sp,-32
    80001f14:	ec06                	sd	ra,24(sp)
    80001f16:	e822                	sd	s0,16(sp)
    80001f18:	e426                	sd	s1,8(sp)
    80001f1a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f1c:	a13ff0ef          	jal	8000192e <myproc>
    80001f20:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f22:	d07fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80001f26:	478d                	li	a5,3
    80001f28:	cc9c                	sw	a5,24(s1)
  sched();
    80001f2a:	f2dff0ef          	jal	80001e56 <sched>
  release(&p->lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	d8dfe0ef          	jal	80000cbc <release>
}
    80001f34:	60e2                	ld	ra,24(sp)
    80001f36:	6442                	ld	s0,16(sp)
    80001f38:	64a2                	ld	s1,8(sp)
    80001f3a:	6105                	addi	sp,sp,32
    80001f3c:	8082                	ret

0000000080001f3e <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f3e:	7179                	addi	sp,sp,-48
    80001f40:	f406                	sd	ra,40(sp)
    80001f42:	f022                	sd	s0,32(sp)
    80001f44:	ec26                	sd	s1,24(sp)
    80001f46:	e84a                	sd	s2,16(sp)
    80001f48:	e44e                	sd	s3,8(sp)
    80001f4a:	1800                	addi	s0,sp,48
    80001f4c:	89aa                	mv	s3,a0
    80001f4e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f50:	9dfff0ef          	jal	8000192e <myproc>
    80001f54:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f56:	cd3fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80001f5a:	854a                	mv	a0,s2
    80001f5c:	d61fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    80001f60:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f64:	4789                	li	a5,2
    80001f66:	cc9c                	sw	a5,24(s1)

  sched();
    80001f68:	eefff0ef          	jal	80001e56 <sched>

  // Tidy up.
  p->chan = 0;
    80001f6c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f70:	8526                	mv	a0,s1
    80001f72:	d4bfe0ef          	jal	80000cbc <release>
  acquire(lk);
    80001f76:	854a                	mv	a0,s2
    80001f78:	cb1fe0ef          	jal	80000c28 <acquire>
}
    80001f7c:	70a2                	ld	ra,40(sp)
    80001f7e:	7402                	ld	s0,32(sp)
    80001f80:	64e2                	ld	s1,24(sp)
    80001f82:	6942                	ld	s2,16(sp)
    80001f84:	69a2                	ld	s3,8(sp)
    80001f86:	6145                	addi	sp,sp,48
    80001f88:	8082                	ret

0000000080001f8a <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f8a:	7139                	addi	sp,sp,-64
    80001f8c:	fc06                	sd	ra,56(sp)
    80001f8e:	f822                	sd	s0,48(sp)
    80001f90:	f426                	sd	s1,40(sp)
    80001f92:	f04a                	sd	s2,32(sp)
    80001f94:	ec4e                	sd	s3,24(sp)
    80001f96:	e852                	sd	s4,16(sp)
    80001f98:	e456                	sd	s5,8(sp)
    80001f9a:	0080                	addi	s0,sp,64
    80001f9c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f9e:	0000e497          	auipc	s1,0xe
    80001fa2:	e4a48493          	addi	s1,s1,-438 # 8000fde8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001fa6:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001fa8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001faa:	00014917          	auipc	s2,0x14
    80001fae:	83e90913          	addi	s2,s2,-1986 # 800157e8 <tickslock>
    80001fb2:	a801                	j	80001fc2 <wakeup+0x38>
      }
      release(&p->lock);
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	d07fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fba:	16848493          	addi	s1,s1,360
    80001fbe:	03248263          	beq	s1,s2,80001fe2 <wakeup+0x58>
    if(p != myproc()){
    80001fc2:	96dff0ef          	jal	8000192e <myproc>
    80001fc6:	fe950ae3          	beq	a0,s1,80001fba <wakeup+0x30>
      acquire(&p->lock);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	c5dfe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fd0:	4c9c                	lw	a5,24(s1)
    80001fd2:	ff3791e3          	bne	a5,s3,80001fb4 <wakeup+0x2a>
    80001fd6:	709c                	ld	a5,32(s1)
    80001fd8:	fd479ee3          	bne	a5,s4,80001fb4 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fdc:	0154ac23          	sw	s5,24(s1)
    80001fe0:	bfd1                	j	80001fb4 <wakeup+0x2a>
    }
  }
}
    80001fe2:	70e2                	ld	ra,56(sp)
    80001fe4:	7442                	ld	s0,48(sp)
    80001fe6:	74a2                	ld	s1,40(sp)
    80001fe8:	7902                	ld	s2,32(sp)
    80001fea:	69e2                	ld	s3,24(sp)
    80001fec:	6a42                	ld	s4,16(sp)
    80001fee:	6aa2                	ld	s5,8(sp)
    80001ff0:	6121                	addi	sp,sp,64
    80001ff2:	8082                	ret

0000000080001ff4 <reparent>:
{
    80001ff4:	7179                	addi	sp,sp,-48
    80001ff6:	f406                	sd	ra,40(sp)
    80001ff8:	f022                	sd	s0,32(sp)
    80001ffa:	ec26                	sd	s1,24(sp)
    80001ffc:	e84a                	sd	s2,16(sp)
    80001ffe:	e44e                	sd	s3,8(sp)
    80002000:	e052                	sd	s4,0(sp)
    80002002:	1800                	addi	s0,sp,48
    80002004:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002006:	0000e497          	auipc	s1,0xe
    8000200a:	de248493          	addi	s1,s1,-542 # 8000fde8 <proc>
      pp->parent = initproc;
    8000200e:	00006a17          	auipc	s4,0x6
    80002012:	8a2a0a13          	addi	s4,s4,-1886 # 800078b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002016:	00013997          	auipc	s3,0x13
    8000201a:	7d298993          	addi	s3,s3,2002 # 800157e8 <tickslock>
    8000201e:	a029                	j	80002028 <reparent+0x34>
    80002020:	16848493          	addi	s1,s1,360
    80002024:	01348b63          	beq	s1,s3,8000203a <reparent+0x46>
    if(pp->parent == p){
    80002028:	7c9c                	ld	a5,56(s1)
    8000202a:	ff279be3          	bne	a5,s2,80002020 <reparent+0x2c>
      pp->parent = initproc;
    8000202e:	000a3503          	ld	a0,0(s4)
    80002032:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002034:	f57ff0ef          	jal	80001f8a <wakeup>
    80002038:	b7e5                	j	80002020 <reparent+0x2c>
}
    8000203a:	70a2                	ld	ra,40(sp)
    8000203c:	7402                	ld	s0,32(sp)
    8000203e:	64e2                	ld	s1,24(sp)
    80002040:	6942                	ld	s2,16(sp)
    80002042:	69a2                	ld	s3,8(sp)
    80002044:	6a02                	ld	s4,0(sp)
    80002046:	6145                	addi	sp,sp,48
    80002048:	8082                	ret

000000008000204a <kexit>:
{
    8000204a:	7179                	addi	sp,sp,-48
    8000204c:	f406                	sd	ra,40(sp)
    8000204e:	f022                	sd	s0,32(sp)
    80002050:	ec26                	sd	s1,24(sp)
    80002052:	e84a                	sd	s2,16(sp)
    80002054:	e44e                	sd	s3,8(sp)
    80002056:	e052                	sd	s4,0(sp)
    80002058:	1800                	addi	s0,sp,48
    8000205a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000205c:	8d3ff0ef          	jal	8000192e <myproc>
    80002060:	89aa                	mv	s3,a0
  if(p == initproc)
    80002062:	00006797          	auipc	a5,0x6
    80002066:	84e7b783          	ld	a5,-1970(a5) # 800078b0 <initproc>
    8000206a:	0d050493          	addi	s1,a0,208
    8000206e:	15050913          	addi	s2,a0,336
    80002072:	00a79b63          	bne	a5,a0,80002088 <kexit+0x3e>
    panic("init exiting");
    80002076:	00005517          	auipc	a0,0x5
    8000207a:	16a50513          	addi	a0,a0,362 # 800071e0 <etext+0x1e0>
    8000207e:	fa6fe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002082:	04a1                	addi	s1,s1,8
    80002084:	01248963          	beq	s1,s2,80002096 <kexit+0x4c>
    if(p->ofile[fd]){
    80002088:	6088                	ld	a0,0(s1)
    8000208a:	dd65                	beqz	a0,80002082 <kexit+0x38>
      fileclose(f);
    8000208c:	0d4020ef          	jal	80004160 <fileclose>
      p->ofile[fd] = 0;
    80002090:	0004b023          	sd	zero,0(s1)
    80002094:	b7fd                	j	80002082 <kexit+0x38>
  begin_op();
    80002096:	4a7010ef          	jal	80003d3c <begin_op>
  iput(p->cwd);
    8000209a:	1509b503          	ld	a0,336(s3)
    8000209e:	414010ef          	jal	800034b2 <iput>
  end_op();
    800020a2:	50b010ef          	jal	80003dac <end_op>
  p->cwd = 0;
    800020a6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020aa:	0000e517          	auipc	a0,0xe
    800020ae:	92650513          	addi	a0,a0,-1754 # 8000f9d0 <wait_lock>
    800020b2:	b77fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800020b6:	854e                	mv	a0,s3
    800020b8:	f3dff0ef          	jal	80001ff4 <reparent>
  wakeup(p->parent);
    800020bc:	0389b503          	ld	a0,56(s3)
    800020c0:	ecbff0ef          	jal	80001f8a <wakeup>
  acquire(&p->lock);
    800020c4:	854e                	mv	a0,s3
    800020c6:	b63fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800020ca:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020ce:	4795                	li	a5,5
    800020d0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020d4:	0000e517          	auipc	a0,0xe
    800020d8:	8fc50513          	addi	a0,a0,-1796 # 8000f9d0 <wait_lock>
    800020dc:	be1fe0ef          	jal	80000cbc <release>
  sched();
    800020e0:	d77ff0ef          	jal	80001e56 <sched>
  panic("zombie exit");
    800020e4:	00005517          	auipc	a0,0x5
    800020e8:	10c50513          	addi	a0,a0,268 # 800071f0 <etext+0x1f0>
    800020ec:	f38fe0ef          	jal	80000824 <panic>

00000000800020f0 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020f0:	7179                	addi	sp,sp,-48
    800020f2:	f406                	sd	ra,40(sp)
    800020f4:	f022                	sd	s0,32(sp)
    800020f6:	ec26                	sd	s1,24(sp)
    800020f8:	e84a                	sd	s2,16(sp)
    800020fa:	e44e                	sd	s3,8(sp)
    800020fc:	1800                	addi	s0,sp,48
    800020fe:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002100:	0000e497          	auipc	s1,0xe
    80002104:	ce848493          	addi	s1,s1,-792 # 8000fde8 <proc>
    80002108:	00013997          	auipc	s3,0x13
    8000210c:	6e098993          	addi	s3,s3,1760 # 800157e8 <tickslock>
    acquire(&p->lock);
    80002110:	8526                	mv	a0,s1
    80002112:	b17fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    80002116:	589c                	lw	a5,48(s1)
    80002118:	01278b63          	beq	a5,s2,8000212e <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000211c:	8526                	mv	a0,s1
    8000211e:	b9ffe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002122:	16848493          	addi	s1,s1,360
    80002126:	ff3495e3          	bne	s1,s3,80002110 <kkill+0x20>
  }
  return -1;
    8000212a:	557d                	li	a0,-1
    8000212c:	a819                	j	80002142 <kkill+0x52>
      p->killed = 1;
    8000212e:	4785                	li	a5,1
    80002130:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002132:	4c98                	lw	a4,24(s1)
    80002134:	4789                	li	a5,2
    80002136:	00f70d63          	beq	a4,a5,80002150 <kkill+0x60>
      release(&p->lock);
    8000213a:	8526                	mv	a0,s1
    8000213c:	b81fe0ef          	jal	80000cbc <release>
      return 0;
    80002140:	4501                	li	a0,0
}
    80002142:	70a2                	ld	ra,40(sp)
    80002144:	7402                	ld	s0,32(sp)
    80002146:	64e2                	ld	s1,24(sp)
    80002148:	6942                	ld	s2,16(sp)
    8000214a:	69a2                	ld	s3,8(sp)
    8000214c:	6145                	addi	sp,sp,48
    8000214e:	8082                	ret
        p->state = RUNNABLE;
    80002150:	478d                	li	a5,3
    80002152:	cc9c                	sw	a5,24(s1)
    80002154:	b7dd                	j	8000213a <kkill+0x4a>

0000000080002156 <setkilled>:

void
setkilled(struct proc *p)
{
    80002156:	1101                	addi	sp,sp,-32
    80002158:	ec06                	sd	ra,24(sp)
    8000215a:	e822                	sd	s0,16(sp)
    8000215c:	e426                	sd	s1,8(sp)
    8000215e:	1000                	addi	s0,sp,32
    80002160:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002162:	ac7fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002166:	4785                	li	a5,1
    80002168:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000216a:	8526                	mv	a0,s1
    8000216c:	b51fe0ef          	jal	80000cbc <release>
}
    80002170:	60e2                	ld	ra,24(sp)
    80002172:	6442                	ld	s0,16(sp)
    80002174:	64a2                	ld	s1,8(sp)
    80002176:	6105                	addi	sp,sp,32
    80002178:	8082                	ret

000000008000217a <killed>:

int
killed(struct proc *p)
{
    8000217a:	1101                	addi	sp,sp,-32
    8000217c:	ec06                	sd	ra,24(sp)
    8000217e:	e822                	sd	s0,16(sp)
    80002180:	e426                	sd	s1,8(sp)
    80002182:	e04a                	sd	s2,0(sp)
    80002184:	1000                	addi	s0,sp,32
    80002186:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002188:	aa1fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    8000218c:	549c                	lw	a5,40(s1)
    8000218e:	893e                	mv	s2,a5
  release(&p->lock);
    80002190:	8526                	mv	a0,s1
    80002192:	b2bfe0ef          	jal	80000cbc <release>
  return k;
}
    80002196:	854a                	mv	a0,s2
    80002198:	60e2                	ld	ra,24(sp)
    8000219a:	6442                	ld	s0,16(sp)
    8000219c:	64a2                	ld	s1,8(sp)
    8000219e:	6902                	ld	s2,0(sp)
    800021a0:	6105                	addi	sp,sp,32
    800021a2:	8082                	ret

00000000800021a4 <kwait>:
{
    800021a4:	715d                	addi	sp,sp,-80
    800021a6:	e486                	sd	ra,72(sp)
    800021a8:	e0a2                	sd	s0,64(sp)
    800021aa:	fc26                	sd	s1,56(sp)
    800021ac:	f84a                	sd	s2,48(sp)
    800021ae:	f44e                	sd	s3,40(sp)
    800021b0:	f052                	sd	s4,32(sp)
    800021b2:	ec56                	sd	s5,24(sp)
    800021b4:	e85a                	sd	s6,16(sp)
    800021b6:	e45e                	sd	s7,8(sp)
    800021b8:	0880                	addi	s0,sp,80
    800021ba:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021bc:	f72ff0ef          	jal	8000192e <myproc>
    800021c0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021c2:	0000e517          	auipc	a0,0xe
    800021c6:	80e50513          	addi	a0,a0,-2034 # 8000f9d0 <wait_lock>
    800021ca:	a5ffe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800021ce:	4a15                	li	s4,5
        havekids = 1;
    800021d0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021d2:	00013997          	auipc	s3,0x13
    800021d6:	61698993          	addi	s3,s3,1558 # 800157e8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021da:	0000db17          	auipc	s6,0xd
    800021de:	7f6b0b13          	addi	s6,s6,2038 # 8000f9d0 <wait_lock>
    800021e2:	a869                	j	8000227c <kwait+0xd8>
          pid = pp->pid;
    800021e4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021e8:	000b8c63          	beqz	s7,80002200 <kwait+0x5c>
    800021ec:	4691                	li	a3,4
    800021ee:	02c48613          	addi	a2,s1,44
    800021f2:	85de                	mv	a1,s7
    800021f4:	05093503          	ld	a0,80(s2)
    800021f8:	c5cff0ef          	jal	80001654 <copyout>
    800021fc:	02054a63          	bltz	a0,80002230 <kwait+0x8c>
          freeproc(pp);
    80002200:	8526                	mv	a0,s1
    80002202:	901ff0ef          	jal	80001b02 <freeproc>
          release(&pp->lock);
    80002206:	8526                	mv	a0,s1
    80002208:	ab5fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    8000220c:	0000d517          	auipc	a0,0xd
    80002210:	7c450513          	addi	a0,a0,1988 # 8000f9d0 <wait_lock>
    80002214:	aa9fe0ef          	jal	80000cbc <release>
}
    80002218:	854e                	mv	a0,s3
    8000221a:	60a6                	ld	ra,72(sp)
    8000221c:	6406                	ld	s0,64(sp)
    8000221e:	74e2                	ld	s1,56(sp)
    80002220:	7942                	ld	s2,48(sp)
    80002222:	79a2                	ld	s3,40(sp)
    80002224:	7a02                	ld	s4,32(sp)
    80002226:	6ae2                	ld	s5,24(sp)
    80002228:	6b42                	ld	s6,16(sp)
    8000222a:	6ba2                	ld	s7,8(sp)
    8000222c:	6161                	addi	sp,sp,80
    8000222e:	8082                	ret
            release(&pp->lock);
    80002230:	8526                	mv	a0,s1
    80002232:	a8bfe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002236:	0000d517          	auipc	a0,0xd
    8000223a:	79a50513          	addi	a0,a0,1946 # 8000f9d0 <wait_lock>
    8000223e:	a7ffe0ef          	jal	80000cbc <release>
            return -1;
    80002242:	59fd                	li	s3,-1
    80002244:	bfd1                	j	80002218 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002246:	16848493          	addi	s1,s1,360
    8000224a:	03348063          	beq	s1,s3,8000226a <kwait+0xc6>
      if(pp->parent == p){
    8000224e:	7c9c                	ld	a5,56(s1)
    80002250:	ff279be3          	bne	a5,s2,80002246 <kwait+0xa2>
        acquire(&pp->lock);
    80002254:	8526                	mv	a0,s1
    80002256:	9d3fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    8000225a:	4c9c                	lw	a5,24(s1)
    8000225c:	f94784e3          	beq	a5,s4,800021e4 <kwait+0x40>
        release(&pp->lock);
    80002260:	8526                	mv	a0,s1
    80002262:	a5bfe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002266:	8756                	mv	a4,s5
    80002268:	bff9                	j	80002246 <kwait+0xa2>
    if(!havekids || killed(p)){
    8000226a:	cf19                	beqz	a4,80002288 <kwait+0xe4>
    8000226c:	854a                	mv	a0,s2
    8000226e:	f0dff0ef          	jal	8000217a <killed>
    80002272:	e919                	bnez	a0,80002288 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002274:	85da                	mv	a1,s6
    80002276:	854a                	mv	a0,s2
    80002278:	cc7ff0ef          	jal	80001f3e <sleep>
    havekids = 0;
    8000227c:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000227e:	0000e497          	auipc	s1,0xe
    80002282:	b6a48493          	addi	s1,s1,-1174 # 8000fde8 <proc>
    80002286:	b7e1                	j	8000224e <kwait+0xaa>
      release(&wait_lock);
    80002288:	0000d517          	auipc	a0,0xd
    8000228c:	74850513          	addi	a0,a0,1864 # 8000f9d0 <wait_lock>
    80002290:	a2dfe0ef          	jal	80000cbc <release>
      return -1;
    80002294:	59fd                	li	s3,-1
    80002296:	b749                	j	80002218 <kwait+0x74>

0000000080002298 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002298:	7179                	addi	sp,sp,-48
    8000229a:	f406                	sd	ra,40(sp)
    8000229c:	f022                	sd	s0,32(sp)
    8000229e:	ec26                	sd	s1,24(sp)
    800022a0:	e84a                	sd	s2,16(sp)
    800022a2:	e44e                	sd	s3,8(sp)
    800022a4:	e052                	sd	s4,0(sp)
    800022a6:	1800                	addi	s0,sp,48
    800022a8:	84aa                	mv	s1,a0
    800022aa:	8a2e                	mv	s4,a1
    800022ac:	89b2                	mv	s3,a2
    800022ae:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022b0:	e7eff0ef          	jal	8000192e <myproc>
  if(user_dst){
    800022b4:	cc99                	beqz	s1,800022d2 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022b6:	86ca                	mv	a3,s2
    800022b8:	864e                	mv	a2,s3
    800022ba:	85d2                	mv	a1,s4
    800022bc:	6928                	ld	a0,80(a0)
    800022be:	b96ff0ef          	jal	80001654 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022c2:	70a2                	ld	ra,40(sp)
    800022c4:	7402                	ld	s0,32(sp)
    800022c6:	64e2                	ld	s1,24(sp)
    800022c8:	6942                	ld	s2,16(sp)
    800022ca:	69a2                	ld	s3,8(sp)
    800022cc:	6a02                	ld	s4,0(sp)
    800022ce:	6145                	addi	sp,sp,48
    800022d0:	8082                	ret
    memmove((char *)dst, src, len);
    800022d2:	0009061b          	sext.w	a2,s2
    800022d6:	85ce                	mv	a1,s3
    800022d8:	8552                	mv	a0,s4
    800022da:	a7ffe0ef          	jal	80000d58 <memmove>
    return 0;
    800022de:	8526                	mv	a0,s1
    800022e0:	b7cd                	j	800022c2 <either_copyout+0x2a>

00000000800022e2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022e2:	7179                	addi	sp,sp,-48
    800022e4:	f406                	sd	ra,40(sp)
    800022e6:	f022                	sd	s0,32(sp)
    800022e8:	ec26                	sd	s1,24(sp)
    800022ea:	e84a                	sd	s2,16(sp)
    800022ec:	e44e                	sd	s3,8(sp)
    800022ee:	e052                	sd	s4,0(sp)
    800022f0:	1800                	addi	s0,sp,48
    800022f2:	8a2a                	mv	s4,a0
    800022f4:	84ae                	mv	s1,a1
    800022f6:	89b2                	mv	s3,a2
    800022f8:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022fa:	e34ff0ef          	jal	8000192e <myproc>
  if(user_src){
    800022fe:	cc99                	beqz	s1,8000231c <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002300:	86ca                	mv	a3,s2
    80002302:	864e                	mv	a2,s3
    80002304:	85d2                	mv	a1,s4
    80002306:	6928                	ld	a0,80(a0)
    80002308:	c0aff0ef          	jal	80001712 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000230c:	70a2                	ld	ra,40(sp)
    8000230e:	7402                	ld	s0,32(sp)
    80002310:	64e2                	ld	s1,24(sp)
    80002312:	6942                	ld	s2,16(sp)
    80002314:	69a2                	ld	s3,8(sp)
    80002316:	6a02                	ld	s4,0(sp)
    80002318:	6145                	addi	sp,sp,48
    8000231a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000231c:	0009061b          	sext.w	a2,s2
    80002320:	85ce                	mv	a1,s3
    80002322:	8552                	mv	a0,s4
    80002324:	a35fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002328:	8526                	mv	a0,s1
    8000232a:	b7cd                	j	8000230c <either_copyin+0x2a>

000000008000232c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000232c:	715d                	addi	sp,sp,-80
    8000232e:	e486                	sd	ra,72(sp)
    80002330:	e0a2                	sd	s0,64(sp)
    80002332:	fc26                	sd	s1,56(sp)
    80002334:	f84a                	sd	s2,48(sp)
    80002336:	f44e                	sd	s3,40(sp)
    80002338:	f052                	sd	s4,32(sp)
    8000233a:	ec56                	sd	s5,24(sp)
    8000233c:	e85a                	sd	s6,16(sp)
    8000233e:	e45e                	sd	s7,8(sp)
    80002340:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002342:	00005517          	auipc	a0,0x5
    80002346:	d3650513          	addi	a0,a0,-714 # 80007078 <etext+0x78>
    8000234a:	9b0fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000234e:	0000e497          	auipc	s1,0xe
    80002352:	bf248493          	addi	s1,s1,-1038 # 8000ff40 <proc+0x158>
    80002356:	00013917          	auipc	s2,0x13
    8000235a:	5ea90913          	addi	s2,s2,1514 # 80015940 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000235e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002360:	00005997          	auipc	s3,0x5
    80002364:	ea098993          	addi	s3,s3,-352 # 80007200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80002368:	00005a97          	auipc	s5,0x5
    8000236c:	ea0a8a93          	addi	s5,s5,-352 # 80007208 <etext+0x208>
    printf("\n");
    80002370:	00005a17          	auipc	s4,0x5
    80002374:	d08a0a13          	addi	s4,s4,-760 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002378:	00005b97          	auipc	s7,0x5
    8000237c:	3d0b8b93          	addi	s7,s7,976 # 80007748 <states.1>
    80002380:	a829                	j	8000239a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002382:	ed86a583          	lw	a1,-296(a3)
    80002386:	8556                	mv	a0,s5
    80002388:	972fe0ef          	jal	800004fa <printf>
    printf("\n");
    8000238c:	8552                	mv	a0,s4
    8000238e:	96cfe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002392:	16848493          	addi	s1,s1,360
    80002396:	03248263          	beq	s1,s2,800023ba <procdump+0x8e>
    if(p->state == UNUSED)
    8000239a:	86a6                	mv	a3,s1
    8000239c:	ec04a783          	lw	a5,-320(s1)
    800023a0:	dbed                	beqz	a5,80002392 <procdump+0x66>
      state = "???";
    800023a2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023a4:	fcfb6fe3          	bltu	s6,a5,80002382 <procdump+0x56>
    800023a8:	02079713          	slli	a4,a5,0x20
    800023ac:	01d75793          	srli	a5,a4,0x1d
    800023b0:	97de                	add	a5,a5,s7
    800023b2:	6390                	ld	a2,0(a5)
    800023b4:	f679                	bnez	a2,80002382 <procdump+0x56>
      state = "???";
    800023b6:	864e                	mv	a2,s3
    800023b8:	b7e9                	j	80002382 <procdump+0x56>
  }
}
    800023ba:	60a6                	ld	ra,72(sp)
    800023bc:	6406                	ld	s0,64(sp)
    800023be:	74e2                	ld	s1,56(sp)
    800023c0:	7942                	ld	s2,48(sp)
    800023c2:	79a2                	ld	s3,40(sp)
    800023c4:	7a02                	ld	s4,32(sp)
    800023c6:	6ae2                	ld	s5,24(sp)
    800023c8:	6b42                	ld	s6,16(sp)
    800023ca:	6ba2                	ld	s7,8(sp)
    800023cc:	6161                	addi	sp,sp,80
    800023ce:	8082                	ret

00000000800023d0 <ps>:

int
ps(int pid)
{
    800023d0:	715d                	addi	sp,sp,-80
    800023d2:	e486                	sd	ra,72(sp)
    800023d4:	e0a2                	sd	s0,64(sp)
    800023d6:	f052                	sd	s4,32(sp)
    800023d8:	0880                	addi	s0,sp,80
    800023da:	8a2a                	mv	s4,a0
      printf("%d,%s,%s\n", p->pid, state, p->name);
    }
    return 0;
  }
  else {
    for(p = proc; p < &proc[NPROC]; p++){
    800023dc:	0000e697          	auipc	a3,0xe
    800023e0:	a0c68693          	addi	a3,a3,-1524 # 8000fde8 <proc>
    800023e4:	00013617          	auipc	a2,0x13
    800023e8:	40460613          	addi	a2,a2,1028 # 800157e8 <tickslock>
  if(pid == 0)
    800023ec:	e559                	bnez	a0,8000247a <ps+0xaa>
    800023ee:	fc26                	sd	s1,56(sp)
    800023f0:	f84a                	sd	s2,48(sp)
    800023f2:	f44e                	sd	s3,40(sp)
    800023f4:	ec56                	sd	s5,24(sp)
    800023f6:	e85a                	sd	s6,16(sp)
    800023f8:	e45e                	sd	s7,8(sp)
    800023fa:	0000e497          	auipc	s1,0xe
    800023fe:	b4648493          	addi	s1,s1,-1210 # 8000ff40 <proc+0x158>
    80002402:	00013917          	auipc	s2,0x13
    80002406:	53e90913          	addi	s2,s2,1342 # 80015940 <bcache+0x140>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000240a:	4b15                	li	s6,5
        state = "???";
    8000240c:	00005997          	auipc	s3,0x5
    80002410:	df498993          	addi	s3,s3,-524 # 80007200 <etext+0x200>
      printf("%d,%s,%s\n", p->pid, state, p->name);
    80002414:	00005a97          	auipc	s5,0x5
    80002418:	e04a8a93          	addi	s5,s5,-508 # 80007218 <etext+0x218>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000241c:	00005b97          	auipc	s7,0x5
    80002420:	32cb8b93          	addi	s7,s7,812 # 80007748 <states.1>
    80002424:	a811                	j	80002438 <ps+0x68>
      printf("%d,%s,%s\n", p->pid, state, p->name);
    80002426:	ed86a583          	lw	a1,-296(a3)
    8000242a:	8556                	mv	a0,s5
    8000242c:	8cefe0ef          	jal	800004fa <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    80002430:	16848493          	addi	s1,s1,360
    80002434:	03248263          	beq	s1,s2,80002458 <ps+0x88>
      if(p->state == UNUSED)
    80002438:	86a6                	mv	a3,s1
    8000243a:	ec04a783          	lw	a5,-320(s1)
    8000243e:	dbed                	beqz	a5,80002430 <ps+0x60>
        state = "???";
    80002440:	864e                	mv	a2,s3
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002442:	fefb62e3          	bltu	s6,a5,80002426 <ps+0x56>
    80002446:	02079713          	slli	a4,a5,0x20
    8000244a:	01d75793          	srli	a5,a4,0x1d
    8000244e:	97de                	add	a5,a5,s7
    80002450:	7b90                	ld	a2,48(a5)
    80002452:	fa71                	bnez	a2,80002426 <ps+0x56>
        state = "???";
    80002454:	864e                	mv	a2,s3
    80002456:	bfc1                	j	80002426 <ps+0x56>
    return 0;
    80002458:	8552                	mv	a0,s4
    8000245a:	74e2                	ld	s1,56(sp)
    8000245c:	7942                	ld	s2,48(sp)
    8000245e:	79a2                	ld	s3,40(sp)
    80002460:	6ae2                	ld	s5,24(sp)
    80002462:	6b42                	ld	s6,16(sp)
    80002464:	6ba2                	ld	s7,8(sp)
    80002466:	a899                	j	800024bc <ps+0xec>
      if(p->pid == pid)
      {
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
          state = states[p->state];
        else
          state = "???";
    80002468:	00005617          	auipc	a2,0x5
    8000246c:	d9860613          	addi	a2,a2,-616 # 80007200 <etext+0x200>
    80002470:	a825                	j	800024a8 <ps+0xd8>
    for(p = proc; p < &proc[NPROC]; p++){
    80002472:	16868693          	addi	a3,a3,360
    80002476:	04c68863          	beq	a3,a2,800024c6 <ps+0xf6>
      if(p->state == UNUSED)
    8000247a:	4e9c                	lw	a5,24(a3)
    8000247c:	dbfd                	beqz	a5,80002472 <ps+0xa2>
      if(p->pid == pid)
    8000247e:	5a98                	lw	a4,48(a3)
    80002480:	ff4719e3          	bne	a4,s4,80002472 <ps+0xa2>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002484:	4715                	li	a4,5
          state = "???";
    80002486:	00005617          	auipc	a2,0x5
    8000248a:	d7a60613          	addi	a2,a2,-646 # 80007200 <etext+0x200>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000248e:	00f76d63          	bltu	a4,a5,800024a8 <ps+0xd8>
    80002492:	02079713          	slli	a4,a5,0x20
    80002496:	01d75793          	srli	a5,a4,0x1d
    8000249a:	00005717          	auipc	a4,0x5
    8000249e:	2ae70713          	addi	a4,a4,686 # 80007748 <states.1>
    800024a2:	97ba                	add	a5,a5,a4
    800024a4:	7b90                	ld	a2,48(a5)
    800024a6:	d269                	beqz	a2,80002468 <ps+0x98>
        printf("%d,%s,%s\n", p->pid, state, p->name);
    800024a8:	15868693          	addi	a3,a3,344
    800024ac:	85d2                	mv	a1,s4
    800024ae:	00005517          	auipc	a0,0x5
    800024b2:	d6a50513          	addi	a0,a0,-662 # 80007218 <etext+0x218>
    800024b6:	844fe0ef          	jal	800004fa <printf>
        return 0;
    800024ba:	4501                	li	a0,0
      }
    }
    return 1;
  }
    800024bc:	60a6                	ld	ra,72(sp)
    800024be:	6406                	ld	s0,64(sp)
    800024c0:	7a02                	ld	s4,32(sp)
    800024c2:	6161                	addi	sp,sp,80
    800024c4:	8082                	ret
    return 1;
    800024c6:	4505                	li	a0,1
    800024c8:	bfd5                	j	800024bc <ps+0xec>

00000000800024ca <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    800024ca:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800024ce:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800024d2:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800024d4:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800024d6:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800024da:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800024de:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800024e2:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800024e6:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800024ea:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800024ee:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800024f2:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800024f6:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800024fa:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800024fe:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002502:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002506:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002508:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000250a:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000250e:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002512:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002516:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000251a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000251e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002522:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002526:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000252a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000252e:	0685bd83          	ld	s11,104(a1)

        ret
    80002532:	8082                	ret

0000000080002534 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002534:	1141                	addi	sp,sp,-16
    80002536:	e406                	sd	ra,8(sp)
    80002538:	e022                	sd	s0,0(sp)
    8000253a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000253c:	00005597          	auipc	a1,0x5
    80002540:	d2c58593          	addi	a1,a1,-724 # 80007268 <etext+0x268>
    80002544:	00013517          	auipc	a0,0x13
    80002548:	2a450513          	addi	a0,a0,676 # 800157e8 <tickslock>
    8000254c:	e52fe0ef          	jal	80000b9e <initlock>
}
    80002550:	60a2                	ld	ra,8(sp)
    80002552:	6402                	ld	s0,0(sp)
    80002554:	0141                	addi	sp,sp,16
    80002556:	8082                	ret

0000000080002558 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002558:	1141                	addi	sp,sp,-16
    8000255a:	e406                	sd	ra,8(sp)
    8000255c:	e022                	sd	s0,0(sp)
    8000255e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002560:	00003797          	auipc	a5,0x3
    80002564:	fc078793          	addi	a5,a5,-64 # 80005520 <kernelvec>
    80002568:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000256c:	60a2                	ld	ra,8(sp)
    8000256e:	6402                	ld	s0,0(sp)
    80002570:	0141                	addi	sp,sp,16
    80002572:	8082                	ret

0000000080002574 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002574:	1141                	addi	sp,sp,-16
    80002576:	e406                	sd	ra,8(sp)
    80002578:	e022                	sd	s0,0(sp)
    8000257a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000257c:	bb2ff0ef          	jal	8000192e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002580:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002584:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002586:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000258a:	04000737          	lui	a4,0x4000
    8000258e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002590:	0732                	slli	a4,a4,0xc
    80002592:	00004797          	auipc	a5,0x4
    80002596:	a6e78793          	addi	a5,a5,-1426 # 80006000 <_trampoline>
    8000259a:	00004697          	auipc	a3,0x4
    8000259e:	a6668693          	addi	a3,a3,-1434 # 80006000 <_trampoline>
    800025a2:	8f95                	sub	a5,a5,a3
    800025a4:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025a6:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025aa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025ac:	18002773          	csrr	a4,satp
    800025b0:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025b2:	6d38                	ld	a4,88(a0)
    800025b4:	613c                	ld	a5,64(a0)
    800025b6:	6685                	lui	a3,0x1
    800025b8:	97b6                	add	a5,a5,a3
    800025ba:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025bc:	6d3c                	ld	a5,88(a0)
    800025be:	00000717          	auipc	a4,0x0
    800025c2:	0fc70713          	addi	a4,a4,252 # 800026ba <usertrap>
    800025c6:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025c8:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025ca:	8712                	mv	a4,tp
    800025cc:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025ce:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025d2:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025d6:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025da:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025de:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025e0:	6f9c                	ld	a5,24(a5)
    800025e2:	14179073          	csrw	sepc,a5
}
    800025e6:	60a2                	ld	ra,8(sp)
    800025e8:	6402                	ld	s0,0(sp)
    800025ea:	0141                	addi	sp,sp,16
    800025ec:	8082                	ret

00000000800025ee <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800025ee:	1141                	addi	sp,sp,-16
    800025f0:	e406                	sd	ra,8(sp)
    800025f2:	e022                	sd	s0,0(sp)
    800025f4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800025f6:	b04ff0ef          	jal	800018fa <cpuid>
    800025fa:	cd11                	beqz	a0,80002616 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800025fc:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002600:	000f4737          	lui	a4,0xf4
    80002604:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002608:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000260a:	14d79073          	csrw	stimecmp,a5
}
    8000260e:	60a2                	ld	ra,8(sp)
    80002610:	6402                	ld	s0,0(sp)
    80002612:	0141                	addi	sp,sp,16
    80002614:	8082                	ret
    acquire(&tickslock);
    80002616:	00013517          	auipc	a0,0x13
    8000261a:	1d250513          	addi	a0,a0,466 # 800157e8 <tickslock>
    8000261e:	e0afe0ef          	jal	80000c28 <acquire>
    ticks++;
    80002622:	00005717          	auipc	a4,0x5
    80002626:	29670713          	addi	a4,a4,662 # 800078b8 <ticks>
    8000262a:	431c                	lw	a5,0(a4)
    8000262c:	2785                	addiw	a5,a5,1
    8000262e:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002630:	853a                	mv	a0,a4
    80002632:	959ff0ef          	jal	80001f8a <wakeup>
    release(&tickslock);
    80002636:	00013517          	auipc	a0,0x13
    8000263a:	1b250513          	addi	a0,a0,434 # 800157e8 <tickslock>
    8000263e:	e7efe0ef          	jal	80000cbc <release>
    80002642:	bf6d                	j	800025fc <clockintr+0xe>

0000000080002644 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002644:	1101                	addi	sp,sp,-32
    80002646:	ec06                	sd	ra,24(sp)
    80002648:	e822                	sd	s0,16(sp)
    8000264a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000264c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002650:	57fd                	li	a5,-1
    80002652:	17fe                	slli	a5,a5,0x3f
    80002654:	07a5                	addi	a5,a5,9
    80002656:	00f70c63          	beq	a4,a5,8000266e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000265a:	57fd                	li	a5,-1
    8000265c:	17fe                	slli	a5,a5,0x3f
    8000265e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002660:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002662:	04f70863          	beq	a4,a5,800026b2 <devintr+0x6e>
  }
}
    80002666:	60e2                	ld	ra,24(sp)
    80002668:	6442                	ld	s0,16(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    8000266e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002670:	75d020ef          	jal	800055cc <plic_claim>
    80002674:	872a                	mv	a4,a0
    80002676:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002678:	47a9                	li	a5,10
    8000267a:	00f50963          	beq	a0,a5,8000268c <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    8000267e:	4785                	li	a5,1
    80002680:	00f50963          	beq	a0,a5,80002692 <devintr+0x4e>
    return 1;
    80002684:	4505                	li	a0,1
    } else if(irq){
    80002686:	eb09                	bnez	a4,80002698 <devintr+0x54>
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	bff1                	j	80002666 <devintr+0x22>
      uartintr();
    8000268c:	b68fe0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002690:	a819                	j	800026a6 <devintr+0x62>
      virtio_disk_intr();
    80002692:	3d0030ef          	jal	80005a62 <virtio_disk_intr>
    if(irq)
    80002696:	a801                	j	800026a6 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002698:	85ba                	mv	a1,a4
    8000269a:	00005517          	auipc	a0,0x5
    8000269e:	bd650513          	addi	a0,a0,-1066 # 80007270 <etext+0x270>
    800026a2:	e59fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    800026a6:	8526                	mv	a0,s1
    800026a8:	745020ef          	jal	800055ec <plic_complete>
    return 1;
    800026ac:	4505                	li	a0,1
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	bf5d                	j	80002666 <devintr+0x22>
    clockintr();
    800026b2:	f3dff0ef          	jal	800025ee <clockintr>
    return 2;
    800026b6:	4509                	li	a0,2
    800026b8:	b77d                	j	80002666 <devintr+0x22>

00000000800026ba <usertrap>:
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	e04a                	sd	s2,0(sp)
    800026c4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800026ca:	1007f793          	andi	a5,a5,256
    800026ce:	eba5                	bnez	a5,8000273e <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026d0:	00003797          	auipc	a5,0x3
    800026d4:	e5078793          	addi	a5,a5,-432 # 80005520 <kernelvec>
    800026d8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800026dc:	a52ff0ef          	jal	8000192e <myproc>
    800026e0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800026e2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026e4:	14102773          	csrr	a4,sepc
    800026e8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026ea:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800026ee:	47a1                	li	a5,8
    800026f0:	04f70d63          	beq	a4,a5,8000274a <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800026f4:	f51ff0ef          	jal	80002644 <devintr>
    800026f8:	892a                	mv	s2,a0
    800026fa:	e945                	bnez	a0,800027aa <usertrap+0xf0>
    800026fc:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002700:	47bd                	li	a5,15
    80002702:	08f70863          	beq	a4,a5,80002792 <usertrap+0xd8>
    80002706:	14202773          	csrr	a4,scause
    8000270a:	47b5                	li	a5,13
    8000270c:	08f70363          	beq	a4,a5,80002792 <usertrap+0xd8>
    80002710:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002714:	5890                	lw	a2,48(s1)
    80002716:	00005517          	auipc	a0,0x5
    8000271a:	b9a50513          	addi	a0,a0,-1126 # 800072b0 <etext+0x2b0>
    8000271e:	dddfd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002722:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002726:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000272a:	00005517          	auipc	a0,0x5
    8000272e:	bb650513          	addi	a0,a0,-1098 # 800072e0 <etext+0x2e0>
    80002732:	dc9fd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002736:	8526                	mv	a0,s1
    80002738:	a1fff0ef          	jal	80002156 <setkilled>
    8000273c:	a035                	j	80002768 <usertrap+0xae>
    panic("usertrap: not from user mode");
    8000273e:	00005517          	auipc	a0,0x5
    80002742:	b5250513          	addi	a0,a0,-1198 # 80007290 <etext+0x290>
    80002746:	8defe0ef          	jal	80000824 <panic>
    if(killed(p))
    8000274a:	a31ff0ef          	jal	8000217a <killed>
    8000274e:	ed15                	bnez	a0,8000278a <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002750:	6cb8                	ld	a4,88(s1)
    80002752:	6f1c                	ld	a5,24(a4)
    80002754:	0791                	addi	a5,a5,4
    80002756:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002758:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000275c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002760:	10079073          	csrw	sstatus,a5
    syscall();
    80002764:	240000ef          	jal	800029a4 <syscall>
  if(killed(p))
    80002768:	8526                	mv	a0,s1
    8000276a:	a11ff0ef          	jal	8000217a <killed>
    8000276e:	e139                	bnez	a0,800027b4 <usertrap+0xfa>
  prepare_return();
    80002770:	e05ff0ef          	jal	80002574 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002774:	68a8                	ld	a0,80(s1)
    80002776:	8131                	srli	a0,a0,0xc
    80002778:	57fd                	li	a5,-1
    8000277a:	17fe                	slli	a5,a5,0x3f
    8000277c:	8d5d                	or	a0,a0,a5
}
    8000277e:	60e2                	ld	ra,24(sp)
    80002780:	6442                	ld	s0,16(sp)
    80002782:	64a2                	ld	s1,8(sp)
    80002784:	6902                	ld	s2,0(sp)
    80002786:	6105                	addi	sp,sp,32
    80002788:	8082                	ret
      kexit(-1);
    8000278a:	557d                	li	a0,-1
    8000278c:	8bfff0ef          	jal	8000204a <kexit>
    80002790:	b7c1                	j	80002750 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002792:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002796:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    8000279a:	164d                	addi	a2,a2,-13
    8000279c:	00163613          	seqz	a2,a2
    800027a0:	68a8                	ld	a0,80(s1)
    800027a2:	e2ffe0ef          	jal	800015d0 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800027a6:	f169                	bnez	a0,80002768 <usertrap+0xae>
    800027a8:	b7a5                	j	80002710 <usertrap+0x56>
  if(killed(p))
    800027aa:	8526                	mv	a0,s1
    800027ac:	9cfff0ef          	jal	8000217a <killed>
    800027b0:	c511                	beqz	a0,800027bc <usertrap+0x102>
    800027b2:	a011                	j	800027b6 <usertrap+0xfc>
    800027b4:	4901                	li	s2,0
    kexit(-1);
    800027b6:	557d                	li	a0,-1
    800027b8:	893ff0ef          	jal	8000204a <kexit>
  if(which_dev == 2)
    800027bc:	4789                	li	a5,2
    800027be:	faf919e3          	bne	s2,a5,80002770 <usertrap+0xb6>
    yield();
    800027c2:	f50ff0ef          	jal	80001f12 <yield>
    800027c6:	b76d                	j	80002770 <usertrap+0xb6>

00000000800027c8 <kerneltrap>:
{
    800027c8:	7179                	addi	sp,sp,-48
    800027ca:	f406                	sd	ra,40(sp)
    800027cc:	f022                	sd	s0,32(sp)
    800027ce:	ec26                	sd	s1,24(sp)
    800027d0:	e84a                	sd	s2,16(sp)
    800027d2:	e44e                	sd	s3,8(sp)
    800027d4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027d6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027da:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027de:	142027f3          	csrr	a5,scause
    800027e2:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800027e4:	1004f793          	andi	a5,s1,256
    800027e8:	c795                	beqz	a5,80002814 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027ee:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800027f0:	eb85                	bnez	a5,80002820 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    800027f2:	e53ff0ef          	jal	80002644 <devintr>
    800027f6:	c91d                	beqz	a0,8000282c <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    800027f8:	4789                	li	a5,2
    800027fa:	04f50a63          	beq	a0,a5,8000284e <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027fe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002802:	10049073          	csrw	sstatus,s1
}
    80002806:	70a2                	ld	ra,40(sp)
    80002808:	7402                	ld	s0,32(sp)
    8000280a:	64e2                	ld	s1,24(sp)
    8000280c:	6942                	ld	s2,16(sp)
    8000280e:	69a2                	ld	s3,8(sp)
    80002810:	6145                	addi	sp,sp,48
    80002812:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002814:	00005517          	auipc	a0,0x5
    80002818:	af450513          	addi	a0,a0,-1292 # 80007308 <etext+0x308>
    8000281c:	808fe0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002820:	00005517          	auipc	a0,0x5
    80002824:	b1050513          	addi	a0,a0,-1264 # 80007330 <etext+0x330>
    80002828:	ffdfd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000282c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002830:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002834:	85ce                	mv	a1,s3
    80002836:	00005517          	auipc	a0,0x5
    8000283a:	b1a50513          	addi	a0,a0,-1254 # 80007350 <etext+0x350>
    8000283e:	cbdfd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002842:	00005517          	auipc	a0,0x5
    80002846:	b3650513          	addi	a0,a0,-1226 # 80007378 <etext+0x378>
    8000284a:	fdbfd0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000284e:	8e0ff0ef          	jal	8000192e <myproc>
    80002852:	d555                	beqz	a0,800027fe <kerneltrap+0x36>
    yield();
    80002854:	ebeff0ef          	jal	80001f12 <yield>
    80002858:	b75d                	j	800027fe <kerneltrap+0x36>

000000008000285a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000285a:	1101                	addi	sp,sp,-32
    8000285c:	ec06                	sd	ra,24(sp)
    8000285e:	e822                	sd	s0,16(sp)
    80002860:	e426                	sd	s1,8(sp)
    80002862:	1000                	addi	s0,sp,32
    80002864:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002866:	8c8ff0ef          	jal	8000192e <myproc>
  switch (n) {
    8000286a:	4795                	li	a5,5
    8000286c:	0497e163          	bltu	a5,s1,800028ae <argraw+0x54>
    80002870:	048a                	slli	s1,s1,0x2
    80002872:	00005717          	auipc	a4,0x5
    80002876:	f3670713          	addi	a4,a4,-202 # 800077a8 <states.0+0x30>
    8000287a:	94ba                	add	s1,s1,a4
    8000287c:	409c                	lw	a5,0(s1)
    8000287e:	97ba                	add	a5,a5,a4
    80002880:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002882:	6d3c                	ld	a5,88(a0)
    80002884:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002886:	60e2                	ld	ra,24(sp)
    80002888:	6442                	ld	s0,16(sp)
    8000288a:	64a2                	ld	s1,8(sp)
    8000288c:	6105                	addi	sp,sp,32
    8000288e:	8082                	ret
    return p->trapframe->a1;
    80002890:	6d3c                	ld	a5,88(a0)
    80002892:	7fa8                	ld	a0,120(a5)
    80002894:	bfcd                	j	80002886 <argraw+0x2c>
    return p->trapframe->a2;
    80002896:	6d3c                	ld	a5,88(a0)
    80002898:	63c8                	ld	a0,128(a5)
    8000289a:	b7f5                	j	80002886 <argraw+0x2c>
    return p->trapframe->a3;
    8000289c:	6d3c                	ld	a5,88(a0)
    8000289e:	67c8                	ld	a0,136(a5)
    800028a0:	b7dd                	j	80002886 <argraw+0x2c>
    return p->trapframe->a4;
    800028a2:	6d3c                	ld	a5,88(a0)
    800028a4:	6bc8                	ld	a0,144(a5)
    800028a6:	b7c5                	j	80002886 <argraw+0x2c>
    return p->trapframe->a5;
    800028a8:	6d3c                	ld	a5,88(a0)
    800028aa:	6fc8                	ld	a0,152(a5)
    800028ac:	bfe9                	j	80002886 <argraw+0x2c>
  panic("argraw");
    800028ae:	00005517          	auipc	a0,0x5
    800028b2:	ada50513          	addi	a0,a0,-1318 # 80007388 <etext+0x388>
    800028b6:	f6ffd0ef          	jal	80000824 <panic>

00000000800028ba <fetchaddr>:
{
    800028ba:	1101                	addi	sp,sp,-32
    800028bc:	ec06                	sd	ra,24(sp)
    800028be:	e822                	sd	s0,16(sp)
    800028c0:	e426                	sd	s1,8(sp)
    800028c2:	e04a                	sd	s2,0(sp)
    800028c4:	1000                	addi	s0,sp,32
    800028c6:	84aa                	mv	s1,a0
    800028c8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028ca:	864ff0ef          	jal	8000192e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028ce:	653c                	ld	a5,72(a0)
    800028d0:	02f4f663          	bgeu	s1,a5,800028fc <fetchaddr+0x42>
    800028d4:	00848713          	addi	a4,s1,8
    800028d8:	02e7e463          	bltu	a5,a4,80002900 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800028dc:	46a1                	li	a3,8
    800028de:	8626                	mv	a2,s1
    800028e0:	85ca                	mv	a1,s2
    800028e2:	6928                	ld	a0,80(a0)
    800028e4:	e2ffe0ef          	jal	80001712 <copyin>
    800028e8:	00a03533          	snez	a0,a0
    800028ec:	40a0053b          	negw	a0,a0
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret
    return -1;
    800028fc:	557d                	li	a0,-1
    800028fe:	bfcd                	j	800028f0 <fetchaddr+0x36>
    80002900:	557d                	li	a0,-1
    80002902:	b7fd                	j	800028f0 <fetchaddr+0x36>

0000000080002904 <fetchstr>:
{
    80002904:	7179                	addi	sp,sp,-48
    80002906:	f406                	sd	ra,40(sp)
    80002908:	f022                	sd	s0,32(sp)
    8000290a:	ec26                	sd	s1,24(sp)
    8000290c:	e84a                	sd	s2,16(sp)
    8000290e:	e44e                	sd	s3,8(sp)
    80002910:	1800                	addi	s0,sp,48
    80002912:	89aa                	mv	s3,a0
    80002914:	84ae                	mv	s1,a1
    80002916:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002918:	816ff0ef          	jal	8000192e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000291c:	86ca                	mv	a3,s2
    8000291e:	864e                	mv	a2,s3
    80002920:	85a6                	mv	a1,s1
    80002922:	6928                	ld	a0,80(a0)
    80002924:	bd5fe0ef          	jal	800014f8 <copyinstr>
    80002928:	00054c63          	bltz	a0,80002940 <fetchstr+0x3c>
  return strlen(buf);
    8000292c:	8526                	mv	a0,s1
    8000292e:	d54fe0ef          	jal	80000e82 <strlen>
}
    80002932:	70a2                	ld	ra,40(sp)
    80002934:	7402                	ld	s0,32(sp)
    80002936:	64e2                	ld	s1,24(sp)
    80002938:	6942                	ld	s2,16(sp)
    8000293a:	69a2                	ld	s3,8(sp)
    8000293c:	6145                	addi	sp,sp,48
    8000293e:	8082                	ret
    return -1;
    80002940:	557d                	li	a0,-1
    80002942:	bfc5                	j	80002932 <fetchstr+0x2e>

0000000080002944 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002944:	1101                	addi	sp,sp,-32
    80002946:	ec06                	sd	ra,24(sp)
    80002948:	e822                	sd	s0,16(sp)
    8000294a:	e426                	sd	s1,8(sp)
    8000294c:	1000                	addi	s0,sp,32
    8000294e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002950:	f0bff0ef          	jal	8000285a <argraw>
    80002954:	c088                	sw	a0,0(s1)
}
    80002956:	60e2                	ld	ra,24(sp)
    80002958:	6442                	ld	s0,16(sp)
    8000295a:	64a2                	ld	s1,8(sp)
    8000295c:	6105                	addi	sp,sp,32
    8000295e:	8082                	ret

0000000080002960 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002960:	1101                	addi	sp,sp,-32
    80002962:	ec06                	sd	ra,24(sp)
    80002964:	e822                	sd	s0,16(sp)
    80002966:	e426                	sd	s1,8(sp)
    80002968:	1000                	addi	s0,sp,32
    8000296a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000296c:	eefff0ef          	jal	8000285a <argraw>
    80002970:	e088                	sd	a0,0(s1)
}
    80002972:	60e2                	ld	ra,24(sp)
    80002974:	6442                	ld	s0,16(sp)
    80002976:	64a2                	ld	s1,8(sp)
    80002978:	6105                	addi	sp,sp,32
    8000297a:	8082                	ret

000000008000297c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000297c:	1101                	addi	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	e426                	sd	s1,8(sp)
    80002984:	e04a                	sd	s2,0(sp)
    80002986:	1000                	addi	s0,sp,32
    80002988:	892e                	mv	s2,a1
    8000298a:	84b2                	mv	s1,a2
  *ip = argraw(n);
    8000298c:	ecfff0ef          	jal	8000285a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002990:	8626                	mv	a2,s1
    80002992:	85ca                	mv	a1,s2
    80002994:	f71ff0ef          	jal	80002904 <fetchstr>
}
    80002998:	60e2                	ld	ra,24(sp)
    8000299a:	6442                	ld	s0,16(sp)
    8000299c:	64a2                	ld	s1,8(sp)
    8000299e:	6902                	ld	s2,0(sp)
    800029a0:	6105                	addi	sp,sp,32
    800029a2:	8082                	ret

00000000800029a4 <syscall>:
[SYS_ps]      sys_ps,
};

void
syscall(void)
{
    800029a4:	1101                	addi	sp,sp,-32
    800029a6:	ec06                	sd	ra,24(sp)
    800029a8:	e822                	sd	s0,16(sp)
    800029aa:	e426                	sd	s1,8(sp)
    800029ac:	e04a                	sd	s2,0(sp)
    800029ae:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800029b0:	f7ffe0ef          	jal	8000192e <myproc>
    800029b4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800029b6:	05853903          	ld	s2,88(a0)
    800029ba:	0a893783          	ld	a5,168(s2)
    800029be:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029c2:	37fd                	addiw	a5,a5,-1
    800029c4:	4755                	li	a4,21
    800029c6:	00f76f63          	bltu	a4,a5,800029e4 <syscall+0x40>
    800029ca:	00369713          	slli	a4,a3,0x3
    800029ce:	00005797          	auipc	a5,0x5
    800029d2:	df278793          	addi	a5,a5,-526 # 800077c0 <syscalls>
    800029d6:	97ba                	add	a5,a5,a4
    800029d8:	639c                	ld	a5,0(a5)
    800029da:	c789                	beqz	a5,800029e4 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029dc:	9782                	jalr	a5
    800029de:	06a93823          	sd	a0,112(s2)
    800029e2:	a829                	j	800029fc <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029e4:	15848613          	addi	a2,s1,344
    800029e8:	588c                	lw	a1,48(s1)
    800029ea:	00005517          	auipc	a0,0x5
    800029ee:	9a650513          	addi	a0,a0,-1626 # 80007390 <etext+0x390>
    800029f2:	b09fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800029f6:	6cbc                	ld	a5,88(s1)
    800029f8:	577d                	li	a4,-1
    800029fa:	fbb8                	sd	a4,112(a5)
  }
}
    800029fc:	60e2                	ld	ra,24(sp)
    800029fe:	6442                	ld	s0,16(sp)
    80002a00:	64a2                	ld	s1,8(sp)
    80002a02:	6902                	ld	s2,0(sp)
    80002a04:	6105                	addi	sp,sp,32
    80002a06:	8082                	ret

0000000080002a08 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002a08:	1101                	addi	sp,sp,-32
    80002a0a:	ec06                	sd	ra,24(sp)
    80002a0c:	e822                	sd	s0,16(sp)
    80002a0e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a10:	fec40593          	addi	a1,s0,-20
    80002a14:	4501                	li	a0,0
    80002a16:	f2fff0ef          	jal	80002944 <argint>
  kexit(n);
    80002a1a:	fec42503          	lw	a0,-20(s0)
    80002a1e:	e2cff0ef          	jal	8000204a <kexit>
  return 0;  // not reached
}
    80002a22:	4501                	li	a0,0
    80002a24:	60e2                	ld	ra,24(sp)
    80002a26:	6442                	ld	s0,16(sp)
    80002a28:	6105                	addi	sp,sp,32
    80002a2a:	8082                	ret

0000000080002a2c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a2c:	1141                	addi	sp,sp,-16
    80002a2e:	e406                	sd	ra,8(sp)
    80002a30:	e022                	sd	s0,0(sp)
    80002a32:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a34:	efbfe0ef          	jal	8000192e <myproc>
}
    80002a38:	5908                	lw	a0,48(a0)
    80002a3a:	60a2                	ld	ra,8(sp)
    80002a3c:	6402                	ld	s0,0(sp)
    80002a3e:	0141                	addi	sp,sp,16
    80002a40:	8082                	ret

0000000080002a42 <sys_fork>:

uint64
sys_fork(void)
{
    80002a42:	1141                	addi	sp,sp,-16
    80002a44:	e406                	sd	ra,8(sp)
    80002a46:	e022                	sd	s0,0(sp)
    80002a48:	0800                	addi	s0,sp,16
  return kfork();
    80002a4a:	a4cff0ef          	jal	80001c96 <kfork>
}
    80002a4e:	60a2                	ld	ra,8(sp)
    80002a50:	6402                	ld	s0,0(sp)
    80002a52:	0141                	addi	sp,sp,16
    80002a54:	8082                	ret

0000000080002a56 <sys_wait>:

uint64
sys_wait(void)
{
    80002a56:	1101                	addi	sp,sp,-32
    80002a58:	ec06                	sd	ra,24(sp)
    80002a5a:	e822                	sd	s0,16(sp)
    80002a5c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a5e:	fe840593          	addi	a1,s0,-24
    80002a62:	4501                	li	a0,0
    80002a64:	efdff0ef          	jal	80002960 <argaddr>
  return kwait(p);
    80002a68:	fe843503          	ld	a0,-24(s0)
    80002a6c:	f38ff0ef          	jal	800021a4 <kwait>
}
    80002a70:	60e2                	ld	ra,24(sp)
    80002a72:	6442                	ld	s0,16(sp)
    80002a74:	6105                	addi	sp,sp,32
    80002a76:	8082                	ret

0000000080002a78 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a78:	7179                	addi	sp,sp,-48
    80002a7a:	f406                	sd	ra,40(sp)
    80002a7c:	f022                	sd	s0,32(sp)
    80002a7e:	ec26                	sd	s1,24(sp)
    80002a80:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002a82:	fd840593          	addi	a1,s0,-40
    80002a86:	4501                	li	a0,0
    80002a88:	ebdff0ef          	jal	80002944 <argint>
  argint(1, &t);
    80002a8c:	fdc40593          	addi	a1,s0,-36
    80002a90:	4505                	li	a0,1
    80002a92:	eb3ff0ef          	jal	80002944 <argint>
  addr = myproc()->sz;
    80002a96:	e99fe0ef          	jal	8000192e <myproc>
    80002a9a:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002a9c:	fdc42703          	lw	a4,-36(s0)
    80002aa0:	4785                	li	a5,1
    80002aa2:	02f70763          	beq	a4,a5,80002ad0 <sys_sbrk+0x58>
    80002aa6:	fd842783          	lw	a5,-40(s0)
    80002aaa:	0207c363          	bltz	a5,80002ad0 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002aae:	97a6                	add	a5,a5,s1
      return -1;
    if(addr + n > TRAPFRAME)
    80002ab0:	02000737          	lui	a4,0x2000
    80002ab4:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002ab6:	0736                	slli	a4,a4,0xd
    80002ab8:	02f76a63          	bltu	a4,a5,80002aec <sys_sbrk+0x74>
    80002abc:	0297e863          	bltu	a5,s1,80002aec <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80002ac0:	e6ffe0ef          	jal	8000192e <myproc>
    80002ac4:	fd842703          	lw	a4,-40(s0)
    80002ac8:	653c                	ld	a5,72(a0)
    80002aca:	97ba                	add	a5,a5,a4
    80002acc:	e53c                	sd	a5,72(a0)
    80002ace:	a039                	j	80002adc <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002ad0:	fd842503          	lw	a0,-40(s0)
    80002ad4:	960ff0ef          	jal	80001c34 <growproc>
    80002ad8:	00054863          	bltz	a0,80002ae8 <sys_sbrk+0x70>
  }
  return addr;
}
    80002adc:	8526                	mv	a0,s1
    80002ade:	70a2                	ld	ra,40(sp)
    80002ae0:	7402                	ld	s0,32(sp)
    80002ae2:	64e2                	ld	s1,24(sp)
    80002ae4:	6145                	addi	sp,sp,48
    80002ae6:	8082                	ret
      return -1;
    80002ae8:	54fd                	li	s1,-1
    80002aea:	bfcd                	j	80002adc <sys_sbrk+0x64>
      return -1;
    80002aec:	54fd                	li	s1,-1
    80002aee:	b7fd                	j	80002adc <sys_sbrk+0x64>

0000000080002af0 <sys_pause>:

uint64
sys_pause(void)
{
    80002af0:	7139                	addi	sp,sp,-64
    80002af2:	fc06                	sd	ra,56(sp)
    80002af4:	f822                	sd	s0,48(sp)
    80002af6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002af8:	fcc40593          	addi	a1,s0,-52
    80002afc:	4501                	li	a0,0
    80002afe:	e47ff0ef          	jal	80002944 <argint>
  if(n < 0)
    80002b02:	fcc42783          	lw	a5,-52(s0)
    80002b06:	0607c863          	bltz	a5,80002b76 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002b0a:	00013517          	auipc	a0,0x13
    80002b0e:	cde50513          	addi	a0,a0,-802 # 800157e8 <tickslock>
    80002b12:	916fe0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002b16:	fcc42783          	lw	a5,-52(s0)
    80002b1a:	c3b9                	beqz	a5,80002b60 <sys_pause+0x70>
    80002b1c:	f426                	sd	s1,40(sp)
    80002b1e:	f04a                	sd	s2,32(sp)
    80002b20:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002b22:	00005997          	auipc	s3,0x5
    80002b26:	d969a983          	lw	s3,-618(s3) # 800078b8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b2a:	00013917          	auipc	s2,0x13
    80002b2e:	cbe90913          	addi	s2,s2,-834 # 800157e8 <tickslock>
    80002b32:	00005497          	auipc	s1,0x5
    80002b36:	d8648493          	addi	s1,s1,-634 # 800078b8 <ticks>
    if(killed(myproc())){
    80002b3a:	df5fe0ef          	jal	8000192e <myproc>
    80002b3e:	e3cff0ef          	jal	8000217a <killed>
    80002b42:	ed0d                	bnez	a0,80002b7c <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002b44:	85ca                	mv	a1,s2
    80002b46:	8526                	mv	a0,s1
    80002b48:	bf6ff0ef          	jal	80001f3e <sleep>
  while(ticks - ticks0 < n){
    80002b4c:	409c                	lw	a5,0(s1)
    80002b4e:	413787bb          	subw	a5,a5,s3
    80002b52:	fcc42703          	lw	a4,-52(s0)
    80002b56:	fee7e2e3          	bltu	a5,a4,80002b3a <sys_pause+0x4a>
    80002b5a:	74a2                	ld	s1,40(sp)
    80002b5c:	7902                	ld	s2,32(sp)
    80002b5e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b60:	00013517          	auipc	a0,0x13
    80002b64:	c8850513          	addi	a0,a0,-888 # 800157e8 <tickslock>
    80002b68:	954fe0ef          	jal	80000cbc <release>
  return 0;
    80002b6c:	4501                	li	a0,0
}
    80002b6e:	70e2                	ld	ra,56(sp)
    80002b70:	7442                	ld	s0,48(sp)
    80002b72:	6121                	addi	sp,sp,64
    80002b74:	8082                	ret
    n = 0;
    80002b76:	fc042623          	sw	zero,-52(s0)
    80002b7a:	bf41                	j	80002b0a <sys_pause+0x1a>
      release(&tickslock);
    80002b7c:	00013517          	auipc	a0,0x13
    80002b80:	c6c50513          	addi	a0,a0,-916 # 800157e8 <tickslock>
    80002b84:	938fe0ef          	jal	80000cbc <release>
      return -1;
    80002b88:	557d                	li	a0,-1
    80002b8a:	74a2                	ld	s1,40(sp)
    80002b8c:	7902                	ld	s2,32(sp)
    80002b8e:	69e2                	ld	s3,24(sp)
    80002b90:	bff9                	j	80002b6e <sys_pause+0x7e>

0000000080002b92 <sys_kill>:

uint64
sys_kill(void)
{
    80002b92:	1101                	addi	sp,sp,-32
    80002b94:	ec06                	sd	ra,24(sp)
    80002b96:	e822                	sd	s0,16(sp)
    80002b98:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b9a:	fec40593          	addi	a1,s0,-20
    80002b9e:	4501                	li	a0,0
    80002ba0:	da5ff0ef          	jal	80002944 <argint>
  return kkill(pid);
    80002ba4:	fec42503          	lw	a0,-20(s0)
    80002ba8:	d48ff0ef          	jal	800020f0 <kkill>
}
    80002bac:	60e2                	ld	ra,24(sp)
    80002bae:	6442                	ld	s0,16(sp)
    80002bb0:	6105                	addi	sp,sp,32
    80002bb2:	8082                	ret

0000000080002bb4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002bb4:	1101                	addi	sp,sp,-32
    80002bb6:	ec06                	sd	ra,24(sp)
    80002bb8:	e822                	sd	s0,16(sp)
    80002bba:	e426                	sd	s1,8(sp)
    80002bbc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002bbe:	00013517          	auipc	a0,0x13
    80002bc2:	c2a50513          	addi	a0,a0,-982 # 800157e8 <tickslock>
    80002bc6:	862fe0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80002bca:	00005797          	auipc	a5,0x5
    80002bce:	cee7a783          	lw	a5,-786(a5) # 800078b8 <ticks>
    80002bd2:	84be                	mv	s1,a5
  release(&tickslock);
    80002bd4:	00013517          	auipc	a0,0x13
    80002bd8:	c1450513          	addi	a0,a0,-1004 # 800157e8 <tickslock>
    80002bdc:	8e0fe0ef          	jal	80000cbc <release>
  return xticks;
}
    80002be0:	02049513          	slli	a0,s1,0x20
    80002be4:	9101                	srli	a0,a0,0x20
    80002be6:	60e2                	ld	ra,24(sp)
    80002be8:	6442                	ld	s0,16(sp)
    80002bea:	64a2                	ld	s1,8(sp)
    80002bec:	6105                	addi	sp,sp,32
    80002bee:	8082                	ret

0000000080002bf0 <sys_ps>:

uint64
sys_ps(void)
{
    80002bf0:	1101                	addi	sp,sp,-32
    80002bf2:	ec06                	sd	ra,24(sp)
    80002bf4:	e822                	sd	s0,16(sp)
    80002bf6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002bf8:	fec40593          	addi	a1,s0,-20
    80002bfc:	4501                	li	a0,0
    80002bfe:	d47ff0ef          	jal	80002944 <argint>
  return ps(pid);
    80002c02:	fec42503          	lw	a0,-20(s0)
    80002c06:	fcaff0ef          	jal	800023d0 <ps>
    80002c0a:	60e2                	ld	ra,24(sp)
    80002c0c:	6442                	ld	s0,16(sp)
    80002c0e:	6105                	addi	sp,sp,32
    80002c10:	8082                	ret

0000000080002c12 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c12:	7179                	addi	sp,sp,-48
    80002c14:	f406                	sd	ra,40(sp)
    80002c16:	f022                	sd	s0,32(sp)
    80002c18:	ec26                	sd	s1,24(sp)
    80002c1a:	e84a                	sd	s2,16(sp)
    80002c1c:	e44e                	sd	s3,8(sp)
    80002c1e:	e052                	sd	s4,0(sp)
    80002c20:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c22:	00004597          	auipc	a1,0x4
    80002c26:	78e58593          	addi	a1,a1,1934 # 800073b0 <etext+0x3b0>
    80002c2a:	00013517          	auipc	a0,0x13
    80002c2e:	bd650513          	addi	a0,a0,-1066 # 80015800 <bcache>
    80002c32:	f6dfd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c36:	0001b797          	auipc	a5,0x1b
    80002c3a:	bca78793          	addi	a5,a5,-1078 # 8001d800 <bcache+0x8000>
    80002c3e:	0001b717          	auipc	a4,0x1b
    80002c42:	e2a70713          	addi	a4,a4,-470 # 8001da68 <bcache+0x8268>
    80002c46:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c4a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c4e:	00013497          	auipc	s1,0x13
    80002c52:	bca48493          	addi	s1,s1,-1078 # 80015818 <bcache+0x18>
    b->next = bcache.head.next;
    80002c56:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c58:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c5a:	00004a17          	auipc	s4,0x4
    80002c5e:	75ea0a13          	addi	s4,s4,1886 # 800073b8 <etext+0x3b8>
    b->next = bcache.head.next;
    80002c62:	2b893783          	ld	a5,696(s2)
    80002c66:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c68:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c6c:	85d2                	mv	a1,s4
    80002c6e:	01048513          	addi	a0,s1,16
    80002c72:	328010ef          	jal	80003f9a <initsleeplock>
    bcache.head.next->prev = b;
    80002c76:	2b893783          	ld	a5,696(s2)
    80002c7a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c7c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c80:	45848493          	addi	s1,s1,1112
    80002c84:	fd349fe3          	bne	s1,s3,80002c62 <binit+0x50>
  }
}
    80002c88:	70a2                	ld	ra,40(sp)
    80002c8a:	7402                	ld	s0,32(sp)
    80002c8c:	64e2                	ld	s1,24(sp)
    80002c8e:	6942                	ld	s2,16(sp)
    80002c90:	69a2                	ld	s3,8(sp)
    80002c92:	6a02                	ld	s4,0(sp)
    80002c94:	6145                	addi	sp,sp,48
    80002c96:	8082                	ret

0000000080002c98 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c98:	7179                	addi	sp,sp,-48
    80002c9a:	f406                	sd	ra,40(sp)
    80002c9c:	f022                	sd	s0,32(sp)
    80002c9e:	ec26                	sd	s1,24(sp)
    80002ca0:	e84a                	sd	s2,16(sp)
    80002ca2:	e44e                	sd	s3,8(sp)
    80002ca4:	1800                	addi	s0,sp,48
    80002ca6:	892a                	mv	s2,a0
    80002ca8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002caa:	00013517          	auipc	a0,0x13
    80002cae:	b5650513          	addi	a0,a0,-1194 # 80015800 <bcache>
    80002cb2:	f77fd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002cb6:	0001b497          	auipc	s1,0x1b
    80002cba:	e024b483          	ld	s1,-510(s1) # 8001dab8 <bcache+0x82b8>
    80002cbe:	0001b797          	auipc	a5,0x1b
    80002cc2:	daa78793          	addi	a5,a5,-598 # 8001da68 <bcache+0x8268>
    80002cc6:	02f48b63          	beq	s1,a5,80002cfc <bread+0x64>
    80002cca:	873e                	mv	a4,a5
    80002ccc:	a021                	j	80002cd4 <bread+0x3c>
    80002cce:	68a4                	ld	s1,80(s1)
    80002cd0:	02e48663          	beq	s1,a4,80002cfc <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002cd4:	449c                	lw	a5,8(s1)
    80002cd6:	ff279ce3          	bne	a5,s2,80002cce <bread+0x36>
    80002cda:	44dc                	lw	a5,12(s1)
    80002cdc:	ff3799e3          	bne	a5,s3,80002cce <bread+0x36>
      b->refcnt++;
    80002ce0:	40bc                	lw	a5,64(s1)
    80002ce2:	2785                	addiw	a5,a5,1
    80002ce4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ce6:	00013517          	auipc	a0,0x13
    80002cea:	b1a50513          	addi	a0,a0,-1254 # 80015800 <bcache>
    80002cee:	fcffd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002cf2:	01048513          	addi	a0,s1,16
    80002cf6:	2da010ef          	jal	80003fd0 <acquiresleep>
      return b;
    80002cfa:	a889                	j	80002d4c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cfc:	0001b497          	auipc	s1,0x1b
    80002d00:	db44b483          	ld	s1,-588(s1) # 8001dab0 <bcache+0x82b0>
    80002d04:	0001b797          	auipc	a5,0x1b
    80002d08:	d6478793          	addi	a5,a5,-668 # 8001da68 <bcache+0x8268>
    80002d0c:	00f48863          	beq	s1,a5,80002d1c <bread+0x84>
    80002d10:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d12:	40bc                	lw	a5,64(s1)
    80002d14:	cb91                	beqz	a5,80002d28 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d16:	64a4                	ld	s1,72(s1)
    80002d18:	fee49de3          	bne	s1,a4,80002d12 <bread+0x7a>
  panic("bget: no buffers");
    80002d1c:	00004517          	auipc	a0,0x4
    80002d20:	6a450513          	addi	a0,a0,1700 # 800073c0 <etext+0x3c0>
    80002d24:	b01fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80002d28:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d2c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d30:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d34:	4785                	li	a5,1
    80002d36:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d38:	00013517          	auipc	a0,0x13
    80002d3c:	ac850513          	addi	a0,a0,-1336 # 80015800 <bcache>
    80002d40:	f7dfd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002d44:	01048513          	addi	a0,s1,16
    80002d48:	288010ef          	jal	80003fd0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d4c:	409c                	lw	a5,0(s1)
    80002d4e:	cb89                	beqz	a5,80002d60 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d50:	8526                	mv	a0,s1
    80002d52:	70a2                	ld	ra,40(sp)
    80002d54:	7402                	ld	s0,32(sp)
    80002d56:	64e2                	ld	s1,24(sp)
    80002d58:	6942                	ld	s2,16(sp)
    80002d5a:	69a2                	ld	s3,8(sp)
    80002d5c:	6145                	addi	sp,sp,48
    80002d5e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d60:	4581                	li	a1,0
    80002d62:	8526                	mv	a0,s1
    80002d64:	2ed020ef          	jal	80005850 <virtio_disk_rw>
    b->valid = 1;
    80002d68:	4785                	li	a5,1
    80002d6a:	c09c                	sw	a5,0(s1)
  return b;
    80002d6c:	b7d5                	j	80002d50 <bread+0xb8>

0000000080002d6e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d6e:	1101                	addi	sp,sp,-32
    80002d70:	ec06                	sd	ra,24(sp)
    80002d72:	e822                	sd	s0,16(sp)
    80002d74:	e426                	sd	s1,8(sp)
    80002d76:	1000                	addi	s0,sp,32
    80002d78:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d7a:	0541                	addi	a0,a0,16
    80002d7c:	2d2010ef          	jal	8000404e <holdingsleep>
    80002d80:	c911                	beqz	a0,80002d94 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d82:	4585                	li	a1,1
    80002d84:	8526                	mv	a0,s1
    80002d86:	2cb020ef          	jal	80005850 <virtio_disk_rw>
}
    80002d8a:	60e2                	ld	ra,24(sp)
    80002d8c:	6442                	ld	s0,16(sp)
    80002d8e:	64a2                	ld	s1,8(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret
    panic("bwrite");
    80002d94:	00004517          	auipc	a0,0x4
    80002d98:	64450513          	addi	a0,a0,1604 # 800073d8 <etext+0x3d8>
    80002d9c:	a89fd0ef          	jal	80000824 <panic>

0000000080002da0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	e04a                	sd	s2,0(sp)
    80002daa:	1000                	addi	s0,sp,32
    80002dac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002dae:	01050913          	addi	s2,a0,16
    80002db2:	854a                	mv	a0,s2
    80002db4:	29a010ef          	jal	8000404e <holdingsleep>
    80002db8:	c125                	beqz	a0,80002e18 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002dba:	854a                	mv	a0,s2
    80002dbc:	25a010ef          	jal	80004016 <releasesleep>

  acquire(&bcache.lock);
    80002dc0:	00013517          	auipc	a0,0x13
    80002dc4:	a4050513          	addi	a0,a0,-1472 # 80015800 <bcache>
    80002dc8:	e61fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002dcc:	40bc                	lw	a5,64(s1)
    80002dce:	37fd                	addiw	a5,a5,-1
    80002dd0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002dd2:	e79d                	bnez	a5,80002e00 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002dd4:	68b8                	ld	a4,80(s1)
    80002dd6:	64bc                	ld	a5,72(s1)
    80002dd8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002dda:	68b8                	ld	a4,80(s1)
    80002ddc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002dde:	0001b797          	auipc	a5,0x1b
    80002de2:	a2278793          	addi	a5,a5,-1502 # 8001d800 <bcache+0x8000>
    80002de6:	2b87b703          	ld	a4,696(a5)
    80002dea:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002dec:	0001b717          	auipc	a4,0x1b
    80002df0:	c7c70713          	addi	a4,a4,-900 # 8001da68 <bcache+0x8268>
    80002df4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002df6:	2b87b703          	ld	a4,696(a5)
    80002dfa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002dfc:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002e00:	00013517          	auipc	a0,0x13
    80002e04:	a0050513          	addi	a0,a0,-1536 # 80015800 <bcache>
    80002e08:	eb5fd0ef          	jal	80000cbc <release>
}
    80002e0c:	60e2                	ld	ra,24(sp)
    80002e0e:	6442                	ld	s0,16(sp)
    80002e10:	64a2                	ld	s1,8(sp)
    80002e12:	6902                	ld	s2,0(sp)
    80002e14:	6105                	addi	sp,sp,32
    80002e16:	8082                	ret
    panic("brelse");
    80002e18:	00004517          	auipc	a0,0x4
    80002e1c:	5c850513          	addi	a0,a0,1480 # 800073e0 <etext+0x3e0>
    80002e20:	a05fd0ef          	jal	80000824 <panic>

0000000080002e24 <bpin>:

void
bpin(struct buf *b) {
    80002e24:	1101                	addi	sp,sp,-32
    80002e26:	ec06                	sd	ra,24(sp)
    80002e28:	e822                	sd	s0,16(sp)
    80002e2a:	e426                	sd	s1,8(sp)
    80002e2c:	1000                	addi	s0,sp,32
    80002e2e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e30:	00013517          	auipc	a0,0x13
    80002e34:	9d050513          	addi	a0,a0,-1584 # 80015800 <bcache>
    80002e38:	df1fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80002e3c:	40bc                	lw	a5,64(s1)
    80002e3e:	2785                	addiw	a5,a5,1
    80002e40:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e42:	00013517          	auipc	a0,0x13
    80002e46:	9be50513          	addi	a0,a0,-1602 # 80015800 <bcache>
    80002e4a:	e73fd0ef          	jal	80000cbc <release>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	64a2                	ld	s1,8(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret

0000000080002e58 <bunpin>:

void
bunpin(struct buf *b) {
    80002e58:	1101                	addi	sp,sp,-32
    80002e5a:	ec06                	sd	ra,24(sp)
    80002e5c:	e822                	sd	s0,16(sp)
    80002e5e:	e426                	sd	s1,8(sp)
    80002e60:	1000                	addi	s0,sp,32
    80002e62:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e64:	00013517          	auipc	a0,0x13
    80002e68:	99c50513          	addi	a0,a0,-1636 # 80015800 <bcache>
    80002e6c:	dbdfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002e70:	40bc                	lw	a5,64(s1)
    80002e72:	37fd                	addiw	a5,a5,-1
    80002e74:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e76:	00013517          	auipc	a0,0x13
    80002e7a:	98a50513          	addi	a0,a0,-1654 # 80015800 <bcache>
    80002e7e:	e3ffd0ef          	jal	80000cbc <release>
}
    80002e82:	60e2                	ld	ra,24(sp)
    80002e84:	6442                	ld	s0,16(sp)
    80002e86:	64a2                	ld	s1,8(sp)
    80002e88:	6105                	addi	sp,sp,32
    80002e8a:	8082                	ret

0000000080002e8c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e8c:	1101                	addi	sp,sp,-32
    80002e8e:	ec06                	sd	ra,24(sp)
    80002e90:	e822                	sd	s0,16(sp)
    80002e92:	e426                	sd	s1,8(sp)
    80002e94:	e04a                	sd	s2,0(sp)
    80002e96:	1000                	addi	s0,sp,32
    80002e98:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e9a:	00d5d79b          	srliw	a5,a1,0xd
    80002e9e:	0001b597          	auipc	a1,0x1b
    80002ea2:	03e5a583          	lw	a1,62(a1) # 8001dedc <sb+0x1c>
    80002ea6:	9dbd                	addw	a1,a1,a5
    80002ea8:	df1ff0ef          	jal	80002c98 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002eac:	0074f713          	andi	a4,s1,7
    80002eb0:	4785                	li	a5,1
    80002eb2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002eb6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002eb8:	90d9                	srli	s1,s1,0x36
    80002eba:	00950733          	add	a4,a0,s1
    80002ebe:	05874703          	lbu	a4,88(a4)
    80002ec2:	00e7f6b3          	and	a3,a5,a4
    80002ec6:	c29d                	beqz	a3,80002eec <bfree+0x60>
    80002ec8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002eca:	94aa                	add	s1,s1,a0
    80002ecc:	fff7c793          	not	a5,a5
    80002ed0:	8f7d                	and	a4,a4,a5
    80002ed2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002ed6:	000010ef          	jal	80003ed6 <log_write>
  brelse(bp);
    80002eda:	854a                	mv	a0,s2
    80002edc:	ec5ff0ef          	jal	80002da0 <brelse>
}
    80002ee0:	60e2                	ld	ra,24(sp)
    80002ee2:	6442                	ld	s0,16(sp)
    80002ee4:	64a2                	ld	s1,8(sp)
    80002ee6:	6902                	ld	s2,0(sp)
    80002ee8:	6105                	addi	sp,sp,32
    80002eea:	8082                	ret
    panic("freeing free block");
    80002eec:	00004517          	auipc	a0,0x4
    80002ef0:	4fc50513          	addi	a0,a0,1276 # 800073e8 <etext+0x3e8>
    80002ef4:	931fd0ef          	jal	80000824 <panic>

0000000080002ef8 <balloc>:
{
    80002ef8:	715d                	addi	sp,sp,-80
    80002efa:	e486                	sd	ra,72(sp)
    80002efc:	e0a2                	sd	s0,64(sp)
    80002efe:	fc26                	sd	s1,56(sp)
    80002f00:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002f02:	0001b797          	auipc	a5,0x1b
    80002f06:	fc27a783          	lw	a5,-62(a5) # 8001dec4 <sb+0x4>
    80002f0a:	0e078263          	beqz	a5,80002fee <balloc+0xf6>
    80002f0e:	f84a                	sd	s2,48(sp)
    80002f10:	f44e                	sd	s3,40(sp)
    80002f12:	f052                	sd	s4,32(sp)
    80002f14:	ec56                	sd	s5,24(sp)
    80002f16:	e85a                	sd	s6,16(sp)
    80002f18:	e45e                	sd	s7,8(sp)
    80002f1a:	e062                	sd	s8,0(sp)
    80002f1c:	8baa                	mv	s7,a0
    80002f1e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f20:	0001bb17          	auipc	s6,0x1b
    80002f24:	fa0b0b13          	addi	s6,s6,-96 # 8001dec0 <sb>
      m = 1 << (bi % 8);
    80002f28:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f2a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f2c:	6c09                	lui	s8,0x2
    80002f2e:	a09d                	j	80002f94 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f30:	97ca                	add	a5,a5,s2
    80002f32:	8e55                	or	a2,a2,a3
    80002f34:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	79d000ef          	jal	80003ed6 <log_write>
        brelse(bp);
    80002f3e:	854a                	mv	a0,s2
    80002f40:	e61ff0ef          	jal	80002da0 <brelse>
  bp = bread(dev, bno);
    80002f44:	85a6                	mv	a1,s1
    80002f46:	855e                	mv	a0,s7
    80002f48:	d51ff0ef          	jal	80002c98 <bread>
    80002f4c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f4e:	40000613          	li	a2,1024
    80002f52:	4581                	li	a1,0
    80002f54:	05850513          	addi	a0,a0,88
    80002f58:	da1fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80002f5c:	854a                	mv	a0,s2
    80002f5e:	779000ef          	jal	80003ed6 <log_write>
  brelse(bp);
    80002f62:	854a                	mv	a0,s2
    80002f64:	e3dff0ef          	jal	80002da0 <brelse>
}
    80002f68:	7942                	ld	s2,48(sp)
    80002f6a:	79a2                	ld	s3,40(sp)
    80002f6c:	7a02                	ld	s4,32(sp)
    80002f6e:	6ae2                	ld	s5,24(sp)
    80002f70:	6b42                	ld	s6,16(sp)
    80002f72:	6ba2                	ld	s7,8(sp)
    80002f74:	6c02                	ld	s8,0(sp)
}
    80002f76:	8526                	mv	a0,s1
    80002f78:	60a6                	ld	ra,72(sp)
    80002f7a:	6406                	ld	s0,64(sp)
    80002f7c:	74e2                	ld	s1,56(sp)
    80002f7e:	6161                	addi	sp,sp,80
    80002f80:	8082                	ret
    brelse(bp);
    80002f82:	854a                	mv	a0,s2
    80002f84:	e1dff0ef          	jal	80002da0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f88:	015c0abb          	addw	s5,s8,s5
    80002f8c:	004b2783          	lw	a5,4(s6)
    80002f90:	04faf863          	bgeu	s5,a5,80002fe0 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002f94:	40dad59b          	sraiw	a1,s5,0xd
    80002f98:	01cb2783          	lw	a5,28(s6)
    80002f9c:	9dbd                	addw	a1,a1,a5
    80002f9e:	855e                	mv	a0,s7
    80002fa0:	cf9ff0ef          	jal	80002c98 <bread>
    80002fa4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fa6:	004b2503          	lw	a0,4(s6)
    80002faa:	84d6                	mv	s1,s5
    80002fac:	4701                	li	a4,0
    80002fae:	fca4fae3          	bgeu	s1,a0,80002f82 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002fb2:	00777693          	andi	a3,a4,7
    80002fb6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002fba:	41f7579b          	sraiw	a5,a4,0x1f
    80002fbe:	01d7d79b          	srliw	a5,a5,0x1d
    80002fc2:	9fb9                	addw	a5,a5,a4
    80002fc4:	4037d79b          	sraiw	a5,a5,0x3
    80002fc8:	00f90633          	add	a2,s2,a5
    80002fcc:	05864603          	lbu	a2,88(a2)
    80002fd0:	00c6f5b3          	and	a1,a3,a2
    80002fd4:	ddb1                	beqz	a1,80002f30 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fd6:	2705                	addiw	a4,a4,1
    80002fd8:	2485                	addiw	s1,s1,1
    80002fda:	fd471ae3          	bne	a4,s4,80002fae <balloc+0xb6>
    80002fde:	b755                	j	80002f82 <balloc+0x8a>
    80002fe0:	7942                	ld	s2,48(sp)
    80002fe2:	79a2                	ld	s3,40(sp)
    80002fe4:	7a02                	ld	s4,32(sp)
    80002fe6:	6ae2                	ld	s5,24(sp)
    80002fe8:	6b42                	ld	s6,16(sp)
    80002fea:	6ba2                	ld	s7,8(sp)
    80002fec:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002fee:	00004517          	auipc	a0,0x4
    80002ff2:	41250513          	addi	a0,a0,1042 # 80007400 <etext+0x400>
    80002ff6:	d04fd0ef          	jal	800004fa <printf>
  return 0;
    80002ffa:	4481                	li	s1,0
    80002ffc:	bfad                	j	80002f76 <balloc+0x7e>

0000000080002ffe <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ffe:	7179                	addi	sp,sp,-48
    80003000:	f406                	sd	ra,40(sp)
    80003002:	f022                	sd	s0,32(sp)
    80003004:	ec26                	sd	s1,24(sp)
    80003006:	e84a                	sd	s2,16(sp)
    80003008:	e44e                	sd	s3,8(sp)
    8000300a:	1800                	addi	s0,sp,48
    8000300c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000300e:	47ad                	li	a5,11
    80003010:	02b7e363          	bltu	a5,a1,80003036 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003014:	02059793          	slli	a5,a1,0x20
    80003018:	01e7d593          	srli	a1,a5,0x1e
    8000301c:	00b509b3          	add	s3,a0,a1
    80003020:	0509a483          	lw	s1,80(s3)
    80003024:	e0b5                	bnez	s1,80003088 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003026:	4108                	lw	a0,0(a0)
    80003028:	ed1ff0ef          	jal	80002ef8 <balloc>
    8000302c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000302e:	cd29                	beqz	a0,80003088 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003030:	04a9a823          	sw	a0,80(s3)
    80003034:	a891                	j	80003088 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003036:	ff45879b          	addiw	a5,a1,-12
    8000303a:	873e                	mv	a4,a5
    8000303c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000303e:	0ff00793          	li	a5,255
    80003042:	06e7e763          	bltu	a5,a4,800030b0 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003046:	08052483          	lw	s1,128(a0)
    8000304a:	e891                	bnez	s1,8000305e <bmap+0x60>
      addr = balloc(ip->dev);
    8000304c:	4108                	lw	a0,0(a0)
    8000304e:	eabff0ef          	jal	80002ef8 <balloc>
    80003052:	84aa                	mv	s1,a0
      if(addr == 0)
    80003054:	c915                	beqz	a0,80003088 <bmap+0x8a>
    80003056:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003058:	08a92023          	sw	a0,128(s2)
    8000305c:	a011                	j	80003060 <bmap+0x62>
    8000305e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003060:	85a6                	mv	a1,s1
    80003062:	00092503          	lw	a0,0(s2)
    80003066:	c33ff0ef          	jal	80002c98 <bread>
    8000306a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000306c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003070:	02099713          	slli	a4,s3,0x20
    80003074:	01e75593          	srli	a1,a4,0x1e
    80003078:	97ae                	add	a5,a5,a1
    8000307a:	89be                	mv	s3,a5
    8000307c:	4384                	lw	s1,0(a5)
    8000307e:	cc89                	beqz	s1,80003098 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003080:	8552                	mv	a0,s4
    80003082:	d1fff0ef          	jal	80002da0 <brelse>
    return addr;
    80003086:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003088:	8526                	mv	a0,s1
    8000308a:	70a2                	ld	ra,40(sp)
    8000308c:	7402                	ld	s0,32(sp)
    8000308e:	64e2                	ld	s1,24(sp)
    80003090:	6942                	ld	s2,16(sp)
    80003092:	69a2                	ld	s3,8(sp)
    80003094:	6145                	addi	sp,sp,48
    80003096:	8082                	ret
      addr = balloc(ip->dev);
    80003098:	00092503          	lw	a0,0(s2)
    8000309c:	e5dff0ef          	jal	80002ef8 <balloc>
    800030a0:	84aa                	mv	s1,a0
      if(addr){
    800030a2:	dd79                	beqz	a0,80003080 <bmap+0x82>
        a[bn] = addr;
    800030a4:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800030a8:	8552                	mv	a0,s4
    800030aa:	62d000ef          	jal	80003ed6 <log_write>
    800030ae:	bfc9                	j	80003080 <bmap+0x82>
    800030b0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800030b2:	00004517          	auipc	a0,0x4
    800030b6:	36650513          	addi	a0,a0,870 # 80007418 <etext+0x418>
    800030ba:	f6afd0ef          	jal	80000824 <panic>

00000000800030be <iget>:
{
    800030be:	7179                	addi	sp,sp,-48
    800030c0:	f406                	sd	ra,40(sp)
    800030c2:	f022                	sd	s0,32(sp)
    800030c4:	ec26                	sd	s1,24(sp)
    800030c6:	e84a                	sd	s2,16(sp)
    800030c8:	e44e                	sd	s3,8(sp)
    800030ca:	e052                	sd	s4,0(sp)
    800030cc:	1800                	addi	s0,sp,48
    800030ce:	892a                	mv	s2,a0
    800030d0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800030d2:	0001b517          	auipc	a0,0x1b
    800030d6:	e0e50513          	addi	a0,a0,-498 # 8001dee0 <itable>
    800030da:	b4ffd0ef          	jal	80000c28 <acquire>
  empty = 0;
    800030de:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030e0:	0001b497          	auipc	s1,0x1b
    800030e4:	e1848493          	addi	s1,s1,-488 # 8001def8 <itable+0x18>
    800030e8:	0001d697          	auipc	a3,0x1d
    800030ec:	8a068693          	addi	a3,a3,-1888 # 8001f988 <log>
    800030f0:	a809                	j	80003102 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030f2:	e781                	bnez	a5,800030fa <iget+0x3c>
    800030f4:	00099363          	bnez	s3,800030fa <iget+0x3c>
      empty = ip;
    800030f8:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030fa:	08848493          	addi	s1,s1,136
    800030fe:	02d48563          	beq	s1,a3,80003128 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003102:	449c                	lw	a5,8(s1)
    80003104:	fef057e3          	blez	a5,800030f2 <iget+0x34>
    80003108:	4098                	lw	a4,0(s1)
    8000310a:	ff2718e3          	bne	a4,s2,800030fa <iget+0x3c>
    8000310e:	40d8                	lw	a4,4(s1)
    80003110:	ff4715e3          	bne	a4,s4,800030fa <iget+0x3c>
      ip->ref++;
    80003114:	2785                	addiw	a5,a5,1
    80003116:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003118:	0001b517          	auipc	a0,0x1b
    8000311c:	dc850513          	addi	a0,a0,-568 # 8001dee0 <itable>
    80003120:	b9dfd0ef          	jal	80000cbc <release>
      return ip;
    80003124:	89a6                	mv	s3,s1
    80003126:	a015                	j	8000314a <iget+0x8c>
  if(empty == 0)
    80003128:	02098a63          	beqz	s3,8000315c <iget+0x9e>
  ip->dev = dev;
    8000312c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003130:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003134:	4785                	li	a5,1
    80003136:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000313a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000313e:	0001b517          	auipc	a0,0x1b
    80003142:	da250513          	addi	a0,a0,-606 # 8001dee0 <itable>
    80003146:	b77fd0ef          	jal	80000cbc <release>
}
    8000314a:	854e                	mv	a0,s3
    8000314c:	70a2                	ld	ra,40(sp)
    8000314e:	7402                	ld	s0,32(sp)
    80003150:	64e2                	ld	s1,24(sp)
    80003152:	6942                	ld	s2,16(sp)
    80003154:	69a2                	ld	s3,8(sp)
    80003156:	6a02                	ld	s4,0(sp)
    80003158:	6145                	addi	sp,sp,48
    8000315a:	8082                	ret
    panic("iget: no inodes");
    8000315c:	00004517          	auipc	a0,0x4
    80003160:	2d450513          	addi	a0,a0,724 # 80007430 <etext+0x430>
    80003164:	ec0fd0ef          	jal	80000824 <panic>

0000000080003168 <iinit>:
{
    80003168:	7179                	addi	sp,sp,-48
    8000316a:	f406                	sd	ra,40(sp)
    8000316c:	f022                	sd	s0,32(sp)
    8000316e:	ec26                	sd	s1,24(sp)
    80003170:	e84a                	sd	s2,16(sp)
    80003172:	e44e                	sd	s3,8(sp)
    80003174:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003176:	00004597          	auipc	a1,0x4
    8000317a:	2ca58593          	addi	a1,a1,714 # 80007440 <etext+0x440>
    8000317e:	0001b517          	auipc	a0,0x1b
    80003182:	d6250513          	addi	a0,a0,-670 # 8001dee0 <itable>
    80003186:	a19fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    8000318a:	0001b497          	auipc	s1,0x1b
    8000318e:	d7e48493          	addi	s1,s1,-642 # 8001df08 <itable+0x28>
    80003192:	0001d997          	auipc	s3,0x1d
    80003196:	80698993          	addi	s3,s3,-2042 # 8001f998 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000319a:	00004917          	auipc	s2,0x4
    8000319e:	2ae90913          	addi	s2,s2,686 # 80007448 <etext+0x448>
    800031a2:	85ca                	mv	a1,s2
    800031a4:	8526                	mv	a0,s1
    800031a6:	5f5000ef          	jal	80003f9a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800031aa:	08848493          	addi	s1,s1,136
    800031ae:	ff349ae3          	bne	s1,s3,800031a2 <iinit+0x3a>
}
    800031b2:	70a2                	ld	ra,40(sp)
    800031b4:	7402                	ld	s0,32(sp)
    800031b6:	64e2                	ld	s1,24(sp)
    800031b8:	6942                	ld	s2,16(sp)
    800031ba:	69a2                	ld	s3,8(sp)
    800031bc:	6145                	addi	sp,sp,48
    800031be:	8082                	ret

00000000800031c0 <ialloc>:
{
    800031c0:	7139                	addi	sp,sp,-64
    800031c2:	fc06                	sd	ra,56(sp)
    800031c4:	f822                	sd	s0,48(sp)
    800031c6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800031c8:	0001b717          	auipc	a4,0x1b
    800031cc:	d0472703          	lw	a4,-764(a4) # 8001decc <sb+0xc>
    800031d0:	4785                	li	a5,1
    800031d2:	06e7f063          	bgeu	a5,a4,80003232 <ialloc+0x72>
    800031d6:	f426                	sd	s1,40(sp)
    800031d8:	f04a                	sd	s2,32(sp)
    800031da:	ec4e                	sd	s3,24(sp)
    800031dc:	e852                	sd	s4,16(sp)
    800031de:	e456                	sd	s5,8(sp)
    800031e0:	e05a                	sd	s6,0(sp)
    800031e2:	8aaa                	mv	s5,a0
    800031e4:	8b2e                	mv	s6,a1
    800031e6:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800031e8:	0001ba17          	auipc	s4,0x1b
    800031ec:	cd8a0a13          	addi	s4,s4,-808 # 8001dec0 <sb>
    800031f0:	00495593          	srli	a1,s2,0x4
    800031f4:	018a2783          	lw	a5,24(s4)
    800031f8:	9dbd                	addw	a1,a1,a5
    800031fa:	8556                	mv	a0,s5
    800031fc:	a9dff0ef          	jal	80002c98 <bread>
    80003200:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003202:	05850993          	addi	s3,a0,88
    80003206:	00f97793          	andi	a5,s2,15
    8000320a:	079a                	slli	a5,a5,0x6
    8000320c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000320e:	00099783          	lh	a5,0(s3)
    80003212:	cb9d                	beqz	a5,80003248 <ialloc+0x88>
    brelse(bp);
    80003214:	b8dff0ef          	jal	80002da0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003218:	0905                	addi	s2,s2,1
    8000321a:	00ca2703          	lw	a4,12(s4)
    8000321e:	0009079b          	sext.w	a5,s2
    80003222:	fce7e7e3          	bltu	a5,a4,800031f0 <ialloc+0x30>
    80003226:	74a2                	ld	s1,40(sp)
    80003228:	7902                	ld	s2,32(sp)
    8000322a:	69e2                	ld	s3,24(sp)
    8000322c:	6a42                	ld	s4,16(sp)
    8000322e:	6aa2                	ld	s5,8(sp)
    80003230:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003232:	00004517          	auipc	a0,0x4
    80003236:	21e50513          	addi	a0,a0,542 # 80007450 <etext+0x450>
    8000323a:	ac0fd0ef          	jal	800004fa <printf>
  return 0;
    8000323e:	4501                	li	a0,0
}
    80003240:	70e2                	ld	ra,56(sp)
    80003242:	7442                	ld	s0,48(sp)
    80003244:	6121                	addi	sp,sp,64
    80003246:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003248:	04000613          	li	a2,64
    8000324c:	4581                	li	a1,0
    8000324e:	854e                	mv	a0,s3
    80003250:	aa9fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003254:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003258:	8526                	mv	a0,s1
    8000325a:	47d000ef          	jal	80003ed6 <log_write>
      brelse(bp);
    8000325e:	8526                	mv	a0,s1
    80003260:	b41ff0ef          	jal	80002da0 <brelse>
      return iget(dev, inum);
    80003264:	0009059b          	sext.w	a1,s2
    80003268:	8556                	mv	a0,s5
    8000326a:	e55ff0ef          	jal	800030be <iget>
    8000326e:	74a2                	ld	s1,40(sp)
    80003270:	7902                	ld	s2,32(sp)
    80003272:	69e2                	ld	s3,24(sp)
    80003274:	6a42                	ld	s4,16(sp)
    80003276:	6aa2                	ld	s5,8(sp)
    80003278:	6b02                	ld	s6,0(sp)
    8000327a:	b7d9                	j	80003240 <ialloc+0x80>

000000008000327c <iupdate>:
{
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	e04a                	sd	s2,0(sp)
    80003286:	1000                	addi	s0,sp,32
    80003288:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000328a:	415c                	lw	a5,4(a0)
    8000328c:	0047d79b          	srliw	a5,a5,0x4
    80003290:	0001b597          	auipc	a1,0x1b
    80003294:	c485a583          	lw	a1,-952(a1) # 8001ded8 <sb+0x18>
    80003298:	9dbd                	addw	a1,a1,a5
    8000329a:	4108                	lw	a0,0(a0)
    8000329c:	9fdff0ef          	jal	80002c98 <bread>
    800032a0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032a2:	05850793          	addi	a5,a0,88
    800032a6:	40d8                	lw	a4,4(s1)
    800032a8:	8b3d                	andi	a4,a4,15
    800032aa:	071a                	slli	a4,a4,0x6
    800032ac:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800032ae:	04449703          	lh	a4,68(s1)
    800032b2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800032b6:	04649703          	lh	a4,70(s1)
    800032ba:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800032be:	04849703          	lh	a4,72(s1)
    800032c2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800032c6:	04a49703          	lh	a4,74(s1)
    800032ca:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032ce:	44f8                	lw	a4,76(s1)
    800032d0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800032d2:	03400613          	li	a2,52
    800032d6:	05048593          	addi	a1,s1,80
    800032da:	00c78513          	addi	a0,a5,12
    800032de:	a7bfd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    800032e2:	854a                	mv	a0,s2
    800032e4:	3f3000ef          	jal	80003ed6 <log_write>
  brelse(bp);
    800032e8:	854a                	mv	a0,s2
    800032ea:	ab7ff0ef          	jal	80002da0 <brelse>
}
    800032ee:	60e2                	ld	ra,24(sp)
    800032f0:	6442                	ld	s0,16(sp)
    800032f2:	64a2                	ld	s1,8(sp)
    800032f4:	6902                	ld	s2,0(sp)
    800032f6:	6105                	addi	sp,sp,32
    800032f8:	8082                	ret

00000000800032fa <idup>:
{
    800032fa:	1101                	addi	sp,sp,-32
    800032fc:	ec06                	sd	ra,24(sp)
    800032fe:	e822                	sd	s0,16(sp)
    80003300:	e426                	sd	s1,8(sp)
    80003302:	1000                	addi	s0,sp,32
    80003304:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003306:	0001b517          	auipc	a0,0x1b
    8000330a:	bda50513          	addi	a0,a0,-1062 # 8001dee0 <itable>
    8000330e:	91bfd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003312:	449c                	lw	a5,8(s1)
    80003314:	2785                	addiw	a5,a5,1
    80003316:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003318:	0001b517          	auipc	a0,0x1b
    8000331c:	bc850513          	addi	a0,a0,-1080 # 8001dee0 <itable>
    80003320:	99dfd0ef          	jal	80000cbc <release>
}
    80003324:	8526                	mv	a0,s1
    80003326:	60e2                	ld	ra,24(sp)
    80003328:	6442                	ld	s0,16(sp)
    8000332a:	64a2                	ld	s1,8(sp)
    8000332c:	6105                	addi	sp,sp,32
    8000332e:	8082                	ret

0000000080003330 <ilock>:
{
    80003330:	1101                	addi	sp,sp,-32
    80003332:	ec06                	sd	ra,24(sp)
    80003334:	e822                	sd	s0,16(sp)
    80003336:	e426                	sd	s1,8(sp)
    80003338:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000333a:	cd19                	beqz	a0,80003358 <ilock+0x28>
    8000333c:	84aa                	mv	s1,a0
    8000333e:	451c                	lw	a5,8(a0)
    80003340:	00f05c63          	blez	a5,80003358 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003344:	0541                	addi	a0,a0,16
    80003346:	48b000ef          	jal	80003fd0 <acquiresleep>
  if(ip->valid == 0){
    8000334a:	40bc                	lw	a5,64(s1)
    8000334c:	cf89                	beqz	a5,80003366 <ilock+0x36>
}
    8000334e:	60e2                	ld	ra,24(sp)
    80003350:	6442                	ld	s0,16(sp)
    80003352:	64a2                	ld	s1,8(sp)
    80003354:	6105                	addi	sp,sp,32
    80003356:	8082                	ret
    80003358:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000335a:	00004517          	auipc	a0,0x4
    8000335e:	10e50513          	addi	a0,a0,270 # 80007468 <etext+0x468>
    80003362:	cc2fd0ef          	jal	80000824 <panic>
    80003366:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003368:	40dc                	lw	a5,4(s1)
    8000336a:	0047d79b          	srliw	a5,a5,0x4
    8000336e:	0001b597          	auipc	a1,0x1b
    80003372:	b6a5a583          	lw	a1,-1174(a1) # 8001ded8 <sb+0x18>
    80003376:	9dbd                	addw	a1,a1,a5
    80003378:	4088                	lw	a0,0(s1)
    8000337a:	91fff0ef          	jal	80002c98 <bread>
    8000337e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003380:	05850593          	addi	a1,a0,88
    80003384:	40dc                	lw	a5,4(s1)
    80003386:	8bbd                	andi	a5,a5,15
    80003388:	079a                	slli	a5,a5,0x6
    8000338a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000338c:	00059783          	lh	a5,0(a1)
    80003390:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003394:	00259783          	lh	a5,2(a1)
    80003398:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000339c:	00459783          	lh	a5,4(a1)
    800033a0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800033a4:	00659783          	lh	a5,6(a1)
    800033a8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800033ac:	459c                	lw	a5,8(a1)
    800033ae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800033b0:	03400613          	li	a2,52
    800033b4:	05b1                	addi	a1,a1,12
    800033b6:	05048513          	addi	a0,s1,80
    800033ba:	99ffd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    800033be:	854a                	mv	a0,s2
    800033c0:	9e1ff0ef          	jal	80002da0 <brelse>
    ip->valid = 1;
    800033c4:	4785                	li	a5,1
    800033c6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800033c8:	04449783          	lh	a5,68(s1)
    800033cc:	c399                	beqz	a5,800033d2 <ilock+0xa2>
    800033ce:	6902                	ld	s2,0(sp)
    800033d0:	bfbd                	j	8000334e <ilock+0x1e>
      panic("ilock: no type");
    800033d2:	00004517          	auipc	a0,0x4
    800033d6:	09e50513          	addi	a0,a0,158 # 80007470 <etext+0x470>
    800033da:	c4afd0ef          	jal	80000824 <panic>

00000000800033de <iunlock>:
{
    800033de:	1101                	addi	sp,sp,-32
    800033e0:	ec06                	sd	ra,24(sp)
    800033e2:	e822                	sd	s0,16(sp)
    800033e4:	e426                	sd	s1,8(sp)
    800033e6:	e04a                	sd	s2,0(sp)
    800033e8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800033ea:	c505                	beqz	a0,80003412 <iunlock+0x34>
    800033ec:	84aa                	mv	s1,a0
    800033ee:	01050913          	addi	s2,a0,16
    800033f2:	854a                	mv	a0,s2
    800033f4:	45b000ef          	jal	8000404e <holdingsleep>
    800033f8:	cd09                	beqz	a0,80003412 <iunlock+0x34>
    800033fa:	449c                	lw	a5,8(s1)
    800033fc:	00f05b63          	blez	a5,80003412 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003400:	854a                	mv	a0,s2
    80003402:	415000ef          	jal	80004016 <releasesleep>
}
    80003406:	60e2                	ld	ra,24(sp)
    80003408:	6442                	ld	s0,16(sp)
    8000340a:	64a2                	ld	s1,8(sp)
    8000340c:	6902                	ld	s2,0(sp)
    8000340e:	6105                	addi	sp,sp,32
    80003410:	8082                	ret
    panic("iunlock");
    80003412:	00004517          	auipc	a0,0x4
    80003416:	06e50513          	addi	a0,a0,110 # 80007480 <etext+0x480>
    8000341a:	c0afd0ef          	jal	80000824 <panic>

000000008000341e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000341e:	7179                	addi	sp,sp,-48
    80003420:	f406                	sd	ra,40(sp)
    80003422:	f022                	sd	s0,32(sp)
    80003424:	ec26                	sd	s1,24(sp)
    80003426:	e84a                	sd	s2,16(sp)
    80003428:	e44e                	sd	s3,8(sp)
    8000342a:	1800                	addi	s0,sp,48
    8000342c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000342e:	05050493          	addi	s1,a0,80
    80003432:	08050913          	addi	s2,a0,128
    80003436:	a021                	j	8000343e <itrunc+0x20>
    80003438:	0491                	addi	s1,s1,4
    8000343a:	01248b63          	beq	s1,s2,80003450 <itrunc+0x32>
    if(ip->addrs[i]){
    8000343e:	408c                	lw	a1,0(s1)
    80003440:	dde5                	beqz	a1,80003438 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003442:	0009a503          	lw	a0,0(s3)
    80003446:	a47ff0ef          	jal	80002e8c <bfree>
      ip->addrs[i] = 0;
    8000344a:	0004a023          	sw	zero,0(s1)
    8000344e:	b7ed                	j	80003438 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003450:	0809a583          	lw	a1,128(s3)
    80003454:	ed89                	bnez	a1,8000346e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003456:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000345a:	854e                	mv	a0,s3
    8000345c:	e21ff0ef          	jal	8000327c <iupdate>
}
    80003460:	70a2                	ld	ra,40(sp)
    80003462:	7402                	ld	s0,32(sp)
    80003464:	64e2                	ld	s1,24(sp)
    80003466:	6942                	ld	s2,16(sp)
    80003468:	69a2                	ld	s3,8(sp)
    8000346a:	6145                	addi	sp,sp,48
    8000346c:	8082                	ret
    8000346e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003470:	0009a503          	lw	a0,0(s3)
    80003474:	825ff0ef          	jal	80002c98 <bread>
    80003478:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000347a:	05850493          	addi	s1,a0,88
    8000347e:	45850913          	addi	s2,a0,1112
    80003482:	a021                	j	8000348a <itrunc+0x6c>
    80003484:	0491                	addi	s1,s1,4
    80003486:	01248963          	beq	s1,s2,80003498 <itrunc+0x7a>
      if(a[j])
    8000348a:	408c                	lw	a1,0(s1)
    8000348c:	dde5                	beqz	a1,80003484 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000348e:	0009a503          	lw	a0,0(s3)
    80003492:	9fbff0ef          	jal	80002e8c <bfree>
    80003496:	b7fd                	j	80003484 <itrunc+0x66>
    brelse(bp);
    80003498:	8552                	mv	a0,s4
    8000349a:	907ff0ef          	jal	80002da0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000349e:	0809a583          	lw	a1,128(s3)
    800034a2:	0009a503          	lw	a0,0(s3)
    800034a6:	9e7ff0ef          	jal	80002e8c <bfree>
    ip->addrs[NDIRECT] = 0;
    800034aa:	0809a023          	sw	zero,128(s3)
    800034ae:	6a02                	ld	s4,0(sp)
    800034b0:	b75d                	j	80003456 <itrunc+0x38>

00000000800034b2 <iput>:
{
    800034b2:	1101                	addi	sp,sp,-32
    800034b4:	ec06                	sd	ra,24(sp)
    800034b6:	e822                	sd	s0,16(sp)
    800034b8:	e426                	sd	s1,8(sp)
    800034ba:	1000                	addi	s0,sp,32
    800034bc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034be:	0001b517          	auipc	a0,0x1b
    800034c2:	a2250513          	addi	a0,a0,-1502 # 8001dee0 <itable>
    800034c6:	f62fd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034ca:	4498                	lw	a4,8(s1)
    800034cc:	4785                	li	a5,1
    800034ce:	02f70063          	beq	a4,a5,800034ee <iput+0x3c>
  ip->ref--;
    800034d2:	449c                	lw	a5,8(s1)
    800034d4:	37fd                	addiw	a5,a5,-1
    800034d6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034d8:	0001b517          	auipc	a0,0x1b
    800034dc:	a0850513          	addi	a0,a0,-1528 # 8001dee0 <itable>
    800034e0:	fdcfd0ef          	jal	80000cbc <release>
}
    800034e4:	60e2                	ld	ra,24(sp)
    800034e6:	6442                	ld	s0,16(sp)
    800034e8:	64a2                	ld	s1,8(sp)
    800034ea:	6105                	addi	sp,sp,32
    800034ec:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034ee:	40bc                	lw	a5,64(s1)
    800034f0:	d3ed                	beqz	a5,800034d2 <iput+0x20>
    800034f2:	04a49783          	lh	a5,74(s1)
    800034f6:	fff1                	bnez	a5,800034d2 <iput+0x20>
    800034f8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800034fa:	01048793          	addi	a5,s1,16
    800034fe:	893e                	mv	s2,a5
    80003500:	853e                	mv	a0,a5
    80003502:	2cf000ef          	jal	80003fd0 <acquiresleep>
    release(&itable.lock);
    80003506:	0001b517          	auipc	a0,0x1b
    8000350a:	9da50513          	addi	a0,a0,-1574 # 8001dee0 <itable>
    8000350e:	faefd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003512:	8526                	mv	a0,s1
    80003514:	f0bff0ef          	jal	8000341e <itrunc>
    ip->type = 0;
    80003518:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000351c:	8526                	mv	a0,s1
    8000351e:	d5fff0ef          	jal	8000327c <iupdate>
    ip->valid = 0;
    80003522:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003526:	854a                	mv	a0,s2
    80003528:	2ef000ef          	jal	80004016 <releasesleep>
    acquire(&itable.lock);
    8000352c:	0001b517          	auipc	a0,0x1b
    80003530:	9b450513          	addi	a0,a0,-1612 # 8001dee0 <itable>
    80003534:	ef4fd0ef          	jal	80000c28 <acquire>
    80003538:	6902                	ld	s2,0(sp)
    8000353a:	bf61                	j	800034d2 <iput+0x20>

000000008000353c <iunlockput>:
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	e426                	sd	s1,8(sp)
    80003544:	1000                	addi	s0,sp,32
    80003546:	84aa                	mv	s1,a0
  iunlock(ip);
    80003548:	e97ff0ef          	jal	800033de <iunlock>
  iput(ip);
    8000354c:	8526                	mv	a0,s1
    8000354e:	f65ff0ef          	jal	800034b2 <iput>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6105                	addi	sp,sp,32
    8000355a:	8082                	ret

000000008000355c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000355c:	0001b717          	auipc	a4,0x1b
    80003560:	97072703          	lw	a4,-1680(a4) # 8001decc <sb+0xc>
    80003564:	4785                	li	a5,1
    80003566:	0ae7fe63          	bgeu	a5,a4,80003622 <ireclaim+0xc6>
{
    8000356a:	7139                	addi	sp,sp,-64
    8000356c:	fc06                	sd	ra,56(sp)
    8000356e:	f822                	sd	s0,48(sp)
    80003570:	f426                	sd	s1,40(sp)
    80003572:	f04a                	sd	s2,32(sp)
    80003574:	ec4e                	sd	s3,24(sp)
    80003576:	e852                	sd	s4,16(sp)
    80003578:	e456                	sd	s5,8(sp)
    8000357a:	e05a                	sd	s6,0(sp)
    8000357c:	0080                	addi	s0,sp,64
    8000357e:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003580:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003582:	0001ba17          	auipc	s4,0x1b
    80003586:	93ea0a13          	addi	s4,s4,-1730 # 8001dec0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    8000358a:	00004b17          	auipc	s6,0x4
    8000358e:	efeb0b13          	addi	s6,s6,-258 # 80007488 <etext+0x488>
    80003592:	a099                	j	800035d8 <ireclaim+0x7c>
    80003594:	85ce                	mv	a1,s3
    80003596:	855a                	mv	a0,s6
    80003598:	f63fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    8000359c:	85ce                	mv	a1,s3
    8000359e:	8556                	mv	a0,s5
    800035a0:	b1fff0ef          	jal	800030be <iget>
    800035a4:	89aa                	mv	s3,a0
    brelse(bp);
    800035a6:	854a                	mv	a0,s2
    800035a8:	ff8ff0ef          	jal	80002da0 <brelse>
    if (ip) {
    800035ac:	00098f63          	beqz	s3,800035ca <ireclaim+0x6e>
      begin_op();
    800035b0:	78c000ef          	jal	80003d3c <begin_op>
      ilock(ip);
    800035b4:	854e                	mv	a0,s3
    800035b6:	d7bff0ef          	jal	80003330 <ilock>
      iunlock(ip);
    800035ba:	854e                	mv	a0,s3
    800035bc:	e23ff0ef          	jal	800033de <iunlock>
      iput(ip);
    800035c0:	854e                	mv	a0,s3
    800035c2:	ef1ff0ef          	jal	800034b2 <iput>
      end_op();
    800035c6:	7e6000ef          	jal	80003dac <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035ca:	0485                	addi	s1,s1,1
    800035cc:	00ca2703          	lw	a4,12(s4)
    800035d0:	0004879b          	sext.w	a5,s1
    800035d4:	02e7fd63          	bgeu	a5,a4,8000360e <ireclaim+0xb2>
    800035d8:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800035dc:	0044d593          	srli	a1,s1,0x4
    800035e0:	018a2783          	lw	a5,24(s4)
    800035e4:	9dbd                	addw	a1,a1,a5
    800035e6:	8556                	mv	a0,s5
    800035e8:	eb0ff0ef          	jal	80002c98 <bread>
    800035ec:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800035ee:	05850793          	addi	a5,a0,88
    800035f2:	00f9f713          	andi	a4,s3,15
    800035f6:	071a                	slli	a4,a4,0x6
    800035f8:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800035fa:	00079703          	lh	a4,0(a5)
    800035fe:	c701                	beqz	a4,80003606 <ireclaim+0xaa>
    80003600:	00679783          	lh	a5,6(a5)
    80003604:	dbc1                	beqz	a5,80003594 <ireclaim+0x38>
    brelse(bp);
    80003606:	854a                	mv	a0,s2
    80003608:	f98ff0ef          	jal	80002da0 <brelse>
    if (ip) {
    8000360c:	bf7d                	j	800035ca <ireclaim+0x6e>
}
    8000360e:	70e2                	ld	ra,56(sp)
    80003610:	7442                	ld	s0,48(sp)
    80003612:	74a2                	ld	s1,40(sp)
    80003614:	7902                	ld	s2,32(sp)
    80003616:	69e2                	ld	s3,24(sp)
    80003618:	6a42                	ld	s4,16(sp)
    8000361a:	6aa2                	ld	s5,8(sp)
    8000361c:	6b02                	ld	s6,0(sp)
    8000361e:	6121                	addi	sp,sp,64
    80003620:	8082                	ret
    80003622:	8082                	ret

0000000080003624 <fsinit>:
fsinit(int dev) {
    80003624:	1101                	addi	sp,sp,-32
    80003626:	ec06                	sd	ra,24(sp)
    80003628:	e822                	sd	s0,16(sp)
    8000362a:	e426                	sd	s1,8(sp)
    8000362c:	e04a                	sd	s2,0(sp)
    8000362e:	1000                	addi	s0,sp,32
    80003630:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003632:	4585                	li	a1,1
    80003634:	e64ff0ef          	jal	80002c98 <bread>
    80003638:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000363a:	02000613          	li	a2,32
    8000363e:	05850593          	addi	a1,a0,88
    80003642:	0001b517          	auipc	a0,0x1b
    80003646:	87e50513          	addi	a0,a0,-1922 # 8001dec0 <sb>
    8000364a:	f0efd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    8000364e:	8526                	mv	a0,s1
    80003650:	f50ff0ef          	jal	80002da0 <brelse>
  if(sb.magic != FSMAGIC)
    80003654:	0001b717          	auipc	a4,0x1b
    80003658:	86c72703          	lw	a4,-1940(a4) # 8001dec0 <sb>
    8000365c:	102037b7          	lui	a5,0x10203
    80003660:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003664:	02f71263          	bne	a4,a5,80003688 <fsinit+0x64>
  initlog(dev, &sb);
    80003668:	0001b597          	auipc	a1,0x1b
    8000366c:	85858593          	addi	a1,a1,-1960 # 8001dec0 <sb>
    80003670:	854a                	mv	a0,s2
    80003672:	648000ef          	jal	80003cba <initlog>
  ireclaim(dev);
    80003676:	854a                	mv	a0,s2
    80003678:	ee5ff0ef          	jal	8000355c <ireclaim>
}
    8000367c:	60e2                	ld	ra,24(sp)
    8000367e:	6442                	ld	s0,16(sp)
    80003680:	64a2                	ld	s1,8(sp)
    80003682:	6902                	ld	s2,0(sp)
    80003684:	6105                	addi	sp,sp,32
    80003686:	8082                	ret
    panic("invalid file system");
    80003688:	00004517          	auipc	a0,0x4
    8000368c:	e2050513          	addi	a0,a0,-480 # 800074a8 <etext+0x4a8>
    80003690:	994fd0ef          	jal	80000824 <panic>

0000000080003694 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003694:	1141                	addi	sp,sp,-16
    80003696:	e406                	sd	ra,8(sp)
    80003698:	e022                	sd	s0,0(sp)
    8000369a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000369c:	411c                	lw	a5,0(a0)
    8000369e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800036a0:	415c                	lw	a5,4(a0)
    800036a2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800036a4:	04451783          	lh	a5,68(a0)
    800036a8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036ac:	04a51783          	lh	a5,74(a0)
    800036b0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036b4:	04c56783          	lwu	a5,76(a0)
    800036b8:	e99c                	sd	a5,16(a1)
}
    800036ba:	60a2                	ld	ra,8(sp)
    800036bc:	6402                	ld	s0,0(sp)
    800036be:	0141                	addi	sp,sp,16
    800036c0:	8082                	ret

00000000800036c2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036c2:	457c                	lw	a5,76(a0)
    800036c4:	0ed7e663          	bltu	a5,a3,800037b0 <readi+0xee>
{
    800036c8:	7159                	addi	sp,sp,-112
    800036ca:	f486                	sd	ra,104(sp)
    800036cc:	f0a2                	sd	s0,96(sp)
    800036ce:	eca6                	sd	s1,88(sp)
    800036d0:	e0d2                	sd	s4,64(sp)
    800036d2:	fc56                	sd	s5,56(sp)
    800036d4:	f85a                	sd	s6,48(sp)
    800036d6:	f45e                	sd	s7,40(sp)
    800036d8:	1880                	addi	s0,sp,112
    800036da:	8b2a                	mv	s6,a0
    800036dc:	8bae                	mv	s7,a1
    800036de:	8a32                	mv	s4,a2
    800036e0:	84b6                	mv	s1,a3
    800036e2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800036e4:	9f35                	addw	a4,a4,a3
    return 0;
    800036e6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800036e8:	0ad76b63          	bltu	a4,a3,8000379e <readi+0xdc>
    800036ec:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800036ee:	00e7f463          	bgeu	a5,a4,800036f6 <readi+0x34>
    n = ip->size - off;
    800036f2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036f6:	080a8b63          	beqz	s5,8000378c <readi+0xca>
    800036fa:	e8ca                	sd	s2,80(sp)
    800036fc:	f062                	sd	s8,32(sp)
    800036fe:	ec66                	sd	s9,24(sp)
    80003700:	e86a                	sd	s10,16(sp)
    80003702:	e46e                	sd	s11,8(sp)
    80003704:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003706:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000370a:	5c7d                	li	s8,-1
    8000370c:	a80d                	j	8000373e <readi+0x7c>
    8000370e:	020d1d93          	slli	s11,s10,0x20
    80003712:	020ddd93          	srli	s11,s11,0x20
    80003716:	05890613          	addi	a2,s2,88
    8000371a:	86ee                	mv	a3,s11
    8000371c:	963e                	add	a2,a2,a5
    8000371e:	85d2                	mv	a1,s4
    80003720:	855e                	mv	a0,s7
    80003722:	b77fe0ef          	jal	80002298 <either_copyout>
    80003726:	05850363          	beq	a0,s8,8000376c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000372a:	854a                	mv	a0,s2
    8000372c:	e74ff0ef          	jal	80002da0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003730:	013d09bb          	addw	s3,s10,s3
    80003734:	009d04bb          	addw	s1,s10,s1
    80003738:	9a6e                	add	s4,s4,s11
    8000373a:	0559f363          	bgeu	s3,s5,80003780 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000373e:	00a4d59b          	srliw	a1,s1,0xa
    80003742:	855a                	mv	a0,s6
    80003744:	8bbff0ef          	jal	80002ffe <bmap>
    80003748:	85aa                	mv	a1,a0
    if(addr == 0)
    8000374a:	c139                	beqz	a0,80003790 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000374c:	000b2503          	lw	a0,0(s6)
    80003750:	d48ff0ef          	jal	80002c98 <bread>
    80003754:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003756:	3ff4f793          	andi	a5,s1,1023
    8000375a:	40fc873b          	subw	a4,s9,a5
    8000375e:	413a86bb          	subw	a3,s5,s3
    80003762:	8d3a                	mv	s10,a4
    80003764:	fae6f5e3          	bgeu	a3,a4,8000370e <readi+0x4c>
    80003768:	8d36                	mv	s10,a3
    8000376a:	b755                	j	8000370e <readi+0x4c>
      brelse(bp);
    8000376c:	854a                	mv	a0,s2
    8000376e:	e32ff0ef          	jal	80002da0 <brelse>
      tot = -1;
    80003772:	59fd                	li	s3,-1
      break;
    80003774:	6946                	ld	s2,80(sp)
    80003776:	7c02                	ld	s8,32(sp)
    80003778:	6ce2                	ld	s9,24(sp)
    8000377a:	6d42                	ld	s10,16(sp)
    8000377c:	6da2                	ld	s11,8(sp)
    8000377e:	a831                	j	8000379a <readi+0xd8>
    80003780:	6946                	ld	s2,80(sp)
    80003782:	7c02                	ld	s8,32(sp)
    80003784:	6ce2                	ld	s9,24(sp)
    80003786:	6d42                	ld	s10,16(sp)
    80003788:	6da2                	ld	s11,8(sp)
    8000378a:	a801                	j	8000379a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000378c:	89d6                	mv	s3,s5
    8000378e:	a031                	j	8000379a <readi+0xd8>
    80003790:	6946                	ld	s2,80(sp)
    80003792:	7c02                	ld	s8,32(sp)
    80003794:	6ce2                	ld	s9,24(sp)
    80003796:	6d42                	ld	s10,16(sp)
    80003798:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000379a:	854e                	mv	a0,s3
    8000379c:	69a6                	ld	s3,72(sp)
}
    8000379e:	70a6                	ld	ra,104(sp)
    800037a0:	7406                	ld	s0,96(sp)
    800037a2:	64e6                	ld	s1,88(sp)
    800037a4:	6a06                	ld	s4,64(sp)
    800037a6:	7ae2                	ld	s5,56(sp)
    800037a8:	7b42                	ld	s6,48(sp)
    800037aa:	7ba2                	ld	s7,40(sp)
    800037ac:	6165                	addi	sp,sp,112
    800037ae:	8082                	ret
    return 0;
    800037b0:	4501                	li	a0,0
}
    800037b2:	8082                	ret

00000000800037b4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037b4:	457c                	lw	a5,76(a0)
    800037b6:	0ed7eb63          	bltu	a5,a3,800038ac <writei+0xf8>
{
    800037ba:	7159                	addi	sp,sp,-112
    800037bc:	f486                	sd	ra,104(sp)
    800037be:	f0a2                	sd	s0,96(sp)
    800037c0:	e8ca                	sd	s2,80(sp)
    800037c2:	e0d2                	sd	s4,64(sp)
    800037c4:	fc56                	sd	s5,56(sp)
    800037c6:	f85a                	sd	s6,48(sp)
    800037c8:	f45e                	sd	s7,40(sp)
    800037ca:	1880                	addi	s0,sp,112
    800037cc:	8aaa                	mv	s5,a0
    800037ce:	8bae                	mv	s7,a1
    800037d0:	8a32                	mv	s4,a2
    800037d2:	8936                	mv	s2,a3
    800037d4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800037d6:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800037da:	00043737          	lui	a4,0x43
    800037de:	0cf76963          	bltu	a4,a5,800038b0 <writei+0xfc>
    800037e2:	0cd7e763          	bltu	a5,a3,800038b0 <writei+0xfc>
    800037e6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037e8:	0a0b0a63          	beqz	s6,8000389c <writei+0xe8>
    800037ec:	eca6                	sd	s1,88(sp)
    800037ee:	f062                	sd	s8,32(sp)
    800037f0:	ec66                	sd	s9,24(sp)
    800037f2:	e86a                	sd	s10,16(sp)
    800037f4:	e46e                	sd	s11,8(sp)
    800037f6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800037f8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037fc:	5c7d                	li	s8,-1
    800037fe:	a825                	j	80003836 <writei+0x82>
    80003800:	020d1d93          	slli	s11,s10,0x20
    80003804:	020ddd93          	srli	s11,s11,0x20
    80003808:	05848513          	addi	a0,s1,88
    8000380c:	86ee                	mv	a3,s11
    8000380e:	8652                	mv	a2,s4
    80003810:	85de                	mv	a1,s7
    80003812:	953e                	add	a0,a0,a5
    80003814:	acffe0ef          	jal	800022e2 <either_copyin>
    80003818:	05850663          	beq	a0,s8,80003864 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000381c:	8526                	mv	a0,s1
    8000381e:	6b8000ef          	jal	80003ed6 <log_write>
    brelse(bp);
    80003822:	8526                	mv	a0,s1
    80003824:	d7cff0ef          	jal	80002da0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003828:	013d09bb          	addw	s3,s10,s3
    8000382c:	012d093b          	addw	s2,s10,s2
    80003830:	9a6e                	add	s4,s4,s11
    80003832:	0369fc63          	bgeu	s3,s6,8000386a <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003836:	00a9559b          	srliw	a1,s2,0xa
    8000383a:	8556                	mv	a0,s5
    8000383c:	fc2ff0ef          	jal	80002ffe <bmap>
    80003840:	85aa                	mv	a1,a0
    if(addr == 0)
    80003842:	c505                	beqz	a0,8000386a <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003844:	000aa503          	lw	a0,0(s5)
    80003848:	c50ff0ef          	jal	80002c98 <bread>
    8000384c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000384e:	3ff97793          	andi	a5,s2,1023
    80003852:	40fc873b          	subw	a4,s9,a5
    80003856:	413b06bb          	subw	a3,s6,s3
    8000385a:	8d3a                	mv	s10,a4
    8000385c:	fae6f2e3          	bgeu	a3,a4,80003800 <writei+0x4c>
    80003860:	8d36                	mv	s10,a3
    80003862:	bf79                	j	80003800 <writei+0x4c>
      brelse(bp);
    80003864:	8526                	mv	a0,s1
    80003866:	d3aff0ef          	jal	80002da0 <brelse>
  }

  if(off > ip->size)
    8000386a:	04caa783          	lw	a5,76(s5)
    8000386e:	0327f963          	bgeu	a5,s2,800038a0 <writei+0xec>
    ip->size = off;
    80003872:	052aa623          	sw	s2,76(s5)
    80003876:	64e6                	ld	s1,88(sp)
    80003878:	7c02                	ld	s8,32(sp)
    8000387a:	6ce2                	ld	s9,24(sp)
    8000387c:	6d42                	ld	s10,16(sp)
    8000387e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003880:	8556                	mv	a0,s5
    80003882:	9fbff0ef          	jal	8000327c <iupdate>

  return tot;
    80003886:	854e                	mv	a0,s3
    80003888:	69a6                	ld	s3,72(sp)
}
    8000388a:	70a6                	ld	ra,104(sp)
    8000388c:	7406                	ld	s0,96(sp)
    8000388e:	6946                	ld	s2,80(sp)
    80003890:	6a06                	ld	s4,64(sp)
    80003892:	7ae2                	ld	s5,56(sp)
    80003894:	7b42                	ld	s6,48(sp)
    80003896:	7ba2                	ld	s7,40(sp)
    80003898:	6165                	addi	sp,sp,112
    8000389a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000389c:	89da                	mv	s3,s6
    8000389e:	b7cd                	j	80003880 <writei+0xcc>
    800038a0:	64e6                	ld	s1,88(sp)
    800038a2:	7c02                	ld	s8,32(sp)
    800038a4:	6ce2                	ld	s9,24(sp)
    800038a6:	6d42                	ld	s10,16(sp)
    800038a8:	6da2                	ld	s11,8(sp)
    800038aa:	bfd9                	j	80003880 <writei+0xcc>
    return -1;
    800038ac:	557d                	li	a0,-1
}
    800038ae:	8082                	ret
    return -1;
    800038b0:	557d                	li	a0,-1
    800038b2:	bfe1                	j	8000388a <writei+0xd6>

00000000800038b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800038b4:	1141                	addi	sp,sp,-16
    800038b6:	e406                	sd	ra,8(sp)
    800038b8:	e022                	sd	s0,0(sp)
    800038ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038bc:	4639                	li	a2,14
    800038be:	d0efd0ef          	jal	80000dcc <strncmp>
}
    800038c2:	60a2                	ld	ra,8(sp)
    800038c4:	6402                	ld	s0,0(sp)
    800038c6:	0141                	addi	sp,sp,16
    800038c8:	8082                	ret

00000000800038ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038ca:	711d                	addi	sp,sp,-96
    800038cc:	ec86                	sd	ra,88(sp)
    800038ce:	e8a2                	sd	s0,80(sp)
    800038d0:	e4a6                	sd	s1,72(sp)
    800038d2:	e0ca                	sd	s2,64(sp)
    800038d4:	fc4e                	sd	s3,56(sp)
    800038d6:	f852                	sd	s4,48(sp)
    800038d8:	f456                	sd	s5,40(sp)
    800038da:	f05a                	sd	s6,32(sp)
    800038dc:	ec5e                	sd	s7,24(sp)
    800038de:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800038e0:	04451703          	lh	a4,68(a0)
    800038e4:	4785                	li	a5,1
    800038e6:	00f71f63          	bne	a4,a5,80003904 <dirlookup+0x3a>
    800038ea:	892a                	mv	s2,a0
    800038ec:	8aae                	mv	s5,a1
    800038ee:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800038f0:	457c                	lw	a5,76(a0)
    800038f2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038f4:	fa040a13          	addi	s4,s0,-96
    800038f8:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800038fa:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038fe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003900:	e39d                	bnez	a5,80003926 <dirlookup+0x5c>
    80003902:	a8b9                	j	80003960 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003904:	00004517          	auipc	a0,0x4
    80003908:	bbc50513          	addi	a0,a0,-1092 # 800074c0 <etext+0x4c0>
    8000390c:	f19fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80003910:	00004517          	auipc	a0,0x4
    80003914:	bc850513          	addi	a0,a0,-1080 # 800074d8 <etext+0x4d8>
    80003918:	f0dfc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000391c:	24c1                	addiw	s1,s1,16
    8000391e:	04c92783          	lw	a5,76(s2)
    80003922:	02f4fe63          	bgeu	s1,a5,8000395e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003926:	874e                	mv	a4,s3
    80003928:	86a6                	mv	a3,s1
    8000392a:	8652                	mv	a2,s4
    8000392c:	4581                	li	a1,0
    8000392e:	854a                	mv	a0,s2
    80003930:	d93ff0ef          	jal	800036c2 <readi>
    80003934:	fd351ee3          	bne	a0,s3,80003910 <dirlookup+0x46>
    if(de.inum == 0)
    80003938:	fa045783          	lhu	a5,-96(s0)
    8000393c:	d3e5                	beqz	a5,8000391c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    8000393e:	85da                	mv	a1,s6
    80003940:	8556                	mv	a0,s5
    80003942:	f73ff0ef          	jal	800038b4 <namecmp>
    80003946:	f979                	bnez	a0,8000391c <dirlookup+0x52>
      if(poff)
    80003948:	000b8463          	beqz	s7,80003950 <dirlookup+0x86>
        *poff = off;
    8000394c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003950:	fa045583          	lhu	a1,-96(s0)
    80003954:	00092503          	lw	a0,0(s2)
    80003958:	f66ff0ef          	jal	800030be <iget>
    8000395c:	a011                	j	80003960 <dirlookup+0x96>
  return 0;
    8000395e:	4501                	li	a0,0
}
    80003960:	60e6                	ld	ra,88(sp)
    80003962:	6446                	ld	s0,80(sp)
    80003964:	64a6                	ld	s1,72(sp)
    80003966:	6906                	ld	s2,64(sp)
    80003968:	79e2                	ld	s3,56(sp)
    8000396a:	7a42                	ld	s4,48(sp)
    8000396c:	7aa2                	ld	s5,40(sp)
    8000396e:	7b02                	ld	s6,32(sp)
    80003970:	6be2                	ld	s7,24(sp)
    80003972:	6125                	addi	sp,sp,96
    80003974:	8082                	ret

0000000080003976 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003976:	711d                	addi	sp,sp,-96
    80003978:	ec86                	sd	ra,88(sp)
    8000397a:	e8a2                	sd	s0,80(sp)
    8000397c:	e4a6                	sd	s1,72(sp)
    8000397e:	e0ca                	sd	s2,64(sp)
    80003980:	fc4e                	sd	s3,56(sp)
    80003982:	f852                	sd	s4,48(sp)
    80003984:	f456                	sd	s5,40(sp)
    80003986:	f05a                	sd	s6,32(sp)
    80003988:	ec5e                	sd	s7,24(sp)
    8000398a:	e862                	sd	s8,16(sp)
    8000398c:	e466                	sd	s9,8(sp)
    8000398e:	e06a                	sd	s10,0(sp)
    80003990:	1080                	addi	s0,sp,96
    80003992:	84aa                	mv	s1,a0
    80003994:	8b2e                	mv	s6,a1
    80003996:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003998:	00054703          	lbu	a4,0(a0)
    8000399c:	02f00793          	li	a5,47
    800039a0:	00f70f63          	beq	a4,a5,800039be <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800039a4:	f8bfd0ef          	jal	8000192e <myproc>
    800039a8:	15053503          	ld	a0,336(a0)
    800039ac:	94fff0ef          	jal	800032fa <idup>
    800039b0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800039b2:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800039b6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800039b8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800039ba:	4b85                	li	s7,1
    800039bc:	a879                	j	80003a5a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800039be:	4585                	li	a1,1
    800039c0:	852e                	mv	a0,a1
    800039c2:	efcff0ef          	jal	800030be <iget>
    800039c6:	8a2a                	mv	s4,a0
    800039c8:	b7ed                	j	800039b2 <namex+0x3c>
      iunlockput(ip);
    800039ca:	8552                	mv	a0,s4
    800039cc:	b71ff0ef          	jal	8000353c <iunlockput>
      return 0;
    800039d0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039d2:	8552                	mv	a0,s4
    800039d4:	60e6                	ld	ra,88(sp)
    800039d6:	6446                	ld	s0,80(sp)
    800039d8:	64a6                	ld	s1,72(sp)
    800039da:	6906                	ld	s2,64(sp)
    800039dc:	79e2                	ld	s3,56(sp)
    800039de:	7a42                	ld	s4,48(sp)
    800039e0:	7aa2                	ld	s5,40(sp)
    800039e2:	7b02                	ld	s6,32(sp)
    800039e4:	6be2                	ld	s7,24(sp)
    800039e6:	6c42                	ld	s8,16(sp)
    800039e8:	6ca2                	ld	s9,8(sp)
    800039ea:	6d02                	ld	s10,0(sp)
    800039ec:	6125                	addi	sp,sp,96
    800039ee:	8082                	ret
      iunlock(ip);
    800039f0:	8552                	mv	a0,s4
    800039f2:	9edff0ef          	jal	800033de <iunlock>
      return ip;
    800039f6:	bff1                	j	800039d2 <namex+0x5c>
      iunlockput(ip);
    800039f8:	8552                	mv	a0,s4
    800039fa:	b43ff0ef          	jal	8000353c <iunlockput>
      return 0;
    800039fe:	8a4a                	mv	s4,s2
    80003a00:	bfc9                	j	800039d2 <namex+0x5c>
  len = path - s;
    80003a02:	40990633          	sub	a2,s2,s1
    80003a06:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003a0a:	09ac5463          	bge	s8,s10,80003a92 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003a0e:	8666                	mv	a2,s9
    80003a10:	85a6                	mv	a1,s1
    80003a12:	8556                	mv	a0,s5
    80003a14:	b44fd0ef          	jal	80000d58 <memmove>
    80003a18:	84ca                	mv	s1,s2
  while(*path == '/')
    80003a1a:	0004c783          	lbu	a5,0(s1)
    80003a1e:	01379763          	bne	a5,s3,80003a2c <namex+0xb6>
    path++;
    80003a22:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a24:	0004c783          	lbu	a5,0(s1)
    80003a28:	ff378de3          	beq	a5,s3,80003a22 <namex+0xac>
    ilock(ip);
    80003a2c:	8552                	mv	a0,s4
    80003a2e:	903ff0ef          	jal	80003330 <ilock>
    if(ip->type != T_DIR){
    80003a32:	044a1783          	lh	a5,68(s4)
    80003a36:	f9779ae3          	bne	a5,s7,800039ca <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003a3a:	000b0563          	beqz	s6,80003a44 <namex+0xce>
    80003a3e:	0004c783          	lbu	a5,0(s1)
    80003a42:	d7dd                	beqz	a5,800039f0 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a44:	4601                	li	a2,0
    80003a46:	85d6                	mv	a1,s5
    80003a48:	8552                	mv	a0,s4
    80003a4a:	e81ff0ef          	jal	800038ca <dirlookup>
    80003a4e:	892a                	mv	s2,a0
    80003a50:	d545                	beqz	a0,800039f8 <namex+0x82>
    iunlockput(ip);
    80003a52:	8552                	mv	a0,s4
    80003a54:	ae9ff0ef          	jal	8000353c <iunlockput>
    ip = next;
    80003a58:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003a5a:	0004c783          	lbu	a5,0(s1)
    80003a5e:	01379763          	bne	a5,s3,80003a6c <namex+0xf6>
    path++;
    80003a62:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a64:	0004c783          	lbu	a5,0(s1)
    80003a68:	ff378de3          	beq	a5,s3,80003a62 <namex+0xec>
  if(*path == 0)
    80003a6c:	cf8d                	beqz	a5,80003aa6 <namex+0x130>
  while(*path != '/' && *path != 0)
    80003a6e:	0004c783          	lbu	a5,0(s1)
    80003a72:	fd178713          	addi	a4,a5,-47
    80003a76:	cb19                	beqz	a4,80003a8c <namex+0x116>
    80003a78:	cb91                	beqz	a5,80003a8c <namex+0x116>
    80003a7a:	8926                	mv	s2,s1
    path++;
    80003a7c:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003a7e:	00094783          	lbu	a5,0(s2)
    80003a82:	fd178713          	addi	a4,a5,-47
    80003a86:	df35                	beqz	a4,80003a02 <namex+0x8c>
    80003a88:	fbf5                	bnez	a5,80003a7c <namex+0x106>
    80003a8a:	bfa5                	j	80003a02 <namex+0x8c>
    80003a8c:	8926                	mv	s2,s1
  len = path - s;
    80003a8e:	4d01                	li	s10,0
    80003a90:	4601                	li	a2,0
    memmove(name, s, len);
    80003a92:	2601                	sext.w	a2,a2
    80003a94:	85a6                	mv	a1,s1
    80003a96:	8556                	mv	a0,s5
    80003a98:	ac0fd0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80003a9c:	9d56                	add	s10,s10,s5
    80003a9e:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde438>
    80003aa2:	84ca                	mv	s1,s2
    80003aa4:	bf9d                	j	80003a1a <namex+0xa4>
  if(nameiparent){
    80003aa6:	f20b06e3          	beqz	s6,800039d2 <namex+0x5c>
    iput(ip);
    80003aaa:	8552                	mv	a0,s4
    80003aac:	a07ff0ef          	jal	800034b2 <iput>
    return 0;
    80003ab0:	4a01                	li	s4,0
    80003ab2:	b705                	j	800039d2 <namex+0x5c>

0000000080003ab4 <dirlink>:
{
    80003ab4:	715d                	addi	sp,sp,-80
    80003ab6:	e486                	sd	ra,72(sp)
    80003ab8:	e0a2                	sd	s0,64(sp)
    80003aba:	f84a                	sd	s2,48(sp)
    80003abc:	ec56                	sd	s5,24(sp)
    80003abe:	e85a                	sd	s6,16(sp)
    80003ac0:	0880                	addi	s0,sp,80
    80003ac2:	892a                	mv	s2,a0
    80003ac4:	8aae                	mv	s5,a1
    80003ac6:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ac8:	4601                	li	a2,0
    80003aca:	e01ff0ef          	jal	800038ca <dirlookup>
    80003ace:	ed1d                	bnez	a0,80003b0c <dirlink+0x58>
    80003ad0:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ad2:	04c92483          	lw	s1,76(s2)
    80003ad6:	c4b9                	beqz	s1,80003b24 <dirlink+0x70>
    80003ad8:	f44e                	sd	s3,40(sp)
    80003ada:	f052                	sd	s4,32(sp)
    80003adc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ade:	fb040a13          	addi	s4,s0,-80
    80003ae2:	49c1                	li	s3,16
    80003ae4:	874e                	mv	a4,s3
    80003ae6:	86a6                	mv	a3,s1
    80003ae8:	8652                	mv	a2,s4
    80003aea:	4581                	li	a1,0
    80003aec:	854a                	mv	a0,s2
    80003aee:	bd5ff0ef          	jal	800036c2 <readi>
    80003af2:	03351163          	bne	a0,s3,80003b14 <dirlink+0x60>
    if(de.inum == 0)
    80003af6:	fb045783          	lhu	a5,-80(s0)
    80003afa:	c39d                	beqz	a5,80003b20 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003afc:	24c1                	addiw	s1,s1,16
    80003afe:	04c92783          	lw	a5,76(s2)
    80003b02:	fef4e1e3          	bltu	s1,a5,80003ae4 <dirlink+0x30>
    80003b06:	79a2                	ld	s3,40(sp)
    80003b08:	7a02                	ld	s4,32(sp)
    80003b0a:	a829                	j	80003b24 <dirlink+0x70>
    iput(ip);
    80003b0c:	9a7ff0ef          	jal	800034b2 <iput>
    return -1;
    80003b10:	557d                	li	a0,-1
    80003b12:	a83d                	j	80003b50 <dirlink+0x9c>
      panic("dirlink read");
    80003b14:	00004517          	auipc	a0,0x4
    80003b18:	9d450513          	addi	a0,a0,-1580 # 800074e8 <etext+0x4e8>
    80003b1c:	d09fc0ef          	jal	80000824 <panic>
    80003b20:	79a2                	ld	s3,40(sp)
    80003b22:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003b24:	4639                	li	a2,14
    80003b26:	85d6                	mv	a1,s5
    80003b28:	fb240513          	addi	a0,s0,-78
    80003b2c:	adafd0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80003b30:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b34:	4741                	li	a4,16
    80003b36:	86a6                	mv	a3,s1
    80003b38:	fb040613          	addi	a2,s0,-80
    80003b3c:	4581                	li	a1,0
    80003b3e:	854a                	mv	a0,s2
    80003b40:	c75ff0ef          	jal	800037b4 <writei>
    80003b44:	1541                	addi	a0,a0,-16
    80003b46:	00a03533          	snez	a0,a0
    80003b4a:	40a0053b          	negw	a0,a0
    80003b4e:	74e2                	ld	s1,56(sp)
}
    80003b50:	60a6                	ld	ra,72(sp)
    80003b52:	6406                	ld	s0,64(sp)
    80003b54:	7942                	ld	s2,48(sp)
    80003b56:	6ae2                	ld	s5,24(sp)
    80003b58:	6b42                	ld	s6,16(sp)
    80003b5a:	6161                	addi	sp,sp,80
    80003b5c:	8082                	ret

0000000080003b5e <namei>:

struct inode*
namei(char *path)
{
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b66:	fe040613          	addi	a2,s0,-32
    80003b6a:	4581                	li	a1,0
    80003b6c:	e0bff0ef          	jal	80003976 <namex>
}
    80003b70:	60e2                	ld	ra,24(sp)
    80003b72:	6442                	ld	s0,16(sp)
    80003b74:	6105                	addi	sp,sp,32
    80003b76:	8082                	ret

0000000080003b78 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003b78:	1141                	addi	sp,sp,-16
    80003b7a:	e406                	sd	ra,8(sp)
    80003b7c:	e022                	sd	s0,0(sp)
    80003b7e:	0800                	addi	s0,sp,16
    80003b80:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b82:	4585                	li	a1,1
    80003b84:	df3ff0ef          	jal	80003976 <namex>
}
    80003b88:	60a2                	ld	ra,8(sp)
    80003b8a:	6402                	ld	s0,0(sp)
    80003b8c:	0141                	addi	sp,sp,16
    80003b8e:	8082                	ret

0000000080003b90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b90:	1101                	addi	sp,sp,-32
    80003b92:	ec06                	sd	ra,24(sp)
    80003b94:	e822                	sd	s0,16(sp)
    80003b96:	e426                	sd	s1,8(sp)
    80003b98:	e04a                	sd	s2,0(sp)
    80003b9a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b9c:	0001c917          	auipc	s2,0x1c
    80003ba0:	dec90913          	addi	s2,s2,-532 # 8001f988 <log>
    80003ba4:	01892583          	lw	a1,24(s2)
    80003ba8:	02492503          	lw	a0,36(s2)
    80003bac:	8ecff0ef          	jal	80002c98 <bread>
    80003bb0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003bb2:	02892603          	lw	a2,40(s2)
    80003bb6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003bb8:	00c05f63          	blez	a2,80003bd6 <write_head+0x46>
    80003bbc:	0001c717          	auipc	a4,0x1c
    80003bc0:	df870713          	addi	a4,a4,-520 # 8001f9b4 <log+0x2c>
    80003bc4:	87aa                	mv	a5,a0
    80003bc6:	060a                	slli	a2,a2,0x2
    80003bc8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003bca:	4314                	lw	a3,0(a4)
    80003bcc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003bce:	0711                	addi	a4,a4,4
    80003bd0:	0791                	addi	a5,a5,4
    80003bd2:	fec79ce3          	bne	a5,a2,80003bca <write_head+0x3a>
  }
  bwrite(buf);
    80003bd6:	8526                	mv	a0,s1
    80003bd8:	996ff0ef          	jal	80002d6e <bwrite>
  brelse(buf);
    80003bdc:	8526                	mv	a0,s1
    80003bde:	9c2ff0ef          	jal	80002da0 <brelse>
}
    80003be2:	60e2                	ld	ra,24(sp)
    80003be4:	6442                	ld	s0,16(sp)
    80003be6:	64a2                	ld	s1,8(sp)
    80003be8:	6902                	ld	s2,0(sp)
    80003bea:	6105                	addi	sp,sp,32
    80003bec:	8082                	ret

0000000080003bee <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bee:	0001c797          	auipc	a5,0x1c
    80003bf2:	dc27a783          	lw	a5,-574(a5) # 8001f9b0 <log+0x28>
    80003bf6:	0cf05163          	blez	a5,80003cb8 <install_trans+0xca>
{
    80003bfa:	715d                	addi	sp,sp,-80
    80003bfc:	e486                	sd	ra,72(sp)
    80003bfe:	e0a2                	sd	s0,64(sp)
    80003c00:	fc26                	sd	s1,56(sp)
    80003c02:	f84a                	sd	s2,48(sp)
    80003c04:	f44e                	sd	s3,40(sp)
    80003c06:	f052                	sd	s4,32(sp)
    80003c08:	ec56                	sd	s5,24(sp)
    80003c0a:	e85a                	sd	s6,16(sp)
    80003c0c:	e45e                	sd	s7,8(sp)
    80003c0e:	e062                	sd	s8,0(sp)
    80003c10:	0880                	addi	s0,sp,80
    80003c12:	8b2a                	mv	s6,a0
    80003c14:	0001ca97          	auipc	s5,0x1c
    80003c18:	da0a8a93          	addi	s5,s5,-608 # 8001f9b4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c1c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c1e:	00004c17          	auipc	s8,0x4
    80003c22:	8dac0c13          	addi	s8,s8,-1830 # 800074f8 <etext+0x4f8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c26:	0001ca17          	auipc	s4,0x1c
    80003c2a:	d62a0a13          	addi	s4,s4,-670 # 8001f988 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c2e:	40000b93          	li	s7,1024
    80003c32:	a025                	j	80003c5a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c34:	000aa603          	lw	a2,0(s5)
    80003c38:	85ce                	mv	a1,s3
    80003c3a:	8562                	mv	a0,s8
    80003c3c:	8bffc0ef          	jal	800004fa <printf>
    80003c40:	a839                	j	80003c5e <install_trans+0x70>
    brelse(lbuf);
    80003c42:	854a                	mv	a0,s2
    80003c44:	95cff0ef          	jal	80002da0 <brelse>
    brelse(dbuf);
    80003c48:	8526                	mv	a0,s1
    80003c4a:	956ff0ef          	jal	80002da0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c4e:	2985                	addiw	s3,s3,1
    80003c50:	0a91                	addi	s5,s5,4
    80003c52:	028a2783          	lw	a5,40(s4)
    80003c56:	04f9d563          	bge	s3,a5,80003ca0 <install_trans+0xb2>
    if(recovering) {
    80003c5a:	fc0b1de3          	bnez	s6,80003c34 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c5e:	018a2583          	lw	a1,24(s4)
    80003c62:	013585bb          	addw	a1,a1,s3
    80003c66:	2585                	addiw	a1,a1,1
    80003c68:	024a2503          	lw	a0,36(s4)
    80003c6c:	82cff0ef          	jal	80002c98 <bread>
    80003c70:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003c72:	000aa583          	lw	a1,0(s5)
    80003c76:	024a2503          	lw	a0,36(s4)
    80003c7a:	81eff0ef          	jal	80002c98 <bread>
    80003c7e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c80:	865e                	mv	a2,s7
    80003c82:	05890593          	addi	a1,s2,88
    80003c86:	05850513          	addi	a0,a0,88
    80003c8a:	8cefd0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003c8e:	8526                	mv	a0,s1
    80003c90:	8deff0ef          	jal	80002d6e <bwrite>
    if(recovering == 0)
    80003c94:	fa0b17e3          	bnez	s6,80003c42 <install_trans+0x54>
      bunpin(dbuf);
    80003c98:	8526                	mv	a0,s1
    80003c9a:	9beff0ef          	jal	80002e58 <bunpin>
    80003c9e:	b755                	j	80003c42 <install_trans+0x54>
}
    80003ca0:	60a6                	ld	ra,72(sp)
    80003ca2:	6406                	ld	s0,64(sp)
    80003ca4:	74e2                	ld	s1,56(sp)
    80003ca6:	7942                	ld	s2,48(sp)
    80003ca8:	79a2                	ld	s3,40(sp)
    80003caa:	7a02                	ld	s4,32(sp)
    80003cac:	6ae2                	ld	s5,24(sp)
    80003cae:	6b42                	ld	s6,16(sp)
    80003cb0:	6ba2                	ld	s7,8(sp)
    80003cb2:	6c02                	ld	s8,0(sp)
    80003cb4:	6161                	addi	sp,sp,80
    80003cb6:	8082                	ret
    80003cb8:	8082                	ret

0000000080003cba <initlog>:
{
    80003cba:	7179                	addi	sp,sp,-48
    80003cbc:	f406                	sd	ra,40(sp)
    80003cbe:	f022                	sd	s0,32(sp)
    80003cc0:	ec26                	sd	s1,24(sp)
    80003cc2:	e84a                	sd	s2,16(sp)
    80003cc4:	e44e                	sd	s3,8(sp)
    80003cc6:	1800                	addi	s0,sp,48
    80003cc8:	84aa                	mv	s1,a0
    80003cca:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003ccc:	0001c917          	auipc	s2,0x1c
    80003cd0:	cbc90913          	addi	s2,s2,-836 # 8001f988 <log>
    80003cd4:	00004597          	auipc	a1,0x4
    80003cd8:	84458593          	addi	a1,a1,-1980 # 80007518 <etext+0x518>
    80003cdc:	854a                	mv	a0,s2
    80003cde:	ec1fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80003ce2:	0149a583          	lw	a1,20(s3)
    80003ce6:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003cea:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003cee:	8526                	mv	a0,s1
    80003cf0:	fa9fe0ef          	jal	80002c98 <bread>
  log.lh.n = lh->n;
    80003cf4:	4d30                	lw	a2,88(a0)
    80003cf6:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003cfa:	00c05f63          	blez	a2,80003d18 <initlog+0x5e>
    80003cfe:	87aa                	mv	a5,a0
    80003d00:	0001c717          	auipc	a4,0x1c
    80003d04:	cb470713          	addi	a4,a4,-844 # 8001f9b4 <log+0x2c>
    80003d08:	060a                	slli	a2,a2,0x2
    80003d0a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003d0c:	4ff4                	lw	a3,92(a5)
    80003d0e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d10:	0791                	addi	a5,a5,4
    80003d12:	0711                	addi	a4,a4,4
    80003d14:	fec79ce3          	bne	a5,a2,80003d0c <initlog+0x52>
  brelse(buf);
    80003d18:	888ff0ef          	jal	80002da0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003d1c:	4505                	li	a0,1
    80003d1e:	ed1ff0ef          	jal	80003bee <install_trans>
  log.lh.n = 0;
    80003d22:	0001c797          	auipc	a5,0x1c
    80003d26:	c807a723          	sw	zero,-882(a5) # 8001f9b0 <log+0x28>
  write_head(); // clear the log
    80003d2a:	e67ff0ef          	jal	80003b90 <write_head>
}
    80003d2e:	70a2                	ld	ra,40(sp)
    80003d30:	7402                	ld	s0,32(sp)
    80003d32:	64e2                	ld	s1,24(sp)
    80003d34:	6942                	ld	s2,16(sp)
    80003d36:	69a2                	ld	s3,8(sp)
    80003d38:	6145                	addi	sp,sp,48
    80003d3a:	8082                	ret

0000000080003d3c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d3c:	1101                	addi	sp,sp,-32
    80003d3e:	ec06                	sd	ra,24(sp)
    80003d40:	e822                	sd	s0,16(sp)
    80003d42:	e426                	sd	s1,8(sp)
    80003d44:	e04a                	sd	s2,0(sp)
    80003d46:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d48:	0001c517          	auipc	a0,0x1c
    80003d4c:	c4050513          	addi	a0,a0,-960 # 8001f988 <log>
    80003d50:	ed9fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80003d54:	0001c497          	auipc	s1,0x1c
    80003d58:	c3448493          	addi	s1,s1,-972 # 8001f988 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003d5c:	4979                	li	s2,30
    80003d5e:	a029                	j	80003d68 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003d60:	85a6                	mv	a1,s1
    80003d62:	8526                	mv	a0,s1
    80003d64:	9dafe0ef          	jal	80001f3e <sleep>
    if(log.committing){
    80003d68:	509c                	lw	a5,32(s1)
    80003d6a:	fbfd                	bnez	a5,80003d60 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003d6c:	4cd8                	lw	a4,28(s1)
    80003d6e:	2705                	addiw	a4,a4,1
    80003d70:	0027179b          	slliw	a5,a4,0x2
    80003d74:	9fb9                	addw	a5,a5,a4
    80003d76:	0017979b          	slliw	a5,a5,0x1
    80003d7a:	5494                	lw	a3,40(s1)
    80003d7c:	9fb5                	addw	a5,a5,a3
    80003d7e:	00f95763          	bge	s2,a5,80003d8c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003d82:	85a6                	mv	a1,s1
    80003d84:	8526                	mv	a0,s1
    80003d86:	9b8fe0ef          	jal	80001f3e <sleep>
    80003d8a:	bff9                	j	80003d68 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003d8c:	0001c797          	auipc	a5,0x1c
    80003d90:	c0e7ac23          	sw	a4,-1000(a5) # 8001f9a4 <log+0x1c>
      release(&log.lock);
    80003d94:	0001c517          	auipc	a0,0x1c
    80003d98:	bf450513          	addi	a0,a0,-1036 # 8001f988 <log>
    80003d9c:	f21fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003da0:	60e2                	ld	ra,24(sp)
    80003da2:	6442                	ld	s0,16(sp)
    80003da4:	64a2                	ld	s1,8(sp)
    80003da6:	6902                	ld	s2,0(sp)
    80003da8:	6105                	addi	sp,sp,32
    80003daa:	8082                	ret

0000000080003dac <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003dac:	7139                	addi	sp,sp,-64
    80003dae:	fc06                	sd	ra,56(sp)
    80003db0:	f822                	sd	s0,48(sp)
    80003db2:	f426                	sd	s1,40(sp)
    80003db4:	f04a                	sd	s2,32(sp)
    80003db6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003db8:	0001c497          	auipc	s1,0x1c
    80003dbc:	bd048493          	addi	s1,s1,-1072 # 8001f988 <log>
    80003dc0:	8526                	mv	a0,s1
    80003dc2:	e67fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80003dc6:	4cdc                	lw	a5,28(s1)
    80003dc8:	37fd                	addiw	a5,a5,-1
    80003dca:	893e                	mv	s2,a5
    80003dcc:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003dce:	509c                	lw	a5,32(s1)
    80003dd0:	e7b1                	bnez	a5,80003e1c <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003dd2:	04091e63          	bnez	s2,80003e2e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003dd6:	0001c497          	auipc	s1,0x1c
    80003dda:	bb248493          	addi	s1,s1,-1102 # 8001f988 <log>
    80003dde:	4785                	li	a5,1
    80003de0:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003de2:	8526                	mv	a0,s1
    80003de4:	ed9fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003de8:	549c                	lw	a5,40(s1)
    80003dea:	06f04463          	bgtz	a5,80003e52 <end_op+0xa6>
    acquire(&log.lock);
    80003dee:	0001c517          	auipc	a0,0x1c
    80003df2:	b9a50513          	addi	a0,a0,-1126 # 8001f988 <log>
    80003df6:	e33fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80003dfa:	0001c797          	auipc	a5,0x1c
    80003dfe:	ba07a723          	sw	zero,-1106(a5) # 8001f9a8 <log+0x20>
    wakeup(&log);
    80003e02:	0001c517          	auipc	a0,0x1c
    80003e06:	b8650513          	addi	a0,a0,-1146 # 8001f988 <log>
    80003e0a:	980fe0ef          	jal	80001f8a <wakeup>
    release(&log.lock);
    80003e0e:	0001c517          	auipc	a0,0x1c
    80003e12:	b7a50513          	addi	a0,a0,-1158 # 8001f988 <log>
    80003e16:	ea7fc0ef          	jal	80000cbc <release>
}
    80003e1a:	a035                	j	80003e46 <end_op+0x9a>
    80003e1c:	ec4e                	sd	s3,24(sp)
    80003e1e:	e852                	sd	s4,16(sp)
    80003e20:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003e22:	00003517          	auipc	a0,0x3
    80003e26:	6fe50513          	addi	a0,a0,1790 # 80007520 <etext+0x520>
    80003e2a:	9fbfc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80003e2e:	0001c517          	auipc	a0,0x1c
    80003e32:	b5a50513          	addi	a0,a0,-1190 # 8001f988 <log>
    80003e36:	954fe0ef          	jal	80001f8a <wakeup>
  release(&log.lock);
    80003e3a:	0001c517          	auipc	a0,0x1c
    80003e3e:	b4e50513          	addi	a0,a0,-1202 # 8001f988 <log>
    80003e42:	e7bfc0ef          	jal	80000cbc <release>
}
    80003e46:	70e2                	ld	ra,56(sp)
    80003e48:	7442                	ld	s0,48(sp)
    80003e4a:	74a2                	ld	s1,40(sp)
    80003e4c:	7902                	ld	s2,32(sp)
    80003e4e:	6121                	addi	sp,sp,64
    80003e50:	8082                	ret
    80003e52:	ec4e                	sd	s3,24(sp)
    80003e54:	e852                	sd	s4,16(sp)
    80003e56:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e58:	0001ca97          	auipc	s5,0x1c
    80003e5c:	b5ca8a93          	addi	s5,s5,-1188 # 8001f9b4 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003e60:	0001ca17          	auipc	s4,0x1c
    80003e64:	b28a0a13          	addi	s4,s4,-1240 # 8001f988 <log>
    80003e68:	018a2583          	lw	a1,24(s4)
    80003e6c:	012585bb          	addw	a1,a1,s2
    80003e70:	2585                	addiw	a1,a1,1
    80003e72:	024a2503          	lw	a0,36(s4)
    80003e76:	e23fe0ef          	jal	80002c98 <bread>
    80003e7a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003e7c:	000aa583          	lw	a1,0(s5)
    80003e80:	024a2503          	lw	a0,36(s4)
    80003e84:	e15fe0ef          	jal	80002c98 <bread>
    80003e88:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003e8a:	40000613          	li	a2,1024
    80003e8e:	05850593          	addi	a1,a0,88
    80003e92:	05848513          	addi	a0,s1,88
    80003e96:	ec3fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	ed3fe0ef          	jal	80002d6e <bwrite>
    brelse(from);
    80003ea0:	854e                	mv	a0,s3
    80003ea2:	efffe0ef          	jal	80002da0 <brelse>
    brelse(to);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	ef9fe0ef          	jal	80002da0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003eac:	2905                	addiw	s2,s2,1
    80003eae:	0a91                	addi	s5,s5,4
    80003eb0:	028a2783          	lw	a5,40(s4)
    80003eb4:	faf94ae3          	blt	s2,a5,80003e68 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003eb8:	cd9ff0ef          	jal	80003b90 <write_head>
    install_trans(0); // Now install writes to home locations
    80003ebc:	4501                	li	a0,0
    80003ebe:	d31ff0ef          	jal	80003bee <install_trans>
    log.lh.n = 0;
    80003ec2:	0001c797          	auipc	a5,0x1c
    80003ec6:	ae07a723          	sw	zero,-1298(a5) # 8001f9b0 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003eca:	cc7ff0ef          	jal	80003b90 <write_head>
    80003ece:	69e2                	ld	s3,24(sp)
    80003ed0:	6a42                	ld	s4,16(sp)
    80003ed2:	6aa2                	ld	s5,8(sp)
    80003ed4:	bf29                	j	80003dee <end_op+0x42>

0000000080003ed6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003ed6:	1101                	addi	sp,sp,-32
    80003ed8:	ec06                	sd	ra,24(sp)
    80003eda:	e822                	sd	s0,16(sp)
    80003edc:	e426                	sd	s1,8(sp)
    80003ede:	1000                	addi	s0,sp,32
    80003ee0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003ee2:	0001c517          	auipc	a0,0x1c
    80003ee6:	aa650513          	addi	a0,a0,-1370 # 8001f988 <log>
    80003eea:	d3ffc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003eee:	0001c617          	auipc	a2,0x1c
    80003ef2:	ac262603          	lw	a2,-1342(a2) # 8001f9b0 <log+0x28>
    80003ef6:	47f5                	li	a5,29
    80003ef8:	04c7cd63          	blt	a5,a2,80003f52 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003efc:	0001c797          	auipc	a5,0x1c
    80003f00:	aa87a783          	lw	a5,-1368(a5) # 8001f9a4 <log+0x1c>
    80003f04:	04f05d63          	blez	a5,80003f5e <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003f08:	4781                	li	a5,0
    80003f0a:	06c05063          	blez	a2,80003f6a <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f0e:	44cc                	lw	a1,12(s1)
    80003f10:	0001c717          	auipc	a4,0x1c
    80003f14:	aa470713          	addi	a4,a4,-1372 # 8001f9b4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003f18:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f1a:	4314                	lw	a3,0(a4)
    80003f1c:	04b68763          	beq	a3,a1,80003f6a <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003f20:	2785                	addiw	a5,a5,1
    80003f22:	0711                	addi	a4,a4,4
    80003f24:	fef61be3          	bne	a2,a5,80003f1a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003f28:	060a                	slli	a2,a2,0x2
    80003f2a:	02060613          	addi	a2,a2,32
    80003f2e:	0001c797          	auipc	a5,0x1c
    80003f32:	a5a78793          	addi	a5,a5,-1446 # 8001f988 <log>
    80003f36:	97b2                	add	a5,a5,a2
    80003f38:	44d8                	lw	a4,12(s1)
    80003f3a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	ee7fe0ef          	jal	80002e24 <bpin>
    log.lh.n++;
    80003f42:	0001c717          	auipc	a4,0x1c
    80003f46:	a4670713          	addi	a4,a4,-1466 # 8001f988 <log>
    80003f4a:	571c                	lw	a5,40(a4)
    80003f4c:	2785                	addiw	a5,a5,1
    80003f4e:	d71c                	sw	a5,40(a4)
    80003f50:	a815                	j	80003f84 <log_write+0xae>
    panic("too big a transaction");
    80003f52:	00003517          	auipc	a0,0x3
    80003f56:	5de50513          	addi	a0,a0,1502 # 80007530 <etext+0x530>
    80003f5a:	8cbfc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80003f5e:	00003517          	auipc	a0,0x3
    80003f62:	5ea50513          	addi	a0,a0,1514 # 80007548 <etext+0x548>
    80003f66:	8bffc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80003f6a:	00279693          	slli	a3,a5,0x2
    80003f6e:	02068693          	addi	a3,a3,32
    80003f72:	0001c717          	auipc	a4,0x1c
    80003f76:	a1670713          	addi	a4,a4,-1514 # 8001f988 <log>
    80003f7a:	9736                	add	a4,a4,a3
    80003f7c:	44d4                	lw	a3,12(s1)
    80003f7e:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003f80:	faf60ee3          	beq	a2,a5,80003f3c <log_write+0x66>
  }
  release(&log.lock);
    80003f84:	0001c517          	auipc	a0,0x1c
    80003f88:	a0450513          	addi	a0,a0,-1532 # 8001f988 <log>
    80003f8c:	d31fc0ef          	jal	80000cbc <release>
}
    80003f90:	60e2                	ld	ra,24(sp)
    80003f92:	6442                	ld	s0,16(sp)
    80003f94:	64a2                	ld	s1,8(sp)
    80003f96:	6105                	addi	sp,sp,32
    80003f98:	8082                	ret

0000000080003f9a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003f9a:	1101                	addi	sp,sp,-32
    80003f9c:	ec06                	sd	ra,24(sp)
    80003f9e:	e822                	sd	s0,16(sp)
    80003fa0:	e426                	sd	s1,8(sp)
    80003fa2:	e04a                	sd	s2,0(sp)
    80003fa4:	1000                	addi	s0,sp,32
    80003fa6:	84aa                	mv	s1,a0
    80003fa8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003faa:	00003597          	auipc	a1,0x3
    80003fae:	5be58593          	addi	a1,a1,1470 # 80007568 <etext+0x568>
    80003fb2:	0521                	addi	a0,a0,8
    80003fb4:	bebfc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    80003fb8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003fbc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003fc0:	0204a423          	sw	zero,40(s1)
}
    80003fc4:	60e2                	ld	ra,24(sp)
    80003fc6:	6442                	ld	s0,16(sp)
    80003fc8:	64a2                	ld	s1,8(sp)
    80003fca:	6902                	ld	s2,0(sp)
    80003fcc:	6105                	addi	sp,sp,32
    80003fce:	8082                	ret

0000000080003fd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003fd0:	1101                	addi	sp,sp,-32
    80003fd2:	ec06                	sd	ra,24(sp)
    80003fd4:	e822                	sd	s0,16(sp)
    80003fd6:	e426                	sd	s1,8(sp)
    80003fd8:	e04a                	sd	s2,0(sp)
    80003fda:	1000                	addi	s0,sp,32
    80003fdc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003fde:	00850913          	addi	s2,a0,8
    80003fe2:	854a                	mv	a0,s2
    80003fe4:	c45fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80003fe8:	409c                	lw	a5,0(s1)
    80003fea:	c799                	beqz	a5,80003ff8 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003fec:	85ca                	mv	a1,s2
    80003fee:	8526                	mv	a0,s1
    80003ff0:	f4ffd0ef          	jal	80001f3e <sleep>
  while (lk->locked) {
    80003ff4:	409c                	lw	a5,0(s1)
    80003ff6:	fbfd                	bnez	a5,80003fec <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003ff8:	4785                	li	a5,1
    80003ffa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ffc:	933fd0ef          	jal	8000192e <myproc>
    80004000:	591c                	lw	a5,48(a0)
    80004002:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004004:	854a                	mv	a0,s2
    80004006:	cb7fc0ef          	jal	80000cbc <release>
}
    8000400a:	60e2                	ld	ra,24(sp)
    8000400c:	6442                	ld	s0,16(sp)
    8000400e:	64a2                	ld	s1,8(sp)
    80004010:	6902                	ld	s2,0(sp)
    80004012:	6105                	addi	sp,sp,32
    80004014:	8082                	ret

0000000080004016 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004016:	1101                	addi	sp,sp,-32
    80004018:	ec06                	sd	ra,24(sp)
    8000401a:	e822                	sd	s0,16(sp)
    8000401c:	e426                	sd	s1,8(sp)
    8000401e:	e04a                	sd	s2,0(sp)
    80004020:	1000                	addi	s0,sp,32
    80004022:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004024:	00850913          	addi	s2,a0,8
    80004028:	854a                	mv	a0,s2
    8000402a:	bfffc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    8000402e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004032:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004036:	8526                	mv	a0,s1
    80004038:	f53fd0ef          	jal	80001f8a <wakeup>
  release(&lk->lk);
    8000403c:	854a                	mv	a0,s2
    8000403e:	c7ffc0ef          	jal	80000cbc <release>
}
    80004042:	60e2                	ld	ra,24(sp)
    80004044:	6442                	ld	s0,16(sp)
    80004046:	64a2                	ld	s1,8(sp)
    80004048:	6902                	ld	s2,0(sp)
    8000404a:	6105                	addi	sp,sp,32
    8000404c:	8082                	ret

000000008000404e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000404e:	7179                	addi	sp,sp,-48
    80004050:	f406                	sd	ra,40(sp)
    80004052:	f022                	sd	s0,32(sp)
    80004054:	ec26                	sd	s1,24(sp)
    80004056:	e84a                	sd	s2,16(sp)
    80004058:	1800                	addi	s0,sp,48
    8000405a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000405c:	00850913          	addi	s2,a0,8
    80004060:	854a                	mv	a0,s2
    80004062:	bc7fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004066:	409c                	lw	a5,0(s1)
    80004068:	ef81                	bnez	a5,80004080 <holdingsleep+0x32>
    8000406a:	4481                	li	s1,0
  release(&lk->lk);
    8000406c:	854a                	mv	a0,s2
    8000406e:	c4ffc0ef          	jal	80000cbc <release>
  return r;
}
    80004072:	8526                	mv	a0,s1
    80004074:	70a2                	ld	ra,40(sp)
    80004076:	7402                	ld	s0,32(sp)
    80004078:	64e2                	ld	s1,24(sp)
    8000407a:	6942                	ld	s2,16(sp)
    8000407c:	6145                	addi	sp,sp,48
    8000407e:	8082                	ret
    80004080:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004082:	0284a983          	lw	s3,40(s1)
    80004086:	8a9fd0ef          	jal	8000192e <myproc>
    8000408a:	5904                	lw	s1,48(a0)
    8000408c:	413484b3          	sub	s1,s1,s3
    80004090:	0014b493          	seqz	s1,s1
    80004094:	69a2                	ld	s3,8(sp)
    80004096:	bfd9                	j	8000406c <holdingsleep+0x1e>

0000000080004098 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004098:	1141                	addi	sp,sp,-16
    8000409a:	e406                	sd	ra,8(sp)
    8000409c:	e022                	sd	s0,0(sp)
    8000409e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040a0:	00003597          	auipc	a1,0x3
    800040a4:	4d858593          	addi	a1,a1,1240 # 80007578 <etext+0x578>
    800040a8:	0001c517          	auipc	a0,0x1c
    800040ac:	a2850513          	addi	a0,a0,-1496 # 8001fad0 <ftable>
    800040b0:	aeffc0ef          	jal	80000b9e <initlock>
}
    800040b4:	60a2                	ld	ra,8(sp)
    800040b6:	6402                	ld	s0,0(sp)
    800040b8:	0141                	addi	sp,sp,16
    800040ba:	8082                	ret

00000000800040bc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800040bc:	1101                	addi	sp,sp,-32
    800040be:	ec06                	sd	ra,24(sp)
    800040c0:	e822                	sd	s0,16(sp)
    800040c2:	e426                	sd	s1,8(sp)
    800040c4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800040c6:	0001c517          	auipc	a0,0x1c
    800040ca:	a0a50513          	addi	a0,a0,-1526 # 8001fad0 <ftable>
    800040ce:	b5bfc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800040d2:	0001c497          	auipc	s1,0x1c
    800040d6:	a1648493          	addi	s1,s1,-1514 # 8001fae8 <ftable+0x18>
    800040da:	0001d717          	auipc	a4,0x1d
    800040de:	9ae70713          	addi	a4,a4,-1618 # 80020a88 <disk>
    if(f->ref == 0){
    800040e2:	40dc                	lw	a5,4(s1)
    800040e4:	cf89                	beqz	a5,800040fe <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800040e6:	02848493          	addi	s1,s1,40
    800040ea:	fee49ce3          	bne	s1,a4,800040e2 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800040ee:	0001c517          	auipc	a0,0x1c
    800040f2:	9e250513          	addi	a0,a0,-1566 # 8001fad0 <ftable>
    800040f6:	bc7fc0ef          	jal	80000cbc <release>
  return 0;
    800040fa:	4481                	li	s1,0
    800040fc:	a809                	j	8000410e <filealloc+0x52>
      f->ref = 1;
    800040fe:	4785                	li	a5,1
    80004100:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004102:	0001c517          	auipc	a0,0x1c
    80004106:	9ce50513          	addi	a0,a0,-1586 # 8001fad0 <ftable>
    8000410a:	bb3fc0ef          	jal	80000cbc <release>
}
    8000410e:	8526                	mv	a0,s1
    80004110:	60e2                	ld	ra,24(sp)
    80004112:	6442                	ld	s0,16(sp)
    80004114:	64a2                	ld	s1,8(sp)
    80004116:	6105                	addi	sp,sp,32
    80004118:	8082                	ret

000000008000411a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000411a:	1101                	addi	sp,sp,-32
    8000411c:	ec06                	sd	ra,24(sp)
    8000411e:	e822                	sd	s0,16(sp)
    80004120:	e426                	sd	s1,8(sp)
    80004122:	1000                	addi	s0,sp,32
    80004124:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004126:	0001c517          	auipc	a0,0x1c
    8000412a:	9aa50513          	addi	a0,a0,-1622 # 8001fad0 <ftable>
    8000412e:	afbfc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004132:	40dc                	lw	a5,4(s1)
    80004134:	02f05063          	blez	a5,80004154 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004138:	2785                	addiw	a5,a5,1
    8000413a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000413c:	0001c517          	auipc	a0,0x1c
    80004140:	99450513          	addi	a0,a0,-1644 # 8001fad0 <ftable>
    80004144:	b79fc0ef          	jal	80000cbc <release>
  return f;
}
    80004148:	8526                	mv	a0,s1
    8000414a:	60e2                	ld	ra,24(sp)
    8000414c:	6442                	ld	s0,16(sp)
    8000414e:	64a2                	ld	s1,8(sp)
    80004150:	6105                	addi	sp,sp,32
    80004152:	8082                	ret
    panic("filedup");
    80004154:	00003517          	auipc	a0,0x3
    80004158:	42c50513          	addi	a0,a0,1068 # 80007580 <etext+0x580>
    8000415c:	ec8fc0ef          	jal	80000824 <panic>

0000000080004160 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004160:	7139                	addi	sp,sp,-64
    80004162:	fc06                	sd	ra,56(sp)
    80004164:	f822                	sd	s0,48(sp)
    80004166:	f426                	sd	s1,40(sp)
    80004168:	0080                	addi	s0,sp,64
    8000416a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000416c:	0001c517          	auipc	a0,0x1c
    80004170:	96450513          	addi	a0,a0,-1692 # 8001fad0 <ftable>
    80004174:	ab5fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004178:	40dc                	lw	a5,4(s1)
    8000417a:	04f05a63          	blez	a5,800041ce <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000417e:	37fd                	addiw	a5,a5,-1
    80004180:	c0dc                	sw	a5,4(s1)
    80004182:	06f04063          	bgtz	a5,800041e2 <fileclose+0x82>
    80004186:	f04a                	sd	s2,32(sp)
    80004188:	ec4e                	sd	s3,24(sp)
    8000418a:	e852                	sd	s4,16(sp)
    8000418c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000418e:	0004a903          	lw	s2,0(s1)
    80004192:	0094c783          	lbu	a5,9(s1)
    80004196:	89be                	mv	s3,a5
    80004198:	689c                	ld	a5,16(s1)
    8000419a:	8a3e                	mv	s4,a5
    8000419c:	6c9c                	ld	a5,24(s1)
    8000419e:	8abe                	mv	s5,a5
  f->ref = 0;
    800041a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041a8:	0001c517          	auipc	a0,0x1c
    800041ac:	92850513          	addi	a0,a0,-1752 # 8001fad0 <ftable>
    800041b0:	b0dfc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    800041b4:	4785                	li	a5,1
    800041b6:	04f90163          	beq	s2,a5,800041f8 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800041ba:	ffe9079b          	addiw	a5,s2,-2
    800041be:	4705                	li	a4,1
    800041c0:	04f77563          	bgeu	a4,a5,8000420a <fileclose+0xaa>
    800041c4:	7902                	ld	s2,32(sp)
    800041c6:	69e2                	ld	s3,24(sp)
    800041c8:	6a42                	ld	s4,16(sp)
    800041ca:	6aa2                	ld	s5,8(sp)
    800041cc:	a00d                	j	800041ee <fileclose+0x8e>
    800041ce:	f04a                	sd	s2,32(sp)
    800041d0:	ec4e                	sd	s3,24(sp)
    800041d2:	e852                	sd	s4,16(sp)
    800041d4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800041d6:	00003517          	auipc	a0,0x3
    800041da:	3b250513          	addi	a0,a0,946 # 80007588 <etext+0x588>
    800041de:	e46fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    800041e2:	0001c517          	auipc	a0,0x1c
    800041e6:	8ee50513          	addi	a0,a0,-1810 # 8001fad0 <ftable>
    800041ea:	ad3fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800041ee:	70e2                	ld	ra,56(sp)
    800041f0:	7442                	ld	s0,48(sp)
    800041f2:	74a2                	ld	s1,40(sp)
    800041f4:	6121                	addi	sp,sp,64
    800041f6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800041f8:	85ce                	mv	a1,s3
    800041fa:	8552                	mv	a0,s4
    800041fc:	348000ef          	jal	80004544 <pipeclose>
    80004200:	7902                	ld	s2,32(sp)
    80004202:	69e2                	ld	s3,24(sp)
    80004204:	6a42                	ld	s4,16(sp)
    80004206:	6aa2                	ld	s5,8(sp)
    80004208:	b7dd                	j	800041ee <fileclose+0x8e>
    begin_op();
    8000420a:	b33ff0ef          	jal	80003d3c <begin_op>
    iput(ff.ip);
    8000420e:	8556                	mv	a0,s5
    80004210:	aa2ff0ef          	jal	800034b2 <iput>
    end_op();
    80004214:	b99ff0ef          	jal	80003dac <end_op>
    80004218:	7902                	ld	s2,32(sp)
    8000421a:	69e2                	ld	s3,24(sp)
    8000421c:	6a42                	ld	s4,16(sp)
    8000421e:	6aa2                	ld	s5,8(sp)
    80004220:	b7f9                	j	800041ee <fileclose+0x8e>

0000000080004222 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004222:	715d                	addi	sp,sp,-80
    80004224:	e486                	sd	ra,72(sp)
    80004226:	e0a2                	sd	s0,64(sp)
    80004228:	fc26                	sd	s1,56(sp)
    8000422a:	f052                	sd	s4,32(sp)
    8000422c:	0880                	addi	s0,sp,80
    8000422e:	84aa                	mv	s1,a0
    80004230:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004232:	efcfd0ef          	jal	8000192e <myproc>
  struct stat st;

  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004236:	409c                	lw	a5,0(s1)
    80004238:	37f9                	addiw	a5,a5,-2
    8000423a:	4705                	li	a4,1
    8000423c:	04f76263          	bltu	a4,a5,80004280 <filestat+0x5e>
    80004240:	f84a                	sd	s2,48(sp)
    80004242:	f44e                	sd	s3,40(sp)
    80004244:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004246:	6c88                	ld	a0,24(s1)
    80004248:	8e8ff0ef          	jal	80003330 <ilock>
    stati(f->ip, &st);
    8000424c:	fb840913          	addi	s2,s0,-72
    80004250:	85ca                	mv	a1,s2
    80004252:	6c88                	ld	a0,24(s1)
    80004254:	c40ff0ef          	jal	80003694 <stati>
    iunlock(f->ip);
    80004258:	6c88                	ld	a0,24(s1)
    8000425a:	984ff0ef          	jal	800033de <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000425e:	46e1                	li	a3,24
    80004260:	864a                	mv	a2,s2
    80004262:	85d2                	mv	a1,s4
    80004264:	0509b503          	ld	a0,80(s3)
    80004268:	becfd0ef          	jal	80001654 <copyout>
    8000426c:	41f5551b          	sraiw	a0,a0,0x1f
    80004270:	7942                	ld	s2,48(sp)
    80004272:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004274:	60a6                	ld	ra,72(sp)
    80004276:	6406                	ld	s0,64(sp)
    80004278:	74e2                	ld	s1,56(sp)
    8000427a:	7a02                	ld	s4,32(sp)
    8000427c:	6161                	addi	sp,sp,80
    8000427e:	8082                	ret
  return -1;
    80004280:	557d                	li	a0,-1
    80004282:	bfcd                	j	80004274 <filestat+0x52>

0000000080004284 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004284:	7179                	addi	sp,sp,-48
    80004286:	f406                	sd	ra,40(sp)
    80004288:	f022                	sd	s0,32(sp)
    8000428a:	e84a                	sd	s2,16(sp)
    8000428c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000428e:	00854783          	lbu	a5,8(a0)
    80004292:	cfd1                	beqz	a5,8000432e <fileread+0xaa>
    80004294:	ec26                	sd	s1,24(sp)
    80004296:	e44e                	sd	s3,8(sp)
    80004298:	84aa                	mv	s1,a0
    8000429a:	892e                	mv	s2,a1
    8000429c:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    8000429e:	411c                	lw	a5,0(a0)
    800042a0:	4705                	li	a4,1
    800042a2:	04e78363          	beq	a5,a4,800042e8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800042a6:	470d                	li	a4,3
    800042a8:	04e78763          	beq	a5,a4,800042f6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800042ac:	4709                	li	a4,2
    800042ae:	06e79a63          	bne	a5,a4,80004322 <fileread+0x9e>
    ilock(f->ip);
    800042b2:	6d08                	ld	a0,24(a0)
    800042b4:	87cff0ef          	jal	80003330 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800042b8:	874e                	mv	a4,s3
    800042ba:	5094                	lw	a3,32(s1)
    800042bc:	864a                	mv	a2,s2
    800042be:	4585                	li	a1,1
    800042c0:	6c88                	ld	a0,24(s1)
    800042c2:	c00ff0ef          	jal	800036c2 <readi>
    800042c6:	892a                	mv	s2,a0
    800042c8:	00a05563          	blez	a0,800042d2 <fileread+0x4e>
      f->off += r;
    800042cc:	509c                	lw	a5,32(s1)
    800042ce:	9fa9                	addw	a5,a5,a0
    800042d0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800042d2:	6c88                	ld	a0,24(s1)
    800042d4:	90aff0ef          	jal	800033de <iunlock>
    800042d8:	64e2                	ld	s1,24(sp)
    800042da:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800042dc:	854a                	mv	a0,s2
    800042de:	70a2                	ld	ra,40(sp)
    800042e0:	7402                	ld	s0,32(sp)
    800042e2:	6942                	ld	s2,16(sp)
    800042e4:	6145                	addi	sp,sp,48
    800042e6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800042e8:	6908                	ld	a0,16(a0)
    800042ea:	3b0000ef          	jal	8000469a <piperead>
    800042ee:	892a                	mv	s2,a0
    800042f0:	64e2                	ld	s1,24(sp)
    800042f2:	69a2                	ld	s3,8(sp)
    800042f4:	b7e5                	j	800042dc <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800042f6:	02451783          	lh	a5,36(a0)
    800042fa:	03079693          	slli	a3,a5,0x30
    800042fe:	92c1                	srli	a3,a3,0x30
    80004300:	4725                	li	a4,9
    80004302:	02d76963          	bltu	a4,a3,80004334 <fileread+0xb0>
    80004306:	0792                	slli	a5,a5,0x4
    80004308:	0001b717          	auipc	a4,0x1b
    8000430c:	72870713          	addi	a4,a4,1832 # 8001fa30 <devsw>
    80004310:	97ba                	add	a5,a5,a4
    80004312:	639c                	ld	a5,0(a5)
    80004314:	c78d                	beqz	a5,8000433e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004316:	4505                	li	a0,1
    80004318:	9782                	jalr	a5
    8000431a:	892a                	mv	s2,a0
    8000431c:	64e2                	ld	s1,24(sp)
    8000431e:	69a2                	ld	s3,8(sp)
    80004320:	bf75                	j	800042dc <fileread+0x58>
    panic("fileread");
    80004322:	00003517          	auipc	a0,0x3
    80004326:	27650513          	addi	a0,a0,630 # 80007598 <etext+0x598>
    8000432a:	cfafc0ef          	jal	80000824 <panic>
    return -1;
    8000432e:	57fd                	li	a5,-1
    80004330:	893e                	mv	s2,a5
    80004332:	b76d                	j	800042dc <fileread+0x58>
      return -1;
    80004334:	57fd                	li	a5,-1
    80004336:	893e                	mv	s2,a5
    80004338:	64e2                	ld	s1,24(sp)
    8000433a:	69a2                	ld	s3,8(sp)
    8000433c:	b745                	j	800042dc <fileread+0x58>
    8000433e:	57fd                	li	a5,-1
    80004340:	893e                	mv	s2,a5
    80004342:	64e2                	ld	s1,24(sp)
    80004344:	69a2                	ld	s3,8(sp)
    80004346:	bf59                	j	800042dc <fileread+0x58>

0000000080004348 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004348:	00954783          	lbu	a5,9(a0)
    8000434c:	10078f63          	beqz	a5,8000446a <filewrite+0x122>
{
    80004350:	711d                	addi	sp,sp,-96
    80004352:	ec86                	sd	ra,88(sp)
    80004354:	e8a2                	sd	s0,80(sp)
    80004356:	e0ca                	sd	s2,64(sp)
    80004358:	f456                	sd	s5,40(sp)
    8000435a:	f05a                	sd	s6,32(sp)
    8000435c:	1080                	addi	s0,sp,96
    8000435e:	892a                	mv	s2,a0
    80004360:	8b2e                	mv	s6,a1
    80004362:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004364:	411c                	lw	a5,0(a0)
    80004366:	4705                	li	a4,1
    80004368:	02e78a63          	beq	a5,a4,8000439c <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000436c:	470d                	li	a4,3
    8000436e:	02e78b63          	beq	a5,a4,800043a4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004372:	4709                	li	a4,2
    80004374:	0ce79f63          	bne	a5,a4,80004452 <filewrite+0x10a>
    80004378:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000437a:	0ac05a63          	blez	a2,8000442e <filewrite+0xe6>
    8000437e:	e4a6                	sd	s1,72(sp)
    80004380:	fc4e                	sd	s3,56(sp)
    80004382:	ec5e                	sd	s7,24(sp)
    80004384:	e862                	sd	s8,16(sp)
    80004386:	e466                	sd	s9,8(sp)
    int i = 0;
    80004388:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000438a:	6b85                	lui	s7,0x1
    8000438c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004390:	6785                	lui	a5,0x1
    80004392:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004396:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004398:	4c05                	li	s8,1
    8000439a:	a8ad                	j	80004414 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000439c:	6908                	ld	a0,16(a0)
    8000439e:	204000ef          	jal	800045a2 <pipewrite>
    800043a2:	a04d                	j	80004444 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800043a4:	02451783          	lh	a5,36(a0)
    800043a8:	03079693          	slli	a3,a5,0x30
    800043ac:	92c1                	srli	a3,a3,0x30
    800043ae:	4725                	li	a4,9
    800043b0:	0ad76f63          	bltu	a4,a3,8000446e <filewrite+0x126>
    800043b4:	0792                	slli	a5,a5,0x4
    800043b6:	0001b717          	auipc	a4,0x1b
    800043ba:	67a70713          	addi	a4,a4,1658 # 8001fa30 <devsw>
    800043be:	97ba                	add	a5,a5,a4
    800043c0:	679c                	ld	a5,8(a5)
    800043c2:	cbc5                	beqz	a5,80004472 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800043c4:	4505                	li	a0,1
    800043c6:	9782                	jalr	a5
    800043c8:	a8b5                	j	80004444 <filewrite+0xfc>
      if(n1 > max)
    800043ca:	2981                	sext.w	s3,s3
      begin_op();
    800043cc:	971ff0ef          	jal	80003d3c <begin_op>
      ilock(f->ip);
    800043d0:	01893503          	ld	a0,24(s2)
    800043d4:	f5dfe0ef          	jal	80003330 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043d8:	874e                	mv	a4,s3
    800043da:	02092683          	lw	a3,32(s2)
    800043de:	016a0633          	add	a2,s4,s6
    800043e2:	85e2                	mv	a1,s8
    800043e4:	01893503          	ld	a0,24(s2)
    800043e8:	bccff0ef          	jal	800037b4 <writei>
    800043ec:	84aa                	mv	s1,a0
    800043ee:	00a05763          	blez	a0,800043fc <filewrite+0xb4>
        f->off += r;
    800043f2:	02092783          	lw	a5,32(s2)
    800043f6:	9fa9                	addw	a5,a5,a0
    800043f8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800043fc:	01893503          	ld	a0,24(s2)
    80004400:	fdffe0ef          	jal	800033de <iunlock>
      end_op();
    80004404:	9a9ff0ef          	jal	80003dac <end_op>

      if(r != n1){
    80004408:	02999563          	bne	s3,s1,80004432 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000440c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004410:	015a5963          	bge	s4,s5,80004422 <filewrite+0xda>
      int n1 = n - i;
    80004414:	414a87bb          	subw	a5,s5,s4
    80004418:	89be                	mv	s3,a5
      if(n1 > max)
    8000441a:	fafbd8e3          	bge	s7,a5,800043ca <filewrite+0x82>
    8000441e:	89e6                	mv	s3,s9
    80004420:	b76d                	j	800043ca <filewrite+0x82>
    80004422:	64a6                	ld	s1,72(sp)
    80004424:	79e2                	ld	s3,56(sp)
    80004426:	6be2                	ld	s7,24(sp)
    80004428:	6c42                	ld	s8,16(sp)
    8000442a:	6ca2                	ld	s9,8(sp)
    8000442c:	a801                	j	8000443c <filewrite+0xf4>
    int i = 0;
    8000442e:	4a01                	li	s4,0
    80004430:	a031                	j	8000443c <filewrite+0xf4>
    80004432:	64a6                	ld	s1,72(sp)
    80004434:	79e2                	ld	s3,56(sp)
    80004436:	6be2                	ld	s7,24(sp)
    80004438:	6c42                	ld	s8,16(sp)
    8000443a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000443c:	034a9d63          	bne	s5,s4,80004476 <filewrite+0x12e>
    80004440:	8556                	mv	a0,s5
    80004442:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004444:	60e6                	ld	ra,88(sp)
    80004446:	6446                	ld	s0,80(sp)
    80004448:	6906                	ld	s2,64(sp)
    8000444a:	7aa2                	ld	s5,40(sp)
    8000444c:	7b02                	ld	s6,32(sp)
    8000444e:	6125                	addi	sp,sp,96
    80004450:	8082                	ret
    80004452:	e4a6                	sd	s1,72(sp)
    80004454:	fc4e                	sd	s3,56(sp)
    80004456:	f852                	sd	s4,48(sp)
    80004458:	ec5e                	sd	s7,24(sp)
    8000445a:	e862                	sd	s8,16(sp)
    8000445c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000445e:	00003517          	auipc	a0,0x3
    80004462:	14a50513          	addi	a0,a0,330 # 800075a8 <etext+0x5a8>
    80004466:	bbefc0ef          	jal	80000824 <panic>
    return -1;
    8000446a:	557d                	li	a0,-1
}
    8000446c:	8082                	ret
      return -1;
    8000446e:	557d                	li	a0,-1
    80004470:	bfd1                	j	80004444 <filewrite+0xfc>
    80004472:	557d                	li	a0,-1
    80004474:	bfc1                	j	80004444 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004476:	557d                	li	a0,-1
    80004478:	7a42                	ld	s4,48(sp)
    8000447a:	b7e9                	j	80004444 <filewrite+0xfc>

000000008000447c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000447c:	7179                	addi	sp,sp,-48
    8000447e:	f406                	sd	ra,40(sp)
    80004480:	f022                	sd	s0,32(sp)
    80004482:	ec26                	sd	s1,24(sp)
    80004484:	e052                	sd	s4,0(sp)
    80004486:	1800                	addi	s0,sp,48
    80004488:	84aa                	mv	s1,a0
    8000448a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000448c:	0005b023          	sd	zero,0(a1)
    80004490:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004494:	c29ff0ef          	jal	800040bc <filealloc>
    80004498:	e088                	sd	a0,0(s1)
    8000449a:	c549                	beqz	a0,80004524 <pipealloc+0xa8>
    8000449c:	c21ff0ef          	jal	800040bc <filealloc>
    800044a0:	00aa3023          	sd	a0,0(s4)
    800044a4:	cd25                	beqz	a0,8000451c <pipealloc+0xa0>
    800044a6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800044a8:	e9cfc0ef          	jal	80000b44 <kalloc>
    800044ac:	892a                	mv	s2,a0
    800044ae:	c12d                	beqz	a0,80004510 <pipealloc+0x94>
    800044b0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800044b2:	4985                	li	s3,1
    800044b4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800044b8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800044bc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800044c0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800044c4:	00003597          	auipc	a1,0x3
    800044c8:	0f458593          	addi	a1,a1,244 # 800075b8 <etext+0x5b8>
    800044cc:	ed2fc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    800044d0:	609c                	ld	a5,0(s1)
    800044d2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800044d6:	609c                	ld	a5,0(s1)
    800044d8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800044dc:	609c                	ld	a5,0(s1)
    800044de:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800044e2:	609c                	ld	a5,0(s1)
    800044e4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800044e8:	000a3783          	ld	a5,0(s4)
    800044ec:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800044f0:	000a3783          	ld	a5,0(s4)
    800044f4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800044f8:	000a3783          	ld	a5,0(s4)
    800044fc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004500:	000a3783          	ld	a5,0(s4)
    80004504:	0127b823          	sd	s2,16(a5)
  return 0;
    80004508:	4501                	li	a0,0
    8000450a:	6942                	ld	s2,16(sp)
    8000450c:	69a2                	ld	s3,8(sp)
    8000450e:	a01d                	j	80004534 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004510:	6088                	ld	a0,0(s1)
    80004512:	c119                	beqz	a0,80004518 <pipealloc+0x9c>
    80004514:	6942                	ld	s2,16(sp)
    80004516:	a029                	j	80004520 <pipealloc+0xa4>
    80004518:	6942                	ld	s2,16(sp)
    8000451a:	a029                	j	80004524 <pipealloc+0xa8>
    8000451c:	6088                	ld	a0,0(s1)
    8000451e:	c10d                	beqz	a0,80004540 <pipealloc+0xc4>
    fileclose(*f0);
    80004520:	c41ff0ef          	jal	80004160 <fileclose>
  if(*f1)
    80004524:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004528:	557d                	li	a0,-1
  if(*f1)
    8000452a:	c789                	beqz	a5,80004534 <pipealloc+0xb8>
    fileclose(*f1);
    8000452c:	853e                	mv	a0,a5
    8000452e:	c33ff0ef          	jal	80004160 <fileclose>
  return -1;
    80004532:	557d                	li	a0,-1
}
    80004534:	70a2                	ld	ra,40(sp)
    80004536:	7402                	ld	s0,32(sp)
    80004538:	64e2                	ld	s1,24(sp)
    8000453a:	6a02                	ld	s4,0(sp)
    8000453c:	6145                	addi	sp,sp,48
    8000453e:	8082                	ret
  return -1;
    80004540:	557d                	li	a0,-1
    80004542:	bfcd                	j	80004534 <pipealloc+0xb8>

0000000080004544 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004544:	1101                	addi	sp,sp,-32
    80004546:	ec06                	sd	ra,24(sp)
    80004548:	e822                	sd	s0,16(sp)
    8000454a:	e426                	sd	s1,8(sp)
    8000454c:	e04a                	sd	s2,0(sp)
    8000454e:	1000                	addi	s0,sp,32
    80004550:	84aa                	mv	s1,a0
    80004552:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004554:	ed4fc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004558:	02090763          	beqz	s2,80004586 <pipeclose+0x42>
    pi->writeopen = 0;
    8000455c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004560:	21848513          	addi	a0,s1,536
    80004564:	a27fd0ef          	jal	80001f8a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004568:	2204a783          	lw	a5,544(s1)
    8000456c:	e781                	bnez	a5,80004574 <pipeclose+0x30>
    8000456e:	2244a783          	lw	a5,548(s1)
    80004572:	c38d                	beqz	a5,80004594 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004574:	8526                	mv	a0,s1
    80004576:	f46fc0ef          	jal	80000cbc <release>
}
    8000457a:	60e2                	ld	ra,24(sp)
    8000457c:	6442                	ld	s0,16(sp)
    8000457e:	64a2                	ld	s1,8(sp)
    80004580:	6902                	ld	s2,0(sp)
    80004582:	6105                	addi	sp,sp,32
    80004584:	8082                	ret
    pi->readopen = 0;
    80004586:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000458a:	21c48513          	addi	a0,s1,540
    8000458e:	9fdfd0ef          	jal	80001f8a <wakeup>
    80004592:	bfd9                	j	80004568 <pipeclose+0x24>
    release(&pi->lock);
    80004594:	8526                	mv	a0,s1
    80004596:	f26fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    8000459a:	8526                	mv	a0,s1
    8000459c:	cc0fc0ef          	jal	80000a5c <kfree>
    800045a0:	bfe9                	j	8000457a <pipeclose+0x36>

00000000800045a2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800045a2:	7159                	addi	sp,sp,-112
    800045a4:	f486                	sd	ra,104(sp)
    800045a6:	f0a2                	sd	s0,96(sp)
    800045a8:	eca6                	sd	s1,88(sp)
    800045aa:	e8ca                	sd	s2,80(sp)
    800045ac:	e4ce                	sd	s3,72(sp)
    800045ae:	e0d2                	sd	s4,64(sp)
    800045b0:	fc56                	sd	s5,56(sp)
    800045b2:	1880                	addi	s0,sp,112
    800045b4:	84aa                	mv	s1,a0
    800045b6:	8aae                	mv	s5,a1
    800045b8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800045ba:	b74fd0ef          	jal	8000192e <myproc>
    800045be:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800045c0:	8526                	mv	a0,s1
    800045c2:	e66fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    800045c6:	0d405263          	blez	s4,8000468a <pipewrite+0xe8>
    800045ca:	f85a                	sd	s6,48(sp)
    800045cc:	f45e                	sd	s7,40(sp)
    800045ce:	f062                	sd	s8,32(sp)
    800045d0:	ec66                	sd	s9,24(sp)
    800045d2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800045d4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800045d6:	f9f40c13          	addi	s8,s0,-97
    800045da:	4b85                	li	s7,1
    800045dc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800045de:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800045e2:	21c48c93          	addi	s9,s1,540
    800045e6:	a82d                	j	80004620 <pipewrite+0x7e>
      release(&pi->lock);
    800045e8:	8526                	mv	a0,s1
    800045ea:	ed2fc0ef          	jal	80000cbc <release>
      return -1;
    800045ee:	597d                	li	s2,-1
    800045f0:	7b42                	ld	s6,48(sp)
    800045f2:	7ba2                	ld	s7,40(sp)
    800045f4:	7c02                	ld	s8,32(sp)
    800045f6:	6ce2                	ld	s9,24(sp)
    800045f8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800045fa:	854a                	mv	a0,s2
    800045fc:	70a6                	ld	ra,104(sp)
    800045fe:	7406                	ld	s0,96(sp)
    80004600:	64e6                	ld	s1,88(sp)
    80004602:	6946                	ld	s2,80(sp)
    80004604:	69a6                	ld	s3,72(sp)
    80004606:	6a06                	ld	s4,64(sp)
    80004608:	7ae2                	ld	s5,56(sp)
    8000460a:	6165                	addi	sp,sp,112
    8000460c:	8082                	ret
      wakeup(&pi->nread);
    8000460e:	856a                	mv	a0,s10
    80004610:	97bfd0ef          	jal	80001f8a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004614:	85a6                	mv	a1,s1
    80004616:	8566                	mv	a0,s9
    80004618:	927fd0ef          	jal	80001f3e <sleep>
  while(i < n){
    8000461c:	05495a63          	bge	s2,s4,80004670 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004620:	2204a783          	lw	a5,544(s1)
    80004624:	d3f1                	beqz	a5,800045e8 <pipewrite+0x46>
    80004626:	854e                	mv	a0,s3
    80004628:	b53fd0ef          	jal	8000217a <killed>
    8000462c:	fd55                	bnez	a0,800045e8 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000462e:	2184a783          	lw	a5,536(s1)
    80004632:	21c4a703          	lw	a4,540(s1)
    80004636:	2007879b          	addiw	a5,a5,512
    8000463a:	fcf70ae3          	beq	a4,a5,8000460e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000463e:	86de                	mv	a3,s7
    80004640:	01590633          	add	a2,s2,s5
    80004644:	85e2                	mv	a1,s8
    80004646:	0509b503          	ld	a0,80(s3)
    8000464a:	8c8fd0ef          	jal	80001712 <copyin>
    8000464e:	05650063          	beq	a0,s6,8000468e <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004652:	21c4a783          	lw	a5,540(s1)
    80004656:	0017871b          	addiw	a4,a5,1
    8000465a:	20e4ae23          	sw	a4,540(s1)
    8000465e:	1ff7f793          	andi	a5,a5,511
    80004662:	97a6                	add	a5,a5,s1
    80004664:	f9f44703          	lbu	a4,-97(s0)
    80004668:	00e78c23          	sb	a4,24(a5)
      i++;
    8000466c:	2905                	addiw	s2,s2,1
    8000466e:	b77d                	j	8000461c <pipewrite+0x7a>
    80004670:	7b42                	ld	s6,48(sp)
    80004672:	7ba2                	ld	s7,40(sp)
    80004674:	7c02                	ld	s8,32(sp)
    80004676:	6ce2                	ld	s9,24(sp)
    80004678:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000467a:	21848513          	addi	a0,s1,536
    8000467e:	90dfd0ef          	jal	80001f8a <wakeup>
  release(&pi->lock);
    80004682:	8526                	mv	a0,s1
    80004684:	e38fc0ef          	jal	80000cbc <release>
  return i;
    80004688:	bf8d                	j	800045fa <pipewrite+0x58>
  int i = 0;
    8000468a:	4901                	li	s2,0
    8000468c:	b7fd                	j	8000467a <pipewrite+0xd8>
    8000468e:	7b42                	ld	s6,48(sp)
    80004690:	7ba2                	ld	s7,40(sp)
    80004692:	7c02                	ld	s8,32(sp)
    80004694:	6ce2                	ld	s9,24(sp)
    80004696:	6d42                	ld	s10,16(sp)
    80004698:	b7cd                	j	8000467a <pipewrite+0xd8>

000000008000469a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000469a:	711d                	addi	sp,sp,-96
    8000469c:	ec86                	sd	ra,88(sp)
    8000469e:	e8a2                	sd	s0,80(sp)
    800046a0:	e4a6                	sd	s1,72(sp)
    800046a2:	e0ca                	sd	s2,64(sp)
    800046a4:	fc4e                	sd	s3,56(sp)
    800046a6:	f852                	sd	s4,48(sp)
    800046a8:	f456                	sd	s5,40(sp)
    800046aa:	1080                	addi	s0,sp,96
    800046ac:	84aa                	mv	s1,a0
    800046ae:	892e                	mv	s2,a1
    800046b0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800046b2:	a7cfd0ef          	jal	8000192e <myproc>
    800046b6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800046b8:	8526                	mv	a0,s1
    800046ba:	d6efc0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046be:	2184a703          	lw	a4,536(s1)
    800046c2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046c6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046ca:	02f71763          	bne	a4,a5,800046f8 <piperead+0x5e>
    800046ce:	2244a783          	lw	a5,548(s1)
    800046d2:	cf85                	beqz	a5,8000470a <piperead+0x70>
    if(killed(pr)){
    800046d4:	8552                	mv	a0,s4
    800046d6:	aa5fd0ef          	jal	8000217a <killed>
    800046da:	e11d                	bnez	a0,80004700 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046dc:	85a6                	mv	a1,s1
    800046de:	854e                	mv	a0,s3
    800046e0:	85ffd0ef          	jal	80001f3e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046e4:	2184a703          	lw	a4,536(s1)
    800046e8:	21c4a783          	lw	a5,540(s1)
    800046ec:	fef701e3          	beq	a4,a5,800046ce <piperead+0x34>
    800046f0:	f05a                	sd	s6,32(sp)
    800046f2:	ec5e                	sd	s7,24(sp)
    800046f4:	e862                	sd	s8,16(sp)
    800046f6:	a829                	j	80004710 <piperead+0x76>
    800046f8:	f05a                	sd	s6,32(sp)
    800046fa:	ec5e                	sd	s7,24(sp)
    800046fc:	e862                	sd	s8,16(sp)
    800046fe:	a809                	j	80004710 <piperead+0x76>
      release(&pi->lock);
    80004700:	8526                	mv	a0,s1
    80004702:	dbafc0ef          	jal	80000cbc <release>
      return -1;
    80004706:	59fd                	li	s3,-1
    80004708:	a0a5                	j	80004770 <piperead+0xd6>
    8000470a:	f05a                	sd	s6,32(sp)
    8000470c:	ec5e                	sd	s7,24(sp)
    8000470e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004710:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004712:	faf40c13          	addi	s8,s0,-81
    80004716:	4b85                	li	s7,1
    80004718:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000471a:	05505163          	blez	s5,8000475c <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000471e:	2184a783          	lw	a5,536(s1)
    80004722:	21c4a703          	lw	a4,540(s1)
    80004726:	02f70b63          	beq	a4,a5,8000475c <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    8000472a:	1ff7f793          	andi	a5,a5,511
    8000472e:	97a6                	add	a5,a5,s1
    80004730:	0187c783          	lbu	a5,24(a5)
    80004734:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004738:	86de                	mv	a3,s7
    8000473a:	8662                	mv	a2,s8
    8000473c:	85ca                	mv	a1,s2
    8000473e:	050a3503          	ld	a0,80(s4)
    80004742:	f13fc0ef          	jal	80001654 <copyout>
    80004746:	03650f63          	beq	a0,s6,80004784 <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000474a:	2184a783          	lw	a5,536(s1)
    8000474e:	2785                	addiw	a5,a5,1
    80004750:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004754:	2985                	addiw	s3,s3,1
    80004756:	0905                	addi	s2,s2,1
    80004758:	fd3a93e3          	bne	s5,s3,8000471e <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000475c:	21c48513          	addi	a0,s1,540
    80004760:	82bfd0ef          	jal	80001f8a <wakeup>
  release(&pi->lock);
    80004764:	8526                	mv	a0,s1
    80004766:	d56fc0ef          	jal	80000cbc <release>
    8000476a:	7b02                	ld	s6,32(sp)
    8000476c:	6be2                	ld	s7,24(sp)
    8000476e:	6c42                	ld	s8,16(sp)
  return i;
}
    80004770:	854e                	mv	a0,s3
    80004772:	60e6                	ld	ra,88(sp)
    80004774:	6446                	ld	s0,80(sp)
    80004776:	64a6                	ld	s1,72(sp)
    80004778:	6906                	ld	s2,64(sp)
    8000477a:	79e2                	ld	s3,56(sp)
    8000477c:	7a42                	ld	s4,48(sp)
    8000477e:	7aa2                	ld	s5,40(sp)
    80004780:	6125                	addi	sp,sp,96
    80004782:	8082                	ret
      if(i == 0)
    80004784:	fc099ce3          	bnez	s3,8000475c <piperead+0xc2>
        i = -1;
    80004788:	89aa                	mv	s3,a0
    8000478a:	bfc9                	j	8000475c <piperead+0xc2>

000000008000478c <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    8000478c:	1141                	addi	sp,sp,-16
    8000478e:	e406                	sd	ra,8(sp)
    80004790:	e022                	sd	s0,0(sp)
    80004792:	0800                	addi	s0,sp,16
    80004794:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004796:	0035151b          	slliw	a0,a0,0x3
    8000479a:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000479c:	8b89                	andi	a5,a5,2
    8000479e:	c399                	beqz	a5,800047a4 <flags2perm+0x18>
      perm |= PTE_W;
    800047a0:	00456513          	ori	a0,a0,4
    return perm;
}
    800047a4:	60a2                	ld	ra,8(sp)
    800047a6:	6402                	ld	s0,0(sp)
    800047a8:	0141                	addi	sp,sp,16
    800047aa:	8082                	ret

00000000800047ac <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800047ac:	de010113          	addi	sp,sp,-544
    800047b0:	20113c23          	sd	ra,536(sp)
    800047b4:	20813823          	sd	s0,528(sp)
    800047b8:	20913423          	sd	s1,520(sp)
    800047bc:	21213023          	sd	s2,512(sp)
    800047c0:	1400                	addi	s0,sp,544
    800047c2:	892a                	mv	s2,a0
    800047c4:	dea43823          	sd	a0,-528(s0)
    800047c8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047cc:	962fd0ef          	jal	8000192e <myproc>
    800047d0:	84aa                	mv	s1,a0

  begin_op();
    800047d2:	d6aff0ef          	jal	80003d3c <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800047d6:	854a                	mv	a0,s2
    800047d8:	b86ff0ef          	jal	80003b5e <namei>
    800047dc:	cd21                	beqz	a0,80004834 <kexec+0x88>
    800047de:	fbd2                	sd	s4,496(sp)
    800047e0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800047e2:	b4ffe0ef          	jal	80003330 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800047e6:	04000713          	li	a4,64
    800047ea:	4681                	li	a3,0
    800047ec:	e5040613          	addi	a2,s0,-432
    800047f0:	4581                	li	a1,0
    800047f2:	8552                	mv	a0,s4
    800047f4:	ecffe0ef          	jal	800036c2 <readi>
    800047f8:	04000793          	li	a5,64
    800047fc:	00f51a63          	bne	a0,a5,80004810 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004800:	e5042703          	lw	a4,-432(s0)
    80004804:	464c47b7          	lui	a5,0x464c4
    80004808:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000480c:	02f70863          	beq	a4,a5,8000483c <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004810:	8552                	mv	a0,s4
    80004812:	d2bfe0ef          	jal	8000353c <iunlockput>
    end_op();
    80004816:	d96ff0ef          	jal	80003dac <end_op>
  }
  return -1;
    8000481a:	557d                	li	a0,-1
    8000481c:	7a5e                	ld	s4,496(sp)
}
    8000481e:	21813083          	ld	ra,536(sp)
    80004822:	21013403          	ld	s0,528(sp)
    80004826:	20813483          	ld	s1,520(sp)
    8000482a:	20013903          	ld	s2,512(sp)
    8000482e:	22010113          	addi	sp,sp,544
    80004832:	8082                	ret
    end_op();
    80004834:	d78ff0ef          	jal	80003dac <end_op>
    return -1;
    80004838:	557d                	li	a0,-1
    8000483a:	b7d5                	j	8000481e <kexec+0x72>
    8000483c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000483e:	8526                	mv	a0,s1
    80004840:	9f8fd0ef          	jal	80001a38 <proc_pagetable>
    80004844:	8b2a                	mv	s6,a0
    80004846:	26050f63          	beqz	a0,80004ac4 <kexec+0x318>
    8000484a:	ffce                	sd	s3,504(sp)
    8000484c:	f7d6                	sd	s5,488(sp)
    8000484e:	efde                	sd	s7,472(sp)
    80004850:	ebe2                	sd	s8,464(sp)
    80004852:	e7e6                	sd	s9,456(sp)
    80004854:	e3ea                	sd	s10,448(sp)
    80004856:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004858:	e8845783          	lhu	a5,-376(s0)
    8000485c:	0e078963          	beqz	a5,8000494e <kexec+0x1a2>
    80004860:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004864:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004866:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004868:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000486c:	6c85                	lui	s9,0x1
    8000486e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004872:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004876:	6a85                	lui	s5,0x1
    80004878:	a085                	j	800048d8 <kexec+0x12c>
      panic("loadseg: address should exist");
    8000487a:	00003517          	auipc	a0,0x3
    8000487e:	d4650513          	addi	a0,a0,-698 # 800075c0 <etext+0x5c0>
    80004882:	fa3fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    80004886:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004888:	874a                	mv	a4,s2
    8000488a:	009b86bb          	addw	a3,s7,s1
    8000488e:	4581                	li	a1,0
    80004890:	8552                	mv	a0,s4
    80004892:	e31fe0ef          	jal	800036c2 <readi>
    80004896:	22a91b63          	bne	s2,a0,80004acc <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    8000489a:	009a84bb          	addw	s1,s5,s1
    8000489e:	0334f263          	bgeu	s1,s3,800048c2 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800048a2:	02049593          	slli	a1,s1,0x20
    800048a6:	9181                	srli	a1,a1,0x20
    800048a8:	95e2                	add	a1,a1,s8
    800048aa:	855a                	mv	a0,s6
    800048ac:	f7afc0ef          	jal	80001026 <walkaddr>
    800048b0:	862a                	mv	a2,a0
    if(pa == 0)
    800048b2:	d561                	beqz	a0,8000487a <kexec+0xce>
    if(sz - i < PGSIZE)
    800048b4:	409987bb          	subw	a5,s3,s1
    800048b8:	893e                	mv	s2,a5
    800048ba:	fcfcf6e3          	bgeu	s9,a5,80004886 <kexec+0xda>
    800048be:	8956                	mv	s2,s5
    800048c0:	b7d9                	j	80004886 <kexec+0xda>
    sz = sz1;
    800048c2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048c6:	2d05                	addiw	s10,s10,1
    800048c8:	e0843783          	ld	a5,-504(s0)
    800048cc:	0387869b          	addiw	a3,a5,56
    800048d0:	e8845783          	lhu	a5,-376(s0)
    800048d4:	06fd5e63          	bge	s10,a5,80004950 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048d8:	e0d43423          	sd	a3,-504(s0)
    800048dc:	876e                	mv	a4,s11
    800048de:	e1840613          	addi	a2,s0,-488
    800048e2:	4581                	li	a1,0
    800048e4:	8552                	mv	a0,s4
    800048e6:	dddfe0ef          	jal	800036c2 <readi>
    800048ea:	1db51f63          	bne	a0,s11,80004ac8 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    800048ee:	e1842783          	lw	a5,-488(s0)
    800048f2:	4705                	li	a4,1
    800048f4:	fce799e3          	bne	a5,a4,800048c6 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    800048f8:	e4043483          	ld	s1,-448(s0)
    800048fc:	e3843783          	ld	a5,-456(s0)
    80004900:	1ef4e463          	bltu	s1,a5,80004ae8 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004904:	e2843783          	ld	a5,-472(s0)
    80004908:	94be                	add	s1,s1,a5
    8000490a:	1ef4e263          	bltu	s1,a5,80004aee <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    8000490e:	de843703          	ld	a4,-536(s0)
    80004912:	8ff9                	and	a5,a5,a4
    80004914:	1e079063          	bnez	a5,80004af4 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004918:	e1c42503          	lw	a0,-484(s0)
    8000491c:	e71ff0ef          	jal	8000478c <flags2perm>
    80004920:	86aa                	mv	a3,a0
    80004922:	8626                	mv	a2,s1
    80004924:	85ca                	mv	a1,s2
    80004926:	855a                	mv	a0,s6
    80004928:	9d5fc0ef          	jal	800012fc <uvmalloc>
    8000492c:	dea43c23          	sd	a0,-520(s0)
    80004930:	1c050563          	beqz	a0,80004afa <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004934:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004938:	00098863          	beqz	s3,80004948 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000493c:	e2843c03          	ld	s8,-472(s0)
    80004940:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004944:	4481                	li	s1,0
    80004946:	bfb1                	j	800048a2 <kexec+0xf6>
    sz = sz1;
    80004948:	df843903          	ld	s2,-520(s0)
    8000494c:	bfad                	j	800048c6 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000494e:	4901                	li	s2,0
  iunlockput(ip);
    80004950:	8552                	mv	a0,s4
    80004952:	bebfe0ef          	jal	8000353c <iunlockput>
  end_op();
    80004956:	c56ff0ef          	jal	80003dac <end_op>
  p = myproc();
    8000495a:	fd5fc0ef          	jal	8000192e <myproc>
    8000495e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004960:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004964:	6985                	lui	s3,0x1
    80004966:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004968:	99ca                	add	s3,s3,s2
    8000496a:	77fd                	lui	a5,0xfffff
    8000496c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004970:	4691                	li	a3,4
    80004972:	6609                	lui	a2,0x2
    80004974:	964e                	add	a2,a2,s3
    80004976:	85ce                	mv	a1,s3
    80004978:	855a                	mv	a0,s6
    8000497a:	983fc0ef          	jal	800012fc <uvmalloc>
    8000497e:	8a2a                	mv	s4,a0
    80004980:	e105                	bnez	a0,800049a0 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80004982:	85ce                	mv	a1,s3
    80004984:	855a                	mv	a0,s6
    80004986:	936fd0ef          	jal	80001abc <proc_freepagetable>
  return -1;
    8000498a:	557d                	li	a0,-1
    8000498c:	79fe                	ld	s3,504(sp)
    8000498e:	7a5e                	ld	s4,496(sp)
    80004990:	7abe                	ld	s5,488(sp)
    80004992:	7b1e                	ld	s6,480(sp)
    80004994:	6bfe                	ld	s7,472(sp)
    80004996:	6c5e                	ld	s8,464(sp)
    80004998:	6cbe                	ld	s9,456(sp)
    8000499a:	6d1e                	ld	s10,448(sp)
    8000499c:	7dfa                	ld	s11,440(sp)
    8000499e:	b541                	j	8000481e <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800049a0:	75f9                	lui	a1,0xffffe
    800049a2:	95aa                	add	a1,a1,a0
    800049a4:	855a                	mv	a0,s6
    800049a6:	b29fc0ef          	jal	800014ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800049aa:	800a0b93          	addi	s7,s4,-2048
    800049ae:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800049b2:	e0043783          	ld	a5,-512(s0)
    800049b6:	6388                	ld	a0,0(a5)
  sp = sz;
    800049b8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800049ba:	4481                	li	s1,0
    ustack[argc] = sp;
    800049bc:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800049c0:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800049c4:	cd21                	beqz	a0,80004a1c <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    800049c6:	cbcfc0ef          	jal	80000e82 <strlen>
    800049ca:	0015079b          	addiw	a5,a0,1
    800049ce:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800049d2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800049d6:	13796563          	bltu	s2,s7,80004b00 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800049da:	e0043d83          	ld	s11,-512(s0)
    800049de:	000db983          	ld	s3,0(s11)
    800049e2:	854e                	mv	a0,s3
    800049e4:	c9efc0ef          	jal	80000e82 <strlen>
    800049e8:	0015069b          	addiw	a3,a0,1
    800049ec:	864e                	mv	a2,s3
    800049ee:	85ca                	mv	a1,s2
    800049f0:	855a                	mv	a0,s6
    800049f2:	c63fc0ef          	jal	80001654 <copyout>
    800049f6:	10054763          	bltz	a0,80004b04 <kexec+0x358>
    ustack[argc] = sp;
    800049fa:	00349793          	slli	a5,s1,0x3
    800049fe:	97e6                	add	a5,a5,s9
    80004a00:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde438>
  for(argc = 0; argv[argc]; argc++) {
    80004a04:	0485                	addi	s1,s1,1
    80004a06:	008d8793          	addi	a5,s11,8
    80004a0a:	e0f43023          	sd	a5,-512(s0)
    80004a0e:	008db503          	ld	a0,8(s11)
    80004a12:	c509                	beqz	a0,80004a1c <kexec+0x270>
    if(argc >= MAXARG)
    80004a14:	fb8499e3          	bne	s1,s8,800049c6 <kexec+0x21a>
  sz = sz1;
    80004a18:	89d2                	mv	s3,s4
    80004a1a:	b7a5                	j	80004982 <kexec+0x1d6>
  ustack[argc] = 0;
    80004a1c:	00349793          	slli	a5,s1,0x3
    80004a20:	f9078793          	addi	a5,a5,-112
    80004a24:	97a2                	add	a5,a5,s0
    80004a26:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004a2a:	00349693          	slli	a3,s1,0x3
    80004a2e:	06a1                	addi	a3,a3,8
    80004a30:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a34:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004a38:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004a3a:	f57964e3          	bltu	s2,s7,80004982 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004a3e:	e9040613          	addi	a2,s0,-368
    80004a42:	85ca                	mv	a1,s2
    80004a44:	855a                	mv	a0,s6
    80004a46:	c0ffc0ef          	jal	80001654 <copyout>
    80004a4a:	f2054ce3          	bltz	a0,80004982 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004a4e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004a52:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004a56:	df043783          	ld	a5,-528(s0)
    80004a5a:	0007c703          	lbu	a4,0(a5)
    80004a5e:	cf11                	beqz	a4,80004a7a <kexec+0x2ce>
    80004a60:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004a62:	02f00693          	li	a3,47
    80004a66:	a029                	j	80004a70 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004a68:	0785                	addi	a5,a5,1
    80004a6a:	fff7c703          	lbu	a4,-1(a5)
    80004a6e:	c711                	beqz	a4,80004a7a <kexec+0x2ce>
    if(*s == '/')
    80004a70:	fed71ce3          	bne	a4,a3,80004a68 <kexec+0x2bc>
      last = s+1;
    80004a74:	def43823          	sd	a5,-528(s0)
    80004a78:	bfc5                	j	80004a68 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004a7a:	4641                	li	a2,16
    80004a7c:	df043583          	ld	a1,-528(s0)
    80004a80:	158a8513          	addi	a0,s5,344
    80004a84:	bc8fc0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80004a88:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004a8c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004a90:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004a94:	058ab783          	ld	a5,88(s5)
    80004a98:	e6843703          	ld	a4,-408(s0)
    80004a9c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004a9e:	058ab783          	ld	a5,88(s5)
    80004aa2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004aa6:	85ea                	mv	a1,s10
    80004aa8:	814fd0ef          	jal	80001abc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004aac:	0004851b          	sext.w	a0,s1
    80004ab0:	79fe                	ld	s3,504(sp)
    80004ab2:	7a5e                	ld	s4,496(sp)
    80004ab4:	7abe                	ld	s5,488(sp)
    80004ab6:	7b1e                	ld	s6,480(sp)
    80004ab8:	6bfe                	ld	s7,472(sp)
    80004aba:	6c5e                	ld	s8,464(sp)
    80004abc:	6cbe                	ld	s9,456(sp)
    80004abe:	6d1e                	ld	s10,448(sp)
    80004ac0:	7dfa                	ld	s11,440(sp)
    80004ac2:	bbb1                	j	8000481e <kexec+0x72>
    80004ac4:	7b1e                	ld	s6,480(sp)
    80004ac6:	b3a9                	j	80004810 <kexec+0x64>
    80004ac8:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004acc:	df843583          	ld	a1,-520(s0)
    80004ad0:	855a                	mv	a0,s6
    80004ad2:	febfc0ef          	jal	80001abc <proc_freepagetable>
  if(ip){
    80004ad6:	79fe                	ld	s3,504(sp)
    80004ad8:	7abe                	ld	s5,488(sp)
    80004ada:	7b1e                	ld	s6,480(sp)
    80004adc:	6bfe                	ld	s7,472(sp)
    80004ade:	6c5e                	ld	s8,464(sp)
    80004ae0:	6cbe                	ld	s9,456(sp)
    80004ae2:	6d1e                	ld	s10,448(sp)
    80004ae4:	7dfa                	ld	s11,440(sp)
    80004ae6:	b32d                	j	80004810 <kexec+0x64>
    80004ae8:	df243c23          	sd	s2,-520(s0)
    80004aec:	b7c5                	j	80004acc <kexec+0x320>
    80004aee:	df243c23          	sd	s2,-520(s0)
    80004af2:	bfe9                	j	80004acc <kexec+0x320>
    80004af4:	df243c23          	sd	s2,-520(s0)
    80004af8:	bfd1                	j	80004acc <kexec+0x320>
    80004afa:	df243c23          	sd	s2,-520(s0)
    80004afe:	b7f9                	j	80004acc <kexec+0x320>
  sz = sz1;
    80004b00:	89d2                	mv	s3,s4
    80004b02:	b541                	j	80004982 <kexec+0x1d6>
    80004b04:	89d2                	mv	s3,s4
    80004b06:	bdb5                	j	80004982 <kexec+0x1d6>

0000000080004b08 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b08:	7179                	addi	sp,sp,-48
    80004b0a:	f406                	sd	ra,40(sp)
    80004b0c:	f022                	sd	s0,32(sp)
    80004b0e:	ec26                	sd	s1,24(sp)
    80004b10:	e84a                	sd	s2,16(sp)
    80004b12:	1800                	addi	s0,sp,48
    80004b14:	892e                	mv	s2,a1
    80004b16:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b18:	fdc40593          	addi	a1,s0,-36
    80004b1c:	e29fd0ef          	jal	80002944 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004b20:	fdc42703          	lw	a4,-36(s0)
    80004b24:	47bd                	li	a5,15
    80004b26:	02e7ea63          	bltu	a5,a4,80004b5a <argfd+0x52>
    80004b2a:	e05fc0ef          	jal	8000192e <myproc>
    80004b2e:	fdc42703          	lw	a4,-36(s0)
    80004b32:	00371793          	slli	a5,a4,0x3
    80004b36:	0d078793          	addi	a5,a5,208
    80004b3a:	953e                	add	a0,a0,a5
    80004b3c:	611c                	ld	a5,0(a0)
    80004b3e:	c385                	beqz	a5,80004b5e <argfd+0x56>
    return -1;
  if(pfd)
    80004b40:	00090463          	beqz	s2,80004b48 <argfd+0x40>
    *pfd = fd;
    80004b44:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004b48:	4501                	li	a0,0
  if(pf)
    80004b4a:	c091                	beqz	s1,80004b4e <argfd+0x46>
    *pf = f;
    80004b4c:	e09c                	sd	a5,0(s1)
}
    80004b4e:	70a2                	ld	ra,40(sp)
    80004b50:	7402                	ld	s0,32(sp)
    80004b52:	64e2                	ld	s1,24(sp)
    80004b54:	6942                	ld	s2,16(sp)
    80004b56:	6145                	addi	sp,sp,48
    80004b58:	8082                	ret
    return -1;
    80004b5a:	557d                	li	a0,-1
    80004b5c:	bfcd                	j	80004b4e <argfd+0x46>
    80004b5e:	557d                	li	a0,-1
    80004b60:	b7fd                	j	80004b4e <argfd+0x46>

0000000080004b62 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b62:	1101                	addi	sp,sp,-32
    80004b64:	ec06                	sd	ra,24(sp)
    80004b66:	e822                	sd	s0,16(sp)
    80004b68:	e426                	sd	s1,8(sp)
    80004b6a:	1000                	addi	s0,sp,32
    80004b6c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b6e:	dc1fc0ef          	jal	8000192e <myproc>
    80004b72:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004b74:	0d050793          	addi	a5,a0,208
    80004b78:	4501                	li	a0,0
    80004b7a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004b7c:	6398                	ld	a4,0(a5)
    80004b7e:	cb19                	beqz	a4,80004b94 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004b80:	2505                	addiw	a0,a0,1
    80004b82:	07a1                	addi	a5,a5,8
    80004b84:	fed51ce3          	bne	a0,a3,80004b7c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004b88:	557d                	li	a0,-1
}
    80004b8a:	60e2                	ld	ra,24(sp)
    80004b8c:	6442                	ld	s0,16(sp)
    80004b8e:	64a2                	ld	s1,8(sp)
    80004b90:	6105                	addi	sp,sp,32
    80004b92:	8082                	ret
      p->ofile[fd] = f;
    80004b94:	00351793          	slli	a5,a0,0x3
    80004b98:	0d078793          	addi	a5,a5,208
    80004b9c:	963e                	add	a2,a2,a5
    80004b9e:	e204                	sd	s1,0(a2)
      return fd;
    80004ba0:	b7ed                	j	80004b8a <fdalloc+0x28>

0000000080004ba2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004ba2:	715d                	addi	sp,sp,-80
    80004ba4:	e486                	sd	ra,72(sp)
    80004ba6:	e0a2                	sd	s0,64(sp)
    80004ba8:	fc26                	sd	s1,56(sp)
    80004baa:	f84a                	sd	s2,48(sp)
    80004bac:	f44e                	sd	s3,40(sp)
    80004bae:	f052                	sd	s4,32(sp)
    80004bb0:	ec56                	sd	s5,24(sp)
    80004bb2:	e85a                	sd	s6,16(sp)
    80004bb4:	0880                	addi	s0,sp,80
    80004bb6:	892e                	mv	s2,a1
    80004bb8:	8a2e                	mv	s4,a1
    80004bba:	8ab2                	mv	s5,a2
    80004bbc:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004bbe:	fb040593          	addi	a1,s0,-80
    80004bc2:	fb7fe0ef          	jal	80003b78 <nameiparent>
    80004bc6:	84aa                	mv	s1,a0
    80004bc8:	10050763          	beqz	a0,80004cd6 <create+0x134>
    return 0;

  ilock(dp);
    80004bcc:	f64fe0ef          	jal	80003330 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004bd0:	4601                	li	a2,0
    80004bd2:	fb040593          	addi	a1,s0,-80
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	cf3fe0ef          	jal	800038ca <dirlookup>
    80004bdc:	89aa                	mv	s3,a0
    80004bde:	c131                	beqz	a0,80004c22 <create+0x80>
    iunlockput(dp);
    80004be0:	8526                	mv	a0,s1
    80004be2:	95bfe0ef          	jal	8000353c <iunlockput>
    ilock(ip);
    80004be6:	854e                	mv	a0,s3
    80004be8:	f48fe0ef          	jal	80003330 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004bec:	4789                	li	a5,2
    80004bee:	02f91563          	bne	s2,a5,80004c18 <create+0x76>
    80004bf2:	0449d783          	lhu	a5,68(s3)
    80004bf6:	37f9                	addiw	a5,a5,-2
    80004bf8:	17c2                	slli	a5,a5,0x30
    80004bfa:	93c1                	srli	a5,a5,0x30
    80004bfc:	4705                	li	a4,1
    80004bfe:	00f76d63          	bltu	a4,a5,80004c18 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004c02:	854e                	mv	a0,s3
    80004c04:	60a6                	ld	ra,72(sp)
    80004c06:	6406                	ld	s0,64(sp)
    80004c08:	74e2                	ld	s1,56(sp)
    80004c0a:	7942                	ld	s2,48(sp)
    80004c0c:	79a2                	ld	s3,40(sp)
    80004c0e:	7a02                	ld	s4,32(sp)
    80004c10:	6ae2                	ld	s5,24(sp)
    80004c12:	6b42                	ld	s6,16(sp)
    80004c14:	6161                	addi	sp,sp,80
    80004c16:	8082                	ret
    iunlockput(ip);
    80004c18:	854e                	mv	a0,s3
    80004c1a:	923fe0ef          	jal	8000353c <iunlockput>
    return 0;
    80004c1e:	4981                	li	s3,0
    80004c20:	b7cd                	j	80004c02 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004c22:	85ca                	mv	a1,s2
    80004c24:	4088                	lw	a0,0(s1)
    80004c26:	d9afe0ef          	jal	800031c0 <ialloc>
    80004c2a:	892a                	mv	s2,a0
    80004c2c:	cd15                	beqz	a0,80004c68 <create+0xc6>
  ilock(ip);
    80004c2e:	f02fe0ef          	jal	80003330 <ilock>
  ip->major = major;
    80004c32:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004c36:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004c3a:	4785                	li	a5,1
    80004c3c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c40:	854a                	mv	a0,s2
    80004c42:	e3afe0ef          	jal	8000327c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004c46:	4705                	li	a4,1
    80004c48:	02ea0463          	beq	s4,a4,80004c70 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c4c:	00492603          	lw	a2,4(s2)
    80004c50:	fb040593          	addi	a1,s0,-80
    80004c54:	8526                	mv	a0,s1
    80004c56:	e5ffe0ef          	jal	80003ab4 <dirlink>
    80004c5a:	06054263          	bltz	a0,80004cbe <create+0x11c>
  iunlockput(dp);
    80004c5e:	8526                	mv	a0,s1
    80004c60:	8ddfe0ef          	jal	8000353c <iunlockput>
  return ip;
    80004c64:	89ca                	mv	s3,s2
    80004c66:	bf71                	j	80004c02 <create+0x60>
    iunlockput(dp);
    80004c68:	8526                	mv	a0,s1
    80004c6a:	8d3fe0ef          	jal	8000353c <iunlockput>
    return 0;
    80004c6e:	bf51                	j	80004c02 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004c70:	00492603          	lw	a2,4(s2)
    80004c74:	00003597          	auipc	a1,0x3
    80004c78:	96c58593          	addi	a1,a1,-1684 # 800075e0 <etext+0x5e0>
    80004c7c:	854a                	mv	a0,s2
    80004c7e:	e37fe0ef          	jal	80003ab4 <dirlink>
    80004c82:	02054e63          	bltz	a0,80004cbe <create+0x11c>
    80004c86:	40d0                	lw	a2,4(s1)
    80004c88:	00003597          	auipc	a1,0x3
    80004c8c:	96058593          	addi	a1,a1,-1696 # 800075e8 <etext+0x5e8>
    80004c90:	854a                	mv	a0,s2
    80004c92:	e23fe0ef          	jal	80003ab4 <dirlink>
    80004c96:	02054463          	bltz	a0,80004cbe <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c9a:	00492603          	lw	a2,4(s2)
    80004c9e:	fb040593          	addi	a1,s0,-80
    80004ca2:	8526                	mv	a0,s1
    80004ca4:	e11fe0ef          	jal	80003ab4 <dirlink>
    80004ca8:	00054b63          	bltz	a0,80004cbe <create+0x11c>
    dp->nlink++;  // for ".."
    80004cac:	04a4d783          	lhu	a5,74(s1)
    80004cb0:	2785                	addiw	a5,a5,1
    80004cb2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	dc4fe0ef          	jal	8000327c <iupdate>
    80004cbc:	b74d                	j	80004c5e <create+0xbc>
  ip->nlink = 0;
    80004cbe:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	db8fe0ef          	jal	8000327c <iupdate>
  iunlockput(ip);
    80004cc8:	854a                	mv	a0,s2
    80004cca:	873fe0ef          	jal	8000353c <iunlockput>
  iunlockput(dp);
    80004cce:	8526                	mv	a0,s1
    80004cd0:	86dfe0ef          	jal	8000353c <iunlockput>
  return 0;
    80004cd4:	b73d                	j	80004c02 <create+0x60>
    return 0;
    80004cd6:	89aa                	mv	s3,a0
    80004cd8:	b72d                	j	80004c02 <create+0x60>

0000000080004cda <sys_dup>:
{
    80004cda:	7179                	addi	sp,sp,-48
    80004cdc:	f406                	sd	ra,40(sp)
    80004cde:	f022                	sd	s0,32(sp)
    80004ce0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004ce2:	fd840613          	addi	a2,s0,-40
    80004ce6:	4581                	li	a1,0
    80004ce8:	4501                	li	a0,0
    80004cea:	e1fff0ef          	jal	80004b08 <argfd>
    return -1;
    80004cee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004cf0:	02054363          	bltz	a0,80004d16 <sys_dup+0x3c>
    80004cf4:	ec26                	sd	s1,24(sp)
    80004cf6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004cf8:	fd843483          	ld	s1,-40(s0)
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	e65ff0ef          	jal	80004b62 <fdalloc>
    80004d02:	892a                	mv	s2,a0
    return -1;
    80004d04:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004d06:	00054d63          	bltz	a0,80004d20 <sys_dup+0x46>
  filedup(f);
    80004d0a:	8526                	mv	a0,s1
    80004d0c:	c0eff0ef          	jal	8000411a <filedup>
  return fd;
    80004d10:	87ca                	mv	a5,s2
    80004d12:	64e2                	ld	s1,24(sp)
    80004d14:	6942                	ld	s2,16(sp)
}
    80004d16:	853e                	mv	a0,a5
    80004d18:	70a2                	ld	ra,40(sp)
    80004d1a:	7402                	ld	s0,32(sp)
    80004d1c:	6145                	addi	sp,sp,48
    80004d1e:	8082                	ret
    80004d20:	64e2                	ld	s1,24(sp)
    80004d22:	6942                	ld	s2,16(sp)
    80004d24:	bfcd                	j	80004d16 <sys_dup+0x3c>

0000000080004d26 <sys_read>:
{
    80004d26:	7179                	addi	sp,sp,-48
    80004d28:	f406                	sd	ra,40(sp)
    80004d2a:	f022                	sd	s0,32(sp)
    80004d2c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d2e:	fd840593          	addi	a1,s0,-40
    80004d32:	4505                	li	a0,1
    80004d34:	c2dfd0ef          	jal	80002960 <argaddr>
  argint(2, &n);
    80004d38:	fe440593          	addi	a1,s0,-28
    80004d3c:	4509                	li	a0,2
    80004d3e:	c07fd0ef          	jal	80002944 <argint>
  if(argfd(0, 0, &f) < 0)
    80004d42:	fe840613          	addi	a2,s0,-24
    80004d46:	4581                	li	a1,0
    80004d48:	4501                	li	a0,0
    80004d4a:	dbfff0ef          	jal	80004b08 <argfd>
    80004d4e:	87aa                	mv	a5,a0
    return -1;
    80004d50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d52:	0007ca63          	bltz	a5,80004d66 <sys_read+0x40>
  return fileread(f, p, n);
    80004d56:	fe442603          	lw	a2,-28(s0)
    80004d5a:	fd843583          	ld	a1,-40(s0)
    80004d5e:	fe843503          	ld	a0,-24(s0)
    80004d62:	d22ff0ef          	jal	80004284 <fileread>
}
    80004d66:	70a2                	ld	ra,40(sp)
    80004d68:	7402                	ld	s0,32(sp)
    80004d6a:	6145                	addi	sp,sp,48
    80004d6c:	8082                	ret

0000000080004d6e <sys_write>:
{
    80004d6e:	7179                	addi	sp,sp,-48
    80004d70:	f406                	sd	ra,40(sp)
    80004d72:	f022                	sd	s0,32(sp)
    80004d74:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d76:	fd840593          	addi	a1,s0,-40
    80004d7a:	4505                	li	a0,1
    80004d7c:	be5fd0ef          	jal	80002960 <argaddr>
  argint(2, &n);
    80004d80:	fe440593          	addi	a1,s0,-28
    80004d84:	4509                	li	a0,2
    80004d86:	bbffd0ef          	jal	80002944 <argint>
  if(argfd(0, 0, &f) < 0)
    80004d8a:	fe840613          	addi	a2,s0,-24
    80004d8e:	4581                	li	a1,0
    80004d90:	4501                	li	a0,0
    80004d92:	d77ff0ef          	jal	80004b08 <argfd>
    80004d96:	87aa                	mv	a5,a0
    return -1;
    80004d98:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d9a:	0007ca63          	bltz	a5,80004dae <sys_write+0x40>
  return filewrite(f, p, n);
    80004d9e:	fe442603          	lw	a2,-28(s0)
    80004da2:	fd843583          	ld	a1,-40(s0)
    80004da6:	fe843503          	ld	a0,-24(s0)
    80004daa:	d9eff0ef          	jal	80004348 <filewrite>
}
    80004dae:	70a2                	ld	ra,40(sp)
    80004db0:	7402                	ld	s0,32(sp)
    80004db2:	6145                	addi	sp,sp,48
    80004db4:	8082                	ret

0000000080004db6 <sys_close>:
{
    80004db6:	1101                	addi	sp,sp,-32
    80004db8:	ec06                	sd	ra,24(sp)
    80004dba:	e822                	sd	s0,16(sp)
    80004dbc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004dbe:	fe040613          	addi	a2,s0,-32
    80004dc2:	fec40593          	addi	a1,s0,-20
    80004dc6:	4501                	li	a0,0
    80004dc8:	d41ff0ef          	jal	80004b08 <argfd>
    return -1;
    80004dcc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004dce:	02054163          	bltz	a0,80004df0 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004dd2:	b5dfc0ef          	jal	8000192e <myproc>
    80004dd6:	fec42783          	lw	a5,-20(s0)
    80004dda:	078e                	slli	a5,a5,0x3
    80004ddc:	0d078793          	addi	a5,a5,208
    80004de0:	953e                	add	a0,a0,a5
    80004de2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004de6:	fe043503          	ld	a0,-32(s0)
    80004dea:	b76ff0ef          	jal	80004160 <fileclose>
  return 0;
    80004dee:	4781                	li	a5,0
}
    80004df0:	853e                	mv	a0,a5
    80004df2:	60e2                	ld	ra,24(sp)
    80004df4:	6442                	ld	s0,16(sp)
    80004df6:	6105                	addi	sp,sp,32
    80004df8:	8082                	ret

0000000080004dfa <sys_fstat>:
{
    80004dfa:	1101                	addi	sp,sp,-32
    80004dfc:	ec06                	sd	ra,24(sp)
    80004dfe:	e822                	sd	s0,16(sp)
    80004e00:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004e02:	fe040593          	addi	a1,s0,-32
    80004e06:	4505                	li	a0,1
    80004e08:	b59fd0ef          	jal	80002960 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004e0c:	fe840613          	addi	a2,s0,-24
    80004e10:	4581                	li	a1,0
    80004e12:	4501                	li	a0,0
    80004e14:	cf5ff0ef          	jal	80004b08 <argfd>
    80004e18:	87aa                	mv	a5,a0
    return -1;
    80004e1a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e1c:	0007c863          	bltz	a5,80004e2c <sys_fstat+0x32>
  return filestat(f, st);
    80004e20:	fe043583          	ld	a1,-32(s0)
    80004e24:	fe843503          	ld	a0,-24(s0)
    80004e28:	bfaff0ef          	jal	80004222 <filestat>
}
    80004e2c:	60e2                	ld	ra,24(sp)
    80004e2e:	6442                	ld	s0,16(sp)
    80004e30:	6105                	addi	sp,sp,32
    80004e32:	8082                	ret

0000000080004e34 <sys_link>:
{
    80004e34:	7169                	addi	sp,sp,-304
    80004e36:	f606                	sd	ra,296(sp)
    80004e38:	f222                	sd	s0,288(sp)
    80004e3a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e3c:	08000613          	li	a2,128
    80004e40:	ed040593          	addi	a1,s0,-304
    80004e44:	4501                	li	a0,0
    80004e46:	b37fd0ef          	jal	8000297c <argstr>
    return -1;
    80004e4a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e4c:	0c054e63          	bltz	a0,80004f28 <sys_link+0xf4>
    80004e50:	08000613          	li	a2,128
    80004e54:	f5040593          	addi	a1,s0,-176
    80004e58:	4505                	li	a0,1
    80004e5a:	b23fd0ef          	jal	8000297c <argstr>
    return -1;
    80004e5e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e60:	0c054463          	bltz	a0,80004f28 <sys_link+0xf4>
    80004e64:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e66:	ed7fe0ef          	jal	80003d3c <begin_op>
  if((ip = namei(old)) == 0){
    80004e6a:	ed040513          	addi	a0,s0,-304
    80004e6e:	cf1fe0ef          	jal	80003b5e <namei>
    80004e72:	84aa                	mv	s1,a0
    80004e74:	c53d                	beqz	a0,80004ee2 <sys_link+0xae>
  ilock(ip);
    80004e76:	cbafe0ef          	jal	80003330 <ilock>
  if(ip->type == T_DIR){
    80004e7a:	04449703          	lh	a4,68(s1)
    80004e7e:	4785                	li	a5,1
    80004e80:	06f70663          	beq	a4,a5,80004eec <sys_link+0xb8>
    80004e84:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004e86:	04a4d783          	lhu	a5,74(s1)
    80004e8a:	2785                	addiw	a5,a5,1
    80004e8c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e90:	8526                	mv	a0,s1
    80004e92:	beafe0ef          	jal	8000327c <iupdate>
  iunlock(ip);
    80004e96:	8526                	mv	a0,s1
    80004e98:	d46fe0ef          	jal	800033de <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004e9c:	fd040593          	addi	a1,s0,-48
    80004ea0:	f5040513          	addi	a0,s0,-176
    80004ea4:	cd5fe0ef          	jal	80003b78 <nameiparent>
    80004ea8:	892a                	mv	s2,a0
    80004eaa:	cd21                	beqz	a0,80004f02 <sys_link+0xce>
  ilock(dp);
    80004eac:	c84fe0ef          	jal	80003330 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004eb0:	854a                	mv	a0,s2
    80004eb2:	00092703          	lw	a4,0(s2)
    80004eb6:	409c                	lw	a5,0(s1)
    80004eb8:	04f71263          	bne	a4,a5,80004efc <sys_link+0xc8>
    80004ebc:	40d0                	lw	a2,4(s1)
    80004ebe:	fd040593          	addi	a1,s0,-48
    80004ec2:	bf3fe0ef          	jal	80003ab4 <dirlink>
    80004ec6:	02054b63          	bltz	a0,80004efc <sys_link+0xc8>
  iunlockput(dp);
    80004eca:	854a                	mv	a0,s2
    80004ecc:	e70fe0ef          	jal	8000353c <iunlockput>
  iput(ip);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	de0fe0ef          	jal	800034b2 <iput>
  end_op();
    80004ed6:	ed7fe0ef          	jal	80003dac <end_op>
  return 0;
    80004eda:	4781                	li	a5,0
    80004edc:	64f2                	ld	s1,280(sp)
    80004ede:	6952                	ld	s2,272(sp)
    80004ee0:	a0a1                	j	80004f28 <sys_link+0xf4>
    end_op();
    80004ee2:	ecbfe0ef          	jal	80003dac <end_op>
    return -1;
    80004ee6:	57fd                	li	a5,-1
    80004ee8:	64f2                	ld	s1,280(sp)
    80004eea:	a83d                	j	80004f28 <sys_link+0xf4>
    iunlockput(ip);
    80004eec:	8526                	mv	a0,s1
    80004eee:	e4efe0ef          	jal	8000353c <iunlockput>
    end_op();
    80004ef2:	ebbfe0ef          	jal	80003dac <end_op>
    return -1;
    80004ef6:	57fd                	li	a5,-1
    80004ef8:	64f2                	ld	s1,280(sp)
    80004efa:	a03d                	j	80004f28 <sys_link+0xf4>
    iunlockput(dp);
    80004efc:	854a                	mv	a0,s2
    80004efe:	e3efe0ef          	jal	8000353c <iunlockput>
  ilock(ip);
    80004f02:	8526                	mv	a0,s1
    80004f04:	c2cfe0ef          	jal	80003330 <ilock>
  ip->nlink--;
    80004f08:	04a4d783          	lhu	a5,74(s1)
    80004f0c:	37fd                	addiw	a5,a5,-1
    80004f0e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f12:	8526                	mv	a0,s1
    80004f14:	b68fe0ef          	jal	8000327c <iupdate>
  iunlockput(ip);
    80004f18:	8526                	mv	a0,s1
    80004f1a:	e22fe0ef          	jal	8000353c <iunlockput>
  end_op();
    80004f1e:	e8ffe0ef          	jal	80003dac <end_op>
  return -1;
    80004f22:	57fd                	li	a5,-1
    80004f24:	64f2                	ld	s1,280(sp)
    80004f26:	6952                	ld	s2,272(sp)
}
    80004f28:	853e                	mv	a0,a5
    80004f2a:	70b2                	ld	ra,296(sp)
    80004f2c:	7412                	ld	s0,288(sp)
    80004f2e:	6155                	addi	sp,sp,304
    80004f30:	8082                	ret

0000000080004f32 <sys_unlink>:
{
    80004f32:	7151                	addi	sp,sp,-240
    80004f34:	f586                	sd	ra,232(sp)
    80004f36:	f1a2                	sd	s0,224(sp)
    80004f38:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004f3a:	08000613          	li	a2,128
    80004f3e:	f3040593          	addi	a1,s0,-208
    80004f42:	4501                	li	a0,0
    80004f44:	a39fd0ef          	jal	8000297c <argstr>
    80004f48:	14054d63          	bltz	a0,800050a2 <sys_unlink+0x170>
    80004f4c:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f4e:	deffe0ef          	jal	80003d3c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f52:	fb040593          	addi	a1,s0,-80
    80004f56:	f3040513          	addi	a0,s0,-208
    80004f5a:	c1ffe0ef          	jal	80003b78 <nameiparent>
    80004f5e:	84aa                	mv	s1,a0
    80004f60:	c955                	beqz	a0,80005014 <sys_unlink+0xe2>
  ilock(dp);
    80004f62:	bcefe0ef          	jal	80003330 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f66:	00002597          	auipc	a1,0x2
    80004f6a:	67a58593          	addi	a1,a1,1658 # 800075e0 <etext+0x5e0>
    80004f6e:	fb040513          	addi	a0,s0,-80
    80004f72:	943fe0ef          	jal	800038b4 <namecmp>
    80004f76:	10050b63          	beqz	a0,8000508c <sys_unlink+0x15a>
    80004f7a:	00002597          	auipc	a1,0x2
    80004f7e:	66e58593          	addi	a1,a1,1646 # 800075e8 <etext+0x5e8>
    80004f82:	fb040513          	addi	a0,s0,-80
    80004f86:	92ffe0ef          	jal	800038b4 <namecmp>
    80004f8a:	10050163          	beqz	a0,8000508c <sys_unlink+0x15a>
    80004f8e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004f90:	f2c40613          	addi	a2,s0,-212
    80004f94:	fb040593          	addi	a1,s0,-80
    80004f98:	8526                	mv	a0,s1
    80004f9a:	931fe0ef          	jal	800038ca <dirlookup>
    80004f9e:	892a                	mv	s2,a0
    80004fa0:	0e050563          	beqz	a0,8000508a <sys_unlink+0x158>
    80004fa4:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004fa6:	b8afe0ef          	jal	80003330 <ilock>
  if(ip->nlink < 1)
    80004faa:	04a91783          	lh	a5,74(s2)
    80004fae:	06f05863          	blez	a5,8000501e <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004fb2:	04491703          	lh	a4,68(s2)
    80004fb6:	4785                	li	a5,1
    80004fb8:	06f70963          	beq	a4,a5,8000502a <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004fbc:	fc040993          	addi	s3,s0,-64
    80004fc0:	4641                	li	a2,16
    80004fc2:	4581                	li	a1,0
    80004fc4:	854e                	mv	a0,s3
    80004fc6:	d33fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fca:	4741                	li	a4,16
    80004fcc:	f2c42683          	lw	a3,-212(s0)
    80004fd0:	864e                	mv	a2,s3
    80004fd2:	4581                	li	a1,0
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	fdefe0ef          	jal	800037b4 <writei>
    80004fda:	47c1                	li	a5,16
    80004fdc:	08f51863          	bne	a0,a5,8000506c <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004fe0:	04491703          	lh	a4,68(s2)
    80004fe4:	4785                	li	a5,1
    80004fe6:	08f70963          	beq	a4,a5,80005078 <sys_unlink+0x146>
  iunlockput(dp);
    80004fea:	8526                	mv	a0,s1
    80004fec:	d50fe0ef          	jal	8000353c <iunlockput>
  ip->nlink--;
    80004ff0:	04a95783          	lhu	a5,74(s2)
    80004ff4:	37fd                	addiw	a5,a5,-1
    80004ff6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ffa:	854a                	mv	a0,s2
    80004ffc:	a80fe0ef          	jal	8000327c <iupdate>
  iunlockput(ip);
    80005000:	854a                	mv	a0,s2
    80005002:	d3afe0ef          	jal	8000353c <iunlockput>
  end_op();
    80005006:	da7fe0ef          	jal	80003dac <end_op>
  return 0;
    8000500a:	4501                	li	a0,0
    8000500c:	64ee                	ld	s1,216(sp)
    8000500e:	694e                	ld	s2,208(sp)
    80005010:	69ae                	ld	s3,200(sp)
    80005012:	a061                	j	8000509a <sys_unlink+0x168>
    end_op();
    80005014:	d99fe0ef          	jal	80003dac <end_op>
    return -1;
    80005018:	557d                	li	a0,-1
    8000501a:	64ee                	ld	s1,216(sp)
    8000501c:	a8bd                	j	8000509a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000501e:	00002517          	auipc	a0,0x2
    80005022:	5d250513          	addi	a0,a0,1490 # 800075f0 <etext+0x5f0>
    80005026:	ffefb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000502a:	04c92703          	lw	a4,76(s2)
    8000502e:	02000793          	li	a5,32
    80005032:	f8e7f5e3          	bgeu	a5,a4,80004fbc <sys_unlink+0x8a>
    80005036:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005038:	4741                	li	a4,16
    8000503a:	86ce                	mv	a3,s3
    8000503c:	f1840613          	addi	a2,s0,-232
    80005040:	4581                	li	a1,0
    80005042:	854a                	mv	a0,s2
    80005044:	e7efe0ef          	jal	800036c2 <readi>
    80005048:	47c1                	li	a5,16
    8000504a:	00f51b63          	bne	a0,a5,80005060 <sys_unlink+0x12e>
    if(de.inum != 0)
    8000504e:	f1845783          	lhu	a5,-232(s0)
    80005052:	ebb1                	bnez	a5,800050a6 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005054:	29c1                	addiw	s3,s3,16
    80005056:	04c92783          	lw	a5,76(s2)
    8000505a:	fcf9efe3          	bltu	s3,a5,80005038 <sys_unlink+0x106>
    8000505e:	bfb9                	j	80004fbc <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005060:	00002517          	auipc	a0,0x2
    80005064:	5a850513          	addi	a0,a0,1448 # 80007608 <etext+0x608>
    80005068:	fbcfb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    8000506c:	00002517          	auipc	a0,0x2
    80005070:	5b450513          	addi	a0,a0,1460 # 80007620 <etext+0x620>
    80005074:	fb0fb0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005078:	04a4d783          	lhu	a5,74(s1)
    8000507c:	37fd                	addiw	a5,a5,-1
    8000507e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005082:	8526                	mv	a0,s1
    80005084:	9f8fe0ef          	jal	8000327c <iupdate>
    80005088:	b78d                	j	80004fea <sys_unlink+0xb8>
    8000508a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000508c:	8526                	mv	a0,s1
    8000508e:	caefe0ef          	jal	8000353c <iunlockput>
  end_op();
    80005092:	d1bfe0ef          	jal	80003dac <end_op>
  return -1;
    80005096:	557d                	li	a0,-1
    80005098:	64ee                	ld	s1,216(sp)
}
    8000509a:	70ae                	ld	ra,232(sp)
    8000509c:	740e                	ld	s0,224(sp)
    8000509e:	616d                	addi	sp,sp,240
    800050a0:	8082                	ret
    return -1;
    800050a2:	557d                	li	a0,-1
    800050a4:	bfdd                	j	8000509a <sys_unlink+0x168>
    iunlockput(ip);
    800050a6:	854a                	mv	a0,s2
    800050a8:	c94fe0ef          	jal	8000353c <iunlockput>
    goto bad;
    800050ac:	694e                	ld	s2,208(sp)
    800050ae:	69ae                	ld	s3,200(sp)
    800050b0:	bff1                	j	8000508c <sys_unlink+0x15a>

00000000800050b2 <sys_open>:

uint64
sys_open(void)
{
    800050b2:	7131                	addi	sp,sp,-192
    800050b4:	fd06                	sd	ra,184(sp)
    800050b6:	f922                	sd	s0,176(sp)
    800050b8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800050ba:	f4c40593          	addi	a1,s0,-180
    800050be:	4505                	li	a0,1
    800050c0:	885fd0ef          	jal	80002944 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800050c4:	08000613          	li	a2,128
    800050c8:	f5040593          	addi	a1,s0,-176
    800050cc:	4501                	li	a0,0
    800050ce:	8affd0ef          	jal	8000297c <argstr>
    800050d2:	87aa                	mv	a5,a0
    return -1;
    800050d4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800050d6:	0a07c363          	bltz	a5,8000517c <sys_open+0xca>
    800050da:	f526                	sd	s1,168(sp)

  begin_op();
    800050dc:	c61fe0ef          	jal	80003d3c <begin_op>

  if(omode & O_CREATE){
    800050e0:	f4c42783          	lw	a5,-180(s0)
    800050e4:	2007f793          	andi	a5,a5,512
    800050e8:	c3dd                	beqz	a5,8000518e <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800050ea:	4681                	li	a3,0
    800050ec:	4601                	li	a2,0
    800050ee:	4589                	li	a1,2
    800050f0:	f5040513          	addi	a0,s0,-176
    800050f4:	aafff0ef          	jal	80004ba2 <create>
    800050f8:	84aa                	mv	s1,a0
    if(ip == 0){
    800050fa:	c549                	beqz	a0,80005184 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800050fc:	04449703          	lh	a4,68(s1)
    80005100:	478d                	li	a5,3
    80005102:	00f71763          	bne	a4,a5,80005110 <sys_open+0x5e>
    80005106:	0464d703          	lhu	a4,70(s1)
    8000510a:	47a5                	li	a5,9
    8000510c:	0ae7ee63          	bltu	a5,a4,800051c8 <sys_open+0x116>
    80005110:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005112:	fabfe0ef          	jal	800040bc <filealloc>
    80005116:	892a                	mv	s2,a0
    80005118:	c561                	beqz	a0,800051e0 <sys_open+0x12e>
    8000511a:	ed4e                	sd	s3,152(sp)
    8000511c:	a47ff0ef          	jal	80004b62 <fdalloc>
    80005120:	89aa                	mv	s3,a0
    80005122:	0a054b63          	bltz	a0,800051d8 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005126:	04449703          	lh	a4,68(s1)
    8000512a:	478d                	li	a5,3
    8000512c:	0cf70363          	beq	a4,a5,800051f2 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005130:	4789                	li	a5,2
    80005132:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005136:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000513a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000513e:	f4c42783          	lw	a5,-180(s0)
    80005142:	0017f713          	andi	a4,a5,1
    80005146:	00174713          	xori	a4,a4,1
    8000514a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000514e:	0037f713          	andi	a4,a5,3
    80005152:	00e03733          	snez	a4,a4
    80005156:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000515a:	4007f793          	andi	a5,a5,1024
    8000515e:	c791                	beqz	a5,8000516a <sys_open+0xb8>
    80005160:	04449703          	lh	a4,68(s1)
    80005164:	4789                	li	a5,2
    80005166:	08f70d63          	beq	a4,a5,80005200 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000516a:	8526                	mv	a0,s1
    8000516c:	a72fe0ef          	jal	800033de <iunlock>
  end_op();
    80005170:	c3dfe0ef          	jal	80003dac <end_op>

  return fd;
    80005174:	854e                	mv	a0,s3
    80005176:	74aa                	ld	s1,168(sp)
    80005178:	790a                	ld	s2,160(sp)
    8000517a:	69ea                	ld	s3,152(sp)
}
    8000517c:	70ea                	ld	ra,184(sp)
    8000517e:	744a                	ld	s0,176(sp)
    80005180:	6129                	addi	sp,sp,192
    80005182:	8082                	ret
      end_op();
    80005184:	c29fe0ef          	jal	80003dac <end_op>
      return -1;
    80005188:	557d                	li	a0,-1
    8000518a:	74aa                	ld	s1,168(sp)
    8000518c:	bfc5                	j	8000517c <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000518e:	f5040513          	addi	a0,s0,-176
    80005192:	9cdfe0ef          	jal	80003b5e <namei>
    80005196:	84aa                	mv	s1,a0
    80005198:	c11d                	beqz	a0,800051be <sys_open+0x10c>
    ilock(ip);
    8000519a:	996fe0ef          	jal	80003330 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000519e:	04449703          	lh	a4,68(s1)
    800051a2:	4785                	li	a5,1
    800051a4:	f4f71ce3          	bne	a4,a5,800050fc <sys_open+0x4a>
    800051a8:	f4c42783          	lw	a5,-180(s0)
    800051ac:	d3b5                	beqz	a5,80005110 <sys_open+0x5e>
      iunlockput(ip);
    800051ae:	8526                	mv	a0,s1
    800051b0:	b8cfe0ef          	jal	8000353c <iunlockput>
      end_op();
    800051b4:	bf9fe0ef          	jal	80003dac <end_op>
      return -1;
    800051b8:	557d                	li	a0,-1
    800051ba:	74aa                	ld	s1,168(sp)
    800051bc:	b7c1                	j	8000517c <sys_open+0xca>
      end_op();
    800051be:	beffe0ef          	jal	80003dac <end_op>
      return -1;
    800051c2:	557d                	li	a0,-1
    800051c4:	74aa                	ld	s1,168(sp)
    800051c6:	bf5d                	j	8000517c <sys_open+0xca>
    iunlockput(ip);
    800051c8:	8526                	mv	a0,s1
    800051ca:	b72fe0ef          	jal	8000353c <iunlockput>
    end_op();
    800051ce:	bdffe0ef          	jal	80003dac <end_op>
    return -1;
    800051d2:	557d                	li	a0,-1
    800051d4:	74aa                	ld	s1,168(sp)
    800051d6:	b75d                	j	8000517c <sys_open+0xca>
      fileclose(f);
    800051d8:	854a                	mv	a0,s2
    800051da:	f87fe0ef          	jal	80004160 <fileclose>
    800051de:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800051e0:	8526                	mv	a0,s1
    800051e2:	b5afe0ef          	jal	8000353c <iunlockput>
    end_op();
    800051e6:	bc7fe0ef          	jal	80003dac <end_op>
    return -1;
    800051ea:	557d                	li	a0,-1
    800051ec:	74aa                	ld	s1,168(sp)
    800051ee:	790a                	ld	s2,160(sp)
    800051f0:	b771                	j	8000517c <sys_open+0xca>
    f->type = FD_DEVICE;
    800051f2:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800051f6:	04649783          	lh	a5,70(s1)
    800051fa:	02f91223          	sh	a5,36(s2)
    800051fe:	bf35                	j	8000513a <sys_open+0x88>
    itrunc(ip);
    80005200:	8526                	mv	a0,s1
    80005202:	a1cfe0ef          	jal	8000341e <itrunc>
    80005206:	b795                	j	8000516a <sys_open+0xb8>

0000000080005208 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005208:	7175                	addi	sp,sp,-144
    8000520a:	e506                	sd	ra,136(sp)
    8000520c:	e122                	sd	s0,128(sp)
    8000520e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005210:	b2dfe0ef          	jal	80003d3c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005214:	08000613          	li	a2,128
    80005218:	f7040593          	addi	a1,s0,-144
    8000521c:	4501                	li	a0,0
    8000521e:	f5efd0ef          	jal	8000297c <argstr>
    80005222:	02054363          	bltz	a0,80005248 <sys_mkdir+0x40>
    80005226:	4681                	li	a3,0
    80005228:	4601                	li	a2,0
    8000522a:	4585                	li	a1,1
    8000522c:	f7040513          	addi	a0,s0,-144
    80005230:	973ff0ef          	jal	80004ba2 <create>
    80005234:	c911                	beqz	a0,80005248 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005236:	b06fe0ef          	jal	8000353c <iunlockput>
  end_op();
    8000523a:	b73fe0ef          	jal	80003dac <end_op>
  return 0;
    8000523e:	4501                	li	a0,0
}
    80005240:	60aa                	ld	ra,136(sp)
    80005242:	640a                	ld	s0,128(sp)
    80005244:	6149                	addi	sp,sp,144
    80005246:	8082                	ret
    end_op();
    80005248:	b65fe0ef          	jal	80003dac <end_op>
    return -1;
    8000524c:	557d                	li	a0,-1
    8000524e:	bfcd                	j	80005240 <sys_mkdir+0x38>

0000000080005250 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005250:	7135                	addi	sp,sp,-160
    80005252:	ed06                	sd	ra,152(sp)
    80005254:	e922                	sd	s0,144(sp)
    80005256:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005258:	ae5fe0ef          	jal	80003d3c <begin_op>
  argint(1, &major);
    8000525c:	f6c40593          	addi	a1,s0,-148
    80005260:	4505                	li	a0,1
    80005262:	ee2fd0ef          	jal	80002944 <argint>
  argint(2, &minor);
    80005266:	f6840593          	addi	a1,s0,-152
    8000526a:	4509                	li	a0,2
    8000526c:	ed8fd0ef          	jal	80002944 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005270:	08000613          	li	a2,128
    80005274:	f7040593          	addi	a1,s0,-144
    80005278:	4501                	li	a0,0
    8000527a:	f02fd0ef          	jal	8000297c <argstr>
    8000527e:	02054563          	bltz	a0,800052a8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005282:	f6841683          	lh	a3,-152(s0)
    80005286:	f6c41603          	lh	a2,-148(s0)
    8000528a:	458d                	li	a1,3
    8000528c:	f7040513          	addi	a0,s0,-144
    80005290:	913ff0ef          	jal	80004ba2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005294:	c911                	beqz	a0,800052a8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005296:	aa6fe0ef          	jal	8000353c <iunlockput>
  end_op();
    8000529a:	b13fe0ef          	jal	80003dac <end_op>
  return 0;
    8000529e:	4501                	li	a0,0
}
    800052a0:	60ea                	ld	ra,152(sp)
    800052a2:	644a                	ld	s0,144(sp)
    800052a4:	610d                	addi	sp,sp,160
    800052a6:	8082                	ret
    end_op();
    800052a8:	b05fe0ef          	jal	80003dac <end_op>
    return -1;
    800052ac:	557d                	li	a0,-1
    800052ae:	bfcd                	j	800052a0 <sys_mknod+0x50>

00000000800052b0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800052b0:	7135                	addi	sp,sp,-160
    800052b2:	ed06                	sd	ra,152(sp)
    800052b4:	e922                	sd	s0,144(sp)
    800052b6:	e14a                	sd	s2,128(sp)
    800052b8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800052ba:	e74fc0ef          	jal	8000192e <myproc>
    800052be:	892a                	mv	s2,a0

  begin_op();
    800052c0:	a7dfe0ef          	jal	80003d3c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800052c4:	08000613          	li	a2,128
    800052c8:	f6040593          	addi	a1,s0,-160
    800052cc:	4501                	li	a0,0
    800052ce:	eaefd0ef          	jal	8000297c <argstr>
    800052d2:	04054363          	bltz	a0,80005318 <sys_chdir+0x68>
    800052d6:	e526                	sd	s1,136(sp)
    800052d8:	f6040513          	addi	a0,s0,-160
    800052dc:	883fe0ef          	jal	80003b5e <namei>
    800052e0:	84aa                	mv	s1,a0
    800052e2:	c915                	beqz	a0,80005316 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800052e4:	84cfe0ef          	jal	80003330 <ilock>
  if(ip->type != T_DIR){
    800052e8:	04449703          	lh	a4,68(s1)
    800052ec:	4785                	li	a5,1
    800052ee:	02f71963          	bne	a4,a5,80005320 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800052f2:	8526                	mv	a0,s1
    800052f4:	8eafe0ef          	jal	800033de <iunlock>
  iput(p->cwd);
    800052f8:	15093503          	ld	a0,336(s2)
    800052fc:	9b6fe0ef          	jal	800034b2 <iput>
  end_op();
    80005300:	aadfe0ef          	jal	80003dac <end_op>
  p->cwd = ip;
    80005304:	14993823          	sd	s1,336(s2)
  return 0;
    80005308:	4501                	li	a0,0
    8000530a:	64aa                	ld	s1,136(sp)
}
    8000530c:	60ea                	ld	ra,152(sp)
    8000530e:	644a                	ld	s0,144(sp)
    80005310:	690a                	ld	s2,128(sp)
    80005312:	610d                	addi	sp,sp,160
    80005314:	8082                	ret
    80005316:	64aa                	ld	s1,136(sp)
    end_op();
    80005318:	a95fe0ef          	jal	80003dac <end_op>
    return -1;
    8000531c:	557d                	li	a0,-1
    8000531e:	b7fd                	j	8000530c <sys_chdir+0x5c>
    iunlockput(ip);
    80005320:	8526                	mv	a0,s1
    80005322:	a1afe0ef          	jal	8000353c <iunlockput>
    end_op();
    80005326:	a87fe0ef          	jal	80003dac <end_op>
    return -1;
    8000532a:	557d                	li	a0,-1
    8000532c:	64aa                	ld	s1,136(sp)
    8000532e:	bff9                	j	8000530c <sys_chdir+0x5c>

0000000080005330 <sys_exec>:

uint64
sys_exec(void)
{
    80005330:	7105                	addi	sp,sp,-480
    80005332:	ef86                	sd	ra,472(sp)
    80005334:	eba2                	sd	s0,464(sp)
    80005336:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005338:	e2840593          	addi	a1,s0,-472
    8000533c:	4505                	li	a0,1
    8000533e:	e22fd0ef          	jal	80002960 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005342:	08000613          	li	a2,128
    80005346:	f3040593          	addi	a1,s0,-208
    8000534a:	4501                	li	a0,0
    8000534c:	e30fd0ef          	jal	8000297c <argstr>
    80005350:	87aa                	mv	a5,a0
    return -1;
    80005352:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005354:	0e07c063          	bltz	a5,80005434 <sys_exec+0x104>
    80005358:	e7a6                	sd	s1,456(sp)
    8000535a:	e3ca                	sd	s2,448(sp)
    8000535c:	ff4e                	sd	s3,440(sp)
    8000535e:	fb52                	sd	s4,432(sp)
    80005360:	f756                	sd	s5,424(sp)
    80005362:	f35a                	sd	s6,416(sp)
    80005364:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005366:	e3040a13          	addi	s4,s0,-464
    8000536a:	10000613          	li	a2,256
    8000536e:	4581                	li	a1,0
    80005370:	8552                	mv	a0,s4
    80005372:	987fb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005376:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005378:	89d2                	mv	s3,s4
    8000537a:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000537c:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005380:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005382:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005386:	00391513          	slli	a0,s2,0x3
    8000538a:	85d6                	mv	a1,s5
    8000538c:	e2843783          	ld	a5,-472(s0)
    80005390:	953e                	add	a0,a0,a5
    80005392:	d28fd0ef          	jal	800028ba <fetchaddr>
    80005396:	02054663          	bltz	a0,800053c2 <sys_exec+0x92>
    if(uarg == 0){
    8000539a:	e2043783          	ld	a5,-480(s0)
    8000539e:	c7a1                	beqz	a5,800053e6 <sys_exec+0xb6>
    argv[i] = kalloc();
    800053a0:	fa4fb0ef          	jal	80000b44 <kalloc>
    800053a4:	85aa                	mv	a1,a0
    800053a6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800053aa:	cd01                	beqz	a0,800053c2 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053ac:	865a                	mv	a2,s6
    800053ae:	e2043503          	ld	a0,-480(s0)
    800053b2:	d52fd0ef          	jal	80002904 <fetchstr>
    800053b6:	00054663          	bltz	a0,800053c2 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800053ba:	0905                	addi	s2,s2,1
    800053bc:	09a1                	addi	s3,s3,8
    800053be:	fd7914e3          	bne	s2,s7,80005386 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053c2:	100a0a13          	addi	s4,s4,256
    800053c6:	6088                	ld	a0,0(s1)
    800053c8:	cd31                	beqz	a0,80005424 <sys_exec+0xf4>
    kfree(argv[i]);
    800053ca:	e92fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053ce:	04a1                	addi	s1,s1,8
    800053d0:	ff449be3          	bne	s1,s4,800053c6 <sys_exec+0x96>
  return -1;
    800053d4:	557d                	li	a0,-1
    800053d6:	64be                	ld	s1,456(sp)
    800053d8:	691e                	ld	s2,448(sp)
    800053da:	79fa                	ld	s3,440(sp)
    800053dc:	7a5a                	ld	s4,432(sp)
    800053de:	7aba                	ld	s5,424(sp)
    800053e0:	7b1a                	ld	s6,416(sp)
    800053e2:	6bfa                	ld	s7,408(sp)
    800053e4:	a881                	j	80005434 <sys_exec+0x104>
      argv[i] = 0;
    800053e6:	0009079b          	sext.w	a5,s2
    800053ea:	e3040593          	addi	a1,s0,-464
    800053ee:	078e                	slli	a5,a5,0x3
    800053f0:	97ae                	add	a5,a5,a1
    800053f2:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800053f6:	f3040513          	addi	a0,s0,-208
    800053fa:	bb2ff0ef          	jal	800047ac <kexec>
    800053fe:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005400:	100a0a13          	addi	s4,s4,256
    80005404:	6088                	ld	a0,0(s1)
    80005406:	c511                	beqz	a0,80005412 <sys_exec+0xe2>
    kfree(argv[i]);
    80005408:	e54fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000540c:	04a1                	addi	s1,s1,8
    8000540e:	ff449be3          	bne	s1,s4,80005404 <sys_exec+0xd4>
  return ret;
    80005412:	854a                	mv	a0,s2
    80005414:	64be                	ld	s1,456(sp)
    80005416:	691e                	ld	s2,448(sp)
    80005418:	79fa                	ld	s3,440(sp)
    8000541a:	7a5a                	ld	s4,432(sp)
    8000541c:	7aba                	ld	s5,424(sp)
    8000541e:	7b1a                	ld	s6,416(sp)
    80005420:	6bfa                	ld	s7,408(sp)
    80005422:	a809                	j	80005434 <sys_exec+0x104>
  return -1;
    80005424:	557d                	li	a0,-1
    80005426:	64be                	ld	s1,456(sp)
    80005428:	691e                	ld	s2,448(sp)
    8000542a:	79fa                	ld	s3,440(sp)
    8000542c:	7a5a                	ld	s4,432(sp)
    8000542e:	7aba                	ld	s5,424(sp)
    80005430:	7b1a                	ld	s6,416(sp)
    80005432:	6bfa                	ld	s7,408(sp)
}
    80005434:	60fe                	ld	ra,472(sp)
    80005436:	645e                	ld	s0,464(sp)
    80005438:	613d                	addi	sp,sp,480
    8000543a:	8082                	ret

000000008000543c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000543c:	7139                	addi	sp,sp,-64
    8000543e:	fc06                	sd	ra,56(sp)
    80005440:	f822                	sd	s0,48(sp)
    80005442:	f426                	sd	s1,40(sp)
    80005444:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005446:	ce8fc0ef          	jal	8000192e <myproc>
    8000544a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000544c:	fd840593          	addi	a1,s0,-40
    80005450:	4501                	li	a0,0
    80005452:	d0efd0ef          	jal	80002960 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005456:	fc840593          	addi	a1,s0,-56
    8000545a:	fd040513          	addi	a0,s0,-48
    8000545e:	81eff0ef          	jal	8000447c <pipealloc>
    return -1;
    80005462:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005464:	0a054763          	bltz	a0,80005512 <sys_pipe+0xd6>
  fd0 = -1;
    80005468:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000546c:	fd043503          	ld	a0,-48(s0)
    80005470:	ef2ff0ef          	jal	80004b62 <fdalloc>
    80005474:	fca42223          	sw	a0,-60(s0)
    80005478:	08054463          	bltz	a0,80005500 <sys_pipe+0xc4>
    8000547c:	fc843503          	ld	a0,-56(s0)
    80005480:	ee2ff0ef          	jal	80004b62 <fdalloc>
    80005484:	fca42023          	sw	a0,-64(s0)
    80005488:	06054263          	bltz	a0,800054ec <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000548c:	4691                	li	a3,4
    8000548e:	fc440613          	addi	a2,s0,-60
    80005492:	fd843583          	ld	a1,-40(s0)
    80005496:	68a8                	ld	a0,80(s1)
    80005498:	9bcfc0ef          	jal	80001654 <copyout>
    8000549c:	00054e63          	bltz	a0,800054b8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800054a0:	4691                	li	a3,4
    800054a2:	fc040613          	addi	a2,s0,-64
    800054a6:	fd843583          	ld	a1,-40(s0)
    800054aa:	95b6                	add	a1,a1,a3
    800054ac:	68a8                	ld	a0,80(s1)
    800054ae:	9a6fc0ef          	jal	80001654 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800054b2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054b4:	04055f63          	bgez	a0,80005512 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800054b8:	fc442783          	lw	a5,-60(s0)
    800054bc:	078e                	slli	a5,a5,0x3
    800054be:	0d078793          	addi	a5,a5,208
    800054c2:	97a6                	add	a5,a5,s1
    800054c4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054c8:	fc042783          	lw	a5,-64(s0)
    800054cc:	078e                	slli	a5,a5,0x3
    800054ce:	0d078793          	addi	a5,a5,208
    800054d2:	97a6                	add	a5,a5,s1
    800054d4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800054d8:	fd043503          	ld	a0,-48(s0)
    800054dc:	c85fe0ef          	jal	80004160 <fileclose>
    fileclose(wf);
    800054e0:	fc843503          	ld	a0,-56(s0)
    800054e4:	c7dfe0ef          	jal	80004160 <fileclose>
    return -1;
    800054e8:	57fd                	li	a5,-1
    800054ea:	a025                	j	80005512 <sys_pipe+0xd6>
    if(fd0 >= 0)
    800054ec:	fc442783          	lw	a5,-60(s0)
    800054f0:	0007c863          	bltz	a5,80005500 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    800054f4:	078e                	slli	a5,a5,0x3
    800054f6:	0d078793          	addi	a5,a5,208
    800054fa:	97a6                	add	a5,a5,s1
    800054fc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005500:	fd043503          	ld	a0,-48(s0)
    80005504:	c5dfe0ef          	jal	80004160 <fileclose>
    fileclose(wf);
    80005508:	fc843503          	ld	a0,-56(s0)
    8000550c:	c55fe0ef          	jal	80004160 <fileclose>
    return -1;
    80005510:	57fd                	li	a5,-1
}
    80005512:	853e                	mv	a0,a5
    80005514:	70e2                	ld	ra,56(sp)
    80005516:	7442                	ld	s0,48(sp)
    80005518:	74a2                	ld	s1,40(sp)
    8000551a:	6121                	addi	sp,sp,64
    8000551c:	8082                	ret
	...

0000000080005520 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005520:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005522:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005524:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005526:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005528:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000552a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000552c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000552e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005530:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005532:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005534:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005536:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005538:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000553a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000553c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000553e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005540:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005542:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005544:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005546:	a82fd0ef          	jal	800027c8 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000554a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000554c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000554e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005550:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005552:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005554:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005556:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005558:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000555a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000555c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000555e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005560:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005562:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005564:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005566:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005568:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000556a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000556c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000556e:	10200073          	sret
    80005572:	00000013          	nop
    80005576:	00000013          	nop
    8000557a:	00000013          	nop

000000008000557e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000557e:	1141                	addi	sp,sp,-16
    80005580:	e406                	sd	ra,8(sp)
    80005582:	e022                	sd	s0,0(sp)
    80005584:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005586:	0c000737          	lui	a4,0xc000
    8000558a:	4785                	li	a5,1
    8000558c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000558e:	c35c                	sw	a5,4(a4)
}
    80005590:	60a2                	ld	ra,8(sp)
    80005592:	6402                	ld	s0,0(sp)
    80005594:	0141                	addi	sp,sp,16
    80005596:	8082                	ret

0000000080005598 <plicinithart>:

void
plicinithart(void)
{
    80005598:	1141                	addi	sp,sp,-16
    8000559a:	e406                	sd	ra,8(sp)
    8000559c:	e022                	sd	s0,0(sp)
    8000559e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055a0:	b5afc0ef          	jal	800018fa <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800055a4:	0085171b          	slliw	a4,a0,0x8
    800055a8:	0c0027b7          	lui	a5,0xc002
    800055ac:	97ba                	add	a5,a5,a4
    800055ae:	40200713          	li	a4,1026
    800055b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800055b6:	00d5151b          	slliw	a0,a0,0xd
    800055ba:	0c2017b7          	lui	a5,0xc201
    800055be:	97aa                	add	a5,a5,a0
    800055c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800055c4:	60a2                	ld	ra,8(sp)
    800055c6:	6402                	ld	s0,0(sp)
    800055c8:	0141                	addi	sp,sp,16
    800055ca:	8082                	ret

00000000800055cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800055cc:	1141                	addi	sp,sp,-16
    800055ce:	e406                	sd	ra,8(sp)
    800055d0:	e022                	sd	s0,0(sp)
    800055d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055d4:	b26fc0ef          	jal	800018fa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800055d8:	00d5151b          	slliw	a0,a0,0xd
    800055dc:	0c2017b7          	lui	a5,0xc201
    800055e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800055e2:	43c8                	lw	a0,4(a5)
    800055e4:	60a2                	ld	ra,8(sp)
    800055e6:	6402                	ld	s0,0(sp)
    800055e8:	0141                	addi	sp,sp,16
    800055ea:	8082                	ret

00000000800055ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055ec:	1101                	addi	sp,sp,-32
    800055ee:	ec06                	sd	ra,24(sp)
    800055f0:	e822                	sd	s0,16(sp)
    800055f2:	e426                	sd	s1,8(sp)
    800055f4:	1000                	addi	s0,sp,32
    800055f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055f8:	b02fc0ef          	jal	800018fa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800055fc:	00d5179b          	slliw	a5,a0,0xd
    80005600:	0c201737          	lui	a4,0xc201
    80005604:	97ba                	add	a5,a5,a4
    80005606:	c3c4                	sw	s1,4(a5)
}
    80005608:	60e2                	ld	ra,24(sp)
    8000560a:	6442                	ld	s0,16(sp)
    8000560c:	64a2                	ld	s1,8(sp)
    8000560e:	6105                	addi	sp,sp,32
    80005610:	8082                	ret

0000000080005612 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005612:	1141                	addi	sp,sp,-16
    80005614:	e406                	sd	ra,8(sp)
    80005616:	e022                	sd	s0,0(sp)
    80005618:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000561a:	479d                	li	a5,7
    8000561c:	04a7ca63          	blt	a5,a0,80005670 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005620:	0001b797          	auipc	a5,0x1b
    80005624:	46878793          	addi	a5,a5,1128 # 80020a88 <disk>
    80005628:	97aa                	add	a5,a5,a0
    8000562a:	0187c783          	lbu	a5,24(a5)
    8000562e:	e7b9                	bnez	a5,8000567c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005630:	00451693          	slli	a3,a0,0x4
    80005634:	0001b797          	auipc	a5,0x1b
    80005638:	45478793          	addi	a5,a5,1108 # 80020a88 <disk>
    8000563c:	6398                	ld	a4,0(a5)
    8000563e:	9736                	add	a4,a4,a3
    80005640:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005644:	6398                	ld	a4,0(a5)
    80005646:	9736                	add	a4,a4,a3
    80005648:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000564c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005650:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005654:	97aa                	add	a5,a5,a0
    80005656:	4705                	li	a4,1
    80005658:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000565c:	0001b517          	auipc	a0,0x1b
    80005660:	44450513          	addi	a0,a0,1092 # 80020aa0 <disk+0x18>
    80005664:	927fc0ef          	jal	80001f8a <wakeup>
}
    80005668:	60a2                	ld	ra,8(sp)
    8000566a:	6402                	ld	s0,0(sp)
    8000566c:	0141                	addi	sp,sp,16
    8000566e:	8082                	ret
    panic("free_desc 1");
    80005670:	00002517          	auipc	a0,0x2
    80005674:	fc050513          	addi	a0,a0,-64 # 80007630 <etext+0x630>
    80005678:	9acfb0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000567c:	00002517          	auipc	a0,0x2
    80005680:	fc450513          	addi	a0,a0,-60 # 80007640 <etext+0x640>
    80005684:	9a0fb0ef          	jal	80000824 <panic>

0000000080005688 <virtio_disk_init>:
{
    80005688:	1101                	addi	sp,sp,-32
    8000568a:	ec06                	sd	ra,24(sp)
    8000568c:	e822                	sd	s0,16(sp)
    8000568e:	e426                	sd	s1,8(sp)
    80005690:	e04a                	sd	s2,0(sp)
    80005692:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005694:	00002597          	auipc	a1,0x2
    80005698:	fbc58593          	addi	a1,a1,-68 # 80007650 <etext+0x650>
    8000569c:	0001b517          	auipc	a0,0x1b
    800056a0:	51450513          	addi	a0,a0,1300 # 80020bb0 <disk+0x128>
    800056a4:	cfafb0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056a8:	100017b7          	lui	a5,0x10001
    800056ac:	4398                	lw	a4,0(a5)
    800056ae:	2701                	sext.w	a4,a4
    800056b0:	747277b7          	lui	a5,0x74727
    800056b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056b8:	14f71863          	bne	a4,a5,80005808 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056bc:	100017b7          	lui	a5,0x10001
    800056c0:	43dc                	lw	a5,4(a5)
    800056c2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056c4:	4709                	li	a4,2
    800056c6:	14e79163          	bne	a5,a4,80005808 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056ca:	100017b7          	lui	a5,0x10001
    800056ce:	479c                	lw	a5,8(a5)
    800056d0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056d2:	12e79b63          	bne	a5,a4,80005808 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800056d6:	100017b7          	lui	a5,0x10001
    800056da:	47d8                	lw	a4,12(a5)
    800056dc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056de:	554d47b7          	lui	a5,0x554d4
    800056e2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056e6:	12f71163          	bne	a4,a5,80005808 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ea:	100017b7          	lui	a5,0x10001
    800056ee:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f2:	4705                	li	a4,1
    800056f4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f6:	470d                	li	a4,3
    800056f8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056fa:	10001737          	lui	a4,0x10001
    800056fe:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005700:	c7ffe6b7          	lui	a3,0xc7ffe
    80005704:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddb97>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005708:	8f75                	and	a4,a4,a3
    8000570a:	100016b7          	lui	a3,0x10001
    8000570e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005710:	472d                	li	a4,11
    80005712:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005714:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005718:	439c                	lw	a5,0(a5)
    8000571a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000571e:	8ba1                	andi	a5,a5,8
    80005720:	0e078a63          	beqz	a5,80005814 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005724:	100017b7          	lui	a5,0x10001
    80005728:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000572c:	43fc                	lw	a5,68(a5)
    8000572e:	2781                	sext.w	a5,a5
    80005730:	0e079863          	bnez	a5,80005820 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005734:	100017b7          	lui	a5,0x10001
    80005738:	5bdc                	lw	a5,52(a5)
    8000573a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000573c:	0e078863          	beqz	a5,8000582c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005740:	471d                	li	a4,7
    80005742:	0ef77b63          	bgeu	a4,a5,80005838 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005746:	bfefb0ef          	jal	80000b44 <kalloc>
    8000574a:	0001b497          	auipc	s1,0x1b
    8000574e:	33e48493          	addi	s1,s1,830 # 80020a88 <disk>
    80005752:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005754:	bf0fb0ef          	jal	80000b44 <kalloc>
    80005758:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000575a:	beafb0ef          	jal	80000b44 <kalloc>
    8000575e:	87aa                	mv	a5,a0
    80005760:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005762:	6088                	ld	a0,0(s1)
    80005764:	0e050063          	beqz	a0,80005844 <virtio_disk_init+0x1bc>
    80005768:	0001b717          	auipc	a4,0x1b
    8000576c:	32873703          	ld	a4,808(a4) # 80020a90 <disk+0x8>
    80005770:	cb71                	beqz	a4,80005844 <virtio_disk_init+0x1bc>
    80005772:	cbe9                	beqz	a5,80005844 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005774:	6605                	lui	a2,0x1
    80005776:	4581                	li	a1,0
    80005778:	d80fb0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000577c:	0001b497          	auipc	s1,0x1b
    80005780:	30c48493          	addi	s1,s1,780 # 80020a88 <disk>
    80005784:	6605                	lui	a2,0x1
    80005786:	4581                	li	a1,0
    80005788:	6488                	ld	a0,8(s1)
    8000578a:	d6efb0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000578e:	6605                	lui	a2,0x1
    80005790:	4581                	li	a1,0
    80005792:	6888                	ld	a0,16(s1)
    80005794:	d64fb0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	4721                	li	a4,8
    8000579e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800057a0:	4098                	lw	a4,0(s1)
    800057a2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800057a6:	40d8                	lw	a4,4(s1)
    800057a8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057ac:	649c                	ld	a5,8(s1)
    800057ae:	0007869b          	sext.w	a3,a5
    800057b2:	10001737          	lui	a4,0x10001
    800057b6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800057ba:	9781                	srai	a5,a5,0x20
    800057bc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800057c0:	689c                	ld	a5,16(s1)
    800057c2:	0007869b          	sext.w	a3,a5
    800057c6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800057ca:	9781                	srai	a5,a5,0x20
    800057cc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800057d0:	4785                	li	a5,1
    800057d2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800057d4:	00f48c23          	sb	a5,24(s1)
    800057d8:	00f48ca3          	sb	a5,25(s1)
    800057dc:	00f48d23          	sb	a5,26(s1)
    800057e0:	00f48da3          	sb	a5,27(s1)
    800057e4:	00f48e23          	sb	a5,28(s1)
    800057e8:	00f48ea3          	sb	a5,29(s1)
    800057ec:	00f48f23          	sb	a5,30(s1)
    800057f0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800057f4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800057f8:	07272823          	sw	s2,112(a4)
}
    800057fc:	60e2                	ld	ra,24(sp)
    800057fe:	6442                	ld	s0,16(sp)
    80005800:	64a2                	ld	s1,8(sp)
    80005802:	6902                	ld	s2,0(sp)
    80005804:	6105                	addi	sp,sp,32
    80005806:	8082                	ret
    panic("could not find virtio disk");
    80005808:	00002517          	auipc	a0,0x2
    8000580c:	e5850513          	addi	a0,a0,-424 # 80007660 <etext+0x660>
    80005810:	814fb0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005814:	00002517          	auipc	a0,0x2
    80005818:	e6c50513          	addi	a0,a0,-404 # 80007680 <etext+0x680>
    8000581c:	808fb0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005820:	00002517          	auipc	a0,0x2
    80005824:	e8050513          	addi	a0,a0,-384 # 800076a0 <etext+0x6a0>
    80005828:	ffdfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    8000582c:	00002517          	auipc	a0,0x2
    80005830:	e9450513          	addi	a0,a0,-364 # 800076c0 <etext+0x6c0>
    80005834:	ff1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005838:	00002517          	auipc	a0,0x2
    8000583c:	ea850513          	addi	a0,a0,-344 # 800076e0 <etext+0x6e0>
    80005840:	fe5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005844:	00002517          	auipc	a0,0x2
    80005848:	ebc50513          	addi	a0,a0,-324 # 80007700 <etext+0x700>
    8000584c:	fd9fa0ef          	jal	80000824 <panic>

0000000080005850 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005850:	711d                	addi	sp,sp,-96
    80005852:	ec86                	sd	ra,88(sp)
    80005854:	e8a2                	sd	s0,80(sp)
    80005856:	e4a6                	sd	s1,72(sp)
    80005858:	e0ca                	sd	s2,64(sp)
    8000585a:	fc4e                	sd	s3,56(sp)
    8000585c:	f852                	sd	s4,48(sp)
    8000585e:	f456                	sd	s5,40(sp)
    80005860:	f05a                	sd	s6,32(sp)
    80005862:	ec5e                	sd	s7,24(sp)
    80005864:	e862                	sd	s8,16(sp)
    80005866:	1080                	addi	s0,sp,96
    80005868:	89aa                	mv	s3,a0
    8000586a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000586c:	00c52b83          	lw	s7,12(a0)
    80005870:	001b9b9b          	slliw	s7,s7,0x1
    80005874:	1b82                	slli	s7,s7,0x20
    80005876:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000587a:	0001b517          	auipc	a0,0x1b
    8000587e:	33650513          	addi	a0,a0,822 # 80020bb0 <disk+0x128>
    80005882:	ba6fb0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005886:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005888:	0001ba97          	auipc	s5,0x1b
    8000588c:	200a8a93          	addi	s5,s5,512 # 80020a88 <disk>
  for(int i = 0; i < 3; i++){
    80005890:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005892:	5c7d                	li	s8,-1
    80005894:	a095                	j	800058f8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005896:	00fa8733          	add	a4,s5,a5
    8000589a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000589e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800058a0:	0207c563          	bltz	a5,800058ca <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800058a4:	2905                	addiw	s2,s2,1
    800058a6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800058a8:	05490c63          	beq	s2,s4,80005900 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800058ac:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800058ae:	0001b717          	auipc	a4,0x1b
    800058b2:	1da70713          	addi	a4,a4,474 # 80020a88 <disk>
    800058b6:	4781                	li	a5,0
    if(disk.free[i]){
    800058b8:	01874683          	lbu	a3,24(a4)
    800058bc:	fee9                	bnez	a3,80005896 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800058be:	2785                	addiw	a5,a5,1
    800058c0:	0705                	addi	a4,a4,1
    800058c2:	fe979be3          	bne	a5,s1,800058b8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800058c6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800058ca:	01205d63          	blez	s2,800058e4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800058ce:	fa042503          	lw	a0,-96(s0)
    800058d2:	d41ff0ef          	jal	80005612 <free_desc>
      for(int j = 0; j < i; j++)
    800058d6:	4785                	li	a5,1
    800058d8:	0127d663          	bge	a5,s2,800058e4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800058dc:	fa442503          	lw	a0,-92(s0)
    800058e0:	d33ff0ef          	jal	80005612 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058e4:	0001b597          	auipc	a1,0x1b
    800058e8:	2cc58593          	addi	a1,a1,716 # 80020bb0 <disk+0x128>
    800058ec:	0001b517          	auipc	a0,0x1b
    800058f0:	1b450513          	addi	a0,a0,436 # 80020aa0 <disk+0x18>
    800058f4:	e4afc0ef          	jal	80001f3e <sleep>
  for(int i = 0; i < 3; i++){
    800058f8:	fa040613          	addi	a2,s0,-96
    800058fc:	4901                	li	s2,0
    800058fe:	b77d                	j	800058ac <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005900:	fa042503          	lw	a0,-96(s0)
    80005904:	00451693          	slli	a3,a0,0x4

  if(write)
    80005908:	0001b797          	auipc	a5,0x1b
    8000590c:	18078793          	addi	a5,a5,384 # 80020a88 <disk>
    80005910:	00451713          	slli	a4,a0,0x4
    80005914:	0a070713          	addi	a4,a4,160
    80005918:	973e                	add	a4,a4,a5
    8000591a:	01603633          	snez	a2,s6
    8000591e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005920:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005924:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005928:	6398                	ld	a4,0(a5)
    8000592a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000592c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005930:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005932:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005934:	6390                	ld	a2,0(a5)
    80005936:	00d60833          	add	a6,a2,a3
    8000593a:	4741                	li	a4,16
    8000593c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005940:	4585                	li	a1,1
    80005942:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005946:	fa442703          	lw	a4,-92(s0)
    8000594a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000594e:	0712                	slli	a4,a4,0x4
    80005950:	963a                	add	a2,a2,a4
    80005952:	05898813          	addi	a6,s3,88
    80005956:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000595a:	0007b883          	ld	a7,0(a5)
    8000595e:	9746                	add	a4,a4,a7
    80005960:	40000613          	li	a2,1024
    80005964:	c710                	sw	a2,8(a4)
  if(write)
    80005966:	001b3613          	seqz	a2,s6
    8000596a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000596e:	8e4d                	or	a2,a2,a1
    80005970:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005974:	fa842603          	lw	a2,-88(s0)
    80005978:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000597c:	00451813          	slli	a6,a0,0x4
    80005980:	02080813          	addi	a6,a6,32
    80005984:	983e                	add	a6,a6,a5
    80005986:	577d                	li	a4,-1
    80005988:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000598c:	0612                	slli	a2,a2,0x4
    8000598e:	98b2                	add	a7,a7,a2
    80005990:	03068713          	addi	a4,a3,48
    80005994:	973e                	add	a4,a4,a5
    80005996:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000599a:	6398                	ld	a4,0(a5)
    8000599c:	9732                	add	a4,a4,a2
    8000599e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059a0:	4689                	li	a3,2
    800059a2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800059a6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059aa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800059ae:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059b2:	6794                	ld	a3,8(a5)
    800059b4:	0026d703          	lhu	a4,2(a3)
    800059b8:	8b1d                	andi	a4,a4,7
    800059ba:	0706                	slli	a4,a4,0x1
    800059bc:	96ba                	add	a3,a3,a4
    800059be:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800059c2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800059c6:	6798                	ld	a4,8(a5)
    800059c8:	00275783          	lhu	a5,2(a4)
    800059cc:	2785                	addiw	a5,a5,1
    800059ce:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800059d2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059d6:	100017b7          	lui	a5,0x10001
    800059da:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800059de:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800059e2:	0001b917          	auipc	s2,0x1b
    800059e6:	1ce90913          	addi	s2,s2,462 # 80020bb0 <disk+0x128>
  while(b->disk == 1) {
    800059ea:	84ae                	mv	s1,a1
    800059ec:	00b79a63          	bne	a5,a1,80005a00 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800059f0:	85ca                	mv	a1,s2
    800059f2:	854e                	mv	a0,s3
    800059f4:	d4afc0ef          	jal	80001f3e <sleep>
  while(b->disk == 1) {
    800059f8:	0049a783          	lw	a5,4(s3)
    800059fc:	fe978ae3          	beq	a5,s1,800059f0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005a00:	fa042903          	lw	s2,-96(s0)
    80005a04:	00491713          	slli	a4,s2,0x4
    80005a08:	02070713          	addi	a4,a4,32
    80005a0c:	0001b797          	auipc	a5,0x1b
    80005a10:	07c78793          	addi	a5,a5,124 # 80020a88 <disk>
    80005a14:	97ba                	add	a5,a5,a4
    80005a16:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a1a:	0001b997          	auipc	s3,0x1b
    80005a1e:	06e98993          	addi	s3,s3,110 # 80020a88 <disk>
    80005a22:	00491713          	slli	a4,s2,0x4
    80005a26:	0009b783          	ld	a5,0(s3)
    80005a2a:	97ba                	add	a5,a5,a4
    80005a2c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a30:	854a                	mv	a0,s2
    80005a32:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a36:	bddff0ef          	jal	80005612 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a3a:	8885                	andi	s1,s1,1
    80005a3c:	f0fd                	bnez	s1,80005a22 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a3e:	0001b517          	auipc	a0,0x1b
    80005a42:	17250513          	addi	a0,a0,370 # 80020bb0 <disk+0x128>
    80005a46:	a76fb0ef          	jal	80000cbc <release>
}
    80005a4a:	60e6                	ld	ra,88(sp)
    80005a4c:	6446                	ld	s0,80(sp)
    80005a4e:	64a6                	ld	s1,72(sp)
    80005a50:	6906                	ld	s2,64(sp)
    80005a52:	79e2                	ld	s3,56(sp)
    80005a54:	7a42                	ld	s4,48(sp)
    80005a56:	7aa2                	ld	s5,40(sp)
    80005a58:	7b02                	ld	s6,32(sp)
    80005a5a:	6be2                	ld	s7,24(sp)
    80005a5c:	6c42                	ld	s8,16(sp)
    80005a5e:	6125                	addi	sp,sp,96
    80005a60:	8082                	ret

0000000080005a62 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a62:	1101                	addi	sp,sp,-32
    80005a64:	ec06                	sd	ra,24(sp)
    80005a66:	e822                	sd	s0,16(sp)
    80005a68:	e426                	sd	s1,8(sp)
    80005a6a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a6c:	0001b497          	auipc	s1,0x1b
    80005a70:	01c48493          	addi	s1,s1,28 # 80020a88 <disk>
    80005a74:	0001b517          	auipc	a0,0x1b
    80005a78:	13c50513          	addi	a0,a0,316 # 80020bb0 <disk+0x128>
    80005a7c:	9acfb0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a80:	100017b7          	lui	a5,0x10001
    80005a84:	53bc                	lw	a5,96(a5)
    80005a86:	8b8d                	andi	a5,a5,3
    80005a88:	10001737          	lui	a4,0x10001
    80005a8c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a8e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a92:	689c                	ld	a5,16(s1)
    80005a94:	0204d703          	lhu	a4,32(s1)
    80005a98:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a9c:	04f70863          	beq	a4,a5,80005aec <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005aa0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005aa4:	6898                	ld	a4,16(s1)
    80005aa6:	0204d783          	lhu	a5,32(s1)
    80005aaa:	8b9d                	andi	a5,a5,7
    80005aac:	078e                	slli	a5,a5,0x3
    80005aae:	97ba                	add	a5,a5,a4
    80005ab0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005ab2:	00479713          	slli	a4,a5,0x4
    80005ab6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005aba:	9726                	add	a4,a4,s1
    80005abc:	01074703          	lbu	a4,16(a4)
    80005ac0:	e329                	bnez	a4,80005b02 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ac2:	0792                	slli	a5,a5,0x4
    80005ac4:	02078793          	addi	a5,a5,32
    80005ac8:	97a6                	add	a5,a5,s1
    80005aca:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005acc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ad0:	cbafc0ef          	jal	80001f8a <wakeup>

    disk.used_idx += 1;
    80005ad4:	0204d783          	lhu	a5,32(s1)
    80005ad8:	2785                	addiw	a5,a5,1
    80005ada:	17c2                	slli	a5,a5,0x30
    80005adc:	93c1                	srli	a5,a5,0x30
    80005ade:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005ae2:	6898                	ld	a4,16(s1)
    80005ae4:	00275703          	lhu	a4,2(a4)
    80005ae8:	faf71ce3          	bne	a4,a5,80005aa0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005aec:	0001b517          	auipc	a0,0x1b
    80005af0:	0c450513          	addi	a0,a0,196 # 80020bb0 <disk+0x128>
    80005af4:	9c8fb0ef          	jal	80000cbc <release>
}
    80005af8:	60e2                	ld	ra,24(sp)
    80005afa:	6442                	ld	s0,16(sp)
    80005afc:	64a2                	ld	s1,8(sp)
    80005afe:	6105                	addi	sp,sp,32
    80005b00:	8082                	ret
      panic("virtio_disk_intr status");
    80005b02:	00002517          	auipc	a0,0x2
    80005b06:	c1650513          	addi	a0,a0,-1002 # 80007718 <etext+0x718>
    80005b0a:	d1bfa0ef          	jal	80000824 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
