
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };

  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++){
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	390000ef          	jal	3b0 <fork>
    if(pid1 < 0){
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++){
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	a2250513          	addi	a0,a0,-1502 # a60 <thread_join+0x3c>
  46:	7de000ef          	jal	824 <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	392000ef          	jal	3de <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	3c0000ef          	jal	41e <open>
  62:	89aa                	mv	s3,a0
      if(fd < 0){
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0'+i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	116000ef          	jal	18e <memset>
  7c:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  80:	7d000913          	li	s2,2000
  84:	00001a17          	auipc	s4,0x1
  88:	f8ca0a13          	addi	s4,s4,-116 # 1010 <buf>
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	36c000ef          	jal	3fe <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	33e000ef          	jal	3de <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	9cc50513          	addi	a0,a0,-1588 # a78 <thread_join+0x54>
  b4:	770000ef          	jal	824 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	324000ef          	jal	3de <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	9d050513          	addi	a0,a0,-1584 # a90 <thread_join+0x6c>
  c8:	75c000ef          	jal	824 <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	310000ef          	jal	3de <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	310000ef          	jal	3e6 <wait>
    if(xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2e4000ef          	jal	3de <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	2d0000ef          	jal	3de <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x28>
 170:	00150793          	addi	a5,a0,1
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  for(n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfdd                	j	182 <strlen+0x20>

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1e>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x14>
  }
  return dst;
}
 1ac:	60a2                	ld	ra,8(sp)
 1ae:	6402                	ld	s0,0(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf81                	beqz	a5,1d8 <strchr+0x24>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1c>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xe>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	60a2                	ld	ra,8(sp)
 1d2:	6402                	ld	s0,0(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  return 0;
 1d8:	4501                	li	a0,0
 1da:	bfdd                	j	1d0 <strchr+0x1c>

00000000000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	711d                	addi	sp,sp,-96
 1de:	ec86                	sd	ra,88(sp)
 1e0:	e8a2                	sd	s0,80(sp)
 1e2:	e4a6                	sd	s1,72(sp)
 1e4:	e0ca                	sd	s2,64(sp)
 1e6:	fc4e                	sd	s3,56(sp)
 1e8:	f852                	sd	s4,48(sp)
 1ea:	f456                	sd	s5,40(sp)
 1ec:	f05a                	sd	s6,32(sp)
 1ee:	ec5e                	sd	s7,24(sp)
 1f0:	e862                	sd	s8,16(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1fc:	faf40b13          	addi	s6,s0,-81
 200:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 202:	8c26                	mv	s8,s1
 204:	0014899b          	addiw	s3,s1,1
 208:	84ce                	mv	s1,s3
 20a:	0349d463          	bge	s3,s4,232 <gets+0x56>
    cc = read(0, &c, 1);
 20e:	8656                	mv	a2,s5
 210:	85da                	mv	a1,s6
 212:	4501                	li	a0,0
 214:	1e2000ef          	jal	3f6 <read>
    if(cc < 1)
 218:	00a05d63          	blez	a0,232 <gets+0x56>
      break;
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	0905                	addi	s2,s2,1
 226:	ff678713          	addi	a4,a5,-10
 22a:	c319                	beqz	a4,230 <gets+0x54>
 22c:	17cd                	addi	a5,a5,-13
 22e:	fbf1                	bnez	a5,202 <gets+0x26>
    buf[i++] = c;
 230:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 232:	9c5e                	add	s8,s8,s7
 234:	000c0023          	sb	zero,0(s8)
  return buf;
}
 238:	855e                	mv	a0,s7
 23a:	60e6                	ld	ra,88(sp)
 23c:	6446                	ld	s0,80(sp)
 23e:	64a6                	ld	s1,72(sp)
 240:	6906                	ld	s2,64(sp)
 242:	79e2                	ld	s3,56(sp)
 244:	7a42                	ld	s4,48(sp)
 246:	7aa2                	ld	s5,40(sp)
 248:	7b02                	ld	s6,32(sp)
 24a:	6be2                	ld	s7,24(sp)
 24c:	6c42                	ld	s8,16(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	1be000ef          	jal	41e <open>
  if(fd < 0)
 264:	02054263          	bltz	a0,288 <stat+0x36>
 268:	e426                	sd	s1,8(sp)
 26a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26c:	85ca                	mv	a1,s2
 26e:	1c8000ef          	jal	436 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	190000ef          	jal	406 <close>
  return r;
 27a:	64a2                	ld	s1,8(sp)
}
 27c:	854a                	mv	a0,s2
 27e:	60e2                	ld	ra,24(sp)
 280:	6442                	ld	s0,16(sp)
 282:	6902                	ld	s2,0(sp)
 284:	6105                	addi	sp,sp,32
 286:	8082                	ret
    return -1;
 288:	57fd                	li	a5,-1
 28a:	893e                	mv	s2,a5
 28c:	bfc5                	j	27c <stat+0x2a>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054683          	lbu	a3,0(a0)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	4625                	li	a2,9
 2a4:	02f66963          	bltu	a2,a5,2d6 <atoi+0x48>
 2a8:	872a                	mv	a4,a0
  n = 0;
 2aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ac:	0705                	addi	a4,a4,1
 2ae:	0025179b          	slliw	a5,a0,0x2
 2b2:	9fa9                	addw	a5,a5,a0
 2b4:	0017979b          	slliw	a5,a5,0x1
 2b8:	9fb5                	addw	a5,a5,a3
 2ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2be:	00074683          	lbu	a3,0(a4)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	fef671e3          	bgeu	a2,a5,2ac <atoi+0x1e>
  return n;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfdd                	j	2ce <atoi+0x40>

00000000000002da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e2:	02b57563          	bgeu	a0,a1,30c <memmove+0x32>
    while(n-- > 0)
 2e6:	00c05f63          	blez	a2,304 <memmove+0x2a>
 2ea:	1602                	slli	a2,a2,0x20
 2ec:	9201                	srli	a2,a2,0x20
 2ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f4:	0585                	addi	a1,a1,1
 2f6:	0705                	addi	a4,a4,1
 2f8:	fff5c683          	lbu	a3,-1(a1)
 2fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 300:	fee79ae3          	bne	a5,a4,2f4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    while(n-- > 0)
 30c:	fec05ce3          	blez	a2,304 <memmove+0x2a>
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fef71ae3          	bne	a4,a5,324 <memmove+0x4a>
 334:	bfc1                	j	304 <memmove+0x2a>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	c61d                	beqz	a2,36c <memcmp+0x36>
 340:	1602                	slli	a2,a2,0x20
 342:	9201                	srli	a2,a2,0x20
 344:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 348:	00054783          	lbu	a5,0(a0)
 34c:	0005c703          	lbu	a4,0(a1)
 350:	00e79863          	bne	a5,a4,360 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 354:	0505                	addi	a0,a0,1
    p2++;
 356:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 358:	fed518e3          	bne	a0,a3,348 <memcmp+0x12>
  }
  return 0;
 35c:	4501                	li	a0,0
 35e:	a019                	j	364 <memcmp+0x2e>
      return *p1 - *p2;
 360:	40e7853b          	subw	a0,a5,a4
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfdd                	j	364 <memcmp+0x2e>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f63ff0ef          	jal	2da <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <sbrk>:

char *
sbrk(int n) {
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 38c:	4585                	li	a1,1
 38e:	0d8000ef          	jal	466 <sys_sbrk>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <sbrklazy>:

char *
sbrklazy(int n) {
 39a:	1141                	addi	sp,sp,-16
 39c:	e406                	sd	ra,8(sp)
 39e:	e022                	sd	s0,0(sp)
 3a0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a2:	4589                	li	a1,2
 3a4:	0c2000ef          	jal	466 <sys_sbrk>
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <fork>:

int
fork(void)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e406                	sd	ra,8(sp)
 3b4:	e022                	sd	s0,0(sp)
 3b6:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 3b8:	4701                	li	a4,0
 3ba:	4681                	li	a3,0
 3bc:	4601                	li	a2,0
 3be:	4581                	li	a1,0
 3c0:	4501                	li	a0,0
 3c2:	00c000ef          	jal	3ce <clone>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <join>:
.global join
join:
 li a7, SYS_join
 3d6:	48d9                	li	a7,22
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <exit>:
.global exit
exit:
 li a7, SYS_exit
 3de:	4889                	li	a7,2
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e6:	488d                	li	a7,3
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ee:	4891                	li	a7,4
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <read>:
.global read
read:
 li a7, SYS_read
 3f6:	4895                	li	a7,5
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <write>:
.global write
write:
 li a7, SYS_write
 3fe:	48c1                	li	a7,16
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <close>:
.global close
close:
 li a7, SYS_close
 406:	48d5                	li	a7,21
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kill>:
.global kill
kill:
 li a7, SYS_kill
 40e:	4899                	li	a7,6
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exec>:
.global exec
exec:
 li a7, SYS_exec
 416:	489d                	li	a7,7
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <open>:
.global open
open:
 li a7, SYS_open
 41e:	48bd                	li	a7,15
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 426:	48c5                	li	a7,17
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42e:	48c9                	li	a7,18
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 436:	48a1                	li	a7,8
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <link>:
.global link
link:
 li a7, SYS_link
 43e:	48cd                	li	a7,19
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 446:	48d1                	li	a7,20
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44e:	48a5                	li	a7,9
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <dup>:
.global dup
dup:
 li a7, SYS_dup
 456:	48a9                	li	a7,10
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45e:	48ad                	li	a7,11
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 466:	48b1                	li	a7,12
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <pause>:
.global pause
pause:
 li a7, SYS_pause
 46e:	48b5                	li	a7,13
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 476:	48b9                	li	a7,14
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 47e:	1101                	addi	sp,sp,-32
 480:	ec06                	sd	ra,24(sp)
 482:	e822                	sd	s0,16(sp)
 484:	1000                	addi	s0,sp,32
 486:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48a:	4605                	li	a2,1
 48c:	fef40593          	addi	a1,s0,-17
 490:	f6fff0ef          	jal	3fe <write>
}
 494:	60e2                	ld	ra,24(sp)
 496:	6442                	ld	s0,16(sp)
 498:	6105                	addi	sp,sp,32
 49a:	8082                	ret

000000000000049c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 49c:	715d                	addi	sp,sp,-80
 49e:	e486                	sd	ra,72(sp)
 4a0:	e0a2                	sd	s0,64(sp)
 4a2:	f84a                	sd	s2,48(sp)
 4a4:	f44e                	sd	s3,40(sp)
 4a6:	0880                	addi	s0,sp,80
 4a8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4aa:	c6d1                	beqz	a3,536 <printint+0x9a>
 4ac:	0805d563          	bgez	a1,536 <printint+0x9a>
    neg = 1;
    x = -xx;
 4b0:	40b005b3          	neg	a1,a1
    neg = 1;
 4b4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4b6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4ba:	86ce                	mv	a3,s3
  i = 0;
 4bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4be:	00000817          	auipc	a6,0x0
 4c2:	5f280813          	addi	a6,a6,1522 # ab0 <digits>
 4c6:	88ba                	mv	a7,a4
 4c8:	0017051b          	addiw	a0,a4,1
 4cc:	872a                	mv	a4,a0
 4ce:	02c5f7b3          	remu	a5,a1,a2
 4d2:	97c2                	add	a5,a5,a6
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4dc:	87ae                	mv	a5,a1
 4de:	02c5d5b3          	divu	a1,a1,a2
 4e2:	0685                	addi	a3,a3,1
 4e4:	fec7f1e3          	bgeu	a5,a2,4c6 <printint+0x2a>
  if(neg)
 4e8:	00030c63          	beqz	t1,500 <printint+0x64>
    buf[i++] = '-';
 4ec:	fd050793          	addi	a5,a0,-48
 4f0:	00878533          	add	a0,a5,s0
 4f4:	02d00793          	li	a5,45
 4f8:	fef50423          	sb	a5,-24(a0)
 4fc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 500:	02e05563          	blez	a4,52a <printint+0x8e>
 504:	fc26                	sd	s1,56(sp)
 506:	377d                	addiw	a4,a4,-1
 508:	00e984b3          	add	s1,s3,a4
 50c:	19fd                	addi	s3,s3,-1
 50e:	99ba                	add	s3,s3,a4
 510:	1702                	slli	a4,a4,0x20
 512:	9301                	srli	a4,a4,0x20
 514:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 518:	0004c583          	lbu	a1,0(s1)
 51c:	854a                	mv	a0,s2
 51e:	f61ff0ef          	jal	47e <putc>
  while(--i >= 0)
 522:	14fd                	addi	s1,s1,-1
 524:	ff349ae3          	bne	s1,s3,518 <printint+0x7c>
 528:	74e2                	ld	s1,56(sp)
}
 52a:	60a6                	ld	ra,72(sp)
 52c:	6406                	ld	s0,64(sp)
 52e:	7942                	ld	s2,48(sp)
 530:	79a2                	ld	s3,40(sp)
 532:	6161                	addi	sp,sp,80
 534:	8082                	ret
  neg = 0;
 536:	4301                	li	t1,0
 538:	bfbd                	j	4b6 <printint+0x1a>

000000000000053a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53a:	711d                	addi	sp,sp,-96
 53c:	ec86                	sd	ra,88(sp)
 53e:	e8a2                	sd	s0,80(sp)
 540:	e4a6                	sd	s1,72(sp)
 542:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 544:	0005c483          	lbu	s1,0(a1)
 548:	22048363          	beqz	s1,76e <vprintf+0x234>
 54c:	e0ca                	sd	s2,64(sp)
 54e:	fc4e                	sd	s3,56(sp)
 550:	f852                	sd	s4,48(sp)
 552:	f456                	sd	s5,40(sp)
 554:	f05a                	sd	s6,32(sp)
 556:	ec5e                	sd	s7,24(sp)
 558:	e862                	sd	s8,16(sp)
 55a:	8b2a                	mv	s6,a0
 55c:	8a2e                	mv	s4,a1
 55e:	8bb2                	mv	s7,a2
  state = 0;
 560:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 562:	4901                	li	s2,0
 564:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 566:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 56a:	06400c13          	li	s8,100
 56e:	a00d                	j	590 <vprintf+0x56>
        putc(fd, c0);
 570:	85a6                	mv	a1,s1
 572:	855a                	mv	a0,s6
 574:	f0bff0ef          	jal	47e <putc>
 578:	a019                	j	57e <vprintf+0x44>
    } else if(state == '%'){
 57a:	03598363          	beq	s3,s5,5a0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 57e:	0019079b          	addiw	a5,s2,1
 582:	893e                	mv	s2,a5
 584:	873e                	mv	a4,a5
 586:	97d2                	add	a5,a5,s4
 588:	0007c483          	lbu	s1,0(a5)
 58c:	1c048a63          	beqz	s1,760 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 590:	0004879b          	sext.w	a5,s1
    if(state == 0){
 594:	fe0993e3          	bnez	s3,57a <vprintf+0x40>
      if(c0 == '%'){
 598:	fd579ce3          	bne	a5,s5,570 <vprintf+0x36>
        state = '%';
 59c:	89be                	mv	s3,a5
 59e:	b7c5                	j	57e <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a0:	00ea06b3          	add	a3,s4,a4
 5a4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5a8:	1c060863          	beqz	a2,778 <vprintf+0x23e>
      if(c0 == 'd'){
 5ac:	03878763          	beq	a5,s8,5da <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b0:	f9478693          	addi	a3,a5,-108
 5b4:	0016b693          	seqz	a3,a3
 5b8:	f9c60593          	addi	a1,a2,-100
 5bc:	e99d                	bnez	a1,5f2 <vprintf+0xb8>
 5be:	ca95                	beqz	a3,5f2 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000bb583          	ld	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	ecfff0ef          	jal	49c <printint>
        i += 1;
 5d2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b75d                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	eb5ff0ef          	jal	49c <printint>
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b779                	j	57e <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5f2:	9752                	add	a4,a4,s4
 5f4:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f8:	f9460713          	addi	a4,a2,-108
 5fc:	00173713          	seqz	a4,a4
 600:	8f75                	and	a4,a4,a3
 602:	f9c58513          	addi	a0,a1,-100
 606:	18051363          	bnez	a0,78c <vprintf+0x252>
 60a:	18070163          	beqz	a4,78c <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	008b8493          	addi	s1,s7,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e81ff0ef          	jal	49c <printint>
        i += 2;
 620:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	bfa1                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 628:	008b8493          	addi	s1,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000be583          	lwu	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e67ff0ef          	jal	49c <printint>
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b781                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8493          	addi	s1,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e4fff0ef          	jal	49c <printint>
        i += 1;
 652:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
 658:	b71d                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e35ff0ef          	jal	49c <printint>
        i += 2;
 66c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	b731                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 674:	008b8493          	addi	s1,s7,8
 678:	4681                	li	a3,0
 67a:	4641                	li	a2,16
 67c:	000be583          	lwu	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	e1bff0ef          	jal	49c <printint>
 686:	8ba6                	mv	s7,s1
      state = 0;
 688:	4981                	li	s3,0
 68a:	bdd5                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8493          	addi	s1,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	e03ff0ef          	jal	49c <printint>
        i += 1;
 69e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bde9                	j	57e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	de9ff0ef          	jal	49c <printint>
        i += 2;
 6b8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
        i += 2;
 6be:	b5c1                	j	57e <vprintf+0x44>
 6c0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6c2:	008b8793          	addi	a5,s7,8
 6c6:	8cbe                	mv	s9,a5
 6c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6cc:	03000593          	li	a1,48
 6d0:	855a                	mv	a0,s6
 6d2:	dadff0ef          	jal	47e <putc>
  putc(fd, 'x');
 6d6:	07800593          	li	a1,120
 6da:	855a                	mv	a0,s6
 6dc:	da3ff0ef          	jal	47e <putc>
 6e0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e2:	00000b97          	auipc	s7,0x0
 6e6:	3ceb8b93          	addi	s7,s7,974 # ab0 <digits>
 6ea:	03c9d793          	srli	a5,s3,0x3c
 6ee:	97de                	add	a5,a5,s7
 6f0:	0007c583          	lbu	a1,0(a5)
 6f4:	855a                	mv	a0,s6
 6f6:	d89ff0ef          	jal	47e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6fa:	0992                	slli	s3,s3,0x4
 6fc:	34fd                	addiw	s1,s1,-1
 6fe:	f4f5                	bnez	s1,6ea <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 700:	8be6                	mv	s7,s9
      state = 0;
 702:	4981                	li	s3,0
 704:	6ca2                	ld	s9,8(sp)
 706:	bda5                	j	57e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 708:	008b8493          	addi	s1,s7,8
 70c:	000bc583          	lbu	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	d6dff0ef          	jal	47e <putc>
 716:	8ba6                	mv	s7,s1
      state = 0;
 718:	4981                	li	s3,0
 71a:	b595                	j	57e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 71c:	008b8993          	addi	s3,s7,8
 720:	000bb483          	ld	s1,0(s7)
 724:	cc91                	beqz	s1,740 <vprintf+0x206>
        for(; *s; s++)
 726:	0004c583          	lbu	a1,0(s1)
 72a:	c985                	beqz	a1,75a <vprintf+0x220>
          putc(fd, *s);
 72c:	855a                	mv	a0,s6
 72e:	d51ff0ef          	jal	47e <putc>
        for(; *s; s++)
 732:	0485                	addi	s1,s1,1
 734:	0004c583          	lbu	a1,0(s1)
 738:	f9f5                	bnez	a1,72c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b581                	j	57e <vprintf+0x44>
          s = "(null)";
 740:	00000497          	auipc	s1,0x0
 744:	36848493          	addi	s1,s1,872 # aa8 <thread_join+0x84>
        for(; *s; s++)
 748:	02800593          	li	a1,40
 74c:	b7c5                	j	72c <vprintf+0x1f2>
        putc(fd, '%');
 74e:	85be                	mv	a1,a5
 750:	855a                	mv	a0,s6
 752:	d2dff0ef          	jal	47e <putc>
      state = 0;
 756:	4981                	li	s3,0
 758:	b51d                	j	57e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b505                	j	57e <vprintf+0x44>
 760:	6906                	ld	s2,64(sp)
 762:	79e2                	ld	s3,56(sp)
 764:	7a42                	ld	s4,48(sp)
 766:	7aa2                	ld	s5,40(sp)
 768:	7b02                	ld	s6,32(sp)
 76a:	6be2                	ld	s7,24(sp)
 76c:	6c42                	ld	s8,16(sp)
    }
  }
}
 76e:	60e6                	ld	ra,88(sp)
 770:	6446                	ld	s0,80(sp)
 772:	64a6                	ld	s1,72(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret
      if(c0 == 'd'){
 778:	06400713          	li	a4,100
 77c:	e4e78fe3          	beq	a5,a4,5da <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 780:	f9478693          	addi	a3,a5,-108
 784:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 788:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78a:	4701                	li	a4,0
      } else if(c0 == 'u'){
 78c:	07500513          	li	a0,117
 790:	e8a78ce3          	beq	a5,a0,628 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 794:	f8b60513          	addi	a0,a2,-117
 798:	e119                	bnez	a0,79e <vprintf+0x264>
 79a:	ea0693e3          	bnez	a3,640 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79e:	f8b58513          	addi	a0,a1,-117
 7a2:	e119                	bnez	a0,7a8 <vprintf+0x26e>
 7a4:	ea071be3          	bnez	a4,65a <vprintf+0x120>
      } else if(c0 == 'x'){
 7a8:	07800513          	li	a0,120
 7ac:	eca784e3          	beq	a5,a0,674 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7b0:	f8860613          	addi	a2,a2,-120
 7b4:	e219                	bnez	a2,7ba <vprintf+0x280>
 7b6:	ec069be3          	bnez	a3,68c <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ba:	f8858593          	addi	a1,a1,-120
 7be:	e199                	bnez	a1,7c4 <vprintf+0x28a>
 7c0:	ee0713e3          	bnez	a4,6a6 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7c4:	07000713          	li	a4,112
 7c8:	eee78ce3          	beq	a5,a4,6c0 <vprintf+0x186>
      } else if(c0 == 'c'){
 7cc:	06300713          	li	a4,99
 7d0:	f2e78ce3          	beq	a5,a4,708 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7d4:	07300713          	li	a4,115
 7d8:	f4e782e3          	beq	a5,a4,71c <vprintf+0x1e2>
      } else if(c0 == '%'){
 7dc:	02500713          	li	a4,37
 7e0:	f6e787e3          	beq	a5,a4,74e <vprintf+0x214>
        putc(fd, '%');
 7e4:	02500593          	li	a1,37
 7e8:	855a                	mv	a0,s6
 7ea:	c95ff0ef          	jal	47e <putc>
        putc(fd, c0);
 7ee:	85a6                	mv	a1,s1
 7f0:	855a                	mv	a0,s6
 7f2:	c8dff0ef          	jal	47e <putc>
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b359                	j	57e <vprintf+0x44>

00000000000007fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e010                	sd	a2,0(s0)
 804:	e414                	sd	a3,8(s0)
 806:	e818                	sd	a4,16(s0)
 808:	ec1c                	sd	a5,24(s0)
 80a:	03043023          	sd	a6,32(s0)
 80e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	8622                	mv	a2,s0
 814:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 818:	d23ff0ef          	jal	53a <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6161                	addi	sp,sp,80
 822:	8082                	ret

0000000000000824 <printf>:

void
printf(const char *fmt, ...)
{
 824:	711d                	addi	sp,sp,-96
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e40c                	sd	a1,8(s0)
 82e:	e810                	sd	a2,16(s0)
 830:	ec14                	sd	a3,24(s0)
 832:	f018                	sd	a4,32(s0)
 834:	f41c                	sd	a5,40(s0)
 836:	03043823          	sd	a6,48(s0)
 83a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	00840613          	addi	a2,s0,8
 842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 846:	85aa                	mv	a1,a0
 848:	4505                	li	a0,1
 84a:	cf1ff0ef          	jal	53a <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6125                	addi	sp,sp,96
 854:	8082                	ret

0000000000000856 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 856:	1141                	addi	sp,sp,-16
 858:	e406                	sd	ra,8(sp)
 85a:	e022                	sd	s0,0(sp)
 85c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	00000797          	auipc	a5,0x0
 866:	79e7b783          	ld	a5,1950(a5) # 1000 <freep>
 86a:	a039                	j	878 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	6398                	ld	a4,0(a5)
 86e:	00e7e463          	bltu	a5,a4,876 <free+0x20>
 872:	00e6ea63          	bltu	a3,a4,886 <free+0x30>
{
 876:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	fed7fae3          	bgeu	a5,a3,86c <free+0x16>
 87c:	6398                	ld	a4,0(a5)
 87e:	00e6e463          	bltu	a3,a4,886 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	fee7eae3          	bltu	a5,a4,876 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 886:	ff852583          	lw	a1,-8(a0)
 88a:	6390                	ld	a2,0(a5)
 88c:	02059813          	slli	a6,a1,0x20
 890:	01c85713          	srli	a4,a6,0x1c
 894:	9736                	add	a4,a4,a3
 896:	02e60563          	beq	a2,a4,8c0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 89a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 89e:	4790                	lw	a2,8(a5)
 8a0:	02061593          	slli	a1,a2,0x20
 8a4:	01c5d713          	srli	a4,a1,0x1c
 8a8:	973e                	add	a4,a4,a5
 8aa:	02e68263          	beq	a3,a4,8ce <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8ae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74f73823          	sd	a5,1872(a4) # 1000 <freep>
}
 8b8:	60a2                	ld	ra,8(sp)
 8ba:	6402                	ld	s0,0(sp)
 8bc:	0141                	addi	sp,sp,16
 8be:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8c0:	4618                	lw	a4,8(a2)
 8c2:	9f2d                	addw	a4,a4,a1
 8c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	6310                	ld	a2,0(a4)
 8cc:	b7f9                	j	89a <free+0x44>
    p->s.size += bp->s.size;
 8ce:	ff852703          	lw	a4,-8(a0)
 8d2:	9f31                	addw	a4,a4,a2
 8d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d6:	ff053683          	ld	a3,-16(a0)
 8da:	bfd1                	j	8ae <free+0x58>

00000000000008dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	ec4e                	sd	s3,24(sp)
 8e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e8:	02051993          	slli	s3,a0,0x20
 8ec:	0209d993          	srli	s3,s3,0x20
 8f0:	09bd                	addi	s3,s3,15
 8f2:	0049d993          	srli	s3,s3,0x4
 8f6:	2985                	addiw	s3,s3,1
 8f8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8fa:	00000517          	auipc	a0,0x0
 8fe:	70653503          	ld	a0,1798(a0) # 1000 <freep>
 902:	c905                	beqz	a0,932 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 904:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 906:	4798                	lw	a4,8(a5)
 908:	09377663          	bgeu	a4,s3,994 <malloc+0xb8>
 90c:	f426                	sd	s1,40(sp)
 90e:	e852                	sd	s4,16(sp)
 910:	e456                	sd	s5,8(sp)
 912:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 914:	8a4e                	mv	s4,s3
 916:	6705                	lui	a4,0x1
 918:	00e9f363          	bgeu	s3,a4,91e <malloc+0x42>
 91c:	6a05                	lui	s4,0x1
 91e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 926:	00000497          	auipc	s1,0x0
 92a:	6da48493          	addi	s1,s1,1754 # 1000 <freep>
  if(p == SBRK_ERROR)
 92e:	5afd                	li	s5,-1
 930:	a83d                	j	96e <malloc+0x92>
 932:	f426                	sd	s1,40(sp)
 934:	e852                	sd	s4,16(sp)
 936:	e456                	sd	s5,8(sp)
 938:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 93a:	00001797          	auipc	a5,0x1
 93e:	8ce78793          	addi	a5,a5,-1842 # 1208 <base>
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
 94a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 950:	b7d1                	j	914 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 952:	6398                	ld	a4,0(a5)
 954:	e118                	sd	a4,0(a0)
 956:	a899                	j	9ac <malloc+0xd0>
  hp->s.size = nu;
 958:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95c:	0541                	addi	a0,a0,16
 95e:	ef9ff0ef          	jal	856 <free>
  return freep;
 962:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 964:	c125                	beqz	a0,9c4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 968:	4798                	lw	a4,8(a5)
 96a:	03277163          	bgeu	a4,s2,98c <malloc+0xb0>
    if(p == freep)
 96e:	6098                	ld	a4,0(s1)
 970:	853e                	mv	a0,a5
 972:	fef71ae3          	bne	a4,a5,966 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 976:	8552                	mv	a0,s4
 978:	a0dff0ef          	jal	384 <sbrk>
  if(p == SBRK_ERROR)
 97c:	fd551ee3          	bne	a0,s5,958 <malloc+0x7c>
        return 0;
 980:	4501                	li	a0,0
 982:	74a2                	ld	s1,40(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
 98a:	a03d                	j	9b8 <malloc+0xdc>
 98c:	74a2                	ld	s1,40(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 994:	fae90fe3          	beq	s2,a4,952 <malloc+0x76>
        p->s.size -= nunits;
 998:	4137073b          	subw	a4,a4,s3
 99c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99e:	02071693          	slli	a3,a4,0x20
 9a2:	01c6d713          	srli	a4,a3,0x1c
 9a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64a73a23          	sd	a0,1620(a4) # 1000 <freep>
      return (void*)(p + 1);
 9b4:	01078513          	addi	a0,a5,16
  }
}
 9b8:	70e2                	ld	ra,56(sp)
 9ba:	7442                	ld	s0,48(sp)
 9bc:	7902                	ld	s2,32(sp)
 9be:	69e2                	ld	s3,24(sp)
 9c0:	6121                	addi	sp,sp,64
 9c2:	8082                	ret
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
 9cc:	b7f5                	j	9b8 <malloc+0xdc>

00000000000009ce <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 9ce:	7179                	addi	sp,sp,-48
 9d0:	f406                	sd	ra,40(sp)
 9d2:	f022                	sd	s0,32(sp)
 9d4:	ec26                	sd	s1,24(sp)
 9d6:	e84a                	sd	s2,16(sp)
 9d8:	e44e                	sd	s3,8(sp)
 9da:	1800                	addi	s0,sp,48
 9dc:	89aa                	mv	s3,a0
 9de:	892e                	mv	s2,a1
 9e0:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 9e2:	00c6151b          	slliw	a0,a2,0xc
 9e6:	ef7ff0ef          	jal	8dc <malloc>
  if(stack == 0) return -1;
 9ea:	c91d                	beqz	a0,a20 <thread_create+0x52>
 9ec:	e052                	sd	s4,0(sp)
 9ee:	862a                	mv	a2,a0
 9f0:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 9f2:	10000713          	li	a4,256
 9f6:	86a6                	mv	a3,s1
 9f8:	85ca                	mv	a1,s2
 9fa:	854e                	mv	a0,s3
 9fc:	9d3ff0ef          	jal	3ce <clone>

  if(pid < 0) {
 a00:	00054a63          	bltz	a0,a14 <thread_create+0x46>
 a04:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 a06:	70a2                	ld	ra,40(sp)
 a08:	7402                	ld	s0,32(sp)
 a0a:	64e2                	ld	s1,24(sp)
 a0c:	6942                	ld	s2,16(sp)
 a0e:	69a2                	ld	s3,8(sp)
 a10:	6145                	addi	sp,sp,48
 a12:	8082                	ret
    free(stack);
 a14:	8552                	mv	a0,s4
 a16:	e41ff0ef          	jal	856 <free>
    return -1;
 a1a:	557d                	li	a0,-1
 a1c:	6a02                	ld	s4,0(sp)
 a1e:	b7e5                	j	a06 <thread_create+0x38>
  if(stack == 0) return -1;
 a20:	557d                	li	a0,-1
 a22:	b7d5                	j	a06 <thread_create+0x38>

0000000000000a24 <thread_join>:

int
thread_join(void)
{
 a24:	7179                	addi	sp,sp,-48
 a26:	f406                	sd	ra,40(sp)
 a28:	f022                	sd	s0,32(sp)
 a2a:	ec26                	sd	s1,24(sp)
 a2c:	1800                	addi	s0,sp,48
  void *stack = 0;
 a2e:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 a32:	fd840513          	addi	a0,s0,-40
 a36:	9a1ff0ef          	jal	3d6 <join>
 a3a:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 a3c:	00a05763          	blez	a0,a4a <thread_join+0x26>
 a40:	fd843503          	ld	a0,-40(s0)
 a44:	c119                	beqz	a0,a4a <thread_join+0x26>
    free(stack);
 a46:	e11ff0ef          	jal	856 <free>
  }
  return pid;
}
 a4a:	8526                	mv	a0,s1
 a4c:	70a2                	ld	ra,40(sp)
 a4e:	7402                	ld	s0,32(sp)
 a50:	64e2                	ld	s1,24(sp)
 a52:	6145                	addi	sp,sp,48
 a54:	8082                	ret
