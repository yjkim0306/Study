
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	9a058593          	addi	a1,a1,-1632 # 9b0 <thread_join+0x40>
  18:	4509                	li	a0,2
  1a:	72c000ef          	jal	746 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	30a000ef          	jal	32a <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	35e000ef          	jal	38a <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2f4000ef          	jal	32a <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	98a58593          	addi	a1,a1,-1654 # 9c8 <thread_join+0x58>
  46:	4509                	li	a0,2
  48:	6fe000ef          	jal	746 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2d0000ef          	jal	32a <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf81                	beqz	a5,124 <strchr+0x24>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strchr+0x1c>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	e862                	sd	s8,16(sp)
 13e:	1080                	addi	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
 148:	faf40b13          	addi	s6,s0,-81
 14c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 14e:	8c26                	mv	s8,s1
 150:	0014899b          	addiw	s3,s1,1
 154:	84ce                	mv	s1,s3
 156:	0349d463          	bge	s3,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 15a:	8656                	mv	a2,s5
 15c:	85da                	mv	a1,s6
 15e:	4501                	li	a0,0
 160:	1e2000ef          	jal	342 <read>
    if(cc < 1)
 164:	00a05d63          	blez	a0,17e <gets+0x56>
      break;
    buf[i++] = c;
 168:	faf44783          	lbu	a5,-81(s0)
 16c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 170:	0905                	addi	s2,s2,1
 172:	ff678713          	addi	a4,a5,-10
 176:	c319                	beqz	a4,17c <gets+0x54>
 178:	17cd                	addi	a5,a5,-13
 17a:	fbf1                	bnez	a5,14e <gets+0x26>
    buf[i++] = c;
 17c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 17e:	9c5e                	add	s8,s8,s7
 180:	000c0023          	sb	zero,0(s8)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6c42                	ld	s8,16(sp)
 19a:	6125                	addi	sp,sp,96
 19c:	8082                	ret

000000000000019e <stat>:

