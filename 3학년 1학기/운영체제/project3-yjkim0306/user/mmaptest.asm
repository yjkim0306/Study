
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
char *testname = "???";
char buf[PGSIZE];

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	892a                	mv	s2,a0
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00002497          	auipc	s1,0x2
      12:	ff24b483          	ld	s1,-14(s1) # 2000 <testname>
      16:	7c3000ef          	jal	fd8 <getpid>
      1a:	86aa                	mv	a3,a0
      1c:	864a                	mv	a2,s2
      1e:	85a6                	mv	a1,s1
      20:	00001517          	auipc	a0,0x1
      24:	54050513          	addi	a0,a0,1344 # 1560 <malloc+0xfa>
      28:	386010ef          	jal	13ae <printf>
  exit(1);
      2c:	4505                	li	a0,1
      2e:	72b000ef          	jal	f58 <exit>

0000000000000032 <make_test_file>:
}

// Make a file with 1.5 pages of 'A' followed by zeros (rest of the page).
static void
make_test_file(const char *name)
{
      32:	1101                	addi	sp,sp,-32
      34:	ec06                	sd	ra,24(sp)
      36:	e822                	sd	s0,16(sp)
      38:	e426                	sd	s1,8(sp)
      3a:	e04a                	sd	s2,0(sp)
      3c:	1000                	addi	s0,sp,32
      3e:	84aa                	mv	s1,a0
  int fd;
  unlink(name);
      40:	769000ef          	jal	fa8 <unlink>
  fd = open(name, O_WRONLY | O_CREATE | O_TRUNC);
      44:	60100593          	li	a1,1537
      48:	8526                	mv	a0,s1
      4a:	74f000ef          	jal	f98 <open>
  if(fd == -1)
      4e:	57fd                	li	a5,-1
      50:	06f50a63          	beq	a0,a5,c4 <make_test_file+0x92>
      54:	84aa                	mv	s1,a0
    err("open create");
  memset(buf, 'A', PGSIZE);
      56:	6605                	lui	a2,0x1
      58:	04100593          	li	a1,65
      5c:	00002517          	auipc	a0,0x2
      60:	fc450513          	addi	a0,a0,-60 # 2020 <buf>
      64:	4cb000ef          	jal	d2e <memset>
  if(write(fd, buf, PGSIZE) != PGSIZE)
      68:	6605                	lui	a2,0x1
      6a:	00002597          	auipc	a1,0x2
      6e:	fb658593          	addi	a1,a1,-74 # 2020 <buf>
      72:	8526                	mv	a0,s1
      74:	705000ef          	jal	f78 <write>
      78:	6785                	lui	a5,0x1
      7a:	04f51b63          	bne	a0,a5,d0 <make_test_file+0x9e>
    err("write 1");
  memset(buf, 'A', PGSIZE/2);
      7e:	6905                	lui	s2,0x1
      80:	80090613          	addi	a2,s2,-2048 # 800 <main+0x698>
      84:	04100593          	li	a1,65
      88:	00002517          	auipc	a0,0x2
      8c:	f9850513          	addi	a0,a0,-104 # 2020 <buf>
      90:	49f000ef          	jal	d2e <memset>
  if(write(fd, buf, PGSIZE/2) != PGSIZE/2)
      94:	80090613          	addi	a2,s2,-2048
      98:	00002597          	auipc	a1,0x2
      9c:	f8858593          	addi	a1,a1,-120 # 2020 <buf>
      a0:	8526                	mv	a0,s1
      a2:	6d7000ef          	jal	f78 <write>
      a6:	8005051b          	addiw	a0,a0,-2048
      aa:	e90d                	bnez	a0,dc <make_test_file+0xaa>
    err("write 2");
  if(close(fd) == -1)
      ac:	8526                	mv	a0,s1
      ae:	6d3000ef          	jal	f80 <close>
      b2:	57fd                	li	a5,-1
      b4:	02f50a63          	beq	a0,a5,e8 <make_test_file+0xb6>
    err("close");
}
      b8:	60e2                	ld	ra,24(sp)
      ba:	6442                	ld	s0,16(sp)
      bc:	64a2                	ld	s1,8(sp)
      be:	6902                	ld	s2,0(sp)
      c0:	6105                	addi	sp,sp,32
      c2:	8082                	ret
    err("open create");
      c4:	00001517          	auipc	a0,0x1
      c8:	4c450513          	addi	a0,a0,1220 # 1588 <malloc+0x122>
      cc:	f35ff0ef          	jal	0 <err>
    err("write 1");
      d0:	00001517          	auipc	a0,0x1
      d4:	4c850513          	addi	a0,a0,1224 # 1598 <malloc+0x132>
      d8:	f29ff0ef          	jal	0 <err>
    err("write 2");
      dc:	00001517          	auipc	a0,0x1
      e0:	4c450513          	addi	a0,a0,1220 # 15a0 <malloc+0x13a>
      e4:	f1dff0ef          	jal	0 <err>
    err("close");
      e8:	00001517          	auipc	a0,0x1
      ec:	4c050513          	addi	a0,a0,1216 # 15a8 <malloc+0x142>
      f0:	f11ff0ef          	jal	0 <err>

00000000000000f4 <verify_content>:

// Verify 1.5 pages of 'A' then zeros (lazy zero-fill for the rest of the page).
static void
verify_content(char *p)
{
      f4:	1141                	addi	sp,sp,-16
      f6:	e406                	sd	ra,8(sp)
      f8:	e022                	sd	s0,0(sp)
      fa:	0800                	addi	s0,sp,16
      fc:	4581                	li	a1,0
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++){
    if(p[i] != 'A'){
      fe:	04100693          	li	a3,65
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++){
     102:	6709                	lui	a4,0x2
     104:	80070713          	addi	a4,a4,-2048 # 1800 <malloc+0x39a>
    if(p[i] != 'A'){
     108:	00b507b3          	add	a5,a0,a1
     10c:	0007c603          	lbu	a2,0(a5) # 1000 <munmap>
     110:	02d61263          	bne	a2,a3,134 <verify_content+0x40>
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++){
     114:	0585                	addi	a1,a1,1
     116:	fee599e3          	bne	a1,a4,108 <verify_content+0x14>
      printf("mismatch at %d: got 0x%x, want 'A'\n", i, p[i]);
      err("content mismatch (A)");
    }
  }
  for(int i = PGSIZE + PGSIZE/2; i < 2*PGSIZE; i++){
     11a:	6709                	lui	a4,0x2
    if(p[i] != 0){
     11c:	00b507b3          	add	a5,a0,a1
     120:	0007c603          	lbu	a2,0(a5)
     124:	e60d                	bnez	a2,14e <verify_content+0x5a>
  for(int i = PGSIZE + PGSIZE/2; i < 2*PGSIZE; i++){
     126:	0585                	addi	a1,a1,1
     128:	fee59ae3          	bne	a1,a4,11c <verify_content+0x28>
      printf("mismatch at %d: got 0x%x, want 0\n", i, p[i]);
      err("content mismatch (zero)");
    }
  }
}
     12c:	60a2                	ld	ra,8(sp)
     12e:	6402                	ld	s0,0(sp)
     130:	0141                	addi	sp,sp,16
     132:	8082                	ret
      printf("mismatch at %d: got 0x%x, want 'A'\n", i, p[i]);
     134:	2581                	sext.w	a1,a1
     136:	00001517          	auipc	a0,0x1
     13a:	47a50513          	addi	a0,a0,1146 # 15b0 <malloc+0x14a>
     13e:	270010ef          	jal	13ae <printf>
      err("content mismatch (A)");
     142:	00001517          	auipc	a0,0x1
     146:	49650513          	addi	a0,a0,1174 # 15d8 <malloc+0x172>
     14a:	eb7ff0ef          	jal	0 <err>
      printf("mismatch at %d: got 0x%x, want 0\n", i, p[i]);
     14e:	2581                	sext.w	a1,a1
     150:	00001517          	auipc	a0,0x1
     154:	4a050513          	addi	a0,a0,1184 # 15f0 <malloc+0x18a>
     158:	256010ef          	jal	13ae <printf>
      err("content mismatch (zero)");
     15c:	00001517          	auipc	a0,0x1
     160:	4bc50513          	addi	a0,a0,1212 # 1618 <malloc+0x1b2>
     164:	e9dff0ef          	jal	0 <err>

0000000000000168 <main>:
  printf("%s: OK\n", testname);
}

