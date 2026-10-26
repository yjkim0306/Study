
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	892a                	mv	s2,a0
  10:	89ae                	mv	s3,a1
    printf("pid,state,name\n");
  12:	00001517          	auipc	a0,0x1
  16:	8fe50513          	addi	a0,a0,-1794 # 910 <malloc+0xfc>
  1a:	742000ef          	jal	75c <printf>
    if(argc == 1){
  1e:	4785                	li	a5,1
  20:	02f90863          	beq	s2,a5,50 <main+0x50>
        ps(0);
    }
    else{
        for(int i = 1; i < argc; i++)
  24:	0327d363          	bge	a5,s2,4a <main+0x4a>
  28:	00898493          	addi	s1,s3,8
  2c:	3979                	addiw	s2,s2,-2
  2e:	02091793          	slli	a5,s2,0x20
  32:	01d7d913          	srli	s2,a5,0x1d
  36:	09c1                	addi	s3,s3,16
  38:	994e                	add	s2,s2,s3
            ps(atoi(argv[i]));
  3a:	6088                	ld	a0,0(s1)
  3c:	1a8000ef          	jal	1e4 <atoi>
  40:	36e000ef          	jal	3ae <ps>
        for(int i = 1; i < argc; i++)
  44:	04a1                	addi	s1,s1,8
  46:	ff249ae3          	bne	s1,s2,3a <main+0x3a>
    }
  exit(0);
  4a:	4501                	li	a0,0
  4c:	2c2000ef          	jal	30e <exit>
        ps(0);
  50:	4501                	li	a0,0
  52:	35c000ef          	jal	3ae <ps>
  56:	bfd5                	j	4a <main+0x4a>

0000000000000058 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  58:	1141                	addi	sp,sp,-16
  5a:	e406                	sd	ra,8(sp)
  5c:	e022                	sd	s0,0(sp)
  5e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  60:	fa1ff0ef          	jal	0 <main>
  exit(r);
  64:	2aa000ef          	jal	30e <exit>

