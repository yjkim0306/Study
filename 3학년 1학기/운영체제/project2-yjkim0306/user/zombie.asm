
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
  12:	2e8000ef          	jal	2fa <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	372000ef          	jal	38a <pause>
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
  2a:	2d0000ef          	jal	2fa <exit>

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
 130:	1e2000ef          	jal	312 <read>
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
 17c:	1be000ef          	jal	33a <open>
  if(fd < 0)
 180:	02054263          	bltz	a0,1a4 <stat+0x36>
 184:	e426                	sd	s1,8(sp)
 186:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 188:	85ca                	mv	a1,s2
 18a:	1c8000ef          	jal	352 <fstat>
 18e:	892a                	mv	s2,a0
  close(fd);
 190:	8526                	mv	a0,s1
 192:	190000ef          	jal	322 <close>
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
 2aa:	0d8000ef          	jal	382 <sys_sbrk>
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
 2c0:	0c2000ef          	jal	382 <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:

int
fork(void)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 2d4:	4701                	li	a4,0
 2d6:	4681                	li	a3,0
 2d8:	4601                	li	a2,0
 2da:	4581                	li	a1,0
 2dc:	4501                	li	a0,0
 2de:	00c000ef          	jal	2ea <clone>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 2ea:	4885                	li	a7,1
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <join>:
.global join
join:
 li a7, SYS_join
 2f2:	48d9                	li	a7,22
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fa:	4889                	li	a7,2
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <wait>:
.global wait
wait:
 li a7, SYS_wait
 302:	488d                	li	a7,3
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30a:	4891                	li	a7,4
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <read>:
.global read
read:
 li a7, SYS_read
 312:	4895                	li	a7,5
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <write>:
.global write
write:
 li a7, SYS_write
 31a:	48c1                	li	a7,16
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <close>:
.global close
close:
 li a7, SYS_close
 322:	48d5                	li	a7,21
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <kill>:
.global kill
kill:
 li a7, SYS_kill
 32a:	4899                	li	a7,6
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exec>:
.global exec
exec:
 li a7, SYS_exec
 332:	489d                	li	a7,7
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <open>:
.global open
open:
 li a7, SYS_open
 33a:	48bd                	li	a7,15
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 342:	48c5                	li	a7,17
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34a:	48c9                	li	a7,18
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 352:	48a1                	li	a7,8
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <link>:
.global link
link:
 li a7, SYS_link
 35a:	48cd                	li	a7,19
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 362:	48d1                	li	a7,20
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36a:	48a5                	li	a7,9
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <dup>:
.global dup
dup:
 li a7, SYS_dup
 372:	48a9                	li	a7,10
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37a:	48ad                	li	a7,11
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 382:	48b1                	li	a7,12
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pause>:
.global pause
pause:
 li a7, SYS_pause
 38a:	48b5                	li	a7,13
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 392:	48b9                	li	a7,14
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39a:	1101                	addi	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	1000                	addi	s0,sp,32
 3a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	fef40593          	addi	a1,s0,-17
 3ac:	f6fff0ef          	jal	31a <write>
}
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret

