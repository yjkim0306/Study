
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
  ae:	4a0000ef          	jal	54e <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913423          	sd	s1,584(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	da840593          	addi	a1,s0,-600
  c0:	4a6000ef          	jal	566 <fstat>
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
  f4:	a5050513          	addi	a0,a0,-1456 # b40 <malloc+0x124>
  f8:	06d000ef          	jal	964 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	438000ef          	jal	536 <close>
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
 11e:	9f658593          	addi	a1,a1,-1546 # b10 <malloc+0xf4>
 122:	4509                	li	a0,2
 124:	017000ef          	jal	93a <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	9fc58593          	addi	a1,a1,-1540 # b28 <malloc+0x10c>
 134:	4509                	li	a0,2
 136:	005000ef          	jal	93a <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3fa000ef          	jal	536 <close>
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
 15a:	9fa50513          	addi	a0,a0,-1542 # b50 <malloc+0x134>
 15e:	007000ef          	jal	964 <printf>
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
 1a0:	98c50513          	addi	a0,a0,-1652 # b28 <malloc+0x10c>
 1a4:	7c0000ef          	jal	964 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a8:	4641                	li	a2,16
 1aa:	dc040593          	addi	a1,s0,-576
 1ae:	8526                	mv	a0,s1
 1b0:	376000ef          	jal	526 <read>
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
 1fa:	94a50513          	addi	a0,a0,-1718 # b40 <malloc+0x124>
 1fe:	766000ef          	jal	964 <printf>
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
 23e:	2d0000ef          	jal	50e <exit>
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
    ls(".");
 246:	00001517          	auipc	a0,0x1
 24a:	92250513          	addi	a0,a0,-1758 # b68 <malloc+0x14c>
 24e:	e4bff0ef          	jal	98 <ls>
    exit(0);
 252:	4501                	li	a0,0
 254:	2ba000ef          	jal	50e <exit>

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
 264:	2aa000ef          	jal	50e <exit>

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
 36a:	1bc000ef          	jal	526 <read>
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
 3b6:	198000ef          	jal	54e <open>
  if(fd < 0)
 3ba:	02054263          	bltz	a0,3de <stat+0x36>
 3be:	e426                	sd	s1,8(sp)
 3c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c2:	85ca                	mv	a1,s2
 3c4:	1a2000ef          	jal	566 <fstat>
 3c8:	892a                	mv	s2,a0
  close(fd);
 3ca:	8526                	mv	a0,s1
 3cc:	16a000ef          	jal	536 <close>
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
 4e4:	0b2000ef          	jal	596 <sys_sbrk>
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
 4fa:	09c000ef          	jal	596 <sys_sbrk>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 506:	4885                	li	a7,1
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exit>:
.global exit
exit:
 li a7, SYS_exit
 50e:	4889                	li	a7,2
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <wait>:
.global wait
wait:
 li a7, SYS_wait
 516:	488d                	li	a7,3
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51e:	4891                	li	a7,4
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <read>:
.global read
read:
 li a7, SYS_read
 526:	4895                	li	a7,5
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <write>:
.global write
write:
 li a7, SYS_write
 52e:	48c1                	li	a7,16
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <close>:
.global close
close:
 li a7, SYS_close
 536:	48d5                	li	a7,21
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <kill>:
.global kill
kill:
 li a7, SYS_kill
 53e:	4899                	li	a7,6
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exec>:
.global exec
exec:
 li a7, SYS_exec
 546:	489d                	li	a7,7
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <open>:
.global open
open:
 li a7, SYS_open
 54e:	48bd                	li	a7,15
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 556:	48c5                	li	a7,17
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55e:	48c9                	li	a7,18
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 566:	48a1                	li	a7,8
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <link>:
.global link
link:
 li a7, SYS_link
 56e:	48cd                	li	a7,19
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 576:	48d1                	li	a7,20
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57e:	48a5                	li	a7,9
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <dup>:
.global dup
dup:
 li a7, SYS_dup
 586:	48a9                	li	a7,10
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58e:	48ad                	li	a7,11
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 596:	48b1                	li	a7,12
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <pause>:
.global pause
pause:
 li a7, SYS_pause
 59e:	48b5                	li	a7,13
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a6:	48b9                	li	a7,14
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5ae:	48d9                	li	a7,22
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 5b6:	48dd                	li	a7,23
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5be:	1101                	addi	sp,sp,-32
 5c0:	ec06                	sd	ra,24(sp)
 5c2:	e822                	sd	s0,16(sp)
 5c4:	1000                	addi	s0,sp,32
 5c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ca:	4605                	li	a2,1
 5cc:	fef40593          	addi	a1,s0,-17
 5d0:	f5fff0ef          	jal	52e <write>
}
 5d4:	60e2                	ld	ra,24(sp)
 5d6:	6442                	ld	s0,16(sp)
 5d8:	6105                	addi	sp,sp,32
 5da:	8082                	ret

