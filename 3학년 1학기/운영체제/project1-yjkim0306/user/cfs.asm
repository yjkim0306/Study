
user/_cfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define PNUM 6
int nice_vals[PNUM] = {-3,-2, -1, 0, 1, 2};

#define LOOP_COUNT 1000000000

int main(int argc, char *argv[]) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
  printf("Starting CFS Test...\n");
   c:	00001517          	auipc	a0,0x1
  10:	9a450513          	addi	a0,a0,-1628 # 9b0 <malloc+0xf8>
  14:	7ec000ef          	jal	800 <printf>

  for (int i = 0; i < PNUM; i++) {
  18:	4481                	li	s1,0
  1a:	4919                	li	s2,6
    int pid = fork();
  1c:	38e000ef          	jal	3aa <fork>
    
    if (pid < 0) {
  20:	02054663          	bltz	a0,4c <main+0x4c>
      printf("fork failed\n");
      exit(1);
    }

    if (pid == 0) {
  24:	cd15                	beqz	a0,60 <main+0x60>
  for (int i = 0; i < PNUM; i++) {
  26:	2485                	addiw	s1,s1,1
  28:	ff249ae3          	bne	s1,s2,1c <main+0x1c>
  2c:	ec4e                	sd	s3,24(sp)
  2e:	4499                	li	s1,6
      exit(0);
    }
  }

  for (int i = 0; i < PNUM; i++) {
    wait(0);
  30:	4501                	li	a0,0
  32:	388000ef          	jal	3ba <wait>
  for (int i = 0; i < PNUM; i++) {
  36:	34fd                	addiw	s1,s1,-1
  38:	fce5                	bnez	s1,30 <main+0x30>
  }

  printf("CFS Test Completed.\n");
  3a:	00001517          	auipc	a0,0x1
  3e:	9de50513          	addi	a0,a0,-1570 # a18 <malloc+0x160>
  42:	7be000ef          	jal	800 <printf>
  exit(0);
  46:	4501                	li	a0,0
  48:	36a000ef          	jal	3b2 <exit>
  4c:	ec4e                	sd	s3,24(sp)
      printf("fork failed\n");
  4e:	00001517          	auipc	a0,0x1
  52:	97a50513          	addi	a0,a0,-1670 # 9c8 <malloc+0x110>
  56:	7aa000ef          	jal	800 <printf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	356000ef          	jal	3b2 <exit>
      if (set_nice(nice_vals[i]) != 0) {
  60:	00249713          	slli	a4,s1,0x2
  64:	00001797          	auipc	a5,0x1
  68:	f9c78793          	addi	a5,a5,-100 # 1000 <nice_vals>
  6c:	97ba                	add	a5,a5,a4
  6e:	4388                	lw	a0,0(a5)
  70:	3e2000ef          	jal	452 <set_nice>
  74:	c115                	beqz	a0,98 <main+0x98>
  76:	ec4e                	sd	s3,24(sp)
        printf("set_nice failed for nice %d\n", nice_vals[i]);
  78:	048a                	slli	s1,s1,0x2
  7a:	00001797          	auipc	a5,0x1
  7e:	f8678793          	addi	a5,a5,-122 # 1000 <nice_vals>
  82:	97a6                	add	a5,a5,s1
  84:	438c                	lw	a1,0(a5)
  86:	00001517          	auipc	a0,0x1
  8a:	95250513          	addi	a0,a0,-1710 # 9d8 <malloc+0x120>
  8e:	772000ef          	jal	800 <printf>
        exit(1);
  92:	4505                	li	a0,1
  94:	31e000ef          	jal	3b2 <exit>
  98:	ec4e                	sd	s3,24(sp)
      int start_tick = uptime();
  9a:	3b0000ef          	jal	44a <uptime>
  9e:	892a                	mv	s2,a0
      for (volatile int j = 0; j < LOOP_COUNT; j++) {
  a0:	fc042623          	sw	zero,-52(s0)
  a4:	fcc42703          	lw	a4,-52(s0)
  a8:	2701                	sext.w	a4,a4
  aa:	3b9ad7b7          	lui	a5,0x3b9ad
  ae:	9ff78793          	addi	a5,a5,-1537 # 3b9ac9ff <base+0x3b9ab9cf>
  b2:	00e7cd63          	blt	a5,a4,cc <main+0xcc>
  b6:	873e                	mv	a4,a5
  b8:	fcc42783          	lw	a5,-52(s0)
  bc:	2785                	addiw	a5,a5,1
  be:	fcf42623          	sw	a5,-52(s0)
  c2:	fcc42783          	lw	a5,-52(s0)
  c6:	2781                	sext.w	a5,a5
  c8:	fef758e3          	bge	a4,a5,b8 <main+0xb8>
      int end_tick = uptime();
  cc:	37e000ef          	jal	44a <uptime>
  d0:	89aa                	mv	s3,a0
      printf("PID: %d, Nice: %d, Ticks: %d\n", getpid(), nice_vals[i], end_tick - start_tick);
  d2:	360000ef          	jal	432 <getpid>
  d6:	85aa                	mv	a1,a0
  d8:	048a                	slli	s1,s1,0x2
  da:	00001797          	auipc	a5,0x1
  de:	f2678793          	addi	a5,a5,-218 # 1000 <nice_vals>
  e2:	97a6                	add	a5,a5,s1
  e4:	412986bb          	subw	a3,s3,s2
  e8:	4390                	lw	a2,0(a5)
  ea:	00001517          	auipc	a0,0x1
  ee:	90e50513          	addi	a0,a0,-1778 # 9f8 <malloc+0x140>
  f2:	70e000ef          	jal	800 <printf>
      exit(0);
  f6:	4501                	li	a0,0
  f8:	2ba000ef          	jal	3b2 <exit>

00000000000000fc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 104:	efdff0ef          	jal	0 <main>
  exit(r);
 108:	2aa000ef          	jal	3b2 <exit>

000000000000010c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 114:	87aa                	mv	a5,a0
 116:	0585                	addi	a1,a1,1
 118:	0785                	addi	a5,a5,1
 11a:	fff5c703          	lbu	a4,-1(a1)
 11e:	fee78fa3          	sb	a4,-1(a5)
 122:	fb75                	bnez	a4,116 <strcpy+0xa>
    ;
  return os;
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x20>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x20>
    p++, q++;
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 164:	00054783          	lbu	a5,0(a0)
 168:	cf91                	beqz	a5,184 <strlen+0x28>
 16a:	00150793          	addi	a5,a0,1
 16e:	86be                	mv	a3,a5
 170:	0785                	addi	a5,a5,1
 172:	fff7c703          	lbu	a4,-1(a5)
 176:	ff65                	bnez	a4,16e <strlen+0x12>
 178:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 17c:	60a2                	ld	ra,8(sp)
 17e:	6402                	ld	s0,0(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  for(n = 0; s[n]; n++)
 184:	4501                	li	a0,0
 186:	bfdd                	j	17c <strlen+0x20>

0000000000000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 190:	ca19                	beqz	a2,1a6 <memset+0x1e>
 192:	87aa                	mv	a5,a0
 194:	1602                	slli	a2,a2,0x20
 196:	9201                	srli	a2,a2,0x20
 198:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	0785                	addi	a5,a5,1
 1a2:	fee79de3          	bne	a5,a4,19c <memset+0x14>
  }
  return dst;
}
 1a6:	60a2                	ld	ra,8(sp)
 1a8:	6402                	ld	s0,0(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cf81                	beqz	a5,1d2 <strchr+0x24>
    if(*s == c)
 1bc:	00f58763          	beq	a1,a5,1ca <strchr+0x1c>
  for(; *s; s++)
 1c0:	0505                	addi	a0,a0,1
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbfd                	bnez	a5,1bc <strchr+0xe>
      return (char*)s;
  return 0;
 1c8:	4501                	li	a0,0
}
 1ca:	60a2                	ld	ra,8(sp)
 1cc:	6402                	ld	s0,0(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfdd                	j	1ca <strchr+0x1c>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	e862                	sd	s8,16(sp)
 1ec:	1080                	addi	s0,sp,96
 1ee:	8baa                	mv	s7,a0
 1f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f2:	892a                	mv	s2,a0
 1f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f6:	faf40b13          	addi	s6,s0,-81
 1fa:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1fc:	8c26                	mv	s8,s1
 1fe:	0014899b          	addiw	s3,s1,1
 202:	84ce                	mv	s1,s3
 204:	0349d463          	bge	s3,s4,22c <gets+0x56>
    cc = read(0, &c, 1);
 208:	8656                	mv	a2,s5
 20a:	85da                	mv	a1,s6
 20c:	4501                	li	a0,0
 20e:	1bc000ef          	jal	3ca <read>
    if(cc < 1)
 212:	00a05d63          	blez	a0,22c <gets+0x56>
      break;
    buf[i++] = c;
 216:	faf44783          	lbu	a5,-81(s0)
 21a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21e:	0905                	addi	s2,s2,1
 220:	ff678713          	addi	a4,a5,-10
 224:	c319                	beqz	a4,22a <gets+0x54>
 226:	17cd                	addi	a5,a5,-13
 228:	fbf1                	bnez	a5,1fc <gets+0x26>
    buf[i++] = c;
 22a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 22c:	9c5e                	add	s8,s8,s7
 22e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6c42                	ld	s8,16(sp)
 248:	6125                	addi	sp,sp,96
 24a:	8082                	ret

000000000000024c <stat>:

int
stat(const char *n, struct stat *st)
{
 24c:	1101                	addi	sp,sp,-32
 24e:	ec06                	sd	ra,24(sp)
 250:	e822                	sd	s0,16(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	198000ef          	jal	3f2 <open>
  if(fd < 0)
 25e:	02054263          	bltz	a0,282 <stat+0x36>
 262:	e426                	sd	s1,8(sp)
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	1a2000ef          	jal	40a <fstat>
 26c:	892a                	mv	s2,a0
  close(fd);
 26e:	8526                	mv	a0,s1
 270:	16a000ef          	jal	3da <close>
  return r;
 274:	64a2                	ld	s1,8(sp)
}
 276:	854a                	mv	a0,s2
 278:	60e2                	ld	ra,24(sp)
 27a:	6442                	ld	s0,16(sp)
 27c:	6902                	ld	s2,0(sp)
 27e:	6105                	addi	sp,sp,32
 280:	8082                	ret
    return -1;
 282:	57fd                	li	a5,-1
 284:	893e                	mv	s2,a5
 286:	bfc5                	j	276 <stat+0x2a>

0000000000000288 <atoi>:

int
atoi(const char *s)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 290:	00054683          	lbu	a3,0(a0)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	4625                	li	a2,9
 29e:	02f66963          	bltu	a2,a5,2d0 <atoi+0x48>
 2a2:	872a                	mv	a4,a0
  n = 0;
 2a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a6:	0705                	addi	a4,a4,1
 2a8:	0025179b          	slliw	a5,a0,0x2
 2ac:	9fa9                	addw	a5,a5,a0
 2ae:	0017979b          	slliw	a5,a5,0x1
 2b2:	9fb5                	addw	a5,a5,a3
 2b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b8:	00074683          	lbu	a3,0(a4)
 2bc:	fd06879b          	addiw	a5,a3,-48
 2c0:	0ff7f793          	zext.b	a5,a5
 2c4:	fef671e3          	bgeu	a2,a5,2a6 <atoi+0x1e>
  return n;
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  n = 0;
 2d0:	4501                	li	a0,0
 2d2:	bfdd                	j	2c8 <atoi+0x40>

00000000000002d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2dc:	02b57563          	bgeu	a0,a1,306 <memmove+0x32>
    while(n-- > 0)
 2e0:	00c05f63          	blez	a2,2fe <memmove+0x2a>
 2e4:	1602                	slli	a2,a2,0x20
 2e6:	9201                	srli	a2,a2,0x20
 2e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ee:	0585                	addi	a1,a1,1
 2f0:	0705                	addi	a4,a4,1
 2f2:	fff5c683          	lbu	a3,-1(a1)
 2f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fa:	fee79ae3          	bne	a5,a4,2ee <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
    while(n-- > 0)
 306:	fec05ce3          	blez	a2,2fe <memmove+0x2a>
    dst += n;
 30a:	00c50733          	add	a4,a0,a2
    src += n;
 30e:	95b2                	add	a1,a1,a2
 310:	fff6079b          	addiw	a5,a2,-1
 314:	1782                	slli	a5,a5,0x20
 316:	9381                	srli	a5,a5,0x20
 318:	fff7c793          	not	a5,a5
 31c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31e:	15fd                	addi	a1,a1,-1
 320:	177d                	addi	a4,a4,-1
 322:	0005c683          	lbu	a3,0(a1)
 326:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32a:	fef71ae3          	bne	a4,a5,31e <memmove+0x4a>
 32e:	bfc1                	j	2fe <memmove+0x2a>

0000000000000330 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 338:	c61d                	beqz	a2,366 <memcmp+0x36>
 33a:	1602                	slli	a2,a2,0x20
 33c:	9201                	srli	a2,a2,0x20
 33e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	addi	a0,a0,1
    p2++;
 350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x12>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x2e>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfdd                	j	35e <memcmp+0x2e>

000000000000036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 372:	f63ff0ef          	jal	2d4 <memmove>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <sbrk>:

char *
sbrk(int n) {
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 386:	4585                	li	a1,1
 388:	0b2000ef          	jal	43a <sys_sbrk>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <sbrklazy>:

char *
sbrklazy(int n) {
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 39c:	4589                	li	a1,2
 39e:	09c000ef          	jal	43a <sys_sbrk>
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3aa:	4885                	li	a7,1
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b2:	4889                	li	a7,2
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ba:	488d                	li	a7,3
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c2:	4891                	li	a7,4
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <read>:
.global read
read:
 li a7, SYS_read
 3ca:	4895                	li	a7,5
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <write>:
.global write
write:
 li a7, SYS_write
 3d2:	48c1                	li	a7,16
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <close>:
.global close
close:
 li a7, SYS_close
 3da:	48d5                	li	a7,21
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e2:	4899                	li	a7,6
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ea:	489d                	li	a7,7
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <open>:
.global open
open:
 li a7, SYS_open
 3f2:	48bd                	li	a7,15
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fa:	48c5                	li	a7,17
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 402:	48c9                	li	a7,18
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40a:	48a1                	li	a7,8
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <link>:
.global link
link:
 li a7, SYS_link
 412:	48cd                	li	a7,19
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41a:	48d1                	li	a7,20
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 422:	48a5                	li	a7,9
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <dup>:
.global dup
dup:
 li a7, SYS_dup
 42a:	48a9                	li	a7,10
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 432:	48ad                	li	a7,11
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 43a:	48b1                	li	a7,12
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <pause>:
.global pause
pause:
 li a7, SYS_pause
 442:	48b5                	li	a7,13
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44a:	48b9                	li	a7,14
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <set_nice>:
.global set_nice
set_nice:
 li a7, SYS_set_nice
 452:	48d9                	li	a7,22
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	f67ff0ef          	jal	3d2 <write>
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 478:	715d                	addi	sp,sp,-80
 47a:	e486                	sd	ra,72(sp)
 47c:	e0a2                	sd	s0,64(sp)
 47e:	f84a                	sd	s2,48(sp)
 480:	f44e                	sd	s3,40(sp)
 482:	0880                	addi	s0,sp,80
 484:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 486:	c6d1                	beqz	a3,512 <printint+0x9a>
 488:	0805d563          	bgez	a1,512 <printint+0x9a>
    neg = 1;
    x = -xx;
 48c:	40b005b3          	neg	a1,a1
    neg = 1;
 490:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 492:	fb840993          	addi	s3,s0,-72
  neg = 0;
 496:	86ce                	mv	a3,s3
  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	00000817          	auipc	a6,0x0
 49e:	59e80813          	addi	a6,a6,1438 # a38 <digits>
 4a2:	88ba                	mv	a7,a4
 4a4:	0017051b          	addiw	a0,a4,1
 4a8:	872a                	mv	a4,a0
 4aa:	02c5f7b3          	remu	a5,a1,a2
 4ae:	97c2                	add	a5,a5,a6
 4b0:	0007c783          	lbu	a5,0(a5)
 4b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b8:	87ae                	mv	a5,a1
 4ba:	02c5d5b3          	divu	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fec7f1e3          	bgeu	a5,a2,4a2 <printint+0x2a>
  if(neg)
 4c4:	00030c63          	beqz	t1,4dc <printint+0x64>
    buf[i++] = '-';
 4c8:	fd050793          	addi	a5,a0,-48
 4cc:	00878533          	add	a0,a5,s0
 4d0:	02d00793          	li	a5,45
 4d4:	fef50423          	sb	a5,-24(a0)
 4d8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4dc:	02e05563          	blez	a4,506 <printint+0x8e>
 4e0:	fc26                	sd	s1,56(sp)
 4e2:	377d                	addiw	a4,a4,-1
 4e4:	00e984b3          	add	s1,s3,a4
 4e8:	19fd                	addi	s3,s3,-1
 4ea:	99ba                	add	s3,s3,a4
 4ec:	1702                	slli	a4,a4,0x20
 4ee:	9301                	srli	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	0004c583          	lbu	a1,0(s1)
 4f8:	854a                	mv	a0,s2
 4fa:	f61ff0ef          	jal	45a <putc>
  while(--i >= 0)
 4fe:	14fd                	addi	s1,s1,-1
 500:	ff349ae3          	bne	s1,s3,4f4 <printint+0x7c>
 504:	74e2                	ld	s1,56(sp)
}
 506:	60a6                	ld	ra,72(sp)
 508:	6406                	ld	s0,64(sp)
 50a:	7942                	ld	s2,48(sp)
 50c:	79a2                	ld	s3,40(sp)
 50e:	6161                	addi	sp,sp,80
 510:	8082                	ret
  neg = 0;
 512:	4301                	li	t1,0
 514:	bfbd                	j	492 <printint+0x1a>

0000000000000516 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 516:	711d                	addi	sp,sp,-96
 518:	ec86                	sd	ra,88(sp)
 51a:	e8a2                	sd	s0,80(sp)
 51c:	e4a6                	sd	s1,72(sp)
 51e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 520:	0005c483          	lbu	s1,0(a1)
 524:	22048363          	beqz	s1,74a <vprintf+0x234>
 528:	e0ca                	sd	s2,64(sp)
 52a:	fc4e                	sd	s3,56(sp)
 52c:	f852                	sd	s4,48(sp)
 52e:	f456                	sd	s5,40(sp)
 530:	f05a                	sd	s6,32(sp)
 532:	ec5e                	sd	s7,24(sp)
 534:	e862                	sd	s8,16(sp)
 536:	8b2a                	mv	s6,a0
 538:	8a2e                	mv	s4,a1
 53a:	8bb2                	mv	s7,a2
  state = 0;
 53c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 53e:	4901                	li	s2,0
 540:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 542:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 546:	06400c13          	li	s8,100
 54a:	a00d                	j	56c <vprintf+0x56>
        putc(fd, c0);
 54c:	85a6                	mv	a1,s1
 54e:	855a                	mv	a0,s6
 550:	f0bff0ef          	jal	45a <putc>
 554:	a019                	j	55a <vprintf+0x44>
    } else if(state == '%'){
 556:	03598363          	beq	s3,s5,57c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 55a:	0019079b          	addiw	a5,s2,1
 55e:	893e                	mv	s2,a5
 560:	873e                	mv	a4,a5
 562:	97d2                	add	a5,a5,s4
 564:	0007c483          	lbu	s1,0(a5)
 568:	1c048a63          	beqz	s1,73c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 56c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 570:	fe0993e3          	bnez	s3,556 <vprintf+0x40>
      if(c0 == '%'){
 574:	fd579ce3          	bne	a5,s5,54c <vprintf+0x36>
        state = '%';
 578:	89be                	mv	s3,a5
 57a:	b7c5                	j	55a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 57c:	00ea06b3          	add	a3,s4,a4
 580:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 584:	1c060863          	beqz	a2,754 <vprintf+0x23e>
      if(c0 == 'd'){
 588:	03878763          	beq	a5,s8,5b6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	f9478693          	addi	a3,a5,-108
 590:	0016b693          	seqz	a3,a3
 594:	f9c60593          	addi	a1,a2,-100
 598:	e99d                	bnez	a1,5ce <vprintf+0xb8>
 59a:	ca95                	beqz	a3,5ce <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	ecfff0ef          	jal	478 <printint>
        i += 1;
 5ae:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b75d                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	eb5ff0ef          	jal	478 <printint>
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b779                	j	55a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5ce:	9752                	add	a4,a4,s4
 5d0:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d4:	f9460713          	addi	a4,a2,-108
 5d8:	00173713          	seqz	a4,a4
 5dc:	8f75                	and	a4,a4,a3
 5de:	f9c58513          	addi	a0,a1,-100
 5e2:	18051363          	bnez	a0,768 <vprintf+0x252>
 5e6:	18070163          	beqz	a4,768 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	008b8493          	addi	s1,s7,8
 5ee:	4685                	li	a3,1
 5f0:	4629                	li	a2,10
 5f2:	000bb583          	ld	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	e81ff0ef          	jal	478 <printint>
        i += 2;
 5fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	8ba6                	mv	s7,s1
      state = 0;
 600:	4981                	li	s3,0
        i += 2;
 602:	bfa1                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 604:	008b8493          	addi	s1,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000be583          	lwu	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	e67ff0ef          	jal	478 <printint>
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
 61a:	b781                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e4fff0ef          	jal	478 <printint>
        i += 1;
 62e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
 634:	b71d                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b8493          	addi	s1,s7,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e35ff0ef          	jal	478 <printint>
        i += 2;
 648:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	b731                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 650:	008b8493          	addi	s1,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000be583          	lwu	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e1bff0ef          	jal	478 <printint>
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
 666:	bdd5                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e03ff0ef          	jal	478 <printint>
        i += 1;
 67a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
 680:	bde9                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	008b8493          	addi	s1,s7,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	de9ff0ef          	jal	478 <printint>
        i += 2;
 694:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	b5c1                	j	55a <vprintf+0x44>
 69c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 69e:	008b8793          	addi	a5,s7,8
 6a2:	8cbe                	mv	s9,a5
 6a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a8:	03000593          	li	a1,48
 6ac:	855a                	mv	a0,s6
 6ae:	dadff0ef          	jal	45a <putc>
  putc(fd, 'x');
 6b2:	07800593          	li	a1,120
 6b6:	855a                	mv	a0,s6
 6b8:	da3ff0ef          	jal	45a <putc>
 6bc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	37ab8b93          	addi	s7,s7,890 # a38 <digits>
 6c6:	03c9d793          	srli	a5,s3,0x3c
 6ca:	97de                	add	a5,a5,s7
 6cc:	0007c583          	lbu	a1,0(a5)
 6d0:	855a                	mv	a0,s6
 6d2:	d89ff0ef          	jal	45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d6:	0992                	slli	s3,s3,0x4
 6d8:	34fd                	addiw	s1,s1,-1
 6da:	f4f5                	bnez	s1,6c6 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6dc:	8be6                	mv	s7,s9
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	6ca2                	ld	s9,8(sp)
 6e2:	bda5                	j	55a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6e4:	008b8493          	addi	s1,s7,8
 6e8:	000bc583          	lbu	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	d6dff0ef          	jal	45a <putc>
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b595                	j	55a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6f8:	008b8993          	addi	s3,s7,8
 6fc:	000bb483          	ld	s1,0(s7)
 700:	cc91                	beqz	s1,71c <vprintf+0x206>
        for(; *s; s++)
 702:	0004c583          	lbu	a1,0(s1)
 706:	c985                	beqz	a1,736 <vprintf+0x220>
          putc(fd, *s);
 708:	855a                	mv	a0,s6
 70a:	d51ff0ef          	jal	45a <putc>
        for(; *s; s++)
 70e:	0485                	addi	s1,s1,1
 710:	0004c583          	lbu	a1,0(s1)
 714:	f9f5                	bnez	a1,708 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 716:	8bce                	mv	s7,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	b581                	j	55a <vprintf+0x44>
          s = "(null)";
 71c:	00000497          	auipc	s1,0x0
 720:	31448493          	addi	s1,s1,788 # a30 <malloc+0x178>
        for(; *s; s++)
 724:	02800593          	li	a1,40
 728:	b7c5                	j	708 <vprintf+0x1f2>
        putc(fd, '%');
 72a:	85be                	mv	a1,a5
 72c:	855a                	mv	a0,s6
 72e:	d2dff0ef          	jal	45a <putc>
      state = 0;
 732:	4981                	li	s3,0
 734:	b51d                	j	55a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 736:	8bce                	mv	s7,s3
      state = 0;
 738:	4981                	li	s3,0
 73a:	b505                	j	55a <vprintf+0x44>
 73c:	6906                	ld	s2,64(sp)
 73e:	79e2                	ld	s3,56(sp)
 740:	7a42                	ld	s4,48(sp)
 742:	7aa2                	ld	s5,40(sp)
 744:	7b02                	ld	s6,32(sp)
 746:	6be2                	ld	s7,24(sp)
 748:	6c42                	ld	s8,16(sp)
    }
  }
}
 74a:	60e6                	ld	ra,88(sp)
 74c:	6446                	ld	s0,80(sp)
 74e:	64a6                	ld	s1,72(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret
      if(c0 == 'd'){
 754:	06400713          	li	a4,100
 758:	e4e78fe3          	beq	a5,a4,5b6 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 75c:	f9478693          	addi	a3,a5,-108
 760:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 764:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 766:	4701                	li	a4,0
      } else if(c0 == 'u'){
 768:	07500513          	li	a0,117
 76c:	e8a78ce3          	beq	a5,a0,604 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 770:	f8b60513          	addi	a0,a2,-117
 774:	e119                	bnez	a0,77a <vprintf+0x264>
 776:	ea0693e3          	bnez	a3,61c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 77a:	f8b58513          	addi	a0,a1,-117
 77e:	e119                	bnez	a0,784 <vprintf+0x26e>
 780:	ea071be3          	bnez	a4,636 <vprintf+0x120>
      } else if(c0 == 'x'){
 784:	07800513          	li	a0,120
 788:	eca784e3          	beq	a5,a0,650 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 78c:	f8860613          	addi	a2,a2,-120
 790:	e219                	bnez	a2,796 <vprintf+0x280>
 792:	ec069be3          	bnez	a3,668 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 796:	f8858593          	addi	a1,a1,-120
 79a:	e199                	bnez	a1,7a0 <vprintf+0x28a>
 79c:	ee0713e3          	bnez	a4,682 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7a0:	07000713          	li	a4,112
 7a4:	eee78ce3          	beq	a5,a4,69c <vprintf+0x186>
      } else if(c0 == 'c'){
 7a8:	06300713          	li	a4,99
 7ac:	f2e78ce3          	beq	a5,a4,6e4 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7b0:	07300713          	li	a4,115
 7b4:	f4e782e3          	beq	a5,a4,6f8 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7b8:	02500713          	li	a4,37
 7bc:	f6e787e3          	beq	a5,a4,72a <vprintf+0x214>
        putc(fd, '%');
 7c0:	02500593          	li	a1,37
 7c4:	855a                	mv	a0,s6
 7c6:	c95ff0ef          	jal	45a <putc>
        putc(fd, c0);
 7ca:	85a6                	mv	a1,s1
 7cc:	855a                	mv	a0,s6
 7ce:	c8dff0ef          	jal	45a <putc>
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b359                	j	55a <vprintf+0x44>

00000000000007d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d6:	715d                	addi	sp,sp,-80
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e010                	sd	a2,0(s0)
 7e0:	e414                	sd	a3,8(s0)
 7e2:	e818                	sd	a4,16(s0)
 7e4:	ec1c                	sd	a5,24(s0)
 7e6:	03043023          	sd	a6,32(s0)
 7ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ee:	8622                	mv	a2,s0
 7f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f4:	d23ff0ef          	jal	516 <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6161                	addi	sp,sp,80
 7fe:	8082                	ret

0000000000000800 <printf>:

void
printf(const char *fmt, ...)
{
 800:	711d                	addi	sp,sp,-96
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	1000                	addi	s0,sp,32
 808:	e40c                	sd	a1,8(s0)
 80a:	e810                	sd	a2,16(s0)
 80c:	ec14                	sd	a3,24(s0)
 80e:	f018                	sd	a4,32(s0)
 810:	f41c                	sd	a5,40(s0)
 812:	03043823          	sd	a6,48(s0)
 816:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	00840613          	addi	a2,s0,8
 81e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 822:	85aa                	mv	a1,a0
 824:	4505                	li	a0,1
 826:	cf1ff0ef          	jal	516 <vprintf>
}
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	6125                	addi	sp,sp,96
 830:	8082                	ret

0000000000000832 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 832:	1141                	addi	sp,sp,-16
 834:	e406                	sd	ra,8(sp)
 836:	e022                	sd	s0,0(sp)
 838:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83e:	00000797          	auipc	a5,0x0
 842:	7e27b783          	ld	a5,2018(a5) # 1020 <freep>
 846:	a039                	j	854 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 848:	6398                	ld	a4,0(a5)
 84a:	00e7e463          	bltu	a5,a4,852 <free+0x20>
 84e:	00e6ea63          	bltu	a3,a4,862 <free+0x30>
{
 852:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	fed7fae3          	bgeu	a5,a3,848 <free+0x16>
 858:	6398                	ld	a4,0(a5)
 85a:	00e6e463          	bltu	a3,a4,862 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	fee7eae3          	bltu	a5,a4,852 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 862:	ff852583          	lw	a1,-8(a0)
 866:	6390                	ld	a2,0(a5)
 868:	02059813          	slli	a6,a1,0x20
 86c:	01c85713          	srli	a4,a6,0x1c
 870:	9736                	add	a4,a4,a3
 872:	02e60563          	beq	a2,a4,89c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 87a:	4790                	lw	a2,8(a5)
 87c:	02061593          	slli	a1,a2,0x20
 880:	01c5d713          	srli	a4,a1,0x1c
 884:	973e                	add	a4,a4,a5
 886:	02e68263          	beq	a3,a4,8aa <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 88a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88c:	00000717          	auipc	a4,0x0
 890:	78f73a23          	sd	a5,1940(a4) # 1020 <freep>
}
 894:	60a2                	ld	ra,8(sp)
 896:	6402                	ld	s0,0(sp)
 898:	0141                	addi	sp,sp,16
 89a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 89c:	4618                	lw	a4,8(a2)
 89e:	9f2d                	addw	a4,a4,a1
 8a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	6398                	ld	a4,0(a5)
 8a6:	6310                	ld	a2,0(a4)
 8a8:	b7f9                	j	876 <free+0x44>
    p->s.size += bp->s.size;
 8aa:	ff852703          	lw	a4,-8(a0)
 8ae:	9f31                	addw	a4,a4,a2
 8b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b2:	ff053683          	ld	a3,-16(a0)
 8b6:	bfd1                	j	88a <free+0x58>

00000000000008b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b8:	7139                	addi	sp,sp,-64
 8ba:	fc06                	sd	ra,56(sp)
 8bc:	f822                	sd	s0,48(sp)
 8be:	f04a                	sd	s2,32(sp)
 8c0:	ec4e                	sd	s3,24(sp)
 8c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c4:	02051993          	slli	s3,a0,0x20
 8c8:	0209d993          	srli	s3,s3,0x20
 8cc:	09bd                	addi	s3,s3,15
 8ce:	0049d993          	srli	s3,s3,0x4
 8d2:	2985                	addiw	s3,s3,1
 8d4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8d6:	00000517          	auipc	a0,0x0
 8da:	74a53503          	ld	a0,1866(a0) # 1020 <freep>
 8de:	c905                	beqz	a0,90e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	09377663          	bgeu	a4,s3,970 <malloc+0xb8>
 8e8:	f426                	sd	s1,40(sp)
 8ea:	e852                	sd	s4,16(sp)
 8ec:	e456                	sd	s5,8(sp)
 8ee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f0:	8a4e                	mv	s4,s3
 8f2:	6705                	lui	a4,0x1
 8f4:	00e9f363          	bgeu	s3,a4,8fa <malloc+0x42>
 8f8:	6a05                	lui	s4,0x1
 8fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 902:	00000497          	auipc	s1,0x0
 906:	71e48493          	addi	s1,s1,1822 # 1020 <freep>
  if(p == SBRK_ERROR)
 90a:	5afd                	li	s5,-1
 90c:	a83d                	j	94a <malloc+0x92>
 90e:	f426                	sd	s1,40(sp)
 910:	e852                	sd	s4,16(sp)
 912:	e456                	sd	s5,8(sp)
 914:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 916:	00000797          	auipc	a5,0x0
 91a:	71a78793          	addi	a5,a5,1818 # 1030 <base>
 91e:	00000717          	auipc	a4,0x0
 922:	70f73123          	sd	a5,1794(a4) # 1020 <freep>
 926:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 928:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92c:	b7d1                	j	8f0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 92e:	6398                	ld	a4,0(a5)
 930:	e118                	sd	a4,0(a0)
 932:	a899                	j	988 <malloc+0xd0>
  hp->s.size = nu;
 934:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 938:	0541                	addi	a0,a0,16
 93a:	ef9ff0ef          	jal	832 <free>
  return freep;
 93e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 940:	c125                	beqz	a0,9a0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 944:	4798                	lw	a4,8(a5)
 946:	03277163          	bgeu	a4,s2,968 <malloc+0xb0>
    if(p == freep)
 94a:	6098                	ld	a4,0(s1)
 94c:	853e                	mv	a0,a5
 94e:	fef71ae3          	bne	a4,a5,942 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 952:	8552                	mv	a0,s4
 954:	a2bff0ef          	jal	37e <sbrk>
  if(p == SBRK_ERROR)
 958:	fd551ee3          	bne	a0,s5,934 <malloc+0x7c>
        return 0;
 95c:	4501                	li	a0,0
 95e:	74a2                	ld	s1,40(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
 966:	a03d                	j	994 <malloc+0xdc>
 968:	74a2                	ld	s1,40(sp)
 96a:	6a42                	ld	s4,16(sp)
 96c:	6aa2                	ld	s5,8(sp)
 96e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 970:	fae90fe3          	beq	s2,a4,92e <malloc+0x76>
        p->s.size -= nunits;
 974:	4137073b          	subw	a4,a4,s3
 978:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97a:	02071693          	slli	a3,a4,0x20
 97e:	01c6d713          	srli	a4,a3,0x1c
 982:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 984:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 988:	00000717          	auipc	a4,0x0
 98c:	68a73c23          	sd	a0,1688(a4) # 1020 <freep>
      return (void*)(p + 1);
 990:	01078513          	addi	a0,a5,16
  }
}
 994:	70e2                	ld	ra,56(sp)
 996:	7442                	ld	s0,48(sp)
 998:	7902                	ld	s2,32(sp)
 99a:	69e2                	ld	s3,24(sp)
 99c:	6121                	addi	sp,sp,64
 99e:	8082                	ret
 9a0:	74a2                	ld	s1,40(sp)
 9a2:	6a42                	ld	s4,16(sp)
 9a4:	6aa2                	ld	s5,8(sp)
 9a6:	6b02                	ld	s6,0(sp)
 9a8:	b7f5                	j	994 <malloc+0xdc>