int
stat(const char *n, struct stat *st)
{
 19e:	1101                	addi	sp,sp,-32
 1a0:	ec06                	sd	ra,24(sp)
 1a2:	e822                	sd	s0,16(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	1be000ef          	jal	36a <open>
  if(fd < 0)
 1b0:	02054263          	bltz	a0,1d4 <stat+0x36>
 1b4:	e426                	sd	s1,8(sp)
 1b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b8:	85ca                	mv	a1,s2
 1ba:	1c8000ef          	jal	382 <fstat>
 1be:	892a                	mv	s2,a0
  close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	190000ef          	jal	352 <close>
  return r;
 1c6:	64a2                	ld	s1,8(sp)
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	57fd                	li	a5,-1
 1d6:	893e                	mv	s2,a5
 1d8:	bfc5                	j	1c8 <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	00054683          	lbu	a3,0(a0)
 1e6:	fd06879b          	addiw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	4625                	li	a2,9
 1f0:	02f66963          	bltu	a2,a5,222 <atoi+0x48>
 1f4:	872a                	mv	a4,a0
  n = 0;
 1f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f8:	0705                	addi	a4,a4,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb5                	addw	a5,a5,a3
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	00074683          	lbu	a3,0(a4)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	fef671e3          	bgeu	a2,a5,1f8 <atoi+0x1e>
  return n;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <atoi+0x40>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22e:	02b57563          	bgeu	a0,a1,258 <memmove+0x32>
    while(n-- > 0)
 232:	00c05f63          	blez	a2,250 <memmove+0x2a>
 236:	1602                	slli	a2,a2,0x20
 238:	9201                	srli	a2,a2,0x20
 23a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23e:	872a                	mv	a4,a0
      *dst++ = *src++;
 240:	0585                	addi	a1,a1,1
 242:	0705                	addi	a4,a4,1
 244:	fff5c683          	lbu	a3,-1(a1)
 248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24c:	fee79ae3          	bne	a5,a4,240 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    while(n-- > 0)
 258:	fec05ce3          	blez	a2,250 <memmove+0x2a>
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fef71ae3          	bne	a4,a5,270 <memmove+0x4a>
 280:	bfc1                	j	250 <memmove+0x2a>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28a:	c61d                	beqz	a2,2b8 <memcmp+0x36>
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 294:	00054783          	lbu	a5,0(a0)
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00e79863          	bne	a5,a4,2ac <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a0:	0505                	addi	a0,a0,1
    p2++;
 2a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a4:	fed518e3          	bne	a0,a3,294 <memcmp+0x12>
  }
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	a019                	j	2b0 <memcmp+0x2e>
      return *p1 - *p2;
 2ac:	40e7853b          	subw	a0,a5,a4
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfdd                	j	2b0 <memcmp+0x2e>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f63ff0ef          	jal	226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n) {
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0d8000ef          	jal	3b2 <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n) {
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	0c2000ef          	jal	3b2 <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:

int
fork(void)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 304:	4701                	li	a4,0
 306:	4681                	li	a3,0
 308:	4601                	li	a2,0
 30a:	4581                	li	a1,0
 30c:	4501                	li	a0,0
 30e:	00c000ef          	jal	31a <clone>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <join>:
.global join
join:
 li a7, SYS_join
 322:	48d9                	li	a7,22
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	1000                	addi	s0,sp,32
 3d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d6:	4605                	li	a2,1
 3d8:	fef40593          	addi	a1,s0,-17
 3dc:	f6fff0ef          	jal	34a <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	addi	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3e8:	715d                	addi	sp,sp,-80
 3ea:	e486                	sd	ra,72(sp)
 3ec:	e0a2                	sd	s0,64(sp)
 3ee:	f84a                	sd	s2,48(sp)
 3f0:	f44e                	sd	s3,40(sp)
 3f2:	0880                	addi	s0,sp,80
 3f4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3f6:	c6d1                	beqz	a3,482 <printint+0x9a>
 3f8:	0805d563          	bgez	a1,482 <printint+0x9a>
    neg = 1;
    x = -xx;
 3fc:	40b005b3          	neg	a1,a1
    neg = 1;
 400:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 402:	fb840993          	addi	s3,s0,-72
  neg = 0;
 406:	86ce                	mv	a3,s3
  i = 0;
 408:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40a:	00000817          	auipc	a6,0x0
 40e:	5de80813          	addi	a6,a6,1502 # 9e8 <digits>
 412:	88ba                	mv	a7,a4
 414:	0017051b          	addiw	a0,a4,1
 418:	872a                	mv	a4,a0
 41a:	02c5f7b3          	remu	a5,a1,a2
 41e:	97c2                	add	a5,a5,a6
 420:	0007c783          	lbu	a5,0(a5)
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	87ae                	mv	a5,a1
 42a:	02c5d5b3          	divu	a1,a1,a2
 42e:	0685                	addi	a3,a3,1
 430:	fec7f1e3          	bgeu	a5,a2,412 <printint+0x2a>
  if(neg)
 434:	00030c63          	beqz	t1,44c <printint+0x64>
    buf[i++] = '-';
 438:	fd050793          	addi	a5,a0,-48
 43c:	00878533          	add	a0,a5,s0
 440:	02d00793          	li	a5,45
 444:	fef50423          	sb	a5,-24(a0)
 448:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 44c:	02e05563          	blez	a4,476 <printint+0x8e>
 450:	fc26                	sd	s1,56(sp)
 452:	377d                	addiw	a4,a4,-1
 454:	00e984b3          	add	s1,s3,a4
 458:	19fd                	addi	s3,s3,-1
 45a:	99ba                	add	s3,s3,a4
 45c:	1702                	slli	a4,a4,0x20
 45e:	9301                	srli	a4,a4,0x20
 460:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 464:	0004c583          	lbu	a1,0(s1)
 468:	854a                	mv	a0,s2
 46a:	f61ff0ef          	jal	3ca <putc>
  while(--i >= 0)
 46e:	14fd                	addi	s1,s1,-1
 470:	ff349ae3          	bne	s1,s3,464 <printint+0x7c>
 474:	74e2                	ld	s1,56(sp)
}
 476:	60a6                	ld	ra,72(sp)
 478:	6406                	ld	s0,64(sp)
 47a:	7942                	ld	s2,48(sp)
 47c:	79a2                	ld	s3,40(sp)
 47e:	6161                	addi	sp,sp,80
 480:	8082                	ret
  neg = 0;
 482:	4301                	li	t1,0
 484:	bfbd                	j	402 <printint+0x1a>