int
main(int argc, char *argv[])
{
     168:	715d                	addi	sp,sp,-80
     16a:	e486                	sd	ra,72(sp)
     16c:	e0a2                	sd	s0,64(sp)
     16e:	0880                	addi	s0,sp,80
  testname = "test basic mmap";
     170:	00001797          	auipc	a5,0x1
     174:	4c078793          	addi	a5,a5,1216 # 1630 <malloc+0x1ca>
     178:	00002717          	auipc	a4,0x2
     17c:	e8f73423          	sd	a5,-376(a4) # 2000 <testname>
  printf("%s\n", testname);
     180:	85be                	mv	a1,a5
     182:	00001517          	auipc	a0,0x1
     186:	4be50513          	addi	a0,a0,1214 # 1640 <malloc+0x1da>
     18a:	224010ef          	jal	13ae <printf>
  make_test_file(f);
     18e:	00001517          	auipc	a0,0x1
     192:	4ba50513          	addi	a0,a0,1210 # 1648 <malloc+0x1e2>
     196:	e9dff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDONLY);
     19a:	4581                	li	a1,0
     19c:	00001517          	auipc	a0,0x1
     1a0:	4ac50513          	addi	a0,a0,1196 # 1648 <malloc+0x1e2>
     1a4:	5f5000ef          	jal	f98 <open>
  if(fd == -1) err("open");
     1a8:	57fd                	li	a5,-1
     1aa:	5cf50663          	beq	a0,a5,776 <main+0x60e>
     1ae:	fc26                	sd	s1,56(sp)
     1b0:	f84a                	sd	s2,48(sp)
     1b2:	84aa                	mv	s1,a0
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     1b4:	4701                	li	a4,0
     1b6:	86aa                	mv	a3,a0
     1b8:	4609                	li	a2,2
     1ba:	4585                	li	a1,1
     1bc:	6509                	lui	a0,0x2
     1be:	63b000ef          	jal	ff8 <mmap>
     1c2:	892a                	mv	s2,a0
  if(p == MAP_FAILED) err("mmap");
     1c4:	57fd                	li	a5,-1
     1c6:	5cf50263          	beq	a0,a5,78a <main+0x622>
  verify_content(p);
     1ca:	f2bff0ef          	jal	f4 <verify_content>
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     1ce:	6589                	lui	a1,0x2
     1d0:	854a                	mv	a0,s2
     1d2:	62f000ef          	jal	1000 <munmap>
     1d6:	57fd                	li	a5,-1
     1d8:	5cf50163          	beq	a0,a5,79a <main+0x632>
  close(fd);
     1dc:	8526                	mv	a0,s1
     1de:	5a3000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     1e2:	00002497          	auipc	s1,0x2
     1e6:	e1e48493          	addi	s1,s1,-482 # 2000 <testname>
     1ea:	608c                	ld	a1,0(s1)
     1ec:	00001517          	auipc	a0,0x1
     1f0:	48450513          	addi	a0,a0,1156 # 1670 <malloc+0x20a>
     1f4:	1ba010ef          	jal	13ae <printf>
  testname = "test mmap private";
     1f8:	00001797          	auipc	a5,0x1
     1fc:	48078793          	addi	a5,a5,1152 # 1678 <malloc+0x212>
     200:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     202:	85be                	mv	a1,a5
     204:	00001517          	auipc	a0,0x1
     208:	43c50513          	addi	a0,a0,1084 # 1640 <malloc+0x1da>
     20c:	1a2010ef          	jal	13ae <printf>
  make_test_file(f);
     210:	00001517          	auipc	a0,0x1
     214:	43850513          	addi	a0,a0,1080 # 1648 <malloc+0x1e2>
     218:	e1bff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDWR);
     21c:	4589                	li	a1,2
     21e:	00001517          	auipc	a0,0x1
     222:	42a50513          	addi	a0,a0,1066 # 1648 <malloc+0x1e2>
     226:	573000ef          	jal	f98 <open>
     22a:	84aa                	mv	s1,a0
  if(fd == -1) err("open");
     22c:	57fd                	li	a5,-1
     22e:	56f50e63          	beq	a0,a5,7aa <main+0x642>
  char *p = mmap(PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     232:	4701                	li	a4,0
     234:	86aa                	mv	a3,a0
     236:	4609                	li	a2,2
     238:	458d                	li	a1,3
     23a:	6509                	lui	a0,0x2
     23c:	5bd000ef          	jal	ff8 <mmap>
  if(p == MAP_FAILED) err("mmap");
     240:	57fd                	li	a5,-1
     242:	56f50c63          	beq	a0,a5,7ba <main+0x652>
     246:	87aa                	mv	a5,a0
     248:	6709                	lui	a4,0x2
     24a:	80070713          	addi	a4,a4,-2048 # 1800 <malloc+0x39a>
     24e:	972a                	add	a4,a4,a0
    p[i] = 'Z';
     250:	05a00693          	li	a3,90
     254:	00d78023          	sb	a3,0(a5)
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++)
     258:	0785                	addi	a5,a5,1
     25a:	fee79de3          	bne	a5,a4,254 <main+0xec>
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     25e:	6589                	lui	a1,0x2
     260:	5a1000ef          	jal	1000 <munmap>
     264:	57fd                	li	a5,-1
     266:	56f50263          	beq	a0,a5,7ca <main+0x662>
  close(fd);
     26a:	8526                	mv	a0,s1
     26c:	515000ef          	jal	f80 <close>
  fd = open(f, O_RDONLY);
     270:	4581                	li	a1,0
     272:	00001517          	auipc	a0,0x1
     276:	3d650513          	addi	a0,a0,982 # 1648 <malloc+0x1e2>
     27a:	51f000ef          	jal	f98 <open>
     27e:	84aa                	mv	s1,a0
  if(fd == -1) err("re-open");
     280:	57fd                	li	a5,-1
     282:	54f50c63          	beq	a0,a5,7da <main+0x672>
  if(read(fd, rb, 8) != 8) err("read");
     286:	4621                	li	a2,8
     288:	fc040593          	addi	a1,s0,-64
     28c:	4e5000ef          	jal	f70 <read>
     290:	4721                	li	a4,8
     292:	fc040793          	addi	a5,s0,-64
     296:	fc840613          	addi	a2,s0,-56
    if(rb[i] != 'A') err("private modified file");
     29a:	04100693          	li	a3,65
  if(read(fd, rb, 8) != 8) err("read");
     29e:	54e51663          	bne	a0,a4,7ea <main+0x682>
    if(rb[i] != 'A') err("private modified file");
     2a2:	0007c703          	lbu	a4,0(a5)
     2a6:	54d71a63          	bne	a4,a3,7fa <main+0x692>
  for(int i = 0; i < 8; i++){
     2aa:	0785                	addi	a5,a5,1
     2ac:	fec79be3          	bne	a5,a2,2a2 <main+0x13a>
  close(fd);
     2b0:	8526                	mv	a0,s1
     2b2:	4cf000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     2b6:	00002497          	auipc	s1,0x2
     2ba:	d4a48493          	addi	s1,s1,-694 # 2000 <testname>
     2be:	608c                	ld	a1,0(s1)
     2c0:	00001517          	auipc	a0,0x1
     2c4:	3b050513          	addi	a0,a0,944 # 1670 <malloc+0x20a>
     2c8:	0e6010ef          	jal	13ae <printf>
  testname = "test mmap read-only";
     2cc:	00001797          	auipc	a5,0x1
     2d0:	3ec78793          	addi	a5,a5,1004 # 16b8 <malloc+0x252>
     2d4:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     2d6:	85be                	mv	a1,a5
     2d8:	00001517          	auipc	a0,0x1
     2dc:	36850513          	addi	a0,a0,872 # 1640 <malloc+0x1da>
     2e0:	0ce010ef          	jal	13ae <printf>
  make_test_file(f);
     2e4:	00001517          	auipc	a0,0x1
     2e8:	36450513          	addi	a0,a0,868 # 1648 <malloc+0x1e2>
     2ec:	d47ff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDONLY);
     2f0:	4581                	li	a1,0
     2f2:	00001517          	auipc	a0,0x1
     2f6:	35650513          	addi	a0,a0,854 # 1648 <malloc+0x1e2>
     2fa:	49f000ef          	jal	f98 <open>
     2fe:	84aa                	mv	s1,a0
  if(fd == -1) err("open");
     300:	57fd                	li	a5,-1
     302:	50f50463          	beq	a0,a5,80a <main+0x6a2>
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     306:	4701                	li	a4,0
     308:	86aa                	mv	a3,a0
     30a:	4605                	li	a2,1
     30c:	85b2                	mv	a1,a2
     30e:	6509                	lui	a0,0x2
     310:	4e9000ef          	jal	ff8 <mmap>
     314:	892a                	mv	s2,a0
  if(p == MAP_FAILED) err("mmap");
     316:	57fd                	li	a5,-1
     318:	50f50163          	beq	a0,a5,81a <main+0x6b2>
  verify_content(p);
     31c:	dd9ff0ef          	jal	f4 <verify_content>
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     320:	6589                	lui	a1,0x2
     322:	854a                	mv	a0,s2
     324:	4dd000ef          	jal	1000 <munmap>
     328:	57fd                	li	a5,-1
     32a:	50f50063          	beq	a0,a5,82a <main+0x6c2>
  close(fd);
     32e:	8526                	mv	a0,s1
     330:	451000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     334:	00002497          	auipc	s1,0x2
     338:	ccc48493          	addi	s1,s1,-820 # 2000 <testname>
     33c:	608c                	ld	a1,0(s1)
     33e:	00001517          	auipc	a0,0x1
     342:	33250513          	addi	a0,a0,818 # 1670 <malloc+0x20a>
     346:	068010ef          	jal	13ae <printf>
  testname = "test mmap read/write";
     34a:	00001797          	auipc	a5,0x1
     34e:	38678793          	addi	a5,a5,902 # 16d0 <malloc+0x26a>
     352:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     354:	85be                	mv	a1,a5
     356:	00001517          	auipc	a0,0x1
     35a:	2ea50513          	addi	a0,a0,746 # 1640 <malloc+0x1da>
     35e:	050010ef          	jal	13ae <printf>
  make_test_file(f);
     362:	00001517          	auipc	a0,0x1
     366:	2e650513          	addi	a0,a0,742 # 1648 <malloc+0x1e2>
     36a:	cc9ff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDWR);
     36e:	4589                	li	a1,2
     370:	00001517          	auipc	a0,0x1
     374:	2d850513          	addi	a0,a0,728 # 1648 <malloc+0x1e2>
     378:	421000ef          	jal	f98 <open>
     37c:	892a                	mv	s2,a0
  if(fd == -1) err("open");
     37e:	57fd                	li	a5,-1
     380:	4af50d63          	beq	a0,a5,83a <main+0x6d2>
  char *p = mmap(PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     384:	4701                	li	a4,0
     386:	86aa                	mv	a3,a0
     388:	4605                	li	a2,1
     38a:	458d                	li	a1,3
     38c:	6509                	lui	a0,0x2
     38e:	46b000ef          	jal	ff8 <mmap>
     392:	84aa                	mv	s1,a0
  if(p == MAP_FAILED) err("mmap");
     394:	57fd                	li	a5,-1
     396:	4af50a63          	beq	a0,a5,84a <main+0x6e2>
  verify_content(p);
     39a:	d5bff0ef          	jal	f4 <verify_content>
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++)
     39e:	87a6                	mv	a5,s1
     3a0:	6709                	lui	a4,0x2
     3a2:	80070713          	addi	a4,a4,-2048 # 1800 <malloc+0x39a>
     3a6:	9726                	add	a4,a4,s1
    p[i] = 'B';
     3a8:	04200693          	li	a3,66
     3ac:	00d78023          	sb	a3,0(a5)
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++)
     3b0:	0785                	addi	a5,a5,1
     3b2:	fee79de3          	bne	a5,a4,3ac <main+0x244>
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     3b6:	6589                	lui	a1,0x2
     3b8:	8526                	mv	a0,s1
     3ba:	447000ef          	jal	1000 <munmap>
     3be:	57fd                	li	a5,-1
     3c0:	48f50d63          	beq	a0,a5,85a <main+0x6f2>
  close(fd);
     3c4:	854a                	mv	a0,s2
     3c6:	3bb000ef          	jal	f80 <close>
  fd = open(f, O_RDONLY);
     3ca:	4581                	li	a1,0
     3cc:	00001517          	auipc	a0,0x1
     3d0:	27c50513          	addi	a0,a0,636 # 1648 <malloc+0x1e2>
     3d4:	3c5000ef          	jal	f98 <open>
     3d8:	84aa                	mv	s1,a0
  if(fd == -1) err("re-open");
     3da:	57fd                	li	a5,-1
     3dc:	48f50763          	beq	a0,a5,86a <main+0x702>
  if(read(fd, rb, 8) != 8) err("read");
     3e0:	4621                	li	a2,8
     3e2:	fc040593          	addi	a1,s0,-64
     3e6:	38b000ef          	jal	f70 <read>
     3ea:	4721                	li	a4,8
     3ec:	fc040793          	addi	a5,s0,-64
     3f0:	fc840613          	addi	a2,s0,-56
    if(rb[i] != 'B') err("shared write not flushed");
     3f4:	04200693          	li	a3,66
  if(read(fd, rb, 8) != 8) err("read");
     3f8:	48e51163          	bne	a0,a4,87a <main+0x712>
    if(rb[i] != 'B') err("shared write not flushed");
     3fc:	0007c703          	lbu	a4,0(a5)
     400:	48d71563          	bne	a4,a3,88a <main+0x722>
  for(int i = 0; i < 8; i++){
     404:	0785                	addi	a5,a5,1
     406:	fec79be3          	bne	a5,a2,3fc <main+0x294>
  close(fd);
     40a:	8526                	mv	a0,s1
     40c:	375000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     410:	00002497          	auipc	s1,0x2
     414:	bf048493          	addi	s1,s1,-1040 # 2000 <testname>
     418:	608c                	ld	a1,0(s1)
     41a:	00001517          	auipc	a0,0x1
     41e:	25650513          	addi	a0,a0,598 # 1670 <malloc+0x20a>
     422:	78d000ef          	jal	13ae <printf>
  testname = "test mmap dirty";
     426:	00001797          	auipc	a5,0x1
     42a:	2e278793          	addi	a5,a5,738 # 1708 <malloc+0x2a2>
     42e:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     430:	85be                	mv	a1,a5
     432:	00001517          	auipc	a0,0x1
     436:	20e50513          	addi	a0,a0,526 # 1640 <malloc+0x1da>
     43a:	775000ef          	jal	13ae <printf>
  make_test_file(f);
     43e:	00001517          	auipc	a0,0x1
     442:	20a50513          	addi	a0,a0,522 # 1648 <malloc+0x1e2>
     446:	bedff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDWR);
     44a:	4589                	li	a1,2
     44c:	00001517          	auipc	a0,0x1
     450:	1fc50513          	addi	a0,a0,508 # 1648 <malloc+0x1e2>
     454:	345000ef          	jal	f98 <open>
     458:	84aa                	mv	s1,a0
  if(fd == -1) err("open");
     45a:	57fd                	li	a5,-1
     45c:	42f50f63          	beq	a0,a5,89a <main+0x732>
  char *p = mmap(PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     460:	4701                	li	a4,0
     462:	86aa                	mv	a3,a0
     464:	4605                	li	a2,1
     466:	458d                	li	a1,3
     468:	6509                	lui	a0,0x2
     46a:	38f000ef          	jal	ff8 <mmap>
  if(p == MAP_FAILED) err("mmap");
     46e:	57fd                	li	a5,-1
     470:	42f50d63          	beq	a0,a5,8aa <main+0x742>
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     474:	6589                	lui	a1,0x2
     476:	38b000ef          	jal	1000 <munmap>
     47a:	57fd                	li	a5,-1
     47c:	42f50f63          	beq	a0,a5,8ba <main+0x752>
  close(fd);
     480:	8526                	mv	a0,s1
     482:	2ff000ef          	jal	f80 <close>
  fd = open(f, O_RDONLY);
     486:	4581                	li	a1,0
     488:	00001517          	auipc	a0,0x1
     48c:	1c050513          	addi	a0,a0,448 # 1648 <malloc+0x1e2>
     490:	309000ef          	jal	f98 <open>
     494:	84aa                	mv	s1,a0
  if(fd == -1) err("re-open");
     496:	57fd                	li	a5,-1
     498:	42f50963          	beq	a0,a5,8ca <main+0x762>
  if(read(fd, rb, 8) != 8) err("read");
     49c:	4621                	li	a2,8
     49e:	fc040593          	addi	a1,s0,-64
     4a2:	2cf000ef          	jal	f70 <read>
     4a6:	4721                	li	a4,8
     4a8:	fc040793          	addi	a5,s0,-64
     4ac:	fc840613          	addi	a2,s0,-56
    if(rb[i] != 'A') err("non-dirty corrupted file");
     4b0:	04100693          	li	a3,65
  if(read(fd, rb, 8) != 8) err("read");
     4b4:	42e51363          	bne	a0,a4,8da <main+0x772>
    if(rb[i] != 'A') err("non-dirty corrupted file");
     4b8:	0007c703          	lbu	a4,0(a5)
     4bc:	42d71763          	bne	a4,a3,8ea <main+0x782>
  for(int i = 0; i < 8; i++){
     4c0:	0785                	addi	a5,a5,1
     4c2:	fec79be3          	bne	a5,a2,4b8 <main+0x350>
  close(fd);
     4c6:	8526                	mv	a0,s1
     4c8:	2b9000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     4cc:	00002497          	auipc	s1,0x2
     4d0:	b3448493          	addi	s1,s1,-1228 # 2000 <testname>
     4d4:	608c                	ld	a1,0(s1)
     4d6:	00001517          	auipc	a0,0x1
     4da:	19a50513          	addi	a0,a0,410 # 1670 <malloc+0x20a>
     4de:	6d1000ef          	jal	13ae <printf>
  testname = "test not-mapped unmap";
     4e2:	00001797          	auipc	a5,0x1
     4e6:	25678793          	addi	a5,a5,598 # 1738 <malloc+0x2d2>
     4ea:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     4ec:	85be                	mv	a1,a5
     4ee:	00001517          	auipc	a0,0x1
     4f2:	15250513          	addi	a0,a0,338 # 1640 <malloc+0x1da>
     4f6:	6b9000ef          	jal	13ae <printf>
  if(munmap((void*)0x10000000UL, PGSIZE) != -1)
     4fa:	6585                	lui	a1,0x1
     4fc:	10000537          	lui	a0,0x10000
     500:	301000ef          	jal	1000 <munmap>
     504:	57fd                	li	a5,-1
     506:	3ef51a63          	bne	a0,a5,8fa <main+0x792>
  printf("%s: OK\n", testname);
     50a:	00002497          	auipc	s1,0x2
     50e:	af648493          	addi	s1,s1,-1290 # 2000 <testname>
     512:	608c                	ld	a1,0(s1)
     514:	00001517          	auipc	a0,0x1
     518:	15c50513          	addi	a0,a0,348 # 1670 <malloc+0x20a>
     51c:	693000ef          	jal	13ae <printf>
  testname = "test lazy access";
     520:	00001797          	auipc	a5,0x1
     524:	25078793          	addi	a5,a5,592 # 1770 <malloc+0x30a>
     528:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     52a:	85be                	mv	a1,a5
     52c:	00001517          	auipc	a0,0x1
     530:	11450513          	addi	a0,a0,276 # 1640 <malloc+0x1da>
     534:	67b000ef          	jal	13ae <printf>
  make_test_file(f);
     538:	00001517          	auipc	a0,0x1
     53c:	11050513          	addi	a0,a0,272 # 1648 <malloc+0x1e2>
     540:	af3ff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDONLY);
     544:	4581                	li	a1,0
     546:	00001517          	auipc	a0,0x1
     54a:	10250513          	addi	a0,a0,258 # 1648 <malloc+0x1e2>
     54e:	24b000ef          	jal	f98 <open>
     552:	84aa                	mv	s1,a0
  if(fd == -1) err("open");
     554:	57fd                	li	a5,-1
     556:	3af50a63          	beq	a0,a5,90a <main+0x7a2>
  char *p = mmap(PGSIZE*3, PROT_READ, MAP_PRIVATE, fd, 0);
     55a:	4701                	li	a4,0
     55c:	86aa                	mv	a3,a0
     55e:	4609                	li	a2,2
     560:	4585                	li	a1,1
     562:	650d                	lui	a0,0x3
     564:	295000ef          	jal	ff8 <mmap>
  if(p == MAP_FAILED) err("mmap");
     568:	57fd                	li	a5,-1
     56a:	3af50863          	beq	a0,a5,91a <main+0x7b2>
  if(p[0] != 'A') err("read");
     56e:	00054703          	lbu	a4,0(a0) # 3000 <buf+0xfe0>
     572:	04100793          	li	a5,65
     576:	3af71a63          	bne	a4,a5,92a <main+0x7c2>
  if(munmap(p, PGSIZE*3) == -1) err("munmap");
     57a:	658d                	lui	a1,0x3
     57c:	285000ef          	jal	1000 <munmap>
     580:	57fd                	li	a5,-1
     582:	3af50c63          	beq	a0,a5,93a <main+0x7d2>
  close(fd);
     586:	8526                	mv	a0,s1
     588:	1f9000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     58c:	00002497          	auipc	s1,0x2
     590:	a7448493          	addi	s1,s1,-1420 # 2000 <testname>
     594:	608c                	ld	a1,0(s1)
     596:	00001517          	auipc	a0,0x1
     59a:	0da50513          	addi	a0,a0,218 # 1670 <malloc+0x20a>
     59e:	611000ef          	jal	13ae <printf>
  testname = "test mmap two files";
     5a2:	00001797          	auipc	a5,0x1
     5a6:	1e678793          	addi	a5,a5,486 # 1788 <malloc+0x322>
     5aa:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     5ac:	85be                	mv	a1,a5
     5ae:	00001517          	auipc	a0,0x1
     5b2:	09250513          	addi	a0,a0,146 # 1640 <malloc+0x1da>
     5b6:	5f9000ef          	jal	13ae <printf>
  unlink(f1);
     5ba:	00001517          	auipc	a0,0x1
     5be:	1e650513          	addi	a0,a0,486 # 17a0 <malloc+0x33a>
     5c2:	1e7000ef          	jal	fa8 <unlink>
  unlink(f2);
     5c6:	00001517          	auipc	a0,0x1
     5ca:	1ea50513          	addi	a0,a0,490 # 17b0 <malloc+0x34a>
     5ce:	1db000ef          	jal	fa8 <unlink>
  int fd1 = open(f1, O_RDWR | O_CREATE | O_TRUNC);
     5d2:	60200593          	li	a1,1538
     5d6:	00001517          	auipc	a0,0x1
     5da:	1ca50513          	addi	a0,a0,458 # 17a0 <malloc+0x33a>
     5de:	1bb000ef          	jal	f98 <open>
     5e2:	892a                	mv	s2,a0
  if(fd1 == -1) err("open f1");
     5e4:	57fd                	li	a5,-1
     5e6:	36f50263          	beq	a0,a5,94a <main+0x7e2>
  memset(buf, 'X', PGSIZE);
     5ea:	6605                	lui	a2,0x1
     5ec:	05800593          	li	a1,88
     5f0:	00002517          	auipc	a0,0x2
     5f4:	a3050513          	addi	a0,a0,-1488 # 2020 <buf>
     5f8:	736000ef          	jal	d2e <memset>
  if(write(fd1, buf, PGSIZE) != PGSIZE) err("write f1");
     5fc:	6605                	lui	a2,0x1
     5fe:	00002597          	auipc	a1,0x2
     602:	a2258593          	addi	a1,a1,-1502 # 2020 <buf>
     606:	854a                	mv	a0,s2
     608:	171000ef          	jal	f78 <write>
     60c:	6785                	lui	a5,0x1
     60e:	34f51663          	bne	a0,a5,95a <main+0x7f2>
  int fd2 = open(f2, O_RDWR | O_CREATE | O_TRUNC);
     612:	60200593          	li	a1,1538
     616:	00001517          	auipc	a0,0x1
     61a:	19a50513          	addi	a0,a0,410 # 17b0 <malloc+0x34a>
     61e:	17b000ef          	jal	f98 <open>
     622:	84aa                	mv	s1,a0
  if(fd2 == -1) err("open f2");
     624:	57fd                	li	a5,-1
     626:	34f50263          	beq	a0,a5,96a <main+0x802>
  memset(buf, 'Y', PGSIZE);
     62a:	6605                	lui	a2,0x1
     62c:	05900593          	li	a1,89
     630:	00002517          	auipc	a0,0x2
     634:	9f050513          	addi	a0,a0,-1552 # 2020 <buf>
     638:	6f6000ef          	jal	d2e <memset>
  if(write(fd2, buf, PGSIZE) != PGSIZE) err("write f2");
     63c:	6605                	lui	a2,0x1
     63e:	00002597          	auipc	a1,0x2
     642:	9e258593          	addi	a1,a1,-1566 # 2020 <buf>
     646:	8526                	mv	a0,s1
     648:	131000ef          	jal	f78 <write>
     64c:	6785                	lui	a5,0x1
     64e:	32f51663          	bne	a0,a5,97a <main+0x812>
     652:	f44e                	sd	s3,40(sp)
  char *p1 = mmap(PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     654:	4701                	li	a4,0
     656:	86ca                	mv	a3,s2
     658:	4609                	li	a2,2
     65a:	4585                	li	a1,1
     65c:	6505                	lui	a0,0x1
     65e:	19b000ef          	jal	ff8 <mmap>
     662:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED) err("mmap f1");
     664:	57fd                	li	a5,-1
     666:	32f50263          	beq	a0,a5,98a <main+0x822>
     66a:	f052                	sd	s4,32(sp)
  char *p2 = mmap(PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     66c:	4701                	li	a4,0
     66e:	86a6                	mv	a3,s1
     670:	4609                	li	a2,2
     672:	4585                	li	a1,1
     674:	6505                	lui	a0,0x1
     676:	183000ef          	jal	ff8 <mmap>
     67a:	8a2a                	mv	s4,a0
  if(p2 == MAP_FAILED) err("mmap f2");
     67c:	57fd                	li	a5,-1
     67e:	30f50d63          	beq	a0,a5,998 <main+0x830>
     682:	87ce                	mv	a5,s3
     684:	872a                	mv	a4,a0
     686:	6605                	lui	a2,0x1
     688:	964e                	add	a2,a2,s3
    if(p1[i] != 'X') err("p1");
     68a:	05800513          	li	a0,88
    if(p2[i] != 'Y') err("p2");
     68e:	05900593          	li	a1,89
    if(p1[i] != 'X') err("p1");
     692:	0007c683          	lbu	a3,0(a5) # 1000 <munmap>
     696:	30a69763          	bne	a3,a0,9a4 <main+0x83c>
    if(p2[i] != 'Y') err("p2");
     69a:	00074683          	lbu	a3,0(a4)
     69e:	30b69963          	bne	a3,a1,9b0 <main+0x848>
  for(int i = 0; i < PGSIZE; i++){
     6a2:	0785                	addi	a5,a5,1
     6a4:	0705                	addi	a4,a4,1
     6a6:	fec796e3          	bne	a5,a2,692 <main+0x52a>
  if(munmap(p1, PGSIZE) == -1) err("munmap f1");
     6aa:	6585                	lui	a1,0x1
     6ac:	854e                	mv	a0,s3
     6ae:	153000ef          	jal	1000 <munmap>
     6b2:	57fd                	li	a5,-1
     6b4:	30f50463          	beq	a0,a5,9bc <main+0x854>
  if(munmap(p2, PGSIZE) == -1) err("munmap f2");
     6b8:	6585                	lui	a1,0x1
     6ba:	8552                	mv	a0,s4
     6bc:	145000ef          	jal	1000 <munmap>
     6c0:	57fd                	li	a5,-1
     6c2:	30f50363          	beq	a0,a5,9c8 <main+0x860>
  close(fd1);
     6c6:	854a                	mv	a0,s2
     6c8:	0b9000ef          	jal	f80 <close>
  close(fd2);
     6cc:	8526                	mv	a0,s1
     6ce:	0b3000ef          	jal	f80 <close>
  unlink(f1);
     6d2:	00001517          	auipc	a0,0x1
     6d6:	0ce50513          	addi	a0,a0,206 # 17a0 <malloc+0x33a>
     6da:	0cf000ef          	jal	fa8 <unlink>
  unlink(f2);
     6de:	00001517          	auipc	a0,0x1
     6e2:	0d250513          	addi	a0,a0,210 # 17b0 <malloc+0x34a>
     6e6:	0c3000ef          	jal	fa8 <unlink>
  printf("%s: OK\n", testname);
     6ea:	00002497          	auipc	s1,0x2
     6ee:	91648493          	addi	s1,s1,-1770 # 2000 <testname>
     6f2:	608c                	ld	a1,0(s1)
     6f4:	00001517          	auipc	a0,0x1
     6f8:	f7c50513          	addi	a0,a0,-132 # 1670 <malloc+0x20a>
     6fc:	4b3000ef          	jal	13ae <printf>
  testname = "test fork";
     700:	00001797          	auipc	a5,0x1
     704:	13078793          	addi	a5,a5,304 # 1830 <malloc+0x3ca>
     708:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     70a:	85be                	mv	a1,a5
     70c:	00001517          	auipc	a0,0x1
     710:	f3450513          	addi	a0,a0,-204 # 1640 <malloc+0x1da>
     714:	49b000ef          	jal	13ae <printf>
  make_test_file(f);
     718:	00001517          	auipc	a0,0x1
     71c:	f3050513          	addi	a0,a0,-208 # 1648 <malloc+0x1e2>
     720:	913ff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDONLY);
     724:	4581                	li	a1,0
     726:	00001517          	auipc	a0,0x1
     72a:	f2250513          	addi	a0,a0,-222 # 1648 <malloc+0x1e2>
     72e:	06b000ef          	jal	f98 <open>
     732:	892a                	mv	s2,a0
  if(fd == -1) err("open");
     734:	57fd                	li	a5,-1
     736:	28f50f63          	beq	a0,a5,9d4 <main+0x86c>
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     73a:	4701                	li	a4,0
     73c:	86aa                	mv	a3,a0
     73e:	4609                	li	a2,2
     740:	4585                	li	a1,1
     742:	6509                	lui	a0,0x2
     744:	0b5000ef          	jal	ff8 <mmap>
     748:	84aa                	mv	s1,a0
  if(p == MAP_FAILED) err("mmap");
     74a:	57fd                	li	a5,-1
     74c:	28f50a63          	beq	a0,a5,9e0 <main+0x878>
  int pid = fork();
     750:	001000ef          	jal	f50 <fork>
  if(pid < 0) err("fork");
     754:	28054c63          	bltz	a0,9ec <main+0x884>
  if(pid == 0){
     758:	2a051663          	bnez	a0,a04 <main+0x89c>
    verify_content(p);
     75c:	8526                	mv	a0,s1
     75e:	997ff0ef          	jal	f4 <verify_content>
    if(munmap(p, PGSIZE*2) == -1) err("munmap child");
     762:	6589                	lui	a1,0x2
     764:	8526                	mv	a0,s1
     766:	09b000ef          	jal	1000 <munmap>
     76a:	57fd                	li	a5,-1
     76c:	28f50663          	beq	a0,a5,9f8 <main+0x890>
    exit(0);
     770:	4501                	li	a0,0
     772:	7e6000ef          	jal	f58 <exit>
     776:	fc26                	sd	s1,56(sp)
     778:	f84a                	sd	s2,48(sp)
     77a:	f44e                	sd	s3,40(sp)
     77c:	f052                	sd	s4,32(sp)
  if(fd == -1) err("open");
     77e:	00001517          	auipc	a0,0x1
     782:	eda50513          	addi	a0,a0,-294 # 1658 <malloc+0x1f2>
     786:	87bff0ef          	jal	0 <err>
     78a:	f44e                	sd	s3,40(sp)
     78c:	f052                	sd	s4,32(sp)
  if(p == MAP_FAILED) err("mmap");
     78e:	00001517          	auipc	a0,0x1
     792:	ed250513          	addi	a0,a0,-302 # 1660 <malloc+0x1fa>
     796:	86bff0ef          	jal	0 <err>
     79a:	f44e                	sd	s3,40(sp)
     79c:	f052                	sd	s4,32(sp)
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     79e:	00001517          	auipc	a0,0x1
     7a2:	eca50513          	addi	a0,a0,-310 # 1668 <malloc+0x202>
     7a6:	85bff0ef          	jal	0 <err>
     7aa:	f44e                	sd	s3,40(sp)
     7ac:	f052                	sd	s4,32(sp)
  if(fd == -1) err("open");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	eaa50513          	addi	a0,a0,-342 # 1658 <malloc+0x1f2>
     7b6:	84bff0ef          	jal	0 <err>
     7ba:	f44e                	sd	s3,40(sp)
     7bc:	f052                	sd	s4,32(sp)
  if(p == MAP_FAILED) err("mmap");
     7be:	00001517          	auipc	a0,0x1
     7c2:	ea250513          	addi	a0,a0,-350 # 1660 <malloc+0x1fa>
     7c6:	83bff0ef          	jal	0 <err>
     7ca:	f44e                	sd	s3,40(sp)
     7cc:	f052                	sd	s4,32(sp)
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     7ce:	00001517          	auipc	a0,0x1
     7d2:	e9a50513          	addi	a0,a0,-358 # 1668 <malloc+0x202>
     7d6:	82bff0ef          	jal	0 <err>
     7da:	f44e                	sd	s3,40(sp)
     7dc:	f052                	sd	s4,32(sp)
  if(fd == -1) err("re-open");
     7de:	00001517          	auipc	a0,0x1
     7e2:	eb250513          	addi	a0,a0,-334 # 1690 <malloc+0x22a>
     7e6:	81bff0ef          	jal	0 <err>
     7ea:	f44e                	sd	s3,40(sp)
     7ec:	f052                	sd	s4,32(sp)
  if(read(fd, rb, 8) != 8) err("read");
     7ee:	00001517          	auipc	a0,0x1
     7f2:	eaa50513          	addi	a0,a0,-342 # 1698 <malloc+0x232>
     7f6:	80bff0ef          	jal	0 <err>
     7fa:	f44e                	sd	s3,40(sp)
     7fc:	f052                	sd	s4,32(sp)
    if(rb[i] != 'A') err("private modified file");
     7fe:	00001517          	auipc	a0,0x1
     802:	ea250513          	addi	a0,a0,-350 # 16a0 <malloc+0x23a>
     806:	ffaff0ef          	jal	0 <err>
     80a:	f44e                	sd	s3,40(sp)
     80c:	f052                	sd	s4,32(sp)
  if(fd == -1) err("open");
     80e:	00001517          	auipc	a0,0x1
     812:	e4a50513          	addi	a0,a0,-438 # 1658 <malloc+0x1f2>
     816:	feaff0ef          	jal	0 <err>
     81a:	f44e                	sd	s3,40(sp)
     81c:	f052                	sd	s4,32(sp)
  if(p == MAP_FAILED) err("mmap");
     81e:	00001517          	auipc	a0,0x1
     822:	e4250513          	addi	a0,a0,-446 # 1660 <malloc+0x1fa>
     826:	fdaff0ef          	jal	0 <err>
     82a:	f44e                	sd	s3,40(sp)
     82c:	f052                	sd	s4,32(sp)
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     82e:	00001517          	auipc	a0,0x1
     832:	e3a50513          	addi	a0,a0,-454 # 1668 <malloc+0x202>
     836:	fcaff0ef          	jal	0 <err>
     83a:	f44e                	sd	s3,40(sp)
     83c:	f052                	sd	s4,32(sp)
  if(fd == -1) err("open");
     83e:	00001517          	auipc	a0,0x1
     842:	e1a50513          	addi	a0,a0,-486 # 1658 <malloc+0x1f2>
     846:	fbaff0ef          	jal	0 <err>
     84a:	f44e                	sd	s3,40(sp)
     84c:	f052                	sd	s4,32(sp)
  if(p == MAP_FAILED) err("mmap");
     84e:	00001517          	auipc	a0,0x1
     852:	e1250513          	addi	a0,a0,-494 # 1660 <malloc+0x1fa>
     856:	faaff0ef          	jal	0 <err>
     85a:	f44e                	sd	s3,40(sp)
     85c:	f052                	sd	s4,32(sp)
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     85e:	00001517          	auipc	a0,0x1
     862:	e0a50513          	addi	a0,a0,-502 # 1668 <malloc+0x202>
     866:	f9aff0ef          	jal	0 <err>
     86a:	f44e                	sd	s3,40(sp)
     86c:	f052                	sd	s4,32(sp)
  if(fd == -1) err("re-open");
     86e:	00001517          	auipc	a0,0x1
     872:	e2250513          	addi	a0,a0,-478 # 1690 <malloc+0x22a>
     876:	f8aff0ef          	jal	0 <err>
     87a:	f44e                	sd	s3,40(sp)
     87c:	f052                	sd	s4,32(sp)
  if(read(fd, rb, 8) != 8) err("read");
     87e:	00001517          	auipc	a0,0x1
     882:	e1a50513          	addi	a0,a0,-486 # 1698 <malloc+0x232>
     886:	f7aff0ef          	jal	0 <err>
     88a:	f44e                	sd	s3,40(sp)
     88c:	f052                	sd	s4,32(sp)
    if(rb[i] != 'B') err("shared write not flushed");
     88e:	00001517          	auipc	a0,0x1
     892:	e5a50513          	addi	a0,a0,-422 # 16e8 <malloc+0x282>
     896:	f6aff0ef          	jal	0 <err>
     89a:	f44e                	sd	s3,40(sp)
     89c:	f052                	sd	s4,32(sp)
  if(fd == -1) err("open");
     89e:	00001517          	auipc	a0,0x1
     8a2:	dba50513          	addi	a0,a0,-582 # 1658 <malloc+0x1f2>
     8a6:	f5aff0ef          	jal	0 <err>
     8aa:	f44e                	sd	s3,40(sp)
     8ac:	f052                	sd	s4,32(sp)
  if(p == MAP_FAILED) err("mmap");
     8ae:	00001517          	auipc	a0,0x1
     8b2:	db250513          	addi	a0,a0,-590 # 1660 <malloc+0x1fa>
     8b6:	f4aff0ef          	jal	0 <err>
     8ba:	f44e                	sd	s3,40(sp)
     8bc:	f052                	sd	s4,32(sp)
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
     8be:	00001517          	auipc	a0,0x1
     8c2:	daa50513          	addi	a0,a0,-598 # 1668 <malloc+0x202>
     8c6:	f3aff0ef          	jal	0 <err>
     8ca:	f44e                	sd	s3,40(sp)
     8cc:	f052                	sd	s4,32(sp)
  if(fd == -1) err("re-open");
     8ce:	00001517          	auipc	a0,0x1
     8d2:	dc250513          	addi	a0,a0,-574 # 1690 <malloc+0x22a>
     8d6:	f2aff0ef          	jal	0 <err>
     8da:	f44e                	sd	s3,40(sp)
     8dc:	f052                	sd	s4,32(sp)
  if(read(fd, rb, 8) != 8) err("read");
     8de:	00001517          	auipc	a0,0x1
     8e2:	dba50513          	addi	a0,a0,-582 # 1698 <malloc+0x232>
     8e6:	f1aff0ef          	jal	0 <err>
     8ea:	f44e                	sd	s3,40(sp)
     8ec:	f052                	sd	s4,32(sp)
    if(rb[i] != 'A') err("non-dirty corrupted file");
     8ee:	00001517          	auipc	a0,0x1
     8f2:	e2a50513          	addi	a0,a0,-470 # 1718 <malloc+0x2b2>
     8f6:	f0aff0ef          	jal	0 <err>
     8fa:	f44e                	sd	s3,40(sp)
     8fc:	f052                	sd	s4,32(sp)
    err("unmap of unmapped should fail");
     8fe:	00001517          	auipc	a0,0x1
     902:	e5250513          	addi	a0,a0,-430 # 1750 <malloc+0x2ea>
     906:	efaff0ef          	jal	0 <err>
     90a:	f44e                	sd	s3,40(sp)
     90c:	f052                	sd	s4,32(sp)
  if(fd == -1) err("open");
     90e:	00001517          	auipc	a0,0x1
     912:	d4a50513          	addi	a0,a0,-694 # 1658 <malloc+0x1f2>
     916:	eeaff0ef          	jal	0 <err>
     91a:	f44e                	sd	s3,40(sp)
     91c:	f052                	sd	s4,32(sp)
  if(p == MAP_FAILED) err("mmap");
     91e:	00001517          	auipc	a0,0x1
     922:	d4250513          	addi	a0,a0,-702 # 1660 <malloc+0x1fa>
     926:	edaff0ef          	jal	0 <err>
     92a:	f44e                	sd	s3,40(sp)
     92c:	f052                	sd	s4,32(sp)
  if(p[0] != 'A') err("read");
     92e:	00001517          	auipc	a0,0x1
     932:	d6a50513          	addi	a0,a0,-662 # 1698 <malloc+0x232>
     936:	ecaff0ef          	jal	0 <err>
     93a:	f44e                	sd	s3,40(sp)
     93c:	f052                	sd	s4,32(sp)
  if(munmap(p, PGSIZE*3) == -1) err("munmap");
     93e:	00001517          	auipc	a0,0x1
     942:	d2a50513          	addi	a0,a0,-726 # 1668 <malloc+0x202>
     946:	ebaff0ef          	jal	0 <err>
     94a:	f44e                	sd	s3,40(sp)
     94c:	f052                	sd	s4,32(sp)
  if(fd1 == -1) err("open f1");
     94e:	00001517          	auipc	a0,0x1
     952:	e7250513          	addi	a0,a0,-398 # 17c0 <malloc+0x35a>
     956:	eaaff0ef          	jal	0 <err>
     95a:	f44e                	sd	s3,40(sp)
     95c:	f052                	sd	s4,32(sp)
  if(write(fd1, buf, PGSIZE) != PGSIZE) err("write f1");
     95e:	00001517          	auipc	a0,0x1
     962:	e6a50513          	addi	a0,a0,-406 # 17c8 <malloc+0x362>
     966:	e9aff0ef          	jal	0 <err>
     96a:	f44e                	sd	s3,40(sp)
     96c:	f052                	sd	s4,32(sp)
  if(fd2 == -1) err("open f2");
     96e:	00001517          	auipc	a0,0x1
     972:	e6a50513          	addi	a0,a0,-406 # 17d8 <malloc+0x372>
     976:	e8aff0ef          	jal	0 <err>
     97a:	f44e                	sd	s3,40(sp)
     97c:	f052                	sd	s4,32(sp)
  if(write(fd2, buf, PGSIZE) != PGSIZE) err("write f2");
     97e:	00001517          	auipc	a0,0x1
     982:	e6250513          	addi	a0,a0,-414 # 17e0 <malloc+0x37a>
     986:	e7aff0ef          	jal	0 <err>
     98a:	f052                	sd	s4,32(sp)
  if(p1 == MAP_FAILED) err("mmap f1");
     98c:	00001517          	auipc	a0,0x1
     990:	e6450513          	addi	a0,a0,-412 # 17f0 <malloc+0x38a>
     994:	e6cff0ef          	jal	0 <err>
  if(p2 == MAP_FAILED) err("mmap f2");
     998:	00001517          	auipc	a0,0x1
     99c:	e6050513          	addi	a0,a0,-416 # 17f8 <malloc+0x392>
     9a0:	e60ff0ef          	jal	0 <err>
    if(p1[i] != 'X') err("p1");
     9a4:	00001517          	auipc	a0,0x1
     9a8:	e5c50513          	addi	a0,a0,-420 # 1800 <malloc+0x39a>
     9ac:	e54ff0ef          	jal	0 <err>
    if(p2[i] != 'Y') err("p2");
     9b0:	00001517          	auipc	a0,0x1
     9b4:	e5850513          	addi	a0,a0,-424 # 1808 <malloc+0x3a2>
     9b8:	e48ff0ef          	jal	0 <err>
  if(munmap(p1, PGSIZE) == -1) err("munmap f1");
     9bc:	00001517          	auipc	a0,0x1
     9c0:	e5450513          	addi	a0,a0,-428 # 1810 <malloc+0x3aa>
     9c4:	e3cff0ef          	jal	0 <err>
  if(munmap(p2, PGSIZE) == -1) err("munmap f2");
     9c8:	00001517          	auipc	a0,0x1
     9cc:	e5850513          	addi	a0,a0,-424 # 1820 <malloc+0x3ba>
     9d0:	e30ff0ef          	jal	0 <err>
  if(fd == -1) err("open");
     9d4:	00001517          	auipc	a0,0x1
     9d8:	c8450513          	addi	a0,a0,-892 # 1658 <malloc+0x1f2>
     9dc:	e24ff0ef          	jal	0 <err>
  if(p == MAP_FAILED) err("mmap");
     9e0:	00001517          	auipc	a0,0x1
     9e4:	c8050513          	addi	a0,a0,-896 # 1660 <malloc+0x1fa>
     9e8:	e18ff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     9ec:	00001517          	auipc	a0,0x1
     9f0:	e5450513          	addi	a0,a0,-428 # 1840 <malloc+0x3da>
     9f4:	e0cff0ef          	jal	0 <err>
    if(munmap(p, PGSIZE*2) == -1) err("munmap child");
     9f8:	00001517          	auipc	a0,0x1
     9fc:	e5050513          	addi	a0,a0,-432 # 1848 <malloc+0x3e2>
     a00:	e00ff0ef          	jal	0 <err>
  wait(&status);
     a04:	fc040513          	addi	a0,s0,-64
     a08:	558000ef          	jal	f60 <wait>
  if(status != 0) err("child exit");
     a0c:	fc042783          	lw	a5,-64(s0)
     a10:	ebc5                	bnez	a5,ac0 <main+0x958>
  verify_content(p);
     a12:	8526                	mv	a0,s1
     a14:	ee0ff0ef          	jal	f4 <verify_content>
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
     a18:	6589                	lui	a1,0x2
     a1a:	8526                	mv	a0,s1
     a1c:	5e4000ef          	jal	1000 <munmap>
     a20:	57fd                	li	a5,-1
     a22:	0af50563          	beq	a0,a5,acc <main+0x964>
  close(fd);
     a26:	854a                	mv	a0,s2
     a28:	558000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     a2c:	00001497          	auipc	s1,0x1
     a30:	5d448493          	addi	s1,s1,1492 # 2000 <testname>
     a34:	608c                	ld	a1,0(s1)
     a36:	00001517          	auipc	a0,0x1
     a3a:	c3a50513          	addi	a0,a0,-966 # 1670 <malloc+0x20a>
     a3e:	171000ef          	jal	13ae <printf>
  testname = "test munmap prevents access";
     a42:	00001797          	auipc	a5,0x1
     a46:	e3678793          	addi	a5,a5,-458 # 1878 <malloc+0x412>
     a4a:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     a4c:	85be                	mv	a1,a5
     a4e:	00001517          	auipc	a0,0x1
     a52:	bf250513          	addi	a0,a0,-1038 # 1640 <malloc+0x1da>
     a56:	159000ef          	jal	13ae <printf>
  make_test_file(f);
     a5a:	00001517          	auipc	a0,0x1
     a5e:	bee50513          	addi	a0,a0,-1042 # 1648 <malloc+0x1e2>
     a62:	dd0ff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDONLY);
     a66:	4581                	li	a1,0
     a68:	00001517          	auipc	a0,0x1
     a6c:	be050513          	addi	a0,a0,-1056 # 1648 <malloc+0x1e2>
     a70:	528000ef          	jal	f98 <open>
     a74:	892a                	mv	s2,a0
  if(fd == -1) err("open");
     a76:	57fd                	li	a5,-1
     a78:	06f50063          	beq	a0,a5,ad8 <main+0x970>
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     a7c:	4701                	li	a4,0
     a7e:	86aa                	mv	a3,a0
     a80:	4609                	li	a2,2
     a82:	4585                	li	a1,1
     a84:	6509                	lui	a0,0x2
     a86:	572000ef          	jal	ff8 <mmap>
     a8a:	84aa                	mv	s1,a0
  if(p == MAP_FAILED) err("mmap");
     a8c:	57fd                	li	a5,-1
     a8e:	04f50b63          	beq	a0,a5,ae4 <main+0x97c>
  int pid = fork();
     a92:	4be000ef          	jal	f50 <fork>
  if(pid < 0) err("fork");
     a96:	04054d63          	bltz	a0,af0 <main+0x988>
  if(pid == 0){
     a9a:	e525                	bnez	a0,b02 <main+0x99a>
    if(munmap(p, PGSIZE*2) == -1) exit(1);
     a9c:	6589                	lui	a1,0x2
     a9e:	8526                	mv	a0,s1
     aa0:	560000ef          	jal	1000 <munmap>
     aa4:	57fd                	li	a5,-1
     aa6:	04f50b63          	beq	a0,a5,afc <main+0x994>
    volatile char c = p[PGSIZE]; // should fault
     aaa:	6785                	lui	a5,0x1
     aac:	97a6                	add	a5,a5,s1
     aae:	0007c783          	lbu	a5,0(a5) # 1000 <munmap>
     ab2:	fcf40023          	sb	a5,-64(s0)
    (void)c;
     ab6:	fc044783          	lbu	a5,-64(s0)
    exit(0);
     aba:	4501                	li	a0,0
     abc:	49c000ef          	jal	f58 <exit>
  if(status != 0) err("child exit");
     ac0:	00001517          	auipc	a0,0x1
     ac4:	d9850513          	addi	a0,a0,-616 # 1858 <malloc+0x3f2>
     ac8:	d38ff0ef          	jal	0 <err>
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
     acc:	00001517          	auipc	a0,0x1
     ad0:	d9c50513          	addi	a0,a0,-612 # 1868 <malloc+0x402>
     ad4:	d2cff0ef          	jal	0 <err>
  if(fd == -1) err("open");
     ad8:	00001517          	auipc	a0,0x1
     adc:	b8050513          	addi	a0,a0,-1152 # 1658 <malloc+0x1f2>
     ae0:	d20ff0ef          	jal	0 <err>
  if(p == MAP_FAILED) err("mmap");
     ae4:	00001517          	auipc	a0,0x1
     ae8:	b7c50513          	addi	a0,a0,-1156 # 1660 <malloc+0x1fa>
     aec:	d14ff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     af0:	00001517          	auipc	a0,0x1
     af4:	d5050513          	addi	a0,a0,-688 # 1840 <malloc+0x3da>
     af8:	d08ff0ef          	jal	0 <err>
    if(munmap(p, PGSIZE*2) == -1) exit(1);
     afc:	4505                	li	a0,1
     afe:	45a000ef          	jal	f58 <exit>
  wait(&status);
     b02:	fc040513          	addi	a0,s0,-64
     b06:	45a000ef          	jal	f60 <wait>
  if(status == 0) err("child should have been killed");
     b0a:	fc042783          	lw	a5,-64(s0)
     b0e:	c795                	beqz	a5,b3a <main+0x9d2>
  pid = fork();
     b10:	440000ef          	jal	f50 <fork>
  if(pid < 0) err("fork");
     b14:	02054963          	bltz	a0,b46 <main+0x9de>
  if(pid == 0){
     b18:	e121                	bnez	a0,b58 <main+0x9f0>
    if(munmap(p, PGSIZE*2) == -1) exit(1);
     b1a:	6589                	lui	a1,0x2
     b1c:	8526                	mv	a0,s1
     b1e:	4e2000ef          	jal	1000 <munmap>
     b22:	57fd                	li	a5,-1
     b24:	02f50763          	beq	a0,a5,b52 <main+0x9ea>
    volatile char c = p[0]; // should fault
     b28:	0004c783          	lbu	a5,0(s1)
     b2c:	faf40fa3          	sb	a5,-65(s0)
    (void)c;
     b30:	fbf44783          	lbu	a5,-65(s0)
    exit(0);
     b34:	4501                	li	a0,0
     b36:	422000ef          	jal	f58 <exit>
  if(status == 0) err("child should have been killed");
     b3a:	00001517          	auipc	a0,0x1
     b3e:	d5e50513          	addi	a0,a0,-674 # 1898 <malloc+0x432>
     b42:	cbeff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     b46:	00001517          	auipc	a0,0x1
     b4a:	cfa50513          	addi	a0,a0,-774 # 1840 <malloc+0x3da>
     b4e:	cb2ff0ef          	jal	0 <err>
    if(munmap(p, PGSIZE*2) == -1) exit(1);
     b52:	4505                	li	a0,1
     b54:	404000ef          	jal	f58 <exit>
  wait(&status);
     b58:	fc040513          	addi	a0,s0,-64
     b5c:	404000ef          	jal	f60 <wait>
  if(status == 0) err("child2 should have been killed");
     b60:	fc042783          	lw	a5,-64(s0)
     b64:	0c078e63          	beqz	a5,c40 <main+0xad8>
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
     b68:	6589                	lui	a1,0x2
     b6a:	8526                	mv	a0,s1
     b6c:	494000ef          	jal	1000 <munmap>
     b70:	57fd                	li	a5,-1
     b72:	0cf50d63          	beq	a0,a5,c4c <main+0xae4>
  close(fd);
     b76:	854a                	mv	a0,s2
     b78:	408000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     b7c:	00001497          	auipc	s1,0x1
     b80:	48448493          	addi	s1,s1,1156 # 2000 <testname>
     b84:	608c                	ld	a1,0(s1)
     b86:	00001517          	auipc	a0,0x1
     b8a:	aea50513          	addi	a0,a0,-1302 # 1670 <malloc+0x20a>
     b8e:	021000ef          	jal	13ae <printf>
  testname = "test writes to read-only mapped memory";
     b92:	00001797          	auipc	a5,0x1
     b96:	d4678793          	addi	a5,a5,-698 # 18d8 <malloc+0x472>
     b9a:	e09c                	sd	a5,0(s1)
  printf("%s\n", testname);
     b9c:	85be                	mv	a1,a5
     b9e:	00001517          	auipc	a0,0x1
     ba2:	aa250513          	addi	a0,a0,-1374 # 1640 <malloc+0x1da>
     ba6:	009000ef          	jal	13ae <printf>
  make_test_file(f);
     baa:	00001517          	auipc	a0,0x1
     bae:	a9e50513          	addi	a0,a0,-1378 # 1648 <malloc+0x1e2>
     bb2:	c80ff0ef          	jal	32 <make_test_file>
  int fd = open(f, O_RDONLY);
     bb6:	4581                	li	a1,0
     bb8:	00001517          	auipc	a0,0x1
     bbc:	a9050513          	addi	a0,a0,-1392 # 1648 <malloc+0x1e2>
     bc0:	3d8000ef          	jal	f98 <open>
     bc4:	84aa                	mv	s1,a0
  if(fd == -1) err("open");
     bc6:	57fd                	li	a5,-1
     bc8:	08f50863          	beq	a0,a5,c58 <main+0xaf0>
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     bcc:	4701                	li	a4,0
     bce:	86aa                	mv	a3,a0
     bd0:	4609                	li	a2,2
     bd2:	4585                	li	a1,1
     bd4:	6509                	lui	a0,0x2
     bd6:	422000ef          	jal	ff8 <mmap>
     bda:	892a                	mv	s2,a0
  if(p == MAP_FAILED) err("mmap");
     bdc:	57fd                	li	a5,-1
     bde:	08f50363          	beq	a0,a5,c64 <main+0xafc>
  int pid = fork();
     be2:	36e000ef          	jal	f50 <fork>
  if(pid < 0) err("fork");
     be6:	08054563          	bltz	a0,c70 <main+0xb08>
  if(pid == 0){
     bea:	c949                	beqz	a0,c7c <main+0xb14>
  wait(&status);
     bec:	fc040513          	addi	a0,s0,-64
     bf0:	370000ef          	jal	f60 <wait>
  if(status == 0) err("child should have been killed");
     bf4:	fc042783          	lw	a5,-64(s0)
     bf8:	cbc9                	beqz	a5,c8a <main+0xb22>
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
     bfa:	6589                	lui	a1,0x2
     bfc:	854a                	mv	a0,s2
     bfe:	402000ef          	jal	1000 <munmap>
     c02:	57fd                	li	a5,-1
     c04:	08f50963          	beq	a0,a5,c96 <main+0xb2e>
  close(fd);
     c08:	8526                	mv	a0,s1
     c0a:	376000ef          	jal	f80 <close>
  printf("%s: OK\n", testname);
     c0e:	00001597          	auipc	a1,0x1
     c12:	3f25b583          	ld	a1,1010(a1) # 2000 <testname>
     c16:	00001517          	auipc	a0,0x1
     c1a:	a5a50513          	addi	a0,a0,-1446 # 1670 <malloc+0x20a>
     c1e:	790000ef          	jal	13ae <printf>
  two_files_test();
  fork_test();
  unmap_access_test();
  readonly_writes_test();

  unlink("mmap.dur");
     c22:	00001517          	auipc	a0,0x1
     c26:	a2650513          	addi	a0,a0,-1498 # 1648 <malloc+0x1e2>
     c2a:	37e000ef          	jal	fa8 <unlink>
  printf("mmaptest: all tests succeeded\n");
     c2e:	00001517          	auipc	a0,0x1
     c32:	cd250513          	addi	a0,a0,-814 # 1900 <malloc+0x49a>
     c36:	778000ef          	jal	13ae <printf>
  exit(0);
     c3a:	4501                	li	a0,0
     c3c:	31c000ef          	jal	f58 <exit>
  if(status == 0) err("child2 should have been killed");
     c40:	00001517          	auipc	a0,0x1
     c44:	c7850513          	addi	a0,a0,-904 # 18b8 <malloc+0x452>
     c48:	bb8ff0ef          	jal	0 <err>
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
     c4c:	00001517          	auipc	a0,0x1
     c50:	c1c50513          	addi	a0,a0,-996 # 1868 <malloc+0x402>
     c54:	bacff0ef          	jal	0 <err>
  if(fd == -1) err("open");
     c58:	00001517          	auipc	a0,0x1
     c5c:	a0050513          	addi	a0,a0,-1536 # 1658 <malloc+0x1f2>
     c60:	ba0ff0ef          	jal	0 <err>
  if(p == MAP_FAILED) err("mmap");
     c64:	00001517          	auipc	a0,0x1
     c68:	9fc50513          	addi	a0,a0,-1540 # 1660 <malloc+0x1fa>
     c6c:	b94ff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     c70:	00001517          	auipc	a0,0x1
     c74:	bd050513          	addi	a0,a0,-1072 # 1840 <malloc+0x3da>
     c78:	b88ff0ef          	jal	0 <err>
    p[0] = 'B'; // should fault, kill the child
     c7c:	04200793          	li	a5,66
     c80:	00f90023          	sb	a5,0(s2)
    exit(0);
     c84:	4501                	li	a0,0
     c86:	2d2000ef          	jal	f58 <exit>
  if(status == 0) err("child should have been killed");
     c8a:	00001517          	auipc	a0,0x1
     c8e:	c0e50513          	addi	a0,a0,-1010 # 1898 <malloc+0x432>
     c92:	b6eff0ef          	jal	0 <err>
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
     c96:	00001517          	auipc	a0,0x1
     c9a:	bd250513          	addi	a0,a0,-1070 # 1868 <malloc+0x402>
     c9e:	b62ff0ef          	jal	0 <err>

0000000000000ca2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     ca2:	1141                	addi	sp,sp,-16
     ca4:	e406                	sd	ra,8(sp)
     ca6:	e022                	sd	s0,0(sp)
     ca8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     caa:	cbeff0ef          	jal	168 <main>
  exit(r);
     cae:	2aa000ef          	jal	f58 <exit>

0000000000000cb2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     cb2:	1141                	addi	sp,sp,-16
     cb4:	e406                	sd	ra,8(sp)
     cb6:	e022                	sd	s0,0(sp)
     cb8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     cba:	87aa                	mv	a5,a0
     cbc:	0585                	addi	a1,a1,1
     cbe:	0785                	addi	a5,a5,1
     cc0:	fff5c703          	lbu	a4,-1(a1)
     cc4:	fee78fa3          	sb	a4,-1(a5)
     cc8:	fb75                	bnez	a4,cbc <strcpy+0xa>
    ;
  return os;
}
     cca:	60a2                	ld	ra,8(sp)
     ccc:	6402                	ld	s0,0(sp)
     cce:	0141                	addi	sp,sp,16
     cd0:	8082                	ret

0000000000000cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cd2:	1141                	addi	sp,sp,-16
     cd4:	e406                	sd	ra,8(sp)
     cd6:	e022                	sd	s0,0(sp)
     cd8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     cda:	00054783          	lbu	a5,0(a0)
     cde:	cb91                	beqz	a5,cf2 <strcmp+0x20>
     ce0:	0005c703          	lbu	a4,0(a1)
     ce4:	00f71763          	bne	a4,a5,cf2 <strcmp+0x20>
    p++, q++;
     ce8:	0505                	addi	a0,a0,1
     cea:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     cec:	00054783          	lbu	a5,0(a0)
     cf0:	fbe5                	bnez	a5,ce0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     cf2:	0005c503          	lbu	a0,0(a1)
}
     cf6:	40a7853b          	subw	a0,a5,a0
     cfa:	60a2                	ld	ra,8(sp)
     cfc:	6402                	ld	s0,0(sp)
     cfe:	0141                	addi	sp,sp,16
     d00:	8082                	ret

0000000000000d02 <strlen>:

uint
strlen(const char *s)
{
     d02:	1141                	addi	sp,sp,-16
     d04:	e406                	sd	ra,8(sp)
     d06:	e022                	sd	s0,0(sp)
     d08:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     d0a:	00054783          	lbu	a5,0(a0)
     d0e:	cf91                	beqz	a5,d2a <strlen+0x28>
     d10:	00150793          	addi	a5,a0,1
     d14:	86be                	mv	a3,a5
     d16:	0785                	addi	a5,a5,1
     d18:	fff7c703          	lbu	a4,-1(a5)
     d1c:	ff65                	bnez	a4,d14 <strlen+0x12>
     d1e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     d22:	60a2                	ld	ra,8(sp)
     d24:	6402                	ld	s0,0(sp)
     d26:	0141                	addi	sp,sp,16
     d28:	8082                	ret
  for(n = 0; s[n]; n++)
     d2a:	4501                	li	a0,0
     d2c:	bfdd                	j	d22 <strlen+0x20>

0000000000000d2e <memset>:

void*
memset(void *dst, int c, uint n)
{
     d2e:	1141                	addi	sp,sp,-16
     d30:	e406                	sd	ra,8(sp)
     d32:	e022                	sd	s0,0(sp)
     d34:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d36:	ca19                	beqz	a2,d4c <memset+0x1e>
     d38:	87aa                	mv	a5,a0
     d3a:	1602                	slli	a2,a2,0x20
     d3c:	9201                	srli	a2,a2,0x20
     d3e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d42:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d46:	0785                	addi	a5,a5,1
     d48:	fee79de3          	bne	a5,a4,d42 <memset+0x14>
  }
  return dst;
}
     d4c:	60a2                	ld	ra,8(sp)
     d4e:	6402                	ld	s0,0(sp)
     d50:	0141                	addi	sp,sp,16
     d52:	8082                	ret

0000000000000d54 <strchr>:

char*
strchr(const char *s, char c)
{
     d54:	1141                	addi	sp,sp,-16
     d56:	e406                	sd	ra,8(sp)
     d58:	e022                	sd	s0,0(sp)
     d5a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     d5c:	00054783          	lbu	a5,0(a0)
     d60:	cf81                	beqz	a5,d78 <strchr+0x24>
    if(*s == c)
     d62:	00f58763          	beq	a1,a5,d70 <strchr+0x1c>
  for(; *s; s++)
     d66:	0505                	addi	a0,a0,1
     d68:	00054783          	lbu	a5,0(a0)
     d6c:	fbfd                	bnez	a5,d62 <strchr+0xe>
      return (char*)s;
  return 0;
     d6e:	4501                	li	a0,0
}
     d70:	60a2                	ld	ra,8(sp)
     d72:	6402                	ld	s0,0(sp)
     d74:	0141                	addi	sp,sp,16
     d76:	8082                	ret
  return 0;
     d78:	4501                	li	a0,0
     d7a:	bfdd                	j	d70 <strchr+0x1c>

0000000000000d7c <gets>:

char*
gets(char *buf, int max)
{
     d7c:	711d                	addi	sp,sp,-96
     d7e:	ec86                	sd	ra,88(sp)
     d80:	e8a2                	sd	s0,80(sp)
     d82:	e4a6                	sd	s1,72(sp)
     d84:	e0ca                	sd	s2,64(sp)
     d86:	fc4e                	sd	s3,56(sp)
     d88:	f852                	sd	s4,48(sp)
     d8a:	f456                	sd	s5,40(sp)
     d8c:	f05a                	sd	s6,32(sp)
     d8e:	ec5e                	sd	s7,24(sp)
     d90:	e862                	sd	s8,16(sp)
     d92:	1080                	addi	s0,sp,96
     d94:	8baa                	mv	s7,a0
     d96:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d98:	892a                	mv	s2,a0
     d9a:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d9c:	faf40b13          	addi	s6,s0,-81
     da0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     da2:	8c26                	mv	s8,s1
     da4:	0014899b          	addiw	s3,s1,1
     da8:	84ce                	mv	s1,s3
     daa:	0349d463          	bge	s3,s4,dd2 <gets+0x56>
    cc = read(0, &c, 1);
     dae:	8656                	mv	a2,s5
     db0:	85da                	mv	a1,s6
     db2:	4501                	li	a0,0
     db4:	1bc000ef          	jal	f70 <read>
    if(cc < 1)
     db8:	00a05d63          	blez	a0,dd2 <gets+0x56>
      break;
    buf[i++] = c;
     dbc:	faf44783          	lbu	a5,-81(s0)
     dc0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     dc4:	0905                	addi	s2,s2,1
     dc6:	ff678713          	addi	a4,a5,-10
     dca:	c319                	beqz	a4,dd0 <gets+0x54>
     dcc:	17cd                	addi	a5,a5,-13
     dce:	fbf1                	bnez	a5,da2 <gets+0x26>
    buf[i++] = c;
     dd0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     dd2:	9c5e                	add	s8,s8,s7
     dd4:	000c0023          	sb	zero,0(s8)
  return buf;
}
     dd8:	855e                	mv	a0,s7
     dda:	60e6                	ld	ra,88(sp)
     ddc:	6446                	ld	s0,80(sp)
     dde:	64a6                	ld	s1,72(sp)
     de0:	6906                	ld	s2,64(sp)
     de2:	79e2                	ld	s3,56(sp)
     de4:	7a42                	ld	s4,48(sp)
     de6:	7aa2                	ld	s5,40(sp)
     de8:	7b02                	ld	s6,32(sp)
     dea:	6be2                	ld	s7,24(sp)
     dec:	6c42                	ld	s8,16(sp)
     dee:	6125                	addi	sp,sp,96
     df0:	8082                	ret

0000000000000df2 <stat>:

int
stat(const char *n, struct stat *st)
{
     df2:	1101                	addi	sp,sp,-32
     df4:	ec06                	sd	ra,24(sp)
     df6:	e822                	sd	s0,16(sp)
     df8:	e04a                	sd	s2,0(sp)
     dfa:	1000                	addi	s0,sp,32
     dfc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dfe:	4581                	li	a1,0
     e00:	198000ef          	jal	f98 <open>
  if(fd < 0)
     e04:	02054263          	bltz	a0,e28 <stat+0x36>
     e08:	e426                	sd	s1,8(sp)
     e0a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e0c:	85ca                	mv	a1,s2
     e0e:	1a2000ef          	jal	fb0 <fstat>
     e12:	892a                	mv	s2,a0
  close(fd);
     e14:	8526                	mv	a0,s1
     e16:	16a000ef          	jal	f80 <close>
  return r;
     e1a:	64a2                	ld	s1,8(sp)
}
     e1c:	854a                	mv	a0,s2
     e1e:	60e2                	ld	ra,24(sp)
     e20:	6442                	ld	s0,16(sp)
     e22:	6902                	ld	s2,0(sp)
     e24:	6105                	addi	sp,sp,32
     e26:	8082                	ret
    return -1;
     e28:	57fd                	li	a5,-1
     e2a:	893e                	mv	s2,a5
     e2c:	bfc5                	j	e1c <stat+0x2a>

0000000000000e2e <atoi>:

int
atoi(const char *s)
{
     e2e:	1141                	addi	sp,sp,-16
     e30:	e406                	sd	ra,8(sp)
     e32:	e022                	sd	s0,0(sp)
     e34:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e36:	00054683          	lbu	a3,0(a0)
     e3a:	fd06879b          	addiw	a5,a3,-48
     e3e:	0ff7f793          	zext.b	a5,a5
     e42:	4625                	li	a2,9
     e44:	02f66963          	bltu	a2,a5,e76 <atoi+0x48>
     e48:	872a                	mv	a4,a0
  n = 0;
     e4a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e4c:	0705                	addi	a4,a4,1
     e4e:	0025179b          	slliw	a5,a0,0x2
     e52:	9fa9                	addw	a5,a5,a0
     e54:	0017979b          	slliw	a5,a5,0x1
     e58:	9fb5                	addw	a5,a5,a3
     e5a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e5e:	00074683          	lbu	a3,0(a4)
     e62:	fd06879b          	addiw	a5,a3,-48
     e66:	0ff7f793          	zext.b	a5,a5
     e6a:	fef671e3          	bgeu	a2,a5,e4c <atoi+0x1e>
  return n;
}
     e6e:	60a2                	ld	ra,8(sp)
     e70:	6402                	ld	s0,0(sp)
     e72:	0141                	addi	sp,sp,16
     e74:	8082                	ret
  n = 0;
     e76:	4501                	li	a0,0
     e78:	bfdd                	j	e6e <atoi+0x40>

0000000000000e7a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e7a:	1141                	addi	sp,sp,-16
     e7c:	e406                	sd	ra,8(sp)
     e7e:	e022                	sd	s0,0(sp)
     e80:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e82:	02b57563          	bgeu	a0,a1,eac <memmove+0x32>
    while(n-- > 0)
     e86:	00c05f63          	blez	a2,ea4 <memmove+0x2a>
     e8a:	1602                	slli	a2,a2,0x20
     e8c:	9201                	srli	a2,a2,0x20
     e8e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e92:	872a                	mv	a4,a0
      *dst++ = *src++;
     e94:	0585                	addi	a1,a1,1
     e96:	0705                	addi	a4,a4,1
     e98:	fff5c683          	lbu	a3,-1(a1)
     e9c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ea0:	fee79ae3          	bne	a5,a4,e94 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ea4:	60a2                	ld	ra,8(sp)
     ea6:	6402                	ld	s0,0(sp)
     ea8:	0141                	addi	sp,sp,16
     eaa:	8082                	ret
    while(n-- > 0)
     eac:	fec05ce3          	blez	a2,ea4 <memmove+0x2a>
    dst += n;
     eb0:	00c50733          	add	a4,a0,a2
    src += n;
     eb4:	95b2                	add	a1,a1,a2
     eb6:	fff6079b          	addiw	a5,a2,-1 # fff <mmap+0x7>
     eba:	1782                	slli	a5,a5,0x20
     ebc:	9381                	srli	a5,a5,0x20
     ebe:	fff7c793          	not	a5,a5
     ec2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ec4:	15fd                	addi	a1,a1,-1
     ec6:	177d                	addi	a4,a4,-1
     ec8:	0005c683          	lbu	a3,0(a1)
     ecc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ed0:	fef71ae3          	bne	a4,a5,ec4 <memmove+0x4a>
     ed4:	bfc1                	j	ea4 <memmove+0x2a>

0000000000000ed6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ed6:	1141                	addi	sp,sp,-16
     ed8:	e406                	sd	ra,8(sp)
     eda:	e022                	sd	s0,0(sp)
     edc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ede:	c61d                	beqz	a2,f0c <memcmp+0x36>
     ee0:	1602                	slli	a2,a2,0x20
     ee2:	9201                	srli	a2,a2,0x20
     ee4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     ee8:	00054783          	lbu	a5,0(a0)
     eec:	0005c703          	lbu	a4,0(a1)
     ef0:	00e79863          	bne	a5,a4,f00 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     ef4:	0505                	addi	a0,a0,1
    p2++;
     ef6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ef8:	fed518e3          	bne	a0,a3,ee8 <memcmp+0x12>
  }
  return 0;
     efc:	4501                	li	a0,0
     efe:	a019                	j	f04 <memcmp+0x2e>
      return *p1 - *p2;
     f00:	40e7853b          	subw	a0,a5,a4
}
     f04:	60a2                	ld	ra,8(sp)
     f06:	6402                	ld	s0,0(sp)
     f08:	0141                	addi	sp,sp,16
     f0a:	8082                	ret
  return 0;
     f0c:	4501                	li	a0,0
     f0e:	bfdd                	j	f04 <memcmp+0x2e>

0000000000000f10 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     f10:	1141                	addi	sp,sp,-16
     f12:	e406                	sd	ra,8(sp)
     f14:	e022                	sd	s0,0(sp)
     f16:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     f18:	f63ff0ef          	jal	e7a <memmove>
}
     f1c:	60a2                	ld	ra,8(sp)
     f1e:	6402                	ld	s0,0(sp)
     f20:	0141                	addi	sp,sp,16
     f22:	8082                	ret

