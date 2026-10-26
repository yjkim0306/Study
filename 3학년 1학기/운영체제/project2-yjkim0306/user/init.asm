
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	a0250513          	addi	a0,a0,-1534 # a10 <thread_join+0x32>
  16:	3c2000ef          	jal	3d8 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3f0000ef          	jal	410 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3ea000ef          	jal	410 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	9ee90913          	addi	s2,s2,-1554 # a18 <thread_join+0x3a>
  32:	854a                	mv	a0,s2
  34:	7aa000ef          	jal	7de <printf>
    pid = fork();
  38:	332000ef          	jal	36a <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	35a000ef          	jal	3a0 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	a1650513          	addi	a0,a0,-1514 # a68 <thread_join+0x8a>
  5a:	784000ef          	jal	7de <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	338000ef          	jal	398 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	9a850513          	addi	a0,a0,-1624 # a10 <thread_join+0x32>
  70:	370000ef          	jal	3e0 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	99a50513          	addi	a0,a0,-1638 # a10 <thread_join+0x32>
  7e:	35a000ef          	jal	3d8 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	9ac50513          	addi	a0,a0,-1620 # a30 <thread_join+0x52>
  8c:	752000ef          	jal	7de <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	306000ef          	jal	398 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	9aa50513          	addi	a0,a0,-1622 # a48 <thread_join+0x6a>
  a6:	32a000ef          	jal	3d0 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	9a650513          	addi	a0,a0,-1626 # a50 <thread_join+0x72>
  b2:	72c000ef          	jal	7de <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2e0000ef          	jal	398 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	2d0000ef          	jal	398 <exit>