00000000000003b8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3b8:	715d                	addi	sp,sp,-80
 3ba:	e486                	sd	ra,72(sp)
 3bc:	e0a2                	sd	s0,64(sp)
 3be:	f84a                	sd	s2,48(sp)
 3c0:	f44e                	sd	s3,40(sp)
 3c2:	0880                	addi	s0,sp,80
 3c4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3c6:	c6d1                	beqz	a3,452 <printint+0x9a>
 3c8:	0805d563          	bgez	a1,452 <printint+0x9a>
    neg = 1;
    x = -xx;
 3cc:	40b005b3          	neg	a1,a1
    neg = 1;
 3d0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3d6:	86ce                	mv	a3,s3
  i = 0;
 3d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3da:	00000817          	auipc	a6,0x0
 3de:	5ae80813          	addi	a6,a6,1454 # 988 <digits>
 3e2:	88ba                	mv	a7,a4
 3e4:	0017051b          	addiw	a0,a4,1
 3e8:	872a                	mv	a4,a0
 3ea:	02c5f7b3          	remu	a5,a1,a2
 3ee:	97c2                	add	a5,a5,a6
 3f0:	0007c783          	lbu	a5,0(a5)
 3f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f8:	87ae                	mv	a5,a1
 3fa:	02c5d5b3          	divu	a1,a1,a2
 3fe:	0685                	addi	a3,a3,1
 400:	fec7f1e3          	bgeu	a5,a2,3e2 <printint+0x2a>
  if(neg)
 404:	00030c63          	beqz	t1,41c <printint+0x64>
    buf[i++] = '-';
 408:	fd050793          	addi	a5,a0,-48
 40c:	00878533          	add	a0,a5,s0
 410:	02d00793          	li	a5,45
 414:	fef50423          	sb	a5,-24(a0)
 418:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 41c:	02e05563          	blez	a4,446 <printint+0x8e>
 420:	fc26                	sd	s1,56(sp)
 422:	377d                	addiw	a4,a4,-1
 424:	00e984b3          	add	s1,s3,a4
 428:	19fd                	addi	s3,s3,-1
 42a:	99ba                	add	s3,s3,a4
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 434:	0004c583          	lbu	a1,0(s1)
 438:	854a                	mv	a0,s2
 43a:	f61ff0ef          	jal	39a <putc>
  while(--i >= 0)
 43e:	14fd                	addi	s1,s1,-1
 440:	ff349ae3          	bne	s1,s3,434 <printint+0x7c>
 444:	74e2                	ld	s1,56(sp)
}
 446:	60a6                	ld	ra,72(sp)
 448:	6406                	ld	s0,64(sp)
 44a:	7942                	ld	s2,48(sp)
 44c:	79a2                	ld	s3,40(sp)
 44e:	6161                	addi	sp,sp,80
 450:	8082                	ret
  neg = 0;
 452:	4301                	li	t1,0
 454:	bfbd                	j	3d2 <printint+0x1a>