0000000000000f24 <sbrk>:

char *
sbrk(int n) {
     f24:	1141                	addi	sp,sp,-16
     f26:	e406                	sd	ra,8(sp)
     f28:	e022                	sd	s0,0(sp)
     f2a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     f2c:	4585                	li	a1,1
     f2e:	0b2000ef          	jal	fe0 <sys_sbrk>
}
     f32:	60a2                	ld	ra,8(sp)
     f34:	6402                	ld	s0,0(sp)
     f36:	0141                	addi	sp,sp,16
     f38:	8082                	ret

0000000000000f3a <sbrklazy>:

char *
sbrklazy(int n) {
     f3a:	1141                	addi	sp,sp,-16
     f3c:	e406                	sd	ra,8(sp)
     f3e:	e022                	sd	s0,0(sp)
     f40:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     f42:	4589                	li	a1,2
     f44:	09c000ef          	jal	fe0 <sys_sbrk>
}
     f48:	60a2                	ld	ra,8(sp)
     f4a:	6402                	ld	s0,0(sp)
     f4c:	0141                	addi	sp,sp,16
     f4e:	8082                	ret

0000000000000f50 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f50:	4885                	li	a7,1
 ecall
     f52:	00000073          	ecall
 ret
     f56:	8082                	ret

0000000000000f58 <exit>:
.global exit
exit:
 li a7, SYS_exit
     f58:	4889                	li	a7,2
 ecall
     f5a:	00000073          	ecall
 ret
     f5e:	8082                	ret