0000000000000068 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	87aa                	mv	a5,a0
  72:	0585                	addi	a1,a1,1
  74:	0785                	addi	a5,a5,1
  76:	fff5c703          	lbu	a4,-1(a1)
  7a:	fee78fa3          	sb	a4,-1(a5)
  7e:	fb75                	bnez	a4,72 <strcpy+0xa>
    ;
  return os;
}
  80:	60a2                	ld	ra,8(sp)
  82:	6402                	ld	s0,0(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e406                	sd	ra,8(sp)
  8c:	e022                	sd	s0,0(sp)
  8e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  90:	00054783          	lbu	a5,0(a0)
  94:	cb91                	beqz	a5,a8 <strcmp+0x20>
  96:	0005c703          	lbu	a4,0(a1)
  9a:	00f71763          	bne	a4,a5,a8 <strcmp+0x20>
    p++, q++;
  9e:	0505                	addi	a0,a0,1
  a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	fbe5                	bnez	a5,96 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a8:	0005c503          	lbu	a0,0(a1)
}
  ac:	40a7853b          	subw	a0,a5,a0
  b0:	60a2                	ld	ra,8(sp)
  b2:	6402                	ld	s0,0(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strlen>:

uint
strlen(const char *s)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cf91                	beqz	a5,e0 <strlen+0x28>
  c6:	00150793          	addi	a5,a0,1
  ca:	86be                	mv	a3,a5
  cc:	0785                	addi	a5,a5,1
  ce:	fff7c703          	lbu	a4,-1(a5)
  d2:	ff65                	bnez	a4,ca <strlen+0x12>
  d4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d8:	60a2                	ld	ra,8(sp)
  da:	6402                	ld	s0,0(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret
  for(n = 0; s[n]; n++)
  e0:	4501                	li	a0,0
  e2:	bfdd                	j	d8 <strlen+0x20>

00000000000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ec:	ca19                	beqz	a2,102 <memset+0x1e>
  ee:	87aa                	mv	a5,a0
  f0:	1602                	slli	a2,a2,0x20
  f2:	9201                	srli	a2,a2,0x20
  f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fc:	0785                	addi	a5,a5,1
  fe:	fee79de3          	bne	a5,a4,f8 <memset+0x14>
  }
  return dst;
}
 102:	60a2                	ld	ra,8(sp)
 104:	6402                	ld	s0,0(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret

000000000000010a <strchr>:

char*
strchr(const char *s, char c)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cf81                	beqz	a5,12e <strchr+0x24>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1c>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xe>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	60a2                	ld	ra,8(sp)
 128:	6402                	ld	s0,0(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret
  return 0;
 12e:	4501                	li	a0,0
 130:	bfdd                	j	126 <strchr+0x1c>

0000000000000132 <gets>:

char*
gets(char *buf, int max)
{
 132:	711d                	addi	sp,sp,-96
 134:	ec86                	sd	ra,88(sp)
 136:	e8a2                	sd	s0,80(sp)
 138:	e4a6                	sd	s1,72(sp)
 13a:	e0ca                	sd	s2,64(sp)
 13c:	fc4e                	sd	s3,56(sp)
 13e:	f852                	sd	s4,48(sp)
 140:	f456                	sd	s5,40(sp)
 142:	f05a                	sd	s6,32(sp)
 144:	ec5e                	sd	s7,24(sp)
 146:	e862                	sd	s8,16(sp)
 148:	1080                	addi	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
 152:	faf40b13          	addi	s6,s0,-81
 156:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 158:	8c26                	mv	s8,s1
 15a:	0014899b          	addiw	s3,s1,1
 15e:	84ce                	mv	s1,s3
 160:	0349d463          	bge	s3,s4,188 <gets+0x56>
    cc = read(0, &c, 1);
 164:	8656                	mv	a2,s5
 166:	85da                	mv	a1,s6
 168:	4501                	li	a0,0
 16a:	1bc000ef          	jal	326 <read>
    if(cc < 1)
 16e:	00a05d63          	blez	a0,188 <gets+0x56>
      break;
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	0905                	addi	s2,s2,1
 17c:	ff678713          	addi	a4,a5,-10
 180:	c319                	beqz	a4,186 <gets+0x54>
 182:	17cd                	addi	a5,a5,-13
 184:	fbf1                	bnez	a5,158 <gets+0x26>
    buf[i++] = c;
 186:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 188:	9c5e                	add	s8,s8,s7
 18a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18e:	855e                	mv	a0,s7
 190:	60e6                	ld	ra,88(sp)
 192:	6446                	ld	s0,80(sp)
 194:	64a6                	ld	s1,72(sp)
 196:	6906                	ld	s2,64(sp)
 198:	79e2                	ld	s3,56(sp)
 19a:	7a42                	ld	s4,48(sp)
 19c:	7aa2                	ld	s5,40(sp)
 19e:	7b02                	ld	s6,32(sp)
 1a0:	6be2                	ld	s7,24(sp)
 1a2:	6c42                	ld	s8,16(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	198000ef          	jal	34e <open>
  if(fd < 0)
 1ba:	02054263          	bltz	a0,1de <stat+0x36>
 1be:	e426                	sd	s1,8(sp)
 1c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c2:	85ca                	mv	a1,s2
 1c4:	1a2000ef          	jal	366 <fstat>
 1c8:	892a                	mv	s2,a0
  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	16a000ef          	jal	336 <close>
  return r;
 1d0:	64a2                	ld	s1,8(sp)
}
 1d2:	854a                	mv	a0,s2
 1d4:	60e2                	ld	ra,24(sp)
 1d6:	6442                	ld	s0,16(sp)
 1d8:	6902                	ld	s2,0(sp)
 1da:	6105                	addi	sp,sp,32
 1dc:	8082                	ret
    return -1;
 1de:	57fd                	li	a5,-1
 1e0:	893e                	mv	s2,a5
 1e2:	bfc5                	j	1d2 <stat+0x2a>

00000000000001e4 <atoi>:

int
atoi(const char *s)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ec:	00054683          	lbu	a3,0(a0)
 1f0:	fd06879b          	addiw	a5,a3,-48
 1f4:	0ff7f793          	zext.b	a5,a5
 1f8:	4625                	li	a2,9
 1fa:	02f66963          	bltu	a2,a5,22c <atoi+0x48>
 1fe:	872a                	mv	a4,a0
  n = 0;
 200:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 202:	0705                	addi	a4,a4,1
 204:	0025179b          	slliw	a5,a0,0x2
 208:	9fa9                	addw	a5,a5,a0
 20a:	0017979b          	slliw	a5,a5,0x1
 20e:	9fb5                	addw	a5,a5,a3
 210:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 214:	00074683          	lbu	a3,0(a4)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	fef671e3          	bgeu	a2,a5,202 <atoi+0x1e>
  return n;
}
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfdd                	j	224 <atoi+0x40>

0000000000000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 238:	02b57563          	bgeu	a0,a1,262 <memmove+0x32>
    while(n-- > 0)
 23c:	00c05f63          	blez	a2,25a <memmove+0x2a>
 240:	1602                	slli	a2,a2,0x20
 242:	9201                	srli	a2,a2,0x20
 244:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 248:	872a                	mv	a4,a0
      *dst++ = *src++;
 24a:	0585                	addi	a1,a1,1
 24c:	0705                	addi	a4,a4,1
 24e:	fff5c683          	lbu	a3,-1(a1)
 252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 256:	fee79ae3          	bne	a5,a4,24a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25a:	60a2                	ld	ra,8(sp)
 25c:	6402                	ld	s0,0(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    while(n-- > 0)
 262:	fec05ce3          	blez	a2,25a <memmove+0x2a>
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fef71ae3          	bne	a4,a5,27a <memmove+0x4a>
 28a:	bfc1                	j	25a <memmove+0x2a>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	c61d                	beqz	a2,2c2 <memcmp+0x36>
 296:	1602                	slli	a2,a2,0x20
 298:	9201                	srli	a2,a2,0x20
 29a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00e79863          	bne	a5,a4,2b6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2aa:	0505                	addi	a0,a0,1
    p2++;
 2ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ae:	fed518e3          	bne	a0,a3,29e <memcmp+0x12>
  }
  return 0;
 2b2:	4501                	li	a0,0
 2b4:	a019                	j	2ba <memcmp+0x2e>
      return *p1 - *p2;
 2b6:	40e7853b          	subw	a0,a5,a4
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfdd                	j	2ba <memcmp+0x2e>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	f63ff0ef          	jal	230 <memmove>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sbrk>:

char *
sbrk(int n) {
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e2:	4585                	li	a1,1
 2e4:	0b2000ef          	jal	396 <sys_sbrk>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <sbrklazy>:

char *
sbrklazy(int n) {
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f8:	4589                	li	a1,2
 2fa:	09c000ef          	jal	396 <sys_sbrk>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d9                	li	a7,22
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pause>:
.global pause
pause:
 li a7, SYS_pause
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <ps>:
.global ps
ps:
 li a7, SYS_ps
 3ae:	4881                	li	a7,0
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b6:	1101                	addi	sp,sp,-32
 3b8:	ec06                	sd	ra,24(sp)
 3ba:	e822                	sd	s0,16(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	fef40593          	addi	a1,s0,-17
 3c8:	f67ff0ef          	jal	32e <write>
}
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6105                	addi	sp,sp,32
 3d2:	8082                	ret

00000000000003d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d4:	715d                	addi	sp,sp,-80
 3d6:	e486                	sd	ra,72(sp)
 3d8:	e0a2                	sd	s0,64(sp)
 3da:	f84a                	sd	s2,48(sp)
 3dc:	f44e                	sd	s3,40(sp)
 3de:	0880                	addi	s0,sp,80
 3e0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3e2:	c6d1                	beqz	a3,46e <printint+0x9a>
 3e4:	0805d563          	bgez	a1,46e <printint+0x9a>
    neg = 1;
    x = -xx;
 3e8:	40b005b3          	neg	a1,a1
    neg = 1;
 3ec:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ee:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3f2:	86ce                	mv	a3,s3
  i = 0;
 3f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f6:	00000817          	auipc	a6,0x0
 3fa:	53280813          	addi	a6,a6,1330 # 928 <digits>
 3fe:	88ba                	mv	a7,a4
 400:	0017051b          	addiw	a0,a4,1
 404:	872a                	mv	a4,a0
 406:	02c5f7b3          	remu	a5,a1,a2
 40a:	97c2                	add	a5,a5,a6
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 414:	87ae                	mv	a5,a1
 416:	02c5d5b3          	divu	a1,a1,a2
 41a:	0685                	addi	a3,a3,1
 41c:	fec7f1e3          	bgeu	a5,a2,3fe <printint+0x2a>
  if(neg)
 420:	00030c63          	beqz	t1,438 <printint+0x64>
    buf[i++] = '-';
 424:	fd050793          	addi	a5,a0,-48
 428:	00878533          	add	a0,a5,s0
 42c:	02d00793          	li	a5,45
 430:	fef50423          	sb	a5,-24(a0)
 434:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 438:	02e05563          	blez	a4,462 <printint+0x8e>
 43c:	fc26                	sd	s1,56(sp)
 43e:	377d                	addiw	a4,a4,-1
 440:	00e984b3          	add	s1,s3,a4
 444:	19fd                	addi	s3,s3,-1
 446:	99ba                	add	s3,s3,a4
 448:	1702                	slli	a4,a4,0x20
 44a:	9301                	srli	a4,a4,0x20
 44c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 450:	0004c583          	lbu	a1,0(s1)
 454:	854a                	mv	a0,s2
 456:	f61ff0ef          	jal	3b6 <putc>
  while(--i >= 0)
 45a:	14fd                	addi	s1,s1,-1
 45c:	ff349ae3          	bne	s1,s3,450 <printint+0x7c>
 460:	74e2                	ld	s1,56(sp)
}
 462:	60a6                	ld	ra,72(sp)
 464:	6406                	ld	s0,64(sp)
 466:	7942                	ld	s2,48(sp)
 468:	79a2                	ld	s3,40(sp)
 46a:	6161                	addi	sp,sp,80
 46c:	8082                	ret
  neg = 0;
 46e:	4301                	li	t1,0
 470:	bfbd                	j	3ee <printint+0x1a>

0000000000000472 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 472:	711d                	addi	sp,sp,-96
 474:	ec86                	sd	ra,88(sp)
 476:	e8a2                	sd	s0,80(sp)
 478:	e4a6                	sd	s1,72(sp)
 47a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47c:	0005c483          	lbu	s1,0(a1)
 480:	22048363          	beqz	s1,6a6 <vprintf+0x234>
 484:	e0ca                	sd	s2,64(sp)
 486:	fc4e                	sd	s3,56(sp)
 488:	f852                	sd	s4,48(sp)
 48a:	f456                	sd	s5,40(sp)
 48c:	f05a                	sd	s6,32(sp)
 48e:	ec5e                	sd	s7,24(sp)
 490:	e862                	sd	s8,16(sp)
 492:	8b2a                	mv	s6,a0
 494:	8a2e                	mv	s4,a1
 496:	8bb2                	mv	s7,a2
  state = 0;
 498:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 49a:	4901                	li	s2,0
 49c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 49e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a2:	06400c13          	li	s8,100
 4a6:	a00d                	j	4c8 <vprintf+0x56>
        putc(fd, c0);
 4a8:	85a6                	mv	a1,s1
 4aa:	855a                	mv	a0,s6
 4ac:	f0bff0ef          	jal	3b6 <putc>
 4b0:	a019                	j	4b6 <vprintf+0x44>
    } else if(state == '%'){
 4b2:	03598363          	beq	s3,s5,4d8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4b6:	0019079b          	addiw	a5,s2,1
 4ba:	893e                	mv	s2,a5
 4bc:	873e                	mv	a4,a5
 4be:	97d2                	add	a5,a5,s4
 4c0:	0007c483          	lbu	s1,0(a5)
 4c4:	1c048a63          	beqz	s1,698 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4c8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4cc:	fe0993e3          	bnez	s3,4b2 <vprintf+0x40>
      if(c0 == '%'){
 4d0:	fd579ce3          	bne	a5,s5,4a8 <vprintf+0x36>
        state = '%';
 4d4:	89be                	mv	s3,a5
 4d6:	b7c5                	j	4b6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d8:	00ea06b3          	add	a3,s4,a4
 4dc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4e0:	1c060863          	beqz	a2,6b0 <vprintf+0x23e>
      if(c0 == 'd'){
 4e4:	03878763          	beq	a5,s8,512 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e8:	f9478693          	addi	a3,a5,-108
 4ec:	0016b693          	seqz	a3,a3
 4f0:	f9c60593          	addi	a1,a2,-100
 4f4:	e99d                	bnez	a1,52a <vprintf+0xb8>
 4f6:	ca95                	beqz	a3,52a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f8:	008b8493          	addi	s1,s7,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000bb583          	ld	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	ecfff0ef          	jal	3d4 <printint>
        i += 1;
 50a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 50e:	4981                	li	s3,0
 510:	b75d                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 512:	008b8493          	addi	s1,s7,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	eb5ff0ef          	jal	3d4 <printint>
 524:	8ba6                	mv	s7,s1
      state = 0;
 526:	4981                	li	s3,0
 528:	b779                	j	4b6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 52a:	9752                	add	a4,a4,s4
 52c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 530:	f9460713          	addi	a4,a2,-108
 534:	00173713          	seqz	a4,a4
 538:	8f75                	and	a4,a4,a3
 53a:	f9c58513          	addi	a0,a1,-100
 53e:	18051363          	bnez	a0,6c4 <vprintf+0x252>
 542:	18070163          	beqz	a4,6c4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 546:	008b8493          	addi	s1,s7,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000bb583          	ld	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	e81ff0ef          	jal	3d4 <printint>
        i += 2;
 558:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	8ba6                	mv	s7,s1
      state = 0;
 55c:	4981                	li	s3,0
        i += 2;
 55e:	bfa1                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 560:	008b8493          	addi	s1,s7,8
 564:	4681                	li	a3,0
 566:	4629                	li	a2,10
 568:	000be583          	lwu	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e67ff0ef          	jal	3d4 <printint>
 572:	8ba6                	mv	s7,s1
      state = 0;
 574:	4981                	li	s3,0
 576:	b781                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 578:	008b8493          	addi	s1,s7,8
 57c:	4681                	li	a3,0
 57e:	4629                	li	a2,10
 580:	000bb583          	ld	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	e4fff0ef          	jal	3d4 <printint>
        i += 1;
 58a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	8ba6                	mv	s7,s1
      state = 0;
 58e:	4981                	li	s3,0
 590:	b71d                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	008b8493          	addi	s1,s7,8
 596:	4681                	li	a3,0
 598:	4629                	li	a2,10
 59a:	000bb583          	ld	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e35ff0ef          	jal	3d4 <printint>
        i += 2;
 5a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
        i += 2;
 5aa:	b731                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000be583          	lwu	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e1bff0ef          	jal	3d4 <printint>
 5be:	8ba6                	mv	s7,s1
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bdd5                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000bb583          	ld	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e03ff0ef          	jal	3d4 <printint>
        i += 1;
 5d6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bde9                	j	4b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4641                	li	a2,16
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	de9ff0ef          	jal	3d4 <printint>
        i += 2;
 5f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	b5c1                	j	4b6 <vprintf+0x44>
 5f8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5fa:	008b8793          	addi	a5,s7,8
 5fe:	8cbe                	mv	s9,a5
 600:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 604:	03000593          	li	a1,48
 608:	855a                	mv	a0,s6
 60a:	dadff0ef          	jal	3b6 <putc>
  putc(fd, 'x');
 60e:	07800593          	li	a1,120
 612:	855a                	mv	a0,s6
 614:	da3ff0ef          	jal	3b6 <putc>
 618:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61a:	00000b97          	auipc	s7,0x0
 61e:	30eb8b93          	addi	s7,s7,782 # 928 <digits>
 622:	03c9d793          	srli	a5,s3,0x3c
 626:	97de                	add	a5,a5,s7
 628:	0007c583          	lbu	a1,0(a5)
 62c:	855a                	mv	a0,s6
 62e:	d89ff0ef          	jal	3b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 632:	0992                	slli	s3,s3,0x4
 634:	34fd                	addiw	s1,s1,-1
 636:	f4f5                	bnez	s1,622 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 638:	8be6                	mv	s7,s9
      state = 0;
 63a:	4981                	li	s3,0
 63c:	6ca2                	ld	s9,8(sp)
 63e:	bda5                	j	4b6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 640:	008b8493          	addi	s1,s7,8
 644:	000bc583          	lbu	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	d6dff0ef          	jal	3b6 <putc>
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	b595                	j	4b6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 654:	008b8993          	addi	s3,s7,8
 658:	000bb483          	ld	s1,0(s7)
 65c:	cc91                	beqz	s1,678 <vprintf+0x206>
        for(; *s; s++)
 65e:	0004c583          	lbu	a1,0(s1)
 662:	c985                	beqz	a1,692 <vprintf+0x220>
          putc(fd, *s);
 664:	855a                	mv	a0,s6
 666:	d51ff0ef          	jal	3b6 <putc>
        for(; *s; s++)
 66a:	0485                	addi	s1,s1,1
 66c:	0004c583          	lbu	a1,0(s1)
 670:	f9f5                	bnez	a1,664 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	b581                	j	4b6 <vprintf+0x44>
          s = "(null)";
 678:	00000497          	auipc	s1,0x0
 67c:	2a848493          	addi	s1,s1,680 # 920 <malloc+0x10c>
        for(; *s; s++)
 680:	02800593          	li	a1,40
 684:	b7c5                	j	664 <vprintf+0x1f2>
        putc(fd, '%');
 686:	85be                	mv	a1,a5
 688:	855a                	mv	a0,s6
 68a:	d2dff0ef          	jal	3b6 <putc>
      state = 0;
 68e:	4981                	li	s3,0
 690:	b51d                	j	4b6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 692:	8bce                	mv	s7,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	b505                	j	4b6 <vprintf+0x44>
 698:	6906                	ld	s2,64(sp)
 69a:	79e2                	ld	s3,56(sp)
 69c:	7a42                	ld	s4,48(sp)
 69e:	7aa2                	ld	s5,40(sp)
 6a0:	7b02                	ld	s6,32(sp)
 6a2:	6be2                	ld	s7,24(sp)
 6a4:	6c42                	ld	s8,16(sp)
    }
  }
}
 6a6:	60e6                	ld	ra,88(sp)
 6a8:	6446                	ld	s0,80(sp)
 6aa:	64a6                	ld	s1,72(sp)
 6ac:	6125                	addi	sp,sp,96
 6ae:	8082                	ret
      if(c0 == 'd'){
 6b0:	06400713          	li	a4,100
 6b4:	e4e78fe3          	beq	a5,a4,512 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6b8:	f9478693          	addi	a3,a5,-108
 6bc:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6c0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6c4:	07500513          	li	a0,117
 6c8:	e8a78ce3          	beq	a5,a0,560 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6cc:	f8b60513          	addi	a0,a2,-117
 6d0:	e119                	bnez	a0,6d6 <vprintf+0x264>
 6d2:	ea0693e3          	bnez	a3,578 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6d6:	f8b58513          	addi	a0,a1,-117
 6da:	e119                	bnez	a0,6e0 <vprintf+0x26e>
 6dc:	ea071be3          	bnez	a4,592 <vprintf+0x120>
      } else if(c0 == 'x'){
 6e0:	07800513          	li	a0,120
 6e4:	eca784e3          	beq	a5,a0,5ac <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6e8:	f8860613          	addi	a2,a2,-120
 6ec:	e219                	bnez	a2,6f2 <vprintf+0x280>
 6ee:	ec069be3          	bnez	a3,5c4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f2:	f8858593          	addi	a1,a1,-120
 6f6:	e199                	bnez	a1,6fc <vprintf+0x28a>
 6f8:	ee0713e3          	bnez	a4,5de <vprintf+0x16c>
      } else if(c0 == 'p'){
 6fc:	07000713          	li	a4,112
 700:	eee78ce3          	beq	a5,a4,5f8 <vprintf+0x186>
      } else if(c0 == 'c'){
 704:	06300713          	li	a4,99
 708:	f2e78ce3          	beq	a5,a4,640 <vprintf+0x1ce>
      } else if(c0 == 's'){
 70c:	07300713          	li	a4,115
 710:	f4e782e3          	beq	a5,a4,654 <vprintf+0x1e2>
      } else if(c0 == '%'){
 714:	02500713          	li	a4,37
 718:	f6e787e3          	beq	a5,a4,686 <vprintf+0x214>
        putc(fd, '%');
 71c:	02500593          	li	a1,37
 720:	855a                	mv	a0,s6
 722:	c95ff0ef          	jal	3b6 <putc>
        putc(fd, c0);
 726:	85a6                	mv	a1,s1
 728:	855a                	mv	a0,s6
 72a:	c8dff0ef          	jal	3b6 <putc>
      state = 0;
 72e:	4981                	li	s3,0
 730:	b359                	j	4b6 <vprintf+0x44>

0000000000000732 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 732:	715d                	addi	sp,sp,-80
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e010                	sd	a2,0(s0)
 73c:	e414                	sd	a3,8(s0)
 73e:	e818                	sd	a4,16(s0)
 740:	ec1c                	sd	a5,24(s0)
 742:	03043023          	sd	a6,32(s0)
 746:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	8622                	mv	a2,s0
 74c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 750:	d23ff0ef          	jal	472 <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6161                	addi	sp,sp,80
 75a:	8082                	ret

000000000000075c <printf>:

void
printf(const char *fmt, ...)
{
 75c:	711d                	addi	sp,sp,-96
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e40c                	sd	a1,8(s0)
 766:	e810                	sd	a2,16(s0)
 768:	ec14                	sd	a3,24(s0)
 76a:	f018                	sd	a4,32(s0)
 76c:	f41c                	sd	a5,40(s0)
 76e:	03043823          	sd	a6,48(s0)
 772:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	00840613          	addi	a2,s0,8
 77a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77e:	85aa                	mv	a1,a0
 780:	4505                	li	a0,1
 782:	cf1ff0ef          	jal	472 <vprintf>
}
 786:	60e2                	ld	ra,24(sp)
 788:	6442                	ld	s0,16(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret

000000000000078e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78e:	1141                	addi	sp,sp,-16
 790:	e406                	sd	ra,8(sp)
 792:	e022                	sd	s0,0(sp)
 794:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 796:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	00001797          	auipc	a5,0x1
 79e:	8667b783          	ld	a5,-1946(a5) # 1000 <freep>
 7a2:	a039                	j	7b0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e7e463          	bltu	a5,a4,7ae <free+0x20>
 7aa:	00e6ea63          	bltu	a3,a4,7be <free+0x30>
{
 7ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	fed7fae3          	bgeu	a5,a3,7a4 <free+0x16>
 7b4:	6398                	ld	a4,0(a5)
 7b6:	00e6e463          	bltu	a3,a4,7be <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	fee7eae3          	bltu	a5,a4,7ae <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7be:	ff852583          	lw	a1,-8(a0)
 7c2:	6390                	ld	a2,0(a5)
 7c4:	02059813          	slli	a6,a1,0x20
 7c8:	01c85713          	srli	a4,a6,0x1c
 7cc:	9736                	add	a4,a4,a3
 7ce:	02e60563          	beq	a2,a4,7f8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d6:	4790                	lw	a2,8(a5)
 7d8:	02061593          	slli	a1,a2,0x20
 7dc:	01c5d713          	srli	a4,a1,0x1c
 7e0:	973e                	add	a4,a4,a5
 7e2:	02e68263          	beq	a3,a4,806 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e8:	00001717          	auipc	a4,0x1
 7ec:	80f73c23          	sd	a5,-2024(a4) # 1000 <freep>
}
 7f0:	60a2                	ld	ra,8(sp)
 7f2:	6402                	ld	s0,0(sp)
 7f4:	0141                	addi	sp,sp,16
 7f6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7f8:	4618                	lw	a4,8(a2)
 7fa:	9f2d                	addw	a4,a4,a1
 7fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	6310                	ld	a2,0(a4)
 804:	b7f9                	j	7d2 <free+0x44>
    p->s.size += bp->s.size;
 806:	ff852703          	lw	a4,-8(a0)
 80a:	9f31                	addw	a4,a4,a2
 80c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80e:	ff053683          	ld	a3,-16(a0)
 812:	bfd1                	j	7e6 <free+0x58>

0000000000000814 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 814:	7139                	addi	sp,sp,-64
 816:	fc06                	sd	ra,56(sp)
 818:	f822                	sd	s0,48(sp)
 81a:	f04a                	sd	s2,32(sp)
 81c:	ec4e                	sd	s3,24(sp)
 81e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	02051993          	slli	s3,a0,0x20
 824:	0209d993          	srli	s3,s3,0x20
 828:	09bd                	addi	s3,s3,15
 82a:	0049d993          	srli	s3,s3,0x4
 82e:	2985                	addiw	s3,s3,1
 830:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 832:	00000517          	auipc	a0,0x0
 836:	7ce53503          	ld	a0,1998(a0) # 1000 <freep>
 83a:	c905                	beqz	a0,86a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83e:	4798                	lw	a4,8(a5)
 840:	09377663          	bgeu	a4,s3,8cc <malloc+0xb8>
 844:	f426                	sd	s1,40(sp)
 846:	e852                	sd	s4,16(sp)
 848:	e456                	sd	s5,8(sp)
 84a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 84c:	8a4e                	mv	s4,s3
 84e:	6705                	lui	a4,0x1
 850:	00e9f363          	bgeu	s3,a4,856 <malloc+0x42>
 854:	6a05                	lui	s4,0x1
 856:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85e:	00000497          	auipc	s1,0x0
 862:	7a248493          	addi	s1,s1,1954 # 1000 <freep>
  if(p == SBRK_ERROR)
 866:	5afd                	li	s5,-1
 868:	a83d                	j	8a6 <malloc+0x92>
 86a:	f426                	sd	s1,40(sp)
 86c:	e852                	sd	s4,16(sp)
 86e:	e456                	sd	s5,8(sp)
 870:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 872:	00000797          	auipc	a5,0x0
 876:	79e78793          	addi	a5,a5,1950 # 1010 <base>
 87a:	00000717          	auipc	a4,0x0
 87e:	78f73323          	sd	a5,1926(a4) # 1000 <freep>
 882:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 884:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 888:	b7d1                	j	84c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	e118                	sd	a4,0(a0)
 88e:	a899                	j	8e4 <malloc+0xd0>
  hp->s.size = nu;
 890:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 894:	0541                	addi	a0,a0,16
 896:	ef9ff0ef          	jal	78e <free>
  return freep;
 89a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 89c:	c125                	beqz	a0,8fc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	03277163          	bgeu	a4,s2,8c4 <malloc+0xb0>
    if(p == freep)
 8a6:	6098                	ld	a4,0(s1)
 8a8:	853e                	mv	a0,a5
 8aa:	fef71ae3          	bne	a4,a5,89e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ae:	8552                	mv	a0,s4
 8b0:	a2bff0ef          	jal	2da <sbrk>
  if(p == SBRK_ERROR)
 8b4:	fd551ee3          	bne	a0,s5,890 <malloc+0x7c>
        return 0;
 8b8:	4501                	li	a0,0
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	a03d                	j	8f0 <malloc+0xdc>
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8cc:	fae90fe3          	beq	s2,a4,88a <malloc+0x76>
        p->s.size -= nunits;
 8d0:	4137073b          	subw	a4,a4,s3
 8d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d6:	02071693          	slli	a3,a4,0x20
 8da:	01c6d713          	srli	a4,a3,0x1c
 8de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	70a73e23          	sd	a0,1820(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ec:	01078513          	addi	a0,a5,16
  }
}
 8f0:	70e2                	ld	ra,56(sp)
 8f2:	7442                	ld	s0,48(sp)
 8f4:	7902                	ld	s2,32(sp)
 8f6:	69e2                	ld	s3,24(sp)
 8f8:	6121                	addi	sp,sp,64
 8fa:	8082                	ret
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	b7f5                	j	8f0 <malloc+0xdc>