00000000000005dc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5dc:	715d                	addi	sp,sp,-80
 5de:	e486                	sd	ra,72(sp)
 5e0:	e0a2                	sd	s0,64(sp)
 5e2:	f84a                	sd	s2,48(sp)
 5e4:	f44e                	sd	s3,40(sp)
 5e6:	0880                	addi	s0,sp,80
 5e8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5ea:	c6d1                	beqz	a3,676 <printint+0x9a>
 5ec:	0805d563          	bgez	a1,676 <printint+0x9a>
    neg = 1;
    x = -xx;
 5f0:	40b005b3          	neg	a1,a1
    neg = 1;
 5f4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5f6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5fa:	86ce                	mv	a3,s3
  i = 0;
 5fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5fe:	00000817          	auipc	a6,0x0
 602:	57a80813          	addi	a6,a6,1402 # b78 <digits>
 606:	88ba                	mv	a7,a4
 608:	0017051b          	addiw	a0,a4,1
 60c:	872a                	mv	a4,a0
 60e:	02c5f7b3          	remu	a5,a1,a2
 612:	97c2                	add	a5,a5,a6
 614:	0007c783          	lbu	a5,0(a5)
 618:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 61c:	87ae                	mv	a5,a1
 61e:	02c5d5b3          	divu	a1,a1,a2
 622:	0685                	addi	a3,a3,1
 624:	fec7f1e3          	bgeu	a5,a2,606 <printint+0x2a>
  if(neg)
 628:	00030c63          	beqz	t1,640 <printint+0x64>
    buf[i++] = '-';
 62c:	fd050793          	addi	a5,a0,-48
 630:	00878533          	add	a0,a5,s0
 634:	02d00793          	li	a5,45
 638:	fef50423          	sb	a5,-24(a0)
 63c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 640:	02e05563          	blez	a4,66a <printint+0x8e>
 644:	fc26                	sd	s1,56(sp)
 646:	377d                	addiw	a4,a4,-1
 648:	00e984b3          	add	s1,s3,a4
 64c:	19fd                	addi	s3,s3,-1
 64e:	99ba                	add	s3,s3,a4
 650:	1702                	slli	a4,a4,0x20
 652:	9301                	srli	a4,a4,0x20
 654:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 658:	0004c583          	lbu	a1,0(s1)
 65c:	854a                	mv	a0,s2
 65e:	f61ff0ef          	jal	5be <putc>
  while(--i >= 0)
 662:	14fd                	addi	s1,s1,-1
 664:	ff349ae3          	bne	s1,s3,658 <printint+0x7c>
 668:	74e2                	ld	s1,56(sp)
}
 66a:	60a6                	ld	ra,72(sp)
 66c:	6406                	ld	s0,64(sp)
 66e:	7942                	ld	s2,48(sp)
 670:	79a2                	ld	s3,40(sp)
 672:	6161                	addi	sp,sp,80
 674:	8082                	ret
  neg = 0;
 676:	4301                	li	t1,0
 678:	bfbd                	j	5f6 <printint+0x1a>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	711d                	addi	sp,sp,-96
 67c:	ec86                	sd	ra,88(sp)
 67e:	e8a2                	sd	s0,80(sp)
 680:	e4a6                	sd	s1,72(sp)
 682:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 684:	0005c483          	lbu	s1,0(a1)
 688:	22048363          	beqz	s1,8ae <vprintf+0x234>
 68c:	e0ca                	sd	s2,64(sp)
 68e:	fc4e                	sd	s3,56(sp)
 690:	f852                	sd	s4,48(sp)
 692:	f456                	sd	s5,40(sp)
 694:	f05a                	sd	s6,32(sp)
 696:	ec5e                	sd	s7,24(sp)
 698:	e862                	sd	s8,16(sp)
 69a:	8b2a                	mv	s6,a0
 69c:	8a2e                	mv	s4,a1
 69e:	8bb2                	mv	s7,a2
  state = 0;
 6a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a2:	4901                	li	s2,0
 6a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6aa:	06400c13          	li	s8,100
 6ae:	a00d                	j	6d0 <vprintf+0x56>
        putc(fd, c0);
 6b0:	85a6                	mv	a1,s1
 6b2:	855a                	mv	a0,s6
 6b4:	f0bff0ef          	jal	5be <putc>
 6b8:	a019                	j	6be <vprintf+0x44>
    } else if(state == '%'){
 6ba:	03598363          	beq	s3,s5,6e0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6be:	0019079b          	addiw	a5,s2,1
 6c2:	893e                	mv	s2,a5
 6c4:	873e                	mv	a4,a5
 6c6:	97d2                	add	a5,a5,s4
 6c8:	0007c483          	lbu	s1,0(a5)
 6cc:	1c048a63          	beqz	s1,8a0 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6d0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6d4:	fe0993e3          	bnez	s3,6ba <vprintf+0x40>
      if(c0 == '%'){
 6d8:	fd579ce3          	bne	a5,s5,6b0 <vprintf+0x36>
        state = '%';
 6dc:	89be                	mv	s3,a5
 6de:	b7c5                	j	6be <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e0:	00ea06b3          	add	a3,s4,a4
 6e4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6e8:	1c060863          	beqz	a2,8b8 <vprintf+0x23e>
      if(c0 == 'd'){
 6ec:	03878763          	beq	a5,s8,71a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	f9478693          	addi	a3,a5,-108
 6f4:	0016b693          	seqz	a3,a3
 6f8:	f9c60593          	addi	a1,a2,-100
 6fc:	e99d                	bnez	a1,732 <vprintf+0xb8>
 6fe:	ca95                	beqz	a3,732 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 700:	008b8493          	addi	s1,s7,8
 704:	4685                	li	a3,1
 706:	4629                	li	a2,10
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	ecfff0ef          	jal	5dc <printint>
        i += 1;
 712:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 716:	4981                	li	s3,0
 718:	b75d                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 71a:	008b8493          	addi	s1,s7,8
 71e:	4685                	li	a3,1
 720:	4629                	li	a2,10
 722:	000ba583          	lw	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	eb5ff0ef          	jal	5dc <printint>
 72c:	8ba6                	mv	s7,s1
      state = 0;
 72e:	4981                	li	s3,0
 730:	b779                	j	6be <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 732:	9752                	add	a4,a4,s4
 734:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 738:	f9460713          	addi	a4,a2,-108
 73c:	00173713          	seqz	a4,a4
 740:	8f75                	and	a4,a4,a3
 742:	f9c58513          	addi	a0,a1,-100
 746:	18051363          	bnez	a0,8cc <vprintf+0x252>
 74a:	18070163          	beqz	a4,8cc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 74e:	008b8493          	addi	s1,s7,8
 752:	4685                	li	a3,1
 754:	4629                	li	a2,10
 756:	000bb583          	ld	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	e81ff0ef          	jal	5dc <printint>
        i += 2;
 760:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 762:	8ba6                	mv	s7,s1
      state = 0;
 764:	4981                	li	s3,0
        i += 2;
 766:	bfa1                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 768:	008b8493          	addi	s1,s7,8
 76c:	4681                	li	a3,0
 76e:	4629                	li	a2,10
 770:	000be583          	lwu	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	e67ff0ef          	jal	5dc <printint>
 77a:	8ba6                	mv	s7,s1
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b781                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 780:	008b8493          	addi	s1,s7,8
 784:	4681                	li	a3,0
 786:	4629                	li	a2,10
 788:	000bb583          	ld	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	e4fff0ef          	jal	5dc <printint>
        i += 1;
 792:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 794:	8ba6                	mv	s7,s1
      state = 0;
 796:	4981                	li	s3,0
 798:	b71d                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	008b8493          	addi	s1,s7,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000bb583          	ld	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	e35ff0ef          	jal	5dc <printint>
        i += 2;
 7ac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ae:	8ba6                	mv	s7,s1
      state = 0;
 7b0:	4981                	li	s3,0
        i += 2;
 7b2:	b731                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7b4:	008b8493          	addi	s1,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4641                	li	a2,16
 7bc:	000be583          	lwu	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	e1bff0ef          	jal	5dc <printint>
 7c6:	8ba6                	mv	s7,s1
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bdd5                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7cc:	008b8493          	addi	s1,s7,8
 7d0:	4681                	li	a3,0
 7d2:	4641                	li	a2,16
 7d4:	000bb583          	ld	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	e03ff0ef          	jal	5dc <printint>
        i += 1;
 7de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e0:	8ba6                	mv	s7,s1
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bde9                	j	6be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	008b8493          	addi	s1,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000bb583          	ld	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	de9ff0ef          	jal	5dc <printint>
        i += 2;
 7f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fa:	8ba6                	mv	s7,s1
      state = 0;
 7fc:	4981                	li	s3,0
        i += 2;
 7fe:	b5c1                	j	6be <vprintf+0x44>
 800:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 802:	008b8793          	addi	a5,s7,8
 806:	8cbe                	mv	s9,a5
 808:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 80c:	03000593          	li	a1,48
 810:	855a                	mv	a0,s6
 812:	dadff0ef          	jal	5be <putc>
  putc(fd, 'x');
 816:	07800593          	li	a1,120
 81a:	855a                	mv	a0,s6
 81c:	da3ff0ef          	jal	5be <putc>
 820:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 822:	00000b97          	auipc	s7,0x0
 826:	356b8b93          	addi	s7,s7,854 # b78 <digits>
 82a:	03c9d793          	srli	a5,s3,0x3c
 82e:	97de                	add	a5,a5,s7
 830:	0007c583          	lbu	a1,0(a5)
 834:	855a                	mv	a0,s6
 836:	d89ff0ef          	jal	5be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 83a:	0992                	slli	s3,s3,0x4
 83c:	34fd                	addiw	s1,s1,-1
 83e:	f4f5                	bnez	s1,82a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 840:	8be6                	mv	s7,s9
      state = 0;
 842:	4981                	li	s3,0
 844:	6ca2                	ld	s9,8(sp)
 846:	bda5                	j	6be <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 848:	008b8493          	addi	s1,s7,8
 84c:	000bc583          	lbu	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	d6dff0ef          	jal	5be <putc>
 856:	8ba6                	mv	s7,s1
      state = 0;
 858:	4981                	li	s3,0
 85a:	b595                	j	6be <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 85c:	008b8993          	addi	s3,s7,8
 860:	000bb483          	ld	s1,0(s7)
 864:	cc91                	beqz	s1,880 <vprintf+0x206>
        for(; *s; s++)
 866:	0004c583          	lbu	a1,0(s1)
 86a:	c985                	beqz	a1,89a <vprintf+0x220>
          putc(fd, *s);
 86c:	855a                	mv	a0,s6
 86e:	d51ff0ef          	jal	5be <putc>
        for(; *s; s++)
 872:	0485                	addi	s1,s1,1
 874:	0004c583          	lbu	a1,0(s1)
 878:	f9f5                	bnez	a1,86c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 87a:	8bce                	mv	s7,s3
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b581                	j	6be <vprintf+0x44>
          s = "(null)";
 880:	00000497          	auipc	s1,0x0
 884:	2f048493          	addi	s1,s1,752 # b70 <malloc+0x154>
        for(; *s; s++)
 888:	02800593          	li	a1,40
 88c:	b7c5                	j	86c <vprintf+0x1f2>
        putc(fd, '%');
 88e:	85be                	mv	a1,a5
 890:	855a                	mv	a0,s6
 892:	d2dff0ef          	jal	5be <putc>
      state = 0;
 896:	4981                	li	s3,0
 898:	b51d                	j	6be <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 89a:	8bce                	mv	s7,s3
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b505                	j	6be <vprintf+0x44>
 8a0:	6906                	ld	s2,64(sp)
 8a2:	79e2                	ld	s3,56(sp)
 8a4:	7a42                	ld	s4,48(sp)
 8a6:	7aa2                	ld	s5,40(sp)
 8a8:	7b02                	ld	s6,32(sp)
 8aa:	6be2                	ld	s7,24(sp)
 8ac:	6c42                	ld	s8,16(sp)
    }
  }
}
 8ae:	60e6                	ld	ra,88(sp)
 8b0:	6446                	ld	s0,80(sp)
 8b2:	64a6                	ld	s1,72(sp)
 8b4:	6125                	addi	sp,sp,96
 8b6:	8082                	ret
      if(c0 == 'd'){
 8b8:	06400713          	li	a4,100
 8bc:	e4e78fe3          	beq	a5,a4,71a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8c0:	f9478693          	addi	a3,a5,-108
 8c4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8c8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8ca:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8cc:	07500513          	li	a0,117
 8d0:	e8a78ce3          	beq	a5,a0,768 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8d4:	f8b60513          	addi	a0,a2,-117
 8d8:	e119                	bnez	a0,8de <vprintf+0x264>
 8da:	ea0693e3          	bnez	a3,780 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8de:	f8b58513          	addi	a0,a1,-117
 8e2:	e119                	bnez	a0,8e8 <vprintf+0x26e>
 8e4:	ea071be3          	bnez	a4,79a <vprintf+0x120>
      } else if(c0 == 'x'){
 8e8:	07800513          	li	a0,120
 8ec:	eca784e3          	beq	a5,a0,7b4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8f0:	f8860613          	addi	a2,a2,-120
 8f4:	e219                	bnez	a2,8fa <vprintf+0x280>
 8f6:	ec069be3          	bnez	a3,7cc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8fa:	f8858593          	addi	a1,a1,-120
 8fe:	e199                	bnez	a1,904 <vprintf+0x28a>
 900:	ee0713e3          	bnez	a4,7e6 <vprintf+0x16c>
      } else if(c0 == 'p'){
 904:	07000713          	li	a4,112
 908:	eee78ce3          	beq	a5,a4,800 <vprintf+0x186>
      } else if(c0 == 'c'){
 90c:	06300713          	li	a4,99
 910:	f2e78ce3          	beq	a5,a4,848 <vprintf+0x1ce>
      } else if(c0 == 's'){
 914:	07300713          	li	a4,115
 918:	f4e782e3          	beq	a5,a4,85c <vprintf+0x1e2>
      } else if(c0 == '%'){
 91c:	02500713          	li	a4,37
 920:	f6e787e3          	beq	a5,a4,88e <vprintf+0x214>
        putc(fd, '%');
 924:	02500593          	li	a1,37
 928:	855a                	mv	a0,s6
 92a:	c95ff0ef          	jal	5be <putc>
        putc(fd, c0);
 92e:	85a6                	mv	a1,s1
 930:	855a                	mv	a0,s6
 932:	c8dff0ef          	jal	5be <putc>
      state = 0;
 936:	4981                	li	s3,0
 938:	b359                	j	6be <vprintf+0x44>

000000000000093a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 93a:	715d                	addi	sp,sp,-80
 93c:	ec06                	sd	ra,24(sp)
 93e:	e822                	sd	s0,16(sp)
 940:	1000                	addi	s0,sp,32
 942:	e010                	sd	a2,0(s0)
 944:	e414                	sd	a3,8(s0)
 946:	e818                	sd	a4,16(s0)
 948:	ec1c                	sd	a5,24(s0)
 94a:	03043023          	sd	a6,32(s0)
 94e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 952:	8622                	mv	a2,s0
 954:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 958:	d23ff0ef          	jal	67a <vprintf>
}
 95c:	60e2                	ld	ra,24(sp)
 95e:	6442                	ld	s0,16(sp)
 960:	6161                	addi	sp,sp,80
 962:	8082                	ret