0000000000000f60 <wait>:
.global wait
wait:
 li a7, SYS_wait
     f60:	488d                	li	a7,3
 ecall
     f62:	00000073          	ecall
 ret
     f66:	8082                	ret

0000000000000f68 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     f68:	4891                	li	a7,4
 ecall
     f6a:	00000073          	ecall
 ret
     f6e:	8082                	ret

0000000000000f70 <read>:
.global read
read:
 li a7, SYS_read
     f70:	4895                	li	a7,5
 ecall
     f72:	00000073          	ecall
 ret
     f76:	8082                	ret

0000000000000f78 <write>:
.global write
write:
 li a7, SYS_write
     f78:	48c1                	li	a7,16
 ecall
     f7a:	00000073          	ecall
 ret
     f7e:	8082                	ret

0000000000000f80 <close>:
.global close
close:
 li a7, SYS_close
     f80:	48d5                	li	a7,21
 ecall
     f82:	00000073          	ecall
 ret
     f86:	8082                	ret

0000000000000f88 <kill>:
.global kill
kill:
 li a7, SYS_kill
     f88:	4899                	li	a7,6
 ecall
     f8a:	00000073          	ecall
 ret
     f8e:	8082                	ret

0000000000000f90 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f90:	489d                	li	a7,7
 ecall
     f92:	00000073          	ecall
 ret
     f96:	8082                	ret

