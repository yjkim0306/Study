
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	a5278793          	addi	a5,a5,-1454 # a70 <thread_join+0x66>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	a0c50513          	addi	a0,a0,-1524 # a40 <thread_join+0x36>
  3c:	7ce000ef          	jal	80a <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	128000ef          	jal	174 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	342000ef          	jal	396 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for(i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	9f450513          	addi	a0,a0,-1548 # a58 <thread_join+0x4e>
  6c:	79e000ef          	jal	80a <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	382000ef          	jal	404 <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	34c000ef          	jal	3e4 <write>
  for(i = 0; i < 20; i++)
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	34a000ef          	jal	3ec <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	9c250513          	addi	a0,a0,-1598 # a68 <thread_join+0x5e>
  ae:	75c000ef          	jal	80a <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	34c000ef          	jal	404 <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	30e000ef          	jal	3dc <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	314000ef          	jal	3ec <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2ee000ef          	jal	3cc <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2e0000ef          	jal	3c4 <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	2d0000ef          	jal	3c4 <exit>

00000000000000f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf91                	beqz	a5,170 <strlen+0x28>
 156:	00150793          	addi	a5,a0,1
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for(n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strlen+0x20>

0000000000000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17c:	ca19                	beqz	a2,192 <memset+0x1e>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x14>
  }
  return dst;
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char*
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cf81                	beqz	a5,1be <strchr+0x24>
    if(*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1c>
  for(; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xe>
      return (char*)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret
  return 0;
 1be:	4501                	li	a0,0
 1c0:	bfdd                	j	1b6 <strchr+0x1c>

00000000000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	711d                	addi	sp,sp,-96
 1c4:	ec86                	sd	ra,88(sp)
 1c6:	e8a2                	sd	s0,80(sp)
 1c8:	e4a6                	sd	s1,72(sp)
 1ca:	e0ca                	sd	s2,64(sp)
 1cc:	fc4e                	sd	s3,56(sp)
 1ce:	f852                	sd	s4,48(sp)
 1d0:	f456                	sd	s5,40(sp)
 1d2:	f05a                	sd	s6,32(sp)
 1d4:	ec5e                	sd	s7,24(sp)
 1d6:	e862                	sd	s8,16(sp)
 1d8:	1080                	addi	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e2:	faf40b13          	addi	s6,s0,-81
 1e6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1e8:	8c26                	mv	s8,s1
 1ea:	0014899b          	addiw	s3,s1,1
 1ee:	84ce                	mv	s1,s3
 1f0:	0349d463          	bge	s3,s4,218 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	8656                	mv	a2,s5
 1f6:	85da                	mv	a1,s6
 1f8:	4501                	li	a0,0
 1fa:	1e2000ef          	jal	3dc <read>
    if(cc < 1)
 1fe:	00a05d63          	blez	a0,218 <gets+0x56>
      break;
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	0905                	addi	s2,s2,1
 20c:	ff678713          	addi	a4,a5,-10
 210:	c319                	beqz	a4,216 <gets+0x54>
 212:	17cd                	addi	a5,a5,-13
 214:	fbf1                	bnez	a5,1e8 <gets+0x26>
    buf[i++] = c;
 216:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 218:	9c5e                	add	s8,s8,s7
 21a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 21e:	855e                	mv	a0,s7
 220:	60e6                	ld	ra,88(sp)
 222:	6446                	ld	s0,80(sp)
 224:	64a6                	ld	s1,72(sp)
 226:	6906                	ld	s2,64(sp)
 228:	79e2                	ld	s3,56(sp)
 22a:	7a42                	ld	s4,48(sp)
 22c:	7aa2                	ld	s5,40(sp)
 22e:	7b02                	ld	s6,32(sp)
 230:	6be2                	ld	s7,24(sp)
 232:	6c42                	ld	s8,16(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	1be000ef          	jal	404 <open>
  if(fd < 0)
 24a:	02054263          	bltz	a0,26e <stat+0x36>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	1c8000ef          	jal	41c <fstat>
 258:	892a                	mv	s2,a0
  close(fd);
 25a:	8526                	mv	a0,s1
 25c:	190000ef          	jal	3ec <close>
  return r;
 260:	64a2                	ld	s1,8(sp)
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	57fd                	li	a5,-1
 270:	893e                	mv	s2,a5
 272:	bfc5                	j	262 <stat+0x2a>

0000000000000274 <atoi>:

int
atoi(const char *s)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27c:	00054683          	lbu	a3,0(a0)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	4625                	li	a2,9
 28a:	02f66963          	bltu	a2,a5,2bc <atoi+0x48>
 28e:	872a                	mv	a4,a0
  n = 0;
 290:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 292:	0705                	addi	a4,a4,1
 294:	0025179b          	slliw	a5,a0,0x2
 298:	9fa9                	addw	a5,a5,a0
 29a:	0017979b          	slliw	a5,a5,0x1
 29e:	9fb5                	addw	a5,a5,a3
 2a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a4:	00074683          	lbu	a3,0(a4)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	fef671e3          	bgeu	a2,a5,292 <atoi+0x1e>
  return n;
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  n = 0;
 2bc:	4501                	li	a0,0
 2be:	bfdd                	j	2b4 <atoi+0x40>

00000000000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c8:	02b57563          	bgeu	a0,a1,2f2 <memmove+0x32>
    while(n-- > 0)
 2cc:	00c05f63          	blez	a2,2ea <memmove+0x2a>
 2d0:	1602                	slli	a2,a2,0x20
 2d2:	9201                	srli	a2,a2,0x20
 2d4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2da:	0585                	addi	a1,a1,1
 2dc:	0705                	addi	a4,a4,1
 2de:	fff5c683          	lbu	a3,-1(a1)
 2e2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
    while(n-- > 0)
 2f2:	fec05ce3          	blez	a2,2ea <memmove+0x2a>
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
 2fc:	fff6079b          	addiw	a5,a2,-1
 300:	1782                	slli	a5,a5,0x20
 302:	9381                	srli	a5,a5,0x20
 304:	fff7c793          	not	a5,a5
 308:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30a:	15fd                	addi	a1,a1,-1
 30c:	177d                	addi	a4,a4,-1
 30e:	0005c683          	lbu	a3,0(a1)
 312:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 316:	fef71ae3          	bne	a4,a5,30a <memmove+0x4a>
 31a:	bfc1                	j	2ea <memmove+0x2a>

000000000000031c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 324:	c61d                	beqz	a2,352 <memcmp+0x36>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 32e:	00054783          	lbu	a5,0(a0)
 332:	0005c703          	lbu	a4,0(a1)
 336:	00e79863          	bne	a5,a4,346 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 33a:	0505                	addi	a0,a0,1
    p2++;
 33c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33e:	fed518e3          	bne	a0,a3,32e <memcmp+0x12>
  }
  return 0;
 342:	4501                	li	a0,0
 344:	a019                	j	34a <memcmp+0x2e>
      return *p1 - *p2;
 346:	40e7853b          	subw	a0,a5,a4
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  return 0;
 352:	4501                	li	a0,0
 354:	bfdd                	j	34a <memcmp+0x2e>

0000000000000356 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35e:	f63ff0ef          	jal	2c0 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrk>:

char *
sbrk(int n) {
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 372:	4585                	li	a1,1
 374:	0d8000ef          	jal	44c <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <sbrklazy>:

char *
sbrklazy(int n) {
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 388:	4589                	li	a1,2
 38a:	0c2000ef          	jal	44c <sys_sbrk>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:

int
fork(void)
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 39e:	4701                	li	a4,0
 3a0:	4681                	li	a3,0
 3a2:	4601                	li	a2,0
 3a4:	4581                	li	a1,0
 3a6:	4501                	li	a0,0
 3a8:	00c000ef          	jal	3b4 <clone>
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret

00000000000003b4 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 3b4:	4885                	li	a7,1
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <join>:
.global join
join:
 li a7, SYS_join
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c4:	4889                	li	a7,2
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3cc:	488d                	li	a7,3
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d4:	4891                	li	a7,4
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <read>:
.global read
read:
 li a7, SYS_read
 3dc:	4895                	li	a7,5
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <write>:
.global write
write:
 li a7, SYS_write
 3e4:	48c1                	li	a7,16
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <close>:
.global close
close:
 li a7, SYS_close
 3ec:	48d5                	li	a7,21
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f4:	4899                	li	a7,6
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fc:	489d                	li	a7,7
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <open>:
.global open
open:
 li a7, SYS_open
 404:	48bd                	li	a7,15
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40c:	48c5                	li	a7,17
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 414:	48c9                	li	a7,18
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41c:	48a1                	li	a7,8
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <link>:
.global link
link:
 li a7, SYS_link
 424:	48cd                	li	a7,19
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42c:	48d1                	li	a7,20
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 434:	48a5                	li	a7,9
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <dup>:
.global dup
dup:
 li a7, SYS_dup
 43c:	48a9                	li	a7,10
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 444:	48ad                	li	a7,11
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 44c:	48b1                	li	a7,12
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <pause>:
.global pause
pause:
 li a7, SYS_pause
 454:	48b5                	li	a7,13
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45c:	48b9                	li	a7,14
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 464:	1101                	addi	sp,sp,-32
 466:	ec06                	sd	ra,24(sp)
 468:	e822                	sd	s0,16(sp)
 46a:	1000                	addi	s0,sp,32
 46c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 470:	4605                	li	a2,1
 472:	fef40593          	addi	a1,s0,-17
 476:	f6fff0ef          	jal	3e4 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 482:	715d                	addi	sp,sp,-80
 484:	e486                	sd	ra,72(sp)
 486:	e0a2                	sd	s0,64(sp)
 488:	f84a                	sd	s2,48(sp)
 48a:	f44e                	sd	s3,40(sp)
 48c:	0880                	addi	s0,sp,80
 48e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 490:	c6d1                	beqz	a3,51c <printint+0x9a>
 492:	0805d563          	bgez	a1,51c <printint+0x9a>
    neg = 1;
    x = -xx;
 496:	40b005b3          	neg	a1,a1
    neg = 1;
 49a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 49c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4a0:	86ce                	mv	a3,s3
  i = 0;
 4a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a4:	00000817          	auipc	a6,0x0
 4a8:	5e480813          	addi	a6,a6,1508 # a88 <digits>
 4ac:	88ba                	mv	a7,a4
 4ae:	0017051b          	addiw	a0,a4,1
 4b2:	872a                	mv	a4,a0
 4b4:	02c5f7b3          	remu	a5,a1,a2
 4b8:	97c2                	add	a5,a5,a6
 4ba:	0007c783          	lbu	a5,0(a5)
 4be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c2:	87ae                	mv	a5,a1
 4c4:	02c5d5b3          	divu	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fec7f1e3          	bgeu	a5,a2,4ac <printint+0x2a>
  if(neg)
 4ce:	00030c63          	beqz	t1,4e6 <printint+0x64>
    buf[i++] = '-';
 4d2:	fd050793          	addi	a5,a0,-48
 4d6:	00878533          	add	a0,a5,s0
 4da:	02d00793          	li	a5,45
 4de:	fef50423          	sb	a5,-24(a0)
 4e2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e6:	02e05563          	blez	a4,510 <printint+0x8e>
 4ea:	fc26                	sd	s1,56(sp)
 4ec:	377d                	addiw	a4,a4,-1
 4ee:	00e984b3          	add	s1,s3,a4
 4f2:	19fd                	addi	s3,s3,-1
 4f4:	99ba                	add	s3,s3,a4
 4f6:	1702                	slli	a4,a4,0x20
 4f8:	9301                	srli	a4,a4,0x20
 4fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fe:	0004c583          	lbu	a1,0(s1)
 502:	854a                	mv	a0,s2
 504:	f61ff0ef          	jal	464 <putc>
  while(--i >= 0)
 508:	14fd                	addi	s1,s1,-1
 50a:	ff349ae3          	bne	s1,s3,4fe <printint+0x7c>
 50e:	74e2                	ld	s1,56(sp)
}
 510:	60a6                	ld	ra,72(sp)
 512:	6406                	ld	s0,64(sp)
 514:	7942                	ld	s2,48(sp)
 516:	79a2                	ld	s3,40(sp)
 518:	6161                	addi	sp,sp,80
 51a:	8082                	ret
  neg = 0;
 51c:	4301                	li	t1,0
 51e:	bfbd                	j	49c <printint+0x1a>

0000000000000520 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 520:	711d                	addi	sp,sp,-96
 522:	ec86                	sd	ra,88(sp)
 524:	e8a2                	sd	s0,80(sp)
 526:	e4a6                	sd	s1,72(sp)
 528:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c483          	lbu	s1,0(a1)
 52e:	22048363          	beqz	s1,754 <vprintf+0x234>
 532:	e0ca                	sd	s2,64(sp)
 534:	fc4e                	sd	s3,56(sp)
 536:	f852                	sd	s4,48(sp)
 538:	f456                	sd	s5,40(sp)
 53a:	f05a                	sd	s6,32(sp)
 53c:	ec5e                	sd	s7,24(sp)
 53e:	e862                	sd	s8,16(sp)
 540:	8b2a                	mv	s6,a0
 542:	8a2e                	mv	s4,a1
 544:	8bb2                	mv	s7,a2
  state = 0;
 546:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 548:	4901                	li	s2,0
 54a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 550:	06400c13          	li	s8,100
 554:	a00d                	j	576 <vprintf+0x56>
        putc(fd, c0);
 556:	85a6                	mv	a1,s1
 558:	855a                	mv	a0,s6
 55a:	f0bff0ef          	jal	464 <putc>
 55e:	a019                	j	564 <vprintf+0x44>
    } else if(state == '%'){
 560:	03598363          	beq	s3,s5,586 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 564:	0019079b          	addiw	a5,s2,1
 568:	893e                	mv	s2,a5
 56a:	873e                	mv	a4,a5
 56c:	97d2                	add	a5,a5,s4
 56e:	0007c483          	lbu	s1,0(a5)
 572:	1c048a63          	beqz	s1,746 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 576:	0004879b          	sext.w	a5,s1
    if(state == 0){
 57a:	fe0993e3          	bnez	s3,560 <vprintf+0x40>
      if(c0 == '%'){
 57e:	fd579ce3          	bne	a5,s5,556 <vprintf+0x36>
        state = '%';
 582:	89be                	mv	s3,a5
 584:	b7c5                	j	564 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 586:	00ea06b3          	add	a3,s4,a4
 58a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 58e:	1c060863          	beqz	a2,75e <vprintf+0x23e>
      if(c0 == 'd'){
 592:	03878763          	beq	a5,s8,5c0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 596:	f9478693          	addi	a3,a5,-108
 59a:	0016b693          	seqz	a3,a3
 59e:	f9c60593          	addi	a1,a2,-100
 5a2:	e99d                	bnez	a1,5d8 <vprintf+0xb8>
 5a4:	ca95                	beqz	a3,5d8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4685                	li	a3,1
 5ac:	4629                	li	a2,10
 5ae:	000bb583          	ld	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	ecfff0ef          	jal	482 <printint>
        i += 1;
 5b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b75d                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	eb5ff0ef          	jal	482 <printint>
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b779                	j	564 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5d8:	9752                	add	a4,a4,s4
 5da:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	f9460713          	addi	a4,a2,-108
 5e2:	00173713          	seqz	a4,a4
 5e6:	8f75                	and	a4,a4,a3
 5e8:	f9c58513          	addi	a0,a1,-100
 5ec:	18051363          	bnez	a0,772 <vprintf+0x252>
 5f0:	18070163          	beqz	a4,772 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4685                	li	a3,1
 5fa:	4629                	li	a2,10
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e81ff0ef          	jal	482 <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	bfa1                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000be583          	lwu	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e67ff0ef          	jal	482 <printint>
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
 624:	b781                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	008b8493          	addi	s1,s7,8
 62a:	4681                	li	a3,0
 62c:	4629                	li	a2,10
 62e:	000bb583          	ld	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	e4fff0ef          	jal	482 <printint>
        i += 1;
 638:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b71d                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8493          	addi	s1,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e35ff0ef          	jal	482 <printint>
        i += 2;
 652:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
        i += 2;
 658:	b731                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000be583          	lwu	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e1bff0ef          	jal	482 <printint>
 66c:	8ba6                	mv	s7,s1
      state = 0;
 66e:	4981                	li	s3,0
 670:	bdd5                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	008b8493          	addi	s1,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000bb583          	ld	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e03ff0ef          	jal	482 <printint>
        i += 1;
 684:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	8ba6                	mv	s7,s1
      state = 0;
 688:	4981                	li	s3,0
 68a:	bde9                	j	564 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8493          	addi	s1,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	de9ff0ef          	jal	482 <printint>
        i += 2;
 69e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
        i += 2;
 6a4:	b5c1                	j	564 <vprintf+0x44>
 6a6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a8:	008b8793          	addi	a5,s7,8
 6ac:	8cbe                	mv	s9,a5
 6ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b2:	03000593          	li	a1,48
 6b6:	855a                	mv	a0,s6
 6b8:	dadff0ef          	jal	464 <putc>
  putc(fd, 'x');
 6bc:	07800593          	li	a1,120
 6c0:	855a                	mv	a0,s6
 6c2:	da3ff0ef          	jal	464 <putc>
 6c6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c8:	00000b97          	auipc	s7,0x0
 6cc:	3c0b8b93          	addi	s7,s7,960 # a88 <digits>
 6d0:	03c9d793          	srli	a5,s3,0x3c
 6d4:	97de                	add	a5,a5,s7
 6d6:	0007c583          	lbu	a1,0(a5)
 6da:	855a                	mv	a0,s6
 6dc:	d89ff0ef          	jal	464 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e0:	0992                	slli	s3,s3,0x4
 6e2:	34fd                	addiw	s1,s1,-1
 6e4:	f4f5                	bnez	s1,6d0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6e6:	8be6                	mv	s7,s9
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	6ca2                	ld	s9,8(sp)
 6ec:	bda5                	j	564 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ee:	008b8493          	addi	s1,s7,8
 6f2:	000bc583          	lbu	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d6dff0ef          	jal	464 <putc>
 6fc:	8ba6                	mv	s7,s1
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b595                	j	564 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 702:	008b8993          	addi	s3,s7,8
 706:	000bb483          	ld	s1,0(s7)
 70a:	cc91                	beqz	s1,726 <vprintf+0x206>
        for(; *s; s++)
 70c:	0004c583          	lbu	a1,0(s1)
 710:	c985                	beqz	a1,740 <vprintf+0x220>
          putc(fd, *s);
 712:	855a                	mv	a0,s6
 714:	d51ff0ef          	jal	464 <putc>
        for(; *s; s++)
 718:	0485                	addi	s1,s1,1
 71a:	0004c583          	lbu	a1,0(s1)
 71e:	f9f5                	bnez	a1,712 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 720:	8bce                	mv	s7,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	b581                	j	564 <vprintf+0x44>
          s = "(null)";
 726:	00000497          	auipc	s1,0x0
 72a:	35a48493          	addi	s1,s1,858 # a80 <thread_join+0x76>
        for(; *s; s++)
 72e:	02800593          	li	a1,40
 732:	b7c5                	j	712 <vprintf+0x1f2>
        putc(fd, '%');
 734:	85be                	mv	a1,a5
 736:	855a                	mv	a0,s6
 738:	d2dff0ef          	jal	464 <putc>
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b51d                	j	564 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 740:	8bce                	mv	s7,s3
      state = 0;
 742:	4981                	li	s3,0
 744:	b505                	j	564 <vprintf+0x44>
 746:	6906                	ld	s2,64(sp)
 748:	79e2                	ld	s3,56(sp)
 74a:	7a42                	ld	s4,48(sp)
 74c:	7aa2                	ld	s5,40(sp)
 74e:	7b02                	ld	s6,32(sp)
 750:	6be2                	ld	s7,24(sp)
 752:	6c42                	ld	s8,16(sp)
    }
  }
}
 754:	60e6                	ld	ra,88(sp)
 756:	6446                	ld	s0,80(sp)
 758:	64a6                	ld	s1,72(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret
      if(c0 == 'd'){
 75e:	06400713          	li	a4,100
 762:	e4e78fe3          	beq	a5,a4,5c0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 766:	f9478693          	addi	a3,a5,-108
 76a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 76e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 770:	4701                	li	a4,0
      } else if(c0 == 'u'){
 772:	07500513          	li	a0,117
 776:	e8a78ce3          	beq	a5,a0,60e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 77a:	f8b60513          	addi	a0,a2,-117
 77e:	e119                	bnez	a0,784 <vprintf+0x264>
 780:	ea0693e3          	bnez	a3,626 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 784:	f8b58513          	addi	a0,a1,-117
 788:	e119                	bnez	a0,78e <vprintf+0x26e>
 78a:	ea071be3          	bnez	a4,640 <vprintf+0x120>
      } else if(c0 == 'x'){
 78e:	07800513          	li	a0,120
 792:	eca784e3          	beq	a5,a0,65a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 796:	f8860613          	addi	a2,a2,-120
 79a:	e219                	bnez	a2,7a0 <vprintf+0x280>
 79c:	ec069be3          	bnez	a3,672 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a0:	f8858593          	addi	a1,a1,-120
 7a4:	e199                	bnez	a1,7aa <vprintf+0x28a>
 7a6:	ee0713e3          	bnez	a4,68c <vprintf+0x16c>
      } else if(c0 == 'p'){
 7aa:	07000713          	li	a4,112
 7ae:	eee78ce3          	beq	a5,a4,6a6 <vprintf+0x186>
      } else if(c0 == 'c'){
 7b2:	06300713          	li	a4,99
 7b6:	f2e78ce3          	beq	a5,a4,6ee <vprintf+0x1ce>
      } else if(c0 == 's'){
 7ba:	07300713          	li	a4,115
 7be:	f4e782e3          	beq	a5,a4,702 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7c2:	02500713          	li	a4,37
 7c6:	f6e787e3          	beq	a5,a4,734 <vprintf+0x214>
        putc(fd, '%');
 7ca:	02500593          	li	a1,37
 7ce:	855a                	mv	a0,s6
 7d0:	c95ff0ef          	jal	464 <putc>
        putc(fd, c0);
 7d4:	85a6                	mv	a1,s1
 7d6:	855a                	mv	a0,s6
 7d8:	c8dff0ef          	jal	464 <putc>
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b359                	j	564 <vprintf+0x44>

00000000000007e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e0:	715d                	addi	sp,sp,-80
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e010                	sd	a2,0(s0)
 7ea:	e414                	sd	a3,8(s0)
 7ec:	e818                	sd	a4,16(s0)
 7ee:	ec1c                	sd	a5,24(s0)
 7f0:	03043023          	sd	a6,32(s0)
 7f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	8622                	mv	a2,s0
 7fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fe:	d23ff0ef          	jal	520 <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6161                	addi	sp,sp,80
 808:	8082                	ret

000000000000080a <printf>:

void
printf(const char *fmt, ...)
{
 80a:	711d                	addi	sp,sp,-96
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e40c                	sd	a1,8(s0)
 814:	e810                	sd	a2,16(s0)
 816:	ec14                	sd	a3,24(s0)
 818:	f018                	sd	a4,32(s0)
 81a:	f41c                	sd	a5,40(s0)
 81c:	03043823          	sd	a6,48(s0)
 820:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	00840613          	addi	a2,s0,8
 828:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82c:	85aa                	mv	a1,a0
 82e:	4505                	li	a0,1
 830:	cf1ff0ef          	jal	520 <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83c:	1141                	addi	sp,sp,-16
 83e:	e406                	sd	ra,8(sp)
 840:	e022                	sd	s0,0(sp)
 842:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 844:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	00000797          	auipc	a5,0x0
 84c:	7b87b783          	ld	a5,1976(a5) # 1000 <freep>
 850:	a039                	j	85e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	6398                	ld	a4,0(a5)
 854:	00e7e463          	bltu	a5,a4,85c <free+0x20>
 858:	00e6ea63          	bltu	a3,a4,86c <free+0x30>
{
 85c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	fed7fae3          	bgeu	a5,a3,852 <free+0x16>
 862:	6398                	ld	a4,0(a5)
 864:	00e6e463          	bltu	a3,a4,86c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	fee7eae3          	bltu	a5,a4,85c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 86c:	ff852583          	lw	a1,-8(a0)
 870:	6390                	ld	a2,0(a5)
 872:	02059813          	slli	a6,a1,0x20
 876:	01c85713          	srli	a4,a6,0x1c
 87a:	9736                	add	a4,a4,a3
 87c:	02e60563          	beq	a2,a4,8a6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 884:	4790                	lw	a2,8(a5)
 886:	02061593          	slli	a1,a2,0x20
 88a:	01c5d713          	srli	a4,a1,0x1c
 88e:	973e                	add	a4,a4,a5
 890:	02e68263          	beq	a3,a4,8b4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 894:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 896:	00000717          	auipc	a4,0x0
 89a:	76f73523          	sd	a5,1898(a4) # 1000 <freep>
}
 89e:	60a2                	ld	ra,8(sp)
 8a0:	6402                	ld	s0,0(sp)
 8a2:	0141                	addi	sp,sp,16
 8a4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8a6:	4618                	lw	a4,8(a2)
 8a8:	9f2d                	addw	a4,a4,a1
 8aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	6310                	ld	a2,0(a4)
 8b2:	b7f9                	j	880 <free+0x44>
    p->s.size += bp->s.size;
 8b4:	ff852703          	lw	a4,-8(a0)
 8b8:	9f31                	addw	a4,a4,a2
 8ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8bc:	ff053683          	ld	a3,-16(a0)
 8c0:	bfd1                	j	894 <free+0x58>

00000000000008c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c2:	7139                	addi	sp,sp,-64
 8c4:	fc06                	sd	ra,56(sp)
 8c6:	f822                	sd	s0,48(sp)
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	ec4e                	sd	s3,24(sp)
 8cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ce:	02051993          	slli	s3,a0,0x20
 8d2:	0209d993          	srli	s3,s3,0x20
 8d6:	09bd                	addi	s3,s3,15
 8d8:	0049d993          	srli	s3,s3,0x4
 8dc:	2985                	addiw	s3,s3,1
 8de:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8e0:	00000517          	auipc	a0,0x0
 8e4:	72053503          	ld	a0,1824(a0) # 1000 <freep>
 8e8:	c905                	beqz	a0,918 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ec:	4798                	lw	a4,8(a5)
 8ee:	09377663          	bgeu	a4,s3,97a <malloc+0xb8>
 8f2:	f426                	sd	s1,40(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8fa:	8a4e                	mv	s4,s3
 8fc:	6705                	lui	a4,0x1
 8fe:	00e9f363          	bgeu	s3,a4,904 <malloc+0x42>
 902:	6a05                	lui	s4,0x1
 904:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 908:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90c:	00000497          	auipc	s1,0x0
 910:	6f448493          	addi	s1,s1,1780 # 1000 <freep>
  if(p == SBRK_ERROR)
 914:	5afd                	li	s5,-1
 916:	a83d                	j	954 <malloc+0x92>
 918:	f426                	sd	s1,40(sp)
 91a:	e852                	sd	s4,16(sp)
 91c:	e456                	sd	s5,8(sp)
 91e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 920:	00000797          	auipc	a5,0x0
 924:	6f078793          	addi	a5,a5,1776 # 1010 <base>
 928:	00000717          	auipc	a4,0x0
 92c:	6cf73c23          	sd	a5,1752(a4) # 1000 <freep>
 930:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 932:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 936:	b7d1                	j	8fa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 938:	6398                	ld	a4,0(a5)
 93a:	e118                	sd	a4,0(a0)
 93c:	a899                	j	992 <malloc+0xd0>
  hp->s.size = nu;
 93e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 942:	0541                	addi	a0,a0,16
 944:	ef9ff0ef          	jal	83c <free>
  return freep;
 948:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 94a:	c125                	beqz	a0,9aa <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94e:	4798                	lw	a4,8(a5)
 950:	03277163          	bgeu	a4,s2,972 <malloc+0xb0>
    if(p == freep)
 954:	6098                	ld	a4,0(s1)
 956:	853e                	mv	a0,a5
 958:	fef71ae3          	bne	a4,a5,94c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 95c:	8552                	mv	a0,s4
 95e:	a0dff0ef          	jal	36a <sbrk>
  if(p == SBRK_ERROR)
 962:	fd551ee3          	bne	a0,s5,93e <malloc+0x7c>
        return 0;
 966:	4501                	li	a0,0
 968:	74a2                	ld	s1,40(sp)
 96a:	6a42                	ld	s4,16(sp)
 96c:	6aa2                	ld	s5,8(sp)
 96e:	6b02                	ld	s6,0(sp)
 970:	a03d                	j	99e <malloc+0xdc>
 972:	74a2                	ld	s1,40(sp)
 974:	6a42                	ld	s4,16(sp)
 976:	6aa2                	ld	s5,8(sp)
 978:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 97a:	fae90fe3          	beq	s2,a4,938 <malloc+0x76>
        p->s.size -= nunits;
 97e:	4137073b          	subw	a4,a4,s3
 982:	c798                	sw	a4,8(a5)
        p += p->s.size;
 984:	02071693          	slli	a3,a4,0x20
 988:	01c6d713          	srli	a4,a3,0x1c
 98c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 992:	00000717          	auipc	a4,0x0
 996:	66a73723          	sd	a0,1646(a4) # 1000 <freep>
      return (void*)(p + 1);
 99a:	01078513          	addi	a0,a5,16
  }
}
 99e:	70e2                	ld	ra,56(sp)
 9a0:	7442                	ld	s0,48(sp)
 9a2:	7902                	ld	s2,32(sp)
 9a4:	69e2                	ld	s3,24(sp)
 9a6:	6121                	addi	sp,sp,64
 9a8:	8082                	ret
 9aa:	74a2                	ld	s1,40(sp)
 9ac:	6a42                	ld	s4,16(sp)
 9ae:	6aa2                	ld	s5,8(sp)
 9b0:	6b02                	ld	s6,0(sp)
 9b2:	b7f5                	j	99e <malloc+0xdc>

00000000000009b4 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 9b4:	7179                	addi	sp,sp,-48
 9b6:	f406                	sd	ra,40(sp)
 9b8:	f022                	sd	s0,32(sp)
 9ba:	ec26                	sd	s1,24(sp)
 9bc:	e84a                	sd	s2,16(sp)
 9be:	e44e                	sd	s3,8(sp)
 9c0:	1800                	addi	s0,sp,48
 9c2:	89aa                	mv	s3,a0
 9c4:	892e                	mv	s2,a1
 9c6:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 9c8:	00c6151b          	slliw	a0,a2,0xc
 9cc:	ef7ff0ef          	jal	8c2 <malloc>
  if(stack == 0) return -1;
 9d0:	c91d                	beqz	a0,a06 <thread_create+0x52>
 9d2:	e052                	sd	s4,0(sp)
 9d4:	862a                	mv	a2,a0
 9d6:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 9d8:	10000713          	li	a4,256
 9dc:	86a6                	mv	a3,s1
 9de:	85ca                	mv	a1,s2
 9e0:	854e                	mv	a0,s3
 9e2:	9d3ff0ef          	jal	3b4 <clone>

  if(pid < 0) {
 9e6:	00054a63          	bltz	a0,9fa <thread_create+0x46>
 9ea:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 9ec:	70a2                	ld	ra,40(sp)
 9ee:	7402                	ld	s0,32(sp)
 9f0:	64e2                	ld	s1,24(sp)
 9f2:	6942                	ld	s2,16(sp)
 9f4:	69a2                	ld	s3,8(sp)
 9f6:	6145                	addi	sp,sp,48
 9f8:	8082                	ret
    free(stack);
 9fa:	8552                	mv	a0,s4
 9fc:	e41ff0ef          	jal	83c <free>
    return -1;
 a00:	557d                	li	a0,-1
 a02:	6a02                	ld	s4,0(sp)
 a04:	b7e5                	j	9ec <thread_create+0x38>
  if(stack == 0) return -1;
 a06:	557d                	li	a0,-1
 a08:	b7d5                	j	9ec <thread_create+0x38>

0000000000000a0a <thread_join>:

int
thread_join(void)
{
 a0a:	7179                	addi	sp,sp,-48
 a0c:	f406                	sd	ra,40(sp)
 a0e:	f022                	sd	s0,32(sp)
 a10:	ec26                	sd	s1,24(sp)
 a12:	1800                	addi	s0,sp,48
  void *stack = 0;
 a14:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 a18:	fd840513          	addi	a0,s0,-40
 a1c:	9a1ff0ef          	jal	3bc <join>
 a20:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 a22:	00a05763          	blez	a0,a30 <thread_join+0x26>
 a26:	fd843503          	ld	a0,-40(s0)
 a2a:	c119                	beqz	a0,a30 <thread_join+0x26>
    free(stack);
 a2c:	e11ff0ef          	jal	83c <free>
  }
  return pid;
}
 a30:	8526                	mv	a0,s1
 a32:	70a2                	ld	ra,40(sp)
 a34:	7402                	ld	s0,32(sp)
 a36:	64e2                	ld	s1,24(sp)
 a38:	6145                	addi	sp,sp,48
 a3a:	8082                	ret