0000000000000964 <printf>:

void
printf(const char *fmt, ...)
{
 964:	711d                	addi	sp,sp,-96
 966:	ec06                	sd	ra,24(sp)
 968:	e822                	sd	s0,16(sp)
 96a:	1000                	addi	s0,sp,32
 96c:	e40c                	sd	a1,8(s0)
 96e:	e810                	sd	a2,16(s0)
 970:	ec14                	sd	a3,24(s0)
 972:	f018                	sd	a4,32(s0)
 974:	f41c                	sd	a5,40(s0)
 976:	03043823          	sd	a6,48(s0)
 97a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 97e:	00840613          	addi	a2,s0,8
 982:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 986:	85aa                	mv	a1,a0
 988:	4505                	li	a0,1
 98a:	cf1ff0ef          	jal	67a <vprintf>
}
 98e:	60e2                	ld	ra,24(sp)
 990:	6442                	ld	s0,16(sp)
 992:	6125                	addi	sp,sp,96
 994:	8082                	ret

0000000000000996 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 996:	1141                	addi	sp,sp,-16
 998:	e406                	sd	ra,8(sp)
 99a:	e022                	sd	s0,0(sp)
 99c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	00000797          	auipc	a5,0x0
 9a6:	65e7b783          	ld	a5,1630(a5) # 1000 <freep>
 9aa:	a039                	j	9b8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ac:	6398                	ld	a4,0(a5)
 9ae:	00e7e463          	bltu	a5,a4,9b6 <free+0x20>
 9b2:	00e6ea63          	bltu	a3,a4,9c6 <free+0x30>
{
 9b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b8:	fed7fae3          	bgeu	a5,a3,9ac <free+0x16>
 9bc:	6398                	ld	a4,0(a5)
 9be:	00e6e463          	bltu	a3,a4,9c6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c2:	fee7eae3          	bltu	a5,a4,9b6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9c6:	ff852583          	lw	a1,-8(a0)
 9ca:	6390                	ld	a2,0(a5)
 9cc:	02059813          	slli	a6,a1,0x20
 9d0:	01c85713          	srli	a4,a6,0x1c
 9d4:	9736                	add	a4,a4,a3
 9d6:	02e60563          	beq	a2,a4,a00 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9da:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9de:	4790                	lw	a2,8(a5)
 9e0:	02061593          	slli	a1,a2,0x20
 9e4:	01c5d713          	srli	a4,a1,0x1c
 9e8:	973e                	add	a4,a4,a5
 9ea:	02e68263          	beq	a3,a4,a0e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9ee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f0:	00000717          	auipc	a4,0x0
 9f4:	60f73823          	sd	a5,1552(a4) # 1000 <freep>
}
 9f8:	60a2                	ld	ra,8(sp)
 9fa:	6402                	ld	s0,0(sp)
 9fc:	0141                	addi	sp,sp,16
 9fe:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a00:	4618                	lw	a4,8(a2)
 a02:	9f2d                	addw	a4,a4,a1
 a04:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a08:	6398                	ld	a4,0(a5)
 a0a:	6310                	ld	a2,0(a4)
 a0c:	b7f9                	j	9da <free+0x44>
    p->s.size += bp->s.size;
 a0e:	ff852703          	lw	a4,-8(a0)
 a12:	9f31                	addw	a4,a4,a2
 a14:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a16:	ff053683          	ld	a3,-16(a0)
 a1a:	bfd1                	j	9ee <free+0x58>