0000000000000486 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 486:	711d                	addi	sp,sp,-96
 488:	ec86                	sd	ra,88(sp)
 48a:	e8a2                	sd	s0,80(sp)
 48c:	e4a6                	sd	s1,72(sp)
 48e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 490:	0005c483          	lbu	s1,0(a1)
 494:	22048363          	beqz	s1,6ba <vprintf+0x234>
 498:	e0ca                	sd	s2,64(sp)
 49a:	fc4e                	sd	s3,56(sp)
 49c:	f852                	sd	s4,48(sp)
 49e:	f456                	sd	s5,40(sp)
 4a0:	f05a                	sd	s6,32(sp)
 4a2:	ec5e                	sd	s7,24(sp)
 4a4:	e862                	sd	s8,16(sp)
 4a6:	8b2a                	mv	s6,a0
 4a8:	8a2e                	mv	s4,a1
 4aa:	8bb2                	mv	s7,a2
  state = 0;
 4ac:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ae:	4901                	li	s2,0
 4b0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b6:	06400c13          	li	s8,100
 4ba:	a00d                	j	4dc <vprintf+0x56>
        putc(fd, c0);
 4bc:	85a6                	mv	a1,s1
 4be:	855a                	mv	a0,s6
 4c0:	f0bff0ef          	jal	3ca <putc>
 4c4:	a019                	j	4ca <vprintf+0x44>
    } else if(state == '%'){
 4c6:	03598363          	beq	s3,s5,4ec <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4ca:	0019079b          	addiw	a5,s2,1
 4ce:	893e                	mv	s2,a5
 4d0:	873e                	mv	a4,a5
 4d2:	97d2                	add	a5,a5,s4
 4d4:	0007c483          	lbu	s1,0(a5)
 4d8:	1c048a63          	beqz	s1,6ac <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4dc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4e0:	fe0993e3          	bnez	s3,4c6 <vprintf+0x40>
      if(c0 == '%'){
 4e4:	fd579ce3          	bne	a5,s5,4bc <vprintf+0x36>
        state = '%';
 4e8:	89be                	mv	s3,a5
 4ea:	b7c5                	j	4ca <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ec:	00ea06b3          	add	a3,s4,a4
 4f0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4f4:	1c060863          	beqz	a2,6c4 <vprintf+0x23e>
      if(c0 == 'd'){
 4f8:	03878763          	beq	a5,s8,526 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4fc:	f9478693          	addi	a3,a5,-108
 500:	0016b693          	seqz	a3,a3
 504:	f9c60593          	addi	a1,a2,-100
 508:	e99d                	bnez	a1,53e <vprintf+0xb8>
 50a:	ca95                	beqz	a3,53e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	008b8493          	addi	s1,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000bb583          	ld	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	ecfff0ef          	jal	3e8 <printint>
        i += 1;
 51e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 520:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 522:	4981                	li	s3,0
 524:	b75d                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 526:	008b8493          	addi	s1,s7,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000ba583          	lw	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	eb5ff0ef          	jal	3e8 <printint>
 538:	8ba6                	mv	s7,s1
      state = 0;
 53a:	4981                	li	s3,0
 53c:	b779                	j	4ca <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 53e:	9752                	add	a4,a4,s4
 540:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 544:	f9460713          	addi	a4,a2,-108
 548:	00173713          	seqz	a4,a4
 54c:	8f75                	and	a4,a4,a3
 54e:	f9c58513          	addi	a0,a1,-100
 552:	18051363          	bnez	a0,6d8 <vprintf+0x252>
 556:	18070163          	beqz	a4,6d8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000bb583          	ld	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e81ff0ef          	jal	3e8 <printint>
        i += 2;
 56c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
        i += 2;
 572:	bfa1                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 574:	008b8493          	addi	s1,s7,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000be583          	lwu	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e67ff0ef          	jal	3e8 <printint>
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	b781                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000bb583          	ld	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e4fff0ef          	jal	3e8 <printint>
        i += 1;
 59e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b71d                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000bb583          	ld	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	e35ff0ef          	jal	3e8 <printint>
        i += 2;
 5b8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
        i += 2;
 5be:	b731                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000be583          	lwu	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e1bff0ef          	jal	3e8 <printint>
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bdd5                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e03ff0ef          	jal	3e8 <printint>
        i += 1;
 5ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bde9                	j	4ca <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	de9ff0ef          	jal	3e8 <printint>
        i += 2;
 604:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	b5c1                	j	4ca <vprintf+0x44>
 60c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 60e:	008b8793          	addi	a5,s7,8
 612:	8cbe                	mv	s9,a5
 614:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 618:	03000593          	li	a1,48
 61c:	855a                	mv	a0,s6
 61e:	dadff0ef          	jal	3ca <putc>
  putc(fd, 'x');
 622:	07800593          	li	a1,120
 626:	855a                	mv	a0,s6
 628:	da3ff0ef          	jal	3ca <putc>
 62c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62e:	00000b97          	auipc	s7,0x0
 632:	3bab8b93          	addi	s7,s7,954 # 9e8 <digits>
 636:	03c9d793          	srli	a5,s3,0x3c
 63a:	97de                	add	a5,a5,s7
 63c:	0007c583          	lbu	a1,0(a5)
 640:	855a                	mv	a0,s6
 642:	d89ff0ef          	jal	3ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 646:	0992                	slli	s3,s3,0x4
 648:	34fd                	addiw	s1,s1,-1
 64a:	f4f5                	bnez	s1,636 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 64c:	8be6                	mv	s7,s9
      state = 0;
 64e:	4981                	li	s3,0
 650:	6ca2                	ld	s9,8(sp)
 652:	bda5                	j	4ca <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 654:	008b8493          	addi	s1,s7,8
 658:	000bc583          	lbu	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d6dff0ef          	jal	3ca <putc>
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
 666:	b595                	j	4ca <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 668:	008b8993          	addi	s3,s7,8
 66c:	000bb483          	ld	s1,0(s7)
 670:	cc91                	beqz	s1,68c <vprintf+0x206>
        for(; *s; s++)
 672:	0004c583          	lbu	a1,0(s1)
 676:	c985                	beqz	a1,6a6 <vprintf+0x220>
          putc(fd, *s);
 678:	855a                	mv	a0,s6
 67a:	d51ff0ef          	jal	3ca <putc>
        for(; *s; s++)
 67e:	0485                	addi	s1,s1,1
 680:	0004c583          	lbu	a1,0(s1)
 684:	f9f5                	bnez	a1,678 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 686:	8bce                	mv	s7,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	b581                	j	4ca <vprintf+0x44>
          s = "(null)";
 68c:	00000497          	auipc	s1,0x0
 690:	35448493          	addi	s1,s1,852 # 9e0 <thread_join+0x70>
        for(; *s; s++)
 694:	02800593          	li	a1,40
 698:	b7c5                	j	678 <vprintf+0x1f2>
        putc(fd, '%');
 69a:	85be                	mv	a1,a5
 69c:	855a                	mv	a0,s6
 69e:	d2dff0ef          	jal	3ca <putc>
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b51d                	j	4ca <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a6:	8bce                	mv	s7,s3
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b505                	j	4ca <vprintf+0x44>
 6ac:	6906                	ld	s2,64(sp)
 6ae:	79e2                	ld	s3,56(sp)
 6b0:	7a42                	ld	s4,48(sp)
 6b2:	7aa2                	ld	s5,40(sp)
 6b4:	7b02                	ld	s6,32(sp)
 6b6:	6be2                	ld	s7,24(sp)
 6b8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6ba:	60e6                	ld	ra,88(sp)
 6bc:	6446                	ld	s0,80(sp)
 6be:	64a6                	ld	s1,72(sp)
 6c0:	6125                	addi	sp,sp,96
 6c2:	8082                	ret
      if(c0 == 'd'){
 6c4:	06400713          	li	a4,100
 6c8:	e4e78fe3          	beq	a5,a4,526 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6cc:	f9478693          	addi	a3,a5,-108
 6d0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6d4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6d8:	07500513          	li	a0,117
 6dc:	e8a78ce3          	beq	a5,a0,574 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6e0:	f8b60513          	addi	a0,a2,-117
 6e4:	e119                	bnez	a0,6ea <vprintf+0x264>
 6e6:	ea0693e3          	bnez	a3,58c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ea:	f8b58513          	addi	a0,a1,-117
 6ee:	e119                	bnez	a0,6f4 <vprintf+0x26e>
 6f0:	ea071be3          	bnez	a4,5a6 <vprintf+0x120>
      } else if(c0 == 'x'){
 6f4:	07800513          	li	a0,120
 6f8:	eca784e3          	beq	a5,a0,5c0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6fc:	f8860613          	addi	a2,a2,-120
 700:	e219                	bnez	a2,706 <vprintf+0x280>
 702:	ec069be3          	bnez	a3,5d8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 706:	f8858593          	addi	a1,a1,-120
 70a:	e199                	bnez	a1,710 <vprintf+0x28a>
 70c:	ee0713e3          	bnez	a4,5f2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 710:	07000713          	li	a4,112
 714:	eee78ce3          	beq	a5,a4,60c <vprintf+0x186>
      } else if(c0 == 'c'){
 718:	06300713          	li	a4,99
 71c:	f2e78ce3          	beq	a5,a4,654 <vprintf+0x1ce>
      } else if(c0 == 's'){
 720:	07300713          	li	a4,115
 724:	f4e782e3          	beq	a5,a4,668 <vprintf+0x1e2>
      } else if(c0 == '%'){
 728:	02500713          	li	a4,37
 72c:	f6e787e3          	beq	a5,a4,69a <vprintf+0x214>
        putc(fd, '%');
 730:	02500593          	li	a1,37
 734:	855a                	mv	a0,s6
 736:	c95ff0ef          	jal	3ca <putc>
        putc(fd, c0);
 73a:	85a6                	mv	a1,s1
 73c:	855a                	mv	a0,s6
 73e:	c8dff0ef          	jal	3ca <putc>
      state = 0;
 742:	4981                	li	s3,0
 744:	b359                	j	4ca <vprintf+0x44>

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	8622                	mv	a2,s0
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	d23ff0ef          	jal	486 <vprintf>
}
 768:	60e2                	ld	ra,24(sp)
 76a:	6442                	ld	s0,16(sp)
 76c:	6161                	addi	sp,sp,80
 76e:	8082                	ret

0000000000000770 <printf>:

void
printf(const char *fmt, ...)
{
 770:	711d                	addi	sp,sp,-96
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e40c                	sd	a1,8(s0)
 77a:	e810                	sd	a2,16(s0)
 77c:	ec14                	sd	a3,24(s0)
 77e:	f018                	sd	a4,32(s0)
 780:	f41c                	sd	a5,40(s0)
 782:	03043823          	sd	a6,48(s0)
 786:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78a:	00840613          	addi	a2,s0,8
 78e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 792:	85aa                	mv	a1,a0
 794:	4505                	li	a0,1
 796:	cf1ff0ef          	jal	486 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a2:	1141                	addi	sp,sp,-16
 7a4:	e406                	sd	ra,8(sp)
 7a6:	e022                	sd	s0,0(sp)
 7a8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7aa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	00001797          	auipc	a5,0x1
 7b2:	8527b783          	ld	a5,-1966(a5) # 1000 <freep>
 7b6:	a039                	j	7c4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e7e463          	bltu	a5,a4,7c2 <free+0x20>
 7be:	00e6ea63          	bltu	a3,a4,7d2 <free+0x30>
{
 7c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	fed7fae3          	bgeu	a5,a3,7b8 <free+0x16>
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e6e463          	bltu	a3,a4,7d2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	fee7eae3          	bltu	a5,a4,7c2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d2:	ff852583          	lw	a1,-8(a0)
 7d6:	6390                	ld	a2,0(a5)
 7d8:	02059813          	slli	a6,a1,0x20
 7dc:	01c85713          	srli	a4,a6,0x1c
 7e0:	9736                	add	a4,a4,a3
 7e2:	02e60563          	beq	a2,a4,80c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7ea:	4790                	lw	a2,8(a5)
 7ec:	02061593          	slli	a1,a2,0x20
 7f0:	01c5d713          	srli	a4,a1,0x1c
 7f4:	973e                	add	a4,a4,a5
 7f6:	02e68263          	beq	a3,a4,81a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fc:	00001717          	auipc	a4,0x1
 800:	80f73223          	sd	a5,-2044(a4) # 1000 <freep>
}
 804:	60a2                	ld	ra,8(sp)
 806:	6402                	ld	s0,0(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 80c:	4618                	lw	a4,8(a2)
 80e:	9f2d                	addw	a4,a4,a1
 810:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	6310                	ld	a2,0(a4)
 818:	b7f9                	j	7e6 <free+0x44>
    p->s.size += bp->s.size;
 81a:	ff852703          	lw	a4,-8(a0)
 81e:	9f31                	addw	a4,a4,a2
 820:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 822:	ff053683          	ld	a3,-16(a0)
 826:	bfd1                	j	7fa <free+0x58>

0000000000000828 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 828:	7139                	addi	sp,sp,-64
 82a:	fc06                	sd	ra,56(sp)
 82c:	f822                	sd	s0,48(sp)
 82e:	f04a                	sd	s2,32(sp)
 830:	ec4e                	sd	s3,24(sp)
 832:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 834:	02051993          	slli	s3,a0,0x20
 838:	0209d993          	srli	s3,s3,0x20
 83c:	09bd                	addi	s3,s3,15
 83e:	0049d993          	srli	s3,s3,0x4
 842:	2985                	addiw	s3,s3,1
 844:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 846:	00000517          	auipc	a0,0x0
 84a:	7ba53503          	ld	a0,1978(a0) # 1000 <freep>
 84e:	c905                	beqz	a0,87e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	09377663          	bgeu	a4,s3,8e0 <malloc+0xb8>
 858:	f426                	sd	s1,40(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 860:	8a4e                	mv	s4,s3
 862:	6705                	lui	a4,0x1
 864:	00e9f363          	bgeu	s3,a4,86a <malloc+0x42>
 868:	6a05                	lui	s4,0x1
 86a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 872:	00000497          	auipc	s1,0x0
 876:	78e48493          	addi	s1,s1,1934 # 1000 <freep>
  if(p == SBRK_ERROR)
 87a:	5afd                	li	s5,-1
 87c:	a83d                	j	8ba <malloc+0x92>
 87e:	f426                	sd	s1,40(sp)
 880:	e852                	sd	s4,16(sp)
 882:	e456                	sd	s5,8(sp)
 884:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 886:	00000797          	auipc	a5,0x0
 88a:	78a78793          	addi	a5,a5,1930 # 1010 <base>
 88e:	00000717          	auipc	a4,0x0
 892:	76f73923          	sd	a5,1906(a4) # 1000 <freep>
 896:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 898:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89c:	b7d1                	j	860 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	e118                	sd	a4,0(a0)
 8a2:	a899                	j	8f8 <malloc+0xd0>
  hp->s.size = nu;
 8a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a8:	0541                	addi	a0,a0,16
 8aa:	ef9ff0ef          	jal	7a2 <free>
  return freep;
 8ae:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8b0:	c125                	beqz	a0,910 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	03277163          	bgeu	a4,s2,8d8 <malloc+0xb0>
    if(p == freep)
 8ba:	6098                	ld	a4,0(s1)
 8bc:	853e                	mv	a0,a5
 8be:	fef71ae3          	bne	a4,a5,8b2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c2:	8552                	mv	a0,s4
 8c4:	a0dff0ef          	jal	2d0 <sbrk>
  if(p == SBRK_ERROR)
 8c8:	fd551ee3          	bne	a0,s5,8a4 <malloc+0x7c>
        return 0;
 8cc:	4501                	li	a0,0
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	a03d                	j	904 <malloc+0xdc>
 8d8:	74a2                	ld	s1,40(sp)
 8da:	6a42                	ld	s4,16(sp)
 8dc:	6aa2                	ld	s5,8(sp)
 8de:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8e0:	fae90fe3          	beq	s2,a4,89e <malloc+0x76>
        p->s.size -= nunits;
 8e4:	4137073b          	subw	a4,a4,s3
 8e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ea:	02071693          	slli	a3,a4,0x20
 8ee:	01c6d713          	srli	a4,a3,0x1c
 8f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70a73423          	sd	a0,1800(a4) # 1000 <freep>
      return (void*)(p + 1);
 900:	01078513          	addi	a0,a5,16
  }
}
 904:	70e2                	ld	ra,56(sp)
 906:	7442                	ld	s0,48(sp)
 908:	7902                	ld	s2,32(sp)
 90a:	69e2                	ld	s3,24(sp)
 90c:	6121                	addi	sp,sp,64
 90e:	8082                	ret
 910:	74a2                	ld	s1,40(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	b7f5                	j	904 <malloc+0xdc>

000000000000091a <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 91a:	7179                	addi	sp,sp,-48
 91c:	f406                	sd	ra,40(sp)
 91e:	f022                	sd	s0,32(sp)
 920:	ec26                	sd	s1,24(sp)
 922:	e84a                	sd	s2,16(sp)
 924:	e44e                	sd	s3,8(sp)
 926:	1800                	addi	s0,sp,48
 928:	89aa                	mv	s3,a0
 92a:	892e                	mv	s2,a1
 92c:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 92e:	00c6151b          	slliw	a0,a2,0xc
 932:	ef7ff0ef          	jal	828 <malloc>
  if(stack == 0) return -1;
 936:	c91d                	beqz	a0,96c <thread_create+0x52>
 938:	e052                	sd	s4,0(sp)
 93a:	862a                	mv	a2,a0
 93c:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 93e:	10000713          	li	a4,256
 942:	86a6                	mv	a3,s1
 944:	85ca                	mv	a1,s2
 946:	854e                	mv	a0,s3
 948:	9d3ff0ef          	jal	31a <clone>

  if(pid < 0) {
 94c:	00054a63          	bltz	a0,960 <thread_create+0x46>
 950:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 952:	70a2                	ld	ra,40(sp)
 954:	7402                	ld	s0,32(sp)
 956:	64e2                	ld	s1,24(sp)
 958:	6942                	ld	s2,16(sp)
 95a:	69a2                	ld	s3,8(sp)
 95c:	6145                	addi	sp,sp,48
 95e:	8082                	ret
    free(stack);
 960:	8552                	mv	a0,s4
 962:	e41ff0ef          	jal	7a2 <free>
    return -1;
 966:	557d                	li	a0,-1
 968:	6a02                	ld	s4,0(sp)
 96a:	b7e5                	j	952 <thread_create+0x38>
  if(stack == 0) return -1;
 96c:	557d                	li	a0,-1
 96e:	b7d5                	j	952 <thread_create+0x38>

0000000000000970 <thread_join>:

int
thread_join(void)
{
 970:	7179                	addi	sp,sp,-48
 972:	f406                	sd	ra,40(sp)
 974:	f022                	sd	s0,32(sp)
 976:	ec26                	sd	s1,24(sp)
 978:	1800                	addi	s0,sp,48
  void *stack = 0;
 97a:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 97e:	fd840513          	addi	a0,s0,-40
 982:	9a1ff0ef          	jal	322 <join>
 986:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 988:	00a05763          	blez	a0,996 <thread_join+0x26>
 98c:	fd843503          	ld	a0,-40(s0)
 990:	c119                	beqz	a0,996 <thread_join+0x26>
    free(stack);
 992:	e11ff0ef          	jal	7a2 <free>
  }
  return pid;
}
 996:	8526                	mv	a0,s1
 998:	70a2                	ld	ra,40(sp)
 99a:	7402                	ld	s0,32(sp)
 99c:	64e2                	ld	s1,24(sp)
 99e:	6145                	addi	sp,sp,48
 9a0:	8082                	ret
