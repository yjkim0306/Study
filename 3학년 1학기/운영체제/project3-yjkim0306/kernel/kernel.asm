
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
    80000004:	87010113          	addi	sp,sp,-1936 # 80007870 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd1c87>
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
    8000011a:	2dc020ef          	jal	800023f6 <either_copyin>
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
    80000196:	6de50513          	addi	a0,a0,1758 # 8000f870 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	0000f497          	auipc	s1,0xf
    800001a2:	6d248493          	addi	s1,s1,1746 # 8000f870 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	0000f917          	auipc	s2,0xf
    800001aa:	76290913          	addi	s2,s2,1890 # 8000f908 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	768010ef          	jal	80001926 <myproc>
    800001c2:	0cc020ef          	jal	8000228e <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	5cd010ef          	jal	80001f98 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	0000f717          	auipc	a4,0xf
    800001e2:	69270713          	addi	a4,a4,1682 # 8000f870 <cons>
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
    80000210:	19c020ef          	jal	800023ac <either_copyout>
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
    8000022c:	64850513          	addi	a0,a0,1608 # 8000f870 <cons>
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
    80000252:	6af72d23          	sw	a5,1722(a4) # 8000f908 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	60c50513          	addi	a0,a0,1548 # 8000f870 <cons>
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
    800002bc:	5b850513          	addi	a0,a0,1464 # 8000f870 <cons>
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
    800002da:	166020ef          	jal	80002440 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002de:	0000f517          	auipc	a0,0xf
    800002e2:	59250513          	addi	a0,a0,1426 # 8000f870 <cons>
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
    80000300:	57470713          	addi	a4,a4,1396 # 8000f870 <cons>
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
    80000326:	54e70713          	addi	a4,a4,1358 # 8000f870 <cons>
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
    80000350:	5bc72703          	lw	a4,1468(a4) # 8000f908 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	0000f717          	auipc	a4,0xf
    80000366:	50e70713          	addi	a4,a4,1294 # 8000f870 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	0000f497          	auipc	s1,0xf
    80000376:	4fe48493          	addi	s1,s1,1278 # 8000f870 <cons>
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
    800003b8:	4bc70713          	addi	a4,a4,1212 # 8000f870 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	0000f717          	auipc	a4,0xf
    800003ce:	54f72323          	sw	a5,1350(a4) # 8000f910 <cons+0xa0>
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
    800003ec:	48878793          	addi	a5,a5,1160 # 8000f870 <cons>
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
    8000040e:	50c7a123          	sw	a2,1282(a5) # 8000f90c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	0000f517          	auipc	a0,0xf
    80000416:	4f650513          	addi	a0,a0,1270 # 8000f908 <cons+0x98>
    8000041a:	3cb010ef          	jal	80001fe4 <wakeup>
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
    80000434:	44050513          	addi	a0,a0,1088 # 8000f870 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	0002b797          	auipc	a5,0x2b
    80000444:	5a078793          	addi	a5,a5,1440 # 8002b9e0 <devsw>
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
    80000482:	29280813          	addi	a6,a6,658 # 80007710 <digits>
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
    8000051c:	32c7a783          	lw	a5,812(a5) # 80007844 <panicking>
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
    80000562:	3ba50513          	addi	a0,a0,954 # 8000f918 <pr>
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
    800006d6:	03ec8c93          	addi	s9,s9,62 # 80007710 <digits>
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
    8000075e:	0ea7a783          	lw	a5,234(a5) # 80007844 <panicking>
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
    80000788:	19450513          	addi	a0,a0,404 # 8000f918 <pr>
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
    80000838:	0097a823          	sw	s1,16(a5) # 80007844 <panicking>
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
    8000085a:	fe97a523          	sw	s1,-22(a5) # 80007840 <panicked>
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
    80000874:	0a850513          	addi	a0,a0,168 # 8000f918 <pr>
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
    800008ca:	06a50513          	addi	a0,a0,106 # 8000f930 <tx_lock>
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
    800008ee:	04650513          	addi	a0,a0,70 # 8000f930 <tx_lock>
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
    8000090c:	f4448493          	addi	s1,s1,-188 # 8000784c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	0000f997          	auipc	s3,0xf
    80000914:	02098993          	addi	s3,s3,32 # 8000f930 <tx_lock>
    80000918:	00007917          	auipc	s2,0x7
    8000091c:	f3090913          	addi	s2,s2,-208 # 80007848 <tx_chan>
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
    8000092c:	66c010ef          	jal	80001f98 <sleep>
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
    8000095a:	fda50513          	addi	a0,a0,-38 # 8000f930 <tx_lock>
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
    8000097e:	eca7a783          	lw	a5,-310(a5) # 80007844 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00007797          	auipc	a5,0x7
    80000988:	ebc7a783          	lw	a5,-324(a5) # 80007840 <panicked>
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
    800009ae:	e9a7a783          	lw	a5,-358(a5) # 80007844 <panicking>
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
    80000a0a:	f2a50513          	addi	a0,a0,-214 # 8000f930 <tx_lock>
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
    80000a24:	f1050513          	addi	a0,a0,-240 # 8000f930 <tx_lock>
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
    80000a40:	e007a823          	sw	zero,-496(a5) # 8000784c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00007517          	auipc	a0,0x7
    80000a48:	e0450513          	addi	a0,a0,-508 # 80007848 <tx_chan>
    80000a4c:	598010ef          	jal	80001fe4 <wakeup>
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
    80000a68:	0002c797          	auipc	a5,0x2c
    80000a6c:	11078793          	addi	a5,a5,272 # 8002cb78 <end>
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
    80000a96:	eb690913          	addi	s2,s2,-330 # 8000f948 <kmem>
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
    80000b24:	e2850513          	addi	a0,a0,-472 # 8000f948 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	0002c517          	auipc	a0,0x2c
    80000b34:	04850513          	addi	a0,a0,72 # 8002cb78 <end>
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
    80000b52:	dfa50513          	addi	a0,a0,-518 # 8000f948 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	0000f497          	auipc	s1,0xf
    80000b5e:	e064b483          	ld	s1,-506(s1) # 8000f960 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	0000f717          	auipc	a4,0xf
    80000b6a:	def73d23          	sd	a5,-518(a4) # 8000f960 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	0000f517          	auipc	a0,0xf
    80000b72:	dda50513          	addi	a0,a0,-550 # 8000f948 <kmem>
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
    80000b94:	db850513          	addi	a0,a0,-584 # 8000f948 <kmem>
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
    80000bce:	539000ef          	jal	80001906 <mycpu>
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
    80000bfe:	509000ef          	jal	80001906 <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	501000ef          	jal	80001906 <mycpu>
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
    80000c1a:	4ed000ef          	jal	80001906 <mycpu>
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
    80000c50:	4b7000ef          	jal	80001906 <mycpu>
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
    80000c74:	493000ef          	jal	80001906 <mycpu>
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
    80000eb6:	23d000ef          	jal	800018f2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00007717          	auipc	a4,0x7
    80000ebe:	99670713          	addi	a4,a4,-1642 # 80007850 <started>
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
    80000ece:	225000ef          	jal	800018f2 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00006517          	auipc	a0,0x6
    80000ed8:	1c450513          	addi	a0,a0,452 # 80007098 <etext+0x98>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	68e010ef          	jal	80002572 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	2d1040ef          	jal	800059b8 <plicinithart>
  }

  scheduler();
    80000eec:	713000ef          	jal	80001dfe <scheduler>
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
    80000f28:	119000ef          	jal	80001840 <procinit>
    trapinit();      // trap vectors
    80000f2c:	622010ef          	jal	8000254e <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	642010ef          	jal	80002572 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	26b040ef          	jal	8000599e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	281040ef          	jal	800059b8 <plicinithart>
    binit();         // buffer cache
    80000f3c:	507010ef          	jal	80002c42 <binit>
    iinit();         // inode table
    80000f40:	258020ef          	jal	80003198 <iinit>
    fileinit();      // file table
    80000f44:	184030ef          	jal	800040c8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	361040ef          	jal	80005aa8 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	4bd000ef          	jal	80001c08 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00007717          	auipc	a4,0x7
    80000f5a:	8ef72d23          	sw	a5,-1798(a4) # 80007850 <started>
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
    80000f70:	8ec7b783          	ld	a5,-1812(a5) # 80007858 <kernel_pagetable>
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
    800011fc:	66a7b023          	sd	a0,1632(a5) # 80007858 <kernel_pagetable>
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
    800015e0:	346000ef          	jal	80001926 <myproc>
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
    800017be:	5de48493          	addi	s1,s1,1502 # 8000fd98 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017c2:	8c26                	mv	s8,s1
    800017c4:	334a77b7          	lui	a5,0x334a7
    800017c8:	078a                	slli	a5,a5,0x2
    800017ca:	24578793          	addi	a5,a5,581 # 334a7245 <_entry-0x4cb58dbb>
    800017ce:	70914937          	lui	s2,0x70914
    800017d2:	f8b90913          	addi	s2,s2,-117 # 70913f8b <_entry-0xf6ec075>
    800017d6:	1902                	slli	s2,s2,0x20
    800017d8:	993e                	add	s2,s2,a5
    800017da:	040009b7          	lui	s3,0x4000
    800017de:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017e0:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e2:	4b99                	li	s7,6
    800017e4:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e6:	00020a97          	auipc	s5,0x20
    800017ea:	fb2a8a93          	addi	s5,s5,-78 # 80021798 <tickslock>
    char *pa = kalloc();
    800017ee:	b56ff0ef          	jal	80000b44 <kalloc>
    800017f2:	862a                	mv	a2,a0
    if(pa == 0)
    800017f4:	c121                	beqz	a0,80001834 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    800017f6:	418485b3          	sub	a1,s1,s8
    800017fa:	858d                	srai	a1,a1,0x3
    800017fc:	032585b3          	mul	a1,a1,s2
    80001800:	05b6                	slli	a1,a1,0xd
    80001802:	6789                	lui	a5,0x2
    80001804:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001806:	875e                	mv	a4,s7
    80001808:	86da                	mv	a3,s6
    8000180a:	40b985b3          	sub	a1,s3,a1
    8000180e:	8552                	mv	a0,s4
    80001810:	907ff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001814:	46848493          	addi	s1,s1,1128
    80001818:	fd549be3          	bne	s1,s5,800017ee <proc_mapstacks+0x4e>
  }
}
    8000181c:	60a6                	ld	ra,72(sp)
    8000181e:	6406                	ld	s0,64(sp)
    80001820:	74e2                	ld	s1,56(sp)
    80001822:	7942                	ld	s2,48(sp)
    80001824:	79a2                	ld	s3,40(sp)
    80001826:	7a02                	ld	s4,32(sp)
    80001828:	6ae2                	ld	s5,24(sp)
    8000182a:	6b42                	ld	s6,16(sp)
    8000182c:	6ba2                	ld	s7,8(sp)
    8000182e:	6c02                	ld	s8,0(sp)
    80001830:	6161                	addi	sp,sp,80
    80001832:	8082                	ret
      panic("kalloc");
    80001834:	00006517          	auipc	a0,0x6
    80001838:	92450513          	addi	a0,a0,-1756 # 80007158 <etext+0x158>
    8000183c:	fe9fe0ef          	jal	80000824 <panic>

0000000080001840 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001840:	7139                	addi	sp,sp,-64
    80001842:	fc06                	sd	ra,56(sp)
    80001844:	f822                	sd	s0,48(sp)
    80001846:	f426                	sd	s1,40(sp)
    80001848:	f04a                	sd	s2,32(sp)
    8000184a:	ec4e                	sd	s3,24(sp)
    8000184c:	e852                	sd	s4,16(sp)
    8000184e:	e456                	sd	s5,8(sp)
    80001850:	e05a                	sd	s6,0(sp)
    80001852:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001854:	00006597          	auipc	a1,0x6
    80001858:	90c58593          	addi	a1,a1,-1780 # 80007160 <etext+0x160>
    8000185c:	0000e517          	auipc	a0,0xe
    80001860:	10c50513          	addi	a0,a0,268 # 8000f968 <pid_lock>
    80001864:	b3aff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001868:	00006597          	auipc	a1,0x6
    8000186c:	90058593          	addi	a1,a1,-1792 # 80007168 <etext+0x168>
    80001870:	0000e517          	auipc	a0,0xe
    80001874:	11050513          	addi	a0,a0,272 # 8000f980 <wait_lock>
    80001878:	b26ff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	0000e497          	auipc	s1,0xe
    80001880:	51c48493          	addi	s1,s1,1308 # 8000fd98 <proc>
      initlock(&p->lock, "proc");
    80001884:	00006b17          	auipc	s6,0x6
    80001888:	8f4b0b13          	addi	s6,s6,-1804 # 80007178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000188c:	8aa6                	mv	s5,s1
    8000188e:	334a77b7          	lui	a5,0x334a7
    80001892:	078a                	slli	a5,a5,0x2
    80001894:	24578793          	addi	a5,a5,581 # 334a7245 <_entry-0x4cb58dbb>
    80001898:	70914937          	lui	s2,0x70914
    8000189c:	f8b90913          	addi	s2,s2,-117 # 70913f8b <_entry-0xf6ec075>
    800018a0:	1902                	slli	s2,s2,0x20
    800018a2:	993e                	add	s2,s2,a5
    800018a4:	040009b7          	lui	s3,0x4000
    800018a8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018aa:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ac:	00020a17          	auipc	s4,0x20
    800018b0:	eeca0a13          	addi	s4,s4,-276 # 80021798 <tickslock>
      initlock(&p->lock, "proc");
    800018b4:	85da                	mv	a1,s6
    800018b6:	8526                	mv	a0,s1
    800018b8:	ae6ff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800018bc:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018c0:	415487b3          	sub	a5,s1,s5
    800018c4:	878d                	srai	a5,a5,0x3
    800018c6:	032787b3          	mul	a5,a5,s2
    800018ca:	07b6                	slli	a5,a5,0xd
    800018cc:	6709                	lui	a4,0x2
    800018ce:	9fb9                	addw	a5,a5,a4
    800018d0:	40f987b3          	sub	a5,s3,a5
    800018d4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018d6:	46848493          	addi	s1,s1,1128
    800018da:	fd449de3          	bne	s1,s4,800018b4 <procinit+0x74>
  }
}
    800018de:	70e2                	ld	ra,56(sp)
    800018e0:	7442                	ld	s0,48(sp)
    800018e2:	74a2                	ld	s1,40(sp)
    800018e4:	7902                	ld	s2,32(sp)
    800018e6:	69e2                	ld	s3,24(sp)
    800018e8:	6a42                	ld	s4,16(sp)
    800018ea:	6aa2                	ld	s5,8(sp)
    800018ec:	6b02                	ld	s6,0(sp)
    800018ee:	6121                	addi	sp,sp,64
    800018f0:	8082                	ret

00000000800018f2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018f2:	1141                	addi	sp,sp,-16
    800018f4:	e406                	sd	ra,8(sp)
    800018f6:	e022                	sd	s0,0(sp)
    800018f8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018fa:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018fc:	2501                	sext.w	a0,a0
    800018fe:	60a2                	ld	ra,8(sp)
    80001900:	6402                	ld	s0,0(sp)
    80001902:	0141                	addi	sp,sp,16
    80001904:	8082                	ret

0000000080001906 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001906:	1141                	addi	sp,sp,-16
    80001908:	e406                	sd	ra,8(sp)
    8000190a:	e022                	sd	s0,0(sp)
    8000190c:	0800                	addi	s0,sp,16
    8000190e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001910:	2781                	sext.w	a5,a5
    80001912:	079e                	slli	a5,a5,0x7
  return c;
}
    80001914:	0000e517          	auipc	a0,0xe
    80001918:	08450513          	addi	a0,a0,132 # 8000f998 <cpus>
    8000191c:	953e                	add	a0,a0,a5
    8000191e:	60a2                	ld	ra,8(sp)
    80001920:	6402                	ld	s0,0(sp)
    80001922:	0141                	addi	sp,sp,16
    80001924:	8082                	ret

0000000080001926 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001926:	1101                	addi	sp,sp,-32
    80001928:	ec06                	sd	ra,24(sp)
    8000192a:	e822                	sd	s0,16(sp)
    8000192c:	e426                	sd	s1,8(sp)
    8000192e:	1000                	addi	s0,sp,32
  push_off();
    80001930:	ab4ff0ef          	jal	80000be4 <push_off>
    80001934:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001936:	2781                	sext.w	a5,a5
    80001938:	079e                	slli	a5,a5,0x7
    8000193a:	0000e717          	auipc	a4,0xe
    8000193e:	02e70713          	addi	a4,a4,46 # 8000f968 <pid_lock>
    80001942:	97ba                	add	a5,a5,a4
    80001944:	7b9c                	ld	a5,48(a5)
    80001946:	84be                	mv	s1,a5
  pop_off();
    80001948:	b24ff0ef          	jal	80000c6c <pop_off>
  return p;
}
    8000194c:	8526                	mv	a0,s1
    8000194e:	60e2                	ld	ra,24(sp)
    80001950:	6442                	ld	s0,16(sp)
    80001952:	64a2                	ld	s1,8(sp)
    80001954:	6105                	addi	sp,sp,32
    80001956:	8082                	ret

0000000080001958 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001962:	fc5ff0ef          	jal	80001926 <myproc>
    80001966:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001968:	b54ff0ef          	jal	80000cbc <release>

  if (first) {
    8000196c:	00006797          	auipc	a5,0x6
    80001970:	ec47a783          	lw	a5,-316(a5) # 80007830 <first.1>
    80001974:	cf95                	beqz	a5,800019b0 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001976:	4505                	li	a0,1
    80001978:	4dd010ef          	jal	80003654 <fsinit>

    first = 0;
    8000197c:	00006797          	auipc	a5,0x6
    80001980:	ea07aa23          	sw	zero,-332(a5) # 80007830 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001984:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001988:	00005797          	auipc	a5,0x5
    8000198c:	7f878793          	addi	a5,a5,2040 # 80007180 <etext+0x180>
    80001990:	fcf43823          	sd	a5,-48(s0)
    80001994:	fc043c23          	sd	zero,-40(s0)
    80001998:	fd040593          	addi	a1,s0,-48
    8000199c:	853e                	mv	a0,a5
    8000199e:	63f020ef          	jal	800047dc <kexec>
    800019a2:	6cbc                	ld	a5,88(s1)
    800019a4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800019a6:	6cbc                	ld	a5,88(s1)
    800019a8:	7bb8                	ld	a4,112(a5)
    800019aa:	57fd                	li	a5,-1
    800019ac:	02f70d63          	beq	a4,a5,800019e6 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019b0:	3df000ef          	jal	8000258e <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019b4:	68a8                	ld	a0,80(s1)
    800019b6:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019b8:	04000737          	lui	a4,0x4000
    800019bc:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019be:	0732                	slli	a4,a4,0xc
    800019c0:	00004797          	auipc	a5,0x4
    800019c4:	6dc78793          	addi	a5,a5,1756 # 8000609c <userret>
    800019c8:	00004697          	auipc	a3,0x4
    800019cc:	63868693          	addi	a3,a3,1592 # 80006000 <_trampoline>
    800019d0:	8f95                	sub	a5,a5,a3
    800019d2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019d4:	577d                	li	a4,-1
    800019d6:	177e                	slli	a4,a4,0x3f
    800019d8:	8d59                	or	a0,a0,a4
    800019da:	9782                	jalr	a5
}
    800019dc:	70a2                	ld	ra,40(sp)
    800019de:	7402                	ld	s0,32(sp)
    800019e0:	64e2                	ld	s1,24(sp)
    800019e2:	6145                	addi	sp,sp,48
    800019e4:	8082                	ret
      panic("exec");
    800019e6:	00005517          	auipc	a0,0x5
    800019ea:	7a250513          	addi	a0,a0,1954 # 80007188 <etext+0x188>
    800019ee:	e37fe0ef          	jal	80000824 <panic>

00000000800019f2 <allocpid>:
{
    800019f2:	1101                	addi	sp,sp,-32
    800019f4:	ec06                	sd	ra,24(sp)
    800019f6:	e822                	sd	s0,16(sp)
    800019f8:	e426                	sd	s1,8(sp)
    800019fa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019fc:	0000e517          	auipc	a0,0xe
    80001a00:	f6c50513          	addi	a0,a0,-148 # 8000f968 <pid_lock>
    80001a04:	a24ff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001a08:	00006797          	auipc	a5,0x6
    80001a0c:	e2c78793          	addi	a5,a5,-468 # 80007834 <nextpid>
    80001a10:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a12:	0014871b          	addiw	a4,s1,1
    80001a16:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a18:	0000e517          	auipc	a0,0xe
    80001a1c:	f5050513          	addi	a0,a0,-176 # 8000f968 <pid_lock>
    80001a20:	a9cff0ef          	jal	80000cbc <release>
}
    80001a24:	8526                	mv	a0,s1
    80001a26:	60e2                	ld	ra,24(sp)
    80001a28:	6442                	ld	s0,16(sp)
    80001a2a:	64a2                	ld	s1,8(sp)
    80001a2c:	6105                	addi	sp,sp,32
    80001a2e:	8082                	ret

0000000080001a30 <proc_pagetable>:
{
    80001a30:	1101                	addi	sp,sp,-32
    80001a32:	ec06                	sd	ra,24(sp)
    80001a34:	e822                	sd	s0,16(sp)
    80001a36:	e426                	sd	s1,8(sp)
    80001a38:	e04a                	sd	s2,0(sp)
    80001a3a:	1000                	addi	s0,sp,32
    80001a3c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a3e:	fcaff0ef          	jal	80001208 <uvmcreate>
    80001a42:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a44:	cd05                	beqz	a0,80001a7c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a46:	4729                	li	a4,10
    80001a48:	00004697          	auipc	a3,0x4
    80001a4c:	5b868693          	addi	a3,a3,1464 # 80006000 <_trampoline>
    80001a50:	6605                	lui	a2,0x1
    80001a52:	040005b7          	lui	a1,0x4000
    80001a56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a58:	05b2                	slli	a1,a1,0xc
    80001a5a:	e06ff0ef          	jal	80001060 <mappages>
    80001a5e:	02054663          	bltz	a0,80001a8a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a62:	4719                	li	a4,6
    80001a64:	05893683          	ld	a3,88(s2)
    80001a68:	6605                	lui	a2,0x1
    80001a6a:	020005b7          	lui	a1,0x2000
    80001a6e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a70:	05b6                	slli	a1,a1,0xd
    80001a72:	8526                	mv	a0,s1
    80001a74:	decff0ef          	jal	80001060 <mappages>
    80001a78:	00054f63          	bltz	a0,80001a96 <proc_pagetable+0x66>
}
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	60e2                	ld	ra,24(sp)
    80001a80:	6442                	ld	s0,16(sp)
    80001a82:	64a2                	ld	s1,8(sp)
    80001a84:	6902                	ld	s2,0(sp)
    80001a86:	6105                	addi	sp,sp,32
    80001a88:	8082                	ret
    uvmfree(pagetable, 0);
    80001a8a:	4581                	li	a1,0
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	975ff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001a92:	4481                	li	s1,0
    80001a94:	b7e5                	j	80001a7c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a96:	4681                	li	a3,0
    80001a98:	4605                	li	a2,1
    80001a9a:	040005b7          	lui	a1,0x4000
    80001a9e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aa0:	05b2                	slli	a1,a1,0xc
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	f8aff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80001aa8:	4581                	li	a1,0
    80001aaa:	8526                	mv	a0,s1
    80001aac:	957ff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001ab0:	4481                	li	s1,0
    80001ab2:	b7e9                	j	80001a7c <proc_pagetable+0x4c>

0000000080001ab4 <proc_freepagetable>:
{
    80001ab4:	1101                	addi	sp,sp,-32
    80001ab6:	ec06                	sd	ra,24(sp)
    80001ab8:	e822                	sd	s0,16(sp)
    80001aba:	e426                	sd	s1,8(sp)
    80001abc:	e04a                	sd	s2,0(sp)
    80001abe:	1000                	addi	s0,sp,32
    80001ac0:	84aa                	mv	s1,a0
    80001ac2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ac4:	4681                	li	a3,0
    80001ac6:	4605                	li	a2,1
    80001ac8:	040005b7          	lui	a1,0x4000
    80001acc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ace:	05b2                	slli	a1,a1,0xc
    80001ad0:	f5eff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ad4:	4681                	li	a3,0
    80001ad6:	4605                	li	a2,1
    80001ad8:	020005b7          	lui	a1,0x2000
    80001adc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ade:	05b6                	slli	a1,a1,0xd
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	f4cff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80001ae6:	85ca                	mv	a1,s2
    80001ae8:	8526                	mv	a0,s1
    80001aea:	919ff0ef          	jal	80001402 <uvmfree>
}
    80001aee:	60e2                	ld	ra,24(sp)
    80001af0:	6442                	ld	s0,16(sp)
    80001af2:	64a2                	ld	s1,8(sp)
    80001af4:	6902                	ld	s2,0(sp)
    80001af6:	6105                	addi	sp,sp,32
    80001af8:	8082                	ret

0000000080001afa <freeproc>:
{
    80001afa:	1101                	addi	sp,sp,-32
    80001afc:	ec06                	sd	ra,24(sp)
    80001afe:	e822                	sd	s0,16(sp)
    80001b00:	e426                	sd	s1,8(sp)
    80001b02:	1000                	addi	s0,sp,32
    80001b04:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b06:	6d28                	ld	a0,88(a0)
    80001b08:	c119                	beqz	a0,80001b0e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b0a:	f53fe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001b0e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b12:	68a8                	ld	a0,80(s1)
    80001b14:	c501                	beqz	a0,80001b1c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b16:	64ac                	ld	a1,72(s1)
    80001b18:	f9dff0ef          	jal	80001ab4 <proc_freepagetable>
  p->pagetable = 0;
    80001b1c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b20:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b24:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b28:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b2c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b30:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b34:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b38:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b3c:	0004ac23          	sw	zero,24(s1)
}
    80001b40:	60e2                	ld	ra,24(sp)
    80001b42:	6442                	ld	s0,16(sp)
    80001b44:	64a2                	ld	s1,8(sp)
    80001b46:	6105                	addi	sp,sp,32
    80001b48:	8082                	ret

0000000080001b4a <allocproc>:
{
    80001b4a:	1101                	addi	sp,sp,-32
    80001b4c:	ec06                	sd	ra,24(sp)
    80001b4e:	e822                	sd	s0,16(sp)
    80001b50:	e426                	sd	s1,8(sp)
    80001b52:	e04a                	sd	s2,0(sp)
    80001b54:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b56:	0000e497          	auipc	s1,0xe
    80001b5a:	24248493          	addi	s1,s1,578 # 8000fd98 <proc>
    80001b5e:	00020917          	auipc	s2,0x20
    80001b62:	c3a90913          	addi	s2,s2,-966 # 80021798 <tickslock>
    acquire(&p->lock);
    80001b66:	8526                	mv	a0,s1
    80001b68:	8c0ff0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001b6c:	4c9c                	lw	a5,24(s1)
    80001b6e:	cb91                	beqz	a5,80001b82 <allocproc+0x38>
      release(&p->lock);
    80001b70:	8526                	mv	a0,s1
    80001b72:	94aff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b76:	46848493          	addi	s1,s1,1128
    80001b7a:	ff2496e3          	bne	s1,s2,80001b66 <allocproc+0x1c>
  return 0;
    80001b7e:	4481                	li	s1,0
    80001b80:	a8a9                	j	80001bda <allocproc+0x90>
  p->pid = allocpid();
    80001b82:	e71ff0ef          	jal	800019f2 <allocpid>
    80001b86:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b88:	4785                	li	a5,1
    80001b8a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b8c:	fb9fe0ef          	jal	80000b44 <kalloc>
    80001b90:	892a                	mv	s2,a0
    80001b92:	eca8                	sd	a0,88(s1)
    80001b94:	c931                	beqz	a0,80001be8 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001b96:	8526                	mv	a0,s1
    80001b98:	e99ff0ef          	jal	80001a30 <proc_pagetable>
    80001b9c:	892a                	mv	s2,a0
    80001b9e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001ba0:	cd21                	beqz	a0,80001bf8 <allocproc+0xae>
  memset(&p->context, 0, sizeof(p->context));
    80001ba2:	07000613          	li	a2,112
    80001ba6:	4581                	li	a1,0
    80001ba8:	06048513          	addi	a0,s1,96
    80001bac:	94cff0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001bb0:	00000797          	auipc	a5,0x0
    80001bb4:	da878793          	addi	a5,a5,-600 # 80001958 <forkret>
    80001bb8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bba:	60bc                	ld	a5,64(s1)
    80001bbc:	6705                	lui	a4,0x1
    80001bbe:	97ba                	add	a5,a5,a4
    80001bc0:	f4bc                	sd	a5,104(s1)
  for(int i = 0; i < NVMA; i++){
    80001bc2:	16848793          	addi	a5,s1,360
    80001bc6:	46848713          	addi	a4,s1,1128
    p->vmas[i].used = 0;
    80001bca:	0007a023          	sw	zero,0(a5)
    p->vmas[i].f = 0;
    80001bce:	0207b423          	sd	zero,40(a5)
  for(int i = 0; i < NVMA; i++){
    80001bd2:	03078793          	addi	a5,a5,48
    80001bd6:	fee79ae3          	bne	a5,a4,80001bca <allocproc+0x80>
}
    80001bda:	8526                	mv	a0,s1
    80001bdc:	60e2                	ld	ra,24(sp)
    80001bde:	6442                	ld	s0,16(sp)
    80001be0:	64a2                	ld	s1,8(sp)
    80001be2:	6902                	ld	s2,0(sp)
    80001be4:	6105                	addi	sp,sp,32
    80001be6:	8082                	ret
    freeproc(p);
    80001be8:	8526                	mv	a0,s1
    80001bea:	f11ff0ef          	jal	80001afa <freeproc>
    release(&p->lock);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	8ccff0ef          	jal	80000cbc <release>
    return 0;
    80001bf4:	84ca                	mv	s1,s2
    80001bf6:	b7d5                	j	80001bda <allocproc+0x90>
    freeproc(p);
    80001bf8:	8526                	mv	a0,s1
    80001bfa:	f01ff0ef          	jal	80001afa <freeproc>
    release(&p->lock);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	8bcff0ef          	jal	80000cbc <release>
    return 0;
    80001c04:	84ca                	mv	s1,s2
    80001c06:	bfd1                	j	80001bda <allocproc+0x90>

0000000080001c08 <userinit>:
{
    80001c08:	1101                	addi	sp,sp,-32
    80001c0a:	ec06                	sd	ra,24(sp)
    80001c0c:	e822                	sd	s0,16(sp)
    80001c0e:	e426                	sd	s1,8(sp)
    80001c10:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c12:	f39ff0ef          	jal	80001b4a <allocproc>
    80001c16:	84aa                	mv	s1,a0
  initproc = p;
    80001c18:	00006797          	auipc	a5,0x6
    80001c1c:	c4a7b423          	sd	a0,-952(a5) # 80007860 <initproc>
  p->cwd = namei("/");
    80001c20:	00005517          	auipc	a0,0x5
    80001c24:	57050513          	addi	a0,a0,1392 # 80007190 <etext+0x190>
    80001c28:	767010ef          	jal	80003b8e <namei>
    80001c2c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c30:	478d                	li	a5,3
    80001c32:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c34:	8526                	mv	a0,s1
    80001c36:	886ff0ef          	jal	80000cbc <release>
}
    80001c3a:	60e2                	ld	ra,24(sp)
    80001c3c:	6442                	ld	s0,16(sp)
    80001c3e:	64a2                	ld	s1,8(sp)
    80001c40:	6105                	addi	sp,sp,32
    80001c42:	8082                	ret

0000000080001c44 <growproc>:
{
    80001c44:	1101                	addi	sp,sp,-32
    80001c46:	ec06                	sd	ra,24(sp)
    80001c48:	e822                	sd	s0,16(sp)
    80001c4a:	e426                	sd	s1,8(sp)
    80001c4c:	e04a                	sd	s2,0(sp)
    80001c4e:	1000                	addi	s0,sp,32
    80001c50:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c52:	cd5ff0ef          	jal	80001926 <myproc>
    80001c56:	892a                	mv	s2,a0
  sz = p->sz;
    80001c58:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c5a:	02905963          	blez	s1,80001c8c <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001c5e:	00b48633          	add	a2,s1,a1
    80001c62:	020007b7          	lui	a5,0x2000
    80001c66:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c68:	07b6                	slli	a5,a5,0xd
    80001c6a:	02c7ea63          	bltu	a5,a2,80001c9e <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c6e:	4691                	li	a3,4
    80001c70:	6928                	ld	a0,80(a0)
    80001c72:	e8aff0ef          	jal	800012fc <uvmalloc>
    80001c76:	85aa                	mv	a1,a0
    80001c78:	c50d                	beqz	a0,80001ca2 <growproc+0x5e>
  p->sz = sz;
    80001c7a:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c7e:	4501                	li	a0,0
}
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6902                	ld	s2,0(sp)
    80001c88:	6105                	addi	sp,sp,32
    80001c8a:	8082                	ret
  } else if(n < 0){
    80001c8c:	fe04d7e3          	bgez	s1,80001c7a <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c90:	00b48633          	add	a2,s1,a1
    80001c94:	6928                	ld	a0,80(a0)
    80001c96:	e22ff0ef          	jal	800012b8 <uvmdealloc>
    80001c9a:	85aa                	mv	a1,a0
    80001c9c:	bff9                	j	80001c7a <growproc+0x36>
      return -1;
    80001c9e:	557d                	li	a0,-1
    80001ca0:	b7c5                	j	80001c80 <growproc+0x3c>
      return -1;
    80001ca2:	557d                	li	a0,-1
    80001ca4:	bff1                	j	80001c80 <growproc+0x3c>

0000000080001ca6 <kfork>:
{
    80001ca6:	7139                	addi	sp,sp,-64
    80001ca8:	fc06                	sd	ra,56(sp)
    80001caa:	f822                	sd	s0,48(sp)
    80001cac:	f426                	sd	s1,40(sp)
    80001cae:	e852                	sd	s4,16(sp)
    80001cb0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001cb2:	c75ff0ef          	jal	80001926 <myproc>
    80001cb6:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001cb8:	e93ff0ef          	jal	80001b4a <allocproc>
    80001cbc:	12050f63          	beqz	a0,80001dfa <kfork+0x154>
    80001cc0:	ec4e                	sd	s3,24(sp)
    80001cc2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001cc4:	048a3603          	ld	a2,72(s4)
    80001cc8:	692c                	ld	a1,80(a0)
    80001cca:	050a3503          	ld	a0,80(s4)
    80001cce:	f66ff0ef          	jal	80001434 <uvmcopy>
    80001cd2:	00054f63          	bltz	a0,80001cf0 <kfork+0x4a>
    80001cd6:	f04a                	sd	s2,32(sp)
    80001cd8:	e456                	sd	s5,8(sp)
  np->sz = p->sz;
    80001cda:	048a3783          	ld	a5,72(s4)
    80001cde:	04f9b423          	sd	a5,72(s3)
  for(int i = 0; i < NVMA; i++) {
    80001ce2:	168a0913          	addi	s2,s4,360
    80001ce6:	16898493          	addi	s1,s3,360
    80001cea:	46898a93          	addi	s5,s3,1128
    80001cee:	a005                	j	80001d0e <kfork+0x68>
    freeproc(np);
    80001cf0:	854e                	mv	a0,s3
    80001cf2:	e09ff0ef          	jal	80001afa <freeproc>
    release(&np->lock);
    80001cf6:	854e                	mv	a0,s3
    80001cf8:	fc5fe0ef          	jal	80000cbc <release>
    return -1;
    80001cfc:	54fd                	li	s1,-1
    80001cfe:	69e2                	ld	s3,24(sp)
    80001d00:	a0f5                	j	80001dec <kfork+0x146>
  for(int i = 0; i < NVMA; i++) {
    80001d02:	03090913          	addi	s2,s2,48
    80001d06:	03048493          	addi	s1,s1,48
    80001d0a:	03548a63          	beq	s1,s5,80001d3e <kfork+0x98>
    np->vmas[i] = p->vmas[i];
    80001d0e:	00093583          	ld	a1,0(s2)
    80001d12:	00893603          	ld	a2,8(s2)
    80001d16:	01093683          	ld	a3,16(s2)
    80001d1a:	01893703          	ld	a4,24(s2)
    80001d1e:	02093783          	ld	a5,32(s2)
    80001d22:	e08c                	sd	a1,0(s1)
    80001d24:	e490                	sd	a2,8(s1)
    80001d26:	e894                	sd	a3,16(s1)
    80001d28:	ec98                	sd	a4,24(s1)
    80001d2a:	f09c                	sd	a5,32(s1)
    80001d2c:	02893783          	ld	a5,40(s2)
    80001d30:	f49c                	sd	a5,40(s1)
    if(np->vmas[i].used) {
    80001d32:	409c                	lw	a5,0(s1)
    80001d34:	d7f9                	beqz	a5,80001d02 <kfork+0x5c>
      filedup(np->vmas[i].f);
    80001d36:	7488                	ld	a0,40(s1)
    80001d38:	412020ef          	jal	8000414a <filedup>
    80001d3c:	b7d9                	j	80001d02 <kfork+0x5c>
  *(np->trapframe) = *(p->trapframe);
    80001d3e:	058a3683          	ld	a3,88(s4)
    80001d42:	87b6                	mv	a5,a3
    80001d44:	0589b703          	ld	a4,88(s3)
    80001d48:	12068693          	addi	a3,a3,288
    80001d4c:	6388                	ld	a0,0(a5)
    80001d4e:	678c                	ld	a1,8(a5)
    80001d50:	6b90                	ld	a2,16(a5)
    80001d52:	e308                	sd	a0,0(a4)
    80001d54:	e70c                	sd	a1,8(a4)
    80001d56:	eb10                	sd	a2,16(a4)
    80001d58:	6f90                	ld	a2,24(a5)
    80001d5a:	ef10                	sd	a2,24(a4)
    80001d5c:	02078793          	addi	a5,a5,32
    80001d60:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001d64:	fed794e3          	bne	a5,a3,80001d4c <kfork+0xa6>
  np->trapframe->a0 = 0;
    80001d68:	0589b783          	ld	a5,88(s3)
    80001d6c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d70:	0d0a0493          	addi	s1,s4,208
    80001d74:	0d098913          	addi	s2,s3,208
    80001d78:	150a0a93          	addi	s5,s4,336
    80001d7c:	a029                	j	80001d86 <kfork+0xe0>
    80001d7e:	04a1                	addi	s1,s1,8
    80001d80:	0921                	addi	s2,s2,8
    80001d82:	01548963          	beq	s1,s5,80001d94 <kfork+0xee>
    if(p->ofile[i])
    80001d86:	6088                	ld	a0,0(s1)
    80001d88:	d97d                	beqz	a0,80001d7e <kfork+0xd8>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d8a:	3c0020ef          	jal	8000414a <filedup>
    80001d8e:	00a93023          	sd	a0,0(s2)
    80001d92:	b7f5                	j	80001d7e <kfork+0xd8>
  np->cwd = idup(p->cwd);
    80001d94:	150a3503          	ld	a0,336(s4)
    80001d98:	592010ef          	jal	8000332a <idup>
    80001d9c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001da0:	4641                	li	a2,16
    80001da2:	158a0593          	addi	a1,s4,344
    80001da6:	15898513          	addi	a0,s3,344
    80001daa:	8a2ff0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001dae:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001db2:	854e                	mv	a0,s3
    80001db4:	f09fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001db8:	0000e517          	auipc	a0,0xe
    80001dbc:	bc850513          	addi	a0,a0,-1080 # 8000f980 <wait_lock>
    80001dc0:	e69fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001dc4:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    80001dc8:	0000e517          	auipc	a0,0xe
    80001dcc:	bb850513          	addi	a0,a0,-1096 # 8000f980 <wait_lock>
    80001dd0:	eedfe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001dd4:	854e                	mv	a0,s3
    80001dd6:	e53fe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001dda:	478d                	li	a5,3
    80001ddc:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001de0:	854e                	mv	a0,s3
    80001de2:	edbfe0ef          	jal	80000cbc <release>
  return pid;
    80001de6:	7902                	ld	s2,32(sp)
    80001de8:	69e2                	ld	s3,24(sp)
    80001dea:	6aa2                	ld	s5,8(sp)
}
    80001dec:	8526                	mv	a0,s1
    80001dee:	70e2                	ld	ra,56(sp)
    80001df0:	7442                	ld	s0,48(sp)
    80001df2:	74a2                	ld	s1,40(sp)
    80001df4:	6a42                	ld	s4,16(sp)
    80001df6:	6121                	addi	sp,sp,64
    80001df8:	8082                	ret
    return -1;
    80001dfa:	54fd                	li	s1,-1
    80001dfc:	bfc5                	j	80001dec <kfork+0x146>

0000000080001dfe <scheduler>:
{
    80001dfe:	715d                	addi	sp,sp,-80
    80001e00:	e486                	sd	ra,72(sp)
    80001e02:	e0a2                	sd	s0,64(sp)
    80001e04:	fc26                	sd	s1,56(sp)
    80001e06:	f84a                	sd	s2,48(sp)
    80001e08:	f44e                	sd	s3,40(sp)
    80001e0a:	f052                	sd	s4,32(sp)
    80001e0c:	ec56                	sd	s5,24(sp)
    80001e0e:	e85a                	sd	s6,16(sp)
    80001e10:	e45e                	sd	s7,8(sp)
    80001e12:	e062                	sd	s8,0(sp)
    80001e14:	0880                	addi	s0,sp,80
    80001e16:	8792                	mv	a5,tp
  int id = r_tp();
    80001e18:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e1a:	00779b13          	slli	s6,a5,0x7
    80001e1e:	0000e717          	auipc	a4,0xe
    80001e22:	b4a70713          	addi	a4,a4,-1206 # 8000f968 <pid_lock>
    80001e26:	975a                	add	a4,a4,s6
    80001e28:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001e2c:	0000e717          	auipc	a4,0xe
    80001e30:	b7470713          	addi	a4,a4,-1164 # 8000f9a0 <cpus+0x8>
    80001e34:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001e36:	4c11                	li	s8,4
        c->proc = p;
    80001e38:	079e                	slli	a5,a5,0x7
    80001e3a:	0000ea17          	auipc	s4,0xe
    80001e3e:	b2ea0a13          	addi	s4,s4,-1234 # 8000f968 <pid_lock>
    80001e42:	9a3e                	add	s4,s4,a5
        found = 1;
    80001e44:	4b85                	li	s7,1
    80001e46:	a83d                	j	80001e84 <scheduler+0x86>
      release(&p->lock);
    80001e48:	8526                	mv	a0,s1
    80001e4a:	e73fe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e4e:	46848493          	addi	s1,s1,1128
    80001e52:	03248563          	beq	s1,s2,80001e7c <scheduler+0x7e>
      acquire(&p->lock);
    80001e56:	8526                	mv	a0,s1
    80001e58:	dd1fe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80001e5c:	4c9c                	lw	a5,24(s1)
    80001e5e:	ff3795e3          	bne	a5,s3,80001e48 <scheduler+0x4a>
        p->state = RUNNING;
    80001e62:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001e66:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001e6a:	06048593          	addi	a1,s1,96
    80001e6e:	855a                	mv	a0,s6
    80001e70:	674000ef          	jal	800024e4 <swtch>
        c->proc = 0;
    80001e74:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e78:	8ade                	mv	s5,s7
    80001e7a:	b7f9                	j	80001e48 <scheduler+0x4a>
    if(found == 0) {
    80001e7c:	000a9463          	bnez	s5,80001e84 <scheduler+0x86>
      asm volatile("wfi");
    80001e80:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e8c:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e94:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e96:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e9a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e9c:	0000e497          	auipc	s1,0xe
    80001ea0:	efc48493          	addi	s1,s1,-260 # 8000fd98 <proc>
      if(p->state == RUNNABLE) {
    80001ea4:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ea6:	00020917          	auipc	s2,0x20
    80001eaa:	8f290913          	addi	s2,s2,-1806 # 80021798 <tickslock>
    80001eae:	b765                	j	80001e56 <scheduler+0x58>

0000000080001eb0 <sched>:
{
    80001eb0:	7179                	addi	sp,sp,-48
    80001eb2:	f406                	sd	ra,40(sp)
    80001eb4:	f022                	sd	s0,32(sp)
    80001eb6:	ec26                	sd	s1,24(sp)
    80001eb8:	e84a                	sd	s2,16(sp)
    80001eba:	e44e                	sd	s3,8(sp)
    80001ebc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001ebe:	a69ff0ef          	jal	80001926 <myproc>
    80001ec2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ec4:	cf5fe0ef          	jal	80000bb8 <holding>
    80001ec8:	c935                	beqz	a0,80001f3c <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001eca:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ecc:	2781                	sext.w	a5,a5
    80001ece:	079e                	slli	a5,a5,0x7
    80001ed0:	0000e717          	auipc	a4,0xe
    80001ed4:	a9870713          	addi	a4,a4,-1384 # 8000f968 <pid_lock>
    80001ed8:	97ba                	add	a5,a5,a4
    80001eda:	0a87a703          	lw	a4,168(a5)
    80001ede:	4785                	li	a5,1
    80001ee0:	06f71463          	bne	a4,a5,80001f48 <sched+0x98>
  if(p->state == RUNNING)
    80001ee4:	4c98                	lw	a4,24(s1)
    80001ee6:	4791                	li	a5,4
    80001ee8:	06f70663          	beq	a4,a5,80001f54 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ef0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001ef2:	e7bd                	bnez	a5,80001f60 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ef4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001ef6:	0000e917          	auipc	s2,0xe
    80001efa:	a7290913          	addi	s2,s2,-1422 # 8000f968 <pid_lock>
    80001efe:	2781                	sext.w	a5,a5
    80001f00:	079e                	slli	a5,a5,0x7
    80001f02:	97ca                	add	a5,a5,s2
    80001f04:	0ac7a983          	lw	s3,172(a5)
    80001f08:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f0a:	2781                	sext.w	a5,a5
    80001f0c:	079e                	slli	a5,a5,0x7
    80001f0e:	07a1                	addi	a5,a5,8
    80001f10:	0000e597          	auipc	a1,0xe
    80001f14:	a8858593          	addi	a1,a1,-1400 # 8000f998 <cpus>
    80001f18:	95be                	add	a1,a1,a5
    80001f1a:	06048513          	addi	a0,s1,96
    80001f1e:	5c6000ef          	jal	800024e4 <swtch>
    80001f22:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f24:	2781                	sext.w	a5,a5
    80001f26:	079e                	slli	a5,a5,0x7
    80001f28:	993e                	add	s2,s2,a5
    80001f2a:	0b392623          	sw	s3,172(s2)
}
    80001f2e:	70a2                	ld	ra,40(sp)
    80001f30:	7402                	ld	s0,32(sp)
    80001f32:	64e2                	ld	s1,24(sp)
    80001f34:	6942                	ld	s2,16(sp)
    80001f36:	69a2                	ld	s3,8(sp)
    80001f38:	6145                	addi	sp,sp,48
    80001f3a:	8082                	ret
    panic("sched p->lock");
    80001f3c:	00005517          	auipc	a0,0x5
    80001f40:	25c50513          	addi	a0,a0,604 # 80007198 <etext+0x198>
    80001f44:	8e1fe0ef          	jal	80000824 <panic>
    panic("sched locks");
    80001f48:	00005517          	auipc	a0,0x5
    80001f4c:	26050513          	addi	a0,a0,608 # 800071a8 <etext+0x1a8>
    80001f50:	8d5fe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    80001f54:	00005517          	auipc	a0,0x5
    80001f58:	26450513          	addi	a0,a0,612 # 800071b8 <etext+0x1b8>
    80001f5c:	8c9fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    80001f60:	00005517          	auipc	a0,0x5
    80001f64:	26850513          	addi	a0,a0,616 # 800071c8 <etext+0x1c8>
    80001f68:	8bdfe0ef          	jal	80000824 <panic>

0000000080001f6c <yield>:
{
    80001f6c:	1101                	addi	sp,sp,-32
    80001f6e:	ec06                	sd	ra,24(sp)
    80001f70:	e822                	sd	s0,16(sp)
    80001f72:	e426                	sd	s1,8(sp)
    80001f74:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f76:	9b1ff0ef          	jal	80001926 <myproc>
    80001f7a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f7c:	cadfe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80001f80:	478d                	li	a5,3
    80001f82:	cc9c                	sw	a5,24(s1)
  sched();
    80001f84:	f2dff0ef          	jal	80001eb0 <sched>
  release(&p->lock);
    80001f88:	8526                	mv	a0,s1
    80001f8a:	d33fe0ef          	jal	80000cbc <release>
}
    80001f8e:	60e2                	ld	ra,24(sp)
    80001f90:	6442                	ld	s0,16(sp)
    80001f92:	64a2                	ld	s1,8(sp)
    80001f94:	6105                	addi	sp,sp,32
    80001f96:	8082                	ret

0000000080001f98 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f98:	7179                	addi	sp,sp,-48
    80001f9a:	f406                	sd	ra,40(sp)
    80001f9c:	f022                	sd	s0,32(sp)
    80001f9e:	ec26                	sd	s1,24(sp)
    80001fa0:	e84a                	sd	s2,16(sp)
    80001fa2:	e44e                	sd	s3,8(sp)
    80001fa4:	1800                	addi	s0,sp,48
    80001fa6:	89aa                	mv	s3,a0
    80001fa8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001faa:	97dff0ef          	jal	80001926 <myproc>
    80001fae:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001fb0:	c79fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80001fb4:	854a                	mv	a0,s2
    80001fb6:	d07fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    80001fba:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001fbe:	4789                	li	a5,2
    80001fc0:	cc9c                	sw	a5,24(s1)

  sched();
    80001fc2:	eefff0ef          	jal	80001eb0 <sched>

  // Tidy up.
  p->chan = 0;
    80001fc6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	cf1fe0ef          	jal	80000cbc <release>
  acquire(lk);
    80001fd0:	854a                	mv	a0,s2
    80001fd2:	c57fe0ef          	jal	80000c28 <acquire>
}
    80001fd6:	70a2                	ld	ra,40(sp)
    80001fd8:	7402                	ld	s0,32(sp)
    80001fda:	64e2                	ld	s1,24(sp)
    80001fdc:	6942                	ld	s2,16(sp)
    80001fde:	69a2                	ld	s3,8(sp)
    80001fe0:	6145                	addi	sp,sp,48
    80001fe2:	8082                	ret

0000000080001fe4 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001fe4:	7139                	addi	sp,sp,-64
    80001fe6:	fc06                	sd	ra,56(sp)
    80001fe8:	f822                	sd	s0,48(sp)
    80001fea:	f426                	sd	s1,40(sp)
    80001fec:	f04a                	sd	s2,32(sp)
    80001fee:	ec4e                	sd	s3,24(sp)
    80001ff0:	e852                	sd	s4,16(sp)
    80001ff2:	e456                	sd	s5,8(sp)
    80001ff4:	0080                	addi	s0,sp,64
    80001ff6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001ff8:	0000e497          	auipc	s1,0xe
    80001ffc:	da048493          	addi	s1,s1,-608 # 8000fd98 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002000:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002002:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002004:	0001f917          	auipc	s2,0x1f
    80002008:	79490913          	addi	s2,s2,1940 # 80021798 <tickslock>
    8000200c:	a801                	j	8000201c <wakeup+0x38>
      }
      release(&p->lock);
    8000200e:	8526                	mv	a0,s1
    80002010:	cadfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002014:	46848493          	addi	s1,s1,1128
    80002018:	03248263          	beq	s1,s2,8000203c <wakeup+0x58>
    if(p != myproc()){
    8000201c:	90bff0ef          	jal	80001926 <myproc>
    80002020:	fe950ae3          	beq	a0,s1,80002014 <wakeup+0x30>
      acquire(&p->lock);
    80002024:	8526                	mv	a0,s1
    80002026:	c03fe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000202a:	4c9c                	lw	a5,24(s1)
    8000202c:	ff3791e3          	bne	a5,s3,8000200e <wakeup+0x2a>
    80002030:	709c                	ld	a5,32(s1)
    80002032:	fd479ee3          	bne	a5,s4,8000200e <wakeup+0x2a>
        p->state = RUNNABLE;
    80002036:	0154ac23          	sw	s5,24(s1)
    8000203a:	bfd1                	j	8000200e <wakeup+0x2a>
    }
  }
}
    8000203c:	70e2                	ld	ra,56(sp)
    8000203e:	7442                	ld	s0,48(sp)
    80002040:	74a2                	ld	s1,40(sp)
    80002042:	7902                	ld	s2,32(sp)
    80002044:	69e2                	ld	s3,24(sp)
    80002046:	6a42                	ld	s4,16(sp)
    80002048:	6aa2                	ld	s5,8(sp)
    8000204a:	6121                	addi	sp,sp,64
    8000204c:	8082                	ret

000000008000204e <reparent>:
{
    8000204e:	7179                	addi	sp,sp,-48
    80002050:	f406                	sd	ra,40(sp)
    80002052:	f022                	sd	s0,32(sp)
    80002054:	ec26                	sd	s1,24(sp)
    80002056:	e84a                	sd	s2,16(sp)
    80002058:	e44e                	sd	s3,8(sp)
    8000205a:	e052                	sd	s4,0(sp)
    8000205c:	1800                	addi	s0,sp,48
    8000205e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002060:	0000e497          	auipc	s1,0xe
    80002064:	d3848493          	addi	s1,s1,-712 # 8000fd98 <proc>
      pp->parent = initproc;
    80002068:	00005a17          	auipc	s4,0x5
    8000206c:	7f8a0a13          	addi	s4,s4,2040 # 80007860 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002070:	0001f997          	auipc	s3,0x1f
    80002074:	72898993          	addi	s3,s3,1832 # 80021798 <tickslock>
    80002078:	a029                	j	80002082 <reparent+0x34>
    8000207a:	46848493          	addi	s1,s1,1128
    8000207e:	01348b63          	beq	s1,s3,80002094 <reparent+0x46>
    if(pp->parent == p){
    80002082:	7c9c                	ld	a5,56(s1)
    80002084:	ff279be3          	bne	a5,s2,8000207a <reparent+0x2c>
      pp->parent = initproc;
    80002088:	000a3503          	ld	a0,0(s4)
    8000208c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000208e:	f57ff0ef          	jal	80001fe4 <wakeup>
    80002092:	b7e5                	j	8000207a <reparent+0x2c>
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6a02                	ld	s4,0(sp)
    800020a0:	6145                	addi	sp,sp,48
    800020a2:	8082                	ret

00000000800020a4 <kexit>:
{
    800020a4:	711d                	addi	sp,sp,-96
    800020a6:	ec86                	sd	ra,88(sp)
    800020a8:	e8a2                	sd	s0,80(sp)
    800020aa:	f852                	sd	s4,48(sp)
    800020ac:	f456                	sd	s5,40(sp)
    800020ae:	f05a                	sd	s6,32(sp)
    800020b0:	ec5e                	sd	s7,24(sp)
    800020b2:	e862                	sd	s8,16(sp)
    800020b4:	e466                	sd	s9,8(sp)
    800020b6:	1080                	addi	s0,sp,96
    800020b8:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800020ba:	86dff0ef          	jal	80001926 <myproc>
    800020be:	8aaa                	mv	s5,a0
  if(p == initproc)
    800020c0:	00005797          	auipc	a5,0x5
    800020c4:	7a07b783          	ld	a5,1952(a5) # 80007860 <initproc>
    800020c8:	16850a13          	addi	s4,a0,360
    800020cc:	46850c93          	addi	s9,a0,1128
          if(v->flags == MAP_SHARED) {
    800020d0:	4b05                	li	s6,1
      for(uint64 va = v->addr; va < v->addr + v->length; va += PGSIZE) {
    800020d2:	6b85                	lui	s7,0x1
  if(p == initproc)
    800020d4:	00a78663          	beq	a5,a0,800020e0 <kexit+0x3c>
    800020d8:	e4a6                	sd	s1,72(sp)
    800020da:	e0ca                	sd	s2,64(sp)
    800020dc:	fc4e                	sd	s3,56(sp)
    800020de:	a859                	j	80002174 <kexit+0xd0>
    800020e0:	e4a6                	sd	s1,72(sp)
    800020e2:	e0ca                	sd	s2,64(sp)
    800020e4:	fc4e                	sd	s3,56(sp)
    panic("init exiting");
    800020e6:	00005517          	auipc	a0,0x5
    800020ea:	0fa50513          	addi	a0,a0,250 # 800071e0 <etext+0x1e0>
    800020ee:	f36fe0ef          	jal	80000824 <panic>
          uvmunmap(p->pagetable, va, 1, 1);
    800020f2:	86da                	mv	a3,s6
    800020f4:	865a                	mv	a2,s6
    800020f6:	85a6                	mv	a1,s1
    800020f8:	050ab503          	ld	a0,80(s5)
    800020fc:	932ff0ef          	jal	8000122e <uvmunmap>
      for(uint64 va = v->addr; va < v->addr + v->length; va += PGSIZE) {
    80002100:	94de                	add	s1,s1,s7
    80002102:	0089b783          	ld	a5,8(s3)
    80002106:	0109b703          	ld	a4,16(s3)
    8000210a:	97ba                	add	a5,a5,a4
    8000210c:	04f4fa63          	bgeu	s1,a5,80002160 <kexit+0xbc>
        uint64 pa = walkaddr(p->pagetable, va);
    80002110:	85a6                	mv	a1,s1
    80002112:	050ab503          	ld	a0,80(s5)
    80002116:	f11fe0ef          	jal	80001026 <walkaddr>
    8000211a:	892a                	mv	s2,a0
        if(pa != 0) {
    8000211c:	d175                	beqz	a0,80002100 <kexit+0x5c>
          if(v->flags == MAP_SHARED) {
    8000211e:	01c9a783          	lw	a5,28(s3)
    80002122:	fd6798e3          	bne	a5,s6,800020f2 <kexit+0x4e>
            begin_op();
    80002126:	447010ef          	jal	80003d6c <begin_op>
            ilock(v->f->ip);
    8000212a:	0289b783          	ld	a5,40(s3)
    8000212e:	6f88                	ld	a0,24(a5)
    80002130:	230010ef          	jal	80003360 <ilock>
            writei(v->f->ip, 0, pa, v->offset + (va - v->addr), PGSIZE);
    80002134:	0089b783          	ld	a5,8(s3)
    80002138:	0209a683          	lw	a3,32(s3)
    8000213c:	9e9d                	subw	a3,a3,a5
    8000213e:	0289b783          	ld	a5,40(s3)
    80002142:	875e                	mv	a4,s7
    80002144:	9ea5                	addw	a3,a3,s1
    80002146:	864a                	mv	a2,s2
    80002148:	4581                	li	a1,0
    8000214a:	6f88                	ld	a0,24(a5)
    8000214c:	698010ef          	jal	800037e4 <writei>
            iunlock(v->f->ip);
    80002150:	0289b783          	ld	a5,40(s3)
    80002154:	6f88                	ld	a0,24(a5)
    80002156:	2b8010ef          	jal	8000340e <iunlock>
            end_op();
    8000215a:	483010ef          	jal	80003ddc <end_op>
    8000215e:	bf51                	j	800020f2 <kexit+0x4e>
      fileclose(v->f);
    80002160:	0289b503          	ld	a0,40(s3)
    80002164:	02c020ef          	jal	80004190 <fileclose>
      v->used = 0;
    80002168:	0009a023          	sw	zero,0(s3)
  for(int i = 0; i < NVMA; i++) {
    8000216c:	030a0a13          	addi	s4,s4,48
    80002170:	019a0e63          	beq	s4,s9,8000218c <kexit+0xe8>
    if(p->vmas[i].used) {
    80002174:	89d2                	mv	s3,s4
    80002176:	000a2783          	lw	a5,0(s4)
    8000217a:	dbed                	beqz	a5,8000216c <kexit+0xc8>
      for(uint64 va = v->addr; va < v->addr + v->length; va += PGSIZE) {
    8000217c:	008a3483          	ld	s1,8(s4)
    80002180:	010a3783          	ld	a5,16(s4)
    80002184:	97a6                	add	a5,a5,s1
    80002186:	f8f4e5e3          	bltu	s1,a5,80002110 <kexit+0x6c>
    8000218a:	bfd9                	j	80002160 <kexit+0xbc>
    8000218c:	0d0a8493          	addi	s1,s5,208
    80002190:	150a8913          	addi	s2,s5,336
    80002194:	a021                	j	8000219c <kexit+0xf8>
  for(int fd = 0; fd < NOFILE; fd++){
    80002196:	04a1                	addi	s1,s1,8
    80002198:	01248963          	beq	s1,s2,800021aa <kexit+0x106>
    if(p->ofile[fd]){
    8000219c:	6088                	ld	a0,0(s1)
    8000219e:	dd65                	beqz	a0,80002196 <kexit+0xf2>
      fileclose(f);
    800021a0:	7f1010ef          	jal	80004190 <fileclose>
      p->ofile[fd] = 0;
    800021a4:	0004b023          	sd	zero,0(s1)
    800021a8:	b7fd                	j	80002196 <kexit+0xf2>
  begin_op();
    800021aa:	3c3010ef          	jal	80003d6c <begin_op>
  iput(p->cwd);
    800021ae:	150ab503          	ld	a0,336(s5)
    800021b2:	330010ef          	jal	800034e2 <iput>
  end_op();
    800021b6:	427010ef          	jal	80003ddc <end_op>
  p->cwd = 0;
    800021ba:	140ab823          	sd	zero,336(s5)
  acquire(&wait_lock);
    800021be:	0000d517          	auipc	a0,0xd
    800021c2:	7c250513          	addi	a0,a0,1986 # 8000f980 <wait_lock>
    800021c6:	a63fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800021ca:	8556                	mv	a0,s5
    800021cc:	e83ff0ef          	jal	8000204e <reparent>
  wakeup(p->parent);
    800021d0:	038ab503          	ld	a0,56(s5)
    800021d4:	e11ff0ef          	jal	80001fe4 <wakeup>
  acquire(&p->lock);
    800021d8:	8556                	mv	a0,s5
    800021da:	a4ffe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800021de:	038aa623          	sw	s8,44(s5)
  p->state = ZOMBIE;
    800021e2:	4795                	li	a5,5
    800021e4:	00faac23          	sw	a5,24(s5)
  release(&wait_lock);
    800021e8:	0000d517          	auipc	a0,0xd
    800021ec:	79850513          	addi	a0,a0,1944 # 8000f980 <wait_lock>
    800021f0:	acdfe0ef          	jal	80000cbc <release>
  sched();
    800021f4:	cbdff0ef          	jal	80001eb0 <sched>
  panic("zombie exit");
    800021f8:	00005517          	auipc	a0,0x5
    800021fc:	ff850513          	addi	a0,a0,-8 # 800071f0 <etext+0x1f0>
    80002200:	e24fe0ef          	jal	80000824 <panic>

0000000080002204 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002204:	7179                	addi	sp,sp,-48
    80002206:	f406                	sd	ra,40(sp)
    80002208:	f022                	sd	s0,32(sp)
    8000220a:	ec26                	sd	s1,24(sp)
    8000220c:	e84a                	sd	s2,16(sp)
    8000220e:	e44e                	sd	s3,8(sp)
    80002210:	1800                	addi	s0,sp,48
    80002212:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002214:	0000e497          	auipc	s1,0xe
    80002218:	b8448493          	addi	s1,s1,-1148 # 8000fd98 <proc>
    8000221c:	0001f997          	auipc	s3,0x1f
    80002220:	57c98993          	addi	s3,s3,1404 # 80021798 <tickslock>
    acquire(&p->lock);
    80002224:	8526                	mv	a0,s1
    80002226:	a03fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    8000222a:	589c                	lw	a5,48(s1)
    8000222c:	01278b63          	beq	a5,s2,80002242 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002230:	8526                	mv	a0,s1
    80002232:	a8bfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002236:	46848493          	addi	s1,s1,1128
    8000223a:	ff3495e3          	bne	s1,s3,80002224 <kkill+0x20>
  }
  return -1;
    8000223e:	557d                	li	a0,-1
    80002240:	a819                	j	80002256 <kkill+0x52>
      p->killed = 1;
    80002242:	4785                	li	a5,1
    80002244:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002246:	4c98                	lw	a4,24(s1)
    80002248:	4789                	li	a5,2
    8000224a:	00f70d63          	beq	a4,a5,80002264 <kkill+0x60>
      release(&p->lock);
    8000224e:	8526                	mv	a0,s1
    80002250:	a6dfe0ef          	jal	80000cbc <release>
      return 0;
    80002254:	4501                	li	a0,0
}
    80002256:	70a2                	ld	ra,40(sp)
    80002258:	7402                	ld	s0,32(sp)
    8000225a:	64e2                	ld	s1,24(sp)
    8000225c:	6942                	ld	s2,16(sp)
    8000225e:	69a2                	ld	s3,8(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret
        p->state = RUNNABLE;
    80002264:	478d                	li	a5,3
    80002266:	cc9c                	sw	a5,24(s1)
    80002268:	b7dd                	j	8000224e <kkill+0x4a>

000000008000226a <setkilled>:

void
setkilled(struct proc *p)
{
    8000226a:	1101                	addi	sp,sp,-32
    8000226c:	ec06                	sd	ra,24(sp)
    8000226e:	e822                	sd	s0,16(sp)
    80002270:	e426                	sd	s1,8(sp)
    80002272:	1000                	addi	s0,sp,32
    80002274:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002276:	9b3fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    8000227a:	4785                	li	a5,1
    8000227c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000227e:	8526                	mv	a0,s1
    80002280:	a3dfe0ef          	jal	80000cbc <release>
}
    80002284:	60e2                	ld	ra,24(sp)
    80002286:	6442                	ld	s0,16(sp)
    80002288:	64a2                	ld	s1,8(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret

000000008000228e <killed>:

int
killed(struct proc *p)
{
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	e426                	sd	s1,8(sp)
    80002296:	e04a                	sd	s2,0(sp)
    80002298:	1000                	addi	s0,sp,32
    8000229a:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000229c:	98dfe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    800022a0:	549c                	lw	a5,40(s1)
    800022a2:	893e                	mv	s2,a5
  release(&p->lock);
    800022a4:	8526                	mv	a0,s1
    800022a6:	a17fe0ef          	jal	80000cbc <release>
  return k;
}
    800022aa:	854a                	mv	a0,s2
    800022ac:	60e2                	ld	ra,24(sp)
    800022ae:	6442                	ld	s0,16(sp)
    800022b0:	64a2                	ld	s1,8(sp)
    800022b2:	6902                	ld	s2,0(sp)
    800022b4:	6105                	addi	sp,sp,32
    800022b6:	8082                	ret

00000000800022b8 <kwait>:
{
    800022b8:	715d                	addi	sp,sp,-80
    800022ba:	e486                	sd	ra,72(sp)
    800022bc:	e0a2                	sd	s0,64(sp)
    800022be:	fc26                	sd	s1,56(sp)
    800022c0:	f84a                	sd	s2,48(sp)
    800022c2:	f44e                	sd	s3,40(sp)
    800022c4:	f052                	sd	s4,32(sp)
    800022c6:	ec56                	sd	s5,24(sp)
    800022c8:	e85a                	sd	s6,16(sp)
    800022ca:	e45e                	sd	s7,8(sp)
    800022cc:	0880                	addi	s0,sp,80
    800022ce:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800022d0:	e56ff0ef          	jal	80001926 <myproc>
    800022d4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800022d6:	0000d517          	auipc	a0,0xd
    800022da:	6aa50513          	addi	a0,a0,1706 # 8000f980 <wait_lock>
    800022de:	94bfe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800022e2:	4a15                	li	s4,5
        havekids = 1;
    800022e4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e6:	0001f997          	auipc	s3,0x1f
    800022ea:	4b298993          	addi	s3,s3,1202 # 80021798 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022ee:	0000db17          	auipc	s6,0xd
    800022f2:	692b0b13          	addi	s6,s6,1682 # 8000f980 <wait_lock>
    800022f6:	a869                	j	80002390 <kwait+0xd8>
          pid = pp->pid;
    800022f8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800022fc:	000b8c63          	beqz	s7,80002314 <kwait+0x5c>
    80002300:	4691                	li	a3,4
    80002302:	02c48613          	addi	a2,s1,44
    80002306:	85de                	mv	a1,s7
    80002308:	05093503          	ld	a0,80(s2)
    8000230c:	b48ff0ef          	jal	80001654 <copyout>
    80002310:	02054a63          	bltz	a0,80002344 <kwait+0x8c>
          freeproc(pp);
    80002314:	8526                	mv	a0,s1
    80002316:	fe4ff0ef          	jal	80001afa <freeproc>
          release(&pp->lock);
    8000231a:	8526                	mv	a0,s1
    8000231c:	9a1fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    80002320:	0000d517          	auipc	a0,0xd
    80002324:	66050513          	addi	a0,a0,1632 # 8000f980 <wait_lock>
    80002328:	995fe0ef          	jal	80000cbc <release>
}
    8000232c:	854e                	mv	a0,s3
    8000232e:	60a6                	ld	ra,72(sp)
    80002330:	6406                	ld	s0,64(sp)
    80002332:	74e2                	ld	s1,56(sp)
    80002334:	7942                	ld	s2,48(sp)
    80002336:	79a2                	ld	s3,40(sp)
    80002338:	7a02                	ld	s4,32(sp)
    8000233a:	6ae2                	ld	s5,24(sp)
    8000233c:	6b42                	ld	s6,16(sp)
    8000233e:	6ba2                	ld	s7,8(sp)
    80002340:	6161                	addi	sp,sp,80
    80002342:	8082                	ret
            release(&pp->lock);
    80002344:	8526                	mv	a0,s1
    80002346:	977fe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    8000234a:	0000d517          	auipc	a0,0xd
    8000234e:	63650513          	addi	a0,a0,1590 # 8000f980 <wait_lock>
    80002352:	96bfe0ef          	jal	80000cbc <release>
            return -1;
    80002356:	59fd                	li	s3,-1
    80002358:	bfd1                	j	8000232c <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000235a:	46848493          	addi	s1,s1,1128
    8000235e:	03348063          	beq	s1,s3,8000237e <kwait+0xc6>
      if(pp->parent == p){
    80002362:	7c9c                	ld	a5,56(s1)
    80002364:	ff279be3          	bne	a5,s2,8000235a <kwait+0xa2>
        acquire(&pp->lock);
    80002368:	8526                	mv	a0,s1
    8000236a:	8bffe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    8000236e:	4c9c                	lw	a5,24(s1)
    80002370:	f94784e3          	beq	a5,s4,800022f8 <kwait+0x40>
        release(&pp->lock);
    80002374:	8526                	mv	a0,s1
    80002376:	947fe0ef          	jal	80000cbc <release>
        havekids = 1;
    8000237a:	8756                	mv	a4,s5
    8000237c:	bff9                	j	8000235a <kwait+0xa2>
    if(!havekids || killed(p)){
    8000237e:	cf19                	beqz	a4,8000239c <kwait+0xe4>
    80002380:	854a                	mv	a0,s2
    80002382:	f0dff0ef          	jal	8000228e <killed>
    80002386:	e919                	bnez	a0,8000239c <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002388:	85da                	mv	a1,s6
    8000238a:	854a                	mv	a0,s2
    8000238c:	c0dff0ef          	jal	80001f98 <sleep>
    havekids = 0;
    80002390:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002392:	0000e497          	auipc	s1,0xe
    80002396:	a0648493          	addi	s1,s1,-1530 # 8000fd98 <proc>
    8000239a:	b7e1                	j	80002362 <kwait+0xaa>
      release(&wait_lock);
    8000239c:	0000d517          	auipc	a0,0xd
    800023a0:	5e450513          	addi	a0,a0,1508 # 8000f980 <wait_lock>
    800023a4:	919fe0ef          	jal	80000cbc <release>
      return -1;
    800023a8:	59fd                	li	s3,-1
    800023aa:	b749                	j	8000232c <kwait+0x74>

00000000800023ac <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800023ac:	7179                	addi	sp,sp,-48
    800023ae:	f406                	sd	ra,40(sp)
    800023b0:	f022                	sd	s0,32(sp)
    800023b2:	ec26                	sd	s1,24(sp)
    800023b4:	e84a                	sd	s2,16(sp)
    800023b6:	e44e                	sd	s3,8(sp)
    800023b8:	e052                	sd	s4,0(sp)
    800023ba:	1800                	addi	s0,sp,48
    800023bc:	84aa                	mv	s1,a0
    800023be:	8a2e                	mv	s4,a1
    800023c0:	89b2                	mv	s3,a2
    800023c2:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800023c4:	d62ff0ef          	jal	80001926 <myproc>
  if(user_dst){
    800023c8:	cc99                	beqz	s1,800023e6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800023ca:	86ca                	mv	a3,s2
    800023cc:	864e                	mv	a2,s3
    800023ce:	85d2                	mv	a1,s4
    800023d0:	6928                	ld	a0,80(a0)
    800023d2:	a82ff0ef          	jal	80001654 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800023d6:	70a2                	ld	ra,40(sp)
    800023d8:	7402                	ld	s0,32(sp)
    800023da:	64e2                	ld	s1,24(sp)
    800023dc:	6942                	ld	s2,16(sp)
    800023de:	69a2                	ld	s3,8(sp)
    800023e0:	6a02                	ld	s4,0(sp)
    800023e2:	6145                	addi	sp,sp,48
    800023e4:	8082                	ret
    memmove((char *)dst, src, len);
    800023e6:	0009061b          	sext.w	a2,s2
    800023ea:	85ce                	mv	a1,s3
    800023ec:	8552                	mv	a0,s4
    800023ee:	96bfe0ef          	jal	80000d58 <memmove>
    return 0;
    800023f2:	8526                	mv	a0,s1
    800023f4:	b7cd                	j	800023d6 <either_copyout+0x2a>

00000000800023f6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800023f6:	7179                	addi	sp,sp,-48
    800023f8:	f406                	sd	ra,40(sp)
    800023fa:	f022                	sd	s0,32(sp)
    800023fc:	ec26                	sd	s1,24(sp)
    800023fe:	e84a                	sd	s2,16(sp)
    80002400:	e44e                	sd	s3,8(sp)
    80002402:	e052                	sd	s4,0(sp)
    80002404:	1800                	addi	s0,sp,48
    80002406:	8a2a                	mv	s4,a0
    80002408:	84ae                	mv	s1,a1
    8000240a:	89b2                	mv	s3,a2
    8000240c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000240e:	d18ff0ef          	jal	80001926 <myproc>
  if(user_src){
    80002412:	cc99                	beqz	s1,80002430 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002414:	86ca                	mv	a3,s2
    80002416:	864e                	mv	a2,s3
    80002418:	85d2                	mv	a1,s4
    8000241a:	6928                	ld	a0,80(a0)
    8000241c:	af6ff0ef          	jal	80001712 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002420:	70a2                	ld	ra,40(sp)
    80002422:	7402                	ld	s0,32(sp)
    80002424:	64e2                	ld	s1,24(sp)
    80002426:	6942                	ld	s2,16(sp)
    80002428:	69a2                	ld	s3,8(sp)
    8000242a:	6a02                	ld	s4,0(sp)
    8000242c:	6145                	addi	sp,sp,48
    8000242e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002430:	0009061b          	sext.w	a2,s2
    80002434:	85ce                	mv	a1,s3
    80002436:	8552                	mv	a0,s4
    80002438:	921fe0ef          	jal	80000d58 <memmove>
    return 0;
    8000243c:	8526                	mv	a0,s1
    8000243e:	b7cd                	j	80002420 <either_copyin+0x2a>

0000000080002440 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002440:	715d                	addi	sp,sp,-80
    80002442:	e486                	sd	ra,72(sp)
    80002444:	e0a2                	sd	s0,64(sp)
    80002446:	fc26                	sd	s1,56(sp)
    80002448:	f84a                	sd	s2,48(sp)
    8000244a:	f44e                	sd	s3,40(sp)
    8000244c:	f052                	sd	s4,32(sp)
    8000244e:	ec56                	sd	s5,24(sp)
    80002450:	e85a                	sd	s6,16(sp)
    80002452:	e45e                	sd	s7,8(sp)
    80002454:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002456:	00005517          	auipc	a0,0x5
    8000245a:	c2250513          	addi	a0,a0,-990 # 80007078 <etext+0x78>
    8000245e:	89cfe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002462:	0000e497          	auipc	s1,0xe
    80002466:	a8e48493          	addi	s1,s1,-1394 # 8000fef0 <proc+0x158>
    8000246a:	0001f917          	auipc	s2,0x1f
    8000246e:	48690913          	addi	s2,s2,1158 # 800218f0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002472:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002474:	00005997          	auipc	s3,0x5
    80002478:	d8c98993          	addi	s3,s3,-628 # 80007200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    8000247c:	00005a97          	auipc	s5,0x5
    80002480:	d8ca8a93          	addi	s5,s5,-628 # 80007208 <etext+0x208>
    printf("\n");
    80002484:	00005a17          	auipc	s4,0x5
    80002488:	bf4a0a13          	addi	s4,s4,-1036 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000248c:	00005b97          	auipc	s7,0x5
    80002490:	29cb8b93          	addi	s7,s7,668 # 80007728 <states.0>
    80002494:	a829                	j	800024ae <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002496:	ed86a583          	lw	a1,-296(a3)
    8000249a:	8556                	mv	a0,s5
    8000249c:	85efe0ef          	jal	800004fa <printf>
    printf("\n");
    800024a0:	8552                	mv	a0,s4
    800024a2:	858fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024a6:	46848493          	addi	s1,s1,1128
    800024aa:	03248263          	beq	s1,s2,800024ce <procdump+0x8e>
    if(p->state == UNUSED)
    800024ae:	86a6                	mv	a3,s1
    800024b0:	ec04a783          	lw	a5,-320(s1)
    800024b4:	dbed                	beqz	a5,800024a6 <procdump+0x66>
      state = "???";
    800024b6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024b8:	fcfb6fe3          	bltu	s6,a5,80002496 <procdump+0x56>
    800024bc:	02079713          	slli	a4,a5,0x20
    800024c0:	01d75793          	srli	a5,a4,0x1d
    800024c4:	97de                	add	a5,a5,s7
    800024c6:	6390                	ld	a2,0(a5)
    800024c8:	f679                	bnez	a2,80002496 <procdump+0x56>
      state = "???";
    800024ca:	864e                	mv	a2,s3
    800024cc:	b7e9                	j	80002496 <procdump+0x56>
  }
}
    800024ce:	60a6                	ld	ra,72(sp)
    800024d0:	6406                	ld	s0,64(sp)
    800024d2:	74e2                	ld	s1,56(sp)
    800024d4:	7942                	ld	s2,48(sp)
    800024d6:	79a2                	ld	s3,40(sp)
    800024d8:	7a02                	ld	s4,32(sp)
    800024da:	6ae2                	ld	s5,24(sp)
    800024dc:	6b42                	ld	s6,16(sp)
    800024de:	6ba2                	ld	s7,8(sp)
    800024e0:	6161                	addi	sp,sp,80
    800024e2:	8082                	ret

00000000800024e4 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    800024e4:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800024e8:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800024ec:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800024ee:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800024f0:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800024f4:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800024f8:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800024fc:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002500:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002504:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002508:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000250c:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002510:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002514:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002518:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000251c:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002520:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002522:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002524:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002528:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000252c:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002530:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002534:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002538:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000253c:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002540:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002544:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002548:	0685bd83          	ld	s11,104(a1)

        ret
    8000254c:	8082                	ret

000000008000254e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000254e:	1141                	addi	sp,sp,-16
    80002550:	e406                	sd	ra,8(sp)
    80002552:	e022                	sd	s0,0(sp)
    80002554:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002556:	00005597          	auipc	a1,0x5
    8000255a:	cf258593          	addi	a1,a1,-782 # 80007248 <etext+0x248>
    8000255e:	0001f517          	auipc	a0,0x1f
    80002562:	23a50513          	addi	a0,a0,570 # 80021798 <tickslock>
    80002566:	e38fe0ef          	jal	80000b9e <initlock>
}
    8000256a:	60a2                	ld	ra,8(sp)
    8000256c:	6402                	ld	s0,0(sp)
    8000256e:	0141                	addi	sp,sp,16
    80002570:	8082                	ret

0000000080002572 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002572:	1141                	addi	sp,sp,-16
    80002574:	e406                	sd	ra,8(sp)
    80002576:	e022                	sd	s0,0(sp)
    80002578:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000257a:	00003797          	auipc	a5,0x3
    8000257e:	3c678793          	addi	a5,a5,966 # 80005940 <kernelvec>
    80002582:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002586:	60a2                	ld	ra,8(sp)
    80002588:	6402                	ld	s0,0(sp)
    8000258a:	0141                	addi	sp,sp,16
    8000258c:	8082                	ret

000000008000258e <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000258e:	1141                	addi	sp,sp,-16
    80002590:	e406                	sd	ra,8(sp)
    80002592:	e022                	sd	s0,0(sp)
    80002594:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002596:	b90ff0ef          	jal	80001926 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000259a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000259e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800025a4:	04000737          	lui	a4,0x4000
    800025a8:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800025aa:	0732                	slli	a4,a4,0xc
    800025ac:	00004797          	auipc	a5,0x4
    800025b0:	a5478793          	addi	a5,a5,-1452 # 80006000 <_trampoline>
    800025b4:	00004697          	auipc	a3,0x4
    800025b8:	a4c68693          	addi	a3,a3,-1460 # 80006000 <_trampoline>
    800025bc:	8f95                	sub	a5,a5,a3
    800025be:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025c0:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800025c4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800025c6:	18002773          	csrr	a4,satp
    800025ca:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800025cc:	6d38                	ld	a4,88(a0)
    800025ce:	613c                	ld	a5,64(a0)
    800025d0:	6685                	lui	a3,0x1
    800025d2:	97b6                	add	a5,a5,a3
    800025d4:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025d6:	6d3c                	ld	a5,88(a0)
    800025d8:	00000717          	auipc	a4,0x0
    800025dc:	0fc70713          	addi	a4,a4,252 # 800026d4 <usertrap>
    800025e0:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800025e2:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800025e4:	8712                	mv	a4,tp
    800025e6:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025e8:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025ec:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025f0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025f4:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025f8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800025fa:	6f9c                	ld	a5,24(a5)
    800025fc:	14179073          	csrw	sepc,a5
}
    80002600:	60a2                	ld	ra,8(sp)
    80002602:	6402                	ld	s0,0(sp)
    80002604:	0141                	addi	sp,sp,16
    80002606:	8082                	ret

0000000080002608 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002608:	1141                	addi	sp,sp,-16
    8000260a:	e406                	sd	ra,8(sp)
    8000260c:	e022                	sd	s0,0(sp)
    8000260e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80002610:	ae2ff0ef          	jal	800018f2 <cpuid>
    80002614:	cd11                	beqz	a0,80002630 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002616:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000261a:	000f4737          	lui	a4,0xf4
    8000261e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002622:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002624:	14d79073          	csrw	stimecmp,a5
}
    80002628:	60a2                	ld	ra,8(sp)
    8000262a:	6402                	ld	s0,0(sp)
    8000262c:	0141                	addi	sp,sp,16
    8000262e:	8082                	ret
    acquire(&tickslock);
    80002630:	0001f517          	auipc	a0,0x1f
    80002634:	16850513          	addi	a0,a0,360 # 80021798 <tickslock>
    80002638:	df0fe0ef          	jal	80000c28 <acquire>
    ticks++;
    8000263c:	00005717          	auipc	a4,0x5
    80002640:	22c70713          	addi	a4,a4,556 # 80007868 <ticks>
    80002644:	431c                	lw	a5,0(a4)
    80002646:	2785                	addiw	a5,a5,1
    80002648:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000264a:	853a                	mv	a0,a4
    8000264c:	999ff0ef          	jal	80001fe4 <wakeup>
    release(&tickslock);
    80002650:	0001f517          	auipc	a0,0x1f
    80002654:	14850513          	addi	a0,a0,328 # 80021798 <tickslock>
    80002658:	e64fe0ef          	jal	80000cbc <release>
    8000265c:	bf6d                	j	80002616 <clockintr+0xe>

000000008000265e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000265e:	1101                	addi	sp,sp,-32
    80002660:	ec06                	sd	ra,24(sp)
    80002662:	e822                	sd	s0,16(sp)
    80002664:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002666:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000266a:	57fd                	li	a5,-1
    8000266c:	17fe                	slli	a5,a5,0x3f
    8000266e:	07a5                	addi	a5,a5,9
    80002670:	00f70c63          	beq	a4,a5,80002688 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002674:	57fd                	li	a5,-1
    80002676:	17fe                	slli	a5,a5,0x3f
    80002678:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000267a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000267c:	04f70863          	beq	a4,a5,800026cc <devintr+0x6e>
  }
}
    80002680:	60e2                	ld	ra,24(sp)
    80002682:	6442                	ld	s0,16(sp)
    80002684:	6105                	addi	sp,sp,32
    80002686:	8082                	ret
    80002688:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000268a:	362030ef          	jal	800059ec <plic_claim>
    8000268e:	872a                	mv	a4,a0
    80002690:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002692:	47a9                	li	a5,10
    80002694:	00f50963          	beq	a0,a5,800026a6 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80002698:	4785                	li	a5,1
    8000269a:	00f50963          	beq	a0,a5,800026ac <devintr+0x4e>
    return 1;
    8000269e:	4505                	li	a0,1
    } else if(irq){
    800026a0:	eb09                	bnez	a4,800026b2 <devintr+0x54>
    800026a2:	64a2                	ld	s1,8(sp)
    800026a4:	bff1                	j	80002680 <devintr+0x22>
      uartintr();
    800026a6:	b4efe0ef          	jal	800009f4 <uartintr>
    if(irq)
    800026aa:	a819                	j	800026c0 <devintr+0x62>
      virtio_disk_intr();
    800026ac:	7d6030ef          	jal	80005e82 <virtio_disk_intr>
    if(irq)
    800026b0:	a801                	j	800026c0 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    800026b2:	85ba                	mv	a1,a4
    800026b4:	00005517          	auipc	a0,0x5
    800026b8:	b9c50513          	addi	a0,a0,-1124 # 80007250 <etext+0x250>
    800026bc:	e3ffd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    800026c0:	8526                	mv	a0,s1
    800026c2:	34a030ef          	jal	80005a0c <plic_complete>
    return 1;
    800026c6:	4505                	li	a0,1
    800026c8:	64a2                	ld	s1,8(sp)
    800026ca:	bf5d                	j	80002680 <devintr+0x22>
    clockintr();
    800026cc:	f3dff0ef          	jal	80002608 <clockintr>
    return 2;
    800026d0:	4509                	li	a0,2
    800026d2:	b77d                	j	80002680 <devintr+0x22>

00000000800026d4 <usertrap>:
{
    800026d4:	1101                	addi	sp,sp,-32
    800026d6:	ec06                	sd	ra,24(sp)
    800026d8:	e822                	sd	s0,16(sp)
    800026da:	e426                	sd	s1,8(sp)
    800026dc:	e04a                	sd	s2,0(sp)
    800026de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026e0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800026e4:	1007f793          	andi	a5,a5,256
    800026e8:	ebc9                	bnez	a5,8000277a <usertrap+0xa6>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026ea:	00003797          	auipc	a5,0x3
    800026ee:	25678793          	addi	a5,a5,598 # 80005940 <kernelvec>
    800026f2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800026f6:	a30ff0ef          	jal	80001926 <myproc>
    800026fa:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800026fc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026fe:	14102773          	csrr	a4,sepc
    80002702:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002704:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002708:	47a1                	li	a5,8
    8000270a:	06f70e63          	beq	a4,a5,80002786 <usertrap+0xb2>
  } else if((which_dev = devintr()) != 0){
    8000270e:	f51ff0ef          	jal	8000265e <devintr>
    80002712:	892a                	mv	s2,a0
    80002714:	0e051463          	bnez	a0,800027fc <usertrap+0x128>
    80002718:	14202773          	csrr	a4,scause
  } else if(r_scause() == 13 || r_scause() == 15){
    8000271c:	47b5                	li	a5,13
    8000271e:	00f70763          	beq	a4,a5,8000272c <usertrap+0x58>
    80002722:	14202773          	csrr	a4,scause
    80002726:	47bd                	li	a5,15
    80002728:	0af71363          	bne	a4,a5,800027ce <usertrap+0xfa>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000272c:	143025f3          	csrr	a1,stval
    80002730:	892e                	mv	s2,a1
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002732:	14202673          	csrr	a2,scause
    if(vmfault(p->pagetable, stval, (r_scause() == 13) ? 1 : 0) != 0){
    80002736:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002738:	00163613          	seqz	a2,a2
    8000273c:	68a8                	ld	a0,80(s1)
    8000273e:	e93fe0ef          	jal	800015d0 <vmfault>
    80002742:	e12d                	bnez	a0,800027a4 <usertrap+0xd0>
    } else if(mmapfault(stval) == 0){
    80002744:	854a                	mv	a0,s2
    80002746:	75d020ef          	jal	800056a2 <mmapfault>
    8000274a:	cd29                	beqz	a0,800027a4 <usertrap+0xd0>
    8000274c:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002750:	5890                	lw	a2,48(s1)
    80002752:	00005517          	auipc	a0,0x5
    80002756:	b3e50513          	addi	a0,a0,-1218 # 80007290 <etext+0x290>
    8000275a:	da1fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000275e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002762:	14302673          	csrr	a2,stval
      printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002766:	00005517          	auipc	a0,0x5
    8000276a:	b5a50513          	addi	a0,a0,-1190 # 800072c0 <etext+0x2c0>
    8000276e:	d8dfd0ef          	jal	800004fa <printf>
      setkilled(p);
    80002772:	8526                	mv	a0,s1
    80002774:	af7ff0ef          	jal	8000226a <setkilled>
    80002778:	a035                	j	800027a4 <usertrap+0xd0>
    panic("usertrap: not from user mode");
    8000277a:	00005517          	auipc	a0,0x5
    8000277e:	af650513          	addi	a0,a0,-1290 # 80007270 <etext+0x270>
    80002782:	8a2fe0ef          	jal	80000824 <panic>
    if(killed(p))
    80002786:	b09ff0ef          	jal	8000228e <killed>
    8000278a:	ed15                	bnez	a0,800027c6 <usertrap+0xf2>
    p->trapframe->epc += 4;
    8000278c:	6cb8                	ld	a4,88(s1)
    8000278e:	6f1c                	ld	a5,24(a4)
    80002790:	0791                	addi	a5,a5,4
    80002792:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002794:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002798:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000279c:	10079073          	csrw	sstatus,a5
    syscall();
    800027a0:	256000ef          	jal	800029f6 <syscall>
  if(killed(p))
    800027a4:	8526                	mv	a0,s1
    800027a6:	ae9ff0ef          	jal	8000228e <killed>
    800027aa:	ed31                	bnez	a0,80002806 <usertrap+0x132>
  prepare_return();
    800027ac:	de3ff0ef          	jal	8000258e <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800027b0:	68a8                	ld	a0,80(s1)
    800027b2:	8131                	srli	a0,a0,0xc
    800027b4:	57fd                	li	a5,-1
    800027b6:	17fe                	slli	a5,a5,0x3f
    800027b8:	8d5d                	or	a0,a0,a5
}
    800027ba:	60e2                	ld	ra,24(sp)
    800027bc:	6442                	ld	s0,16(sp)
    800027be:	64a2                	ld	s1,8(sp)
    800027c0:	6902                	ld	s2,0(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret
      kexit(-1);
    800027c6:	557d                	li	a0,-1
    800027c8:	8ddff0ef          	jal	800020a4 <kexit>
    800027cc:	b7c1                	j	8000278c <usertrap+0xb8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027ce:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800027d2:	5890                	lw	a2,48(s1)
    800027d4:	00005517          	auipc	a0,0x5
    800027d8:	abc50513          	addi	a0,a0,-1348 # 80007290 <etext+0x290>
    800027dc:	d1ffd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027e0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027e4:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800027e8:	00005517          	auipc	a0,0x5
    800027ec:	ad850513          	addi	a0,a0,-1320 # 800072c0 <etext+0x2c0>
    800027f0:	d0bfd0ef          	jal	800004fa <printf>
    setkilled(p);
    800027f4:	8526                	mv	a0,s1
    800027f6:	a75ff0ef          	jal	8000226a <setkilled>
    800027fa:	b76d                	j	800027a4 <usertrap+0xd0>
  if(killed(p))
    800027fc:	8526                	mv	a0,s1
    800027fe:	a91ff0ef          	jal	8000228e <killed>
    80002802:	c511                	beqz	a0,8000280e <usertrap+0x13a>
    80002804:	a011                	j	80002808 <usertrap+0x134>
    80002806:	4901                	li	s2,0
    kexit(-1);
    80002808:	557d                	li	a0,-1
    8000280a:	89bff0ef          	jal	800020a4 <kexit>
  if(which_dev == 2)
    8000280e:	4789                	li	a5,2
    80002810:	f8f91ee3          	bne	s2,a5,800027ac <usertrap+0xd8>
    yield();
    80002814:	f58ff0ef          	jal	80001f6c <yield>
    80002818:	bf51                	j	800027ac <usertrap+0xd8>

000000008000281a <kerneltrap>:
{
    8000281a:	7179                	addi	sp,sp,-48
    8000281c:	f406                	sd	ra,40(sp)
    8000281e:	f022                	sd	s0,32(sp)
    80002820:	ec26                	sd	s1,24(sp)
    80002822:	e84a                	sd	s2,16(sp)
    80002824:	e44e                	sd	s3,8(sp)
    80002826:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002828:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000282c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002830:	142027f3          	csrr	a5,scause
    80002834:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80002836:	1004f793          	andi	a5,s1,256
    8000283a:	c795                	beqz	a5,80002866 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000283c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002840:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002842:	eb85                	bnez	a5,80002872 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80002844:	e1bff0ef          	jal	8000265e <devintr>
    80002848:	c91d                	beqz	a0,8000287e <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    8000284a:	4789                	li	a5,2
    8000284c:	04f50a63          	beq	a0,a5,800028a0 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002850:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002854:	10049073          	csrw	sstatus,s1
}
    80002858:	70a2                	ld	ra,40(sp)
    8000285a:	7402                	ld	s0,32(sp)
    8000285c:	64e2                	ld	s1,24(sp)
    8000285e:	6942                	ld	s2,16(sp)
    80002860:	69a2                	ld	s3,8(sp)
    80002862:	6145                	addi	sp,sp,48
    80002864:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002866:	00005517          	auipc	a0,0x5
    8000286a:	a8250513          	addi	a0,a0,-1406 # 800072e8 <etext+0x2e8>
    8000286e:	fb7fd0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002872:	00005517          	auipc	a0,0x5
    80002876:	a9e50513          	addi	a0,a0,-1378 # 80007310 <etext+0x310>
    8000287a:	fabfd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000287e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002882:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002886:	85ce                	mv	a1,s3
    80002888:	00005517          	auipc	a0,0x5
    8000288c:	aa850513          	addi	a0,a0,-1368 # 80007330 <etext+0x330>
    80002890:	c6bfd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002894:	00005517          	auipc	a0,0x5
    80002898:	ac450513          	addi	a0,a0,-1340 # 80007358 <etext+0x358>
    8000289c:	f89fd0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    800028a0:	886ff0ef          	jal	80001926 <myproc>
    800028a4:	d555                	beqz	a0,80002850 <kerneltrap+0x36>
    yield();
    800028a6:	ec6ff0ef          	jal	80001f6c <yield>
    800028aa:	b75d                	j	80002850 <kerneltrap+0x36>

00000000800028ac <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800028ac:	1101                	addi	sp,sp,-32
    800028ae:	ec06                	sd	ra,24(sp)
    800028b0:	e822                	sd	s0,16(sp)
    800028b2:	e426                	sd	s1,8(sp)
    800028b4:	1000                	addi	s0,sp,32
    800028b6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800028b8:	86eff0ef          	jal	80001926 <myproc>
  switch (n) {
    800028bc:	4795                	li	a5,5
    800028be:	0497e163          	bltu	a5,s1,80002900 <argraw+0x54>
    800028c2:	048a                	slli	s1,s1,0x2
    800028c4:	00005717          	auipc	a4,0x5
    800028c8:	e9470713          	addi	a4,a4,-364 # 80007758 <states.0+0x30>
    800028cc:	94ba                	add	s1,s1,a4
    800028ce:	409c                	lw	a5,0(s1)
    800028d0:	97ba                	add	a5,a5,a4
    800028d2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800028d4:	6d3c                	ld	a5,88(a0)
    800028d6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800028d8:	60e2                	ld	ra,24(sp)
    800028da:	6442                	ld	s0,16(sp)
    800028dc:	64a2                	ld	s1,8(sp)
    800028de:	6105                	addi	sp,sp,32
    800028e0:	8082                	ret
    return p->trapframe->a1;
    800028e2:	6d3c                	ld	a5,88(a0)
    800028e4:	7fa8                	ld	a0,120(a5)
    800028e6:	bfcd                	j	800028d8 <argraw+0x2c>
    return p->trapframe->a2;
    800028e8:	6d3c                	ld	a5,88(a0)
    800028ea:	63c8                	ld	a0,128(a5)
    800028ec:	b7f5                	j	800028d8 <argraw+0x2c>
    return p->trapframe->a3;
    800028ee:	6d3c                	ld	a5,88(a0)
    800028f0:	67c8                	ld	a0,136(a5)
    800028f2:	b7dd                	j	800028d8 <argraw+0x2c>
    return p->trapframe->a4;
    800028f4:	6d3c                	ld	a5,88(a0)
    800028f6:	6bc8                	ld	a0,144(a5)
    800028f8:	b7c5                	j	800028d8 <argraw+0x2c>
    return p->trapframe->a5;
    800028fa:	6d3c                	ld	a5,88(a0)
    800028fc:	6fc8                	ld	a0,152(a5)
    800028fe:	bfe9                	j	800028d8 <argraw+0x2c>
  panic("argraw");
    80002900:	00005517          	auipc	a0,0x5
    80002904:	a6850513          	addi	a0,a0,-1432 # 80007368 <etext+0x368>
    80002908:	f1dfd0ef          	jal	80000824 <panic>

000000008000290c <fetchaddr>:
{
    8000290c:	1101                	addi	sp,sp,-32
    8000290e:	ec06                	sd	ra,24(sp)
    80002910:	e822                	sd	s0,16(sp)
    80002912:	e426                	sd	s1,8(sp)
    80002914:	e04a                	sd	s2,0(sp)
    80002916:	1000                	addi	s0,sp,32
    80002918:	84aa                	mv	s1,a0
    8000291a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000291c:	80aff0ef          	jal	80001926 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002920:	653c                	ld	a5,72(a0)
    80002922:	02f4f663          	bgeu	s1,a5,8000294e <fetchaddr+0x42>
    80002926:	00848713          	addi	a4,s1,8
    8000292a:	02e7e463          	bltu	a5,a4,80002952 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000292e:	46a1                	li	a3,8
    80002930:	8626                	mv	a2,s1
    80002932:	85ca                	mv	a1,s2
    80002934:	6928                	ld	a0,80(a0)
    80002936:	dddfe0ef          	jal	80001712 <copyin>
    8000293a:	00a03533          	snez	a0,a0
    8000293e:	40a0053b          	negw	a0,a0
}
    80002942:	60e2                	ld	ra,24(sp)
    80002944:	6442                	ld	s0,16(sp)
    80002946:	64a2                	ld	s1,8(sp)
    80002948:	6902                	ld	s2,0(sp)
    8000294a:	6105                	addi	sp,sp,32
    8000294c:	8082                	ret
    return -1;
    8000294e:	557d                	li	a0,-1
    80002950:	bfcd                	j	80002942 <fetchaddr+0x36>
    80002952:	557d                	li	a0,-1
    80002954:	b7fd                	j	80002942 <fetchaddr+0x36>

0000000080002956 <fetchstr>:
{
    80002956:	7179                	addi	sp,sp,-48
    80002958:	f406                	sd	ra,40(sp)
    8000295a:	f022                	sd	s0,32(sp)
    8000295c:	ec26                	sd	s1,24(sp)
    8000295e:	e84a                	sd	s2,16(sp)
    80002960:	e44e                	sd	s3,8(sp)
    80002962:	1800                	addi	s0,sp,48
    80002964:	89aa                	mv	s3,a0
    80002966:	84ae                	mv	s1,a1
    80002968:	8932                	mv	s2,a2
  struct proc *p = myproc();
    8000296a:	fbdfe0ef          	jal	80001926 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000296e:	86ca                	mv	a3,s2
    80002970:	864e                	mv	a2,s3
    80002972:	85a6                	mv	a1,s1
    80002974:	6928                	ld	a0,80(a0)
    80002976:	b83fe0ef          	jal	800014f8 <copyinstr>
    8000297a:	00054c63          	bltz	a0,80002992 <fetchstr+0x3c>
  return strlen(buf);
    8000297e:	8526                	mv	a0,s1
    80002980:	d02fe0ef          	jal	80000e82 <strlen>
}
    80002984:	70a2                	ld	ra,40(sp)
    80002986:	7402                	ld	s0,32(sp)
    80002988:	64e2                	ld	s1,24(sp)
    8000298a:	6942                	ld	s2,16(sp)
    8000298c:	69a2                	ld	s3,8(sp)
    8000298e:	6145                	addi	sp,sp,48
    80002990:	8082                	ret
    return -1;
    80002992:	557d                	li	a0,-1
    80002994:	bfc5                	j	80002984 <fetchstr+0x2e>

0000000080002996 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002996:	1101                	addi	sp,sp,-32
    80002998:	ec06                	sd	ra,24(sp)
    8000299a:	e822                	sd	s0,16(sp)
    8000299c:	e426                	sd	s1,8(sp)
    8000299e:	1000                	addi	s0,sp,32
    800029a0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029a2:	f0bff0ef          	jal	800028ac <argraw>
    800029a6:	c088                	sw	a0,0(s1)
}
    800029a8:	60e2                	ld	ra,24(sp)
    800029aa:	6442                	ld	s0,16(sp)
    800029ac:	64a2                	ld	s1,8(sp)
    800029ae:	6105                	addi	sp,sp,32
    800029b0:	8082                	ret

00000000800029b2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800029b2:	1101                	addi	sp,sp,-32
    800029b4:	ec06                	sd	ra,24(sp)
    800029b6:	e822                	sd	s0,16(sp)
    800029b8:	e426                	sd	s1,8(sp)
    800029ba:	1000                	addi	s0,sp,32
    800029bc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800029be:	eefff0ef          	jal	800028ac <argraw>
    800029c2:	e088                	sd	a0,0(s1)
}
    800029c4:	60e2                	ld	ra,24(sp)
    800029c6:	6442                	ld	s0,16(sp)
    800029c8:	64a2                	ld	s1,8(sp)
    800029ca:	6105                	addi	sp,sp,32
    800029cc:	8082                	ret

00000000800029ce <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800029ce:	1101                	addi	sp,sp,-32
    800029d0:	ec06                	sd	ra,24(sp)
    800029d2:	e822                	sd	s0,16(sp)
    800029d4:	e426                	sd	s1,8(sp)
    800029d6:	e04a                	sd	s2,0(sp)
    800029d8:	1000                	addi	s0,sp,32
    800029da:	892e                	mv	s2,a1
    800029dc:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800029de:	ecfff0ef          	jal	800028ac <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800029e2:	8626                	mv	a2,s1
    800029e4:	85ca                	mv	a1,s2
    800029e6:	f71ff0ef          	jal	80002956 <fetchstr>
}
    800029ea:	60e2                	ld	ra,24(sp)
    800029ec:	6442                	ld	s0,16(sp)
    800029ee:	64a2                	ld	s1,8(sp)
    800029f0:	6902                	ld	s2,0(sp)
    800029f2:	6105                	addi	sp,sp,32
    800029f4:	8082                	ret

00000000800029f6 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    800029f6:	1101                	addi	sp,sp,-32
    800029f8:	ec06                	sd	ra,24(sp)
    800029fa:	e822                	sd	s0,16(sp)
    800029fc:	e426                	sd	s1,8(sp)
    800029fe:	e04a                	sd	s2,0(sp)
    80002a00:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002a02:	f25fe0ef          	jal	80001926 <myproc>
    80002a06:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002a08:	05853903          	ld	s2,88(a0)
    80002a0c:	0a893783          	ld	a5,168(s2)
    80002a10:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002a14:	37fd                	addiw	a5,a5,-1
    80002a16:	4759                	li	a4,22
    80002a18:	00f76f63          	bltu	a4,a5,80002a36 <syscall+0x40>
    80002a1c:	00369713          	slli	a4,a3,0x3
    80002a20:	00005797          	auipc	a5,0x5
    80002a24:	d5078793          	addi	a5,a5,-688 # 80007770 <syscalls>
    80002a28:	97ba                	add	a5,a5,a4
    80002a2a:	639c                	ld	a5,0(a5)
    80002a2c:	c789                	beqz	a5,80002a36 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002a2e:	9782                	jalr	a5
    80002a30:	06a93823          	sd	a0,112(s2)
    80002a34:	a829                	j	80002a4e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002a36:	15848613          	addi	a2,s1,344
    80002a3a:	588c                	lw	a1,48(s1)
    80002a3c:	00005517          	auipc	a0,0x5
    80002a40:	93450513          	addi	a0,a0,-1740 # 80007370 <etext+0x370>
    80002a44:	ab7fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002a48:	6cbc                	ld	a5,88(s1)
    80002a4a:	577d                	li	a4,-1
    80002a4c:	fbb8                	sd	a4,112(a5)
  }
}
    80002a4e:	60e2                	ld	ra,24(sp)
    80002a50:	6442                	ld	s0,16(sp)
    80002a52:	64a2                	ld	s1,8(sp)
    80002a54:	6902                	ld	s2,0(sp)
    80002a56:	6105                	addi	sp,sp,32
    80002a58:	8082                	ret

0000000080002a5a <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002a5a:	1101                	addi	sp,sp,-32
    80002a5c:	ec06                	sd	ra,24(sp)
    80002a5e:	e822                	sd	s0,16(sp)
    80002a60:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a62:	fec40593          	addi	a1,s0,-20
    80002a66:	4501                	li	a0,0
    80002a68:	f2fff0ef          	jal	80002996 <argint>
  kexit(n);
    80002a6c:	fec42503          	lw	a0,-20(s0)
    80002a70:	e34ff0ef          	jal	800020a4 <kexit>
  return 0;  // not reached
}
    80002a74:	4501                	li	a0,0
    80002a76:	60e2                	ld	ra,24(sp)
    80002a78:	6442                	ld	s0,16(sp)
    80002a7a:	6105                	addi	sp,sp,32
    80002a7c:	8082                	ret

0000000080002a7e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a7e:	1141                	addi	sp,sp,-16
    80002a80:	e406                	sd	ra,8(sp)
    80002a82:	e022                	sd	s0,0(sp)
    80002a84:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a86:	ea1fe0ef          	jal	80001926 <myproc>
}
    80002a8a:	5908                	lw	a0,48(a0)
    80002a8c:	60a2                	ld	ra,8(sp)
    80002a8e:	6402                	ld	s0,0(sp)
    80002a90:	0141                	addi	sp,sp,16
    80002a92:	8082                	ret

0000000080002a94 <sys_fork>:

uint64
sys_fork(void)
{
    80002a94:	1141                	addi	sp,sp,-16
    80002a96:	e406                	sd	ra,8(sp)
    80002a98:	e022                	sd	s0,0(sp)
    80002a9a:	0800                	addi	s0,sp,16
  return kfork();
    80002a9c:	a0aff0ef          	jal	80001ca6 <kfork>
}
    80002aa0:	60a2                	ld	ra,8(sp)
    80002aa2:	6402                	ld	s0,0(sp)
    80002aa4:	0141                	addi	sp,sp,16
    80002aa6:	8082                	ret

0000000080002aa8 <sys_wait>:

uint64
sys_wait(void)
{
    80002aa8:	1101                	addi	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002ab0:	fe840593          	addi	a1,s0,-24
    80002ab4:	4501                	li	a0,0
    80002ab6:	efdff0ef          	jal	800029b2 <argaddr>
  return kwait(p);
    80002aba:	fe843503          	ld	a0,-24(s0)
    80002abe:	ffaff0ef          	jal	800022b8 <kwait>
}
    80002ac2:	60e2                	ld	ra,24(sp)
    80002ac4:	6442                	ld	s0,16(sp)
    80002ac6:	6105                	addi	sp,sp,32
    80002ac8:	8082                	ret

0000000080002aca <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002aca:	7179                	addi	sp,sp,-48
    80002acc:	f406                	sd	ra,40(sp)
    80002ace:	f022                	sd	s0,32(sp)
    80002ad0:	ec26                	sd	s1,24(sp)
    80002ad2:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002ad4:	fd840593          	addi	a1,s0,-40
    80002ad8:	4501                	li	a0,0
    80002ada:	ebdff0ef          	jal	80002996 <argint>
  argint(1, &t);
    80002ade:	fdc40593          	addi	a1,s0,-36
    80002ae2:	4505                	li	a0,1
    80002ae4:	eb3ff0ef          	jal	80002996 <argint>
  addr = myproc()->sz;
    80002ae8:	e3ffe0ef          	jal	80001926 <myproc>
    80002aec:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002aee:	fdc42703          	lw	a4,-36(s0)
    80002af2:	4785                	li	a5,1
    80002af4:	02f70763          	beq	a4,a5,80002b22 <sys_sbrk+0x58>
    80002af8:	fd842783          	lw	a5,-40(s0)
    80002afc:	0207c363          	bltz	a5,80002b22 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002b00:	97a6                	add	a5,a5,s1
      return -1;
    if(addr + n > TRAPFRAME)
    80002b02:	02000737          	lui	a4,0x2000
    80002b06:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002b08:	0736                	slli	a4,a4,0xd
    80002b0a:	02f76a63          	bltu	a4,a5,80002b3e <sys_sbrk+0x74>
    80002b0e:	0297e863          	bltu	a5,s1,80002b3e <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80002b12:	e15fe0ef          	jal	80001926 <myproc>
    80002b16:	fd842703          	lw	a4,-40(s0)
    80002b1a:	653c                	ld	a5,72(a0)
    80002b1c:	97ba                	add	a5,a5,a4
    80002b1e:	e53c                	sd	a5,72(a0)
    80002b20:	a039                	j	80002b2e <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002b22:	fd842503          	lw	a0,-40(s0)
    80002b26:	91eff0ef          	jal	80001c44 <growproc>
    80002b2a:	00054863          	bltz	a0,80002b3a <sys_sbrk+0x70>
  }
  return addr;
}
    80002b2e:	8526                	mv	a0,s1
    80002b30:	70a2                	ld	ra,40(sp)
    80002b32:	7402                	ld	s0,32(sp)
    80002b34:	64e2                	ld	s1,24(sp)
    80002b36:	6145                	addi	sp,sp,48
    80002b38:	8082                	ret
      return -1;
    80002b3a:	54fd                	li	s1,-1
    80002b3c:	bfcd                	j	80002b2e <sys_sbrk+0x64>
      return -1;
    80002b3e:	54fd                	li	s1,-1
    80002b40:	b7fd                	j	80002b2e <sys_sbrk+0x64>

0000000080002b42 <sys_pause>:

uint64
sys_pause(void)
{
    80002b42:	7139                	addi	sp,sp,-64
    80002b44:	fc06                	sd	ra,56(sp)
    80002b46:	f822                	sd	s0,48(sp)
    80002b48:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002b4a:	fcc40593          	addi	a1,s0,-52
    80002b4e:	4501                	li	a0,0
    80002b50:	e47ff0ef          	jal	80002996 <argint>
  if(n < 0)
    80002b54:	fcc42783          	lw	a5,-52(s0)
    80002b58:	0607c863          	bltz	a5,80002bc8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002b5c:	0001f517          	auipc	a0,0x1f
    80002b60:	c3c50513          	addi	a0,a0,-964 # 80021798 <tickslock>
    80002b64:	8c4fe0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002b68:	fcc42783          	lw	a5,-52(s0)
    80002b6c:	c3b9                	beqz	a5,80002bb2 <sys_pause+0x70>
    80002b6e:	f426                	sd	s1,40(sp)
    80002b70:	f04a                	sd	s2,32(sp)
    80002b72:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002b74:	00005997          	auipc	s3,0x5
    80002b78:	cf49a983          	lw	s3,-780(s3) # 80007868 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b7c:	0001f917          	auipc	s2,0x1f
    80002b80:	c1c90913          	addi	s2,s2,-996 # 80021798 <tickslock>
    80002b84:	00005497          	auipc	s1,0x5
    80002b88:	ce448493          	addi	s1,s1,-796 # 80007868 <ticks>
    if(killed(myproc())){
    80002b8c:	d9bfe0ef          	jal	80001926 <myproc>
    80002b90:	efeff0ef          	jal	8000228e <killed>
    80002b94:	ed0d                	bnez	a0,80002bce <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002b96:	85ca                	mv	a1,s2
    80002b98:	8526                	mv	a0,s1
    80002b9a:	bfeff0ef          	jal	80001f98 <sleep>
  while(ticks - ticks0 < n){
    80002b9e:	409c                	lw	a5,0(s1)
    80002ba0:	413787bb          	subw	a5,a5,s3
    80002ba4:	fcc42703          	lw	a4,-52(s0)
    80002ba8:	fee7e2e3          	bltu	a5,a4,80002b8c <sys_pause+0x4a>
    80002bac:	74a2                	ld	s1,40(sp)
    80002bae:	7902                	ld	s2,32(sp)
    80002bb0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002bb2:	0001f517          	auipc	a0,0x1f
    80002bb6:	be650513          	addi	a0,a0,-1050 # 80021798 <tickslock>
    80002bba:	902fe0ef          	jal	80000cbc <release>
  return 0;
    80002bbe:	4501                	li	a0,0
}
    80002bc0:	70e2                	ld	ra,56(sp)
    80002bc2:	7442                	ld	s0,48(sp)
    80002bc4:	6121                	addi	sp,sp,64
    80002bc6:	8082                	ret
    n = 0;
    80002bc8:	fc042623          	sw	zero,-52(s0)
    80002bcc:	bf41                	j	80002b5c <sys_pause+0x1a>
      release(&tickslock);
    80002bce:	0001f517          	auipc	a0,0x1f
    80002bd2:	bca50513          	addi	a0,a0,-1078 # 80021798 <tickslock>
    80002bd6:	8e6fe0ef          	jal	80000cbc <release>
      return -1;
    80002bda:	557d                	li	a0,-1
    80002bdc:	74a2                	ld	s1,40(sp)
    80002bde:	7902                	ld	s2,32(sp)
    80002be0:	69e2                	ld	s3,24(sp)
    80002be2:	bff9                	j	80002bc0 <sys_pause+0x7e>

0000000080002be4 <sys_kill>:

uint64
sys_kill(void)
{
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002bec:	fec40593          	addi	a1,s0,-20
    80002bf0:	4501                	li	a0,0
    80002bf2:	da5ff0ef          	jal	80002996 <argint>
  return kkill(pid);
    80002bf6:	fec42503          	lw	a0,-20(s0)
    80002bfa:	e0aff0ef          	jal	80002204 <kkill>
}
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	6105                	addi	sp,sp,32
    80002c04:	8082                	ret

0000000080002c06 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002c06:	1101                	addi	sp,sp,-32
    80002c08:	ec06                	sd	ra,24(sp)
    80002c0a:	e822                	sd	s0,16(sp)
    80002c0c:	e426                	sd	s1,8(sp)
    80002c0e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002c10:	0001f517          	auipc	a0,0x1f
    80002c14:	b8850513          	addi	a0,a0,-1144 # 80021798 <tickslock>
    80002c18:	810fe0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80002c1c:	00005797          	auipc	a5,0x5
    80002c20:	c4c7a783          	lw	a5,-948(a5) # 80007868 <ticks>
    80002c24:	84be                	mv	s1,a5
  release(&tickslock);
    80002c26:	0001f517          	auipc	a0,0x1f
    80002c2a:	b7250513          	addi	a0,a0,-1166 # 80021798 <tickslock>
    80002c2e:	88efe0ef          	jal	80000cbc <release>
  return xticks;
}
    80002c32:	02049513          	slli	a0,s1,0x20
    80002c36:	9101                	srli	a0,a0,0x20
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6105                	addi	sp,sp,32
    80002c40:	8082                	ret

0000000080002c42 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c42:	7179                	addi	sp,sp,-48
    80002c44:	f406                	sd	ra,40(sp)
    80002c46:	f022                	sd	s0,32(sp)
    80002c48:	ec26                	sd	s1,24(sp)
    80002c4a:	e84a                	sd	s2,16(sp)
    80002c4c:	e44e                	sd	s3,8(sp)
    80002c4e:	e052                	sd	s4,0(sp)
    80002c50:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c52:	00004597          	auipc	a1,0x4
    80002c56:	73e58593          	addi	a1,a1,1854 # 80007390 <etext+0x390>
    80002c5a:	0001f517          	auipc	a0,0x1f
    80002c5e:	b5650513          	addi	a0,a0,-1194 # 800217b0 <bcache>
    80002c62:	f3dfd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c66:	00027797          	auipc	a5,0x27
    80002c6a:	b4a78793          	addi	a5,a5,-1206 # 800297b0 <bcache+0x8000>
    80002c6e:	00027717          	auipc	a4,0x27
    80002c72:	daa70713          	addi	a4,a4,-598 # 80029a18 <bcache+0x8268>
    80002c76:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c7a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c7e:	0001f497          	auipc	s1,0x1f
    80002c82:	b4a48493          	addi	s1,s1,-1206 # 800217c8 <bcache+0x18>
    b->next = bcache.head.next;
    80002c86:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c88:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c8a:	00004a17          	auipc	s4,0x4
    80002c8e:	70ea0a13          	addi	s4,s4,1806 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    80002c92:	2b893783          	ld	a5,696(s2)
    80002c96:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c98:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c9c:	85d2                	mv	a1,s4
    80002c9e:	01048513          	addi	a0,s1,16
    80002ca2:	328010ef          	jal	80003fca <initsleeplock>
    bcache.head.next->prev = b;
    80002ca6:	2b893783          	ld	a5,696(s2)
    80002caa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002cac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cb0:	45848493          	addi	s1,s1,1112
    80002cb4:	fd349fe3          	bne	s1,s3,80002c92 <binit+0x50>
  }
}
    80002cb8:	70a2                	ld	ra,40(sp)
    80002cba:	7402                	ld	s0,32(sp)
    80002cbc:	64e2                	ld	s1,24(sp)
    80002cbe:	6942                	ld	s2,16(sp)
    80002cc0:	69a2                	ld	s3,8(sp)
    80002cc2:	6a02                	ld	s4,0(sp)
    80002cc4:	6145                	addi	sp,sp,48
    80002cc6:	8082                	ret

0000000080002cc8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002cc8:	7179                	addi	sp,sp,-48
    80002cca:	f406                	sd	ra,40(sp)
    80002ccc:	f022                	sd	s0,32(sp)
    80002cce:	ec26                	sd	s1,24(sp)
    80002cd0:	e84a                	sd	s2,16(sp)
    80002cd2:	e44e                	sd	s3,8(sp)
    80002cd4:	1800                	addi	s0,sp,48
    80002cd6:	892a                	mv	s2,a0
    80002cd8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002cda:	0001f517          	auipc	a0,0x1f
    80002cde:	ad650513          	addi	a0,a0,-1322 # 800217b0 <bcache>
    80002ce2:	f47fd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ce6:	00027497          	auipc	s1,0x27
    80002cea:	d824b483          	ld	s1,-638(s1) # 80029a68 <bcache+0x82b8>
    80002cee:	00027797          	auipc	a5,0x27
    80002cf2:	d2a78793          	addi	a5,a5,-726 # 80029a18 <bcache+0x8268>
    80002cf6:	02f48b63          	beq	s1,a5,80002d2c <bread+0x64>
    80002cfa:	873e                	mv	a4,a5
    80002cfc:	a021                	j	80002d04 <bread+0x3c>
    80002cfe:	68a4                	ld	s1,80(s1)
    80002d00:	02e48663          	beq	s1,a4,80002d2c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002d04:	449c                	lw	a5,8(s1)
    80002d06:	ff279ce3          	bne	a5,s2,80002cfe <bread+0x36>
    80002d0a:	44dc                	lw	a5,12(s1)
    80002d0c:	ff3799e3          	bne	a5,s3,80002cfe <bread+0x36>
      b->refcnt++;
    80002d10:	40bc                	lw	a5,64(s1)
    80002d12:	2785                	addiw	a5,a5,1
    80002d14:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d16:	0001f517          	auipc	a0,0x1f
    80002d1a:	a9a50513          	addi	a0,a0,-1382 # 800217b0 <bcache>
    80002d1e:	f9ffd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002d22:	01048513          	addi	a0,s1,16
    80002d26:	2da010ef          	jal	80004000 <acquiresleep>
      return b;
    80002d2a:	a889                	j	80002d7c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d2c:	00027497          	auipc	s1,0x27
    80002d30:	d344b483          	ld	s1,-716(s1) # 80029a60 <bcache+0x82b0>
    80002d34:	00027797          	auipc	a5,0x27
    80002d38:	ce478793          	addi	a5,a5,-796 # 80029a18 <bcache+0x8268>
    80002d3c:	00f48863          	beq	s1,a5,80002d4c <bread+0x84>
    80002d40:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d42:	40bc                	lw	a5,64(s1)
    80002d44:	cb91                	beqz	a5,80002d58 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d46:	64a4                	ld	s1,72(s1)
    80002d48:	fee49de3          	bne	s1,a4,80002d42 <bread+0x7a>
  panic("bget: no buffers");
    80002d4c:	00004517          	auipc	a0,0x4
    80002d50:	65450513          	addi	a0,a0,1620 # 800073a0 <etext+0x3a0>
    80002d54:	ad1fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80002d58:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d5c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d60:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d64:	4785                	li	a5,1
    80002d66:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d68:	0001f517          	auipc	a0,0x1f
    80002d6c:	a4850513          	addi	a0,a0,-1464 # 800217b0 <bcache>
    80002d70:	f4dfd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002d74:	01048513          	addi	a0,s1,16
    80002d78:	288010ef          	jal	80004000 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d7c:	409c                	lw	a5,0(s1)
    80002d7e:	cb89                	beqz	a5,80002d90 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d80:	8526                	mv	a0,s1
    80002d82:	70a2                	ld	ra,40(sp)
    80002d84:	7402                	ld	s0,32(sp)
    80002d86:	64e2                	ld	s1,24(sp)
    80002d88:	6942                	ld	s2,16(sp)
    80002d8a:	69a2                	ld	s3,8(sp)
    80002d8c:	6145                	addi	sp,sp,48
    80002d8e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d90:	4581                	li	a1,0
    80002d92:	8526                	mv	a0,s1
    80002d94:	6dd020ef          	jal	80005c70 <virtio_disk_rw>
    b->valid = 1;
    80002d98:	4785                	li	a5,1
    80002d9a:	c09c                	sw	a5,0(s1)
  return b;
    80002d9c:	b7d5                	j	80002d80 <bread+0xb8>

0000000080002d9e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d9e:	1101                	addi	sp,sp,-32
    80002da0:	ec06                	sd	ra,24(sp)
    80002da2:	e822                	sd	s0,16(sp)
    80002da4:	e426                	sd	s1,8(sp)
    80002da6:	1000                	addi	s0,sp,32
    80002da8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002daa:	0541                	addi	a0,a0,16
    80002dac:	2d2010ef          	jal	8000407e <holdingsleep>
    80002db0:	c911                	beqz	a0,80002dc4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002db2:	4585                	li	a1,1
    80002db4:	8526                	mv	a0,s1
    80002db6:	6bb020ef          	jal	80005c70 <virtio_disk_rw>
}
    80002dba:	60e2                	ld	ra,24(sp)
    80002dbc:	6442                	ld	s0,16(sp)
    80002dbe:	64a2                	ld	s1,8(sp)
    80002dc0:	6105                	addi	sp,sp,32
    80002dc2:	8082                	ret
    panic("bwrite");
    80002dc4:	00004517          	auipc	a0,0x4
    80002dc8:	5f450513          	addi	a0,a0,1524 # 800073b8 <etext+0x3b8>
    80002dcc:	a59fd0ef          	jal	80000824 <panic>

0000000080002dd0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002dd0:	1101                	addi	sp,sp,-32
    80002dd2:	ec06                	sd	ra,24(sp)
    80002dd4:	e822                	sd	s0,16(sp)
    80002dd6:	e426                	sd	s1,8(sp)
    80002dd8:	e04a                	sd	s2,0(sp)
    80002dda:	1000                	addi	s0,sp,32
    80002ddc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002dde:	01050913          	addi	s2,a0,16
    80002de2:	854a                	mv	a0,s2
    80002de4:	29a010ef          	jal	8000407e <holdingsleep>
    80002de8:	c125                	beqz	a0,80002e48 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002dea:	854a                	mv	a0,s2
    80002dec:	25a010ef          	jal	80004046 <releasesleep>

  acquire(&bcache.lock);
    80002df0:	0001f517          	auipc	a0,0x1f
    80002df4:	9c050513          	addi	a0,a0,-1600 # 800217b0 <bcache>
    80002df8:	e31fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002dfc:	40bc                	lw	a5,64(s1)
    80002dfe:	37fd                	addiw	a5,a5,-1
    80002e00:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e02:	e79d                	bnez	a5,80002e30 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e04:	68b8                	ld	a4,80(s1)
    80002e06:	64bc                	ld	a5,72(s1)
    80002e08:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e0a:	68b8                	ld	a4,80(s1)
    80002e0c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e0e:	00027797          	auipc	a5,0x27
    80002e12:	9a278793          	addi	a5,a5,-1630 # 800297b0 <bcache+0x8000>
    80002e16:	2b87b703          	ld	a4,696(a5)
    80002e1a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e1c:	00027717          	auipc	a4,0x27
    80002e20:	bfc70713          	addi	a4,a4,-1028 # 80029a18 <bcache+0x8268>
    80002e24:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e26:	2b87b703          	ld	a4,696(a5)
    80002e2a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e2c:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002e30:	0001f517          	auipc	a0,0x1f
    80002e34:	98050513          	addi	a0,a0,-1664 # 800217b0 <bcache>
    80002e38:	e85fd0ef          	jal	80000cbc <release>
}
    80002e3c:	60e2                	ld	ra,24(sp)
    80002e3e:	6442                	ld	s0,16(sp)
    80002e40:	64a2                	ld	s1,8(sp)
    80002e42:	6902                	ld	s2,0(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret
    panic("brelse");
    80002e48:	00004517          	auipc	a0,0x4
    80002e4c:	57850513          	addi	a0,a0,1400 # 800073c0 <etext+0x3c0>
    80002e50:	9d5fd0ef          	jal	80000824 <panic>

0000000080002e54 <bpin>:

void
bpin(struct buf *b) {
    80002e54:	1101                	addi	sp,sp,-32
    80002e56:	ec06                	sd	ra,24(sp)
    80002e58:	e822                	sd	s0,16(sp)
    80002e5a:	e426                	sd	s1,8(sp)
    80002e5c:	1000                	addi	s0,sp,32
    80002e5e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e60:	0001f517          	auipc	a0,0x1f
    80002e64:	95050513          	addi	a0,a0,-1712 # 800217b0 <bcache>
    80002e68:	dc1fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80002e6c:	40bc                	lw	a5,64(s1)
    80002e6e:	2785                	addiw	a5,a5,1
    80002e70:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e72:	0001f517          	auipc	a0,0x1f
    80002e76:	93e50513          	addi	a0,a0,-1730 # 800217b0 <bcache>
    80002e7a:	e43fd0ef          	jal	80000cbc <release>
}
    80002e7e:	60e2                	ld	ra,24(sp)
    80002e80:	6442                	ld	s0,16(sp)
    80002e82:	64a2                	ld	s1,8(sp)
    80002e84:	6105                	addi	sp,sp,32
    80002e86:	8082                	ret

0000000080002e88 <bunpin>:

void
bunpin(struct buf *b) {
    80002e88:	1101                	addi	sp,sp,-32
    80002e8a:	ec06                	sd	ra,24(sp)
    80002e8c:	e822                	sd	s0,16(sp)
    80002e8e:	e426                	sd	s1,8(sp)
    80002e90:	1000                	addi	s0,sp,32
    80002e92:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e94:	0001f517          	auipc	a0,0x1f
    80002e98:	91c50513          	addi	a0,a0,-1764 # 800217b0 <bcache>
    80002e9c:	d8dfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002ea0:	40bc                	lw	a5,64(s1)
    80002ea2:	37fd                	addiw	a5,a5,-1
    80002ea4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ea6:	0001f517          	auipc	a0,0x1f
    80002eaa:	90a50513          	addi	a0,a0,-1782 # 800217b0 <bcache>
    80002eae:	e0ffd0ef          	jal	80000cbc <release>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6105                	addi	sp,sp,32
    80002eba:	8082                	ret

0000000080002ebc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ebc:	1101                	addi	sp,sp,-32
    80002ebe:	ec06                	sd	ra,24(sp)
    80002ec0:	e822                	sd	s0,16(sp)
    80002ec2:	e426                	sd	s1,8(sp)
    80002ec4:	e04a                	sd	s2,0(sp)
    80002ec6:	1000                	addi	s0,sp,32
    80002ec8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002eca:	00d5d79b          	srliw	a5,a1,0xd
    80002ece:	00027597          	auipc	a1,0x27
    80002ed2:	fbe5a583          	lw	a1,-66(a1) # 80029e8c <sb+0x1c>
    80002ed6:	9dbd                	addw	a1,a1,a5
    80002ed8:	df1ff0ef          	jal	80002cc8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002edc:	0074f713          	andi	a4,s1,7
    80002ee0:	4785                	li	a5,1
    80002ee2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002ee6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002ee8:	90d9                	srli	s1,s1,0x36
    80002eea:	00950733          	add	a4,a0,s1
    80002eee:	05874703          	lbu	a4,88(a4)
    80002ef2:	00e7f6b3          	and	a3,a5,a4
    80002ef6:	c29d                	beqz	a3,80002f1c <bfree+0x60>
    80002ef8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002efa:	94aa                	add	s1,s1,a0
    80002efc:	fff7c793          	not	a5,a5
    80002f00:	8f7d                	and	a4,a4,a5
    80002f02:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f06:	000010ef          	jal	80003f06 <log_write>
  brelse(bp);
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	ec5ff0ef          	jal	80002dd0 <brelse>
}
    80002f10:	60e2                	ld	ra,24(sp)
    80002f12:	6442                	ld	s0,16(sp)
    80002f14:	64a2                	ld	s1,8(sp)
    80002f16:	6902                	ld	s2,0(sp)
    80002f18:	6105                	addi	sp,sp,32
    80002f1a:	8082                	ret
    panic("freeing free block");
    80002f1c:	00004517          	auipc	a0,0x4
    80002f20:	4ac50513          	addi	a0,a0,1196 # 800073c8 <etext+0x3c8>
    80002f24:	901fd0ef          	jal	80000824 <panic>

0000000080002f28 <balloc>:
{
    80002f28:	715d                	addi	sp,sp,-80
    80002f2a:	e486                	sd	ra,72(sp)
    80002f2c:	e0a2                	sd	s0,64(sp)
    80002f2e:	fc26                	sd	s1,56(sp)
    80002f30:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002f32:	00027797          	auipc	a5,0x27
    80002f36:	f427a783          	lw	a5,-190(a5) # 80029e74 <sb+0x4>
    80002f3a:	0e078263          	beqz	a5,8000301e <balloc+0xf6>
    80002f3e:	f84a                	sd	s2,48(sp)
    80002f40:	f44e                	sd	s3,40(sp)
    80002f42:	f052                	sd	s4,32(sp)
    80002f44:	ec56                	sd	s5,24(sp)
    80002f46:	e85a                	sd	s6,16(sp)
    80002f48:	e45e                	sd	s7,8(sp)
    80002f4a:	e062                	sd	s8,0(sp)
    80002f4c:	8baa                	mv	s7,a0
    80002f4e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f50:	00027b17          	auipc	s6,0x27
    80002f54:	f20b0b13          	addi	s6,s6,-224 # 80029e70 <sb>
      m = 1 << (bi % 8);
    80002f58:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f5a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f5c:	6c09                	lui	s8,0x2
    80002f5e:	a09d                	j	80002fc4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f60:	97ca                	add	a5,a5,s2
    80002f62:	8e55                	or	a2,a2,a3
    80002f64:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f68:	854a                	mv	a0,s2
    80002f6a:	79d000ef          	jal	80003f06 <log_write>
        brelse(bp);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	e61ff0ef          	jal	80002dd0 <brelse>
  bp = bread(dev, bno);
    80002f74:	85a6                	mv	a1,s1
    80002f76:	855e                	mv	a0,s7
    80002f78:	d51ff0ef          	jal	80002cc8 <bread>
    80002f7c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f7e:	40000613          	li	a2,1024
    80002f82:	4581                	li	a1,0
    80002f84:	05850513          	addi	a0,a0,88
    80002f88:	d71fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80002f8c:	854a                	mv	a0,s2
    80002f8e:	779000ef          	jal	80003f06 <log_write>
  brelse(bp);
    80002f92:	854a                	mv	a0,s2
    80002f94:	e3dff0ef          	jal	80002dd0 <brelse>
}
    80002f98:	7942                	ld	s2,48(sp)
    80002f9a:	79a2                	ld	s3,40(sp)
    80002f9c:	7a02                	ld	s4,32(sp)
    80002f9e:	6ae2                	ld	s5,24(sp)
    80002fa0:	6b42                	ld	s6,16(sp)
    80002fa2:	6ba2                	ld	s7,8(sp)
    80002fa4:	6c02                	ld	s8,0(sp)
}
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	60a6                	ld	ra,72(sp)
    80002faa:	6406                	ld	s0,64(sp)
    80002fac:	74e2                	ld	s1,56(sp)
    80002fae:	6161                	addi	sp,sp,80
    80002fb0:	8082                	ret
    brelse(bp);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	e1dff0ef          	jal	80002dd0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002fb8:	015c0abb          	addw	s5,s8,s5
    80002fbc:	004b2783          	lw	a5,4(s6)
    80002fc0:	04faf863          	bgeu	s5,a5,80003010 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002fc4:	40dad59b          	sraiw	a1,s5,0xd
    80002fc8:	01cb2783          	lw	a5,28(s6)
    80002fcc:	9dbd                	addw	a1,a1,a5
    80002fce:	855e                	mv	a0,s7
    80002fd0:	cf9ff0ef          	jal	80002cc8 <bread>
    80002fd4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fd6:	004b2503          	lw	a0,4(s6)
    80002fda:	84d6                	mv	s1,s5
    80002fdc:	4701                	li	a4,0
    80002fde:	fca4fae3          	bgeu	s1,a0,80002fb2 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002fe2:	00777693          	andi	a3,a4,7
    80002fe6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002fea:	41f7579b          	sraiw	a5,a4,0x1f
    80002fee:	01d7d79b          	srliw	a5,a5,0x1d
    80002ff2:	9fb9                	addw	a5,a5,a4
    80002ff4:	4037d79b          	sraiw	a5,a5,0x3
    80002ff8:	00f90633          	add	a2,s2,a5
    80002ffc:	05864603          	lbu	a2,88(a2)
    80003000:	00c6f5b3          	and	a1,a3,a2
    80003004:	ddb1                	beqz	a1,80002f60 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003006:	2705                	addiw	a4,a4,1
    80003008:	2485                	addiw	s1,s1,1
    8000300a:	fd471ae3          	bne	a4,s4,80002fde <balloc+0xb6>
    8000300e:	b755                	j	80002fb2 <balloc+0x8a>
    80003010:	7942                	ld	s2,48(sp)
    80003012:	79a2                	ld	s3,40(sp)
    80003014:	7a02                	ld	s4,32(sp)
    80003016:	6ae2                	ld	s5,24(sp)
    80003018:	6b42                	ld	s6,16(sp)
    8000301a:	6ba2                	ld	s7,8(sp)
    8000301c:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000301e:	00004517          	auipc	a0,0x4
    80003022:	3c250513          	addi	a0,a0,962 # 800073e0 <etext+0x3e0>
    80003026:	cd4fd0ef          	jal	800004fa <printf>
  return 0;
    8000302a:	4481                	li	s1,0
    8000302c:	bfad                	j	80002fa6 <balloc+0x7e>

000000008000302e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000302e:	7179                	addi	sp,sp,-48
    80003030:	f406                	sd	ra,40(sp)
    80003032:	f022                	sd	s0,32(sp)
    80003034:	ec26                	sd	s1,24(sp)
    80003036:	e84a                	sd	s2,16(sp)
    80003038:	e44e                	sd	s3,8(sp)
    8000303a:	1800                	addi	s0,sp,48
    8000303c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000303e:	47ad                	li	a5,11
    80003040:	02b7e363          	bltu	a5,a1,80003066 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003044:	02059793          	slli	a5,a1,0x20
    80003048:	01e7d593          	srli	a1,a5,0x1e
    8000304c:	00b509b3          	add	s3,a0,a1
    80003050:	0509a483          	lw	s1,80(s3)
    80003054:	e0b5                	bnez	s1,800030b8 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003056:	4108                	lw	a0,0(a0)
    80003058:	ed1ff0ef          	jal	80002f28 <balloc>
    8000305c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000305e:	cd29                	beqz	a0,800030b8 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003060:	04a9a823          	sw	a0,80(s3)
    80003064:	a891                	j	800030b8 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003066:	ff45879b          	addiw	a5,a1,-12
    8000306a:	873e                	mv	a4,a5
    8000306c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000306e:	0ff00793          	li	a5,255
    80003072:	06e7e763          	bltu	a5,a4,800030e0 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003076:	08052483          	lw	s1,128(a0)
    8000307a:	e891                	bnez	s1,8000308e <bmap+0x60>
      addr = balloc(ip->dev);
    8000307c:	4108                	lw	a0,0(a0)
    8000307e:	eabff0ef          	jal	80002f28 <balloc>
    80003082:	84aa                	mv	s1,a0
      if(addr == 0)
    80003084:	c915                	beqz	a0,800030b8 <bmap+0x8a>
    80003086:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003088:	08a92023          	sw	a0,128(s2)
    8000308c:	a011                	j	80003090 <bmap+0x62>
    8000308e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003090:	85a6                	mv	a1,s1
    80003092:	00092503          	lw	a0,0(s2)
    80003096:	c33ff0ef          	jal	80002cc8 <bread>
    8000309a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000309c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800030a0:	02099713          	slli	a4,s3,0x20
    800030a4:	01e75593          	srli	a1,a4,0x1e
    800030a8:	97ae                	add	a5,a5,a1
    800030aa:	89be                	mv	s3,a5
    800030ac:	4384                	lw	s1,0(a5)
    800030ae:	cc89                	beqz	s1,800030c8 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800030b0:	8552                	mv	a0,s4
    800030b2:	d1fff0ef          	jal	80002dd0 <brelse>
    return addr;
    800030b6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800030b8:	8526                	mv	a0,s1
    800030ba:	70a2                	ld	ra,40(sp)
    800030bc:	7402                	ld	s0,32(sp)
    800030be:	64e2                	ld	s1,24(sp)
    800030c0:	6942                	ld	s2,16(sp)
    800030c2:	69a2                	ld	s3,8(sp)
    800030c4:	6145                	addi	sp,sp,48
    800030c6:	8082                	ret
      addr = balloc(ip->dev);
    800030c8:	00092503          	lw	a0,0(s2)
    800030cc:	e5dff0ef          	jal	80002f28 <balloc>
    800030d0:	84aa                	mv	s1,a0
      if(addr){
    800030d2:	dd79                	beqz	a0,800030b0 <bmap+0x82>
        a[bn] = addr;
    800030d4:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800030d8:	8552                	mv	a0,s4
    800030da:	62d000ef          	jal	80003f06 <log_write>
    800030de:	bfc9                	j	800030b0 <bmap+0x82>
    800030e0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800030e2:	00004517          	auipc	a0,0x4
    800030e6:	31650513          	addi	a0,a0,790 # 800073f8 <etext+0x3f8>
    800030ea:	f3afd0ef          	jal	80000824 <panic>

00000000800030ee <iget>:
{
    800030ee:	7179                	addi	sp,sp,-48
    800030f0:	f406                	sd	ra,40(sp)
    800030f2:	f022                	sd	s0,32(sp)
    800030f4:	ec26                	sd	s1,24(sp)
    800030f6:	e84a                	sd	s2,16(sp)
    800030f8:	e44e                	sd	s3,8(sp)
    800030fa:	e052                	sd	s4,0(sp)
    800030fc:	1800                	addi	s0,sp,48
    800030fe:	892a                	mv	s2,a0
    80003100:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003102:	00027517          	auipc	a0,0x27
    80003106:	d8e50513          	addi	a0,a0,-626 # 80029e90 <itable>
    8000310a:	b1ffd0ef          	jal	80000c28 <acquire>
  empty = 0;
    8000310e:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003110:	00027497          	auipc	s1,0x27
    80003114:	d9848493          	addi	s1,s1,-616 # 80029ea8 <itable+0x18>
    80003118:	00029697          	auipc	a3,0x29
    8000311c:	82068693          	addi	a3,a3,-2016 # 8002b938 <log>
    80003120:	a809                	j	80003132 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003122:	e781                	bnez	a5,8000312a <iget+0x3c>
    80003124:	00099363          	bnez	s3,8000312a <iget+0x3c>
      empty = ip;
    80003128:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000312a:	08848493          	addi	s1,s1,136
    8000312e:	02d48563          	beq	s1,a3,80003158 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003132:	449c                	lw	a5,8(s1)
    80003134:	fef057e3          	blez	a5,80003122 <iget+0x34>
    80003138:	4098                	lw	a4,0(s1)
    8000313a:	ff2718e3          	bne	a4,s2,8000312a <iget+0x3c>
    8000313e:	40d8                	lw	a4,4(s1)
    80003140:	ff4715e3          	bne	a4,s4,8000312a <iget+0x3c>
      ip->ref++;
    80003144:	2785                	addiw	a5,a5,1
    80003146:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003148:	00027517          	auipc	a0,0x27
    8000314c:	d4850513          	addi	a0,a0,-696 # 80029e90 <itable>
    80003150:	b6dfd0ef          	jal	80000cbc <release>
      return ip;
    80003154:	89a6                	mv	s3,s1
    80003156:	a015                	j	8000317a <iget+0x8c>
  if(empty == 0)
    80003158:	02098a63          	beqz	s3,8000318c <iget+0x9e>
  ip->dev = dev;
    8000315c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003160:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003164:	4785                	li	a5,1
    80003166:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000316a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000316e:	00027517          	auipc	a0,0x27
    80003172:	d2250513          	addi	a0,a0,-734 # 80029e90 <itable>
    80003176:	b47fd0ef          	jal	80000cbc <release>
}
    8000317a:	854e                	mv	a0,s3
    8000317c:	70a2                	ld	ra,40(sp)
    8000317e:	7402                	ld	s0,32(sp)
    80003180:	64e2                	ld	s1,24(sp)
    80003182:	6942                	ld	s2,16(sp)
    80003184:	69a2                	ld	s3,8(sp)
    80003186:	6a02                	ld	s4,0(sp)
    80003188:	6145                	addi	sp,sp,48
    8000318a:	8082                	ret
    panic("iget: no inodes");
    8000318c:	00004517          	auipc	a0,0x4
    80003190:	28450513          	addi	a0,a0,644 # 80007410 <etext+0x410>
    80003194:	e90fd0ef          	jal	80000824 <panic>

0000000080003198 <iinit>:
{
    80003198:	7179                	addi	sp,sp,-48
    8000319a:	f406                	sd	ra,40(sp)
    8000319c:	f022                	sd	s0,32(sp)
    8000319e:	ec26                	sd	s1,24(sp)
    800031a0:	e84a                	sd	s2,16(sp)
    800031a2:	e44e                	sd	s3,8(sp)
    800031a4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031a6:	00004597          	auipc	a1,0x4
    800031aa:	27a58593          	addi	a1,a1,634 # 80007420 <etext+0x420>
    800031ae:	00027517          	auipc	a0,0x27
    800031b2:	ce250513          	addi	a0,a0,-798 # 80029e90 <itable>
    800031b6:	9e9fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    800031ba:	00027497          	auipc	s1,0x27
    800031be:	cfe48493          	addi	s1,s1,-770 # 80029eb8 <itable+0x28>
    800031c2:	00028997          	auipc	s3,0x28
    800031c6:	78698993          	addi	s3,s3,1926 # 8002b948 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800031ca:	00004917          	auipc	s2,0x4
    800031ce:	25e90913          	addi	s2,s2,606 # 80007428 <etext+0x428>
    800031d2:	85ca                	mv	a1,s2
    800031d4:	8526                	mv	a0,s1
    800031d6:	5f5000ef          	jal	80003fca <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800031da:	08848493          	addi	s1,s1,136
    800031de:	ff349ae3          	bne	s1,s3,800031d2 <iinit+0x3a>
}
    800031e2:	70a2                	ld	ra,40(sp)
    800031e4:	7402                	ld	s0,32(sp)
    800031e6:	64e2                	ld	s1,24(sp)
    800031e8:	6942                	ld	s2,16(sp)
    800031ea:	69a2                	ld	s3,8(sp)
    800031ec:	6145                	addi	sp,sp,48
    800031ee:	8082                	ret

00000000800031f0 <ialloc>:
{
    800031f0:	7139                	addi	sp,sp,-64
    800031f2:	fc06                	sd	ra,56(sp)
    800031f4:	f822                	sd	s0,48(sp)
    800031f6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800031f8:	00027717          	auipc	a4,0x27
    800031fc:	c8472703          	lw	a4,-892(a4) # 80029e7c <sb+0xc>
    80003200:	4785                	li	a5,1
    80003202:	06e7f063          	bgeu	a5,a4,80003262 <ialloc+0x72>
    80003206:	f426                	sd	s1,40(sp)
    80003208:	f04a                	sd	s2,32(sp)
    8000320a:	ec4e                	sd	s3,24(sp)
    8000320c:	e852                	sd	s4,16(sp)
    8000320e:	e456                	sd	s5,8(sp)
    80003210:	e05a                	sd	s6,0(sp)
    80003212:	8aaa                	mv	s5,a0
    80003214:	8b2e                	mv	s6,a1
    80003216:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003218:	00027a17          	auipc	s4,0x27
    8000321c:	c58a0a13          	addi	s4,s4,-936 # 80029e70 <sb>
    80003220:	00495593          	srli	a1,s2,0x4
    80003224:	018a2783          	lw	a5,24(s4)
    80003228:	9dbd                	addw	a1,a1,a5
    8000322a:	8556                	mv	a0,s5
    8000322c:	a9dff0ef          	jal	80002cc8 <bread>
    80003230:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003232:	05850993          	addi	s3,a0,88
    80003236:	00f97793          	andi	a5,s2,15
    8000323a:	079a                	slli	a5,a5,0x6
    8000323c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000323e:	00099783          	lh	a5,0(s3)
    80003242:	cb9d                	beqz	a5,80003278 <ialloc+0x88>
    brelse(bp);
    80003244:	b8dff0ef          	jal	80002dd0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003248:	0905                	addi	s2,s2,1
    8000324a:	00ca2703          	lw	a4,12(s4)
    8000324e:	0009079b          	sext.w	a5,s2
    80003252:	fce7e7e3          	bltu	a5,a4,80003220 <ialloc+0x30>
    80003256:	74a2                	ld	s1,40(sp)
    80003258:	7902                	ld	s2,32(sp)
    8000325a:	69e2                	ld	s3,24(sp)
    8000325c:	6a42                	ld	s4,16(sp)
    8000325e:	6aa2                	ld	s5,8(sp)
    80003260:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003262:	00004517          	auipc	a0,0x4
    80003266:	1ce50513          	addi	a0,a0,462 # 80007430 <etext+0x430>
    8000326a:	a90fd0ef          	jal	800004fa <printf>
  return 0;
    8000326e:	4501                	li	a0,0
}
    80003270:	70e2                	ld	ra,56(sp)
    80003272:	7442                	ld	s0,48(sp)
    80003274:	6121                	addi	sp,sp,64
    80003276:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003278:	04000613          	li	a2,64
    8000327c:	4581                	li	a1,0
    8000327e:	854e                	mv	a0,s3
    80003280:	a79fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003284:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003288:	8526                	mv	a0,s1
    8000328a:	47d000ef          	jal	80003f06 <log_write>
      brelse(bp);
    8000328e:	8526                	mv	a0,s1
    80003290:	b41ff0ef          	jal	80002dd0 <brelse>
      return iget(dev, inum);
    80003294:	0009059b          	sext.w	a1,s2
    80003298:	8556                	mv	a0,s5
    8000329a:	e55ff0ef          	jal	800030ee <iget>
    8000329e:	74a2                	ld	s1,40(sp)
    800032a0:	7902                	ld	s2,32(sp)
    800032a2:	69e2                	ld	s3,24(sp)
    800032a4:	6a42                	ld	s4,16(sp)
    800032a6:	6aa2                	ld	s5,8(sp)
    800032a8:	6b02                	ld	s6,0(sp)
    800032aa:	b7d9                	j	80003270 <ialloc+0x80>

00000000800032ac <iupdate>:
{
    800032ac:	1101                	addi	sp,sp,-32
    800032ae:	ec06                	sd	ra,24(sp)
    800032b0:	e822                	sd	s0,16(sp)
    800032b2:	e426                	sd	s1,8(sp)
    800032b4:	e04a                	sd	s2,0(sp)
    800032b6:	1000                	addi	s0,sp,32
    800032b8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032ba:	415c                	lw	a5,4(a0)
    800032bc:	0047d79b          	srliw	a5,a5,0x4
    800032c0:	00027597          	auipc	a1,0x27
    800032c4:	bc85a583          	lw	a1,-1080(a1) # 80029e88 <sb+0x18>
    800032c8:	9dbd                	addw	a1,a1,a5
    800032ca:	4108                	lw	a0,0(a0)
    800032cc:	9fdff0ef          	jal	80002cc8 <bread>
    800032d0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032d2:	05850793          	addi	a5,a0,88
    800032d6:	40d8                	lw	a4,4(s1)
    800032d8:	8b3d                	andi	a4,a4,15
    800032da:	071a                	slli	a4,a4,0x6
    800032dc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800032de:	04449703          	lh	a4,68(s1)
    800032e2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800032e6:	04649703          	lh	a4,70(s1)
    800032ea:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800032ee:	04849703          	lh	a4,72(s1)
    800032f2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800032f6:	04a49703          	lh	a4,74(s1)
    800032fa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800032fe:	44f8                	lw	a4,76(s1)
    80003300:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003302:	03400613          	li	a2,52
    80003306:	05048593          	addi	a1,s1,80
    8000330a:	00c78513          	addi	a0,a5,12
    8000330e:	a4bfd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003312:	854a                	mv	a0,s2
    80003314:	3f3000ef          	jal	80003f06 <log_write>
  brelse(bp);
    80003318:	854a                	mv	a0,s2
    8000331a:	ab7ff0ef          	jal	80002dd0 <brelse>
}
    8000331e:	60e2                	ld	ra,24(sp)
    80003320:	6442                	ld	s0,16(sp)
    80003322:	64a2                	ld	s1,8(sp)
    80003324:	6902                	ld	s2,0(sp)
    80003326:	6105                	addi	sp,sp,32
    80003328:	8082                	ret

000000008000332a <idup>:
{
    8000332a:	1101                	addi	sp,sp,-32
    8000332c:	ec06                	sd	ra,24(sp)
    8000332e:	e822                	sd	s0,16(sp)
    80003330:	e426                	sd	s1,8(sp)
    80003332:	1000                	addi	s0,sp,32
    80003334:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003336:	00027517          	auipc	a0,0x27
    8000333a:	b5a50513          	addi	a0,a0,-1190 # 80029e90 <itable>
    8000333e:	8ebfd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003342:	449c                	lw	a5,8(s1)
    80003344:	2785                	addiw	a5,a5,1
    80003346:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003348:	00027517          	auipc	a0,0x27
    8000334c:	b4850513          	addi	a0,a0,-1208 # 80029e90 <itable>
    80003350:	96dfd0ef          	jal	80000cbc <release>
}
    80003354:	8526                	mv	a0,s1
    80003356:	60e2                	ld	ra,24(sp)
    80003358:	6442                	ld	s0,16(sp)
    8000335a:	64a2                	ld	s1,8(sp)
    8000335c:	6105                	addi	sp,sp,32
    8000335e:	8082                	ret

0000000080003360 <ilock>:
{
    80003360:	1101                	addi	sp,sp,-32
    80003362:	ec06                	sd	ra,24(sp)
    80003364:	e822                	sd	s0,16(sp)
    80003366:	e426                	sd	s1,8(sp)
    80003368:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000336a:	cd19                	beqz	a0,80003388 <ilock+0x28>
    8000336c:	84aa                	mv	s1,a0
    8000336e:	451c                	lw	a5,8(a0)
    80003370:	00f05c63          	blez	a5,80003388 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003374:	0541                	addi	a0,a0,16
    80003376:	48b000ef          	jal	80004000 <acquiresleep>
  if(ip->valid == 0){
    8000337a:	40bc                	lw	a5,64(s1)
    8000337c:	cf89                	beqz	a5,80003396 <ilock+0x36>
}
    8000337e:	60e2                	ld	ra,24(sp)
    80003380:	6442                	ld	s0,16(sp)
    80003382:	64a2                	ld	s1,8(sp)
    80003384:	6105                	addi	sp,sp,32
    80003386:	8082                	ret
    80003388:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000338a:	00004517          	auipc	a0,0x4
    8000338e:	0be50513          	addi	a0,a0,190 # 80007448 <etext+0x448>
    80003392:	c92fd0ef          	jal	80000824 <panic>
    80003396:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003398:	40dc                	lw	a5,4(s1)
    8000339a:	0047d79b          	srliw	a5,a5,0x4
    8000339e:	00027597          	auipc	a1,0x27
    800033a2:	aea5a583          	lw	a1,-1302(a1) # 80029e88 <sb+0x18>
    800033a6:	9dbd                	addw	a1,a1,a5
    800033a8:	4088                	lw	a0,0(s1)
    800033aa:	91fff0ef          	jal	80002cc8 <bread>
    800033ae:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033b0:	05850593          	addi	a1,a0,88
    800033b4:	40dc                	lw	a5,4(s1)
    800033b6:	8bbd                	andi	a5,a5,15
    800033b8:	079a                	slli	a5,a5,0x6
    800033ba:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033bc:	00059783          	lh	a5,0(a1)
    800033c0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800033c4:	00259783          	lh	a5,2(a1)
    800033c8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800033cc:	00459783          	lh	a5,4(a1)
    800033d0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800033d4:	00659783          	lh	a5,6(a1)
    800033d8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800033dc:	459c                	lw	a5,8(a1)
    800033de:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800033e0:	03400613          	li	a2,52
    800033e4:	05b1                	addi	a1,a1,12
    800033e6:	05048513          	addi	a0,s1,80
    800033ea:	96ffd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    800033ee:	854a                	mv	a0,s2
    800033f0:	9e1ff0ef          	jal	80002dd0 <brelse>
    ip->valid = 1;
    800033f4:	4785                	li	a5,1
    800033f6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800033f8:	04449783          	lh	a5,68(s1)
    800033fc:	c399                	beqz	a5,80003402 <ilock+0xa2>
    800033fe:	6902                	ld	s2,0(sp)
    80003400:	bfbd                	j	8000337e <ilock+0x1e>
      panic("ilock: no type");
    80003402:	00004517          	auipc	a0,0x4
    80003406:	04e50513          	addi	a0,a0,78 # 80007450 <etext+0x450>
    8000340a:	c1afd0ef          	jal	80000824 <panic>

000000008000340e <iunlock>:
{
    8000340e:	1101                	addi	sp,sp,-32
    80003410:	ec06                	sd	ra,24(sp)
    80003412:	e822                	sd	s0,16(sp)
    80003414:	e426                	sd	s1,8(sp)
    80003416:	e04a                	sd	s2,0(sp)
    80003418:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000341a:	c505                	beqz	a0,80003442 <iunlock+0x34>
    8000341c:	84aa                	mv	s1,a0
    8000341e:	01050913          	addi	s2,a0,16
    80003422:	854a                	mv	a0,s2
    80003424:	45b000ef          	jal	8000407e <holdingsleep>
    80003428:	cd09                	beqz	a0,80003442 <iunlock+0x34>
    8000342a:	449c                	lw	a5,8(s1)
    8000342c:	00f05b63          	blez	a5,80003442 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003430:	854a                	mv	a0,s2
    80003432:	415000ef          	jal	80004046 <releasesleep>
}
    80003436:	60e2                	ld	ra,24(sp)
    80003438:	6442                	ld	s0,16(sp)
    8000343a:	64a2                	ld	s1,8(sp)
    8000343c:	6902                	ld	s2,0(sp)
    8000343e:	6105                	addi	sp,sp,32
    80003440:	8082                	ret
    panic("iunlock");
    80003442:	00004517          	auipc	a0,0x4
    80003446:	01e50513          	addi	a0,a0,30 # 80007460 <etext+0x460>
    8000344a:	bdafd0ef          	jal	80000824 <panic>

000000008000344e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000344e:	7179                	addi	sp,sp,-48
    80003450:	f406                	sd	ra,40(sp)
    80003452:	f022                	sd	s0,32(sp)
    80003454:	ec26                	sd	s1,24(sp)
    80003456:	e84a                	sd	s2,16(sp)
    80003458:	e44e                	sd	s3,8(sp)
    8000345a:	1800                	addi	s0,sp,48
    8000345c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000345e:	05050493          	addi	s1,a0,80
    80003462:	08050913          	addi	s2,a0,128
    80003466:	a021                	j	8000346e <itrunc+0x20>
    80003468:	0491                	addi	s1,s1,4
    8000346a:	01248b63          	beq	s1,s2,80003480 <itrunc+0x32>
    if(ip->addrs[i]){
    8000346e:	408c                	lw	a1,0(s1)
    80003470:	dde5                	beqz	a1,80003468 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003472:	0009a503          	lw	a0,0(s3)
    80003476:	a47ff0ef          	jal	80002ebc <bfree>
      ip->addrs[i] = 0;
    8000347a:	0004a023          	sw	zero,0(s1)
    8000347e:	b7ed                	j	80003468 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003480:	0809a583          	lw	a1,128(s3)
    80003484:	ed89                	bnez	a1,8000349e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003486:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000348a:	854e                	mv	a0,s3
    8000348c:	e21ff0ef          	jal	800032ac <iupdate>
}
    80003490:	70a2                	ld	ra,40(sp)
    80003492:	7402                	ld	s0,32(sp)
    80003494:	64e2                	ld	s1,24(sp)
    80003496:	6942                	ld	s2,16(sp)
    80003498:	69a2                	ld	s3,8(sp)
    8000349a:	6145                	addi	sp,sp,48
    8000349c:	8082                	ret
    8000349e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800034a0:	0009a503          	lw	a0,0(s3)
    800034a4:	825ff0ef          	jal	80002cc8 <bread>
    800034a8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800034aa:	05850493          	addi	s1,a0,88
    800034ae:	45850913          	addi	s2,a0,1112
    800034b2:	a021                	j	800034ba <itrunc+0x6c>
    800034b4:	0491                	addi	s1,s1,4
    800034b6:	01248963          	beq	s1,s2,800034c8 <itrunc+0x7a>
      if(a[j])
    800034ba:	408c                	lw	a1,0(s1)
    800034bc:	dde5                	beqz	a1,800034b4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800034be:	0009a503          	lw	a0,0(s3)
    800034c2:	9fbff0ef          	jal	80002ebc <bfree>
    800034c6:	b7fd                	j	800034b4 <itrunc+0x66>
    brelse(bp);
    800034c8:	8552                	mv	a0,s4
    800034ca:	907ff0ef          	jal	80002dd0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800034ce:	0809a583          	lw	a1,128(s3)
    800034d2:	0009a503          	lw	a0,0(s3)
    800034d6:	9e7ff0ef          	jal	80002ebc <bfree>
    ip->addrs[NDIRECT] = 0;
    800034da:	0809a023          	sw	zero,128(s3)
    800034de:	6a02                	ld	s4,0(sp)
    800034e0:	b75d                	j	80003486 <itrunc+0x38>

00000000800034e2 <iput>:
{
    800034e2:	1101                	addi	sp,sp,-32
    800034e4:	ec06                	sd	ra,24(sp)
    800034e6:	e822                	sd	s0,16(sp)
    800034e8:	e426                	sd	s1,8(sp)
    800034ea:	1000                	addi	s0,sp,32
    800034ec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034ee:	00027517          	auipc	a0,0x27
    800034f2:	9a250513          	addi	a0,a0,-1630 # 80029e90 <itable>
    800034f6:	f32fd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800034fa:	4498                	lw	a4,8(s1)
    800034fc:	4785                	li	a5,1
    800034fe:	02f70063          	beq	a4,a5,8000351e <iput+0x3c>
  ip->ref--;
    80003502:	449c                	lw	a5,8(s1)
    80003504:	37fd                	addiw	a5,a5,-1
    80003506:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003508:	00027517          	auipc	a0,0x27
    8000350c:	98850513          	addi	a0,a0,-1656 # 80029e90 <itable>
    80003510:	facfd0ef          	jal	80000cbc <release>
}
    80003514:	60e2                	ld	ra,24(sp)
    80003516:	6442                	ld	s0,16(sp)
    80003518:	64a2                	ld	s1,8(sp)
    8000351a:	6105                	addi	sp,sp,32
    8000351c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000351e:	40bc                	lw	a5,64(s1)
    80003520:	d3ed                	beqz	a5,80003502 <iput+0x20>
    80003522:	04a49783          	lh	a5,74(s1)
    80003526:	fff1                	bnez	a5,80003502 <iput+0x20>
    80003528:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000352a:	01048793          	addi	a5,s1,16
    8000352e:	893e                	mv	s2,a5
    80003530:	853e                	mv	a0,a5
    80003532:	2cf000ef          	jal	80004000 <acquiresleep>
    release(&itable.lock);
    80003536:	00027517          	auipc	a0,0x27
    8000353a:	95a50513          	addi	a0,a0,-1702 # 80029e90 <itable>
    8000353e:	f7efd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003542:	8526                	mv	a0,s1
    80003544:	f0bff0ef          	jal	8000344e <itrunc>
    ip->type = 0;
    80003548:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000354c:	8526                	mv	a0,s1
    8000354e:	d5fff0ef          	jal	800032ac <iupdate>
    ip->valid = 0;
    80003552:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003556:	854a                	mv	a0,s2
    80003558:	2ef000ef          	jal	80004046 <releasesleep>
    acquire(&itable.lock);
    8000355c:	00027517          	auipc	a0,0x27
    80003560:	93450513          	addi	a0,a0,-1740 # 80029e90 <itable>
    80003564:	ec4fd0ef          	jal	80000c28 <acquire>
    80003568:	6902                	ld	s2,0(sp)
    8000356a:	bf61                	j	80003502 <iput+0x20>

000000008000356c <iunlockput>:
{
    8000356c:	1101                	addi	sp,sp,-32
    8000356e:	ec06                	sd	ra,24(sp)
    80003570:	e822                	sd	s0,16(sp)
    80003572:	e426                	sd	s1,8(sp)
    80003574:	1000                	addi	s0,sp,32
    80003576:	84aa                	mv	s1,a0
  iunlock(ip);
    80003578:	e97ff0ef          	jal	8000340e <iunlock>
  iput(ip);
    8000357c:	8526                	mv	a0,s1
    8000357e:	f65ff0ef          	jal	800034e2 <iput>
}
    80003582:	60e2                	ld	ra,24(sp)
    80003584:	6442                	ld	s0,16(sp)
    80003586:	64a2                	ld	s1,8(sp)
    80003588:	6105                	addi	sp,sp,32
    8000358a:	8082                	ret

000000008000358c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000358c:	00027717          	auipc	a4,0x27
    80003590:	8f072703          	lw	a4,-1808(a4) # 80029e7c <sb+0xc>
    80003594:	4785                	li	a5,1
    80003596:	0ae7fe63          	bgeu	a5,a4,80003652 <ireclaim+0xc6>
{
    8000359a:	7139                	addi	sp,sp,-64
    8000359c:	fc06                	sd	ra,56(sp)
    8000359e:	f822                	sd	s0,48(sp)
    800035a0:	f426                	sd	s1,40(sp)
    800035a2:	f04a                	sd	s2,32(sp)
    800035a4:	ec4e                	sd	s3,24(sp)
    800035a6:	e852                	sd	s4,16(sp)
    800035a8:	e456                	sd	s5,8(sp)
    800035aa:	e05a                	sd	s6,0(sp)
    800035ac:	0080                	addi	s0,sp,64
    800035ae:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035b0:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800035b2:	00027a17          	auipc	s4,0x27
    800035b6:	8bea0a13          	addi	s4,s4,-1858 # 80029e70 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800035ba:	00004b17          	auipc	s6,0x4
    800035be:	eaeb0b13          	addi	s6,s6,-338 # 80007468 <etext+0x468>
    800035c2:	a099                	j	80003608 <ireclaim+0x7c>
    800035c4:	85ce                	mv	a1,s3
    800035c6:	855a                	mv	a0,s6
    800035c8:	f33fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    800035cc:	85ce                	mv	a1,s3
    800035ce:	8556                	mv	a0,s5
    800035d0:	b1fff0ef          	jal	800030ee <iget>
    800035d4:	89aa                	mv	s3,a0
    brelse(bp);
    800035d6:	854a                	mv	a0,s2
    800035d8:	ff8ff0ef          	jal	80002dd0 <brelse>
    if (ip) {
    800035dc:	00098f63          	beqz	s3,800035fa <ireclaim+0x6e>
      begin_op();
    800035e0:	78c000ef          	jal	80003d6c <begin_op>
      ilock(ip);
    800035e4:	854e                	mv	a0,s3
    800035e6:	d7bff0ef          	jal	80003360 <ilock>
      iunlock(ip);
    800035ea:	854e                	mv	a0,s3
    800035ec:	e23ff0ef          	jal	8000340e <iunlock>
      iput(ip);
    800035f0:	854e                	mv	a0,s3
    800035f2:	ef1ff0ef          	jal	800034e2 <iput>
      end_op();
    800035f6:	7e6000ef          	jal	80003ddc <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035fa:	0485                	addi	s1,s1,1
    800035fc:	00ca2703          	lw	a4,12(s4)
    80003600:	0004879b          	sext.w	a5,s1
    80003604:	02e7fd63          	bgeu	a5,a4,8000363e <ireclaim+0xb2>
    80003608:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000360c:	0044d593          	srli	a1,s1,0x4
    80003610:	018a2783          	lw	a5,24(s4)
    80003614:	9dbd                	addw	a1,a1,a5
    80003616:	8556                	mv	a0,s5
    80003618:	eb0ff0ef          	jal	80002cc8 <bread>
    8000361c:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000361e:	05850793          	addi	a5,a0,88
    80003622:	00f9f713          	andi	a4,s3,15
    80003626:	071a                	slli	a4,a4,0x6
    80003628:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    8000362a:	00079703          	lh	a4,0(a5)
    8000362e:	c701                	beqz	a4,80003636 <ireclaim+0xaa>
    80003630:	00679783          	lh	a5,6(a5)
    80003634:	dbc1                	beqz	a5,800035c4 <ireclaim+0x38>
    brelse(bp);
    80003636:	854a                	mv	a0,s2
    80003638:	f98ff0ef          	jal	80002dd0 <brelse>
    if (ip) {
    8000363c:	bf7d                	j	800035fa <ireclaim+0x6e>
}
    8000363e:	70e2                	ld	ra,56(sp)
    80003640:	7442                	ld	s0,48(sp)
    80003642:	74a2                	ld	s1,40(sp)
    80003644:	7902                	ld	s2,32(sp)
    80003646:	69e2                	ld	s3,24(sp)
    80003648:	6a42                	ld	s4,16(sp)
    8000364a:	6aa2                	ld	s5,8(sp)
    8000364c:	6b02                	ld	s6,0(sp)
    8000364e:	6121                	addi	sp,sp,64
    80003650:	8082                	ret
    80003652:	8082                	ret

0000000080003654 <fsinit>:
fsinit(int dev) {
    80003654:	1101                	addi	sp,sp,-32
    80003656:	ec06                	sd	ra,24(sp)
    80003658:	e822                	sd	s0,16(sp)
    8000365a:	e426                	sd	s1,8(sp)
    8000365c:	e04a                	sd	s2,0(sp)
    8000365e:	1000                	addi	s0,sp,32
    80003660:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003662:	4585                	li	a1,1
    80003664:	e64ff0ef          	jal	80002cc8 <bread>
    80003668:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000366a:	02000613          	li	a2,32
    8000366e:	05850593          	addi	a1,a0,88
    80003672:	00026517          	auipc	a0,0x26
    80003676:	7fe50513          	addi	a0,a0,2046 # 80029e70 <sb>
    8000367a:	edefd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    8000367e:	8526                	mv	a0,s1
    80003680:	f50ff0ef          	jal	80002dd0 <brelse>
  if(sb.magic != FSMAGIC)
    80003684:	00026717          	auipc	a4,0x26
    80003688:	7ec72703          	lw	a4,2028(a4) # 80029e70 <sb>
    8000368c:	102037b7          	lui	a5,0x10203
    80003690:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003694:	02f71263          	bne	a4,a5,800036b8 <fsinit+0x64>
  initlog(dev, &sb);
    80003698:	00026597          	auipc	a1,0x26
    8000369c:	7d858593          	addi	a1,a1,2008 # 80029e70 <sb>
    800036a0:	854a                	mv	a0,s2
    800036a2:	648000ef          	jal	80003cea <initlog>
  ireclaim(dev);
    800036a6:	854a                	mv	a0,s2
    800036a8:	ee5ff0ef          	jal	8000358c <ireclaim>
}
    800036ac:	60e2                	ld	ra,24(sp)
    800036ae:	6442                	ld	s0,16(sp)
    800036b0:	64a2                	ld	s1,8(sp)
    800036b2:	6902                	ld	s2,0(sp)
    800036b4:	6105                	addi	sp,sp,32
    800036b6:	8082                	ret
    panic("invalid file system");
    800036b8:	00004517          	auipc	a0,0x4
    800036bc:	dd050513          	addi	a0,a0,-560 # 80007488 <etext+0x488>
    800036c0:	964fd0ef          	jal	80000824 <panic>

00000000800036c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800036c4:	1141                	addi	sp,sp,-16
    800036c6:	e406                	sd	ra,8(sp)
    800036c8:	e022                	sd	s0,0(sp)
    800036ca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800036cc:	411c                	lw	a5,0(a0)
    800036ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800036d0:	415c                	lw	a5,4(a0)
    800036d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800036d4:	04451783          	lh	a5,68(a0)
    800036d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036dc:	04a51783          	lh	a5,74(a0)
    800036e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036e4:	04c56783          	lwu	a5,76(a0)
    800036e8:	e99c                	sd	a5,16(a1)
}
    800036ea:	60a2                	ld	ra,8(sp)
    800036ec:	6402                	ld	s0,0(sp)
    800036ee:	0141                	addi	sp,sp,16
    800036f0:	8082                	ret

00000000800036f2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036f2:	457c                	lw	a5,76(a0)
    800036f4:	0ed7e663          	bltu	a5,a3,800037e0 <readi+0xee>
{
    800036f8:	7159                	addi	sp,sp,-112
    800036fa:	f486                	sd	ra,104(sp)
    800036fc:	f0a2                	sd	s0,96(sp)
    800036fe:	eca6                	sd	s1,88(sp)
    80003700:	e0d2                	sd	s4,64(sp)
    80003702:	fc56                	sd	s5,56(sp)
    80003704:	f85a                	sd	s6,48(sp)
    80003706:	f45e                	sd	s7,40(sp)
    80003708:	1880                	addi	s0,sp,112
    8000370a:	8b2a                	mv	s6,a0
    8000370c:	8bae                	mv	s7,a1
    8000370e:	8a32                	mv	s4,a2
    80003710:	84b6                	mv	s1,a3
    80003712:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003714:	9f35                	addw	a4,a4,a3
    return 0;
    80003716:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003718:	0ad76b63          	bltu	a4,a3,800037ce <readi+0xdc>
    8000371c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000371e:	00e7f463          	bgeu	a5,a4,80003726 <readi+0x34>
    n = ip->size - off;
    80003722:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003726:	080a8b63          	beqz	s5,800037bc <readi+0xca>
    8000372a:	e8ca                	sd	s2,80(sp)
    8000372c:	f062                	sd	s8,32(sp)
    8000372e:	ec66                	sd	s9,24(sp)
    80003730:	e86a                	sd	s10,16(sp)
    80003732:	e46e                	sd	s11,8(sp)
    80003734:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003736:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000373a:	5c7d                	li	s8,-1
    8000373c:	a80d                	j	8000376e <readi+0x7c>
    8000373e:	020d1d93          	slli	s11,s10,0x20
    80003742:	020ddd93          	srli	s11,s11,0x20
    80003746:	05890613          	addi	a2,s2,88
    8000374a:	86ee                	mv	a3,s11
    8000374c:	963e                	add	a2,a2,a5
    8000374e:	85d2                	mv	a1,s4
    80003750:	855e                	mv	a0,s7
    80003752:	c5bfe0ef          	jal	800023ac <either_copyout>
    80003756:	05850363          	beq	a0,s8,8000379c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000375a:	854a                	mv	a0,s2
    8000375c:	e74ff0ef          	jal	80002dd0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003760:	013d09bb          	addw	s3,s10,s3
    80003764:	009d04bb          	addw	s1,s10,s1
    80003768:	9a6e                	add	s4,s4,s11
    8000376a:	0559f363          	bgeu	s3,s5,800037b0 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000376e:	00a4d59b          	srliw	a1,s1,0xa
    80003772:	855a                	mv	a0,s6
    80003774:	8bbff0ef          	jal	8000302e <bmap>
    80003778:	85aa                	mv	a1,a0
    if(addr == 0)
    8000377a:	c139                	beqz	a0,800037c0 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000377c:	000b2503          	lw	a0,0(s6)
    80003780:	d48ff0ef          	jal	80002cc8 <bread>
    80003784:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003786:	3ff4f793          	andi	a5,s1,1023
    8000378a:	40fc873b          	subw	a4,s9,a5
    8000378e:	413a86bb          	subw	a3,s5,s3
    80003792:	8d3a                	mv	s10,a4
    80003794:	fae6f5e3          	bgeu	a3,a4,8000373e <readi+0x4c>
    80003798:	8d36                	mv	s10,a3
    8000379a:	b755                	j	8000373e <readi+0x4c>
      brelse(bp);
    8000379c:	854a                	mv	a0,s2
    8000379e:	e32ff0ef          	jal	80002dd0 <brelse>
      tot = -1;
    800037a2:	59fd                	li	s3,-1
      break;
    800037a4:	6946                	ld	s2,80(sp)
    800037a6:	7c02                	ld	s8,32(sp)
    800037a8:	6ce2                	ld	s9,24(sp)
    800037aa:	6d42                	ld	s10,16(sp)
    800037ac:	6da2                	ld	s11,8(sp)
    800037ae:	a831                	j	800037ca <readi+0xd8>
    800037b0:	6946                	ld	s2,80(sp)
    800037b2:	7c02                	ld	s8,32(sp)
    800037b4:	6ce2                	ld	s9,24(sp)
    800037b6:	6d42                	ld	s10,16(sp)
    800037b8:	6da2                	ld	s11,8(sp)
    800037ba:	a801                	j	800037ca <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800037bc:	89d6                	mv	s3,s5
    800037be:	a031                	j	800037ca <readi+0xd8>
    800037c0:	6946                	ld	s2,80(sp)
    800037c2:	7c02                	ld	s8,32(sp)
    800037c4:	6ce2                	ld	s9,24(sp)
    800037c6:	6d42                	ld	s10,16(sp)
    800037c8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800037ca:	854e                	mv	a0,s3
    800037cc:	69a6                	ld	s3,72(sp)
}
    800037ce:	70a6                	ld	ra,104(sp)
    800037d0:	7406                	ld	s0,96(sp)
    800037d2:	64e6                	ld	s1,88(sp)
    800037d4:	6a06                	ld	s4,64(sp)
    800037d6:	7ae2                	ld	s5,56(sp)
    800037d8:	7b42                	ld	s6,48(sp)
    800037da:	7ba2                	ld	s7,40(sp)
    800037dc:	6165                	addi	sp,sp,112
    800037de:	8082                	ret
    return 0;
    800037e0:	4501                	li	a0,0
}
    800037e2:	8082                	ret

00000000800037e4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037e4:	457c                	lw	a5,76(a0)
    800037e6:	0ed7eb63          	bltu	a5,a3,800038dc <writei+0xf8>
{
    800037ea:	7159                	addi	sp,sp,-112
    800037ec:	f486                	sd	ra,104(sp)
    800037ee:	f0a2                	sd	s0,96(sp)
    800037f0:	e8ca                	sd	s2,80(sp)
    800037f2:	e0d2                	sd	s4,64(sp)
    800037f4:	fc56                	sd	s5,56(sp)
    800037f6:	f85a                	sd	s6,48(sp)
    800037f8:	f45e                	sd	s7,40(sp)
    800037fa:	1880                	addi	s0,sp,112
    800037fc:	8aaa                	mv	s5,a0
    800037fe:	8bae                	mv	s7,a1
    80003800:	8a32                	mv	s4,a2
    80003802:	8936                	mv	s2,a3
    80003804:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003806:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000380a:	00043737          	lui	a4,0x43
    8000380e:	0cf76963          	bltu	a4,a5,800038e0 <writei+0xfc>
    80003812:	0cd7e763          	bltu	a5,a3,800038e0 <writei+0xfc>
    80003816:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003818:	0a0b0a63          	beqz	s6,800038cc <writei+0xe8>
    8000381c:	eca6                	sd	s1,88(sp)
    8000381e:	f062                	sd	s8,32(sp)
    80003820:	ec66                	sd	s9,24(sp)
    80003822:	e86a                	sd	s10,16(sp)
    80003824:	e46e                	sd	s11,8(sp)
    80003826:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003828:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000382c:	5c7d                	li	s8,-1
    8000382e:	a825                	j	80003866 <writei+0x82>
    80003830:	020d1d93          	slli	s11,s10,0x20
    80003834:	020ddd93          	srli	s11,s11,0x20
    80003838:	05848513          	addi	a0,s1,88
    8000383c:	86ee                	mv	a3,s11
    8000383e:	8652                	mv	a2,s4
    80003840:	85de                	mv	a1,s7
    80003842:	953e                	add	a0,a0,a5
    80003844:	bb3fe0ef          	jal	800023f6 <either_copyin>
    80003848:	05850663          	beq	a0,s8,80003894 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000384c:	8526                	mv	a0,s1
    8000384e:	6b8000ef          	jal	80003f06 <log_write>
    brelse(bp);
    80003852:	8526                	mv	a0,s1
    80003854:	d7cff0ef          	jal	80002dd0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003858:	013d09bb          	addw	s3,s10,s3
    8000385c:	012d093b          	addw	s2,s10,s2
    80003860:	9a6e                	add	s4,s4,s11
    80003862:	0369fc63          	bgeu	s3,s6,8000389a <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003866:	00a9559b          	srliw	a1,s2,0xa
    8000386a:	8556                	mv	a0,s5
    8000386c:	fc2ff0ef          	jal	8000302e <bmap>
    80003870:	85aa                	mv	a1,a0
    if(addr == 0)
    80003872:	c505                	beqz	a0,8000389a <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003874:	000aa503          	lw	a0,0(s5)
    80003878:	c50ff0ef          	jal	80002cc8 <bread>
    8000387c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000387e:	3ff97793          	andi	a5,s2,1023
    80003882:	40fc873b          	subw	a4,s9,a5
    80003886:	413b06bb          	subw	a3,s6,s3
    8000388a:	8d3a                	mv	s10,a4
    8000388c:	fae6f2e3          	bgeu	a3,a4,80003830 <writei+0x4c>
    80003890:	8d36                	mv	s10,a3
    80003892:	bf79                	j	80003830 <writei+0x4c>
      brelse(bp);
    80003894:	8526                	mv	a0,s1
    80003896:	d3aff0ef          	jal	80002dd0 <brelse>
  }

  if(off > ip->size)
    8000389a:	04caa783          	lw	a5,76(s5)
    8000389e:	0327f963          	bgeu	a5,s2,800038d0 <writei+0xec>
    ip->size = off;
    800038a2:	052aa623          	sw	s2,76(s5)
    800038a6:	64e6                	ld	s1,88(sp)
    800038a8:	7c02                	ld	s8,32(sp)
    800038aa:	6ce2                	ld	s9,24(sp)
    800038ac:	6d42                	ld	s10,16(sp)
    800038ae:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800038b0:	8556                	mv	a0,s5
    800038b2:	9fbff0ef          	jal	800032ac <iupdate>

  return tot;
    800038b6:	854e                	mv	a0,s3
    800038b8:	69a6                	ld	s3,72(sp)
}
    800038ba:	70a6                	ld	ra,104(sp)
    800038bc:	7406                	ld	s0,96(sp)
    800038be:	6946                	ld	s2,80(sp)
    800038c0:	6a06                	ld	s4,64(sp)
    800038c2:	7ae2                	ld	s5,56(sp)
    800038c4:	7b42                	ld	s6,48(sp)
    800038c6:	7ba2                	ld	s7,40(sp)
    800038c8:	6165                	addi	sp,sp,112
    800038ca:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800038cc:	89da                	mv	s3,s6
    800038ce:	b7cd                	j	800038b0 <writei+0xcc>
    800038d0:	64e6                	ld	s1,88(sp)
    800038d2:	7c02                	ld	s8,32(sp)
    800038d4:	6ce2                	ld	s9,24(sp)
    800038d6:	6d42                	ld	s10,16(sp)
    800038d8:	6da2                	ld	s11,8(sp)
    800038da:	bfd9                	j	800038b0 <writei+0xcc>
    return -1;
    800038dc:	557d                	li	a0,-1
}
    800038de:	8082                	ret
    return -1;
    800038e0:	557d                	li	a0,-1
    800038e2:	bfe1                	j	800038ba <writei+0xd6>

00000000800038e4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800038e4:	1141                	addi	sp,sp,-16
    800038e6:	e406                	sd	ra,8(sp)
    800038e8:	e022                	sd	s0,0(sp)
    800038ea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038ec:	4639                	li	a2,14
    800038ee:	cdefd0ef          	jal	80000dcc <strncmp>
}
    800038f2:	60a2                	ld	ra,8(sp)
    800038f4:	6402                	ld	s0,0(sp)
    800038f6:	0141                	addi	sp,sp,16
    800038f8:	8082                	ret

00000000800038fa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038fa:	711d                	addi	sp,sp,-96
    800038fc:	ec86                	sd	ra,88(sp)
    800038fe:	e8a2                	sd	s0,80(sp)
    80003900:	e4a6                	sd	s1,72(sp)
    80003902:	e0ca                	sd	s2,64(sp)
    80003904:	fc4e                	sd	s3,56(sp)
    80003906:	f852                	sd	s4,48(sp)
    80003908:	f456                	sd	s5,40(sp)
    8000390a:	f05a                	sd	s6,32(sp)
    8000390c:	ec5e                	sd	s7,24(sp)
    8000390e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003910:	04451703          	lh	a4,68(a0)
    80003914:	4785                	li	a5,1
    80003916:	00f71f63          	bne	a4,a5,80003934 <dirlookup+0x3a>
    8000391a:	892a                	mv	s2,a0
    8000391c:	8aae                	mv	s5,a1
    8000391e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003920:	457c                	lw	a5,76(a0)
    80003922:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003924:	fa040a13          	addi	s4,s0,-96
    80003928:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000392a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000392e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003930:	e39d                	bnez	a5,80003956 <dirlookup+0x5c>
    80003932:	a8b9                	j	80003990 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003934:	00004517          	auipc	a0,0x4
    80003938:	b6c50513          	addi	a0,a0,-1172 # 800074a0 <etext+0x4a0>
    8000393c:	ee9fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80003940:	00004517          	auipc	a0,0x4
    80003944:	b7850513          	addi	a0,a0,-1160 # 800074b8 <etext+0x4b8>
    80003948:	eddfc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000394c:	24c1                	addiw	s1,s1,16
    8000394e:	04c92783          	lw	a5,76(s2)
    80003952:	02f4fe63          	bgeu	s1,a5,8000398e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003956:	874e                	mv	a4,s3
    80003958:	86a6                	mv	a3,s1
    8000395a:	8652                	mv	a2,s4
    8000395c:	4581                	li	a1,0
    8000395e:	854a                	mv	a0,s2
    80003960:	d93ff0ef          	jal	800036f2 <readi>
    80003964:	fd351ee3          	bne	a0,s3,80003940 <dirlookup+0x46>
    if(de.inum == 0)
    80003968:	fa045783          	lhu	a5,-96(s0)
    8000396c:	d3e5                	beqz	a5,8000394c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    8000396e:	85da                	mv	a1,s6
    80003970:	8556                	mv	a0,s5
    80003972:	f73ff0ef          	jal	800038e4 <namecmp>
    80003976:	f979                	bnez	a0,8000394c <dirlookup+0x52>
      if(poff)
    80003978:	000b8463          	beqz	s7,80003980 <dirlookup+0x86>
        *poff = off;
    8000397c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003980:	fa045583          	lhu	a1,-96(s0)
    80003984:	00092503          	lw	a0,0(s2)
    80003988:	f66ff0ef          	jal	800030ee <iget>
    8000398c:	a011                	j	80003990 <dirlookup+0x96>
  return 0;
    8000398e:	4501                	li	a0,0
}
    80003990:	60e6                	ld	ra,88(sp)
    80003992:	6446                	ld	s0,80(sp)
    80003994:	64a6                	ld	s1,72(sp)
    80003996:	6906                	ld	s2,64(sp)
    80003998:	79e2                	ld	s3,56(sp)
    8000399a:	7a42                	ld	s4,48(sp)
    8000399c:	7aa2                	ld	s5,40(sp)
    8000399e:	7b02                	ld	s6,32(sp)
    800039a0:	6be2                	ld	s7,24(sp)
    800039a2:	6125                	addi	sp,sp,96
    800039a4:	8082                	ret

00000000800039a6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800039a6:	711d                	addi	sp,sp,-96
    800039a8:	ec86                	sd	ra,88(sp)
    800039aa:	e8a2                	sd	s0,80(sp)
    800039ac:	e4a6                	sd	s1,72(sp)
    800039ae:	e0ca                	sd	s2,64(sp)
    800039b0:	fc4e                	sd	s3,56(sp)
    800039b2:	f852                	sd	s4,48(sp)
    800039b4:	f456                	sd	s5,40(sp)
    800039b6:	f05a                	sd	s6,32(sp)
    800039b8:	ec5e                	sd	s7,24(sp)
    800039ba:	e862                	sd	s8,16(sp)
    800039bc:	e466                	sd	s9,8(sp)
    800039be:	e06a                	sd	s10,0(sp)
    800039c0:	1080                	addi	s0,sp,96
    800039c2:	84aa                	mv	s1,a0
    800039c4:	8b2e                	mv	s6,a1
    800039c6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800039c8:	00054703          	lbu	a4,0(a0)
    800039cc:	02f00793          	li	a5,47
    800039d0:	00f70f63          	beq	a4,a5,800039ee <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800039d4:	f53fd0ef          	jal	80001926 <myproc>
    800039d8:	15053503          	ld	a0,336(a0)
    800039dc:	94fff0ef          	jal	8000332a <idup>
    800039e0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800039e2:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800039e6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800039e8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800039ea:	4b85                	li	s7,1
    800039ec:	a879                	j	80003a8a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800039ee:	4585                	li	a1,1
    800039f0:	852e                	mv	a0,a1
    800039f2:	efcff0ef          	jal	800030ee <iget>
    800039f6:	8a2a                	mv	s4,a0
    800039f8:	b7ed                	j	800039e2 <namex+0x3c>
      iunlockput(ip);
    800039fa:	8552                	mv	a0,s4
    800039fc:	b71ff0ef          	jal	8000356c <iunlockput>
      return 0;
    80003a00:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a02:	8552                	mv	a0,s4
    80003a04:	60e6                	ld	ra,88(sp)
    80003a06:	6446                	ld	s0,80(sp)
    80003a08:	64a6                	ld	s1,72(sp)
    80003a0a:	6906                	ld	s2,64(sp)
    80003a0c:	79e2                	ld	s3,56(sp)
    80003a0e:	7a42                	ld	s4,48(sp)
    80003a10:	7aa2                	ld	s5,40(sp)
    80003a12:	7b02                	ld	s6,32(sp)
    80003a14:	6be2                	ld	s7,24(sp)
    80003a16:	6c42                	ld	s8,16(sp)
    80003a18:	6ca2                	ld	s9,8(sp)
    80003a1a:	6d02                	ld	s10,0(sp)
    80003a1c:	6125                	addi	sp,sp,96
    80003a1e:	8082                	ret
      iunlock(ip);
    80003a20:	8552                	mv	a0,s4
    80003a22:	9edff0ef          	jal	8000340e <iunlock>
      return ip;
    80003a26:	bff1                	j	80003a02 <namex+0x5c>
      iunlockput(ip);
    80003a28:	8552                	mv	a0,s4
    80003a2a:	b43ff0ef          	jal	8000356c <iunlockput>
      return 0;
    80003a2e:	8a4a                	mv	s4,s2
    80003a30:	bfc9                	j	80003a02 <namex+0x5c>
  len = path - s;
    80003a32:	40990633          	sub	a2,s2,s1
    80003a36:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003a3a:	09ac5463          	bge	s8,s10,80003ac2 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003a3e:	8666                	mv	a2,s9
    80003a40:	85a6                	mv	a1,s1
    80003a42:	8556                	mv	a0,s5
    80003a44:	b14fd0ef          	jal	80000d58 <memmove>
    80003a48:	84ca                	mv	s1,s2
  while(*path == '/')
    80003a4a:	0004c783          	lbu	a5,0(s1)
    80003a4e:	01379763          	bne	a5,s3,80003a5c <namex+0xb6>
    path++;
    80003a52:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a54:	0004c783          	lbu	a5,0(s1)
    80003a58:	ff378de3          	beq	a5,s3,80003a52 <namex+0xac>
    ilock(ip);
    80003a5c:	8552                	mv	a0,s4
    80003a5e:	903ff0ef          	jal	80003360 <ilock>
    if(ip->type != T_DIR){
    80003a62:	044a1783          	lh	a5,68(s4)
    80003a66:	f9779ae3          	bne	a5,s7,800039fa <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003a6a:	000b0563          	beqz	s6,80003a74 <namex+0xce>
    80003a6e:	0004c783          	lbu	a5,0(s1)
    80003a72:	d7dd                	beqz	a5,80003a20 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a74:	4601                	li	a2,0
    80003a76:	85d6                	mv	a1,s5
    80003a78:	8552                	mv	a0,s4
    80003a7a:	e81ff0ef          	jal	800038fa <dirlookup>
    80003a7e:	892a                	mv	s2,a0
    80003a80:	d545                	beqz	a0,80003a28 <namex+0x82>
    iunlockput(ip);
    80003a82:	8552                	mv	a0,s4
    80003a84:	ae9ff0ef          	jal	8000356c <iunlockput>
    ip = next;
    80003a88:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003a8a:	0004c783          	lbu	a5,0(s1)
    80003a8e:	01379763          	bne	a5,s3,80003a9c <namex+0xf6>
    path++;
    80003a92:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a94:	0004c783          	lbu	a5,0(s1)
    80003a98:	ff378de3          	beq	a5,s3,80003a92 <namex+0xec>
  if(*path == 0)
    80003a9c:	cf8d                	beqz	a5,80003ad6 <namex+0x130>
  while(*path != '/' && *path != 0)
    80003a9e:	0004c783          	lbu	a5,0(s1)
    80003aa2:	fd178713          	addi	a4,a5,-47
    80003aa6:	cb19                	beqz	a4,80003abc <namex+0x116>
    80003aa8:	cb91                	beqz	a5,80003abc <namex+0x116>
    80003aaa:	8926                	mv	s2,s1
    path++;
    80003aac:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003aae:	00094783          	lbu	a5,0(s2)
    80003ab2:	fd178713          	addi	a4,a5,-47
    80003ab6:	df35                	beqz	a4,80003a32 <namex+0x8c>
    80003ab8:	fbf5                	bnez	a5,80003aac <namex+0x106>
    80003aba:	bfa5                	j	80003a32 <namex+0x8c>
    80003abc:	8926                	mv	s2,s1
  len = path - s;
    80003abe:	4d01                	li	s10,0
    80003ac0:	4601                	li	a2,0
    memmove(name, s, len);
    80003ac2:	2601                	sext.w	a2,a2
    80003ac4:	85a6                	mv	a1,s1
    80003ac6:	8556                	mv	a0,s5
    80003ac8:	a90fd0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80003acc:	9d56                	add	s10,s10,s5
    80003ace:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffd2488>
    80003ad2:	84ca                	mv	s1,s2
    80003ad4:	bf9d                	j	80003a4a <namex+0xa4>
  if(nameiparent){
    80003ad6:	f20b06e3          	beqz	s6,80003a02 <namex+0x5c>
    iput(ip);
    80003ada:	8552                	mv	a0,s4
    80003adc:	a07ff0ef          	jal	800034e2 <iput>
    return 0;
    80003ae0:	4a01                	li	s4,0
    80003ae2:	b705                	j	80003a02 <namex+0x5c>

0000000080003ae4 <dirlink>:
{
    80003ae4:	715d                	addi	sp,sp,-80
    80003ae6:	e486                	sd	ra,72(sp)
    80003ae8:	e0a2                	sd	s0,64(sp)
    80003aea:	f84a                	sd	s2,48(sp)
    80003aec:	ec56                	sd	s5,24(sp)
    80003aee:	e85a                	sd	s6,16(sp)
    80003af0:	0880                	addi	s0,sp,80
    80003af2:	892a                	mv	s2,a0
    80003af4:	8aae                	mv	s5,a1
    80003af6:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003af8:	4601                	li	a2,0
    80003afa:	e01ff0ef          	jal	800038fa <dirlookup>
    80003afe:	ed1d                	bnez	a0,80003b3c <dirlink+0x58>
    80003b00:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b02:	04c92483          	lw	s1,76(s2)
    80003b06:	c4b9                	beqz	s1,80003b54 <dirlink+0x70>
    80003b08:	f44e                	sd	s3,40(sp)
    80003b0a:	f052                	sd	s4,32(sp)
    80003b0c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b0e:	fb040a13          	addi	s4,s0,-80
    80003b12:	49c1                	li	s3,16
    80003b14:	874e                	mv	a4,s3
    80003b16:	86a6                	mv	a3,s1
    80003b18:	8652                	mv	a2,s4
    80003b1a:	4581                	li	a1,0
    80003b1c:	854a                	mv	a0,s2
    80003b1e:	bd5ff0ef          	jal	800036f2 <readi>
    80003b22:	03351163          	bne	a0,s3,80003b44 <dirlink+0x60>
    if(de.inum == 0)
    80003b26:	fb045783          	lhu	a5,-80(s0)
    80003b2a:	c39d                	beqz	a5,80003b50 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b2c:	24c1                	addiw	s1,s1,16
    80003b2e:	04c92783          	lw	a5,76(s2)
    80003b32:	fef4e1e3          	bltu	s1,a5,80003b14 <dirlink+0x30>
    80003b36:	79a2                	ld	s3,40(sp)
    80003b38:	7a02                	ld	s4,32(sp)
    80003b3a:	a829                	j	80003b54 <dirlink+0x70>
    iput(ip);
    80003b3c:	9a7ff0ef          	jal	800034e2 <iput>
    return -1;
    80003b40:	557d                	li	a0,-1
    80003b42:	a83d                	j	80003b80 <dirlink+0x9c>
      panic("dirlink read");
    80003b44:	00004517          	auipc	a0,0x4
    80003b48:	98450513          	addi	a0,a0,-1660 # 800074c8 <etext+0x4c8>
    80003b4c:	cd9fc0ef          	jal	80000824 <panic>
    80003b50:	79a2                	ld	s3,40(sp)
    80003b52:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003b54:	4639                	li	a2,14
    80003b56:	85d6                	mv	a1,s5
    80003b58:	fb240513          	addi	a0,s0,-78
    80003b5c:	aaafd0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80003b60:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b64:	4741                	li	a4,16
    80003b66:	86a6                	mv	a3,s1
    80003b68:	fb040613          	addi	a2,s0,-80
    80003b6c:	4581                	li	a1,0
    80003b6e:	854a                	mv	a0,s2
    80003b70:	c75ff0ef          	jal	800037e4 <writei>
    80003b74:	1541                	addi	a0,a0,-16
    80003b76:	00a03533          	snez	a0,a0
    80003b7a:	40a0053b          	negw	a0,a0
    80003b7e:	74e2                	ld	s1,56(sp)
}
    80003b80:	60a6                	ld	ra,72(sp)
    80003b82:	6406                	ld	s0,64(sp)
    80003b84:	7942                	ld	s2,48(sp)
    80003b86:	6ae2                	ld	s5,24(sp)
    80003b88:	6b42                	ld	s6,16(sp)
    80003b8a:	6161                	addi	sp,sp,80
    80003b8c:	8082                	ret

0000000080003b8e <namei>:

struct inode*
namei(char *path)
{
    80003b8e:	1101                	addi	sp,sp,-32
    80003b90:	ec06                	sd	ra,24(sp)
    80003b92:	e822                	sd	s0,16(sp)
    80003b94:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b96:	fe040613          	addi	a2,s0,-32
    80003b9a:	4581                	li	a1,0
    80003b9c:	e0bff0ef          	jal	800039a6 <namex>
}
    80003ba0:	60e2                	ld	ra,24(sp)
    80003ba2:	6442                	ld	s0,16(sp)
    80003ba4:	6105                	addi	sp,sp,32
    80003ba6:	8082                	ret

0000000080003ba8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003ba8:	1141                	addi	sp,sp,-16
    80003baa:	e406                	sd	ra,8(sp)
    80003bac:	e022                	sd	s0,0(sp)
    80003bae:	0800                	addi	s0,sp,16
    80003bb0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003bb2:	4585                	li	a1,1
    80003bb4:	df3ff0ef          	jal	800039a6 <namex>
}
    80003bb8:	60a2                	ld	ra,8(sp)
    80003bba:	6402                	ld	s0,0(sp)
    80003bbc:	0141                	addi	sp,sp,16
    80003bbe:	8082                	ret

0000000080003bc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003bc0:	1101                	addi	sp,sp,-32
    80003bc2:	ec06                	sd	ra,24(sp)
    80003bc4:	e822                	sd	s0,16(sp)
    80003bc6:	e426                	sd	s1,8(sp)
    80003bc8:	e04a                	sd	s2,0(sp)
    80003bca:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003bcc:	00028917          	auipc	s2,0x28
    80003bd0:	d6c90913          	addi	s2,s2,-660 # 8002b938 <log>
    80003bd4:	01892583          	lw	a1,24(s2)
    80003bd8:	02492503          	lw	a0,36(s2)
    80003bdc:	8ecff0ef          	jal	80002cc8 <bread>
    80003be0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003be2:	02892603          	lw	a2,40(s2)
    80003be6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003be8:	00c05f63          	blez	a2,80003c06 <write_head+0x46>
    80003bec:	00028717          	auipc	a4,0x28
    80003bf0:	d7870713          	addi	a4,a4,-648 # 8002b964 <log+0x2c>
    80003bf4:	87aa                	mv	a5,a0
    80003bf6:	060a                	slli	a2,a2,0x2
    80003bf8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003bfa:	4314                	lw	a3,0(a4)
    80003bfc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003bfe:	0711                	addi	a4,a4,4
    80003c00:	0791                	addi	a5,a5,4
    80003c02:	fec79ce3          	bne	a5,a2,80003bfa <write_head+0x3a>
  }
  bwrite(buf);
    80003c06:	8526                	mv	a0,s1
    80003c08:	996ff0ef          	jal	80002d9e <bwrite>
  brelse(buf);
    80003c0c:	8526                	mv	a0,s1
    80003c0e:	9c2ff0ef          	jal	80002dd0 <brelse>
}
    80003c12:	60e2                	ld	ra,24(sp)
    80003c14:	6442                	ld	s0,16(sp)
    80003c16:	64a2                	ld	s1,8(sp)
    80003c18:	6902                	ld	s2,0(sp)
    80003c1a:	6105                	addi	sp,sp,32
    80003c1c:	8082                	ret

0000000080003c1e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c1e:	00028797          	auipc	a5,0x28
    80003c22:	d427a783          	lw	a5,-702(a5) # 8002b960 <log+0x28>
    80003c26:	0cf05163          	blez	a5,80003ce8 <install_trans+0xca>
{
    80003c2a:	715d                	addi	sp,sp,-80
    80003c2c:	e486                	sd	ra,72(sp)
    80003c2e:	e0a2                	sd	s0,64(sp)
    80003c30:	fc26                	sd	s1,56(sp)
    80003c32:	f84a                	sd	s2,48(sp)
    80003c34:	f44e                	sd	s3,40(sp)
    80003c36:	f052                	sd	s4,32(sp)
    80003c38:	ec56                	sd	s5,24(sp)
    80003c3a:	e85a                	sd	s6,16(sp)
    80003c3c:	e45e                	sd	s7,8(sp)
    80003c3e:	e062                	sd	s8,0(sp)
    80003c40:	0880                	addi	s0,sp,80
    80003c42:	8b2a                	mv	s6,a0
    80003c44:	00028a97          	auipc	s5,0x28
    80003c48:	d20a8a93          	addi	s5,s5,-736 # 8002b964 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c4c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c4e:	00004c17          	auipc	s8,0x4
    80003c52:	88ac0c13          	addi	s8,s8,-1910 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c56:	00028a17          	auipc	s4,0x28
    80003c5a:	ce2a0a13          	addi	s4,s4,-798 # 8002b938 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c5e:	40000b93          	li	s7,1024
    80003c62:	a025                	j	80003c8a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c64:	000aa603          	lw	a2,0(s5)
    80003c68:	85ce                	mv	a1,s3
    80003c6a:	8562                	mv	a0,s8
    80003c6c:	88ffc0ef          	jal	800004fa <printf>
    80003c70:	a839                	j	80003c8e <install_trans+0x70>
    brelse(lbuf);
    80003c72:	854a                	mv	a0,s2
    80003c74:	95cff0ef          	jal	80002dd0 <brelse>
    brelse(dbuf);
    80003c78:	8526                	mv	a0,s1
    80003c7a:	956ff0ef          	jal	80002dd0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c7e:	2985                	addiw	s3,s3,1
    80003c80:	0a91                	addi	s5,s5,4
    80003c82:	028a2783          	lw	a5,40(s4)
    80003c86:	04f9d563          	bge	s3,a5,80003cd0 <install_trans+0xb2>
    if(recovering) {
    80003c8a:	fc0b1de3          	bnez	s6,80003c64 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c8e:	018a2583          	lw	a1,24(s4)
    80003c92:	013585bb          	addw	a1,a1,s3
    80003c96:	2585                	addiw	a1,a1,1
    80003c98:	024a2503          	lw	a0,36(s4)
    80003c9c:	82cff0ef          	jal	80002cc8 <bread>
    80003ca0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003ca2:	000aa583          	lw	a1,0(s5)
    80003ca6:	024a2503          	lw	a0,36(s4)
    80003caa:	81eff0ef          	jal	80002cc8 <bread>
    80003cae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003cb0:	865e                	mv	a2,s7
    80003cb2:	05890593          	addi	a1,s2,88
    80003cb6:	05850513          	addi	a0,a0,88
    80003cba:	89efd0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003cbe:	8526                	mv	a0,s1
    80003cc0:	8deff0ef          	jal	80002d9e <bwrite>
    if(recovering == 0)
    80003cc4:	fa0b17e3          	bnez	s6,80003c72 <install_trans+0x54>
      bunpin(dbuf);
    80003cc8:	8526                	mv	a0,s1
    80003cca:	9beff0ef          	jal	80002e88 <bunpin>
    80003cce:	b755                	j	80003c72 <install_trans+0x54>
}
    80003cd0:	60a6                	ld	ra,72(sp)
    80003cd2:	6406                	ld	s0,64(sp)
    80003cd4:	74e2                	ld	s1,56(sp)
    80003cd6:	7942                	ld	s2,48(sp)
    80003cd8:	79a2                	ld	s3,40(sp)
    80003cda:	7a02                	ld	s4,32(sp)
    80003cdc:	6ae2                	ld	s5,24(sp)
    80003cde:	6b42                	ld	s6,16(sp)
    80003ce0:	6ba2                	ld	s7,8(sp)
    80003ce2:	6c02                	ld	s8,0(sp)
    80003ce4:	6161                	addi	sp,sp,80
    80003ce6:	8082                	ret
    80003ce8:	8082                	ret

0000000080003cea <initlog>:
{
    80003cea:	7179                	addi	sp,sp,-48
    80003cec:	f406                	sd	ra,40(sp)
    80003cee:	f022                	sd	s0,32(sp)
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e84a                	sd	s2,16(sp)
    80003cf4:	e44e                	sd	s3,8(sp)
    80003cf6:	1800                	addi	s0,sp,48
    80003cf8:	84aa                	mv	s1,a0
    80003cfa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003cfc:	00028917          	auipc	s2,0x28
    80003d00:	c3c90913          	addi	s2,s2,-964 # 8002b938 <log>
    80003d04:	00003597          	auipc	a1,0x3
    80003d08:	7f458593          	addi	a1,a1,2036 # 800074f8 <etext+0x4f8>
    80003d0c:	854a                	mv	a0,s2
    80003d0e:	e91fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80003d12:	0149a583          	lw	a1,20(s3)
    80003d16:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003d1a:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003d1e:	8526                	mv	a0,s1
    80003d20:	fa9fe0ef          	jal	80002cc8 <bread>
  log.lh.n = lh->n;
    80003d24:	4d30                	lw	a2,88(a0)
    80003d26:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003d2a:	00c05f63          	blez	a2,80003d48 <initlog+0x5e>
    80003d2e:	87aa                	mv	a5,a0
    80003d30:	00028717          	auipc	a4,0x28
    80003d34:	c3470713          	addi	a4,a4,-972 # 8002b964 <log+0x2c>
    80003d38:	060a                	slli	a2,a2,0x2
    80003d3a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003d3c:	4ff4                	lw	a3,92(a5)
    80003d3e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d40:	0791                	addi	a5,a5,4
    80003d42:	0711                	addi	a4,a4,4
    80003d44:	fec79ce3          	bne	a5,a2,80003d3c <initlog+0x52>
  brelse(buf);
    80003d48:	888ff0ef          	jal	80002dd0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003d4c:	4505                	li	a0,1
    80003d4e:	ed1ff0ef          	jal	80003c1e <install_trans>
  log.lh.n = 0;
    80003d52:	00028797          	auipc	a5,0x28
    80003d56:	c007a723          	sw	zero,-1010(a5) # 8002b960 <log+0x28>
  write_head(); // clear the log
    80003d5a:	e67ff0ef          	jal	80003bc0 <write_head>
}
    80003d5e:	70a2                	ld	ra,40(sp)
    80003d60:	7402                	ld	s0,32(sp)
    80003d62:	64e2                	ld	s1,24(sp)
    80003d64:	6942                	ld	s2,16(sp)
    80003d66:	69a2                	ld	s3,8(sp)
    80003d68:	6145                	addi	sp,sp,48
    80003d6a:	8082                	ret

0000000080003d6c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d6c:	1101                	addi	sp,sp,-32
    80003d6e:	ec06                	sd	ra,24(sp)
    80003d70:	e822                	sd	s0,16(sp)
    80003d72:	e426                	sd	s1,8(sp)
    80003d74:	e04a                	sd	s2,0(sp)
    80003d76:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d78:	00028517          	auipc	a0,0x28
    80003d7c:	bc050513          	addi	a0,a0,-1088 # 8002b938 <log>
    80003d80:	ea9fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80003d84:	00028497          	auipc	s1,0x28
    80003d88:	bb448493          	addi	s1,s1,-1100 # 8002b938 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003d8c:	4979                	li	s2,30
    80003d8e:	a029                	j	80003d98 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003d90:	85a6                	mv	a1,s1
    80003d92:	8526                	mv	a0,s1
    80003d94:	a04fe0ef          	jal	80001f98 <sleep>
    if(log.committing){
    80003d98:	509c                	lw	a5,32(s1)
    80003d9a:	fbfd                	bnez	a5,80003d90 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003d9c:	4cd8                	lw	a4,28(s1)
    80003d9e:	2705                	addiw	a4,a4,1
    80003da0:	0027179b          	slliw	a5,a4,0x2
    80003da4:	9fb9                	addw	a5,a5,a4
    80003da6:	0017979b          	slliw	a5,a5,0x1
    80003daa:	5494                	lw	a3,40(s1)
    80003dac:	9fb5                	addw	a5,a5,a3
    80003dae:	00f95763          	bge	s2,a5,80003dbc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003db2:	85a6                	mv	a1,s1
    80003db4:	8526                	mv	a0,s1
    80003db6:	9e2fe0ef          	jal	80001f98 <sleep>
    80003dba:	bff9                	j	80003d98 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003dbc:	00028797          	auipc	a5,0x28
    80003dc0:	b8e7ac23          	sw	a4,-1128(a5) # 8002b954 <log+0x1c>
      release(&log.lock);
    80003dc4:	00028517          	auipc	a0,0x28
    80003dc8:	b7450513          	addi	a0,a0,-1164 # 8002b938 <log>
    80003dcc:	ef1fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003dd0:	60e2                	ld	ra,24(sp)
    80003dd2:	6442                	ld	s0,16(sp)
    80003dd4:	64a2                	ld	s1,8(sp)
    80003dd6:	6902                	ld	s2,0(sp)
    80003dd8:	6105                	addi	sp,sp,32
    80003dda:	8082                	ret

0000000080003ddc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003ddc:	7139                	addi	sp,sp,-64
    80003dde:	fc06                	sd	ra,56(sp)
    80003de0:	f822                	sd	s0,48(sp)
    80003de2:	f426                	sd	s1,40(sp)
    80003de4:	f04a                	sd	s2,32(sp)
    80003de6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003de8:	00028497          	auipc	s1,0x28
    80003dec:	b5048493          	addi	s1,s1,-1200 # 8002b938 <log>
    80003df0:	8526                	mv	a0,s1
    80003df2:	e37fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80003df6:	4cdc                	lw	a5,28(s1)
    80003df8:	37fd                	addiw	a5,a5,-1
    80003dfa:	893e                	mv	s2,a5
    80003dfc:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003dfe:	509c                	lw	a5,32(s1)
    80003e00:	e7b1                	bnez	a5,80003e4c <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003e02:	04091e63          	bnez	s2,80003e5e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003e06:	00028497          	auipc	s1,0x28
    80003e0a:	b3248493          	addi	s1,s1,-1230 # 8002b938 <log>
    80003e0e:	4785                	li	a5,1
    80003e10:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e12:	8526                	mv	a0,s1
    80003e14:	ea9fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e18:	549c                	lw	a5,40(s1)
    80003e1a:	06f04463          	bgtz	a5,80003e82 <end_op+0xa6>
    acquire(&log.lock);
    80003e1e:	00028517          	auipc	a0,0x28
    80003e22:	b1a50513          	addi	a0,a0,-1254 # 8002b938 <log>
    80003e26:	e03fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80003e2a:	00028797          	auipc	a5,0x28
    80003e2e:	b207a723          	sw	zero,-1234(a5) # 8002b958 <log+0x20>
    wakeup(&log);
    80003e32:	00028517          	auipc	a0,0x28
    80003e36:	b0650513          	addi	a0,a0,-1274 # 8002b938 <log>
    80003e3a:	9aafe0ef          	jal	80001fe4 <wakeup>
    release(&log.lock);
    80003e3e:	00028517          	auipc	a0,0x28
    80003e42:	afa50513          	addi	a0,a0,-1286 # 8002b938 <log>
    80003e46:	e77fc0ef          	jal	80000cbc <release>
}
    80003e4a:	a035                	j	80003e76 <end_op+0x9a>
    80003e4c:	ec4e                	sd	s3,24(sp)
    80003e4e:	e852                	sd	s4,16(sp)
    80003e50:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003e52:	00003517          	auipc	a0,0x3
    80003e56:	6ae50513          	addi	a0,a0,1710 # 80007500 <etext+0x500>
    80003e5a:	9cbfc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80003e5e:	00028517          	auipc	a0,0x28
    80003e62:	ada50513          	addi	a0,a0,-1318 # 8002b938 <log>
    80003e66:	97efe0ef          	jal	80001fe4 <wakeup>
  release(&log.lock);
    80003e6a:	00028517          	auipc	a0,0x28
    80003e6e:	ace50513          	addi	a0,a0,-1330 # 8002b938 <log>
    80003e72:	e4bfc0ef          	jal	80000cbc <release>
}
    80003e76:	70e2                	ld	ra,56(sp)
    80003e78:	7442                	ld	s0,48(sp)
    80003e7a:	74a2                	ld	s1,40(sp)
    80003e7c:	7902                	ld	s2,32(sp)
    80003e7e:	6121                	addi	sp,sp,64
    80003e80:	8082                	ret
    80003e82:	ec4e                	sd	s3,24(sp)
    80003e84:	e852                	sd	s4,16(sp)
    80003e86:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e88:	00028a97          	auipc	s5,0x28
    80003e8c:	adca8a93          	addi	s5,s5,-1316 # 8002b964 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003e90:	00028a17          	auipc	s4,0x28
    80003e94:	aa8a0a13          	addi	s4,s4,-1368 # 8002b938 <log>
    80003e98:	018a2583          	lw	a1,24(s4)
    80003e9c:	012585bb          	addw	a1,a1,s2
    80003ea0:	2585                	addiw	a1,a1,1
    80003ea2:	024a2503          	lw	a0,36(s4)
    80003ea6:	e23fe0ef          	jal	80002cc8 <bread>
    80003eaa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003eac:	000aa583          	lw	a1,0(s5)
    80003eb0:	024a2503          	lw	a0,36(s4)
    80003eb4:	e15fe0ef          	jal	80002cc8 <bread>
    80003eb8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003eba:	40000613          	li	a2,1024
    80003ebe:	05850593          	addi	a1,a0,88
    80003ec2:	05848513          	addi	a0,s1,88
    80003ec6:	e93fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80003eca:	8526                	mv	a0,s1
    80003ecc:	ed3fe0ef          	jal	80002d9e <bwrite>
    brelse(from);
    80003ed0:	854e                	mv	a0,s3
    80003ed2:	efffe0ef          	jal	80002dd0 <brelse>
    brelse(to);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	ef9fe0ef          	jal	80002dd0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003edc:	2905                	addiw	s2,s2,1
    80003ede:	0a91                	addi	s5,s5,4
    80003ee0:	028a2783          	lw	a5,40(s4)
    80003ee4:	faf94ae3          	blt	s2,a5,80003e98 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003ee8:	cd9ff0ef          	jal	80003bc0 <write_head>
    install_trans(0); // Now install writes to home locations
    80003eec:	4501                	li	a0,0
    80003eee:	d31ff0ef          	jal	80003c1e <install_trans>
    log.lh.n = 0;
    80003ef2:	00028797          	auipc	a5,0x28
    80003ef6:	a607a723          	sw	zero,-1426(a5) # 8002b960 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003efa:	cc7ff0ef          	jal	80003bc0 <write_head>
    80003efe:	69e2                	ld	s3,24(sp)
    80003f00:	6a42                	ld	s4,16(sp)
    80003f02:	6aa2                	ld	s5,8(sp)
    80003f04:	bf29                	j	80003e1e <end_op+0x42>

0000000080003f06 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f06:	1101                	addi	sp,sp,-32
    80003f08:	ec06                	sd	ra,24(sp)
    80003f0a:	e822                	sd	s0,16(sp)
    80003f0c:	e426                	sd	s1,8(sp)
    80003f0e:	1000                	addi	s0,sp,32
    80003f10:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003f12:	00028517          	auipc	a0,0x28
    80003f16:	a2650513          	addi	a0,a0,-1498 # 8002b938 <log>
    80003f1a:	d0ffc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003f1e:	00028617          	auipc	a2,0x28
    80003f22:	a4262603          	lw	a2,-1470(a2) # 8002b960 <log+0x28>
    80003f26:	47f5                	li	a5,29
    80003f28:	04c7cd63          	blt	a5,a2,80003f82 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003f2c:	00028797          	auipc	a5,0x28
    80003f30:	a287a783          	lw	a5,-1496(a5) # 8002b954 <log+0x1c>
    80003f34:	04f05d63          	blez	a5,80003f8e <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003f38:	4781                	li	a5,0
    80003f3a:	06c05063          	blez	a2,80003f9a <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f3e:	44cc                	lw	a1,12(s1)
    80003f40:	00028717          	auipc	a4,0x28
    80003f44:	a2470713          	addi	a4,a4,-1500 # 8002b964 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003f48:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f4a:	4314                	lw	a3,0(a4)
    80003f4c:	04b68763          	beq	a3,a1,80003f9a <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003f50:	2785                	addiw	a5,a5,1
    80003f52:	0711                	addi	a4,a4,4
    80003f54:	fef61be3          	bne	a2,a5,80003f4a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003f58:	060a                	slli	a2,a2,0x2
    80003f5a:	02060613          	addi	a2,a2,32
    80003f5e:	00028797          	auipc	a5,0x28
    80003f62:	9da78793          	addi	a5,a5,-1574 # 8002b938 <log>
    80003f66:	97b2                	add	a5,a5,a2
    80003f68:	44d8                	lw	a4,12(s1)
    80003f6a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	ee7fe0ef          	jal	80002e54 <bpin>
    log.lh.n++;
    80003f72:	00028717          	auipc	a4,0x28
    80003f76:	9c670713          	addi	a4,a4,-1594 # 8002b938 <log>
    80003f7a:	571c                	lw	a5,40(a4)
    80003f7c:	2785                	addiw	a5,a5,1
    80003f7e:	d71c                	sw	a5,40(a4)
    80003f80:	a815                	j	80003fb4 <log_write+0xae>
    panic("too big a transaction");
    80003f82:	00003517          	auipc	a0,0x3
    80003f86:	58e50513          	addi	a0,a0,1422 # 80007510 <etext+0x510>
    80003f8a:	89bfc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80003f8e:	00003517          	auipc	a0,0x3
    80003f92:	59a50513          	addi	a0,a0,1434 # 80007528 <etext+0x528>
    80003f96:	88ffc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80003f9a:	00279693          	slli	a3,a5,0x2
    80003f9e:	02068693          	addi	a3,a3,32
    80003fa2:	00028717          	auipc	a4,0x28
    80003fa6:	99670713          	addi	a4,a4,-1642 # 8002b938 <log>
    80003faa:	9736                	add	a4,a4,a3
    80003fac:	44d4                	lw	a3,12(s1)
    80003fae:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003fb0:	faf60ee3          	beq	a2,a5,80003f6c <log_write+0x66>
  }
  release(&log.lock);
    80003fb4:	00028517          	auipc	a0,0x28
    80003fb8:	98450513          	addi	a0,a0,-1660 # 8002b938 <log>
    80003fbc:	d01fc0ef          	jal	80000cbc <release>
}
    80003fc0:	60e2                	ld	ra,24(sp)
    80003fc2:	6442                	ld	s0,16(sp)
    80003fc4:	64a2                	ld	s1,8(sp)
    80003fc6:	6105                	addi	sp,sp,32
    80003fc8:	8082                	ret

0000000080003fca <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003fca:	1101                	addi	sp,sp,-32
    80003fcc:	ec06                	sd	ra,24(sp)
    80003fce:	e822                	sd	s0,16(sp)
    80003fd0:	e426                	sd	s1,8(sp)
    80003fd2:	e04a                	sd	s2,0(sp)
    80003fd4:	1000                	addi	s0,sp,32
    80003fd6:	84aa                	mv	s1,a0
    80003fd8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003fda:	00003597          	auipc	a1,0x3
    80003fde:	56e58593          	addi	a1,a1,1390 # 80007548 <etext+0x548>
    80003fe2:	0521                	addi	a0,a0,8
    80003fe4:	bbbfc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    80003fe8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003fec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ff0:	0204a423          	sw	zero,40(s1)
}
    80003ff4:	60e2                	ld	ra,24(sp)
    80003ff6:	6442                	ld	s0,16(sp)
    80003ff8:	64a2                	ld	s1,8(sp)
    80003ffa:	6902                	ld	s2,0(sp)
    80003ffc:	6105                	addi	sp,sp,32
    80003ffe:	8082                	ret

0000000080004000 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004000:	1101                	addi	sp,sp,-32
    80004002:	ec06                	sd	ra,24(sp)
    80004004:	e822                	sd	s0,16(sp)
    80004006:	e426                	sd	s1,8(sp)
    80004008:	e04a                	sd	s2,0(sp)
    8000400a:	1000                	addi	s0,sp,32
    8000400c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000400e:	00850913          	addi	s2,a0,8
    80004012:	854a                	mv	a0,s2
    80004014:	c15fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004018:	409c                	lw	a5,0(s1)
    8000401a:	c799                	beqz	a5,80004028 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000401c:	85ca                	mv	a1,s2
    8000401e:	8526                	mv	a0,s1
    80004020:	f79fd0ef          	jal	80001f98 <sleep>
  while (lk->locked) {
    80004024:	409c                	lw	a5,0(s1)
    80004026:	fbfd                	bnez	a5,8000401c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004028:	4785                	li	a5,1
    8000402a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000402c:	8fbfd0ef          	jal	80001926 <myproc>
    80004030:	591c                	lw	a5,48(a0)
    80004032:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004034:	854a                	mv	a0,s2
    80004036:	c87fc0ef          	jal	80000cbc <release>
}
    8000403a:	60e2                	ld	ra,24(sp)
    8000403c:	6442                	ld	s0,16(sp)
    8000403e:	64a2                	ld	s1,8(sp)
    80004040:	6902                	ld	s2,0(sp)
    80004042:	6105                	addi	sp,sp,32
    80004044:	8082                	ret

0000000080004046 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004046:	1101                	addi	sp,sp,-32
    80004048:	ec06                	sd	ra,24(sp)
    8000404a:	e822                	sd	s0,16(sp)
    8000404c:	e426                	sd	s1,8(sp)
    8000404e:	e04a                	sd	s2,0(sp)
    80004050:	1000                	addi	s0,sp,32
    80004052:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004054:	00850913          	addi	s2,a0,8
    80004058:	854a                	mv	a0,s2
    8000405a:	bcffc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    8000405e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004062:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004066:	8526                	mv	a0,s1
    80004068:	f7dfd0ef          	jal	80001fe4 <wakeup>
  release(&lk->lk);
    8000406c:	854a                	mv	a0,s2
    8000406e:	c4ffc0ef          	jal	80000cbc <release>
}
    80004072:	60e2                	ld	ra,24(sp)
    80004074:	6442                	ld	s0,16(sp)
    80004076:	64a2                	ld	s1,8(sp)
    80004078:	6902                	ld	s2,0(sp)
    8000407a:	6105                	addi	sp,sp,32
    8000407c:	8082                	ret

000000008000407e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000407e:	7179                	addi	sp,sp,-48
    80004080:	f406                	sd	ra,40(sp)
    80004082:	f022                	sd	s0,32(sp)
    80004084:	ec26                	sd	s1,24(sp)
    80004086:	e84a                	sd	s2,16(sp)
    80004088:	1800                	addi	s0,sp,48
    8000408a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000408c:	00850913          	addi	s2,a0,8
    80004090:	854a                	mv	a0,s2
    80004092:	b97fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004096:	409c                	lw	a5,0(s1)
    80004098:	ef81                	bnez	a5,800040b0 <holdingsleep+0x32>
    8000409a:	4481                	li	s1,0
  release(&lk->lk);
    8000409c:	854a                	mv	a0,s2
    8000409e:	c1ffc0ef          	jal	80000cbc <release>
  return r;
}
    800040a2:	8526                	mv	a0,s1
    800040a4:	70a2                	ld	ra,40(sp)
    800040a6:	7402                	ld	s0,32(sp)
    800040a8:	64e2                	ld	s1,24(sp)
    800040aa:	6942                	ld	s2,16(sp)
    800040ac:	6145                	addi	sp,sp,48
    800040ae:	8082                	ret
    800040b0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040b2:	0284a983          	lw	s3,40(s1)
    800040b6:	871fd0ef          	jal	80001926 <myproc>
    800040ba:	5904                	lw	s1,48(a0)
    800040bc:	413484b3          	sub	s1,s1,s3
    800040c0:	0014b493          	seqz	s1,s1
    800040c4:	69a2                	ld	s3,8(sp)
    800040c6:	bfd9                	j	8000409c <holdingsleep+0x1e>

00000000800040c8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040c8:	1141                	addi	sp,sp,-16
    800040ca:	e406                	sd	ra,8(sp)
    800040cc:	e022                	sd	s0,0(sp)
    800040ce:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040d0:	00003597          	auipc	a1,0x3
    800040d4:	48858593          	addi	a1,a1,1160 # 80007558 <etext+0x558>
    800040d8:	00028517          	auipc	a0,0x28
    800040dc:	9a850513          	addi	a0,a0,-1624 # 8002ba80 <ftable>
    800040e0:	abffc0ef          	jal	80000b9e <initlock>
}
    800040e4:	60a2                	ld	ra,8(sp)
    800040e6:	6402                	ld	s0,0(sp)
    800040e8:	0141                	addi	sp,sp,16
    800040ea:	8082                	ret

00000000800040ec <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800040ec:	1101                	addi	sp,sp,-32
    800040ee:	ec06                	sd	ra,24(sp)
    800040f0:	e822                	sd	s0,16(sp)
    800040f2:	e426                	sd	s1,8(sp)
    800040f4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800040f6:	00028517          	auipc	a0,0x28
    800040fa:	98a50513          	addi	a0,a0,-1654 # 8002ba80 <ftable>
    800040fe:	b2bfc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004102:	00028497          	auipc	s1,0x28
    80004106:	99648493          	addi	s1,s1,-1642 # 8002ba98 <ftable+0x18>
    8000410a:	00029717          	auipc	a4,0x29
    8000410e:	92e70713          	addi	a4,a4,-1746 # 8002ca38 <disk>
    if(f->ref == 0){
    80004112:	40dc                	lw	a5,4(s1)
    80004114:	cf89                	beqz	a5,8000412e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004116:	02848493          	addi	s1,s1,40
    8000411a:	fee49ce3          	bne	s1,a4,80004112 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000411e:	00028517          	auipc	a0,0x28
    80004122:	96250513          	addi	a0,a0,-1694 # 8002ba80 <ftable>
    80004126:	b97fc0ef          	jal	80000cbc <release>
  return 0;
    8000412a:	4481                	li	s1,0
    8000412c:	a809                	j	8000413e <filealloc+0x52>
      f->ref = 1;
    8000412e:	4785                	li	a5,1
    80004130:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004132:	00028517          	auipc	a0,0x28
    80004136:	94e50513          	addi	a0,a0,-1714 # 8002ba80 <ftable>
    8000413a:	b83fc0ef          	jal	80000cbc <release>
}
    8000413e:	8526                	mv	a0,s1
    80004140:	60e2                	ld	ra,24(sp)
    80004142:	6442                	ld	s0,16(sp)
    80004144:	64a2                	ld	s1,8(sp)
    80004146:	6105                	addi	sp,sp,32
    80004148:	8082                	ret

000000008000414a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000414a:	1101                	addi	sp,sp,-32
    8000414c:	ec06                	sd	ra,24(sp)
    8000414e:	e822                	sd	s0,16(sp)
    80004150:	e426                	sd	s1,8(sp)
    80004152:	1000                	addi	s0,sp,32
    80004154:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004156:	00028517          	auipc	a0,0x28
    8000415a:	92a50513          	addi	a0,a0,-1750 # 8002ba80 <ftable>
    8000415e:	acbfc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004162:	40dc                	lw	a5,4(s1)
    80004164:	02f05063          	blez	a5,80004184 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004168:	2785                	addiw	a5,a5,1
    8000416a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000416c:	00028517          	auipc	a0,0x28
    80004170:	91450513          	addi	a0,a0,-1772 # 8002ba80 <ftable>
    80004174:	b49fc0ef          	jal	80000cbc <release>
  return f;
}
    80004178:	8526                	mv	a0,s1
    8000417a:	60e2                	ld	ra,24(sp)
    8000417c:	6442                	ld	s0,16(sp)
    8000417e:	64a2                	ld	s1,8(sp)
    80004180:	6105                	addi	sp,sp,32
    80004182:	8082                	ret
    panic("filedup");
    80004184:	00003517          	auipc	a0,0x3
    80004188:	3dc50513          	addi	a0,a0,988 # 80007560 <etext+0x560>
    8000418c:	e98fc0ef          	jal	80000824 <panic>

0000000080004190 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004190:	7139                	addi	sp,sp,-64
    80004192:	fc06                	sd	ra,56(sp)
    80004194:	f822                	sd	s0,48(sp)
    80004196:	f426                	sd	s1,40(sp)
    80004198:	0080                	addi	s0,sp,64
    8000419a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000419c:	00028517          	auipc	a0,0x28
    800041a0:	8e450513          	addi	a0,a0,-1820 # 8002ba80 <ftable>
    800041a4:	a85fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    800041a8:	40dc                	lw	a5,4(s1)
    800041aa:	04f05a63          	blez	a5,800041fe <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800041ae:	37fd                	addiw	a5,a5,-1
    800041b0:	c0dc                	sw	a5,4(s1)
    800041b2:	06f04063          	bgtz	a5,80004212 <fileclose+0x82>
    800041b6:	f04a                	sd	s2,32(sp)
    800041b8:	ec4e                	sd	s3,24(sp)
    800041ba:	e852                	sd	s4,16(sp)
    800041bc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041be:	0004a903          	lw	s2,0(s1)
    800041c2:	0094c783          	lbu	a5,9(s1)
    800041c6:	89be                	mv	s3,a5
    800041c8:	689c                	ld	a5,16(s1)
    800041ca:	8a3e                	mv	s4,a5
    800041cc:	6c9c                	ld	a5,24(s1)
    800041ce:	8abe                	mv	s5,a5
  f->ref = 0;
    800041d0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041d4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041d8:	00028517          	auipc	a0,0x28
    800041dc:	8a850513          	addi	a0,a0,-1880 # 8002ba80 <ftable>
    800041e0:	addfc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    800041e4:	4785                	li	a5,1
    800041e6:	04f90163          	beq	s2,a5,80004228 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800041ea:	ffe9079b          	addiw	a5,s2,-2
    800041ee:	4705                	li	a4,1
    800041f0:	04f77563          	bgeu	a4,a5,8000423a <fileclose+0xaa>
    800041f4:	7902                	ld	s2,32(sp)
    800041f6:	69e2                	ld	s3,24(sp)
    800041f8:	6a42                	ld	s4,16(sp)
    800041fa:	6aa2                	ld	s5,8(sp)
    800041fc:	a00d                	j	8000421e <fileclose+0x8e>
    800041fe:	f04a                	sd	s2,32(sp)
    80004200:	ec4e                	sd	s3,24(sp)
    80004202:	e852                	sd	s4,16(sp)
    80004204:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004206:	00003517          	auipc	a0,0x3
    8000420a:	36250513          	addi	a0,a0,866 # 80007568 <etext+0x568>
    8000420e:	e16fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004212:	00028517          	auipc	a0,0x28
    80004216:	86e50513          	addi	a0,a0,-1938 # 8002ba80 <ftable>
    8000421a:	aa3fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000421e:	70e2                	ld	ra,56(sp)
    80004220:	7442                	ld	s0,48(sp)
    80004222:	74a2                	ld	s1,40(sp)
    80004224:	6121                	addi	sp,sp,64
    80004226:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004228:	85ce                	mv	a1,s3
    8000422a:	8552                	mv	a0,s4
    8000422c:	348000ef          	jal	80004574 <pipeclose>
    80004230:	7902                	ld	s2,32(sp)
    80004232:	69e2                	ld	s3,24(sp)
    80004234:	6a42                	ld	s4,16(sp)
    80004236:	6aa2                	ld	s5,8(sp)
    80004238:	b7dd                	j	8000421e <fileclose+0x8e>
    begin_op();
    8000423a:	b33ff0ef          	jal	80003d6c <begin_op>
    iput(ff.ip);
    8000423e:	8556                	mv	a0,s5
    80004240:	aa2ff0ef          	jal	800034e2 <iput>
    end_op();
    80004244:	b99ff0ef          	jal	80003ddc <end_op>
    80004248:	7902                	ld	s2,32(sp)
    8000424a:	69e2                	ld	s3,24(sp)
    8000424c:	6a42                	ld	s4,16(sp)
    8000424e:	6aa2                	ld	s5,8(sp)
    80004250:	b7f9                	j	8000421e <fileclose+0x8e>

0000000080004252 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004252:	715d                	addi	sp,sp,-80
    80004254:	e486                	sd	ra,72(sp)
    80004256:	e0a2                	sd	s0,64(sp)
    80004258:	fc26                	sd	s1,56(sp)
    8000425a:	f052                	sd	s4,32(sp)
    8000425c:	0880                	addi	s0,sp,80
    8000425e:	84aa                	mv	s1,a0
    80004260:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004262:	ec4fd0ef          	jal	80001926 <myproc>
  struct stat st;

  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004266:	409c                	lw	a5,0(s1)
    80004268:	37f9                	addiw	a5,a5,-2
    8000426a:	4705                	li	a4,1
    8000426c:	04f76263          	bltu	a4,a5,800042b0 <filestat+0x5e>
    80004270:	f84a                	sd	s2,48(sp)
    80004272:	f44e                	sd	s3,40(sp)
    80004274:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004276:	6c88                	ld	a0,24(s1)
    80004278:	8e8ff0ef          	jal	80003360 <ilock>
    stati(f->ip, &st);
    8000427c:	fb840913          	addi	s2,s0,-72
    80004280:	85ca                	mv	a1,s2
    80004282:	6c88                	ld	a0,24(s1)
    80004284:	c40ff0ef          	jal	800036c4 <stati>
    iunlock(f->ip);
    80004288:	6c88                	ld	a0,24(s1)
    8000428a:	984ff0ef          	jal	8000340e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000428e:	46e1                	li	a3,24
    80004290:	864a                	mv	a2,s2
    80004292:	85d2                	mv	a1,s4
    80004294:	0509b503          	ld	a0,80(s3)
    80004298:	bbcfd0ef          	jal	80001654 <copyout>
    8000429c:	41f5551b          	sraiw	a0,a0,0x1f
    800042a0:	7942                	ld	s2,48(sp)
    800042a2:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800042a4:	60a6                	ld	ra,72(sp)
    800042a6:	6406                	ld	s0,64(sp)
    800042a8:	74e2                	ld	s1,56(sp)
    800042aa:	7a02                	ld	s4,32(sp)
    800042ac:	6161                	addi	sp,sp,80
    800042ae:	8082                	ret
  return -1;
    800042b0:	557d                	li	a0,-1
    800042b2:	bfcd                	j	800042a4 <filestat+0x52>

00000000800042b4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042b4:	7179                	addi	sp,sp,-48
    800042b6:	f406                	sd	ra,40(sp)
    800042b8:	f022                	sd	s0,32(sp)
    800042ba:	e84a                	sd	s2,16(sp)
    800042bc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800042be:	00854783          	lbu	a5,8(a0)
    800042c2:	cfd1                	beqz	a5,8000435e <fileread+0xaa>
    800042c4:	ec26                	sd	s1,24(sp)
    800042c6:	e44e                	sd	s3,8(sp)
    800042c8:	84aa                	mv	s1,a0
    800042ca:	892e                	mv	s2,a1
    800042cc:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800042ce:	411c                	lw	a5,0(a0)
    800042d0:	4705                	li	a4,1
    800042d2:	04e78363          	beq	a5,a4,80004318 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800042d6:	470d                	li	a4,3
    800042d8:	04e78763          	beq	a5,a4,80004326 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800042dc:	4709                	li	a4,2
    800042de:	06e79a63          	bne	a5,a4,80004352 <fileread+0x9e>
    ilock(f->ip);
    800042e2:	6d08                	ld	a0,24(a0)
    800042e4:	87cff0ef          	jal	80003360 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800042e8:	874e                	mv	a4,s3
    800042ea:	5094                	lw	a3,32(s1)
    800042ec:	864a                	mv	a2,s2
    800042ee:	4585                	li	a1,1
    800042f0:	6c88                	ld	a0,24(s1)
    800042f2:	c00ff0ef          	jal	800036f2 <readi>
    800042f6:	892a                	mv	s2,a0
    800042f8:	00a05563          	blez	a0,80004302 <fileread+0x4e>
      f->off += r;
    800042fc:	509c                	lw	a5,32(s1)
    800042fe:	9fa9                	addw	a5,a5,a0
    80004300:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004302:	6c88                	ld	a0,24(s1)
    80004304:	90aff0ef          	jal	8000340e <iunlock>
    80004308:	64e2                	ld	s1,24(sp)
    8000430a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000430c:	854a                	mv	a0,s2
    8000430e:	70a2                	ld	ra,40(sp)
    80004310:	7402                	ld	s0,32(sp)
    80004312:	6942                	ld	s2,16(sp)
    80004314:	6145                	addi	sp,sp,48
    80004316:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004318:	6908                	ld	a0,16(a0)
    8000431a:	3b0000ef          	jal	800046ca <piperead>
    8000431e:	892a                	mv	s2,a0
    80004320:	64e2                	ld	s1,24(sp)
    80004322:	69a2                	ld	s3,8(sp)
    80004324:	b7e5                	j	8000430c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004326:	02451783          	lh	a5,36(a0)
    8000432a:	03079693          	slli	a3,a5,0x30
    8000432e:	92c1                	srli	a3,a3,0x30
    80004330:	4725                	li	a4,9
    80004332:	02d76963          	bltu	a4,a3,80004364 <fileread+0xb0>
    80004336:	0792                	slli	a5,a5,0x4
    80004338:	00027717          	auipc	a4,0x27
    8000433c:	6a870713          	addi	a4,a4,1704 # 8002b9e0 <devsw>
    80004340:	97ba                	add	a5,a5,a4
    80004342:	639c                	ld	a5,0(a5)
    80004344:	c78d                	beqz	a5,8000436e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004346:	4505                	li	a0,1
    80004348:	9782                	jalr	a5
    8000434a:	892a                	mv	s2,a0
    8000434c:	64e2                	ld	s1,24(sp)
    8000434e:	69a2                	ld	s3,8(sp)
    80004350:	bf75                	j	8000430c <fileread+0x58>
    panic("fileread");
    80004352:	00003517          	auipc	a0,0x3
    80004356:	22650513          	addi	a0,a0,550 # 80007578 <etext+0x578>
    8000435a:	ccafc0ef          	jal	80000824 <panic>
    return -1;
    8000435e:	57fd                	li	a5,-1
    80004360:	893e                	mv	s2,a5
    80004362:	b76d                	j	8000430c <fileread+0x58>
      return -1;
    80004364:	57fd                	li	a5,-1
    80004366:	893e                	mv	s2,a5
    80004368:	64e2                	ld	s1,24(sp)
    8000436a:	69a2                	ld	s3,8(sp)
    8000436c:	b745                	j	8000430c <fileread+0x58>
    8000436e:	57fd                	li	a5,-1
    80004370:	893e                	mv	s2,a5
    80004372:	64e2                	ld	s1,24(sp)
    80004374:	69a2                	ld	s3,8(sp)
    80004376:	bf59                	j	8000430c <fileread+0x58>

0000000080004378 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004378:	00954783          	lbu	a5,9(a0)
    8000437c:	10078f63          	beqz	a5,8000449a <filewrite+0x122>
{
    80004380:	711d                	addi	sp,sp,-96
    80004382:	ec86                	sd	ra,88(sp)
    80004384:	e8a2                	sd	s0,80(sp)
    80004386:	e0ca                	sd	s2,64(sp)
    80004388:	f456                	sd	s5,40(sp)
    8000438a:	f05a                	sd	s6,32(sp)
    8000438c:	1080                	addi	s0,sp,96
    8000438e:	892a                	mv	s2,a0
    80004390:	8b2e                	mv	s6,a1
    80004392:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004394:	411c                	lw	a5,0(a0)
    80004396:	4705                	li	a4,1
    80004398:	02e78a63          	beq	a5,a4,800043cc <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000439c:	470d                	li	a4,3
    8000439e:	02e78b63          	beq	a5,a4,800043d4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800043a2:	4709                	li	a4,2
    800043a4:	0ce79f63          	bne	a5,a4,80004482 <filewrite+0x10a>
    800043a8:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800043aa:	0ac05a63          	blez	a2,8000445e <filewrite+0xe6>
    800043ae:	e4a6                	sd	s1,72(sp)
    800043b0:	fc4e                	sd	s3,56(sp)
    800043b2:	ec5e                	sd	s7,24(sp)
    800043b4:	e862                	sd	s8,16(sp)
    800043b6:	e466                	sd	s9,8(sp)
    int i = 0;
    800043b8:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800043ba:	6b85                	lui	s7,0x1
    800043bc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043c0:	6785                	lui	a5,0x1
    800043c2:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800043c6:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043c8:	4c05                	li	s8,1
    800043ca:	a8ad                	j	80004444 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800043cc:	6908                	ld	a0,16(a0)
    800043ce:	204000ef          	jal	800045d2 <pipewrite>
    800043d2:	a04d                	j	80004474 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800043d4:	02451783          	lh	a5,36(a0)
    800043d8:	03079693          	slli	a3,a5,0x30
    800043dc:	92c1                	srli	a3,a3,0x30
    800043de:	4725                	li	a4,9
    800043e0:	0ad76f63          	bltu	a4,a3,8000449e <filewrite+0x126>
    800043e4:	0792                	slli	a5,a5,0x4
    800043e6:	00027717          	auipc	a4,0x27
    800043ea:	5fa70713          	addi	a4,a4,1530 # 8002b9e0 <devsw>
    800043ee:	97ba                	add	a5,a5,a4
    800043f0:	679c                	ld	a5,8(a5)
    800043f2:	cbc5                	beqz	a5,800044a2 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800043f4:	4505                	li	a0,1
    800043f6:	9782                	jalr	a5
    800043f8:	a8b5                	j	80004474 <filewrite+0xfc>
      if(n1 > max)
    800043fa:	2981                	sext.w	s3,s3
      begin_op();
    800043fc:	971ff0ef          	jal	80003d6c <begin_op>
      ilock(f->ip);
    80004400:	01893503          	ld	a0,24(s2)
    80004404:	f5dfe0ef          	jal	80003360 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004408:	874e                	mv	a4,s3
    8000440a:	02092683          	lw	a3,32(s2)
    8000440e:	016a0633          	add	a2,s4,s6
    80004412:	85e2                	mv	a1,s8
    80004414:	01893503          	ld	a0,24(s2)
    80004418:	bccff0ef          	jal	800037e4 <writei>
    8000441c:	84aa                	mv	s1,a0
    8000441e:	00a05763          	blez	a0,8000442c <filewrite+0xb4>
        f->off += r;
    80004422:	02092783          	lw	a5,32(s2)
    80004426:	9fa9                	addw	a5,a5,a0
    80004428:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000442c:	01893503          	ld	a0,24(s2)
    80004430:	fdffe0ef          	jal	8000340e <iunlock>
      end_op();
    80004434:	9a9ff0ef          	jal	80003ddc <end_op>

      if(r != n1){
    80004438:	02999563          	bne	s3,s1,80004462 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000443c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004440:	015a5963          	bge	s4,s5,80004452 <filewrite+0xda>
      int n1 = n - i;
    80004444:	414a87bb          	subw	a5,s5,s4
    80004448:	89be                	mv	s3,a5
      if(n1 > max)
    8000444a:	fafbd8e3          	bge	s7,a5,800043fa <filewrite+0x82>
    8000444e:	89e6                	mv	s3,s9
    80004450:	b76d                	j	800043fa <filewrite+0x82>
    80004452:	64a6                	ld	s1,72(sp)
    80004454:	79e2                	ld	s3,56(sp)
    80004456:	6be2                	ld	s7,24(sp)
    80004458:	6c42                	ld	s8,16(sp)
    8000445a:	6ca2                	ld	s9,8(sp)
    8000445c:	a801                	j	8000446c <filewrite+0xf4>
    int i = 0;
    8000445e:	4a01                	li	s4,0
    80004460:	a031                	j	8000446c <filewrite+0xf4>
    80004462:	64a6                	ld	s1,72(sp)
    80004464:	79e2                	ld	s3,56(sp)
    80004466:	6be2                	ld	s7,24(sp)
    80004468:	6c42                	ld	s8,16(sp)
    8000446a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000446c:	034a9d63          	bne	s5,s4,800044a6 <filewrite+0x12e>
    80004470:	8556                	mv	a0,s5
    80004472:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004474:	60e6                	ld	ra,88(sp)
    80004476:	6446                	ld	s0,80(sp)
    80004478:	6906                	ld	s2,64(sp)
    8000447a:	7aa2                	ld	s5,40(sp)
    8000447c:	7b02                	ld	s6,32(sp)
    8000447e:	6125                	addi	sp,sp,96
    80004480:	8082                	ret
    80004482:	e4a6                	sd	s1,72(sp)
    80004484:	fc4e                	sd	s3,56(sp)
    80004486:	f852                	sd	s4,48(sp)
    80004488:	ec5e                	sd	s7,24(sp)
    8000448a:	e862                	sd	s8,16(sp)
    8000448c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000448e:	00003517          	auipc	a0,0x3
    80004492:	0fa50513          	addi	a0,a0,250 # 80007588 <etext+0x588>
    80004496:	b8efc0ef          	jal	80000824 <panic>
    return -1;
    8000449a:	557d                	li	a0,-1
}
    8000449c:	8082                	ret
      return -1;
    8000449e:	557d                	li	a0,-1
    800044a0:	bfd1                	j	80004474 <filewrite+0xfc>
    800044a2:	557d                	li	a0,-1
    800044a4:	bfc1                	j	80004474 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800044a6:	557d                	li	a0,-1
    800044a8:	7a42                	ld	s4,48(sp)
    800044aa:	b7e9                	j	80004474 <filewrite+0xfc>

00000000800044ac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800044ac:	7179                	addi	sp,sp,-48
    800044ae:	f406                	sd	ra,40(sp)
    800044b0:	f022                	sd	s0,32(sp)
    800044b2:	ec26                	sd	s1,24(sp)
    800044b4:	e052                	sd	s4,0(sp)
    800044b6:	1800                	addi	s0,sp,48
    800044b8:	84aa                	mv	s1,a0
    800044ba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044bc:	0005b023          	sd	zero,0(a1)
    800044c0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044c4:	c29ff0ef          	jal	800040ec <filealloc>
    800044c8:	e088                	sd	a0,0(s1)
    800044ca:	c549                	beqz	a0,80004554 <pipealloc+0xa8>
    800044cc:	c21ff0ef          	jal	800040ec <filealloc>
    800044d0:	00aa3023          	sd	a0,0(s4)
    800044d4:	cd25                	beqz	a0,8000454c <pipealloc+0xa0>
    800044d6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800044d8:	e6cfc0ef          	jal	80000b44 <kalloc>
    800044dc:	892a                	mv	s2,a0
    800044de:	c12d                	beqz	a0,80004540 <pipealloc+0x94>
    800044e0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800044e2:	4985                	li	s3,1
    800044e4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800044e8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800044ec:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800044f0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800044f4:	00003597          	auipc	a1,0x3
    800044f8:	0a458593          	addi	a1,a1,164 # 80007598 <etext+0x598>
    800044fc:	ea2fc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004500:	609c                	ld	a5,0(s1)
    80004502:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004506:	609c                	ld	a5,0(s1)
    80004508:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000450c:	609c                	ld	a5,0(s1)
    8000450e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004512:	609c                	ld	a5,0(s1)
    80004514:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004518:	000a3783          	ld	a5,0(s4)
    8000451c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004520:	000a3783          	ld	a5,0(s4)
    80004524:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004528:	000a3783          	ld	a5,0(s4)
    8000452c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004530:	000a3783          	ld	a5,0(s4)
    80004534:	0127b823          	sd	s2,16(a5)
  return 0;
    80004538:	4501                	li	a0,0
    8000453a:	6942                	ld	s2,16(sp)
    8000453c:	69a2                	ld	s3,8(sp)
    8000453e:	a01d                	j	80004564 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004540:	6088                	ld	a0,0(s1)
    80004542:	c119                	beqz	a0,80004548 <pipealloc+0x9c>
    80004544:	6942                	ld	s2,16(sp)
    80004546:	a029                	j	80004550 <pipealloc+0xa4>
    80004548:	6942                	ld	s2,16(sp)
    8000454a:	a029                	j	80004554 <pipealloc+0xa8>
    8000454c:	6088                	ld	a0,0(s1)
    8000454e:	c10d                	beqz	a0,80004570 <pipealloc+0xc4>
    fileclose(*f0);
    80004550:	c41ff0ef          	jal	80004190 <fileclose>
  if(*f1)
    80004554:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004558:	557d                	li	a0,-1
  if(*f1)
    8000455a:	c789                	beqz	a5,80004564 <pipealloc+0xb8>
    fileclose(*f1);
    8000455c:	853e                	mv	a0,a5
    8000455e:	c33ff0ef          	jal	80004190 <fileclose>
  return -1;
    80004562:	557d                	li	a0,-1
}
    80004564:	70a2                	ld	ra,40(sp)
    80004566:	7402                	ld	s0,32(sp)
    80004568:	64e2                	ld	s1,24(sp)
    8000456a:	6a02                	ld	s4,0(sp)
    8000456c:	6145                	addi	sp,sp,48
    8000456e:	8082                	ret
  return -1;
    80004570:	557d                	li	a0,-1
    80004572:	bfcd                	j	80004564 <pipealloc+0xb8>

0000000080004574 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004574:	1101                	addi	sp,sp,-32
    80004576:	ec06                	sd	ra,24(sp)
    80004578:	e822                	sd	s0,16(sp)
    8000457a:	e426                	sd	s1,8(sp)
    8000457c:	e04a                	sd	s2,0(sp)
    8000457e:	1000                	addi	s0,sp,32
    80004580:	84aa                	mv	s1,a0
    80004582:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004584:	ea4fc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004588:	02090763          	beqz	s2,800045b6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000458c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004590:	21848513          	addi	a0,s1,536
    80004594:	a51fd0ef          	jal	80001fe4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004598:	2204a783          	lw	a5,544(s1)
    8000459c:	e781                	bnez	a5,800045a4 <pipeclose+0x30>
    8000459e:	2244a783          	lw	a5,548(s1)
    800045a2:	c38d                	beqz	a5,800045c4 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800045a4:	8526                	mv	a0,s1
    800045a6:	f16fc0ef          	jal	80000cbc <release>
}
    800045aa:	60e2                	ld	ra,24(sp)
    800045ac:	6442                	ld	s0,16(sp)
    800045ae:	64a2                	ld	s1,8(sp)
    800045b0:	6902                	ld	s2,0(sp)
    800045b2:	6105                	addi	sp,sp,32
    800045b4:	8082                	ret
    pi->readopen = 0;
    800045b6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045ba:	21c48513          	addi	a0,s1,540
    800045be:	a27fd0ef          	jal	80001fe4 <wakeup>
    800045c2:	bfd9                	j	80004598 <pipeclose+0x24>
    release(&pi->lock);
    800045c4:	8526                	mv	a0,s1
    800045c6:	ef6fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    800045ca:	8526                	mv	a0,s1
    800045cc:	c90fc0ef          	jal	80000a5c <kfree>
    800045d0:	bfe9                	j	800045aa <pipeclose+0x36>

00000000800045d2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800045d2:	7159                	addi	sp,sp,-112
    800045d4:	f486                	sd	ra,104(sp)
    800045d6:	f0a2                	sd	s0,96(sp)
    800045d8:	eca6                	sd	s1,88(sp)
    800045da:	e8ca                	sd	s2,80(sp)
    800045dc:	e4ce                	sd	s3,72(sp)
    800045de:	e0d2                	sd	s4,64(sp)
    800045e0:	fc56                	sd	s5,56(sp)
    800045e2:	1880                	addi	s0,sp,112
    800045e4:	84aa                	mv	s1,a0
    800045e6:	8aae                	mv	s5,a1
    800045e8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800045ea:	b3cfd0ef          	jal	80001926 <myproc>
    800045ee:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800045f0:	8526                	mv	a0,s1
    800045f2:	e36fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    800045f6:	0d405263          	blez	s4,800046ba <pipewrite+0xe8>
    800045fa:	f85a                	sd	s6,48(sp)
    800045fc:	f45e                	sd	s7,40(sp)
    800045fe:	f062                	sd	s8,32(sp)
    80004600:	ec66                	sd	s9,24(sp)
    80004602:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004604:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004606:	f9f40c13          	addi	s8,s0,-97
    8000460a:	4b85                	li	s7,1
    8000460c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000460e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004612:	21c48c93          	addi	s9,s1,540
    80004616:	a82d                	j	80004650 <pipewrite+0x7e>
      release(&pi->lock);
    80004618:	8526                	mv	a0,s1
    8000461a:	ea2fc0ef          	jal	80000cbc <release>
      return -1;
    8000461e:	597d                	li	s2,-1
    80004620:	7b42                	ld	s6,48(sp)
    80004622:	7ba2                	ld	s7,40(sp)
    80004624:	7c02                	ld	s8,32(sp)
    80004626:	6ce2                	ld	s9,24(sp)
    80004628:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000462a:	854a                	mv	a0,s2
    8000462c:	70a6                	ld	ra,104(sp)
    8000462e:	7406                	ld	s0,96(sp)
    80004630:	64e6                	ld	s1,88(sp)
    80004632:	6946                	ld	s2,80(sp)
    80004634:	69a6                	ld	s3,72(sp)
    80004636:	6a06                	ld	s4,64(sp)
    80004638:	7ae2                	ld	s5,56(sp)
    8000463a:	6165                	addi	sp,sp,112
    8000463c:	8082                	ret
      wakeup(&pi->nread);
    8000463e:	856a                	mv	a0,s10
    80004640:	9a5fd0ef          	jal	80001fe4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004644:	85a6                	mv	a1,s1
    80004646:	8566                	mv	a0,s9
    80004648:	951fd0ef          	jal	80001f98 <sleep>
  while(i < n){
    8000464c:	05495a63          	bge	s2,s4,800046a0 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004650:	2204a783          	lw	a5,544(s1)
    80004654:	d3f1                	beqz	a5,80004618 <pipewrite+0x46>
    80004656:	854e                	mv	a0,s3
    80004658:	c37fd0ef          	jal	8000228e <killed>
    8000465c:	fd55                	bnez	a0,80004618 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000465e:	2184a783          	lw	a5,536(s1)
    80004662:	21c4a703          	lw	a4,540(s1)
    80004666:	2007879b          	addiw	a5,a5,512
    8000466a:	fcf70ae3          	beq	a4,a5,8000463e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000466e:	86de                	mv	a3,s7
    80004670:	01590633          	add	a2,s2,s5
    80004674:	85e2                	mv	a1,s8
    80004676:	0509b503          	ld	a0,80(s3)
    8000467a:	898fd0ef          	jal	80001712 <copyin>
    8000467e:	05650063          	beq	a0,s6,800046be <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004682:	21c4a783          	lw	a5,540(s1)
    80004686:	0017871b          	addiw	a4,a5,1
    8000468a:	20e4ae23          	sw	a4,540(s1)
    8000468e:	1ff7f793          	andi	a5,a5,511
    80004692:	97a6                	add	a5,a5,s1
    80004694:	f9f44703          	lbu	a4,-97(s0)
    80004698:	00e78c23          	sb	a4,24(a5)
      i++;
    8000469c:	2905                	addiw	s2,s2,1
    8000469e:	b77d                	j	8000464c <pipewrite+0x7a>
    800046a0:	7b42                	ld	s6,48(sp)
    800046a2:	7ba2                	ld	s7,40(sp)
    800046a4:	7c02                	ld	s8,32(sp)
    800046a6:	6ce2                	ld	s9,24(sp)
    800046a8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800046aa:	21848513          	addi	a0,s1,536
    800046ae:	937fd0ef          	jal	80001fe4 <wakeup>
  release(&pi->lock);
    800046b2:	8526                	mv	a0,s1
    800046b4:	e08fc0ef          	jal	80000cbc <release>
  return i;
    800046b8:	bf8d                	j	8000462a <pipewrite+0x58>
  int i = 0;
    800046ba:	4901                	li	s2,0
    800046bc:	b7fd                	j	800046aa <pipewrite+0xd8>
    800046be:	7b42                	ld	s6,48(sp)
    800046c0:	7ba2                	ld	s7,40(sp)
    800046c2:	7c02                	ld	s8,32(sp)
    800046c4:	6ce2                	ld	s9,24(sp)
    800046c6:	6d42                	ld	s10,16(sp)
    800046c8:	b7cd                	j	800046aa <pipewrite+0xd8>

00000000800046ca <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800046ca:	711d                	addi	sp,sp,-96
    800046cc:	ec86                	sd	ra,88(sp)
    800046ce:	e8a2                	sd	s0,80(sp)
    800046d0:	e4a6                	sd	s1,72(sp)
    800046d2:	e0ca                	sd	s2,64(sp)
    800046d4:	fc4e                	sd	s3,56(sp)
    800046d6:	f852                	sd	s4,48(sp)
    800046d8:	f456                	sd	s5,40(sp)
    800046da:	1080                	addi	s0,sp,96
    800046dc:	84aa                	mv	s1,a0
    800046de:	892e                	mv	s2,a1
    800046e0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800046e2:	a44fd0ef          	jal	80001926 <myproc>
    800046e6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800046e8:	8526                	mv	a0,s1
    800046ea:	d3efc0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046ee:	2184a703          	lw	a4,536(s1)
    800046f2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046f6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046fa:	02f71763          	bne	a4,a5,80004728 <piperead+0x5e>
    800046fe:	2244a783          	lw	a5,548(s1)
    80004702:	cf85                	beqz	a5,8000473a <piperead+0x70>
    if(killed(pr)){
    80004704:	8552                	mv	a0,s4
    80004706:	b89fd0ef          	jal	8000228e <killed>
    8000470a:	e11d                	bnez	a0,80004730 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000470c:	85a6                	mv	a1,s1
    8000470e:	854e                	mv	a0,s3
    80004710:	889fd0ef          	jal	80001f98 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004714:	2184a703          	lw	a4,536(s1)
    80004718:	21c4a783          	lw	a5,540(s1)
    8000471c:	fef701e3          	beq	a4,a5,800046fe <piperead+0x34>
    80004720:	f05a                	sd	s6,32(sp)
    80004722:	ec5e                	sd	s7,24(sp)
    80004724:	e862                	sd	s8,16(sp)
    80004726:	a829                	j	80004740 <piperead+0x76>
    80004728:	f05a                	sd	s6,32(sp)
    8000472a:	ec5e                	sd	s7,24(sp)
    8000472c:	e862                	sd	s8,16(sp)
    8000472e:	a809                	j	80004740 <piperead+0x76>
      release(&pi->lock);
    80004730:	8526                	mv	a0,s1
    80004732:	d8afc0ef          	jal	80000cbc <release>
      return -1;
    80004736:	59fd                	li	s3,-1
    80004738:	a0a5                	j	800047a0 <piperead+0xd6>
    8000473a:	f05a                	sd	s6,32(sp)
    8000473c:	ec5e                	sd	s7,24(sp)
    8000473e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004740:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004742:	faf40c13          	addi	s8,s0,-81
    80004746:	4b85                	li	s7,1
    80004748:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000474a:	05505163          	blez	s5,8000478c <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000474e:	2184a783          	lw	a5,536(s1)
    80004752:	21c4a703          	lw	a4,540(s1)
    80004756:	02f70b63          	beq	a4,a5,8000478c <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    8000475a:	1ff7f793          	andi	a5,a5,511
    8000475e:	97a6                	add	a5,a5,s1
    80004760:	0187c783          	lbu	a5,24(a5)
    80004764:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004768:	86de                	mv	a3,s7
    8000476a:	8662                	mv	a2,s8
    8000476c:	85ca                	mv	a1,s2
    8000476e:	050a3503          	ld	a0,80(s4)
    80004772:	ee3fc0ef          	jal	80001654 <copyout>
    80004776:	03650f63          	beq	a0,s6,800047b4 <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000477a:	2184a783          	lw	a5,536(s1)
    8000477e:	2785                	addiw	a5,a5,1
    80004780:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004784:	2985                	addiw	s3,s3,1
    80004786:	0905                	addi	s2,s2,1
    80004788:	fd3a93e3          	bne	s5,s3,8000474e <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000478c:	21c48513          	addi	a0,s1,540
    80004790:	855fd0ef          	jal	80001fe4 <wakeup>
  release(&pi->lock);
    80004794:	8526                	mv	a0,s1
    80004796:	d26fc0ef          	jal	80000cbc <release>
    8000479a:	7b02                	ld	s6,32(sp)
    8000479c:	6be2                	ld	s7,24(sp)
    8000479e:	6c42                	ld	s8,16(sp)
  return i;
}
    800047a0:	854e                	mv	a0,s3
    800047a2:	60e6                	ld	ra,88(sp)
    800047a4:	6446                	ld	s0,80(sp)
    800047a6:	64a6                	ld	s1,72(sp)
    800047a8:	6906                	ld	s2,64(sp)
    800047aa:	79e2                	ld	s3,56(sp)
    800047ac:	7a42                	ld	s4,48(sp)
    800047ae:	7aa2                	ld	s5,40(sp)
    800047b0:	6125                	addi	sp,sp,96
    800047b2:	8082                	ret
      if(i == 0)
    800047b4:	fc099ce3          	bnez	s3,8000478c <piperead+0xc2>
        i = -1;
    800047b8:	89aa                	mv	s3,a0
    800047ba:	bfc9                	j	8000478c <piperead+0xc2>

00000000800047bc <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800047bc:	1141                	addi	sp,sp,-16
    800047be:	e406                	sd	ra,8(sp)
    800047c0:	e022                	sd	s0,0(sp)
    800047c2:	0800                	addi	s0,sp,16
    800047c4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800047c6:	0035151b          	slliw	a0,a0,0x3
    800047ca:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800047cc:	8b89                	andi	a5,a5,2
    800047ce:	c399                	beqz	a5,800047d4 <flags2perm+0x18>
      perm |= PTE_W;
    800047d0:	00456513          	ori	a0,a0,4
    return perm;
}
    800047d4:	60a2                	ld	ra,8(sp)
    800047d6:	6402                	ld	s0,0(sp)
    800047d8:	0141                	addi	sp,sp,16
    800047da:	8082                	ret

00000000800047dc <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800047dc:	de010113          	addi	sp,sp,-544
    800047e0:	20113c23          	sd	ra,536(sp)
    800047e4:	20813823          	sd	s0,528(sp)
    800047e8:	20913423          	sd	s1,520(sp)
    800047ec:	21213023          	sd	s2,512(sp)
    800047f0:	1400                	addi	s0,sp,544
    800047f2:	892a                	mv	s2,a0
    800047f4:	dea43823          	sd	a0,-528(s0)
    800047f8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047fc:	92afd0ef          	jal	80001926 <myproc>
    80004800:	84aa                	mv	s1,a0

  begin_op();
    80004802:	d6aff0ef          	jal	80003d6c <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004806:	854a                	mv	a0,s2
    80004808:	b86ff0ef          	jal	80003b8e <namei>
    8000480c:	cd21                	beqz	a0,80004864 <kexec+0x88>
    8000480e:	fbd2                	sd	s4,496(sp)
    80004810:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004812:	b4ffe0ef          	jal	80003360 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004816:	04000713          	li	a4,64
    8000481a:	4681                	li	a3,0
    8000481c:	e5040613          	addi	a2,s0,-432
    80004820:	4581                	li	a1,0
    80004822:	8552                	mv	a0,s4
    80004824:	ecffe0ef          	jal	800036f2 <readi>
    80004828:	04000793          	li	a5,64
    8000482c:	00f51a63          	bne	a0,a5,80004840 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004830:	e5042703          	lw	a4,-432(s0)
    80004834:	464c47b7          	lui	a5,0x464c4
    80004838:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000483c:	02f70863          	beq	a4,a5,8000486c <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004840:	8552                	mv	a0,s4
    80004842:	d2bfe0ef          	jal	8000356c <iunlockput>
    end_op();
    80004846:	d96ff0ef          	jal	80003ddc <end_op>
  }
  return -1;
    8000484a:	557d                	li	a0,-1
    8000484c:	7a5e                	ld	s4,496(sp)
}
    8000484e:	21813083          	ld	ra,536(sp)
    80004852:	21013403          	ld	s0,528(sp)
    80004856:	20813483          	ld	s1,520(sp)
    8000485a:	20013903          	ld	s2,512(sp)
    8000485e:	22010113          	addi	sp,sp,544
    80004862:	8082                	ret
    end_op();
    80004864:	d78ff0ef          	jal	80003ddc <end_op>
    return -1;
    80004868:	557d                	li	a0,-1
    8000486a:	b7d5                	j	8000484e <kexec+0x72>
    8000486c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000486e:	8526                	mv	a0,s1
    80004870:	9c0fd0ef          	jal	80001a30 <proc_pagetable>
    80004874:	8b2a                	mv	s6,a0
    80004876:	26050f63          	beqz	a0,80004af4 <kexec+0x318>
    8000487a:	ffce                	sd	s3,504(sp)
    8000487c:	f7d6                	sd	s5,488(sp)
    8000487e:	efde                	sd	s7,472(sp)
    80004880:	ebe2                	sd	s8,464(sp)
    80004882:	e7e6                	sd	s9,456(sp)
    80004884:	e3ea                	sd	s10,448(sp)
    80004886:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004888:	e8845783          	lhu	a5,-376(s0)
    8000488c:	0e078963          	beqz	a5,8000497e <kexec+0x1a2>
    80004890:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004894:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004896:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004898:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000489c:	6c85                	lui	s9,0x1
    8000489e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800048a2:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800048a6:	6a85                	lui	s5,0x1
    800048a8:	a085                	j	80004908 <kexec+0x12c>
      panic("loadseg: address should exist");
    800048aa:	00003517          	auipc	a0,0x3
    800048ae:	cf650513          	addi	a0,a0,-778 # 800075a0 <etext+0x5a0>
    800048b2:	f73fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    800048b6:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800048b8:	874a                	mv	a4,s2
    800048ba:	009b86bb          	addw	a3,s7,s1
    800048be:	4581                	li	a1,0
    800048c0:	8552                	mv	a0,s4
    800048c2:	e31fe0ef          	jal	800036f2 <readi>
    800048c6:	22a91b63          	bne	s2,a0,80004afc <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    800048ca:	009a84bb          	addw	s1,s5,s1
    800048ce:	0334f263          	bgeu	s1,s3,800048f2 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800048d2:	02049593          	slli	a1,s1,0x20
    800048d6:	9181                	srli	a1,a1,0x20
    800048d8:	95e2                	add	a1,a1,s8
    800048da:	855a                	mv	a0,s6
    800048dc:	f4afc0ef          	jal	80001026 <walkaddr>
    800048e0:	862a                	mv	a2,a0
    if(pa == 0)
    800048e2:	d561                	beqz	a0,800048aa <kexec+0xce>
    if(sz - i < PGSIZE)
    800048e4:	409987bb          	subw	a5,s3,s1
    800048e8:	893e                	mv	s2,a5
    800048ea:	fcfcf6e3          	bgeu	s9,a5,800048b6 <kexec+0xda>
    800048ee:	8956                	mv	s2,s5
    800048f0:	b7d9                	j	800048b6 <kexec+0xda>
    sz = sz1;
    800048f2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048f6:	2d05                	addiw	s10,s10,1
    800048f8:	e0843783          	ld	a5,-504(s0)
    800048fc:	0387869b          	addiw	a3,a5,56
    80004900:	e8845783          	lhu	a5,-376(s0)
    80004904:	06fd5e63          	bge	s10,a5,80004980 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004908:	e0d43423          	sd	a3,-504(s0)
    8000490c:	876e                	mv	a4,s11
    8000490e:	e1840613          	addi	a2,s0,-488
    80004912:	4581                	li	a1,0
    80004914:	8552                	mv	a0,s4
    80004916:	dddfe0ef          	jal	800036f2 <readi>
    8000491a:	1db51f63          	bne	a0,s11,80004af8 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    8000491e:	e1842783          	lw	a5,-488(s0)
    80004922:	4705                	li	a4,1
    80004924:	fce799e3          	bne	a5,a4,800048f6 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80004928:	e4043483          	ld	s1,-448(s0)
    8000492c:	e3843783          	ld	a5,-456(s0)
    80004930:	1ef4e463          	bltu	s1,a5,80004b18 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004934:	e2843783          	ld	a5,-472(s0)
    80004938:	94be                	add	s1,s1,a5
    8000493a:	1ef4e263          	bltu	s1,a5,80004b1e <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    8000493e:	de843703          	ld	a4,-536(s0)
    80004942:	8ff9                	and	a5,a5,a4
    80004944:	1e079063          	bnez	a5,80004b24 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004948:	e1c42503          	lw	a0,-484(s0)
    8000494c:	e71ff0ef          	jal	800047bc <flags2perm>
    80004950:	86aa                	mv	a3,a0
    80004952:	8626                	mv	a2,s1
    80004954:	85ca                	mv	a1,s2
    80004956:	855a                	mv	a0,s6
    80004958:	9a5fc0ef          	jal	800012fc <uvmalloc>
    8000495c:	dea43c23          	sd	a0,-520(s0)
    80004960:	1c050563          	beqz	a0,80004b2a <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004964:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004968:	00098863          	beqz	s3,80004978 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000496c:	e2843c03          	ld	s8,-472(s0)
    80004970:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004974:	4481                	li	s1,0
    80004976:	bfb1                	j	800048d2 <kexec+0xf6>
    sz = sz1;
    80004978:	df843903          	ld	s2,-520(s0)
    8000497c:	bfad                	j	800048f6 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000497e:	4901                	li	s2,0
  iunlockput(ip);
    80004980:	8552                	mv	a0,s4
    80004982:	bebfe0ef          	jal	8000356c <iunlockput>
  end_op();
    80004986:	c56ff0ef          	jal	80003ddc <end_op>
  p = myproc();
    8000498a:	f9dfc0ef          	jal	80001926 <myproc>
    8000498e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004990:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004994:	6985                	lui	s3,0x1
    80004996:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004998:	99ca                	add	s3,s3,s2
    8000499a:	77fd                	lui	a5,0xfffff
    8000499c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800049a0:	4691                	li	a3,4
    800049a2:	6609                	lui	a2,0x2
    800049a4:	964e                	add	a2,a2,s3
    800049a6:	85ce                	mv	a1,s3
    800049a8:	855a                	mv	a0,s6
    800049aa:	953fc0ef          	jal	800012fc <uvmalloc>
    800049ae:	8a2a                	mv	s4,a0
    800049b0:	e105                	bnez	a0,800049d0 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800049b2:	85ce                	mv	a1,s3
    800049b4:	855a                	mv	a0,s6
    800049b6:	8fefd0ef          	jal	80001ab4 <proc_freepagetable>
  return -1;
    800049ba:	557d                	li	a0,-1
    800049bc:	79fe                	ld	s3,504(sp)
    800049be:	7a5e                	ld	s4,496(sp)
    800049c0:	7abe                	ld	s5,488(sp)
    800049c2:	7b1e                	ld	s6,480(sp)
    800049c4:	6bfe                	ld	s7,472(sp)
    800049c6:	6c5e                	ld	s8,464(sp)
    800049c8:	6cbe                	ld	s9,456(sp)
    800049ca:	6d1e                	ld	s10,448(sp)
    800049cc:	7dfa                	ld	s11,440(sp)
    800049ce:	b541                	j	8000484e <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800049d0:	75f9                	lui	a1,0xffffe
    800049d2:	95aa                	add	a1,a1,a0
    800049d4:	855a                	mv	a0,s6
    800049d6:	af9fc0ef          	jal	800014ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800049da:	800a0b93          	addi	s7,s4,-2048
    800049de:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800049e2:	e0043783          	ld	a5,-512(s0)
    800049e6:	6388                	ld	a0,0(a5)
  sp = sz;
    800049e8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800049ea:	4481                	li	s1,0
    ustack[argc] = sp;
    800049ec:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800049f0:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800049f4:	cd21                	beqz	a0,80004a4c <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    800049f6:	c8cfc0ef          	jal	80000e82 <strlen>
    800049fa:	0015079b          	addiw	a5,a0,1
    800049fe:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a02:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004a06:	13796563          	bltu	s2,s7,80004b30 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a0a:	e0043d83          	ld	s11,-512(s0)
    80004a0e:	000db983          	ld	s3,0(s11)
    80004a12:	854e                	mv	a0,s3
    80004a14:	c6efc0ef          	jal	80000e82 <strlen>
    80004a18:	0015069b          	addiw	a3,a0,1
    80004a1c:	864e                	mv	a2,s3
    80004a1e:	85ca                	mv	a1,s2
    80004a20:	855a                	mv	a0,s6
    80004a22:	c33fc0ef          	jal	80001654 <copyout>
    80004a26:	10054763          	bltz	a0,80004b34 <kexec+0x358>
    ustack[argc] = sp;
    80004a2a:	00349793          	slli	a5,s1,0x3
    80004a2e:	97e6                	add	a5,a5,s9
    80004a30:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd2488>
  for(argc = 0; argv[argc]; argc++) {
    80004a34:	0485                	addi	s1,s1,1
    80004a36:	008d8793          	addi	a5,s11,8
    80004a3a:	e0f43023          	sd	a5,-512(s0)
    80004a3e:	008db503          	ld	a0,8(s11)
    80004a42:	c509                	beqz	a0,80004a4c <kexec+0x270>
    if(argc >= MAXARG)
    80004a44:	fb8499e3          	bne	s1,s8,800049f6 <kexec+0x21a>
  sz = sz1;
    80004a48:	89d2                	mv	s3,s4
    80004a4a:	b7a5                	j	800049b2 <kexec+0x1d6>
  ustack[argc] = 0;
    80004a4c:	00349793          	slli	a5,s1,0x3
    80004a50:	f9078793          	addi	a5,a5,-112
    80004a54:	97a2                	add	a5,a5,s0
    80004a56:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004a5a:	00349693          	slli	a3,s1,0x3
    80004a5e:	06a1                	addi	a3,a3,8
    80004a60:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a64:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004a68:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004a6a:	f57964e3          	bltu	s2,s7,800049b2 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004a6e:	e9040613          	addi	a2,s0,-368
    80004a72:	85ca                	mv	a1,s2
    80004a74:	855a                	mv	a0,s6
    80004a76:	bdffc0ef          	jal	80001654 <copyout>
    80004a7a:	f2054ce3          	bltz	a0,800049b2 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004a7e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004a82:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004a86:	df043783          	ld	a5,-528(s0)
    80004a8a:	0007c703          	lbu	a4,0(a5)
    80004a8e:	cf11                	beqz	a4,80004aaa <kexec+0x2ce>
    80004a90:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004a92:	02f00693          	li	a3,47
    80004a96:	a029                	j	80004aa0 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004a98:	0785                	addi	a5,a5,1
    80004a9a:	fff7c703          	lbu	a4,-1(a5)
    80004a9e:	c711                	beqz	a4,80004aaa <kexec+0x2ce>
    if(*s == '/')
    80004aa0:	fed71ce3          	bne	a4,a3,80004a98 <kexec+0x2bc>
      last = s+1;
    80004aa4:	def43823          	sd	a5,-528(s0)
    80004aa8:	bfc5                	j	80004a98 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004aaa:	4641                	li	a2,16
    80004aac:	df043583          	ld	a1,-528(s0)
    80004ab0:	158a8513          	addi	a0,s5,344
    80004ab4:	b98fc0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80004ab8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004abc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004ac0:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004ac4:	058ab783          	ld	a5,88(s5)
    80004ac8:	e6843703          	ld	a4,-408(s0)
    80004acc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004ace:	058ab783          	ld	a5,88(s5)
    80004ad2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ad6:	85ea                	mv	a1,s10
    80004ad8:	fddfc0ef          	jal	80001ab4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004adc:	0004851b          	sext.w	a0,s1
    80004ae0:	79fe                	ld	s3,504(sp)
    80004ae2:	7a5e                	ld	s4,496(sp)
    80004ae4:	7abe                	ld	s5,488(sp)
    80004ae6:	7b1e                	ld	s6,480(sp)
    80004ae8:	6bfe                	ld	s7,472(sp)
    80004aea:	6c5e                	ld	s8,464(sp)
    80004aec:	6cbe                	ld	s9,456(sp)
    80004aee:	6d1e                	ld	s10,448(sp)
    80004af0:	7dfa                	ld	s11,440(sp)
    80004af2:	bbb1                	j	8000484e <kexec+0x72>
    80004af4:	7b1e                	ld	s6,480(sp)
    80004af6:	b3a9                	j	80004840 <kexec+0x64>
    80004af8:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004afc:	df843583          	ld	a1,-520(s0)
    80004b00:	855a                	mv	a0,s6
    80004b02:	fb3fc0ef          	jal	80001ab4 <proc_freepagetable>
  if(ip){
    80004b06:	79fe                	ld	s3,504(sp)
    80004b08:	7abe                	ld	s5,488(sp)
    80004b0a:	7b1e                	ld	s6,480(sp)
    80004b0c:	6bfe                	ld	s7,472(sp)
    80004b0e:	6c5e                	ld	s8,464(sp)
    80004b10:	6cbe                	ld	s9,456(sp)
    80004b12:	6d1e                	ld	s10,448(sp)
    80004b14:	7dfa                	ld	s11,440(sp)
    80004b16:	b32d                	j	80004840 <kexec+0x64>
    80004b18:	df243c23          	sd	s2,-520(s0)
    80004b1c:	b7c5                	j	80004afc <kexec+0x320>
    80004b1e:	df243c23          	sd	s2,-520(s0)
    80004b22:	bfe9                	j	80004afc <kexec+0x320>
    80004b24:	df243c23          	sd	s2,-520(s0)
    80004b28:	bfd1                	j	80004afc <kexec+0x320>
    80004b2a:	df243c23          	sd	s2,-520(s0)
    80004b2e:	b7f9                	j	80004afc <kexec+0x320>
  sz = sz1;
    80004b30:	89d2                	mv	s3,s4
    80004b32:	b541                	j	800049b2 <kexec+0x1d6>
    80004b34:	89d2                	mv	s3,s4
    80004b36:	bdb5                	j	800049b2 <kexec+0x1d6>

0000000080004b38 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b38:	7179                	addi	sp,sp,-48
    80004b3a:	f406                	sd	ra,40(sp)
    80004b3c:	f022                	sd	s0,32(sp)
    80004b3e:	ec26                	sd	s1,24(sp)
    80004b40:	e84a                	sd	s2,16(sp)
    80004b42:	1800                	addi	s0,sp,48
    80004b44:	892e                	mv	s2,a1
    80004b46:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b48:	fdc40593          	addi	a1,s0,-36
    80004b4c:	e4bfd0ef          	jal	80002996 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004b50:	fdc42703          	lw	a4,-36(s0)
    80004b54:	47bd                	li	a5,15
    80004b56:	02e7ea63          	bltu	a5,a4,80004b8a <argfd+0x52>
    80004b5a:	dcdfc0ef          	jal	80001926 <myproc>
    80004b5e:	fdc42703          	lw	a4,-36(s0)
    80004b62:	00371793          	slli	a5,a4,0x3
    80004b66:	0d078793          	addi	a5,a5,208
    80004b6a:	953e                	add	a0,a0,a5
    80004b6c:	611c                	ld	a5,0(a0)
    80004b6e:	c385                	beqz	a5,80004b8e <argfd+0x56>
    return -1;
  if(pfd)
    80004b70:	00090463          	beqz	s2,80004b78 <argfd+0x40>
    *pfd = fd;
    80004b74:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004b78:	4501                	li	a0,0
  if(pf)
    80004b7a:	c091                	beqz	s1,80004b7e <argfd+0x46>
    *pf = f;
    80004b7c:	e09c                	sd	a5,0(s1)
}
    80004b7e:	70a2                	ld	ra,40(sp)
    80004b80:	7402                	ld	s0,32(sp)
    80004b82:	64e2                	ld	s1,24(sp)
    80004b84:	6942                	ld	s2,16(sp)
    80004b86:	6145                	addi	sp,sp,48
    80004b88:	8082                	ret
    return -1;
    80004b8a:	557d                	li	a0,-1
    80004b8c:	bfcd                	j	80004b7e <argfd+0x46>
    80004b8e:	557d                	li	a0,-1
    80004b90:	b7fd                	j	80004b7e <argfd+0x46>

0000000080004b92 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b92:	1101                	addi	sp,sp,-32
    80004b94:	ec06                	sd	ra,24(sp)
    80004b96:	e822                	sd	s0,16(sp)
    80004b98:	e426                	sd	s1,8(sp)
    80004b9a:	1000                	addi	s0,sp,32
    80004b9c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b9e:	d89fc0ef          	jal	80001926 <myproc>
    80004ba2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ba4:	0d050793          	addi	a5,a0,208
    80004ba8:	4501                	li	a0,0
    80004baa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004bac:	6398                	ld	a4,0(a5)
    80004bae:	cb19                	beqz	a4,80004bc4 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004bb0:	2505                	addiw	a0,a0,1
    80004bb2:	07a1                	addi	a5,a5,8
    80004bb4:	fed51ce3          	bne	a0,a3,80004bac <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004bb8:	557d                	li	a0,-1
}
    80004bba:	60e2                	ld	ra,24(sp)
    80004bbc:	6442                	ld	s0,16(sp)
    80004bbe:	64a2                	ld	s1,8(sp)
    80004bc0:	6105                	addi	sp,sp,32
    80004bc2:	8082                	ret
      p->ofile[fd] = f;
    80004bc4:	00351793          	slli	a5,a0,0x3
    80004bc8:	0d078793          	addi	a5,a5,208
    80004bcc:	963e                	add	a2,a2,a5
    80004bce:	e204                	sd	s1,0(a2)
      return fd;
    80004bd0:	b7ed                	j	80004bba <fdalloc+0x28>

0000000080004bd2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004bd2:	715d                	addi	sp,sp,-80
    80004bd4:	e486                	sd	ra,72(sp)
    80004bd6:	e0a2                	sd	s0,64(sp)
    80004bd8:	fc26                	sd	s1,56(sp)
    80004bda:	f84a                	sd	s2,48(sp)
    80004bdc:	f44e                	sd	s3,40(sp)
    80004bde:	f052                	sd	s4,32(sp)
    80004be0:	ec56                	sd	s5,24(sp)
    80004be2:	e85a                	sd	s6,16(sp)
    80004be4:	0880                	addi	s0,sp,80
    80004be6:	892e                	mv	s2,a1
    80004be8:	8a2e                	mv	s4,a1
    80004bea:	8ab2                	mv	s5,a2
    80004bec:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004bee:	fb040593          	addi	a1,s0,-80
    80004bf2:	fb7fe0ef          	jal	80003ba8 <nameiparent>
    80004bf6:	84aa                	mv	s1,a0
    80004bf8:	10050763          	beqz	a0,80004d06 <create+0x134>
    return 0;

  ilock(dp);
    80004bfc:	f64fe0ef          	jal	80003360 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c00:	4601                	li	a2,0
    80004c02:	fb040593          	addi	a1,s0,-80
    80004c06:	8526                	mv	a0,s1
    80004c08:	cf3fe0ef          	jal	800038fa <dirlookup>
    80004c0c:	89aa                	mv	s3,a0
    80004c0e:	c131                	beqz	a0,80004c52 <create+0x80>
    iunlockput(dp);
    80004c10:	8526                	mv	a0,s1
    80004c12:	95bfe0ef          	jal	8000356c <iunlockput>
    ilock(ip);
    80004c16:	854e                	mv	a0,s3
    80004c18:	f48fe0ef          	jal	80003360 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c1c:	4789                	li	a5,2
    80004c1e:	02f91563          	bne	s2,a5,80004c48 <create+0x76>
    80004c22:	0449d783          	lhu	a5,68(s3)
    80004c26:	37f9                	addiw	a5,a5,-2
    80004c28:	17c2                	slli	a5,a5,0x30
    80004c2a:	93c1                	srli	a5,a5,0x30
    80004c2c:	4705                	li	a4,1
    80004c2e:	00f76d63          	bltu	a4,a5,80004c48 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004c32:	854e                	mv	a0,s3
    80004c34:	60a6                	ld	ra,72(sp)
    80004c36:	6406                	ld	s0,64(sp)
    80004c38:	74e2                	ld	s1,56(sp)
    80004c3a:	7942                	ld	s2,48(sp)
    80004c3c:	79a2                	ld	s3,40(sp)
    80004c3e:	7a02                	ld	s4,32(sp)
    80004c40:	6ae2                	ld	s5,24(sp)
    80004c42:	6b42                	ld	s6,16(sp)
    80004c44:	6161                	addi	sp,sp,80
    80004c46:	8082                	ret
    iunlockput(ip);
    80004c48:	854e                	mv	a0,s3
    80004c4a:	923fe0ef          	jal	8000356c <iunlockput>
    return 0;
    80004c4e:	4981                	li	s3,0
    80004c50:	b7cd                	j	80004c32 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004c52:	85ca                	mv	a1,s2
    80004c54:	4088                	lw	a0,0(s1)
    80004c56:	d9afe0ef          	jal	800031f0 <ialloc>
    80004c5a:	892a                	mv	s2,a0
    80004c5c:	cd15                	beqz	a0,80004c98 <create+0xc6>
  ilock(ip);
    80004c5e:	f02fe0ef          	jal	80003360 <ilock>
  ip->major = major;
    80004c62:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004c66:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004c6a:	4785                	li	a5,1
    80004c6c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c70:	854a                	mv	a0,s2
    80004c72:	e3afe0ef          	jal	800032ac <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004c76:	4705                	li	a4,1
    80004c78:	02ea0463          	beq	s4,a4,80004ca0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c7c:	00492603          	lw	a2,4(s2)
    80004c80:	fb040593          	addi	a1,s0,-80
    80004c84:	8526                	mv	a0,s1
    80004c86:	e5ffe0ef          	jal	80003ae4 <dirlink>
    80004c8a:	06054263          	bltz	a0,80004cee <create+0x11c>
  iunlockput(dp);
    80004c8e:	8526                	mv	a0,s1
    80004c90:	8ddfe0ef          	jal	8000356c <iunlockput>
  return ip;
    80004c94:	89ca                	mv	s3,s2
    80004c96:	bf71                	j	80004c32 <create+0x60>
    iunlockput(dp);
    80004c98:	8526                	mv	a0,s1
    80004c9a:	8d3fe0ef          	jal	8000356c <iunlockput>
    return 0;
    80004c9e:	bf51                	j	80004c32 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004ca0:	00492603          	lw	a2,4(s2)
    80004ca4:	00003597          	auipc	a1,0x3
    80004ca8:	91c58593          	addi	a1,a1,-1764 # 800075c0 <etext+0x5c0>
    80004cac:	854a                	mv	a0,s2
    80004cae:	e37fe0ef          	jal	80003ae4 <dirlink>
    80004cb2:	02054e63          	bltz	a0,80004cee <create+0x11c>
    80004cb6:	40d0                	lw	a2,4(s1)
    80004cb8:	00003597          	auipc	a1,0x3
    80004cbc:	91058593          	addi	a1,a1,-1776 # 800075c8 <etext+0x5c8>
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	e23fe0ef          	jal	80003ae4 <dirlink>
    80004cc6:	02054463          	bltz	a0,80004cee <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004cca:	00492603          	lw	a2,4(s2)
    80004cce:	fb040593          	addi	a1,s0,-80
    80004cd2:	8526                	mv	a0,s1
    80004cd4:	e11fe0ef          	jal	80003ae4 <dirlink>
    80004cd8:	00054b63          	bltz	a0,80004cee <create+0x11c>
    dp->nlink++;  // for ".."
    80004cdc:	04a4d783          	lhu	a5,74(s1)
    80004ce0:	2785                	addiw	a5,a5,1
    80004ce2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	dc4fe0ef          	jal	800032ac <iupdate>
    80004cec:	b74d                	j	80004c8e <create+0xbc>
  ip->nlink = 0;
    80004cee:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004cf2:	854a                	mv	a0,s2
    80004cf4:	db8fe0ef          	jal	800032ac <iupdate>
  iunlockput(ip);
    80004cf8:	854a                	mv	a0,s2
    80004cfa:	873fe0ef          	jal	8000356c <iunlockput>
  iunlockput(dp);
    80004cfe:	8526                	mv	a0,s1
    80004d00:	86dfe0ef          	jal	8000356c <iunlockput>
  return 0;
    80004d04:	b73d                	j	80004c32 <create+0x60>
    return 0;
    80004d06:	89aa                	mv	s3,a0
    80004d08:	b72d                	j	80004c32 <create+0x60>

0000000080004d0a <sys_dup>:
{
    80004d0a:	7179                	addi	sp,sp,-48
    80004d0c:	f406                	sd	ra,40(sp)
    80004d0e:	f022                	sd	s0,32(sp)
    80004d10:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004d12:	fd840613          	addi	a2,s0,-40
    80004d16:	4581                	li	a1,0
    80004d18:	4501                	li	a0,0
    80004d1a:	e1fff0ef          	jal	80004b38 <argfd>
    return -1;
    80004d1e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004d20:	02054363          	bltz	a0,80004d46 <sys_dup+0x3c>
    80004d24:	ec26                	sd	s1,24(sp)
    80004d26:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004d28:	fd843483          	ld	s1,-40(s0)
    80004d2c:	8526                	mv	a0,s1
    80004d2e:	e65ff0ef          	jal	80004b92 <fdalloc>
    80004d32:	892a                	mv	s2,a0
    return -1;
    80004d34:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004d36:	00054d63          	bltz	a0,80004d50 <sys_dup+0x46>
  filedup(f);
    80004d3a:	8526                	mv	a0,s1
    80004d3c:	c0eff0ef          	jal	8000414a <filedup>
  return fd;
    80004d40:	87ca                	mv	a5,s2
    80004d42:	64e2                	ld	s1,24(sp)
    80004d44:	6942                	ld	s2,16(sp)
}
    80004d46:	853e                	mv	a0,a5
    80004d48:	70a2                	ld	ra,40(sp)
    80004d4a:	7402                	ld	s0,32(sp)
    80004d4c:	6145                	addi	sp,sp,48
    80004d4e:	8082                	ret
    80004d50:	64e2                	ld	s1,24(sp)
    80004d52:	6942                	ld	s2,16(sp)
    80004d54:	bfcd                	j	80004d46 <sys_dup+0x3c>

0000000080004d56 <sys_read>:
{
    80004d56:	7179                	addi	sp,sp,-48
    80004d58:	f406                	sd	ra,40(sp)
    80004d5a:	f022                	sd	s0,32(sp)
    80004d5c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d5e:	fd840593          	addi	a1,s0,-40
    80004d62:	4505                	li	a0,1
    80004d64:	c4ffd0ef          	jal	800029b2 <argaddr>
  argint(2, &n);
    80004d68:	fe440593          	addi	a1,s0,-28
    80004d6c:	4509                	li	a0,2
    80004d6e:	c29fd0ef          	jal	80002996 <argint>
  if(argfd(0, 0, &f) < 0)
    80004d72:	fe840613          	addi	a2,s0,-24
    80004d76:	4581                	li	a1,0
    80004d78:	4501                	li	a0,0
    80004d7a:	dbfff0ef          	jal	80004b38 <argfd>
    80004d7e:	87aa                	mv	a5,a0
    return -1;
    80004d80:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d82:	0007ca63          	bltz	a5,80004d96 <sys_read+0x40>
  return fileread(f, p, n);
    80004d86:	fe442603          	lw	a2,-28(s0)
    80004d8a:	fd843583          	ld	a1,-40(s0)
    80004d8e:	fe843503          	ld	a0,-24(s0)
    80004d92:	d22ff0ef          	jal	800042b4 <fileread>
}
    80004d96:	70a2                	ld	ra,40(sp)
    80004d98:	7402                	ld	s0,32(sp)
    80004d9a:	6145                	addi	sp,sp,48
    80004d9c:	8082                	ret

0000000080004d9e <sys_write>:
{
    80004d9e:	7179                	addi	sp,sp,-48
    80004da0:	f406                	sd	ra,40(sp)
    80004da2:	f022                	sd	s0,32(sp)
    80004da4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004da6:	fd840593          	addi	a1,s0,-40
    80004daa:	4505                	li	a0,1
    80004dac:	c07fd0ef          	jal	800029b2 <argaddr>
  argint(2, &n);
    80004db0:	fe440593          	addi	a1,s0,-28
    80004db4:	4509                	li	a0,2
    80004db6:	be1fd0ef          	jal	80002996 <argint>
  if(argfd(0, 0, &f) < 0)
    80004dba:	fe840613          	addi	a2,s0,-24
    80004dbe:	4581                	li	a1,0
    80004dc0:	4501                	li	a0,0
    80004dc2:	d77ff0ef          	jal	80004b38 <argfd>
    80004dc6:	87aa                	mv	a5,a0
    return -1;
    80004dc8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004dca:	0007ca63          	bltz	a5,80004dde <sys_write+0x40>
  return filewrite(f, p, n);
    80004dce:	fe442603          	lw	a2,-28(s0)
    80004dd2:	fd843583          	ld	a1,-40(s0)
    80004dd6:	fe843503          	ld	a0,-24(s0)
    80004dda:	d9eff0ef          	jal	80004378 <filewrite>
}
    80004dde:	70a2                	ld	ra,40(sp)
    80004de0:	7402                	ld	s0,32(sp)
    80004de2:	6145                	addi	sp,sp,48
    80004de4:	8082                	ret

0000000080004de6 <sys_close>:
{
    80004de6:	1101                	addi	sp,sp,-32
    80004de8:	ec06                	sd	ra,24(sp)
    80004dea:	e822                	sd	s0,16(sp)
    80004dec:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004dee:	fe040613          	addi	a2,s0,-32
    80004df2:	fec40593          	addi	a1,s0,-20
    80004df6:	4501                	li	a0,0
    80004df8:	d41ff0ef          	jal	80004b38 <argfd>
    return -1;
    80004dfc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004dfe:	02054163          	bltz	a0,80004e20 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004e02:	b25fc0ef          	jal	80001926 <myproc>
    80004e06:	fec42783          	lw	a5,-20(s0)
    80004e0a:	078e                	slli	a5,a5,0x3
    80004e0c:	0d078793          	addi	a5,a5,208
    80004e10:	953e                	add	a0,a0,a5
    80004e12:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004e16:	fe043503          	ld	a0,-32(s0)
    80004e1a:	b76ff0ef          	jal	80004190 <fileclose>
  return 0;
    80004e1e:	4781                	li	a5,0
}
    80004e20:	853e                	mv	a0,a5
    80004e22:	60e2                	ld	ra,24(sp)
    80004e24:	6442                	ld	s0,16(sp)
    80004e26:	6105                	addi	sp,sp,32
    80004e28:	8082                	ret

0000000080004e2a <sys_fstat>:
{
    80004e2a:	1101                	addi	sp,sp,-32
    80004e2c:	ec06                	sd	ra,24(sp)
    80004e2e:	e822                	sd	s0,16(sp)
    80004e30:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004e32:	fe040593          	addi	a1,s0,-32
    80004e36:	4505                	li	a0,1
    80004e38:	b7bfd0ef          	jal	800029b2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004e3c:	fe840613          	addi	a2,s0,-24
    80004e40:	4581                	li	a1,0
    80004e42:	4501                	li	a0,0
    80004e44:	cf5ff0ef          	jal	80004b38 <argfd>
    80004e48:	87aa                	mv	a5,a0
    return -1;
    80004e4a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e4c:	0007c863          	bltz	a5,80004e5c <sys_fstat+0x32>
  return filestat(f, st);
    80004e50:	fe043583          	ld	a1,-32(s0)
    80004e54:	fe843503          	ld	a0,-24(s0)
    80004e58:	bfaff0ef          	jal	80004252 <filestat>
}
    80004e5c:	60e2                	ld	ra,24(sp)
    80004e5e:	6442                	ld	s0,16(sp)
    80004e60:	6105                	addi	sp,sp,32
    80004e62:	8082                	ret

0000000080004e64 <sys_link>:
{
    80004e64:	7169                	addi	sp,sp,-304
    80004e66:	f606                	sd	ra,296(sp)
    80004e68:	f222                	sd	s0,288(sp)
    80004e6a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e6c:	08000613          	li	a2,128
    80004e70:	ed040593          	addi	a1,s0,-304
    80004e74:	4501                	li	a0,0
    80004e76:	b59fd0ef          	jal	800029ce <argstr>
    return -1;
    80004e7a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e7c:	0c054e63          	bltz	a0,80004f58 <sys_link+0xf4>
    80004e80:	08000613          	li	a2,128
    80004e84:	f5040593          	addi	a1,s0,-176
    80004e88:	4505                	li	a0,1
    80004e8a:	b45fd0ef          	jal	800029ce <argstr>
    return -1;
    80004e8e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e90:	0c054463          	bltz	a0,80004f58 <sys_link+0xf4>
    80004e94:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e96:	ed7fe0ef          	jal	80003d6c <begin_op>
  if((ip = namei(old)) == 0){
    80004e9a:	ed040513          	addi	a0,s0,-304
    80004e9e:	cf1fe0ef          	jal	80003b8e <namei>
    80004ea2:	84aa                	mv	s1,a0
    80004ea4:	c53d                	beqz	a0,80004f12 <sys_link+0xae>
  ilock(ip);
    80004ea6:	cbafe0ef          	jal	80003360 <ilock>
  if(ip->type == T_DIR){
    80004eaa:	04449703          	lh	a4,68(s1)
    80004eae:	4785                	li	a5,1
    80004eb0:	06f70663          	beq	a4,a5,80004f1c <sys_link+0xb8>
    80004eb4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004eb6:	04a4d783          	lhu	a5,74(s1)
    80004eba:	2785                	addiw	a5,a5,1
    80004ebc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	beafe0ef          	jal	800032ac <iupdate>
  iunlock(ip);
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	d46fe0ef          	jal	8000340e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ecc:	fd040593          	addi	a1,s0,-48
    80004ed0:	f5040513          	addi	a0,s0,-176
    80004ed4:	cd5fe0ef          	jal	80003ba8 <nameiparent>
    80004ed8:	892a                	mv	s2,a0
    80004eda:	cd21                	beqz	a0,80004f32 <sys_link+0xce>
  ilock(dp);
    80004edc:	c84fe0ef          	jal	80003360 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ee0:	854a                	mv	a0,s2
    80004ee2:	00092703          	lw	a4,0(s2)
    80004ee6:	409c                	lw	a5,0(s1)
    80004ee8:	04f71263          	bne	a4,a5,80004f2c <sys_link+0xc8>
    80004eec:	40d0                	lw	a2,4(s1)
    80004eee:	fd040593          	addi	a1,s0,-48
    80004ef2:	bf3fe0ef          	jal	80003ae4 <dirlink>
    80004ef6:	02054b63          	bltz	a0,80004f2c <sys_link+0xc8>
  iunlockput(dp);
    80004efa:	854a                	mv	a0,s2
    80004efc:	e70fe0ef          	jal	8000356c <iunlockput>
  iput(ip);
    80004f00:	8526                	mv	a0,s1
    80004f02:	de0fe0ef          	jal	800034e2 <iput>
  end_op();
    80004f06:	ed7fe0ef          	jal	80003ddc <end_op>
  return 0;
    80004f0a:	4781                	li	a5,0
    80004f0c:	64f2                	ld	s1,280(sp)
    80004f0e:	6952                	ld	s2,272(sp)
    80004f10:	a0a1                	j	80004f58 <sys_link+0xf4>
    end_op();
    80004f12:	ecbfe0ef          	jal	80003ddc <end_op>
    return -1;
    80004f16:	57fd                	li	a5,-1
    80004f18:	64f2                	ld	s1,280(sp)
    80004f1a:	a83d                	j	80004f58 <sys_link+0xf4>
    iunlockput(ip);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	e4efe0ef          	jal	8000356c <iunlockput>
    end_op();
    80004f22:	ebbfe0ef          	jal	80003ddc <end_op>
    return -1;
    80004f26:	57fd                	li	a5,-1
    80004f28:	64f2                	ld	s1,280(sp)
    80004f2a:	a03d                	j	80004f58 <sys_link+0xf4>
    iunlockput(dp);
    80004f2c:	854a                	mv	a0,s2
    80004f2e:	e3efe0ef          	jal	8000356c <iunlockput>
  ilock(ip);
    80004f32:	8526                	mv	a0,s1
    80004f34:	c2cfe0ef          	jal	80003360 <ilock>
  ip->nlink--;
    80004f38:	04a4d783          	lhu	a5,74(s1)
    80004f3c:	37fd                	addiw	a5,a5,-1
    80004f3e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f42:	8526                	mv	a0,s1
    80004f44:	b68fe0ef          	jal	800032ac <iupdate>
  iunlockput(ip);
    80004f48:	8526                	mv	a0,s1
    80004f4a:	e22fe0ef          	jal	8000356c <iunlockput>
  end_op();
    80004f4e:	e8ffe0ef          	jal	80003ddc <end_op>
  return -1;
    80004f52:	57fd                	li	a5,-1
    80004f54:	64f2                	ld	s1,280(sp)
    80004f56:	6952                	ld	s2,272(sp)
}
    80004f58:	853e                	mv	a0,a5
    80004f5a:	70b2                	ld	ra,296(sp)
    80004f5c:	7412                	ld	s0,288(sp)
    80004f5e:	6155                	addi	sp,sp,304
    80004f60:	8082                	ret

0000000080004f62 <sys_unlink>:
{
    80004f62:	7151                	addi	sp,sp,-240
    80004f64:	f586                	sd	ra,232(sp)
    80004f66:	f1a2                	sd	s0,224(sp)
    80004f68:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004f6a:	08000613          	li	a2,128
    80004f6e:	f3040593          	addi	a1,s0,-208
    80004f72:	4501                	li	a0,0
    80004f74:	a5bfd0ef          	jal	800029ce <argstr>
    80004f78:	14054d63          	bltz	a0,800050d2 <sys_unlink+0x170>
    80004f7c:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f7e:	deffe0ef          	jal	80003d6c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f82:	fb040593          	addi	a1,s0,-80
    80004f86:	f3040513          	addi	a0,s0,-208
    80004f8a:	c1ffe0ef          	jal	80003ba8 <nameiparent>
    80004f8e:	84aa                	mv	s1,a0
    80004f90:	c955                	beqz	a0,80005044 <sys_unlink+0xe2>
  ilock(dp);
    80004f92:	bcefe0ef          	jal	80003360 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f96:	00002597          	auipc	a1,0x2
    80004f9a:	62a58593          	addi	a1,a1,1578 # 800075c0 <etext+0x5c0>
    80004f9e:	fb040513          	addi	a0,s0,-80
    80004fa2:	943fe0ef          	jal	800038e4 <namecmp>
    80004fa6:	10050b63          	beqz	a0,800050bc <sys_unlink+0x15a>
    80004faa:	00002597          	auipc	a1,0x2
    80004fae:	61e58593          	addi	a1,a1,1566 # 800075c8 <etext+0x5c8>
    80004fb2:	fb040513          	addi	a0,s0,-80
    80004fb6:	92ffe0ef          	jal	800038e4 <namecmp>
    80004fba:	10050163          	beqz	a0,800050bc <sys_unlink+0x15a>
    80004fbe:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004fc0:	f2c40613          	addi	a2,s0,-212
    80004fc4:	fb040593          	addi	a1,s0,-80
    80004fc8:	8526                	mv	a0,s1
    80004fca:	931fe0ef          	jal	800038fa <dirlookup>
    80004fce:	892a                	mv	s2,a0
    80004fd0:	0e050563          	beqz	a0,800050ba <sys_unlink+0x158>
    80004fd4:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004fd6:	b8afe0ef          	jal	80003360 <ilock>
  if(ip->nlink < 1)
    80004fda:	04a91783          	lh	a5,74(s2)
    80004fde:	06f05863          	blez	a5,8000504e <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004fe2:	04491703          	lh	a4,68(s2)
    80004fe6:	4785                	li	a5,1
    80004fe8:	06f70963          	beq	a4,a5,8000505a <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004fec:	fc040993          	addi	s3,s0,-64
    80004ff0:	4641                	li	a2,16
    80004ff2:	4581                	li	a1,0
    80004ff4:	854e                	mv	a0,s3
    80004ff6:	d03fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ffa:	4741                	li	a4,16
    80004ffc:	f2c42683          	lw	a3,-212(s0)
    80005000:	864e                	mv	a2,s3
    80005002:	4581                	li	a1,0
    80005004:	8526                	mv	a0,s1
    80005006:	fdefe0ef          	jal	800037e4 <writei>
    8000500a:	47c1                	li	a5,16
    8000500c:	08f51863          	bne	a0,a5,8000509c <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80005010:	04491703          	lh	a4,68(s2)
    80005014:	4785                	li	a5,1
    80005016:	08f70963          	beq	a4,a5,800050a8 <sys_unlink+0x146>
  iunlockput(dp);
    8000501a:	8526                	mv	a0,s1
    8000501c:	d50fe0ef          	jal	8000356c <iunlockput>
  ip->nlink--;
    80005020:	04a95783          	lhu	a5,74(s2)
    80005024:	37fd                	addiw	a5,a5,-1
    80005026:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000502a:	854a                	mv	a0,s2
    8000502c:	a80fe0ef          	jal	800032ac <iupdate>
  iunlockput(ip);
    80005030:	854a                	mv	a0,s2
    80005032:	d3afe0ef          	jal	8000356c <iunlockput>
  end_op();
    80005036:	da7fe0ef          	jal	80003ddc <end_op>
  return 0;
    8000503a:	4501                	li	a0,0
    8000503c:	64ee                	ld	s1,216(sp)
    8000503e:	694e                	ld	s2,208(sp)
    80005040:	69ae                	ld	s3,200(sp)
    80005042:	a061                	j	800050ca <sys_unlink+0x168>
    end_op();
    80005044:	d99fe0ef          	jal	80003ddc <end_op>
    return -1;
    80005048:	557d                	li	a0,-1
    8000504a:	64ee                	ld	s1,216(sp)
    8000504c:	a8bd                	j	800050ca <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000504e:	00002517          	auipc	a0,0x2
    80005052:	58250513          	addi	a0,a0,1410 # 800075d0 <etext+0x5d0>
    80005056:	fcefb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000505a:	04c92703          	lw	a4,76(s2)
    8000505e:	02000793          	li	a5,32
    80005062:	f8e7f5e3          	bgeu	a5,a4,80004fec <sys_unlink+0x8a>
    80005066:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005068:	4741                	li	a4,16
    8000506a:	86ce                	mv	a3,s3
    8000506c:	f1840613          	addi	a2,s0,-232
    80005070:	4581                	li	a1,0
    80005072:	854a                	mv	a0,s2
    80005074:	e7efe0ef          	jal	800036f2 <readi>
    80005078:	47c1                	li	a5,16
    8000507a:	00f51b63          	bne	a0,a5,80005090 <sys_unlink+0x12e>
    if(de.inum != 0)
    8000507e:	f1845783          	lhu	a5,-232(s0)
    80005082:	ebb1                	bnez	a5,800050d6 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005084:	29c1                	addiw	s3,s3,16
    80005086:	04c92783          	lw	a5,76(s2)
    8000508a:	fcf9efe3          	bltu	s3,a5,80005068 <sys_unlink+0x106>
    8000508e:	bfb9                	j	80004fec <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005090:	00002517          	auipc	a0,0x2
    80005094:	55850513          	addi	a0,a0,1368 # 800075e8 <etext+0x5e8>
    80005098:	f8cfb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    8000509c:	00002517          	auipc	a0,0x2
    800050a0:	56450513          	addi	a0,a0,1380 # 80007600 <etext+0x600>
    800050a4:	f80fb0ef          	jal	80000824 <panic>
    dp->nlink--;
    800050a8:	04a4d783          	lhu	a5,74(s1)
    800050ac:	37fd                	addiw	a5,a5,-1
    800050ae:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050b2:	8526                	mv	a0,s1
    800050b4:	9f8fe0ef          	jal	800032ac <iupdate>
    800050b8:	b78d                	j	8000501a <sys_unlink+0xb8>
    800050ba:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800050bc:	8526                	mv	a0,s1
    800050be:	caefe0ef          	jal	8000356c <iunlockput>
  end_op();
    800050c2:	d1bfe0ef          	jal	80003ddc <end_op>
  return -1;
    800050c6:	557d                	li	a0,-1
    800050c8:	64ee                	ld	s1,216(sp)
}
    800050ca:	70ae                	ld	ra,232(sp)
    800050cc:	740e                	ld	s0,224(sp)
    800050ce:	616d                	addi	sp,sp,240
    800050d0:	8082                	ret
    return -1;
    800050d2:	557d                	li	a0,-1
    800050d4:	bfdd                	j	800050ca <sys_unlink+0x168>
    iunlockput(ip);
    800050d6:	854a                	mv	a0,s2
    800050d8:	c94fe0ef          	jal	8000356c <iunlockput>
    goto bad;
    800050dc:	694e                	ld	s2,208(sp)
    800050de:	69ae                	ld	s3,200(sp)
    800050e0:	bff1                	j	800050bc <sys_unlink+0x15a>

00000000800050e2 <sys_open>:

uint64
sys_open(void)
{
    800050e2:	7131                	addi	sp,sp,-192
    800050e4:	fd06                	sd	ra,184(sp)
    800050e6:	f922                	sd	s0,176(sp)
    800050e8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800050ea:	f4c40593          	addi	a1,s0,-180
    800050ee:	4505                	li	a0,1
    800050f0:	8a7fd0ef          	jal	80002996 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800050f4:	08000613          	li	a2,128
    800050f8:	f5040593          	addi	a1,s0,-176
    800050fc:	4501                	li	a0,0
    800050fe:	8d1fd0ef          	jal	800029ce <argstr>
    80005102:	87aa                	mv	a5,a0
    return -1;
    80005104:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005106:	0a07c363          	bltz	a5,800051ac <sys_open+0xca>
    8000510a:	f526                	sd	s1,168(sp)

  begin_op();
    8000510c:	c61fe0ef          	jal	80003d6c <begin_op>

  if(omode & O_CREATE){
    80005110:	f4c42783          	lw	a5,-180(s0)
    80005114:	2007f793          	andi	a5,a5,512
    80005118:	c3dd                	beqz	a5,800051be <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000511a:	4681                	li	a3,0
    8000511c:	4601                	li	a2,0
    8000511e:	4589                	li	a1,2
    80005120:	f5040513          	addi	a0,s0,-176
    80005124:	aafff0ef          	jal	80004bd2 <create>
    80005128:	84aa                	mv	s1,a0
    if(ip == 0){
    8000512a:	c549                	beqz	a0,800051b4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000512c:	04449703          	lh	a4,68(s1)
    80005130:	478d                	li	a5,3
    80005132:	00f71763          	bne	a4,a5,80005140 <sys_open+0x5e>
    80005136:	0464d703          	lhu	a4,70(s1)
    8000513a:	47a5                	li	a5,9
    8000513c:	0ae7ee63          	bltu	a5,a4,800051f8 <sys_open+0x116>
    80005140:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005142:	fabfe0ef          	jal	800040ec <filealloc>
    80005146:	892a                	mv	s2,a0
    80005148:	c561                	beqz	a0,80005210 <sys_open+0x12e>
    8000514a:	ed4e                	sd	s3,152(sp)
    8000514c:	a47ff0ef          	jal	80004b92 <fdalloc>
    80005150:	89aa                	mv	s3,a0
    80005152:	0a054b63          	bltz	a0,80005208 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005156:	04449703          	lh	a4,68(s1)
    8000515a:	478d                	li	a5,3
    8000515c:	0cf70363          	beq	a4,a5,80005222 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005160:	4789                	li	a5,2
    80005162:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005166:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000516a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000516e:	f4c42783          	lw	a5,-180(s0)
    80005172:	0017f713          	andi	a4,a5,1
    80005176:	00174713          	xori	a4,a4,1
    8000517a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000517e:	0037f713          	andi	a4,a5,3
    80005182:	00e03733          	snez	a4,a4
    80005186:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000518a:	4007f793          	andi	a5,a5,1024
    8000518e:	c791                	beqz	a5,8000519a <sys_open+0xb8>
    80005190:	04449703          	lh	a4,68(s1)
    80005194:	4789                	li	a5,2
    80005196:	08f70d63          	beq	a4,a5,80005230 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000519a:	8526                	mv	a0,s1
    8000519c:	a72fe0ef          	jal	8000340e <iunlock>
  end_op();
    800051a0:	c3dfe0ef          	jal	80003ddc <end_op>

  return fd;
    800051a4:	854e                	mv	a0,s3
    800051a6:	74aa                	ld	s1,168(sp)
    800051a8:	790a                	ld	s2,160(sp)
    800051aa:	69ea                	ld	s3,152(sp)
}
    800051ac:	70ea                	ld	ra,184(sp)
    800051ae:	744a                	ld	s0,176(sp)
    800051b0:	6129                	addi	sp,sp,192
    800051b2:	8082                	ret
      end_op();
    800051b4:	c29fe0ef          	jal	80003ddc <end_op>
      return -1;
    800051b8:	557d                	li	a0,-1
    800051ba:	74aa                	ld	s1,168(sp)
    800051bc:	bfc5                	j	800051ac <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800051be:	f5040513          	addi	a0,s0,-176
    800051c2:	9cdfe0ef          	jal	80003b8e <namei>
    800051c6:	84aa                	mv	s1,a0
    800051c8:	c11d                	beqz	a0,800051ee <sys_open+0x10c>
    ilock(ip);
    800051ca:	996fe0ef          	jal	80003360 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800051ce:	04449703          	lh	a4,68(s1)
    800051d2:	4785                	li	a5,1
    800051d4:	f4f71ce3          	bne	a4,a5,8000512c <sys_open+0x4a>
    800051d8:	f4c42783          	lw	a5,-180(s0)
    800051dc:	d3b5                	beqz	a5,80005140 <sys_open+0x5e>
      iunlockput(ip);
    800051de:	8526                	mv	a0,s1
    800051e0:	b8cfe0ef          	jal	8000356c <iunlockput>
      end_op();
    800051e4:	bf9fe0ef          	jal	80003ddc <end_op>
      return -1;
    800051e8:	557d                	li	a0,-1
    800051ea:	74aa                	ld	s1,168(sp)
    800051ec:	b7c1                	j	800051ac <sys_open+0xca>
      end_op();
    800051ee:	beffe0ef          	jal	80003ddc <end_op>
      return -1;
    800051f2:	557d                	li	a0,-1
    800051f4:	74aa                	ld	s1,168(sp)
    800051f6:	bf5d                	j	800051ac <sys_open+0xca>
    iunlockput(ip);
    800051f8:	8526                	mv	a0,s1
    800051fa:	b72fe0ef          	jal	8000356c <iunlockput>
    end_op();
    800051fe:	bdffe0ef          	jal	80003ddc <end_op>
    return -1;
    80005202:	557d                	li	a0,-1
    80005204:	74aa                	ld	s1,168(sp)
    80005206:	b75d                	j	800051ac <sys_open+0xca>
      fileclose(f);
    80005208:	854a                	mv	a0,s2
    8000520a:	f87fe0ef          	jal	80004190 <fileclose>
    8000520e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005210:	8526                	mv	a0,s1
    80005212:	b5afe0ef          	jal	8000356c <iunlockput>
    end_op();
    80005216:	bc7fe0ef          	jal	80003ddc <end_op>
    return -1;
    8000521a:	557d                	li	a0,-1
    8000521c:	74aa                	ld	s1,168(sp)
    8000521e:	790a                	ld	s2,160(sp)
    80005220:	b771                	j	800051ac <sys_open+0xca>
    f->type = FD_DEVICE;
    80005222:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005226:	04649783          	lh	a5,70(s1)
    8000522a:	02f91223          	sh	a5,36(s2)
    8000522e:	bf35                	j	8000516a <sys_open+0x88>
    itrunc(ip);
    80005230:	8526                	mv	a0,s1
    80005232:	a1cfe0ef          	jal	8000344e <itrunc>
    80005236:	b795                	j	8000519a <sys_open+0xb8>

0000000080005238 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005238:	7175                	addi	sp,sp,-144
    8000523a:	e506                	sd	ra,136(sp)
    8000523c:	e122                	sd	s0,128(sp)
    8000523e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005240:	b2dfe0ef          	jal	80003d6c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005244:	08000613          	li	a2,128
    80005248:	f7040593          	addi	a1,s0,-144
    8000524c:	4501                	li	a0,0
    8000524e:	f80fd0ef          	jal	800029ce <argstr>
    80005252:	02054363          	bltz	a0,80005278 <sys_mkdir+0x40>
    80005256:	4681                	li	a3,0
    80005258:	4601                	li	a2,0
    8000525a:	4585                	li	a1,1
    8000525c:	f7040513          	addi	a0,s0,-144
    80005260:	973ff0ef          	jal	80004bd2 <create>
    80005264:	c911                	beqz	a0,80005278 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005266:	b06fe0ef          	jal	8000356c <iunlockput>
  end_op();
    8000526a:	b73fe0ef          	jal	80003ddc <end_op>
  return 0;
    8000526e:	4501                	li	a0,0
}
    80005270:	60aa                	ld	ra,136(sp)
    80005272:	640a                	ld	s0,128(sp)
    80005274:	6149                	addi	sp,sp,144
    80005276:	8082                	ret
    end_op();
    80005278:	b65fe0ef          	jal	80003ddc <end_op>
    return -1;
    8000527c:	557d                	li	a0,-1
    8000527e:	bfcd                	j	80005270 <sys_mkdir+0x38>

0000000080005280 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005280:	7135                	addi	sp,sp,-160
    80005282:	ed06                	sd	ra,152(sp)
    80005284:	e922                	sd	s0,144(sp)
    80005286:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005288:	ae5fe0ef          	jal	80003d6c <begin_op>
  argint(1, &major);
    8000528c:	f6c40593          	addi	a1,s0,-148
    80005290:	4505                	li	a0,1
    80005292:	f04fd0ef          	jal	80002996 <argint>
  argint(2, &minor);
    80005296:	f6840593          	addi	a1,s0,-152
    8000529a:	4509                	li	a0,2
    8000529c:	efafd0ef          	jal	80002996 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052a0:	08000613          	li	a2,128
    800052a4:	f7040593          	addi	a1,s0,-144
    800052a8:	4501                	li	a0,0
    800052aa:	f24fd0ef          	jal	800029ce <argstr>
    800052ae:	02054563          	bltz	a0,800052d8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800052b2:	f6841683          	lh	a3,-152(s0)
    800052b6:	f6c41603          	lh	a2,-148(s0)
    800052ba:	458d                	li	a1,3
    800052bc:	f7040513          	addi	a0,s0,-144
    800052c0:	913ff0ef          	jal	80004bd2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052c4:	c911                	beqz	a0,800052d8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052c6:	aa6fe0ef          	jal	8000356c <iunlockput>
  end_op();
    800052ca:	b13fe0ef          	jal	80003ddc <end_op>
  return 0;
    800052ce:	4501                	li	a0,0
}
    800052d0:	60ea                	ld	ra,152(sp)
    800052d2:	644a                	ld	s0,144(sp)
    800052d4:	610d                	addi	sp,sp,160
    800052d6:	8082                	ret
    end_op();
    800052d8:	b05fe0ef          	jal	80003ddc <end_op>
    return -1;
    800052dc:	557d                	li	a0,-1
    800052de:	bfcd                	j	800052d0 <sys_mknod+0x50>

00000000800052e0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800052e0:	7135                	addi	sp,sp,-160
    800052e2:	ed06                	sd	ra,152(sp)
    800052e4:	e922                	sd	s0,144(sp)
    800052e6:	e14a                	sd	s2,128(sp)
    800052e8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800052ea:	e3cfc0ef          	jal	80001926 <myproc>
    800052ee:	892a                	mv	s2,a0

  begin_op();
    800052f0:	a7dfe0ef          	jal	80003d6c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800052f4:	08000613          	li	a2,128
    800052f8:	f6040593          	addi	a1,s0,-160
    800052fc:	4501                	li	a0,0
    800052fe:	ed0fd0ef          	jal	800029ce <argstr>
    80005302:	04054363          	bltz	a0,80005348 <sys_chdir+0x68>
    80005306:	e526                	sd	s1,136(sp)
    80005308:	f6040513          	addi	a0,s0,-160
    8000530c:	883fe0ef          	jal	80003b8e <namei>
    80005310:	84aa                	mv	s1,a0
    80005312:	c915                	beqz	a0,80005346 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005314:	84cfe0ef          	jal	80003360 <ilock>
  if(ip->type != T_DIR){
    80005318:	04449703          	lh	a4,68(s1)
    8000531c:	4785                	li	a5,1
    8000531e:	02f71963          	bne	a4,a5,80005350 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005322:	8526                	mv	a0,s1
    80005324:	8eafe0ef          	jal	8000340e <iunlock>
  iput(p->cwd);
    80005328:	15093503          	ld	a0,336(s2)
    8000532c:	9b6fe0ef          	jal	800034e2 <iput>
  end_op();
    80005330:	aadfe0ef          	jal	80003ddc <end_op>
  p->cwd = ip;
    80005334:	14993823          	sd	s1,336(s2)
  return 0;
    80005338:	4501                	li	a0,0
    8000533a:	64aa                	ld	s1,136(sp)
}
    8000533c:	60ea                	ld	ra,152(sp)
    8000533e:	644a                	ld	s0,144(sp)
    80005340:	690a                	ld	s2,128(sp)
    80005342:	610d                	addi	sp,sp,160
    80005344:	8082                	ret
    80005346:	64aa                	ld	s1,136(sp)
    end_op();
    80005348:	a95fe0ef          	jal	80003ddc <end_op>
    return -1;
    8000534c:	557d                	li	a0,-1
    8000534e:	b7fd                	j	8000533c <sys_chdir+0x5c>
    iunlockput(ip);
    80005350:	8526                	mv	a0,s1
    80005352:	a1afe0ef          	jal	8000356c <iunlockput>
    end_op();
    80005356:	a87fe0ef          	jal	80003ddc <end_op>
    return -1;
    8000535a:	557d                	li	a0,-1
    8000535c:	64aa                	ld	s1,136(sp)
    8000535e:	bff9                	j	8000533c <sys_chdir+0x5c>

0000000080005360 <sys_exec>:

uint64
sys_exec(void)
{
    80005360:	7105                	addi	sp,sp,-480
    80005362:	ef86                	sd	ra,472(sp)
    80005364:	eba2                	sd	s0,464(sp)
    80005366:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005368:	e2840593          	addi	a1,s0,-472
    8000536c:	4505                	li	a0,1
    8000536e:	e44fd0ef          	jal	800029b2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005372:	08000613          	li	a2,128
    80005376:	f3040593          	addi	a1,s0,-208
    8000537a:	4501                	li	a0,0
    8000537c:	e52fd0ef          	jal	800029ce <argstr>
    80005380:	87aa                	mv	a5,a0
    return -1;
    80005382:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005384:	0e07c063          	bltz	a5,80005464 <sys_exec+0x104>
    80005388:	e7a6                	sd	s1,456(sp)
    8000538a:	e3ca                	sd	s2,448(sp)
    8000538c:	ff4e                	sd	s3,440(sp)
    8000538e:	fb52                	sd	s4,432(sp)
    80005390:	f756                	sd	s5,424(sp)
    80005392:	f35a                	sd	s6,416(sp)
    80005394:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005396:	e3040a13          	addi	s4,s0,-464
    8000539a:	10000613          	li	a2,256
    8000539e:	4581                	li	a1,0
    800053a0:	8552                	mv	a0,s4
    800053a2:	957fb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800053a6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800053a8:	89d2                	mv	s3,s4
    800053aa:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800053ac:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053b0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800053b2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800053b6:	00391513          	slli	a0,s2,0x3
    800053ba:	85d6                	mv	a1,s5
    800053bc:	e2843783          	ld	a5,-472(s0)
    800053c0:	953e                	add	a0,a0,a5
    800053c2:	d4afd0ef          	jal	8000290c <fetchaddr>
    800053c6:	02054663          	bltz	a0,800053f2 <sys_exec+0x92>
    if(uarg == 0){
    800053ca:	e2043783          	ld	a5,-480(s0)
    800053ce:	c7a1                	beqz	a5,80005416 <sys_exec+0xb6>
    argv[i] = kalloc();
    800053d0:	f74fb0ef          	jal	80000b44 <kalloc>
    800053d4:	85aa                	mv	a1,a0
    800053d6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800053da:	cd01                	beqz	a0,800053f2 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053dc:	865a                	mv	a2,s6
    800053de:	e2043503          	ld	a0,-480(s0)
    800053e2:	d74fd0ef          	jal	80002956 <fetchstr>
    800053e6:	00054663          	bltz	a0,800053f2 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800053ea:	0905                	addi	s2,s2,1
    800053ec:	09a1                	addi	s3,s3,8
    800053ee:	fd7914e3          	bne	s2,s7,800053b6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053f2:	100a0a13          	addi	s4,s4,256
    800053f6:	6088                	ld	a0,0(s1)
    800053f8:	cd31                	beqz	a0,80005454 <sys_exec+0xf4>
    kfree(argv[i]);
    800053fa:	e62fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053fe:	04a1                	addi	s1,s1,8
    80005400:	ff449be3          	bne	s1,s4,800053f6 <sys_exec+0x96>
  return -1;
    80005404:	557d                	li	a0,-1
    80005406:	64be                	ld	s1,456(sp)
    80005408:	691e                	ld	s2,448(sp)
    8000540a:	79fa                	ld	s3,440(sp)
    8000540c:	7a5a                	ld	s4,432(sp)
    8000540e:	7aba                	ld	s5,424(sp)
    80005410:	7b1a                	ld	s6,416(sp)
    80005412:	6bfa                	ld	s7,408(sp)
    80005414:	a881                	j	80005464 <sys_exec+0x104>
      argv[i] = 0;
    80005416:	0009079b          	sext.w	a5,s2
    8000541a:	e3040593          	addi	a1,s0,-464
    8000541e:	078e                	slli	a5,a5,0x3
    80005420:	97ae                	add	a5,a5,a1
    80005422:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005426:	f3040513          	addi	a0,s0,-208
    8000542a:	bb2ff0ef          	jal	800047dc <kexec>
    8000542e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005430:	100a0a13          	addi	s4,s4,256
    80005434:	6088                	ld	a0,0(s1)
    80005436:	c511                	beqz	a0,80005442 <sys_exec+0xe2>
    kfree(argv[i]);
    80005438:	e24fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000543c:	04a1                	addi	s1,s1,8
    8000543e:	ff449be3          	bne	s1,s4,80005434 <sys_exec+0xd4>
  return ret;
    80005442:	854a                	mv	a0,s2
    80005444:	64be                	ld	s1,456(sp)
    80005446:	691e                	ld	s2,448(sp)
    80005448:	79fa                	ld	s3,440(sp)
    8000544a:	7a5a                	ld	s4,432(sp)
    8000544c:	7aba                	ld	s5,424(sp)
    8000544e:	7b1a                	ld	s6,416(sp)
    80005450:	6bfa                	ld	s7,408(sp)
    80005452:	a809                	j	80005464 <sys_exec+0x104>
  return -1;
    80005454:	557d                	li	a0,-1
    80005456:	64be                	ld	s1,456(sp)
    80005458:	691e                	ld	s2,448(sp)
    8000545a:	79fa                	ld	s3,440(sp)
    8000545c:	7a5a                	ld	s4,432(sp)
    8000545e:	7aba                	ld	s5,424(sp)
    80005460:	7b1a                	ld	s6,416(sp)
    80005462:	6bfa                	ld	s7,408(sp)
}
    80005464:	60fe                	ld	ra,472(sp)
    80005466:	645e                	ld	s0,464(sp)
    80005468:	613d                	addi	sp,sp,480
    8000546a:	8082                	ret

000000008000546c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000546c:	7139                	addi	sp,sp,-64
    8000546e:	fc06                	sd	ra,56(sp)
    80005470:	f822                	sd	s0,48(sp)
    80005472:	f426                	sd	s1,40(sp)
    80005474:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005476:	cb0fc0ef          	jal	80001926 <myproc>
    8000547a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000547c:	fd840593          	addi	a1,s0,-40
    80005480:	4501                	li	a0,0
    80005482:	d30fd0ef          	jal	800029b2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005486:	fc840593          	addi	a1,s0,-56
    8000548a:	fd040513          	addi	a0,s0,-48
    8000548e:	81eff0ef          	jal	800044ac <pipealloc>
    return -1;
    80005492:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005494:	0a054763          	bltz	a0,80005542 <sys_pipe+0xd6>
  fd0 = -1;
    80005498:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000549c:	fd043503          	ld	a0,-48(s0)
    800054a0:	ef2ff0ef          	jal	80004b92 <fdalloc>
    800054a4:	fca42223          	sw	a0,-60(s0)
    800054a8:	08054463          	bltz	a0,80005530 <sys_pipe+0xc4>
    800054ac:	fc843503          	ld	a0,-56(s0)
    800054b0:	ee2ff0ef          	jal	80004b92 <fdalloc>
    800054b4:	fca42023          	sw	a0,-64(s0)
    800054b8:	06054263          	bltz	a0,8000551c <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054bc:	4691                	li	a3,4
    800054be:	fc440613          	addi	a2,s0,-60
    800054c2:	fd843583          	ld	a1,-40(s0)
    800054c6:	68a8                	ld	a0,80(s1)
    800054c8:	98cfc0ef          	jal	80001654 <copyout>
    800054cc:	00054e63          	bltz	a0,800054e8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800054d0:	4691                	li	a3,4
    800054d2:	fc040613          	addi	a2,s0,-64
    800054d6:	fd843583          	ld	a1,-40(s0)
    800054da:	95b6                	add	a1,a1,a3
    800054dc:	68a8                	ld	a0,80(s1)
    800054de:	976fc0ef          	jal	80001654 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800054e2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054e4:	04055f63          	bgez	a0,80005542 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800054e8:	fc442783          	lw	a5,-60(s0)
    800054ec:	078e                	slli	a5,a5,0x3
    800054ee:	0d078793          	addi	a5,a5,208
    800054f2:	97a6                	add	a5,a5,s1
    800054f4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054f8:	fc042783          	lw	a5,-64(s0)
    800054fc:	078e                	slli	a5,a5,0x3
    800054fe:	0d078793          	addi	a5,a5,208
    80005502:	97a6                	add	a5,a5,s1
    80005504:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005508:	fd043503          	ld	a0,-48(s0)
    8000550c:	c85fe0ef          	jal	80004190 <fileclose>
    fileclose(wf);
    80005510:	fc843503          	ld	a0,-56(s0)
    80005514:	c7dfe0ef          	jal	80004190 <fileclose>
    return -1;
    80005518:	57fd                	li	a5,-1
    8000551a:	a025                	j	80005542 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000551c:	fc442783          	lw	a5,-60(s0)
    80005520:	0007c863          	bltz	a5,80005530 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005524:	078e                	slli	a5,a5,0x3
    80005526:	0d078793          	addi	a5,a5,208
    8000552a:	97a6                	add	a5,a5,s1
    8000552c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005530:	fd043503          	ld	a0,-48(s0)
    80005534:	c5dfe0ef          	jal	80004190 <fileclose>
    fileclose(wf);
    80005538:	fc843503          	ld	a0,-56(s0)
    8000553c:	c55fe0ef          	jal	80004190 <fileclose>
    return -1;
    80005540:	57fd                	li	a5,-1
}
    80005542:	853e                	mv	a0,a5
    80005544:	70e2                	ld	ra,56(sp)
    80005546:	7442                	ld	s0,48(sp)
    80005548:	74a2                	ld	s1,40(sp)
    8000554a:	6121                	addi	sp,sp,64
    8000554c:	8082                	ret

000000008000554e <sys_mmap>:

uint64
sys_mmap(void)
{
    8000554e:	7139                	addi	sp,sp,-64
    80005550:	fc06                	sd	ra,56(sp)
    80005552:	f822                	sd	s0,48(sp)
    80005554:	0080                	addi	s0,sp,64
  int len, prot, flags, fd, offset;
  struct file *f;
  
  // 1. 인자 가져오기 (void 함수들이므로 반환값 검사 없이 호출)
  argint(0, &len);
    80005556:	fdc40593          	addi	a1,s0,-36
    8000555a:	4501                	li	a0,0
    8000555c:	c3afd0ef          	jal	80002996 <argint>
  argint(1, &prot);
    80005560:	fd840593          	addi	a1,s0,-40
    80005564:	4505                	li	a0,1
    80005566:	c30fd0ef          	jal	80002996 <argint>
  argint(2, &flags);
    8000556a:	fd440593          	addi	a1,s0,-44
    8000556e:	4509                	li	a0,2
    80005570:	c26fd0ef          	jal	80002996 <argint>
  // argfd는 int를 반환하므로 검사해야 함
  if(argfd(3, &fd, &f) < 0) 
    80005574:	fc040613          	addi	a2,s0,-64
    80005578:	fd040593          	addi	a1,s0,-48
    8000557c:	450d                	li	a0,3
    8000557e:	dbaff0ef          	jal	80004b38 <argfd>
    return -1;
    80005582:	57fd                	li	a5,-1
  if(argfd(3, &fd, &f) < 0) 
    80005584:	0e054863          	bltz	a0,80005674 <sys_mmap+0x126>
  argint(4, &offset);
    80005588:	fcc40593          	addi	a1,s0,-52
    8000558c:	4511                	li	a0,4
    8000558e:	c08fd0ef          	jal	80002996 <argint>

  if(len <= 0 || (offset % PGSIZE) != 0)
    80005592:	fdc42783          	lw	a5,-36(s0)
    80005596:	0ef05463          	blez	a5,8000567e <sys_mmap+0x130>
    8000559a:	f426                	sd	s1,40(sp)
    8000559c:	fcc42703          	lw	a4,-52(s0)
    800055a0:	1752                	slli	a4,a4,0x34
    800055a2:	03475493          	srli	s1,a4,0x34
    return -1;
    800055a6:	57fd                	li	a5,-1
  if(len <= 0 || (offset % PGSIZE) != 0)
    800055a8:	e76d                	bnez	a4,80005692 <sys_mmap+0x144>
    800055aa:	f04a                	sd	s2,32(sp)

  // 권한 확인: 읽기 권한이 없는데 PROT_READ를 요청한 경우
  if(!f->readable && (prot & PROT_READ)) return -1;
    800055ac:	fc043783          	ld	a5,-64(s0)
    800055b0:	893e                	mv	s2,a5
    800055b2:	0087c783          	lbu	a5,8(a5)
    800055b6:	e791                	bnez	a5,800055c2 <sys_mmap+0x74>
    800055b8:	fd842703          	lw	a4,-40(s0)
    800055bc:	8b05                	andi	a4,a4,1
    800055be:	57fd                	li	a5,-1
    800055c0:	eb79                	bnez	a4,80005696 <sys_mmap+0x148>
  // 파일이 쓰기 불가능한데 PROT_WRITE + MAP_SHARED를 요청한 경우
  if(!f->writable && (prot & PROT_WRITE) && (flags == MAP_SHARED)) return -1;
    800055c2:	00994783          	lbu	a5,9(s2)
    800055c6:	eb91                	bnez	a5,800055da <sys_mmap+0x8c>
    800055c8:	fd842783          	lw	a5,-40(s0)
    800055cc:	8b89                	andi	a5,a5,2
    800055ce:	c791                	beqz	a5,800055da <sys_mmap+0x8c>
    800055d0:	fd442703          	lw	a4,-44(s0)
    800055d4:	4785                	li	a5,1
    800055d6:	0af70663          	beq	a4,a5,80005682 <sys_mmap+0x134>

  struct proc *p = myproc();
    800055da:	b4cfc0ef          	jal	80001926 <myproc>
  struct vma *v = 0;

  // 2. 비어있는 VMA 슬롯 찾기 [cite: 449]
  for(int i = 0; i < NVMA; i++) {
    800055de:	16850793          	addi	a5,a0,360
  struct proc *p = myproc();
    800055e2:	873e                	mv	a4,a5
  for(int i = 0; i < NVMA; i++) {
    800055e4:	4641                	li	a2,16
    if(p->vmas[i].used == 0) {
    800055e6:	4314                	lw	a3,0(a4)
    800055e8:	ca91                	beqz	a3,800055fc <sys_mmap+0xae>
  for(int i = 0; i < NVMA; i++) {
    800055ea:	2485                	addiw	s1,s1,1
    800055ec:	03070713          	addi	a4,a4,48
    800055f0:	fec49be3          	bne	s1,a2,800055e6 <sys_mmap+0x98>
      v = &p->vmas[i];
      break;
    }
  }
  if(!v) return -1; // 빈 슬롯이 없음
    800055f4:	57fd                	li	a5,-1
    800055f6:	74a2                	ld	s1,40(sp)
    800055f8:	7902                	ld	s2,32(sp)
    800055fa:	a8ad                	j	80005674 <sys_mmap+0x126>
      v = &p->vmas[i];
    800055fc:	00149713          	slli	a4,s1,0x1
    80005600:	94ba                	add	s1,s1,a4
    80005602:	0492                	slli	s1,s1,0x4
    80005604:	16848493          	addi	s1,s1,360
    80005608:	94aa                	add	s1,s1,a0
  if(!v) return -1; // 빈 슬롯이 없음
    8000560a:	c0c1                	beqz	s1,8000568a <sys_mmap+0x13c>
    8000560c:	46850613          	addi	a2,a0,1128

  // 3. TRAPFRAME 아래, p->sz 위의 사용하지 않는 가상 주소(VA) 공간 찾기 [cite: 386, 450]
  uint64 map_start = TRAPFRAME;
    80005610:	020006b7          	lui	a3,0x2000
    80005614:	16fd                	addi	a3,a3,-1 # 1ffffff <_entry-0x7e000001>
    80005616:	06b6                	slli	a3,a3,0xd
    80005618:	a029                	j	80005622 <sys_mmap+0xd4>
  for(int i = 0; i < NVMA; i++){
    8000561a:	03078793          	addi	a5,a5,48
    8000561e:	00c78963          	beq	a5,a2,80005630 <sys_mmap+0xe2>
    if(p->vmas[i].used && p->vmas[i].addr < map_start) {
    80005622:	4398                	lw	a4,0(a5)
    80005624:	db7d                	beqz	a4,8000561a <sys_mmap+0xcc>
    80005626:	6798                	ld	a4,8(a5)
    80005628:	fed779e3          	bgeu	a4,a3,8000561a <sys_mmap+0xcc>
    8000562c:	86ba                	mv	a3,a4
    8000562e:	b7f5                	j	8000561a <sys_mmap+0xcc>
      map_start = p->vmas[i].addr;
    }
  }
  map_start -= PGROUNDUP(len); // 페이지 크기 단위로 정렬
    80005630:	fdc42703          	lw	a4,-36(s0)
    80005634:	6785                	lui	a5,0x1
    80005636:	37fd                	addiw	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005638:	9fb9                	addw	a5,a5,a4
    8000563a:	777d                	lui	a4,0xfffff
    8000563c:	8ff9                	and	a5,a5,a4
    8000563e:	8e9d                	sub	a3,a3,a5
  if(map_start < p->sz) return -1; // 힙(heap) 영역과 겹치면 에러
    80005640:	6538                	ld	a4,72(a0)
    80005642:	57fd                	li	a5,-1
    80005644:	04e6ec63          	bltu	a3,a4,8000569c <sys_mmap+0x14e>

  // 4. VMA 구조체 채우기 및 파일 참조 횟수 증가 [cite: 451, 493]
  v->used = 1;
    80005648:	4785                	li	a5,1
    8000564a:	c09c                	sw	a5,0(s1)
  v->addr = map_start;
    8000564c:	e494                	sd	a3,8(s1)
  v->length = len;
    8000564e:	fdc42783          	lw	a5,-36(s0)
    80005652:	e89c                	sd	a5,16(s1)
  v->prot = prot;
    80005654:	fd842783          	lw	a5,-40(s0)
    80005658:	cc9c                	sw	a5,24(s1)
  v->flags = flags;
    8000565a:	fd442783          	lw	a5,-44(s0)
    8000565e:	ccdc                	sw	a5,28(s1)
  v->offset = offset;
    80005660:	fcc42783          	lw	a5,-52(s0)
    80005664:	d09c                	sw	a5,32(s1)
  v->f = filedup(f); 
    80005666:	854a                	mv	a0,s2
    80005668:	ae3fe0ef          	jal	8000414a <filedup>
    8000566c:	f488                	sd	a0,40(s1)

  return v->addr;
    8000566e:	649c                	ld	a5,8(s1)
    80005670:	74a2                	ld	s1,40(sp)
    80005672:	7902                	ld	s2,32(sp)
}
    80005674:	853e                	mv	a0,a5
    80005676:	70e2                	ld	ra,56(sp)
    80005678:	7442                	ld	s0,48(sp)
    8000567a:	6121                	addi	sp,sp,64
    8000567c:	8082                	ret
    return -1;
    8000567e:	57fd                	li	a5,-1
    80005680:	bfd5                	j	80005674 <sys_mmap+0x126>
  if(!f->writable && (prot & PROT_WRITE) && (flags == MAP_SHARED)) return -1;
    80005682:	57fd                	li	a5,-1
    80005684:	74a2                	ld	s1,40(sp)
    80005686:	7902                	ld	s2,32(sp)
    80005688:	b7f5                	j	80005674 <sys_mmap+0x126>
  if(!v) return -1; // 빈 슬롯이 없음
    8000568a:	57fd                	li	a5,-1
    8000568c:	74a2                	ld	s1,40(sp)
    8000568e:	7902                	ld	s2,32(sp)
    80005690:	b7d5                	j	80005674 <sys_mmap+0x126>
    80005692:	74a2                	ld	s1,40(sp)
    80005694:	b7c5                	j	80005674 <sys_mmap+0x126>
    80005696:	74a2                	ld	s1,40(sp)
    80005698:	7902                	ld	s2,32(sp)
    8000569a:	bfe9                	j	80005674 <sys_mmap+0x126>
    8000569c:	74a2                	ld	s1,40(sp)
    8000569e:	7902                	ld	s2,32(sp)
    800056a0:	bfd1                	j	80005674 <sys_mmap+0x126>

00000000800056a2 <mmapfault>:

int
mmapfault(uint64 va)
{
    800056a2:	7179                	addi	sp,sp,-48
    800056a4:	f406                	sd	ra,40(sp)
    800056a6:	f022                	sd	s0,32(sp)
    800056a8:	ec26                	sd	s1,24(sp)
    800056aa:	e44e                	sd	s3,8(sp)
    800056ac:	1800                	addi	s0,sp,48
    800056ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800056b0:	a76fc0ef          	jal	80001926 <myproc>
    800056b4:	89aa                	mv	s3,a0
  struct vma *v = 0;

  // 1. va를 포함하는 VMA 찾기 [cite: 458]
  for(int i = 0; i < NVMA; i++) {
    800056b6:	16850793          	addi	a5,a0,360
    800056ba:	4701                	li	a4,0
    800056bc:	4641                	li	a2,16
    800056be:	a031                	j	800056ca <mmapfault+0x28>
    800056c0:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd2489>
    800056c2:	03078793          	addi	a5,a5,48
    800056c6:	0ac70f63          	beq	a4,a2,80005784 <mmapfault+0xe2>
    if(p->vmas[i].used && va >= p->vmas[i].addr && va < p->vmas[i].addr + p->vmas[i].length) {
    800056ca:	4394                	lw	a3,0(a5)
    800056cc:	daf5                	beqz	a3,800056c0 <mmapfault+0x1e>
    800056ce:	6794                	ld	a3,8(a5)
    800056d0:	fed4e8e3          	bltu	s1,a3,800056c0 <mmapfault+0x1e>
    800056d4:	6b8c                	ld	a1,16(a5)
    800056d6:	96ae                	add	a3,a3,a1
    800056d8:	fed4f4e3          	bgeu	s1,a3,800056c0 <mmapfault+0x1e>
    800056dc:	e84a                	sd	s2,16(sp)
      v = &p->vmas[i];
    800056de:	00171913          	slli	s2,a4,0x1
    800056e2:	993a                	add	s2,s2,a4
    800056e4:	0912                	slli	s2,s2,0x4
    800056e6:	16890913          	addi	s2,s2,360
    800056ea:	994e                	add	s2,s2,s3
      break;
    }
  }
  if(!v) return -1;
    800056ec:	0a090563          	beqz	s2,80005796 <mmapfault+0xf4>
    800056f0:	e052                	sd	s4,0(sp)

  // 이미 할당된 페이지에 다시 폴트가 발생한 경우 (권한 오류) [cite: 495]
  uint64 va_align = PGROUNDDOWN(va);
    800056f2:	7a7d                	lui	s4,0xfffff
    800056f4:	0144fa33          	and	s4,s1,s4
  if(walkaddr(p->pagetable, va_align) != 0) return -1;
    800056f8:	85d2                	mv	a1,s4
    800056fa:	0509b503          	ld	a0,80(s3)
    800056fe:	929fb0ef          	jal	80001026 <walkaddr>
    80005702:	ed49                	bnez	a0,8000579c <mmapfault+0xfa>

  // 2. 물리 페이지 할당 및 0으로 초기화 [cite: 459]
  char *mem = kalloc();
    80005704:	c40fb0ef          	jal	80000b44 <kalloc>
    80005708:	84aa                	mv	s1,a0
  if(!mem) return -1;
    8000570a:	cd49                	beqz	a0,800057a4 <mmapfault+0x102>
  memset(mem, 0, PGSIZE);
    8000570c:	6605                	lui	a2,0x1
    8000570e:	4581                	li	a1,0
    80005710:	de8fb0ef          	jal	80000cf8 <memset>

  // 3. 파일 데이터를 할당된 페이지로 읽기 [cite: 460, 461]
  ilock(v->f->ip);
    80005714:	02893783          	ld	a5,40(s2)
    80005718:	6f88                	ld	a0,24(a5)
    8000571a:	c47fd0ef          	jal	80003360 <ilock>
  int read_offset = v->offset + (va_align - v->addr);
    8000571e:	02092783          	lw	a5,32(s2)
    80005722:	014787bb          	addw	a5,a5,s4
    80005726:	00893683          	ld	a3,8(s2)
  readi(v->f->ip, 0, (uint64)mem, read_offset, PGSIZE);
    8000572a:	02893503          	ld	a0,40(s2)
    8000572e:	6705                	lui	a4,0x1
    80005730:	40d786bb          	subw	a3,a5,a3
    80005734:	8626                	mv	a2,s1
    80005736:	4581                	li	a1,0
    80005738:	6d08                	ld	a0,24(a0)
    8000573a:	fb9fd0ef          	jal	800036f2 <readi>
  iunlock(v->f->ip);
    8000573e:	02893783          	ld	a5,40(s2)
    80005742:	6f88                	ld	a0,24(a5)
    80005744:	ccbfd0ef          	jal	8000340e <iunlock>

  // 4. PROT 플래그를 PTE 플래그로 변환 [cite: 462, 491, 492]
  int perm = PTE_U;
  if(v->prot & PROT_READ) perm |= PTE_R;
    80005748:	01892783          	lw	a5,24(s2)
    8000574c:	0017f693          	andi	a3,a5,1
    80005750:	4749                	li	a4,18
    80005752:	e291                	bnez	a3,80005756 <mmapfault+0xb4>
  int perm = PTE_U;
    80005754:	4741                	li	a4,16
  if(v->prot & PROT_WRITE) perm |= PTE_W;
    80005756:	8b89                	andi	a5,a5,2
    80005758:	c399                	beqz	a5,8000575e <mmapfault+0xbc>
    8000575a:	00476713          	ori	a4,a4,4

  // 매핑 수행
  if(mappages(p->pagetable, va_align, PGSIZE, (uint64)mem, perm) < 0) {
    8000575e:	86a6                	mv	a3,s1
    80005760:	6605                	lui	a2,0x1
    80005762:	85d2                	mv	a1,s4
    80005764:	0509b503          	ld	a0,80(s3)
    80005768:	8f9fb0ef          	jal	80001060 <mappages>
    8000576c:	87aa                	mv	a5,a0
    return -1;
  }
  
  // 5. 성공 시 명세에 따라 물리 주소(또는 성공을 의미하는 0) 반환 [cite: 463]
  // (스켈레톤 리턴 타입이 int이므로, xv6 관례상 0을 반환합니다)
  return 0;
    8000576e:	4501                	li	a0,0
  if(mappages(p->pagetable, va_align, PGSIZE, (uint64)mem, perm) < 0) {
    80005770:	0007cc63          	bltz	a5,80005788 <mmapfault+0xe6>
    80005774:	6942                	ld	s2,16(sp)
    80005776:	6a02                	ld	s4,0(sp)
}
    80005778:	70a2                	ld	ra,40(sp)
    8000577a:	7402                	ld	s0,32(sp)
    8000577c:	64e2                	ld	s1,24(sp)
    8000577e:	69a2                	ld	s3,8(sp)
    80005780:	6145                	addi	sp,sp,48
    80005782:	8082                	ret
  if(!v) return -1;
    80005784:	557d                	li	a0,-1
    80005786:	bfcd                	j	80005778 <mmapfault+0xd6>
    kfree(mem);
    80005788:	8526                	mv	a0,s1
    8000578a:	ad2fb0ef          	jal	80000a5c <kfree>
    return -1;
    8000578e:	557d                	li	a0,-1
    80005790:	6942                	ld	s2,16(sp)
    80005792:	6a02                	ld	s4,0(sp)
    80005794:	b7d5                	j	80005778 <mmapfault+0xd6>
  if(!v) return -1;
    80005796:	557d                	li	a0,-1
    80005798:	6942                	ld	s2,16(sp)
    8000579a:	bff9                	j	80005778 <mmapfault+0xd6>
  if(walkaddr(p->pagetable, va_align) != 0) return -1;
    8000579c:	557d                	li	a0,-1
    8000579e:	6942                	ld	s2,16(sp)
    800057a0:	6a02                	ld	s4,0(sp)
    800057a2:	bfd9                	j	80005778 <mmapfault+0xd6>
  if(!mem) return -1;
    800057a4:	557d                	li	a0,-1
    800057a6:	6942                	ld	s2,16(sp)
    800057a8:	6a02                	ld	s4,0(sp)
    800057aa:	b7f9                	j	80005778 <mmapfault+0xd6>

00000000800057ac <sys_munmap>:

uint64
sys_munmap(void)
{
    800057ac:	711d                	addi	sp,sp,-96
    800057ae:	ec86                	sd	ra,88(sp)
    800057b0:	e8a2                	sd	s0,80(sp)
    800057b2:	e4a6                	sd	s1,72(sp)
    800057b4:	f852                	sd	s4,48(sp)
    800057b6:	1080                	addi	s0,sp,96
  uint64 addr;
  int length;
  
  // 1. 인자 가져오기
  argaddr(0, &addr);
    800057b8:	fa840593          	addi	a1,s0,-88
    800057bc:	4501                	li	a0,0
    800057be:	9f4fd0ef          	jal	800029b2 <argaddr>
  argint(1, &length);
    800057c2:	fa440593          	addi	a1,s0,-92
    800057c6:	4505                	li	a0,1
    800057c8:	9cefd0ef          	jal	80002996 <argint>

  struct proc *p = myproc();
    800057cc:	95afc0ef          	jal	80001926 <myproc>
    800057d0:	8a2a                	mv	s4,a0
  struct vma *v = 0;

  for(int i = 0; i < NVMA; i++) {
    if(p->vmas[i].used && addr >= p->vmas[i].addr && addr < p->vmas[i].addr + p->vmas[i].length) {
    800057d2:	fa843483          	ld	s1,-88(s0)
    800057d6:	16850793          	addi	a5,a0,360
  for(int i = 0; i < NVMA; i++) {
    800057da:	4701                	li	a4,0
    800057dc:	4641                	li	a2,16
    800057de:	a031                	j	800057ea <sys_munmap+0x3e>
    800057e0:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    800057e2:	03078793          	addi	a5,a5,48
    800057e6:	04c70b63          	beq	a4,a2,8000583c <sys_munmap+0x90>
    if(p->vmas[i].used && addr >= p->vmas[i].addr && addr < p->vmas[i].addr + p->vmas[i].length) {
    800057ea:	4394                	lw	a3,0(a5)
    800057ec:	daf5                	beqz	a3,800057e0 <sys_munmap+0x34>
    800057ee:	6794                	ld	a3,8(a5)
    800057f0:	fed4e8e3          	bltu	s1,a3,800057e0 <sys_munmap+0x34>
    800057f4:	6b8c                	ld	a1,16(a5)
    800057f6:	96ae                	add	a3,a3,a1
    800057f8:	fed4f4e3          	bgeu	s1,a3,800057e0 <sys_munmap+0x34>
    800057fc:	fc4e                	sd	s3,56(sp)
      v = &p->vmas[i];
    800057fe:	00171993          	slli	s3,a4,0x1
    80005802:	99ba                	add	s3,s3,a4
    80005804:	0992                	slli	s3,s3,0x4
    80005806:	16898993          	addi	s3,s3,360
    8000580a:	99d2                	add	s3,s3,s4
      break;
    }
  }
  if(!v) return -1;
    8000580c:	10098763          	beqz	s3,8000591a <sys_munmap+0x16e>
    80005810:	f456                	sd	s5,40(sp)

  // 범위 중간에 구멍을 뚫는 unmap은 거부 [cite: 419, 473]
  if(addr != v->addr && addr + length != v->addr + v->length)
    80005812:	0089b783          	ld	a5,8(s3)
    80005816:	10f48563          	beq	s1,a5,80005920 <sys_munmap+0x174>
    8000581a:	fa442a83          	lw	s5,-92(s0)
    8000581e:	9aa6                	add	s5,s5,s1
    80005820:	0109b703          	ld	a4,16(s3)
    80005824:	97ba                	add	a5,a5,a4
    return -1;
    80005826:	557d                	li	a0,-1
  if(addr != v->addr && addr + length != v->addr + v->length)
    80005828:	10fa9263          	bne	s5,a5,8000592c <sys_munmap+0x180>

  uint64 va = addr;
  uint64 end = addr + length;
  
  // 1. 페이지 해제 및 MAP_SHARED인 경우 write-back [cite: 469]
  while(va < end) {
    8000582c:	0954fa63          	bgeu	s1,s5,800058c0 <sys_munmap+0x114>
    80005830:	e0ca                	sd	s2,64(sp)
    80005832:	f05a                	sd	s6,32(sp)
    80005834:	ec5e                	sd	s7,24(sp)
    uint64 pa = walkaddr(p->pagetable, va);
    if(pa != 0) { // 페이지가 실제로 매핑되어 있는 경우에만 [cite: 470]
      if(v->flags == MAP_SHARED) {
    80005836:	4b05                	li	s6,1
        iunlock(v->f->ip);
        end_op();
      }
      uvmunmap(p->pagetable, va, 1, 1);
    }
    va += PGSIZE;
    80005838:	6b85                	lui	s7,0x1
    8000583a:	a015                	j	8000585e <sys_munmap+0xb2>
  if(!v) return -1;
    8000583c:	557d                	li	a0,-1
  } else {
    v->length -= length;
  }

  return 0;
}
    8000583e:	60e6                	ld	ra,88(sp)
    80005840:	6446                	ld	s0,80(sp)
    80005842:	64a6                	ld	s1,72(sp)
    80005844:	7a42                	ld	s4,48(sp)
    80005846:	6125                	addi	sp,sp,96
    80005848:	8082                	ret
      uvmunmap(p->pagetable, va, 1, 1);
    8000584a:	86da                	mv	a3,s6
    8000584c:	865a                	mv	a2,s6
    8000584e:	85a6                	mv	a1,s1
    80005850:	050a3503          	ld	a0,80(s4) # fffffffffffff050 <end+0xffffffff7ffd24d8>
    80005854:	9dbfb0ef          	jal	8000122e <uvmunmap>
    va += PGSIZE;
    80005858:	94de                	add	s1,s1,s7
  while(va < end) {
    8000585a:	0554fa63          	bgeu	s1,s5,800058ae <sys_munmap+0x102>
    uint64 pa = walkaddr(p->pagetable, va);
    8000585e:	85a6                	mv	a1,s1
    80005860:	050a3503          	ld	a0,80(s4)
    80005864:	fc2fb0ef          	jal	80001026 <walkaddr>
    80005868:	892a                	mv	s2,a0
    if(pa != 0) { // 페이지가 실제로 매핑되어 있는 경우에만 [cite: 470]
    8000586a:	d57d                	beqz	a0,80005858 <sys_munmap+0xac>
      if(v->flags == MAP_SHARED) {
    8000586c:	01c9a783          	lw	a5,28(s3)
    80005870:	fd679de3          	bne	a5,s6,8000584a <sys_munmap+0x9e>
        begin_op();
    80005874:	cf8fe0ef          	jal	80003d6c <begin_op>
        ilock(v->f->ip);
    80005878:	0289b783          	ld	a5,40(s3)
    8000587c:	6f88                	ld	a0,24(a5)
    8000587e:	ae3fd0ef          	jal	80003360 <ilock>
        writei(v->f->ip, 0, pa, v->offset + (va - v->addr), PGSIZE);
    80005882:	0089b783          	ld	a5,8(s3)
    80005886:	0209a683          	lw	a3,32(s3)
    8000588a:	9e9d                	subw	a3,a3,a5
    8000588c:	0289b783          	ld	a5,40(s3)
    80005890:	6705                	lui	a4,0x1
    80005892:	9ea5                	addw	a3,a3,s1
    80005894:	864a                	mv	a2,s2
    80005896:	4581                	li	a1,0
    80005898:	6f88                	ld	a0,24(a5)
    8000589a:	f4bfd0ef          	jal	800037e4 <writei>
        iunlock(v->f->ip);
    8000589e:	0289b783          	ld	a5,40(s3)
    800058a2:	6f88                	ld	a0,24(a5)
    800058a4:	b6bfd0ef          	jal	8000340e <iunlock>
        end_op();
    800058a8:	d34fe0ef          	jal	80003ddc <end_op>
    800058ac:	bf79                	j	8000584a <sys_munmap+0x9e>
  if(addr == v->addr && length == v->length) {
    800058ae:	fa843783          	ld	a5,-88(s0)
    800058b2:	0089b703          	ld	a4,8(s3)
    800058b6:	02f70063          	beq	a4,a5,800058d6 <sys_munmap+0x12a>
    800058ba:	6906                	ld	s2,64(sp)
    800058bc:	7b02                	ld	s6,32(sp)
    800058be:	6be2                	ld	s7,24(sp)
    v->length -= length;
    800058c0:	fa442703          	lw	a4,-92(s0)
    800058c4:	0109b783          	ld	a5,16(s3)
    800058c8:	8f99                	sub	a5,a5,a4
    800058ca:	00f9b823          	sd	a5,16(s3)
  return 0;
    800058ce:	4501                	li	a0,0
    800058d0:	79e2                	ld	s3,56(sp)
    800058d2:	7aa2                	ld	s5,40(sp)
    800058d4:	b7ad                	j	8000583e <sys_munmap+0x92>
    800058d6:	6906                	ld	s2,64(sp)
    800058d8:	7b02                	ld	s6,32(sp)
    800058da:	6be2                	ld	s7,24(sp)
  if(addr == v->addr && length == v->length) {
    800058dc:	fa442703          	lw	a4,-92(s0)
    800058e0:	0109b683          	ld	a3,16(s3)
    800058e4:	02d70163          	beq	a4,a3,80005906 <sys_munmap+0x15a>
    v->addr += length;
    800058e8:	97ba                	add	a5,a5,a4
    800058ea:	00f9b423          	sd	a5,8(s3)
    v->length -= length;
    800058ee:	8e99                	sub	a3,a3,a4
    800058f0:	00d9b823          	sd	a3,16(s3)
    v->offset += length;
    800058f4:	0209a783          	lw	a5,32(s3)
    800058f8:	9fb9                	addw	a5,a5,a4
    800058fa:	02f9a023          	sw	a5,32(s3)
  return 0;
    800058fe:	4501                	li	a0,0
    80005900:	79e2                	ld	s3,56(sp)
    80005902:	7aa2                	ld	s5,40(sp)
    80005904:	bf2d                	j	8000583e <sys_munmap+0x92>
    fileclose(v->f);
    80005906:	0289b503          	ld	a0,40(s3)
    8000590a:	887fe0ef          	jal	80004190 <fileclose>
    v->used = 0;
    8000590e:	0009a023          	sw	zero,0(s3)
  return 0;
    80005912:	4501                	li	a0,0
    v->used = 0;
    80005914:	79e2                	ld	s3,56(sp)
    80005916:	7aa2                	ld	s5,40(sp)
    80005918:	b71d                	j	8000583e <sys_munmap+0x92>
  if(!v) return -1;
    8000591a:	557d                	li	a0,-1
    8000591c:	79e2                	ld	s3,56(sp)
    8000591e:	b705                	j	8000583e <sys_munmap+0x92>
  uint64 end = addr + length;
    80005920:	fa442a83          	lw	s5,-92(s0)
    80005924:	9aa6                	add	s5,s5,s1
  while(va < end) {
    80005926:	f154e5e3          	bltu	s1,s5,80005830 <sys_munmap+0x84>
    8000592a:	bf4d                	j	800058dc <sys_munmap+0x130>
    8000592c:	79e2                	ld	s3,56(sp)
    8000592e:	7aa2                	ld	s5,40(sp)
    80005930:	b739                	j	8000583e <sys_munmap+0x92>
	...

0000000080005940 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005940:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005942:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005944:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005946:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005948:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000594a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000594c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000594e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005950:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005952:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005954:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005956:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005958:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000595a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000595c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000595e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005960:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005962:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005964:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005966:	eb5fc0ef          	jal	8000281a <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000596a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000596c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000596e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005970:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005972:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005974:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005976:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005978:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000597a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000597c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000597e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005980:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005982:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005984:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005986:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005988:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000598a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000598c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000598e:	10200073          	sret
    80005992:	00000013          	nop
    80005996:	00000013          	nop
    8000599a:	00000013          	nop

000000008000599e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000599e:	1141                	addi	sp,sp,-16
    800059a0:	e406                	sd	ra,8(sp)
    800059a2:	e022                	sd	s0,0(sp)
    800059a4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800059a6:	0c000737          	lui	a4,0xc000
    800059aa:	4785                	li	a5,1
    800059ac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800059ae:	c35c                	sw	a5,4(a4)
}
    800059b0:	60a2                	ld	ra,8(sp)
    800059b2:	6402                	ld	s0,0(sp)
    800059b4:	0141                	addi	sp,sp,16
    800059b6:	8082                	ret

00000000800059b8 <plicinithart>:

void
plicinithart(void)
{
    800059b8:	1141                	addi	sp,sp,-16
    800059ba:	e406                	sd	ra,8(sp)
    800059bc:	e022                	sd	s0,0(sp)
    800059be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800059c0:	f33fb0ef          	jal	800018f2 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800059c4:	0085171b          	slliw	a4,a0,0x8
    800059c8:	0c0027b7          	lui	a5,0xc002
    800059cc:	97ba                	add	a5,a5,a4
    800059ce:	40200713          	li	a4,1026
    800059d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800059d6:	00d5151b          	slliw	a0,a0,0xd
    800059da:	0c2017b7          	lui	a5,0xc201
    800059de:	97aa                	add	a5,a5,a0
    800059e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800059e4:	60a2                	ld	ra,8(sp)
    800059e6:	6402                	ld	s0,0(sp)
    800059e8:	0141                	addi	sp,sp,16
    800059ea:	8082                	ret

00000000800059ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800059ec:	1141                	addi	sp,sp,-16
    800059ee:	e406                	sd	ra,8(sp)
    800059f0:	e022                	sd	s0,0(sp)
    800059f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800059f4:	efffb0ef          	jal	800018f2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800059f8:	00d5151b          	slliw	a0,a0,0xd
    800059fc:	0c2017b7          	lui	a5,0xc201
    80005a00:	97aa                	add	a5,a5,a0
  return irq;
}
    80005a02:	43c8                	lw	a0,4(a5)
    80005a04:	60a2                	ld	ra,8(sp)
    80005a06:	6402                	ld	s0,0(sp)
    80005a08:	0141                	addi	sp,sp,16
    80005a0a:	8082                	ret

0000000080005a0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005a0c:	1101                	addi	sp,sp,-32
    80005a0e:	ec06                	sd	ra,24(sp)
    80005a10:	e822                	sd	s0,16(sp)
    80005a12:	e426                	sd	s1,8(sp)
    80005a14:	1000                	addi	s0,sp,32
    80005a16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005a18:	edbfb0ef          	jal	800018f2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005a1c:	00d5179b          	slliw	a5,a0,0xd
    80005a20:	0c201737          	lui	a4,0xc201
    80005a24:	97ba                	add	a5,a5,a4
    80005a26:	c3c4                	sw	s1,4(a5)
}
    80005a28:	60e2                	ld	ra,24(sp)
    80005a2a:	6442                	ld	s0,16(sp)
    80005a2c:	64a2                	ld	s1,8(sp)
    80005a2e:	6105                	addi	sp,sp,32
    80005a30:	8082                	ret

0000000080005a32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005a32:	1141                	addi	sp,sp,-16
    80005a34:	e406                	sd	ra,8(sp)
    80005a36:	e022                	sd	s0,0(sp)
    80005a38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005a3a:	479d                	li	a5,7
    80005a3c:	04a7ca63          	blt	a5,a0,80005a90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005a40:	00027797          	auipc	a5,0x27
    80005a44:	ff878793          	addi	a5,a5,-8 # 8002ca38 <disk>
    80005a48:	97aa                	add	a5,a5,a0
    80005a4a:	0187c783          	lbu	a5,24(a5)
    80005a4e:	e7b9                	bnez	a5,80005a9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005a50:	00451693          	slli	a3,a0,0x4
    80005a54:	00027797          	auipc	a5,0x27
    80005a58:	fe478793          	addi	a5,a5,-28 # 8002ca38 <disk>
    80005a5c:	6398                	ld	a4,0(a5)
    80005a5e:	9736                	add	a4,a4,a3
    80005a60:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005a64:	6398                	ld	a4,0(a5)
    80005a66:	9736                	add	a4,a4,a3
    80005a68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005a6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005a70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005a74:	97aa                	add	a5,a5,a0
    80005a76:	4705                	li	a4,1
    80005a78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005a7c:	00027517          	auipc	a0,0x27
    80005a80:	fd450513          	addi	a0,a0,-44 # 8002ca50 <disk+0x18>
    80005a84:	d60fc0ef          	jal	80001fe4 <wakeup>
}
    80005a88:	60a2                	ld	ra,8(sp)
    80005a8a:	6402                	ld	s0,0(sp)
    80005a8c:	0141                	addi	sp,sp,16
    80005a8e:	8082                	ret
    panic("free_desc 1");
    80005a90:	00002517          	auipc	a0,0x2
    80005a94:	b8050513          	addi	a0,a0,-1152 # 80007610 <etext+0x610>
    80005a98:	d8dfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    80005a9c:	00002517          	auipc	a0,0x2
    80005aa0:	b8450513          	addi	a0,a0,-1148 # 80007620 <etext+0x620>
    80005aa4:	d81fa0ef          	jal	80000824 <panic>

0000000080005aa8 <virtio_disk_init>:
{
    80005aa8:	1101                	addi	sp,sp,-32
    80005aaa:	ec06                	sd	ra,24(sp)
    80005aac:	e822                	sd	s0,16(sp)
    80005aae:	e426                	sd	s1,8(sp)
    80005ab0:	e04a                	sd	s2,0(sp)
    80005ab2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005ab4:	00002597          	auipc	a1,0x2
    80005ab8:	b7c58593          	addi	a1,a1,-1156 # 80007630 <etext+0x630>
    80005abc:	00027517          	auipc	a0,0x27
    80005ac0:	0a450513          	addi	a0,a0,164 # 8002cb60 <disk+0x128>
    80005ac4:	8dafb0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ac8:	100017b7          	lui	a5,0x10001
    80005acc:	4398                	lw	a4,0(a5)
    80005ace:	2701                	sext.w	a4,a4
    80005ad0:	747277b7          	lui	a5,0x74727
    80005ad4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005ad8:	14f71863          	bne	a4,a5,80005c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005adc:	100017b7          	lui	a5,0x10001
    80005ae0:	43dc                	lw	a5,4(a5)
    80005ae2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ae4:	4709                	li	a4,2
    80005ae6:	14e79163          	bne	a5,a4,80005c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005aea:	100017b7          	lui	a5,0x10001
    80005aee:	479c                	lw	a5,8(a5)
    80005af0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005af2:	12e79b63          	bne	a5,a4,80005c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005af6:	100017b7          	lui	a5,0x10001
    80005afa:	47d8                	lw	a4,12(a5)
    80005afc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005afe:	554d47b7          	lui	a5,0x554d4
    80005b02:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005b06:	12f71163          	bne	a4,a5,80005c28 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b0a:	100017b7          	lui	a5,0x10001
    80005b0e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b12:	4705                	li	a4,1
    80005b14:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b16:	470d                	li	a4,3
    80005b18:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005b1a:	10001737          	lui	a4,0x10001
    80005b1e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005b20:	c7ffe6b7          	lui	a3,0xc7ffe
    80005b24:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd1be7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005b28:	8f75                	and	a4,a4,a3
    80005b2a:	100016b7          	lui	a3,0x10001
    80005b2e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b30:	472d                	li	a4,11
    80005b32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b34:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005b38:	439c                	lw	a5,0(a5)
    80005b3a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005b3e:	8ba1                	andi	a5,a5,8
    80005b40:	0e078a63          	beqz	a5,80005c34 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005b44:	100017b7          	lui	a5,0x10001
    80005b48:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005b4c:	43fc                	lw	a5,68(a5)
    80005b4e:	2781                	sext.w	a5,a5
    80005b50:	0e079863          	bnez	a5,80005c40 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005b54:	100017b7          	lui	a5,0x10001
    80005b58:	5bdc                	lw	a5,52(a5)
    80005b5a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005b5c:	0e078863          	beqz	a5,80005c4c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005b60:	471d                	li	a4,7
    80005b62:	0ef77b63          	bgeu	a4,a5,80005c58 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005b66:	fdffa0ef          	jal	80000b44 <kalloc>
    80005b6a:	00027497          	auipc	s1,0x27
    80005b6e:	ece48493          	addi	s1,s1,-306 # 8002ca38 <disk>
    80005b72:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005b74:	fd1fa0ef          	jal	80000b44 <kalloc>
    80005b78:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005b7a:	fcbfa0ef          	jal	80000b44 <kalloc>
    80005b7e:	87aa                	mv	a5,a0
    80005b80:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005b82:	6088                	ld	a0,0(s1)
    80005b84:	0e050063          	beqz	a0,80005c64 <virtio_disk_init+0x1bc>
    80005b88:	00027717          	auipc	a4,0x27
    80005b8c:	eb873703          	ld	a4,-328(a4) # 8002ca40 <disk+0x8>
    80005b90:	cb71                	beqz	a4,80005c64 <virtio_disk_init+0x1bc>
    80005b92:	cbe9                	beqz	a5,80005c64 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005b94:	6605                	lui	a2,0x1
    80005b96:	4581                	li	a1,0
    80005b98:	960fb0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005b9c:	00027497          	auipc	s1,0x27
    80005ba0:	e9c48493          	addi	s1,s1,-356 # 8002ca38 <disk>
    80005ba4:	6605                	lui	a2,0x1
    80005ba6:	4581                	li	a1,0
    80005ba8:	6488                	ld	a0,8(s1)
    80005baa:	94efb0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005bae:	6605                	lui	a2,0x1
    80005bb0:	4581                	li	a1,0
    80005bb2:	6888                	ld	a0,16(s1)
    80005bb4:	944fb0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005bb8:	100017b7          	lui	a5,0x10001
    80005bbc:	4721                	li	a4,8
    80005bbe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005bc0:	4098                	lw	a4,0(s1)
    80005bc2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005bc6:	40d8                	lw	a4,4(s1)
    80005bc8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005bcc:	649c                	ld	a5,8(s1)
    80005bce:	0007869b          	sext.w	a3,a5
    80005bd2:	10001737          	lui	a4,0x10001
    80005bd6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005bda:	9781                	srai	a5,a5,0x20
    80005bdc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005be0:	689c                	ld	a5,16(s1)
    80005be2:	0007869b          	sext.w	a3,a5
    80005be6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005bea:	9781                	srai	a5,a5,0x20
    80005bec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005bf0:	4785                	li	a5,1
    80005bf2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005bf4:	00f48c23          	sb	a5,24(s1)
    80005bf8:	00f48ca3          	sb	a5,25(s1)
    80005bfc:	00f48d23          	sb	a5,26(s1)
    80005c00:	00f48da3          	sb	a5,27(s1)
    80005c04:	00f48e23          	sb	a5,28(s1)
    80005c08:	00f48ea3          	sb	a5,29(s1)
    80005c0c:	00f48f23          	sb	a5,30(s1)
    80005c10:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005c14:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005c18:	07272823          	sw	s2,112(a4)
}
    80005c1c:	60e2                	ld	ra,24(sp)
    80005c1e:	6442                	ld	s0,16(sp)
    80005c20:	64a2                	ld	s1,8(sp)
    80005c22:	6902                	ld	s2,0(sp)
    80005c24:	6105                	addi	sp,sp,32
    80005c26:	8082                	ret
    panic("could not find virtio disk");
    80005c28:	00002517          	auipc	a0,0x2
    80005c2c:	a1850513          	addi	a0,a0,-1512 # 80007640 <etext+0x640>
    80005c30:	bf5fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005c34:	00002517          	auipc	a0,0x2
    80005c38:	a2c50513          	addi	a0,a0,-1492 # 80007660 <etext+0x660>
    80005c3c:	be9fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005c40:	00002517          	auipc	a0,0x2
    80005c44:	a4050513          	addi	a0,a0,-1472 # 80007680 <etext+0x680>
    80005c48:	bddfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    80005c4c:	00002517          	auipc	a0,0x2
    80005c50:	a5450513          	addi	a0,a0,-1452 # 800076a0 <etext+0x6a0>
    80005c54:	bd1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005c58:	00002517          	auipc	a0,0x2
    80005c5c:	a6850513          	addi	a0,a0,-1432 # 800076c0 <etext+0x6c0>
    80005c60:	bc5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005c64:	00002517          	auipc	a0,0x2
    80005c68:	a7c50513          	addi	a0,a0,-1412 # 800076e0 <etext+0x6e0>
    80005c6c:	bb9fa0ef          	jal	80000824 <panic>

0000000080005c70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005c70:	711d                	addi	sp,sp,-96
    80005c72:	ec86                	sd	ra,88(sp)
    80005c74:	e8a2                	sd	s0,80(sp)
    80005c76:	e4a6                	sd	s1,72(sp)
    80005c78:	e0ca                	sd	s2,64(sp)
    80005c7a:	fc4e                	sd	s3,56(sp)
    80005c7c:	f852                	sd	s4,48(sp)
    80005c7e:	f456                	sd	s5,40(sp)
    80005c80:	f05a                	sd	s6,32(sp)
    80005c82:	ec5e                	sd	s7,24(sp)
    80005c84:	e862                	sd	s8,16(sp)
    80005c86:	1080                	addi	s0,sp,96
    80005c88:	89aa                	mv	s3,a0
    80005c8a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005c8c:	00c52b83          	lw	s7,12(a0)
    80005c90:	001b9b9b          	slliw	s7,s7,0x1
    80005c94:	1b82                	slli	s7,s7,0x20
    80005c96:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005c9a:	00027517          	auipc	a0,0x27
    80005c9e:	ec650513          	addi	a0,a0,-314 # 8002cb60 <disk+0x128>
    80005ca2:	f87fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005ca6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ca8:	00027a97          	auipc	s5,0x27
    80005cac:	d90a8a93          	addi	s5,s5,-624 # 8002ca38 <disk>
  for(int i = 0; i < 3; i++){
    80005cb0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005cb2:	5c7d                	li	s8,-1
    80005cb4:	a095                	j	80005d18 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005cb6:	00fa8733          	add	a4,s5,a5
    80005cba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005cbe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005cc0:	0207c563          	bltz	a5,80005cea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005cc4:	2905                	addiw	s2,s2,1
    80005cc6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005cc8:	05490c63          	beq	s2,s4,80005d20 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005ccc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005cce:	00027717          	auipc	a4,0x27
    80005cd2:	d6a70713          	addi	a4,a4,-662 # 8002ca38 <disk>
    80005cd6:	4781                	li	a5,0
    if(disk.free[i]){
    80005cd8:	01874683          	lbu	a3,24(a4)
    80005cdc:	fee9                	bnez	a3,80005cb6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005cde:	2785                	addiw	a5,a5,1
    80005ce0:	0705                	addi	a4,a4,1
    80005ce2:	fe979be3          	bne	a5,s1,80005cd8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005ce6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005cea:	01205d63          	blez	s2,80005d04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005cee:	fa042503          	lw	a0,-96(s0)
    80005cf2:	d41ff0ef          	jal	80005a32 <free_desc>
      for(int j = 0; j < i; j++)
    80005cf6:	4785                	li	a5,1
    80005cf8:	0127d663          	bge	a5,s2,80005d04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005cfc:	fa442503          	lw	a0,-92(s0)
    80005d00:	d33ff0ef          	jal	80005a32 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005d04:	00027597          	auipc	a1,0x27
    80005d08:	e5c58593          	addi	a1,a1,-420 # 8002cb60 <disk+0x128>
    80005d0c:	00027517          	auipc	a0,0x27
    80005d10:	d4450513          	addi	a0,a0,-700 # 8002ca50 <disk+0x18>
    80005d14:	a84fc0ef          	jal	80001f98 <sleep>
  for(int i = 0; i < 3; i++){
    80005d18:	fa040613          	addi	a2,s0,-96
    80005d1c:	4901                	li	s2,0
    80005d1e:	b77d                	j	80005ccc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005d20:	fa042503          	lw	a0,-96(s0)
    80005d24:	00451693          	slli	a3,a0,0x4

  if(write)
    80005d28:	00027797          	auipc	a5,0x27
    80005d2c:	d1078793          	addi	a5,a5,-752 # 8002ca38 <disk>
    80005d30:	00451713          	slli	a4,a0,0x4
    80005d34:	0a070713          	addi	a4,a4,160
    80005d38:	973e                	add	a4,a4,a5
    80005d3a:	01603633          	snez	a2,s6
    80005d3e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005d40:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005d44:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005d48:	6398                	ld	a4,0(a5)
    80005d4a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005d4c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005d50:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005d52:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005d54:	6390                	ld	a2,0(a5)
    80005d56:	00d60833          	add	a6,a2,a3
    80005d5a:	4741                	li	a4,16
    80005d5c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005d60:	4585                	li	a1,1
    80005d62:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005d66:	fa442703          	lw	a4,-92(s0)
    80005d6a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005d6e:	0712                	slli	a4,a4,0x4
    80005d70:	963a                	add	a2,a2,a4
    80005d72:	05898813          	addi	a6,s3,88
    80005d76:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005d7a:	0007b883          	ld	a7,0(a5)
    80005d7e:	9746                	add	a4,a4,a7
    80005d80:	40000613          	li	a2,1024
    80005d84:	c710                	sw	a2,8(a4)
  if(write)
    80005d86:	001b3613          	seqz	a2,s6
    80005d8a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005d8e:	8e4d                	or	a2,a2,a1
    80005d90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005d94:	fa842603          	lw	a2,-88(s0)
    80005d98:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005d9c:	00451813          	slli	a6,a0,0x4
    80005da0:	02080813          	addi	a6,a6,32
    80005da4:	983e                	add	a6,a6,a5
    80005da6:	577d                	li	a4,-1
    80005da8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005dac:	0612                	slli	a2,a2,0x4
    80005dae:	98b2                	add	a7,a7,a2
    80005db0:	03068713          	addi	a4,a3,48
    80005db4:	973e                	add	a4,a4,a5
    80005db6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005dba:	6398                	ld	a4,0(a5)
    80005dbc:	9732                	add	a4,a4,a2
    80005dbe:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005dc0:	4689                	li	a3,2
    80005dc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005dc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005dca:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005dce:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005dd2:	6794                	ld	a3,8(a5)
    80005dd4:	0026d703          	lhu	a4,2(a3)
    80005dd8:	8b1d                	andi	a4,a4,7
    80005dda:	0706                	slli	a4,a4,0x1
    80005ddc:	96ba                	add	a3,a3,a4
    80005dde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005de2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005de6:	6798                	ld	a4,8(a5)
    80005de8:	00275783          	lhu	a5,2(a4)
    80005dec:	2785                	addiw	a5,a5,1
    80005dee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005df2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005df6:	100017b7          	lui	a5,0x10001
    80005dfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005dfe:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005e02:	00027917          	auipc	s2,0x27
    80005e06:	d5e90913          	addi	s2,s2,-674 # 8002cb60 <disk+0x128>
  while(b->disk == 1) {
    80005e0a:	84ae                	mv	s1,a1
    80005e0c:	00b79a63          	bne	a5,a1,80005e20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005e10:	85ca                	mv	a1,s2
    80005e12:	854e                	mv	a0,s3
    80005e14:	984fc0ef          	jal	80001f98 <sleep>
  while(b->disk == 1) {
    80005e18:	0049a783          	lw	a5,4(s3)
    80005e1c:	fe978ae3          	beq	a5,s1,80005e10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005e20:	fa042903          	lw	s2,-96(s0)
    80005e24:	00491713          	slli	a4,s2,0x4
    80005e28:	02070713          	addi	a4,a4,32
    80005e2c:	00027797          	auipc	a5,0x27
    80005e30:	c0c78793          	addi	a5,a5,-1012 # 8002ca38 <disk>
    80005e34:	97ba                	add	a5,a5,a4
    80005e36:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005e3a:	00027997          	auipc	s3,0x27
    80005e3e:	bfe98993          	addi	s3,s3,-1026 # 8002ca38 <disk>
    80005e42:	00491713          	slli	a4,s2,0x4
    80005e46:	0009b783          	ld	a5,0(s3)
    80005e4a:	97ba                	add	a5,a5,a4
    80005e4c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005e50:	854a                	mv	a0,s2
    80005e52:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005e56:	bddff0ef          	jal	80005a32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005e5a:	8885                	andi	s1,s1,1
    80005e5c:	f0fd                	bnez	s1,80005e42 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005e5e:	00027517          	auipc	a0,0x27
    80005e62:	d0250513          	addi	a0,a0,-766 # 8002cb60 <disk+0x128>
    80005e66:	e57fa0ef          	jal	80000cbc <release>
}
    80005e6a:	60e6                	ld	ra,88(sp)
    80005e6c:	6446                	ld	s0,80(sp)
    80005e6e:	64a6                	ld	s1,72(sp)
    80005e70:	6906                	ld	s2,64(sp)
    80005e72:	79e2                	ld	s3,56(sp)
    80005e74:	7a42                	ld	s4,48(sp)
    80005e76:	7aa2                	ld	s5,40(sp)
    80005e78:	7b02                	ld	s6,32(sp)
    80005e7a:	6be2                	ld	s7,24(sp)
    80005e7c:	6c42                	ld	s8,16(sp)
    80005e7e:	6125                	addi	sp,sp,96
    80005e80:	8082                	ret

0000000080005e82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005e82:	1101                	addi	sp,sp,-32
    80005e84:	ec06                	sd	ra,24(sp)
    80005e86:	e822                	sd	s0,16(sp)
    80005e88:	e426                	sd	s1,8(sp)
    80005e8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005e8c:	00027497          	auipc	s1,0x27
    80005e90:	bac48493          	addi	s1,s1,-1108 # 8002ca38 <disk>
    80005e94:	00027517          	auipc	a0,0x27
    80005e98:	ccc50513          	addi	a0,a0,-820 # 8002cb60 <disk+0x128>
    80005e9c:	d8dfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ea0:	100017b7          	lui	a5,0x10001
    80005ea4:	53bc                	lw	a5,96(a5)
    80005ea6:	8b8d                	andi	a5,a5,3
    80005ea8:	10001737          	lui	a4,0x10001
    80005eac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005eae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005eb2:	689c                	ld	a5,16(s1)
    80005eb4:	0204d703          	lhu	a4,32(s1)
    80005eb8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ebc:	04f70863          	beq	a4,a5,80005f0c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005ec0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ec4:	6898                	ld	a4,16(s1)
    80005ec6:	0204d783          	lhu	a5,32(s1)
    80005eca:	8b9d                	andi	a5,a5,7
    80005ecc:	078e                	slli	a5,a5,0x3
    80005ece:	97ba                	add	a5,a5,a4
    80005ed0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005ed2:	00479713          	slli	a4,a5,0x4
    80005ed6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005eda:	9726                	add	a4,a4,s1
    80005edc:	01074703          	lbu	a4,16(a4)
    80005ee0:	e329                	bnez	a4,80005f22 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ee2:	0792                	slli	a5,a5,0x4
    80005ee4:	02078793          	addi	a5,a5,32
    80005ee8:	97a6                	add	a5,a5,s1
    80005eea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005eec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ef0:	8f4fc0ef          	jal	80001fe4 <wakeup>

    disk.used_idx += 1;
    80005ef4:	0204d783          	lhu	a5,32(s1)
    80005ef8:	2785                	addiw	a5,a5,1
    80005efa:	17c2                	slli	a5,a5,0x30
    80005efc:	93c1                	srli	a5,a5,0x30
    80005efe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005f02:	6898                	ld	a4,16(s1)
    80005f04:	00275703          	lhu	a4,2(a4)
    80005f08:	faf71ce3          	bne	a4,a5,80005ec0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005f0c:	00027517          	auipc	a0,0x27
    80005f10:	c5450513          	addi	a0,a0,-940 # 8002cb60 <disk+0x128>
    80005f14:	da9fa0ef          	jal	80000cbc <release>
}
    80005f18:	60e2                	ld	ra,24(sp)
    80005f1a:	6442                	ld	s0,16(sp)
    80005f1c:	64a2                	ld	s1,8(sp)
    80005f1e:	6105                	addi	sp,sp,32
    80005f20:	8082                	ret
      panic("virtio_disk_intr status");
    80005f22:	00001517          	auipc	a0,0x1
    80005f26:	7d650513          	addi	a0,a0,2006 # 800076f8 <etext+0x6f8>
    80005f2a:	8fbfa0ef          	jal	80000824 <panic>
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