0000000000000456 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 456:	711d                	addi	sp,sp,-96
 458:	ec86                	sd	ra,88(sp)
 45a:	e8a2                	sd	s0,80(sp)
 45c:	e4a6                	sd	s1,72(sp)
 45e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 460:	0005c483          	lbu	s1,0(a1)
 464:	22048363          	beqz	s1,68a <vprintf+0x234>
 468:	e0ca                	sd	s2,64(sp)
 46a:	fc4e                	sd	s3,56(sp)
 46c:	f852                	sd	s4,48(sp)
 46e:	f456                	sd	s5,40(sp)
 470:	f05a                	sd	s6,32(sp)
 472:	ec5e                	sd	s7,24(sp)
 474:	e862                	sd	s8,16(sp)
 476:	8b2a                	mv	s6,a0
 478:	8a2e                	mv	s4,a1
 47a:	8bb2                	mv	s7,a2
  state = 0;
 47c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47e:	4901                	li	s2,0
 480:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 482:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 486:	06400c13          	li	s8,100
 48a:	a00d                	j	4ac <vprintf+0x56>
        putc(fd, c0);
 48c:	85a6                	mv	a1,s1
 48e:	855a                	mv	a0,s6
 490:	f0bff0ef          	jal	39a <putc>
 494:	a019                	j	49a <vprintf+0x44>
    } else if(state == '%'){
 496:	03598363          	beq	s3,s5,4bc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 49a:	0019079b          	addiw	a5,s2,1
 49e:	893e                	mv	s2,a5
 4a0:	873e                	mv	a4,a5
 4a2:	97d2                	add	a5,a5,s4
 4a4:	0007c483          	lbu	s1,0(a5)
 4a8:	1c048a63          	beqz	s1,67c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ac:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4b0:	fe0993e3          	bnez	s3,496 <vprintf+0x40>
      if(c0 == '%'){
 4b4:	fd579ce3          	bne	a5,s5,48c <vprintf+0x36>
        state = '%';
 4b8:	89be                	mv	s3,a5
 4ba:	b7c5                	j	49a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4bc:	00ea06b3          	add	a3,s4,a4
 4c0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4c4:	1c060863          	beqz	a2,694 <vprintf+0x23e>
      if(c0 == 'd'){
 4c8:	03878763          	beq	a5,s8,4f6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	f9478693          	addi	a3,a5,-108
 4d0:	0016b693          	seqz	a3,a3
 4d4:	f9c60593          	addi	a1,a2,-100
 4d8:	e99d                	bnez	a1,50e <vprintf+0xb8>
 4da:	ca95                	beqz	a3,50e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4dc:	008b8493          	addi	s1,s7,8
 4e0:	4685                	li	a3,1
 4e2:	4629                	li	a2,10
 4e4:	000bb583          	ld	a1,0(s7)
 4e8:	855a                	mv	a0,s6
 4ea:	ecfff0ef          	jal	3b8 <printint>
        i += 1;
 4ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b75d                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4f6:	008b8493          	addi	s1,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	855a                	mv	a0,s6
 504:	eb5ff0ef          	jal	3b8 <printint>
 508:	8ba6                	mv	s7,s1
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b779                	j	49a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 50e:	9752                	add	a4,a4,s4
 510:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 514:	f9460713          	addi	a4,a2,-108
 518:	00173713          	seqz	a4,a4
 51c:	8f75                	and	a4,a4,a3
 51e:	f9c58513          	addi	a0,a1,-100
 522:	18051363          	bnez	a0,6a8 <vprintf+0x252>
 526:	18070163          	beqz	a4,6a8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52a:	008b8493          	addi	s1,s7,8
 52e:	4685                	li	a3,1
 530:	4629                	li	a2,10
 532:	000bb583          	ld	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e81ff0ef          	jal	3b8 <printint>
        i += 2;
 53c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	8ba6                	mv	s7,s1
      state = 0;
 540:	4981                	li	s3,0
        i += 2;
 542:	bfa1                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 544:	008b8493          	addi	s1,s7,8
 548:	4681                	li	a3,0
 54a:	4629                	li	a2,10
 54c:	000be583          	lwu	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e67ff0ef          	jal	3b8 <printint>
 556:	8ba6                	mv	s7,s1
      state = 0;
 558:	4981                	li	s3,0
 55a:	b781                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55c:	008b8493          	addi	s1,s7,8
 560:	4681                	li	a3,0
 562:	4629                	li	a2,10
 564:	000bb583          	ld	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e4fff0ef          	jal	3b8 <printint>
        i += 1;
 56e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
 574:	b71d                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b8493          	addi	s1,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000bb583          	ld	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e35ff0ef          	jal	3b8 <printint>
        i += 2;
 588:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
        i += 2;
 58e:	b731                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 590:	008b8493          	addi	s1,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000be583          	lwu	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e1bff0ef          	jal	3b8 <printint>
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bdd5                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e03ff0ef          	jal	3b8 <printint>
        i += 1;
 5ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bde9                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	de9ff0ef          	jal	3b8 <printint>
        i += 2;
 5d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	b5c1                	j	49a <vprintf+0x44>
 5dc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5de:	008b8793          	addi	a5,s7,8
 5e2:	8cbe                	mv	s9,a5
 5e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e8:	03000593          	li	a1,48
 5ec:	855a                	mv	a0,s6
 5ee:	dadff0ef          	jal	39a <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	855a                	mv	a0,s6
 5f8:	da3ff0ef          	jal	39a <putc>
 5fc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fe:	00000b97          	auipc	s7,0x0
 602:	38ab8b93          	addi	s7,s7,906 # 988 <digits>
 606:	03c9d793          	srli	a5,s3,0x3c
 60a:	97de                	add	a5,a5,s7
 60c:	0007c583          	lbu	a1,0(a5)
 610:	855a                	mv	a0,s6
 612:	d89ff0ef          	jal	39a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	34fd                	addiw	s1,s1,-1
 61a:	f4f5                	bnez	s1,606 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 61c:	8be6                	mv	s7,s9
      state = 0;
 61e:	4981                	li	s3,0
 620:	6ca2                	ld	s9,8(sp)
 622:	bda5                	j	49a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 624:	008b8493          	addi	s1,s7,8
 628:	000bc583          	lbu	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	d6dff0ef          	jal	39a <putc>
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	b595                	j	49a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 638:	008b8993          	addi	s3,s7,8
 63c:	000bb483          	ld	s1,0(s7)
 640:	cc91                	beqz	s1,65c <vprintf+0x206>
        for(; *s; s++)
 642:	0004c583          	lbu	a1,0(s1)
 646:	c985                	beqz	a1,676 <vprintf+0x220>
          putc(fd, *s);
 648:	855a                	mv	a0,s6
 64a:	d51ff0ef          	jal	39a <putc>
        for(; *s; s++)
 64e:	0485                	addi	s1,s1,1
 650:	0004c583          	lbu	a1,0(s1)
 654:	f9f5                	bnez	a1,648 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 656:	8bce                	mv	s7,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	b581                	j	49a <vprintf+0x44>
          s = "(null)";
 65c:	00000497          	auipc	s1,0x0
 660:	32448493          	addi	s1,s1,804 # 980 <thread_join+0x40>
        for(; *s; s++)
 664:	02800593          	li	a1,40
 668:	b7c5                	j	648 <vprintf+0x1f2>
        putc(fd, '%');
 66a:	85be                	mv	a1,a5
 66c:	855a                	mv	a0,s6
 66e:	d2dff0ef          	jal	39a <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	b51d                	j	49a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	b505                	j	49a <vprintf+0x44>
 67c:	6906                	ld	s2,64(sp)
 67e:	79e2                	ld	s3,56(sp)
 680:	7a42                	ld	s4,48(sp)
 682:	7aa2                	ld	s5,40(sp)
 684:	7b02                	ld	s6,32(sp)
 686:	6be2                	ld	s7,24(sp)
 688:	6c42                	ld	s8,16(sp)
    }
  }
}
 68a:	60e6                	ld	ra,88(sp)
 68c:	6446                	ld	s0,80(sp)
 68e:	64a6                	ld	s1,72(sp)
 690:	6125                	addi	sp,sp,96
 692:	8082                	ret
      if(c0 == 'd'){
 694:	06400713          	li	a4,100
 698:	e4e78fe3          	beq	a5,a4,4f6 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	f9478693          	addi	a3,a5,-108
 6a0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6a4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6a8:	07500513          	li	a0,117
 6ac:	e8a78ce3          	beq	a5,a0,544 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6b0:	f8b60513          	addi	a0,a2,-117
 6b4:	e119                	bnez	a0,6ba <vprintf+0x264>
 6b6:	ea0693e3          	bnez	a3,55c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ba:	f8b58513          	addi	a0,a1,-117
 6be:	e119                	bnez	a0,6c4 <vprintf+0x26e>
 6c0:	ea071be3          	bnez	a4,576 <vprintf+0x120>
      } else if(c0 == 'x'){
 6c4:	07800513          	li	a0,120
 6c8:	eca784e3          	beq	a5,a0,590 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6cc:	f8860613          	addi	a2,a2,-120
 6d0:	e219                	bnez	a2,6d6 <vprintf+0x280>
 6d2:	ec069be3          	bnez	a3,5a8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d6:	f8858593          	addi	a1,a1,-120
 6da:	e199                	bnez	a1,6e0 <vprintf+0x28a>
 6dc:	ee0713e3          	bnez	a4,5c2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6e0:	07000713          	li	a4,112
 6e4:	eee78ce3          	beq	a5,a4,5dc <vprintf+0x186>
      } else if(c0 == 'c'){
 6e8:	06300713          	li	a4,99
 6ec:	f2e78ce3          	beq	a5,a4,624 <vprintf+0x1ce>
      } else if(c0 == 's'){
 6f0:	07300713          	li	a4,115
 6f4:	f4e782e3          	beq	a5,a4,638 <vprintf+0x1e2>
      } else if(c0 == '%'){
 6f8:	02500713          	li	a4,37
 6fc:	f6e787e3          	beq	a5,a4,66a <vprintf+0x214>
        putc(fd, '%');
 700:	02500593          	li	a1,37
 704:	855a                	mv	a0,s6
 706:	c95ff0ef          	jal	39a <putc>
        putc(fd, c0);
 70a:	85a6                	mv	a1,s1
 70c:	855a                	mv	a0,s6
 70e:	c8dff0ef          	jal	39a <putc>
      state = 0;
 712:	4981                	li	s3,0
 714:	b359                	j	49a <vprintf+0x44>

0000000000000716 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 716:	715d                	addi	sp,sp,-80
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e010                	sd	a2,0(s0)
 720:	e414                	sd	a3,8(s0)
 722:	e818                	sd	a4,16(s0)
 724:	ec1c                	sd	a5,24(s0)
 726:	03043023          	sd	a6,32(s0)
 72a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	8622                	mv	a2,s0
 730:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 734:	d23ff0ef          	jal	456 <vprintf>
}
 738:	60e2                	ld	ra,24(sp)
 73a:	6442                	ld	s0,16(sp)
 73c:	6161                	addi	sp,sp,80
 73e:	8082                	ret

