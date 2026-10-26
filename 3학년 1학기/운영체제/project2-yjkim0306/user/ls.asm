
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2ac000ef          	jal	2b8 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	284000ef          	jal	2b8 <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[sizeof(buf)-1] = '\0';
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	60e2                	ld	ra,24(sp)
  42:	6442                	ld	s0,16(sp)
  44:	64a2                	ld	s1,8(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret
  4a:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  4c:	8526                	mv	a0,s1
  4e:	26a000ef          	jal	2b8 <strlen>
  52:	862a                	mv	a2,a0
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	fba50513          	addi	a0,a0,-70 # 1010 <buf.0>
  5e:	3d2000ef          	jal	430 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  62:	8526                	mv	a0,s1
  64:	254000ef          	jal	2b8 <strlen>
  68:	892a                	mv	s2,a0
  6a:	8526                	mv	a0,s1
  6c:	24c000ef          	jal	2b8 <strlen>
  70:	02091793          	slli	a5,s2,0x20
  74:	9381                	srli	a5,a5,0x20
  76:	4639                	li	a2,14
  78:	9e09                	subw	a2,a2,a0
  7a:	02000593          	li	a1,32
  7e:	00001717          	auipc	a4,0x1
  82:	f9270713          	addi	a4,a4,-110 # 1010 <buf.0>
  86:	84ba                	mv	s1,a4
  88:	00f70533          	add	a0,a4,a5
  8c:	258000ef          	jal	2e4 <memset>
  buf[sizeof(buf)-1] = '\0';
  90:	00048723          	sb	zero,14(s1)
  return buf;
  94:	6902                	ld	s2,0(sp)
  96:	b765                	j	3e <fmtname+0x3e>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	da010113          	addi	sp,sp,-608
  9c:	24113c23          	sd	ra,600(sp)
  a0:	24813823          	sd	s0,592(sp)
  a4:	25213023          	sd	s2,576(sp)
  a8:	1480                	addi	s0,sp,608
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	4c6000ef          	jal	574 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913423          	sd	s1,584(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	da840593          	addi	a1,s0,-600
  c0:	4cc000ef          	jal	58c <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	db041783          	lh	a5,-592(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	db842703          	lw	a4,-584(s0)
  e8:	dac42683          	lw	a3,-596(s0)
  ec:	db041603          	lh	a2,-592(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	af050513          	addi	a0,a0,-1296 # be0 <thread_join+0x66>
  f8:	083000ef          	jal	97a <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	45e000ef          	jal	55c <close>
 102:	24813483          	ld	s1,584(sp)
}
 106:	25813083          	ld	ra,600(sp)
 10a:	25013403          	ld	s0,592(sp)
 10e:	24013903          	ld	s2,576(sp)
 112:	26010113          	addi	sp,sp,608
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	a9658593          	addi	a1,a1,-1386 # bb0 <thread_join+0x36>
 122:	4509                	li	a0,2
 124:	02d000ef          	jal	950 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	a9c58593          	addi	a1,a1,-1380 # bc8 <thread_join+0x4e>
 134:	4509                	li	a0,2
 136:	01b000ef          	jal	950 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	420000ef          	jal	55c <close>
    return;
 140:	24813483          	ld	s1,584(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	170000ef          	jal	2b8 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a9a50513          	addi	a0,a0,-1382 # bf0 <thread_join+0x76>
 15e:	01d000ef          	jal	97a <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 168:	85ca                	mv	a1,s2
 16a:	dd040513          	addi	a0,s0,-560
 16e:	0fa000ef          	jal	268 <strcpy>
    p = buf+strlen(buf);
 172:	dd040513          	addi	a0,s0,-560
 176:	142000ef          	jal	2b8 <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	dd040793          	addi	a5,s0,-560
 182:	00a78733          	add	a4,a5,a0
 186:	893a                	mv	s2,a4
    *p++ = '/';
 188:	00170793          	addi	a5,a4,1
 18c:	89be                	mv	s3,a5
 18e:	02f00793          	li	a5,47
 192:	00f70023          	sb	a5,0(a4)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 196:	a809                	j	1a8 <ls+0x110>
        printf("ls: cannot stat %s\n", buf);
 198:	dd040593          	addi	a1,s0,-560
 19c:	00001517          	auipc	a0,0x1
 1a0:	a2c50513          	addi	a0,a0,-1492 # bc8 <thread_join+0x4e>
 1a4:	7d6000ef          	jal	97a <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a8:	4641                	li	a2,16
 1aa:	dc040593          	addi	a1,s0,-576
 1ae:	8526                	mv	a0,s1
 1b0:	39c000ef          	jal	54c <read>
 1b4:	47c1                	li	a5,16
 1b6:	04f51763          	bne	a0,a5,204 <ls+0x16c>
      if(de.inum == 0)
 1ba:	dc045783          	lhu	a5,-576(s0)
 1be:	d7ed                	beqz	a5,1a8 <ls+0x110>
      memmove(p, de.name, DIRSIZ);
 1c0:	4639                	li	a2,14
 1c2:	dc240593          	addi	a1,s0,-574
 1c6:	854e                	mv	a0,s3
 1c8:	268000ef          	jal	430 <memmove>
      p[DIRSIZ] = 0;
 1cc:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1d0:	da840593          	addi	a1,s0,-600
 1d4:	dd040513          	addi	a0,s0,-560
 1d8:	1d0000ef          	jal	3a8 <stat>
 1dc:	fa054ee3          	bltz	a0,198 <ls+0x100>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1e0:	dd040513          	addi	a0,s0,-560
 1e4:	e1dff0ef          	jal	0 <fmtname>
 1e8:	85aa                	mv	a1,a0
 1ea:	db842703          	lw	a4,-584(s0)
 1ee:	dac42683          	lw	a3,-596(s0)
 1f2:	db041603          	lh	a2,-592(s0)
 1f6:	00001517          	auipc	a0,0x1
 1fa:	9ea50513          	addi	a0,a0,-1558 # be0 <thread_join+0x66>
 1fe:	77c000ef          	jal	97a <printf>
 202:	b75d                	j	1a8 <ls+0x110>
 204:	23813983          	ld	s3,568(sp)
 208:	bdd5                	j	fc <ls+0x64>

000000000000020a <main>:

int
main(int argc, char *argv[])
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 212:	4785                	li	a5,1
 214:	02a7d763          	bge	a5,a0,242 <main+0x38>
 218:	e426                	sd	s1,8(sp)
 21a:	e04a                	sd	s2,0(sp)
 21c:	00858493          	addi	s1,a1,8
 220:	ffe5091b          	addiw	s2,a0,-2
 224:	02091793          	slli	a5,s2,0x20
 228:	01d7d913          	srli	s2,a5,0x1d
 22c:	05c1                	addi	a1,a1,16
 22e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 230:	6088                	ld	a0,0(s1)
 232:	e67ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 236:	04a1                	addi	s1,s1,8
 238:	ff249ce3          	bne	s1,s2,230 <main+0x26>
  exit(0);
 23c:	4501                	li	a0,0
 23e:	2f6000ef          	jal	534 <exit>
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
    ls(".");
 246:	00001517          	auipc	a0,0x1
 24a:	9c250513          	addi	a0,a0,-1598 # c08 <thread_join+0x8e>
 24e:	e4bff0ef          	jal	98 <ls>
    exit(0);
 252:	4501                	li	a0,0
 254:	2e0000ef          	jal	534 <exit>

0000000000000258 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 260:	fabff0ef          	jal	20a <main>
  exit(r);
 264:	2d0000ef          	jal	534 <exit>

0000000000000268 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	addi	a1,a1,1
 274:	0785                	addi	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0xa>
    ;
  return os;
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb91                	beqz	a5,2a8 <strcmp+0x20>
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00f71763          	bne	a4,a5,2a8 <strcmp+0x20>
    p++, q++;
 29e:	0505                	addi	a0,a0,1
 2a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbe5                	bnez	a5,296 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2a8:	0005c503          	lbu	a0,0(a1)
}
 2ac:	40a7853b          	subw	a0,a5,a0
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <strlen>:

uint
strlen(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cf91                	beqz	a5,2e0 <strlen+0x28>
 2c6:	00150793          	addi	a5,a0,1
 2ca:	86be                	mv	a3,a5
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff7c703          	lbu	a4,-1(a5)
 2d2:	ff65                	bnez	a4,2ca <strlen+0x12>
 2d4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  for(n = 0; s[n]; n++)
 2e0:	4501                	li	a0,0
 2e2:	bfdd                	j	2d8 <strlen+0x20>

00000000000002e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ec:	ca19                	beqz	a2,302 <memset+0x1e>
 2ee:	87aa                	mv	a5,a0
 2f0:	1602                	slli	a2,a2,0x20
 2f2:	9201                	srli	a2,a2,0x20
 2f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fc:	0785                	addi	a5,a5,1
 2fe:	fee79de3          	bne	a5,a4,2f8 <memset+0x14>
  }
  return dst;
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strchr>:

char*
strchr(const char *s, char c)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  for(; *s; s++)
 312:	00054783          	lbu	a5,0(a0)
 316:	cf81                	beqz	a5,32e <strchr+0x24>
    if(*s == c)
 318:	00f58763          	beq	a1,a5,326 <strchr+0x1c>
  for(; *s; s++)
 31c:	0505                	addi	a0,a0,1
 31e:	00054783          	lbu	a5,0(a0)
 322:	fbfd                	bnez	a5,318 <strchr+0xe>
      return (char*)s;
  return 0;
 324:	4501                	li	a0,0
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfdd                	j	326 <strchr+0x1c>

0000000000000332 <gets>:

char*
gets(char *buf, int max)
{
 332:	711d                	addi	sp,sp,-96
 334:	ec86                	sd	ra,88(sp)
 336:	e8a2                	sd	s0,80(sp)
 338:	e4a6                	sd	s1,72(sp)
 33a:	e0ca                	sd	s2,64(sp)
 33c:	fc4e                	sd	s3,56(sp)
 33e:	f852                	sd	s4,48(sp)
 340:	f456                	sd	s5,40(sp)
 342:	f05a                	sd	s6,32(sp)
 344:	ec5e                	sd	s7,24(sp)
 346:	e862                	sd	s8,16(sp)
 348:	1080                	addi	s0,sp,96
 34a:	8baa                	mv	s7,a0
 34c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34e:	892a                	mv	s2,a0
 350:	4481                	li	s1,0
    cc = read(0, &c, 1);
 352:	faf40b13          	addi	s6,s0,-81
 356:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 358:	8c26                	mv	s8,s1
 35a:	0014899b          	addiw	s3,s1,1
 35e:	84ce                	mv	s1,s3
 360:	0349d463          	bge	s3,s4,388 <gets+0x56>
    cc = read(0, &c, 1);
 364:	8656                	mv	a2,s5
 366:	85da                	mv	a1,s6
 368:	4501                	li	a0,0
 36a:	1e2000ef          	jal	54c <read>
    if(cc < 1)
 36e:	00a05d63          	blez	a0,388 <gets+0x56>
      break;
    buf[i++] = c;
 372:	faf44783          	lbu	a5,-81(s0)
 376:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37a:	0905                	addi	s2,s2,1
 37c:	ff678713          	addi	a4,a5,-10
 380:	c319                	beqz	a4,386 <gets+0x54>
 382:	17cd                	addi	a5,a5,-13
 384:	fbf1                	bnez	a5,358 <gets+0x26>
    buf[i++] = c;
 386:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 388:	9c5e                	add	s8,s8,s7
 38a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 38e:	855e                	mv	a0,s7
 390:	60e6                	ld	ra,88(sp)
 392:	6446                	ld	s0,80(sp)
 394:	64a6                	ld	s1,72(sp)
 396:	6906                	ld	s2,64(sp)
 398:	79e2                	ld	s3,56(sp)
 39a:	7a42                	ld	s4,48(sp)
 39c:	7aa2                	ld	s5,40(sp)
 39e:	7b02                	ld	s6,32(sp)
 3a0:	6be2                	ld	s7,24(sp)
 3a2:	6c42                	ld	s8,16(sp)
 3a4:	6125                	addi	sp,sp,96
 3a6:	8082                	ret

00000000000003a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	e04a                	sd	s2,0(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b4:	4581                	li	a1,0
 3b6:	1be000ef          	jal	574 <open>
  if(fd < 0)
 3ba:	02054263          	bltz	a0,3de <stat+0x36>
 3be:	e426                	sd	s1,8(sp)
 3c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c2:	85ca                	mv	a1,s2
 3c4:	1c8000ef          	jal	58c <fstat>
 3c8:	892a                	mv	s2,a0
  close(fd);
 3ca:	8526                	mv	a0,s1
 3cc:	190000ef          	jal	55c <close>
  return r;
 3d0:	64a2                	ld	s1,8(sp)
}
 3d2:	854a                	mv	a0,s2
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	6902                	ld	s2,0(sp)
 3da:	6105                	addi	sp,sp,32
 3dc:	8082                	ret
    return -1;
 3de:	57fd                	li	a5,-1
 3e0:	893e                	mv	s2,a5
 3e2:	bfc5                	j	3d2 <stat+0x2a>

00000000000003e4 <atoi>:

int
atoi(const char *s)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ec:	00054683          	lbu	a3,0(a0)
 3f0:	fd06879b          	addiw	a5,a3,-48
 3f4:	0ff7f793          	zext.b	a5,a5
 3f8:	4625                	li	a2,9
 3fa:	02f66963          	bltu	a2,a5,42c <atoi+0x48>
 3fe:	872a                	mv	a4,a0
  n = 0;
 400:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 402:	0705                	addi	a4,a4,1
 404:	0025179b          	slliw	a5,a0,0x2
 408:	9fa9                	addw	a5,a5,a0
 40a:	0017979b          	slliw	a5,a5,0x1
 40e:	9fb5                	addw	a5,a5,a3
 410:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 414:	00074683          	lbu	a3,0(a4)
 418:	fd06879b          	addiw	a5,a3,-48
 41c:	0ff7f793          	zext.b	a5,a5
 420:	fef671e3          	bgeu	a2,a5,402 <atoi+0x1e>
  return n;
}
 424:	60a2                	ld	ra,8(sp)
 426:	6402                	ld	s0,0(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret
  n = 0;
 42c:	4501                	li	a0,0
 42e:	bfdd                	j	424 <atoi+0x40>

0000000000000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	1141                	addi	sp,sp,-16
 432:	e406                	sd	ra,8(sp)
 434:	e022                	sd	s0,0(sp)
 436:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 438:	02b57563          	bgeu	a0,a1,462 <memmove+0x32>
    while(n-- > 0)
 43c:	00c05f63          	blez	a2,45a <memmove+0x2a>
 440:	1602                	slli	a2,a2,0x20
 442:	9201                	srli	a2,a2,0x20
 444:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 448:	872a                	mv	a4,a0
      *dst++ = *src++;
 44a:	0585                	addi	a1,a1,1
 44c:	0705                	addi	a4,a4,1
 44e:	fff5c683          	lbu	a3,-1(a1)
 452:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 456:	fee79ae3          	bne	a5,a4,44a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45a:	60a2                	ld	ra,8(sp)
 45c:	6402                	ld	s0,0(sp)
 45e:	0141                	addi	sp,sp,16
 460:	8082                	ret
    while(n-- > 0)
 462:	fec05ce3          	blez	a2,45a <memmove+0x2a>
    dst += n;
 466:	00c50733          	add	a4,a0,a2
    src += n;
 46a:	95b2                	add	a1,a1,a2
 46c:	fff6079b          	addiw	a5,a2,-1
 470:	1782                	slli	a5,a5,0x20
 472:	9381                	srli	a5,a5,0x20
 474:	fff7c793          	not	a5,a5
 478:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47a:	15fd                	addi	a1,a1,-1
 47c:	177d                	addi	a4,a4,-1
 47e:	0005c683          	lbu	a3,0(a1)
 482:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 486:	fef71ae3          	bne	a4,a5,47a <memmove+0x4a>
 48a:	bfc1                	j	45a <memmove+0x2a>

000000000000048c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e406                	sd	ra,8(sp)
 490:	e022                	sd	s0,0(sp)
 492:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 494:	c61d                	beqz	a2,4c2 <memcmp+0x36>
 496:	1602                	slli	a2,a2,0x20
 498:	9201                	srli	a2,a2,0x20
 49a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 49e:	00054783          	lbu	a5,0(a0)
 4a2:	0005c703          	lbu	a4,0(a1)
 4a6:	00e79863          	bne	a5,a4,4b6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4aa:	0505                	addi	a0,a0,1
    p2++;
 4ac:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ae:	fed518e3          	bne	a0,a3,49e <memcmp+0x12>
  }
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	a019                	j	4ba <memcmp+0x2e>
      return *p1 - *p2;
 4b6:	40e7853b          	subw	a0,a5,a4
}
 4ba:	60a2                	ld	ra,8(sp)
 4bc:	6402                	ld	s0,0(sp)
 4be:	0141                	addi	sp,sp,16
 4c0:	8082                	ret
  return 0;
 4c2:	4501                	li	a0,0
 4c4:	bfdd                	j	4ba <memcmp+0x2e>

00000000000004c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e406                	sd	ra,8(sp)
 4ca:	e022                	sd	s0,0(sp)
 4cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ce:	f63ff0ef          	jal	430 <memmove>
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret

00000000000004da <sbrk>:

char *
sbrk(int n) {
 4da:	1141                	addi	sp,sp,-16
 4dc:	e406                	sd	ra,8(sp)
 4de:	e022                	sd	s0,0(sp)
 4e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e2:	4585                	li	a1,1
 4e4:	0d8000ef          	jal	5bc <sys_sbrk>
}
 4e8:	60a2                	ld	ra,8(sp)
 4ea:	6402                	ld	s0,0(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <sbrklazy>:

char *
sbrklazy(int n) {
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e406                	sd	ra,8(sp)
 4f4:	e022                	sd	s0,0(sp)
 4f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4f8:	4589                	li	a1,2
 4fa:	0c2000ef          	jal	5bc <sys_sbrk>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <fork>:

int
fork(void)
{
 506:	1141                	addi	sp,sp,-16
 508:	e406                	sd	ra,8(sp)
 50a:	e022                	sd	s0,0(sp)
 50c:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 50e:	4701                	li	a4,0
 510:	4681                	li	a3,0
 512:	4601                	li	a2,0
 514:	4581                	li	a1,0
 516:	4501                	li	a0,0
 518:	00c000ef          	jal	524 <clone>
}
 51c:	60a2                	ld	ra,8(sp)
 51e:	6402                	ld	s0,0(sp)
 520:	0141                	addi	sp,sp,16
 522:	8082                	ret

0000000000000524 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 524:	4885                	li	a7,1
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <join>:
.global join
join:
 li a7, SYS_join
 52c:	48d9                	li	a7,22
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <exit>:
.global exit
exit:
 li a7, SYS_exit
 534:	4889                	li	a7,2
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <wait>:
.global wait
wait:
 li a7, SYS_wait
 53c:	488d                	li	a7,3
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 544:	4891                	li	a7,4
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <read>:
.global read
read:
 li a7, SYS_read
 54c:	4895                	li	a7,5
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <write>:
.global write
write:
 li a7, SYS_write
 554:	48c1                	li	a7,16
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <close>:
.global close
close:
 li a7, SYS_close
 55c:	48d5                	li	a7,21
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <kill>:
.global kill
kill:
 li a7, SYS_kill
 564:	4899                	li	a7,6
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exec>:
.global exec
exec:
 li a7, SYS_exec
 56c:	489d                	li	a7,7
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <open>:
.global open
open:
 li a7, SYS_open
 574:	48bd                	li	a7,15
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 57c:	48c5                	li	a7,17
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 584:	48c9                	li	a7,18
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 58c:	48a1                	li	a7,8
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <link>:
.global link
link:
 li a7, SYS_link
 594:	48cd                	li	a7,19
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 59c:	48d1                	li	a7,20
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5a4:	48a5                	li	a7,9
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ac:	48a9                	li	a7,10
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5b4:	48ad                	li	a7,11
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5bc:	48b1                	li	a7,12
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5c4:	48b5                	li	a7,13
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5cc:	48b9                	li	a7,14
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d4:	1101                	addi	sp,sp,-32
 5d6:	ec06                	sd	ra,24(sp)
 5d8:	e822                	sd	s0,16(sp)
 5da:	1000                	addi	s0,sp,32
 5dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e0:	4605                	li	a2,1
 5e2:	fef40593          	addi	a1,s0,-17
 5e6:	f6fff0ef          	jal	554 <write>
}
 5ea:	60e2                	ld	ra,24(sp)
 5ec:	6442                	ld	s0,16(sp)
 5ee:	6105                	addi	sp,sp,32
 5f0:	8082                	ret

00000000000005f2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5f2:	715d                	addi	sp,sp,-80
 5f4:	e486                	sd	ra,72(sp)
 5f6:	e0a2                	sd	s0,64(sp)
 5f8:	f84a                	sd	s2,48(sp)
 5fa:	f44e                	sd	s3,40(sp)
 5fc:	0880                	addi	s0,sp,80
 5fe:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 600:	c6d1                	beqz	a3,68c <printint+0x9a>
 602:	0805d563          	bgez	a1,68c <printint+0x9a>
    neg = 1;
    x = -xx;
 606:	40b005b3          	neg	a1,a1
    neg = 1;
 60a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 60c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 610:	86ce                	mv	a3,s3
  i = 0;
 612:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 614:	00000817          	auipc	a6,0x0
 618:	60480813          	addi	a6,a6,1540 # c18 <digits>
 61c:	88ba                	mv	a7,a4
 61e:	0017051b          	addiw	a0,a4,1
 622:	872a                	mv	a4,a0
 624:	02c5f7b3          	remu	a5,a1,a2
 628:	97c2                	add	a5,a5,a6
 62a:	0007c783          	lbu	a5,0(a5)
 62e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 632:	87ae                	mv	a5,a1
 634:	02c5d5b3          	divu	a1,a1,a2
 638:	0685                	addi	a3,a3,1
 63a:	fec7f1e3          	bgeu	a5,a2,61c <printint+0x2a>
  if(neg)
 63e:	00030c63          	beqz	t1,656 <printint+0x64>
    buf[i++] = '-';
 642:	fd050793          	addi	a5,a0,-48
 646:	00878533          	add	a0,a5,s0
 64a:	02d00793          	li	a5,45
 64e:	fef50423          	sb	a5,-24(a0)
 652:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 656:	02e05563          	blez	a4,680 <printint+0x8e>
 65a:	fc26                	sd	s1,56(sp)
 65c:	377d                	addiw	a4,a4,-1
 65e:	00e984b3          	add	s1,s3,a4
 662:	19fd                	addi	s3,s3,-1
 664:	99ba                	add	s3,s3,a4
 666:	1702                	slli	a4,a4,0x20
 668:	9301                	srli	a4,a4,0x20
 66a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 66e:	0004c583          	lbu	a1,0(s1)
 672:	854a                	mv	a0,s2
 674:	f61ff0ef          	jal	5d4 <putc>
  while(--i >= 0)
 678:	14fd                	addi	s1,s1,-1
 67a:	ff349ae3          	bne	s1,s3,66e <printint+0x7c>
 67e:	74e2                	ld	s1,56(sp)
}
 680:	60a6                	ld	ra,72(sp)
 682:	6406                	ld	s0,64(sp)
 684:	7942                	ld	s2,48(sp)
 686:	79a2                	ld	s3,40(sp)
 688:	6161                	addi	sp,sp,80
 68a:	8082                	ret
  neg = 0;
 68c:	4301                	li	t1,0
 68e:	bfbd                	j	60c <printint+0x1a>

0000000000000690 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 690:	711d                	addi	sp,sp,-96
 692:	ec86                	sd	ra,88(sp)
 694:	e8a2                	sd	s0,80(sp)
 696:	e4a6                	sd	s1,72(sp)
 698:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69a:	0005c483          	lbu	s1,0(a1)
 69e:	22048363          	beqz	s1,8c4 <vprintf+0x234>
 6a2:	e0ca                	sd	s2,64(sp)
 6a4:	fc4e                	sd	s3,56(sp)
 6a6:	f852                	sd	s4,48(sp)
 6a8:	f456                	sd	s5,40(sp)
 6aa:	f05a                	sd	s6,32(sp)
 6ac:	ec5e                	sd	s7,24(sp)
 6ae:	e862                	sd	s8,16(sp)
 6b0:	8b2a                	mv	s6,a0
 6b2:	8a2e                	mv	s4,a1
 6b4:	8bb2                	mv	s7,a2
  state = 0;
 6b6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6b8:	4901                	li	s2,0
 6ba:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c0:	06400c13          	li	s8,100
 6c4:	a00d                	j	6e6 <vprintf+0x56>
        putc(fd, c0);
 6c6:	85a6                	mv	a1,s1
 6c8:	855a                	mv	a0,s6
 6ca:	f0bff0ef          	jal	5d4 <putc>
 6ce:	a019                	j	6d4 <vprintf+0x44>
    } else if(state == '%'){
 6d0:	03598363          	beq	s3,s5,6f6 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6d4:	0019079b          	addiw	a5,s2,1
 6d8:	893e                	mv	s2,a5
 6da:	873e                	mv	a4,a5
 6dc:	97d2                	add	a5,a5,s4
 6de:	0007c483          	lbu	s1,0(a5)
 6e2:	1c048a63          	beqz	s1,8b6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6e6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6ea:	fe0993e3          	bnez	s3,6d0 <vprintf+0x40>
      if(c0 == '%'){
 6ee:	fd579ce3          	bne	a5,s5,6c6 <vprintf+0x36>
        state = '%';
 6f2:	89be                	mv	s3,a5
 6f4:	b7c5                	j	6d4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6f6:	00ea06b3          	add	a3,s4,a4
 6fa:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6fe:	1c060863          	beqz	a2,8ce <vprintf+0x23e>
      if(c0 == 'd'){
 702:	03878763          	beq	a5,s8,730 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 706:	f9478693          	addi	a3,a5,-108
 70a:	0016b693          	seqz	a3,a3
 70e:	f9c60593          	addi	a1,a2,-100
 712:	e99d                	bnez	a1,748 <vprintf+0xb8>
 714:	ca95                	beqz	a3,748 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 716:	008b8493          	addi	s1,s7,8
 71a:	4685                	li	a3,1
 71c:	4629                	li	a2,10
 71e:	000bb583          	ld	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	ecfff0ef          	jal	5f2 <printint>
        i += 1;
 728:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 72a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 72c:	4981                	li	s3,0
 72e:	b75d                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 730:	008b8493          	addi	s1,s7,8
 734:	4685                	li	a3,1
 736:	4629                	li	a2,10
 738:	000ba583          	lw	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	eb5ff0ef          	jal	5f2 <printint>
 742:	8ba6                	mv	s7,s1
      state = 0;
 744:	4981                	li	s3,0
 746:	b779                	j	6d4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 748:	9752                	add	a4,a4,s4
 74a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74e:	f9460713          	addi	a4,a2,-108
 752:	00173713          	seqz	a4,a4
 756:	8f75                	and	a4,a4,a3
 758:	f9c58513          	addi	a0,a1,-100
 75c:	18051363          	bnez	a0,8e2 <vprintf+0x252>
 760:	18070163          	beqz	a4,8e2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 764:	008b8493          	addi	s1,s7,8
 768:	4685                	li	a3,1
 76a:	4629                	li	a2,10
 76c:	000bb583          	ld	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	e81ff0ef          	jal	5f2 <printint>
        i += 2;
 776:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 778:	8ba6                	mv	s7,s1
      state = 0;
 77a:	4981                	li	s3,0
        i += 2;
 77c:	bfa1                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 77e:	008b8493          	addi	s1,s7,8
 782:	4681                	li	a3,0
 784:	4629                	li	a2,10
 786:	000be583          	lwu	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	e67ff0ef          	jal	5f2 <printint>
 790:	8ba6                	mv	s7,s1
      state = 0;
 792:	4981                	li	s3,0
 794:	b781                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 796:	008b8493          	addi	s1,s7,8
 79a:	4681                	li	a3,0
 79c:	4629                	li	a2,10
 79e:	000bb583          	ld	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e4fff0ef          	jal	5f2 <printint>
        i += 1;
 7a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7aa:	8ba6                	mv	s7,s1
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b71d                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b0:	008b8493          	addi	s1,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4629                	li	a2,10
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e35ff0ef          	jal	5f2 <printint>
        i += 2;
 7c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	8ba6                	mv	s7,s1
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	b731                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7ca:	008b8493          	addi	s1,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4641                	li	a2,16
 7d2:	000be583          	lwu	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	e1bff0ef          	jal	5f2 <printint>
 7dc:	8ba6                	mv	s7,s1
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bdd5                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4641                	li	a2,16
 7ea:	000bb583          	ld	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	e03ff0ef          	jal	5f2 <printint>
        i += 1;
 7f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f6:	8ba6                	mv	s7,s1
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bde9                	j	6d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fc:	008b8493          	addi	s1,s7,8
 800:	4681                	li	a3,0
 802:	4641                	li	a2,16
 804:	000bb583          	ld	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	de9ff0ef          	jal	5f2 <printint>
        i += 2;
 80e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	8ba6                	mv	s7,s1
      state = 0;
 812:	4981                	li	s3,0
        i += 2;
 814:	b5c1                	j	6d4 <vprintf+0x44>
 816:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 818:	008b8793          	addi	a5,s7,8
 81c:	8cbe                	mv	s9,a5
 81e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 822:	03000593          	li	a1,48
 826:	855a                	mv	a0,s6
 828:	dadff0ef          	jal	5d4 <putc>
  putc(fd, 'x');
 82c:	07800593          	li	a1,120
 830:	855a                	mv	a0,s6
 832:	da3ff0ef          	jal	5d4 <putc>
 836:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 838:	00000b97          	auipc	s7,0x0
 83c:	3e0b8b93          	addi	s7,s7,992 # c18 <digits>
 840:	03c9d793          	srli	a5,s3,0x3c
 844:	97de                	add	a5,a5,s7
 846:	0007c583          	lbu	a1,0(a5)
 84a:	855a                	mv	a0,s6
 84c:	d89ff0ef          	jal	5d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 850:	0992                	slli	s3,s3,0x4
 852:	34fd                	addiw	s1,s1,-1
 854:	f4f5                	bnez	s1,840 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 856:	8be6                	mv	s7,s9
      state = 0;
 858:	4981                	li	s3,0
 85a:	6ca2                	ld	s9,8(sp)
 85c:	bda5                	j	6d4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 85e:	008b8493          	addi	s1,s7,8
 862:	000bc583          	lbu	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	d6dff0ef          	jal	5d4 <putc>
 86c:	8ba6                	mv	s7,s1
      state = 0;
 86e:	4981                	li	s3,0
 870:	b595                	j	6d4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 872:	008b8993          	addi	s3,s7,8
 876:	000bb483          	ld	s1,0(s7)
 87a:	cc91                	beqz	s1,896 <vprintf+0x206>
        for(; *s; s++)
 87c:	0004c583          	lbu	a1,0(s1)
 880:	c985                	beqz	a1,8b0 <vprintf+0x220>
          putc(fd, *s);
 882:	855a                	mv	a0,s6
 884:	d51ff0ef          	jal	5d4 <putc>
        for(; *s; s++)
 888:	0485                	addi	s1,s1,1
 88a:	0004c583          	lbu	a1,0(s1)
 88e:	f9f5                	bnez	a1,882 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 890:	8bce                	mv	s7,s3
      state = 0;
 892:	4981                	li	s3,0
 894:	b581                	j	6d4 <vprintf+0x44>
          s = "(null)";
 896:	00000497          	auipc	s1,0x0
 89a:	37a48493          	addi	s1,s1,890 # c10 <thread_join+0x96>
        for(; *s; s++)
 89e:	02800593          	li	a1,40
 8a2:	b7c5                	j	882 <vprintf+0x1f2>
        putc(fd, '%');
 8a4:	85be                	mv	a1,a5
 8a6:	855a                	mv	a0,s6
 8a8:	d2dff0ef          	jal	5d4 <putc>
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	b51d                	j	6d4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8b0:	8bce                	mv	s7,s3
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	b505                	j	6d4 <vprintf+0x44>
 8b6:	6906                	ld	s2,64(sp)
 8b8:	79e2                	ld	s3,56(sp)
 8ba:	7a42                	ld	s4,48(sp)
 8bc:	7aa2                	ld	s5,40(sp)
 8be:	7b02                	ld	s6,32(sp)
 8c0:	6be2                	ld	s7,24(sp)
 8c2:	6c42                	ld	s8,16(sp)
    }
  }
}
 8c4:	60e6                	ld	ra,88(sp)
 8c6:	6446                	ld	s0,80(sp)
 8c8:	64a6                	ld	s1,72(sp)
 8ca:	6125                	addi	sp,sp,96
 8cc:	8082                	ret
      if(c0 == 'd'){
 8ce:	06400713          	li	a4,100
 8d2:	e4e78fe3          	beq	a5,a4,730 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8d6:	f9478693          	addi	a3,a5,-108
 8da:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8de:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8e0:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8e2:	07500513          	li	a0,117
 8e6:	e8a78ce3          	beq	a5,a0,77e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8ea:	f8b60513          	addi	a0,a2,-117
 8ee:	e119                	bnez	a0,8f4 <vprintf+0x264>
 8f0:	ea0693e3          	bnez	a3,796 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8f4:	f8b58513          	addi	a0,a1,-117
 8f8:	e119                	bnez	a0,8fe <vprintf+0x26e>
 8fa:	ea071be3          	bnez	a4,7b0 <vprintf+0x120>
      } else if(c0 == 'x'){
 8fe:	07800513          	li	a0,120
 902:	eca784e3          	beq	a5,a0,7ca <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 906:	f8860613          	addi	a2,a2,-120
 90a:	e219                	bnez	a2,910 <vprintf+0x280>
 90c:	ec069be3          	bnez	a3,7e2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 910:	f8858593          	addi	a1,a1,-120
 914:	e199                	bnez	a1,91a <vprintf+0x28a>
 916:	ee0713e3          	bnez	a4,7fc <vprintf+0x16c>
      } else if(c0 == 'p'){
 91a:	07000713          	li	a4,112
 91e:	eee78ce3          	beq	a5,a4,816 <vprintf+0x186>
      } else if(c0 == 'c'){
 922:	06300713          	li	a4,99
 926:	f2e78ce3          	beq	a5,a4,85e <vprintf+0x1ce>
      } else if(c0 == 's'){
 92a:	07300713          	li	a4,115
 92e:	f4e782e3          	beq	a5,a4,872 <vprintf+0x1e2>
      } else if(c0 == '%'){
 932:	02500713          	li	a4,37
 936:	f6e787e3          	beq	a5,a4,8a4 <vprintf+0x214>
        putc(fd, '%');
 93a:	02500593          	li	a1,37
 93e:	855a                	mv	a0,s6
 940:	c95ff0ef          	jal	5d4 <putc>
        putc(fd, c0);
 944:	85a6                	mv	a1,s1
 946:	855a                	mv	a0,s6
 948:	c8dff0ef          	jal	5d4 <putc>
      state = 0;
 94c:	4981                	li	s3,0
 94e:	b359                	j	6d4 <vprintf+0x44>

0000000000000950 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 950:	715d                	addi	sp,sp,-80
 952:	ec06                	sd	ra,24(sp)
 954:	e822                	sd	s0,16(sp)
 956:	1000                	addi	s0,sp,32
 958:	e010                	sd	a2,0(s0)
 95a:	e414                	sd	a3,8(s0)
 95c:	e818                	sd	a4,16(s0)
 95e:	ec1c                	sd	a5,24(s0)
 960:	03043023          	sd	a6,32(s0)
 964:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 968:	8622                	mv	a2,s0
 96a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 96e:	d23ff0ef          	jal	690 <vprintf>
}
 972:	60e2                	ld	ra,24(sp)
 974:	6442                	ld	s0,16(sp)
 976:	6161                	addi	sp,sp,80
 978:	8082                	ret

000000000000097a <printf>:

void
printf(const char *fmt, ...)
{
 97a:	711d                	addi	sp,sp,-96
 97c:	ec06                	sd	ra,24(sp)
 97e:	e822                	sd	s0,16(sp)
 980:	1000                	addi	s0,sp,32
 982:	e40c                	sd	a1,8(s0)
 984:	e810                	sd	a2,16(s0)
 986:	ec14                	sd	a3,24(s0)
 988:	f018                	sd	a4,32(s0)
 98a:	f41c                	sd	a5,40(s0)
 98c:	03043823          	sd	a6,48(s0)
 990:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 994:	00840613          	addi	a2,s0,8
 998:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 99c:	85aa                	mv	a1,a0
 99e:	4505                	li	a0,1
 9a0:	cf1ff0ef          	jal	690 <vprintf>
}
 9a4:	60e2                	ld	ra,24(sp)
 9a6:	6442                	ld	s0,16(sp)
 9a8:	6125                	addi	sp,sp,96
 9aa:	8082                	ret

00000000000009ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ac:	1141                	addi	sp,sp,-16
 9ae:	e406                	sd	ra,8(sp)
 9b0:	e022                	sd	s0,0(sp)
 9b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b8:	00000797          	auipc	a5,0x0
 9bc:	6487b783          	ld	a5,1608(a5) # 1000 <freep>
 9c0:	a039                	j	9ce <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c2:	6398                	ld	a4,0(a5)
 9c4:	00e7e463          	bltu	a5,a4,9cc <free+0x20>
 9c8:	00e6ea63          	bltu	a3,a4,9dc <free+0x30>
{
 9cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ce:	fed7fae3          	bgeu	a5,a3,9c2 <free+0x16>
 9d2:	6398                	ld	a4,0(a5)
 9d4:	00e6e463          	bltu	a3,a4,9dc <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d8:	fee7eae3          	bltu	a5,a4,9cc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9dc:	ff852583          	lw	a1,-8(a0)
 9e0:	6390                	ld	a2,0(a5)
 9e2:	02059813          	slli	a6,a1,0x20
 9e6:	01c85713          	srli	a4,a6,0x1c
 9ea:	9736                	add	a4,a4,a3
 9ec:	02e60563          	beq	a2,a4,a16 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9f0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9f4:	4790                	lw	a2,8(a5)
 9f6:	02061593          	slli	a1,a2,0x20
 9fa:	01c5d713          	srli	a4,a1,0x1c
 9fe:	973e                	add	a4,a4,a5
 a00:	02e68263          	beq	a3,a4,a24 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a04:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a06:	00000717          	auipc	a4,0x0
 a0a:	5ef73d23          	sd	a5,1530(a4) # 1000 <freep>
}
 a0e:	60a2                	ld	ra,8(sp)
 a10:	6402                	ld	s0,0(sp)
 a12:	0141                	addi	sp,sp,16
 a14:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a16:	4618                	lw	a4,8(a2)
 a18:	9f2d                	addw	a4,a4,a1
 a1a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a1e:	6398                	ld	a4,0(a5)
 a20:	6310                	ld	a2,0(a4)
 a22:	b7f9                	j	9f0 <free+0x44>
    p->s.size += bp->s.size;
 a24:	ff852703          	lw	a4,-8(a0)
 a28:	9f31                	addw	a4,a4,a2
 a2a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a2c:	ff053683          	ld	a3,-16(a0)
 a30:	bfd1                	j	a04 <free+0x58>

0000000000000a32 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a32:	7139                	addi	sp,sp,-64
 a34:	fc06                	sd	ra,56(sp)
 a36:	f822                	sd	s0,48(sp)
 a38:	f04a                	sd	s2,32(sp)
 a3a:	ec4e                	sd	s3,24(sp)
 a3c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3e:	02051993          	slli	s3,a0,0x20
 a42:	0209d993          	srli	s3,s3,0x20
 a46:	09bd                	addi	s3,s3,15
 a48:	0049d993          	srli	s3,s3,0x4
 a4c:	2985                	addiw	s3,s3,1
 a4e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a50:	00000517          	auipc	a0,0x0
 a54:	5b053503          	ld	a0,1456(a0) # 1000 <freep>
 a58:	c905                	beqz	a0,a88 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a5c:	4798                	lw	a4,8(a5)
 a5e:	09377663          	bgeu	a4,s3,aea <malloc+0xb8>
 a62:	f426                	sd	s1,40(sp)
 a64:	e852                	sd	s4,16(sp)
 a66:	e456                	sd	s5,8(sp)
 a68:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a6a:	8a4e                	mv	s4,s3
 a6c:	6705                	lui	a4,0x1
 a6e:	00e9f363          	bgeu	s3,a4,a74 <malloc+0x42>
 a72:	6a05                	lui	s4,0x1
 a74:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a78:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a7c:	00000497          	auipc	s1,0x0
 a80:	58448493          	addi	s1,s1,1412 # 1000 <freep>
  if(p == SBRK_ERROR)
 a84:	5afd                	li	s5,-1
 a86:	a83d                	j	ac4 <malloc+0x92>
 a88:	f426                	sd	s1,40(sp)
 a8a:	e852                	sd	s4,16(sp)
 a8c:	e456                	sd	s5,8(sp)
 a8e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a90:	00000797          	auipc	a5,0x0
 a94:	59078793          	addi	a5,a5,1424 # 1020 <base>
 a98:	00000717          	auipc	a4,0x0
 a9c:	56f73423          	sd	a5,1384(a4) # 1000 <freep>
 aa0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aa2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aa6:	b7d1                	j	a6a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 aa8:	6398                	ld	a4,0(a5)
 aaa:	e118                	sd	a4,0(a0)
 aac:	a899                	j	b02 <malloc+0xd0>
  hp->s.size = nu;
 aae:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ab2:	0541                	addi	a0,a0,16
 ab4:	ef9ff0ef          	jal	9ac <free>
  return freep;
 ab8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 aba:	c125                	beqz	a0,b1a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 abc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 abe:	4798                	lw	a4,8(a5)
 ac0:	03277163          	bgeu	a4,s2,ae2 <malloc+0xb0>
    if(p == freep)
 ac4:	6098                	ld	a4,0(s1)
 ac6:	853e                	mv	a0,a5
 ac8:	fef71ae3          	bne	a4,a5,abc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 acc:	8552                	mv	a0,s4
 ace:	a0dff0ef          	jal	4da <sbrk>
  if(p == SBRK_ERROR)
 ad2:	fd551ee3          	bne	a0,s5,aae <malloc+0x7c>
        return 0;
 ad6:	4501                	li	a0,0
 ad8:	74a2                	ld	s1,40(sp)
 ada:	6a42                	ld	s4,16(sp)
 adc:	6aa2                	ld	s5,8(sp)
 ade:	6b02                	ld	s6,0(sp)
 ae0:	a03d                	j	b0e <malloc+0xdc>
 ae2:	74a2                	ld	s1,40(sp)
 ae4:	6a42                	ld	s4,16(sp)
 ae6:	6aa2                	ld	s5,8(sp)
 ae8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aea:	fae90fe3          	beq	s2,a4,aa8 <malloc+0x76>
        p->s.size -= nunits;
 aee:	4137073b          	subw	a4,a4,s3
 af2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af4:	02071693          	slli	a3,a4,0x20
 af8:	01c6d713          	srli	a4,a3,0x1c
 afc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 afe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b02:	00000717          	auipc	a4,0x0
 b06:	4ea73f23          	sd	a0,1278(a4) # 1000 <freep>
      return (void*)(p + 1);
 b0a:	01078513          	addi	a0,a5,16
  }
}
 b0e:	70e2                	ld	ra,56(sp)
 b10:	7442                	ld	s0,48(sp)
 b12:	7902                	ld	s2,32(sp)
 b14:	69e2                	ld	s3,24(sp)
 b16:	6121                	addi	sp,sp,64
 b18:	8082                	ret
 b1a:	74a2                	ld	s1,40(sp)
 b1c:	6a42                	ld	s4,16(sp)
 b1e:	6aa2                	ld	s5,8(sp)
 b20:	6b02                	ld	s6,0(sp)
 b22:	b7f5                	j	b0e <malloc+0xdc>