0000000000000f98 <open>:
.global open
open:
 li a7, SYS_open
     f98:	48bd                	li	a7,15
 ecall
     f9a:	00000073          	ecall
 ret
     f9e:	8082                	ret

0000000000000fa0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     fa0:	48c5                	li	a7,17
 ecall
     fa2:	00000073          	ecall
 ret
     fa6:	8082                	ret

0000000000000fa8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     fa8:	48c9                	li	a7,18
 ecall
     faa:	00000073          	ecall
 ret
     fae:	8082                	ret

0000000000000fb0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     fb0:	48a1                	li	a7,8
 ecall
     fb2:	00000073          	ecall
 ret
     fb6:	8082                	ret

0000000000000fb8 <link>:
.global link
link:
 li a7, SYS_link
     fb8:	48cd                	li	a7,19
 ecall
     fba:	00000073          	ecall
 ret
     fbe:	8082                	ret

0000000000000fc0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     fc0:	48d1                	li	a7,20
 ecall
     fc2:	00000073          	ecall
 ret
     fc6:	8082                	ret

0000000000000fc8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     fc8:	48a5                	li	a7,9
 ecall
     fca:	00000073          	ecall
 ret
     fce:	8082                	ret

0000000000000fd0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     fd0:	48a9                	li	a7,10
 ecall
     fd2:	00000073          	ecall
 ret
     fd6:	8082                	ret

