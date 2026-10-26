
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	3c2000ef          	jal	3ea <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	3ba000ef          	jal	3f2 <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	a1058593          	addi	a1,a1,-1520 # a50 <thread_join+0x38>
  48:	4509                	li	a0,2
  4a:	7a4000ef          	jal	7ee <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	382000ef          	jal	3d2 <exit>
    }
  }
  if(n < 0){
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	9fe58593          	addi	a1,a1,-1538 # a68 <thread_join+0x50>
  72:	4509                	li	a0,2
  74:	77a000ef          	jal	7ee <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	358000ef          	jal	3d2 <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	366000ef          	jal	412 <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	33e000ef          	jal	3fa <close>
  for(i = 1; i < argc; i++){
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	30a000ef          	jal	3d2 <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2f8000ef          	jal	3d2 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	99e58593          	addi	a1,a1,-1634 # a80 <thread_join+0x68>
  ea:	4509                	li	a0,2
  ec:	702000ef          	jal	7ee <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2e0000ef          	jal	3d2 <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	2d0000ef          	jal	3d2 <exit>

0000000000000106 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x28>
 164:	00150793          	addi	a5,a0,1
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfdd                	j	176 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1e>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x14>
  }
  return dst;
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char*
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf81                	beqz	a5,1cc <strchr+0x24>
    if(*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1c>
  for(; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xe>
      return (char*)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret
  return 0;
 1cc:	4501                	li	a0,0
 1ce:	bfdd                	j	1c4 <strchr+0x1c>

00000000000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	711d                	addi	sp,sp,-96
 1d2:	ec86                	sd	ra,88(sp)
 1d4:	e8a2                	sd	s0,80(sp)
 1d6:	e4a6                	sd	s1,72(sp)
 1d8:	e0ca                	sd	s2,64(sp)
 1da:	fc4e                	sd	s3,56(sp)
 1dc:	f852                	sd	s4,48(sp)
 1de:	f456                	sd	s5,40(sp)
 1e0:	f05a                	sd	s6,32(sp)
 1e2:	ec5e                	sd	s7,24(sp)
 1e4:	e862                	sd	s8,16(sp)
 1e6:	1080                	addi	s0,sp,96
 1e8:	8baa                	mv	s7,a0
 1ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	892a                	mv	s2,a0
 1ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f0:	faf40b13          	addi	s6,s0,-81
 1f4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1f6:	8c26                	mv	s8,s1
 1f8:	0014899b          	addiw	s3,s1,1
 1fc:	84ce                	mv	s1,s3
 1fe:	0349d463          	bge	s3,s4,226 <gets+0x56>
    cc = read(0, &c, 1);
 202:	8656                	mv	a2,s5
 204:	85da                	mv	a1,s6
 206:	4501                	li	a0,0
 208:	1e2000ef          	jal	3ea <read>
    if(cc < 1)
 20c:	00a05d63          	blez	a0,226 <gets+0x56>
      break;
    buf[i++] = c;
 210:	faf44783          	lbu	a5,-81(s0)
 214:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 218:	0905                	addi	s2,s2,1
 21a:	ff678713          	addi	a4,a5,-10
 21e:	c319                	beqz	a4,224 <gets+0x54>
 220:	17cd                	addi	a5,a5,-13
 222:	fbf1                	bnez	a5,1f6 <gets+0x26>
    buf[i++] = c;
 224:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 226:	9c5e                	add	s8,s8,s7
 228:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22c:	855e                	mv	a0,s7
 22e:	60e6                	ld	ra,88(sp)
 230:	6446                	ld	s0,80(sp)
 232:	64a6                	ld	s1,72(sp)
 234:	6906                	ld	s2,64(sp)
 236:	79e2                	ld	s3,56(sp)
 238:	7a42                	ld	s4,48(sp)
 23a:	7aa2                	ld	s5,40(sp)
 23c:	7b02                	ld	s6,32(sp)
 23e:	6be2                	ld	s7,24(sp)
 240:	6c42                	ld	s8,16(sp)
 242:	6125                	addi	sp,sp,96
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	1be000ef          	jal	412 <open>
  if(fd < 0)
 258:	02054263          	bltz	a0,27c <stat+0x36>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	1c8000ef          	jal	42a <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	190000ef          	jal	3fa <close>
  return r;
 26e:	64a2                	ld	s1,8(sp)
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	57fd                	li	a5,-1
 27e:	893e                	mv	s2,a5
 280:	bfc5                	j	270 <stat+0x2a>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66963          	bltu	a2,a5,2ca <atoi+0x48>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1e>
  return n;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <atoi+0x40>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d6:	02b57563          	bgeu	a0,a1,300 <memmove+0x32>
    while(n-- > 0)
 2da:	00c05f63          	blez	a2,2f8 <memmove+0x2a>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
    while(n-- > 0)
 300:	fec05ce3          	blez	a2,2f8 <memmove+0x2a>
    dst += n;
 304:	00c50733          	add	a4,a0,a2
    src += n;
 308:	95b2                	add	a1,a1,a2
 30a:	fff6079b          	addiw	a5,a2,-1
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	fff7c793          	not	a5,a5
 316:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 318:	15fd                	addi	a1,a1,-1
 31a:	177d                	addi	a4,a4,-1
 31c:	0005c683          	lbu	a3,0(a1)
 320:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 324:	fef71ae3          	bne	a4,a5,318 <memmove+0x4a>
 328:	bfc1                	j	2f8 <memmove+0x2a>

000000000000032a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 332:	c61d                	beqz	a2,360 <memcmp+0x36>
 334:	1602                	slli	a2,a2,0x20
 336:	9201                	srli	a2,a2,0x20
 338:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 33c:	00054783          	lbu	a5,0(a0)
 340:	0005c703          	lbu	a4,0(a1)
 344:	00e79863          	bne	a5,a4,354 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 348:	0505                	addi	a0,a0,1
    p2++;
 34a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34c:	fed518e3          	bne	a0,a3,33c <memcmp+0x12>
  }
  return 0;
 350:	4501                	li	a0,0
 352:	a019                	j	358 <memcmp+0x2e>
      return *p1 - *p2;
 354:	40e7853b          	subw	a0,a5,a4
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  return 0;
 360:	4501                	li	a0,0
 362:	bfdd                	j	358 <memcmp+0x2e>

0000000000000364 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36c:	f63ff0ef          	jal	2ce <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrk>:

char *
sbrk(int n) {
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 380:	4585                	li	a1,1
 382:	0d8000ef          	jal	45a <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret

000000000000038e <sbrklazy>:

char *
sbrklazy(int n) {
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 396:	4589                	li	a1,2
 398:	0c2000ef          	jal	45a <sys_sbrk>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:

int
fork(void)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 3ac:	4701                	li	a4,0
 3ae:	4681                	li	a3,0
 3b0:	4601                	li	a2,0
 3b2:	4581                	li	a1,0
 3b4:	4501                	li	a0,0
 3b6:	00c000ef          	jal	3c2 <clone>
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 3c2:	4885                	li	a7,1
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <join>:
.global join
join:
 li a7, SYS_join
 3ca:	48d9                	li	a7,22
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d2:	4889                	li	a7,2
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <wait>:
.global wait
wait:
 li a7, SYS_wait
 3da:	488d                	li	a7,3
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e2:	4891                	li	a7,4
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <read>:
.global read
read:
 li a7, SYS_read
 3ea:	4895                	li	a7,5
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <write>:
.global write
write:
 li a7, SYS_write
 3f2:	48c1                	li	a7,16
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <close>:
.global close
close:
 li a7, SYS_close
 3fa:	48d5                	li	a7,21
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <kill>:
.global kill
kill:
 li a7, SYS_kill
 402:	4899                	li	a7,6
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exec>:
.global exec
exec:
 li a7, SYS_exec
 40a:	489d                	li	a7,7
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <open>:
.global open
open:
 li a7, SYS_open
 412:	48bd                	li	a7,15
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41a:	48c5                	li	a7,17
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 422:	48c9                	li	a7,18
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42a:	48a1                	li	a7,8
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <link>:
.global link
link:
 li a7, SYS_link
 432:	48cd                	li	a7,19
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43a:	48d1                	li	a7,20
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 442:	48a5                	li	a7,9
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <dup>:
.global dup
dup:
 li a7, SYS_dup
 44a:	48a9                	li	a7,10
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 452:	48ad                	li	a7,11
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 45a:	48b1                	li	a7,12
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <pause>:
.global pause
pause:
 li a7, SYS_pause
 462:	48b5                	li	a7,13
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46a:	48b9                	li	a7,14
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	f6fff0ef          	jal	3f2 <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 490:	715d                	addi	sp,sp,-80
 492:	e486                	sd	ra,72(sp)
 494:	e0a2                	sd	s0,64(sp)
 496:	f84a                	sd	s2,48(sp)
 498:	f44e                	sd	s3,40(sp)
 49a:	0880                	addi	s0,sp,80
 49c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 49e:	c6d1                	beqz	a3,52a <printint+0x9a>
 4a0:	0805d563          	bgez	a1,52a <printint+0x9a>
    neg = 1;
    x = -xx;
 4a4:	40b005b3          	neg	a1,a1
    neg = 1;
 4a8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4aa:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4ae:	86ce                	mv	a3,s3
  i = 0;
 4b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b2:	00000817          	auipc	a6,0x0
 4b6:	5ee80813          	addi	a6,a6,1518 # aa0 <digits>
 4ba:	88ba                	mv	a7,a4
 4bc:	0017051b          	addiw	a0,a4,1
 4c0:	872a                	mv	a4,a0
 4c2:	02c5f7b3          	remu	a5,a1,a2
 4c6:	97c2                	add	a5,a5,a6
 4c8:	0007c783          	lbu	a5,0(a5)
 4cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d0:	87ae                	mv	a5,a1
 4d2:	02c5d5b3          	divu	a1,a1,a2
 4d6:	0685                	addi	a3,a3,1
 4d8:	fec7f1e3          	bgeu	a5,a2,4ba <printint+0x2a>
  if(neg)
 4dc:	00030c63          	beqz	t1,4f4 <printint+0x64>
    buf[i++] = '-';
 4e0:	fd050793          	addi	a5,a0,-48
 4e4:	00878533          	add	a0,a5,s0
 4e8:	02d00793          	li	a5,45
 4ec:	fef50423          	sb	a5,-24(a0)
 4f0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4f4:	02e05563          	blez	a4,51e <printint+0x8e>
 4f8:	fc26                	sd	s1,56(sp)
 4fa:	377d                	addiw	a4,a4,-1
 4fc:	00e984b3          	add	s1,s3,a4
 500:	19fd                	addi	s3,s3,-1
 502:	99ba                	add	s3,s3,a4
 504:	1702                	slli	a4,a4,0x20
 506:	9301                	srli	a4,a4,0x20
 508:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50c:	0004c583          	lbu	a1,0(s1)
 510:	854a                	mv	a0,s2
 512:	f61ff0ef          	jal	472 <putc>
  while(--i >= 0)
 516:	14fd                	addi	s1,s1,-1
 518:	ff349ae3          	bne	s1,s3,50c <printint+0x7c>
 51c:	74e2                	ld	s1,56(sp)
}
 51e:	60a6                	ld	ra,72(sp)
 520:	6406                	ld	s0,64(sp)
 522:	7942                	ld	s2,48(sp)
 524:	79a2                	ld	s3,40(sp)
 526:	6161                	addi	sp,sp,80
 528:	8082                	ret
  neg = 0;
 52a:	4301                	li	t1,0
 52c:	bfbd                	j	4aa <printint+0x1a>

000000000000052e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52e:	711d                	addi	sp,sp,-96
 530:	ec86                	sd	ra,88(sp)
 532:	e8a2                	sd	s0,80(sp)
 534:	e4a6                	sd	s1,72(sp)
 536:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 538:	0005c483          	lbu	s1,0(a1)
 53c:	22048363          	beqz	s1,762 <vprintf+0x234>
 540:	e0ca                	sd	s2,64(sp)
 542:	fc4e                	sd	s3,56(sp)
 544:	f852                	sd	s4,48(sp)
 546:	f456                	sd	s5,40(sp)
 548:	f05a                	sd	s6,32(sp)
 54a:	ec5e                	sd	s7,24(sp)
 54c:	e862                	sd	s8,16(sp)
 54e:	8b2a                	mv	s6,a0
 550:	8a2e                	mv	s4,a1
 552:	8bb2                	mv	s7,a2
  state = 0;
 554:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 556:	4901                	li	s2,0
 558:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 55a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 55e:	06400c13          	li	s8,100
 562:	a00d                	j	584 <vprintf+0x56>
        putc(fd, c0);
 564:	85a6                	mv	a1,s1
 566:	855a                	mv	a0,s6
 568:	f0bff0ef          	jal	472 <putc>
 56c:	a019                	j	572 <vprintf+0x44>
    } else if(state == '%'){
 56e:	03598363          	beq	s3,s5,594 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 572:	0019079b          	addiw	a5,s2,1
 576:	893e                	mv	s2,a5
 578:	873e                	mv	a4,a5
 57a:	97d2                	add	a5,a5,s4
 57c:	0007c483          	lbu	s1,0(a5)
 580:	1c048a63          	beqz	s1,754 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 584:	0004879b          	sext.w	a5,s1
    if(state == 0){
 588:	fe0993e3          	bnez	s3,56e <vprintf+0x40>
      if(c0 == '%'){
 58c:	fd579ce3          	bne	a5,s5,564 <vprintf+0x36>
        state = '%';
 590:	89be                	mv	s3,a5
 592:	b7c5                	j	572 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 594:	00ea06b3          	add	a3,s4,a4
 598:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 59c:	1c060863          	beqz	a2,76c <vprintf+0x23e>
      if(c0 == 'd'){
 5a0:	03878763          	beq	a5,s8,5ce <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a4:	f9478693          	addi	a3,a5,-108
 5a8:	0016b693          	seqz	a3,a3
 5ac:	f9c60593          	addi	a1,a2,-100
 5b0:	e99d                	bnez	a1,5e6 <vprintf+0xb8>
 5b2:	ca95                	beqz	a3,5e6 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	ecfff0ef          	jal	490 <printint>
        i += 1;
 5c6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b75d                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	eb5ff0ef          	jal	490 <printint>
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b779                	j	572 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5e6:	9752                	add	a4,a4,s4
 5e8:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ec:	f9460713          	addi	a4,a2,-108
 5f0:	00173713          	seqz	a4,a4
 5f4:	8f75                	and	a4,a4,a3
 5f6:	f9c58513          	addi	a0,a1,-100
 5fa:	18051363          	bnez	a0,780 <vprintf+0x252>
 5fe:	18070163          	beqz	a4,780 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e81ff0ef          	jal	490 <printint>
        i += 2;
 614:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	bfa1                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000be583          	lwu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e67ff0ef          	jal	490 <printint>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	b781                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	e4fff0ef          	jal	490 <printint>
        i += 1;
 646:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b71d                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8493          	addi	s1,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e35ff0ef          	jal	490 <printint>
        i += 2;
 660:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	b731                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000be583          	lwu	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e1bff0ef          	jal	490 <printint>
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bdd5                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	008b8493          	addi	s1,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000bb583          	ld	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	e03ff0ef          	jal	490 <printint>
        i += 1;
 692:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	8ba6                	mv	s7,s1
      state = 0;
 696:	4981                	li	s3,0
 698:	bde9                	j	572 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69a:	008b8493          	addi	s1,s7,8
 69e:	4681                	li	a3,0
 6a0:	4641                	li	a2,16
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	de9ff0ef          	jal	490 <printint>
        i += 2;
 6ac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	8ba6                	mv	s7,s1
      state = 0;
 6b0:	4981                	li	s3,0
        i += 2;
 6b2:	b5c1                	j	572 <vprintf+0x44>
 6b4:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6b6:	008b8793          	addi	a5,s7,8
 6ba:	8cbe                	mv	s9,a5
 6bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c0:	03000593          	li	a1,48
 6c4:	855a                	mv	a0,s6
 6c6:	dadff0ef          	jal	472 <putc>
  putc(fd, 'x');
 6ca:	07800593          	li	a1,120
 6ce:	855a                	mv	a0,s6
 6d0:	da3ff0ef          	jal	472 <putc>
 6d4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d6:	00000b97          	auipc	s7,0x0
 6da:	3cab8b93          	addi	s7,s7,970 # aa0 <digits>
 6de:	03c9d793          	srli	a5,s3,0x3c
 6e2:	97de                	add	a5,a5,s7
 6e4:	0007c583          	lbu	a1,0(a5)
 6e8:	855a                	mv	a0,s6
 6ea:	d89ff0ef          	jal	472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ee:	0992                	slli	s3,s3,0x4
 6f0:	34fd                	addiw	s1,s1,-1
 6f2:	f4f5                	bnez	s1,6de <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6f4:	8be6                	mv	s7,s9
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	6ca2                	ld	s9,8(sp)
 6fa:	bda5                	j	572 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6fc:	008b8493          	addi	s1,s7,8
 700:	000bc583          	lbu	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	d6dff0ef          	jal	472 <putc>
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b595                	j	572 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 710:	008b8993          	addi	s3,s7,8
 714:	000bb483          	ld	s1,0(s7)
 718:	cc91                	beqz	s1,734 <vprintf+0x206>
        for(; *s; s++)
 71a:	0004c583          	lbu	a1,0(s1)
 71e:	c985                	beqz	a1,74e <vprintf+0x220>
          putc(fd, *s);
 720:	855a                	mv	a0,s6
 722:	d51ff0ef          	jal	472 <putc>
        for(; *s; s++)
 726:	0485                	addi	s1,s1,1
 728:	0004c583          	lbu	a1,0(s1)
 72c:	f9f5                	bnez	a1,720 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	b581                	j	572 <vprintf+0x44>
          s = "(null)";
 734:	00000497          	auipc	s1,0x0
 738:	36448493          	addi	s1,s1,868 # a98 <thread_join+0x80>
        for(; *s; s++)
 73c:	02800593          	li	a1,40
 740:	b7c5                	j	720 <vprintf+0x1f2>
        putc(fd, '%');
 742:	85be                	mv	a1,a5
 744:	855a                	mv	a0,s6
 746:	d2dff0ef          	jal	472 <putc>
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b51d                	j	572 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	b505                	j	572 <vprintf+0x44>
 754:	6906                	ld	s2,64(sp)
 756:	79e2                	ld	s3,56(sp)
 758:	7a42                	ld	s4,48(sp)
 75a:	7aa2                	ld	s5,40(sp)
 75c:	7b02                	ld	s6,32(sp)
 75e:	6be2                	ld	s7,24(sp)
 760:	6c42                	ld	s8,16(sp)
    }
  }
}
 762:	60e6                	ld	ra,88(sp)
 764:	6446                	ld	s0,80(sp)
 766:	64a6                	ld	s1,72(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret
      if(c0 == 'd'){
 76c:	06400713          	li	a4,100
 770:	e4e78fe3          	beq	a5,a4,5ce <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 774:	f9478693          	addi	a3,a5,-108
 778:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 77c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 77e:	4701                	li	a4,0
      } else if(c0 == 'u'){
 780:	07500513          	li	a0,117
 784:	e8a78ce3          	beq	a5,a0,61c <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 788:	f8b60513          	addi	a0,a2,-117
 78c:	e119                	bnez	a0,792 <vprintf+0x264>
 78e:	ea0693e3          	bnez	a3,634 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 792:	f8b58513          	addi	a0,a1,-117
 796:	e119                	bnez	a0,79c <vprintf+0x26e>
 798:	ea071be3          	bnez	a4,64e <vprintf+0x120>
      } else if(c0 == 'x'){
 79c:	07800513          	li	a0,120
 7a0:	eca784e3          	beq	a5,a0,668 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7a4:	f8860613          	addi	a2,a2,-120
 7a8:	e219                	bnez	a2,7ae <vprintf+0x280>
 7aa:	ec069be3          	bnez	a3,680 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7ae:	f8858593          	addi	a1,a1,-120
 7b2:	e199                	bnez	a1,7b8 <vprintf+0x28a>
 7b4:	ee0713e3          	bnez	a4,69a <vprintf+0x16c>
      } else if(c0 == 'p'){
 7b8:	07000713          	li	a4,112
 7bc:	eee78ce3          	beq	a5,a4,6b4 <vprintf+0x186>
      } else if(c0 == 'c'){
 7c0:	06300713          	li	a4,99
 7c4:	f2e78ce3          	beq	a5,a4,6fc <vprintf+0x1ce>
      } else if(c0 == 's'){
 7c8:	07300713          	li	a4,115
 7cc:	f4e782e3          	beq	a5,a4,710 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7d0:	02500713          	li	a4,37
 7d4:	f6e787e3          	beq	a5,a4,742 <vprintf+0x214>
        putc(fd, '%');
 7d8:	02500593          	li	a1,37
 7dc:	855a                	mv	a0,s6
 7de:	c95ff0ef          	jal	472 <putc>
        putc(fd, c0);
 7e2:	85a6                	mv	a1,s1
 7e4:	855a                	mv	a0,s6
 7e6:	c8dff0ef          	jal	472 <putc>
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	b359                	j	572 <vprintf+0x44>

00000000000007ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ee:	715d                	addi	sp,sp,-80
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e010                	sd	a2,0(s0)
 7f8:	e414                	sd	a3,8(s0)
 7fa:	e818                	sd	a4,16(s0)
 7fc:	ec1c                	sd	a5,24(s0)
 7fe:	03043023          	sd	a6,32(s0)
 802:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	8622                	mv	a2,s0
 808:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80c:	d23ff0ef          	jal	52e <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6161                	addi	sp,sp,80
 816:	8082                	ret

0000000000000818 <printf>:

void
printf(const char *fmt, ...)
{
 818:	711d                	addi	sp,sp,-96
 81a:	ec06                	sd	ra,24(sp)
 81c:	e822                	sd	s0,16(sp)
 81e:	1000                	addi	s0,sp,32
 820:	e40c                	sd	a1,8(s0)
 822:	e810                	sd	a2,16(s0)
 824:	ec14                	sd	a3,24(s0)
 826:	f018                	sd	a4,32(s0)
 828:	f41c                	sd	a5,40(s0)
 82a:	03043823          	sd	a6,48(s0)
 82e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 832:	00840613          	addi	a2,s0,8
 836:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83a:	85aa                	mv	a1,a0
 83c:	4505                	li	a0,1
 83e:	cf1ff0ef          	jal	52e <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6125                	addi	sp,sp,96
 848:	8082                	ret

000000000000084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84a:	1141                	addi	sp,sp,-16
 84c:	e406                	sd	ra,8(sp)
 84e:	e022                	sd	s0,0(sp)
 850:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 852:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	00000797          	auipc	a5,0x0
 85a:	7aa7b783          	ld	a5,1962(a5) # 1000 <freep>
 85e:	a039                	j	86c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	6398                	ld	a4,0(a5)
 862:	00e7e463          	bltu	a5,a4,86a <free+0x20>
 866:	00e6ea63          	bltu	a3,a4,87a <free+0x30>
{
 86a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	fed7fae3          	bgeu	a5,a3,860 <free+0x16>
 870:	6398                	ld	a4,0(a5)
 872:	00e6e463          	bltu	a3,a4,87a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	fee7eae3          	bltu	a5,a4,86a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 87a:	ff852583          	lw	a1,-8(a0)
 87e:	6390                	ld	a2,0(a5)
 880:	02059813          	slli	a6,a1,0x20
 884:	01c85713          	srli	a4,a6,0x1c
 888:	9736                	add	a4,a4,a3
 88a:	02e60563          	beq	a2,a4,8b4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 88e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 892:	4790                	lw	a2,8(a5)
 894:	02061593          	slli	a1,a2,0x20
 898:	01c5d713          	srli	a4,a1,0x1c
 89c:	973e                	add	a4,a4,a5
 89e:	02e68263          	beq	a3,a4,8c2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8a2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
}
 8ac:	60a2                	ld	ra,8(sp)
 8ae:	6402                	ld	s0,0(sp)
 8b0:	0141                	addi	sp,sp,16
 8b2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8b4:	4618                	lw	a4,8(a2)
 8b6:	9f2d                	addw	a4,a4,a1
 8b8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	6398                	ld	a4,0(a5)
 8be:	6310                	ld	a2,0(a4)
 8c0:	b7f9                	j	88e <free+0x44>
    p->s.size += bp->s.size;
 8c2:	ff852703          	lw	a4,-8(a0)
 8c6:	9f31                	addw	a4,a4,a2
 8c8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ca:	ff053683          	ld	a3,-16(a0)
 8ce:	bfd1                	j	8a2 <free+0x58>

00000000000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	7139                	addi	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	ec4e                	sd	s3,24(sp)
 8da:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8dc:	02051993          	slli	s3,a0,0x20
 8e0:	0209d993          	srli	s3,s3,0x20
 8e4:	09bd                	addi	s3,s3,15
 8e6:	0049d993          	srli	s3,s3,0x4
 8ea:	2985                	addiw	s3,s3,1
 8ec:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8ee:	00000517          	auipc	a0,0x0
 8f2:	71253503          	ld	a0,1810(a0) # 1000 <freep>
 8f6:	c905                	beqz	a0,926 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fa:	4798                	lw	a4,8(a5)
 8fc:	09377663          	bgeu	a4,s3,988 <malloc+0xb8>
 900:	f426                	sd	s1,40(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 908:	8a4e                	mv	s4,s3
 90a:	6705                	lui	a4,0x1
 90c:	00e9f363          	bgeu	s3,a4,912 <malloc+0x42>
 910:	6a05                	lui	s4,0x1
 912:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 916:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91a:	00000497          	auipc	s1,0x0
 91e:	6e648493          	addi	s1,s1,1766 # 1000 <freep>
  if(p == SBRK_ERROR)
 922:	5afd                	li	s5,-1
 924:	a83d                	j	962 <malloc+0x92>
 926:	f426                	sd	s1,40(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 92e:	00001797          	auipc	a5,0x1
 932:	8e278793          	addi	a5,a5,-1822 # 1210 <base>
 936:	00000717          	auipc	a4,0x0
 93a:	6cf73523          	sd	a5,1738(a4) # 1000 <freep>
 93e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 940:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 944:	b7d1                	j	908 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	e118                	sd	a4,0(a0)
 94a:	a899                	j	9a0 <malloc+0xd0>
  hp->s.size = nu;
 94c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 950:	0541                	addi	a0,a0,16
 952:	ef9ff0ef          	jal	84a <free>
  return freep;
 956:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 958:	c125                	beqz	a0,9b8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95c:	4798                	lw	a4,8(a5)
 95e:	03277163          	bgeu	a4,s2,980 <malloc+0xb0>
    if(p == freep)
 962:	6098                	ld	a4,0(s1)
 964:	853e                	mv	a0,a5
 966:	fef71ae3          	bne	a4,a5,95a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 96a:	8552                	mv	a0,s4
 96c:	a0dff0ef          	jal	378 <sbrk>
  if(p == SBRK_ERROR)
 970:	fd551ee3          	bne	a0,s5,94c <malloc+0x7c>
        return 0;
 974:	4501                	li	a0,0
 976:	74a2                	ld	s1,40(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	a03d                	j	9ac <malloc+0xdc>
 980:	74a2                	ld	s1,40(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 988:	fae90fe3          	beq	s2,a4,946 <malloc+0x76>
        p->s.size -= nunits;
 98c:	4137073b          	subw	a4,a4,s3
 990:	c798                	sw	a4,8(a5)
        p += p->s.size;
 992:	02071693          	slli	a3,a4,0x20
 996:	01c6d713          	srli	a4,a3,0x1c
 99a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a0:	00000717          	auipc	a4,0x0
 9a4:	66a73023          	sd	a0,1632(a4) # 1000 <freep>
      return (void*)(p + 1);
 9a8:	01078513          	addi	a0,a5,16
  }
}
 9ac:	70e2                	ld	ra,56(sp)
 9ae:	7442                	ld	s0,48(sp)
 9b0:	7902                	ld	s2,32(sp)
 9b2:	69e2                	ld	s3,24(sp)
 9b4:	6121                	addi	sp,sp,64
 9b6:	8082                	ret
 9b8:	74a2                	ld	s1,40(sp)
 9ba:	6a42                	ld	s4,16(sp)
 9bc:	6aa2                	ld	s5,8(sp)
 9be:	6b02                	ld	s6,0(sp)
 9c0:	b7f5                	j	9ac <malloc+0xdc>

00000000000009c2 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 9c2:	7179                	addi	sp,sp,-48
 9c4:	f406                	sd	ra,40(sp)
 9c6:	f022                	sd	s0,32(sp)
 9c8:	ec26                	sd	s1,24(sp)
 9ca:	e84a                	sd	s2,16(sp)
 9cc:	e44e                	sd	s3,8(sp)
 9ce:	1800                	addi	s0,sp,48
 9d0:	89aa                	mv	s3,a0
 9d2:	892e                	mv	s2,a1
 9d4:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 9d6:	00c6151b          	slliw	a0,a2,0xc
 9da:	ef7ff0ef          	jal	8d0 <malloc>
  if(stack == 0) return -1;
 9de:	c91d                	beqz	a0,a14 <thread_create+0x52>
 9e0:	e052                	sd	s4,0(sp)
 9e2:	862a                	mv	a2,a0
 9e4:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 9e6:	10000713          	li	a4,256
 9ea:	86a6                	mv	a3,s1
 9ec:	85ca                	mv	a1,s2
 9ee:	854e                	mv	a0,s3
 9f0:	9d3ff0ef          	jal	3c2 <clone>

  if(pid < 0) {
 9f4:	00054a63          	bltz	a0,a08 <thread_create+0x46>
 9f8:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 9fa:	70a2                	ld	ra,40(sp)
 9fc:	7402                	ld	s0,32(sp)
 9fe:	64e2                	ld	s1,24(sp)
 a00:	6942                	ld	s2,16(sp)
 a02:	69a2                	ld	s3,8(sp)
 a04:	6145                	addi	sp,sp,48
 a06:	8082                	ret
    free(stack);
 a08:	8552                	mv	a0,s4
 a0a:	e41ff0ef          	jal	84a <free>
    return -1;
 a0e:	557d                	li	a0,-1
 a10:	6a02                	ld	s4,0(sp)
 a12:	b7e5                	j	9fa <thread_create+0x38>
  if(stack == 0) return -1;
 a14:	557d                	li	a0,-1
 a16:	b7d5                	j	9fa <thread_create+0x38>

0000000000000a18 <thread_join>:

int
thread_join(void)
{
 a18:	7179                	addi	sp,sp,-48
 a1a:	f406                	sd	ra,40(sp)
 a1c:	f022                	sd	s0,32(sp)
 a1e:	ec26                	sd	s1,24(sp)
 a20:	1800                	addi	s0,sp,48
  void *stack = 0;
 a22:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 a26:	fd840513          	addi	a0,s0,-40
 a2a:	9a1ff0ef          	jal	3ca <join>
 a2e:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 a30:	00a05763          	blez	a0,a3e <thread_join+0x26>
 a34:	fd843503          	ld	a0,-40(s0)
 a38:	c119                	beqz	a0,a3e <thread_join+0x26>
    free(stack);
 a3a:	e11ff0ef          	jal	84a <free>
  }
  return pid;
}
 a3e:	8526                	mv	a0,s1
 a40:	70a2                	ld	ra,40(sp)
 a42:	7402                	ld	s0,32(sp)
 a44:	64e2                	ld	s1,24(sp)
 a46:	6145                	addi	sp,sp,48
 a48:	8082                	ret