0000000000000b24 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 b24:	7179                	addi	sp,sp,-48
 b26:	f406                	sd	ra,40(sp)
 b28:	f022                	sd	s0,32(sp)
 b2a:	ec26                	sd	s1,24(sp)
 b2c:	e84a                	sd	s2,16(sp)
 b2e:	e44e                	sd	s3,8(sp)
 b30:	1800                	addi	s0,sp,48
 b32:	89aa                	mv	s3,a0
 b34:	892e                	mv	s2,a1
 b36:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 b38:	00c6151b          	slliw	a0,a2,0xc
 b3c:	ef7ff0ef          	jal	a32 <malloc>
  if(stack == 0) return -1;
 b40:	c91d                	beqz	a0,b76 <thread_create+0x52>
 b42:	e052                	sd	s4,0(sp)
 b44:	862a                	mv	a2,a0
 b46:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 b48:	10000713          	li	a4,256
 b4c:	86a6                	mv	a3,s1
 b4e:	85ca                	mv	a1,s2
 b50:	854e                	mv	a0,s3
 b52:	9d3ff0ef          	jal	524 <clone>

  if(pid < 0) {
 b56:	00054a63          	bltz	a0,b6a <thread_create+0x46>
 b5a:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 b5c:	70a2                	ld	ra,40(sp)
 b5e:	7402                	ld	s0,32(sp)
 b60:	64e2                	ld	s1,24(sp)
 b62:	6942                	ld	s2,16(sp)
 b64:	69a2                	ld	s3,8(sp)
 b66:	6145                	addi	sp,sp,48
 b68:	8082                	ret
    free(stack);
 b6a:	8552                	mv	a0,s4
 b6c:	e41ff0ef          	jal	9ac <free>
    return -1;
 b70:	557d                	li	a0,-1
 b72:	6a02                	ld	s4,0(sp)
 b74:	b7e5                	j	b5c <thread_create+0x38>
  if(stack == 0) return -1;
 b76:	557d                	li	a0,-1
 b78:	b7d5                	j	b5c <thread_create+0x38>

0000000000000b7a <thread_join>:

int
thread_join(void)
{
 b7a:	7179                	addi	sp,sp,-48
 b7c:	f406                	sd	ra,40(sp)
 b7e:	f022                	sd	s0,32(sp)
 b80:	ec26                	sd	s1,24(sp)
 b82:	1800                	addi	s0,sp,48
  void *stack = 0;
 b84:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 b88:	fd840513          	addi	a0,s0,-40
 b8c:	9a1ff0ef          	jal	52c <join>
 b90:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 b92:	00a05763          	blez	a0,ba0 <thread_join+0x26>
 b96:	fd843503          	ld	a0,-40(s0)
 b9a:	c119                	beqz	a0,ba0 <thread_join+0x26>
    free(stack);
 b9c:	e11ff0ef          	jal	9ac <free>
  }
  return pid;
}
 ba0:	8526                	mv	a0,s1
 ba2:	70a2                	ld	ra,40(sp)
 ba4:	7402                	ld	s0,32(sp)
 ba6:	64e2                	ld	s1,24(sp)
 ba8:	6145                	addi	sp,sp,48
 baa:	8082                	ret