0000000000000fd8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     fd8:	48ad                	li	a7,11
 ecall
     fda:	00000073          	ecall
 ret
     fde:	8082                	ret

0000000000000fe0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     fe0:	48b1                	li	a7,12
 ecall
     fe2:	00000073          	ecall
 ret
     fe6:	8082                	ret

0000000000000fe8 <pause>:
.global pause
pause:
 li a7, SYS_pause
     fe8:	48b5                	li	a7,13
 ecall
     fea:	00000073          	ecall
 ret
     fee:	8082                	ret

0000000000000ff0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ff0:	48b9                	li	a7,14
 ecall
     ff2:	00000073          	ecall
 ret
     ff6:	8082                	ret

0000000000000ff8 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     ff8:	48d9                	li	a7,22
 ecall
     ffa:	00000073          	ecall
 ret
     ffe:	8082                	ret

0000000000001000 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    1000:	48dd                	li	a7,23
 ecall
    1002:	00000073          	ecall
 ret
    1006:	8082                	ret

0000000000001008 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1008:	1101                	addi	sp,sp,-32
    100a:	ec06                	sd	ra,24(sp)
    100c:	e822                	sd	s0,16(sp)
    100e:	1000                	addi	s0,sp,32
    1010:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1014:	4605                	li	a2,1
    1016:	fef40593          	addi	a1,s0,-17
    101a:	f5fff0ef          	jal	f78 <write>
}
    101e:	60e2                	ld	ra,24(sp)
    1020:	6442                	ld	s0,16(sp)
    1022:	6105                	addi	sp,sp,32
    1024:	8082                	ret

