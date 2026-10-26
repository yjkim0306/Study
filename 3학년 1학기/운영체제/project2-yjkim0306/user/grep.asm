
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	fd250a13          	addi	s4,a0,-46
  1a:	001a3a13          	seqz	s4,s4
    if(matchhere(re, text))
  1e:	85a6                	mv	a1,s1
  20:	854e                	mv	a0,s3
  22:	02a000ef          	jal	4c <matchhere>
  26:	e911                	bnez	a0,3a <matchstar+0x3a>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb81                	beqz	a5,3c <matchstar+0x3c>
  2e:	0485                	addi	s1,s1,1
  30:	ff2787e3          	beq	a5,s2,1e <matchstar+0x1e>
  34:	fe0a15e3          	bnez	s4,1e <matchstar+0x1e>
  38:	a011                	j	3c <matchstar+0x3c>
      return 1;
  3a:	4505                	li	a0,1
  return 0;
}
  3c:	70a2                	ld	ra,40(sp)
  3e:	7402                	ld	s0,32(sp)
  40:	64e2                	ld	s1,24(sp)
  42:	6942                	ld	s2,16(sp)
  44:	69a2                	ld	s3,8(sp)
  46:	6a02                	ld	s4,0(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret

000000000000004c <matchhere>:
  if(re[0] == '\0')
  4c:	00054703          	lbu	a4,0(a0)
  50:	cf39                	beqz	a4,ae <matchhere+0x62>
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  5a:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5c:	00154683          	lbu	a3,1(a0)
  60:	02a00613          	li	a2,42
  64:	02c68363          	beq	a3,a2,8a <matchhere+0x3e>
  if(re[0] == '$' && re[1] == '\0')
  68:	e681                	bnez	a3,70 <matchhere+0x24>
  6a:	fdc70693          	addi	a3,a4,-36
  6e:	c68d                	beqz	a3,98 <matchhere+0x4c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  70:	0005c683          	lbu	a3,0(a1)
  return 0;
  74:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  76:	c691                	beqz	a3,82 <matchhere+0x36>
  78:	02d70563          	beq	a4,a3,a2 <matchhere+0x56>
  7c:	fd270713          	addi	a4,a4,-46
  80:	c30d                	beqz	a4,a2 <matchhere+0x56>
}
  82:	60a2                	ld	ra,8(sp)
  84:	6402                	ld	s0,0(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
    return matchstar(re[0], re+2, text);
  8a:	862e                	mv	a2,a1
  8c:	00250593          	addi	a1,a0,2
  90:	853a                	mv	a0,a4
  92:	f6fff0ef          	jal	0 <matchstar>
  96:	b7f5                	j	82 <matchhere+0x36>
    return *text == '\0';
  98:	0005c503          	lbu	a0,0(a1)
  9c:	00153513          	seqz	a0,a0
  a0:	b7cd                	j	82 <matchhere+0x36>
    return matchhere(re+1, text+1);
  a2:	0585                	addi	a1,a1,1
  a4:	00178513          	addi	a0,a5,1
  a8:	fa5ff0ef          	jal	4c <matchhere>
  ac:	bfd9                	j	82 <matchhere+0x36>
    return 1;
  ae:	4505                	li	a0,1
}
  b0:	8082                	ret

00000000000000b2 <match>:
{
  b2:	1101                	addi	sp,sp,-32
  b4:	ec06                	sd	ra,24(sp)
  b6:	e822                	sd	s0,16(sp)
  b8:	e426                	sd	s1,8(sp)
  ba:	e04a                	sd	s2,0(sp)
  bc:	1000                	addi	s0,sp,32
  be:	892a                	mv	s2,a0
  c0:	84ae                	mv	s1,a1
  if(re[0] == '^')
  c2:	00054703          	lbu	a4,0(a0)
  c6:	05e00793          	li	a5,94
  ca:	00f70c63          	beq	a4,a5,e2 <match+0x30>
    if(matchhere(re, text))
  ce:	85a6                	mv	a1,s1
  d0:	854a                	mv	a0,s2
  d2:	f7bff0ef          	jal	4c <matchhere>
  d6:	e911                	bnez	a0,ea <match+0x38>
  }while(*text++ != '\0');
  d8:	0485                	addi	s1,s1,1
  da:	fff4c783          	lbu	a5,-1(s1)
  de:	fbe5                	bnez	a5,ce <match+0x1c>
  e0:	a031                	j	ec <match+0x3a>
    return matchhere(re+1, text);
  e2:	0505                	addi	a0,a0,1
  e4:	f69ff0ef          	jal	4c <matchhere>
  e8:	a011                	j	ec <match+0x3a>
      return 1;
  ea:	4505                	li	a0,1
}
  ec:	60e2                	ld	ra,24(sp)
  ee:	6442                	ld	s0,16(sp)
  f0:	64a2                	ld	s1,8(sp)
  f2:	6902                	ld	s2,0(sp)
  f4:	6105                	addi	sp,sp,32
  f6:	8082                	ret

