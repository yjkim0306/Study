
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	9d450513          	addi	a0,a0,-1580 # 9e0 <thread_join+0x32>
  14:	3bc000ef          	jal	3d0 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	9cc50513          	addi	a0,a0,-1588 # 9e8 <thread_join+0x3a>
  24:	78a000ef          	jal	7ae <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	33e000ef          	jal	368 <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	9b250513          	addi	a0,a0,-1614 # 9e0 <thread_join+0x32>
  36:	3a2000ef          	jal	3d8 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	9c250513          	addi	a0,a0,-1598 # a00 <thread_join+0x52>
  46:	768000ef          	jal	7ae <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	31c000ef          	jal	368 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	9c850513          	addi	a0,a0,-1592 # a18 <thread_join+0x6a>
  58:	360000ef          	jal	3b8 <unlink>
  5c:	00054e63          	bltz	a0,78 <main+0x78>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	9d850513          	addi	a0,a0,-1576 # a38 <thread_join+0x8a>
  68:	746000ef          	jal	7ae <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800493          	li	s1,1000
  70:	8526                	mv	a0,s1
  72:	386000ef          	jal	3f8 <pause>
  76:	bfed                	j	70 <main+0x70>
    printf("%s: unlink failed\n", s);
  78:	85a6                	mv	a1,s1
  7a:	00001517          	auipc	a0,0x1
  7e:	9a650513          	addi	a0,a0,-1626 # a20 <thread_join+0x72>
  82:	72c000ef          	jal	7ae <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	2e0000ef          	jal	368 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	2d0000ef          	jal	368 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf91                	beqz	a5,114 <strlen+0x28>
  fa:	00150793          	addi	a5,a0,1
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 10c:	60a2                	ld	ra,8(sp)
 10e:	6402                	ld	s0,0(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  for(n = 0; s[n]; n++)
 114:	4501                	li	a0,0
 116:	bfdd                	j	10c <strlen+0x20>

0000000000000118 <memset>:

void*
memset(void *dst, int c, uint n)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1e>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x14>
  }
  return dst;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  for(; *s; s++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf81                	beqz	a5,162 <strchr+0x24>
    if(*s == c)
 14c:	00f58763          	beq	a1,a5,15a <strchr+0x1c>
  for(; *s; s++)
 150:	0505                	addi	a0,a0,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbfd                	bnez	a5,14c <strchr+0xe>
      return (char*)s;
  return 0;
 158:	4501                	li	a0,0
}
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfdd                	j	15a <strchr+0x1c>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	e862                	sd	s8,16(sp)
 17c:	1080                	addi	s0,sp,96
 17e:	8baa                	mv	s7,a0
 180:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	892a                	mv	s2,a0
 184:	4481                	li	s1,0
    cc = read(0, &c, 1);
 186:	faf40b13          	addi	s6,s0,-81
 18a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 18c:	8c26                	mv	s8,s1
 18e:	0014899b          	addiw	s3,s1,1
 192:	84ce                	mv	s1,s3
 194:	0349d463          	bge	s3,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 198:	8656                	mv	a2,s5
 19a:	85da                	mv	a1,s6
 19c:	4501                	li	a0,0
 19e:	1e2000ef          	jal	380 <read>
    if(cc < 1)
 1a2:	00a05d63          	blez	a0,1bc <gets+0x56>
      break;
    buf[i++] = c;
 1a6:	faf44783          	lbu	a5,-81(s0)
 1aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ae:	0905                	addi	s2,s2,1
 1b0:	ff678713          	addi	a4,a5,-10
 1b4:	c319                	beqz	a4,1ba <gets+0x54>
 1b6:	17cd                	addi	a5,a5,-13
 1b8:	fbf1                	bnez	a5,18c <gets+0x26>
    buf[i++] = c;
 1ba:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1bc:	9c5e                	add	s8,s8,s7
 1be:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6c42                	ld	s8,16(sp)
 1d8:	6125                	addi	sp,sp,96
 1da:	8082                	ret

00000000000001dc <stat>:

int
stat(const char *n, struct stat *st)
{
 1dc:	1101                	addi	sp,sp,-32
 1de:	ec06                	sd	ra,24(sp)
 1e0:	e822                	sd	s0,16(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	1be000ef          	jal	3a8 <open>
  if(fd < 0)
 1ee:	02054263          	bltz	a0,212 <stat+0x36>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	1c8000ef          	jal	3c0 <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	190000ef          	jal	390 <close>
  return r;
 204:	64a2                	ld	s1,8(sp)
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	57fd                	li	a5,-1
 214:	893e                	mv	s2,a5
 216:	bfc5                	j	206 <stat+0x2a>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addiw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66963          	bltu	a2,a5,260 <atoi+0x48>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	addi	a4,a4,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addiw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1e>
  return n;
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  n = 0;
 260:	4501                	li	a0,0
 262:	bfdd                	j	258 <atoi+0x40>

0000000000000264 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26c:	02b57563          	bgeu	a0,a1,296 <memmove+0x32>
    while(n-- > 0)
 270:	00c05f63          	blez	a2,28e <memmove+0x2a>
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
    while(n-- > 0)
 296:	fec05ce3          	blez	a2,28e <memmove+0x2a>
    dst += n;
 29a:	00c50733          	add	a4,a0,a2
    src += n;
 29e:	95b2                	add	a1,a1,a2
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	fff7c793          	not	a5,a5
 2ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ae:	15fd                	addi	a1,a1,-1
 2b0:	177d                	addi	a4,a4,-1
 2b2:	0005c683          	lbu	a3,0(a1)
 2b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ba:	fef71ae3          	bne	a4,a5,2ae <memmove+0x4a>
 2be:	bfc1                	j	28e <memmove+0x2a>

00000000000002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c8:	c61d                	beqz	a2,2f6 <memcmp+0x36>
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	0005c703          	lbu	a4,0(a1)
 2da:	00e79863          	bne	a5,a4,2ea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2de:	0505                	addi	a0,a0,1
    p2++;
 2e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e2:	fed518e3          	bne	a0,a3,2d2 <memcmp+0x12>
  }
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	a019                	j	2ee <memcmp+0x2e>
      return *p1 - *p2;
 2ea:	40e7853b          	subw	a0,a5,a4
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfdd                	j	2ee <memcmp+0x2e>

00000000000002fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 302:	f63ff0ef          	jal	264 <memmove>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <sbrk>:

char *
sbrk(int n) {
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 316:	4585                	li	a1,1
 318:	0d8000ef          	jal	3f0 <sys_sbrk>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <sbrklazy>:

char *
sbrklazy(int n) {
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 32c:	4589                	li	a1,2
 32e:	0c2000ef          	jal	3f0 <sys_sbrk>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <fork>:

int
fork(void)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 342:	4701                	li	a4,0
 344:	4681                	li	a3,0
 346:	4601                	li	a2,0
 348:	4581                	li	a1,0
 34a:	4501                	li	a0,0
 34c:	00c000ef          	jal	358 <clone>
}
 350:	60a2                	ld	ra,8(sp)
 352:	6402                	ld	s0,0(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret

0000000000000358 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 358:	4885                	li	a7,1
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <join>:
.global join
join:
 li a7, SYS_join
 360:	48d9                	li	a7,22
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exit>:
.global exit
exit:
 li a7, SYS_exit
 368:	4889                	li	a7,2
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <wait>:
.global wait
wait:
 li a7, SYS_wait
 370:	488d                	li	a7,3
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 378:	4891                	li	a7,4
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <read>:
.global read
read:
 li a7, SYS_read
 380:	4895                	li	a7,5
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <write>:
.global write
write:
 li a7, SYS_write
 388:	48c1                	li	a7,16
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <close>:
.global close
close:
 li a7, SYS_close
 390:	48d5                	li	a7,21
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <kill>:
.global kill
kill:
 li a7, SYS_kill
 398:	4899                	li	a7,6
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a0:	489d                	li	a7,7
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <open>:
.global open
open:
 li a7, SYS_open
 3a8:	48bd                	li	a7,15
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b0:	48c5                	li	a7,17
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b8:	48c9                	li	a7,18
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c0:	48a1                	li	a7,8
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <link>:
.global link
link:
 li a7, SYS_link
 3c8:	48cd                	li	a7,19
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d0:	48d1                	li	a7,20
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d8:	48a5                	li	a7,9
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e0:	48a9                	li	a7,10
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e8:	48ad                	li	a7,11
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3f0:	48b1                	li	a7,12
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3f8:	48b5                	li	a7,13
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 400:	48b9                	li	a7,14
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	addi	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 414:	4605                	li	a2,1
 416:	fef40593          	addi	a1,s0,-17
 41a:	f6fff0ef          	jal	388 <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 426:	715d                	addi	sp,sp,-80
 428:	e486                	sd	ra,72(sp)
 42a:	e0a2                	sd	s0,64(sp)
 42c:	f84a                	sd	s2,48(sp)
 42e:	f44e                	sd	s3,40(sp)
 430:	0880                	addi	s0,sp,80
 432:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 434:	c6d1                	beqz	a3,4c0 <printint+0x9a>
 436:	0805d563          	bgez	a1,4c0 <printint+0x9a>
    neg = 1;
    x = -xx;
 43a:	40b005b3          	neg	a1,a1
    neg = 1;
 43e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 440:	fb840993          	addi	s3,s0,-72
  neg = 0;
 444:	86ce                	mv	a3,s3
  i = 0;
 446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 448:	00000817          	auipc	a6,0x0
 44c:	61880813          	addi	a6,a6,1560 # a60 <digits>
 450:	88ba                	mv	a7,a4
 452:	0017051b          	addiw	a0,a4,1
 456:	872a                	mv	a4,a0
 458:	02c5f7b3          	remu	a5,a1,a2
 45c:	97c2                	add	a5,a5,a6
 45e:	0007c783          	lbu	a5,0(a5)
 462:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 466:	87ae                	mv	a5,a1
 468:	02c5d5b3          	divu	a1,a1,a2
 46c:	0685                	addi	a3,a3,1
 46e:	fec7f1e3          	bgeu	a5,a2,450 <printint+0x2a>
  if(neg)
 472:	00030c63          	beqz	t1,48a <printint+0x64>
    buf[i++] = '-';
 476:	fd050793          	addi	a5,a0,-48
 47a:	00878533          	add	a0,a5,s0
 47e:	02d00793          	li	a5,45
 482:	fef50423          	sb	a5,-24(a0)
 486:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 48a:	02e05563          	blez	a4,4b4 <printint+0x8e>
 48e:	fc26                	sd	s1,56(sp)
 490:	377d                	addiw	a4,a4,-1
 492:	00e984b3          	add	s1,s3,a4
 496:	19fd                	addi	s3,s3,-1
 498:	99ba                	add	s3,s3,a4
 49a:	1702                	slli	a4,a4,0x20
 49c:	9301                	srli	a4,a4,0x20
 49e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a2:	0004c583          	lbu	a1,0(s1)
 4a6:	854a                	mv	a0,s2
 4a8:	f61ff0ef          	jal	408 <putc>
  while(--i >= 0)
 4ac:	14fd                	addi	s1,s1,-1
 4ae:	ff349ae3          	bne	s1,s3,4a2 <printint+0x7c>
 4b2:	74e2                	ld	s1,56(sp)
}
 4b4:	60a6                	ld	ra,72(sp)
 4b6:	6406                	ld	s0,64(sp)
 4b8:	7942                	ld	s2,48(sp)
 4ba:	79a2                	ld	s3,40(sp)
 4bc:	6161                	addi	sp,sp,80
 4be:	8082                	ret
  neg = 0;
 4c0:	4301                	li	t1,0
 4c2:	bfbd                	j	440 <printint+0x1a>

00000000000004c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c4:	711d                	addi	sp,sp,-96
 4c6:	ec86                	sd	ra,88(sp)
 4c8:	e8a2                	sd	s0,80(sp)
 4ca:	e4a6                	sd	s1,72(sp)
 4cc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ce:	0005c483          	lbu	s1,0(a1)
 4d2:	22048363          	beqz	s1,6f8 <vprintf+0x234>
 4d6:	e0ca                	sd	s2,64(sp)
 4d8:	fc4e                	sd	s3,56(sp)
 4da:	f852                	sd	s4,48(sp)
 4dc:	f456                	sd	s5,40(sp)
 4de:	f05a                	sd	s6,32(sp)
 4e0:	ec5e                	sd	s7,24(sp)
 4e2:	e862                	sd	s8,16(sp)
 4e4:	8b2a                	mv	s6,a0
 4e6:	8a2e                	mv	s4,a1
 4e8:	8bb2                	mv	s7,a2
  state = 0;
 4ea:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ec:	4901                	li	s2,0
 4ee:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f4:	06400c13          	li	s8,100
 4f8:	a00d                	j	51a <vprintf+0x56>
        putc(fd, c0);
 4fa:	85a6                	mv	a1,s1
 4fc:	855a                	mv	a0,s6
 4fe:	f0bff0ef          	jal	408 <putc>
 502:	a019                	j	508 <vprintf+0x44>
    } else if(state == '%'){
 504:	03598363          	beq	s3,s5,52a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 508:	0019079b          	addiw	a5,s2,1
 50c:	893e                	mv	s2,a5
 50e:	873e                	mv	a4,a5
 510:	97d2                	add	a5,a5,s4
 512:	0007c483          	lbu	s1,0(a5)
 516:	1c048a63          	beqz	s1,6ea <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 51a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51e:	fe0993e3          	bnez	s3,504 <vprintf+0x40>
      if(c0 == '%'){
 522:	fd579ce3          	bne	a5,s5,4fa <vprintf+0x36>
        state = '%';
 526:	89be                	mv	s3,a5
 528:	b7c5                	j	508 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 52a:	00ea06b3          	add	a3,s4,a4
 52e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 532:	1c060863          	beqz	a2,702 <vprintf+0x23e>
      if(c0 == 'd'){
 536:	03878763          	beq	a5,s8,564 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	f9478693          	addi	a3,a5,-108
 53e:	0016b693          	seqz	a3,a3
 542:	f9c60593          	addi	a1,a2,-100
 546:	e99d                	bnez	a1,57c <vprintf+0xb8>
 548:	ca95                	beqz	a3,57c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	008b8493          	addi	s1,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000bb583          	ld	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	ecfff0ef          	jal	426 <printint>
        i += 1;
 55c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 560:	4981                	li	s3,0
 562:	b75d                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 564:	008b8493          	addi	s1,s7,8
 568:	4685                	li	a3,1
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	eb5ff0ef          	jal	426 <printint>
 576:	8ba6                	mv	s7,s1
      state = 0;
 578:	4981                	li	s3,0
 57a:	b779                	j	508 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 57c:	9752                	add	a4,a4,s4
 57e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 582:	f9460713          	addi	a4,a2,-108
 586:	00173713          	seqz	a4,a4
 58a:	8f75                	and	a4,a4,a3
 58c:	f9c58513          	addi	a0,a1,-100
 590:	18051363          	bnez	a0,716 <vprintf+0x252>
 594:	18070163          	beqz	a4,716 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	008b8493          	addi	s1,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000bb583          	ld	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	e81ff0ef          	jal	426 <printint>
        i += 2;
 5aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	8ba6                	mv	s7,s1
      state = 0;
 5ae:	4981                	li	s3,0
        i += 2;
 5b0:	bfa1                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b2:	008b8493          	addi	s1,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000be583          	lwu	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e67ff0ef          	jal	426 <printint>
 5c4:	8ba6                	mv	s7,s1
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b781                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b8493          	addi	s1,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	e4fff0ef          	jal	426 <printint>
        i += 1;
 5dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	8ba6                	mv	s7,s1
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b71d                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e35ff0ef          	jal	426 <printint>
        i += 2;
 5f6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	8ba6                	mv	s7,s1
      state = 0;
 5fa:	4981                	li	s3,0
        i += 2;
 5fc:	b731                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5fe:	008b8493          	addi	s1,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000be583          	lwu	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e1bff0ef          	jal	426 <printint>
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	bdd5                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e03ff0ef          	jal	426 <printint>
        i += 1;
 628:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bde9                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	008b8493          	addi	s1,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	de9ff0ef          	jal	426 <printint>
        i += 2;
 642:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	b5c1                	j	508 <vprintf+0x44>
 64a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 64c:	008b8793          	addi	a5,s7,8
 650:	8cbe                	mv	s9,a5
 652:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 656:	03000593          	li	a1,48
 65a:	855a                	mv	a0,s6
 65c:	dadff0ef          	jal	408 <putc>
  putc(fd, 'x');
 660:	07800593          	li	a1,120
 664:	855a                	mv	a0,s6
 666:	da3ff0ef          	jal	408 <putc>
 66a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	3f4b8b93          	addi	s7,s7,1012 # a60 <digits>
 674:	03c9d793          	srli	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	855a                	mv	a0,s6
 680:	d89ff0ef          	jal	408 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 684:	0992                	slli	s3,s3,0x4
 686:	34fd                	addiw	s1,s1,-1
 688:	f4f5                	bnez	s1,674 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 68a:	8be6                	mv	s7,s9
      state = 0;
 68c:	4981                	li	s3,0
 68e:	6ca2                	ld	s9,8(sp)
 690:	bda5                	j	508 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 692:	008b8493          	addi	s1,s7,8
 696:	000bc583          	lbu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d6dff0ef          	jal	408 <putc>
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b595                	j	508 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a6:	008b8993          	addi	s3,s7,8
 6aa:	000bb483          	ld	s1,0(s7)
 6ae:	cc91                	beqz	s1,6ca <vprintf+0x206>
        for(; *s; s++)
 6b0:	0004c583          	lbu	a1,0(s1)
 6b4:	c985                	beqz	a1,6e4 <vprintf+0x220>
          putc(fd, *s);
 6b6:	855a                	mv	a0,s6
 6b8:	d51ff0ef          	jal	408 <putc>
        for(; *s; s++)
 6bc:	0485                	addi	s1,s1,1
 6be:	0004c583          	lbu	a1,0(s1)
 6c2:	f9f5                	bnez	a1,6b6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b581                	j	508 <vprintf+0x44>
          s = "(null)";
 6ca:	00000497          	auipc	s1,0x0
 6ce:	38e48493          	addi	s1,s1,910 # a58 <thread_join+0xaa>
        for(; *s; s++)
 6d2:	02800593          	li	a1,40
 6d6:	b7c5                	j	6b6 <vprintf+0x1f2>
        putc(fd, '%');
 6d8:	85be                	mv	a1,a5
 6da:	855a                	mv	a0,s6
 6dc:	d2dff0ef          	jal	408 <putc>
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b51d                	j	508 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b505                	j	508 <vprintf+0x44>
 6ea:	6906                	ld	s2,64(sp)
 6ec:	79e2                	ld	s3,56(sp)
 6ee:	7a42                	ld	s4,48(sp)
 6f0:	7aa2                	ld	s5,40(sp)
 6f2:	7b02                	ld	s6,32(sp)
 6f4:	6be2                	ld	s7,24(sp)
 6f6:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f8:	60e6                	ld	ra,88(sp)
 6fa:	6446                	ld	s0,80(sp)
 6fc:	64a6                	ld	s1,72(sp)
 6fe:	6125                	addi	sp,sp,96
 700:	8082                	ret
      if(c0 == 'd'){
 702:	06400713          	li	a4,100
 706:	e4e78fe3          	beq	a5,a4,564 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 70a:	f9478693          	addi	a3,a5,-108
 70e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 712:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 714:	4701                	li	a4,0
      } else if(c0 == 'u'){
 716:	07500513          	li	a0,117
 71a:	e8a78ce3          	beq	a5,a0,5b2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 71e:	f8b60513          	addi	a0,a2,-117
 722:	e119                	bnez	a0,728 <vprintf+0x264>
 724:	ea0693e3          	bnez	a3,5ca <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 728:	f8b58513          	addi	a0,a1,-117
 72c:	e119                	bnez	a0,732 <vprintf+0x26e>
 72e:	ea071be3          	bnez	a4,5e4 <vprintf+0x120>
      } else if(c0 == 'x'){
 732:	07800513          	li	a0,120
 736:	eca784e3          	beq	a5,a0,5fe <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 73a:	f8860613          	addi	a2,a2,-120
 73e:	e219                	bnez	a2,744 <vprintf+0x280>
 740:	ec069be3          	bnez	a3,616 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 744:	f8858593          	addi	a1,a1,-120
 748:	e199                	bnez	a1,74e <vprintf+0x28a>
 74a:	ee0713e3          	bnez	a4,630 <vprintf+0x16c>
      } else if(c0 == 'p'){
 74e:	07000713          	li	a4,112
 752:	eee78ce3          	beq	a5,a4,64a <vprintf+0x186>
      } else if(c0 == 'c'){
 756:	06300713          	li	a4,99
 75a:	f2e78ce3          	beq	a5,a4,692 <vprintf+0x1ce>
      } else if(c0 == 's'){
 75e:	07300713          	li	a4,115
 762:	f4e782e3          	beq	a5,a4,6a6 <vprintf+0x1e2>
      } else if(c0 == '%'){
 766:	02500713          	li	a4,37
 76a:	f6e787e3          	beq	a5,a4,6d8 <vprintf+0x214>
        putc(fd, '%');
 76e:	02500593          	li	a1,37
 772:	855a                	mv	a0,s6
 774:	c95ff0ef          	jal	408 <putc>
        putc(fd, c0);
 778:	85a6                	mv	a1,s1
 77a:	855a                	mv	a0,s6
 77c:	c8dff0ef          	jal	408 <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b359                	j	508 <vprintf+0x44>

0000000000000784 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 784:	715d                	addi	sp,sp,-80
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e010                	sd	a2,0(s0)
 78e:	e414                	sd	a3,8(s0)
 790:	e818                	sd	a4,16(s0)
 792:	ec1c                	sd	a5,24(s0)
 794:	03043023          	sd	a6,32(s0)
 798:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79c:	8622                	mv	a2,s0
 79e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a2:	d23ff0ef          	jal	4c4 <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <printf>:

void
printf(const char *fmt, ...)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	addi	s0,sp,32
 7b6:	e40c                	sd	a1,8(s0)
 7b8:	e810                	sd	a2,16(s0)
 7ba:	ec14                	sd	a3,24(s0)
 7bc:	f018                	sd	a4,32(s0)
 7be:	f41c                	sd	a5,40(s0)
 7c0:	03043823          	sd	a6,48(s0)
 7c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	00840613          	addi	a2,s0,8
 7cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d0:	85aa                	mv	a1,a0
 7d2:	4505                	li	a0,1
 7d4:	cf1ff0ef          	jal	4c4 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e406                	sd	ra,8(sp)
 7e4:	e022                	sd	s0,0(sp)
 7e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	00001797          	auipc	a5,0x1
 7f0:	8147b783          	ld	a5,-2028(a5) # 1000 <freep>
 7f4:	a039                	j	802 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	6398                	ld	a4,0(a5)
 7f8:	00e7e463          	bltu	a5,a4,800 <free+0x20>
 7fc:	00e6ea63          	bltu	a3,a4,810 <free+0x30>
{
 800:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	fed7fae3          	bgeu	a5,a3,7f6 <free+0x16>
 806:	6398                	ld	a4,0(a5)
 808:	00e6e463          	bltu	a3,a4,810 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80c:	fee7eae3          	bltu	a5,a4,800 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 810:	ff852583          	lw	a1,-8(a0)
 814:	6390                	ld	a2,0(a5)
 816:	02059813          	slli	a6,a1,0x20
 81a:	01c85713          	srli	a4,a6,0x1c
 81e:	9736                	add	a4,a4,a3
 820:	02e60563          	beq	a2,a4,84a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 828:	4790                	lw	a2,8(a5)
 82a:	02061593          	slli	a1,a2,0x20
 82e:	01c5d713          	srli	a4,a1,0x1c
 832:	973e                	add	a4,a4,a5
 834:	02e68263          	beq	a3,a4,858 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 838:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83a:	00000717          	auipc	a4,0x0
 83e:	7cf73323          	sd	a5,1990(a4) # 1000 <freep>
}
 842:	60a2                	ld	ra,8(sp)
 844:	6402                	ld	s0,0(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 84a:	4618                	lw	a4,8(a2)
 84c:	9f2d                	addw	a4,a4,a1
 84e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	6310                	ld	a2,0(a4)
 856:	b7f9                	j	824 <free+0x44>
    p->s.size += bp->s.size;
 858:	ff852703          	lw	a4,-8(a0)
 85c:	9f31                	addw	a4,a4,a2
 85e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 860:	ff053683          	ld	a3,-16(a0)
 864:	bfd1                	j	838 <free+0x58>

0000000000000866 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 866:	7139                	addi	sp,sp,-64
 868:	fc06                	sd	ra,56(sp)
 86a:	f822                	sd	s0,48(sp)
 86c:	f04a                	sd	s2,32(sp)
 86e:	ec4e                	sd	s3,24(sp)
 870:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	02051993          	slli	s3,a0,0x20
 876:	0209d993          	srli	s3,s3,0x20
 87a:	09bd                	addi	s3,s3,15
 87c:	0049d993          	srli	s3,s3,0x4
 880:	2985                	addiw	s3,s3,1
 882:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	77c53503          	ld	a0,1916(a0) # 1000 <freep>
 88c:	c905                	beqz	a0,8bc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	09377663          	bgeu	a4,s3,91e <malloc+0xb8>
 896:	f426                	sd	s1,40(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 89e:	8a4e                	mv	s4,s3
 8a0:	6705                	lui	a4,0x1
 8a2:	00e9f363          	bgeu	s3,a4,8a8 <malloc+0x42>
 8a6:	6a05                	lui	s4,0x1
 8a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b0:	00000497          	auipc	s1,0x0
 8b4:	75048493          	addi	s1,s1,1872 # 1000 <freep>
  if(p == SBRK_ERROR)
 8b8:	5afd                	li	s5,-1
 8ba:	a83d                	j	8f8 <malloc+0x92>
 8bc:	f426                	sd	s1,40(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c4:	00001797          	auipc	a5,0x1
 8c8:	94478793          	addi	a5,a5,-1724 # 1208 <base>
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8da:	b7d1                	j	89e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	e118                	sd	a4,0(a0)
 8e0:	a899                	j	936 <malloc+0xd0>
  hp->s.size = nu;
 8e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e6:	0541                	addi	a0,a0,16
 8e8:	ef9ff0ef          	jal	7e0 <free>
  return freep;
 8ec:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ee:	c125                	beqz	a0,94e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	03277163          	bgeu	a4,s2,916 <malloc+0xb0>
    if(p == freep)
 8f8:	6098                	ld	a4,0(s1)
 8fa:	853e                	mv	a0,a5
 8fc:	fef71ae3          	bne	a4,a5,8f0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 900:	8552                	mv	a0,s4
 902:	a0dff0ef          	jal	30e <sbrk>
  if(p == SBRK_ERROR)
 906:	fd551ee3          	bne	a0,s5,8e2 <malloc+0x7c>
        return 0;
 90a:	4501                	li	a0,0
 90c:	74a2                	ld	s1,40(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
 914:	a03d                	j	942 <malloc+0xdc>
 916:	74a2                	ld	s1,40(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 91e:	fae90fe3          	beq	s2,a4,8dc <malloc+0x76>
        p->s.size -= nunits;
 922:	4137073b          	subw	a4,a4,s3
 926:	c798                	sw	a4,8(a5)
        p += p->s.size;
 928:	02071693          	slli	a3,a4,0x20
 92c:	01c6d713          	srli	a4,a3,0x1c
 930:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 932:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 936:	00000717          	auipc	a4,0x0
 93a:	6ca73523          	sd	a0,1738(a4) # 1000 <freep>
      return (void*)(p + 1);
 93e:	01078513          	addi	a0,a5,16
  }
}
 942:	70e2                	ld	ra,56(sp)
 944:	7442                	ld	s0,48(sp)
 946:	7902                	ld	s2,32(sp)
 948:	69e2                	ld	s3,24(sp)
 94a:	6121                	addi	sp,sp,64
 94c:	8082                	ret
 94e:	74a2                	ld	s1,40(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
 956:	b7f5                	j	942 <malloc+0xdc>

0000000000000958 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 958:	7179                	addi	sp,sp,-48
 95a:	f406                	sd	ra,40(sp)
 95c:	f022                	sd	s0,32(sp)
 95e:	ec26                	sd	s1,24(sp)
 960:	e84a                	sd	s2,16(sp)
 962:	e44e                	sd	s3,8(sp)
 964:	1800                	addi	s0,sp,48
 966:	89aa                	mv	s3,a0
 968:	892e                	mv	s2,a1
 96a:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 96c:	00c6151b          	slliw	a0,a2,0xc
 970:	ef7ff0ef          	jal	866 <malloc>
  if(stack == 0) return -1;
 974:	c91d                	beqz	a0,9aa <thread_create+0x52>
 976:	e052                	sd	s4,0(sp)
 978:	862a                	mv	a2,a0
 97a:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 97c:	10000713          	li	a4,256
 980:	86a6                	mv	a3,s1
 982:	85ca                	mv	a1,s2
 984:	854e                	mv	a0,s3
 986:	9d3ff0ef          	jal	358 <clone>

  if(pid < 0) {
 98a:	00054a63          	bltz	a0,99e <thread_create+0x46>
 98e:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 990:	70a2                	ld	ra,40(sp)
 992:	7402                	ld	s0,32(sp)
 994:	64e2                	ld	s1,24(sp)
 996:	6942                	ld	s2,16(sp)
 998:	69a2                	ld	s3,8(sp)
 99a:	6145                	addi	sp,sp,48
 99c:	8082                	ret
    free(stack);
 99e:	8552                	mv	a0,s4
 9a0:	e41ff0ef          	jal	7e0 <free>
    return -1;
 9a4:	557d                	li	a0,-1
 9a6:	6a02                	ld	s4,0(sp)
 9a8:	b7e5                	j	990 <thread_create+0x38>
  if(stack == 0) return -1;
 9aa:	557d                	li	a0,-1
 9ac:	b7d5                	j	990 <thread_create+0x38>

00000000000009ae <thread_join>:

int
thread_join(void)
{
 9ae:	7179                	addi	sp,sp,-48
 9b0:	f406                	sd	ra,40(sp)
 9b2:	f022                	sd	s0,32(sp)
 9b4:	ec26                	sd	s1,24(sp)
 9b6:	1800                	addi	s0,sp,48
  void *stack = 0;
 9b8:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 9bc:	fd840513          	addi	a0,s0,-40
 9c0:	9a1ff0ef          	jal	360 <join>
 9c4:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 9c6:	00a05763          	blez	a0,9d4 <thread_join+0x26>
 9ca:	fd843503          	ld	a0,-40(s0)
 9ce:	c119                	beqz	a0,9d4 <thread_join+0x26>
    free(stack);
 9d0:	e11ff0ef          	jal	7e0 <free>
  }
  return pid;
}
 9d4:	8526                	mv	a0,s1
 9d6:	70a2                	ld	ra,40(sp)
 9d8:	7402                	ld	s0,32(sp)
 9da:	64e2                	ld	s1,24(sp)
 9dc:	6145                	addi	sp,sp,48
 9de:	8082                	ret