0000000000000740 <printf>:

void
printf(const char *fmt, ...)
{
 740:	711d                	addi	sp,sp,-96
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e40c                	sd	a1,8(s0)
 74a:	e810                	sd	a2,16(s0)
 74c:	ec14                	sd	a3,24(s0)
 74e:	f018                	sd	a4,32(s0)
 750:	f41c                	sd	a5,40(s0)
 752:	03043823          	sd	a6,48(s0)
 756:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75a:	00840613          	addi	a2,s0,8
 75e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 762:	85aa                	mv	a1,a0
 764:	4505                	li	a0,1
 766:	cf1ff0ef          	jal	456 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6125                	addi	sp,sp,96
 770:	8082                	ret

0000000000000772 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 772:	1141                	addi	sp,sp,-16
 774:	e406                	sd	ra,8(sp)
 776:	e022                	sd	s0,0(sp)
 778:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	00001797          	auipc	a5,0x1
 782:	8827b783          	ld	a5,-1918(a5) # 1000 <freep>
 786:	a039                	j	794 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	6398                	ld	a4,0(a5)
 78a:	00e7e463          	bltu	a5,a4,792 <free+0x20>
 78e:	00e6ea63          	bltu	a3,a4,7a2 <free+0x30>
{
 792:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	fed7fae3          	bgeu	a5,a3,788 <free+0x16>
 798:	6398                	ld	a4,0(a5)
 79a:	00e6e463          	bltu	a3,a4,7a2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	fee7eae3          	bltu	a5,a4,792 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a2:	ff852583          	lw	a1,-8(a0)
 7a6:	6390                	ld	a2,0(a5)
 7a8:	02059813          	slli	a6,a1,0x20
 7ac:	01c85713          	srli	a4,a6,0x1c
 7b0:	9736                	add	a4,a4,a3
 7b2:	02e60563          	beq	a2,a4,7dc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7ba:	4790                	lw	a2,8(a5)
 7bc:	02061593          	slli	a1,a2,0x20
 7c0:	01c5d713          	srli	a4,a1,0x1c
 7c4:	973e                	add	a4,a4,a5
 7c6:	02e68263          	beq	a3,a4,7ea <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
}
 7d4:	60a2                	ld	ra,8(sp)
 7d6:	6402                	ld	s0,0(sp)
 7d8:	0141                	addi	sp,sp,16
 7da:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7dc:	4618                	lw	a4,8(a2)
 7de:	9f2d                	addw	a4,a4,a1
 7e0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	6398                	ld	a4,0(a5)
 7e6:	6310                	ld	a2,0(a4)
 7e8:	b7f9                	j	7b6 <free+0x44>
    p->s.size += bp->s.size;
 7ea:	ff852703          	lw	a4,-8(a0)
 7ee:	9f31                	addw	a4,a4,a2
 7f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f2:	ff053683          	ld	a3,-16(a0)
 7f6:	bfd1                	j	7ca <free+0x58>

00000000000007f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f8:	7139                	addi	sp,sp,-64
 7fa:	fc06                	sd	ra,56(sp)
 7fc:	f822                	sd	s0,48(sp)
 7fe:	f04a                	sd	s2,32(sp)
 800:	ec4e                	sd	s3,24(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051993          	slli	s3,a0,0x20
 808:	0209d993          	srli	s3,s3,0x20
 80c:	09bd                	addi	s3,s3,15
 80e:	0049d993          	srli	s3,s3,0x4
 812:	2985                	addiw	s3,s3,1
 814:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 816:	00000517          	auipc	a0,0x0
 81a:	7ea53503          	ld	a0,2026(a0) # 1000 <freep>
 81e:	c905                	beqz	a0,84e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 822:	4798                	lw	a4,8(a5)
 824:	09377663          	bgeu	a4,s3,8b0 <malloc+0xb8>
 828:	f426                	sd	s1,40(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	6705                	lui	a4,0x1
 834:	00e9f363          	bgeu	s3,a4,83a <malloc+0x42>
 838:	6a05                	lui	s4,0x1
 83a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 842:	00000497          	auipc	s1,0x0
 846:	7be48493          	addi	s1,s1,1982 # 1000 <freep>
  if(p == SBRK_ERROR)
 84a:	5afd                	li	s5,-1
 84c:	a83d                	j	88a <malloc+0x92>
 84e:	f426                	sd	s1,40(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 856:	00000797          	auipc	a5,0x0
 85a:	7ba78793          	addi	a5,a5,1978 # 1010 <base>
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
 866:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 868:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 86c:	b7d1                	j	830 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	e118                	sd	a4,0(a0)
 872:	a899                	j	8c8 <malloc+0xd0>
  hp->s.size = nu;
 874:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 878:	0541                	addi	a0,a0,16
 87a:	ef9ff0ef          	jal	772 <free>
  return freep;
 87e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 880:	c125                	beqz	a0,8e0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	03277163          	bgeu	a4,s2,8a8 <malloc+0xb0>
    if(p == freep)
 88a:	6098                	ld	a4,0(s1)
 88c:	853e                	mv	a0,a5
 88e:	fef71ae3          	bne	a4,a5,882 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 892:	8552                	mv	a0,s4
 894:	a0dff0ef          	jal	2a0 <sbrk>
  if(p == SBRK_ERROR)
 898:	fd551ee3          	bne	a0,s5,874 <malloc+0x7c>
        return 0;
 89c:	4501                	li	a0,0
 89e:	74a2                	ld	s1,40(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	a03d                	j	8d4 <malloc+0xdc>
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b0:	fae90fe3          	beq	s2,a4,86e <malloc+0x76>
        p->s.size -= nunits;
 8b4:	4137073b          	subw	a4,a4,s3
 8b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ba:	02071693          	slli	a3,a4,0x20
 8be:	01c6d713          	srli	a4,a3,0x1c
 8c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c8:	00000717          	auipc	a4,0x0
 8cc:	72a73c23          	sd	a0,1848(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d0:	01078513          	addi	a0,a5,16
  }
}
 8d4:	70e2                	ld	ra,56(sp)
 8d6:	7442                	ld	s0,48(sp)
 8d8:	7902                	ld	s2,32(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6121                	addi	sp,sp,64
 8de:	8082                	ret
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	b7f5                	j	8d4 <malloc+0xdc>

00000000000008ea <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 8ea:	7179                	addi	sp,sp,-48
 8ec:	f406                	sd	ra,40(sp)
 8ee:	f022                	sd	s0,32(sp)
 8f0:	ec26                	sd	s1,24(sp)
 8f2:	e84a                	sd	s2,16(sp)
 8f4:	e44e                	sd	s3,8(sp)
 8f6:	1800                	addi	s0,sp,48
 8f8:	89aa                	mv	s3,a0
 8fa:	892e                	mv	s2,a1
 8fc:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 8fe:	00c6151b          	slliw	a0,a2,0xc
 902:	ef7ff0ef          	jal	7f8 <malloc>
  if(stack == 0) return -1;
 906:	c91d                	beqz	a0,93c <thread_create+0x52>
 908:	e052                	sd	s4,0(sp)
 90a:	862a                	mv	a2,a0
 90c:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 90e:	10000713          	li	a4,256
 912:	86a6                	mv	a3,s1
 914:	85ca                	mv	a1,s2
 916:	854e                	mv	a0,s3
 918:	9d3ff0ef          	jal	2ea <clone>

  if(pid < 0) {
 91c:	00054a63          	bltz	a0,930 <thread_create+0x46>
 920:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 922:	70a2                	ld	ra,40(sp)
 924:	7402                	ld	s0,32(sp)
 926:	64e2                	ld	s1,24(sp)
 928:	6942                	ld	s2,16(sp)
 92a:	69a2                	ld	s3,8(sp)
 92c:	6145                	addi	sp,sp,48
 92e:	8082                	ret
    free(stack);
 930:	8552                	mv	a0,s4
 932:	e41ff0ef          	jal	772 <free>
    return -1;
 936:	557d                	li	a0,-1
 938:	6a02                	ld	s4,0(sp)
 93a:	b7e5                	j	922 <thread_create+0x38>
  if(stack == 0) return -1;
 93c:	557d                	li	a0,-1
 93e:	b7d5                	j	922 <thread_create+0x38>

0000000000000940 <thread_join>:

int
thread_join(void)
{
 940:	7179                	addi	sp,sp,-48
 942:	f406                	sd	ra,40(sp)
 944:	f022                	sd	s0,32(sp)
 946:	ec26                	sd	s1,24(sp)
 948:	1800                	addi	s0,sp,48
  void *stack = 0;
 94a:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 94e:	fd840513          	addi	a0,s0,-40
 952:	9a1ff0ef          	jal	2f2 <join>
 956:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 958:	00a05763          	blez	a0,966 <thread_join+0x26>
 95c:	fd843503          	ld	a0,-40(s0)
 960:	c119                	beqz	a0,966 <thread_join+0x26>
    free(stack);
 962:	e11ff0ef          	jal	772 <free>
  }
  return pid;
}
 966:	8526                	mv	a0,s1
 968:	70a2                	ld	ra,40(sp)
 96a:	7402                	ld	s0,32(sp)
 96c:	64e2                	ld	s1,24(sp)
 96e:	6145                	addi	sp,sp,48
 970:	8082                	ret
