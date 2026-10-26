
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
    80000004:	8a010113          	addi	sp,sp,-1888 # 800078a0 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcc37>
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
    8000011a:	388020ef          	jal	800024a2 <either_copyin>
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
    80000196:	70e50513          	addi	a0,a0,1806 # 8000f8a0 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	0000f497          	auipc	s1,0xf
    800001a2:	70248493          	addi	s1,s1,1794 # 8000f8a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	0000f917          	auipc	s2,0xf
    800001aa:	79290913          	addi	s2,s2,1938 # 8000f938 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	08d010ef          	jal	80001a4a <myproc>
    800001c2:	178020ef          	jal	8000233a <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	70b010ef          	jal	800020d6 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	0000f717          	auipc	a4,0xf
    800001e2:	6c270713          	addi	a4,a4,1730 # 8000f8a0 <cons>
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
    80000210:	248020ef          	jal	80002458 <either_copyout>
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
    8000022c:	67850513          	addi	a0,a0,1656 # 8000f8a0 <cons>
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
    80000252:	6ef72523          	sw	a5,1770(a4) # 8000f938 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	63c50513          	addi	a0,a0,1596 # 8000f8a0 <cons>
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
    800002bc:	5e850513          	addi	a0,a0,1512 # 8000f8a0 <cons>
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
    800002da:	212020ef          	jal	800024ec <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002de:	0000f517          	auipc	a0,0xf
    800002e2:	5c250513          	addi	a0,a0,1474 # 8000f8a0 <cons>
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
    80000300:	5a470713          	addi	a4,a4,1444 # 8000f8a0 <cons>
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
    80000326:	57e70713          	addi	a4,a4,1406 # 8000f8a0 <cons>
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
    80000350:	5ec72703          	lw	a4,1516(a4) # 8000f938 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	0000f717          	auipc	a4,0xf
    80000366:	53e70713          	addi	a4,a4,1342 # 8000f8a0 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	0000f497          	auipc	s1,0xf
    80000376:	52e48493          	addi	s1,s1,1326 # 8000f8a0 <cons>
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
    800003b8:	4ec70713          	addi	a4,a4,1260 # 8000f8a0 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	0000f717          	auipc	a4,0xf
    800003ce:	56f72b23          	sw	a5,1398(a4) # 8000f940 <cons+0xa0>
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
    800003ec:	4b878793          	addi	a5,a5,1208 # 8000f8a0 <cons>
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
    8000040e:	52c7a923          	sw	a2,1330(a5) # 8000f93c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	0000f517          	auipc	a0,0xf
    80000416:	52650513          	addi	a0,a0,1318 # 8000f938 <cons+0x98>
    8000041a:	509010ef          	jal	80002122 <wakeup>
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
    80000434:	47050513          	addi	a0,a0,1136 # 8000f8a0 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00020797          	auipc	a5,0x20
    80000444:	5f078793          	addi	a5,a5,1520 # 80020a30 <devsw>
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
    80000482:	2aa80813          	addi	a6,a6,682 # 80007728 <digits>
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
    8000051c:	35c7a783          	lw	a5,860(a5) # 80007874 <panicking>
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
    80000562:	3ea50513          	addi	a0,a0,1002 # 8000f948 <pr>
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
    800006d6:	056c8c93          	addi	s9,s9,86 # 80007728 <digits>
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
    8000075e:	11a7a783          	lw	a5,282(a5) # 80007874 <panicking>
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
    80000788:	1c450513          	addi	a0,a0,452 # 8000f948 <pr>
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
    80000838:	0497a023          	sw	s1,64(a5) # 80007874 <panicking>
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
    8000085a:	0097ad23          	sw	s1,26(a5) # 80007870 <panicked>
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
    80000874:	0d850513          	addi	a0,a0,216 # 8000f948 <pr>
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
    800008ca:	09a50513          	addi	a0,a0,154 # 8000f960 <tx_lock>
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
    800008ee:	07650513          	addi	a0,a0,118 # 8000f960 <tx_lock>
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
    8000090c:	f7448493          	addi	s1,s1,-140 # 8000787c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	0000f997          	auipc	s3,0xf
    80000914:	05098993          	addi	s3,s3,80 # 8000f960 <tx_lock>
    80000918:	00007917          	auipc	s2,0x7
    8000091c:	f6090913          	addi	s2,s2,-160 # 80007878 <tx_chan>
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
    8000092c:	7aa010ef          	jal	800020d6 <sleep>
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
    8000095a:	00a50513          	addi	a0,a0,10 # 8000f960 <tx_lock>
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
    8000097e:	efa7a783          	lw	a5,-262(a5) # 80007874 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00007797          	auipc	a5,0x7
    80000988:	eec7a783          	lw	a5,-276(a5) # 80007870 <panicked>
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
    800009ae:	eca7a783          	lw	a5,-310(a5) # 80007874 <panicking>
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
    80000a0a:	f5a50513          	addi	a0,a0,-166 # 8000f960 <tx_lock>
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
    80000a24:	f4050513          	addi	a0,a0,-192 # 8000f960 <tx_lock>
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
    80000a40:	e407a023          	sw	zero,-448(a5) # 8000787c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00007517          	auipc	a0,0x7
    80000a48:	e3450513          	addi	a0,a0,-460 # 80007878 <tx_chan>
    80000a4c:	6d6010ef          	jal	80002122 <wakeup>
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
    80000a6c:	16078793          	addi	a5,a5,352 # 80021bc8 <end>
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
    80000a96:	ee690913          	addi	s2,s2,-282 # 8000f978 <kmem>
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
    80000b24:	e5850513          	addi	a0,a0,-424 # 8000f978 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00021517          	auipc	a0,0x21
    80000b34:	09850513          	addi	a0,a0,152 # 80021bc8 <end>
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
    80000b52:	e2a50513          	addi	a0,a0,-470 # 8000f978 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	0000f497          	auipc	s1,0xf
    80000b5e:	e364b483          	ld	s1,-458(s1) # 8000f990 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	0000f717          	auipc	a4,0xf
    80000b6a:	e2f73523          	sd	a5,-470(a4) # 8000f990 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	0000f517          	auipc	a0,0xf
    80000b72:	e0a50513          	addi	a0,a0,-502 # 8000f978 <kmem>
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
    80000b94:	de850513          	addi	a0,a0,-536 # 8000f978 <kmem>
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
    80000bce:	65d000ef          	jal	80001a2a <mycpu>
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
    80000bfe:	62d000ef          	jal	80001a2a <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	625000ef          	jal	80001a2a <mycpu>
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
    80000c1a:	611000ef          	jal	80001a2a <mycpu>
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
    80000c50:	5db000ef          	jal	80001a2a <mycpu>
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
    80000c74:	5b7000ef          	jal	80001a2a <mycpu>
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
    80000eb6:	361000ef          	jal	80001a16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00007717          	auipc	a4,0x7
    80000ebe:	9c670713          	addi	a4,a4,-1594 # 80007880 <started>
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
    80000ece:	349000ef          	jal	80001a16 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00006517          	auipc	a0,0x6
    80000ed8:	1c450513          	addi	a0,a0,452 # 80007098 <etext+0x98>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	774010ef          	jal	80002658 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	7b0040ef          	jal	80005698 <plicinithart>
  }

  scheduler();
    80000eec:	7f9000ef          	jal	80001ee4 <scheduler>
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
    80000f28:	21d000ef          	jal	80001944 <procinit>
    trapinit();      // trap vectors
    80000f2c:	708010ef          	jal	80002634 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	728010ef          	jal	80002658 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	74a040ef          	jal	8000567e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	760040ef          	jal	80005698 <plicinithart>
    binit();         // buffer cache
    80000f3c:	5d7010ef          	jal	80002d12 <binit>
    iinit();         // inode table
    80000f40:	328020ef          	jal	80003268 <iinit>
    fileinit();      // file table
    80000f44:	254030ef          	jal	80004198 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	041040ef          	jal	80005788 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	5d1000ef          	jal	80001d1c <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00007717          	auipc	a4,0x7
    80000f5a:	92f72523          	sw	a5,-1750(a4) # 80007880 <started>
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
    80000f70:	91c7b783          	ld	a5,-1764(a5) # 80007888 <kernel_pagetable>
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
    800011dc:	6c4000ef          	jal	800018a0 <proc_mapstacks>
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
    800011fc:	68a7b823          	sd	a0,1680(a5) # 80007888 <kernel_pagetable>
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
    800015e0:	46a000ef          	jal	80001a4a <myproc>
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

00000000800017a0 <insert_process_into_runnable_tree>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.

void insert_process_into_runnable_tree(struct proc *p) 
{
    800017a0:	1101                	addi	sp,sp,-32
    800017a2:	ec06                	sd	ra,24(sp)
    800017a4:	e822                	sd	s0,16(sp)
    800017a6:	e426                	sd	s1,8(sp)
    800017a8:	1000                	addi	s0,sp,32
    800017aa:	84aa                	mv	s1,a0
  acquire(&runnable_tree.lock);
    800017ac:	0000e517          	auipc	a0,0xe
    800017b0:	1f450513          	addi	a0,a0,500 # 8000f9a0 <runnable_tree+0x8>
    800017b4:	c74ff0ef          	jal	80000c28 <acquire>
  p->runnable_node.key = p->vruntime;
    800017b8:	1a04b783          	ld	a5,416(s1)
    800017bc:	16f4b823          	sd	a5,368(s1)
  p->runnable_node.data = p;
    800017c0:	1694bc23          	sd	s1,376(s1)
  rb_insert(&runnable_tree, &p->runnable_node);
    800017c4:	17048593          	addi	a1,s1,368
    800017c8:	0000e517          	auipc	a0,0xe
    800017cc:	1d050513          	addi	a0,a0,464 # 8000f998 <runnable_tree>
    800017d0:	4d0040ef          	jal	80005ca0 <rb_insert>
  release(&runnable_tree.lock);
    800017d4:	0000e517          	auipc	a0,0xe
    800017d8:	1cc50513          	addi	a0,a0,460 # 8000f9a0 <runnable_tree+0x8>
    800017dc:	ce0ff0ef          	jal	80000cbc <release>
}
    800017e0:	60e2                	ld	ra,24(sp)
    800017e2:	6442                	ld	s0,16(sp)
    800017e4:	64a2                	ld	s1,8(sp)
    800017e6:	6105                	addi	sp,sp,32
    800017e8:	8082                	ret

00000000800017ea <get_min_vruntime>:

uint64 get_min_vruntime(void)
{
    800017ea:	7139                	addi	sp,sp,-64
    800017ec:	fc06                	sd	ra,56(sp)
    800017ee:	f822                	sd	s0,48(sp)
    800017f0:	e456                	sd	s5,8(sp)
    800017f2:	0080                	addi	s0,sp,64
  uint64 min_vruntime = 0;
  int found = 0;

  acquire(&runnable_tree.lock);
    800017f4:	0000e517          	auipc	a0,0xe
    800017f8:	1ac50513          	addi	a0,a0,428 # 8000f9a0 <runnable_tree+0x8>
    800017fc:	c2cff0ef          	jal	80000c28 <acquire>
  struct rb_node *min_node = rb_first(runnable_tree.root);
    80001800:	0000e517          	auipc	a0,0xe
    80001804:	19853503          	ld	a0,408(a0) # 8000f998 <runnable_tree>
    80001808:	5c8040ef          	jal	80005dd0 <rb_first>
  if (min_node) {
    8000180c:	cd19                	beqz	a0,8000182a <get_min_vruntime+0x40>
    min_vruntime = min_node->key;
    8000180e:	00053a83          	ld	s5,0(a0)
    release(&runnable_tree.lock);
    80001812:	0000e517          	auipc	a0,0xe
    80001816:	18e50513          	addi	a0,a0,398 # 8000f9a0 <runnable_tree+0x8>
    8000181a:	ca2ff0ef          	jal	80000cbc <release>
    release(&p->lock);
  }
  if(found) return min_vruntime;

  return 0;
}
    8000181e:	8556                	mv	a0,s5
    80001820:	70e2                	ld	ra,56(sp)
    80001822:	7442                	ld	s0,48(sp)
    80001824:	6aa2                	ld	s5,8(sp)
    80001826:	6121                	addi	sp,sp,64
    80001828:	8082                	ret
    8000182a:	f426                	sd	s1,40(sp)
    8000182c:	f04a                	sd	s2,32(sp)
    8000182e:	ec4e                	sd	s3,24(sp)
    80001830:	e852                	sd	s4,16(sp)
  release(&runnable_tree.lock);
    80001832:	0000e517          	auipc	a0,0xe
    80001836:	16e50513          	addi	a0,a0,366 # 8000f9a0 <runnable_tree+0x8>
    8000183a:	c82ff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183e:	0000e497          	auipc	s1,0xe
    80001842:	5aa48493          	addi	s1,s1,1450 # 8000fde8 <proc>
  int found = 0;
    80001846:	4a01                	li	s4,0
  uint64 min_vruntime = 0;
    80001848:	4a81                	li	s5,0
    if (p->state == RUNNING) {
    8000184a:	4991                	li	s3,4
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184c:	00015917          	auipc	s2,0x15
    80001850:	f9c90913          	addi	s2,s2,-100 # 800167e8 <tickslock>
    80001854:	a829                	j	8000186e <get_min_vruntime+0x84>
      else if (p->vruntime < min_vruntime) min_vruntime = p->vruntime;
    80001856:	1a04b783          	ld	a5,416(s1)
    8000185a:	0157f363          	bgeu	a5,s5,80001860 <get_min_vruntime+0x76>
    8000185e:	8abe                	mv	s5,a5
    release(&p->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	c5aff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	1a848493          	addi	s1,s1,424
    8000186a:	01248e63          	beq	s1,s2,80001886 <get_min_vruntime+0x9c>
    acquire(&p->lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	bb8ff0ef          	jal	80000c28 <acquire>
    if (p->state == RUNNING) {
    80001874:	4c9c                	lw	a5,24(s1)
    80001876:	ff3795e3          	bne	a5,s3,80001860 <get_min_vruntime+0x76>
      if(!found) {
    8000187a:	fc0a1ee3          	bnez	s4,80001856 <get_min_vruntime+0x6c>
        min_vruntime = p->vruntime;
    8000187e:	1a04ba83          	ld	s5,416(s1)
        found = 1;
    80001882:	4a05                	li	s4,1
    80001884:	bff1                	j	80001860 <get_min_vruntime+0x76>
  if(found) return min_vruntime;
    80001886:	000a1863          	bnez	s4,80001896 <get_min_vruntime+0xac>
  return 0;
    8000188a:	4a81                	li	s5,0
    8000188c:	74a2                	ld	s1,40(sp)
    8000188e:	7902                	ld	s2,32(sp)
    80001890:	69e2                	ld	s3,24(sp)
    80001892:	6a42                	ld	s4,16(sp)
    80001894:	b769                	j	8000181e <get_min_vruntime+0x34>
    80001896:	74a2                	ld	s1,40(sp)
    80001898:	7902                	ld	s2,32(sp)
    8000189a:	69e2                	ld	s3,24(sp)
    8000189c:	6a42                	ld	s4,16(sp)
    8000189e:	b741                	j	8000181e <get_min_vruntime+0x34>

00000000800018a0 <proc_mapstacks>:

void
proc_mapstacks(pagetable_t kpgtbl)
{
    800018a0:	715d                	addi	sp,sp,-80
    800018a2:	e486                	sd	ra,72(sp)
    800018a4:	e0a2                	sd	s0,64(sp)
    800018a6:	fc26                	sd	s1,56(sp)
    800018a8:	f84a                	sd	s2,48(sp)
    800018aa:	f44e                	sd	s3,40(sp)
    800018ac:	f052                	sd	s4,32(sp)
    800018ae:	ec56                	sd	s5,24(sp)
    800018b0:	e85a                	sd	s6,16(sp)
    800018b2:	e45e                	sd	s7,8(sp)
    800018b4:	e062                	sd	s8,0(sp)
    800018b6:	0880                	addi	s0,sp,80
    800018b8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018ba:	0000e497          	auipc	s1,0xe
    800018be:	52e48493          	addi	s1,s1,1326 # 8000fde8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800018c2:	8c26                	mv	s8,s1
    800018c4:	0008c7b7          	lui	a5,0x8c
    800018c8:	13578793          	addi	a5,a5,309 # 8c135 <_entry-0x7ff73ecb>
    800018cc:	07b2                	slli	a5,a5,0xc
    800018ce:	21d78793          	addi	a5,a5,541
    800018d2:	21cfb937          	lui	s2,0x21cfb
    800018d6:	2b790913          	addi	s2,s2,695 # 21cfb2b7 <_entry-0x5e304d49>
    800018da:	1902                	slli	s2,s2,0x20
    800018dc:	993e                	add	s2,s2,a5
    800018de:	040009b7          	lui	s3,0x4000
    800018e2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018e4:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018e6:	4b99                	li	s7,6
    800018e8:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ea:	00015a97          	auipc	s5,0x15
    800018ee:	efea8a93          	addi	s5,s5,-258 # 800167e8 <tickslock>
    char *pa = kalloc();
    800018f2:	a52ff0ef          	jal	80000b44 <kalloc>
    800018f6:	862a                	mv	a2,a0
    if(pa == 0)
    800018f8:	c121                	beqz	a0,80001938 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    800018fa:	418485b3          	sub	a1,s1,s8
    800018fe:	858d                	srai	a1,a1,0x3
    80001900:	032585b3          	mul	a1,a1,s2
    80001904:	05b6                	slli	a1,a1,0xd
    80001906:	6789                	lui	a5,0x2
    80001908:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000190a:	875e                	mv	a4,s7
    8000190c:	86da                	mv	a3,s6
    8000190e:	40b985b3          	sub	a1,s3,a1
    80001912:	8552                	mv	a0,s4
    80001914:	803ff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001918:	1a848493          	addi	s1,s1,424
    8000191c:	fd549be3          	bne	s1,s5,800018f2 <proc_mapstacks+0x52>
  }
}
    80001920:	60a6                	ld	ra,72(sp)
    80001922:	6406                	ld	s0,64(sp)
    80001924:	74e2                	ld	s1,56(sp)
    80001926:	7942                	ld	s2,48(sp)
    80001928:	79a2                	ld	s3,40(sp)
    8000192a:	7a02                	ld	s4,32(sp)
    8000192c:	6ae2                	ld	s5,24(sp)
    8000192e:	6b42                	ld	s6,16(sp)
    80001930:	6ba2                	ld	s7,8(sp)
    80001932:	6c02                	ld	s8,0(sp)
    80001934:	6161                	addi	sp,sp,80
    80001936:	8082                	ret
      panic("kalloc");
    80001938:	00006517          	auipc	a0,0x6
    8000193c:	82050513          	addi	a0,a0,-2016 # 80007158 <etext+0x158>
    80001940:	ee5fe0ef          	jal	80000824 <panic>

0000000080001944 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001944:	7139                	addi	sp,sp,-64
    80001946:	fc06                	sd	ra,56(sp)
    80001948:	f822                	sd	s0,48(sp)
    8000194a:	f426                	sd	s1,40(sp)
    8000194c:	f04a                	sd	s2,32(sp)
    8000194e:	ec4e                	sd	s3,24(sp)
    80001950:	e852                	sd	s4,16(sp)
    80001952:	e456                	sd	s5,8(sp)
    80001954:	e05a                	sd	s6,0(sp)
    80001956:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001958:	00006597          	auipc	a1,0x6
    8000195c:	80858593          	addi	a1,a1,-2040 # 80007160 <etext+0x160>
    80001960:	0000e517          	auipc	a0,0xe
    80001964:	05850513          	addi	a0,a0,88 # 8000f9b8 <pid_lock>
    80001968:	a36ff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000196c:	00005597          	auipc	a1,0x5
    80001970:	7fc58593          	addi	a1,a1,2044 # 80007168 <etext+0x168>
    80001974:	0000e517          	auipc	a0,0xe
    80001978:	05c50513          	addi	a0,a0,92 # 8000f9d0 <wait_lock>
    8000197c:	a22ff0ef          	jal	80000b9e <initlock>
  initlock(&runnable_tree.lock, "runnable_tree_lock");
    80001980:	00005597          	auipc	a1,0x5
    80001984:	7f858593          	addi	a1,a1,2040 # 80007178 <etext+0x178>
    80001988:	0000e517          	auipc	a0,0xe
    8000198c:	01850513          	addi	a0,a0,24 # 8000f9a0 <runnable_tree+0x8>
    80001990:	a0eff0ef          	jal	80000b9e <initlock>
  runnable_tree.root = 0;
    80001994:	0000e797          	auipc	a5,0xe
    80001998:	0007b223          	sd	zero,4(a5) # 8000f998 <runnable_tree>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000199c:	0000e497          	auipc	s1,0xe
    800019a0:	44c48493          	addi	s1,s1,1100 # 8000fde8 <proc>
      initlock(&p->lock, "proc");
    800019a4:	00005b17          	auipc	s6,0x5
    800019a8:	7ecb0b13          	addi	s6,s6,2028 # 80007190 <etext+0x190>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800019ac:	8aa6                	mv	s5,s1
    800019ae:	0008c7b7          	lui	a5,0x8c
    800019b2:	13578793          	addi	a5,a5,309 # 8c135 <_entry-0x7ff73ecb>
    800019b6:	07b2                	slli	a5,a5,0xc
    800019b8:	21d78793          	addi	a5,a5,541
    800019bc:	21cfb937          	lui	s2,0x21cfb
    800019c0:	2b790913          	addi	s2,s2,695 # 21cfb2b7 <_entry-0x5e304d49>
    800019c4:	1902                	slli	s2,s2,0x20
    800019c6:	993e                	add	s2,s2,a5
    800019c8:	040009b7          	lui	s3,0x4000
    800019cc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019ce:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019d0:	00015a17          	auipc	s4,0x15
    800019d4:	e18a0a13          	addi	s4,s4,-488 # 800167e8 <tickslock>
      initlock(&p->lock, "proc");
    800019d8:	85da                	mv	a1,s6
    800019da:	8526                	mv	a0,s1
    800019dc:	9c2ff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800019e0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800019e4:	415487b3          	sub	a5,s1,s5
    800019e8:	878d                	srai	a5,a5,0x3
    800019ea:	032787b3          	mul	a5,a5,s2
    800019ee:	07b6                	slli	a5,a5,0xd
    800019f0:	6709                	lui	a4,0x2
    800019f2:	9fb9                	addw	a5,a5,a4
    800019f4:	40f987b3          	sub	a5,s3,a5
    800019f8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019fa:	1a848493          	addi	s1,s1,424
    800019fe:	fd449de3          	bne	s1,s4,800019d8 <procinit+0x94>
  }
}
    80001a02:	70e2                	ld	ra,56(sp)
    80001a04:	7442                	ld	s0,48(sp)
    80001a06:	74a2                	ld	s1,40(sp)
    80001a08:	7902                	ld	s2,32(sp)
    80001a0a:	69e2                	ld	s3,24(sp)
    80001a0c:	6a42                	ld	s4,16(sp)
    80001a0e:	6aa2                	ld	s5,8(sp)
    80001a10:	6b02                	ld	s6,0(sp)
    80001a12:	6121                	addi	sp,sp,64
    80001a14:	8082                	ret

0000000080001a16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a16:	1141                	addi	sp,sp,-16
    80001a18:	e406                	sd	ra,8(sp)
    80001a1a:	e022                	sd	s0,0(sp)
    80001a1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a20:	2501                	sext.w	a0,a0
    80001a22:	60a2                	ld	ra,8(sp)
    80001a24:	6402                	ld	s0,0(sp)
    80001a26:	0141                	addi	sp,sp,16
    80001a28:	8082                	ret

0000000080001a2a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001a2a:	1141                	addi	sp,sp,-16
    80001a2c:	e406                	sd	ra,8(sp)
    80001a2e:	e022                	sd	s0,0(sp)
    80001a30:	0800                	addi	s0,sp,16
    80001a32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a34:	2781                	sext.w	a5,a5
    80001a36:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a38:	0000e517          	auipc	a0,0xe
    80001a3c:	fb050513          	addi	a0,a0,-80 # 8000f9e8 <cpus>
    80001a40:	953e                	add	a0,a0,a5
    80001a42:	60a2                	ld	ra,8(sp)
    80001a44:	6402                	ld	s0,0(sp)
    80001a46:	0141                	addi	sp,sp,16
    80001a48:	8082                	ret

0000000080001a4a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001a4a:	1101                	addi	sp,sp,-32
    80001a4c:	ec06                	sd	ra,24(sp)
    80001a4e:	e822                	sd	s0,16(sp)
    80001a50:	e426                	sd	s1,8(sp)
    80001a52:	1000                	addi	s0,sp,32
  push_off();
    80001a54:	990ff0ef          	jal	80000be4 <push_off>
    80001a58:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a5a:	2781                	sext.w	a5,a5
    80001a5c:	079e                	slli	a5,a5,0x7
    80001a5e:	0000e717          	auipc	a4,0xe
    80001a62:	f3a70713          	addi	a4,a4,-198 # 8000f998 <runnable_tree>
    80001a66:	97ba                	add	a5,a5,a4
    80001a68:	6bbc                	ld	a5,80(a5)
    80001a6a:	84be                	mv	s1,a5
  pop_off();
    80001a6c:	a00ff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001a70:	8526                	mv	a0,s1
    80001a72:	60e2                	ld	ra,24(sp)
    80001a74:	6442                	ld	s0,16(sp)
    80001a76:	64a2                	ld	s1,8(sp)
    80001a78:	6105                	addi	sp,sp,32
    80001a7a:	8082                	ret

0000000080001a7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a7c:	7179                	addi	sp,sp,-48
    80001a7e:	f406                	sd	ra,40(sp)
    80001a80:	f022                	sd	s0,32(sp)
    80001a82:	ec26                	sd	s1,24(sp)
    80001a84:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001a86:	fc5ff0ef          	jal	80001a4a <myproc>
    80001a8a:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001a8c:	a30ff0ef          	jal	80000cbc <release>

  if (first) {
    80001a90:	00006797          	auipc	a5,0x6
    80001a94:	dd07a783          	lw	a5,-560(a5) # 80007860 <first.1>
    80001a98:	cf95                	beqz	a5,80001ad4 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001a9a:	4505                	li	a0,1
    80001a9c:	489010ef          	jal	80003724 <fsinit>

    first = 0;
    80001aa0:	00006797          	auipc	a5,0x6
    80001aa4:	dc07a023          	sw	zero,-576(a5) # 80007860 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001aa8:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001aac:	00005797          	auipc	a5,0x5
    80001ab0:	6ec78793          	addi	a5,a5,1772 # 80007198 <etext+0x198>
    80001ab4:	fcf43823          	sd	a5,-48(s0)
    80001ab8:	fc043c23          	sd	zero,-40(s0)
    80001abc:	fd040593          	addi	a1,s0,-48
    80001ac0:	853e                	mv	a0,a5
    80001ac2:	5eb020ef          	jal	800048ac <kexec>
    80001ac6:	6cbc                	ld	a5,88(s1)
    80001ac8:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001aca:	6cbc                	ld	a5,88(s1)
    80001acc:	7bb8                	ld	a4,112(a5)
    80001ace:	57fd                	li	a5,-1
    80001ad0:	02f70d63          	beq	a4,a5,80001b0a <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001ad4:	3a1000ef          	jal	80002674 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ad8:	68a8                	ld	a0,80(s1)
    80001ada:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001adc:	04000737          	lui	a4,0x4000
    80001ae0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001ae2:	0732                	slli	a4,a4,0xc
    80001ae4:	00004797          	auipc	a5,0x4
    80001ae8:	5b878793          	addi	a5,a5,1464 # 8000609c <userret>
    80001aec:	00004697          	auipc	a3,0x4
    80001af0:	51468693          	addi	a3,a3,1300 # 80006000 <_trampoline>
    80001af4:	8f95                	sub	a5,a5,a3
    80001af6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001af8:	577d                	li	a4,-1
    80001afa:	177e                	slli	a4,a4,0x3f
    80001afc:	8d59                	or	a0,a0,a4
    80001afe:	9782                	jalr	a5
}
    80001b00:	70a2                	ld	ra,40(sp)
    80001b02:	7402                	ld	s0,32(sp)
    80001b04:	64e2                	ld	s1,24(sp)
    80001b06:	6145                	addi	sp,sp,48
    80001b08:	8082                	ret
      panic("exec");
    80001b0a:	00005517          	auipc	a0,0x5
    80001b0e:	69650513          	addi	a0,a0,1686 # 800071a0 <etext+0x1a0>
    80001b12:	d13fe0ef          	jal	80000824 <panic>

0000000080001b16 <allocpid>:
{
    80001b16:	1101                	addi	sp,sp,-32
    80001b18:	ec06                	sd	ra,24(sp)
    80001b1a:	e822                	sd	s0,16(sp)
    80001b1c:	e426                	sd	s1,8(sp)
    80001b1e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b20:	0000e517          	auipc	a0,0xe
    80001b24:	e9850513          	addi	a0,a0,-360 # 8000f9b8 <pid_lock>
    80001b28:	900ff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001b2c:	00006797          	auipc	a5,0x6
    80001b30:	d3878793          	addi	a5,a5,-712 # 80007864 <nextpid>
    80001b34:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b36:	0014871b          	addiw	a4,s1,1
    80001b3a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b3c:	0000e517          	auipc	a0,0xe
    80001b40:	e7c50513          	addi	a0,a0,-388 # 8000f9b8 <pid_lock>
    80001b44:	978ff0ef          	jal	80000cbc <release>
}
    80001b48:	8526                	mv	a0,s1
    80001b4a:	60e2                	ld	ra,24(sp)
    80001b4c:	6442                	ld	s0,16(sp)
    80001b4e:	64a2                	ld	s1,8(sp)
    80001b50:	6105                	addi	sp,sp,32
    80001b52:	8082                	ret

0000000080001b54 <proc_pagetable>:
{
    80001b54:	1101                	addi	sp,sp,-32
    80001b56:	ec06                	sd	ra,24(sp)
    80001b58:	e822                	sd	s0,16(sp)
    80001b5a:	e426                	sd	s1,8(sp)
    80001b5c:	e04a                	sd	s2,0(sp)
    80001b5e:	1000                	addi	s0,sp,32
    80001b60:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b62:	ea6ff0ef          	jal	80001208 <uvmcreate>
    80001b66:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b68:	cd05                	beqz	a0,80001ba0 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b6a:	4729                	li	a4,10
    80001b6c:	00004697          	auipc	a3,0x4
    80001b70:	49468693          	addi	a3,a3,1172 # 80006000 <_trampoline>
    80001b74:	6605                	lui	a2,0x1
    80001b76:	040005b7          	lui	a1,0x4000
    80001b7a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b7c:	05b2                	slli	a1,a1,0xc
    80001b7e:	ce2ff0ef          	jal	80001060 <mappages>
    80001b82:	02054663          	bltz	a0,80001bae <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b86:	4719                	li	a4,6
    80001b88:	05893683          	ld	a3,88(s2)
    80001b8c:	6605                	lui	a2,0x1
    80001b8e:	020005b7          	lui	a1,0x2000
    80001b92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b94:	05b6                	slli	a1,a1,0xd
    80001b96:	8526                	mv	a0,s1
    80001b98:	cc8ff0ef          	jal	80001060 <mappages>
    80001b9c:	00054f63          	bltz	a0,80001bba <proc_pagetable+0x66>
}
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	60e2                	ld	ra,24(sp)
    80001ba4:	6442                	ld	s0,16(sp)
    80001ba6:	64a2                	ld	s1,8(sp)
    80001ba8:	6902                	ld	s2,0(sp)
    80001baa:	6105                	addi	sp,sp,32
    80001bac:	8082                	ret
    uvmfree(pagetable, 0);
    80001bae:	4581                	li	a1,0
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	851ff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001bb6:	4481                	li	s1,0
    80001bb8:	b7e5                	j	80001ba0 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bba:	4681                	li	a3,0
    80001bbc:	4605                	li	a2,1
    80001bbe:	040005b7          	lui	a1,0x4000
    80001bc2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bc4:	05b2                	slli	a1,a1,0xc
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	e66ff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80001bcc:	4581                	li	a1,0
    80001bce:	8526                	mv	a0,s1
    80001bd0:	833ff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001bd4:	4481                	li	s1,0
    80001bd6:	b7e9                	j	80001ba0 <proc_pagetable+0x4c>

0000000080001bd8 <proc_freepagetable>:
{
    80001bd8:	1101                	addi	sp,sp,-32
    80001bda:	ec06                	sd	ra,24(sp)
    80001bdc:	e822                	sd	s0,16(sp)
    80001bde:	e426                	sd	s1,8(sp)
    80001be0:	e04a                	sd	s2,0(sp)
    80001be2:	1000                	addi	s0,sp,32
    80001be4:	84aa                	mv	s1,a0
    80001be6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001be8:	4681                	li	a3,0
    80001bea:	4605                	li	a2,1
    80001bec:	040005b7          	lui	a1,0x4000
    80001bf0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bf2:	05b2                	slli	a1,a1,0xc
    80001bf4:	e3aff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bf8:	4681                	li	a3,0
    80001bfa:	4605                	li	a2,1
    80001bfc:	020005b7          	lui	a1,0x2000
    80001c00:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c02:	05b6                	slli	a1,a1,0xd
    80001c04:	8526                	mv	a0,s1
    80001c06:	e28ff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80001c0a:	85ca                	mv	a1,s2
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	ff4ff0ef          	jal	80001402 <uvmfree>
}
    80001c12:	60e2                	ld	ra,24(sp)
    80001c14:	6442                	ld	s0,16(sp)
    80001c16:	64a2                	ld	s1,8(sp)
    80001c18:	6902                	ld	s2,0(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret

0000000080001c1e <freeproc>:
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	1000                	addi	s0,sp,32
    80001c28:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c2a:	6d28                	ld	a0,88(a0)
    80001c2c:	c119                	beqz	a0,80001c32 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001c2e:	e2ffe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001c32:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c36:	68a8                	ld	a0,80(s1)
    80001c38:	c501                	beqz	a0,80001c40 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001c3a:	64ac                	ld	a1,72(s1)
    80001c3c:	f9dff0ef          	jal	80001bd8 <proc_freepagetable>
  p->pagetable = 0;
    80001c40:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c44:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c48:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c4c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c50:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c54:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c58:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c5c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c60:	0004ac23          	sw	zero,24(s1)
}
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6105                	addi	sp,sp,32
    80001c6c:	8082                	ret

0000000080001c6e <allocproc>:
{
    80001c6e:	1101                	addi	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	e04a                	sd	s2,0(sp)
    80001c78:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c7a:	0000e497          	auipc	s1,0xe
    80001c7e:	16e48493          	addi	s1,s1,366 # 8000fde8 <proc>
    80001c82:	00015917          	auipc	s2,0x15
    80001c86:	b6690913          	addi	s2,s2,-1178 # 800167e8 <tickslock>
    acquire(&p->lock);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	f9dfe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001c90:	4c9c                	lw	a5,24(s1)
    80001c92:	cb91                	beqz	a5,80001ca6 <allocproc+0x38>
      release(&p->lock);
    80001c94:	8526                	mv	a0,s1
    80001c96:	826ff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c9a:	1a848493          	addi	s1,s1,424
    80001c9e:	ff2496e3          	bne	s1,s2,80001c8a <allocproc+0x1c>
  return 0;
    80001ca2:	4481                	li	s1,0
    80001ca4:	a0a9                	j	80001cee <allocproc+0x80>
  p->pid = allocpid();
    80001ca6:	e71ff0ef          	jal	80001b16 <allocpid>
    80001caa:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cac:	4785                	li	a5,1
    80001cae:	cc9c                	sw	a5,24(s1)
  p->nice = 0;
    80001cb0:	1604a423          	sw	zero,360(s1)
  p->vruntime = 0;
    80001cb4:	1a04b023          	sd	zero,416(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cb8:	e8dfe0ef          	jal	80000b44 <kalloc>
    80001cbc:	892a                	mv	s2,a0
    80001cbe:	eca8                	sd	a0,88(s1)
    80001cc0:	cd15                	beqz	a0,80001cfc <allocproc+0x8e>
  p->pagetable = proc_pagetable(p);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	e91ff0ef          	jal	80001b54 <proc_pagetable>
    80001cc8:	892a                	mv	s2,a0
    80001cca:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001ccc:	c121                	beqz	a0,80001d0c <allocproc+0x9e>
  memset(&p->context, 0, sizeof(p->context));
    80001cce:	07000613          	li	a2,112
    80001cd2:	4581                	li	a1,0
    80001cd4:	06048513          	addi	a0,s1,96
    80001cd8:	820ff0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001cdc:	00000797          	auipc	a5,0x0
    80001ce0:	da078793          	addi	a5,a5,-608 # 80001a7c <forkret>
    80001ce4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ce6:	60bc                	ld	a5,64(s1)
    80001ce8:	6705                	lui	a4,0x1
    80001cea:	97ba                	add	a5,a5,a4
    80001cec:	f4bc                	sd	a5,104(s1)
}
    80001cee:	8526                	mv	a0,s1
    80001cf0:	60e2                	ld	ra,24(sp)
    80001cf2:	6442                	ld	s0,16(sp)
    80001cf4:	64a2                	ld	s1,8(sp)
    80001cf6:	6902                	ld	s2,0(sp)
    80001cf8:	6105                	addi	sp,sp,32
    80001cfa:	8082                	ret
    freeproc(p);
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	f21ff0ef          	jal	80001c1e <freeproc>
    release(&p->lock);
    80001d02:	8526                	mv	a0,s1
    80001d04:	fb9fe0ef          	jal	80000cbc <release>
    return 0;
    80001d08:	84ca                	mv	s1,s2
    80001d0a:	b7d5                	j	80001cee <allocproc+0x80>
    freeproc(p);
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	f11ff0ef          	jal	80001c1e <freeproc>
    release(&p->lock);
    80001d12:	8526                	mv	a0,s1
    80001d14:	fa9fe0ef          	jal	80000cbc <release>
    return 0;
    80001d18:	84ca                	mv	s1,s2
    80001d1a:	bfd1                	j	80001cee <allocproc+0x80>

0000000080001d1c <userinit>:
{
    80001d1c:	1101                	addi	sp,sp,-32
    80001d1e:	ec06                	sd	ra,24(sp)
    80001d20:	e822                	sd	s0,16(sp)
    80001d22:	e426                	sd	s1,8(sp)
    80001d24:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d26:	f49ff0ef          	jal	80001c6e <allocproc>
    80001d2a:	84aa                	mv	s1,a0
  initproc = p;
    80001d2c:	00006797          	auipc	a5,0x6
    80001d30:	b6a7b223          	sd	a0,-1180(a5) # 80007890 <initproc>
  p->cwd = namei("/");
    80001d34:	00005517          	auipc	a0,0x5
    80001d38:	47450513          	addi	a0,a0,1140 # 800071a8 <etext+0x1a8>
    80001d3c:	723010ef          	jal	80003c5e <namei>
    80001d40:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d44:	478d                	li	a5,3
    80001d46:	cc9c                	sw	a5,24(s1)
  insert_process_into_runnable_tree(p);
    80001d48:	8526                	mv	a0,s1
    80001d4a:	a57ff0ef          	jal	800017a0 <insert_process_into_runnable_tree>
  release(&p->lock);
    80001d4e:	8526                	mv	a0,s1
    80001d50:	f6dfe0ef          	jal	80000cbc <release>
}
    80001d54:	60e2                	ld	ra,24(sp)
    80001d56:	6442                	ld	s0,16(sp)
    80001d58:	64a2                	ld	s1,8(sp)
    80001d5a:	6105                	addi	sp,sp,32
    80001d5c:	8082                	ret

0000000080001d5e <growproc>:
{
    80001d5e:	1101                	addi	sp,sp,-32
    80001d60:	ec06                	sd	ra,24(sp)
    80001d62:	e822                	sd	s0,16(sp)
    80001d64:	e426                	sd	s1,8(sp)
    80001d66:	e04a                	sd	s2,0(sp)
    80001d68:	1000                	addi	s0,sp,32
    80001d6a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d6c:	cdfff0ef          	jal	80001a4a <myproc>
    80001d70:	892a                	mv	s2,a0
  sz = p->sz;
    80001d72:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001d74:	02905963          	blez	s1,80001da6 <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001d78:	00b48633          	add	a2,s1,a1
    80001d7c:	020007b7          	lui	a5,0x2000
    80001d80:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001d82:	07b6                	slli	a5,a5,0xd
    80001d84:	02c7ea63          	bltu	a5,a2,80001db8 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d88:	4691                	li	a3,4
    80001d8a:	6928                	ld	a0,80(a0)
    80001d8c:	d70ff0ef          	jal	800012fc <uvmalloc>
    80001d90:	85aa                	mv	a1,a0
    80001d92:	c50d                	beqz	a0,80001dbc <growproc+0x5e>
  p->sz = sz;
    80001d94:	04b93423          	sd	a1,72(s2)
  return 0;
    80001d98:	4501                	li	a0,0
}
    80001d9a:	60e2                	ld	ra,24(sp)
    80001d9c:	6442                	ld	s0,16(sp)
    80001d9e:	64a2                	ld	s1,8(sp)
    80001da0:	6902                	ld	s2,0(sp)
    80001da2:	6105                	addi	sp,sp,32
    80001da4:	8082                	ret
  } else if(n < 0){
    80001da6:	fe04d7e3          	bgez	s1,80001d94 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001daa:	00b48633          	add	a2,s1,a1
    80001dae:	6928                	ld	a0,80(a0)
    80001db0:	d08ff0ef          	jal	800012b8 <uvmdealloc>
    80001db4:	85aa                	mv	a1,a0
    80001db6:	bff9                	j	80001d94 <growproc+0x36>
      return -1;
    80001db8:	557d                	li	a0,-1
    80001dba:	b7c5                	j	80001d9a <growproc+0x3c>
      return -1;
    80001dbc:	557d                	li	a0,-1
    80001dbe:	bff1                	j	80001d9a <growproc+0x3c>

0000000080001dc0 <kfork>:
{
    80001dc0:	7139                	addi	sp,sp,-64
    80001dc2:	fc06                	sd	ra,56(sp)
    80001dc4:	f822                	sd	s0,48(sp)
    80001dc6:	f426                	sd	s1,40(sp)
    80001dc8:	e456                	sd	s5,8(sp)
    80001dca:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001dcc:	c7fff0ef          	jal	80001a4a <myproc>
    80001dd0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001dd2:	e9dff0ef          	jal	80001c6e <allocproc>
    80001dd6:	10050563          	beqz	a0,80001ee0 <kfork+0x120>
    80001dda:	ec4e                	sd	s3,24(sp)
    80001ddc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dde:	048ab603          	ld	a2,72(s5)
    80001de2:	692c                	ld	a1,80(a0)
    80001de4:	050ab503          	ld	a0,80(s5)
    80001de8:	e4cff0ef          	jal	80001434 <uvmcopy>
    80001dec:	04054863          	bltz	a0,80001e3c <kfork+0x7c>
    80001df0:	f04a                	sd	s2,32(sp)
    80001df2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001df4:	048ab783          	ld	a5,72(s5)
    80001df8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001dfc:	058ab683          	ld	a3,88(s5)
    80001e00:	87b6                	mv	a5,a3
    80001e02:	0589b703          	ld	a4,88(s3)
    80001e06:	12068693          	addi	a3,a3,288
    80001e0a:	6388                	ld	a0,0(a5)
    80001e0c:	678c                	ld	a1,8(a5)
    80001e0e:	6b90                	ld	a2,16(a5)
    80001e10:	e308                	sd	a0,0(a4)
    80001e12:	e70c                	sd	a1,8(a4)
    80001e14:	eb10                	sd	a2,16(a4)
    80001e16:	6f90                	ld	a2,24(a5)
    80001e18:	ef10                	sd	a2,24(a4)
    80001e1a:	02078793          	addi	a5,a5,32
    80001e1e:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001e22:	fed794e3          	bne	a5,a3,80001e0a <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001e26:	0589b783          	ld	a5,88(s3)
    80001e2a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e2e:	0d0a8493          	addi	s1,s5,208
    80001e32:	0d098913          	addi	s2,s3,208
    80001e36:	150a8a13          	addi	s4,s5,336
    80001e3a:	a831                	j	80001e56 <kfork+0x96>
    freeproc(np);
    80001e3c:	854e                	mv	a0,s3
    80001e3e:	de1ff0ef          	jal	80001c1e <freeproc>
    release(&np->lock);
    80001e42:	854e                	mv	a0,s3
    80001e44:	e79fe0ef          	jal	80000cbc <release>
    return -1;
    80001e48:	54fd                	li	s1,-1
    80001e4a:	69e2                	ld	s3,24(sp)
    80001e4c:	a059                	j	80001ed2 <kfork+0x112>
  for(i = 0; i < NOFILE; i++)
    80001e4e:	04a1                	addi	s1,s1,8
    80001e50:	0921                	addi	s2,s2,8
    80001e52:	01448963          	beq	s1,s4,80001e64 <kfork+0xa4>
    if(p->ofile[i])
    80001e56:	6088                	ld	a0,0(s1)
    80001e58:	d97d                	beqz	a0,80001e4e <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e5a:	3c0020ef          	jal	8000421a <filedup>
    80001e5e:	00a93023          	sd	a0,0(s2)
    80001e62:	b7f5                	j	80001e4e <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001e64:	150ab503          	ld	a0,336(s5)
    80001e68:	592010ef          	jal	800033fa <idup>
    80001e6c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e70:	4641                	li	a2,16
    80001e72:	158a8593          	addi	a1,s5,344
    80001e76:	15898513          	addi	a0,s3,344
    80001e7a:	fd3fe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001e7e:	0309a483          	lw	s1,48(s3)
  np->vruntime = p->vruntime;
    80001e82:	1a0ab783          	ld	a5,416(s5)
    80001e86:	1af9b023          	sd	a5,416(s3)
  np->nice = p->nice;
    80001e8a:	168aa783          	lw	a5,360(s5)
    80001e8e:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    80001e92:	854e                	mv	a0,s3
    80001e94:	e29fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001e98:	0000e517          	auipc	a0,0xe
    80001e9c:	b3850513          	addi	a0,a0,-1224 # 8000f9d0 <wait_lock>
    80001ea0:	d89fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001ea4:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001ea8:	0000e517          	auipc	a0,0xe
    80001eac:	b2850513          	addi	a0,a0,-1240 # 8000f9d0 <wait_lock>
    80001eb0:	e0dfe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001eb4:	854e                	mv	a0,s3
    80001eb6:	d73fe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001eba:	478d                	li	a5,3
    80001ebc:	00f9ac23          	sw	a5,24(s3)
  insert_process_into_runnable_tree(np);
    80001ec0:	854e                	mv	a0,s3
    80001ec2:	8dfff0ef          	jal	800017a0 <insert_process_into_runnable_tree>
  release(&np->lock);
    80001ec6:	854e                	mv	a0,s3
    80001ec8:	df5fe0ef          	jal	80000cbc <release>
  return pid;
    80001ecc:	7902                	ld	s2,32(sp)
    80001ece:	69e2                	ld	s3,24(sp)
    80001ed0:	6a42                	ld	s4,16(sp)
}
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	70e2                	ld	ra,56(sp)
    80001ed6:	7442                	ld	s0,48(sp)
    80001ed8:	74a2                	ld	s1,40(sp)
    80001eda:	6aa2                	ld	s5,8(sp)
    80001edc:	6121                	addi	sp,sp,64
    80001ede:	8082                	ret
    return -1;
    80001ee0:	54fd                	li	s1,-1
    80001ee2:	bfc5                	j	80001ed2 <kfork+0x112>

0000000080001ee4 <scheduler>:
{
    80001ee4:	715d                	addi	sp,sp,-80
    80001ee6:	e486                	sd	ra,72(sp)
    80001ee8:	e0a2                	sd	s0,64(sp)
    80001eea:	fc26                	sd	s1,56(sp)
    80001eec:	f84a                	sd	s2,48(sp)
    80001eee:	f44e                	sd	s3,40(sp)
    80001ef0:	f052                	sd	s4,32(sp)
    80001ef2:	ec56                	sd	s5,24(sp)
    80001ef4:	e85a                	sd	s6,16(sp)
    80001ef6:	e45e                	sd	s7,8(sp)
    80001ef8:	e062                	sd	s8,0(sp)
    80001efa:	0880                	addi	s0,sp,80
    80001efc:	8792                	mv	a5,tp
  int id = r_tp();
    80001efe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f00:	00779c13          	slli	s8,a5,0x7
    80001f04:	0000e717          	auipc	a4,0xe
    80001f08:	a9470713          	addi	a4,a4,-1388 # 8000f998 <runnable_tree>
    80001f0c:	9762                	add	a4,a4,s8
    80001f0e:	04073823          	sd	zero,80(a4)
        swtch(&c->context, &p->context);
    80001f12:	0000e717          	auipc	a4,0xe
    80001f16:	ade70713          	addi	a4,a4,-1314 # 8000f9f0 <cpus+0x8>
    80001f1a:	9c3a                	add	s8,s8,a4
    acquire(&runnable_tree.lock);
    80001f1c:	0000e997          	auipc	s3,0xe
    80001f20:	a7c98993          	addi	s3,s3,-1412 # 8000f998 <runnable_tree>
    80001f24:	0000e917          	auipc	s2,0xe
    80001f28:	a7c90913          	addi	s2,s2,-1412 # 8000f9a0 <runnable_tree+0x8>
      if(p->state == RUNNABLE) {
    80001f2c:	4a0d                	li	s4,3
        p->state = RUNNING;
    80001f2e:	4b11                	li	s6,4
        c->proc = p;
    80001f30:	079e                	slli	a5,a5,0x7
    80001f32:	00f98ab3          	add	s5,s3,a5
    80001f36:	00006b97          	auipc	s7,0x6
    80001f3a:	80ab8b93          	addi	s7,s7,-2038 # 80007740 <digits+0x18>
    80001f3e:	a825                	j	80001f76 <scheduler+0x92>
        if(p->nice == -3) vruntime = 1;
    80001f40:	4705                	li	a4,1
    80001f42:	a819                	j	80001f58 <scheduler+0x74>
    80001f44:	875a                	mv	a4,s6
    80001f46:	a809                	j	80001f58 <scheduler+0x74>
    80001f48:	4721                	li	a4,8
    80001f4a:	a039                	j	80001f58 <scheduler+0x74>
    80001f4c:	4741                	li	a4,16
    80001f4e:	a029                	j	80001f58 <scheduler+0x74>
        else if(p->nice == 2) vruntime = 32;
    80001f50:	02000713          	li	a4,32
    80001f54:	a011                	j	80001f58 <scheduler+0x74>
        if(p->nice == -3) vruntime = 1;
    80001f56:	4709                	li	a4,2
        p->vruntime += vruntime;
    80001f58:	1a04b783          	ld	a5,416(s1)
    80001f5c:	97ba                	add	a5,a5,a4
    80001f5e:	1af4b023          	sd	a5,416(s1)
        swtch(&c->context, &p->context);
    80001f62:	06048593          	addi	a1,s1,96
    80001f66:	8562                	mv	a0,s8
    80001f68:	662000ef          	jal	800025ca <swtch>
        c->proc = 0;
    80001f6c:	040ab823          	sd	zero,80(s5)
      release(&p->lock);
    80001f70:	8526                	mv	a0,s1
    80001f72:	d4bfe0ef          	jal	80000cbc <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f76:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f7a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f7e:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f82:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001f86:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f88:	10079073          	csrw	sstatus,a5
    acquire(&runnable_tree.lock);
    80001f8c:	854a                	mv	a0,s2
    80001f8e:	c9bfe0ef          	jal	80000c28 <acquire>
    struct rb_node *min_node = rb_first(runnable_tree.root);
    80001f92:	0009b503          	ld	a0,0(s3)
    80001f96:	63b030ef          	jal	80005dd0 <rb_first>
    80001f9a:	84aa                	mv	s1,a0
    if (min_node) {
    80001f9c:	c121                	beqz	a0,80001fdc <scheduler+0xf8>
      rb_delete(&runnable_tree, min_node);
    80001f9e:	85aa                	mv	a1,a0
    80001fa0:	854e                	mv	a0,s3
    80001fa2:	649030ef          	jal	80005dea <rb_delete>
      p = (struct proc *)min_node->data;
    80001fa6:	6484                	ld	s1,8(s1)
      release(&runnable_tree.lock);
    80001fa8:	854a                	mv	a0,s2
    80001faa:	d13fe0ef          	jal	80000cbc <release>
      acquire(&p->lock);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	c79fe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80001fb4:	4c9c                	lw	a5,24(s1)
    80001fb6:	fb479de3          	bne	a5,s4,80001f70 <scheduler+0x8c>
        p->state = RUNNING;
    80001fba:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001fbe:	049ab823          	sd	s1,80(s5)
        if(p->nice == -3) vruntime = 1;
    80001fc2:	1684a783          	lw	a5,360(s1)
    80001fc6:	2789                	addiw	a5,a5,2
    80001fc8:	f6fb6ce3          	bltu	s6,a5,80001f40 <scheduler+0x5c>
    80001fcc:	02079713          	slli	a4,a5,0x20
    80001fd0:	01e75793          	srli	a5,a4,0x1e
    80001fd4:	97de                	add	a5,a5,s7
    80001fd6:	439c                	lw	a5,0(a5)
    80001fd8:	97de                	add	a5,a5,s7
    80001fda:	8782                	jr	a5
      release(&runnable_tree.lock);
    80001fdc:	854a                	mv	a0,s2
    80001fde:	cdffe0ef          	jal	80000cbc <release>
      asm volatile("wfi");
    80001fe2:	10500073          	wfi
    80001fe6:	bf41                	j	80001f76 <scheduler+0x92>

0000000080001fe8 <sched>:
{
    80001fe8:	7179                	addi	sp,sp,-48
    80001fea:	f406                	sd	ra,40(sp)
    80001fec:	f022                	sd	s0,32(sp)
    80001fee:	ec26                	sd	s1,24(sp)
    80001ff0:	e84a                	sd	s2,16(sp)
    80001ff2:	e44e                	sd	s3,8(sp)
    80001ff4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001ff6:	a55ff0ef          	jal	80001a4a <myproc>
    80001ffa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001ffc:	bbdfe0ef          	jal	80000bb8 <holding>
    80002000:	c935                	beqz	a0,80002074 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002002:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002004:	2781                	sext.w	a5,a5
    80002006:	079e                	slli	a5,a5,0x7
    80002008:	0000e717          	auipc	a4,0xe
    8000200c:	99070713          	addi	a4,a4,-1648 # 8000f998 <runnable_tree>
    80002010:	97ba                	add	a5,a5,a4
    80002012:	0c87a703          	lw	a4,200(a5)
    80002016:	4785                	li	a5,1
    80002018:	06f71463          	bne	a4,a5,80002080 <sched+0x98>
  if(p->state == RUNNING)
    8000201c:	4c98                	lw	a4,24(s1)
    8000201e:	4791                	li	a5,4
    80002020:	06f70663          	beq	a4,a5,8000208c <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002024:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002028:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000202a:	e7bd                	bnez	a5,80002098 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000202c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000202e:	0000e917          	auipc	s2,0xe
    80002032:	96a90913          	addi	s2,s2,-1686 # 8000f998 <runnable_tree>
    80002036:	2781                	sext.w	a5,a5
    80002038:	079e                	slli	a5,a5,0x7
    8000203a:	97ca                	add	a5,a5,s2
    8000203c:	0cc7a983          	lw	s3,204(a5)
    80002040:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002042:	2781                	sext.w	a5,a5
    80002044:	079e                	slli	a5,a5,0x7
    80002046:	07a1                	addi	a5,a5,8
    80002048:	0000e597          	auipc	a1,0xe
    8000204c:	9a058593          	addi	a1,a1,-1632 # 8000f9e8 <cpus>
    80002050:	95be                	add	a1,a1,a5
    80002052:	06048513          	addi	a0,s1,96
    80002056:	574000ef          	jal	800025ca <swtch>
    8000205a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000205c:	2781                	sext.w	a5,a5
    8000205e:	079e                	slli	a5,a5,0x7
    80002060:	993e                	add	s2,s2,a5
    80002062:	0d392623          	sw	s3,204(s2)
}
    80002066:	70a2                	ld	ra,40(sp)
    80002068:	7402                	ld	s0,32(sp)
    8000206a:	64e2                	ld	s1,24(sp)
    8000206c:	6942                	ld	s2,16(sp)
    8000206e:	69a2                	ld	s3,8(sp)
    80002070:	6145                	addi	sp,sp,48
    80002072:	8082                	ret
    panic("sched p->lock");
    80002074:	00005517          	auipc	a0,0x5
    80002078:	13c50513          	addi	a0,a0,316 # 800071b0 <etext+0x1b0>
    8000207c:	fa8fe0ef          	jal	80000824 <panic>
    panic("sched locks");
    80002080:	00005517          	auipc	a0,0x5
    80002084:	14050513          	addi	a0,a0,320 # 800071c0 <etext+0x1c0>
    80002088:	f9cfe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    8000208c:	00005517          	auipc	a0,0x5
    80002090:	14450513          	addi	a0,a0,324 # 800071d0 <etext+0x1d0>
    80002094:	f90fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    80002098:	00005517          	auipc	a0,0x5
    8000209c:	14850513          	addi	a0,a0,328 # 800071e0 <etext+0x1e0>
    800020a0:	f84fe0ef          	jal	80000824 <panic>

00000000800020a4 <yield>:
{
    800020a4:	1101                	addi	sp,sp,-32
    800020a6:	ec06                	sd	ra,24(sp)
    800020a8:	e822                	sd	s0,16(sp)
    800020aa:	e426                	sd	s1,8(sp)
    800020ac:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020ae:	99dff0ef          	jal	80001a4a <myproc>
    800020b2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020b4:	b75fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    800020b8:	478d                	li	a5,3
    800020ba:	cc9c                	sw	a5,24(s1)
  insert_process_into_runnable_tree(p);
    800020bc:	8526                	mv	a0,s1
    800020be:	ee2ff0ef          	jal	800017a0 <insert_process_into_runnable_tree>
  sched();
    800020c2:	f27ff0ef          	jal	80001fe8 <sched>
  release(&p->lock);
    800020c6:	8526                	mv	a0,s1
    800020c8:	bf5fe0ef          	jal	80000cbc <release>
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	64a2                	ld	s1,8(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020d6:	7179                	addi	sp,sp,-48
    800020d8:	f406                	sd	ra,40(sp)
    800020da:	f022                	sd	s0,32(sp)
    800020dc:	ec26                	sd	s1,24(sp)
    800020de:	e84a                	sd	s2,16(sp)
    800020e0:	e44e                	sd	s3,8(sp)
    800020e2:	1800                	addi	s0,sp,48
    800020e4:	89aa                	mv	s3,a0
    800020e6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020e8:	963ff0ef          	jal	80001a4a <myproc>
    800020ec:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020ee:	b3bfe0ef          	jal	80000c28 <acquire>
  release(lk);
    800020f2:	854a                	mv	a0,s2
    800020f4:	bc9fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    800020f8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800020fc:	4789                	li	a5,2
    800020fe:	cc9c                	sw	a5,24(s1)

  sched();
    80002100:	ee9ff0ef          	jal	80001fe8 <sched>

  // Tidy up.
  p->chan = 0;
    80002104:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002108:	8526                	mv	a0,s1
    8000210a:	bb3fe0ef          	jal	80000cbc <release>
  acquire(lk);
    8000210e:	854a                	mv	a0,s2
    80002110:	b19fe0ef          	jal	80000c28 <acquire>
}
    80002114:	70a2                	ld	ra,40(sp)
    80002116:	7402                	ld	s0,32(sp)
    80002118:	64e2                	ld	s1,24(sp)
    8000211a:	6942                	ld	s2,16(sp)
    8000211c:	69a2                	ld	s3,8(sp)
    8000211e:	6145                	addi	sp,sp,48
    80002120:	8082                	ret

0000000080002122 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002122:	7139                	addi	sp,sp,-64
    80002124:	fc06                	sd	ra,56(sp)
    80002126:	f822                	sd	s0,48(sp)
    80002128:	f426                	sd	s1,40(sp)
    8000212a:	f04a                	sd	s2,32(sp)
    8000212c:	ec4e                	sd	s3,24(sp)
    8000212e:	e852                	sd	s4,16(sp)
    80002130:	e456                	sd	s5,8(sp)
    80002132:	e05a                	sd	s6,0(sp)
    80002134:	0080                	addi	s0,sp,64
    80002136:	8a2a                	mv	s4,a0
  struct proc *p;
  uint64 min_vruntime = get_min_vruntime();
    80002138:	eb2ff0ef          	jal	800017ea <get_min_vruntime>
    8000213c:	8aaa                	mv	s5,a0

  for(p = proc; p < &proc[NPROC]; p++) {
    8000213e:	0000e497          	auipc	s1,0xe
    80002142:	caa48493          	addi	s1,s1,-854 # 8000fde8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002146:	4989                	li	s3,2
        p->vruntime = min_vruntime;
        p->state = RUNNABLE;
    80002148:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000214a:	00014917          	auipc	s2,0x14
    8000214e:	69e90913          	addi	s2,s2,1694 # 800167e8 <tickslock>
    80002152:	a801                	j	80002162 <wakeup+0x40>
        insert_process_into_runnable_tree(p);
      }
      release(&p->lock);
    80002154:	8526                	mv	a0,s1
    80002156:	b67fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000215a:	1a848493          	addi	s1,s1,424
    8000215e:	03248763          	beq	s1,s2,8000218c <wakeup+0x6a>
    if(p != myproc()){
    80002162:	8e9ff0ef          	jal	80001a4a <myproc>
    80002166:	fe950ae3          	beq	a0,s1,8000215a <wakeup+0x38>
      acquire(&p->lock);
    8000216a:	8526                	mv	a0,s1
    8000216c:	abdfe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002170:	4c9c                	lw	a5,24(s1)
    80002172:	ff3791e3          	bne	a5,s3,80002154 <wakeup+0x32>
    80002176:	709c                	ld	a5,32(s1)
    80002178:	fd479ee3          	bne	a5,s4,80002154 <wakeup+0x32>
        p->vruntime = min_vruntime;
    8000217c:	1b54b023          	sd	s5,416(s1)
        p->state = RUNNABLE;
    80002180:	0164ac23          	sw	s6,24(s1)
        insert_process_into_runnable_tree(p);
    80002184:	8526                	mv	a0,s1
    80002186:	e1aff0ef          	jal	800017a0 <insert_process_into_runnable_tree>
    8000218a:	b7e9                	j	80002154 <wakeup+0x32>
    }
  }
}
    8000218c:	70e2                	ld	ra,56(sp)
    8000218e:	7442                	ld	s0,48(sp)
    80002190:	74a2                	ld	s1,40(sp)
    80002192:	7902                	ld	s2,32(sp)
    80002194:	69e2                	ld	s3,24(sp)
    80002196:	6a42                	ld	s4,16(sp)
    80002198:	6aa2                	ld	s5,8(sp)
    8000219a:	6b02                	ld	s6,0(sp)
    8000219c:	6121                	addi	sp,sp,64
    8000219e:	8082                	ret

00000000800021a0 <reparent>:
{
    800021a0:	7179                	addi	sp,sp,-48
    800021a2:	f406                	sd	ra,40(sp)
    800021a4:	f022                	sd	s0,32(sp)
    800021a6:	ec26                	sd	s1,24(sp)
    800021a8:	e84a                	sd	s2,16(sp)
    800021aa:	e44e                	sd	s3,8(sp)
    800021ac:	e052                	sd	s4,0(sp)
    800021ae:	1800                	addi	s0,sp,48
    800021b0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021b2:	0000e497          	auipc	s1,0xe
    800021b6:	c3648493          	addi	s1,s1,-970 # 8000fde8 <proc>
      pp->parent = initproc;
    800021ba:	00005a17          	auipc	s4,0x5
    800021be:	6d6a0a13          	addi	s4,s4,1750 # 80007890 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021c2:	00014997          	auipc	s3,0x14
    800021c6:	62698993          	addi	s3,s3,1574 # 800167e8 <tickslock>
    800021ca:	a029                	j	800021d4 <reparent+0x34>
    800021cc:	1a848493          	addi	s1,s1,424
    800021d0:	01348b63          	beq	s1,s3,800021e6 <reparent+0x46>
    if(pp->parent == p){
    800021d4:	7c9c                	ld	a5,56(s1)
    800021d6:	ff279be3          	bne	a5,s2,800021cc <reparent+0x2c>
      pp->parent = initproc;
    800021da:	000a3503          	ld	a0,0(s4)
    800021de:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800021e0:	f43ff0ef          	jal	80002122 <wakeup>
    800021e4:	b7e5                	j	800021cc <reparent+0x2c>
}
    800021e6:	70a2                	ld	ra,40(sp)
    800021e8:	7402                	ld	s0,32(sp)
    800021ea:	64e2                	ld	s1,24(sp)
    800021ec:	6942                	ld	s2,16(sp)
    800021ee:	69a2                	ld	s3,8(sp)
    800021f0:	6a02                	ld	s4,0(sp)
    800021f2:	6145                	addi	sp,sp,48
    800021f4:	8082                	ret

00000000800021f6 <kexit>:
{
    800021f6:	7179                	addi	sp,sp,-48
    800021f8:	f406                	sd	ra,40(sp)
    800021fa:	f022                	sd	s0,32(sp)
    800021fc:	ec26                	sd	s1,24(sp)
    800021fe:	e84a                	sd	s2,16(sp)
    80002200:	e44e                	sd	s3,8(sp)
    80002202:	e052                	sd	s4,0(sp)
    80002204:	1800                	addi	s0,sp,48
    80002206:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002208:	843ff0ef          	jal	80001a4a <myproc>
    8000220c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000220e:	00005797          	auipc	a5,0x5
    80002212:	6827b783          	ld	a5,1666(a5) # 80007890 <initproc>
    80002216:	0d050493          	addi	s1,a0,208
    8000221a:	15050913          	addi	s2,a0,336
    8000221e:	00a79b63          	bne	a5,a0,80002234 <kexit+0x3e>
    panic("init exiting");
    80002222:	00005517          	auipc	a0,0x5
    80002226:	fd650513          	addi	a0,a0,-42 # 800071f8 <etext+0x1f8>
    8000222a:	dfafe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000222e:	04a1                	addi	s1,s1,8
    80002230:	01248963          	beq	s1,s2,80002242 <kexit+0x4c>
    if(p->ofile[fd]){
    80002234:	6088                	ld	a0,0(s1)
    80002236:	dd65                	beqz	a0,8000222e <kexit+0x38>
      fileclose(f);
    80002238:	028020ef          	jal	80004260 <fileclose>
      p->ofile[fd] = 0;
    8000223c:	0004b023          	sd	zero,0(s1)
    80002240:	b7fd                	j	8000222e <kexit+0x38>
  begin_op();
    80002242:	3fb010ef          	jal	80003e3c <begin_op>
  iput(p->cwd);
    80002246:	1509b503          	ld	a0,336(s3)
    8000224a:	368010ef          	jal	800035b2 <iput>
  end_op();
    8000224e:	45f010ef          	jal	80003eac <end_op>
  p->cwd = 0;
    80002252:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002256:	0000d517          	auipc	a0,0xd
    8000225a:	77a50513          	addi	a0,a0,1914 # 8000f9d0 <wait_lock>
    8000225e:	9cbfe0ef          	jal	80000c28 <acquire>
  reparent(p);
    80002262:	854e                	mv	a0,s3
    80002264:	f3dff0ef          	jal	800021a0 <reparent>
  wakeup(p->parent);
    80002268:	0389b503          	ld	a0,56(s3)
    8000226c:	eb7ff0ef          	jal	80002122 <wakeup>
  acquire(&p->lock);
    80002270:	854e                	mv	a0,s3
    80002272:	9b7fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    80002276:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000227a:	4795                	li	a5,5
    8000227c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002280:	0000d517          	auipc	a0,0xd
    80002284:	75050513          	addi	a0,a0,1872 # 8000f9d0 <wait_lock>
    80002288:	a35fe0ef          	jal	80000cbc <release>
  sched();
    8000228c:	d5dff0ef          	jal	80001fe8 <sched>
  panic("zombie exit");
    80002290:	00005517          	auipc	a0,0x5
    80002294:	f7850513          	addi	a0,a0,-136 # 80007208 <etext+0x208>
    80002298:	d8cfe0ef          	jal	80000824 <panic>

000000008000229c <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000229c:	7179                	addi	sp,sp,-48
    8000229e:	f406                	sd	ra,40(sp)
    800022a0:	f022                	sd	s0,32(sp)
    800022a2:	ec26                	sd	s1,24(sp)
    800022a4:	e84a                	sd	s2,16(sp)
    800022a6:	e44e                	sd	s3,8(sp)
    800022a8:	e052                	sd	s4,0(sp)
    800022aa:	1800                	addi	s0,sp,48
    800022ac:	892a                	mv	s2,a0
  struct proc *p;

  uint64 min_vruntime = get_min_vruntime();
    800022ae:	d3cff0ef          	jal	800017ea <get_min_vruntime>
    800022b2:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++){
    800022b4:	0000e497          	auipc	s1,0xe
    800022b8:	b3448493          	addi	s1,s1,-1228 # 8000fde8 <proc>
    800022bc:	00014997          	auipc	s3,0x14
    800022c0:	52c98993          	addi	s3,s3,1324 # 800167e8 <tickslock>
    acquire(&p->lock);
    800022c4:	8526                	mv	a0,s1
    800022c6:	963fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    800022ca:	589c                	lw	a5,48(s1)
    800022cc:	01278b63          	beq	a5,s2,800022e2 <kkill+0x46>
        insert_process_into_runnable_tree(p);
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800022d0:	8526                	mv	a0,s1
    800022d2:	9ebfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800022d6:	1a848493          	addi	s1,s1,424
    800022da:	ff3495e3          	bne	s1,s3,800022c4 <kkill+0x28>
  }
  return -1;
    800022de:	557d                	li	a0,-1
    800022e0:	a819                	j	800022f6 <kkill+0x5a>
      p->killed = 1;
    800022e2:	4785                	li	a5,1
    800022e4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800022e6:	4c98                	lw	a4,24(s1)
    800022e8:	4789                	li	a5,2
    800022ea:	00f70e63          	beq	a4,a5,80002306 <kkill+0x6a>
      release(&p->lock);
    800022ee:	8526                	mv	a0,s1
    800022f0:	9cdfe0ef          	jal	80000cbc <release>
      return 0;
    800022f4:	4501                	li	a0,0
}
    800022f6:	70a2                	ld	ra,40(sp)
    800022f8:	7402                	ld	s0,32(sp)
    800022fa:	64e2                	ld	s1,24(sp)
    800022fc:	6942                	ld	s2,16(sp)
    800022fe:	69a2                	ld	s3,8(sp)
    80002300:	6a02                	ld	s4,0(sp)
    80002302:	6145                	addi	sp,sp,48
    80002304:	8082                	ret
        p->vruntime = min_vruntime;
    80002306:	1b44b023          	sd	s4,416(s1)
        p->state = RUNNABLE;
    8000230a:	478d                	li	a5,3
    8000230c:	cc9c                	sw	a5,24(s1)
        insert_process_into_runnable_tree(p);
    8000230e:	8526                	mv	a0,s1
    80002310:	c90ff0ef          	jal	800017a0 <insert_process_into_runnable_tree>
    80002314:	bfe9                	j	800022ee <kkill+0x52>

0000000080002316 <setkilled>:

void
setkilled(struct proc *p)
{
    80002316:	1101                	addi	sp,sp,-32
    80002318:	ec06                	sd	ra,24(sp)
    8000231a:	e822                	sd	s0,16(sp)
    8000231c:	e426                	sd	s1,8(sp)
    8000231e:	1000                	addi	s0,sp,32
    80002320:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002322:	907fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002326:	4785                	li	a5,1
    80002328:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000232a:	8526                	mv	a0,s1
    8000232c:	991fe0ef          	jal	80000cbc <release>
}
    80002330:	60e2                	ld	ra,24(sp)
    80002332:	6442                	ld	s0,16(sp)
    80002334:	64a2                	ld	s1,8(sp)
    80002336:	6105                	addi	sp,sp,32
    80002338:	8082                	ret

000000008000233a <killed>:

int
killed(struct proc *p)
{
    8000233a:	1101                	addi	sp,sp,-32
    8000233c:	ec06                	sd	ra,24(sp)
    8000233e:	e822                	sd	s0,16(sp)
    80002340:	e426                	sd	s1,8(sp)
    80002342:	e04a                	sd	s2,0(sp)
    80002344:	1000                	addi	s0,sp,32
    80002346:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002348:	8e1fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    8000234c:	549c                	lw	a5,40(s1)
    8000234e:	893e                	mv	s2,a5
  release(&p->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	96bfe0ef          	jal	80000cbc <release>
  return k;
}
    80002356:	854a                	mv	a0,s2
    80002358:	60e2                	ld	ra,24(sp)
    8000235a:	6442                	ld	s0,16(sp)
    8000235c:	64a2                	ld	s1,8(sp)
    8000235e:	6902                	ld	s2,0(sp)
    80002360:	6105                	addi	sp,sp,32
    80002362:	8082                	ret

0000000080002364 <kwait>:
{
    80002364:	715d                	addi	sp,sp,-80
    80002366:	e486                	sd	ra,72(sp)
    80002368:	e0a2                	sd	s0,64(sp)
    8000236a:	fc26                	sd	s1,56(sp)
    8000236c:	f84a                	sd	s2,48(sp)
    8000236e:	f44e                	sd	s3,40(sp)
    80002370:	f052                	sd	s4,32(sp)
    80002372:	ec56                	sd	s5,24(sp)
    80002374:	e85a                	sd	s6,16(sp)
    80002376:	e45e                	sd	s7,8(sp)
    80002378:	0880                	addi	s0,sp,80
    8000237a:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000237c:	eceff0ef          	jal	80001a4a <myproc>
    80002380:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002382:	0000d517          	auipc	a0,0xd
    80002386:	64e50513          	addi	a0,a0,1614 # 8000f9d0 <wait_lock>
    8000238a:	89ffe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    8000238e:	4a15                	li	s4,5
        havekids = 1;
    80002390:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002392:	00014997          	auipc	s3,0x14
    80002396:	45698993          	addi	s3,s3,1110 # 800167e8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000239a:	0000db17          	auipc	s6,0xd
    8000239e:	636b0b13          	addi	s6,s6,1590 # 8000f9d0 <wait_lock>
    800023a2:	a869                	j	8000243c <kwait+0xd8>
          pid = pp->pid;
    800023a4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023a8:	000b8c63          	beqz	s7,800023c0 <kwait+0x5c>
    800023ac:	4691                	li	a3,4
    800023ae:	02c48613          	addi	a2,s1,44
    800023b2:	85de                	mv	a1,s7
    800023b4:	05093503          	ld	a0,80(s2)
    800023b8:	a9cff0ef          	jal	80001654 <copyout>
    800023bc:	02054a63          	bltz	a0,800023f0 <kwait+0x8c>
          freeproc(pp);
    800023c0:	8526                	mv	a0,s1
    800023c2:	85dff0ef          	jal	80001c1e <freeproc>
          release(&pp->lock);
    800023c6:	8526                	mv	a0,s1
    800023c8:	8f5fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    800023cc:	0000d517          	auipc	a0,0xd
    800023d0:	60450513          	addi	a0,a0,1540 # 8000f9d0 <wait_lock>
    800023d4:	8e9fe0ef          	jal	80000cbc <release>
}
    800023d8:	854e                	mv	a0,s3
    800023da:	60a6                	ld	ra,72(sp)
    800023dc:	6406                	ld	s0,64(sp)
    800023de:	74e2                	ld	s1,56(sp)
    800023e0:	7942                	ld	s2,48(sp)
    800023e2:	79a2                	ld	s3,40(sp)
    800023e4:	7a02                	ld	s4,32(sp)
    800023e6:	6ae2                	ld	s5,24(sp)
    800023e8:	6b42                	ld	s6,16(sp)
    800023ea:	6ba2                	ld	s7,8(sp)
    800023ec:	6161                	addi	sp,sp,80
    800023ee:	8082                	ret
            release(&pp->lock);
    800023f0:	8526                	mv	a0,s1
    800023f2:	8cbfe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    800023f6:	0000d517          	auipc	a0,0xd
    800023fa:	5da50513          	addi	a0,a0,1498 # 8000f9d0 <wait_lock>
    800023fe:	8bffe0ef          	jal	80000cbc <release>
            return -1;
    80002402:	59fd                	li	s3,-1
    80002404:	bfd1                	j	800023d8 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002406:	1a848493          	addi	s1,s1,424
    8000240a:	03348063          	beq	s1,s3,8000242a <kwait+0xc6>
      if(pp->parent == p){
    8000240e:	7c9c                	ld	a5,56(s1)
    80002410:	ff279be3          	bne	a5,s2,80002406 <kwait+0xa2>
        acquire(&pp->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	813fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    8000241a:	4c9c                	lw	a5,24(s1)
    8000241c:	f94784e3          	beq	a5,s4,800023a4 <kwait+0x40>
        release(&pp->lock);
    80002420:	8526                	mv	a0,s1
    80002422:	89bfe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002426:	8756                	mv	a4,s5
    80002428:	bff9                	j	80002406 <kwait+0xa2>
    if(!havekids || killed(p)){
    8000242a:	cf19                	beqz	a4,80002448 <kwait+0xe4>
    8000242c:	854a                	mv	a0,s2
    8000242e:	f0dff0ef          	jal	8000233a <killed>
    80002432:	e919                	bnez	a0,80002448 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002434:	85da                	mv	a1,s6
    80002436:	854a                	mv	a0,s2
    80002438:	c9fff0ef          	jal	800020d6 <sleep>
    havekids = 0;
    8000243c:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000243e:	0000e497          	auipc	s1,0xe
    80002442:	9aa48493          	addi	s1,s1,-1622 # 8000fde8 <proc>
    80002446:	b7e1                	j	8000240e <kwait+0xaa>
      release(&wait_lock);
    80002448:	0000d517          	auipc	a0,0xd
    8000244c:	58850513          	addi	a0,a0,1416 # 8000f9d0 <wait_lock>
    80002450:	86dfe0ef          	jal	80000cbc <release>
      return -1;
    80002454:	59fd                	li	s3,-1
    80002456:	b749                	j	800023d8 <kwait+0x74>

0000000080002458 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002458:	7179                	addi	sp,sp,-48
    8000245a:	f406                	sd	ra,40(sp)
    8000245c:	f022                	sd	s0,32(sp)
    8000245e:	ec26                	sd	s1,24(sp)
    80002460:	e84a                	sd	s2,16(sp)
    80002462:	e44e                	sd	s3,8(sp)
    80002464:	e052                	sd	s4,0(sp)
    80002466:	1800                	addi	s0,sp,48
    80002468:	84aa                	mv	s1,a0
    8000246a:	8a2e                	mv	s4,a1
    8000246c:	89b2                	mv	s3,a2
    8000246e:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002470:	ddaff0ef          	jal	80001a4a <myproc>
  if(user_dst){
    80002474:	cc99                	beqz	s1,80002492 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002476:	86ca                	mv	a3,s2
    80002478:	864e                	mv	a2,s3
    8000247a:	85d2                	mv	a1,s4
    8000247c:	6928                	ld	a0,80(a0)
    8000247e:	9d6ff0ef          	jal	80001654 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002482:	70a2                	ld	ra,40(sp)
    80002484:	7402                	ld	s0,32(sp)
    80002486:	64e2                	ld	s1,24(sp)
    80002488:	6942                	ld	s2,16(sp)
    8000248a:	69a2                	ld	s3,8(sp)
    8000248c:	6a02                	ld	s4,0(sp)
    8000248e:	6145                	addi	sp,sp,48
    80002490:	8082                	ret
    memmove((char *)dst, src, len);
    80002492:	0009061b          	sext.w	a2,s2
    80002496:	85ce                	mv	a1,s3
    80002498:	8552                	mv	a0,s4
    8000249a:	8bffe0ef          	jal	80000d58 <memmove>
    return 0;
    8000249e:	8526                	mv	a0,s1
    800024a0:	b7cd                	j	80002482 <either_copyout+0x2a>

00000000800024a2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024a2:	7179                	addi	sp,sp,-48
    800024a4:	f406                	sd	ra,40(sp)
    800024a6:	f022                	sd	s0,32(sp)
    800024a8:	ec26                	sd	s1,24(sp)
    800024aa:	e84a                	sd	s2,16(sp)
    800024ac:	e44e                	sd	s3,8(sp)
    800024ae:	e052                	sd	s4,0(sp)
    800024b0:	1800                	addi	s0,sp,48
    800024b2:	8a2a                	mv	s4,a0
    800024b4:	84ae                	mv	s1,a1
    800024b6:	89b2                	mv	s3,a2
    800024b8:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800024ba:	d90ff0ef          	jal	80001a4a <myproc>
  if(user_src){
    800024be:	cc99                	beqz	s1,800024dc <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800024c0:	86ca                	mv	a3,s2
    800024c2:	864e                	mv	a2,s3
    800024c4:	85d2                	mv	a1,s4
    800024c6:	6928                	ld	a0,80(a0)
    800024c8:	a4aff0ef          	jal	80001712 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024cc:	70a2                	ld	ra,40(sp)
    800024ce:	7402                	ld	s0,32(sp)
    800024d0:	64e2                	ld	s1,24(sp)
    800024d2:	6942                	ld	s2,16(sp)
    800024d4:	69a2                	ld	s3,8(sp)
    800024d6:	6a02                	ld	s4,0(sp)
    800024d8:	6145                	addi	sp,sp,48
    800024da:	8082                	ret
    memmove(dst, (char*)src, len);
    800024dc:	0009061b          	sext.w	a2,s2
    800024e0:	85ce                	mv	a1,s3
    800024e2:	8552                	mv	a0,s4
    800024e4:	875fe0ef          	jal	80000d58 <memmove>
    return 0;
    800024e8:	8526                	mv	a0,s1
    800024ea:	b7cd                	j	800024cc <either_copyin+0x2a>

00000000800024ec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024ec:	715d                	addi	sp,sp,-80
    800024ee:	e486                	sd	ra,72(sp)
    800024f0:	e0a2                	sd	s0,64(sp)
    800024f2:	fc26                	sd	s1,56(sp)
    800024f4:	f84a                	sd	s2,48(sp)
    800024f6:	f44e                	sd	s3,40(sp)
    800024f8:	f052                	sd	s4,32(sp)
    800024fa:	ec56                	sd	s5,24(sp)
    800024fc:	e85a                	sd	s6,16(sp)
    800024fe:	e45e                	sd	s7,8(sp)
    80002500:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002502:	00005517          	auipc	a0,0x5
    80002506:	b7650513          	addi	a0,a0,-1162 # 80007078 <etext+0x78>
    8000250a:	ff1fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000250e:	0000e497          	auipc	s1,0xe
    80002512:	a3248493          	addi	s1,s1,-1486 # 8000ff40 <proc+0x158>
    80002516:	00014917          	auipc	s2,0x14
    8000251a:	42a90913          	addi	s2,s2,1066 # 80016940 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000251e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002520:	00005997          	auipc	s3,0x5
    80002524:	cf898993          	addi	s3,s3,-776 # 80007218 <etext+0x218>
    printf("%d %s %s", p->pid, state, p->name);
    80002528:	00005a97          	auipc	s5,0x5
    8000252c:	cf8a8a93          	addi	s5,s5,-776 # 80007220 <etext+0x220>
    printf("\n");
    80002530:	00005a17          	auipc	s4,0x5
    80002534:	b48a0a13          	addi	s4,s4,-1208 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002538:	00005b97          	auipc	s7,0x5
    8000253c:	220b8b93          	addi	s7,s7,544 # 80007758 <states.0>
    80002540:	a829                	j	8000255a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002542:	ed86a583          	lw	a1,-296(a3)
    80002546:	8556                	mv	a0,s5
    80002548:	fb3fd0ef          	jal	800004fa <printf>
    printf("\n");
    8000254c:	8552                	mv	a0,s4
    8000254e:	fadfd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002552:	1a848493          	addi	s1,s1,424
    80002556:	03248263          	beq	s1,s2,8000257a <procdump+0x8e>
    if(p->state == UNUSED)
    8000255a:	86a6                	mv	a3,s1
    8000255c:	ec04a783          	lw	a5,-320(s1)
    80002560:	dbed                	beqz	a5,80002552 <procdump+0x66>
      state = "???";
    80002562:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002564:	fcfb6fe3          	bltu	s6,a5,80002542 <procdump+0x56>
    80002568:	02079713          	slli	a4,a5,0x20
    8000256c:	01d75793          	srli	a5,a4,0x1d
    80002570:	97de                	add	a5,a5,s7
    80002572:	6390                	ld	a2,0(a5)
    80002574:	f679                	bnez	a2,80002542 <procdump+0x56>
      state = "???";
    80002576:	864e                	mv	a2,s3
    80002578:	b7e9                	j	80002542 <procdump+0x56>
  }
}
    8000257a:	60a6                	ld	ra,72(sp)
    8000257c:	6406                	ld	s0,64(sp)
    8000257e:	74e2                	ld	s1,56(sp)
    80002580:	7942                	ld	s2,48(sp)
    80002582:	79a2                	ld	s3,40(sp)
    80002584:	7a02                	ld	s4,32(sp)
    80002586:	6ae2                	ld	s5,24(sp)
    80002588:	6b42                	ld	s6,16(sp)
    8000258a:	6ba2                	ld	s7,8(sp)
    8000258c:	6161                	addi	sp,sp,80
    8000258e:	8082                	ret

0000000080002590 <set_nice>:

int
set_nice(int nice)
{
    80002590:	1101                	addi	sp,sp,-32
    80002592:	ec06                	sd	ra,24(sp)
    80002594:	e822                	sd	s0,16(sp)
    80002596:	e426                	sd	s1,8(sp)
    80002598:	1000                	addi	s0,sp,32
    8000259a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000259c:	caeff0ef          	jal	80001a4a <myproc>
  if (p->state != RUNNING || nice < -3 || nice > 2)
    800025a0:	4d14                	lw	a3,24(a0)
    800025a2:	4711                	li	a4,4
    800025a4:	00e69d63          	bne	a3,a4,800025be <set_nice+0x2e>
    800025a8:	87aa                	mv	a5,a0
    800025aa:	0034871b          	addiw	a4,s1,3
    800025ae:	4695                	li	a3,5
    return 1;
    800025b0:	4505                	li	a0,1
  if (p->state != RUNNING || nice < -3 || nice > 2)
    800025b2:	00e6e763          	bltu	a3,a4,800025c0 <set_nice+0x30>
  p->nice = nice;
    800025b6:	1697a423          	sw	s1,360(a5)
  return 0;
    800025ba:	4501                	li	a0,0
    800025bc:	a011                	j	800025c0 <set_nice+0x30>
    return 1;
    800025be:	4505                	li	a0,1
    800025c0:	60e2                	ld	ra,24(sp)
    800025c2:	6442                	ld	s0,16(sp)
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	6105                	addi	sp,sp,32
    800025c8:	8082                	ret

00000000800025ca <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    800025ca:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800025ce:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800025d2:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800025d4:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800025d6:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800025da:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800025de:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800025e2:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800025e6:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800025ea:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800025ee:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800025f2:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800025f6:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800025fa:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800025fe:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002602:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002606:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002608:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000260a:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000260e:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002612:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002616:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000261a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000261e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002622:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002626:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000262a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000262e:	0685bd83          	ld	s11,104(a1)

        ret
    80002632:	8082                	ret

0000000080002634 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002634:	1141                	addi	sp,sp,-16
    80002636:	e406                	sd	ra,8(sp)
    80002638:	e022                	sd	s0,0(sp)
    8000263a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000263c:	00005597          	auipc	a1,0x5
    80002640:	c2458593          	addi	a1,a1,-988 # 80007260 <etext+0x260>
    80002644:	00014517          	auipc	a0,0x14
    80002648:	1a450513          	addi	a0,a0,420 # 800167e8 <tickslock>
    8000264c:	d52fe0ef          	jal	80000b9e <initlock>
}
    80002650:	60a2                	ld	ra,8(sp)
    80002652:	6402                	ld	s0,0(sp)
    80002654:	0141                	addi	sp,sp,16
    80002656:	8082                	ret

0000000080002658 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002658:	1141                	addi	sp,sp,-16
    8000265a:	e406                	sd	ra,8(sp)
    8000265c:	e022                	sd	s0,0(sp)
    8000265e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002660:	00003797          	auipc	a5,0x3
    80002664:	fc078793          	addi	a5,a5,-64 # 80005620 <kernelvec>
    80002668:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000266c:	60a2                	ld	ra,8(sp)
    8000266e:	6402                	ld	s0,0(sp)
    80002670:	0141                	addi	sp,sp,16
    80002672:	8082                	ret

0000000080002674 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002674:	1141                	addi	sp,sp,-16
    80002676:	e406                	sd	ra,8(sp)
    80002678:	e022                	sd	s0,0(sp)
    8000267a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000267c:	bceff0ef          	jal	80001a4a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002680:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002684:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002686:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000268a:	04000737          	lui	a4,0x4000
    8000268e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002690:	0732                	slli	a4,a4,0xc
    80002692:	00004797          	auipc	a5,0x4
    80002696:	96e78793          	addi	a5,a5,-1682 # 80006000 <_trampoline>
    8000269a:	00004697          	auipc	a3,0x4
    8000269e:	96668693          	addi	a3,a3,-1690 # 80006000 <_trampoline>
    800026a2:	8f95                	sub	a5,a5,a3
    800026a4:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026a6:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026aa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026ac:	18002773          	csrr	a4,satp
    800026b0:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026b2:	6d38                	ld	a4,88(a0)
    800026b4:	613c                	ld	a5,64(a0)
    800026b6:	6685                	lui	a3,0x1
    800026b8:	97b6                	add	a5,a5,a3
    800026ba:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800026bc:	6d3c                	ld	a5,88(a0)
    800026be:	00000717          	auipc	a4,0x0
    800026c2:	0fc70713          	addi	a4,a4,252 # 800027ba <usertrap>
    800026c6:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026c8:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026ca:	8712                	mv	a4,tp
    800026cc:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ce:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026d2:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026d6:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026da:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026de:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026e0:	6f9c                	ld	a5,24(a5)
    800026e2:	14179073          	csrw	sepc,a5
}
    800026e6:	60a2                	ld	ra,8(sp)
    800026e8:	6402                	ld	s0,0(sp)
    800026ea:	0141                	addi	sp,sp,16
    800026ec:	8082                	ret

00000000800026ee <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026ee:	1141                	addi	sp,sp,-16
    800026f0:	e406                	sd	ra,8(sp)
    800026f2:	e022                	sd	s0,0(sp)
    800026f4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800026f6:	b20ff0ef          	jal	80001a16 <cpuid>
    800026fa:	cd11                	beqz	a0,80002716 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800026fc:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002700:	000f4737          	lui	a4,0xf4
    80002704:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002708:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000270a:	14d79073          	csrw	stimecmp,a5
}
    8000270e:	60a2                	ld	ra,8(sp)
    80002710:	6402                	ld	s0,0(sp)
    80002712:	0141                	addi	sp,sp,16
    80002714:	8082                	ret
    acquire(&tickslock);
    80002716:	00014517          	auipc	a0,0x14
    8000271a:	0d250513          	addi	a0,a0,210 # 800167e8 <tickslock>
    8000271e:	d0afe0ef          	jal	80000c28 <acquire>
    ticks++;
    80002722:	00005717          	auipc	a4,0x5
    80002726:	17670713          	addi	a4,a4,374 # 80007898 <ticks>
    8000272a:	431c                	lw	a5,0(a4)
    8000272c:	2785                	addiw	a5,a5,1
    8000272e:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002730:	853a                	mv	a0,a4
    80002732:	9f1ff0ef          	jal	80002122 <wakeup>
    release(&tickslock);
    80002736:	00014517          	auipc	a0,0x14
    8000273a:	0b250513          	addi	a0,a0,178 # 800167e8 <tickslock>
    8000273e:	d7efe0ef          	jal	80000cbc <release>
    80002742:	bf6d                	j	800026fc <clockintr+0xe>

0000000080002744 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002744:	1101                	addi	sp,sp,-32
    80002746:	ec06                	sd	ra,24(sp)
    80002748:	e822                	sd	s0,16(sp)
    8000274a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000274c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002750:	57fd                	li	a5,-1
    80002752:	17fe                	slli	a5,a5,0x3f
    80002754:	07a5                	addi	a5,a5,9
    80002756:	00f70c63          	beq	a4,a5,8000276e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000275a:	57fd                	li	a5,-1
    8000275c:	17fe                	slli	a5,a5,0x3f
    8000275e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002760:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002762:	04f70863          	beq	a4,a5,800027b2 <devintr+0x6e>
  }
}
    80002766:	60e2                	ld	ra,24(sp)
    80002768:	6442                	ld	s0,16(sp)
    8000276a:	6105                	addi	sp,sp,32
    8000276c:	8082                	ret
    8000276e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002770:	75d020ef          	jal	800056cc <plic_claim>
    80002774:	872a                	mv	a4,a0
    80002776:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002778:	47a9                	li	a5,10
    8000277a:	00f50963          	beq	a0,a5,8000278c <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    8000277e:	4785                	li	a5,1
    80002780:	00f50963          	beq	a0,a5,80002792 <devintr+0x4e>
    return 1;
    80002784:	4505                	li	a0,1
    } else if(irq){
    80002786:	eb09                	bnez	a4,80002798 <devintr+0x54>
    80002788:	64a2                	ld	s1,8(sp)
    8000278a:	bff1                	j	80002766 <devintr+0x22>
      uartintr();
    8000278c:	a68fe0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002790:	a819                	j	800027a6 <devintr+0x62>
      virtio_disk_intr();
    80002792:	3d0030ef          	jal	80005b62 <virtio_disk_intr>
    if(irq)
    80002796:	a801                	j	800027a6 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002798:	85ba                	mv	a1,a4
    8000279a:	00005517          	auipc	a0,0x5
    8000279e:	ace50513          	addi	a0,a0,-1330 # 80007268 <etext+0x268>
    800027a2:	d59fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    800027a6:	8526                	mv	a0,s1
    800027a8:	745020ef          	jal	800056ec <plic_complete>
    return 1;
    800027ac:	4505                	li	a0,1
    800027ae:	64a2                	ld	s1,8(sp)
    800027b0:	bf5d                	j	80002766 <devintr+0x22>
    clockintr();
    800027b2:	f3dff0ef          	jal	800026ee <clockintr>
    return 2;
    800027b6:	4509                	li	a0,2
    800027b8:	b77d                	j	80002766 <devintr+0x22>

00000000800027ba <usertrap>:
{
    800027ba:	1101                	addi	sp,sp,-32
    800027bc:	ec06                	sd	ra,24(sp)
    800027be:	e822                	sd	s0,16(sp)
    800027c0:	e426                	sd	s1,8(sp)
    800027c2:	e04a                	sd	s2,0(sp)
    800027c4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027c6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027ca:	1007f793          	andi	a5,a5,256
    800027ce:	eba5                	bnez	a5,8000283e <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027d0:	00003797          	auipc	a5,0x3
    800027d4:	e5078793          	addi	a5,a5,-432 # 80005620 <kernelvec>
    800027d8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027dc:	a6eff0ef          	jal	80001a4a <myproc>
    800027e0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027e2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027e4:	14102773          	csrr	a4,sepc
    800027e8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027ea:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027ee:	47a1                	li	a5,8
    800027f0:	04f70d63          	beq	a4,a5,8000284a <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800027f4:	f51ff0ef          	jal	80002744 <devintr>
    800027f8:	892a                	mv	s2,a0
    800027fa:	e945                	bnez	a0,800028aa <usertrap+0xf0>
    800027fc:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002800:	47bd                	li	a5,15
    80002802:	08f70863          	beq	a4,a5,80002892 <usertrap+0xd8>
    80002806:	14202773          	csrr	a4,scause
    8000280a:	47b5                	li	a5,13
    8000280c:	08f70363          	beq	a4,a5,80002892 <usertrap+0xd8>
    80002810:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002814:	5890                	lw	a2,48(s1)
    80002816:	00005517          	auipc	a0,0x5
    8000281a:	a9250513          	addi	a0,a0,-1390 # 800072a8 <etext+0x2a8>
    8000281e:	cddfd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002822:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002826:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000282a:	00005517          	auipc	a0,0x5
    8000282e:	aae50513          	addi	a0,a0,-1362 # 800072d8 <etext+0x2d8>
    80002832:	cc9fd0ef          	jal	800004fa <printf>
    setkilled(p);
    80002836:	8526                	mv	a0,s1
    80002838:	adfff0ef          	jal	80002316 <setkilled>
    8000283c:	a035                	j	80002868 <usertrap+0xae>
    panic("usertrap: not from user mode");
    8000283e:	00005517          	auipc	a0,0x5
    80002842:	a4a50513          	addi	a0,a0,-1462 # 80007288 <etext+0x288>
    80002846:	fdffd0ef          	jal	80000824 <panic>
    if(killed(p))
    8000284a:	af1ff0ef          	jal	8000233a <killed>
    8000284e:	ed15                	bnez	a0,8000288a <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002850:	6cb8                	ld	a4,88(s1)
    80002852:	6f1c                	ld	a5,24(a4)
    80002854:	0791                	addi	a5,a5,4
    80002856:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002858:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000285c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002860:	10079073          	csrw	sstatus,a5
    syscall();
    80002864:	240000ef          	jal	80002aa4 <syscall>
  if(killed(p))
    80002868:	8526                	mv	a0,s1
    8000286a:	ad1ff0ef          	jal	8000233a <killed>
    8000286e:	e139                	bnez	a0,800028b4 <usertrap+0xfa>
  prepare_return();
    80002870:	e05ff0ef          	jal	80002674 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002874:	68a8                	ld	a0,80(s1)
    80002876:	8131                	srli	a0,a0,0xc
    80002878:	57fd                	li	a5,-1
    8000287a:	17fe                	slli	a5,a5,0x3f
    8000287c:	8d5d                	or	a0,a0,a5
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6902                	ld	s2,0(sp)
    80002886:	6105                	addi	sp,sp,32
    80002888:	8082                	ret
      kexit(-1);
    8000288a:	557d                	li	a0,-1
    8000288c:	96bff0ef          	jal	800021f6 <kexit>
    80002890:	b7c1                	j	80002850 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002892:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002896:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    8000289a:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    8000289c:	00163613          	seqz	a2,a2
    800028a0:	68a8                	ld	a0,80(s1)
    800028a2:	d2ffe0ef          	jal	800015d0 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800028a6:	f169                	bnez	a0,80002868 <usertrap+0xae>
    800028a8:	b7a5                	j	80002810 <usertrap+0x56>
  if(killed(p))
    800028aa:	8526                	mv	a0,s1
    800028ac:	a8fff0ef          	jal	8000233a <killed>
    800028b0:	c511                	beqz	a0,800028bc <usertrap+0x102>
    800028b2:	a011                	j	800028b6 <usertrap+0xfc>
    800028b4:	4901                	li	s2,0
    kexit(-1);
    800028b6:	557d                	li	a0,-1
    800028b8:	93fff0ef          	jal	800021f6 <kexit>
  if(which_dev == 2)
    800028bc:	4789                	li	a5,2
    800028be:	faf919e3          	bne	s2,a5,80002870 <usertrap+0xb6>
    yield();
    800028c2:	fe2ff0ef          	jal	800020a4 <yield>
    800028c6:	b76d                	j	80002870 <usertrap+0xb6>

00000000800028c8 <kerneltrap>:
{
    800028c8:	7179                	addi	sp,sp,-48
    800028ca:	f406                	sd	ra,40(sp)
    800028cc:	f022                	sd	s0,32(sp)
    800028ce:	ec26                	sd	s1,24(sp)
    800028d0:	e84a                	sd	s2,16(sp)
    800028d2:	e44e                	sd	s3,8(sp)
    800028d4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028d6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028da:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028de:	142027f3          	csrr	a5,scause
    800028e2:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800028e4:	1004f793          	andi	a5,s1,256
    800028e8:	c795                	beqz	a5,80002914 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028ee:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028f0:	eb85                	bnez	a5,80002920 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    800028f2:	e53ff0ef          	jal	80002744 <devintr>
    800028f6:	c91d                	beqz	a0,8000292c <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    800028f8:	4789                	li	a5,2
    800028fa:	04f50a63          	beq	a0,a5,8000294e <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028fe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002902:	10049073          	csrw	sstatus,s1
}
    80002906:	70a2                	ld	ra,40(sp)
    80002908:	7402                	ld	s0,32(sp)
    8000290a:	64e2                	ld	s1,24(sp)
    8000290c:	6942                	ld	s2,16(sp)
    8000290e:	69a2                	ld	s3,8(sp)
    80002910:	6145                	addi	sp,sp,48
    80002912:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002914:	00005517          	auipc	a0,0x5
    80002918:	9ec50513          	addi	a0,a0,-1556 # 80007300 <etext+0x300>
    8000291c:	f09fd0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002920:	00005517          	auipc	a0,0x5
    80002924:	a0850513          	addi	a0,a0,-1528 # 80007328 <etext+0x328>
    80002928:	efdfd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000292c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002930:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002934:	85ce                	mv	a1,s3
    80002936:	00005517          	auipc	a0,0x5
    8000293a:	a1250513          	addi	a0,a0,-1518 # 80007348 <etext+0x348>
    8000293e:	bbdfd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002942:	00005517          	auipc	a0,0x5
    80002946:	a2e50513          	addi	a0,a0,-1490 # 80007370 <etext+0x370>
    8000294a:	edbfd0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000294e:	8fcff0ef          	jal	80001a4a <myproc>
    80002952:	d555                	beqz	a0,800028fe <kerneltrap+0x36>
    yield();
    80002954:	f50ff0ef          	jal	800020a4 <yield>
    80002958:	b75d                	j	800028fe <kerneltrap+0x36>

000000008000295a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000295a:	1101                	addi	sp,sp,-32
    8000295c:	ec06                	sd	ra,24(sp)
    8000295e:	e822                	sd	s0,16(sp)
    80002960:	e426                	sd	s1,8(sp)
    80002962:	1000                	addi	s0,sp,32
    80002964:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002966:	8e4ff0ef          	jal	80001a4a <myproc>
  switch (n) {
    8000296a:	4795                	li	a5,5
    8000296c:	0497e163          	bltu	a5,s1,800029ae <argraw+0x54>
    80002970:	048a                	slli	s1,s1,0x2
    80002972:	00005717          	auipc	a4,0x5
    80002976:	e1670713          	addi	a4,a4,-490 # 80007788 <states.0+0x30>
    8000297a:	94ba                	add	s1,s1,a4
    8000297c:	409c                	lw	a5,0(s1)
    8000297e:	97ba                	add	a5,a5,a4
    80002980:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002982:	6d3c                	ld	a5,88(a0)
    80002984:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002986:	60e2                	ld	ra,24(sp)
    80002988:	6442                	ld	s0,16(sp)
    8000298a:	64a2                	ld	s1,8(sp)
    8000298c:	6105                	addi	sp,sp,32
    8000298e:	8082                	ret
    return p->trapframe->a1;
    80002990:	6d3c                	ld	a5,88(a0)
    80002992:	7fa8                	ld	a0,120(a5)
    80002994:	bfcd                	j	80002986 <argraw+0x2c>
    return p->trapframe->a2;
    80002996:	6d3c                	ld	a5,88(a0)
    80002998:	63c8                	ld	a0,128(a5)
    8000299a:	b7f5                	j	80002986 <argraw+0x2c>
    return p->trapframe->a3;
    8000299c:	6d3c                	ld	a5,88(a0)
    8000299e:	67c8                	ld	a0,136(a5)
    800029a0:	b7dd                	j	80002986 <argraw+0x2c>
    return p->trapframe->a4;
    800029a2:	6d3c                	ld	a5,88(a0)
    800029a4:	6bc8                	ld	a0,144(a5)
    800029a6:	b7c5                	j	80002986 <argraw+0x2c>
    return p->trapframe->a5;
    800029a8:	6d3c                	ld	a5,88(a0)
    800029aa:	6fc8                	ld	a0,152(a5)
    800029ac:	bfe9                	j	80002986 <argraw+0x2c>
  panic("argraw");
    800029ae:	00005517          	auipc	a0,0x5
    800029b2:	9d250513          	addi	a0,a0,-1582 # 80007380 <etext+0x380>
    800029b6:	e6ffd0ef          	jal	80000824 <panic>

00000000800029ba <fetchaddr>:
{
    800029ba:	1101                	addi	sp,sp,-32
    800029bc:	ec06                	sd	ra,24(sp)
    800029be:	e822                	sd	s0,16(sp)
    800029c0:	e426                	sd	s1,8(sp)
    800029c2:	e04a                	sd	s2,0(sp)
    800029c4:	1000                	addi	s0,sp,32
    800029c6:	84aa                	mv	s1,a0
    800029c8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029ca:	880ff0ef          	jal	80001a4a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800029ce:	653c                	ld	a5,72(a0)
    800029d0:	02f4f663          	bgeu	s1,a5,800029fc <fetchaddr+0x42>
    800029d4:	00848713          	addi	a4,s1,8
    800029d8:	02e7e463          	bltu	a5,a4,80002a00 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800029dc:	46a1                	li	a3,8
    800029de:	8626                	mv	a2,s1
    800029e0:	85ca                	mv	a1,s2
    800029e2:	6928                	ld	a0,80(a0)
    800029e4:	d2ffe0ef          	jal	80001712 <copyin>
    800029e8:	00a03533          	snez	a0,a0
    800029ec:	40a0053b          	negw	a0,a0
}
    800029f0:	60e2                	ld	ra,24(sp)
    800029f2:	6442                	ld	s0,16(sp)
    800029f4:	64a2                	ld	s1,8(sp)
    800029f6:	6902                	ld	s2,0(sp)
    800029f8:	6105                	addi	sp,sp,32
    800029fa:	8082                	ret
    return -1;
    800029fc:	557d                	li	a0,-1
    800029fe:	bfcd                	j	800029f0 <fetchaddr+0x36>
    80002a00:	557d                	li	a0,-1
    80002a02:	b7fd                	j	800029f0 <fetchaddr+0x36>

0000000080002a04 <fetchstr>:
{
    80002a04:	7179                	addi	sp,sp,-48
    80002a06:	f406                	sd	ra,40(sp)
    80002a08:	f022                	sd	s0,32(sp)
    80002a0a:	ec26                	sd	s1,24(sp)
    80002a0c:	e84a                	sd	s2,16(sp)
    80002a0e:	e44e                	sd	s3,8(sp)
    80002a10:	1800                	addi	s0,sp,48
    80002a12:	89aa                	mv	s3,a0
    80002a14:	84ae                	mv	s1,a1
    80002a16:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002a18:	832ff0ef          	jal	80001a4a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002a1c:	86ca                	mv	a3,s2
    80002a1e:	864e                	mv	a2,s3
    80002a20:	85a6                	mv	a1,s1
    80002a22:	6928                	ld	a0,80(a0)
    80002a24:	ad5fe0ef          	jal	800014f8 <copyinstr>
    80002a28:	00054c63          	bltz	a0,80002a40 <fetchstr+0x3c>
  return strlen(buf);
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	c54fe0ef          	jal	80000e82 <strlen>
}
    80002a32:	70a2                	ld	ra,40(sp)
    80002a34:	7402                	ld	s0,32(sp)
    80002a36:	64e2                	ld	s1,24(sp)
    80002a38:	6942                	ld	s2,16(sp)
    80002a3a:	69a2                	ld	s3,8(sp)
    80002a3c:	6145                	addi	sp,sp,48
    80002a3e:	8082                	ret
    return -1;
    80002a40:	557d                	li	a0,-1
    80002a42:	bfc5                	j	80002a32 <fetchstr+0x2e>

0000000080002a44 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002a44:	1101                	addi	sp,sp,-32
    80002a46:	ec06                	sd	ra,24(sp)
    80002a48:	e822                	sd	s0,16(sp)
    80002a4a:	e426                	sd	s1,8(sp)
    80002a4c:	1000                	addi	s0,sp,32
    80002a4e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a50:	f0bff0ef          	jal	8000295a <argraw>
    80002a54:	c088                	sw	a0,0(s1)
}
    80002a56:	60e2                	ld	ra,24(sp)
    80002a58:	6442                	ld	s0,16(sp)
    80002a5a:	64a2                	ld	s1,8(sp)
    80002a5c:	6105                	addi	sp,sp,32
    80002a5e:	8082                	ret

0000000080002a60 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002a60:	1101                	addi	sp,sp,-32
    80002a62:	ec06                	sd	ra,24(sp)
    80002a64:	e822                	sd	s0,16(sp)
    80002a66:	e426                	sd	s1,8(sp)
    80002a68:	1000                	addi	s0,sp,32
    80002a6a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a6c:	eefff0ef          	jal	8000295a <argraw>
    80002a70:	e088                	sd	a0,0(s1)
}
    80002a72:	60e2                	ld	ra,24(sp)
    80002a74:	6442                	ld	s0,16(sp)
    80002a76:	64a2                	ld	s1,8(sp)
    80002a78:	6105                	addi	sp,sp,32
    80002a7a:	8082                	ret

0000000080002a7c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a7c:	1101                	addi	sp,sp,-32
    80002a7e:	ec06                	sd	ra,24(sp)
    80002a80:	e822                	sd	s0,16(sp)
    80002a82:	e426                	sd	s1,8(sp)
    80002a84:	e04a                	sd	s2,0(sp)
    80002a86:	1000                	addi	s0,sp,32
    80002a88:	892e                	mv	s2,a1
    80002a8a:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002a8c:	ecfff0ef          	jal	8000295a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002a90:	8626                	mv	a2,s1
    80002a92:	85ca                	mv	a1,s2
    80002a94:	f71ff0ef          	jal	80002a04 <fetchstr>
}
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6902                	ld	s2,0(sp)
    80002aa0:	6105                	addi	sp,sp,32
    80002aa2:	8082                	ret

0000000080002aa4 <syscall>:
[SYS_set_nice] sys_set_nice,
};

void
syscall(void)
{
    80002aa4:	1101                	addi	sp,sp,-32
    80002aa6:	ec06                	sd	ra,24(sp)
    80002aa8:	e822                	sd	s0,16(sp)
    80002aaa:	e426                	sd	s1,8(sp)
    80002aac:	e04a                	sd	s2,0(sp)
    80002aae:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ab0:	f9bfe0ef          	jal	80001a4a <myproc>
    80002ab4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ab6:	05853903          	ld	s2,88(a0)
    80002aba:	0a893783          	ld	a5,168(s2)
    80002abe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ac2:	37fd                	addiw	a5,a5,-1
    80002ac4:	4755                	li	a4,21
    80002ac6:	00f76f63          	bltu	a4,a5,80002ae4 <syscall+0x40>
    80002aca:	00369713          	slli	a4,a3,0x3
    80002ace:	00005797          	auipc	a5,0x5
    80002ad2:	cd278793          	addi	a5,a5,-814 # 800077a0 <syscalls>
    80002ad6:	97ba                	add	a5,a5,a4
    80002ad8:	639c                	ld	a5,0(a5)
    80002ada:	c789                	beqz	a5,80002ae4 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002adc:	9782                	jalr	a5
    80002ade:	06a93823          	sd	a0,112(s2)
    80002ae2:	a829                	j	80002afc <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ae4:	15848613          	addi	a2,s1,344
    80002ae8:	588c                	lw	a1,48(s1)
    80002aea:	00005517          	auipc	a0,0x5
    80002aee:	89e50513          	addi	a0,a0,-1890 # 80007388 <etext+0x388>
    80002af2:	a09fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002af6:	6cbc                	ld	a5,88(s1)
    80002af8:	577d                	li	a4,-1
    80002afa:	fbb8                	sd	a4,112(a5)
  }
}
    80002afc:	60e2                	ld	ra,24(sp)
    80002afe:	6442                	ld	s0,16(sp)
    80002b00:	64a2                	ld	s1,8(sp)
    80002b02:	6902                	ld	s2,0(sp)
    80002b04:	6105                	addi	sp,sp,32
    80002b06:	8082                	ret

0000000080002b08 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002b08:	1101                	addi	sp,sp,-32
    80002b0a:	ec06                	sd	ra,24(sp)
    80002b0c:	e822                	sd	s0,16(sp)
    80002b0e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002b10:	fec40593          	addi	a1,s0,-20
    80002b14:	4501                	li	a0,0
    80002b16:	f2fff0ef          	jal	80002a44 <argint>
  kexit(n);
    80002b1a:	fec42503          	lw	a0,-20(s0)
    80002b1e:	ed8ff0ef          	jal	800021f6 <kexit>
  return 0;  // not reached
}
    80002b22:	4501                	li	a0,0
    80002b24:	60e2                	ld	ra,24(sp)
    80002b26:	6442                	ld	s0,16(sp)
    80002b28:	6105                	addi	sp,sp,32
    80002b2a:	8082                	ret

0000000080002b2c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b2c:	1141                	addi	sp,sp,-16
    80002b2e:	e406                	sd	ra,8(sp)
    80002b30:	e022                	sd	s0,0(sp)
    80002b32:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002b34:	f17fe0ef          	jal	80001a4a <myproc>
}
    80002b38:	5908                	lw	a0,48(a0)
    80002b3a:	60a2                	ld	ra,8(sp)
    80002b3c:	6402                	ld	s0,0(sp)
    80002b3e:	0141                	addi	sp,sp,16
    80002b40:	8082                	ret

0000000080002b42 <sys_fork>:

uint64
sys_fork(void)
{
    80002b42:	1141                	addi	sp,sp,-16
    80002b44:	e406                	sd	ra,8(sp)
    80002b46:	e022                	sd	s0,0(sp)
    80002b48:	0800                	addi	s0,sp,16
  return kfork();
    80002b4a:	a76ff0ef          	jal	80001dc0 <kfork>
}
    80002b4e:	60a2                	ld	ra,8(sp)
    80002b50:	6402                	ld	s0,0(sp)
    80002b52:	0141                	addi	sp,sp,16
    80002b54:	8082                	ret

0000000080002b56 <sys_wait>:

uint64
sys_wait(void)
{
    80002b56:	1101                	addi	sp,sp,-32
    80002b58:	ec06                	sd	ra,24(sp)
    80002b5a:	e822                	sd	s0,16(sp)
    80002b5c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002b5e:	fe840593          	addi	a1,s0,-24
    80002b62:	4501                	li	a0,0
    80002b64:	efdff0ef          	jal	80002a60 <argaddr>
  return kwait(p);
    80002b68:	fe843503          	ld	a0,-24(s0)
    80002b6c:	ff8ff0ef          	jal	80002364 <kwait>
}
    80002b70:	60e2                	ld	ra,24(sp)
    80002b72:	6442                	ld	s0,16(sp)
    80002b74:	6105                	addi	sp,sp,32
    80002b76:	8082                	ret

0000000080002b78 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002b78:	7179                	addi	sp,sp,-48
    80002b7a:	f406                	sd	ra,40(sp)
    80002b7c:	f022                	sd	s0,32(sp)
    80002b7e:	ec26                	sd	s1,24(sp)
    80002b80:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002b82:	fd840593          	addi	a1,s0,-40
    80002b86:	4501                	li	a0,0
    80002b88:	ebdff0ef          	jal	80002a44 <argint>
  argint(1, &t);
    80002b8c:	fdc40593          	addi	a1,s0,-36
    80002b90:	4505                	li	a0,1
    80002b92:	eb3ff0ef          	jal	80002a44 <argint>
  addr = myproc()->sz;
    80002b96:	eb5fe0ef          	jal	80001a4a <myproc>
    80002b9a:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002b9c:	fdc42703          	lw	a4,-36(s0)
    80002ba0:	4785                	li	a5,1
    80002ba2:	02f70763          	beq	a4,a5,80002bd0 <sys_sbrk+0x58>
    80002ba6:	fd842783          	lw	a5,-40(s0)
    80002baa:	0207c363          	bltz	a5,80002bd0 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80002bae:	97a6                	add	a5,a5,s1
      return -1;
    if(addr + n > TRAPFRAME)
    80002bb0:	02000737          	lui	a4,0x2000
    80002bb4:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002bb6:	0736                	slli	a4,a4,0xd
    80002bb8:	02f76a63          	bltu	a4,a5,80002bec <sys_sbrk+0x74>
    80002bbc:	0297e863          	bltu	a5,s1,80002bec <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80002bc0:	e8bfe0ef          	jal	80001a4a <myproc>
    80002bc4:	fd842703          	lw	a4,-40(s0)
    80002bc8:	653c                	ld	a5,72(a0)
    80002bca:	97ba                	add	a5,a5,a4
    80002bcc:	e53c                	sd	a5,72(a0)
    80002bce:	a039                	j	80002bdc <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002bd0:	fd842503          	lw	a0,-40(s0)
    80002bd4:	98aff0ef          	jal	80001d5e <growproc>
    80002bd8:	00054863          	bltz	a0,80002be8 <sys_sbrk+0x70>
  }
  return addr;
}
    80002bdc:	8526                	mv	a0,s1
    80002bde:	70a2                	ld	ra,40(sp)
    80002be0:	7402                	ld	s0,32(sp)
    80002be2:	64e2                	ld	s1,24(sp)
    80002be4:	6145                	addi	sp,sp,48
    80002be6:	8082                	ret
      return -1;
    80002be8:	54fd                	li	s1,-1
    80002bea:	bfcd                	j	80002bdc <sys_sbrk+0x64>
      return -1;
    80002bec:	54fd                	li	s1,-1
    80002bee:	b7fd                	j	80002bdc <sys_sbrk+0x64>

0000000080002bf0 <sys_pause>:

uint64
sys_pause(void)
{
    80002bf0:	7139                	addi	sp,sp,-64
    80002bf2:	fc06                	sd	ra,56(sp)
    80002bf4:	f822                	sd	s0,48(sp)
    80002bf6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002bf8:	fcc40593          	addi	a1,s0,-52
    80002bfc:	4501                	li	a0,0
    80002bfe:	e47ff0ef          	jal	80002a44 <argint>
  if(n < 0)
    80002c02:	fcc42783          	lw	a5,-52(s0)
    80002c06:	0607c863          	bltz	a5,80002c76 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002c0a:	00014517          	auipc	a0,0x14
    80002c0e:	bde50513          	addi	a0,a0,-1058 # 800167e8 <tickslock>
    80002c12:	816fe0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002c16:	fcc42783          	lw	a5,-52(s0)
    80002c1a:	c3b9                	beqz	a5,80002c60 <sys_pause+0x70>
    80002c1c:	f426                	sd	s1,40(sp)
    80002c1e:	f04a                	sd	s2,32(sp)
    80002c20:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002c22:	00005997          	auipc	s3,0x5
    80002c26:	c769a983          	lw	s3,-906(s3) # 80007898 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c2a:	00014917          	auipc	s2,0x14
    80002c2e:	bbe90913          	addi	s2,s2,-1090 # 800167e8 <tickslock>
    80002c32:	00005497          	auipc	s1,0x5
    80002c36:	c6648493          	addi	s1,s1,-922 # 80007898 <ticks>
    if(killed(myproc())){
    80002c3a:	e11fe0ef          	jal	80001a4a <myproc>
    80002c3e:	efcff0ef          	jal	8000233a <killed>
    80002c42:	ed0d                	bnez	a0,80002c7c <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002c44:	85ca                	mv	a1,s2
    80002c46:	8526                	mv	a0,s1
    80002c48:	c8eff0ef          	jal	800020d6 <sleep>
  while(ticks - ticks0 < n){
    80002c4c:	409c                	lw	a5,0(s1)
    80002c4e:	413787bb          	subw	a5,a5,s3
    80002c52:	fcc42703          	lw	a4,-52(s0)
    80002c56:	fee7e2e3          	bltu	a5,a4,80002c3a <sys_pause+0x4a>
    80002c5a:	74a2                	ld	s1,40(sp)
    80002c5c:	7902                	ld	s2,32(sp)
    80002c5e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002c60:	00014517          	auipc	a0,0x14
    80002c64:	b8850513          	addi	a0,a0,-1144 # 800167e8 <tickslock>
    80002c68:	854fe0ef          	jal	80000cbc <release>
  return 0;
    80002c6c:	4501                	li	a0,0
}
    80002c6e:	70e2                	ld	ra,56(sp)
    80002c70:	7442                	ld	s0,48(sp)
    80002c72:	6121                	addi	sp,sp,64
    80002c74:	8082                	ret
    n = 0;
    80002c76:	fc042623          	sw	zero,-52(s0)
    80002c7a:	bf41                	j	80002c0a <sys_pause+0x1a>
      release(&tickslock);
    80002c7c:	00014517          	auipc	a0,0x14
    80002c80:	b6c50513          	addi	a0,a0,-1172 # 800167e8 <tickslock>
    80002c84:	838fe0ef          	jal	80000cbc <release>
      return -1;
    80002c88:	557d                	li	a0,-1
    80002c8a:	74a2                	ld	s1,40(sp)
    80002c8c:	7902                	ld	s2,32(sp)
    80002c8e:	69e2                	ld	s3,24(sp)
    80002c90:	bff9                	j	80002c6e <sys_pause+0x7e>

0000000080002c92 <sys_kill>:

uint64
sys_kill(void)
{
    80002c92:	1101                	addi	sp,sp,-32
    80002c94:	ec06                	sd	ra,24(sp)
    80002c96:	e822                	sd	s0,16(sp)
    80002c98:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002c9a:	fec40593          	addi	a1,s0,-20
    80002c9e:	4501                	li	a0,0
    80002ca0:	da5ff0ef          	jal	80002a44 <argint>
  return kkill(pid);
    80002ca4:	fec42503          	lw	a0,-20(s0)
    80002ca8:	df4ff0ef          	jal	8000229c <kkill>
}
    80002cac:	60e2                	ld	ra,24(sp)
    80002cae:	6442                	ld	s0,16(sp)
    80002cb0:	6105                	addi	sp,sp,32
    80002cb2:	8082                	ret

0000000080002cb4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002cb4:	1101                	addi	sp,sp,-32
    80002cb6:	ec06                	sd	ra,24(sp)
    80002cb8:	e822                	sd	s0,16(sp)
    80002cba:	e426                	sd	s1,8(sp)
    80002cbc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002cbe:	00014517          	auipc	a0,0x14
    80002cc2:	b2a50513          	addi	a0,a0,-1238 # 800167e8 <tickslock>
    80002cc6:	f63fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80002cca:	00005797          	auipc	a5,0x5
    80002cce:	bce7a783          	lw	a5,-1074(a5) # 80007898 <ticks>
    80002cd2:	84be                	mv	s1,a5
  release(&tickslock);
    80002cd4:	00014517          	auipc	a0,0x14
    80002cd8:	b1450513          	addi	a0,a0,-1260 # 800167e8 <tickslock>
    80002cdc:	fe1fd0ef          	jal	80000cbc <release>
  return xticks;
}
    80002ce0:	02049513          	slli	a0,s1,0x20
    80002ce4:	9101                	srli	a0,a0,0x20
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret

0000000080002cf0 <sys_set_nice>:

uint64
sys_set_nice(void)
{
    80002cf0:	1101                	addi	sp,sp,-32
    80002cf2:	ec06                	sd	ra,24(sp)
    80002cf4:	e822                	sd	s0,16(sp)
    80002cf6:	1000                	addi	s0,sp,32
  int nice;
  argint(0, &nice);
    80002cf8:	fec40593          	addi	a1,s0,-20
    80002cfc:	4501                	li	a0,0
    80002cfe:	d47ff0ef          	jal	80002a44 <argint>
  return set_nice(nice);
    80002d02:	fec42503          	lw	a0,-20(s0)
    80002d06:	88bff0ef          	jal	80002590 <set_nice>
    80002d0a:	60e2                	ld	ra,24(sp)
    80002d0c:	6442                	ld	s0,16(sp)
    80002d0e:	6105                	addi	sp,sp,32
    80002d10:	8082                	ret

0000000080002d12 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d12:	7179                	addi	sp,sp,-48
    80002d14:	f406                	sd	ra,40(sp)
    80002d16:	f022                	sd	s0,32(sp)
    80002d18:	ec26                	sd	s1,24(sp)
    80002d1a:	e84a                	sd	s2,16(sp)
    80002d1c:	e44e                	sd	s3,8(sp)
    80002d1e:	e052                	sd	s4,0(sp)
    80002d20:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d22:	00004597          	auipc	a1,0x4
    80002d26:	68658593          	addi	a1,a1,1670 # 800073a8 <etext+0x3a8>
    80002d2a:	00014517          	auipc	a0,0x14
    80002d2e:	ad650513          	addi	a0,a0,-1322 # 80016800 <bcache>
    80002d32:	e6dfd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d36:	0001c797          	auipc	a5,0x1c
    80002d3a:	aca78793          	addi	a5,a5,-1334 # 8001e800 <bcache+0x8000>
    80002d3e:	0001c717          	auipc	a4,0x1c
    80002d42:	d2a70713          	addi	a4,a4,-726 # 8001ea68 <bcache+0x8268>
    80002d46:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d4a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d4e:	00014497          	auipc	s1,0x14
    80002d52:	aca48493          	addi	s1,s1,-1334 # 80016818 <bcache+0x18>
    b->next = bcache.head.next;
    80002d56:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d58:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d5a:	00004a17          	auipc	s4,0x4
    80002d5e:	656a0a13          	addi	s4,s4,1622 # 800073b0 <etext+0x3b0>
    b->next = bcache.head.next;
    80002d62:	2b893783          	ld	a5,696(s2)
    80002d66:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002d68:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002d6c:	85d2                	mv	a1,s4
    80002d6e:	01048513          	addi	a0,s1,16
    80002d72:	328010ef          	jal	8000409a <initsleeplock>
    bcache.head.next->prev = b;
    80002d76:	2b893783          	ld	a5,696(s2)
    80002d7a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002d7c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d80:	45848493          	addi	s1,s1,1112
    80002d84:	fd349fe3          	bne	s1,s3,80002d62 <binit+0x50>
  }
}
    80002d88:	70a2                	ld	ra,40(sp)
    80002d8a:	7402                	ld	s0,32(sp)
    80002d8c:	64e2                	ld	s1,24(sp)
    80002d8e:	6942                	ld	s2,16(sp)
    80002d90:	69a2                	ld	s3,8(sp)
    80002d92:	6a02                	ld	s4,0(sp)
    80002d94:	6145                	addi	sp,sp,48
    80002d96:	8082                	ret

0000000080002d98 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002d98:	7179                	addi	sp,sp,-48
    80002d9a:	f406                	sd	ra,40(sp)
    80002d9c:	f022                	sd	s0,32(sp)
    80002d9e:	ec26                	sd	s1,24(sp)
    80002da0:	e84a                	sd	s2,16(sp)
    80002da2:	e44e                	sd	s3,8(sp)
    80002da4:	1800                	addi	s0,sp,48
    80002da6:	892a                	mv	s2,a0
    80002da8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002daa:	00014517          	auipc	a0,0x14
    80002dae:	a5650513          	addi	a0,a0,-1450 # 80016800 <bcache>
    80002db2:	e77fd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002db6:	0001c497          	auipc	s1,0x1c
    80002dba:	d024b483          	ld	s1,-766(s1) # 8001eab8 <bcache+0x82b8>
    80002dbe:	0001c797          	auipc	a5,0x1c
    80002dc2:	caa78793          	addi	a5,a5,-854 # 8001ea68 <bcache+0x8268>
    80002dc6:	02f48b63          	beq	s1,a5,80002dfc <bread+0x64>
    80002dca:	873e                	mv	a4,a5
    80002dcc:	a021                	j	80002dd4 <bread+0x3c>
    80002dce:	68a4                	ld	s1,80(s1)
    80002dd0:	02e48663          	beq	s1,a4,80002dfc <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002dd4:	449c                	lw	a5,8(s1)
    80002dd6:	ff279ce3          	bne	a5,s2,80002dce <bread+0x36>
    80002dda:	44dc                	lw	a5,12(s1)
    80002ddc:	ff3799e3          	bne	a5,s3,80002dce <bread+0x36>
      b->refcnt++;
    80002de0:	40bc                	lw	a5,64(s1)
    80002de2:	2785                	addiw	a5,a5,1
    80002de4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002de6:	00014517          	auipc	a0,0x14
    80002dea:	a1a50513          	addi	a0,a0,-1510 # 80016800 <bcache>
    80002dee:	ecffd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002df2:	01048513          	addi	a0,s1,16
    80002df6:	2da010ef          	jal	800040d0 <acquiresleep>
      return b;
    80002dfa:	a889                	j	80002e4c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002dfc:	0001c497          	auipc	s1,0x1c
    80002e00:	cb44b483          	ld	s1,-844(s1) # 8001eab0 <bcache+0x82b0>
    80002e04:	0001c797          	auipc	a5,0x1c
    80002e08:	c6478793          	addi	a5,a5,-924 # 8001ea68 <bcache+0x8268>
    80002e0c:	00f48863          	beq	s1,a5,80002e1c <bread+0x84>
    80002e10:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e12:	40bc                	lw	a5,64(s1)
    80002e14:	cb91                	beqz	a5,80002e28 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e16:	64a4                	ld	s1,72(s1)
    80002e18:	fee49de3          	bne	s1,a4,80002e12 <bread+0x7a>
  panic("bget: no buffers");
    80002e1c:	00004517          	auipc	a0,0x4
    80002e20:	59c50513          	addi	a0,a0,1436 # 800073b8 <etext+0x3b8>
    80002e24:	a01fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80002e28:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e2c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e30:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e34:	4785                	li	a5,1
    80002e36:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e38:	00014517          	auipc	a0,0x14
    80002e3c:	9c850513          	addi	a0,a0,-1592 # 80016800 <bcache>
    80002e40:	e7dfd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002e44:	01048513          	addi	a0,s1,16
    80002e48:	288010ef          	jal	800040d0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002e4c:	409c                	lw	a5,0(s1)
    80002e4e:	cb89                	beqz	a5,80002e60 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002e50:	8526                	mv	a0,s1
    80002e52:	70a2                	ld	ra,40(sp)
    80002e54:	7402                	ld	s0,32(sp)
    80002e56:	64e2                	ld	s1,24(sp)
    80002e58:	6942                	ld	s2,16(sp)
    80002e5a:	69a2                	ld	s3,8(sp)
    80002e5c:	6145                	addi	sp,sp,48
    80002e5e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002e60:	4581                	li	a1,0
    80002e62:	8526                	mv	a0,s1
    80002e64:	2ed020ef          	jal	80005950 <virtio_disk_rw>
    b->valid = 1;
    80002e68:	4785                	li	a5,1
    80002e6a:	c09c                	sw	a5,0(s1)
  return b;
    80002e6c:	b7d5                	j	80002e50 <bread+0xb8>

0000000080002e6e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002e6e:	1101                	addi	sp,sp,-32
    80002e70:	ec06                	sd	ra,24(sp)
    80002e72:	e822                	sd	s0,16(sp)
    80002e74:	e426                	sd	s1,8(sp)
    80002e76:	1000                	addi	s0,sp,32
    80002e78:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e7a:	0541                	addi	a0,a0,16
    80002e7c:	2d2010ef          	jal	8000414e <holdingsleep>
    80002e80:	c911                	beqz	a0,80002e94 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002e82:	4585                	li	a1,1
    80002e84:	8526                	mv	a0,s1
    80002e86:	2cb020ef          	jal	80005950 <virtio_disk_rw>
}
    80002e8a:	60e2                	ld	ra,24(sp)
    80002e8c:	6442                	ld	s0,16(sp)
    80002e8e:	64a2                	ld	s1,8(sp)
    80002e90:	6105                	addi	sp,sp,32
    80002e92:	8082                	ret
    panic("bwrite");
    80002e94:	00004517          	auipc	a0,0x4
    80002e98:	53c50513          	addi	a0,a0,1340 # 800073d0 <etext+0x3d0>
    80002e9c:	989fd0ef          	jal	80000824 <panic>

0000000080002ea0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ea0:	1101                	addi	sp,sp,-32
    80002ea2:	ec06                	sd	ra,24(sp)
    80002ea4:	e822                	sd	s0,16(sp)
    80002ea6:	e426                	sd	s1,8(sp)
    80002ea8:	e04a                	sd	s2,0(sp)
    80002eaa:	1000                	addi	s0,sp,32
    80002eac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002eae:	01050913          	addi	s2,a0,16
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	29a010ef          	jal	8000414e <holdingsleep>
    80002eb8:	c125                	beqz	a0,80002f18 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002eba:	854a                	mv	a0,s2
    80002ebc:	25a010ef          	jal	80004116 <releasesleep>

  acquire(&bcache.lock);
    80002ec0:	00014517          	auipc	a0,0x14
    80002ec4:	94050513          	addi	a0,a0,-1728 # 80016800 <bcache>
    80002ec8:	d61fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002ecc:	40bc                	lw	a5,64(s1)
    80002ece:	37fd                	addiw	a5,a5,-1
    80002ed0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002ed2:	e79d                	bnez	a5,80002f00 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002ed4:	68b8                	ld	a4,80(s1)
    80002ed6:	64bc                	ld	a5,72(s1)
    80002ed8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002eda:	68b8                	ld	a4,80(s1)
    80002edc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002ede:	0001c797          	auipc	a5,0x1c
    80002ee2:	92278793          	addi	a5,a5,-1758 # 8001e800 <bcache+0x8000>
    80002ee6:	2b87b703          	ld	a4,696(a5)
    80002eea:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002eec:	0001c717          	auipc	a4,0x1c
    80002ef0:	b7c70713          	addi	a4,a4,-1156 # 8001ea68 <bcache+0x8268>
    80002ef4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002ef6:	2b87b703          	ld	a4,696(a5)
    80002efa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002efc:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002f00:	00014517          	auipc	a0,0x14
    80002f04:	90050513          	addi	a0,a0,-1792 # 80016800 <bcache>
    80002f08:	db5fd0ef          	jal	80000cbc <release>
}
    80002f0c:	60e2                	ld	ra,24(sp)
    80002f0e:	6442                	ld	s0,16(sp)
    80002f10:	64a2                	ld	s1,8(sp)
    80002f12:	6902                	ld	s2,0(sp)
    80002f14:	6105                	addi	sp,sp,32
    80002f16:	8082                	ret
    panic("brelse");
    80002f18:	00004517          	auipc	a0,0x4
    80002f1c:	4c050513          	addi	a0,a0,1216 # 800073d8 <etext+0x3d8>
    80002f20:	905fd0ef          	jal	80000824 <panic>

0000000080002f24 <bpin>:

void
bpin(struct buf *b) {
    80002f24:	1101                	addi	sp,sp,-32
    80002f26:	ec06                	sd	ra,24(sp)
    80002f28:	e822                	sd	s0,16(sp)
    80002f2a:	e426                	sd	s1,8(sp)
    80002f2c:	1000                	addi	s0,sp,32
    80002f2e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f30:	00014517          	auipc	a0,0x14
    80002f34:	8d050513          	addi	a0,a0,-1840 # 80016800 <bcache>
    80002f38:	cf1fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80002f3c:	40bc                	lw	a5,64(s1)
    80002f3e:	2785                	addiw	a5,a5,1
    80002f40:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f42:	00014517          	auipc	a0,0x14
    80002f46:	8be50513          	addi	a0,a0,-1858 # 80016800 <bcache>
    80002f4a:	d73fd0ef          	jal	80000cbc <release>
}
    80002f4e:	60e2                	ld	ra,24(sp)
    80002f50:	6442                	ld	s0,16(sp)
    80002f52:	64a2                	ld	s1,8(sp)
    80002f54:	6105                	addi	sp,sp,32
    80002f56:	8082                	ret

0000000080002f58 <bunpin>:

void
bunpin(struct buf *b) {
    80002f58:	1101                	addi	sp,sp,-32
    80002f5a:	ec06                	sd	ra,24(sp)
    80002f5c:	e822                	sd	s0,16(sp)
    80002f5e:	e426                	sd	s1,8(sp)
    80002f60:	1000                	addi	s0,sp,32
    80002f62:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f64:	00014517          	auipc	a0,0x14
    80002f68:	89c50513          	addi	a0,a0,-1892 # 80016800 <bcache>
    80002f6c:	cbdfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002f70:	40bc                	lw	a5,64(s1)
    80002f72:	37fd                	addiw	a5,a5,-1
    80002f74:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f76:	00014517          	auipc	a0,0x14
    80002f7a:	88a50513          	addi	a0,a0,-1910 # 80016800 <bcache>
    80002f7e:	d3ffd0ef          	jal	80000cbc <release>
}
    80002f82:	60e2                	ld	ra,24(sp)
    80002f84:	6442                	ld	s0,16(sp)
    80002f86:	64a2                	ld	s1,8(sp)
    80002f88:	6105                	addi	sp,sp,32
    80002f8a:	8082                	ret

0000000080002f8c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002f8c:	1101                	addi	sp,sp,-32
    80002f8e:	ec06                	sd	ra,24(sp)
    80002f90:	e822                	sd	s0,16(sp)
    80002f92:	e426                	sd	s1,8(sp)
    80002f94:	e04a                	sd	s2,0(sp)
    80002f96:	1000                	addi	s0,sp,32
    80002f98:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002f9a:	00d5d79b          	srliw	a5,a1,0xd
    80002f9e:	0001c597          	auipc	a1,0x1c
    80002fa2:	f3e5a583          	lw	a1,-194(a1) # 8001eedc <sb+0x1c>
    80002fa6:	9dbd                	addw	a1,a1,a5
    80002fa8:	df1ff0ef          	jal	80002d98 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002fac:	0074f713          	andi	a4,s1,7
    80002fb0:	4785                	li	a5,1
    80002fb2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002fb6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002fb8:	90d9                	srli	s1,s1,0x36
    80002fba:	00950733          	add	a4,a0,s1
    80002fbe:	05874703          	lbu	a4,88(a4)
    80002fc2:	00e7f6b3          	and	a3,a5,a4
    80002fc6:	c29d                	beqz	a3,80002fec <bfree+0x60>
    80002fc8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002fca:	94aa                	add	s1,s1,a0
    80002fcc:	fff7c793          	not	a5,a5
    80002fd0:	8f7d                	and	a4,a4,a5
    80002fd2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002fd6:	000010ef          	jal	80003fd6 <log_write>
  brelse(bp);
    80002fda:	854a                	mv	a0,s2
    80002fdc:	ec5ff0ef          	jal	80002ea0 <brelse>
}
    80002fe0:	60e2                	ld	ra,24(sp)
    80002fe2:	6442                	ld	s0,16(sp)
    80002fe4:	64a2                	ld	s1,8(sp)
    80002fe6:	6902                	ld	s2,0(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret
    panic("freeing free block");
    80002fec:	00004517          	auipc	a0,0x4
    80002ff0:	3f450513          	addi	a0,a0,1012 # 800073e0 <etext+0x3e0>
    80002ff4:	831fd0ef          	jal	80000824 <panic>

0000000080002ff8 <balloc>:
{
    80002ff8:	715d                	addi	sp,sp,-80
    80002ffa:	e486                	sd	ra,72(sp)
    80002ffc:	e0a2                	sd	s0,64(sp)
    80002ffe:	fc26                	sd	s1,56(sp)
    80003000:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003002:	0001c797          	auipc	a5,0x1c
    80003006:	ec27a783          	lw	a5,-318(a5) # 8001eec4 <sb+0x4>
    8000300a:	0e078263          	beqz	a5,800030ee <balloc+0xf6>
    8000300e:	f84a                	sd	s2,48(sp)
    80003010:	f44e                	sd	s3,40(sp)
    80003012:	f052                	sd	s4,32(sp)
    80003014:	ec56                	sd	s5,24(sp)
    80003016:	e85a                	sd	s6,16(sp)
    80003018:	e45e                	sd	s7,8(sp)
    8000301a:	e062                	sd	s8,0(sp)
    8000301c:	8baa                	mv	s7,a0
    8000301e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003020:	0001cb17          	auipc	s6,0x1c
    80003024:	ea0b0b13          	addi	s6,s6,-352 # 8001eec0 <sb>
      m = 1 << (bi % 8);
    80003028:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000302a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000302c:	6c09                	lui	s8,0x2
    8000302e:	a09d                	j	80003094 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003030:	97ca                	add	a5,a5,s2
    80003032:	8e55                	or	a2,a2,a3
    80003034:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003038:	854a                	mv	a0,s2
    8000303a:	79d000ef          	jal	80003fd6 <log_write>
        brelse(bp);
    8000303e:	854a                	mv	a0,s2
    80003040:	e61ff0ef          	jal	80002ea0 <brelse>
  bp = bread(dev, bno);
    80003044:	85a6                	mv	a1,s1
    80003046:	855e                	mv	a0,s7
    80003048:	d51ff0ef          	jal	80002d98 <bread>
    8000304c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000304e:	40000613          	li	a2,1024
    80003052:	4581                	li	a1,0
    80003054:	05850513          	addi	a0,a0,88
    80003058:	ca1fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    8000305c:	854a                	mv	a0,s2
    8000305e:	779000ef          	jal	80003fd6 <log_write>
  brelse(bp);
    80003062:	854a                	mv	a0,s2
    80003064:	e3dff0ef          	jal	80002ea0 <brelse>
}
    80003068:	7942                	ld	s2,48(sp)
    8000306a:	79a2                	ld	s3,40(sp)
    8000306c:	7a02                	ld	s4,32(sp)
    8000306e:	6ae2                	ld	s5,24(sp)
    80003070:	6b42                	ld	s6,16(sp)
    80003072:	6ba2                	ld	s7,8(sp)
    80003074:	6c02                	ld	s8,0(sp)
}
    80003076:	8526                	mv	a0,s1
    80003078:	60a6                	ld	ra,72(sp)
    8000307a:	6406                	ld	s0,64(sp)
    8000307c:	74e2                	ld	s1,56(sp)
    8000307e:	6161                	addi	sp,sp,80
    80003080:	8082                	ret
    brelse(bp);
    80003082:	854a                	mv	a0,s2
    80003084:	e1dff0ef          	jal	80002ea0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003088:	015c0abb          	addw	s5,s8,s5
    8000308c:	004b2783          	lw	a5,4(s6)
    80003090:	04faf863          	bgeu	s5,a5,800030e0 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003094:	40dad59b          	sraiw	a1,s5,0xd
    80003098:	01cb2783          	lw	a5,28(s6)
    8000309c:	9dbd                	addw	a1,a1,a5
    8000309e:	855e                	mv	a0,s7
    800030a0:	cf9ff0ef          	jal	80002d98 <bread>
    800030a4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030a6:	004b2503          	lw	a0,4(s6)
    800030aa:	84d6                	mv	s1,s5
    800030ac:	4701                	li	a4,0
    800030ae:	fca4fae3          	bgeu	s1,a0,80003082 <balloc+0x8a>
      m = 1 << (bi % 8);
    800030b2:	00777693          	andi	a3,a4,7
    800030b6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800030ba:	41f7579b          	sraiw	a5,a4,0x1f
    800030be:	01d7d79b          	srliw	a5,a5,0x1d
    800030c2:	9fb9                	addw	a5,a5,a4
    800030c4:	4037d79b          	sraiw	a5,a5,0x3
    800030c8:	00f90633          	add	a2,s2,a5
    800030cc:	05864603          	lbu	a2,88(a2)
    800030d0:	00c6f5b3          	and	a1,a3,a2
    800030d4:	ddb1                	beqz	a1,80003030 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030d6:	2705                	addiw	a4,a4,1
    800030d8:	2485                	addiw	s1,s1,1
    800030da:	fd471ae3          	bne	a4,s4,800030ae <balloc+0xb6>
    800030de:	b755                	j	80003082 <balloc+0x8a>
    800030e0:	7942                	ld	s2,48(sp)
    800030e2:	79a2                	ld	s3,40(sp)
    800030e4:	7a02                	ld	s4,32(sp)
    800030e6:	6ae2                	ld	s5,24(sp)
    800030e8:	6b42                	ld	s6,16(sp)
    800030ea:	6ba2                	ld	s7,8(sp)
    800030ec:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800030ee:	00004517          	auipc	a0,0x4
    800030f2:	30a50513          	addi	a0,a0,778 # 800073f8 <etext+0x3f8>
    800030f6:	c04fd0ef          	jal	800004fa <printf>
  return 0;
    800030fa:	4481                	li	s1,0
    800030fc:	bfad                	j	80003076 <balloc+0x7e>

00000000800030fe <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800030fe:	7179                	addi	sp,sp,-48
    80003100:	f406                	sd	ra,40(sp)
    80003102:	f022                	sd	s0,32(sp)
    80003104:	ec26                	sd	s1,24(sp)
    80003106:	e84a                	sd	s2,16(sp)
    80003108:	e44e                	sd	s3,8(sp)
    8000310a:	1800                	addi	s0,sp,48
    8000310c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000310e:	47ad                	li	a5,11
    80003110:	02b7e363          	bltu	a5,a1,80003136 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003114:	02059793          	slli	a5,a1,0x20
    80003118:	01e7d593          	srli	a1,a5,0x1e
    8000311c:	00b509b3          	add	s3,a0,a1
    80003120:	0509a483          	lw	s1,80(s3)
    80003124:	e0b5                	bnez	s1,80003188 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003126:	4108                	lw	a0,0(a0)
    80003128:	ed1ff0ef          	jal	80002ff8 <balloc>
    8000312c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000312e:	cd29                	beqz	a0,80003188 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003130:	04a9a823          	sw	a0,80(s3)
    80003134:	a891                	j	80003188 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003136:	ff45879b          	addiw	a5,a1,-12
    8000313a:	873e                	mv	a4,a5
    8000313c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000313e:	0ff00793          	li	a5,255
    80003142:	06e7e763          	bltu	a5,a4,800031b0 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003146:	08052483          	lw	s1,128(a0)
    8000314a:	e891                	bnez	s1,8000315e <bmap+0x60>
      addr = balloc(ip->dev);
    8000314c:	4108                	lw	a0,0(a0)
    8000314e:	eabff0ef          	jal	80002ff8 <balloc>
    80003152:	84aa                	mv	s1,a0
      if(addr == 0)
    80003154:	c915                	beqz	a0,80003188 <bmap+0x8a>
    80003156:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003158:	08a92023          	sw	a0,128(s2)
    8000315c:	a011                	j	80003160 <bmap+0x62>
    8000315e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003160:	85a6                	mv	a1,s1
    80003162:	00092503          	lw	a0,0(s2)
    80003166:	c33ff0ef          	jal	80002d98 <bread>
    8000316a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000316c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003170:	02099713          	slli	a4,s3,0x20
    80003174:	01e75593          	srli	a1,a4,0x1e
    80003178:	97ae                	add	a5,a5,a1
    8000317a:	89be                	mv	s3,a5
    8000317c:	4384                	lw	s1,0(a5)
    8000317e:	cc89                	beqz	s1,80003198 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003180:	8552                	mv	a0,s4
    80003182:	d1fff0ef          	jal	80002ea0 <brelse>
    return addr;
    80003186:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003188:	8526                	mv	a0,s1
    8000318a:	70a2                	ld	ra,40(sp)
    8000318c:	7402                	ld	s0,32(sp)
    8000318e:	64e2                	ld	s1,24(sp)
    80003190:	6942                	ld	s2,16(sp)
    80003192:	69a2                	ld	s3,8(sp)
    80003194:	6145                	addi	sp,sp,48
    80003196:	8082                	ret
      addr = balloc(ip->dev);
    80003198:	00092503          	lw	a0,0(s2)
    8000319c:	e5dff0ef          	jal	80002ff8 <balloc>
    800031a0:	84aa                	mv	s1,a0
      if(addr){
    800031a2:	dd79                	beqz	a0,80003180 <bmap+0x82>
        a[bn] = addr;
    800031a4:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800031a8:	8552                	mv	a0,s4
    800031aa:	62d000ef          	jal	80003fd6 <log_write>
    800031ae:	bfc9                	j	80003180 <bmap+0x82>
    800031b0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800031b2:	00004517          	auipc	a0,0x4
    800031b6:	25e50513          	addi	a0,a0,606 # 80007410 <etext+0x410>
    800031ba:	e6afd0ef          	jal	80000824 <panic>

00000000800031be <iget>:
{
    800031be:	7179                	addi	sp,sp,-48
    800031c0:	f406                	sd	ra,40(sp)
    800031c2:	f022                	sd	s0,32(sp)
    800031c4:	ec26                	sd	s1,24(sp)
    800031c6:	e84a                	sd	s2,16(sp)
    800031c8:	e44e                	sd	s3,8(sp)
    800031ca:	e052                	sd	s4,0(sp)
    800031cc:	1800                	addi	s0,sp,48
    800031ce:	892a                	mv	s2,a0
    800031d0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800031d2:	0001c517          	auipc	a0,0x1c
    800031d6:	d0e50513          	addi	a0,a0,-754 # 8001eee0 <itable>
    800031da:	a4ffd0ef          	jal	80000c28 <acquire>
  empty = 0;
    800031de:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800031e0:	0001c497          	auipc	s1,0x1c
    800031e4:	d1848493          	addi	s1,s1,-744 # 8001eef8 <itable+0x18>
    800031e8:	0001d697          	auipc	a3,0x1d
    800031ec:	7a068693          	addi	a3,a3,1952 # 80020988 <log>
    800031f0:	a809                	j	80003202 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031f2:	e781                	bnez	a5,800031fa <iget+0x3c>
    800031f4:	00099363          	bnez	s3,800031fa <iget+0x3c>
      empty = ip;
    800031f8:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800031fa:	08848493          	addi	s1,s1,136
    800031fe:	02d48563          	beq	s1,a3,80003228 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003202:	449c                	lw	a5,8(s1)
    80003204:	fef057e3          	blez	a5,800031f2 <iget+0x34>
    80003208:	4098                	lw	a4,0(s1)
    8000320a:	ff2718e3          	bne	a4,s2,800031fa <iget+0x3c>
    8000320e:	40d8                	lw	a4,4(s1)
    80003210:	ff4715e3          	bne	a4,s4,800031fa <iget+0x3c>
      ip->ref++;
    80003214:	2785                	addiw	a5,a5,1
    80003216:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003218:	0001c517          	auipc	a0,0x1c
    8000321c:	cc850513          	addi	a0,a0,-824 # 8001eee0 <itable>
    80003220:	a9dfd0ef          	jal	80000cbc <release>
      return ip;
    80003224:	89a6                	mv	s3,s1
    80003226:	a015                	j	8000324a <iget+0x8c>
  if(empty == 0)
    80003228:	02098a63          	beqz	s3,8000325c <iget+0x9e>
  ip->dev = dev;
    8000322c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003230:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003234:	4785                	li	a5,1
    80003236:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000323a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000323e:	0001c517          	auipc	a0,0x1c
    80003242:	ca250513          	addi	a0,a0,-862 # 8001eee0 <itable>
    80003246:	a77fd0ef          	jal	80000cbc <release>
}
    8000324a:	854e                	mv	a0,s3
    8000324c:	70a2                	ld	ra,40(sp)
    8000324e:	7402                	ld	s0,32(sp)
    80003250:	64e2                	ld	s1,24(sp)
    80003252:	6942                	ld	s2,16(sp)
    80003254:	69a2                	ld	s3,8(sp)
    80003256:	6a02                	ld	s4,0(sp)
    80003258:	6145                	addi	sp,sp,48
    8000325a:	8082                	ret
    panic("iget: no inodes");
    8000325c:	00004517          	auipc	a0,0x4
    80003260:	1cc50513          	addi	a0,a0,460 # 80007428 <etext+0x428>
    80003264:	dc0fd0ef          	jal	80000824 <panic>

0000000080003268 <iinit>:
{
    80003268:	7179                	addi	sp,sp,-48
    8000326a:	f406                	sd	ra,40(sp)
    8000326c:	f022                	sd	s0,32(sp)
    8000326e:	ec26                	sd	s1,24(sp)
    80003270:	e84a                	sd	s2,16(sp)
    80003272:	e44e                	sd	s3,8(sp)
    80003274:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003276:	00004597          	auipc	a1,0x4
    8000327a:	1c258593          	addi	a1,a1,450 # 80007438 <etext+0x438>
    8000327e:	0001c517          	auipc	a0,0x1c
    80003282:	c6250513          	addi	a0,a0,-926 # 8001eee0 <itable>
    80003286:	919fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    8000328a:	0001c497          	auipc	s1,0x1c
    8000328e:	c7e48493          	addi	s1,s1,-898 # 8001ef08 <itable+0x28>
    80003292:	0001d997          	auipc	s3,0x1d
    80003296:	70698993          	addi	s3,s3,1798 # 80020998 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000329a:	00004917          	auipc	s2,0x4
    8000329e:	1a690913          	addi	s2,s2,422 # 80007440 <etext+0x440>
    800032a2:	85ca                	mv	a1,s2
    800032a4:	8526                	mv	a0,s1
    800032a6:	5f5000ef          	jal	8000409a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800032aa:	08848493          	addi	s1,s1,136
    800032ae:	ff349ae3          	bne	s1,s3,800032a2 <iinit+0x3a>
}
    800032b2:	70a2                	ld	ra,40(sp)
    800032b4:	7402                	ld	s0,32(sp)
    800032b6:	64e2                	ld	s1,24(sp)
    800032b8:	6942                	ld	s2,16(sp)
    800032ba:	69a2                	ld	s3,8(sp)
    800032bc:	6145                	addi	sp,sp,48
    800032be:	8082                	ret

00000000800032c0 <ialloc>:
{
    800032c0:	7139                	addi	sp,sp,-64
    800032c2:	fc06                	sd	ra,56(sp)
    800032c4:	f822                	sd	s0,48(sp)
    800032c6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800032c8:	0001c717          	auipc	a4,0x1c
    800032cc:	c0472703          	lw	a4,-1020(a4) # 8001eecc <sb+0xc>
    800032d0:	4785                	li	a5,1
    800032d2:	06e7f063          	bgeu	a5,a4,80003332 <ialloc+0x72>
    800032d6:	f426                	sd	s1,40(sp)
    800032d8:	f04a                	sd	s2,32(sp)
    800032da:	ec4e                	sd	s3,24(sp)
    800032dc:	e852                	sd	s4,16(sp)
    800032de:	e456                	sd	s5,8(sp)
    800032e0:	e05a                	sd	s6,0(sp)
    800032e2:	8aaa                	mv	s5,a0
    800032e4:	8b2e                	mv	s6,a1
    800032e6:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800032e8:	0001ca17          	auipc	s4,0x1c
    800032ec:	bd8a0a13          	addi	s4,s4,-1064 # 8001eec0 <sb>
    800032f0:	00495593          	srli	a1,s2,0x4
    800032f4:	018a2783          	lw	a5,24(s4)
    800032f8:	9dbd                	addw	a1,a1,a5
    800032fa:	8556                	mv	a0,s5
    800032fc:	a9dff0ef          	jal	80002d98 <bread>
    80003300:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003302:	05850993          	addi	s3,a0,88
    80003306:	00f97793          	andi	a5,s2,15
    8000330a:	079a                	slli	a5,a5,0x6
    8000330c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000330e:	00099783          	lh	a5,0(s3)
    80003312:	cb9d                	beqz	a5,80003348 <ialloc+0x88>
    brelse(bp);
    80003314:	b8dff0ef          	jal	80002ea0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003318:	0905                	addi	s2,s2,1
    8000331a:	00ca2703          	lw	a4,12(s4)
    8000331e:	0009079b          	sext.w	a5,s2
    80003322:	fce7e7e3          	bltu	a5,a4,800032f0 <ialloc+0x30>
    80003326:	74a2                	ld	s1,40(sp)
    80003328:	7902                	ld	s2,32(sp)
    8000332a:	69e2                	ld	s3,24(sp)
    8000332c:	6a42                	ld	s4,16(sp)
    8000332e:	6aa2                	ld	s5,8(sp)
    80003330:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003332:	00004517          	auipc	a0,0x4
    80003336:	11650513          	addi	a0,a0,278 # 80007448 <etext+0x448>
    8000333a:	9c0fd0ef          	jal	800004fa <printf>
  return 0;
    8000333e:	4501                	li	a0,0
}
    80003340:	70e2                	ld	ra,56(sp)
    80003342:	7442                	ld	s0,48(sp)
    80003344:	6121                	addi	sp,sp,64
    80003346:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003348:	04000613          	li	a2,64
    8000334c:	4581                	li	a1,0
    8000334e:	854e                	mv	a0,s3
    80003350:	9a9fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003354:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003358:	8526                	mv	a0,s1
    8000335a:	47d000ef          	jal	80003fd6 <log_write>
      brelse(bp);
    8000335e:	8526                	mv	a0,s1
    80003360:	b41ff0ef          	jal	80002ea0 <brelse>
      return iget(dev, inum);
    80003364:	0009059b          	sext.w	a1,s2
    80003368:	8556                	mv	a0,s5
    8000336a:	e55ff0ef          	jal	800031be <iget>
    8000336e:	74a2                	ld	s1,40(sp)
    80003370:	7902                	ld	s2,32(sp)
    80003372:	69e2                	ld	s3,24(sp)
    80003374:	6a42                	ld	s4,16(sp)
    80003376:	6aa2                	ld	s5,8(sp)
    80003378:	6b02                	ld	s6,0(sp)
    8000337a:	b7d9                	j	80003340 <ialloc+0x80>

000000008000337c <iupdate>:
{
    8000337c:	1101                	addi	sp,sp,-32
    8000337e:	ec06                	sd	ra,24(sp)
    80003380:	e822                	sd	s0,16(sp)
    80003382:	e426                	sd	s1,8(sp)
    80003384:	e04a                	sd	s2,0(sp)
    80003386:	1000                	addi	s0,sp,32
    80003388:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000338a:	415c                	lw	a5,4(a0)
    8000338c:	0047d79b          	srliw	a5,a5,0x4
    80003390:	0001c597          	auipc	a1,0x1c
    80003394:	b485a583          	lw	a1,-1208(a1) # 8001eed8 <sb+0x18>
    80003398:	9dbd                	addw	a1,a1,a5
    8000339a:	4108                	lw	a0,0(a0)
    8000339c:	9fdff0ef          	jal	80002d98 <bread>
    800033a0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033a2:	05850793          	addi	a5,a0,88
    800033a6:	40d8                	lw	a4,4(s1)
    800033a8:	8b3d                	andi	a4,a4,15
    800033aa:	071a                	slli	a4,a4,0x6
    800033ac:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800033ae:	04449703          	lh	a4,68(s1)
    800033b2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800033b6:	04649703          	lh	a4,70(s1)
    800033ba:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800033be:	04849703          	lh	a4,72(s1)
    800033c2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800033c6:	04a49703          	lh	a4,74(s1)
    800033ca:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800033ce:	44f8                	lw	a4,76(s1)
    800033d0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800033d2:	03400613          	li	a2,52
    800033d6:	05048593          	addi	a1,s1,80
    800033da:	00c78513          	addi	a0,a5,12
    800033de:	97bfd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    800033e2:	854a                	mv	a0,s2
    800033e4:	3f3000ef          	jal	80003fd6 <log_write>
  brelse(bp);
    800033e8:	854a                	mv	a0,s2
    800033ea:	ab7ff0ef          	jal	80002ea0 <brelse>
}
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	64a2                	ld	s1,8(sp)
    800033f4:	6902                	ld	s2,0(sp)
    800033f6:	6105                	addi	sp,sp,32
    800033f8:	8082                	ret

00000000800033fa <idup>:
{
    800033fa:	1101                	addi	sp,sp,-32
    800033fc:	ec06                	sd	ra,24(sp)
    800033fe:	e822                	sd	s0,16(sp)
    80003400:	e426                	sd	s1,8(sp)
    80003402:	1000                	addi	s0,sp,32
    80003404:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003406:	0001c517          	auipc	a0,0x1c
    8000340a:	ada50513          	addi	a0,a0,-1318 # 8001eee0 <itable>
    8000340e:	81bfd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003412:	449c                	lw	a5,8(s1)
    80003414:	2785                	addiw	a5,a5,1
    80003416:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003418:	0001c517          	auipc	a0,0x1c
    8000341c:	ac850513          	addi	a0,a0,-1336 # 8001eee0 <itable>
    80003420:	89dfd0ef          	jal	80000cbc <release>
}
    80003424:	8526                	mv	a0,s1
    80003426:	60e2                	ld	ra,24(sp)
    80003428:	6442                	ld	s0,16(sp)
    8000342a:	64a2                	ld	s1,8(sp)
    8000342c:	6105                	addi	sp,sp,32
    8000342e:	8082                	ret

0000000080003430 <ilock>:
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000343a:	cd19                	beqz	a0,80003458 <ilock+0x28>
    8000343c:	84aa                	mv	s1,a0
    8000343e:	451c                	lw	a5,8(a0)
    80003440:	00f05c63          	blez	a5,80003458 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003444:	0541                	addi	a0,a0,16
    80003446:	48b000ef          	jal	800040d0 <acquiresleep>
  if(ip->valid == 0){
    8000344a:	40bc                	lw	a5,64(s1)
    8000344c:	cf89                	beqz	a5,80003466 <ilock+0x36>
}
    8000344e:	60e2                	ld	ra,24(sp)
    80003450:	6442                	ld	s0,16(sp)
    80003452:	64a2                	ld	s1,8(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret
    80003458:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000345a:	00004517          	auipc	a0,0x4
    8000345e:	00650513          	addi	a0,a0,6 # 80007460 <etext+0x460>
    80003462:	bc2fd0ef          	jal	80000824 <panic>
    80003466:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003468:	40dc                	lw	a5,4(s1)
    8000346a:	0047d79b          	srliw	a5,a5,0x4
    8000346e:	0001c597          	auipc	a1,0x1c
    80003472:	a6a5a583          	lw	a1,-1430(a1) # 8001eed8 <sb+0x18>
    80003476:	9dbd                	addw	a1,a1,a5
    80003478:	4088                	lw	a0,0(s1)
    8000347a:	91fff0ef          	jal	80002d98 <bread>
    8000347e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003480:	05850593          	addi	a1,a0,88
    80003484:	40dc                	lw	a5,4(s1)
    80003486:	8bbd                	andi	a5,a5,15
    80003488:	079a                	slli	a5,a5,0x6
    8000348a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000348c:	00059783          	lh	a5,0(a1)
    80003490:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003494:	00259783          	lh	a5,2(a1)
    80003498:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000349c:	00459783          	lh	a5,4(a1)
    800034a0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034a4:	00659783          	lh	a5,6(a1)
    800034a8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034ac:	459c                	lw	a5,8(a1)
    800034ae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800034b0:	03400613          	li	a2,52
    800034b4:	05b1                	addi	a1,a1,12
    800034b6:	05048513          	addi	a0,s1,80
    800034ba:	89ffd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    800034be:	854a                	mv	a0,s2
    800034c0:	9e1ff0ef          	jal	80002ea0 <brelse>
    ip->valid = 1;
    800034c4:	4785                	li	a5,1
    800034c6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800034c8:	04449783          	lh	a5,68(s1)
    800034cc:	c399                	beqz	a5,800034d2 <ilock+0xa2>
    800034ce:	6902                	ld	s2,0(sp)
    800034d0:	bfbd                	j	8000344e <ilock+0x1e>
      panic("ilock: no type");
    800034d2:	00004517          	auipc	a0,0x4
    800034d6:	f9650513          	addi	a0,a0,-106 # 80007468 <etext+0x468>
    800034da:	b4afd0ef          	jal	80000824 <panic>

00000000800034de <iunlock>:
{
    800034de:	1101                	addi	sp,sp,-32
    800034e0:	ec06                	sd	ra,24(sp)
    800034e2:	e822                	sd	s0,16(sp)
    800034e4:	e426                	sd	s1,8(sp)
    800034e6:	e04a                	sd	s2,0(sp)
    800034e8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034ea:	c505                	beqz	a0,80003512 <iunlock+0x34>
    800034ec:	84aa                	mv	s1,a0
    800034ee:	01050913          	addi	s2,a0,16
    800034f2:	854a                	mv	a0,s2
    800034f4:	45b000ef          	jal	8000414e <holdingsleep>
    800034f8:	cd09                	beqz	a0,80003512 <iunlock+0x34>
    800034fa:	449c                	lw	a5,8(s1)
    800034fc:	00f05b63          	blez	a5,80003512 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003500:	854a                	mv	a0,s2
    80003502:	415000ef          	jal	80004116 <releasesleep>
}
    80003506:	60e2                	ld	ra,24(sp)
    80003508:	6442                	ld	s0,16(sp)
    8000350a:	64a2                	ld	s1,8(sp)
    8000350c:	6902                	ld	s2,0(sp)
    8000350e:	6105                	addi	sp,sp,32
    80003510:	8082                	ret
    panic("iunlock");
    80003512:	00004517          	auipc	a0,0x4
    80003516:	f6650513          	addi	a0,a0,-154 # 80007478 <etext+0x478>
    8000351a:	b0afd0ef          	jal	80000824 <panic>

000000008000351e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000351e:	7179                	addi	sp,sp,-48
    80003520:	f406                	sd	ra,40(sp)
    80003522:	f022                	sd	s0,32(sp)
    80003524:	ec26                	sd	s1,24(sp)
    80003526:	e84a                	sd	s2,16(sp)
    80003528:	e44e                	sd	s3,8(sp)
    8000352a:	1800                	addi	s0,sp,48
    8000352c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000352e:	05050493          	addi	s1,a0,80
    80003532:	08050913          	addi	s2,a0,128
    80003536:	a021                	j	8000353e <itrunc+0x20>
    80003538:	0491                	addi	s1,s1,4
    8000353a:	01248b63          	beq	s1,s2,80003550 <itrunc+0x32>
    if(ip->addrs[i]){
    8000353e:	408c                	lw	a1,0(s1)
    80003540:	dde5                	beqz	a1,80003538 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003542:	0009a503          	lw	a0,0(s3)
    80003546:	a47ff0ef          	jal	80002f8c <bfree>
      ip->addrs[i] = 0;
    8000354a:	0004a023          	sw	zero,0(s1)
    8000354e:	b7ed                	j	80003538 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003550:	0809a583          	lw	a1,128(s3)
    80003554:	ed89                	bnez	a1,8000356e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003556:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000355a:	854e                	mv	a0,s3
    8000355c:	e21ff0ef          	jal	8000337c <iupdate>
}
    80003560:	70a2                	ld	ra,40(sp)
    80003562:	7402                	ld	s0,32(sp)
    80003564:	64e2                	ld	s1,24(sp)
    80003566:	6942                	ld	s2,16(sp)
    80003568:	69a2                	ld	s3,8(sp)
    8000356a:	6145                	addi	sp,sp,48
    8000356c:	8082                	ret
    8000356e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003570:	0009a503          	lw	a0,0(s3)
    80003574:	825ff0ef          	jal	80002d98 <bread>
    80003578:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000357a:	05850493          	addi	s1,a0,88
    8000357e:	45850913          	addi	s2,a0,1112
    80003582:	a021                	j	8000358a <itrunc+0x6c>
    80003584:	0491                	addi	s1,s1,4
    80003586:	01248963          	beq	s1,s2,80003598 <itrunc+0x7a>
      if(a[j])
    8000358a:	408c                	lw	a1,0(s1)
    8000358c:	dde5                	beqz	a1,80003584 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000358e:	0009a503          	lw	a0,0(s3)
    80003592:	9fbff0ef          	jal	80002f8c <bfree>
    80003596:	b7fd                	j	80003584 <itrunc+0x66>
    brelse(bp);
    80003598:	8552                	mv	a0,s4
    8000359a:	907ff0ef          	jal	80002ea0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000359e:	0809a583          	lw	a1,128(s3)
    800035a2:	0009a503          	lw	a0,0(s3)
    800035a6:	9e7ff0ef          	jal	80002f8c <bfree>
    ip->addrs[NDIRECT] = 0;
    800035aa:	0809a023          	sw	zero,128(s3)
    800035ae:	6a02                	ld	s4,0(sp)
    800035b0:	b75d                	j	80003556 <itrunc+0x38>

00000000800035b2 <iput>:
{
    800035b2:	1101                	addi	sp,sp,-32
    800035b4:	ec06                	sd	ra,24(sp)
    800035b6:	e822                	sd	s0,16(sp)
    800035b8:	e426                	sd	s1,8(sp)
    800035ba:	1000                	addi	s0,sp,32
    800035bc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035be:	0001c517          	auipc	a0,0x1c
    800035c2:	92250513          	addi	a0,a0,-1758 # 8001eee0 <itable>
    800035c6:	e62fd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035ca:	4498                	lw	a4,8(s1)
    800035cc:	4785                	li	a5,1
    800035ce:	02f70063          	beq	a4,a5,800035ee <iput+0x3c>
  ip->ref--;
    800035d2:	449c                	lw	a5,8(s1)
    800035d4:	37fd                	addiw	a5,a5,-1
    800035d6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035d8:	0001c517          	auipc	a0,0x1c
    800035dc:	90850513          	addi	a0,a0,-1784 # 8001eee0 <itable>
    800035e0:	edcfd0ef          	jal	80000cbc <release>
}
    800035e4:	60e2                	ld	ra,24(sp)
    800035e6:	6442                	ld	s0,16(sp)
    800035e8:	64a2                	ld	s1,8(sp)
    800035ea:	6105                	addi	sp,sp,32
    800035ec:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035ee:	40bc                	lw	a5,64(s1)
    800035f0:	d3ed                	beqz	a5,800035d2 <iput+0x20>
    800035f2:	04a49783          	lh	a5,74(s1)
    800035f6:	fff1                	bnez	a5,800035d2 <iput+0x20>
    800035f8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800035fa:	01048793          	addi	a5,s1,16
    800035fe:	893e                	mv	s2,a5
    80003600:	853e                	mv	a0,a5
    80003602:	2cf000ef          	jal	800040d0 <acquiresleep>
    release(&itable.lock);
    80003606:	0001c517          	auipc	a0,0x1c
    8000360a:	8da50513          	addi	a0,a0,-1830 # 8001eee0 <itable>
    8000360e:	eaefd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003612:	8526                	mv	a0,s1
    80003614:	f0bff0ef          	jal	8000351e <itrunc>
    ip->type = 0;
    80003618:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000361c:	8526                	mv	a0,s1
    8000361e:	d5fff0ef          	jal	8000337c <iupdate>
    ip->valid = 0;
    80003622:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003626:	854a                	mv	a0,s2
    80003628:	2ef000ef          	jal	80004116 <releasesleep>
    acquire(&itable.lock);
    8000362c:	0001c517          	auipc	a0,0x1c
    80003630:	8b450513          	addi	a0,a0,-1868 # 8001eee0 <itable>
    80003634:	df4fd0ef          	jal	80000c28 <acquire>
    80003638:	6902                	ld	s2,0(sp)
    8000363a:	bf61                	j	800035d2 <iput+0x20>

000000008000363c <iunlockput>:
{
    8000363c:	1101                	addi	sp,sp,-32
    8000363e:	ec06                	sd	ra,24(sp)
    80003640:	e822                	sd	s0,16(sp)
    80003642:	e426                	sd	s1,8(sp)
    80003644:	1000                	addi	s0,sp,32
    80003646:	84aa                	mv	s1,a0
  iunlock(ip);
    80003648:	e97ff0ef          	jal	800034de <iunlock>
  iput(ip);
    8000364c:	8526                	mv	a0,s1
    8000364e:	f65ff0ef          	jal	800035b2 <iput>
}
    80003652:	60e2                	ld	ra,24(sp)
    80003654:	6442                	ld	s0,16(sp)
    80003656:	64a2                	ld	s1,8(sp)
    80003658:	6105                	addi	sp,sp,32
    8000365a:	8082                	ret

000000008000365c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000365c:	0001c717          	auipc	a4,0x1c
    80003660:	87072703          	lw	a4,-1936(a4) # 8001eecc <sb+0xc>
    80003664:	4785                	li	a5,1
    80003666:	0ae7fe63          	bgeu	a5,a4,80003722 <ireclaim+0xc6>
{
    8000366a:	7139                	addi	sp,sp,-64
    8000366c:	fc06                	sd	ra,56(sp)
    8000366e:	f822                	sd	s0,48(sp)
    80003670:	f426                	sd	s1,40(sp)
    80003672:	f04a                	sd	s2,32(sp)
    80003674:	ec4e                	sd	s3,24(sp)
    80003676:	e852                	sd	s4,16(sp)
    80003678:	e456                	sd	s5,8(sp)
    8000367a:	e05a                	sd	s6,0(sp)
    8000367c:	0080                	addi	s0,sp,64
    8000367e:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003680:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003682:	0001ca17          	auipc	s4,0x1c
    80003686:	83ea0a13          	addi	s4,s4,-1986 # 8001eec0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    8000368a:	00004b17          	auipc	s6,0x4
    8000368e:	df6b0b13          	addi	s6,s6,-522 # 80007480 <etext+0x480>
    80003692:	a099                	j	800036d8 <ireclaim+0x7c>
    80003694:	85ce                	mv	a1,s3
    80003696:	855a                	mv	a0,s6
    80003698:	e63fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    8000369c:	85ce                	mv	a1,s3
    8000369e:	8556                	mv	a0,s5
    800036a0:	b1fff0ef          	jal	800031be <iget>
    800036a4:	89aa                	mv	s3,a0
    brelse(bp);
    800036a6:	854a                	mv	a0,s2
    800036a8:	ff8ff0ef          	jal	80002ea0 <brelse>
    if (ip) {
    800036ac:	00098f63          	beqz	s3,800036ca <ireclaim+0x6e>
      begin_op();
    800036b0:	78c000ef          	jal	80003e3c <begin_op>
      ilock(ip);
    800036b4:	854e                	mv	a0,s3
    800036b6:	d7bff0ef          	jal	80003430 <ilock>
      iunlock(ip);
    800036ba:	854e                	mv	a0,s3
    800036bc:	e23ff0ef          	jal	800034de <iunlock>
      iput(ip);
    800036c0:	854e                	mv	a0,s3
    800036c2:	ef1ff0ef          	jal	800035b2 <iput>
      end_op();
    800036c6:	7e6000ef          	jal	80003eac <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800036ca:	0485                	addi	s1,s1,1
    800036cc:	00ca2703          	lw	a4,12(s4)
    800036d0:	0004879b          	sext.w	a5,s1
    800036d4:	02e7fd63          	bgeu	a5,a4,8000370e <ireclaim+0xb2>
    800036d8:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800036dc:	0044d593          	srli	a1,s1,0x4
    800036e0:	018a2783          	lw	a5,24(s4)
    800036e4:	9dbd                	addw	a1,a1,a5
    800036e6:	8556                	mv	a0,s5
    800036e8:	eb0ff0ef          	jal	80002d98 <bread>
    800036ec:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800036ee:	05850793          	addi	a5,a0,88
    800036f2:	00f9f713          	andi	a4,s3,15
    800036f6:	071a                	slli	a4,a4,0x6
    800036f8:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800036fa:	00079703          	lh	a4,0(a5)
    800036fe:	c701                	beqz	a4,80003706 <ireclaim+0xaa>
    80003700:	00679783          	lh	a5,6(a5)
    80003704:	dbc1                	beqz	a5,80003694 <ireclaim+0x38>
    brelse(bp);
    80003706:	854a                	mv	a0,s2
    80003708:	f98ff0ef          	jal	80002ea0 <brelse>
    if (ip) {
    8000370c:	bf7d                	j	800036ca <ireclaim+0x6e>
}
    8000370e:	70e2                	ld	ra,56(sp)
    80003710:	7442                	ld	s0,48(sp)
    80003712:	74a2                	ld	s1,40(sp)
    80003714:	7902                	ld	s2,32(sp)
    80003716:	69e2                	ld	s3,24(sp)
    80003718:	6a42                	ld	s4,16(sp)
    8000371a:	6aa2                	ld	s5,8(sp)
    8000371c:	6b02                	ld	s6,0(sp)
    8000371e:	6121                	addi	sp,sp,64
    80003720:	8082                	ret
    80003722:	8082                	ret

0000000080003724 <fsinit>:
fsinit(int dev) {
    80003724:	1101                	addi	sp,sp,-32
    80003726:	ec06                	sd	ra,24(sp)
    80003728:	e822                	sd	s0,16(sp)
    8000372a:	e426                	sd	s1,8(sp)
    8000372c:	e04a                	sd	s2,0(sp)
    8000372e:	1000                	addi	s0,sp,32
    80003730:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003732:	4585                	li	a1,1
    80003734:	e64ff0ef          	jal	80002d98 <bread>
    80003738:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000373a:	02000613          	li	a2,32
    8000373e:	05850593          	addi	a1,a0,88
    80003742:	0001b517          	auipc	a0,0x1b
    80003746:	77e50513          	addi	a0,a0,1918 # 8001eec0 <sb>
    8000374a:	e0efd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    8000374e:	8526                	mv	a0,s1
    80003750:	f50ff0ef          	jal	80002ea0 <brelse>
  if(sb.magic != FSMAGIC)
    80003754:	0001b717          	auipc	a4,0x1b
    80003758:	76c72703          	lw	a4,1900(a4) # 8001eec0 <sb>
    8000375c:	102037b7          	lui	a5,0x10203
    80003760:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003764:	02f71263          	bne	a4,a5,80003788 <fsinit+0x64>
  initlog(dev, &sb);
    80003768:	0001b597          	auipc	a1,0x1b
    8000376c:	75858593          	addi	a1,a1,1880 # 8001eec0 <sb>
    80003770:	854a                	mv	a0,s2
    80003772:	648000ef          	jal	80003dba <initlog>
  ireclaim(dev);
    80003776:	854a                	mv	a0,s2
    80003778:	ee5ff0ef          	jal	8000365c <ireclaim>
}
    8000377c:	60e2                	ld	ra,24(sp)
    8000377e:	6442                	ld	s0,16(sp)
    80003780:	64a2                	ld	s1,8(sp)
    80003782:	6902                	ld	s2,0(sp)
    80003784:	6105                	addi	sp,sp,32
    80003786:	8082                	ret
    panic("invalid file system");
    80003788:	00004517          	auipc	a0,0x4
    8000378c:	d1850513          	addi	a0,a0,-744 # 800074a0 <etext+0x4a0>
    80003790:	894fd0ef          	jal	80000824 <panic>

0000000080003794 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003794:	1141                	addi	sp,sp,-16
    80003796:	e406                	sd	ra,8(sp)
    80003798:	e022                	sd	s0,0(sp)
    8000379a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000379c:	411c                	lw	a5,0(a0)
    8000379e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800037a0:	415c                	lw	a5,4(a0)
    800037a2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800037a4:	04451783          	lh	a5,68(a0)
    800037a8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800037ac:	04a51783          	lh	a5,74(a0)
    800037b0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800037b4:	04c56783          	lwu	a5,76(a0)
    800037b8:	e99c                	sd	a5,16(a1)
}
    800037ba:	60a2                	ld	ra,8(sp)
    800037bc:	6402                	ld	s0,0(sp)
    800037be:	0141                	addi	sp,sp,16
    800037c0:	8082                	ret

00000000800037c2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037c2:	457c                	lw	a5,76(a0)
    800037c4:	0ed7e663          	bltu	a5,a3,800038b0 <readi+0xee>
{
    800037c8:	7159                	addi	sp,sp,-112
    800037ca:	f486                	sd	ra,104(sp)
    800037cc:	f0a2                	sd	s0,96(sp)
    800037ce:	eca6                	sd	s1,88(sp)
    800037d0:	e0d2                	sd	s4,64(sp)
    800037d2:	fc56                	sd	s5,56(sp)
    800037d4:	f85a                	sd	s6,48(sp)
    800037d6:	f45e                	sd	s7,40(sp)
    800037d8:	1880                	addi	s0,sp,112
    800037da:	8b2a                	mv	s6,a0
    800037dc:	8bae                	mv	s7,a1
    800037de:	8a32                	mv	s4,a2
    800037e0:	84b6                	mv	s1,a3
    800037e2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800037e4:	9f35                	addw	a4,a4,a3
    return 0;
    800037e6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800037e8:	0ad76b63          	bltu	a4,a3,8000389e <readi+0xdc>
    800037ec:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800037ee:	00e7f463          	bgeu	a5,a4,800037f6 <readi+0x34>
    n = ip->size - off;
    800037f2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800037f6:	080a8b63          	beqz	s5,8000388c <readi+0xca>
    800037fa:	e8ca                	sd	s2,80(sp)
    800037fc:	f062                	sd	s8,32(sp)
    800037fe:	ec66                	sd	s9,24(sp)
    80003800:	e86a                	sd	s10,16(sp)
    80003802:	e46e                	sd	s11,8(sp)
    80003804:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003806:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000380a:	5c7d                	li	s8,-1
    8000380c:	a80d                	j	8000383e <readi+0x7c>
    8000380e:	020d1d93          	slli	s11,s10,0x20
    80003812:	020ddd93          	srli	s11,s11,0x20
    80003816:	05890613          	addi	a2,s2,88
    8000381a:	86ee                	mv	a3,s11
    8000381c:	963e                	add	a2,a2,a5
    8000381e:	85d2                	mv	a1,s4
    80003820:	855e                	mv	a0,s7
    80003822:	c37fe0ef          	jal	80002458 <either_copyout>
    80003826:	05850363          	beq	a0,s8,8000386c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000382a:	854a                	mv	a0,s2
    8000382c:	e74ff0ef          	jal	80002ea0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003830:	013d09bb          	addw	s3,s10,s3
    80003834:	009d04bb          	addw	s1,s10,s1
    80003838:	9a6e                	add	s4,s4,s11
    8000383a:	0559f363          	bgeu	s3,s5,80003880 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000383e:	00a4d59b          	srliw	a1,s1,0xa
    80003842:	855a                	mv	a0,s6
    80003844:	8bbff0ef          	jal	800030fe <bmap>
    80003848:	85aa                	mv	a1,a0
    if(addr == 0)
    8000384a:	c139                	beqz	a0,80003890 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000384c:	000b2503          	lw	a0,0(s6)
    80003850:	d48ff0ef          	jal	80002d98 <bread>
    80003854:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003856:	3ff4f793          	andi	a5,s1,1023
    8000385a:	40fc873b          	subw	a4,s9,a5
    8000385e:	413a86bb          	subw	a3,s5,s3
    80003862:	8d3a                	mv	s10,a4
    80003864:	fae6f5e3          	bgeu	a3,a4,8000380e <readi+0x4c>
    80003868:	8d36                	mv	s10,a3
    8000386a:	b755                	j	8000380e <readi+0x4c>
      brelse(bp);
    8000386c:	854a                	mv	a0,s2
    8000386e:	e32ff0ef          	jal	80002ea0 <brelse>
      tot = -1;
    80003872:	59fd                	li	s3,-1
      break;
    80003874:	6946                	ld	s2,80(sp)
    80003876:	7c02                	ld	s8,32(sp)
    80003878:	6ce2                	ld	s9,24(sp)
    8000387a:	6d42                	ld	s10,16(sp)
    8000387c:	6da2                	ld	s11,8(sp)
    8000387e:	a831                	j	8000389a <readi+0xd8>
    80003880:	6946                	ld	s2,80(sp)
    80003882:	7c02                	ld	s8,32(sp)
    80003884:	6ce2                	ld	s9,24(sp)
    80003886:	6d42                	ld	s10,16(sp)
    80003888:	6da2                	ld	s11,8(sp)
    8000388a:	a801                	j	8000389a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000388c:	89d6                	mv	s3,s5
    8000388e:	a031                	j	8000389a <readi+0xd8>
    80003890:	6946                	ld	s2,80(sp)
    80003892:	7c02                	ld	s8,32(sp)
    80003894:	6ce2                	ld	s9,24(sp)
    80003896:	6d42                	ld	s10,16(sp)
    80003898:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000389a:	854e                	mv	a0,s3
    8000389c:	69a6                	ld	s3,72(sp)
}
    8000389e:	70a6                	ld	ra,104(sp)
    800038a0:	7406                	ld	s0,96(sp)
    800038a2:	64e6                	ld	s1,88(sp)
    800038a4:	6a06                	ld	s4,64(sp)
    800038a6:	7ae2                	ld	s5,56(sp)
    800038a8:	7b42                	ld	s6,48(sp)
    800038aa:	7ba2                	ld	s7,40(sp)
    800038ac:	6165                	addi	sp,sp,112
    800038ae:	8082                	ret
    return 0;
    800038b0:	4501                	li	a0,0
}
    800038b2:	8082                	ret

00000000800038b4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038b4:	457c                	lw	a5,76(a0)
    800038b6:	0ed7eb63          	bltu	a5,a3,800039ac <writei+0xf8>
{
    800038ba:	7159                	addi	sp,sp,-112
    800038bc:	f486                	sd	ra,104(sp)
    800038be:	f0a2                	sd	s0,96(sp)
    800038c0:	e8ca                	sd	s2,80(sp)
    800038c2:	e0d2                	sd	s4,64(sp)
    800038c4:	fc56                	sd	s5,56(sp)
    800038c6:	f85a                	sd	s6,48(sp)
    800038c8:	f45e                	sd	s7,40(sp)
    800038ca:	1880                	addi	s0,sp,112
    800038cc:	8aaa                	mv	s5,a0
    800038ce:	8bae                	mv	s7,a1
    800038d0:	8a32                	mv	s4,a2
    800038d2:	8936                	mv	s2,a3
    800038d4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038d6:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800038da:	00043737          	lui	a4,0x43
    800038de:	0cf76963          	bltu	a4,a5,800039b0 <writei+0xfc>
    800038e2:	0cd7e763          	bltu	a5,a3,800039b0 <writei+0xfc>
    800038e6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800038e8:	0a0b0a63          	beqz	s6,8000399c <writei+0xe8>
    800038ec:	eca6                	sd	s1,88(sp)
    800038ee:	f062                	sd	s8,32(sp)
    800038f0:	ec66                	sd	s9,24(sp)
    800038f2:	e86a                	sd	s10,16(sp)
    800038f4:	e46e                	sd	s11,8(sp)
    800038f6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800038f8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800038fc:	5c7d                	li	s8,-1
    800038fe:	a825                	j	80003936 <writei+0x82>
    80003900:	020d1d93          	slli	s11,s10,0x20
    80003904:	020ddd93          	srli	s11,s11,0x20
    80003908:	05848513          	addi	a0,s1,88
    8000390c:	86ee                	mv	a3,s11
    8000390e:	8652                	mv	a2,s4
    80003910:	85de                	mv	a1,s7
    80003912:	953e                	add	a0,a0,a5
    80003914:	b8ffe0ef          	jal	800024a2 <either_copyin>
    80003918:	05850663          	beq	a0,s8,80003964 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000391c:	8526                	mv	a0,s1
    8000391e:	6b8000ef          	jal	80003fd6 <log_write>
    brelse(bp);
    80003922:	8526                	mv	a0,s1
    80003924:	d7cff0ef          	jal	80002ea0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003928:	013d09bb          	addw	s3,s10,s3
    8000392c:	012d093b          	addw	s2,s10,s2
    80003930:	9a6e                	add	s4,s4,s11
    80003932:	0369fc63          	bgeu	s3,s6,8000396a <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003936:	00a9559b          	srliw	a1,s2,0xa
    8000393a:	8556                	mv	a0,s5
    8000393c:	fc2ff0ef          	jal	800030fe <bmap>
    80003940:	85aa                	mv	a1,a0
    if(addr == 0)
    80003942:	c505                	beqz	a0,8000396a <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003944:	000aa503          	lw	a0,0(s5)
    80003948:	c50ff0ef          	jal	80002d98 <bread>
    8000394c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000394e:	3ff97793          	andi	a5,s2,1023
    80003952:	40fc873b          	subw	a4,s9,a5
    80003956:	413b06bb          	subw	a3,s6,s3
    8000395a:	8d3a                	mv	s10,a4
    8000395c:	fae6f2e3          	bgeu	a3,a4,80003900 <writei+0x4c>
    80003960:	8d36                	mv	s10,a3
    80003962:	bf79                	j	80003900 <writei+0x4c>
      brelse(bp);
    80003964:	8526                	mv	a0,s1
    80003966:	d3aff0ef          	jal	80002ea0 <brelse>
  }

  if(off > ip->size)
    8000396a:	04caa783          	lw	a5,76(s5)
    8000396e:	0327f963          	bgeu	a5,s2,800039a0 <writei+0xec>
    ip->size = off;
    80003972:	052aa623          	sw	s2,76(s5)
    80003976:	64e6                	ld	s1,88(sp)
    80003978:	7c02                	ld	s8,32(sp)
    8000397a:	6ce2                	ld	s9,24(sp)
    8000397c:	6d42                	ld	s10,16(sp)
    8000397e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003980:	8556                	mv	a0,s5
    80003982:	9fbff0ef          	jal	8000337c <iupdate>

  return tot;
    80003986:	854e                	mv	a0,s3
    80003988:	69a6                	ld	s3,72(sp)
}
    8000398a:	70a6                	ld	ra,104(sp)
    8000398c:	7406                	ld	s0,96(sp)
    8000398e:	6946                	ld	s2,80(sp)
    80003990:	6a06                	ld	s4,64(sp)
    80003992:	7ae2                	ld	s5,56(sp)
    80003994:	7b42                	ld	s6,48(sp)
    80003996:	7ba2                	ld	s7,40(sp)
    80003998:	6165                	addi	sp,sp,112
    8000399a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000399c:	89da                	mv	s3,s6
    8000399e:	b7cd                	j	80003980 <writei+0xcc>
    800039a0:	64e6                	ld	s1,88(sp)
    800039a2:	7c02                	ld	s8,32(sp)
    800039a4:	6ce2                	ld	s9,24(sp)
    800039a6:	6d42                	ld	s10,16(sp)
    800039a8:	6da2                	ld	s11,8(sp)
    800039aa:	bfd9                	j	80003980 <writei+0xcc>
    return -1;
    800039ac:	557d                	li	a0,-1
}
    800039ae:	8082                	ret
    return -1;
    800039b0:	557d                	li	a0,-1
    800039b2:	bfe1                	j	8000398a <writei+0xd6>

00000000800039b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800039b4:	1141                	addi	sp,sp,-16
    800039b6:	e406                	sd	ra,8(sp)
    800039b8:	e022                	sd	s0,0(sp)
    800039ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800039bc:	4639                	li	a2,14
    800039be:	c0efd0ef          	jal	80000dcc <strncmp>
}
    800039c2:	60a2                	ld	ra,8(sp)
    800039c4:	6402                	ld	s0,0(sp)
    800039c6:	0141                	addi	sp,sp,16
    800039c8:	8082                	ret

00000000800039ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800039ca:	711d                	addi	sp,sp,-96
    800039cc:	ec86                	sd	ra,88(sp)
    800039ce:	e8a2                	sd	s0,80(sp)
    800039d0:	e4a6                	sd	s1,72(sp)
    800039d2:	e0ca                	sd	s2,64(sp)
    800039d4:	fc4e                	sd	s3,56(sp)
    800039d6:	f852                	sd	s4,48(sp)
    800039d8:	f456                	sd	s5,40(sp)
    800039da:	f05a                	sd	s6,32(sp)
    800039dc:	ec5e                	sd	s7,24(sp)
    800039de:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800039e0:	04451703          	lh	a4,68(a0)
    800039e4:	4785                	li	a5,1
    800039e6:	00f71f63          	bne	a4,a5,80003a04 <dirlookup+0x3a>
    800039ea:	892a                	mv	s2,a0
    800039ec:	8aae                	mv	s5,a1
    800039ee:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800039f0:	457c                	lw	a5,76(a0)
    800039f2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039f4:	fa040a13          	addi	s4,s0,-96
    800039f8:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800039fa:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800039fe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a00:	e39d                	bnez	a5,80003a26 <dirlookup+0x5c>
    80003a02:	a8b9                	j	80003a60 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003a04:	00004517          	auipc	a0,0x4
    80003a08:	ab450513          	addi	a0,a0,-1356 # 800074b8 <etext+0x4b8>
    80003a0c:	e19fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80003a10:	00004517          	auipc	a0,0x4
    80003a14:	ac050513          	addi	a0,a0,-1344 # 800074d0 <etext+0x4d0>
    80003a18:	e0dfc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a1c:	24c1                	addiw	s1,s1,16
    80003a1e:	04c92783          	lw	a5,76(s2)
    80003a22:	02f4fe63          	bgeu	s1,a5,80003a5e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a26:	874e                	mv	a4,s3
    80003a28:	86a6                	mv	a3,s1
    80003a2a:	8652                	mv	a2,s4
    80003a2c:	4581                	li	a1,0
    80003a2e:	854a                	mv	a0,s2
    80003a30:	d93ff0ef          	jal	800037c2 <readi>
    80003a34:	fd351ee3          	bne	a0,s3,80003a10 <dirlookup+0x46>
    if(de.inum == 0)
    80003a38:	fa045783          	lhu	a5,-96(s0)
    80003a3c:	d3e5                	beqz	a5,80003a1c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003a3e:	85da                	mv	a1,s6
    80003a40:	8556                	mv	a0,s5
    80003a42:	f73ff0ef          	jal	800039b4 <namecmp>
    80003a46:	f979                	bnez	a0,80003a1c <dirlookup+0x52>
      if(poff)
    80003a48:	000b8463          	beqz	s7,80003a50 <dirlookup+0x86>
        *poff = off;
    80003a4c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003a50:	fa045583          	lhu	a1,-96(s0)
    80003a54:	00092503          	lw	a0,0(s2)
    80003a58:	f66ff0ef          	jal	800031be <iget>
    80003a5c:	a011                	j	80003a60 <dirlookup+0x96>
  return 0;
    80003a5e:	4501                	li	a0,0
}
    80003a60:	60e6                	ld	ra,88(sp)
    80003a62:	6446                	ld	s0,80(sp)
    80003a64:	64a6                	ld	s1,72(sp)
    80003a66:	6906                	ld	s2,64(sp)
    80003a68:	79e2                	ld	s3,56(sp)
    80003a6a:	7a42                	ld	s4,48(sp)
    80003a6c:	7aa2                	ld	s5,40(sp)
    80003a6e:	7b02                	ld	s6,32(sp)
    80003a70:	6be2                	ld	s7,24(sp)
    80003a72:	6125                	addi	sp,sp,96
    80003a74:	8082                	ret

0000000080003a76 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003a76:	711d                	addi	sp,sp,-96
    80003a78:	ec86                	sd	ra,88(sp)
    80003a7a:	e8a2                	sd	s0,80(sp)
    80003a7c:	e4a6                	sd	s1,72(sp)
    80003a7e:	e0ca                	sd	s2,64(sp)
    80003a80:	fc4e                	sd	s3,56(sp)
    80003a82:	f852                	sd	s4,48(sp)
    80003a84:	f456                	sd	s5,40(sp)
    80003a86:	f05a                	sd	s6,32(sp)
    80003a88:	ec5e                	sd	s7,24(sp)
    80003a8a:	e862                	sd	s8,16(sp)
    80003a8c:	e466                	sd	s9,8(sp)
    80003a8e:	e06a                	sd	s10,0(sp)
    80003a90:	1080                	addi	s0,sp,96
    80003a92:	84aa                	mv	s1,a0
    80003a94:	8b2e                	mv	s6,a1
    80003a96:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003a98:	00054703          	lbu	a4,0(a0)
    80003a9c:	02f00793          	li	a5,47
    80003aa0:	00f70f63          	beq	a4,a5,80003abe <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003aa4:	fa7fd0ef          	jal	80001a4a <myproc>
    80003aa8:	15053503          	ld	a0,336(a0)
    80003aac:	94fff0ef          	jal	800033fa <idup>
    80003ab0:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003ab2:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003ab6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003ab8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003aba:	4b85                	li	s7,1
    80003abc:	a879                	j	80003b5a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003abe:	4585                	li	a1,1
    80003ac0:	852e                	mv	a0,a1
    80003ac2:	efcff0ef          	jal	800031be <iget>
    80003ac6:	8a2a                	mv	s4,a0
    80003ac8:	b7ed                	j	80003ab2 <namex+0x3c>
      iunlockput(ip);
    80003aca:	8552                	mv	a0,s4
    80003acc:	b71ff0ef          	jal	8000363c <iunlockput>
      return 0;
    80003ad0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003ad2:	8552                	mv	a0,s4
    80003ad4:	60e6                	ld	ra,88(sp)
    80003ad6:	6446                	ld	s0,80(sp)
    80003ad8:	64a6                	ld	s1,72(sp)
    80003ada:	6906                	ld	s2,64(sp)
    80003adc:	79e2                	ld	s3,56(sp)
    80003ade:	7a42                	ld	s4,48(sp)
    80003ae0:	7aa2                	ld	s5,40(sp)
    80003ae2:	7b02                	ld	s6,32(sp)
    80003ae4:	6be2                	ld	s7,24(sp)
    80003ae6:	6c42                	ld	s8,16(sp)
    80003ae8:	6ca2                	ld	s9,8(sp)
    80003aea:	6d02                	ld	s10,0(sp)
    80003aec:	6125                	addi	sp,sp,96
    80003aee:	8082                	ret
      iunlock(ip);
    80003af0:	8552                	mv	a0,s4
    80003af2:	9edff0ef          	jal	800034de <iunlock>
      return ip;
    80003af6:	bff1                	j	80003ad2 <namex+0x5c>
      iunlockput(ip);
    80003af8:	8552                	mv	a0,s4
    80003afa:	b43ff0ef          	jal	8000363c <iunlockput>
      return 0;
    80003afe:	8a4a                	mv	s4,s2
    80003b00:	bfc9                	j	80003ad2 <namex+0x5c>
  len = path - s;
    80003b02:	40990633          	sub	a2,s2,s1
    80003b06:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003b0a:	09ac5463          	bge	s8,s10,80003b92 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003b0e:	8666                	mv	a2,s9
    80003b10:	85a6                	mv	a1,s1
    80003b12:	8556                	mv	a0,s5
    80003b14:	a44fd0ef          	jal	80000d58 <memmove>
    80003b18:	84ca                	mv	s1,s2
  while(*path == '/')
    80003b1a:	0004c783          	lbu	a5,0(s1)
    80003b1e:	01379763          	bne	a5,s3,80003b2c <namex+0xb6>
    path++;
    80003b22:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b24:	0004c783          	lbu	a5,0(s1)
    80003b28:	ff378de3          	beq	a5,s3,80003b22 <namex+0xac>
    ilock(ip);
    80003b2c:	8552                	mv	a0,s4
    80003b2e:	903ff0ef          	jal	80003430 <ilock>
    if(ip->type != T_DIR){
    80003b32:	044a1783          	lh	a5,68(s4)
    80003b36:	f9779ae3          	bne	a5,s7,80003aca <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003b3a:	000b0563          	beqz	s6,80003b44 <namex+0xce>
    80003b3e:	0004c783          	lbu	a5,0(s1)
    80003b42:	d7dd                	beqz	a5,80003af0 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003b44:	4601                	li	a2,0
    80003b46:	85d6                	mv	a1,s5
    80003b48:	8552                	mv	a0,s4
    80003b4a:	e81ff0ef          	jal	800039ca <dirlookup>
    80003b4e:	892a                	mv	s2,a0
    80003b50:	d545                	beqz	a0,80003af8 <namex+0x82>
    iunlockput(ip);
    80003b52:	8552                	mv	a0,s4
    80003b54:	ae9ff0ef          	jal	8000363c <iunlockput>
    ip = next;
    80003b58:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003b5a:	0004c783          	lbu	a5,0(s1)
    80003b5e:	01379763          	bne	a5,s3,80003b6c <namex+0xf6>
    path++;
    80003b62:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b64:	0004c783          	lbu	a5,0(s1)
    80003b68:	ff378de3          	beq	a5,s3,80003b62 <namex+0xec>
  if(*path == 0)
    80003b6c:	cf8d                	beqz	a5,80003ba6 <namex+0x130>
  while(*path != '/' && *path != 0)
    80003b6e:	0004c783          	lbu	a5,0(s1)
    80003b72:	fd178713          	addi	a4,a5,-47
    80003b76:	cb19                	beqz	a4,80003b8c <namex+0x116>
    80003b78:	cb91                	beqz	a5,80003b8c <namex+0x116>
    80003b7a:	8926                	mv	s2,s1
    path++;
    80003b7c:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003b7e:	00094783          	lbu	a5,0(s2)
    80003b82:	fd178713          	addi	a4,a5,-47
    80003b86:	df35                	beqz	a4,80003b02 <namex+0x8c>
    80003b88:	fbf5                	bnez	a5,80003b7c <namex+0x106>
    80003b8a:	bfa5                	j	80003b02 <namex+0x8c>
    80003b8c:	8926                	mv	s2,s1
  len = path - s;
    80003b8e:	4d01                	li	s10,0
    80003b90:	4601                	li	a2,0
    memmove(name, s, len);
    80003b92:	2601                	sext.w	a2,a2
    80003b94:	85a6                	mv	a1,s1
    80003b96:	8556                	mv	a0,s5
    80003b98:	9c0fd0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80003b9c:	9d56                	add	s10,s10,s5
    80003b9e:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdd438>
    80003ba2:	84ca                	mv	s1,s2
    80003ba4:	bf9d                	j	80003b1a <namex+0xa4>
  if(nameiparent){
    80003ba6:	f20b06e3          	beqz	s6,80003ad2 <namex+0x5c>
    iput(ip);
    80003baa:	8552                	mv	a0,s4
    80003bac:	a07ff0ef          	jal	800035b2 <iput>
    return 0;
    80003bb0:	4a01                	li	s4,0
    80003bb2:	b705                	j	80003ad2 <namex+0x5c>

0000000080003bb4 <dirlink>:
{
    80003bb4:	715d                	addi	sp,sp,-80
    80003bb6:	e486                	sd	ra,72(sp)
    80003bb8:	e0a2                	sd	s0,64(sp)
    80003bba:	f84a                	sd	s2,48(sp)
    80003bbc:	ec56                	sd	s5,24(sp)
    80003bbe:	e85a                	sd	s6,16(sp)
    80003bc0:	0880                	addi	s0,sp,80
    80003bc2:	892a                	mv	s2,a0
    80003bc4:	8aae                	mv	s5,a1
    80003bc6:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003bc8:	4601                	li	a2,0
    80003bca:	e01ff0ef          	jal	800039ca <dirlookup>
    80003bce:	ed1d                	bnez	a0,80003c0c <dirlink+0x58>
    80003bd0:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bd2:	04c92483          	lw	s1,76(s2)
    80003bd6:	c4b9                	beqz	s1,80003c24 <dirlink+0x70>
    80003bd8:	f44e                	sd	s3,40(sp)
    80003bda:	f052                	sd	s4,32(sp)
    80003bdc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bde:	fb040a13          	addi	s4,s0,-80
    80003be2:	49c1                	li	s3,16
    80003be4:	874e                	mv	a4,s3
    80003be6:	86a6                	mv	a3,s1
    80003be8:	8652                	mv	a2,s4
    80003bea:	4581                	li	a1,0
    80003bec:	854a                	mv	a0,s2
    80003bee:	bd5ff0ef          	jal	800037c2 <readi>
    80003bf2:	03351163          	bne	a0,s3,80003c14 <dirlink+0x60>
    if(de.inum == 0)
    80003bf6:	fb045783          	lhu	a5,-80(s0)
    80003bfa:	c39d                	beqz	a5,80003c20 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bfc:	24c1                	addiw	s1,s1,16
    80003bfe:	04c92783          	lw	a5,76(s2)
    80003c02:	fef4e1e3          	bltu	s1,a5,80003be4 <dirlink+0x30>
    80003c06:	79a2                	ld	s3,40(sp)
    80003c08:	7a02                	ld	s4,32(sp)
    80003c0a:	a829                	j	80003c24 <dirlink+0x70>
    iput(ip);
    80003c0c:	9a7ff0ef          	jal	800035b2 <iput>
    return -1;
    80003c10:	557d                	li	a0,-1
    80003c12:	a83d                	j	80003c50 <dirlink+0x9c>
      panic("dirlink read");
    80003c14:	00004517          	auipc	a0,0x4
    80003c18:	8cc50513          	addi	a0,a0,-1844 # 800074e0 <etext+0x4e0>
    80003c1c:	c09fc0ef          	jal	80000824 <panic>
    80003c20:	79a2                	ld	s3,40(sp)
    80003c22:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003c24:	4639                	li	a2,14
    80003c26:	85d6                	mv	a1,s5
    80003c28:	fb240513          	addi	a0,s0,-78
    80003c2c:	9dafd0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80003c30:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c34:	4741                	li	a4,16
    80003c36:	86a6                	mv	a3,s1
    80003c38:	fb040613          	addi	a2,s0,-80
    80003c3c:	4581                	li	a1,0
    80003c3e:	854a                	mv	a0,s2
    80003c40:	c75ff0ef          	jal	800038b4 <writei>
    80003c44:	1541                	addi	a0,a0,-16
    80003c46:	00a03533          	snez	a0,a0
    80003c4a:	40a0053b          	negw	a0,a0
    80003c4e:	74e2                	ld	s1,56(sp)
}
    80003c50:	60a6                	ld	ra,72(sp)
    80003c52:	6406                	ld	s0,64(sp)
    80003c54:	7942                	ld	s2,48(sp)
    80003c56:	6ae2                	ld	s5,24(sp)
    80003c58:	6b42                	ld	s6,16(sp)
    80003c5a:	6161                	addi	sp,sp,80
    80003c5c:	8082                	ret

0000000080003c5e <namei>:

struct inode*
namei(char *path)
{
    80003c5e:	1101                	addi	sp,sp,-32
    80003c60:	ec06                	sd	ra,24(sp)
    80003c62:	e822                	sd	s0,16(sp)
    80003c64:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c66:	fe040613          	addi	a2,s0,-32
    80003c6a:	4581                	li	a1,0
    80003c6c:	e0bff0ef          	jal	80003a76 <namex>
}
    80003c70:	60e2                	ld	ra,24(sp)
    80003c72:	6442                	ld	s0,16(sp)
    80003c74:	6105                	addi	sp,sp,32
    80003c76:	8082                	ret

0000000080003c78 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c78:	1141                	addi	sp,sp,-16
    80003c7a:	e406                	sd	ra,8(sp)
    80003c7c:	e022                	sd	s0,0(sp)
    80003c7e:	0800                	addi	s0,sp,16
    80003c80:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003c82:	4585                	li	a1,1
    80003c84:	df3ff0ef          	jal	80003a76 <namex>
}
    80003c88:	60a2                	ld	ra,8(sp)
    80003c8a:	6402                	ld	s0,0(sp)
    80003c8c:	0141                	addi	sp,sp,16
    80003c8e:	8082                	ret

0000000080003c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003c90:	1101                	addi	sp,sp,-32
    80003c92:	ec06                	sd	ra,24(sp)
    80003c94:	e822                	sd	s0,16(sp)
    80003c96:	e426                	sd	s1,8(sp)
    80003c98:	e04a                	sd	s2,0(sp)
    80003c9a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003c9c:	0001d917          	auipc	s2,0x1d
    80003ca0:	cec90913          	addi	s2,s2,-788 # 80020988 <log>
    80003ca4:	01892583          	lw	a1,24(s2)
    80003ca8:	02492503          	lw	a0,36(s2)
    80003cac:	8ecff0ef          	jal	80002d98 <bread>
    80003cb0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003cb2:	02892603          	lw	a2,40(s2)
    80003cb6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003cb8:	00c05f63          	blez	a2,80003cd6 <write_head+0x46>
    80003cbc:	0001d717          	auipc	a4,0x1d
    80003cc0:	cf870713          	addi	a4,a4,-776 # 800209b4 <log+0x2c>
    80003cc4:	87aa                	mv	a5,a0
    80003cc6:	060a                	slli	a2,a2,0x2
    80003cc8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003cca:	4314                	lw	a3,0(a4)
    80003ccc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003cce:	0711                	addi	a4,a4,4
    80003cd0:	0791                	addi	a5,a5,4
    80003cd2:	fec79ce3          	bne	a5,a2,80003cca <write_head+0x3a>
  }
  bwrite(buf);
    80003cd6:	8526                	mv	a0,s1
    80003cd8:	996ff0ef          	jal	80002e6e <bwrite>
  brelse(buf);
    80003cdc:	8526                	mv	a0,s1
    80003cde:	9c2ff0ef          	jal	80002ea0 <brelse>
}
    80003ce2:	60e2                	ld	ra,24(sp)
    80003ce4:	6442                	ld	s0,16(sp)
    80003ce6:	64a2                	ld	s1,8(sp)
    80003ce8:	6902                	ld	s2,0(sp)
    80003cea:	6105                	addi	sp,sp,32
    80003cec:	8082                	ret

0000000080003cee <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cee:	0001d797          	auipc	a5,0x1d
    80003cf2:	cc27a783          	lw	a5,-830(a5) # 800209b0 <log+0x28>
    80003cf6:	0cf05163          	blez	a5,80003db8 <install_trans+0xca>
{
    80003cfa:	715d                	addi	sp,sp,-80
    80003cfc:	e486                	sd	ra,72(sp)
    80003cfe:	e0a2                	sd	s0,64(sp)
    80003d00:	fc26                	sd	s1,56(sp)
    80003d02:	f84a                	sd	s2,48(sp)
    80003d04:	f44e                	sd	s3,40(sp)
    80003d06:	f052                	sd	s4,32(sp)
    80003d08:	ec56                	sd	s5,24(sp)
    80003d0a:	e85a                	sd	s6,16(sp)
    80003d0c:	e45e                	sd	s7,8(sp)
    80003d0e:	e062                	sd	s8,0(sp)
    80003d10:	0880                	addi	s0,sp,80
    80003d12:	8b2a                	mv	s6,a0
    80003d14:	0001da97          	auipc	s5,0x1d
    80003d18:	ca0a8a93          	addi	s5,s5,-864 # 800209b4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d1c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003d1e:	00003c17          	auipc	s8,0x3
    80003d22:	7d2c0c13          	addi	s8,s8,2002 # 800074f0 <etext+0x4f0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d26:	0001da17          	auipc	s4,0x1d
    80003d2a:	c62a0a13          	addi	s4,s4,-926 # 80020988 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d2e:	40000b93          	li	s7,1024
    80003d32:	a025                	j	80003d5a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003d34:	000aa603          	lw	a2,0(s5)
    80003d38:	85ce                	mv	a1,s3
    80003d3a:	8562                	mv	a0,s8
    80003d3c:	fbefc0ef          	jal	800004fa <printf>
    80003d40:	a839                	j	80003d5e <install_trans+0x70>
    brelse(lbuf);
    80003d42:	854a                	mv	a0,s2
    80003d44:	95cff0ef          	jal	80002ea0 <brelse>
    brelse(dbuf);
    80003d48:	8526                	mv	a0,s1
    80003d4a:	956ff0ef          	jal	80002ea0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d4e:	2985                	addiw	s3,s3,1
    80003d50:	0a91                	addi	s5,s5,4
    80003d52:	028a2783          	lw	a5,40(s4)
    80003d56:	04f9d563          	bge	s3,a5,80003da0 <install_trans+0xb2>
    if(recovering) {
    80003d5a:	fc0b1de3          	bnez	s6,80003d34 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d5e:	018a2583          	lw	a1,24(s4)
    80003d62:	013585bb          	addw	a1,a1,s3
    80003d66:	2585                	addiw	a1,a1,1
    80003d68:	024a2503          	lw	a0,36(s4)
    80003d6c:	82cff0ef          	jal	80002d98 <bread>
    80003d70:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003d72:	000aa583          	lw	a1,0(s5)
    80003d76:	024a2503          	lw	a0,36(s4)
    80003d7a:	81eff0ef          	jal	80002d98 <bread>
    80003d7e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d80:	865e                	mv	a2,s7
    80003d82:	05890593          	addi	a1,s2,88
    80003d86:	05850513          	addi	a0,a0,88
    80003d8a:	fcffc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d8e:	8526                	mv	a0,s1
    80003d90:	8deff0ef          	jal	80002e6e <bwrite>
    if(recovering == 0)
    80003d94:	fa0b17e3          	bnez	s6,80003d42 <install_trans+0x54>
      bunpin(dbuf);
    80003d98:	8526                	mv	a0,s1
    80003d9a:	9beff0ef          	jal	80002f58 <bunpin>
    80003d9e:	b755                	j	80003d42 <install_trans+0x54>
}
    80003da0:	60a6                	ld	ra,72(sp)
    80003da2:	6406                	ld	s0,64(sp)
    80003da4:	74e2                	ld	s1,56(sp)
    80003da6:	7942                	ld	s2,48(sp)
    80003da8:	79a2                	ld	s3,40(sp)
    80003daa:	7a02                	ld	s4,32(sp)
    80003dac:	6ae2                	ld	s5,24(sp)
    80003dae:	6b42                	ld	s6,16(sp)
    80003db0:	6ba2                	ld	s7,8(sp)
    80003db2:	6c02                	ld	s8,0(sp)
    80003db4:	6161                	addi	sp,sp,80
    80003db6:	8082                	ret
    80003db8:	8082                	ret

0000000080003dba <initlog>:
{
    80003dba:	7179                	addi	sp,sp,-48
    80003dbc:	f406                	sd	ra,40(sp)
    80003dbe:	f022                	sd	s0,32(sp)
    80003dc0:	ec26                	sd	s1,24(sp)
    80003dc2:	e84a                	sd	s2,16(sp)
    80003dc4:	e44e                	sd	s3,8(sp)
    80003dc6:	1800                	addi	s0,sp,48
    80003dc8:	84aa                	mv	s1,a0
    80003dca:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003dcc:	0001d917          	auipc	s2,0x1d
    80003dd0:	bbc90913          	addi	s2,s2,-1092 # 80020988 <log>
    80003dd4:	00003597          	auipc	a1,0x3
    80003dd8:	73c58593          	addi	a1,a1,1852 # 80007510 <etext+0x510>
    80003ddc:	854a                	mv	a0,s2
    80003dde:	dc1fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80003de2:	0149a583          	lw	a1,20(s3)
    80003de6:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003dea:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003dee:	8526                	mv	a0,s1
    80003df0:	fa9fe0ef          	jal	80002d98 <bread>
  log.lh.n = lh->n;
    80003df4:	4d30                	lw	a2,88(a0)
    80003df6:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003dfa:	00c05f63          	blez	a2,80003e18 <initlog+0x5e>
    80003dfe:	87aa                	mv	a5,a0
    80003e00:	0001d717          	auipc	a4,0x1d
    80003e04:	bb470713          	addi	a4,a4,-1100 # 800209b4 <log+0x2c>
    80003e08:	060a                	slli	a2,a2,0x2
    80003e0a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e0c:	4ff4                	lw	a3,92(a5)
    80003e0e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e10:	0791                	addi	a5,a5,4
    80003e12:	0711                	addi	a4,a4,4
    80003e14:	fec79ce3          	bne	a5,a2,80003e0c <initlog+0x52>
  brelse(buf);
    80003e18:	888ff0ef          	jal	80002ea0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e1c:	4505                	li	a0,1
    80003e1e:	ed1ff0ef          	jal	80003cee <install_trans>
  log.lh.n = 0;
    80003e22:	0001d797          	auipc	a5,0x1d
    80003e26:	b807a723          	sw	zero,-1138(a5) # 800209b0 <log+0x28>
  write_head(); // clear the log
    80003e2a:	e67ff0ef          	jal	80003c90 <write_head>
}
    80003e2e:	70a2                	ld	ra,40(sp)
    80003e30:	7402                	ld	s0,32(sp)
    80003e32:	64e2                	ld	s1,24(sp)
    80003e34:	6942                	ld	s2,16(sp)
    80003e36:	69a2                	ld	s3,8(sp)
    80003e38:	6145                	addi	sp,sp,48
    80003e3a:	8082                	ret

0000000080003e3c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e3c:	1101                	addi	sp,sp,-32
    80003e3e:	ec06                	sd	ra,24(sp)
    80003e40:	e822                	sd	s0,16(sp)
    80003e42:	e426                	sd	s1,8(sp)
    80003e44:	e04a                	sd	s2,0(sp)
    80003e46:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e48:	0001d517          	auipc	a0,0x1d
    80003e4c:	b4050513          	addi	a0,a0,-1216 # 80020988 <log>
    80003e50:	dd9fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80003e54:	0001d497          	auipc	s1,0x1d
    80003e58:	b3448493          	addi	s1,s1,-1228 # 80020988 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003e5c:	4979                	li	s2,30
    80003e5e:	a029                	j	80003e68 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003e60:	85a6                	mv	a1,s1
    80003e62:	8526                	mv	a0,s1
    80003e64:	a72fe0ef          	jal	800020d6 <sleep>
    if(log.committing){
    80003e68:	509c                	lw	a5,32(s1)
    80003e6a:	fbfd                	bnez	a5,80003e60 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003e6c:	4cd8                	lw	a4,28(s1)
    80003e6e:	2705                	addiw	a4,a4,1
    80003e70:	0027179b          	slliw	a5,a4,0x2
    80003e74:	9fb9                	addw	a5,a5,a4
    80003e76:	0017979b          	slliw	a5,a5,0x1
    80003e7a:	5494                	lw	a3,40(s1)
    80003e7c:	9fb5                	addw	a5,a5,a3
    80003e7e:	00f95763          	bge	s2,a5,80003e8c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003e82:	85a6                	mv	a1,s1
    80003e84:	8526                	mv	a0,s1
    80003e86:	a50fe0ef          	jal	800020d6 <sleep>
    80003e8a:	bff9                	j	80003e68 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003e8c:	0001d797          	auipc	a5,0x1d
    80003e90:	b0e7ac23          	sw	a4,-1256(a5) # 800209a4 <log+0x1c>
      release(&log.lock);
    80003e94:	0001d517          	auipc	a0,0x1d
    80003e98:	af450513          	addi	a0,a0,-1292 # 80020988 <log>
    80003e9c:	e21fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003ea0:	60e2                	ld	ra,24(sp)
    80003ea2:	6442                	ld	s0,16(sp)
    80003ea4:	64a2                	ld	s1,8(sp)
    80003ea6:	6902                	ld	s2,0(sp)
    80003ea8:	6105                	addi	sp,sp,32
    80003eaa:	8082                	ret

0000000080003eac <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003eac:	7139                	addi	sp,sp,-64
    80003eae:	fc06                	sd	ra,56(sp)
    80003eb0:	f822                	sd	s0,48(sp)
    80003eb2:	f426                	sd	s1,40(sp)
    80003eb4:	f04a                	sd	s2,32(sp)
    80003eb6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003eb8:	0001d497          	auipc	s1,0x1d
    80003ebc:	ad048493          	addi	s1,s1,-1328 # 80020988 <log>
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	d67fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80003ec6:	4cdc                	lw	a5,28(s1)
    80003ec8:	37fd                	addiw	a5,a5,-1
    80003eca:	893e                	mv	s2,a5
    80003ecc:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003ece:	509c                	lw	a5,32(s1)
    80003ed0:	e7b1                	bnez	a5,80003f1c <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ed2:	04091e63          	bnez	s2,80003f2e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003ed6:	0001d497          	auipc	s1,0x1d
    80003eda:	ab248493          	addi	s1,s1,-1358 # 80020988 <log>
    80003ede:	4785                	li	a5,1
    80003ee0:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	dd9fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003ee8:	549c                	lw	a5,40(s1)
    80003eea:	06f04463          	bgtz	a5,80003f52 <end_op+0xa6>
    acquire(&log.lock);
    80003eee:	0001d517          	auipc	a0,0x1d
    80003ef2:	a9a50513          	addi	a0,a0,-1382 # 80020988 <log>
    80003ef6:	d33fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80003efa:	0001d797          	auipc	a5,0x1d
    80003efe:	aa07a723          	sw	zero,-1362(a5) # 800209a8 <log+0x20>
    wakeup(&log);
    80003f02:	0001d517          	auipc	a0,0x1d
    80003f06:	a8650513          	addi	a0,a0,-1402 # 80020988 <log>
    80003f0a:	a18fe0ef          	jal	80002122 <wakeup>
    release(&log.lock);
    80003f0e:	0001d517          	auipc	a0,0x1d
    80003f12:	a7a50513          	addi	a0,a0,-1414 # 80020988 <log>
    80003f16:	da7fc0ef          	jal	80000cbc <release>
}
    80003f1a:	a035                	j	80003f46 <end_op+0x9a>
    80003f1c:	ec4e                	sd	s3,24(sp)
    80003f1e:	e852                	sd	s4,16(sp)
    80003f20:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f22:	00003517          	auipc	a0,0x3
    80003f26:	5f650513          	addi	a0,a0,1526 # 80007518 <etext+0x518>
    80003f2a:	8fbfc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80003f2e:	0001d517          	auipc	a0,0x1d
    80003f32:	a5a50513          	addi	a0,a0,-1446 # 80020988 <log>
    80003f36:	9ecfe0ef          	jal	80002122 <wakeup>
  release(&log.lock);
    80003f3a:	0001d517          	auipc	a0,0x1d
    80003f3e:	a4e50513          	addi	a0,a0,-1458 # 80020988 <log>
    80003f42:	d7bfc0ef          	jal	80000cbc <release>
}
    80003f46:	70e2                	ld	ra,56(sp)
    80003f48:	7442                	ld	s0,48(sp)
    80003f4a:	74a2                	ld	s1,40(sp)
    80003f4c:	7902                	ld	s2,32(sp)
    80003f4e:	6121                	addi	sp,sp,64
    80003f50:	8082                	ret
    80003f52:	ec4e                	sd	s3,24(sp)
    80003f54:	e852                	sd	s4,16(sp)
    80003f56:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f58:	0001da97          	auipc	s5,0x1d
    80003f5c:	a5ca8a93          	addi	s5,s5,-1444 # 800209b4 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003f60:	0001da17          	auipc	s4,0x1d
    80003f64:	a28a0a13          	addi	s4,s4,-1496 # 80020988 <log>
    80003f68:	018a2583          	lw	a1,24(s4)
    80003f6c:	012585bb          	addw	a1,a1,s2
    80003f70:	2585                	addiw	a1,a1,1
    80003f72:	024a2503          	lw	a0,36(s4)
    80003f76:	e23fe0ef          	jal	80002d98 <bread>
    80003f7a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003f7c:	000aa583          	lw	a1,0(s5)
    80003f80:	024a2503          	lw	a0,36(s4)
    80003f84:	e15fe0ef          	jal	80002d98 <bread>
    80003f88:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f8a:	40000613          	li	a2,1024
    80003f8e:	05850593          	addi	a1,a0,88
    80003f92:	05848513          	addi	a0,s1,88
    80003f96:	dc3fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	ed3fe0ef          	jal	80002e6e <bwrite>
    brelse(from);
    80003fa0:	854e                	mv	a0,s3
    80003fa2:	efffe0ef          	jal	80002ea0 <brelse>
    brelse(to);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	ef9fe0ef          	jal	80002ea0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fac:	2905                	addiw	s2,s2,1
    80003fae:	0a91                	addi	s5,s5,4
    80003fb0:	028a2783          	lw	a5,40(s4)
    80003fb4:	faf94ae3          	blt	s2,a5,80003f68 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003fb8:	cd9ff0ef          	jal	80003c90 <write_head>
    install_trans(0); // Now install writes to home locations
    80003fbc:	4501                	li	a0,0
    80003fbe:	d31ff0ef          	jal	80003cee <install_trans>
    log.lh.n = 0;
    80003fc2:	0001d797          	auipc	a5,0x1d
    80003fc6:	9e07a723          	sw	zero,-1554(a5) # 800209b0 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003fca:	cc7ff0ef          	jal	80003c90 <write_head>
    80003fce:	69e2                	ld	s3,24(sp)
    80003fd0:	6a42                	ld	s4,16(sp)
    80003fd2:	6aa2                	ld	s5,8(sp)
    80003fd4:	bf29                	j	80003eee <end_op+0x42>

0000000080003fd6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003fd6:	1101                	addi	sp,sp,-32
    80003fd8:	ec06                	sd	ra,24(sp)
    80003fda:	e822                	sd	s0,16(sp)
    80003fdc:	e426                	sd	s1,8(sp)
    80003fde:	1000                	addi	s0,sp,32
    80003fe0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003fe2:	0001d517          	auipc	a0,0x1d
    80003fe6:	9a650513          	addi	a0,a0,-1626 # 80020988 <log>
    80003fea:	c3ffc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003fee:	0001d617          	auipc	a2,0x1d
    80003ff2:	9c262603          	lw	a2,-1598(a2) # 800209b0 <log+0x28>
    80003ff6:	47f5                	li	a5,29
    80003ff8:	04c7cd63          	blt	a5,a2,80004052 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ffc:	0001d797          	auipc	a5,0x1d
    80004000:	9a87a783          	lw	a5,-1624(a5) # 800209a4 <log+0x1c>
    80004004:	04f05d63          	blez	a5,8000405e <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004008:	4781                	li	a5,0
    8000400a:	06c05063          	blez	a2,8000406a <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000400e:	44cc                	lw	a1,12(s1)
    80004010:	0001d717          	auipc	a4,0x1d
    80004014:	9a470713          	addi	a4,a4,-1628 # 800209b4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004018:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000401a:	4314                	lw	a3,0(a4)
    8000401c:	04b68763          	beq	a3,a1,8000406a <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80004020:	2785                	addiw	a5,a5,1
    80004022:	0711                	addi	a4,a4,4
    80004024:	fef61be3          	bne	a2,a5,8000401a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004028:	060a                	slli	a2,a2,0x2
    8000402a:	02060613          	addi	a2,a2,32
    8000402e:	0001d797          	auipc	a5,0x1d
    80004032:	95a78793          	addi	a5,a5,-1702 # 80020988 <log>
    80004036:	97b2                	add	a5,a5,a2
    80004038:	44d8                	lw	a4,12(s1)
    8000403a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000403c:	8526                	mv	a0,s1
    8000403e:	ee7fe0ef          	jal	80002f24 <bpin>
    log.lh.n++;
    80004042:	0001d717          	auipc	a4,0x1d
    80004046:	94670713          	addi	a4,a4,-1722 # 80020988 <log>
    8000404a:	571c                	lw	a5,40(a4)
    8000404c:	2785                	addiw	a5,a5,1
    8000404e:	d71c                	sw	a5,40(a4)
    80004050:	a815                	j	80004084 <log_write+0xae>
    panic("too big a transaction");
    80004052:	00003517          	auipc	a0,0x3
    80004056:	4d650513          	addi	a0,a0,1238 # 80007528 <etext+0x528>
    8000405a:	fcafc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    8000405e:	00003517          	auipc	a0,0x3
    80004062:	4e250513          	addi	a0,a0,1250 # 80007540 <etext+0x540>
    80004066:	fbefc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    8000406a:	00279693          	slli	a3,a5,0x2
    8000406e:	02068693          	addi	a3,a3,32
    80004072:	0001d717          	auipc	a4,0x1d
    80004076:	91670713          	addi	a4,a4,-1770 # 80020988 <log>
    8000407a:	9736                	add	a4,a4,a3
    8000407c:	44d4                	lw	a3,12(s1)
    8000407e:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004080:	faf60ee3          	beq	a2,a5,8000403c <log_write+0x66>
  }
  release(&log.lock);
    80004084:	0001d517          	auipc	a0,0x1d
    80004088:	90450513          	addi	a0,a0,-1788 # 80020988 <log>
    8000408c:	c31fc0ef          	jal	80000cbc <release>
}
    80004090:	60e2                	ld	ra,24(sp)
    80004092:	6442                	ld	s0,16(sp)
    80004094:	64a2                	ld	s1,8(sp)
    80004096:	6105                	addi	sp,sp,32
    80004098:	8082                	ret

000000008000409a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000409a:	1101                	addi	sp,sp,-32
    8000409c:	ec06                	sd	ra,24(sp)
    8000409e:	e822                	sd	s0,16(sp)
    800040a0:	e426                	sd	s1,8(sp)
    800040a2:	e04a                	sd	s2,0(sp)
    800040a4:	1000                	addi	s0,sp,32
    800040a6:	84aa                	mv	s1,a0
    800040a8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800040aa:	00003597          	auipc	a1,0x3
    800040ae:	4b658593          	addi	a1,a1,1206 # 80007560 <etext+0x560>
    800040b2:	0521                	addi	a0,a0,8
    800040b4:	aebfc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    800040b8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800040bc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800040c0:	0204a423          	sw	zero,40(s1)
}
    800040c4:	60e2                	ld	ra,24(sp)
    800040c6:	6442                	ld	s0,16(sp)
    800040c8:	64a2                	ld	s1,8(sp)
    800040ca:	6902                	ld	s2,0(sp)
    800040cc:	6105                	addi	sp,sp,32
    800040ce:	8082                	ret

00000000800040d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800040d0:	1101                	addi	sp,sp,-32
    800040d2:	ec06                	sd	ra,24(sp)
    800040d4:	e822                	sd	s0,16(sp)
    800040d6:	e426                	sd	s1,8(sp)
    800040d8:	e04a                	sd	s2,0(sp)
    800040da:	1000                	addi	s0,sp,32
    800040dc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040de:	00850913          	addi	s2,a0,8
    800040e2:	854a                	mv	a0,s2
    800040e4:	b45fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    800040e8:	409c                	lw	a5,0(s1)
    800040ea:	c799                	beqz	a5,800040f8 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800040ec:	85ca                	mv	a1,s2
    800040ee:	8526                	mv	a0,s1
    800040f0:	fe7fd0ef          	jal	800020d6 <sleep>
  while (lk->locked) {
    800040f4:	409c                	lw	a5,0(s1)
    800040f6:	fbfd                	bnez	a5,800040ec <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800040f8:	4785                	li	a5,1
    800040fa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800040fc:	94ffd0ef          	jal	80001a4a <myproc>
    80004100:	591c                	lw	a5,48(a0)
    80004102:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004104:	854a                	mv	a0,s2
    80004106:	bb7fc0ef          	jal	80000cbc <release>
}
    8000410a:	60e2                	ld	ra,24(sp)
    8000410c:	6442                	ld	s0,16(sp)
    8000410e:	64a2                	ld	s1,8(sp)
    80004110:	6902                	ld	s2,0(sp)
    80004112:	6105                	addi	sp,sp,32
    80004114:	8082                	ret

0000000080004116 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004116:	1101                	addi	sp,sp,-32
    80004118:	ec06                	sd	ra,24(sp)
    8000411a:	e822                	sd	s0,16(sp)
    8000411c:	e426                	sd	s1,8(sp)
    8000411e:	e04a                	sd	s2,0(sp)
    80004120:	1000                	addi	s0,sp,32
    80004122:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004124:	00850913          	addi	s2,a0,8
    80004128:	854a                	mv	a0,s2
    8000412a:	afffc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    8000412e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004132:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004136:	8526                	mv	a0,s1
    80004138:	febfd0ef          	jal	80002122 <wakeup>
  release(&lk->lk);
    8000413c:	854a                	mv	a0,s2
    8000413e:	b7ffc0ef          	jal	80000cbc <release>
}
    80004142:	60e2                	ld	ra,24(sp)
    80004144:	6442                	ld	s0,16(sp)
    80004146:	64a2                	ld	s1,8(sp)
    80004148:	6902                	ld	s2,0(sp)
    8000414a:	6105                	addi	sp,sp,32
    8000414c:	8082                	ret

000000008000414e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000414e:	7179                	addi	sp,sp,-48
    80004150:	f406                	sd	ra,40(sp)
    80004152:	f022                	sd	s0,32(sp)
    80004154:	ec26                	sd	s1,24(sp)
    80004156:	e84a                	sd	s2,16(sp)
    80004158:	1800                	addi	s0,sp,48
    8000415a:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000415c:	00850913          	addi	s2,a0,8
    80004160:	854a                	mv	a0,s2
    80004162:	ac7fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004166:	409c                	lw	a5,0(s1)
    80004168:	ef81                	bnez	a5,80004180 <holdingsleep+0x32>
    8000416a:	4481                	li	s1,0
  release(&lk->lk);
    8000416c:	854a                	mv	a0,s2
    8000416e:	b4ffc0ef          	jal	80000cbc <release>
  return r;
}
    80004172:	8526                	mv	a0,s1
    80004174:	70a2                	ld	ra,40(sp)
    80004176:	7402                	ld	s0,32(sp)
    80004178:	64e2                	ld	s1,24(sp)
    8000417a:	6942                	ld	s2,16(sp)
    8000417c:	6145                	addi	sp,sp,48
    8000417e:	8082                	ret
    80004180:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004182:	0284a983          	lw	s3,40(s1)
    80004186:	8c5fd0ef          	jal	80001a4a <myproc>
    8000418a:	5904                	lw	s1,48(a0)
    8000418c:	413484b3          	sub	s1,s1,s3
    80004190:	0014b493          	seqz	s1,s1
    80004194:	69a2                	ld	s3,8(sp)
    80004196:	bfd9                	j	8000416c <holdingsleep+0x1e>

0000000080004198 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004198:	1141                	addi	sp,sp,-16
    8000419a:	e406                	sd	ra,8(sp)
    8000419c:	e022                	sd	s0,0(sp)
    8000419e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800041a0:	00003597          	auipc	a1,0x3
    800041a4:	3d058593          	addi	a1,a1,976 # 80007570 <etext+0x570>
    800041a8:	0001d517          	auipc	a0,0x1d
    800041ac:	92850513          	addi	a0,a0,-1752 # 80020ad0 <ftable>
    800041b0:	9effc0ef          	jal	80000b9e <initlock>
}
    800041b4:	60a2                	ld	ra,8(sp)
    800041b6:	6402                	ld	s0,0(sp)
    800041b8:	0141                	addi	sp,sp,16
    800041ba:	8082                	ret

00000000800041bc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800041bc:	1101                	addi	sp,sp,-32
    800041be:	ec06                	sd	ra,24(sp)
    800041c0:	e822                	sd	s0,16(sp)
    800041c2:	e426                	sd	s1,8(sp)
    800041c4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800041c6:	0001d517          	auipc	a0,0x1d
    800041ca:	90a50513          	addi	a0,a0,-1782 # 80020ad0 <ftable>
    800041ce:	a5bfc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041d2:	0001d497          	auipc	s1,0x1d
    800041d6:	91648493          	addi	s1,s1,-1770 # 80020ae8 <ftable+0x18>
    800041da:	0001e717          	auipc	a4,0x1e
    800041de:	8ae70713          	addi	a4,a4,-1874 # 80021a88 <disk>
    if(f->ref == 0){
    800041e2:	40dc                	lw	a5,4(s1)
    800041e4:	cf89                	beqz	a5,800041fe <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041e6:	02848493          	addi	s1,s1,40
    800041ea:	fee49ce3          	bne	s1,a4,800041e2 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800041ee:	0001d517          	auipc	a0,0x1d
    800041f2:	8e250513          	addi	a0,a0,-1822 # 80020ad0 <ftable>
    800041f6:	ac7fc0ef          	jal	80000cbc <release>
  return 0;
    800041fa:	4481                	li	s1,0
    800041fc:	a809                	j	8000420e <filealloc+0x52>
      f->ref = 1;
    800041fe:	4785                	li	a5,1
    80004200:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004202:	0001d517          	auipc	a0,0x1d
    80004206:	8ce50513          	addi	a0,a0,-1842 # 80020ad0 <ftable>
    8000420a:	ab3fc0ef          	jal	80000cbc <release>
}
    8000420e:	8526                	mv	a0,s1
    80004210:	60e2                	ld	ra,24(sp)
    80004212:	6442                	ld	s0,16(sp)
    80004214:	64a2                	ld	s1,8(sp)
    80004216:	6105                	addi	sp,sp,32
    80004218:	8082                	ret

000000008000421a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000421a:	1101                	addi	sp,sp,-32
    8000421c:	ec06                	sd	ra,24(sp)
    8000421e:	e822                	sd	s0,16(sp)
    80004220:	e426                	sd	s1,8(sp)
    80004222:	1000                	addi	s0,sp,32
    80004224:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004226:	0001d517          	auipc	a0,0x1d
    8000422a:	8aa50513          	addi	a0,a0,-1878 # 80020ad0 <ftable>
    8000422e:	9fbfc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004232:	40dc                	lw	a5,4(s1)
    80004234:	02f05063          	blez	a5,80004254 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004238:	2785                	addiw	a5,a5,1
    8000423a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000423c:	0001d517          	auipc	a0,0x1d
    80004240:	89450513          	addi	a0,a0,-1900 # 80020ad0 <ftable>
    80004244:	a79fc0ef          	jal	80000cbc <release>
  return f;
}
    80004248:	8526                	mv	a0,s1
    8000424a:	60e2                	ld	ra,24(sp)
    8000424c:	6442                	ld	s0,16(sp)
    8000424e:	64a2                	ld	s1,8(sp)
    80004250:	6105                	addi	sp,sp,32
    80004252:	8082                	ret
    panic("filedup");
    80004254:	00003517          	auipc	a0,0x3
    80004258:	32450513          	addi	a0,a0,804 # 80007578 <etext+0x578>
    8000425c:	dc8fc0ef          	jal	80000824 <panic>

0000000080004260 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004260:	7139                	addi	sp,sp,-64
    80004262:	fc06                	sd	ra,56(sp)
    80004264:	f822                	sd	s0,48(sp)
    80004266:	f426                	sd	s1,40(sp)
    80004268:	0080                	addi	s0,sp,64
    8000426a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000426c:	0001d517          	auipc	a0,0x1d
    80004270:	86450513          	addi	a0,a0,-1948 # 80020ad0 <ftable>
    80004274:	9b5fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004278:	40dc                	lw	a5,4(s1)
    8000427a:	04f05a63          	blez	a5,800042ce <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000427e:	37fd                	addiw	a5,a5,-1
    80004280:	c0dc                	sw	a5,4(s1)
    80004282:	06f04063          	bgtz	a5,800042e2 <fileclose+0x82>
    80004286:	f04a                	sd	s2,32(sp)
    80004288:	ec4e                	sd	s3,24(sp)
    8000428a:	e852                	sd	s4,16(sp)
    8000428c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000428e:	0004a903          	lw	s2,0(s1)
    80004292:	0094c783          	lbu	a5,9(s1)
    80004296:	89be                	mv	s3,a5
    80004298:	689c                	ld	a5,16(s1)
    8000429a:	8a3e                	mv	s4,a5
    8000429c:	6c9c                	ld	a5,24(s1)
    8000429e:	8abe                	mv	s5,a5
  f->ref = 0;
    800042a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800042a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800042a8:	0001d517          	auipc	a0,0x1d
    800042ac:	82850513          	addi	a0,a0,-2008 # 80020ad0 <ftable>
    800042b0:	a0dfc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    800042b4:	4785                	li	a5,1
    800042b6:	04f90163          	beq	s2,a5,800042f8 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800042ba:	ffe9079b          	addiw	a5,s2,-2
    800042be:	4705                	li	a4,1
    800042c0:	04f77563          	bgeu	a4,a5,8000430a <fileclose+0xaa>
    800042c4:	7902                	ld	s2,32(sp)
    800042c6:	69e2                	ld	s3,24(sp)
    800042c8:	6a42                	ld	s4,16(sp)
    800042ca:	6aa2                	ld	s5,8(sp)
    800042cc:	a00d                	j	800042ee <fileclose+0x8e>
    800042ce:	f04a                	sd	s2,32(sp)
    800042d0:	ec4e                	sd	s3,24(sp)
    800042d2:	e852                	sd	s4,16(sp)
    800042d4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800042d6:	00003517          	auipc	a0,0x3
    800042da:	2aa50513          	addi	a0,a0,682 # 80007580 <etext+0x580>
    800042de:	d46fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    800042e2:	0001c517          	auipc	a0,0x1c
    800042e6:	7ee50513          	addi	a0,a0,2030 # 80020ad0 <ftable>
    800042ea:	9d3fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800042ee:	70e2                	ld	ra,56(sp)
    800042f0:	7442                	ld	s0,48(sp)
    800042f2:	74a2                	ld	s1,40(sp)
    800042f4:	6121                	addi	sp,sp,64
    800042f6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800042f8:	85ce                	mv	a1,s3
    800042fa:	8552                	mv	a0,s4
    800042fc:	348000ef          	jal	80004644 <pipeclose>
    80004300:	7902                	ld	s2,32(sp)
    80004302:	69e2                	ld	s3,24(sp)
    80004304:	6a42                	ld	s4,16(sp)
    80004306:	6aa2                	ld	s5,8(sp)
    80004308:	b7dd                	j	800042ee <fileclose+0x8e>
    begin_op();
    8000430a:	b33ff0ef          	jal	80003e3c <begin_op>
    iput(ff.ip);
    8000430e:	8556                	mv	a0,s5
    80004310:	aa2ff0ef          	jal	800035b2 <iput>
    end_op();
    80004314:	b99ff0ef          	jal	80003eac <end_op>
    80004318:	7902                	ld	s2,32(sp)
    8000431a:	69e2                	ld	s3,24(sp)
    8000431c:	6a42                	ld	s4,16(sp)
    8000431e:	6aa2                	ld	s5,8(sp)
    80004320:	b7f9                	j	800042ee <fileclose+0x8e>

0000000080004322 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004322:	715d                	addi	sp,sp,-80
    80004324:	e486                	sd	ra,72(sp)
    80004326:	e0a2                	sd	s0,64(sp)
    80004328:	fc26                	sd	s1,56(sp)
    8000432a:	f052                	sd	s4,32(sp)
    8000432c:	0880                	addi	s0,sp,80
    8000432e:	84aa                	mv	s1,a0
    80004330:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004332:	f18fd0ef          	jal	80001a4a <myproc>
  struct stat st;

  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004336:	409c                	lw	a5,0(s1)
    80004338:	37f9                	addiw	a5,a5,-2
    8000433a:	4705                	li	a4,1
    8000433c:	04f76263          	bltu	a4,a5,80004380 <filestat+0x5e>
    80004340:	f84a                	sd	s2,48(sp)
    80004342:	f44e                	sd	s3,40(sp)
    80004344:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004346:	6c88                	ld	a0,24(s1)
    80004348:	8e8ff0ef          	jal	80003430 <ilock>
    stati(f->ip, &st);
    8000434c:	fb840913          	addi	s2,s0,-72
    80004350:	85ca                	mv	a1,s2
    80004352:	6c88                	ld	a0,24(s1)
    80004354:	c40ff0ef          	jal	80003794 <stati>
    iunlock(f->ip);
    80004358:	6c88                	ld	a0,24(s1)
    8000435a:	984ff0ef          	jal	800034de <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000435e:	46e1                	li	a3,24
    80004360:	864a                	mv	a2,s2
    80004362:	85d2                	mv	a1,s4
    80004364:	0509b503          	ld	a0,80(s3)
    80004368:	aecfd0ef          	jal	80001654 <copyout>
    8000436c:	41f5551b          	sraiw	a0,a0,0x1f
    80004370:	7942                	ld	s2,48(sp)
    80004372:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004374:	60a6                	ld	ra,72(sp)
    80004376:	6406                	ld	s0,64(sp)
    80004378:	74e2                	ld	s1,56(sp)
    8000437a:	7a02                	ld	s4,32(sp)
    8000437c:	6161                	addi	sp,sp,80
    8000437e:	8082                	ret
  return -1;
    80004380:	557d                	li	a0,-1
    80004382:	bfcd                	j	80004374 <filestat+0x52>

0000000080004384 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004384:	7179                	addi	sp,sp,-48
    80004386:	f406                	sd	ra,40(sp)
    80004388:	f022                	sd	s0,32(sp)
    8000438a:	e84a                	sd	s2,16(sp)
    8000438c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000438e:	00854783          	lbu	a5,8(a0)
    80004392:	cfd1                	beqz	a5,8000442e <fileread+0xaa>
    80004394:	ec26                	sd	s1,24(sp)
    80004396:	e44e                	sd	s3,8(sp)
    80004398:	84aa                	mv	s1,a0
    8000439a:	892e                	mv	s2,a1
    8000439c:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    8000439e:	411c                	lw	a5,0(a0)
    800043a0:	4705                	li	a4,1
    800043a2:	04e78363          	beq	a5,a4,800043e8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043a6:	470d                	li	a4,3
    800043a8:	04e78763          	beq	a5,a4,800043f6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800043ac:	4709                	li	a4,2
    800043ae:	06e79a63          	bne	a5,a4,80004422 <fileread+0x9e>
    ilock(f->ip);
    800043b2:	6d08                	ld	a0,24(a0)
    800043b4:	87cff0ef          	jal	80003430 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800043b8:	874e                	mv	a4,s3
    800043ba:	5094                	lw	a3,32(s1)
    800043bc:	864a                	mv	a2,s2
    800043be:	4585                	li	a1,1
    800043c0:	6c88                	ld	a0,24(s1)
    800043c2:	c00ff0ef          	jal	800037c2 <readi>
    800043c6:	892a                	mv	s2,a0
    800043c8:	00a05563          	blez	a0,800043d2 <fileread+0x4e>
      f->off += r;
    800043cc:	509c                	lw	a5,32(s1)
    800043ce:	9fa9                	addw	a5,a5,a0
    800043d0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800043d2:	6c88                	ld	a0,24(s1)
    800043d4:	90aff0ef          	jal	800034de <iunlock>
    800043d8:	64e2                	ld	s1,24(sp)
    800043da:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800043dc:	854a                	mv	a0,s2
    800043de:	70a2                	ld	ra,40(sp)
    800043e0:	7402                	ld	s0,32(sp)
    800043e2:	6942                	ld	s2,16(sp)
    800043e4:	6145                	addi	sp,sp,48
    800043e6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800043e8:	6908                	ld	a0,16(a0)
    800043ea:	3b0000ef          	jal	8000479a <piperead>
    800043ee:	892a                	mv	s2,a0
    800043f0:	64e2                	ld	s1,24(sp)
    800043f2:	69a2                	ld	s3,8(sp)
    800043f4:	b7e5                	j	800043dc <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800043f6:	02451783          	lh	a5,36(a0)
    800043fa:	03079693          	slli	a3,a5,0x30
    800043fe:	92c1                	srli	a3,a3,0x30
    80004400:	4725                	li	a4,9
    80004402:	02d76963          	bltu	a4,a3,80004434 <fileread+0xb0>
    80004406:	0792                	slli	a5,a5,0x4
    80004408:	0001c717          	auipc	a4,0x1c
    8000440c:	62870713          	addi	a4,a4,1576 # 80020a30 <devsw>
    80004410:	97ba                	add	a5,a5,a4
    80004412:	639c                	ld	a5,0(a5)
    80004414:	c78d                	beqz	a5,8000443e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004416:	4505                	li	a0,1
    80004418:	9782                	jalr	a5
    8000441a:	892a                	mv	s2,a0
    8000441c:	64e2                	ld	s1,24(sp)
    8000441e:	69a2                	ld	s3,8(sp)
    80004420:	bf75                	j	800043dc <fileread+0x58>
    panic("fileread");
    80004422:	00003517          	auipc	a0,0x3
    80004426:	16e50513          	addi	a0,a0,366 # 80007590 <etext+0x590>
    8000442a:	bfafc0ef          	jal	80000824 <panic>
    return -1;
    8000442e:	57fd                	li	a5,-1
    80004430:	893e                	mv	s2,a5
    80004432:	b76d                	j	800043dc <fileread+0x58>
      return -1;
    80004434:	57fd                	li	a5,-1
    80004436:	893e                	mv	s2,a5
    80004438:	64e2                	ld	s1,24(sp)
    8000443a:	69a2                	ld	s3,8(sp)
    8000443c:	b745                	j	800043dc <fileread+0x58>
    8000443e:	57fd                	li	a5,-1
    80004440:	893e                	mv	s2,a5
    80004442:	64e2                	ld	s1,24(sp)
    80004444:	69a2                	ld	s3,8(sp)
    80004446:	bf59                	j	800043dc <fileread+0x58>

0000000080004448 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004448:	00954783          	lbu	a5,9(a0)
    8000444c:	10078f63          	beqz	a5,8000456a <filewrite+0x122>
{
    80004450:	711d                	addi	sp,sp,-96
    80004452:	ec86                	sd	ra,88(sp)
    80004454:	e8a2                	sd	s0,80(sp)
    80004456:	e0ca                	sd	s2,64(sp)
    80004458:	f456                	sd	s5,40(sp)
    8000445a:	f05a                	sd	s6,32(sp)
    8000445c:	1080                	addi	s0,sp,96
    8000445e:	892a                	mv	s2,a0
    80004460:	8b2e                	mv	s6,a1
    80004462:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004464:	411c                	lw	a5,0(a0)
    80004466:	4705                	li	a4,1
    80004468:	02e78a63          	beq	a5,a4,8000449c <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000446c:	470d                	li	a4,3
    8000446e:	02e78b63          	beq	a5,a4,800044a4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004472:	4709                	li	a4,2
    80004474:	0ce79f63          	bne	a5,a4,80004552 <filewrite+0x10a>
    80004478:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000447a:	0ac05a63          	blez	a2,8000452e <filewrite+0xe6>
    8000447e:	e4a6                	sd	s1,72(sp)
    80004480:	fc4e                	sd	s3,56(sp)
    80004482:	ec5e                	sd	s7,24(sp)
    80004484:	e862                	sd	s8,16(sp)
    80004486:	e466                	sd	s9,8(sp)
    int i = 0;
    80004488:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000448a:	6b85                	lui	s7,0x1
    8000448c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004490:	6785                	lui	a5,0x1
    80004492:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004496:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004498:	4c05                	li	s8,1
    8000449a:	a8ad                	j	80004514 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000449c:	6908                	ld	a0,16(a0)
    8000449e:	204000ef          	jal	800046a2 <pipewrite>
    800044a2:	a04d                	j	80004544 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800044a4:	02451783          	lh	a5,36(a0)
    800044a8:	03079693          	slli	a3,a5,0x30
    800044ac:	92c1                	srli	a3,a3,0x30
    800044ae:	4725                	li	a4,9
    800044b0:	0ad76f63          	bltu	a4,a3,8000456e <filewrite+0x126>
    800044b4:	0792                	slli	a5,a5,0x4
    800044b6:	0001c717          	auipc	a4,0x1c
    800044ba:	57a70713          	addi	a4,a4,1402 # 80020a30 <devsw>
    800044be:	97ba                	add	a5,a5,a4
    800044c0:	679c                	ld	a5,8(a5)
    800044c2:	cbc5                	beqz	a5,80004572 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800044c4:	4505                	li	a0,1
    800044c6:	9782                	jalr	a5
    800044c8:	a8b5                	j	80004544 <filewrite+0xfc>
      if(n1 > max)
    800044ca:	2981                	sext.w	s3,s3
      begin_op();
    800044cc:	971ff0ef          	jal	80003e3c <begin_op>
      ilock(f->ip);
    800044d0:	01893503          	ld	a0,24(s2)
    800044d4:	f5dfe0ef          	jal	80003430 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800044d8:	874e                	mv	a4,s3
    800044da:	02092683          	lw	a3,32(s2)
    800044de:	016a0633          	add	a2,s4,s6
    800044e2:	85e2                	mv	a1,s8
    800044e4:	01893503          	ld	a0,24(s2)
    800044e8:	bccff0ef          	jal	800038b4 <writei>
    800044ec:	84aa                	mv	s1,a0
    800044ee:	00a05763          	blez	a0,800044fc <filewrite+0xb4>
        f->off += r;
    800044f2:	02092783          	lw	a5,32(s2)
    800044f6:	9fa9                	addw	a5,a5,a0
    800044f8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800044fc:	01893503          	ld	a0,24(s2)
    80004500:	fdffe0ef          	jal	800034de <iunlock>
      end_op();
    80004504:	9a9ff0ef          	jal	80003eac <end_op>

      if(r != n1){
    80004508:	02999563          	bne	s3,s1,80004532 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000450c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004510:	015a5963          	bge	s4,s5,80004522 <filewrite+0xda>
      int n1 = n - i;
    80004514:	414a87bb          	subw	a5,s5,s4
    80004518:	89be                	mv	s3,a5
      if(n1 > max)
    8000451a:	fafbd8e3          	bge	s7,a5,800044ca <filewrite+0x82>
    8000451e:	89e6                	mv	s3,s9
    80004520:	b76d                	j	800044ca <filewrite+0x82>
    80004522:	64a6                	ld	s1,72(sp)
    80004524:	79e2                	ld	s3,56(sp)
    80004526:	6be2                	ld	s7,24(sp)
    80004528:	6c42                	ld	s8,16(sp)
    8000452a:	6ca2                	ld	s9,8(sp)
    8000452c:	a801                	j	8000453c <filewrite+0xf4>
    int i = 0;
    8000452e:	4a01                	li	s4,0
    80004530:	a031                	j	8000453c <filewrite+0xf4>
    80004532:	64a6                	ld	s1,72(sp)
    80004534:	79e2                	ld	s3,56(sp)
    80004536:	6be2                	ld	s7,24(sp)
    80004538:	6c42                	ld	s8,16(sp)
    8000453a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000453c:	034a9d63          	bne	s5,s4,80004576 <filewrite+0x12e>
    80004540:	8556                	mv	a0,s5
    80004542:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004544:	60e6                	ld	ra,88(sp)
    80004546:	6446                	ld	s0,80(sp)
    80004548:	6906                	ld	s2,64(sp)
    8000454a:	7aa2                	ld	s5,40(sp)
    8000454c:	7b02                	ld	s6,32(sp)
    8000454e:	6125                	addi	sp,sp,96
    80004550:	8082                	ret
    80004552:	e4a6                	sd	s1,72(sp)
    80004554:	fc4e                	sd	s3,56(sp)
    80004556:	f852                	sd	s4,48(sp)
    80004558:	ec5e                	sd	s7,24(sp)
    8000455a:	e862                	sd	s8,16(sp)
    8000455c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000455e:	00003517          	auipc	a0,0x3
    80004562:	04250513          	addi	a0,a0,66 # 800075a0 <etext+0x5a0>
    80004566:	abefc0ef          	jal	80000824 <panic>
    return -1;
    8000456a:	557d                	li	a0,-1
}
    8000456c:	8082                	ret
      return -1;
    8000456e:	557d                	li	a0,-1
    80004570:	bfd1                	j	80004544 <filewrite+0xfc>
    80004572:	557d                	li	a0,-1
    80004574:	bfc1                	j	80004544 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004576:	557d                	li	a0,-1
    80004578:	7a42                	ld	s4,48(sp)
    8000457a:	b7e9                	j	80004544 <filewrite+0xfc>

000000008000457c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000457c:	7179                	addi	sp,sp,-48
    8000457e:	f406                	sd	ra,40(sp)
    80004580:	f022                	sd	s0,32(sp)
    80004582:	ec26                	sd	s1,24(sp)
    80004584:	e052                	sd	s4,0(sp)
    80004586:	1800                	addi	s0,sp,48
    80004588:	84aa                	mv	s1,a0
    8000458a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000458c:	0005b023          	sd	zero,0(a1)
    80004590:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004594:	c29ff0ef          	jal	800041bc <filealloc>
    80004598:	e088                	sd	a0,0(s1)
    8000459a:	c549                	beqz	a0,80004624 <pipealloc+0xa8>
    8000459c:	c21ff0ef          	jal	800041bc <filealloc>
    800045a0:	00aa3023          	sd	a0,0(s4)
    800045a4:	cd25                	beqz	a0,8000461c <pipealloc+0xa0>
    800045a6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800045a8:	d9cfc0ef          	jal	80000b44 <kalloc>
    800045ac:	892a                	mv	s2,a0
    800045ae:	c12d                	beqz	a0,80004610 <pipealloc+0x94>
    800045b0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800045b2:	4985                	li	s3,1
    800045b4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800045b8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800045bc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800045c0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800045c4:	00003597          	auipc	a1,0x3
    800045c8:	fec58593          	addi	a1,a1,-20 # 800075b0 <etext+0x5b0>
    800045cc:	dd2fc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    800045d0:	609c                	ld	a5,0(s1)
    800045d2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800045d6:	609c                	ld	a5,0(s1)
    800045d8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800045dc:	609c                	ld	a5,0(s1)
    800045de:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800045e2:	609c                	ld	a5,0(s1)
    800045e4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800045e8:	000a3783          	ld	a5,0(s4)
    800045ec:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800045f0:	000a3783          	ld	a5,0(s4)
    800045f4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800045f8:	000a3783          	ld	a5,0(s4)
    800045fc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004600:	000a3783          	ld	a5,0(s4)
    80004604:	0127b823          	sd	s2,16(a5)
  return 0;
    80004608:	4501                	li	a0,0
    8000460a:	6942                	ld	s2,16(sp)
    8000460c:	69a2                	ld	s3,8(sp)
    8000460e:	a01d                	j	80004634 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004610:	6088                	ld	a0,0(s1)
    80004612:	c119                	beqz	a0,80004618 <pipealloc+0x9c>
    80004614:	6942                	ld	s2,16(sp)
    80004616:	a029                	j	80004620 <pipealloc+0xa4>
    80004618:	6942                	ld	s2,16(sp)
    8000461a:	a029                	j	80004624 <pipealloc+0xa8>
    8000461c:	6088                	ld	a0,0(s1)
    8000461e:	c10d                	beqz	a0,80004640 <pipealloc+0xc4>
    fileclose(*f0);
    80004620:	c41ff0ef          	jal	80004260 <fileclose>
  if(*f1)
    80004624:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004628:	557d                	li	a0,-1
  if(*f1)
    8000462a:	c789                	beqz	a5,80004634 <pipealloc+0xb8>
    fileclose(*f1);
    8000462c:	853e                	mv	a0,a5
    8000462e:	c33ff0ef          	jal	80004260 <fileclose>
  return -1;
    80004632:	557d                	li	a0,-1
}
    80004634:	70a2                	ld	ra,40(sp)
    80004636:	7402                	ld	s0,32(sp)
    80004638:	64e2                	ld	s1,24(sp)
    8000463a:	6a02                	ld	s4,0(sp)
    8000463c:	6145                	addi	sp,sp,48
    8000463e:	8082                	ret
  return -1;
    80004640:	557d                	li	a0,-1
    80004642:	bfcd                	j	80004634 <pipealloc+0xb8>

0000000080004644 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004644:	1101                	addi	sp,sp,-32
    80004646:	ec06                	sd	ra,24(sp)
    80004648:	e822                	sd	s0,16(sp)
    8000464a:	e426                	sd	s1,8(sp)
    8000464c:	e04a                	sd	s2,0(sp)
    8000464e:	1000                	addi	s0,sp,32
    80004650:	84aa                	mv	s1,a0
    80004652:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004654:	dd4fc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004658:	02090763          	beqz	s2,80004686 <pipeclose+0x42>
    pi->writeopen = 0;
    8000465c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004660:	21848513          	addi	a0,s1,536
    80004664:	abffd0ef          	jal	80002122 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004668:	2204a783          	lw	a5,544(s1)
    8000466c:	e781                	bnez	a5,80004674 <pipeclose+0x30>
    8000466e:	2244a783          	lw	a5,548(s1)
    80004672:	c38d                	beqz	a5,80004694 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004674:	8526                	mv	a0,s1
    80004676:	e46fc0ef          	jal	80000cbc <release>
}
    8000467a:	60e2                	ld	ra,24(sp)
    8000467c:	6442                	ld	s0,16(sp)
    8000467e:	64a2                	ld	s1,8(sp)
    80004680:	6902                	ld	s2,0(sp)
    80004682:	6105                	addi	sp,sp,32
    80004684:	8082                	ret
    pi->readopen = 0;
    80004686:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000468a:	21c48513          	addi	a0,s1,540
    8000468e:	a95fd0ef          	jal	80002122 <wakeup>
    80004692:	bfd9                	j	80004668 <pipeclose+0x24>
    release(&pi->lock);
    80004694:	8526                	mv	a0,s1
    80004696:	e26fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    8000469a:	8526                	mv	a0,s1
    8000469c:	bc0fc0ef          	jal	80000a5c <kfree>
    800046a0:	bfe9                	j	8000467a <pipeclose+0x36>

00000000800046a2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800046a2:	7159                	addi	sp,sp,-112
    800046a4:	f486                	sd	ra,104(sp)
    800046a6:	f0a2                	sd	s0,96(sp)
    800046a8:	eca6                	sd	s1,88(sp)
    800046aa:	e8ca                	sd	s2,80(sp)
    800046ac:	e4ce                	sd	s3,72(sp)
    800046ae:	e0d2                	sd	s4,64(sp)
    800046b0:	fc56                	sd	s5,56(sp)
    800046b2:	1880                	addi	s0,sp,112
    800046b4:	84aa                	mv	s1,a0
    800046b6:	8aae                	mv	s5,a1
    800046b8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800046ba:	b90fd0ef          	jal	80001a4a <myproc>
    800046be:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800046c0:	8526                	mv	a0,s1
    800046c2:	d66fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    800046c6:	0d405263          	blez	s4,8000478a <pipewrite+0xe8>
    800046ca:	f85a                	sd	s6,48(sp)
    800046cc:	f45e                	sd	s7,40(sp)
    800046ce:	f062                	sd	s8,32(sp)
    800046d0:	ec66                	sd	s9,24(sp)
    800046d2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800046d4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800046d6:	f9f40c13          	addi	s8,s0,-97
    800046da:	4b85                	li	s7,1
    800046dc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800046de:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800046e2:	21c48c93          	addi	s9,s1,540
    800046e6:	a82d                	j	80004720 <pipewrite+0x7e>
      release(&pi->lock);
    800046e8:	8526                	mv	a0,s1
    800046ea:	dd2fc0ef          	jal	80000cbc <release>
      return -1;
    800046ee:	597d                	li	s2,-1
    800046f0:	7b42                	ld	s6,48(sp)
    800046f2:	7ba2                	ld	s7,40(sp)
    800046f4:	7c02                	ld	s8,32(sp)
    800046f6:	6ce2                	ld	s9,24(sp)
    800046f8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800046fa:	854a                	mv	a0,s2
    800046fc:	70a6                	ld	ra,104(sp)
    800046fe:	7406                	ld	s0,96(sp)
    80004700:	64e6                	ld	s1,88(sp)
    80004702:	6946                	ld	s2,80(sp)
    80004704:	69a6                	ld	s3,72(sp)
    80004706:	6a06                	ld	s4,64(sp)
    80004708:	7ae2                	ld	s5,56(sp)
    8000470a:	6165                	addi	sp,sp,112
    8000470c:	8082                	ret
      wakeup(&pi->nread);
    8000470e:	856a                	mv	a0,s10
    80004710:	a13fd0ef          	jal	80002122 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004714:	85a6                	mv	a1,s1
    80004716:	8566                	mv	a0,s9
    80004718:	9bffd0ef          	jal	800020d6 <sleep>
  while(i < n){
    8000471c:	05495a63          	bge	s2,s4,80004770 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004720:	2204a783          	lw	a5,544(s1)
    80004724:	d3f1                	beqz	a5,800046e8 <pipewrite+0x46>
    80004726:	854e                	mv	a0,s3
    80004728:	c13fd0ef          	jal	8000233a <killed>
    8000472c:	fd55                	bnez	a0,800046e8 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000472e:	2184a783          	lw	a5,536(s1)
    80004732:	21c4a703          	lw	a4,540(s1)
    80004736:	2007879b          	addiw	a5,a5,512
    8000473a:	fcf70ae3          	beq	a4,a5,8000470e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000473e:	86de                	mv	a3,s7
    80004740:	01590633          	add	a2,s2,s5
    80004744:	85e2                	mv	a1,s8
    80004746:	0509b503          	ld	a0,80(s3)
    8000474a:	fc9fc0ef          	jal	80001712 <copyin>
    8000474e:	05650063          	beq	a0,s6,8000478e <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004752:	21c4a783          	lw	a5,540(s1)
    80004756:	0017871b          	addiw	a4,a5,1
    8000475a:	20e4ae23          	sw	a4,540(s1)
    8000475e:	1ff7f793          	andi	a5,a5,511
    80004762:	97a6                	add	a5,a5,s1
    80004764:	f9f44703          	lbu	a4,-97(s0)
    80004768:	00e78c23          	sb	a4,24(a5)
      i++;
    8000476c:	2905                	addiw	s2,s2,1
    8000476e:	b77d                	j	8000471c <pipewrite+0x7a>
    80004770:	7b42                	ld	s6,48(sp)
    80004772:	7ba2                	ld	s7,40(sp)
    80004774:	7c02                	ld	s8,32(sp)
    80004776:	6ce2                	ld	s9,24(sp)
    80004778:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000477a:	21848513          	addi	a0,s1,536
    8000477e:	9a5fd0ef          	jal	80002122 <wakeup>
  release(&pi->lock);
    80004782:	8526                	mv	a0,s1
    80004784:	d38fc0ef          	jal	80000cbc <release>
  return i;
    80004788:	bf8d                	j	800046fa <pipewrite+0x58>
  int i = 0;
    8000478a:	4901                	li	s2,0
    8000478c:	b7fd                	j	8000477a <pipewrite+0xd8>
    8000478e:	7b42                	ld	s6,48(sp)
    80004790:	7ba2                	ld	s7,40(sp)
    80004792:	7c02                	ld	s8,32(sp)
    80004794:	6ce2                	ld	s9,24(sp)
    80004796:	6d42                	ld	s10,16(sp)
    80004798:	b7cd                	j	8000477a <pipewrite+0xd8>

000000008000479a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000479a:	711d                	addi	sp,sp,-96
    8000479c:	ec86                	sd	ra,88(sp)
    8000479e:	e8a2                	sd	s0,80(sp)
    800047a0:	e4a6                	sd	s1,72(sp)
    800047a2:	e0ca                	sd	s2,64(sp)
    800047a4:	fc4e                	sd	s3,56(sp)
    800047a6:	f852                	sd	s4,48(sp)
    800047a8:	f456                	sd	s5,40(sp)
    800047aa:	1080                	addi	s0,sp,96
    800047ac:	84aa                	mv	s1,a0
    800047ae:	892e                	mv	s2,a1
    800047b0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800047b2:	a98fd0ef          	jal	80001a4a <myproc>
    800047b6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800047b8:	8526                	mv	a0,s1
    800047ba:	c6efc0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047be:	2184a703          	lw	a4,536(s1)
    800047c2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047c6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047ca:	02f71763          	bne	a4,a5,800047f8 <piperead+0x5e>
    800047ce:	2244a783          	lw	a5,548(s1)
    800047d2:	cf85                	beqz	a5,8000480a <piperead+0x70>
    if(killed(pr)){
    800047d4:	8552                	mv	a0,s4
    800047d6:	b65fd0ef          	jal	8000233a <killed>
    800047da:	e11d                	bnez	a0,80004800 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047dc:	85a6                	mv	a1,s1
    800047de:	854e                	mv	a0,s3
    800047e0:	8f7fd0ef          	jal	800020d6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047e4:	2184a703          	lw	a4,536(s1)
    800047e8:	21c4a783          	lw	a5,540(s1)
    800047ec:	fef701e3          	beq	a4,a5,800047ce <piperead+0x34>
    800047f0:	f05a                	sd	s6,32(sp)
    800047f2:	ec5e                	sd	s7,24(sp)
    800047f4:	e862                	sd	s8,16(sp)
    800047f6:	a829                	j	80004810 <piperead+0x76>
    800047f8:	f05a                	sd	s6,32(sp)
    800047fa:	ec5e                	sd	s7,24(sp)
    800047fc:	e862                	sd	s8,16(sp)
    800047fe:	a809                	j	80004810 <piperead+0x76>
      release(&pi->lock);
    80004800:	8526                	mv	a0,s1
    80004802:	cbafc0ef          	jal	80000cbc <release>
      return -1;
    80004806:	59fd                	li	s3,-1
    80004808:	a0a5                	j	80004870 <piperead+0xd6>
    8000480a:	f05a                	sd	s6,32(sp)
    8000480c:	ec5e                	sd	s7,24(sp)
    8000480e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004810:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004812:	faf40c13          	addi	s8,s0,-81
    80004816:	4b85                	li	s7,1
    80004818:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000481a:	05505163          	blez	s5,8000485c <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000481e:	2184a783          	lw	a5,536(s1)
    80004822:	21c4a703          	lw	a4,540(s1)
    80004826:	02f70b63          	beq	a4,a5,8000485c <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    8000482a:	1ff7f793          	andi	a5,a5,511
    8000482e:	97a6                	add	a5,a5,s1
    80004830:	0187c783          	lbu	a5,24(a5)
    80004834:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004838:	86de                	mv	a3,s7
    8000483a:	8662                	mv	a2,s8
    8000483c:	85ca                	mv	a1,s2
    8000483e:	050a3503          	ld	a0,80(s4)
    80004842:	e13fc0ef          	jal	80001654 <copyout>
    80004846:	03650f63          	beq	a0,s6,80004884 <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000484a:	2184a783          	lw	a5,536(s1)
    8000484e:	2785                	addiw	a5,a5,1
    80004850:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004854:	2985                	addiw	s3,s3,1
    80004856:	0905                	addi	s2,s2,1
    80004858:	fd3a93e3          	bne	s5,s3,8000481e <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000485c:	21c48513          	addi	a0,s1,540
    80004860:	8c3fd0ef          	jal	80002122 <wakeup>
  release(&pi->lock);
    80004864:	8526                	mv	a0,s1
    80004866:	c56fc0ef          	jal	80000cbc <release>
    8000486a:	7b02                	ld	s6,32(sp)
    8000486c:	6be2                	ld	s7,24(sp)
    8000486e:	6c42                	ld	s8,16(sp)
  return i;
}
    80004870:	854e                	mv	a0,s3
    80004872:	60e6                	ld	ra,88(sp)
    80004874:	6446                	ld	s0,80(sp)
    80004876:	64a6                	ld	s1,72(sp)
    80004878:	6906                	ld	s2,64(sp)
    8000487a:	79e2                	ld	s3,56(sp)
    8000487c:	7a42                	ld	s4,48(sp)
    8000487e:	7aa2                	ld	s5,40(sp)
    80004880:	6125                	addi	sp,sp,96
    80004882:	8082                	ret
      if(i == 0)
    80004884:	fc099ce3          	bnez	s3,8000485c <piperead+0xc2>
        i = -1;
    80004888:	89aa                	mv	s3,a0
    8000488a:	bfc9                	j	8000485c <piperead+0xc2>

000000008000488c <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    8000488c:	1141                	addi	sp,sp,-16
    8000488e:	e406                	sd	ra,8(sp)
    80004890:	e022                	sd	s0,0(sp)
    80004892:	0800                	addi	s0,sp,16
    80004894:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004896:	0035151b          	slliw	a0,a0,0x3
    8000489a:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000489c:	8b89                	andi	a5,a5,2
    8000489e:	c399                	beqz	a5,800048a4 <flags2perm+0x18>
      perm |= PTE_W;
    800048a0:	00456513          	ori	a0,a0,4
    return perm;
}
    800048a4:	60a2                	ld	ra,8(sp)
    800048a6:	6402                	ld	s0,0(sp)
    800048a8:	0141                	addi	sp,sp,16
    800048aa:	8082                	ret

00000000800048ac <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800048ac:	de010113          	addi	sp,sp,-544
    800048b0:	20113c23          	sd	ra,536(sp)
    800048b4:	20813823          	sd	s0,528(sp)
    800048b8:	20913423          	sd	s1,520(sp)
    800048bc:	21213023          	sd	s2,512(sp)
    800048c0:	1400                	addi	s0,sp,544
    800048c2:	892a                	mv	s2,a0
    800048c4:	dea43823          	sd	a0,-528(s0)
    800048c8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800048cc:	97efd0ef          	jal	80001a4a <myproc>
    800048d0:	84aa                	mv	s1,a0

  begin_op();
    800048d2:	d6aff0ef          	jal	80003e3c <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800048d6:	854a                	mv	a0,s2
    800048d8:	b86ff0ef          	jal	80003c5e <namei>
    800048dc:	cd21                	beqz	a0,80004934 <kexec+0x88>
    800048de:	fbd2                	sd	s4,496(sp)
    800048e0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800048e2:	b4ffe0ef          	jal	80003430 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800048e6:	04000713          	li	a4,64
    800048ea:	4681                	li	a3,0
    800048ec:	e5040613          	addi	a2,s0,-432
    800048f0:	4581                	li	a1,0
    800048f2:	8552                	mv	a0,s4
    800048f4:	ecffe0ef          	jal	800037c2 <readi>
    800048f8:	04000793          	li	a5,64
    800048fc:	00f51a63          	bne	a0,a5,80004910 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004900:	e5042703          	lw	a4,-432(s0)
    80004904:	464c47b7          	lui	a5,0x464c4
    80004908:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000490c:	02f70863          	beq	a4,a5,8000493c <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004910:	8552                	mv	a0,s4
    80004912:	d2bfe0ef          	jal	8000363c <iunlockput>
    end_op();
    80004916:	d96ff0ef          	jal	80003eac <end_op>
  }
  return -1;
    8000491a:	557d                	li	a0,-1
    8000491c:	7a5e                	ld	s4,496(sp)
}
    8000491e:	21813083          	ld	ra,536(sp)
    80004922:	21013403          	ld	s0,528(sp)
    80004926:	20813483          	ld	s1,520(sp)
    8000492a:	20013903          	ld	s2,512(sp)
    8000492e:	22010113          	addi	sp,sp,544
    80004932:	8082                	ret
    end_op();
    80004934:	d78ff0ef          	jal	80003eac <end_op>
    return -1;
    80004938:	557d                	li	a0,-1
    8000493a:	b7d5                	j	8000491e <kexec+0x72>
    8000493c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000493e:	8526                	mv	a0,s1
    80004940:	a14fd0ef          	jal	80001b54 <proc_pagetable>
    80004944:	8b2a                	mv	s6,a0
    80004946:	26050f63          	beqz	a0,80004bc4 <kexec+0x318>
    8000494a:	ffce                	sd	s3,504(sp)
    8000494c:	f7d6                	sd	s5,488(sp)
    8000494e:	efde                	sd	s7,472(sp)
    80004950:	ebe2                	sd	s8,464(sp)
    80004952:	e7e6                	sd	s9,456(sp)
    80004954:	e3ea                	sd	s10,448(sp)
    80004956:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004958:	e8845783          	lhu	a5,-376(s0)
    8000495c:	0e078963          	beqz	a5,80004a4e <kexec+0x1a2>
    80004960:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004964:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004966:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004968:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000496c:	6c85                	lui	s9,0x1
    8000496e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004972:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004976:	6a85                	lui	s5,0x1
    80004978:	a085                	j	800049d8 <kexec+0x12c>
      panic("loadseg: address should exist");
    8000497a:	00003517          	auipc	a0,0x3
    8000497e:	c3e50513          	addi	a0,a0,-962 # 800075b8 <etext+0x5b8>
    80004982:	ea3fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    80004986:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004988:	874a                	mv	a4,s2
    8000498a:	009b86bb          	addw	a3,s7,s1
    8000498e:	4581                	li	a1,0
    80004990:	8552                	mv	a0,s4
    80004992:	e31fe0ef          	jal	800037c2 <readi>
    80004996:	22a91b63          	bne	s2,a0,80004bcc <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    8000499a:	009a84bb          	addw	s1,s5,s1
    8000499e:	0334f263          	bgeu	s1,s3,800049c2 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800049a2:	02049593          	slli	a1,s1,0x20
    800049a6:	9181                	srli	a1,a1,0x20
    800049a8:	95e2                	add	a1,a1,s8
    800049aa:	855a                	mv	a0,s6
    800049ac:	e7afc0ef          	jal	80001026 <walkaddr>
    800049b0:	862a                	mv	a2,a0
    if(pa == 0)
    800049b2:	d561                	beqz	a0,8000497a <kexec+0xce>
    if(sz - i < PGSIZE)
    800049b4:	409987bb          	subw	a5,s3,s1
    800049b8:	893e                	mv	s2,a5
    800049ba:	fcfcf6e3          	bgeu	s9,a5,80004986 <kexec+0xda>
    800049be:	8956                	mv	s2,s5
    800049c0:	b7d9                	j	80004986 <kexec+0xda>
    sz = sz1;
    800049c2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049c6:	2d05                	addiw	s10,s10,1
    800049c8:	e0843783          	ld	a5,-504(s0)
    800049cc:	0387869b          	addiw	a3,a5,56
    800049d0:	e8845783          	lhu	a5,-376(s0)
    800049d4:	06fd5e63          	bge	s10,a5,80004a50 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800049d8:	e0d43423          	sd	a3,-504(s0)
    800049dc:	876e                	mv	a4,s11
    800049de:	e1840613          	addi	a2,s0,-488
    800049e2:	4581                	li	a1,0
    800049e4:	8552                	mv	a0,s4
    800049e6:	dddfe0ef          	jal	800037c2 <readi>
    800049ea:	1db51f63          	bne	a0,s11,80004bc8 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    800049ee:	e1842783          	lw	a5,-488(s0)
    800049f2:	4705                	li	a4,1
    800049f4:	fce799e3          	bne	a5,a4,800049c6 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    800049f8:	e4043483          	ld	s1,-448(s0)
    800049fc:	e3843783          	ld	a5,-456(s0)
    80004a00:	1ef4e463          	bltu	s1,a5,80004be8 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004a04:	e2843783          	ld	a5,-472(s0)
    80004a08:	94be                	add	s1,s1,a5
    80004a0a:	1ef4e263          	bltu	s1,a5,80004bee <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80004a0e:	de843703          	ld	a4,-536(s0)
    80004a12:	8ff9                	and	a5,a5,a4
    80004a14:	1e079063          	bnez	a5,80004bf4 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004a18:	e1c42503          	lw	a0,-484(s0)
    80004a1c:	e71ff0ef          	jal	8000488c <flags2perm>
    80004a20:	86aa                	mv	a3,a0
    80004a22:	8626                	mv	a2,s1
    80004a24:	85ca                	mv	a1,s2
    80004a26:	855a                	mv	a0,s6
    80004a28:	8d5fc0ef          	jal	800012fc <uvmalloc>
    80004a2c:	dea43c23          	sd	a0,-520(s0)
    80004a30:	1c050563          	beqz	a0,80004bfa <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004a34:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004a38:	00098863          	beqz	s3,80004a48 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004a3c:	e2843c03          	ld	s8,-472(s0)
    80004a40:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004a44:	4481                	li	s1,0
    80004a46:	bfb1                	j	800049a2 <kexec+0xf6>
    sz = sz1;
    80004a48:	df843903          	ld	s2,-520(s0)
    80004a4c:	bfad                	j	800049c6 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a4e:	4901                	li	s2,0
  iunlockput(ip);
    80004a50:	8552                	mv	a0,s4
    80004a52:	bebfe0ef          	jal	8000363c <iunlockput>
  end_op();
    80004a56:	c56ff0ef          	jal	80003eac <end_op>
  p = myproc();
    80004a5a:	ff1fc0ef          	jal	80001a4a <myproc>
    80004a5e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004a60:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004a64:	6985                	lui	s3,0x1
    80004a66:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004a68:	99ca                	add	s3,s3,s2
    80004a6a:	77fd                	lui	a5,0xfffff
    80004a6c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004a70:	4691                	li	a3,4
    80004a72:	6609                	lui	a2,0x2
    80004a74:	964e                	add	a2,a2,s3
    80004a76:	85ce                	mv	a1,s3
    80004a78:	855a                	mv	a0,s6
    80004a7a:	883fc0ef          	jal	800012fc <uvmalloc>
    80004a7e:	8a2a                	mv	s4,a0
    80004a80:	e105                	bnez	a0,80004aa0 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80004a82:	85ce                	mv	a1,s3
    80004a84:	855a                	mv	a0,s6
    80004a86:	952fd0ef          	jal	80001bd8 <proc_freepagetable>
  return -1;
    80004a8a:	557d                	li	a0,-1
    80004a8c:	79fe                	ld	s3,504(sp)
    80004a8e:	7a5e                	ld	s4,496(sp)
    80004a90:	7abe                	ld	s5,488(sp)
    80004a92:	7b1e                	ld	s6,480(sp)
    80004a94:	6bfe                	ld	s7,472(sp)
    80004a96:	6c5e                	ld	s8,464(sp)
    80004a98:	6cbe                	ld	s9,456(sp)
    80004a9a:	6d1e                	ld	s10,448(sp)
    80004a9c:	7dfa                	ld	s11,440(sp)
    80004a9e:	b541                	j	8000491e <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004aa0:	75f9                	lui	a1,0xffffe
    80004aa2:	95aa                	add	a1,a1,a0
    80004aa4:	855a                	mv	a0,s6
    80004aa6:	a29fc0ef          	jal	800014ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004aaa:	800a0b93          	addi	s7,s4,-2048
    80004aae:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80004ab2:	e0043783          	ld	a5,-512(s0)
    80004ab6:	6388                	ld	a0,0(a5)
  sp = sz;
    80004ab8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004aba:	4481                	li	s1,0
    ustack[argc] = sp;
    80004abc:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004ac0:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004ac4:	cd21                	beqz	a0,80004b1c <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80004ac6:	bbcfc0ef          	jal	80000e82 <strlen>
    80004aca:	0015079b          	addiw	a5,a0,1
    80004ace:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ad2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004ad6:	13796563          	bltu	s2,s7,80004c00 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ada:	e0043d83          	ld	s11,-512(s0)
    80004ade:	000db983          	ld	s3,0(s11)
    80004ae2:	854e                	mv	a0,s3
    80004ae4:	b9efc0ef          	jal	80000e82 <strlen>
    80004ae8:	0015069b          	addiw	a3,a0,1
    80004aec:	864e                	mv	a2,s3
    80004aee:	85ca                	mv	a1,s2
    80004af0:	855a                	mv	a0,s6
    80004af2:	b63fc0ef          	jal	80001654 <copyout>
    80004af6:	10054763          	bltz	a0,80004c04 <kexec+0x358>
    ustack[argc] = sp;
    80004afa:	00349793          	slli	a5,s1,0x3
    80004afe:	97e6                	add	a5,a5,s9
    80004b00:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdd438>
  for(argc = 0; argv[argc]; argc++) {
    80004b04:	0485                	addi	s1,s1,1
    80004b06:	008d8793          	addi	a5,s11,8
    80004b0a:	e0f43023          	sd	a5,-512(s0)
    80004b0e:	008db503          	ld	a0,8(s11)
    80004b12:	c509                	beqz	a0,80004b1c <kexec+0x270>
    if(argc >= MAXARG)
    80004b14:	fb8499e3          	bne	s1,s8,80004ac6 <kexec+0x21a>
  sz = sz1;
    80004b18:	89d2                	mv	s3,s4
    80004b1a:	b7a5                	j	80004a82 <kexec+0x1d6>
  ustack[argc] = 0;
    80004b1c:	00349793          	slli	a5,s1,0x3
    80004b20:	f9078793          	addi	a5,a5,-112
    80004b24:	97a2                	add	a5,a5,s0
    80004b26:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004b2a:	00349693          	slli	a3,s1,0x3
    80004b2e:	06a1                	addi	a3,a3,8
    80004b30:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004b34:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004b38:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004b3a:	f57964e3          	bltu	s2,s7,80004a82 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004b3e:	e9040613          	addi	a2,s0,-368
    80004b42:	85ca                	mv	a1,s2
    80004b44:	855a                	mv	a0,s6
    80004b46:	b0ffc0ef          	jal	80001654 <copyout>
    80004b4a:	f2054ce3          	bltz	a0,80004a82 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004b4e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004b52:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004b56:	df043783          	ld	a5,-528(s0)
    80004b5a:	0007c703          	lbu	a4,0(a5)
    80004b5e:	cf11                	beqz	a4,80004b7a <kexec+0x2ce>
    80004b60:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004b62:	02f00693          	li	a3,47
    80004b66:	a029                	j	80004b70 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004b68:	0785                	addi	a5,a5,1
    80004b6a:	fff7c703          	lbu	a4,-1(a5)
    80004b6e:	c711                	beqz	a4,80004b7a <kexec+0x2ce>
    if(*s == '/')
    80004b70:	fed71ce3          	bne	a4,a3,80004b68 <kexec+0x2bc>
      last = s+1;
    80004b74:	def43823          	sd	a5,-528(s0)
    80004b78:	bfc5                	j	80004b68 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b7a:	4641                	li	a2,16
    80004b7c:	df043583          	ld	a1,-528(s0)
    80004b80:	158a8513          	addi	a0,s5,344
    80004b84:	ac8fc0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80004b88:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004b8c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004b90:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004b94:	058ab783          	ld	a5,88(s5)
    80004b98:	e6843703          	ld	a4,-408(s0)
    80004b9c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004b9e:	058ab783          	ld	a5,88(s5)
    80004ba2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ba6:	85ea                	mv	a1,s10
    80004ba8:	830fd0ef          	jal	80001bd8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004bac:	0004851b          	sext.w	a0,s1
    80004bb0:	79fe                	ld	s3,504(sp)
    80004bb2:	7a5e                	ld	s4,496(sp)
    80004bb4:	7abe                	ld	s5,488(sp)
    80004bb6:	7b1e                	ld	s6,480(sp)
    80004bb8:	6bfe                	ld	s7,472(sp)
    80004bba:	6c5e                	ld	s8,464(sp)
    80004bbc:	6cbe                	ld	s9,456(sp)
    80004bbe:	6d1e                	ld	s10,448(sp)
    80004bc0:	7dfa                	ld	s11,440(sp)
    80004bc2:	bbb1                	j	8000491e <kexec+0x72>
    80004bc4:	7b1e                	ld	s6,480(sp)
    80004bc6:	b3a9                	j	80004910 <kexec+0x64>
    80004bc8:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004bcc:	df843583          	ld	a1,-520(s0)
    80004bd0:	855a                	mv	a0,s6
    80004bd2:	806fd0ef          	jal	80001bd8 <proc_freepagetable>
  if(ip){
    80004bd6:	79fe                	ld	s3,504(sp)
    80004bd8:	7abe                	ld	s5,488(sp)
    80004bda:	7b1e                	ld	s6,480(sp)
    80004bdc:	6bfe                	ld	s7,472(sp)
    80004bde:	6c5e                	ld	s8,464(sp)
    80004be0:	6cbe                	ld	s9,456(sp)
    80004be2:	6d1e                	ld	s10,448(sp)
    80004be4:	7dfa                	ld	s11,440(sp)
    80004be6:	b32d                	j	80004910 <kexec+0x64>
    80004be8:	df243c23          	sd	s2,-520(s0)
    80004bec:	b7c5                	j	80004bcc <kexec+0x320>
    80004bee:	df243c23          	sd	s2,-520(s0)
    80004bf2:	bfe9                	j	80004bcc <kexec+0x320>
    80004bf4:	df243c23          	sd	s2,-520(s0)
    80004bf8:	bfd1                	j	80004bcc <kexec+0x320>
    80004bfa:	df243c23          	sd	s2,-520(s0)
    80004bfe:	b7f9                	j	80004bcc <kexec+0x320>
  sz = sz1;
    80004c00:	89d2                	mv	s3,s4
    80004c02:	b541                	j	80004a82 <kexec+0x1d6>
    80004c04:	89d2                	mv	s3,s4
    80004c06:	bdb5                	j	80004a82 <kexec+0x1d6>

0000000080004c08 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c08:	7179                	addi	sp,sp,-48
    80004c0a:	f406                	sd	ra,40(sp)
    80004c0c:	f022                	sd	s0,32(sp)
    80004c0e:	ec26                	sd	s1,24(sp)
    80004c10:	e84a                	sd	s2,16(sp)
    80004c12:	1800                	addi	s0,sp,48
    80004c14:	892e                	mv	s2,a1
    80004c16:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004c18:	fdc40593          	addi	a1,s0,-36
    80004c1c:	e29fd0ef          	jal	80002a44 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004c20:	fdc42703          	lw	a4,-36(s0)
    80004c24:	47bd                	li	a5,15
    80004c26:	02e7ea63          	bltu	a5,a4,80004c5a <argfd+0x52>
    80004c2a:	e21fc0ef          	jal	80001a4a <myproc>
    80004c2e:	fdc42703          	lw	a4,-36(s0)
    80004c32:	00371793          	slli	a5,a4,0x3
    80004c36:	0d078793          	addi	a5,a5,208
    80004c3a:	953e                	add	a0,a0,a5
    80004c3c:	611c                	ld	a5,0(a0)
    80004c3e:	c385                	beqz	a5,80004c5e <argfd+0x56>
    return -1;
  if(pfd)
    80004c40:	00090463          	beqz	s2,80004c48 <argfd+0x40>
    *pfd = fd;
    80004c44:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c48:	4501                	li	a0,0
  if(pf)
    80004c4a:	c091                	beqz	s1,80004c4e <argfd+0x46>
    *pf = f;
    80004c4c:	e09c                	sd	a5,0(s1)
}
    80004c4e:	70a2                	ld	ra,40(sp)
    80004c50:	7402                	ld	s0,32(sp)
    80004c52:	64e2                	ld	s1,24(sp)
    80004c54:	6942                	ld	s2,16(sp)
    80004c56:	6145                	addi	sp,sp,48
    80004c58:	8082                	ret
    return -1;
    80004c5a:	557d                	li	a0,-1
    80004c5c:	bfcd                	j	80004c4e <argfd+0x46>
    80004c5e:	557d                	li	a0,-1
    80004c60:	b7fd                	j	80004c4e <argfd+0x46>

0000000080004c62 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c62:	1101                	addi	sp,sp,-32
    80004c64:	ec06                	sd	ra,24(sp)
    80004c66:	e822                	sd	s0,16(sp)
    80004c68:	e426                	sd	s1,8(sp)
    80004c6a:	1000                	addi	s0,sp,32
    80004c6c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c6e:	dddfc0ef          	jal	80001a4a <myproc>
    80004c72:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004c74:	0d050793          	addi	a5,a0,208
    80004c78:	4501                	li	a0,0
    80004c7a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004c7c:	6398                	ld	a4,0(a5)
    80004c7e:	cb19                	beqz	a4,80004c94 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004c80:	2505                	addiw	a0,a0,1
    80004c82:	07a1                	addi	a5,a5,8
    80004c84:	fed51ce3          	bne	a0,a3,80004c7c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c88:	557d                	li	a0,-1
}
    80004c8a:	60e2                	ld	ra,24(sp)
    80004c8c:	6442                	ld	s0,16(sp)
    80004c8e:	64a2                	ld	s1,8(sp)
    80004c90:	6105                	addi	sp,sp,32
    80004c92:	8082                	ret
      p->ofile[fd] = f;
    80004c94:	00351793          	slli	a5,a0,0x3
    80004c98:	0d078793          	addi	a5,a5,208
    80004c9c:	963e                	add	a2,a2,a5
    80004c9e:	e204                	sd	s1,0(a2)
      return fd;
    80004ca0:	b7ed                	j	80004c8a <fdalloc+0x28>

0000000080004ca2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004ca2:	715d                	addi	sp,sp,-80
    80004ca4:	e486                	sd	ra,72(sp)
    80004ca6:	e0a2                	sd	s0,64(sp)
    80004ca8:	fc26                	sd	s1,56(sp)
    80004caa:	f84a                	sd	s2,48(sp)
    80004cac:	f44e                	sd	s3,40(sp)
    80004cae:	f052                	sd	s4,32(sp)
    80004cb0:	ec56                	sd	s5,24(sp)
    80004cb2:	e85a                	sd	s6,16(sp)
    80004cb4:	0880                	addi	s0,sp,80
    80004cb6:	892e                	mv	s2,a1
    80004cb8:	8a2e                	mv	s4,a1
    80004cba:	8ab2                	mv	s5,a2
    80004cbc:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004cbe:	fb040593          	addi	a1,s0,-80
    80004cc2:	fb7fe0ef          	jal	80003c78 <nameiparent>
    80004cc6:	84aa                	mv	s1,a0
    80004cc8:	10050763          	beqz	a0,80004dd6 <create+0x134>
    return 0;

  ilock(dp);
    80004ccc:	f64fe0ef          	jal	80003430 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004cd0:	4601                	li	a2,0
    80004cd2:	fb040593          	addi	a1,s0,-80
    80004cd6:	8526                	mv	a0,s1
    80004cd8:	cf3fe0ef          	jal	800039ca <dirlookup>
    80004cdc:	89aa                	mv	s3,a0
    80004cde:	c131                	beqz	a0,80004d22 <create+0x80>
    iunlockput(dp);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	95bfe0ef          	jal	8000363c <iunlockput>
    ilock(ip);
    80004ce6:	854e                	mv	a0,s3
    80004ce8:	f48fe0ef          	jal	80003430 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004cec:	4789                	li	a5,2
    80004cee:	02f91563          	bne	s2,a5,80004d18 <create+0x76>
    80004cf2:	0449d783          	lhu	a5,68(s3)
    80004cf6:	37f9                	addiw	a5,a5,-2
    80004cf8:	17c2                	slli	a5,a5,0x30
    80004cfa:	93c1                	srli	a5,a5,0x30
    80004cfc:	4705                	li	a4,1
    80004cfe:	00f76d63          	bltu	a4,a5,80004d18 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004d02:	854e                	mv	a0,s3
    80004d04:	60a6                	ld	ra,72(sp)
    80004d06:	6406                	ld	s0,64(sp)
    80004d08:	74e2                	ld	s1,56(sp)
    80004d0a:	7942                	ld	s2,48(sp)
    80004d0c:	79a2                	ld	s3,40(sp)
    80004d0e:	7a02                	ld	s4,32(sp)
    80004d10:	6ae2                	ld	s5,24(sp)
    80004d12:	6b42                	ld	s6,16(sp)
    80004d14:	6161                	addi	sp,sp,80
    80004d16:	8082                	ret
    iunlockput(ip);
    80004d18:	854e                	mv	a0,s3
    80004d1a:	923fe0ef          	jal	8000363c <iunlockput>
    return 0;
    80004d1e:	4981                	li	s3,0
    80004d20:	b7cd                	j	80004d02 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004d22:	85ca                	mv	a1,s2
    80004d24:	4088                	lw	a0,0(s1)
    80004d26:	d9afe0ef          	jal	800032c0 <ialloc>
    80004d2a:	892a                	mv	s2,a0
    80004d2c:	cd15                	beqz	a0,80004d68 <create+0xc6>
  ilock(ip);
    80004d2e:	f02fe0ef          	jal	80003430 <ilock>
  ip->major = major;
    80004d32:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004d36:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004d3a:	4785                	li	a5,1
    80004d3c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d40:	854a                	mv	a0,s2
    80004d42:	e3afe0ef          	jal	8000337c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d46:	4705                	li	a4,1
    80004d48:	02ea0463          	beq	s4,a4,80004d70 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d4c:	00492603          	lw	a2,4(s2)
    80004d50:	fb040593          	addi	a1,s0,-80
    80004d54:	8526                	mv	a0,s1
    80004d56:	e5ffe0ef          	jal	80003bb4 <dirlink>
    80004d5a:	06054263          	bltz	a0,80004dbe <create+0x11c>
  iunlockput(dp);
    80004d5e:	8526                	mv	a0,s1
    80004d60:	8ddfe0ef          	jal	8000363c <iunlockput>
  return ip;
    80004d64:	89ca                	mv	s3,s2
    80004d66:	bf71                	j	80004d02 <create+0x60>
    iunlockput(dp);
    80004d68:	8526                	mv	a0,s1
    80004d6a:	8d3fe0ef          	jal	8000363c <iunlockput>
    return 0;
    80004d6e:	bf51                	j	80004d02 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d70:	00492603          	lw	a2,4(s2)
    80004d74:	00003597          	auipc	a1,0x3
    80004d78:	86458593          	addi	a1,a1,-1948 # 800075d8 <etext+0x5d8>
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	e37fe0ef          	jal	80003bb4 <dirlink>
    80004d82:	02054e63          	bltz	a0,80004dbe <create+0x11c>
    80004d86:	40d0                	lw	a2,4(s1)
    80004d88:	00003597          	auipc	a1,0x3
    80004d8c:	85858593          	addi	a1,a1,-1960 # 800075e0 <etext+0x5e0>
    80004d90:	854a                	mv	a0,s2
    80004d92:	e23fe0ef          	jal	80003bb4 <dirlink>
    80004d96:	02054463          	bltz	a0,80004dbe <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d9a:	00492603          	lw	a2,4(s2)
    80004d9e:	fb040593          	addi	a1,s0,-80
    80004da2:	8526                	mv	a0,s1
    80004da4:	e11fe0ef          	jal	80003bb4 <dirlink>
    80004da8:	00054b63          	bltz	a0,80004dbe <create+0x11c>
    dp->nlink++;  // for ".."
    80004dac:	04a4d783          	lhu	a5,74(s1)
    80004db0:	2785                	addiw	a5,a5,1
    80004db2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004db6:	8526                	mv	a0,s1
    80004db8:	dc4fe0ef          	jal	8000337c <iupdate>
    80004dbc:	b74d                	j	80004d5e <create+0xbc>
  ip->nlink = 0;
    80004dbe:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004dc2:	854a                	mv	a0,s2
    80004dc4:	db8fe0ef          	jal	8000337c <iupdate>
  iunlockput(ip);
    80004dc8:	854a                	mv	a0,s2
    80004dca:	873fe0ef          	jal	8000363c <iunlockput>
  iunlockput(dp);
    80004dce:	8526                	mv	a0,s1
    80004dd0:	86dfe0ef          	jal	8000363c <iunlockput>
  return 0;
    80004dd4:	b73d                	j	80004d02 <create+0x60>
    return 0;
    80004dd6:	89aa                	mv	s3,a0
    80004dd8:	b72d                	j	80004d02 <create+0x60>

0000000080004dda <sys_dup>:
{
    80004dda:	7179                	addi	sp,sp,-48
    80004ddc:	f406                	sd	ra,40(sp)
    80004dde:	f022                	sd	s0,32(sp)
    80004de0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004de2:	fd840613          	addi	a2,s0,-40
    80004de6:	4581                	li	a1,0
    80004de8:	4501                	li	a0,0
    80004dea:	e1fff0ef          	jal	80004c08 <argfd>
    return -1;
    80004dee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004df0:	02054363          	bltz	a0,80004e16 <sys_dup+0x3c>
    80004df4:	ec26                	sd	s1,24(sp)
    80004df6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004df8:	fd843483          	ld	s1,-40(s0)
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	e65ff0ef          	jal	80004c62 <fdalloc>
    80004e02:	892a                	mv	s2,a0
    return -1;
    80004e04:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004e06:	00054d63          	bltz	a0,80004e20 <sys_dup+0x46>
  filedup(f);
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	c0eff0ef          	jal	8000421a <filedup>
  return fd;
    80004e10:	87ca                	mv	a5,s2
    80004e12:	64e2                	ld	s1,24(sp)
    80004e14:	6942                	ld	s2,16(sp)
}
    80004e16:	853e                	mv	a0,a5
    80004e18:	70a2                	ld	ra,40(sp)
    80004e1a:	7402                	ld	s0,32(sp)
    80004e1c:	6145                	addi	sp,sp,48
    80004e1e:	8082                	ret
    80004e20:	64e2                	ld	s1,24(sp)
    80004e22:	6942                	ld	s2,16(sp)
    80004e24:	bfcd                	j	80004e16 <sys_dup+0x3c>

0000000080004e26 <sys_read>:
{
    80004e26:	7179                	addi	sp,sp,-48
    80004e28:	f406                	sd	ra,40(sp)
    80004e2a:	f022                	sd	s0,32(sp)
    80004e2c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e2e:	fd840593          	addi	a1,s0,-40
    80004e32:	4505                	li	a0,1
    80004e34:	c2dfd0ef          	jal	80002a60 <argaddr>
  argint(2, &n);
    80004e38:	fe440593          	addi	a1,s0,-28
    80004e3c:	4509                	li	a0,2
    80004e3e:	c07fd0ef          	jal	80002a44 <argint>
  if(argfd(0, 0, &f) < 0)
    80004e42:	fe840613          	addi	a2,s0,-24
    80004e46:	4581                	li	a1,0
    80004e48:	4501                	li	a0,0
    80004e4a:	dbfff0ef          	jal	80004c08 <argfd>
    80004e4e:	87aa                	mv	a5,a0
    return -1;
    80004e50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e52:	0007ca63          	bltz	a5,80004e66 <sys_read+0x40>
  return fileread(f, p, n);
    80004e56:	fe442603          	lw	a2,-28(s0)
    80004e5a:	fd843583          	ld	a1,-40(s0)
    80004e5e:	fe843503          	ld	a0,-24(s0)
    80004e62:	d22ff0ef          	jal	80004384 <fileread>
}
    80004e66:	70a2                	ld	ra,40(sp)
    80004e68:	7402                	ld	s0,32(sp)
    80004e6a:	6145                	addi	sp,sp,48
    80004e6c:	8082                	ret

0000000080004e6e <sys_write>:
{
    80004e6e:	7179                	addi	sp,sp,-48
    80004e70:	f406                	sd	ra,40(sp)
    80004e72:	f022                	sd	s0,32(sp)
    80004e74:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e76:	fd840593          	addi	a1,s0,-40
    80004e7a:	4505                	li	a0,1
    80004e7c:	be5fd0ef          	jal	80002a60 <argaddr>
  argint(2, &n);
    80004e80:	fe440593          	addi	a1,s0,-28
    80004e84:	4509                	li	a0,2
    80004e86:	bbffd0ef          	jal	80002a44 <argint>
  if(argfd(0, 0, &f) < 0)
    80004e8a:	fe840613          	addi	a2,s0,-24
    80004e8e:	4581                	li	a1,0
    80004e90:	4501                	li	a0,0
    80004e92:	d77ff0ef          	jal	80004c08 <argfd>
    80004e96:	87aa                	mv	a5,a0
    return -1;
    80004e98:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e9a:	0007ca63          	bltz	a5,80004eae <sys_write+0x40>
  return filewrite(f, p, n);
    80004e9e:	fe442603          	lw	a2,-28(s0)
    80004ea2:	fd843583          	ld	a1,-40(s0)
    80004ea6:	fe843503          	ld	a0,-24(s0)
    80004eaa:	d9eff0ef          	jal	80004448 <filewrite>
}
    80004eae:	70a2                	ld	ra,40(sp)
    80004eb0:	7402                	ld	s0,32(sp)
    80004eb2:	6145                	addi	sp,sp,48
    80004eb4:	8082                	ret

0000000080004eb6 <sys_close>:
{
    80004eb6:	1101                	addi	sp,sp,-32
    80004eb8:	ec06                	sd	ra,24(sp)
    80004eba:	e822                	sd	s0,16(sp)
    80004ebc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ebe:	fe040613          	addi	a2,s0,-32
    80004ec2:	fec40593          	addi	a1,s0,-20
    80004ec6:	4501                	li	a0,0
    80004ec8:	d41ff0ef          	jal	80004c08 <argfd>
    return -1;
    80004ecc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ece:	02054163          	bltz	a0,80004ef0 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004ed2:	b79fc0ef          	jal	80001a4a <myproc>
    80004ed6:	fec42783          	lw	a5,-20(s0)
    80004eda:	078e                	slli	a5,a5,0x3
    80004edc:	0d078793          	addi	a5,a5,208
    80004ee0:	953e                	add	a0,a0,a5
    80004ee2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ee6:	fe043503          	ld	a0,-32(s0)
    80004eea:	b76ff0ef          	jal	80004260 <fileclose>
  return 0;
    80004eee:	4781                	li	a5,0
}
    80004ef0:	853e                	mv	a0,a5
    80004ef2:	60e2                	ld	ra,24(sp)
    80004ef4:	6442                	ld	s0,16(sp)
    80004ef6:	6105                	addi	sp,sp,32
    80004ef8:	8082                	ret

0000000080004efa <sys_fstat>:
{
    80004efa:	1101                	addi	sp,sp,-32
    80004efc:	ec06                	sd	ra,24(sp)
    80004efe:	e822                	sd	s0,16(sp)
    80004f00:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004f02:	fe040593          	addi	a1,s0,-32
    80004f06:	4505                	li	a0,1
    80004f08:	b59fd0ef          	jal	80002a60 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004f0c:	fe840613          	addi	a2,s0,-24
    80004f10:	4581                	li	a1,0
    80004f12:	4501                	li	a0,0
    80004f14:	cf5ff0ef          	jal	80004c08 <argfd>
    80004f18:	87aa                	mv	a5,a0
    return -1;
    80004f1a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f1c:	0007c863          	bltz	a5,80004f2c <sys_fstat+0x32>
  return filestat(f, st);
    80004f20:	fe043583          	ld	a1,-32(s0)
    80004f24:	fe843503          	ld	a0,-24(s0)
    80004f28:	bfaff0ef          	jal	80004322 <filestat>
}
    80004f2c:	60e2                	ld	ra,24(sp)
    80004f2e:	6442                	ld	s0,16(sp)
    80004f30:	6105                	addi	sp,sp,32
    80004f32:	8082                	ret

0000000080004f34 <sys_link>:
{
    80004f34:	7169                	addi	sp,sp,-304
    80004f36:	f606                	sd	ra,296(sp)
    80004f38:	f222                	sd	s0,288(sp)
    80004f3a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f3c:	08000613          	li	a2,128
    80004f40:	ed040593          	addi	a1,s0,-304
    80004f44:	4501                	li	a0,0
    80004f46:	b37fd0ef          	jal	80002a7c <argstr>
    return -1;
    80004f4a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f4c:	0c054e63          	bltz	a0,80005028 <sys_link+0xf4>
    80004f50:	08000613          	li	a2,128
    80004f54:	f5040593          	addi	a1,s0,-176
    80004f58:	4505                	li	a0,1
    80004f5a:	b23fd0ef          	jal	80002a7c <argstr>
    return -1;
    80004f5e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f60:	0c054463          	bltz	a0,80005028 <sys_link+0xf4>
    80004f64:	ee26                	sd	s1,280(sp)
  begin_op();
    80004f66:	ed7fe0ef          	jal	80003e3c <begin_op>
  if((ip = namei(old)) == 0){
    80004f6a:	ed040513          	addi	a0,s0,-304
    80004f6e:	cf1fe0ef          	jal	80003c5e <namei>
    80004f72:	84aa                	mv	s1,a0
    80004f74:	c53d                	beqz	a0,80004fe2 <sys_link+0xae>
  ilock(ip);
    80004f76:	cbafe0ef          	jal	80003430 <ilock>
  if(ip->type == T_DIR){
    80004f7a:	04449703          	lh	a4,68(s1)
    80004f7e:	4785                	li	a5,1
    80004f80:	06f70663          	beq	a4,a5,80004fec <sys_link+0xb8>
    80004f84:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004f86:	04a4d783          	lhu	a5,74(s1)
    80004f8a:	2785                	addiw	a5,a5,1
    80004f8c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f90:	8526                	mv	a0,s1
    80004f92:	beafe0ef          	jal	8000337c <iupdate>
  iunlock(ip);
    80004f96:	8526                	mv	a0,s1
    80004f98:	d46fe0ef          	jal	800034de <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004f9c:	fd040593          	addi	a1,s0,-48
    80004fa0:	f5040513          	addi	a0,s0,-176
    80004fa4:	cd5fe0ef          	jal	80003c78 <nameiparent>
    80004fa8:	892a                	mv	s2,a0
    80004faa:	cd21                	beqz	a0,80005002 <sys_link+0xce>
  ilock(dp);
    80004fac:	c84fe0ef          	jal	80003430 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004fb0:	854a                	mv	a0,s2
    80004fb2:	00092703          	lw	a4,0(s2)
    80004fb6:	409c                	lw	a5,0(s1)
    80004fb8:	04f71263          	bne	a4,a5,80004ffc <sys_link+0xc8>
    80004fbc:	40d0                	lw	a2,4(s1)
    80004fbe:	fd040593          	addi	a1,s0,-48
    80004fc2:	bf3fe0ef          	jal	80003bb4 <dirlink>
    80004fc6:	02054b63          	bltz	a0,80004ffc <sys_link+0xc8>
  iunlockput(dp);
    80004fca:	854a                	mv	a0,s2
    80004fcc:	e70fe0ef          	jal	8000363c <iunlockput>
  iput(ip);
    80004fd0:	8526                	mv	a0,s1
    80004fd2:	de0fe0ef          	jal	800035b2 <iput>
  end_op();
    80004fd6:	ed7fe0ef          	jal	80003eac <end_op>
  return 0;
    80004fda:	4781                	li	a5,0
    80004fdc:	64f2                	ld	s1,280(sp)
    80004fde:	6952                	ld	s2,272(sp)
    80004fe0:	a0a1                	j	80005028 <sys_link+0xf4>
    end_op();
    80004fe2:	ecbfe0ef          	jal	80003eac <end_op>
    return -1;
    80004fe6:	57fd                	li	a5,-1
    80004fe8:	64f2                	ld	s1,280(sp)
    80004fea:	a83d                	j	80005028 <sys_link+0xf4>
    iunlockput(ip);
    80004fec:	8526                	mv	a0,s1
    80004fee:	e4efe0ef          	jal	8000363c <iunlockput>
    end_op();
    80004ff2:	ebbfe0ef          	jal	80003eac <end_op>
    return -1;
    80004ff6:	57fd                	li	a5,-1
    80004ff8:	64f2                	ld	s1,280(sp)
    80004ffa:	a03d                	j	80005028 <sys_link+0xf4>
    iunlockput(dp);
    80004ffc:	854a                	mv	a0,s2
    80004ffe:	e3efe0ef          	jal	8000363c <iunlockput>
  ilock(ip);
    80005002:	8526                	mv	a0,s1
    80005004:	c2cfe0ef          	jal	80003430 <ilock>
  ip->nlink--;
    80005008:	04a4d783          	lhu	a5,74(s1)
    8000500c:	37fd                	addiw	a5,a5,-1
    8000500e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005012:	8526                	mv	a0,s1
    80005014:	b68fe0ef          	jal	8000337c <iupdate>
  iunlockput(ip);
    80005018:	8526                	mv	a0,s1
    8000501a:	e22fe0ef          	jal	8000363c <iunlockput>
  end_op();
    8000501e:	e8ffe0ef          	jal	80003eac <end_op>
  return -1;
    80005022:	57fd                	li	a5,-1
    80005024:	64f2                	ld	s1,280(sp)
    80005026:	6952                	ld	s2,272(sp)
}
    80005028:	853e                	mv	a0,a5
    8000502a:	70b2                	ld	ra,296(sp)
    8000502c:	7412                	ld	s0,288(sp)
    8000502e:	6155                	addi	sp,sp,304
    80005030:	8082                	ret

0000000080005032 <sys_unlink>:
{
    80005032:	7151                	addi	sp,sp,-240
    80005034:	f586                	sd	ra,232(sp)
    80005036:	f1a2                	sd	s0,224(sp)
    80005038:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000503a:	08000613          	li	a2,128
    8000503e:	f3040593          	addi	a1,s0,-208
    80005042:	4501                	li	a0,0
    80005044:	a39fd0ef          	jal	80002a7c <argstr>
    80005048:	14054d63          	bltz	a0,800051a2 <sys_unlink+0x170>
    8000504c:	eda6                	sd	s1,216(sp)
  begin_op();
    8000504e:	deffe0ef          	jal	80003e3c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005052:	fb040593          	addi	a1,s0,-80
    80005056:	f3040513          	addi	a0,s0,-208
    8000505a:	c1ffe0ef          	jal	80003c78 <nameiparent>
    8000505e:	84aa                	mv	s1,a0
    80005060:	c955                	beqz	a0,80005114 <sys_unlink+0xe2>
  ilock(dp);
    80005062:	bcefe0ef          	jal	80003430 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005066:	00002597          	auipc	a1,0x2
    8000506a:	57258593          	addi	a1,a1,1394 # 800075d8 <etext+0x5d8>
    8000506e:	fb040513          	addi	a0,s0,-80
    80005072:	943fe0ef          	jal	800039b4 <namecmp>
    80005076:	10050b63          	beqz	a0,8000518c <sys_unlink+0x15a>
    8000507a:	00002597          	auipc	a1,0x2
    8000507e:	56658593          	addi	a1,a1,1382 # 800075e0 <etext+0x5e0>
    80005082:	fb040513          	addi	a0,s0,-80
    80005086:	92ffe0ef          	jal	800039b4 <namecmp>
    8000508a:	10050163          	beqz	a0,8000518c <sys_unlink+0x15a>
    8000508e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005090:	f2c40613          	addi	a2,s0,-212
    80005094:	fb040593          	addi	a1,s0,-80
    80005098:	8526                	mv	a0,s1
    8000509a:	931fe0ef          	jal	800039ca <dirlookup>
    8000509e:	892a                	mv	s2,a0
    800050a0:	0e050563          	beqz	a0,8000518a <sys_unlink+0x158>
    800050a4:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800050a6:	b8afe0ef          	jal	80003430 <ilock>
  if(ip->nlink < 1)
    800050aa:	04a91783          	lh	a5,74(s2)
    800050ae:	06f05863          	blez	a5,8000511e <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800050b2:	04491703          	lh	a4,68(s2)
    800050b6:	4785                	li	a5,1
    800050b8:	06f70963          	beq	a4,a5,8000512a <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800050bc:	fc040993          	addi	s3,s0,-64
    800050c0:	4641                	li	a2,16
    800050c2:	4581                	li	a1,0
    800050c4:	854e                	mv	a0,s3
    800050c6:	c33fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050ca:	4741                	li	a4,16
    800050cc:	f2c42683          	lw	a3,-212(s0)
    800050d0:	864e                	mv	a2,s3
    800050d2:	4581                	li	a1,0
    800050d4:	8526                	mv	a0,s1
    800050d6:	fdefe0ef          	jal	800038b4 <writei>
    800050da:	47c1                	li	a5,16
    800050dc:	08f51863          	bne	a0,a5,8000516c <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800050e0:	04491703          	lh	a4,68(s2)
    800050e4:	4785                	li	a5,1
    800050e6:	08f70963          	beq	a4,a5,80005178 <sys_unlink+0x146>
  iunlockput(dp);
    800050ea:	8526                	mv	a0,s1
    800050ec:	d50fe0ef          	jal	8000363c <iunlockput>
  ip->nlink--;
    800050f0:	04a95783          	lhu	a5,74(s2)
    800050f4:	37fd                	addiw	a5,a5,-1
    800050f6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800050fa:	854a                	mv	a0,s2
    800050fc:	a80fe0ef          	jal	8000337c <iupdate>
  iunlockput(ip);
    80005100:	854a                	mv	a0,s2
    80005102:	d3afe0ef          	jal	8000363c <iunlockput>
  end_op();
    80005106:	da7fe0ef          	jal	80003eac <end_op>
  return 0;
    8000510a:	4501                	li	a0,0
    8000510c:	64ee                	ld	s1,216(sp)
    8000510e:	694e                	ld	s2,208(sp)
    80005110:	69ae                	ld	s3,200(sp)
    80005112:	a061                	j	8000519a <sys_unlink+0x168>
    end_op();
    80005114:	d99fe0ef          	jal	80003eac <end_op>
    return -1;
    80005118:	557d                	li	a0,-1
    8000511a:	64ee                	ld	s1,216(sp)
    8000511c:	a8bd                	j	8000519a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000511e:	00002517          	auipc	a0,0x2
    80005122:	4ca50513          	addi	a0,a0,1226 # 800075e8 <etext+0x5e8>
    80005126:	efefb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000512a:	04c92703          	lw	a4,76(s2)
    8000512e:	02000793          	li	a5,32
    80005132:	f8e7f5e3          	bgeu	a5,a4,800050bc <sys_unlink+0x8a>
    80005136:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005138:	4741                	li	a4,16
    8000513a:	86ce                	mv	a3,s3
    8000513c:	f1840613          	addi	a2,s0,-232
    80005140:	4581                	li	a1,0
    80005142:	854a                	mv	a0,s2
    80005144:	e7efe0ef          	jal	800037c2 <readi>
    80005148:	47c1                	li	a5,16
    8000514a:	00f51b63          	bne	a0,a5,80005160 <sys_unlink+0x12e>
    if(de.inum != 0)
    8000514e:	f1845783          	lhu	a5,-232(s0)
    80005152:	ebb1                	bnez	a5,800051a6 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005154:	29c1                	addiw	s3,s3,16
    80005156:	04c92783          	lw	a5,76(s2)
    8000515a:	fcf9efe3          	bltu	s3,a5,80005138 <sys_unlink+0x106>
    8000515e:	bfb9                	j	800050bc <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005160:	00002517          	auipc	a0,0x2
    80005164:	4a050513          	addi	a0,a0,1184 # 80007600 <etext+0x600>
    80005168:	ebcfb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    8000516c:	00002517          	auipc	a0,0x2
    80005170:	4ac50513          	addi	a0,a0,1196 # 80007618 <etext+0x618>
    80005174:	eb0fb0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005178:	04a4d783          	lhu	a5,74(s1)
    8000517c:	37fd                	addiw	a5,a5,-1
    8000517e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005182:	8526                	mv	a0,s1
    80005184:	9f8fe0ef          	jal	8000337c <iupdate>
    80005188:	b78d                	j	800050ea <sys_unlink+0xb8>
    8000518a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000518c:	8526                	mv	a0,s1
    8000518e:	caefe0ef          	jal	8000363c <iunlockput>
  end_op();
    80005192:	d1bfe0ef          	jal	80003eac <end_op>
  return -1;
    80005196:	557d                	li	a0,-1
    80005198:	64ee                	ld	s1,216(sp)
}
    8000519a:	70ae                	ld	ra,232(sp)
    8000519c:	740e                	ld	s0,224(sp)
    8000519e:	616d                	addi	sp,sp,240
    800051a0:	8082                	ret
    return -1;
    800051a2:	557d                	li	a0,-1
    800051a4:	bfdd                	j	8000519a <sys_unlink+0x168>
    iunlockput(ip);
    800051a6:	854a                	mv	a0,s2
    800051a8:	c94fe0ef          	jal	8000363c <iunlockput>
    goto bad;
    800051ac:	694e                	ld	s2,208(sp)
    800051ae:	69ae                	ld	s3,200(sp)
    800051b0:	bff1                	j	8000518c <sys_unlink+0x15a>

00000000800051b2 <sys_open>:

uint64
sys_open(void)
{
    800051b2:	7131                	addi	sp,sp,-192
    800051b4:	fd06                	sd	ra,184(sp)
    800051b6:	f922                	sd	s0,176(sp)
    800051b8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800051ba:	f4c40593          	addi	a1,s0,-180
    800051be:	4505                	li	a0,1
    800051c0:	885fd0ef          	jal	80002a44 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800051c4:	08000613          	li	a2,128
    800051c8:	f5040593          	addi	a1,s0,-176
    800051cc:	4501                	li	a0,0
    800051ce:	8affd0ef          	jal	80002a7c <argstr>
    800051d2:	87aa                	mv	a5,a0
    return -1;
    800051d4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800051d6:	0a07c363          	bltz	a5,8000527c <sys_open+0xca>
    800051da:	f526                	sd	s1,168(sp)

  begin_op();
    800051dc:	c61fe0ef          	jal	80003e3c <begin_op>

  if(omode & O_CREATE){
    800051e0:	f4c42783          	lw	a5,-180(s0)
    800051e4:	2007f793          	andi	a5,a5,512
    800051e8:	c3dd                	beqz	a5,8000528e <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800051ea:	4681                	li	a3,0
    800051ec:	4601                	li	a2,0
    800051ee:	4589                	li	a1,2
    800051f0:	f5040513          	addi	a0,s0,-176
    800051f4:	aafff0ef          	jal	80004ca2 <create>
    800051f8:	84aa                	mv	s1,a0
    if(ip == 0){
    800051fa:	c549                	beqz	a0,80005284 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800051fc:	04449703          	lh	a4,68(s1)
    80005200:	478d                	li	a5,3
    80005202:	00f71763          	bne	a4,a5,80005210 <sys_open+0x5e>
    80005206:	0464d703          	lhu	a4,70(s1)
    8000520a:	47a5                	li	a5,9
    8000520c:	0ae7ee63          	bltu	a5,a4,800052c8 <sys_open+0x116>
    80005210:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005212:	fabfe0ef          	jal	800041bc <filealloc>
    80005216:	892a                	mv	s2,a0
    80005218:	c561                	beqz	a0,800052e0 <sys_open+0x12e>
    8000521a:	ed4e                	sd	s3,152(sp)
    8000521c:	a47ff0ef          	jal	80004c62 <fdalloc>
    80005220:	89aa                	mv	s3,a0
    80005222:	0a054b63          	bltz	a0,800052d8 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005226:	04449703          	lh	a4,68(s1)
    8000522a:	478d                	li	a5,3
    8000522c:	0cf70363          	beq	a4,a5,800052f2 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005230:	4789                	li	a5,2
    80005232:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005236:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000523a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000523e:	f4c42783          	lw	a5,-180(s0)
    80005242:	0017f713          	andi	a4,a5,1
    80005246:	00174713          	xori	a4,a4,1
    8000524a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000524e:	0037f713          	andi	a4,a5,3
    80005252:	00e03733          	snez	a4,a4
    80005256:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000525a:	4007f793          	andi	a5,a5,1024
    8000525e:	c791                	beqz	a5,8000526a <sys_open+0xb8>
    80005260:	04449703          	lh	a4,68(s1)
    80005264:	4789                	li	a5,2
    80005266:	08f70d63          	beq	a4,a5,80005300 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000526a:	8526                	mv	a0,s1
    8000526c:	a72fe0ef          	jal	800034de <iunlock>
  end_op();
    80005270:	c3dfe0ef          	jal	80003eac <end_op>

  return fd;
    80005274:	854e                	mv	a0,s3
    80005276:	74aa                	ld	s1,168(sp)
    80005278:	790a                	ld	s2,160(sp)
    8000527a:	69ea                	ld	s3,152(sp)
}
    8000527c:	70ea                	ld	ra,184(sp)
    8000527e:	744a                	ld	s0,176(sp)
    80005280:	6129                	addi	sp,sp,192
    80005282:	8082                	ret
      end_op();
    80005284:	c29fe0ef          	jal	80003eac <end_op>
      return -1;
    80005288:	557d                	li	a0,-1
    8000528a:	74aa                	ld	s1,168(sp)
    8000528c:	bfc5                	j	8000527c <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000528e:	f5040513          	addi	a0,s0,-176
    80005292:	9cdfe0ef          	jal	80003c5e <namei>
    80005296:	84aa                	mv	s1,a0
    80005298:	c11d                	beqz	a0,800052be <sys_open+0x10c>
    ilock(ip);
    8000529a:	996fe0ef          	jal	80003430 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000529e:	04449703          	lh	a4,68(s1)
    800052a2:	4785                	li	a5,1
    800052a4:	f4f71ce3          	bne	a4,a5,800051fc <sys_open+0x4a>
    800052a8:	f4c42783          	lw	a5,-180(s0)
    800052ac:	d3b5                	beqz	a5,80005210 <sys_open+0x5e>
      iunlockput(ip);
    800052ae:	8526                	mv	a0,s1
    800052b0:	b8cfe0ef          	jal	8000363c <iunlockput>
      end_op();
    800052b4:	bf9fe0ef          	jal	80003eac <end_op>
      return -1;
    800052b8:	557d                	li	a0,-1
    800052ba:	74aa                	ld	s1,168(sp)
    800052bc:	b7c1                	j	8000527c <sys_open+0xca>
      end_op();
    800052be:	beffe0ef          	jal	80003eac <end_op>
      return -1;
    800052c2:	557d                	li	a0,-1
    800052c4:	74aa                	ld	s1,168(sp)
    800052c6:	bf5d                	j	8000527c <sys_open+0xca>
    iunlockput(ip);
    800052c8:	8526                	mv	a0,s1
    800052ca:	b72fe0ef          	jal	8000363c <iunlockput>
    end_op();
    800052ce:	bdffe0ef          	jal	80003eac <end_op>
    return -1;
    800052d2:	557d                	li	a0,-1
    800052d4:	74aa                	ld	s1,168(sp)
    800052d6:	b75d                	j	8000527c <sys_open+0xca>
      fileclose(f);
    800052d8:	854a                	mv	a0,s2
    800052da:	f87fe0ef          	jal	80004260 <fileclose>
    800052de:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800052e0:	8526                	mv	a0,s1
    800052e2:	b5afe0ef          	jal	8000363c <iunlockput>
    end_op();
    800052e6:	bc7fe0ef          	jal	80003eac <end_op>
    return -1;
    800052ea:	557d                	li	a0,-1
    800052ec:	74aa                	ld	s1,168(sp)
    800052ee:	790a                	ld	s2,160(sp)
    800052f0:	b771                	j	8000527c <sys_open+0xca>
    f->type = FD_DEVICE;
    800052f2:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800052f6:	04649783          	lh	a5,70(s1)
    800052fa:	02f91223          	sh	a5,36(s2)
    800052fe:	bf35                	j	8000523a <sys_open+0x88>
    itrunc(ip);
    80005300:	8526                	mv	a0,s1
    80005302:	a1cfe0ef          	jal	8000351e <itrunc>
    80005306:	b795                	j	8000526a <sys_open+0xb8>

0000000080005308 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005308:	7175                	addi	sp,sp,-144
    8000530a:	e506                	sd	ra,136(sp)
    8000530c:	e122                	sd	s0,128(sp)
    8000530e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005310:	b2dfe0ef          	jal	80003e3c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005314:	08000613          	li	a2,128
    80005318:	f7040593          	addi	a1,s0,-144
    8000531c:	4501                	li	a0,0
    8000531e:	f5efd0ef          	jal	80002a7c <argstr>
    80005322:	02054363          	bltz	a0,80005348 <sys_mkdir+0x40>
    80005326:	4681                	li	a3,0
    80005328:	4601                	li	a2,0
    8000532a:	4585                	li	a1,1
    8000532c:	f7040513          	addi	a0,s0,-144
    80005330:	973ff0ef          	jal	80004ca2 <create>
    80005334:	c911                	beqz	a0,80005348 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005336:	b06fe0ef          	jal	8000363c <iunlockput>
  end_op();
    8000533a:	b73fe0ef          	jal	80003eac <end_op>
  return 0;
    8000533e:	4501                	li	a0,0
}
    80005340:	60aa                	ld	ra,136(sp)
    80005342:	640a                	ld	s0,128(sp)
    80005344:	6149                	addi	sp,sp,144
    80005346:	8082                	ret
    end_op();
    80005348:	b65fe0ef          	jal	80003eac <end_op>
    return -1;
    8000534c:	557d                	li	a0,-1
    8000534e:	bfcd                	j	80005340 <sys_mkdir+0x38>

0000000080005350 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005350:	7135                	addi	sp,sp,-160
    80005352:	ed06                	sd	ra,152(sp)
    80005354:	e922                	sd	s0,144(sp)
    80005356:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005358:	ae5fe0ef          	jal	80003e3c <begin_op>
  argint(1, &major);
    8000535c:	f6c40593          	addi	a1,s0,-148
    80005360:	4505                	li	a0,1
    80005362:	ee2fd0ef          	jal	80002a44 <argint>
  argint(2, &minor);
    80005366:	f6840593          	addi	a1,s0,-152
    8000536a:	4509                	li	a0,2
    8000536c:	ed8fd0ef          	jal	80002a44 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005370:	08000613          	li	a2,128
    80005374:	f7040593          	addi	a1,s0,-144
    80005378:	4501                	li	a0,0
    8000537a:	f02fd0ef          	jal	80002a7c <argstr>
    8000537e:	02054563          	bltz	a0,800053a8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005382:	f6841683          	lh	a3,-152(s0)
    80005386:	f6c41603          	lh	a2,-148(s0)
    8000538a:	458d                	li	a1,3
    8000538c:	f7040513          	addi	a0,s0,-144
    80005390:	913ff0ef          	jal	80004ca2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005394:	c911                	beqz	a0,800053a8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005396:	aa6fe0ef          	jal	8000363c <iunlockput>
  end_op();
    8000539a:	b13fe0ef          	jal	80003eac <end_op>
  return 0;
    8000539e:	4501                	li	a0,0
}
    800053a0:	60ea                	ld	ra,152(sp)
    800053a2:	644a                	ld	s0,144(sp)
    800053a4:	610d                	addi	sp,sp,160
    800053a6:	8082                	ret
    end_op();
    800053a8:	b05fe0ef          	jal	80003eac <end_op>
    return -1;
    800053ac:	557d                	li	a0,-1
    800053ae:	bfcd                	j	800053a0 <sys_mknod+0x50>

00000000800053b0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800053b0:	7135                	addi	sp,sp,-160
    800053b2:	ed06                	sd	ra,152(sp)
    800053b4:	e922                	sd	s0,144(sp)
    800053b6:	e14a                	sd	s2,128(sp)
    800053b8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800053ba:	e90fc0ef          	jal	80001a4a <myproc>
    800053be:	892a                	mv	s2,a0

  begin_op();
    800053c0:	a7dfe0ef          	jal	80003e3c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800053c4:	08000613          	li	a2,128
    800053c8:	f6040593          	addi	a1,s0,-160
    800053cc:	4501                	li	a0,0
    800053ce:	eaefd0ef          	jal	80002a7c <argstr>
    800053d2:	04054363          	bltz	a0,80005418 <sys_chdir+0x68>
    800053d6:	e526                	sd	s1,136(sp)
    800053d8:	f6040513          	addi	a0,s0,-160
    800053dc:	883fe0ef          	jal	80003c5e <namei>
    800053e0:	84aa                	mv	s1,a0
    800053e2:	c915                	beqz	a0,80005416 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800053e4:	84cfe0ef          	jal	80003430 <ilock>
  if(ip->type != T_DIR){
    800053e8:	04449703          	lh	a4,68(s1)
    800053ec:	4785                	li	a5,1
    800053ee:	02f71963          	bne	a4,a5,80005420 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800053f2:	8526                	mv	a0,s1
    800053f4:	8eafe0ef          	jal	800034de <iunlock>
  iput(p->cwd);
    800053f8:	15093503          	ld	a0,336(s2)
    800053fc:	9b6fe0ef          	jal	800035b2 <iput>
  end_op();
    80005400:	aadfe0ef          	jal	80003eac <end_op>
  p->cwd = ip;
    80005404:	14993823          	sd	s1,336(s2)
  return 0;
    80005408:	4501                	li	a0,0
    8000540a:	64aa                	ld	s1,136(sp)
}
    8000540c:	60ea                	ld	ra,152(sp)
    8000540e:	644a                	ld	s0,144(sp)
    80005410:	690a                	ld	s2,128(sp)
    80005412:	610d                	addi	sp,sp,160
    80005414:	8082                	ret
    80005416:	64aa                	ld	s1,136(sp)
    end_op();
    80005418:	a95fe0ef          	jal	80003eac <end_op>
    return -1;
    8000541c:	557d                	li	a0,-1
    8000541e:	b7fd                	j	8000540c <sys_chdir+0x5c>
    iunlockput(ip);
    80005420:	8526                	mv	a0,s1
    80005422:	a1afe0ef          	jal	8000363c <iunlockput>
    end_op();
    80005426:	a87fe0ef          	jal	80003eac <end_op>
    return -1;
    8000542a:	557d                	li	a0,-1
    8000542c:	64aa                	ld	s1,136(sp)
    8000542e:	bff9                	j	8000540c <sys_chdir+0x5c>

0000000080005430 <sys_exec>:

uint64
sys_exec(void)
{
    80005430:	7105                	addi	sp,sp,-480
    80005432:	ef86                	sd	ra,472(sp)
    80005434:	eba2                	sd	s0,464(sp)
    80005436:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005438:	e2840593          	addi	a1,s0,-472
    8000543c:	4505                	li	a0,1
    8000543e:	e22fd0ef          	jal	80002a60 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005442:	08000613          	li	a2,128
    80005446:	f3040593          	addi	a1,s0,-208
    8000544a:	4501                	li	a0,0
    8000544c:	e30fd0ef          	jal	80002a7c <argstr>
    80005450:	87aa                	mv	a5,a0
    return -1;
    80005452:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005454:	0e07c063          	bltz	a5,80005534 <sys_exec+0x104>
    80005458:	e7a6                	sd	s1,456(sp)
    8000545a:	e3ca                	sd	s2,448(sp)
    8000545c:	ff4e                	sd	s3,440(sp)
    8000545e:	fb52                	sd	s4,432(sp)
    80005460:	f756                	sd	s5,424(sp)
    80005462:	f35a                	sd	s6,416(sp)
    80005464:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005466:	e3040a13          	addi	s4,s0,-464
    8000546a:	10000613          	li	a2,256
    8000546e:	4581                	li	a1,0
    80005470:	8552                	mv	a0,s4
    80005472:	887fb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005476:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005478:	89d2                	mv	s3,s4
    8000547a:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000547c:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005480:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005482:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005486:	00391513          	slli	a0,s2,0x3
    8000548a:	85d6                	mv	a1,s5
    8000548c:	e2843783          	ld	a5,-472(s0)
    80005490:	953e                	add	a0,a0,a5
    80005492:	d28fd0ef          	jal	800029ba <fetchaddr>
    80005496:	02054663          	bltz	a0,800054c2 <sys_exec+0x92>
    if(uarg == 0){
    8000549a:	e2043783          	ld	a5,-480(s0)
    8000549e:	c7a1                	beqz	a5,800054e6 <sys_exec+0xb6>
    argv[i] = kalloc();
    800054a0:	ea4fb0ef          	jal	80000b44 <kalloc>
    800054a4:	85aa                	mv	a1,a0
    800054a6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800054aa:	cd01                	beqz	a0,800054c2 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054ac:	865a                	mv	a2,s6
    800054ae:	e2043503          	ld	a0,-480(s0)
    800054b2:	d52fd0ef          	jal	80002a04 <fetchstr>
    800054b6:	00054663          	bltz	a0,800054c2 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800054ba:	0905                	addi	s2,s2,1
    800054bc:	09a1                	addi	s3,s3,8
    800054be:	fd7914e3          	bne	s2,s7,80005486 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054c2:	100a0a13          	addi	s4,s4,256
    800054c6:	6088                	ld	a0,0(s1)
    800054c8:	cd31                	beqz	a0,80005524 <sys_exec+0xf4>
    kfree(argv[i]);
    800054ca:	d92fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054ce:	04a1                	addi	s1,s1,8
    800054d0:	ff449be3          	bne	s1,s4,800054c6 <sys_exec+0x96>
  return -1;
    800054d4:	557d                	li	a0,-1
    800054d6:	64be                	ld	s1,456(sp)
    800054d8:	691e                	ld	s2,448(sp)
    800054da:	79fa                	ld	s3,440(sp)
    800054dc:	7a5a                	ld	s4,432(sp)
    800054de:	7aba                	ld	s5,424(sp)
    800054e0:	7b1a                	ld	s6,416(sp)
    800054e2:	6bfa                	ld	s7,408(sp)
    800054e4:	a881                	j	80005534 <sys_exec+0x104>
      argv[i] = 0;
    800054e6:	0009079b          	sext.w	a5,s2
    800054ea:	e3040593          	addi	a1,s0,-464
    800054ee:	078e                	slli	a5,a5,0x3
    800054f0:	97ae                	add	a5,a5,a1
    800054f2:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800054f6:	f3040513          	addi	a0,s0,-208
    800054fa:	bb2ff0ef          	jal	800048ac <kexec>
    800054fe:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005500:	100a0a13          	addi	s4,s4,256
    80005504:	6088                	ld	a0,0(s1)
    80005506:	c511                	beqz	a0,80005512 <sys_exec+0xe2>
    kfree(argv[i]);
    80005508:	d54fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000550c:	04a1                	addi	s1,s1,8
    8000550e:	ff449be3          	bne	s1,s4,80005504 <sys_exec+0xd4>
  return ret;
    80005512:	854a                	mv	a0,s2
    80005514:	64be                	ld	s1,456(sp)
    80005516:	691e                	ld	s2,448(sp)
    80005518:	79fa                	ld	s3,440(sp)
    8000551a:	7a5a                	ld	s4,432(sp)
    8000551c:	7aba                	ld	s5,424(sp)
    8000551e:	7b1a                	ld	s6,416(sp)
    80005520:	6bfa                	ld	s7,408(sp)
    80005522:	a809                	j	80005534 <sys_exec+0x104>
  return -1;
    80005524:	557d                	li	a0,-1
    80005526:	64be                	ld	s1,456(sp)
    80005528:	691e                	ld	s2,448(sp)
    8000552a:	79fa                	ld	s3,440(sp)
    8000552c:	7a5a                	ld	s4,432(sp)
    8000552e:	7aba                	ld	s5,424(sp)
    80005530:	7b1a                	ld	s6,416(sp)
    80005532:	6bfa                	ld	s7,408(sp)
}
    80005534:	60fe                	ld	ra,472(sp)
    80005536:	645e                	ld	s0,464(sp)
    80005538:	613d                	addi	sp,sp,480
    8000553a:	8082                	ret

000000008000553c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000553c:	7139                	addi	sp,sp,-64
    8000553e:	fc06                	sd	ra,56(sp)
    80005540:	f822                	sd	s0,48(sp)
    80005542:	f426                	sd	s1,40(sp)
    80005544:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005546:	d04fc0ef          	jal	80001a4a <myproc>
    8000554a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000554c:	fd840593          	addi	a1,s0,-40
    80005550:	4501                	li	a0,0
    80005552:	d0efd0ef          	jal	80002a60 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005556:	fc840593          	addi	a1,s0,-56
    8000555a:	fd040513          	addi	a0,s0,-48
    8000555e:	81eff0ef          	jal	8000457c <pipealloc>
    return -1;
    80005562:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005564:	0a054763          	bltz	a0,80005612 <sys_pipe+0xd6>
  fd0 = -1;
    80005568:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000556c:	fd043503          	ld	a0,-48(s0)
    80005570:	ef2ff0ef          	jal	80004c62 <fdalloc>
    80005574:	fca42223          	sw	a0,-60(s0)
    80005578:	08054463          	bltz	a0,80005600 <sys_pipe+0xc4>
    8000557c:	fc843503          	ld	a0,-56(s0)
    80005580:	ee2ff0ef          	jal	80004c62 <fdalloc>
    80005584:	fca42023          	sw	a0,-64(s0)
    80005588:	06054263          	bltz	a0,800055ec <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000558c:	4691                	li	a3,4
    8000558e:	fc440613          	addi	a2,s0,-60
    80005592:	fd843583          	ld	a1,-40(s0)
    80005596:	68a8                	ld	a0,80(s1)
    80005598:	8bcfc0ef          	jal	80001654 <copyout>
    8000559c:	00054e63          	bltz	a0,800055b8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800055a0:	4691                	li	a3,4
    800055a2:	fc040613          	addi	a2,s0,-64
    800055a6:	fd843583          	ld	a1,-40(s0)
    800055aa:	95b6                	add	a1,a1,a3
    800055ac:	68a8                	ld	a0,80(s1)
    800055ae:	8a6fc0ef          	jal	80001654 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055b2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055b4:	04055f63          	bgez	a0,80005612 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800055b8:	fc442783          	lw	a5,-60(s0)
    800055bc:	078e                	slli	a5,a5,0x3
    800055be:	0d078793          	addi	a5,a5,208
    800055c2:	97a6                	add	a5,a5,s1
    800055c4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800055c8:	fc042783          	lw	a5,-64(s0)
    800055cc:	078e                	slli	a5,a5,0x3
    800055ce:	0d078793          	addi	a5,a5,208
    800055d2:	97a6                	add	a5,a5,s1
    800055d4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800055d8:	fd043503          	ld	a0,-48(s0)
    800055dc:	c85fe0ef          	jal	80004260 <fileclose>
    fileclose(wf);
    800055e0:	fc843503          	ld	a0,-56(s0)
    800055e4:	c7dfe0ef          	jal	80004260 <fileclose>
    return -1;
    800055e8:	57fd                	li	a5,-1
    800055ea:	a025                	j	80005612 <sys_pipe+0xd6>
    if(fd0 >= 0)
    800055ec:	fc442783          	lw	a5,-60(s0)
    800055f0:	0007c863          	bltz	a5,80005600 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    800055f4:	078e                	slli	a5,a5,0x3
    800055f6:	0d078793          	addi	a5,a5,208
    800055fa:	97a6                	add	a5,a5,s1
    800055fc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005600:	fd043503          	ld	a0,-48(s0)
    80005604:	c5dfe0ef          	jal	80004260 <fileclose>
    fileclose(wf);
    80005608:	fc843503          	ld	a0,-56(s0)
    8000560c:	c55fe0ef          	jal	80004260 <fileclose>
    return -1;
    80005610:	57fd                	li	a5,-1
}
    80005612:	853e                	mv	a0,a5
    80005614:	70e2                	ld	ra,56(sp)
    80005616:	7442                	ld	s0,48(sp)
    80005618:	74a2                	ld	s1,40(sp)
    8000561a:	6121                	addi	sp,sp,64
    8000561c:	8082                	ret
	...

0000000080005620 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005620:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005622:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005624:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005626:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005628:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000562a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000562c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000562e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005630:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005632:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005634:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005636:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005638:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000563a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000563c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000563e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005640:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005642:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005644:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005646:	a82fd0ef          	jal	800028c8 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000564a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000564c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000564e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005650:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005652:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005654:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005656:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005658:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000565a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000565c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000565e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005660:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005662:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005664:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005666:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005668:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000566a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000566c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000566e:	10200073          	sret
    80005672:	00000013          	nop
    80005676:	00000013          	nop
    8000567a:	00000013          	nop

000000008000567e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000567e:	1141                	addi	sp,sp,-16
    80005680:	e406                	sd	ra,8(sp)
    80005682:	e022                	sd	s0,0(sp)
    80005684:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005686:	0c000737          	lui	a4,0xc000
    8000568a:	4785                	li	a5,1
    8000568c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000568e:	c35c                	sw	a5,4(a4)
}
    80005690:	60a2                	ld	ra,8(sp)
    80005692:	6402                	ld	s0,0(sp)
    80005694:	0141                	addi	sp,sp,16
    80005696:	8082                	ret

0000000080005698 <plicinithart>:

void
plicinithart(void)
{
    80005698:	1141                	addi	sp,sp,-16
    8000569a:	e406                	sd	ra,8(sp)
    8000569c:	e022                	sd	s0,0(sp)
    8000569e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056a0:	b76fc0ef          	jal	80001a16 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800056a4:	0085171b          	slliw	a4,a0,0x8
    800056a8:	0c0027b7          	lui	a5,0xc002
    800056ac:	97ba                	add	a5,a5,a4
    800056ae:	40200713          	li	a4,1026
    800056b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800056b6:	00d5151b          	slliw	a0,a0,0xd
    800056ba:	0c2017b7          	lui	a5,0xc201
    800056be:	97aa                	add	a5,a5,a0
    800056c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800056c4:	60a2                	ld	ra,8(sp)
    800056c6:	6402                	ld	s0,0(sp)
    800056c8:	0141                	addi	sp,sp,16
    800056ca:	8082                	ret

00000000800056cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800056cc:	1141                	addi	sp,sp,-16
    800056ce:	e406                	sd	ra,8(sp)
    800056d0:	e022                	sd	s0,0(sp)
    800056d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056d4:	b42fc0ef          	jal	80001a16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800056d8:	00d5151b          	slliw	a0,a0,0xd
    800056dc:	0c2017b7          	lui	a5,0xc201
    800056e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800056e2:	43c8                	lw	a0,4(a5)
    800056e4:	60a2                	ld	ra,8(sp)
    800056e6:	6402                	ld	s0,0(sp)
    800056e8:	0141                	addi	sp,sp,16
    800056ea:	8082                	ret

00000000800056ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800056ec:	1101                	addi	sp,sp,-32
    800056ee:	ec06                	sd	ra,24(sp)
    800056f0:	e822                	sd	s0,16(sp)
    800056f2:	e426                	sd	s1,8(sp)
    800056f4:	1000                	addi	s0,sp,32
    800056f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800056f8:	b1efc0ef          	jal	80001a16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800056fc:	00d5179b          	slliw	a5,a0,0xd
    80005700:	0c201737          	lui	a4,0xc201
    80005704:	97ba                	add	a5,a5,a4
    80005706:	c3c4                	sw	s1,4(a5)
}
    80005708:	60e2                	ld	ra,24(sp)
    8000570a:	6442                	ld	s0,16(sp)
    8000570c:	64a2                	ld	s1,8(sp)
    8000570e:	6105                	addi	sp,sp,32
    80005710:	8082                	ret

0000000080005712 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005712:	1141                	addi	sp,sp,-16
    80005714:	e406                	sd	ra,8(sp)
    80005716:	e022                	sd	s0,0(sp)
    80005718:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000571a:	479d                	li	a5,7
    8000571c:	04a7ca63          	blt	a5,a0,80005770 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005720:	0001c797          	auipc	a5,0x1c
    80005724:	36878793          	addi	a5,a5,872 # 80021a88 <disk>
    80005728:	97aa                	add	a5,a5,a0
    8000572a:	0187c783          	lbu	a5,24(a5)
    8000572e:	e7b9                	bnez	a5,8000577c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005730:	00451693          	slli	a3,a0,0x4
    80005734:	0001c797          	auipc	a5,0x1c
    80005738:	35478793          	addi	a5,a5,852 # 80021a88 <disk>
    8000573c:	6398                	ld	a4,0(a5)
    8000573e:	9736                	add	a4,a4,a3
    80005740:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005744:	6398                	ld	a4,0(a5)
    80005746:	9736                	add	a4,a4,a3
    80005748:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000574c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005750:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005754:	97aa                	add	a5,a5,a0
    80005756:	4705                	li	a4,1
    80005758:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000575c:	0001c517          	auipc	a0,0x1c
    80005760:	34450513          	addi	a0,a0,836 # 80021aa0 <disk+0x18>
    80005764:	9bffc0ef          	jal	80002122 <wakeup>
}
    80005768:	60a2                	ld	ra,8(sp)
    8000576a:	6402                	ld	s0,0(sp)
    8000576c:	0141                	addi	sp,sp,16
    8000576e:	8082                	ret
    panic("free_desc 1");
    80005770:	00002517          	auipc	a0,0x2
    80005774:	eb850513          	addi	a0,a0,-328 # 80007628 <etext+0x628>
    80005778:	8acfb0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000577c:	00002517          	auipc	a0,0x2
    80005780:	ebc50513          	addi	a0,a0,-324 # 80007638 <etext+0x638>
    80005784:	8a0fb0ef          	jal	80000824 <panic>

0000000080005788 <virtio_disk_init>:
{
    80005788:	1101                	addi	sp,sp,-32
    8000578a:	ec06                	sd	ra,24(sp)
    8000578c:	e822                	sd	s0,16(sp)
    8000578e:	e426                	sd	s1,8(sp)
    80005790:	e04a                	sd	s2,0(sp)
    80005792:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005794:	00002597          	auipc	a1,0x2
    80005798:	eb458593          	addi	a1,a1,-332 # 80007648 <etext+0x648>
    8000579c:	0001c517          	auipc	a0,0x1c
    800057a0:	41450513          	addi	a0,a0,1044 # 80021bb0 <disk+0x128>
    800057a4:	bfafb0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057a8:	100017b7          	lui	a5,0x10001
    800057ac:	4398                	lw	a4,0(a5)
    800057ae:	2701                	sext.w	a4,a4
    800057b0:	747277b7          	lui	a5,0x74727
    800057b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800057b8:	14f71863          	bne	a4,a5,80005908 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057bc:	100017b7          	lui	a5,0x10001
    800057c0:	43dc                	lw	a5,4(a5)
    800057c2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057c4:	4709                	li	a4,2
    800057c6:	14e79163          	bne	a5,a4,80005908 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057ca:	100017b7          	lui	a5,0x10001
    800057ce:	479c                	lw	a5,8(a5)
    800057d0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800057d2:	12e79b63          	bne	a5,a4,80005908 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800057d6:	100017b7          	lui	a5,0x10001
    800057da:	47d8                	lw	a4,12(a5)
    800057dc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057de:	554d47b7          	lui	a5,0x554d4
    800057e2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800057e6:	12f71163          	bne	a4,a5,80005908 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057ea:	100017b7          	lui	a5,0x10001
    800057ee:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057f2:	4705                	li	a4,1
    800057f4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057f6:	470d                	li	a4,3
    800057f8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800057fa:	10001737          	lui	a4,0x10001
    800057fe:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005800:	c7ffe6b7          	lui	a3,0xc7ffe
    80005804:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdcb97>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005808:	8f75                	and	a4,a4,a3
    8000580a:	100016b7          	lui	a3,0x10001
    8000580e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005810:	472d                	li	a4,11
    80005812:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005814:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005818:	439c                	lw	a5,0(a5)
    8000581a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000581e:	8ba1                	andi	a5,a5,8
    80005820:	0e078a63          	beqz	a5,80005914 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005824:	100017b7          	lui	a5,0x10001
    80005828:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000582c:	43fc                	lw	a5,68(a5)
    8000582e:	2781                	sext.w	a5,a5
    80005830:	0e079863          	bnez	a5,80005920 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005834:	100017b7          	lui	a5,0x10001
    80005838:	5bdc                	lw	a5,52(a5)
    8000583a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000583c:	0e078863          	beqz	a5,8000592c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005840:	471d                	li	a4,7
    80005842:	0ef77b63          	bgeu	a4,a5,80005938 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005846:	afefb0ef          	jal	80000b44 <kalloc>
    8000584a:	0001c497          	auipc	s1,0x1c
    8000584e:	23e48493          	addi	s1,s1,574 # 80021a88 <disk>
    80005852:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005854:	af0fb0ef          	jal	80000b44 <kalloc>
    80005858:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000585a:	aeafb0ef          	jal	80000b44 <kalloc>
    8000585e:	87aa                	mv	a5,a0
    80005860:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005862:	6088                	ld	a0,0(s1)
    80005864:	0e050063          	beqz	a0,80005944 <virtio_disk_init+0x1bc>
    80005868:	0001c717          	auipc	a4,0x1c
    8000586c:	22873703          	ld	a4,552(a4) # 80021a90 <disk+0x8>
    80005870:	cb71                	beqz	a4,80005944 <virtio_disk_init+0x1bc>
    80005872:	cbe9                	beqz	a5,80005944 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005874:	6605                	lui	a2,0x1
    80005876:	4581                	li	a1,0
    80005878:	c80fb0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000587c:	0001c497          	auipc	s1,0x1c
    80005880:	20c48493          	addi	s1,s1,524 # 80021a88 <disk>
    80005884:	6605                	lui	a2,0x1
    80005886:	4581                	li	a1,0
    80005888:	6488                	ld	a0,8(s1)
    8000588a:	c6efb0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000588e:	6605                	lui	a2,0x1
    80005890:	4581                	li	a1,0
    80005892:	6888                	ld	a0,16(s1)
    80005894:	c64fb0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005898:	100017b7          	lui	a5,0x10001
    8000589c:	4721                	li	a4,8
    8000589e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800058a0:	4098                	lw	a4,0(s1)
    800058a2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800058a6:	40d8                	lw	a4,4(s1)
    800058a8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800058ac:	649c                	ld	a5,8(s1)
    800058ae:	0007869b          	sext.w	a3,a5
    800058b2:	10001737          	lui	a4,0x10001
    800058b6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800058ba:	9781                	srai	a5,a5,0x20
    800058bc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800058c0:	689c                	ld	a5,16(s1)
    800058c2:	0007869b          	sext.w	a3,a5
    800058c6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800058ca:	9781                	srai	a5,a5,0x20
    800058cc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800058d0:	4785                	li	a5,1
    800058d2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800058d4:	00f48c23          	sb	a5,24(s1)
    800058d8:	00f48ca3          	sb	a5,25(s1)
    800058dc:	00f48d23          	sb	a5,26(s1)
    800058e0:	00f48da3          	sb	a5,27(s1)
    800058e4:	00f48e23          	sb	a5,28(s1)
    800058e8:	00f48ea3          	sb	a5,29(s1)
    800058ec:	00f48f23          	sb	a5,30(s1)
    800058f0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800058f4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800058f8:	07272823          	sw	s2,112(a4)
}
    800058fc:	60e2                	ld	ra,24(sp)
    800058fe:	6442                	ld	s0,16(sp)
    80005900:	64a2                	ld	s1,8(sp)
    80005902:	6902                	ld	s2,0(sp)
    80005904:	6105                	addi	sp,sp,32
    80005906:	8082                	ret
    panic("could not find virtio disk");
    80005908:	00002517          	auipc	a0,0x2
    8000590c:	d5050513          	addi	a0,a0,-688 # 80007658 <etext+0x658>
    80005910:	f15fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005914:	00002517          	auipc	a0,0x2
    80005918:	d6450513          	addi	a0,a0,-668 # 80007678 <etext+0x678>
    8000591c:	f09fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005920:	00002517          	auipc	a0,0x2
    80005924:	d7850513          	addi	a0,a0,-648 # 80007698 <etext+0x698>
    80005928:	efdfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    8000592c:	00002517          	auipc	a0,0x2
    80005930:	d8c50513          	addi	a0,a0,-628 # 800076b8 <etext+0x6b8>
    80005934:	ef1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005938:	00002517          	auipc	a0,0x2
    8000593c:	da050513          	addi	a0,a0,-608 # 800076d8 <etext+0x6d8>
    80005940:	ee5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005944:	00002517          	auipc	a0,0x2
    80005948:	db450513          	addi	a0,a0,-588 # 800076f8 <etext+0x6f8>
    8000594c:	ed9fa0ef          	jal	80000824 <panic>

0000000080005950 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005950:	711d                	addi	sp,sp,-96
    80005952:	ec86                	sd	ra,88(sp)
    80005954:	e8a2                	sd	s0,80(sp)
    80005956:	e4a6                	sd	s1,72(sp)
    80005958:	e0ca                	sd	s2,64(sp)
    8000595a:	fc4e                	sd	s3,56(sp)
    8000595c:	f852                	sd	s4,48(sp)
    8000595e:	f456                	sd	s5,40(sp)
    80005960:	f05a                	sd	s6,32(sp)
    80005962:	ec5e                	sd	s7,24(sp)
    80005964:	e862                	sd	s8,16(sp)
    80005966:	1080                	addi	s0,sp,96
    80005968:	89aa                	mv	s3,a0
    8000596a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000596c:	00c52b83          	lw	s7,12(a0)
    80005970:	001b9b9b          	slliw	s7,s7,0x1
    80005974:	1b82                	slli	s7,s7,0x20
    80005976:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000597a:	0001c517          	auipc	a0,0x1c
    8000597e:	23650513          	addi	a0,a0,566 # 80021bb0 <disk+0x128>
    80005982:	aa6fb0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005986:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005988:	0001ca97          	auipc	s5,0x1c
    8000598c:	100a8a93          	addi	s5,s5,256 # 80021a88 <disk>
  for(int i = 0; i < 3; i++){
    80005990:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005992:	5c7d                	li	s8,-1
    80005994:	a095                	j	800059f8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005996:	00fa8733          	add	a4,s5,a5
    8000599a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000599e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800059a0:	0207c563          	bltz	a5,800059ca <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800059a4:	2905                	addiw	s2,s2,1
    800059a6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800059a8:	05490c63          	beq	s2,s4,80005a00 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800059ac:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800059ae:	0001c717          	auipc	a4,0x1c
    800059b2:	0da70713          	addi	a4,a4,218 # 80021a88 <disk>
    800059b6:	4781                	li	a5,0
    if(disk.free[i]){
    800059b8:	01874683          	lbu	a3,24(a4)
    800059bc:	fee9                	bnez	a3,80005996 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800059be:	2785                	addiw	a5,a5,1
    800059c0:	0705                	addi	a4,a4,1
    800059c2:	fe979be3          	bne	a5,s1,800059b8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800059c6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800059ca:	01205d63          	blez	s2,800059e4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800059ce:	fa042503          	lw	a0,-96(s0)
    800059d2:	d41ff0ef          	jal	80005712 <free_desc>
      for(int j = 0; j < i; j++)
    800059d6:	4785                	li	a5,1
    800059d8:	0127d663          	bge	a5,s2,800059e4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800059dc:	fa442503          	lw	a0,-92(s0)
    800059e0:	d33ff0ef          	jal	80005712 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800059e4:	0001c597          	auipc	a1,0x1c
    800059e8:	1cc58593          	addi	a1,a1,460 # 80021bb0 <disk+0x128>
    800059ec:	0001c517          	auipc	a0,0x1c
    800059f0:	0b450513          	addi	a0,a0,180 # 80021aa0 <disk+0x18>
    800059f4:	ee2fc0ef          	jal	800020d6 <sleep>
  for(int i = 0; i < 3; i++){
    800059f8:	fa040613          	addi	a2,s0,-96
    800059fc:	4901                	li	s2,0
    800059fe:	b77d                	j	800059ac <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a00:	fa042503          	lw	a0,-96(s0)
    80005a04:	00451693          	slli	a3,a0,0x4

  if(write)
    80005a08:	0001c797          	auipc	a5,0x1c
    80005a0c:	08078793          	addi	a5,a5,128 # 80021a88 <disk>
    80005a10:	00451713          	slli	a4,a0,0x4
    80005a14:	0a070713          	addi	a4,a4,160
    80005a18:	973e                	add	a4,a4,a5
    80005a1a:	01603633          	snez	a2,s6
    80005a1e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a20:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a24:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a28:	6398                	ld	a4,0(a5)
    80005a2a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a2c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005a30:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a32:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a34:	6390                	ld	a2,0(a5)
    80005a36:	00d60833          	add	a6,a2,a3
    80005a3a:	4741                	li	a4,16
    80005a3c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a40:	4585                	li	a1,1
    80005a42:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005a46:	fa442703          	lw	a4,-92(s0)
    80005a4a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a4e:	0712                	slli	a4,a4,0x4
    80005a50:	963a                	add	a2,a2,a4
    80005a52:	05898813          	addi	a6,s3,88
    80005a56:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a5a:	0007b883          	ld	a7,0(a5)
    80005a5e:	9746                	add	a4,a4,a7
    80005a60:	40000613          	li	a2,1024
    80005a64:	c710                	sw	a2,8(a4)
  if(write)
    80005a66:	001b3613          	seqz	a2,s6
    80005a6a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005a6e:	8e4d                	or	a2,a2,a1
    80005a70:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005a74:	fa842603          	lw	a2,-88(s0)
    80005a78:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a7c:	00451813          	slli	a6,a0,0x4
    80005a80:	02080813          	addi	a6,a6,32
    80005a84:	983e                	add	a6,a6,a5
    80005a86:	577d                	li	a4,-1
    80005a88:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005a8c:	0612                	slli	a2,a2,0x4
    80005a8e:	98b2                	add	a7,a7,a2
    80005a90:	03068713          	addi	a4,a3,48
    80005a94:	973e                	add	a4,a4,a5
    80005a96:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005a9a:	6398                	ld	a4,0(a5)
    80005a9c:	9732                	add	a4,a4,a2
    80005a9e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005aa0:	4689                	li	a3,2
    80005aa2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005aa6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005aaa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005aae:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005ab2:	6794                	ld	a3,8(a5)
    80005ab4:	0026d703          	lhu	a4,2(a3)
    80005ab8:	8b1d                	andi	a4,a4,7
    80005aba:	0706                	slli	a4,a4,0x1
    80005abc:	96ba                	add	a3,a3,a4
    80005abe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005ac2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005ac6:	6798                	ld	a4,8(a5)
    80005ac8:	00275783          	lhu	a5,2(a4)
    80005acc:	2785                	addiw	a5,a5,1
    80005ace:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005ad2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005ad6:	100017b7          	lui	a5,0x10001
    80005ada:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005ade:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005ae2:	0001c917          	auipc	s2,0x1c
    80005ae6:	0ce90913          	addi	s2,s2,206 # 80021bb0 <disk+0x128>
  while(b->disk == 1) {
    80005aea:	84ae                	mv	s1,a1
    80005aec:	00b79a63          	bne	a5,a1,80005b00 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005af0:	85ca                	mv	a1,s2
    80005af2:	854e                	mv	a0,s3
    80005af4:	de2fc0ef          	jal	800020d6 <sleep>
  while(b->disk == 1) {
    80005af8:	0049a783          	lw	a5,4(s3)
    80005afc:	fe978ae3          	beq	a5,s1,80005af0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005b00:	fa042903          	lw	s2,-96(s0)
    80005b04:	00491713          	slli	a4,s2,0x4
    80005b08:	02070713          	addi	a4,a4,32
    80005b0c:	0001c797          	auipc	a5,0x1c
    80005b10:	f7c78793          	addi	a5,a5,-132 # 80021a88 <disk>
    80005b14:	97ba                	add	a5,a5,a4
    80005b16:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b1a:	0001c997          	auipc	s3,0x1c
    80005b1e:	f6e98993          	addi	s3,s3,-146 # 80021a88 <disk>
    80005b22:	00491713          	slli	a4,s2,0x4
    80005b26:	0009b783          	ld	a5,0(s3)
    80005b2a:	97ba                	add	a5,a5,a4
    80005b2c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b30:	854a                	mv	a0,s2
    80005b32:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b36:	bddff0ef          	jal	80005712 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005b3a:	8885                	andi	s1,s1,1
    80005b3c:	f0fd                	bnez	s1,80005b22 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b3e:	0001c517          	auipc	a0,0x1c
    80005b42:	07250513          	addi	a0,a0,114 # 80021bb0 <disk+0x128>
    80005b46:	976fb0ef          	jal	80000cbc <release>
}
    80005b4a:	60e6                	ld	ra,88(sp)
    80005b4c:	6446                	ld	s0,80(sp)
    80005b4e:	64a6                	ld	s1,72(sp)
    80005b50:	6906                	ld	s2,64(sp)
    80005b52:	79e2                	ld	s3,56(sp)
    80005b54:	7a42                	ld	s4,48(sp)
    80005b56:	7aa2                	ld	s5,40(sp)
    80005b58:	7b02                	ld	s6,32(sp)
    80005b5a:	6be2                	ld	s7,24(sp)
    80005b5c:	6c42                	ld	s8,16(sp)
    80005b5e:	6125                	addi	sp,sp,96
    80005b60:	8082                	ret

0000000080005b62 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b62:	1101                	addi	sp,sp,-32
    80005b64:	ec06                	sd	ra,24(sp)
    80005b66:	e822                	sd	s0,16(sp)
    80005b68:	e426                	sd	s1,8(sp)
    80005b6a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b6c:	0001c497          	auipc	s1,0x1c
    80005b70:	f1c48493          	addi	s1,s1,-228 # 80021a88 <disk>
    80005b74:	0001c517          	auipc	a0,0x1c
    80005b78:	03c50513          	addi	a0,a0,60 # 80021bb0 <disk+0x128>
    80005b7c:	8acfb0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b80:	100017b7          	lui	a5,0x10001
    80005b84:	53bc                	lw	a5,96(a5)
    80005b86:	8b8d                	andi	a5,a5,3
    80005b88:	10001737          	lui	a4,0x10001
    80005b8c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b8e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b92:	689c                	ld	a5,16(s1)
    80005b94:	0204d703          	lhu	a4,32(s1)
    80005b98:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005b9c:	04f70863          	beq	a4,a5,80005bec <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005ba0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ba4:	6898                	ld	a4,16(s1)
    80005ba6:	0204d783          	lhu	a5,32(s1)
    80005baa:	8b9d                	andi	a5,a5,7
    80005bac:	078e                	slli	a5,a5,0x3
    80005bae:	97ba                	add	a5,a5,a4
    80005bb0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005bb2:	00479713          	slli	a4,a5,0x4
    80005bb6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005bba:	9726                	add	a4,a4,s1
    80005bbc:	01074703          	lbu	a4,16(a4)
    80005bc0:	e329                	bnez	a4,80005c02 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005bc2:	0792                	slli	a5,a5,0x4
    80005bc4:	02078793          	addi	a5,a5,32
    80005bc8:	97a6                	add	a5,a5,s1
    80005bca:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005bcc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005bd0:	d52fc0ef          	jal	80002122 <wakeup>

    disk.used_idx += 1;
    80005bd4:	0204d783          	lhu	a5,32(s1)
    80005bd8:	2785                	addiw	a5,a5,1
    80005bda:	17c2                	slli	a5,a5,0x30
    80005bdc:	93c1                	srli	a5,a5,0x30
    80005bde:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005be2:	6898                	ld	a4,16(s1)
    80005be4:	00275703          	lhu	a4,2(a4)
    80005be8:	faf71ce3          	bne	a4,a5,80005ba0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005bec:	0001c517          	auipc	a0,0x1c
    80005bf0:	fc450513          	addi	a0,a0,-60 # 80021bb0 <disk+0x128>
    80005bf4:	8c8fb0ef          	jal	80000cbc <release>
}
    80005bf8:	60e2                	ld	ra,24(sp)
    80005bfa:	6442                	ld	s0,16(sp)
    80005bfc:	64a2                	ld	s1,8(sp)
    80005bfe:	6105                	addi	sp,sp,32
    80005c00:	8082                	ret
      panic("virtio_disk_intr status");
    80005c02:	00002517          	auipc	a0,0x2
    80005c06:	b0e50513          	addi	a0,a0,-1266 # 80007710 <etext+0x710>
    80005c0a:	c1bfa0ef          	jal	80000824 <panic>

0000000080005c0e <_left_rotate>:
#include "rbtree.h"

static void _left_rotate(struct rb_tree *tree, struct rb_node *x) {
    80005c0e:	1141                	addi	sp,sp,-16
    80005c10:	e406                	sd	ra,8(sp)
    80005c12:	e022                	sd	s0,0(sp)
    80005c14:	0800                	addi	s0,sp,16
  struct rb_node *y = x->right;
    80005c16:	719c                	ld	a5,32(a1)
  x->right = y->left;
    80005c18:	6f98                	ld	a4,24(a5)
    80005c1a:	f198                	sd	a4,32(a1)
  if (y->left != 0)
    80005c1c:	c311                	beqz	a4,80005c20 <_left_rotate+0x12>
    y->left->parent = x;
    80005c1e:	eb0c                	sd	a1,16(a4)
  y->parent = x->parent;
    80005c20:	6998                	ld	a4,16(a1)
    80005c22:	eb98                	sd	a4,16(a5)
  if (x->parent == 0) // x was root
    80005c24:	cb19                	beqz	a4,80005c3a <_left_rotate+0x2c>
    tree->root = y;
  else if (x == x->parent->left) // x was left child
    80005c26:	6f14                	ld	a3,24(a4)
    80005c28:	00b68b63          	beq	a3,a1,80005c3e <_left_rotate+0x30>
    x->parent->left = y;
  else // x was right child
    x->parent->right = y;
    80005c2c:	f31c                	sd	a5,32(a4)
  y->left = x;
    80005c2e:	ef8c                	sd	a1,24(a5)
  x->parent = y;
    80005c30:	e99c                	sd	a5,16(a1)
}
    80005c32:	60a2                	ld	ra,8(sp)
    80005c34:	6402                	ld	s0,0(sp)
    80005c36:	0141                	addi	sp,sp,16
    80005c38:	8082                	ret
    tree->root = y;
    80005c3a:	e11c                	sd	a5,0(a0)
    80005c3c:	bfcd                	j	80005c2e <_left_rotate+0x20>
    x->parent->left = y;
    80005c3e:	ef1c                	sd	a5,24(a4)
    80005c40:	b7fd                	j	80005c2e <_left_rotate+0x20>

0000000080005c42 <_right_rotate>:

static void _right_rotate(struct rb_tree *tree, struct rb_node *y) {
    80005c42:	1141                	addi	sp,sp,-16
    80005c44:	e406                	sd	ra,8(sp)
    80005c46:	e022                	sd	s0,0(sp)
    80005c48:	0800                	addi	s0,sp,16
  struct rb_node *x = y->left;
    80005c4a:	6d9c                	ld	a5,24(a1)
  y->left = x->right;
    80005c4c:	7398                	ld	a4,32(a5)
    80005c4e:	ed98                	sd	a4,24(a1)
  if (x->right != 0)
    80005c50:	c311                	beqz	a4,80005c54 <_right_rotate+0x12>
    x->right->parent = y;
    80005c52:	eb0c                	sd	a1,16(a4)
  x->parent = y->parent;
    80005c54:	6998                	ld	a4,16(a1)
    80005c56:	eb98                	sd	a4,16(a5)
  if (y->parent == 0) // y was root
    80005c58:	cb19                	beqz	a4,80005c6e <_right_rotate+0x2c>
    tree->root = x;
  else if (y == y->parent->left) // y was left child
    80005c5a:	6f14                	ld	a3,24(a4)
    80005c5c:	00b68b63          	beq	a3,a1,80005c72 <_right_rotate+0x30>
    y->parent->left = x;
  else // y was right child
    y->parent->right = x;
    80005c60:	f31c                	sd	a5,32(a4)
  x->right = y;
    80005c62:	f38c                	sd	a1,32(a5)
  y->parent = x;
    80005c64:	e99c                	sd	a5,16(a1)
}
    80005c66:	60a2                	ld	ra,8(sp)
    80005c68:	6402                	ld	s0,0(sp)
    80005c6a:	0141                	addi	sp,sp,16
    80005c6c:	8082                	ret
    tree->root = x;
    80005c6e:	e11c                	sd	a5,0(a0)
    80005c70:	bfcd                	j	80005c62 <_right_rotate+0x20>
    y->parent->left = x;
    80005c72:	ef1c                	sd	a5,24(a4)
    80005c74:	b7fd                	j	80005c62 <_right_rotate+0x20>

0000000080005c76 <_rb_transplant>:
  z->color = RED;

  _insert_fixup(tree, z);
}

static void _rb_transplant(struct rb_tree *tree, struct rb_node *u, struct rb_node *v) {
    80005c76:	1141                	addi	sp,sp,-16
    80005c78:	e406                	sd	ra,8(sp)
    80005c7a:	e022                	sd	s0,0(sp)
    80005c7c:	0800                	addi	s0,sp,16
  if (u->parent == 0)
    80005c7e:	699c                	ld	a5,16(a1)
    80005c80:	cf81                	beqz	a5,80005c98 <_rb_transplant+0x22>
    tree->root = v;
  else if (u == u->parent->left)
    80005c82:	6f98                	ld	a4,24(a5)
    80005c84:	00b70c63          	beq	a4,a1,80005c9c <_rb_transplant+0x26>
    u->parent->left = v;
  else
    u->parent->right = v;
    80005c88:	f390                	sd	a2,32(a5)
  if (v != 0)
    80005c8a:	c219                	beqz	a2,80005c90 <_rb_transplant+0x1a>
    v->parent = u->parent;
    80005c8c:	699c                	ld	a5,16(a1)
    80005c8e:	ea1c                	sd	a5,16(a2)
}
    80005c90:	60a2                	ld	ra,8(sp)
    80005c92:	6402                	ld	s0,0(sp)
    80005c94:	0141                	addi	sp,sp,16
    80005c96:	8082                	ret
    tree->root = v;
    80005c98:	e110                	sd	a2,0(a0)
    80005c9a:	bfc5                	j	80005c8a <_rb_transplant+0x14>
    u->parent->left = v;
    80005c9c:	ef90                	sd	a2,24(a5)
    80005c9e:	b7f5                	j	80005c8a <_rb_transplant+0x14>

0000000080005ca0 <rb_insert>:
void rb_insert(struct rb_tree *tree, struct rb_node *z) {
    80005ca0:	7179                	addi	sp,sp,-48
    80005ca2:	f406                	sd	ra,40(sp)
    80005ca4:	f022                	sd	s0,32(sp)
    80005ca6:	ec26                	sd	s1,24(sp)
    80005ca8:	e84a                	sd	s2,16(sp)
    80005caa:	e44e                	sd	s3,8(sp)
    80005cac:	e052                	sd	s4,0(sp)
    80005cae:	1800                	addi	s0,sp,48
    80005cb0:	89aa                	mv	s3,a0
    80005cb2:	892e                	mv	s2,a1
  struct rb_node *x = tree->root;
    80005cb4:	611c                	ld	a5,0(a0)
  while (x != 0) {
    80005cb6:	10078863          	beqz	a5,80005dc6 <rb_insert+0x126>
    if (z->key < x->key)
    80005cba:	6194                	ld	a3,0(a1)
    80005cbc:	a021                	j	80005cc4 <rb_insert+0x24>
      x = x->right;
    80005cbe:	7398                	ld	a4,32(a5)
  while (x != 0) {
    80005cc0:	c719                	beqz	a4,80005cce <rb_insert+0x2e>
    80005cc2:	87ba                	mv	a5,a4
    if (z->key < x->key)
    80005cc4:	6398                	ld	a4,0(a5)
    80005cc6:	fee6fce3          	bgeu	a3,a4,80005cbe <rb_insert+0x1e>
      x = x->left;
    80005cca:	6f98                	ld	a4,24(a5)
    80005ccc:	bfd5                	j	80005cc0 <rb_insert+0x20>
  z->parent = y;
    80005cce:	00f93823          	sd	a5,16(s2)
  else if (z->key < y->key)
    80005cd2:	6398                	ld	a4,0(a5)
    80005cd4:	02e6fa63          	bgeu	a3,a4,80005d08 <rb_insert+0x68>
    y->left = z;
    80005cd8:	0127bc23          	sd	s2,24(a5)
  z->left = 0;
    80005cdc:	00093c23          	sd	zero,24(s2)
  z->right = 0;
    80005ce0:	02093023          	sd	zero,32(s2)
  z->color = RED;
    80005ce4:	02092423          	sw	zero,40(s2)
  while (z->parent != 0 && z->parent->color == RED) {
    80005ce8:	01093483          	ld	s1,16(s2)
        z->parent->color = BLACK;
    80005cec:	4a05                	li	s4,1
  while (z->parent != 0 && z->parent->color == RED) {
    80005cee:	ecd9                	bnez	s1,80005d8c <rb_insert+0xec>
  tree->root->color = BLACK;
    80005cf0:	0009b783          	ld	a5,0(s3)
    80005cf4:	4705                	li	a4,1
    80005cf6:	d798                	sw	a4,40(a5)
}
    80005cf8:	70a2                	ld	ra,40(sp)
    80005cfa:	7402                	ld	s0,32(sp)
    80005cfc:	64e2                	ld	s1,24(sp)
    80005cfe:	6942                	ld	s2,16(sp)
    80005d00:	69a2                	ld	s3,8(sp)
    80005d02:	6a02                	ld	s4,0(sp)
    80005d04:	6145                	addi	sp,sp,48
    80005d06:	8082                	ret
    y->right = z;
    80005d08:	0327b023          	sd	s2,32(a5)
    80005d0c:	bfc1                	j	80005cdc <rb_insert+0x3c>
      struct rb_node *y = z->parent->parent->right; // uncle
    80005d0e:	731c                	ld	a5,32(a4)
      if (y != 0 && y->color == RED) {
    80005d10:	c385                	beqz	a5,80005d30 <rb_insert+0x90>
    80005d12:	5798                	lw	a4,40(a5)
    80005d14:	ef11                	bnez	a4,80005d30 <rb_insert+0x90>
        z->parent->color = BLACK;
    80005d16:	4705                	li	a4,1
    80005d18:	d498                	sw	a4,40(s1)
        y->color = BLACK;
    80005d1a:	d798                	sw	a4,40(a5)
        z->parent->parent->color = RED;
    80005d1c:	01093783          	ld	a5,16(s2)
    80005d20:	6b9c                	ld	a5,16(a5)
    80005d22:	0207a423          	sw	zero,40(a5)
        z = z->parent->parent;
    80005d26:	01093783          	ld	a5,16(s2)
    80005d2a:	0107b903          	ld	s2,16(a5)
    80005d2e:	a8a1                	j	80005d86 <rb_insert+0xe6>
        if (z == z->parent->right) {
    80005d30:	709c                	ld	a5,32(s1)
    80005d32:	03278263          	beq	a5,s2,80005d56 <rb_insert+0xb6>
        z->parent->color = BLACK;
    80005d36:	01093783          	ld	a5,16(s2)
    80005d3a:	0347a423          	sw	s4,40(a5)
        z->parent->parent->color = RED;
    80005d3e:	01093783          	ld	a5,16(s2)
    80005d42:	6b9c                	ld	a5,16(a5)
    80005d44:	0207a423          	sw	zero,40(a5)
        _right_rotate(tree, z->parent->parent);
    80005d48:	01093783          	ld	a5,16(s2)
    80005d4c:	6b8c                	ld	a1,16(a5)
    80005d4e:	854e                	mv	a0,s3
    80005d50:	ef3ff0ef          	jal	80005c42 <_right_rotate>
    80005d54:	a80d                	j	80005d86 <rb_insert+0xe6>
          _left_rotate(tree, z);
    80005d56:	85a6                	mv	a1,s1
    80005d58:	854e                	mv	a0,s3
    80005d5a:	eb5ff0ef          	jal	80005c0e <_left_rotate>
          z = z->parent;
    80005d5e:	8926                	mv	s2,s1
    80005d60:	bfd9                	j	80005d36 <rb_insert+0x96>
        if (z == z->parent->left) {
    80005d62:	6c9c                	ld	a5,24(s1)
    80005d64:	05278b63          	beq	a5,s2,80005dba <rb_insert+0x11a>
        z->parent->color = BLACK;
    80005d68:	01093783          	ld	a5,16(s2)
    80005d6c:	0347a423          	sw	s4,40(a5)
        z->parent->parent->color = RED;
    80005d70:	01093783          	ld	a5,16(s2)
    80005d74:	6b9c                	ld	a5,16(a5)
    80005d76:	0207a423          	sw	zero,40(a5)
        _left_rotate(tree, z->parent->parent);
    80005d7a:	01093783          	ld	a5,16(s2)
    80005d7e:	6b8c                	ld	a1,16(a5)
    80005d80:	854e                	mv	a0,s3
    80005d82:	e8dff0ef          	jal	80005c0e <_left_rotate>
  while (z->parent != 0 && z->parent->color == RED) {
    80005d86:	01093483          	ld	s1,16(s2)
    80005d8a:	d0bd                	beqz	s1,80005cf0 <rb_insert+0x50>
    80005d8c:	549c                	lw	a5,40(s1)
    80005d8e:	f3ad                	bnez	a5,80005cf0 <rb_insert+0x50>
    if (z->parent == z->parent->parent->left) {
    80005d90:	6898                	ld	a4,16(s1)
    80005d92:	6f1c                	ld	a5,24(a4)
    80005d94:	f6978de3          	beq	a5,s1,80005d0e <rb_insert+0x6e>
      if (y != 0 && y->color == RED) {
    80005d98:	d7e9                	beqz	a5,80005d62 <rb_insert+0xc2>
    80005d9a:	5798                	lw	a4,40(a5)
    80005d9c:	f379                	bnez	a4,80005d62 <rb_insert+0xc2>
        z->parent->color = BLACK;
    80005d9e:	0344a423          	sw	s4,40(s1)
        y->color = BLACK;
    80005da2:	0347a423          	sw	s4,40(a5)
        z->parent->parent->color = RED;
    80005da6:	01093783          	ld	a5,16(s2)
    80005daa:	6b9c                	ld	a5,16(a5)
    80005dac:	0207a423          	sw	zero,40(a5)
        z = z->parent->parent;
    80005db0:	01093783          	ld	a5,16(s2)
    80005db4:	0107b903          	ld	s2,16(a5)
    80005db8:	b7f9                	j	80005d86 <rb_insert+0xe6>
          _right_rotate(tree, z);
    80005dba:	85a6                	mv	a1,s1
    80005dbc:	854e                	mv	a0,s3
    80005dbe:	e85ff0ef          	jal	80005c42 <_right_rotate>
          z = z->parent;
    80005dc2:	8926                	mv	s2,s1
    80005dc4:	b755                	j	80005d68 <rb_insert+0xc8>
  z->parent = y;
    80005dc6:	0005b823          	sd	zero,16(a1)
    tree->root = z;
    80005dca:	00b9b023          	sd	a1,0(s3)
    80005dce:	b739                	j	80005cdc <rb_insert+0x3c>

0000000080005dd0 <rb_first>:

  if (y_original_color == BLACK)
    _delete_fixup(tree, x, x_parent);
}

struct rb_node* rb_first(struct rb_node *node) {
    80005dd0:	1141                	addi	sp,sp,-16
    80005dd2:	e406                	sd	ra,8(sp)
    80005dd4:	e022                	sd	s0,0(sp)
    80005dd6:	0800                	addi	s0,sp,16
    80005dd8:	87aa                	mv	a5,a0
  if (node == 0) return 0;
    80005dda:	c501                	beqz	a0,80005de2 <rb_first+0x12>
  while (node->left != 0)
    80005ddc:	853e                	mv	a0,a5
    80005dde:	6f9c                	ld	a5,24(a5)
    80005de0:	fff5                	bnez	a5,80005ddc <rb_first+0xc>
    node = node->left;
  return node;
}
    80005de2:	60a2                	ld	ra,8(sp)
    80005de4:	6402                	ld	s0,0(sp)
    80005de6:	0141                	addi	sp,sp,16
    80005de8:	8082                	ret

0000000080005dea <rb_delete>:
void rb_delete(struct rb_tree *tree, struct rb_node *z) {
    80005dea:	7139                	addi	sp,sp,-64
    80005dec:	fc06                	sd	ra,56(sp)
    80005dee:	f822                	sd	s0,48(sp)
    80005df0:	f426                	sd	s1,40(sp)
    80005df2:	f04a                	sd	s2,32(sp)
    80005df4:	ec4e                	sd	s3,24(sp)
    80005df6:	e852                	sd	s4,16(sp)
    80005df8:	e05a                	sd	s6,0(sp)
    80005dfa:	0080                	addi	s0,sp,64
    80005dfc:	89aa                	mv	s3,a0
    80005dfe:	8a2e                	mv	s4,a1
  rb_color y_original_color = y->color;
    80005e00:	0285ab03          	lw	s6,40(a1)
  if (z->left == 0) {
    80005e04:	0185b903          	ld	s2,24(a1)
    80005e08:	06090663          	beqz	s2,80005e74 <rb_delete+0x8a>
  } else if (z->right == 0) {
    80005e0c:	7188                	ld	a0,32(a1)
    80005e0e:	c935                	beqz	a0,80005e82 <rb_delete+0x98>
    80005e10:	e456                	sd	s5,8(sp)
    y = rb_first(z->right);
    80005e12:	fbfff0ef          	jal	80005dd0 <rb_first>
    80005e16:	8aaa                	mv	s5,a0
    y_original_color = y->color;
    80005e18:	02852b03          	lw	s6,40(a0)
    x = y->right;
    80005e1c:	02053903          	ld	s2,32(a0)
    if (y->parent == z) {
    80005e20:	6904                	ld	s1,16(a0)
    80005e22:	07448663          	beq	s1,s4,80005e8e <rb_delete+0xa4>
      _rb_transplant(tree, y, y->right);
    80005e26:	864a                	mv	a2,s2
    80005e28:	85aa                	mv	a1,a0
    80005e2a:	854e                	mv	a0,s3
    80005e2c:	e4bff0ef          	jal	80005c76 <_rb_transplant>
      y->right = z->right;
    80005e30:	020a3783          	ld	a5,32(s4)
    80005e34:	02fab023          	sd	a5,32(s5)
      y->right->parent = y;
    80005e38:	0157b823          	sd	s5,16(a5)
    _rb_transplant(tree, z, y);
    80005e3c:	8656                	mv	a2,s5
    80005e3e:	85d2                	mv	a1,s4
    80005e40:	854e                	mv	a0,s3
    80005e42:	e35ff0ef          	jal	80005c76 <_rb_transplant>
    y->left = z->left;
    80005e46:	018a3783          	ld	a5,24(s4)
    80005e4a:	00fabc23          	sd	a5,24(s5)
    y->left->parent = y;
    80005e4e:	0157b823          	sd	s5,16(a5)
    y->color = z->color;
    80005e52:	028a2783          	lw	a5,40(s4)
    80005e56:	02faa423          	sw	a5,40(s5)
    80005e5a:	6aa2                	ld	s5,8(sp)
  if (y_original_color == BLACK)
    80005e5c:	4785                	li	a5,1
    80005e5e:	02fb0a63          	beq	s6,a5,80005e92 <rb_delete+0xa8>
}
    80005e62:	70e2                	ld	ra,56(sp)
    80005e64:	7442                	ld	s0,48(sp)
    80005e66:	74a2                	ld	s1,40(sp)
    80005e68:	7902                	ld	s2,32(sp)
    80005e6a:	69e2                	ld	s3,24(sp)
    80005e6c:	6a42                	ld	s4,16(sp)
    80005e6e:	6b02                	ld	s6,0(sp)
    80005e70:	6121                	addi	sp,sp,64
    80005e72:	8082                	ret
    x = z->right;
    80005e74:	0205b903          	ld	s2,32(a1)
    x_parent = z->parent;
    80005e78:	6984                	ld	s1,16(a1)
    _rb_transplant(tree, z, z->right);
    80005e7a:	864a                	mv	a2,s2
    80005e7c:	dfbff0ef          	jal	80005c76 <_rb_transplant>
    80005e80:	bff1                	j	80005e5c <rb_delete+0x72>
    x_parent = z->parent;
    80005e82:	6984                	ld	s1,16(a1)
    _rb_transplant(tree, z, z->left);
    80005e84:	864a                	mv	a2,s2
    80005e86:	854e                	mv	a0,s3
    80005e88:	defff0ef          	jal	80005c76 <_rb_transplant>
    80005e8c:	bfc1                	j	80005e5c <rb_delete+0x72>
      x_parent = y;
    80005e8e:	84aa                	mv	s1,a0
    80005e90:	b775                	j	80005e3c <rb_delete+0x52>
  while (x != tree->root && (x == 0 || x->color == BLACK)) {
    80005e92:	0009b783          	ld	a5,0(s3)
    80005e96:	8a5a                	mv	s4,s6
    80005e98:	0af91363          	bne	s2,a5,80005f3e <rb_delete+0x154>
    80005e9c:	a8ed                	j	80005f96 <rb_delete+0x1ac>
      struct rb_node *w = x_parent->right; // sibling
    80005e9e:	708c                	ld	a1,32(s1)
      if (w->color == RED) {
    80005ea0:	559c                	lw	a5,40(a1)
    80005ea2:	c3b9                	beqz	a5,80005ee8 <rb_delete+0xfe>
      if ((w->left == 0 || w->left->color == BLACK) &&
    80005ea4:	6d9c                	ld	a5,24(a1)
    80005ea6:	cbb9                	beqz	a5,80005efc <rb_delete+0x112>
    80005ea8:	5798                	lw	a4,40(a5)
    80005eaa:	05470963          	beq	a4,s4,80005efc <rb_delete+0x112>
        if (w->right == 0 || w->right->color == BLACK) {
    80005eae:	7198                	ld	a4,32(a1)
    80005eb0:	c709                	beqz	a4,80005eba <rb_delete+0xd0>
    80005eb2:	5714                	lw	a3,40(a4)
    80005eb4:	4705                	li	a4,1
    80005eb6:	00e69a63          	bne	a3,a4,80005eca <rb_delete+0xe0>
          if (w->left) w->left->color = BLACK;
    80005eba:	4705                	li	a4,1
    80005ebc:	d798                	sw	a4,40(a5)
          w->color = RED;
    80005ebe:	0205a423          	sw	zero,40(a1)
          _right_rotate(tree, w);
    80005ec2:	854e                	mv	a0,s3
    80005ec4:	d7fff0ef          	jal	80005c42 <_right_rotate>
          w = x_parent->right;
    80005ec8:	708c                	ld	a1,32(s1)
        w->color = x_parent->color;
    80005eca:	549c                	lw	a5,40(s1)
    80005ecc:	d59c                	sw	a5,40(a1)
        x_parent->color = BLACK;
    80005ece:	4785                	li	a5,1
    80005ed0:	d49c                	sw	a5,40(s1)
        if (w->right) w->right->color = BLACK;
    80005ed2:	719c                	ld	a5,32(a1)
    80005ed4:	c399                	beqz	a5,80005eda <rb_delete+0xf0>
    80005ed6:	4705                	li	a4,1
    80005ed8:	d798                	sw	a4,40(a5)
        _left_rotate(tree, x_parent);
    80005eda:	85a6                	mv	a1,s1
    80005edc:	854e                	mv	a0,s3
    80005ede:	d31ff0ef          	jal	80005c0e <_left_rotate>
        x = tree->root;
    80005ee2:	0009b903          	ld	s2,0(s3)
    80005ee6:	a845                	j	80005f96 <rb_delete+0x1ac>
        w->color = BLACK;
    80005ee8:	0345a423          	sw	s4,40(a1)
        x_parent->color = RED;
    80005eec:	0204a423          	sw	zero,40(s1)
        _left_rotate(tree, x_parent);
    80005ef0:	85a6                	mv	a1,s1
    80005ef2:	854e                	mv	a0,s3
    80005ef4:	d1bff0ef          	jal	80005c0e <_left_rotate>
        w = x_parent->right;
    80005ef8:	708c                	ld	a1,32(s1)
    80005efa:	b76d                	j	80005ea4 <rb_delete+0xba>
          (w->right == 0 || w->right->color == BLACK)) {
    80005efc:	719c                	ld	a5,32(a1)
      if ((w->left == 0 || w->left->color == BLACK) &&
    80005efe:	c781                	beqz	a5,80005f06 <rb_delete+0x11c>
          (w->right == 0 || w->right->color == BLACK)) {
    80005f00:	579c                	lw	a5,40(a5)
    80005f02:	fd4794e3          	bne	a5,s4,80005eca <rb_delete+0xe0>
        w->color = RED;
    80005f06:	0205a423          	sw	zero,40(a1)
        x_parent = x->parent;
    80005f0a:	6898                	ld	a4,16(s1)
    80005f0c:	a01d                	j	80005f32 <rb_delete+0x148>
        w->color = BLACK;
    80005f0e:	0345a423          	sw	s4,40(a1)
        x_parent->color = RED;
    80005f12:	0204a423          	sw	zero,40(s1)
        _right_rotate(tree, x_parent);
    80005f16:	85a6                	mv	a1,s1
    80005f18:	854e                	mv	a0,s3
    80005f1a:	d29ff0ef          	jal	80005c42 <_right_rotate>
        w = x_parent->left;
    80005f1e:	6c8c                	ld	a1,24(s1)
    80005f20:	a815                	j	80005f54 <rb_delete+0x16a>
          (w->left == 0 || w->left->color == BLACK)) {
    80005f22:	6d9c                	ld	a5,24(a1)
      if ((w->right == 0 || w->right->color == BLACK) &&
    80005f24:	c781                	beqz	a5,80005f2c <rb_delete+0x142>
          (w->left == 0 || w->left->color == BLACK)) {
    80005f26:	579c                	lw	a5,40(a5)
    80005f28:	05479963          	bne	a5,s4,80005f7a <rb_delete+0x190>
        w->color = RED;
    80005f2c:	0205a423          	sw	zero,40(a1)
        x_parent = x->parent;
    80005f30:	6898                	ld	a4,16(s1)
  while (x != tree->root && (x == 0 || x->color == BLACK)) {
    80005f32:	8926                	mv	s2,s1
    80005f34:	0009b783          	ld	a5,0(s3)
    80005f38:	06978163          	beq	a5,s1,80005f9a <rb_delete+0x1b0>
    80005f3c:	84ba                	mv	s1,a4
    80005f3e:	00090663          	beqz	s2,80005f4a <rb_delete+0x160>
    80005f42:	02892783          	lw	a5,40(s2)
    80005f46:	05479a63          	bne	a5,s4,80005f9a <rb_delete+0x1b0>
    if (x == x_parent->left) {
    80005f4a:	6c8c                	ld	a1,24(s1)
    80005f4c:	f52589e3          	beq	a1,s2,80005e9e <rb_delete+0xb4>
      if (w->color == RED) {
    80005f50:	559c                	lw	a5,40(a1)
    80005f52:	dfd5                	beqz	a5,80005f0e <rb_delete+0x124>
      if ((w->right == 0 || w->right->color == BLACK) &&
    80005f54:	719c                	ld	a5,32(a1)
    80005f56:	d7f1                	beqz	a5,80005f22 <rb_delete+0x138>
    80005f58:	5798                	lw	a4,40(a5)
    80005f5a:	fd4704e3          	beq	a4,s4,80005f22 <rb_delete+0x138>
        if (w->left == 0 || w->left->color == BLACK) {
    80005f5e:	6d98                	ld	a4,24(a1)
    80005f60:	c709                	beqz	a4,80005f6a <rb_delete+0x180>
    80005f62:	5714                	lw	a3,40(a4)
    80005f64:	4705                	li	a4,1
    80005f66:	00e69a63          	bne	a3,a4,80005f7a <rb_delete+0x190>
          if (w->right) w->right->color = BLACK;
    80005f6a:	4705                	li	a4,1
    80005f6c:	d798                	sw	a4,40(a5)
          w->color = RED;
    80005f6e:	0205a423          	sw	zero,40(a1)
          _left_rotate(tree, w);
    80005f72:	854e                	mv	a0,s3
    80005f74:	c9bff0ef          	jal	80005c0e <_left_rotate>
          w = x_parent->left;
    80005f78:	6c8c                	ld	a1,24(s1)
        w->color = x_parent->color;
    80005f7a:	549c                	lw	a5,40(s1)
    80005f7c:	d59c                	sw	a5,40(a1)
        x_parent->color = BLACK;
    80005f7e:	4785                	li	a5,1
    80005f80:	d49c                	sw	a5,40(s1)
        if (w->left) w->left->color = BLACK;
    80005f82:	6d9c                	ld	a5,24(a1)
    80005f84:	c399                	beqz	a5,80005f8a <rb_delete+0x1a0>
    80005f86:	4705                	li	a4,1
    80005f88:	d798                	sw	a4,40(a5)
        _right_rotate(tree, x_parent);
    80005f8a:	85a6                	mv	a1,s1
    80005f8c:	854e                	mv	a0,s3
    80005f8e:	cb5ff0ef          	jal	80005c42 <_right_rotate>
        x = tree->root;
    80005f92:	0009b903          	ld	s2,0(s3)
  if (x != 0)
    80005f96:	ec0906e3          	beqz	s2,80005e62 <rb_delete+0x78>
    x->color = BLACK;
    80005f9a:	4785                	li	a5,1
    80005f9c:	02f92423          	sw	a5,40(s2)
}
    80005fa0:	b5c9                	j	80005e62 <rb_delete+0x78>

0000000080005fa2 <rb_last>:

struct rb_node* rb_last(struct rb_node *node) {
    80005fa2:	1141                	addi	sp,sp,-16
    80005fa4:	e406                	sd	ra,8(sp)
    80005fa6:	e022                	sd	s0,0(sp)
    80005fa8:	0800                	addi	s0,sp,16
    80005faa:	87aa                	mv	a5,a0
  if (node == 0) return 0;
    80005fac:	c501                	beqz	a0,80005fb4 <rb_last+0x12>
  while (node->right != 0)
    80005fae:	853e                	mv	a0,a5
    80005fb0:	739c                	ld	a5,32(a5)
    80005fb2:	fff5                	bnez	a5,80005fae <rb_last+0xc>
    node = node->right;
  return node;
}
    80005fb4:	60a2                	ld	ra,8(sp)
    80005fb6:	6402                	ld	s0,0(sp)
    80005fb8:	0141                	addi	sp,sp,16
    80005fba:	8082                	ret
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