0000000000001026 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    1026:	715d                	addi	sp,sp,-80
    1028:	e486                	sd	ra,72(sp)
    102a:	e0a2                	sd	s0,64(sp)
    102c:	f84a                	sd	s2,48(sp)
    102e:	f44e                	sd	s3,40(sp)
    1030:	0880                	addi	s0,sp,80
    1032:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    1034:	c6d1                	beqz	a3,10c0 <printint+0x9a>
    1036:	0805d563          	bgez	a1,10c0 <printint+0x9a>
    neg = 1;
    x = -xx;
    103a:	40b005b3          	neg	a1,a1
    neg = 1;
    103e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    1040:	fb840993          	addi	s3,s0,-72
  neg = 0;
    1044:	86ce                	mv	a3,s3
  i = 0;
    1046:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1048:	00001817          	auipc	a6,0x1
    104c:	8e880813          	addi	a6,a6,-1816 # 1930 <digits>
    1050:	88ba                	mv	a7,a4
    1052:	0017051b          	addiw	a0,a4,1
    1056:	872a                	mv	a4,a0
    1058:	02c5f7b3          	remu	a5,a1,a2
    105c:	97c2                	add	a5,a5,a6
    105e:	0007c783          	lbu	a5,0(a5)
    1062:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1066:	87ae                	mv	a5,a1
    1068:	02c5d5b3          	divu	a1,a1,a2
    106c:	0685                	addi	a3,a3,1
    106e:	fec7f1e3          	bgeu	a5,a2,1050 <printint+0x2a>
  if(neg)
    1072:	00030c63          	beqz	t1,108a <printint+0x64>
    buf[i++] = '-';
    1076:	fd050793          	addi	a5,a0,-48
    107a:	00878533          	add	a0,a5,s0
    107e:	02d00793          	li	a5,45
    1082:	fef50423          	sb	a5,-24(a0)
    1086:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    108a:	02e05563          	blez	a4,10b4 <printint+0x8e>
    108e:	fc26                	sd	s1,56(sp)
    1090:	377d                	addiw	a4,a4,-1
    1092:	00e984b3          	add	s1,s3,a4
    1096:	19fd                	addi	s3,s3,-1
    1098:	99ba                	add	s3,s3,a4
    109a:	1702                	slli	a4,a4,0x20
    109c:	9301                	srli	a4,a4,0x20
    109e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    10a2:	0004c583          	lbu	a1,0(s1)
    10a6:	854a                	mv	a0,s2
    10a8:	f61ff0ef          	jal	1008 <putc>
  while(--i >= 0)
    10ac:	14fd                	addi	s1,s1,-1
    10ae:	ff349ae3          	bne	s1,s3,10a2 <printint+0x7c>
    10b2:	74e2                	ld	s1,56(sp)
}
    10b4:	60a6                	ld	ra,72(sp)
    10b6:	6406                	ld	s0,64(sp)
    10b8:	7942                	ld	s2,48(sp)
    10ba:	79a2                	ld	s3,40(sp)
    10bc:	6161                	addi	sp,sp,80
    10be:	8082                	ret
  neg = 0;
    10c0:	4301                	li	t1,0
    10c2:	bfbd                	j	1040 <printint+0x1a>