00000000000000f8 <grep>:
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
 10e:	e466                	sd	s9,8(sp)
 110:	e06a                	sd	s10,0(sp)
 112:	1080                	addi	s0,sp,96
 114:	8aaa                	mv	s5,a0
 116:	8cae                	mv	s9,a1
  m = 0;
 118:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 11a:	3ff00d13          	li	s10,1023
 11e:	00001b97          	auipc	s7,0x1
 122:	ef2b8b93          	addi	s7,s7,-270 # 1010 <buf>
    while((q = strchr(p, '\n')) != 0){
 126:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 128:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 12a:	a82d                	j	164 <grep+0x6c>
      p = q+1;
 12c:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 130:	85ce                	mv	a1,s3
 132:	854a                	mv	a0,s2
 134:	1da000ef          	jal	30e <strchr>
 138:	84aa                	mv	s1,a0
 13a:	c11d                	beqz	a0,160 <grep+0x68>
      *q = 0;
 13c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 140:	85ca                	mv	a1,s2
 142:	8556                	mv	a0,s5
 144:	f6fff0ef          	jal	b2 <match>
 148:	d175                	beqz	a0,12c <grep+0x34>
        *q = '\n';
 14a:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 14e:	00148613          	addi	a2,s1,1
 152:	4126063b          	subw	a2,a2,s2
 156:	85ca                	mv	a1,s2
 158:	8562                	mv	a0,s8
 15a:	3fe000ef          	jal	558 <write>
 15e:	b7f9                	j	12c <grep+0x34>
    if(m > 0){
 160:	03604463          	bgtz	s6,188 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 164:	416d063b          	subw	a2,s10,s6
 168:	016b85b3          	add	a1,s7,s6
 16c:	8566                	mv	a0,s9
 16e:	3e2000ef          	jal	550 <read>
 172:	02a05c63          	blez	a0,1aa <grep+0xb2>
    m += n;
 176:	00ab0a3b          	addw	s4,s6,a0
 17a:	8b52                	mv	s6,s4
    buf[m] = '\0';
 17c:	014b87b3          	add	a5,s7,s4
 180:	00078023          	sb	zero,0(a5)
    p = buf;
 184:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 186:	b76d                	j	130 <grep+0x38>
      m -= p - buf;
 188:	00001797          	auipc	a5,0x1
 18c:	e8878793          	addi	a5,a5,-376 # 1010 <buf>
 190:	40f907b3          	sub	a5,s2,a5
 194:	40fa063b          	subw	a2,s4,a5
 198:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 19a:	85ca                	mv	a1,s2
 19c:	00001517          	auipc	a0,0x1
 1a0:	e7450513          	addi	a0,a0,-396 # 1010 <buf>
 1a4:	290000ef          	jal	434 <memmove>
 1a8:	bf75                	j	164 <grep+0x6c>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7179                	addi	sp,sp,-48
 1c8:	f406                	sd	ra,40(sp)
 1ca:	f022                	sd	s0,32(sp)
 1cc:	ec26                	sd	s1,24(sp)
 1ce:	e84a                	sd	s2,16(sp)
 1d0:	e44e                	sd	s3,8(sp)
 1d2:	e052                	sd	s4,0(sp)
 1d4:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1d6:	4785                	li	a5,1
 1d8:	04a7d663          	bge	a5,a0,224 <main+0x5e>
  pattern = argv[1];
 1dc:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e0:	4789                	li	a5,2
 1e2:	04a7db63          	bge	a5,a0,238 <main+0x72>
 1e6:	01058913          	addi	s2,a1,16
 1ea:	ffd5099b          	addiw	s3,a0,-3
 1ee:	02099793          	slli	a5,s3,0x20
 1f2:	01d7d993          	srli	s3,a5,0x1d
 1f6:	05e1                	addi	a1,a1,24
 1f8:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1fa:	4581                	li	a1,0
 1fc:	00093503          	ld	a0,0(s2)
 200:	378000ef          	jal	578 <open>
 204:	84aa                	mv	s1,a0
 206:	04054063          	bltz	a0,246 <main+0x80>
    grep(pattern, fd);
 20a:	85aa                	mv	a1,a0
 20c:	8552                	mv	a0,s4
 20e:	eebff0ef          	jal	f8 <grep>
    close(fd);
 212:	8526                	mv	a0,s1
 214:	34c000ef          	jal	560 <close>
  for(i = 2; i < argc; i++){
 218:	0921                	addi	s2,s2,8
 21a:	ff3910e3          	bne	s2,s3,1fa <main+0x34>
  exit(0);
 21e:	4501                	li	a0,0
 220:	318000ef          	jal	538 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 224:	00001597          	auipc	a1,0x1
 228:	98c58593          	addi	a1,a1,-1652 # bb0 <thread_join+0x32>
 22c:	4509                	li	a0,2
 22e:	726000ef          	jal	954 <fprintf>
    exit(1);
 232:	4505                	li	a0,1
 234:	304000ef          	jal	538 <exit>
    grep(pattern, 0);
 238:	4581                	li	a1,0
 23a:	8552                	mv	a0,s4
 23c:	ebdff0ef          	jal	f8 <grep>
    exit(0);
 240:	4501                	li	a0,0
 242:	2f6000ef          	jal	538 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 246:	00093583          	ld	a1,0(s2)
 24a:	00001517          	auipc	a0,0x1
 24e:	98650513          	addi	a0,a0,-1658 # bd0 <thread_join+0x52>
 252:	72c000ef          	jal	97e <printf>
      exit(1);
 256:	4505                	li	a0,1
 258:	2e0000ef          	jal	538 <exit>

000000000000025c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 264:	f63ff0ef          	jal	1c6 <main>
  exit(r);
 268:	2d0000ef          	jal	538 <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 274:	87aa                	mv	a5,a0
 276:	0585                	addi	a1,a1,1
 278:	0785                	addi	a5,a5,1
 27a:	fff5c703          	lbu	a4,-1(a1)
 27e:	fee78fa3          	sb	a4,-1(a5)
 282:	fb75                	bnez	a4,276 <strcpy+0xa>
    ;
  return os;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb91                	beqz	a5,2ac <strcmp+0x20>
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00f71763          	bne	a4,a5,2ac <strcmp+0x20>
    p++, q++;
 2a2:	0505                	addi	a0,a0,1
 2a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	fbe5                	bnez	a5,29a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2ac:	0005c503          	lbu	a0,0(a1)
}
 2b0:	40a7853b          	subw	a0,a5,a0
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strlen>:

uint
strlen(const char *s)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x28>
 2ca:	00150793          	addi	a5,a0,1
 2ce:	86be                	mv	a3,a5
 2d0:	0785                	addi	a5,a5,1
 2d2:	fff7c703          	lbu	a4,-1(a5)
 2d6:	ff65                	bnez	a4,2ce <strlen+0x12>
 2d8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for(n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <strlen+0x20>

00000000000002e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f0:	ca19                	beqz	a2,306 <memset+0x1e>
 2f2:	87aa                	mv	a5,a0
 2f4:	1602                	slli	a2,a2,0x20
 2f6:	9201                	srli	a2,a2,0x20
 2f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 300:	0785                	addi	a5,a5,1
 302:	fee79de3          	bne	a5,a4,2fc <memset+0x14>
  }
  return dst;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf81                	beqz	a5,332 <strchr+0x24>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1c>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xe>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <strchr+0x1c>

0000000000000336 <gets>:

char*
gets(char *buf, int max)
{
 336:	711d                	addi	sp,sp,-96
 338:	ec86                	sd	ra,88(sp)
 33a:	e8a2                	sd	s0,80(sp)
 33c:	e4a6                	sd	s1,72(sp)
 33e:	e0ca                	sd	s2,64(sp)
 340:	fc4e                	sd	s3,56(sp)
 342:	f852                	sd	s4,48(sp)
 344:	f456                	sd	s5,40(sp)
 346:	f05a                	sd	s6,32(sp)
 348:	ec5e                	sd	s7,24(sp)
 34a:	e862                	sd	s8,16(sp)
 34c:	1080                	addi	s0,sp,96
 34e:	8baa                	mv	s7,a0
 350:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 352:	892a                	mv	s2,a0
 354:	4481                	li	s1,0
    cc = read(0, &c, 1);
 356:	faf40b13          	addi	s6,s0,-81
 35a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 35c:	8c26                	mv	s8,s1
 35e:	0014899b          	addiw	s3,s1,1
 362:	84ce                	mv	s1,s3
 364:	0349d463          	bge	s3,s4,38c <gets+0x56>
    cc = read(0, &c, 1);
 368:	8656                	mv	a2,s5
 36a:	85da                	mv	a1,s6
 36c:	4501                	li	a0,0
 36e:	1e2000ef          	jal	550 <read>
    if(cc < 1)
 372:	00a05d63          	blez	a0,38c <gets+0x56>
      break;
    buf[i++] = c;
 376:	faf44783          	lbu	a5,-81(s0)
 37a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37e:	0905                	addi	s2,s2,1
 380:	ff678713          	addi	a4,a5,-10
 384:	c319                	beqz	a4,38a <gets+0x54>
 386:	17cd                	addi	a5,a5,-13
 388:	fbf1                	bnez	a5,35c <gets+0x26>
    buf[i++] = c;
 38a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38c:	9c5e                	add	s8,s8,s7
 38e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 392:	855e                	mv	a0,s7
 394:	60e6                	ld	ra,88(sp)
 396:	6446                	ld	s0,80(sp)
 398:	64a6                	ld	s1,72(sp)
 39a:	6906                	ld	s2,64(sp)
 39c:	79e2                	ld	s3,56(sp)
 39e:	7a42                	ld	s4,48(sp)
 3a0:	7aa2                	ld	s5,40(sp)
 3a2:	7b02                	ld	s6,32(sp)
 3a4:	6be2                	ld	s7,24(sp)
 3a6:	6c42                	ld	s8,16(sp)
 3a8:	6125                	addi	sp,sp,96
 3aa:	8082                	ret

00000000000003ac <stat>:

int
stat(const char *n, struct stat *st)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	e04a                	sd	s2,0(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b8:	4581                	li	a1,0
 3ba:	1be000ef          	jal	578 <open>
  if(fd < 0)
 3be:	02054263          	bltz	a0,3e2 <stat+0x36>
 3c2:	e426                	sd	s1,8(sp)
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	1c8000ef          	jal	590 <fstat>
 3cc:	892a                	mv	s2,a0
  close(fd);
 3ce:	8526                	mv	a0,s1
 3d0:	190000ef          	jal	560 <close>
  return r;
 3d4:	64a2                	ld	s1,8(sp)
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6902                	ld	s2,0(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret
    return -1;
 3e2:	57fd                	li	a5,-1
 3e4:	893e                	mv	s2,a5
 3e6:	bfc5                	j	3d6 <stat+0x2a>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f0:	00054683          	lbu	a3,0(a0)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	4625                	li	a2,9
 3fe:	02f66963          	bltu	a2,a5,430 <atoi+0x48>
 402:	872a                	mv	a4,a0
  n = 0;
 404:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 406:	0705                	addi	a4,a4,1
 408:	0025179b          	slliw	a5,a0,0x2
 40c:	9fa9                	addw	a5,a5,a0
 40e:	0017979b          	slliw	a5,a5,0x1
 412:	9fb5                	addw	a5,a5,a3
 414:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 418:	00074683          	lbu	a3,0(a4)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	fef671e3          	bgeu	a2,a5,406 <atoi+0x1e>
  return n;
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
  n = 0;
 430:	4501                	li	a0,0
 432:	bfdd                	j	428 <atoi+0x40>

0000000000000434 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43c:	02b57563          	bgeu	a0,a1,466 <memmove+0x32>
    while(n-- > 0)
 440:	00c05f63          	blez	a2,45e <memmove+0x2a>
 444:	1602                	slli	a2,a2,0x20
 446:	9201                	srli	a2,a2,0x20
 448:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44c:	872a                	mv	a4,a0
      *dst++ = *src++;
 44e:	0585                	addi	a1,a1,1
 450:	0705                	addi	a4,a4,1
 452:	fff5c683          	lbu	a3,-1(a1)
 456:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
    while(n-- > 0)
 466:	fec05ce3          	blez	a2,45e <memmove+0x2a>
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
 470:	fff6079b          	addiw	a5,a2,-1
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	fff7c793          	not	a5,a5
 47c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47e:	15fd                	addi	a1,a1,-1
 480:	177d                	addi	a4,a4,-1
 482:	0005c683          	lbu	a3,0(a1)
 486:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48a:	fef71ae3          	bne	a4,a5,47e <memmove+0x4a>
 48e:	bfc1                	j	45e <memmove+0x2a>

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	c61d                	beqz	a2,4c6 <memcmp+0x36>
 49a:	1602                	slli	a2,a2,0x20
 49c:	9201                	srli	a2,a2,0x20
 49e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	0005c703          	lbu	a4,0(a1)
 4aa:	00e79863          	bne	a5,a4,4ba <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4ae:	0505                	addi	a0,a0,1
    p2++;
 4b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b2:	fed518e3          	bne	a0,a3,4a2 <memcmp+0x12>
  }
  return 0;
 4b6:	4501                	li	a0,0
 4b8:	a019                	j	4be <memcmp+0x2e>
      return *p1 - *p2;
 4ba:	40e7853b          	subw	a0,a5,a4
}
 4be:	60a2                	ld	ra,8(sp)
 4c0:	6402                	ld	s0,0(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
  return 0;
 4c6:	4501                	li	a0,0
 4c8:	bfdd                	j	4be <memcmp+0x2e>

00000000000004ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e406                	sd	ra,8(sp)
 4ce:	e022                	sd	s0,0(sp)
 4d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d2:	f63ff0ef          	jal	434 <memmove>
}
 4d6:	60a2                	ld	ra,8(sp)
 4d8:	6402                	ld	s0,0(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret

00000000000004de <sbrk>:

char *
sbrk(int n) {
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e6:	4585                	li	a1,1
 4e8:	0d8000ef          	jal	5c0 <sys_sbrk>
}
 4ec:	60a2                	ld	ra,8(sp)
 4ee:	6402                	ld	s0,0(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <sbrklazy>:

char *
sbrklazy(int n) {
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e406                	sd	ra,8(sp)
 4f8:	e022                	sd	s0,0(sp)
 4fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4fc:	4589                	li	a1,2
 4fe:	0c2000ef          	jal	5c0 <sys_sbrk>
}
 502:	60a2                	ld	ra,8(sp)
 504:	6402                	ld	s0,0(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <fork>:

int
fork(void)
{
 50a:	1141                	addi	sp,sp,-16
 50c:	e406                	sd	ra,8(sp)
 50e:	e022                	sd	s0,0(sp)
 510:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 512:	4701                	li	a4,0
 514:	4681                	li	a3,0
 516:	4601                	li	a2,0
 518:	4581                	li	a1,0
 51a:	4501                	li	a0,0
 51c:	00c000ef          	jal	528 <clone>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret

0000000000000528 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 528:	4885                	li	a7,1
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <join>:
.global join
join:
 li a7, SYS_join
 530:	48d9                	li	a7,22
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <exit>:
.global exit
exit:
 li a7, SYS_exit
 538:	4889                	li	a7,2
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <wait>:
.global wait
wait:
 li a7, SYS_wait
 540:	488d                	li	a7,3
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 548:	4891                	li	a7,4
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <read>:
.global read
read:
 li a7, SYS_read
 550:	4895                	li	a7,5
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <write>:
.global write
write:
 li a7, SYS_write
 558:	48c1                	li	a7,16
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <close>:
.global close
close:
 li a7, SYS_close
 560:	48d5                	li	a7,21
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <kill>:
.global kill
kill:
 li a7, SYS_kill
 568:	4899                	li	a7,6
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <exec>:
.global exec
exec:
 li a7, SYS_exec
 570:	489d                	li	a7,7
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <open>:
.global open
open:
 li a7, SYS_open
 578:	48bd                	li	a7,15
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 580:	48c5                	li	a7,17
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 588:	48c9                	li	a7,18
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 590:	48a1                	li	a7,8
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <link>:
.global link
link:
 li a7, SYS_link
 598:	48cd                	li	a7,19
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a0:	48d1                	li	a7,20
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a8:	48a5                	li	a7,9
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b0:	48a9                	li	a7,10
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b8:	48ad                	li	a7,11
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5c0:	48b1                	li	a7,12
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5c8:	48b5                	li	a7,13
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d0:	48b9                	li	a7,14
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d8:	1101                	addi	sp,sp,-32
 5da:	ec06                	sd	ra,24(sp)
 5dc:	e822                	sd	s0,16(sp)
 5de:	1000                	addi	s0,sp,32
 5e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e4:	4605                	li	a2,1
 5e6:	fef40593          	addi	a1,s0,-17
 5ea:	f6fff0ef          	jal	558 <write>
}
 5ee:	60e2                	ld	ra,24(sp)
 5f0:	6442                	ld	s0,16(sp)
 5f2:	6105                	addi	sp,sp,32
 5f4:	8082                	ret

00000000000005f6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5f6:	715d                	addi	sp,sp,-80
 5f8:	e486                	sd	ra,72(sp)
 5fa:	e0a2                	sd	s0,64(sp)
 5fc:	f84a                	sd	s2,48(sp)
 5fe:	f44e                	sd	s3,40(sp)
 600:	0880                	addi	s0,sp,80
 602:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 604:	c6d1                	beqz	a3,690 <printint+0x9a>
 606:	0805d563          	bgez	a1,690 <printint+0x9a>
    neg = 1;
    x = -xx;
 60a:	40b005b3          	neg	a1,a1
    neg = 1;
 60e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 610:	fb840993          	addi	s3,s0,-72
  neg = 0;
 614:	86ce                	mv	a3,s3
  i = 0;
 616:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 618:	00000817          	auipc	a6,0x0
 61c:	5d880813          	addi	a6,a6,1496 # bf0 <digits>
 620:	88ba                	mv	a7,a4
 622:	0017051b          	addiw	a0,a4,1
 626:	872a                	mv	a4,a0
 628:	02c5f7b3          	remu	a5,a1,a2
 62c:	97c2                	add	a5,a5,a6
 62e:	0007c783          	lbu	a5,0(a5)
 632:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 636:	87ae                	mv	a5,a1
 638:	02c5d5b3          	divu	a1,a1,a2
 63c:	0685                	addi	a3,a3,1
 63e:	fec7f1e3          	bgeu	a5,a2,620 <printint+0x2a>
  if(neg)
 642:	00030c63          	beqz	t1,65a <printint+0x64>
    buf[i++] = '-';
 646:	fd050793          	addi	a5,a0,-48
 64a:	00878533          	add	a0,a5,s0
 64e:	02d00793          	li	a5,45
 652:	fef50423          	sb	a5,-24(a0)
 656:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 65a:	02e05563          	blez	a4,684 <printint+0x8e>
 65e:	fc26                	sd	s1,56(sp)
 660:	377d                	addiw	a4,a4,-1
 662:	00e984b3          	add	s1,s3,a4
 666:	19fd                	addi	s3,s3,-1
 668:	99ba                	add	s3,s3,a4
 66a:	1702                	slli	a4,a4,0x20
 66c:	9301                	srli	a4,a4,0x20
 66e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 672:	0004c583          	lbu	a1,0(s1)
 676:	854a                	mv	a0,s2
 678:	f61ff0ef          	jal	5d8 <putc>
  while(--i >= 0)
 67c:	14fd                	addi	s1,s1,-1
 67e:	ff349ae3          	bne	s1,s3,672 <printint+0x7c>
 682:	74e2                	ld	s1,56(sp)
}
 684:	60a6                	ld	ra,72(sp)
 686:	6406                	ld	s0,64(sp)
 688:	7942                	ld	s2,48(sp)
 68a:	79a2                	ld	s3,40(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret
  neg = 0;
 690:	4301                	li	t1,0
 692:	bfbd                	j	610 <printint+0x1a>

0000000000000694 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec86                	sd	ra,88(sp)
 698:	e8a2                	sd	s0,80(sp)
 69a:	e4a6                	sd	s1,72(sp)
 69c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69e:	0005c483          	lbu	s1,0(a1)
 6a2:	22048363          	beqz	s1,8c8 <vprintf+0x234>
 6a6:	e0ca                	sd	s2,64(sp)
 6a8:	fc4e                	sd	s3,56(sp)
 6aa:	f852                	sd	s4,48(sp)
 6ac:	f456                	sd	s5,40(sp)
 6ae:	f05a                	sd	s6,32(sp)
 6b0:	ec5e                	sd	s7,24(sp)
 6b2:	e862                	sd	s8,16(sp)
 6b4:	8b2a                	mv	s6,a0
 6b6:	8a2e                	mv	s4,a1
 6b8:	8bb2                	mv	s7,a2
  state = 0;
 6ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6bc:	4901                	li	s2,0
 6be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c4:	06400c13          	li	s8,100
 6c8:	a00d                	j	6ea <vprintf+0x56>
        putc(fd, c0);
 6ca:	85a6                	mv	a1,s1
 6cc:	855a                	mv	a0,s6
 6ce:	f0bff0ef          	jal	5d8 <putc>
 6d2:	a019                	j	6d8 <vprintf+0x44>
    } else if(state == '%'){
 6d4:	03598363          	beq	s3,s5,6fa <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6d8:	0019079b          	addiw	a5,s2,1
 6dc:	893e                	mv	s2,a5
 6de:	873e                	mv	a4,a5
 6e0:	97d2                	add	a5,a5,s4
 6e2:	0007c483          	lbu	s1,0(a5)
 6e6:	1c048a63          	beqz	s1,8ba <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6ea:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6ee:	fe0993e3          	bnez	s3,6d4 <vprintf+0x40>
      if(c0 == '%'){
 6f2:	fd579ce3          	bne	a5,s5,6ca <vprintf+0x36>
        state = '%';
 6f6:	89be                	mv	s3,a5
 6f8:	b7c5                	j	6d8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6fa:	00ea06b3          	add	a3,s4,a4
 6fe:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 702:	1c060863          	beqz	a2,8d2 <vprintf+0x23e>
      if(c0 == 'd'){
 706:	03878763          	beq	a5,s8,734 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 70a:	f9478693          	addi	a3,a5,-108
 70e:	0016b693          	seqz	a3,a3
 712:	f9c60593          	addi	a1,a2,-100
 716:	e99d                	bnez	a1,74c <vprintf+0xb8>
 718:	ca95                	beqz	a3,74c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 71a:	008b8493          	addi	s1,s7,8
 71e:	4685                	li	a3,1
 720:	4629                	li	a2,10
 722:	000bb583          	ld	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	ecfff0ef          	jal	5f6 <printint>
        i += 1;
 72c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 72e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 730:	4981                	li	s3,0
 732:	b75d                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 734:	008b8493          	addi	s1,s7,8
 738:	4685                	li	a3,1
 73a:	4629                	li	a2,10
 73c:	000ba583          	lw	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	eb5ff0ef          	jal	5f6 <printint>
 746:	8ba6                	mv	s7,s1
      state = 0;
 748:	4981                	li	s3,0
 74a:	b779                	j	6d8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 74c:	9752                	add	a4,a4,s4
 74e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 752:	f9460713          	addi	a4,a2,-108
 756:	00173713          	seqz	a4,a4
 75a:	8f75                	and	a4,a4,a3
 75c:	f9c58513          	addi	a0,a1,-100
 760:	18051363          	bnez	a0,8e6 <vprintf+0x252>
 764:	18070163          	beqz	a4,8e6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 768:	008b8493          	addi	s1,s7,8
 76c:	4685                	li	a3,1
 76e:	4629                	li	a2,10
 770:	000bb583          	ld	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	e81ff0ef          	jal	5f6 <printint>
        i += 2;
 77a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	8ba6                	mv	s7,s1
      state = 0;
 77e:	4981                	li	s3,0
        i += 2;
 780:	bfa1                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 782:	008b8493          	addi	s1,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000be583          	lwu	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	e67ff0ef          	jal	5f6 <printint>
 794:	8ba6                	mv	s7,s1
      state = 0;
 796:	4981                	li	s3,0
 798:	b781                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	008b8493          	addi	s1,s7,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000bb583          	ld	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	e4fff0ef          	jal	5f6 <printint>
        i += 1;
 7ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ae:	8ba6                	mv	s7,s1
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b71d                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	008b8493          	addi	s1,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4629                	li	a2,10
 7bc:	000bb583          	ld	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	e35ff0ef          	jal	5f6 <printint>
        i += 2;
 7c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c8:	8ba6                	mv	s7,s1
      state = 0;
 7ca:	4981                	li	s3,0
        i += 2;
 7cc:	b731                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7ce:	008b8493          	addi	s1,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4641                	li	a2,16
 7d6:	000be583          	lwu	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	e1bff0ef          	jal	5f6 <printint>
 7e0:	8ba6                	mv	s7,s1
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bdd5                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	008b8493          	addi	s1,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000bb583          	ld	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	e03ff0ef          	jal	5f6 <printint>
        i += 1;
 7f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fa:	8ba6                	mv	s7,s1
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bde9                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 800:	008b8493          	addi	s1,s7,8
 804:	4681                	li	a3,0
 806:	4641                	li	a2,16
 808:	000bb583          	ld	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	de9ff0ef          	jal	5f6 <printint>
        i += 2;
 812:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 814:	8ba6                	mv	s7,s1
      state = 0;
 816:	4981                	li	s3,0
        i += 2;
 818:	b5c1                	j	6d8 <vprintf+0x44>
 81a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 81c:	008b8793          	addi	a5,s7,8
 820:	8cbe                	mv	s9,a5
 822:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 826:	03000593          	li	a1,48
 82a:	855a                	mv	a0,s6
 82c:	dadff0ef          	jal	5d8 <putc>
  putc(fd, 'x');
 830:	07800593          	li	a1,120
 834:	855a                	mv	a0,s6
 836:	da3ff0ef          	jal	5d8 <putc>
 83a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83c:	00000b97          	auipc	s7,0x0
 840:	3b4b8b93          	addi	s7,s7,948 # bf0 <digits>
 844:	03c9d793          	srli	a5,s3,0x3c
 848:	97de                	add	a5,a5,s7
 84a:	0007c583          	lbu	a1,0(a5)
 84e:	855a                	mv	a0,s6
 850:	d89ff0ef          	jal	5d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 854:	0992                	slli	s3,s3,0x4
 856:	34fd                	addiw	s1,s1,-1
 858:	f4f5                	bnez	s1,844 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 85a:	8be6                	mv	s7,s9
      state = 0;
 85c:	4981                	li	s3,0
 85e:	6ca2                	ld	s9,8(sp)
 860:	bda5                	j	6d8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 862:	008b8493          	addi	s1,s7,8
 866:	000bc583          	lbu	a1,0(s7)
 86a:	855a                	mv	a0,s6
 86c:	d6dff0ef          	jal	5d8 <putc>
 870:	8ba6                	mv	s7,s1
      state = 0;
 872:	4981                	li	s3,0
 874:	b595                	j	6d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 876:	008b8993          	addi	s3,s7,8
 87a:	000bb483          	ld	s1,0(s7)
 87e:	cc91                	beqz	s1,89a <vprintf+0x206>
        for(; *s; s++)
 880:	0004c583          	lbu	a1,0(s1)
 884:	c985                	beqz	a1,8b4 <vprintf+0x220>
          putc(fd, *s);
 886:	855a                	mv	a0,s6
 888:	d51ff0ef          	jal	5d8 <putc>
        for(; *s; s++)
 88c:	0485                	addi	s1,s1,1
 88e:	0004c583          	lbu	a1,0(s1)
 892:	f9f5                	bnez	a1,886 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 894:	8bce                	mv	s7,s3
      state = 0;
 896:	4981                	li	s3,0
 898:	b581                	j	6d8 <vprintf+0x44>
          s = "(null)";
 89a:	00000497          	auipc	s1,0x0
 89e:	34e48493          	addi	s1,s1,846 # be8 <thread_join+0x6a>
        for(; *s; s++)
 8a2:	02800593          	li	a1,40
 8a6:	b7c5                	j	886 <vprintf+0x1f2>
        putc(fd, '%');
 8a8:	85be                	mv	a1,a5
 8aa:	855a                	mv	a0,s6
 8ac:	d2dff0ef          	jal	5d8 <putc>
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b51d                	j	6d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8b4:	8bce                	mv	s7,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b505                	j	6d8 <vprintf+0x44>
 8ba:	6906                	ld	s2,64(sp)
 8bc:	79e2                	ld	s3,56(sp)
 8be:	7a42                	ld	s4,48(sp)
 8c0:	7aa2                	ld	s5,40(sp)
 8c2:	7b02                	ld	s6,32(sp)
 8c4:	6be2                	ld	s7,24(sp)
 8c6:	6c42                	ld	s8,16(sp)
    }
  }
}
 8c8:	60e6                	ld	ra,88(sp)
 8ca:	6446                	ld	s0,80(sp)
 8cc:	64a6                	ld	s1,72(sp)
 8ce:	6125                	addi	sp,sp,96
 8d0:	8082                	ret
      if(c0 == 'd'){
 8d2:	06400713          	li	a4,100
 8d6:	e4e78fe3          	beq	a5,a4,734 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8da:	f9478693          	addi	a3,a5,-108
 8de:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8e2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8e4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8e6:	07500513          	li	a0,117
 8ea:	e8a78ce3          	beq	a5,a0,782 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8ee:	f8b60513          	addi	a0,a2,-117
 8f2:	e119                	bnez	a0,8f8 <vprintf+0x264>
 8f4:	ea0693e3          	bnez	a3,79a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8f8:	f8b58513          	addi	a0,a1,-117
 8fc:	e119                	bnez	a0,902 <vprintf+0x26e>
 8fe:	ea071be3          	bnez	a4,7b4 <vprintf+0x120>
      } else if(c0 == 'x'){
 902:	07800513          	li	a0,120
 906:	eca784e3          	beq	a5,a0,7ce <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 90a:	f8860613          	addi	a2,a2,-120
 90e:	e219                	bnez	a2,914 <vprintf+0x280>
 910:	ec069be3          	bnez	a3,7e6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 914:	f8858593          	addi	a1,a1,-120
 918:	e199                	bnez	a1,91e <vprintf+0x28a>
 91a:	ee0713e3          	bnez	a4,800 <vprintf+0x16c>
      } else if(c0 == 'p'){
 91e:	07000713          	li	a4,112
 922:	eee78ce3          	beq	a5,a4,81a <vprintf+0x186>
      } else if(c0 == 'c'){
 926:	06300713          	li	a4,99
 92a:	f2e78ce3          	beq	a5,a4,862 <vprintf+0x1ce>
      } else if(c0 == 's'){
 92e:	07300713          	li	a4,115
 932:	f4e782e3          	beq	a5,a4,876 <vprintf+0x1e2>
      } else if(c0 == '%'){
 936:	02500713          	li	a4,37
 93a:	f6e787e3          	beq	a5,a4,8a8 <vprintf+0x214>
        putc(fd, '%');
 93e:	02500593          	li	a1,37
 942:	855a                	mv	a0,s6
 944:	c95ff0ef          	jal	5d8 <putc>
        putc(fd, c0);
 948:	85a6                	mv	a1,s1
 94a:	855a                	mv	a0,s6
 94c:	c8dff0ef          	jal	5d8 <putc>
      state = 0;
 950:	4981                	li	s3,0
 952:	b359                	j	6d8 <vprintf+0x44>

0000000000000954 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 954:	715d                	addi	sp,sp,-80
 956:	ec06                	sd	ra,24(sp)
 958:	e822                	sd	s0,16(sp)
 95a:	1000                	addi	s0,sp,32
 95c:	e010                	sd	a2,0(s0)
 95e:	e414                	sd	a3,8(s0)
 960:	e818                	sd	a4,16(s0)
 962:	ec1c                	sd	a5,24(s0)
 964:	03043023          	sd	a6,32(s0)
 968:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 96c:	8622                	mv	a2,s0
 96e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 972:	d23ff0ef          	jal	694 <vprintf>
}
 976:	60e2                	ld	ra,24(sp)
 978:	6442                	ld	s0,16(sp)
 97a:	6161                	addi	sp,sp,80
 97c:	8082                	ret

000000000000097e <printf>:

void
printf(const char *fmt, ...)
{
 97e:	711d                	addi	sp,sp,-96
 980:	ec06                	sd	ra,24(sp)
 982:	e822                	sd	s0,16(sp)
 984:	1000                	addi	s0,sp,32
 986:	e40c                	sd	a1,8(s0)
 988:	e810                	sd	a2,16(s0)
 98a:	ec14                	sd	a3,24(s0)
 98c:	f018                	sd	a4,32(s0)
 98e:	f41c                	sd	a5,40(s0)
 990:	03043823          	sd	a6,48(s0)
 994:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 998:	00840613          	addi	a2,s0,8
 99c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9a0:	85aa                	mv	a1,a0
 9a2:	4505                	li	a0,1
 9a4:	cf1ff0ef          	jal	694 <vprintf>
}
 9a8:	60e2                	ld	ra,24(sp)
 9aa:	6442                	ld	s0,16(sp)
 9ac:	6125                	addi	sp,sp,96
 9ae:	8082                	ret

00000000000009b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9b0:	1141                	addi	sp,sp,-16
 9b2:	e406                	sd	ra,8(sp)
 9b4:	e022                	sd	s0,0(sp)
 9b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9bc:	00000797          	auipc	a5,0x0
 9c0:	6447b783          	ld	a5,1604(a5) # 1000 <freep>
 9c4:	a039                	j	9d2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c6:	6398                	ld	a4,0(a5)
 9c8:	00e7e463          	bltu	a5,a4,9d0 <free+0x20>
 9cc:	00e6ea63          	bltu	a3,a4,9e0 <free+0x30>
{
 9d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d2:	fed7fae3          	bgeu	a5,a3,9c6 <free+0x16>
 9d6:	6398                	ld	a4,0(a5)
 9d8:	00e6e463          	bltu	a3,a4,9e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9dc:	fee7eae3          	bltu	a5,a4,9d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9e0:	ff852583          	lw	a1,-8(a0)
 9e4:	6390                	ld	a2,0(a5)
 9e6:	02059813          	slli	a6,a1,0x20
 9ea:	01c85713          	srli	a4,a6,0x1c
 9ee:	9736                	add	a4,a4,a3
 9f0:	02e60563          	beq	a2,a4,a1a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9f4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9f8:	4790                	lw	a2,8(a5)
 9fa:	02061593          	slli	a1,a2,0x20
 9fe:	01c5d713          	srli	a4,a1,0x1c
 a02:	973e                	add	a4,a4,a5
 a04:	02e68263          	beq	a3,a4,a28 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a08:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a0a:	00000717          	auipc	a4,0x0
 a0e:	5ef73b23          	sd	a5,1526(a4) # 1000 <freep>
}
 a12:	60a2                	ld	ra,8(sp)
 a14:	6402                	ld	s0,0(sp)
 a16:	0141                	addi	sp,sp,16
 a18:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a1a:	4618                	lw	a4,8(a2)
 a1c:	9f2d                	addw	a4,a4,a1
 a1e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a22:	6398                	ld	a4,0(a5)
 a24:	6310                	ld	a2,0(a4)
 a26:	b7f9                	j	9f4 <free+0x44>
    p->s.size += bp->s.size;
 a28:	ff852703          	lw	a4,-8(a0)
 a2c:	9f31                	addw	a4,a4,a2
 a2e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a30:	ff053683          	ld	a3,-16(a0)
 a34:	bfd1                	j	a08 <free+0x58>

0000000000000a36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a36:	7139                	addi	sp,sp,-64
 a38:	fc06                	sd	ra,56(sp)
 a3a:	f822                	sd	s0,48(sp)
 a3c:	f04a                	sd	s2,32(sp)
 a3e:	ec4e                	sd	s3,24(sp)
 a40:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a42:	02051993          	slli	s3,a0,0x20
 a46:	0209d993          	srli	s3,s3,0x20
 a4a:	09bd                	addi	s3,s3,15
 a4c:	0049d993          	srli	s3,s3,0x4
 a50:	2985                	addiw	s3,s3,1
 a52:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a54:	00000517          	auipc	a0,0x0
 a58:	5ac53503          	ld	a0,1452(a0) # 1000 <freep>
 a5c:	c905                	beqz	a0,a8c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a60:	4798                	lw	a4,8(a5)
 a62:	09377663          	bgeu	a4,s3,aee <malloc+0xb8>
 a66:	f426                	sd	s1,40(sp)
 a68:	e852                	sd	s4,16(sp)
 a6a:	e456                	sd	s5,8(sp)
 a6c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a6e:	8a4e                	mv	s4,s3
 a70:	6705                	lui	a4,0x1
 a72:	00e9f363          	bgeu	s3,a4,a78 <malloc+0x42>
 a76:	6a05                	lui	s4,0x1
 a78:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a7c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a80:	00000497          	auipc	s1,0x0
 a84:	58048493          	addi	s1,s1,1408 # 1000 <freep>
  if(p == SBRK_ERROR)
 a88:	5afd                	li	s5,-1
 a8a:	a83d                	j	ac8 <malloc+0x92>
 a8c:	f426                	sd	s1,40(sp)
 a8e:	e852                	sd	s4,16(sp)
 a90:	e456                	sd	s5,8(sp)
 a92:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a94:	00001797          	auipc	a5,0x1
 a98:	97c78793          	addi	a5,a5,-1668 # 1410 <base>
 a9c:	00000717          	auipc	a4,0x0
 aa0:	56f73223          	sd	a5,1380(a4) # 1000 <freep>
 aa4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aaa:	b7d1                	j	a6e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 aac:	6398                	ld	a4,0(a5)
 aae:	e118                	sd	a4,0(a0)
 ab0:	a899                	j	b06 <malloc+0xd0>
  hp->s.size = nu;
 ab2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ab6:	0541                	addi	a0,a0,16
 ab8:	ef9ff0ef          	jal	9b0 <free>
  return freep;
 abc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 abe:	c125                	beqz	a0,b1e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ac2:	4798                	lw	a4,8(a5)
 ac4:	03277163          	bgeu	a4,s2,ae6 <malloc+0xb0>
    if(p == freep)
 ac8:	6098                	ld	a4,0(s1)
 aca:	853e                	mv	a0,a5
 acc:	fef71ae3          	bne	a4,a5,ac0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ad0:	8552                	mv	a0,s4
 ad2:	a0dff0ef          	jal	4de <sbrk>
  if(p == SBRK_ERROR)
 ad6:	fd551ee3          	bne	a0,s5,ab2 <malloc+0x7c>
        return 0;
 ada:	4501                	li	a0,0
 adc:	74a2                	ld	s1,40(sp)
 ade:	6a42                	ld	s4,16(sp)
 ae0:	6aa2                	ld	s5,8(sp)
 ae2:	6b02                	ld	s6,0(sp)
 ae4:	a03d                	j	b12 <malloc+0xdc>
 ae6:	74a2                	ld	s1,40(sp)
 ae8:	6a42                	ld	s4,16(sp)
 aea:	6aa2                	ld	s5,8(sp)
 aec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aee:	fae90fe3          	beq	s2,a4,aac <malloc+0x76>
        p->s.size -= nunits;
 af2:	4137073b          	subw	a4,a4,s3
 af6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af8:	02071693          	slli	a3,a4,0x20
 afc:	01c6d713          	srli	a4,a3,0x1c
 b00:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b02:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b06:	00000717          	auipc	a4,0x0
 b0a:	4ea73d23          	sd	a0,1274(a4) # 1000 <freep>
      return (void*)(p + 1);
 b0e:	01078513          	addi	a0,a5,16
  }
}
 b12:	70e2                	ld	ra,56(sp)
 b14:	7442                	ld	s0,48(sp)
 b16:	7902                	ld	s2,32(sp)
 b18:	69e2                	ld	s3,24(sp)
 b1a:	6121                	addi	sp,sp,64
 b1c:	8082                	ret
 b1e:	74a2                	ld	s1,40(sp)
 b20:	6a42                	ld	s4,16(sp)
 b22:	6aa2                	ld	s5,8(sp)
 b24:	6b02                	ld	s6,0(sp)
 b26:	b7f5                	j	b12 <malloc+0xdc>

0000000000000b28 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 b28:	7179                	addi	sp,sp,-48
 b2a:	f406                	sd	ra,40(sp)
 b2c:	f022                	sd	s0,32(sp)
 b2e:	ec26                	sd	s1,24(sp)
 b30:	e84a                	sd	s2,16(sp)
 b32:	e44e                	sd	s3,8(sp)
 b34:	1800                	addi	s0,sp,48
 b36:	89aa                	mv	s3,a0
 b38:	892e                	mv	s2,a1
 b3a:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 b3c:	00c6151b          	slliw	a0,a2,0xc
 b40:	ef7ff0ef          	jal	a36 <malloc>
  if(stack == 0) return -1;
 b44:	c91d                	beqz	a0,b7a <thread_create+0x52>
 b46:	e052                	sd	s4,0(sp)
 b48:	862a                	mv	a2,a0
 b4a:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 b4c:	10000713          	li	a4,256
 b50:	86a6                	mv	a3,s1
 b52:	85ca                	mv	a1,s2
 b54:	854e                	mv	a0,s3
 b56:	9d3ff0ef          	jal	528 <clone>

  if(pid < 0) {
 b5a:	00054a63          	bltz	a0,b6e <thread_create+0x46>
 b5e:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 b60:	70a2                	ld	ra,40(sp)
 b62:	7402                	ld	s0,32(sp)
 b64:	64e2                	ld	s1,24(sp)
 b66:	6942                	ld	s2,16(sp)
 b68:	69a2                	ld	s3,8(sp)
 b6a:	6145                	addi	sp,sp,48
 b6c:	8082                	ret
    free(stack);
 b6e:	8552                	mv	a0,s4
 b70:	e41ff0ef          	jal	9b0 <free>
    return -1;
 b74:	557d                	li	a0,-1
 b76:	6a02                	ld	s4,0(sp)
 b78:	b7e5                	j	b60 <thread_create+0x38>
  if(stack == 0) return -1;
 b7a:	557d                	li	a0,-1
 b7c:	b7d5                	j	b60 <thread_create+0x38>

0000000000000b7e <thread_join>:

int
thread_join(void)
{
 b7e:	7179                	addi	sp,sp,-48
 b80:	f406                	sd	ra,40(sp)
 b82:	f022                	sd	s0,32(sp)
 b84:	ec26                	sd	s1,24(sp)
 b86:	1800                	addi	s0,sp,48
  void *stack = 0;
 b88:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 b8c:	fd840513          	addi	a0,s0,-40
 b90:	9a1ff0ef          	jal	530 <join>
 b94:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 b96:	00a05763          	blez	a0,ba4 <thread_join+0x26>
 b9a:	fd843503          	ld	a0,-40(s0)
 b9e:	c119                	beqz	a0,ba4 <thread_join+0x26>
    free(stack);
 ba0:	e11ff0ef          	jal	9b0 <free>
  }
  return pid;
}
 ba4:	8526                	mv	a0,s1
 ba6:	70a2                	ld	ra,40(sp)
 ba8:	7402                	ld	s0,32(sp)
 baa:	64e2                	ld	s1,24(sp)
 bac:	6145                	addi	sp,sp,48
 bae:	8082                	ret
