
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2c4000ef          	jal	2cc <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2c2000ef          	jal	2d4 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	34c000ef          	jal	364 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	2aa000ef          	jal	2d4 <exit>

000000000000002e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0xa>
    ;
  return os;
}
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	cb91                	beqz	a5,6e <strcmp+0x20>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x20>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf91                	beqz	a5,a6 <strlen+0x28>
  8c:	00150793          	addi	a5,a0,1
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x12>
  9a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  9e:	60a2                	ld	ra,8(sp)
  a0:	6402                	ld	s0,0(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret
  for(n = 0; s[n]; n++)
  a6:	4501                	li	a0,0
  a8:	bfdd                	j	9e <strlen+0x20>

00000000000000aa <memset>:

void*
memset(void *dst, int c, uint n)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b2:	ca19                	beqz	a2,c8 <memset+0x1e>
  b4:	87aa                	mv	a5,a0
  b6:	1602                	slli	a2,a2,0x20
  b8:	9201                	srli	a2,a2,0x20
  ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c2:	0785                	addi	a5,a5,1
  c4:	fee79de3          	bne	a5,a4,be <memset+0x14>
  }
  return dst;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cf81                	beqz	a5,f4 <strchr+0x24>
    if(*s == c)
  de:	00f58763          	beq	a1,a5,ec <strchr+0x1c>
  for(; *s; s++)
  e2:	0505                	addi	a0,a0,1
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbfd                	bnez	a5,de <strchr+0xe>
      return (char*)s;
  return 0;
  ea:	4501                	li	a0,0
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  return 0;
  f4:	4501                	li	a0,0
  f6:	bfdd                	j	ec <strchr+0x1c>

00000000000000f8 <gets>:

char*
gets(char *buf, int max)
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	e862                	sd	s8,16(sp)
 10e:	1080                	addi	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
 118:	faf40b13          	addi	s6,s0,-81
 11c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 11e:	8c26                	mv	s8,s1
 120:	0014899b          	addiw	s3,s1,1
 124:	84ce                	mv	s1,s3
 126:	0349d463          	bge	s3,s4,14e <gets+0x56>
    cc = read(0, &c, 1);
 12a:	8656                	mv	a2,s5
 12c:	85da                	mv	a1,s6
 12e:	4501                	li	a0,0
 130:	1bc000ef          	jal	2ec <read>
    if(cc < 1)
 134:	00a05d63          	blez	a0,14e <gets+0x56>
      break;
    buf[i++] = c;
 138:	faf44783          	lbu	a5,-81(s0)
 13c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 140:	0905                	addi	s2,s2,1
 142:	ff678713          	addi	a4,a5,-10
 146:	c319                	beqz	a4,14c <gets+0x54>
 148:	17cd                	addi	a5,a5,-13
 14a:	fbf1                	bnez	a5,11e <gets+0x26>
    buf[i++] = c;
 14c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 14e:	9c5e                	add	s8,s8,s7
 150:	000c0023          	sb	zero,0(s8)
  return buf;
}
 154:	855e                	mv	a0,s7
 156:	60e6                	ld	ra,88(sp)
 158:	6446                	ld	s0,80(sp)
 15a:	64a6                	ld	s1,72(sp)
 15c:	6906                	ld	s2,64(sp)
 15e:	79e2                	ld	s3,56(sp)
 160:	7a42                	ld	s4,48(sp)
 162:	7aa2                	ld	s5,40(sp)
 164:	7b02                	ld	s6,32(sp)
 166:	6be2                	ld	s7,24(sp)
 168:	6c42                	ld	s8,16(sp)
 16a:	6125                	addi	sp,sp,96
 16c:	8082                	ret

000000000000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	1101                	addi	sp,sp,-32
 170:	ec06                	sd	ra,24(sp)
 172:	e822                	sd	s0,16(sp)
 174:	e04a                	sd	s2,0(sp)
 176:	1000                	addi	s0,sp,32
 178:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17a:	4581                	li	a1,0
 17c:	198000ef          	jal	314 <open>
  if(fd < 0)
 180:	02054263          	bltz	a0,1a4 <stat+0x36>
 184:	e426                	sd	s1,8(sp)
 186:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 188:	85ca                	mv	a1,s2
 18a:	1a2000ef          	jal	32c <fstat>
 18e:	892a                	mv	s2,a0
  close(fd);
 190:	8526                	mv	a0,s1
 192:	16a000ef          	jal	2fc <close>
  return r;
 196:	64a2                	ld	s1,8(sp)
}
 198:	854a                	mv	a0,s2
 19a:	60e2                	ld	ra,24(sp)
 19c:	6442                	ld	s0,16(sp)
 19e:	6902                	ld	s2,0(sp)
 1a0:	6105                	addi	sp,sp,32
 1a2:	8082                	ret
    return -1;
 1a4:	57fd                	li	a5,-1
 1a6:	893e                	mv	s2,a5
 1a8:	bfc5                	j	198 <stat+0x2a>