00000000000000cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0xa>
    ;
  return os;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x20>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x20>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x28>
 12a:	00150793          	addi	a5,a0,1
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x12>
 138:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for(n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfdd                	j	13c <strlen+0x20>

0000000000000148 <memset>:

void*
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 150:	ca19                	beqz	a2,166 <memset+0x1e>
 152:	87aa                	mv	a5,a0
 154:	1602                	slli	a2,a2,0x20
 156:	9201                	srli	a2,a2,0x20
 158:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 160:	0785                	addi	a5,a5,1
 162:	fee79de3          	bne	a5,a4,15c <memset+0x14>
  }
  return dst;
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  for(; *s; s++)
 176:	00054783          	lbu	a5,0(a0)
 17a:	cf81                	beqz	a5,192 <strchr+0x24>
    if(*s == c)
 17c:	00f58763          	beq	a1,a5,18a <strchr+0x1c>
  for(; *s; s++)
 180:	0505                	addi	a0,a0,1
 182:	00054783          	lbu	a5,0(a0)
 186:	fbfd                	bnez	a5,17c <strchr+0xe>
      return (char*)s;
  return 0;
 188:	4501                	li	a0,0
}
 18a:	60a2                	ld	ra,8(sp)
 18c:	6402                	ld	s0,0(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  return 0;
 192:	4501                	li	a0,0
 194:	bfdd                	j	18a <strchr+0x1c>

0000000000000196 <gets>:

char*
gets(char *buf, int max)
{
 196:	711d                	addi	sp,sp,-96
 198:	ec86                	sd	ra,88(sp)
 19a:	e8a2                	sd	s0,80(sp)
 19c:	e4a6                	sd	s1,72(sp)
 19e:	e0ca                	sd	s2,64(sp)
 1a0:	fc4e                	sd	s3,56(sp)
 1a2:	f852                	sd	s4,48(sp)
 1a4:	f456                	sd	s5,40(sp)
 1a6:	f05a                	sd	s6,32(sp)
 1a8:	ec5e                	sd	s7,24(sp)
 1aa:	e862                	sd	s8,16(sp)
 1ac:	1080                	addi	s0,sp,96
 1ae:	8baa                	mv	s7,a0
 1b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b2:	892a                	mv	s2,a0
 1b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b6:	faf40b13          	addi	s6,s0,-81
 1ba:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1bc:	8c26                	mv	s8,s1
 1be:	0014899b          	addiw	s3,s1,1
 1c2:	84ce                	mv	s1,s3
 1c4:	0349d463          	bge	s3,s4,1ec <gets+0x56>
    cc = read(0, &c, 1);
 1c8:	8656                	mv	a2,s5
 1ca:	85da                	mv	a1,s6
 1cc:	4501                	li	a0,0
 1ce:	1e2000ef          	jal	3b0 <read>
    if(cc < 1)
 1d2:	00a05d63          	blez	a0,1ec <gets+0x56>
      break;
    buf[i++] = c;
 1d6:	faf44783          	lbu	a5,-81(s0)
 1da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1de:	0905                	addi	s2,s2,1
 1e0:	ff678713          	addi	a4,a5,-10
 1e4:	c319                	beqz	a4,1ea <gets+0x54>
 1e6:	17cd                	addi	a5,a5,-13
 1e8:	fbf1                	bnez	a5,1bc <gets+0x26>
    buf[i++] = c;
 1ea:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ec:	9c5e                	add	s8,s8,s7
 1ee:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f2:	855e                	mv	a0,s7
 1f4:	60e6                	ld	ra,88(sp)
 1f6:	6446                	ld	s0,80(sp)
 1f8:	64a6                	ld	s1,72(sp)
 1fa:	6906                	ld	s2,64(sp)
 1fc:	79e2                	ld	s3,56(sp)
 1fe:	7a42                	ld	s4,48(sp)
 200:	7aa2                	ld	s5,40(sp)
 202:	7b02                	ld	s6,32(sp)
 204:	6be2                	ld	s7,24(sp)
 206:	6c42                	ld	s8,16(sp)
 208:	6125                	addi	sp,sp,96
 20a:	8082                	ret

000000000000020c <stat>:

int
stat(const char *n, struct stat *st)
{
 20c:	1101                	addi	sp,sp,-32
 20e:	ec06                	sd	ra,24(sp)
 210:	e822                	sd	s0,16(sp)
 212:	e04a                	sd	s2,0(sp)
 214:	1000                	addi	s0,sp,32
 216:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	4581                	li	a1,0
 21a:	1be000ef          	jal	3d8 <open>
  if(fd < 0)
 21e:	02054263          	bltz	a0,242 <stat+0x36>
 222:	e426                	sd	s1,8(sp)
 224:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 226:	85ca                	mv	a1,s2
 228:	1c8000ef          	jal	3f0 <fstat>
 22c:	892a                	mv	s2,a0
  close(fd);
 22e:	8526                	mv	a0,s1
 230:	190000ef          	jal	3c0 <close>
  return r;
 234:	64a2                	ld	s1,8(sp)
}
 236:	854a                	mv	a0,s2
 238:	60e2                	ld	ra,24(sp)
 23a:	6442                	ld	s0,16(sp)
 23c:	6902                	ld	s2,0(sp)
 23e:	6105                	addi	sp,sp,32
 240:	8082                	ret
    return -1;
 242:	57fd                	li	a5,-1
 244:	893e                	mv	s2,a5
 246:	bfc5                	j	236 <stat+0x2a>

0000000000000248 <atoi>:

int
atoi(const char *s)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e406                	sd	ra,8(sp)
 24c:	e022                	sd	s0,0(sp)
 24e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 250:	00054683          	lbu	a3,0(a0)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	4625                	li	a2,9
 25e:	02f66963          	bltu	a2,a5,290 <atoi+0x48>
 262:	872a                	mv	a4,a0
  n = 0;
 264:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 266:	0705                	addi	a4,a4,1
 268:	0025179b          	slliw	a5,a0,0x2
 26c:	9fa9                	addw	a5,a5,a0
 26e:	0017979b          	slliw	a5,a5,0x1
 272:	9fb5                	addw	a5,a5,a3
 274:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 278:	00074683          	lbu	a3,0(a4)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	fef671e3          	bgeu	a2,a5,266 <atoi+0x1e>
  return n;
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfdd                	j	288 <atoi+0x40>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29c:	02b57563          	bgeu	a0,a1,2c6 <memmove+0x32>
    while(n-- > 0)
 2a0:	00c05f63          	blez	a2,2be <memmove+0x2a>
 2a4:	1602                	slli	a2,a2,0x20
 2a6:	9201                	srli	a2,a2,0x20
 2a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ae:	0585                	addi	a1,a1,1
 2b0:	0705                	addi	a4,a4,1
 2b2:	fff5c683          	lbu	a3,-1(a1)
 2b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ba:	fee79ae3          	bne	a5,a4,2ae <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
    while(n-- > 0)
 2c6:	fec05ce3          	blez	a2,2be <memmove+0x2a>
    dst += n;
 2ca:	00c50733          	add	a4,a0,a2
    src += n;
 2ce:	95b2                	add	a1,a1,a2
 2d0:	fff6079b          	addiw	a5,a2,-1
 2d4:	1782                	slli	a5,a5,0x20
 2d6:	9381                	srli	a5,a5,0x20
 2d8:	fff7c793          	not	a5,a5
 2dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2de:	15fd                	addi	a1,a1,-1
 2e0:	177d                	addi	a4,a4,-1
 2e2:	0005c683          	lbu	a3,0(a1)
 2e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ea:	fef71ae3          	bne	a4,a5,2de <memmove+0x4a>
 2ee:	bfc1                	j	2be <memmove+0x2a>

00000000000002f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f8:	c61d                	beqz	a2,326 <memcmp+0x36>
 2fa:	1602                	slli	a2,a2,0x20
 2fc:	9201                	srli	a2,a2,0x20
 2fe:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x12>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x2e>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfdd                	j	31e <memcmp+0x2e>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	f63ff0ef          	jal	294 <memmove>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <sbrk>:

char *
sbrk(int n) {
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 346:	4585                	li	a1,1
 348:	0d8000ef          	jal	420 <sys_sbrk>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <sbrklazy>:

char *
sbrklazy(int n) {
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 35c:	4589                	li	a1,2
 35e:	0c2000ef          	jal	420 <sys_sbrk>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <fork>:

int
fork(void)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 372:	4701                	li	a4,0
 374:	4681                	li	a3,0
 376:	4601                	li	a2,0
 378:	4581                	li	a1,0
 37a:	4501                	li	a0,0
 37c:	00c000ef          	jal	388 <clone>
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 388:	4885                	li	a7,1
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <join>:
.global join
join:
 li a7, SYS_join
 390:	48d9                	li	a7,22
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exit>:
.global exit
exit:
 li a7, SYS_exit
 398:	4889                	li	a7,2
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a0:	488d                	li	a7,3
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a8:	4891                	li	a7,4
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <read>:
.global read
read:
 li a7, SYS_read
 3b0:	4895                	li	a7,5
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <write>:
.global write
write:
 li a7, SYS_write
 3b8:	48c1                	li	a7,16
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <close>:
.global close
close:
 li a7, SYS_close
 3c0:	48d5                	li	a7,21
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c8:	4899                	li	a7,6
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d0:	489d                	li	a7,7
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <open>:
.global open
open:
 li a7, SYS_open
 3d8:	48bd                	li	a7,15
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e0:	48c5                	li	a7,17
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e8:	48c9                	li	a7,18
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f0:	48a1                	li	a7,8
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <link>:
.global link
link:
 li a7, SYS_link
 3f8:	48cd                	li	a7,19
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 400:	48d1                	li	a7,20
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 408:	48a5                	li	a7,9
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <dup>:
.global dup
dup:
 li a7, SYS_dup
 410:	48a9                	li	a7,10
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 418:	48ad                	li	a7,11
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 420:	48b1                	li	a7,12
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <pause>:
.global pause
pause:
 li a7, SYS_pause
 428:	48b5                	li	a7,13
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 430:	48b9                	li	a7,14
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 438:	1101                	addi	sp,sp,-32
 43a:	ec06                	sd	ra,24(sp)
 43c:	e822                	sd	s0,16(sp)
 43e:	1000                	addi	s0,sp,32
 440:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 444:	4605                	li	a2,1
 446:	fef40593          	addi	a1,s0,-17
 44a:	f6fff0ef          	jal	3b8 <write>
}
 44e:	60e2                	ld	ra,24(sp)
 450:	6442                	ld	s0,16(sp)
 452:	6105                	addi	sp,sp,32
 454:	8082                	ret

0000000000000456 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 456:	715d                	addi	sp,sp,-80
 458:	e486                	sd	ra,72(sp)
 45a:	e0a2                	sd	s0,64(sp)
 45c:	f84a                	sd	s2,48(sp)
 45e:	f44e                	sd	s3,40(sp)
 460:	0880                	addi	s0,sp,80
 462:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 464:	c6d1                	beqz	a3,4f0 <printint+0x9a>
 466:	0805d563          	bgez	a1,4f0 <printint+0x9a>
    neg = 1;
    x = -xx;
 46a:	40b005b3          	neg	a1,a1
    neg = 1;
 46e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 470:	fb840993          	addi	s3,s0,-72
  neg = 0;
 474:	86ce                	mv	a3,s3
  i = 0;
 476:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 478:	00000817          	auipc	a6,0x0
 47c:	61880813          	addi	a6,a6,1560 # a90 <digits>
 480:	88ba                	mv	a7,a4
 482:	0017051b          	addiw	a0,a4,1
 486:	872a                	mv	a4,a0
 488:	02c5f7b3          	remu	a5,a1,a2
 48c:	97c2                	add	a5,a5,a6
 48e:	0007c783          	lbu	a5,0(a5)
 492:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 496:	87ae                	mv	a5,a1
 498:	02c5d5b3          	divu	a1,a1,a2
 49c:	0685                	addi	a3,a3,1
 49e:	fec7f1e3          	bgeu	a5,a2,480 <printint+0x2a>
  if(neg)
 4a2:	00030c63          	beqz	t1,4ba <printint+0x64>
    buf[i++] = '-';
 4a6:	fd050793          	addi	a5,a0,-48
 4aa:	00878533          	add	a0,a5,s0
 4ae:	02d00793          	li	a5,45
 4b2:	fef50423          	sb	a5,-24(a0)
 4b6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ba:	02e05563          	blez	a4,4e4 <printint+0x8e>
 4be:	fc26                	sd	s1,56(sp)
 4c0:	377d                	addiw	a4,a4,-1
 4c2:	00e984b3          	add	s1,s3,a4
 4c6:	19fd                	addi	s3,s3,-1
 4c8:	99ba                	add	s3,s3,a4
 4ca:	1702                	slli	a4,a4,0x20
 4cc:	9301                	srli	a4,a4,0x20
 4ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d2:	0004c583          	lbu	a1,0(s1)
 4d6:	854a                	mv	a0,s2
 4d8:	f61ff0ef          	jal	438 <putc>
  while(--i >= 0)
 4dc:	14fd                	addi	s1,s1,-1
 4de:	ff349ae3          	bne	s1,s3,4d2 <printint+0x7c>
 4e2:	74e2                	ld	s1,56(sp)
}
 4e4:	60a6                	ld	ra,72(sp)
 4e6:	6406                	ld	s0,64(sp)
 4e8:	7942                	ld	s2,48(sp)
 4ea:	79a2                	ld	s3,40(sp)
 4ec:	6161                	addi	sp,sp,80
 4ee:	8082                	ret
  neg = 0;
 4f0:	4301                	li	t1,0
 4f2:	bfbd                	j	470 <printint+0x1a>

00000000000004f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f4:	711d                	addi	sp,sp,-96
 4f6:	ec86                	sd	ra,88(sp)
 4f8:	e8a2                	sd	s0,80(sp)
 4fa:	e4a6                	sd	s1,72(sp)
 4fc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fe:	0005c483          	lbu	s1,0(a1)
 502:	22048363          	beqz	s1,728 <vprintf+0x234>
 506:	e0ca                	sd	s2,64(sp)
 508:	fc4e                	sd	s3,56(sp)
 50a:	f852                	sd	s4,48(sp)
 50c:	f456                	sd	s5,40(sp)
 50e:	f05a                	sd	s6,32(sp)
 510:	ec5e                	sd	s7,24(sp)
 512:	e862                	sd	s8,16(sp)
 514:	8b2a                	mv	s6,a0
 516:	8a2e                	mv	s4,a1
 518:	8bb2                	mv	s7,a2
  state = 0;
 51a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 51c:	4901                	li	s2,0
 51e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 520:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 524:	06400c13          	li	s8,100
 528:	a00d                	j	54a <vprintf+0x56>
        putc(fd, c0);
 52a:	85a6                	mv	a1,s1
 52c:	855a                	mv	a0,s6
 52e:	f0bff0ef          	jal	438 <putc>
 532:	a019                	j	538 <vprintf+0x44>
    } else if(state == '%'){
 534:	03598363          	beq	s3,s5,55a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 538:	0019079b          	addiw	a5,s2,1
 53c:	893e                	mv	s2,a5
 53e:	873e                	mv	a4,a5
 540:	97d2                	add	a5,a5,s4
 542:	0007c483          	lbu	s1,0(a5)
 546:	1c048a63          	beqz	s1,71a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 54a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 54e:	fe0993e3          	bnez	s3,534 <vprintf+0x40>
      if(c0 == '%'){
 552:	fd579ce3          	bne	a5,s5,52a <vprintf+0x36>
        state = '%';
 556:	89be                	mv	s3,a5
 558:	b7c5                	j	538 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 55a:	00ea06b3          	add	a3,s4,a4
 55e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 562:	1c060863          	beqz	a2,732 <vprintf+0x23e>
      if(c0 == 'd'){
 566:	03878763          	beq	a5,s8,594 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 56a:	f9478693          	addi	a3,a5,-108
 56e:	0016b693          	seqz	a3,a3
 572:	f9c60593          	addi	a1,a2,-100
 576:	e99d                	bnez	a1,5ac <vprintf+0xb8>
 578:	ca95                	beqz	a3,5ac <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4685                	li	a3,1
 580:	4629                	li	a2,10
 582:	000bb583          	ld	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	ecfff0ef          	jal	456 <printint>
        i += 1;
 58c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 58e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 590:	4981                	li	s3,0
 592:	b75d                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 594:	008b8493          	addi	s1,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	eb5ff0ef          	jal	456 <printint>
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b779                	j	538 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5ac:	9752                	add	a4,a4,s4
 5ae:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b2:	f9460713          	addi	a4,a2,-108
 5b6:	00173713          	seqz	a4,a4
 5ba:	8f75                	and	a4,a4,a3
 5bc:	f9c58513          	addi	a0,a1,-100
 5c0:	18051363          	bnez	a0,746 <vprintf+0x252>
 5c4:	18070163          	beqz	a4,746 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e81ff0ef          	jal	456 <printint>
        i += 2;
 5da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	8ba6                	mv	s7,s1
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	bfa1                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000be583          	lwu	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e67ff0ef          	jal	456 <printint>
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b781                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e4fff0ef          	jal	456 <printint>
        i += 1;
 60c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
 612:	b71d                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e35ff0ef          	jal	456 <printint>
        i += 2;
 626:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
        i += 2;
 62c:	b731                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62e:	008b8493          	addi	s1,s7,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000be583          	lwu	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	e1bff0ef          	jal	456 <printint>
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
 644:	bdd5                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	008b8493          	addi	s1,s7,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000bb583          	ld	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e03ff0ef          	jal	456 <printint>
        i += 1;
 658:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bde9                	j	538 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	008b8493          	addi	s1,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	de9ff0ef          	jal	456 <printint>
        i += 2;
 672:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
        i += 2;
 678:	b5c1                	j	538 <vprintf+0x44>
 67a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 67c:	008b8793          	addi	a5,s7,8
 680:	8cbe                	mv	s9,a5
 682:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 686:	03000593          	li	a1,48
 68a:	855a                	mv	a0,s6
 68c:	dadff0ef          	jal	438 <putc>
  putc(fd, 'x');
 690:	07800593          	li	a1,120
 694:	855a                	mv	a0,s6
 696:	da3ff0ef          	jal	438 <putc>
 69a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	00000b97          	auipc	s7,0x0
 6a0:	3f4b8b93          	addi	s7,s7,1012 # a90 <digits>
 6a4:	03c9d793          	srli	a5,s3,0x3c
 6a8:	97de                	add	a5,a5,s7
 6aa:	0007c583          	lbu	a1,0(a5)
 6ae:	855a                	mv	a0,s6
 6b0:	d89ff0ef          	jal	438 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b4:	0992                	slli	s3,s3,0x4
 6b6:	34fd                	addiw	s1,s1,-1
 6b8:	f4f5                	bnez	s1,6a4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6ba:	8be6                	mv	s7,s9
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	6ca2                	ld	s9,8(sp)
 6c0:	bda5                	j	538 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6c2:	008b8493          	addi	s1,s7,8
 6c6:	000bc583          	lbu	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	d6dff0ef          	jal	438 <putc>
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b595                	j	538 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6d6:	008b8993          	addi	s3,s7,8
 6da:	000bb483          	ld	s1,0(s7)
 6de:	cc91                	beqz	s1,6fa <vprintf+0x206>
        for(; *s; s++)
 6e0:	0004c583          	lbu	a1,0(s1)
 6e4:	c985                	beqz	a1,714 <vprintf+0x220>
          putc(fd, *s);
 6e6:	855a                	mv	a0,s6
 6e8:	d51ff0ef          	jal	438 <putc>
        for(; *s; s++)
 6ec:	0485                	addi	s1,s1,1
 6ee:	0004c583          	lbu	a1,0(s1)
 6f2:	f9f5                	bnez	a1,6e6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6f4:	8bce                	mv	s7,s3
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b581                	j	538 <vprintf+0x44>
          s = "(null)";
 6fa:	00000497          	auipc	s1,0x0
 6fe:	38e48493          	addi	s1,s1,910 # a88 <thread_join+0xaa>
        for(; *s; s++)
 702:	02800593          	li	a1,40
 706:	b7c5                	j	6e6 <vprintf+0x1f2>
        putc(fd, '%');
 708:	85be                	mv	a1,a5
 70a:	855a                	mv	a0,s6
 70c:	d2dff0ef          	jal	438 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	b51d                	j	538 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 714:	8bce                	mv	s7,s3
      state = 0;
 716:	4981                	li	s3,0
 718:	b505                	j	538 <vprintf+0x44>
 71a:	6906                	ld	s2,64(sp)
 71c:	79e2                	ld	s3,56(sp)
 71e:	7a42                	ld	s4,48(sp)
 720:	7aa2                	ld	s5,40(sp)
 722:	7b02                	ld	s6,32(sp)
 724:	6be2                	ld	s7,24(sp)
 726:	6c42                	ld	s8,16(sp)
    }
  }
}
 728:	60e6                	ld	ra,88(sp)
 72a:	6446                	ld	s0,80(sp)
 72c:	64a6                	ld	s1,72(sp)
 72e:	6125                	addi	sp,sp,96
 730:	8082                	ret
      if(c0 == 'd'){
 732:	06400713          	li	a4,100
 736:	e4e78fe3          	beq	a5,a4,594 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 73a:	f9478693          	addi	a3,a5,-108
 73e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 742:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 744:	4701                	li	a4,0
      } else if(c0 == 'u'){
 746:	07500513          	li	a0,117
 74a:	e8a78ce3          	beq	a5,a0,5e2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 74e:	f8b60513          	addi	a0,a2,-117
 752:	e119                	bnez	a0,758 <vprintf+0x264>
 754:	ea0693e3          	bnez	a3,5fa <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 758:	f8b58513          	addi	a0,a1,-117
 75c:	e119                	bnez	a0,762 <vprintf+0x26e>
 75e:	ea071be3          	bnez	a4,614 <vprintf+0x120>
      } else if(c0 == 'x'){
 762:	07800513          	li	a0,120
 766:	eca784e3          	beq	a5,a0,62e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 76a:	f8860613          	addi	a2,a2,-120
 76e:	e219                	bnez	a2,774 <vprintf+0x280>
 770:	ec069be3          	bnez	a3,646 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 774:	f8858593          	addi	a1,a1,-120
 778:	e199                	bnez	a1,77e <vprintf+0x28a>
 77a:	ee0713e3          	bnez	a4,660 <vprintf+0x16c>
      } else if(c0 == 'p'){
 77e:	07000713          	li	a4,112
 782:	eee78ce3          	beq	a5,a4,67a <vprintf+0x186>
      } else if(c0 == 'c'){
 786:	06300713          	li	a4,99
 78a:	f2e78ce3          	beq	a5,a4,6c2 <vprintf+0x1ce>
      } else if(c0 == 's'){
 78e:	07300713          	li	a4,115
 792:	f4e782e3          	beq	a5,a4,6d6 <vprintf+0x1e2>
      } else if(c0 == '%'){
 796:	02500713          	li	a4,37
 79a:	f6e787e3          	beq	a5,a4,708 <vprintf+0x214>
        putc(fd, '%');
 79e:	02500593          	li	a1,37
 7a2:	855a                	mv	a0,s6
 7a4:	c95ff0ef          	jal	438 <putc>
        putc(fd, c0);
 7a8:	85a6                	mv	a1,s1
 7aa:	855a                	mv	a0,s6
 7ac:	c8dff0ef          	jal	438 <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b359                	j	538 <vprintf+0x44>

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	8622                	mv	a2,s0
 7ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d2:	d23ff0ef          	jal	4f4 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6161                	addi	sp,sp,80
 7dc:	8082                	ret

00000000000007de <printf>:

void
printf(const char *fmt, ...)
{
 7de:	711d                	addi	sp,sp,-96
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e40c                	sd	a1,8(s0)
 7e8:	e810                	sd	a2,16(s0)
 7ea:	ec14                	sd	a3,24(s0)
 7ec:	f018                	sd	a4,32(s0)
 7ee:	f41c                	sd	a5,40(s0)
 7f0:	03043823          	sd	a6,48(s0)
 7f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	00840613          	addi	a2,s0,8
 7fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 800:	85aa                	mv	a1,a0
 802:	4505                	li	a0,1
 804:	cf1ff0ef          	jal	4f4 <vprintf>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6125                	addi	sp,sp,96
 80e:	8082                	ret

0000000000000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	1141                	addi	sp,sp,-16
 812:	e406                	sd	ra,8(sp)
 814:	e022                	sd	s0,0(sp)
 816:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 818:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81c:	00000797          	auipc	a5,0x0
 820:	7f47b783          	ld	a5,2036(a5) # 1010 <freep>
 824:	a039                	j	832 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	6398                	ld	a4,0(a5)
 828:	00e7e463          	bltu	a5,a4,830 <free+0x20>
 82c:	00e6ea63          	bltu	a3,a4,840 <free+0x30>
{
 830:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	fed7fae3          	bgeu	a5,a3,826 <free+0x16>
 836:	6398                	ld	a4,0(a5)
 838:	00e6e463          	bltu	a3,a4,840 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	fee7eae3          	bltu	a5,a4,830 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 840:	ff852583          	lw	a1,-8(a0)
 844:	6390                	ld	a2,0(a5)
 846:	02059813          	slli	a6,a1,0x20
 84a:	01c85713          	srli	a4,a6,0x1c
 84e:	9736                	add	a4,a4,a3
 850:	02e60563          	beq	a2,a4,87a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 858:	4790                	lw	a2,8(a5)
 85a:	02061593          	slli	a1,a2,0x20
 85e:	01c5d713          	srli	a4,a1,0x1c
 862:	973e                	add	a4,a4,a5
 864:	02e68263          	beq	a3,a4,888 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 868:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86a:	00000717          	auipc	a4,0x0
 86e:	7af73323          	sd	a5,1958(a4) # 1010 <freep>
}
 872:	60a2                	ld	ra,8(sp)
 874:	6402                	ld	s0,0(sp)
 876:	0141                	addi	sp,sp,16
 878:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 87a:	4618                	lw	a4,8(a2)
 87c:	9f2d                	addw	a4,a4,a1
 87e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	6310                	ld	a2,0(a4)
 886:	b7f9                	j	854 <free+0x44>
    p->s.size += bp->s.size;
 888:	ff852703          	lw	a4,-8(a0)
 88c:	9f31                	addw	a4,a4,a2
 88e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 890:	ff053683          	ld	a3,-16(a0)
 894:	bfd1                	j	868 <free+0x58>

0000000000000896 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 896:	7139                	addi	sp,sp,-64
 898:	fc06                	sd	ra,56(sp)
 89a:	f822                	sd	s0,48(sp)
 89c:	f04a                	sd	s2,32(sp)
 89e:	ec4e                	sd	s3,24(sp)
 8a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	02051993          	slli	s3,a0,0x20
 8a6:	0209d993          	srli	s3,s3,0x20
 8aa:	09bd                	addi	s3,s3,15
 8ac:	0049d993          	srli	s3,s3,0x4
 8b0:	2985                	addiw	s3,s3,1
 8b2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8b4:	00000517          	auipc	a0,0x0
 8b8:	75c53503          	ld	a0,1884(a0) # 1010 <freep>
 8bc:	c905                	beqz	a0,8ec <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c0:	4798                	lw	a4,8(a5)
 8c2:	09377663          	bgeu	a4,s3,94e <malloc+0xb8>
 8c6:	f426                	sd	s1,40(sp)
 8c8:	e852                	sd	s4,16(sp)
 8ca:	e456                	sd	s5,8(sp)
 8cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ce:	8a4e                	mv	s4,s3
 8d0:	6705                	lui	a4,0x1
 8d2:	00e9f363          	bgeu	s3,a4,8d8 <malloc+0x42>
 8d6:	6a05                	lui	s4,0x1
 8d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e0:	00000497          	auipc	s1,0x0
 8e4:	73048493          	addi	s1,s1,1840 # 1010 <freep>
  if(p == SBRK_ERROR)
 8e8:	5afd                	li	s5,-1
 8ea:	a83d                	j	928 <malloc+0x92>
 8ec:	f426                	sd	s1,40(sp)
 8ee:	e852                	sd	s4,16(sp)
 8f0:	e456                	sd	s5,8(sp)
 8f2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f4:	00000797          	auipc	a5,0x0
 8f8:	72c78793          	addi	a5,a5,1836 # 1020 <base>
 8fc:	00000717          	auipc	a4,0x0
 900:	70f73a23          	sd	a5,1812(a4) # 1010 <freep>
 904:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 906:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90a:	b7d1                	j	8ce <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	e118                	sd	a4,0(a0)
 910:	a899                	j	966 <malloc+0xd0>
  hp->s.size = nu;
 912:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 916:	0541                	addi	a0,a0,16
 918:	ef9ff0ef          	jal	810 <free>
  return freep;
 91c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 91e:	c125                	beqz	a0,97e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	03277163          	bgeu	a4,s2,946 <malloc+0xb0>
    if(p == freep)
 928:	6098                	ld	a4,0(s1)
 92a:	853e                	mv	a0,a5
 92c:	fef71ae3          	bne	a4,a5,920 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 930:	8552                	mv	a0,s4
 932:	a0dff0ef          	jal	33e <sbrk>
  if(p == SBRK_ERROR)
 936:	fd551ee3          	bne	a0,s5,912 <malloc+0x7c>
        return 0;
 93a:	4501                	li	a0,0
 93c:	74a2                	ld	s1,40(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
 944:	a03d                	j	972 <malloc+0xdc>
 946:	74a2                	ld	s1,40(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 94e:	fae90fe3          	beq	s2,a4,90c <malloc+0x76>
        p->s.size -= nunits;
 952:	4137073b          	subw	a4,a4,s3
 956:	c798                	sw	a4,8(a5)
        p += p->s.size;
 958:	02071693          	slli	a3,a4,0x20
 95c:	01c6d713          	srli	a4,a3,0x1c
 960:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 962:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 966:	00000717          	auipc	a4,0x0
 96a:	6aa73523          	sd	a0,1706(a4) # 1010 <freep>
      return (void*)(p + 1);
 96e:	01078513          	addi	a0,a5,16
  }
}
 972:	70e2                	ld	ra,56(sp)
 974:	7442                	ld	s0,48(sp)
 976:	7902                	ld	s2,32(sp)
 978:	69e2                	ld	s3,24(sp)
 97a:	6121                	addi	sp,sp,64
 97c:	8082                	ret
 97e:	74a2                	ld	s1,40(sp)
 980:	6a42                	ld	s4,16(sp)
 982:	6aa2                	ld	s5,8(sp)
 984:	6b02                	ld	s6,0(sp)
 986:	b7f5                	j	972 <malloc+0xdc>

0000000000000988 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 988:	7179                	addi	sp,sp,-48
 98a:	f406                	sd	ra,40(sp)
 98c:	f022                	sd	s0,32(sp)
 98e:	ec26                	sd	s1,24(sp)
 990:	e84a                	sd	s2,16(sp)
 992:	e44e                	sd	s3,8(sp)
 994:	1800                	addi	s0,sp,48
 996:	89aa                	mv	s3,a0
 998:	892e                	mv	s2,a1
 99a:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 99c:	00c6151b          	slliw	a0,a2,0xc
 9a0:	ef7ff0ef          	jal	896 <malloc>
  if(stack == 0) return -1;
 9a4:	c91d                	beqz	a0,9da <thread_create+0x52>
 9a6:	e052                	sd	s4,0(sp)
 9a8:	862a                	mv	a2,a0
 9aa:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 9ac:	10000713          	li	a4,256
 9b0:	86a6                	mv	a3,s1
 9b2:	85ca                	mv	a1,s2
 9b4:	854e                	mv	a0,s3
 9b6:	9d3ff0ef          	jal	388 <clone>

  if(pid < 0) {
 9ba:	00054a63          	bltz	a0,9ce <thread_create+0x46>
 9be:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 9c0:	70a2                	ld	ra,40(sp)
 9c2:	7402                	ld	s0,32(sp)
 9c4:	64e2                	ld	s1,24(sp)
 9c6:	6942                	ld	s2,16(sp)
 9c8:	69a2                	ld	s3,8(sp)
 9ca:	6145                	addi	sp,sp,48
 9cc:	8082                	ret
    free(stack);
 9ce:	8552                	mv	a0,s4
 9d0:	e41ff0ef          	jal	810 <free>
    return -1;
 9d4:	557d                	li	a0,-1
 9d6:	6a02                	ld	s4,0(sp)
 9d8:	b7e5                	j	9c0 <thread_create+0x38>
  if(stack == 0) return -1;
 9da:	557d                	li	a0,-1
 9dc:	b7d5                	j	9c0 <thread_create+0x38>

00000000000009de <thread_join>:

int
thread_join(void)
{
 9de:	7179                	addi	sp,sp,-48
 9e0:	f406                	sd	ra,40(sp)
 9e2:	f022                	sd	s0,32(sp)
 9e4:	ec26                	sd	s1,24(sp)
 9e6:	1800                	addi	s0,sp,48
  void *stack = 0;
 9e8:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 9ec:	fd840513          	addi	a0,s0,-40
 9f0:	9a1ff0ef          	jal	390 <join>
 9f4:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 9f6:	00a05763          	blez	a0,a04 <thread_join+0x26>
 9fa:	fd843503          	ld	a0,-40(s0)
 9fe:	c119                	beqz	a0,a04 <thread_join+0x26>
    free(stack);
 a00:	e11ff0ef          	jal	810 <free>
  }
  return pid;
}
 a04:	8526                	mv	a0,s1
 a06:	70a2                	ld	ra,40(sp)
 a08:	7402                	ld	s0,32(sp)
 a0a:	64e2                	ld	s1,24(sp)
 a0c:	6145                	addi	sp,sp,48
 a0e:	8082                	ret