0000000000000a1c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a1c:	7139                	addi	sp,sp,-64
 a1e:	fc06                	sd	ra,56(sp)
 a20:	f822                	sd	s0,48(sp)
 a22:	f04a                	sd	s2,32(sp)
 a24:	ec4e                	sd	s3,24(sp)
 a26:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a28:	02051993          	slli	s3,a0,0x20
 a2c:	0209d993          	srli	s3,s3,0x20
 a30:	09bd                	addi	s3,s3,15
 a32:	0049d993          	srli	s3,s3,0x4
 a36:	2985                	addiw	s3,s3,1
 a38:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a3a:	00000517          	auipc	a0,0x0
 a3e:	5c653503          	ld	a0,1478(a0) # 1000 <freep>
 a42:	c905                	beqz	a0,a72 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a46:	4798                	lw	a4,8(a5)
 a48:	09377663          	bgeu	a4,s3,ad4 <malloc+0xb8>
 a4c:	f426                	sd	s1,40(sp)
 a4e:	e852                	sd	s4,16(sp)
 a50:	e456                	sd	s5,8(sp)
 a52:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a54:	8a4e                	mv	s4,s3
 a56:	6705                	lui	a4,0x1
 a58:	00e9f363          	bgeu	s3,a4,a5e <malloc+0x42>
 a5c:	6a05                	lui	s4,0x1
 a5e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a62:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a66:	00000497          	auipc	s1,0x0
 a6a:	59a48493          	addi	s1,s1,1434 # 1000 <freep>
  if(p == SBRK_ERROR)
 a6e:	5afd                	li	s5,-1
 a70:	a83d                	j	aae <malloc+0x92>
 a72:	f426                	sd	s1,40(sp)
 a74:	e852                	sd	s4,16(sp)
 a76:	e456                	sd	s5,8(sp)
 a78:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a7a:	00000797          	auipc	a5,0x0
 a7e:	5a678793          	addi	a5,a5,1446 # 1020 <base>
 a82:	00000717          	auipc	a4,0x0
 a86:	56f73f23          	sd	a5,1406(a4) # 1000 <freep>
 a8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a90:	b7d1                	j	a54 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a92:	6398                	ld	a4,0(a5)
 a94:	e118                	sd	a4,0(a0)
 a96:	a899                	j	aec <malloc+0xd0>
  hp->s.size = nu;
 a98:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a9c:	0541                	addi	a0,a0,16
 a9e:	ef9ff0ef          	jal	996 <free>
  return freep;
 aa2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 aa4:	c125                	beqz	a0,b04 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa8:	4798                	lw	a4,8(a5)
 aaa:	03277163          	bgeu	a4,s2,acc <malloc+0xb0>
    if(p == freep)
 aae:	6098                	ld	a4,0(s1)
 ab0:	853e                	mv	a0,a5
 ab2:	fef71ae3          	bne	a4,a5,aa6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ab6:	8552                	mv	a0,s4
 ab8:	a23ff0ef          	jal	4da <sbrk>
  if(p == SBRK_ERROR)
 abc:	fd551ee3          	bne	a0,s5,a98 <malloc+0x7c>
        return 0;
 ac0:	4501                	li	a0,0
 ac2:	74a2                	ld	s1,40(sp)
 ac4:	6a42                	ld	s4,16(sp)
 ac6:	6aa2                	ld	s5,8(sp)
 ac8:	6b02                	ld	s6,0(sp)
 aca:	a03d                	j	af8 <malloc+0xdc>
 acc:	74a2                	ld	s1,40(sp)
 ace:	6a42                	ld	s4,16(sp)
 ad0:	6aa2                	ld	s5,8(sp)
 ad2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad4:	fae90fe3          	beq	s2,a4,a92 <malloc+0x76>
        p->s.size -= nunits;
 ad8:	4137073b          	subw	a4,a4,s3
 adc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ade:	02071693          	slli	a3,a4,0x20
 ae2:	01c6d713          	srli	a4,a3,0x1c
 ae6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aec:	00000717          	auipc	a4,0x0
 af0:	50a73a23          	sd	a0,1300(a4) # 1000 <freep>
      return (void*)(p + 1);
 af4:	01078513          	addi	a0,a5,16
  }
}
 af8:	70e2                	ld	ra,56(sp)
 afa:	7442                	ld	s0,48(sp)
 afc:	7902                	ld	s2,32(sp)
 afe:	69e2                	ld	s3,24(sp)
 b00:	6121                	addi	sp,sp,64
 b02:	8082                	ret
 b04:	74a2                	ld	s1,40(sp)
 b06:	6a42                	ld	s4,16(sp)
 b08:	6aa2                	ld	s5,8(sp)
 b0a:	6b02                	ld	s6,0(sp)
 b0c:	b7f5                	j	af8 <malloc+0xdc>