00000000000001aa <atoi>:

int
atoi(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b2:	00054683          	lbu	a3,0(a0)
 1b6:	fd06879b          	addiw	a5,a3,-48
 1ba:	0ff7f793          	zext.b	a5,a5
 1be:	4625                	li	a2,9
 1c0:	02f66963          	bltu	a2,a5,1f2 <atoi+0x48>
 1c4:	872a                	mv	a4,a0
  n = 0;
 1c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c8:	0705                	addi	a4,a4,1
 1ca:	0025179b          	slliw	a5,a0,0x2
 1ce:	9fa9                	addw	a5,a5,a0
 1d0:	0017979b          	slliw	a5,a5,0x1
 1d4:	9fb5                	addw	a5,a5,a3
 1d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1da:	00074683          	lbu	a3,0(a4)
 1de:	fd06879b          	addiw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	fef671e3          	bgeu	a2,a5,1c8 <atoi+0x1e>
  return n;
}
 1ea:	60a2                	ld	ra,8(sp)
 1ec:	6402                	ld	s0,0(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  n = 0;
 1f2:	4501                	li	a0,0
 1f4:	bfdd                	j	1ea <atoi+0x40>

00000000000001f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57563          	bgeu	a0,a1,228 <memmove+0x32>
    while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x2a>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20e:	872a                	mv	a4,a0
      *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0705                	addi	a4,a4,1
 214:	fff5c683          	lbu	a3,-1(a1)
 218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21c:	fee79ae3          	bne	a5,a4,210 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 220:	60a2                	ld	ra,8(sp)
 222:	6402                	ld	s0,0(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
    while(n-- > 0)
 228:	fec05ce3          	blez	a2,220 <memmove+0x2a>
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
 232:	fff6079b          	addiw	a5,a2,-1
 236:	1782                	slli	a5,a5,0x20
 238:	9381                	srli	a5,a5,0x20
 23a:	fff7c793          	not	a5,a5
 23e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 240:	15fd                	addi	a1,a1,-1
 242:	177d                	addi	a4,a4,-1
 244:	0005c683          	lbu	a3,0(a1)
 248:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24c:	fef71ae3          	bne	a4,a5,240 <memmove+0x4a>
 250:	bfc1                	j	220 <memmove+0x2a>

0000000000000252 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25a:	c61d                	beqz	a2,288 <memcmp+0x36>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 264:	00054783          	lbu	a5,0(a0)
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00e79863          	bne	a5,a4,27c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 270:	0505                	addi	a0,a0,1
    p2++;
 272:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 274:	fed518e3          	bne	a0,a3,264 <memcmp+0x12>
  }
  return 0;
 278:	4501                	li	a0,0
 27a:	a019                	j	280 <memcmp+0x2e>
      return *p1 - *p2;
 27c:	40e7853b          	subw	a0,a5,a4
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
  return 0;
 288:	4501                	li	a0,0
 28a:	bfdd                	j	280 <memcmp+0x2e>

000000000000028c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 294:	f63ff0ef          	jal	1f6 <memmove>
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <sbrk>:

char *
sbrk(int n) {
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2a8:	4585                	li	a1,1
 2aa:	0b2000ef          	jal	35c <sys_sbrk>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrklazy>:

char *
sbrklazy(int n) {
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2be:	4589                	li	a1,2
 2c0:	09c000ef          	jal	35c <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pause>:
.global pause
pause:
 li a7, SYS_pause
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 374:	48d9                	li	a7,22
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 384:	1101                	addi	sp,sp,-32
 386:	ec06                	sd	ra,24(sp)
 388:	e822                	sd	s0,16(sp)
 38a:	1000                	addi	s0,sp,32
 38c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 390:	4605                	li	a2,1
 392:	fef40593          	addi	a1,s0,-17
 396:	f5fff0ef          	jal	2f4 <write>
}
 39a:	60e2                	ld	ra,24(sp)
 39c:	6442                	ld	s0,16(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret

00000000000003a2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3a2:	715d                	addi	sp,sp,-80
 3a4:	e486                	sd	ra,72(sp)
 3a6:	e0a2                	sd	s0,64(sp)
 3a8:	f84a                	sd	s2,48(sp)
 3aa:	f44e                	sd	s3,40(sp)
 3ac:	0880                	addi	s0,sp,80
 3ae:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3b0:	c6d1                	beqz	a3,43c <printint+0x9a>
 3b2:	0805d563          	bgez	a1,43c <printint+0x9a>
    neg = 1;
    x = -xx;
 3b6:	40b005b3          	neg	a1,a1
    neg = 1;
 3ba:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3bc:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3c0:	86ce                	mv	a3,s3
  i = 0;
 3c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c4:	00000817          	auipc	a6,0x0
 3c8:	52480813          	addi	a6,a6,1316 # 8e8 <digits>
 3cc:	88ba                	mv	a7,a4
 3ce:	0017051b          	addiw	a0,a4,1
 3d2:	872a                	mv	a4,a0
 3d4:	02c5f7b3          	remu	a5,a1,a2
 3d8:	97c2                	add	a5,a5,a6
 3da:	0007c783          	lbu	a5,0(a5)
 3de:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e2:	87ae                	mv	a5,a1
 3e4:	02c5d5b3          	divu	a1,a1,a2
 3e8:	0685                	addi	a3,a3,1
 3ea:	fec7f1e3          	bgeu	a5,a2,3cc <printint+0x2a>
  if(neg)
 3ee:	00030c63          	beqz	t1,406 <printint+0x64>
    buf[i++] = '-';
 3f2:	fd050793          	addi	a5,a0,-48
 3f6:	00878533          	add	a0,a5,s0
 3fa:	02d00793          	li	a5,45
 3fe:	fef50423          	sb	a5,-24(a0)
 402:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 406:	02e05563          	blez	a4,430 <printint+0x8e>
 40a:	fc26                	sd	s1,56(sp)
 40c:	377d                	addiw	a4,a4,-1
 40e:	00e984b3          	add	s1,s3,a4
 412:	19fd                	addi	s3,s3,-1
 414:	99ba                	add	s3,s3,a4
 416:	1702                	slli	a4,a4,0x20
 418:	9301                	srli	a4,a4,0x20
 41a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41e:	0004c583          	lbu	a1,0(s1)
 422:	854a                	mv	a0,s2
 424:	f61ff0ef          	jal	384 <putc>
  while(--i >= 0)
 428:	14fd                	addi	s1,s1,-1
 42a:	ff349ae3          	bne	s1,s3,41e <printint+0x7c>
 42e:	74e2                	ld	s1,56(sp)
}
 430:	60a6                	ld	ra,72(sp)
 432:	6406                	ld	s0,64(sp)
 434:	7942                	ld	s2,48(sp)
 436:	79a2                	ld	s3,40(sp)
 438:	6161                	addi	sp,sp,80
 43a:	8082                	ret
  neg = 0;
 43c:	4301                	li	t1,0
 43e:	bfbd                	j	3bc <printint+0x1a>

0000000000000440 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 440:	711d                	addi	sp,sp,-96
 442:	ec86                	sd	ra,88(sp)
 444:	e8a2                	sd	s0,80(sp)
 446:	e4a6                	sd	s1,72(sp)
 448:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44a:	0005c483          	lbu	s1,0(a1)
 44e:	22048363          	beqz	s1,674 <vprintf+0x234>
 452:	e0ca                	sd	s2,64(sp)
 454:	fc4e                	sd	s3,56(sp)
 456:	f852                	sd	s4,48(sp)
 458:	f456                	sd	s5,40(sp)
 45a:	f05a                	sd	s6,32(sp)
 45c:	ec5e                	sd	s7,24(sp)
 45e:	e862                	sd	s8,16(sp)
 460:	8b2a                	mv	s6,a0
 462:	8a2e                	mv	s4,a1
 464:	8bb2                	mv	s7,a2
  state = 0;
 466:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 468:	4901                	li	s2,0
 46a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 46c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 470:	06400c13          	li	s8,100
 474:	a00d                	j	496 <vprintf+0x56>
        putc(fd, c0);
 476:	85a6                	mv	a1,s1
 478:	855a                	mv	a0,s6
 47a:	f0bff0ef          	jal	384 <putc>
 47e:	a019                	j	484 <vprintf+0x44>
    } else if(state == '%'){
 480:	03598363          	beq	s3,s5,4a6 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 484:	0019079b          	addiw	a5,s2,1
 488:	893e                	mv	s2,a5
 48a:	873e                	mv	a4,a5
 48c:	97d2                	add	a5,a5,s4
 48e:	0007c483          	lbu	s1,0(a5)
 492:	1c048a63          	beqz	s1,666 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 496:	0004879b          	sext.w	a5,s1
    if(state == 0){
 49a:	fe0993e3          	bnez	s3,480 <vprintf+0x40>
      if(c0 == '%'){
 49e:	fd579ce3          	bne	a5,s5,476 <vprintf+0x36>
        state = '%';
 4a2:	89be                	mv	s3,a5
 4a4:	b7c5                	j	484 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a6:	00ea06b3          	add	a3,s4,a4
 4aa:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4ae:	1c060863          	beqz	a2,67e <vprintf+0x23e>
      if(c0 == 'd'){
 4b2:	03878763          	beq	a5,s8,4e0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b6:	f9478693          	addi	a3,a5,-108
 4ba:	0016b693          	seqz	a3,a3
 4be:	f9c60593          	addi	a1,a2,-100
 4c2:	e99d                	bnez	a1,4f8 <vprintf+0xb8>
 4c4:	ca95                	beqz	a3,4f8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4c6:	008b8493          	addi	s1,s7,8
 4ca:	4685                	li	a3,1
 4cc:	4629                	li	a2,10
 4ce:	000bb583          	ld	a1,0(s7)
 4d2:	855a                	mv	a0,s6
 4d4:	ecfff0ef          	jal	3a2 <printint>
        i += 1;
 4d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4da:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4dc:	4981                	li	s3,0
 4de:	b75d                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4e0:	008b8493          	addi	s1,s7,8
 4e4:	4685                	li	a3,1
 4e6:	4629                	li	a2,10
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	855a                	mv	a0,s6
 4ee:	eb5ff0ef          	jal	3a2 <printint>
 4f2:	8ba6                	mv	s7,s1
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	b779                	j	484 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4f8:	9752                	add	a4,a4,s4
 4fa:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4fe:	f9460713          	addi	a4,a2,-108
 502:	00173713          	seqz	a4,a4
 506:	8f75                	and	a4,a4,a3
 508:	f9c58513          	addi	a0,a1,-100
 50c:	18051363          	bnez	a0,692 <vprintf+0x252>
 510:	18070163          	beqz	a4,692 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 514:	008b8493          	addi	s1,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000bb583          	ld	a1,0(s7)
 520:	855a                	mv	a0,s6
 522:	e81ff0ef          	jal	3a2 <printint>
        i += 2;
 526:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 528:	8ba6                	mv	s7,s1
      state = 0;
 52a:	4981                	li	s3,0
        i += 2;
 52c:	bfa1                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 52e:	008b8493          	addi	s1,s7,8
 532:	4681                	li	a3,0
 534:	4629                	li	a2,10
 536:	000be583          	lwu	a1,0(s7)
 53a:	855a                	mv	a0,s6
 53c:	e67ff0ef          	jal	3a2 <printint>
 540:	8ba6                	mv	s7,s1
      state = 0;
 542:	4981                	li	s3,0
 544:	b781                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 546:	008b8493          	addi	s1,s7,8
 54a:	4681                	li	a3,0
 54c:	4629                	li	a2,10
 54e:	000bb583          	ld	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	e4fff0ef          	jal	3a2 <printint>
        i += 1;
 558:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 55a:	8ba6                	mv	s7,s1
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b71d                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 560:	008b8493          	addi	s1,s7,8
 564:	4681                	li	a3,0
 566:	4629                	li	a2,10
 568:	000bb583          	ld	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e35ff0ef          	jal	3a2 <printint>
        i += 2;
 572:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
        i += 2;
 578:	b731                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4681                	li	a3,0
 580:	4641                	li	a2,16
 582:	000be583          	lwu	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e1bff0ef          	jal	3a2 <printint>
 58c:	8ba6                	mv	s7,s1
      state = 0;
 58e:	4981                	li	s3,0
 590:	bdd5                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 592:	008b8493          	addi	s1,s7,8
 596:	4681                	li	a3,0
 598:	4641                	li	a2,16
 59a:	000bb583          	ld	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e03ff0ef          	jal	3a2 <printint>
        i += 1;
 5a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bde9                	j	484 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000bb583          	ld	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	de9ff0ef          	jal	3a2 <printint>
        i += 2;
 5be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
        i += 2;
 5c4:	b5c1                	j	484 <vprintf+0x44>
 5c6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5c8:	008b8793          	addi	a5,s7,8
 5cc:	8cbe                	mv	s9,a5
 5ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	855a                	mv	a0,s6
 5d8:	dadff0ef          	jal	384 <putc>
  putc(fd, 'x');
 5dc:	07800593          	li	a1,120
 5e0:	855a                	mv	a0,s6
 5e2:	da3ff0ef          	jal	384 <putc>
 5e6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e8:	00000b97          	auipc	s7,0x0
 5ec:	300b8b93          	addi	s7,s7,768 # 8e8 <digits>
 5f0:	03c9d793          	srli	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	855a                	mv	a0,s6
 5fc:	d89ff0ef          	jal	384 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 600:	0992                	slli	s3,s3,0x4
 602:	34fd                	addiw	s1,s1,-1
 604:	f4f5                	bnez	s1,5f0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 606:	8be6                	mv	s7,s9
      state = 0;
 608:	4981                	li	s3,0
 60a:	6ca2                	ld	s9,8(sp)
 60c:	bda5                	j	484 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 60e:	008b8493          	addi	s1,s7,8
 612:	000bc583          	lbu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	d6dff0ef          	jal	384 <putc>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	b595                	j	484 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 622:	008b8993          	addi	s3,s7,8
 626:	000bb483          	ld	s1,0(s7)
 62a:	cc91                	beqz	s1,646 <vprintf+0x206>
        for(; *s; s++)
 62c:	0004c583          	lbu	a1,0(s1)
 630:	c985                	beqz	a1,660 <vprintf+0x220>
          putc(fd, *s);
 632:	855a                	mv	a0,s6
 634:	d51ff0ef          	jal	384 <putc>
        for(; *s; s++)
 638:	0485                	addi	s1,s1,1
 63a:	0004c583          	lbu	a1,0(s1)
 63e:	f9f5                	bnez	a1,632 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 640:	8bce                	mv	s7,s3
      state = 0;
 642:	4981                	li	s3,0
 644:	b581                	j	484 <vprintf+0x44>
          s = "(null)";
 646:	00000497          	auipc	s1,0x0
 64a:	29a48493          	addi	s1,s1,666 # 8e0 <malloc+0xfe>
        for(; *s; s++)
 64e:	02800593          	li	a1,40
 652:	b7c5                	j	632 <vprintf+0x1f2>
        putc(fd, '%');
 654:	85be                	mv	a1,a5
 656:	855a                	mv	a0,s6
 658:	d2dff0ef          	jal	384 <putc>
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b51d                	j	484 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 660:	8bce                	mv	s7,s3
      state = 0;
 662:	4981                	li	s3,0
 664:	b505                	j	484 <vprintf+0x44>
 666:	6906                	ld	s2,64(sp)
 668:	79e2                	ld	s3,56(sp)
 66a:	7a42                	ld	s4,48(sp)
 66c:	7aa2                	ld	s5,40(sp)
 66e:	7b02                	ld	s6,32(sp)
 670:	6be2                	ld	s7,24(sp)
 672:	6c42                	ld	s8,16(sp)
    }
  }
}
 674:	60e6                	ld	ra,88(sp)
 676:	6446                	ld	s0,80(sp)
 678:	64a6                	ld	s1,72(sp)
 67a:	6125                	addi	sp,sp,96
 67c:	8082                	ret
      if(c0 == 'd'){
 67e:	06400713          	li	a4,100
 682:	e4e78fe3          	beq	a5,a4,4e0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 686:	f9478693          	addi	a3,a5,-108
 68a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 68e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 690:	4701                	li	a4,0
      } else if(c0 == 'u'){
 692:	07500513          	li	a0,117
 696:	e8a78ce3          	beq	a5,a0,52e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 69a:	f8b60513          	addi	a0,a2,-117
 69e:	e119                	bnez	a0,6a4 <vprintf+0x264>
 6a0:	ea0693e3          	bnez	a3,546 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a4:	f8b58513          	addi	a0,a1,-117
 6a8:	e119                	bnez	a0,6ae <vprintf+0x26e>
 6aa:	ea071be3          	bnez	a4,560 <vprintf+0x120>
      } else if(c0 == 'x'){
 6ae:	07800513          	li	a0,120
 6b2:	eca784e3          	beq	a5,a0,57a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6b6:	f8860613          	addi	a2,a2,-120
 6ba:	e219                	bnez	a2,6c0 <vprintf+0x280>
 6bc:	ec069be3          	bnez	a3,592 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6c0:	f8858593          	addi	a1,a1,-120
 6c4:	e199                	bnez	a1,6ca <vprintf+0x28a>
 6c6:	ee0713e3          	bnez	a4,5ac <vprintf+0x16c>
      } else if(c0 == 'p'){
 6ca:	07000713          	li	a4,112
 6ce:	eee78ce3          	beq	a5,a4,5c6 <vprintf+0x186>
      } else if(c0 == 'c'){
 6d2:	06300713          	li	a4,99
 6d6:	f2e78ce3          	beq	a5,a4,60e <vprintf+0x1ce>
      } else if(c0 == 's'){
 6da:	07300713          	li	a4,115
 6de:	f4e782e3          	beq	a5,a4,622 <vprintf+0x1e2>
      } else if(c0 == '%'){
 6e2:	02500713          	li	a4,37
 6e6:	f6e787e3          	beq	a5,a4,654 <vprintf+0x214>
        putc(fd, '%');
 6ea:	02500593          	li	a1,37
 6ee:	855a                	mv	a0,s6
 6f0:	c95ff0ef          	jal	384 <putc>
        putc(fd, c0);
 6f4:	85a6                	mv	a1,s1
 6f6:	855a                	mv	a0,s6
 6f8:	c8dff0ef          	jal	384 <putc>
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b359                	j	484 <vprintf+0x44>

0000000000000700 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 700:	715d                	addi	sp,sp,-80
 702:	ec06                	sd	ra,24(sp)
 704:	e822                	sd	s0,16(sp)
 706:	1000                	addi	s0,sp,32
 708:	e010                	sd	a2,0(s0)
 70a:	e414                	sd	a3,8(s0)
 70c:	e818                	sd	a4,16(s0)
 70e:	ec1c                	sd	a5,24(s0)
 710:	03043023          	sd	a6,32(s0)
 714:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 718:	8622                	mv	a2,s0
 71a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71e:	d23ff0ef          	jal	440 <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6161                	addi	sp,sp,80
 728:	8082                	ret

000000000000072a <printf>:

void
printf(const char *fmt, ...)
{
 72a:	711d                	addi	sp,sp,-96
 72c:	ec06                	sd	ra,24(sp)
 72e:	e822                	sd	s0,16(sp)
 730:	1000                	addi	s0,sp,32
 732:	e40c                	sd	a1,8(s0)
 734:	e810                	sd	a2,16(s0)
 736:	ec14                	sd	a3,24(s0)
 738:	f018                	sd	a4,32(s0)
 73a:	f41c                	sd	a5,40(s0)
 73c:	03043823          	sd	a6,48(s0)
 740:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	00840613          	addi	a2,s0,8
 748:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74c:	85aa                	mv	a1,a0
 74e:	4505                	li	a0,1
 750:	cf1ff0ef          	jal	440 <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e406                	sd	ra,8(sp)
 760:	e022                	sd	s0,0(sp)
 762:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 764:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	00001797          	auipc	a5,0x1
 76c:	8987b783          	ld	a5,-1896(a5) # 1000 <freep>
 770:	a039                	j	77e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	6398                	ld	a4,0(a5)
 774:	00e7e463          	bltu	a5,a4,77c <free+0x20>
 778:	00e6ea63          	bltu	a3,a4,78c <free+0x30>
{
 77c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	fed7fae3          	bgeu	a5,a3,772 <free+0x16>
 782:	6398                	ld	a4,0(a5)
 784:	00e6e463          	bltu	a3,a4,78c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	fee7eae3          	bltu	a5,a4,77c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 78c:	ff852583          	lw	a1,-8(a0)
 790:	6390                	ld	a2,0(a5)
 792:	02059813          	slli	a6,a1,0x20
 796:	01c85713          	srli	a4,a6,0x1c
 79a:	9736                	add	a4,a4,a3
 79c:	02e60563          	beq	a2,a4,7c6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a4:	4790                	lw	a2,8(a5)
 7a6:	02061593          	slli	a1,a2,0x20
 7aa:	01c5d713          	srli	a4,a1,0x1c
 7ae:	973e                	add	a4,a4,a5
 7b0:	02e68263          	beq	a3,a4,7d4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7b4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b6:	00001717          	auipc	a4,0x1
 7ba:	84f73523          	sd	a5,-1974(a4) # 1000 <freep>
}
 7be:	60a2                	ld	ra,8(sp)
 7c0:	6402                	ld	s0,0(sp)
 7c2:	0141                	addi	sp,sp,16
 7c4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	b7f9                	j	7a0 <free+0x44>
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	bfd1                	j	7b4 <free+0x58>

00000000000007e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e2:	7139                	addi	sp,sp,-64
 7e4:	fc06                	sd	ra,56(sp)
 7e6:	f822                	sd	s0,48(sp)
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	ec4e                	sd	s3,24(sp)
 7ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ee:	02051993          	slli	s3,a0,0x20
 7f2:	0209d993          	srli	s3,s3,0x20
 7f6:	09bd                	addi	s3,s3,15
 7f8:	0049d993          	srli	s3,s3,0x4
 7fc:	2985                	addiw	s3,s3,1
 7fe:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 800:	00001517          	auipc	a0,0x1
 804:	80053503          	ld	a0,-2048(a0) # 1000 <freep>
 808:	c905                	beqz	a0,838 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	09377663          	bgeu	a4,s3,89a <malloc+0xb8>
 812:	f426                	sd	s1,40(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81a:	8a4e                	mv	s4,s3
 81c:	6705                	lui	a4,0x1
 81e:	00e9f363          	bgeu	s3,a4,824 <malloc+0x42>
 822:	6a05                	lui	s4,0x1
 824:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 828:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82c:	00000497          	auipc	s1,0x0
 830:	7d448493          	addi	s1,s1,2004 # 1000 <freep>
  if(p == SBRK_ERROR)
 834:	5afd                	li	s5,-1
 836:	a83d                	j	874 <malloc+0x92>
 838:	f426                	sd	s1,40(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 840:	00000797          	auipc	a5,0x0
 844:	7d078793          	addi	a5,a5,2000 # 1010 <base>
 848:	00000717          	auipc	a4,0x0
 84c:	7af73c23          	sd	a5,1976(a4) # 1000 <freep>
 850:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 852:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 856:	b7d1                	j	81a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	e118                	sd	a4,0(a0)
 85c:	a899                	j	8b2 <malloc+0xd0>
  hp->s.size = nu;
 85e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 862:	0541                	addi	a0,a0,16
 864:	ef9ff0ef          	jal	75c <free>
  return freep;
 868:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 86a:	c125                	beqz	a0,8ca <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86e:	4798                	lw	a4,8(a5)
 870:	03277163          	bgeu	a4,s2,892 <malloc+0xb0>
    if(p == freep)
 874:	6098                	ld	a4,0(s1)
 876:	853e                	mv	a0,a5
 878:	fef71ae3          	bne	a4,a5,86c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 87c:	8552                	mv	a0,s4
 87e:	a23ff0ef          	jal	2a0 <sbrk>
  if(p == SBRK_ERROR)
 882:	fd551ee3          	bne	a0,s5,85e <malloc+0x7c>
        return 0;
 886:	4501                	li	a0,0
 888:	74a2                	ld	s1,40(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
 890:	a03d                	j	8be <malloc+0xdc>
 892:	74a2                	ld	s1,40(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89a:	fae90fe3          	beq	s2,a4,858 <malloc+0x76>
        p->s.size -= nunits;
 89e:	4137073b          	subw	a4,a4,s3
 8a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a4:	02071693          	slli	a3,a4,0x20
 8a8:	01c6d713          	srli	a4,a3,0x1c
 8ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b2:	00000717          	auipc	a4,0x0
 8b6:	74a73723          	sd	a0,1870(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ba:	01078513          	addi	a0,a5,16
  }
}
 8be:	70e2                	ld	ra,56(sp)
 8c0:	7442                	ld	s0,48(sp)
 8c2:	7902                	ld	s2,32(sp)
 8c4:	69e2                	ld	s3,24(sp)
 8c6:	6121                	addi	sp,sp,64
 8c8:	8082                	ret
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	b7f5                	j	8be <malloc+0xdc>