00000000000010c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    10c4:	711d                	addi	sp,sp,-96
    10c6:	ec86                	sd	ra,88(sp)
    10c8:	e8a2                	sd	s0,80(sp)
    10ca:	e4a6                	sd	s1,72(sp)
    10cc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    10ce:	0005c483          	lbu	s1,0(a1)
    10d2:	22048363          	beqz	s1,12f8 <vprintf+0x234>
    10d6:	e0ca                	sd	s2,64(sp)
    10d8:	fc4e                	sd	s3,56(sp)
    10da:	f852                	sd	s4,48(sp)
    10dc:	f456                	sd	s5,40(sp)
    10de:	f05a                	sd	s6,32(sp)
    10e0:	ec5e                	sd	s7,24(sp)
    10e2:	e862                	sd	s8,16(sp)
    10e4:	8b2a                	mv	s6,a0
    10e6:	8a2e                	mv	s4,a1
    10e8:	8bb2                	mv	s7,a2
  state = 0;
    10ea:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    10ec:	4901                	li	s2,0
    10ee:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    10f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    10f4:	06400c13          	li	s8,100
    10f8:	a00d                	j	111a <vprintf+0x56>
        putc(fd, c0);
    10fa:	85a6                	mv	a1,s1
    10fc:	855a                	mv	a0,s6
    10fe:	f0bff0ef          	jal	1008 <putc>
    1102:	a019                	j	1108 <vprintf+0x44>
    } else if(state == '%'){
    1104:	03598363          	beq	s3,s5,112a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    1108:	0019079b          	addiw	a5,s2,1
    110c:	893e                	mv	s2,a5
    110e:	873e                	mv	a4,a5
    1110:	97d2                	add	a5,a5,s4
    1112:	0007c483          	lbu	s1,0(a5)
    1116:	1c048a63          	beqz	s1,12ea <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    111a:	0004879b          	sext.w	a5,s1
    if(state == 0){
    111e:	fe0993e3          	bnez	s3,1104 <vprintf+0x40>
      if(c0 == '%'){
    1122:	fd579ce3          	bne	a5,s5,10fa <vprintf+0x36>
        state = '%';
    1126:	89be                	mv	s3,a5
    1128:	b7c5                	j	1108 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    112a:	00ea06b3          	add	a3,s4,a4
    112e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    1132:	1c060863          	beqz	a2,1302 <vprintf+0x23e>
      if(c0 == 'd'){
    1136:	03878763          	beq	a5,s8,1164 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    113a:	f9478693          	addi	a3,a5,-108
    113e:	0016b693          	seqz	a3,a3
    1142:	f9c60593          	addi	a1,a2,-100
    1146:	e99d                	bnez	a1,117c <vprintf+0xb8>
    1148:	ca95                	beqz	a3,117c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    114a:	008b8493          	addi	s1,s7,8
    114e:	4685                	li	a3,1
    1150:	4629                	li	a2,10
    1152:	000bb583          	ld	a1,0(s7)
    1156:	855a                	mv	a0,s6
    1158:	ecfff0ef          	jal	1026 <printint>
        i += 1;
    115c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    115e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    1160:	4981                	li	s3,0
    1162:	b75d                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    1164:	008b8493          	addi	s1,s7,8
    1168:	4685                	li	a3,1
    116a:	4629                	li	a2,10
    116c:	000ba583          	lw	a1,0(s7)
    1170:	855a                	mv	a0,s6
    1172:	eb5ff0ef          	jal	1026 <printint>
    1176:	8ba6                	mv	s7,s1
      state = 0;
    1178:	4981                	li	s3,0
    117a:	b779                	j	1108 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    117c:	9752                	add	a4,a4,s4
    117e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1182:	f9460713          	addi	a4,a2,-108
    1186:	00173713          	seqz	a4,a4
    118a:	8f75                	and	a4,a4,a3
    118c:	f9c58513          	addi	a0,a1,-100
    1190:	18051363          	bnez	a0,1316 <vprintf+0x252>
    1194:	18070163          	beqz	a4,1316 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1198:	008b8493          	addi	s1,s7,8
    119c:	4685                	li	a3,1
    119e:	4629                	li	a2,10
    11a0:	000bb583          	ld	a1,0(s7)
    11a4:	855a                	mv	a0,s6
    11a6:	e81ff0ef          	jal	1026 <printint>
        i += 2;
    11aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    11ac:	8ba6                	mv	s7,s1
      state = 0;
    11ae:	4981                	li	s3,0
        i += 2;
    11b0:	bfa1                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    11b2:	008b8493          	addi	s1,s7,8
    11b6:	4681                	li	a3,0
    11b8:	4629                	li	a2,10
    11ba:	000be583          	lwu	a1,0(s7)
    11be:	855a                	mv	a0,s6
    11c0:	e67ff0ef          	jal	1026 <printint>
    11c4:	8ba6                	mv	s7,s1
      state = 0;
    11c6:	4981                	li	s3,0
    11c8:	b781                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    11ca:	008b8493          	addi	s1,s7,8
    11ce:	4681                	li	a3,0
    11d0:	4629                	li	a2,10
    11d2:	000bb583          	ld	a1,0(s7)
    11d6:	855a                	mv	a0,s6
    11d8:	e4fff0ef          	jal	1026 <printint>
        i += 1;
    11dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    11de:	8ba6                	mv	s7,s1
      state = 0;
    11e0:	4981                	li	s3,0
    11e2:	b71d                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    11e4:	008b8493          	addi	s1,s7,8
    11e8:	4681                	li	a3,0
    11ea:	4629                	li	a2,10
    11ec:	000bb583          	ld	a1,0(s7)
    11f0:	855a                	mv	a0,s6
    11f2:	e35ff0ef          	jal	1026 <printint>
        i += 2;
    11f6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    11f8:	8ba6                	mv	s7,s1
      state = 0;
    11fa:	4981                	li	s3,0
        i += 2;
    11fc:	b731                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    11fe:	008b8493          	addi	s1,s7,8
    1202:	4681                	li	a3,0
    1204:	4641                	li	a2,16
    1206:	000be583          	lwu	a1,0(s7)
    120a:	855a                	mv	a0,s6
    120c:	e1bff0ef          	jal	1026 <printint>
    1210:	8ba6                	mv	s7,s1
      state = 0;
    1212:	4981                	li	s3,0
    1214:	bdd5                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1216:	008b8493          	addi	s1,s7,8
    121a:	4681                	li	a3,0
    121c:	4641                	li	a2,16
    121e:	000bb583          	ld	a1,0(s7)
    1222:	855a                	mv	a0,s6
    1224:	e03ff0ef          	jal	1026 <printint>
        i += 1;
    1228:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    122a:	8ba6                	mv	s7,s1
      state = 0;
    122c:	4981                	li	s3,0
    122e:	bde9                	j	1108 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1230:	008b8493          	addi	s1,s7,8
    1234:	4681                	li	a3,0
    1236:	4641                	li	a2,16
    1238:	000bb583          	ld	a1,0(s7)
    123c:	855a                	mv	a0,s6
    123e:	de9ff0ef          	jal	1026 <printint>
        i += 2;
    1242:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1244:	8ba6                	mv	s7,s1
      state = 0;
    1246:	4981                	li	s3,0
        i += 2;
    1248:	b5c1                	j	1108 <vprintf+0x44>
    124a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    124c:	008b8793          	addi	a5,s7,8
    1250:	8cbe                	mv	s9,a5
    1252:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1256:	03000593          	li	a1,48
    125a:	855a                	mv	a0,s6
    125c:	dadff0ef          	jal	1008 <putc>
  putc(fd, 'x');
    1260:	07800593          	li	a1,120
    1264:	855a                	mv	a0,s6
    1266:	da3ff0ef          	jal	1008 <putc>
    126a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    126c:	00000b97          	auipc	s7,0x0
    1270:	6c4b8b93          	addi	s7,s7,1732 # 1930 <digits>
    1274:	03c9d793          	srli	a5,s3,0x3c
    1278:	97de                	add	a5,a5,s7
    127a:	0007c583          	lbu	a1,0(a5)
    127e:	855a                	mv	a0,s6
    1280:	d89ff0ef          	jal	1008 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1284:	0992                	slli	s3,s3,0x4
    1286:	34fd                	addiw	s1,s1,-1
    1288:	f4f5                	bnez	s1,1274 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    128a:	8be6                	mv	s7,s9
      state = 0;
    128c:	4981                	li	s3,0
    128e:	6ca2                	ld	s9,8(sp)
    1290:	bda5                	j	1108 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    1292:	008b8493          	addi	s1,s7,8
    1296:	000bc583          	lbu	a1,0(s7)
    129a:	855a                	mv	a0,s6
    129c:	d6dff0ef          	jal	1008 <putc>
    12a0:	8ba6                	mv	s7,s1
      state = 0;
    12a2:	4981                	li	s3,0
    12a4:	b595                	j	1108 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    12a6:	008b8993          	addi	s3,s7,8
    12aa:	000bb483          	ld	s1,0(s7)
    12ae:	cc91                	beqz	s1,12ca <vprintf+0x206>
        for(; *s; s++)
    12b0:	0004c583          	lbu	a1,0(s1)
    12b4:	c985                	beqz	a1,12e4 <vprintf+0x220>
          putc(fd, *s);
    12b6:	855a                	mv	a0,s6
    12b8:	d51ff0ef          	jal	1008 <putc>
        for(; *s; s++)
    12bc:	0485                	addi	s1,s1,1
    12be:	0004c583          	lbu	a1,0(s1)
    12c2:	f9f5                	bnez	a1,12b6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    12c4:	8bce                	mv	s7,s3
      state = 0;
    12c6:	4981                	li	s3,0
    12c8:	b581                	j	1108 <vprintf+0x44>
          s = "(null)";
    12ca:	00000497          	auipc	s1,0x0
    12ce:	65e48493          	addi	s1,s1,1630 # 1928 <malloc+0x4c2>
        for(; *s; s++)
    12d2:	02800593          	li	a1,40
    12d6:	b7c5                	j	12b6 <vprintf+0x1f2>
        putc(fd, '%');
    12d8:	85be                	mv	a1,a5
    12da:	855a                	mv	a0,s6
    12dc:	d2dff0ef          	jal	1008 <putc>
      state = 0;
    12e0:	4981                	li	s3,0
    12e2:	b51d                	j	1108 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    12e4:	8bce                	mv	s7,s3
      state = 0;
    12e6:	4981                	li	s3,0
    12e8:	b505                	j	1108 <vprintf+0x44>
    12ea:	6906                	ld	s2,64(sp)
    12ec:	79e2                	ld	s3,56(sp)
    12ee:	7a42                	ld	s4,48(sp)
    12f0:	7aa2                	ld	s5,40(sp)
    12f2:	7b02                	ld	s6,32(sp)
    12f4:	6be2                	ld	s7,24(sp)
    12f6:	6c42                	ld	s8,16(sp)
    }
  }
}
    12f8:	60e6                	ld	ra,88(sp)
    12fa:	6446                	ld	s0,80(sp)
    12fc:	64a6                	ld	s1,72(sp)
    12fe:	6125                	addi	sp,sp,96
    1300:	8082                	ret
      if(c0 == 'd'){
    1302:	06400713          	li	a4,100
    1306:	e4e78fe3          	beq	a5,a4,1164 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    130a:	f9478693          	addi	a3,a5,-108
    130e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1312:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1314:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1316:	07500513          	li	a0,117
    131a:	e8a78ce3          	beq	a5,a0,11b2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    131e:	f8b60513          	addi	a0,a2,-117
    1322:	e119                	bnez	a0,1328 <vprintf+0x264>
    1324:	ea0693e3          	bnez	a3,11ca <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1328:	f8b58513          	addi	a0,a1,-117
    132c:	e119                	bnez	a0,1332 <vprintf+0x26e>
    132e:	ea071be3          	bnez	a4,11e4 <vprintf+0x120>
      } else if(c0 == 'x'){
    1332:	07800513          	li	a0,120
    1336:	eca784e3          	beq	a5,a0,11fe <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    133a:	f8860613          	addi	a2,a2,-120
    133e:	e219                	bnez	a2,1344 <vprintf+0x280>
    1340:	ec069be3          	bnez	a3,1216 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1344:	f8858593          	addi	a1,a1,-120
    1348:	e199                	bnez	a1,134e <vprintf+0x28a>
    134a:	ee0713e3          	bnez	a4,1230 <vprintf+0x16c>
      } else if(c0 == 'p'){
    134e:	07000713          	li	a4,112
    1352:	eee78ce3          	beq	a5,a4,124a <vprintf+0x186>
      } else if(c0 == 'c'){
    1356:	06300713          	li	a4,99
    135a:	f2e78ce3          	beq	a5,a4,1292 <vprintf+0x1ce>
      } else if(c0 == 's'){
    135e:	07300713          	li	a4,115
    1362:	f4e782e3          	beq	a5,a4,12a6 <vprintf+0x1e2>
      } else if(c0 == '%'){
    1366:	02500713          	li	a4,37
    136a:	f6e787e3          	beq	a5,a4,12d8 <vprintf+0x214>
        putc(fd, '%');
    136e:	02500593          	li	a1,37
    1372:	855a                	mv	a0,s6
    1374:	c95ff0ef          	jal	1008 <putc>
        putc(fd, c0);
    1378:	85a6                	mv	a1,s1
    137a:	855a                	mv	a0,s6
    137c:	c8dff0ef          	jal	1008 <putc>
      state = 0;
    1380:	4981                	li	s3,0
    1382:	b359                	j	1108 <vprintf+0x44>

0000000000001384 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1384:	715d                	addi	sp,sp,-80
    1386:	ec06                	sd	ra,24(sp)
    1388:	e822                	sd	s0,16(sp)
    138a:	1000                	addi	s0,sp,32
    138c:	e010                	sd	a2,0(s0)
    138e:	e414                	sd	a3,8(s0)
    1390:	e818                	sd	a4,16(s0)
    1392:	ec1c                	sd	a5,24(s0)
    1394:	03043023          	sd	a6,32(s0)
    1398:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    139c:	8622                	mv	a2,s0
    139e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    13a2:	d23ff0ef          	jal	10c4 <vprintf>
}
    13a6:	60e2                	ld	ra,24(sp)
    13a8:	6442                	ld	s0,16(sp)
    13aa:	6161                	addi	sp,sp,80
    13ac:	8082                	ret

00000000000013ae <printf>:

void
printf(const char *fmt, ...)
{
    13ae:	711d                	addi	sp,sp,-96
    13b0:	ec06                	sd	ra,24(sp)
    13b2:	e822                	sd	s0,16(sp)
    13b4:	1000                	addi	s0,sp,32
    13b6:	e40c                	sd	a1,8(s0)
    13b8:	e810                	sd	a2,16(s0)
    13ba:	ec14                	sd	a3,24(s0)
    13bc:	f018                	sd	a4,32(s0)
    13be:	f41c                	sd	a5,40(s0)
    13c0:	03043823          	sd	a6,48(s0)
    13c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    13c8:	00840613          	addi	a2,s0,8
    13cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    13d0:	85aa                	mv	a1,a0
    13d2:	4505                	li	a0,1
    13d4:	cf1ff0ef          	jal	10c4 <vprintf>
}
    13d8:	60e2                	ld	ra,24(sp)
    13da:	6442                	ld	s0,16(sp)
    13dc:	6125                	addi	sp,sp,96
    13de:	8082                	ret

00000000000013e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    13e0:	1141                	addi	sp,sp,-16
    13e2:	e406                	sd	ra,8(sp)
    13e4:	e022                	sd	s0,0(sp)
    13e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    13e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13ec:	00001797          	auipc	a5,0x1
    13f0:	c247b783          	ld	a5,-988(a5) # 2010 <freep>
    13f4:	a039                	j	1402 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13f6:	6398                	ld	a4,0(a5)
    13f8:	00e7e463          	bltu	a5,a4,1400 <free+0x20>
    13fc:	00e6ea63          	bltu	a3,a4,1410 <free+0x30>
{
    1400:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1402:	fed7fae3          	bgeu	a5,a3,13f6 <free+0x16>
    1406:	6398                	ld	a4,0(a5)
    1408:	00e6e463          	bltu	a3,a4,1410 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    140c:	fee7eae3          	bltu	a5,a4,1400 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1410:	ff852583          	lw	a1,-8(a0)
    1414:	6390                	ld	a2,0(a5)
    1416:	02059813          	slli	a6,a1,0x20
    141a:	01c85713          	srli	a4,a6,0x1c
    141e:	9736                	add	a4,a4,a3
    1420:	02e60563          	beq	a2,a4,144a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1424:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1428:	4790                	lw	a2,8(a5)
    142a:	02061593          	slli	a1,a2,0x20
    142e:	01c5d713          	srli	a4,a1,0x1c
    1432:	973e                	add	a4,a4,a5
    1434:	02e68263          	beq	a3,a4,1458 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1438:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    143a:	00001717          	auipc	a4,0x1
    143e:	bcf73b23          	sd	a5,-1066(a4) # 2010 <freep>
}
    1442:	60a2                	ld	ra,8(sp)
    1444:	6402                	ld	s0,0(sp)
    1446:	0141                	addi	sp,sp,16
    1448:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    144a:	4618                	lw	a4,8(a2)
    144c:	9f2d                	addw	a4,a4,a1
    144e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1452:	6398                	ld	a4,0(a5)
    1454:	6310                	ld	a2,0(a4)
    1456:	b7f9                	j	1424 <free+0x44>
    p->s.size += bp->s.size;
    1458:	ff852703          	lw	a4,-8(a0)
    145c:	9f31                	addw	a4,a4,a2
    145e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1460:	ff053683          	ld	a3,-16(a0)
    1464:	bfd1                	j	1438 <free+0x58>

0000000000001466 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1466:	7139                	addi	sp,sp,-64
    1468:	fc06                	sd	ra,56(sp)
    146a:	f822                	sd	s0,48(sp)
    146c:	f04a                	sd	s2,32(sp)
    146e:	ec4e                	sd	s3,24(sp)
    1470:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1472:	02051993          	slli	s3,a0,0x20
    1476:	0209d993          	srli	s3,s3,0x20
    147a:	09bd                	addi	s3,s3,15
    147c:	0049d993          	srli	s3,s3,0x4
    1480:	2985                	addiw	s3,s3,1
    1482:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1484:	00001517          	auipc	a0,0x1
    1488:	b8c53503          	ld	a0,-1140(a0) # 2010 <freep>
    148c:	c905                	beqz	a0,14bc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    148e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1490:	4798                	lw	a4,8(a5)
    1492:	09377663          	bgeu	a4,s3,151e <malloc+0xb8>
    1496:	f426                	sd	s1,40(sp)
    1498:	e852                	sd	s4,16(sp)
    149a:	e456                	sd	s5,8(sp)
    149c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    149e:	8a4e                	mv	s4,s3
    14a0:	6705                	lui	a4,0x1
    14a2:	00e9f363          	bgeu	s3,a4,14a8 <malloc+0x42>
    14a6:	6a05                	lui	s4,0x1
    14a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    14ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    14b0:	00001497          	auipc	s1,0x1
    14b4:	b6048493          	addi	s1,s1,-1184 # 2010 <freep>
  if(p == SBRK_ERROR)
    14b8:	5afd                	li	s5,-1
    14ba:	a83d                	j	14f8 <malloc+0x92>
    14bc:	f426                	sd	s1,40(sp)
    14be:	e852                	sd	s4,16(sp)
    14c0:	e456                	sd	s5,8(sp)
    14c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    14c4:	00002797          	auipc	a5,0x2
    14c8:	b5c78793          	addi	a5,a5,-1188 # 3020 <base>
    14cc:	00001717          	auipc	a4,0x1
    14d0:	b4f73223          	sd	a5,-1212(a4) # 2010 <freep>
    14d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    14d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    14da:	b7d1                	j	149e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    14dc:	6398                	ld	a4,0(a5)
    14de:	e118                	sd	a4,0(a0)
    14e0:	a899                	j	1536 <malloc+0xd0>
  hp->s.size = nu;
    14e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    14e6:	0541                	addi	a0,a0,16
    14e8:	ef9ff0ef          	jal	13e0 <free>
  return freep;
    14ec:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    14ee:	c125                	beqz	a0,154e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    14f2:	4798                	lw	a4,8(a5)
    14f4:	03277163          	bgeu	a4,s2,1516 <malloc+0xb0>
    if(p == freep)
    14f8:	6098                	ld	a4,0(s1)
    14fa:	853e                	mv	a0,a5
    14fc:	fef71ae3          	bne	a4,a5,14f0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1500:	8552                	mv	a0,s4
    1502:	a23ff0ef          	jal	f24 <sbrk>
  if(p == SBRK_ERROR)
    1506:	fd551ee3          	bne	a0,s5,14e2 <malloc+0x7c>
        return 0;
    150a:	4501                	li	a0,0
    150c:	74a2                	ld	s1,40(sp)
    150e:	6a42                	ld	s4,16(sp)
    1510:	6aa2                	ld	s5,8(sp)
    1512:	6b02                	ld	s6,0(sp)
    1514:	a03d                	j	1542 <malloc+0xdc>
    1516:	74a2                	ld	s1,40(sp)
    1518:	6a42                	ld	s4,16(sp)
    151a:	6aa2                	ld	s5,8(sp)
    151c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    151e:	fae90fe3          	beq	s2,a4,14dc <malloc+0x76>
        p->s.size -= nunits;
    1522:	4137073b          	subw	a4,a4,s3
    1526:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1528:	02071693          	slli	a3,a4,0x20
    152c:	01c6d713          	srli	a4,a3,0x1c
    1530:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1532:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1536:	00001717          	auipc	a4,0x1
    153a:	aca73d23          	sd	a0,-1318(a4) # 2010 <freep>
      return (void*)(p + 1);
    153e:	01078513          	addi	a0,a5,16
  }
}
    1542:	70e2                	ld	ra,56(sp)
    1544:	7442                	ld	s0,48(sp)
    1546:	7902                	ld	s2,32(sp)
    1548:	69e2                	ld	s3,24(sp)
    154a:	6121                	addi	sp,sp,64
    154c:	8082                	ret
    154e:	74a2                	ld	s1,40(sp)
    1550:	6a42                	ld	s4,16(sp)
    1552:	6aa2                	ld	s5,8(sp)
    1554:	6b02                	ld	s6,0(sp)
    1556:	b7f5                	j	1542 <malloc+0xdc>
