
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
int
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	d0078793          	addi	a5,a5,-768 # 7d10 <malloc+0x2694>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	164050ef          	jal	51ae <open>
    if(fd >= 0){
      4e:	00055e63          	bgez	a0,6a <copyinstr1+0x6a>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
  return 0;
}
      58:	4501                	li	a0,0
      5a:	60e6                	ld	ra,88(sp)
      5c:	6446                	ld	s0,80(sp)
      5e:	64a6                	ld	s1,72(sp)
      60:	6906                	ld	s2,64(sp)
      62:	79e2                	ld	s3,56(sp)
      64:	7a42                	ld	s4,48(sp)
      66:	6125                	addi	sp,sp,96
      68:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      6a:	862a                	mv	a2,a0
      6c:	85ca                	mv	a1,s2
      6e:	00005517          	auipc	a0,0x5
      72:	70250513          	addi	a0,a0,1794 # 5770 <malloc+0xf4>
      76:	54e050ef          	jal	55c4 <printf>
      exit(1);
      7a:	4505                	li	a0,1
      7c:	0f2050ef          	jal	516e <exit>

0000000000000080 <bsstest>:
int
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      80:	00009797          	auipc	a5,0x9
      84:	52878793          	addi	a5,a5,1320 # 95a8 <uninit>
      88:	0000c697          	auipc	a3,0xc
      8c:	c3068693          	addi	a3,a3,-976 # bcb8 <buf>
    if(uninit[i] != '\0'){
      90:	0007c703          	lbu	a4,0(a5)
      94:	e711                	bnez	a4,a0 <bsstest+0x20>
  for(i = 0; i < sizeof(uninit); i++){
      96:	0785                	addi	a5,a5,1
      98:	fed79ce3          	bne	a5,a3,90 <bsstest+0x10>
      printf("%s: bss test failed\n", s);
      exit(1);
    }
  }
  return 0;
}
      9c:	4501                	li	a0,0
      9e:	8082                	ret
{
      a0:	1141                	addi	sp,sp,-16
      a2:	e406                	sd	ra,8(sp)
      a4:	e022                	sd	s0,0(sp)
      a6:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a8:	85aa                	mv	a1,a0
      aa:	00005517          	auipc	a0,0x5
      ae:	6e650513          	addi	a0,a0,1766 # 5790 <malloc+0x114>
      b2:	512050ef          	jal	55c4 <printf>
      exit(1);
      b6:	4505                	li	a0,1
      b8:	0b6050ef          	jal	516e <exit>

00000000000000bc <opentest>:
{
      bc:	1101                	addi	sp,sp,-32
      be:	ec06                	sd	ra,24(sp)
      c0:	e822                	sd	s0,16(sp)
      c2:	e426                	sd	s1,8(sp)
      c4:	1000                	addi	s0,sp,32
      c6:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c8:	4581                	li	a1,0
      ca:	00005517          	auipc	a0,0x5
      ce:	6de50513          	addi	a0,a0,1758 # 57a8 <malloc+0x12c>
      d2:	0dc050ef          	jal	51ae <open>
  if(fd < 0){
      d6:	02054363          	bltz	a0,fc <opentest+0x40>
  close(fd);
      da:	0bc050ef          	jal	5196 <close>
  fd = open("doesnotexist", 0);
      de:	4581                	li	a1,0
      e0:	00005517          	auipc	a0,0x5
      e4:	6e850513          	addi	a0,a0,1768 # 57c8 <malloc+0x14c>
      e8:	0c6050ef          	jal	51ae <open>
  if(fd >= 0){
      ec:	02055263          	bgez	a0,110 <opentest+0x54>
}
      f0:	4501                	li	a0,0
      f2:	60e2                	ld	ra,24(sp)
      f4:	6442                	ld	s0,16(sp)
      f6:	64a2                	ld	s1,8(sp)
      f8:	6105                	addi	sp,sp,32
      fa:	8082                	ret
    printf("%s: open echo failed!\n", s);
      fc:	85a6                	mv	a1,s1
      fe:	00005517          	auipc	a0,0x5
     102:	6b250513          	addi	a0,a0,1714 # 57b0 <malloc+0x134>
     106:	4be050ef          	jal	55c4 <printf>
    exit(1);
     10a:	4505                	li	a0,1
     10c:	062050ef          	jal	516e <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     110:	85a6                	mv	a1,s1
     112:	00005517          	auipc	a0,0x5
     116:	6c650513          	addi	a0,a0,1734 # 57d8 <malloc+0x15c>
     11a:	4aa050ef          	jal	55c4 <printf>
    exit(1);
     11e:	4505                	li	a0,1
     120:	04e050ef          	jal	516e <exit>

0000000000000124 <truncate2>:
{
     124:	7179                	addi	sp,sp,-48
     126:	f406                	sd	ra,40(sp)
     128:	f022                	sd	s0,32(sp)
     12a:	ec26                	sd	s1,24(sp)
     12c:	e84a                	sd	s2,16(sp)
     12e:	e44e                	sd	s3,8(sp)
     130:	1800                	addi	s0,sp,48
     132:	89aa                	mv	s3,a0
  unlink("truncfile");
     134:	00005517          	auipc	a0,0x5
     138:	6cc50513          	addi	a0,a0,1740 # 5800 <malloc+0x184>
     13c:	082050ef          	jal	51be <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     140:	60100593          	li	a1,1537
     144:	00005517          	auipc	a0,0x5
     148:	6bc50513          	addi	a0,a0,1724 # 5800 <malloc+0x184>
     14c:	062050ef          	jal	51ae <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00005597          	auipc	a1,0x5
     158:	6bc58593          	addi	a1,a1,1724 # 5810 <malloc+0x194>
     15c:	032050ef          	jal	518e <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     160:	40100593          	li	a1,1025
     164:	00005517          	auipc	a0,0x5
     168:	69c50513          	addi	a0,a0,1692 # 5800 <malloc+0x184>
     16c:	042050ef          	jal	51ae <open>
     170:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     172:	4605                	li	a2,1
     174:	00005597          	auipc	a1,0x5
     178:	6a458593          	addi	a1,a1,1700 # 5818 <malloc+0x19c>
     17c:	8526                	mv	a0,s1
     17e:	010050ef          	jal	518e <write>
  if(n != -1){
     182:	57fd                	li	a5,-1
     184:	02f51663          	bne	a0,a5,1b0 <truncate2+0x8c>
  unlink("truncfile");
     188:	00005517          	auipc	a0,0x5
     18c:	67850513          	addi	a0,a0,1656 # 5800 <malloc+0x184>
     190:	02e050ef          	jal	51be <unlink>
  close(fd1);
     194:	8526                	mv	a0,s1
     196:	000050ef          	jal	5196 <close>
  close(fd2);
     19a:	854a                	mv	a0,s2
     19c:	7fb040ef          	jal	5196 <close>
}
     1a0:	4501                	li	a0,0
     1a2:	70a2                	ld	ra,40(sp)
     1a4:	7402                	ld	s0,32(sp)
     1a6:	64e2                	ld	s1,24(sp)
     1a8:	6942                	ld	s2,16(sp)
     1aa:	69a2                	ld	s3,8(sp)
     1ac:	6145                	addi	sp,sp,48
     1ae:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1b0:	862a                	mv	a2,a0
     1b2:	85ce                	mv	a1,s3
     1b4:	00005517          	auipc	a0,0x5
     1b8:	66c50513          	addi	a0,a0,1644 # 5820 <malloc+0x1a4>
     1bc:	408050ef          	jal	55c4 <printf>
    exit(1);
     1c0:	4505                	li	a0,1
     1c2:	7ad040ef          	jal	516e <exit>

00000000000001c6 <createtest>:
{
     1c6:	7139                	addi	sp,sp,-64
     1c8:	fc06                	sd	ra,56(sp)
     1ca:	f822                	sd	s0,48(sp)
     1cc:	f426                	sd	s1,40(sp)
     1ce:	f04a                	sd	s2,32(sp)
     1d0:	ec4e                	sd	s3,24(sp)
     1d2:	e852                	sd	s4,16(sp)
     1d4:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1d6:	06100793          	li	a5,97
     1da:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1de:	fc040523          	sb	zero,-54(s0)
     1e2:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     1e6:	fc840a13          	addi	s4,s0,-56
     1ea:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     1ee:	06400913          	li	s2,100
    name[1] = '0' + i;
     1f2:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1f6:	85ce                	mv	a1,s3
     1f8:	8552                	mv	a0,s4
     1fa:	7b5040ef          	jal	51ae <open>
    close(fd);
     1fe:	799040ef          	jal	5196 <close>
  for(i = 0; i < N; i++){
     202:	2485                	addiw	s1,s1,1
     204:	0ff4f493          	zext.b	s1,s1
     208:	ff2495e3          	bne	s1,s2,1f2 <createtest+0x2c>
  name[0] = 'a';
     20c:	06100793          	li	a5,97
     210:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     214:	fc040523          	sb	zero,-54(s0)
     218:	03000493          	li	s1,48
    unlink(name);
     21c:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     220:	06400913          	li	s2,100
    name[1] = '0' + i;
     224:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     228:	854e                	mv	a0,s3
     22a:	795040ef          	jal	51be <unlink>
  for(i = 0; i < N; i++){
     22e:	2485                	addiw	s1,s1,1
     230:	0ff4f493          	zext.b	s1,s1
     234:	ff2498e3          	bne	s1,s2,224 <createtest+0x5e>
}
     238:	4501                	li	a0,0
     23a:	70e2                	ld	ra,56(sp)
     23c:	7442                	ld	s0,48(sp)
     23e:	74a2                	ld	s1,40(sp)
     240:	7902                	ld	s2,32(sp)
     242:	69e2                	ld	s3,24(sp)
     244:	6a42                	ld	s4,16(sp)
     246:	6121                	addi	sp,sp,64
     248:	8082                	ret

000000000000024a <bigwrite>:
{
     24a:	711d                	addi	sp,sp,-96
     24c:	ec86                	sd	ra,88(sp)
     24e:	e8a2                	sd	s0,80(sp)
     250:	e4a6                	sd	s1,72(sp)
     252:	e0ca                	sd	s2,64(sp)
     254:	fc4e                	sd	s3,56(sp)
     256:	f852                	sd	s4,48(sp)
     258:	f456                	sd	s5,40(sp)
     25a:	f05a                	sd	s6,32(sp)
     25c:	ec5e                	sd	s7,24(sp)
     25e:	e862                	sd	s8,16(sp)
     260:	e466                	sd	s9,8(sp)
     262:	1080                	addi	s0,sp,96
     264:	8caa                	mv	s9,a0
  unlink("bigwrite");
     266:	00005517          	auipc	a0,0x5
     26a:	5e250513          	addi	a0,a0,1506 # 5848 <malloc+0x1cc>
     26e:	751040ef          	jal	51be <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     272:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     276:	20200b93          	li	s7,514
     27a:	00005a17          	auipc	s4,0x5
     27e:	5cea0a13          	addi	s4,s4,1486 # 5848 <malloc+0x1cc>
     282:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     284:	0000c997          	auipc	s3,0xc
     288:	a3498993          	addi	s3,s3,-1484 # bcb8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	6a8d                	lui	s5,0x3
     28e:	1c9a8a93          	addi	s5,s5,457 # 31c9 <subdir+0x463>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     292:	85de                	mv	a1,s7
     294:	8552                	mv	a0,s4
     296:	719040ef          	jal	51ae <open>
     29a:	892a                	mv	s2,a0
    if(fd < 0){
     29c:	04054563          	bltz	a0,2e6 <bigwrite+0x9c>
     2a0:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     2a2:	8626                	mv	a2,s1
     2a4:	85ce                	mv	a1,s3
     2a6:	854a                	mv	a0,s2
     2a8:	6e7040ef          	jal	518e <write>
      if(cc != sz){
     2ac:	04951763          	bne	a0,s1,2fa <bigwrite+0xb0>
    for(i = 0; i < 2; i++){
     2b0:	3c7d                	addiw	s8,s8,-1
     2b2:	fe0c18e3          	bnez	s8,2a2 <bigwrite+0x58>
    close(fd);
     2b6:	854a                	mv	a0,s2
     2b8:	6df040ef          	jal	5196 <close>
    unlink("bigwrite");
     2bc:	8552                	mv	a0,s4
     2be:	701040ef          	jal	51be <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2c2:	1d74849b          	addiw	s1,s1,471
     2c6:	fd5496e3          	bne	s1,s5,292 <bigwrite+0x48>
}
     2ca:	4501                	li	a0,0
     2cc:	60e6                	ld	ra,88(sp)
     2ce:	6446                	ld	s0,80(sp)
     2d0:	64a6                	ld	s1,72(sp)
     2d2:	6906                	ld	s2,64(sp)
     2d4:	79e2                	ld	s3,56(sp)
     2d6:	7a42                	ld	s4,48(sp)
     2d8:	7aa2                	ld	s5,40(sp)
     2da:	7b02                	ld	s6,32(sp)
     2dc:	6be2                	ld	s7,24(sp)
     2de:	6c42                	ld	s8,16(sp)
     2e0:	6ca2                	ld	s9,8(sp)
     2e2:	6125                	addi	sp,sp,96
     2e4:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2e6:	85e6                	mv	a1,s9
     2e8:	00005517          	auipc	a0,0x5
     2ec:	57050513          	addi	a0,a0,1392 # 5858 <malloc+0x1dc>
     2f0:	2d4050ef          	jal	55c4 <printf>
      exit(1);
     2f4:	4505                	li	a0,1
     2f6:	679040ef          	jal	516e <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2fa:	86aa                	mv	a3,a0
     2fc:	8626                	mv	a2,s1
     2fe:	85e6                	mv	a1,s9
     300:	00005517          	auipc	a0,0x5
     304:	57850513          	addi	a0,a0,1400 # 5878 <malloc+0x1fc>
     308:	2bc050ef          	jal	55c4 <printf>
        exit(1);
     30c:	4505                	li	a0,1
     30e:	661040ef          	jal	516e <exit>

0000000000000312 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
int
badwrite(char *s)
{
     312:	7139                	addi	sp,sp,-64
     314:	fc06                	sd	ra,56(sp)
     316:	f822                	sd	s0,48(sp)
     318:	f426                	sd	s1,40(sp)
     31a:	f04a                	sd	s2,32(sp)
     31c:	ec4e                	sd	s3,24(sp)
     31e:	e852                	sd	s4,16(sp)
     320:	e456                	sd	s5,8(sp)
     322:	e05a                	sd	s6,0(sp)
     324:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     326:	00005517          	auipc	a0,0x5
     32a:	56a50513          	addi	a0,a0,1386 # 5890 <malloc+0x214>
     32e:	691040ef          	jal	51be <unlink>
     332:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     336:	20100a93          	li	s5,513
     33a:	00005997          	auipc	s3,0x5
     33e:	55698993          	addi	s3,s3,1366 # 5890 <malloc+0x214>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     342:	4b05                	li	s6,1
     344:	5a7d                	li	s4,-1
     346:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     34a:	85d6                	mv	a1,s5
     34c:	854e                	mv	a0,s3
     34e:	661040ef          	jal	51ae <open>
     352:	84aa                	mv	s1,a0
    if(fd < 0){
     354:	06054863          	bltz	a0,3c4 <badwrite+0xb2>
    write(fd, (char*)0xffffffffffL, 1);
     358:	865a                	mv	a2,s6
     35a:	85d2                	mv	a1,s4
     35c:	633040ef          	jal	518e <write>
    close(fd);
     360:	8526                	mv	a0,s1
     362:	635040ef          	jal	5196 <close>
    unlink("junk");
     366:	854e                	mv	a0,s3
     368:	657040ef          	jal	51be <unlink>
  for(int i = 0; i < assumed_free; i++){
     36c:	397d                	addiw	s2,s2,-1
     36e:	fc091ee3          	bnez	s2,34a <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     372:	20100593          	li	a1,513
     376:	00005517          	auipc	a0,0x5
     37a:	51a50513          	addi	a0,a0,1306 # 5890 <malloc+0x214>
     37e:	631040ef          	jal	51ae <open>
     382:	84aa                	mv	s1,a0
  if(fd < 0){
     384:	04054963          	bltz	a0,3d6 <badwrite+0xc4>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     388:	4605                	li	a2,1
     38a:	00005597          	auipc	a1,0x5
     38e:	48e58593          	addi	a1,a1,1166 # 5818 <malloc+0x19c>
     392:	5fd040ef          	jal	518e <write>
     396:	4785                	li	a5,1
     398:	04f51863          	bne	a0,a5,3e8 <badwrite+0xd6>
    printf("write failed\n");
    exit(1);
  }
  close(fd);
     39c:	8526                	mv	a0,s1
     39e:	5f9040ef          	jal	5196 <close>
  unlink("junk");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	4ee50513          	addi	a0,a0,1262 # 5890 <malloc+0x214>
     3aa:	615040ef          	jal	51be <unlink>

  return 0;
}
     3ae:	4501                	li	a0,0
     3b0:	70e2                	ld	ra,56(sp)
     3b2:	7442                	ld	s0,48(sp)
     3b4:	74a2                	ld	s1,40(sp)
     3b6:	7902                	ld	s2,32(sp)
     3b8:	69e2                	ld	s3,24(sp)
     3ba:	6a42                	ld	s4,16(sp)
     3bc:	6aa2                	ld	s5,8(sp)
     3be:	6b02                	ld	s6,0(sp)
     3c0:	6121                	addi	sp,sp,64
     3c2:	8082                	ret
      printf("open junk failed\n");
     3c4:	00005517          	auipc	a0,0x5
     3c8:	4d450513          	addi	a0,a0,1236 # 5898 <malloc+0x21c>
     3cc:	1f8050ef          	jal	55c4 <printf>
      exit(1);
     3d0:	4505                	li	a0,1
     3d2:	59d040ef          	jal	516e <exit>
    printf("open junk failed\n");
     3d6:	00005517          	auipc	a0,0x5
     3da:	4c250513          	addi	a0,a0,1218 # 5898 <malloc+0x21c>
     3de:	1e6050ef          	jal	55c4 <printf>
    exit(1);
     3e2:	4505                	li	a0,1
     3e4:	58b040ef          	jal	516e <exit>
    printf("write failed\n");
     3e8:	00005517          	auipc	a0,0x5
     3ec:	4c850513          	addi	a0,a0,1224 # 58b0 <malloc+0x234>
     3f0:	1d4050ef          	jal	55c4 <printf>
    exit(1);
     3f4:	4505                	li	a0,1
     3f6:	579040ef          	jal	516e <exit>

00000000000003fa <outofinodes>:
  return 0;
}

int
outofinodes(char *s)
{
     3fa:	711d                	addi	sp,sp,-96
     3fc:	ec86                	sd	ra,88(sp)
     3fe:	e8a2                	sd	s0,80(sp)
     400:	e4a6                	sd	s1,72(sp)
     402:	e0ca                	sd	s2,64(sp)
     404:	fc4e                	sd	s3,56(sp)
     406:	f852                	sd	s4,48(sp)
     408:	f456                	sd	s5,40(sp)
     40a:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     40c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     40e:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     412:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     416:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     41a:	40000a93          	li	s5,1024
    name[0] = 'z';
     41e:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     422:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     426:	41f4d71b          	sraiw	a4,s1,0x1f
     42a:	01b7571b          	srliw	a4,a4,0x1b
     42e:	009707bb          	addw	a5,a4,s1
     432:	4057d69b          	sraiw	a3,a5,0x5
     436:	0306869b          	addiw	a3,a3,48
     43a:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     43e:	8bfd                	andi	a5,a5,31
     440:	9f99                	subw	a5,a5,a4
     442:	0307879b          	addiw	a5,a5,48
     446:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     44a:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     44e:	854a                	mv	a0,s2
     450:	56f040ef          	jal	51be <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     454:	85d2                	mv	a1,s4
     456:	854a                	mv	a0,s2
     458:	557040ef          	jal	51ae <open>
    if(fd < 0){
     45c:	00054763          	bltz	a0,46a <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     460:	537040ef          	jal	5196 <close>
  for(int i = 0; i < nzz; i++){
     464:	2485                	addiw	s1,s1,1
     466:	fb549ce3          	bne	s1,s5,41e <outofinodes+0x24>
     46a:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     46c:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     470:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     47c:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d71b          	sraiw	a4,s1,0x1f
     484:	01b7571b          	srliw	a4,a4,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     4a4:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     4a8:	8552                	mv	a0,s4
     4aa:	515040ef          	jal	51be <unlink>
  for(int i = 0; i < nzz; i++){
     4ae:	2485                	addiw	s1,s1,1
     4b0:	fd3494e3          	bne	s1,s3,478 <outofinodes+0x7e>
  }
  return 0;
}
     4b4:	4501                	li	a0,0
     4b6:	60e6                	ld	ra,88(sp)
     4b8:	6446                	ld	s0,80(sp)
     4ba:	64a6                	ld	s1,72(sp)
     4bc:	6906                	ld	s2,64(sp)
     4be:	79e2                	ld	s3,56(sp)
     4c0:	7a42                	ld	s4,48(sp)
     4c2:	7aa2                	ld	s5,40(sp)
     4c4:	6125                	addi	sp,sp,96
     4c6:	8082                	ret

00000000000004c8 <copyin>:
{
     4c8:	7175                	addi	sp,sp,-144
     4ca:	e506                	sd	ra,136(sp)
     4cc:	e122                	sd	s0,128(sp)
     4ce:	fca6                	sd	s1,120(sp)
     4d0:	f8ca                	sd	s2,112(sp)
     4d2:	f4ce                	sd	s3,104(sp)
     4d4:	f0d2                	sd	s4,96(sp)
     4d6:	ecd6                	sd	s5,88(sp)
     4d8:	e8da                	sd	s6,80(sp)
     4da:	e4de                	sd	s7,72(sp)
     4dc:	e0e2                	sd	s8,64(sp)
     4de:	fc66                	sd	s9,56(sp)
     4e0:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4e2:	00008797          	auipc	a5,0x8
     4e6:	82e78793          	addi	a5,a5,-2002 # 7d10 <malloc+0x2694>
     4ea:	638c                	ld	a1,0(a5)
     4ec:	6790                	ld	a2,8(a5)
     4ee:	6b94                	ld	a3,16(a5)
     4f0:	6f98                	ld	a4,24(a5)
     4f2:	f6b43c23          	sd	a1,-136(s0)
     4f6:	f8c43023          	sd	a2,-128(s0)
     4fa:	f8d43423          	sd	a3,-120(s0)
     4fe:	f8e43823          	sd	a4,-112(s0)
     502:	739c                	ld	a5,32(a5)
     504:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     508:	f7840913          	addi	s2,s0,-136
     50c:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     510:	20100b13          	li	s6,513
     514:	00005a97          	auipc	s5,0x5
     518:	3aca8a93          	addi	s5,s5,940 # 58c0 <malloc+0x244>
    int n = write(fd, (void*)addr, 8192);
     51c:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     51e:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     520:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     524:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     528:	85da                	mv	a1,s6
     52a:	8556                	mv	a0,s5
     52c:	483040ef          	jal	51ae <open>
     530:	84aa                	mv	s1,a0
    if(fd < 0){
     532:	06054b63          	bltz	a0,5a8 <copyin+0xe0>
    int n = write(fd, (void*)addr, 8192);
     536:	8652                	mv	a2,s4
     538:	85ce                	mv	a1,s3
     53a:	455040ef          	jal	518e <write>
    if(n >= 0){
     53e:	06055e63          	bgez	a0,5ba <copyin+0xf2>
    close(fd);
     542:	8526                	mv	a0,s1
     544:	453040ef          	jal	5196 <close>
    unlink("copyin1");
     548:	8556                	mv	a0,s5
     54a:	475040ef          	jal	51be <unlink>
    n = write(1, (char*)addr, 8192);
     54e:	8652                	mv	a2,s4
     550:	85ce                	mv	a1,s3
     552:	8562                	mv	a0,s8
     554:	43b040ef          	jal	518e <write>
    if(n > 0){
     558:	06a04c63          	bgtz	a0,5d0 <copyin+0x108>
    if(pipe(fds) < 0){
     55c:	855e                	mv	a0,s7
     55e:	421040ef          	jal	517e <pipe>
     562:	08054263          	bltz	a0,5e6 <copyin+0x11e>
    n = write(fds[1], (char*)addr, 8192);
     566:	8652                	mv	a2,s4
     568:	85ce                	mv	a1,s3
     56a:	f7442503          	lw	a0,-140(s0)
     56e:	421040ef          	jal	518e <write>
    if(n > 0){
     572:	08a04363          	bgtz	a0,5f8 <copyin+0x130>
    close(fds[0]);
     576:	f7042503          	lw	a0,-144(s0)
     57a:	41d040ef          	jal	5196 <close>
    close(fds[1]);
     57e:	f7442503          	lw	a0,-140(s0)
     582:	415040ef          	jal	5196 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     586:	0921                	addi	s2,s2,8
     588:	f9991ee3          	bne	s2,s9,524 <copyin+0x5c>
}
     58c:	4501                	li	a0,0
     58e:	60aa                	ld	ra,136(sp)
     590:	640a                	ld	s0,128(sp)
     592:	74e6                	ld	s1,120(sp)
     594:	7946                	ld	s2,112(sp)
     596:	79a6                	ld	s3,104(sp)
     598:	7a06                	ld	s4,96(sp)
     59a:	6ae6                	ld	s5,88(sp)
     59c:	6b46                	ld	s6,80(sp)
     59e:	6ba6                	ld	s7,72(sp)
     5a0:	6c06                	ld	s8,64(sp)
     5a2:	7ce2                	ld	s9,56(sp)
     5a4:	6149                	addi	sp,sp,144
     5a6:	8082                	ret
      printf("open(copyin1) failed\n");
     5a8:	00005517          	auipc	a0,0x5
     5ac:	32050513          	addi	a0,a0,800 # 58c8 <malloc+0x24c>
     5b0:	014050ef          	jal	55c4 <printf>
      exit(1);
     5b4:	4505                	li	a0,1
     5b6:	3b9040ef          	jal	516e <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     5ba:	862a                	mv	a2,a0
     5bc:	85ce                	mv	a1,s3
     5be:	00005517          	auipc	a0,0x5
     5c2:	32250513          	addi	a0,a0,802 # 58e0 <malloc+0x264>
     5c6:	7ff040ef          	jal	55c4 <printf>
      exit(1);
     5ca:	4505                	li	a0,1
     5cc:	3a3040ef          	jal	516e <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5d0:	862a                	mv	a2,a0
     5d2:	85ce                	mv	a1,s3
     5d4:	00005517          	auipc	a0,0x5
     5d8:	33c50513          	addi	a0,a0,828 # 5910 <malloc+0x294>
     5dc:	7e9040ef          	jal	55c4 <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	38d040ef          	jal	516e <exit>
      printf("pipe() failed\n");
     5e6:	00005517          	auipc	a0,0x5
     5ea:	35a50513          	addi	a0,a0,858 # 5940 <malloc+0x2c4>
     5ee:	7d7040ef          	jal	55c4 <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	37b040ef          	jal	516e <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5f8:	862a                	mv	a2,a0
     5fa:	85ce                	mv	a1,s3
     5fc:	00005517          	auipc	a0,0x5
     600:	35450513          	addi	a0,a0,852 # 5950 <malloc+0x2d4>
     604:	7c1040ef          	jal	55c4 <printf>
      exit(1);
     608:	4505                	li	a0,1
     60a:	365040ef          	jal	516e <exit>

000000000000060e <copyout>:
{
     60e:	7135                	addi	sp,sp,-160
     610:	ed06                	sd	ra,152(sp)
     612:	e922                	sd	s0,144(sp)
     614:	e526                	sd	s1,136(sp)
     616:	e14a                	sd	s2,128(sp)
     618:	fcce                	sd	s3,120(sp)
     61a:	f8d2                	sd	s4,112(sp)
     61c:	f4d6                	sd	s5,104(sp)
     61e:	f0da                	sd	s6,96(sp)
     620:	ecde                	sd	s7,88(sp)
     622:	e8e2                	sd	s8,80(sp)
     624:	e4e6                	sd	s9,72(sp)
     626:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     628:	00007797          	auipc	a5,0x7
     62c:	6e878793          	addi	a5,a5,1768 # 7d10 <malloc+0x2694>
     630:	7788                	ld	a0,40(a5)
     632:	7b8c                	ld	a1,48(a5)
     634:	7f90                	ld	a2,56(a5)
     636:	63b4                	ld	a3,64(a5)
     638:	67b8                	ld	a4,72(a5)
     63a:	f6a43823          	sd	a0,-144(s0)
     63e:	f6b43c23          	sd	a1,-136(s0)
     642:	f8c43023          	sd	a2,-128(s0)
     646:	f8d43423          	sd	a3,-120(s0)
     64a:	f8e43823          	sd	a4,-112(s0)
     64e:	6bbc                	ld	a5,80(a5)
     650:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     654:	f7040913          	addi	s2,s0,-144
     658:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     65c:	00005b17          	auipc	s6,0x5
     660:	324b0b13          	addi	s6,s6,804 # 5980 <malloc+0x304>
    int n = read(fd, (void*)addr, 8192);
     664:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     666:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     66a:	4a05                	li	s4,1
     66c:	00005b97          	auipc	s7,0x5
     670:	1acb8b93          	addi	s7,s7,428 # 5818 <malloc+0x19c>
    uint64 addr = addrs[ai];
     674:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     678:	4581                	li	a1,0
     67a:	855a                	mv	a0,s6
     67c:	333040ef          	jal	51ae <open>
     680:	84aa                	mv	s1,a0
    if(fd < 0){
     682:	06054963          	bltz	a0,6f4 <copyout+0xe6>
    int n = read(fd, (void*)addr, 8192);
     686:	8656                	mv	a2,s5
     688:	85ce                	mv	a1,s3
     68a:	2fd040ef          	jal	5186 <read>
    if(n > 0){
     68e:	06a04c63          	bgtz	a0,706 <copyout+0xf8>
    close(fd);
     692:	8526                	mv	a0,s1
     694:	303040ef          	jal	5196 <close>
    if(pipe(fds) < 0){
     698:	8562                	mv	a0,s8
     69a:	2e5040ef          	jal	517e <pipe>
     69e:	06054f63          	bltz	a0,71c <copyout+0x10e>
    n = write(fds[1], "x", 1);
     6a2:	8652                	mv	a2,s4
     6a4:	85de                	mv	a1,s7
     6a6:	f6c42503          	lw	a0,-148(s0)
     6aa:	2e5040ef          	jal	518e <write>
    if(n != 1){
     6ae:	09451063          	bne	a0,s4,72e <copyout+0x120>
    n = read(fds[0], (void*)addr, 8192);
     6b2:	8656                	mv	a2,s5
     6b4:	85ce                	mv	a1,s3
     6b6:	f6842503          	lw	a0,-152(s0)
     6ba:	2cd040ef          	jal	5186 <read>
    if(n > 0){
     6be:	08a04163          	bgtz	a0,740 <copyout+0x132>
    close(fds[0]);
     6c2:	f6842503          	lw	a0,-152(s0)
     6c6:	2d1040ef          	jal	5196 <close>
    close(fds[1]);
     6ca:	f6c42503          	lw	a0,-148(s0)
     6ce:	2c9040ef          	jal	5196 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6d2:	0921                	addi	s2,s2,8
     6d4:	fb9910e3          	bne	s2,s9,674 <copyout+0x66>
}
     6d8:	4501                	li	a0,0
     6da:	60ea                	ld	ra,152(sp)
     6dc:	644a                	ld	s0,144(sp)
     6de:	64aa                	ld	s1,136(sp)
     6e0:	690a                	ld	s2,128(sp)
     6e2:	79e6                	ld	s3,120(sp)
     6e4:	7a46                	ld	s4,112(sp)
     6e6:	7aa6                	ld	s5,104(sp)
     6e8:	7b06                	ld	s6,96(sp)
     6ea:	6be6                	ld	s7,88(sp)
     6ec:	6c46                	ld	s8,80(sp)
     6ee:	6ca6                	ld	s9,72(sp)
     6f0:	610d                	addi	sp,sp,160
     6f2:	8082                	ret
      printf("open(README) failed\n");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	29450513          	addi	a0,a0,660 # 5988 <malloc+0x30c>
     6fc:	6c9040ef          	jal	55c4 <printf>
      exit(1);
     700:	4505                	li	a0,1
     702:	26d040ef          	jal	516e <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     706:	862a                	mv	a2,a0
     708:	85ce                	mv	a1,s3
     70a:	00005517          	auipc	a0,0x5
     70e:	29650513          	addi	a0,a0,662 # 59a0 <malloc+0x324>
     712:	6b3040ef          	jal	55c4 <printf>
      exit(1);
     716:	4505                	li	a0,1
     718:	257040ef          	jal	516e <exit>
      printf("pipe() failed\n");
     71c:	00005517          	auipc	a0,0x5
     720:	22450513          	addi	a0,a0,548 # 5940 <malloc+0x2c4>
     724:	6a1040ef          	jal	55c4 <printf>
      exit(1);
     728:	4505                	li	a0,1
     72a:	245040ef          	jal	516e <exit>
      printf("pipe write failed\n");
     72e:	00005517          	auipc	a0,0x5
     732:	2a250513          	addi	a0,a0,674 # 59d0 <malloc+0x354>
     736:	68f040ef          	jal	55c4 <printf>
      exit(1);
     73a:	4505                	li	a0,1
     73c:	233040ef          	jal	516e <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     740:	862a                	mv	a2,a0
     742:	85ce                	mv	a1,s3
     744:	00005517          	auipc	a0,0x5
     748:	2a450513          	addi	a0,a0,676 # 59e8 <malloc+0x36c>
     74c:	679040ef          	jal	55c4 <printf>
      exit(1);
     750:	4505                	li	a0,1
     752:	21d040ef          	jal	516e <exit>

0000000000000756 <truncate1>:
{
     756:	711d                	addi	sp,sp,-96
     758:	ec86                	sd	ra,88(sp)
     75a:	e8a2                	sd	s0,80(sp)
     75c:	e4a6                	sd	s1,72(sp)
     75e:	e0ca                	sd	s2,64(sp)
     760:	fc4e                	sd	s3,56(sp)
     762:	f852                	sd	s4,48(sp)
     764:	f456                	sd	s5,40(sp)
     766:	1080                	addi	s0,sp,96
     768:	8a2a                	mv	s4,a0
  unlink("truncfile");
     76a:	00005517          	auipc	a0,0x5
     76e:	09650513          	addi	a0,a0,150 # 5800 <malloc+0x184>
     772:	24d040ef          	jal	51be <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     776:	60100593          	li	a1,1537
     77a:	00005517          	auipc	a0,0x5
     77e:	08650513          	addi	a0,a0,134 # 5800 <malloc+0x184>
     782:	22d040ef          	jal	51ae <open>
     786:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     788:	4611                	li	a2,4
     78a:	00005597          	auipc	a1,0x5
     78e:	08658593          	addi	a1,a1,134 # 5810 <malloc+0x194>
     792:	1fd040ef          	jal	518e <write>
  close(fd1);
     796:	8526                	mv	a0,s1
     798:	1ff040ef          	jal	5196 <close>
  int fd2 = open("truncfile", O_RDONLY);
     79c:	4581                	li	a1,0
     79e:	00005517          	auipc	a0,0x5
     7a2:	06250513          	addi	a0,a0,98 # 5800 <malloc+0x184>
     7a6:	209040ef          	jal	51ae <open>
     7aa:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     7ac:	02000613          	li	a2,32
     7b0:	fa040593          	addi	a1,s0,-96
     7b4:	1d3040ef          	jal	5186 <read>
  if(n != 4){
     7b8:	4791                	li	a5,4
     7ba:	0af51963          	bne	a0,a5,86c <truncate1+0x116>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     7be:	40100593          	li	a1,1025
     7c2:	00005517          	auipc	a0,0x5
     7c6:	03e50513          	addi	a0,a0,62 # 5800 <malloc+0x184>
     7ca:	1e5040ef          	jal	51ae <open>
     7ce:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7d0:	4581                	li	a1,0
     7d2:	00005517          	auipc	a0,0x5
     7d6:	02e50513          	addi	a0,a0,46 # 5800 <malloc+0x184>
     7da:	1d5040ef          	jal	51ae <open>
     7de:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7e0:	02000613          	li	a2,32
     7e4:	fa040593          	addi	a1,s0,-96
     7e8:	19f040ef          	jal	5186 <read>
     7ec:	8aaa                	mv	s5,a0
  if(n != 0){
     7ee:	e951                	bnez	a0,882 <truncate1+0x12c>
  n = read(fd2, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	8526                	mv	a0,s1
     7fa:	18d040ef          	jal	5186 <read>
     7fe:	8aaa                	mv	s5,a0
  if(n != 0){
     800:	e15d                	bnez	a0,8a6 <truncate1+0x150>
  write(fd1, "abcdef", 6);
     802:	4619                	li	a2,6
     804:	00005597          	auipc	a1,0x5
     808:	27458593          	addi	a1,a1,628 # 5a78 <malloc+0x3fc>
     80c:	854e                	mv	a0,s3
     80e:	181040ef          	jal	518e <write>
  n = read(fd3, buf, sizeof(buf));
     812:	02000613          	li	a2,32
     816:	fa040593          	addi	a1,s0,-96
     81a:	854a                	mv	a0,s2
     81c:	16b040ef          	jal	5186 <read>
  if(n != 6){
     820:	4799                	li	a5,6
     822:	0af51463          	bne	a0,a5,8ca <truncate1+0x174>
  n = read(fd2, buf, sizeof(buf));
     826:	02000613          	li	a2,32
     82a:	fa040593          	addi	a1,s0,-96
     82e:	8526                	mv	a0,s1
     830:	157040ef          	jal	5186 <read>
  if(n != 2){
     834:	4789                	li	a5,2
     836:	0af51563          	bne	a0,a5,8e0 <truncate1+0x18a>
  unlink("truncfile");
     83a:	00005517          	auipc	a0,0x5
     83e:	fc650513          	addi	a0,a0,-58 # 5800 <malloc+0x184>
     842:	17d040ef          	jal	51be <unlink>
  close(fd1);
     846:	854e                	mv	a0,s3
     848:	14f040ef          	jal	5196 <close>
  close(fd2);
     84c:	8526                	mv	a0,s1
     84e:	149040ef          	jal	5196 <close>
  close(fd3);
     852:	854a                	mv	a0,s2
     854:	143040ef          	jal	5196 <close>
}
     858:	4501                	li	a0,0
     85a:	60e6                	ld	ra,88(sp)
     85c:	6446                	ld	s0,80(sp)
     85e:	64a6                	ld	s1,72(sp)
     860:	6906                	ld	s2,64(sp)
     862:	79e2                	ld	s3,56(sp)
     864:	7a42                	ld	s4,48(sp)
     866:	7aa2                	ld	s5,40(sp)
     868:	6125                	addi	sp,sp,96
     86a:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     86c:	862a                	mv	a2,a0
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	1a850513          	addi	a0,a0,424 # 5a18 <malloc+0x39c>
     878:	54d040ef          	jal	55c4 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	0f1040ef          	jal	516e <exit>
    printf("aaa fd3=%d\n", fd3);
     882:	85ca                	mv	a1,s2
     884:	00005517          	auipc	a0,0x5
     888:	1b450513          	addi	a0,a0,436 # 5a38 <malloc+0x3bc>
     88c:	539040ef          	jal	55c4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	1b450513          	addi	a0,a0,436 # 5a48 <malloc+0x3cc>
     89c:	529040ef          	jal	55c4 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	0cd040ef          	jal	516e <exit>
    printf("bbb fd2=%d\n", fd2);
     8a6:	85a6                	mv	a1,s1
     8a8:	00005517          	auipc	a0,0x5
     8ac:	1c050513          	addi	a0,a0,448 # 5a68 <malloc+0x3ec>
     8b0:	515040ef          	jal	55c4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     8b4:	8656                	mv	a2,s5
     8b6:	85d2                	mv	a1,s4
     8b8:	00005517          	auipc	a0,0x5
     8bc:	19050513          	addi	a0,a0,400 # 5a48 <malloc+0x3cc>
     8c0:	505040ef          	jal	55c4 <printf>
    exit(1);
     8c4:	4505                	li	a0,1
     8c6:	0a9040ef          	jal	516e <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8ca:	862a                	mv	a2,a0
     8cc:	85d2                	mv	a1,s4
     8ce:	00005517          	auipc	a0,0x5
     8d2:	1b250513          	addi	a0,a0,434 # 5a80 <malloc+0x404>
     8d6:	4ef040ef          	jal	55c4 <printf>
    exit(1);
     8da:	4505                	li	a0,1
     8dc:	093040ef          	jal	516e <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8e0:	862a                	mv	a2,a0
     8e2:	85d2                	mv	a1,s4
     8e4:	00005517          	auipc	a0,0x5
     8e8:	1bc50513          	addi	a0,a0,444 # 5aa0 <malloc+0x424>
     8ec:	4d9040ef          	jal	55c4 <printf>
    exit(1);
     8f0:	4505                	li	a0,1
     8f2:	07d040ef          	jal	516e <exit>

00000000000008f6 <writetest>:
{
     8f6:	715d                	addi	sp,sp,-80
     8f8:	e486                	sd	ra,72(sp)
     8fa:	e0a2                	sd	s0,64(sp)
     8fc:	fc26                	sd	s1,56(sp)
     8fe:	f84a                	sd	s2,48(sp)
     900:	f44e                	sd	s3,40(sp)
     902:	f052                	sd	s4,32(sp)
     904:	ec56                	sd	s5,24(sp)
     906:	e85a                	sd	s6,16(sp)
     908:	e45e                	sd	s7,8(sp)
     90a:	0880                	addi	s0,sp,80
     90c:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     90e:	20200593          	li	a1,514
     912:	00005517          	auipc	a0,0x5
     916:	1ae50513          	addi	a0,a0,430 # 5ac0 <malloc+0x444>
     91a:	095040ef          	jal	51ae <open>
  if(fd < 0){
     91e:	0a054063          	bltz	a0,9be <writetest+0xc8>
     922:	89aa                	mv	s3,a0
     924:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     926:	44a9                	li	s1,10
     928:	00005a17          	auipc	s4,0x5
     92c:	1c0a0a13          	addi	s4,s4,448 # 5ae8 <malloc+0x46c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     930:	00005b17          	auipc	s6,0x5
     934:	1f0b0b13          	addi	s6,s6,496 # 5b20 <malloc+0x4a4>
  for(i = 0; i < N; i++){
     938:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     93c:	8626                	mv	a2,s1
     93e:	85d2                	mv	a1,s4
     940:	854e                	mv	a0,s3
     942:	04d040ef          	jal	518e <write>
     946:	08951663          	bne	a0,s1,9d2 <writetest+0xdc>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     94a:	8626                	mv	a2,s1
     94c:	85da                	mv	a1,s6
     94e:	854e                	mv	a0,s3
     950:	03f040ef          	jal	518e <write>
     954:	08951a63          	bne	a0,s1,9e8 <writetest+0xf2>
  for(i = 0; i < N; i++){
     958:	2905                	addiw	s2,s2,1
     95a:	ff5911e3          	bne	s2,s5,93c <writetest+0x46>
  close(fd);
     95e:	854e                	mv	a0,s3
     960:	037040ef          	jal	5196 <close>
  fd = open("small", O_RDONLY);
     964:	4581                	li	a1,0
     966:	00005517          	auipc	a0,0x5
     96a:	15a50513          	addi	a0,a0,346 # 5ac0 <malloc+0x444>
     96e:	041040ef          	jal	51ae <open>
     972:	84aa                	mv	s1,a0
  if(fd < 0){
     974:	08054563          	bltz	a0,9fe <writetest+0x108>
  i = read(fd, buf, N*SZ*2);
     978:	7d000613          	li	a2,2000
     97c:	0000b597          	auipc	a1,0xb
     980:	33c58593          	addi	a1,a1,828 # bcb8 <buf>
     984:	003040ef          	jal	5186 <read>
  if(i != N*SZ*2){
     988:	7d000793          	li	a5,2000
     98c:	08f51363          	bne	a0,a5,a12 <writetest+0x11c>
  close(fd);
     990:	8526                	mv	a0,s1
     992:	005040ef          	jal	5196 <close>
  if(unlink("small") < 0){
     996:	00005517          	auipc	a0,0x5
     99a:	12a50513          	addi	a0,a0,298 # 5ac0 <malloc+0x444>
     99e:	021040ef          	jal	51be <unlink>
     9a2:	08054263          	bltz	a0,a26 <writetest+0x130>
}
     9a6:	4501                	li	a0,0
     9a8:	60a6                	ld	ra,72(sp)
     9aa:	6406                	ld	s0,64(sp)
     9ac:	74e2                	ld	s1,56(sp)
     9ae:	7942                	ld	s2,48(sp)
     9b0:	79a2                	ld	s3,40(sp)
     9b2:	7a02                	ld	s4,32(sp)
     9b4:	6ae2                	ld	s5,24(sp)
     9b6:	6b42                	ld	s6,16(sp)
     9b8:	6ba2                	ld	s7,8(sp)
     9ba:	6161                	addi	sp,sp,80
     9bc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     9be:	85de                	mv	a1,s7
     9c0:	00005517          	auipc	a0,0x5
     9c4:	10850513          	addi	a0,a0,264 # 5ac8 <malloc+0x44c>
     9c8:	3fd040ef          	jal	55c4 <printf>
    exit(1);
     9cc:	4505                	li	a0,1
     9ce:	7a0040ef          	jal	516e <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9d2:	864a                	mv	a2,s2
     9d4:	85de                	mv	a1,s7
     9d6:	00005517          	auipc	a0,0x5
     9da:	12250513          	addi	a0,a0,290 # 5af8 <malloc+0x47c>
     9de:	3e7040ef          	jal	55c4 <printf>
      exit(1);
     9e2:	4505                	li	a0,1
     9e4:	78a040ef          	jal	516e <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9e8:	864a                	mv	a2,s2
     9ea:	85de                	mv	a1,s7
     9ec:	00005517          	auipc	a0,0x5
     9f0:	14450513          	addi	a0,a0,324 # 5b30 <malloc+0x4b4>
     9f4:	3d1040ef          	jal	55c4 <printf>
      exit(1);
     9f8:	4505                	li	a0,1
     9fa:	774040ef          	jal	516e <exit>
    printf("%s: error: open small failed!\n", s);
     9fe:	85de                	mv	a1,s7
     a00:	00005517          	auipc	a0,0x5
     a04:	15850513          	addi	a0,a0,344 # 5b58 <malloc+0x4dc>
     a08:	3bd040ef          	jal	55c4 <printf>
    exit(1);
     a0c:	4505                	li	a0,1
     a0e:	760040ef          	jal	516e <exit>
    printf("%s: read failed\n", s);
     a12:	85de                	mv	a1,s7
     a14:	00005517          	auipc	a0,0x5
     a18:	16450513          	addi	a0,a0,356 # 5b78 <malloc+0x4fc>
     a1c:	3a9040ef          	jal	55c4 <printf>
    exit(1);
     a20:	4505                	li	a0,1
     a22:	74c040ef          	jal	516e <exit>
    printf("%s: unlink small failed\n", s);
     a26:	85de                	mv	a1,s7
     a28:	00005517          	auipc	a0,0x5
     a2c:	16850513          	addi	a0,a0,360 # 5b90 <malloc+0x514>
     a30:	395040ef          	jal	55c4 <printf>
    exit(1);
     a34:	4505                	li	a0,1
     a36:	738040ef          	jal	516e <exit>

0000000000000a3a <writebig>:
{
     a3a:	7139                	addi	sp,sp,-64
     a3c:	fc06                	sd	ra,56(sp)
     a3e:	f822                	sd	s0,48(sp)
     a40:	f426                	sd	s1,40(sp)
     a42:	f04a                	sd	s2,32(sp)
     a44:	ec4e                	sd	s3,24(sp)
     a46:	e852                	sd	s4,16(sp)
     a48:	e456                	sd	s5,8(sp)
     a4a:	e05a                	sd	s6,0(sp)
     a4c:	0080                	addi	s0,sp,64
     a4e:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     a50:	20200593          	li	a1,514
     a54:	00005517          	auipc	a0,0x5
     a58:	15c50513          	addi	a0,a0,348 # 5bb0 <malloc+0x534>
     a5c:	752040ef          	jal	51ae <open>
  if(fd < 0){
     a60:	06054a63          	bltz	a0,ad4 <writebig+0x9a>
     a64:	8a2a                	mv	s4,a0
     a66:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a68:	0000b997          	auipc	s3,0xb
     a6c:	25098993          	addi	s3,s3,592 # bcb8 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a70:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a74:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     a78:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a7c:	864a                	mv	a2,s2
     a7e:	85ce                	mv	a1,s3
     a80:	8552                	mv	a0,s4
     a82:	70c040ef          	jal	518e <write>
     a86:	07251163          	bne	a0,s2,ae8 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
     a8a:	2485                	addiw	s1,s1,1
     a8c:	ff5496e3          	bne	s1,s5,a78 <writebig+0x3e>
  close(fd);
     a90:	8552                	mv	a0,s4
     a92:	704040ef          	jal	5196 <close>
  fd = open("big", O_RDONLY);
     a96:	4581                	li	a1,0
     a98:	00005517          	auipc	a0,0x5
     a9c:	11850513          	addi	a0,a0,280 # 5bb0 <malloc+0x534>
     aa0:	70e040ef          	jal	51ae <open>
     aa4:	8a2a                	mv	s4,a0
  n = 0;
     aa6:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     aa8:	40000993          	li	s3,1024
     aac:	0000b917          	auipc	s2,0xb
     ab0:	20c90913          	addi	s2,s2,524 # bcb8 <buf>
  if(fd < 0){
     ab4:	04054563          	bltz	a0,afe <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     ab8:	864e                	mv	a2,s3
     aba:	85ca                	mv	a1,s2
     abc:	8552                	mv	a0,s4
     abe:	6c8040ef          	jal	5186 <read>
    if(i == 0){
     ac2:	c921                	beqz	a0,b12 <writebig+0xd8>
    } else if(i != BSIZE){
     ac4:	09351c63          	bne	a0,s3,b5c <writebig+0x122>
    if(((int*)buf)[0] != n){
     ac8:	00092683          	lw	a3,0(s2)
     acc:	0a969363          	bne	a3,s1,b72 <writebig+0x138>
    n++;
     ad0:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     ad2:	b7dd                	j	ab8 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     ad4:	85da                	mv	a1,s6
     ad6:	00005517          	auipc	a0,0x5
     ada:	0e250513          	addi	a0,a0,226 # 5bb8 <malloc+0x53c>
     ade:	2e7040ef          	jal	55c4 <printf>
    exit(1);
     ae2:	4505                	li	a0,1
     ae4:	68a040ef          	jal	516e <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ae8:	8626                	mv	a2,s1
     aea:	85da                	mv	a1,s6
     aec:	00005517          	auipc	a0,0x5
     af0:	0ec50513          	addi	a0,a0,236 # 5bd8 <malloc+0x55c>
     af4:	2d1040ef          	jal	55c4 <printf>
      exit(1);
     af8:	4505                	li	a0,1
     afa:	674040ef          	jal	516e <exit>
    printf("%s: error: open big failed!\n", s);
     afe:	85da                	mv	a1,s6
     b00:	00005517          	auipc	a0,0x5
     b04:	10050513          	addi	a0,a0,256 # 5c00 <malloc+0x584>
     b08:	2bd040ef          	jal	55c4 <printf>
    exit(1);
     b0c:	4505                	li	a0,1
     b0e:	660040ef          	jal	516e <exit>
      if(n != MAXFILE){
     b12:	10c00793          	li	a5,268
     b16:	02f49863          	bne	s1,a5,b46 <writebig+0x10c>
  close(fd);
     b1a:	8552                	mv	a0,s4
     b1c:	67a040ef          	jal	5196 <close>
  if(unlink("big") < 0){
     b20:	00005517          	auipc	a0,0x5
     b24:	09050513          	addi	a0,a0,144 # 5bb0 <malloc+0x534>
     b28:	696040ef          	jal	51be <unlink>
     b2c:	04054e63          	bltz	a0,b88 <writebig+0x14e>
}
     b30:	4501                	li	a0,0
     b32:	70e2                	ld	ra,56(sp)
     b34:	7442                	ld	s0,48(sp)
     b36:	74a2                	ld	s1,40(sp)
     b38:	7902                	ld	s2,32(sp)
     b3a:	69e2                	ld	s3,24(sp)
     b3c:	6a42                	ld	s4,16(sp)
     b3e:	6aa2                	ld	s5,8(sp)
     b40:	6b02                	ld	s6,0(sp)
     b42:	6121                	addi	sp,sp,64
     b44:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b46:	8626                	mv	a2,s1
     b48:	85da                	mv	a1,s6
     b4a:	00005517          	auipc	a0,0x5
     b4e:	0d650513          	addi	a0,a0,214 # 5c20 <malloc+0x5a4>
     b52:	273040ef          	jal	55c4 <printf>
        exit(1);
     b56:	4505                	li	a0,1
     b58:	616040ef          	jal	516e <exit>
      printf("%s: read failed %d\n", s, i);
     b5c:	862a                	mv	a2,a0
     b5e:	85da                	mv	a1,s6
     b60:	00005517          	auipc	a0,0x5
     b64:	0e850513          	addi	a0,a0,232 # 5c48 <malloc+0x5cc>
     b68:	25d040ef          	jal	55c4 <printf>
      exit(1);
     b6c:	4505                	li	a0,1
     b6e:	600040ef          	jal	516e <exit>
      printf("%s: read content of block %d is %d\n", s,
     b72:	8626                	mv	a2,s1
     b74:	85da                	mv	a1,s6
     b76:	00005517          	auipc	a0,0x5
     b7a:	0ea50513          	addi	a0,a0,234 # 5c60 <malloc+0x5e4>
     b7e:	247040ef          	jal	55c4 <printf>
      exit(1);
     b82:	4505                	li	a0,1
     b84:	5ea040ef          	jal	516e <exit>
    printf("%s: unlink big failed\n", s);
     b88:	85da                	mv	a1,s6
     b8a:	00005517          	auipc	a0,0x5
     b8e:	0fe50513          	addi	a0,a0,254 # 5c88 <malloc+0x60c>
     b92:	233040ef          	jal	55c4 <printf>
    exit(1);
     b96:	4505                	li	a0,1
     b98:	5d6040ef          	jal	516e <exit>

0000000000000b9c <unlinkread>:
{
     b9c:	7179                	addi	sp,sp,-48
     b9e:	f406                	sd	ra,40(sp)
     ba0:	f022                	sd	s0,32(sp)
     ba2:	ec26                	sd	s1,24(sp)
     ba4:	e84a                	sd	s2,16(sp)
     ba6:	e44e                	sd	s3,8(sp)
     ba8:	1800                	addi	s0,sp,48
     baa:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     bac:	20200593          	li	a1,514
     bb0:	00005517          	auipc	a0,0x5
     bb4:	0f050513          	addi	a0,a0,240 # 5ca0 <malloc+0x624>
     bb8:	5f6040ef          	jal	51ae <open>
  if(fd < 0){
     bbc:	0c054063          	bltz	a0,c7c <unlinkread+0xe0>
     bc0:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     bc2:	4615                	li	a2,5
     bc4:	00005597          	auipc	a1,0x5
     bc8:	10c58593          	addi	a1,a1,268 # 5cd0 <malloc+0x654>
     bcc:	5c2040ef          	jal	518e <write>
  close(fd);
     bd0:	8526                	mv	a0,s1
     bd2:	5c4040ef          	jal	5196 <close>
  fd = open("unlinkread", O_RDWR);
     bd6:	4589                	li	a1,2
     bd8:	00005517          	auipc	a0,0x5
     bdc:	0c850513          	addi	a0,a0,200 # 5ca0 <malloc+0x624>
     be0:	5ce040ef          	jal	51ae <open>
     be4:	84aa                	mv	s1,a0
  if(fd < 0){
     be6:	0a054563          	bltz	a0,c90 <unlinkread+0xf4>
  if(unlink("unlinkread") != 0){
     bea:	00005517          	auipc	a0,0x5
     bee:	0b650513          	addi	a0,a0,182 # 5ca0 <malloc+0x624>
     bf2:	5cc040ef          	jal	51be <unlink>
     bf6:	e55d                	bnez	a0,ca4 <unlinkread+0x108>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bf8:	20200593          	li	a1,514
     bfc:	00005517          	auipc	a0,0x5
     c00:	0a450513          	addi	a0,a0,164 # 5ca0 <malloc+0x624>
     c04:	5aa040ef          	jal	51ae <open>
     c08:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     c0a:	460d                	li	a2,3
     c0c:	00005597          	auipc	a1,0x5
     c10:	10c58593          	addi	a1,a1,268 # 5d18 <malloc+0x69c>
     c14:	57a040ef          	jal	518e <write>
  close(fd1);
     c18:	854a                	mv	a0,s2
     c1a:	57c040ef          	jal	5196 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c1e:	660d                	lui	a2,0x3
     c20:	0000b597          	auipc	a1,0xb
     c24:	09858593          	addi	a1,a1,152 # bcb8 <buf>
     c28:	8526                	mv	a0,s1
     c2a:	55c040ef          	jal	5186 <read>
     c2e:	4795                	li	a5,5
     c30:	08f51463          	bne	a0,a5,cb8 <unlinkread+0x11c>
  if(buf[0] != 'h'){
     c34:	0000b717          	auipc	a4,0xb
     c38:	08474703          	lbu	a4,132(a4) # bcb8 <buf>
     c3c:	06800793          	li	a5,104
     c40:	08f71663          	bne	a4,a5,ccc <unlinkread+0x130>
  if(write(fd, buf, 10) != 10){
     c44:	4629                	li	a2,10
     c46:	0000b597          	auipc	a1,0xb
     c4a:	07258593          	addi	a1,a1,114 # bcb8 <buf>
     c4e:	8526                	mv	a0,s1
     c50:	53e040ef          	jal	518e <write>
     c54:	47a9                	li	a5,10
     c56:	08f51563          	bne	a0,a5,ce0 <unlinkread+0x144>
  close(fd);
     c5a:	8526                	mv	a0,s1
     c5c:	53a040ef          	jal	5196 <close>
  unlink("unlinkread");
     c60:	00005517          	auipc	a0,0x5
     c64:	04050513          	addi	a0,a0,64 # 5ca0 <malloc+0x624>
     c68:	556040ef          	jal	51be <unlink>
}
     c6c:	4501                	li	a0,0
     c6e:	70a2                	ld	ra,40(sp)
     c70:	7402                	ld	s0,32(sp)
     c72:	64e2                	ld	s1,24(sp)
     c74:	6942                	ld	s2,16(sp)
     c76:	69a2                	ld	s3,8(sp)
     c78:	6145                	addi	sp,sp,48
     c7a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c7c:	85ce                	mv	a1,s3
     c7e:	00005517          	auipc	a0,0x5
     c82:	03250513          	addi	a0,a0,50 # 5cb0 <malloc+0x634>
     c86:	13f040ef          	jal	55c4 <printf>
    exit(1);
     c8a:	4505                	li	a0,1
     c8c:	4e2040ef          	jal	516e <exit>
    printf("%s: open unlinkread failed\n", s);
     c90:	85ce                	mv	a1,s3
     c92:	00005517          	auipc	a0,0x5
     c96:	04650513          	addi	a0,a0,70 # 5cd8 <malloc+0x65c>
     c9a:	12b040ef          	jal	55c4 <printf>
    exit(1);
     c9e:	4505                	li	a0,1
     ca0:	4ce040ef          	jal	516e <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	05250513          	addi	a0,a0,82 # 5cf8 <malloc+0x67c>
     cae:	117040ef          	jal	55c4 <printf>
    exit(1);
     cb2:	4505                	li	a0,1
     cb4:	4ba040ef          	jal	516e <exit>
    printf("%s: unlinkread read failed", s);
     cb8:	85ce                	mv	a1,s3
     cba:	00005517          	auipc	a0,0x5
     cbe:	06650513          	addi	a0,a0,102 # 5d20 <malloc+0x6a4>
     cc2:	103040ef          	jal	55c4 <printf>
    exit(1);
     cc6:	4505                	li	a0,1
     cc8:	4a6040ef          	jal	516e <exit>
    printf("%s: unlinkread wrong data\n", s);
     ccc:	85ce                	mv	a1,s3
     cce:	00005517          	auipc	a0,0x5
     cd2:	07250513          	addi	a0,a0,114 # 5d40 <malloc+0x6c4>
     cd6:	0ef040ef          	jal	55c4 <printf>
    exit(1);
     cda:	4505                	li	a0,1
     cdc:	492040ef          	jal	516e <exit>
    printf("%s: unlinkread write failed\n", s);
     ce0:	85ce                	mv	a1,s3
     ce2:	00005517          	auipc	a0,0x5
     ce6:	07e50513          	addi	a0,a0,126 # 5d60 <malloc+0x6e4>
     cea:	0db040ef          	jal	55c4 <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	47e040ef          	jal	516e <exit>

0000000000000cf4 <linktest>:
{
     cf4:	1101                	addi	sp,sp,-32
     cf6:	ec06                	sd	ra,24(sp)
     cf8:	e822                	sd	s0,16(sp)
     cfa:	e426                	sd	s1,8(sp)
     cfc:	e04a                	sd	s2,0(sp)
     cfe:	1000                	addi	s0,sp,32
     d00:	892a                	mv	s2,a0
  unlink("lf1");
     d02:	00005517          	auipc	a0,0x5
     d06:	07e50513          	addi	a0,a0,126 # 5d80 <malloc+0x704>
     d0a:	4b4040ef          	jal	51be <unlink>
  unlink("lf2");
     d0e:	00005517          	auipc	a0,0x5
     d12:	07a50513          	addi	a0,a0,122 # 5d88 <malloc+0x70c>
     d16:	4a8040ef          	jal	51be <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d1a:	20200593          	li	a1,514
     d1e:	00005517          	auipc	a0,0x5
     d22:	06250513          	addi	a0,a0,98 # 5d80 <malloc+0x704>
     d26:	488040ef          	jal	51ae <open>
  if(fd < 0){
     d2a:	0e054063          	bltz	a0,e0a <linktest+0x116>
     d2e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d30:	4615                	li	a2,5
     d32:	00005597          	auipc	a1,0x5
     d36:	f9e58593          	addi	a1,a1,-98 # 5cd0 <malloc+0x654>
     d3a:	454040ef          	jal	518e <write>
     d3e:	4795                	li	a5,5
     d40:	0cf51f63          	bne	a0,a5,e1e <linktest+0x12a>
  close(fd);
     d44:	8526                	mv	a0,s1
     d46:	450040ef          	jal	5196 <close>
  if(link("lf1", "lf2") < 0){
     d4a:	00005597          	auipc	a1,0x5
     d4e:	03e58593          	addi	a1,a1,62 # 5d88 <malloc+0x70c>
     d52:	00005517          	auipc	a0,0x5
     d56:	02e50513          	addi	a0,a0,46 # 5d80 <malloc+0x704>
     d5a:	474040ef          	jal	51ce <link>
     d5e:	0c054a63          	bltz	a0,e32 <linktest+0x13e>
  unlink("lf1");
     d62:	00005517          	auipc	a0,0x5
     d66:	01e50513          	addi	a0,a0,30 # 5d80 <malloc+0x704>
     d6a:	454040ef          	jal	51be <unlink>
  if(open("lf1", 0) >= 0){
     d6e:	4581                	li	a1,0
     d70:	00005517          	auipc	a0,0x5
     d74:	01050513          	addi	a0,a0,16 # 5d80 <malloc+0x704>
     d78:	436040ef          	jal	51ae <open>
     d7c:	0c055563          	bgez	a0,e46 <linktest+0x152>
  fd = open("lf2", 0);
     d80:	4581                	li	a1,0
     d82:	00005517          	auipc	a0,0x5
     d86:	00650513          	addi	a0,a0,6 # 5d88 <malloc+0x70c>
     d8a:	424040ef          	jal	51ae <open>
     d8e:	84aa                	mv	s1,a0
  if(fd < 0){
     d90:	0c054563          	bltz	a0,e5a <linktest+0x166>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d94:	660d                	lui	a2,0x3
     d96:	0000b597          	auipc	a1,0xb
     d9a:	f2258593          	addi	a1,a1,-222 # bcb8 <buf>
     d9e:	3e8040ef          	jal	5186 <read>
     da2:	4795                	li	a5,5
     da4:	0cf51563          	bne	a0,a5,e6e <linktest+0x17a>
  close(fd);
     da8:	8526                	mv	a0,s1
     daa:	3ec040ef          	jal	5196 <close>
  if(link("lf2", "lf2") >= 0){
     dae:	00005597          	auipc	a1,0x5
     db2:	fda58593          	addi	a1,a1,-38 # 5d88 <malloc+0x70c>
     db6:	852e                	mv	a0,a1
     db8:	416040ef          	jal	51ce <link>
     dbc:	0c055363          	bgez	a0,e82 <linktest+0x18e>
  unlink("lf2");
     dc0:	00005517          	auipc	a0,0x5
     dc4:	fc850513          	addi	a0,a0,-56 # 5d88 <malloc+0x70c>
     dc8:	3f6040ef          	jal	51be <unlink>
  if(link("lf2", "lf1") >= 0){
     dcc:	00005597          	auipc	a1,0x5
     dd0:	fb458593          	addi	a1,a1,-76 # 5d80 <malloc+0x704>
     dd4:	00005517          	auipc	a0,0x5
     dd8:	fb450513          	addi	a0,a0,-76 # 5d88 <malloc+0x70c>
     ddc:	3f2040ef          	jal	51ce <link>
     de0:	0a055b63          	bgez	a0,e96 <linktest+0x1a2>
  if(link(".", "lf1") >= 0){
     de4:	00005597          	auipc	a1,0x5
     de8:	f9c58593          	addi	a1,a1,-100 # 5d80 <malloc+0x704>
     dec:	00005517          	auipc	a0,0x5
     df0:	0a450513          	addi	a0,a0,164 # 5e90 <malloc+0x814>
     df4:	3da040ef          	jal	51ce <link>
     df8:	0a055963          	bgez	a0,eaa <linktest+0x1b6>
}
     dfc:	4501                	li	a0,0
     dfe:	60e2                	ld	ra,24(sp)
     e00:	6442                	ld	s0,16(sp)
     e02:	64a2                	ld	s1,8(sp)
     e04:	6902                	ld	s2,0(sp)
     e06:	6105                	addi	sp,sp,32
     e08:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e0a:	85ca                	mv	a1,s2
     e0c:	00005517          	auipc	a0,0x5
     e10:	f8450513          	addi	a0,a0,-124 # 5d90 <malloc+0x714>
     e14:	7b0040ef          	jal	55c4 <printf>
    exit(1);
     e18:	4505                	li	a0,1
     e1a:	354040ef          	jal	516e <exit>
    printf("%s: write lf1 failed\n", s);
     e1e:	85ca                	mv	a1,s2
     e20:	00005517          	auipc	a0,0x5
     e24:	f8850513          	addi	a0,a0,-120 # 5da8 <malloc+0x72c>
     e28:	79c040ef          	jal	55c4 <printf>
    exit(1);
     e2c:	4505                	li	a0,1
     e2e:	340040ef          	jal	516e <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e32:	85ca                	mv	a1,s2
     e34:	00005517          	auipc	a0,0x5
     e38:	f8c50513          	addi	a0,a0,-116 # 5dc0 <malloc+0x744>
     e3c:	788040ef          	jal	55c4 <printf>
    exit(1);
     e40:	4505                	li	a0,1
     e42:	32c040ef          	jal	516e <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e46:	85ca                	mv	a1,s2
     e48:	00005517          	auipc	a0,0x5
     e4c:	f9850513          	addi	a0,a0,-104 # 5de0 <malloc+0x764>
     e50:	774040ef          	jal	55c4 <printf>
    exit(1);
     e54:	4505                	li	a0,1
     e56:	318040ef          	jal	516e <exit>
    printf("%s: open lf2 failed\n", s);
     e5a:	85ca                	mv	a1,s2
     e5c:	00005517          	auipc	a0,0x5
     e60:	fb450513          	addi	a0,a0,-76 # 5e10 <malloc+0x794>
     e64:	760040ef          	jal	55c4 <printf>
    exit(1);
     e68:	4505                	li	a0,1
     e6a:	304040ef          	jal	516e <exit>
    printf("%s: read lf2 failed\n", s);
     e6e:	85ca                	mv	a1,s2
     e70:	00005517          	auipc	a0,0x5
     e74:	fb850513          	addi	a0,a0,-72 # 5e28 <malloc+0x7ac>
     e78:	74c040ef          	jal	55c4 <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	2f0040ef          	jal	516e <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	fbc50513          	addi	a0,a0,-68 # 5e40 <malloc+0x7c4>
     e8c:	738040ef          	jal	55c4 <printf>
    exit(1);
     e90:	4505                	li	a0,1
     e92:	2dc040ef          	jal	516e <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e96:	85ca                	mv	a1,s2
     e98:	00005517          	auipc	a0,0x5
     e9c:	fd050513          	addi	a0,a0,-48 # 5e68 <malloc+0x7ec>
     ea0:	724040ef          	jal	55c4 <printf>
    exit(1);
     ea4:	4505                	li	a0,1
     ea6:	2c8040ef          	jal	516e <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     eaa:	85ca                	mv	a1,s2
     eac:	00005517          	auipc	a0,0x5
     eb0:	fec50513          	addi	a0,a0,-20 # 5e98 <malloc+0x81c>
     eb4:	710040ef          	jal	55c4 <printf>
    exit(1);
     eb8:	4505                	li	a0,1
     eba:	2b4040ef          	jal	516e <exit>

0000000000000ebe <validatetest>:
{
     ebe:	7139                	addi	sp,sp,-64
     ec0:	fc06                	sd	ra,56(sp)
     ec2:	f822                	sd	s0,48(sp)
     ec4:	f426                	sd	s1,40(sp)
     ec6:	f04a                	sd	s2,32(sp)
     ec8:	ec4e                	sd	s3,24(sp)
     eca:	e852                	sd	s4,16(sp)
     ecc:	e456                	sd	s5,8(sp)
     ece:	e05a                	sd	s6,0(sp)
     ed0:	0080                	addi	s0,sp,64
     ed2:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ed4:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     ed6:	00005997          	auipc	s3,0x5
     eda:	fe298993          	addi	s3,s3,-30 # 5eb8 <malloc+0x83c>
     ede:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ee0:	6a85                	lui	s5,0x1
     ee2:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     ee6:	85a6                	mv	a1,s1
     ee8:	854e                	mv	a0,s3
     eea:	2e4040ef          	jal	51ce <link>
     eee:	03251063          	bne	a0,s2,f0e <validatetest+0x50>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ef2:	94d6                	add	s1,s1,s5
     ef4:	ff4499e3          	bne	s1,s4,ee6 <validatetest+0x28>
}
     ef8:	4501                	li	a0,0
     efa:	70e2                	ld	ra,56(sp)
     efc:	7442                	ld	s0,48(sp)
     efe:	74a2                	ld	s1,40(sp)
     f00:	7902                	ld	s2,32(sp)
     f02:	69e2                	ld	s3,24(sp)
     f04:	6a42                	ld	s4,16(sp)
     f06:	6aa2                	ld	s5,8(sp)
     f08:	6b02                	ld	s6,0(sp)
     f0a:	6121                	addi	sp,sp,64
     f0c:	8082                	ret
      printf("%s: link should not succeed\n", s);
     f0e:	85da                	mv	a1,s6
     f10:	00005517          	auipc	a0,0x5
     f14:	fb850513          	addi	a0,a0,-72 # 5ec8 <malloc+0x84c>
     f18:	6ac040ef          	jal	55c4 <printf>
      exit(1);
     f1c:	4505                	li	a0,1
     f1e:	250040ef          	jal	516e <exit>

0000000000000f22 <bigdir>:
{
     f22:	711d                	addi	sp,sp,-96
     f24:	ec86                	sd	ra,88(sp)
     f26:	e8a2                	sd	s0,80(sp)
     f28:	e4a6                	sd	s1,72(sp)
     f2a:	e0ca                	sd	s2,64(sp)
     f2c:	fc4e                	sd	s3,56(sp)
     f2e:	f852                	sd	s4,48(sp)
     f30:	f456                	sd	s5,40(sp)
     f32:	f05a                	sd	s6,32(sp)
     f34:	ec5e                	sd	s7,24(sp)
     f36:	1080                	addi	s0,sp,96
     f38:	8baa                	mv	s7,a0
  unlink("bd");
     f3a:	00005517          	auipc	a0,0x5
     f3e:	fae50513          	addi	a0,a0,-82 # 5ee8 <malloc+0x86c>
     f42:	27c040ef          	jal	51be <unlink>
  fd = open("bd", O_CREATE);
     f46:	20000593          	li	a1,512
     f4a:	00005517          	auipc	a0,0x5
     f4e:	f9e50513          	addi	a0,a0,-98 # 5ee8 <malloc+0x86c>
     f52:	25c040ef          	jal	51ae <open>
  if(fd < 0){
     f56:	0c054463          	bltz	a0,101e <bigdir+0xfc>
  close(fd);
     f5a:	23c040ef          	jal	5196 <close>
  for(i = 0; i < N; i++){
     f5e:	4901                	li	s2,0
    name[0] = 'x';
     f60:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     f64:	fa040a13          	addi	s4,s0,-96
     f68:	00005997          	auipc	s3,0x5
     f6c:	f8098993          	addi	s3,s3,-128 # 5ee8 <malloc+0x86c>
  for(i = 0; i < N; i++){
     f70:	1f400b13          	li	s6,500
    name[0] = 'x';
     f74:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f78:	41f9571b          	sraiw	a4,s2,0x1f
     f7c:	01a7571b          	srliw	a4,a4,0x1a
     f80:	012707bb          	addw	a5,a4,s2
     f84:	4067d69b          	sraiw	a3,a5,0x6
     f88:	0306869b          	addiw	a3,a3,48
     f8c:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f90:	03f7f793          	andi	a5,a5,63
     f94:	9f99                	subw	a5,a5,a4
     f96:	0307879b          	addiw	a5,a5,48
     f9a:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f9e:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     fa2:	85d2                	mv	a1,s4
     fa4:	854e                	mv	a0,s3
     fa6:	228040ef          	jal	51ce <link>
     faa:	84aa                	mv	s1,a0
     fac:	e159                	bnez	a0,1032 <bigdir+0x110>
  for(i = 0; i < N; i++){
     fae:	2905                	addiw	s2,s2,1
     fb0:	fd6912e3          	bne	s2,s6,f74 <bigdir+0x52>
  unlink("bd");
     fb4:	00005517          	auipc	a0,0x5
     fb8:	f3450513          	addi	a0,a0,-204 # 5ee8 <malloc+0x86c>
     fbc:	202040ef          	jal	51be <unlink>
    name[0] = 'x';
     fc0:	07800993          	li	s3,120
    if(unlink(name) != 0){
     fc4:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     fc8:	1f400a13          	li	s4,500
    name[0] = 'x';
     fcc:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fd0:	41f4d71b          	sraiw	a4,s1,0x1f
     fd4:	01a7571b          	srliw	a4,a4,0x1a
     fd8:	009707bb          	addw	a5,a4,s1
     fdc:	4067d69b          	sraiw	a3,a5,0x6
     fe0:	0306869b          	addiw	a3,a3,48
     fe4:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fe8:	03f7f793          	andi	a5,a5,63
     fec:	9f99                	subw	a5,a5,a4
     fee:	0307879b          	addiw	a5,a5,48
     ff2:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     ff6:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     ffa:	854a                	mv	a0,s2
     ffc:	1c2040ef          	jal	51be <unlink>
    1000:	e531                	bnez	a0,104c <bigdir+0x12a>
  for(i = 0; i < N; i++){
    1002:	2485                	addiw	s1,s1,1
    1004:	fd4494e3          	bne	s1,s4,fcc <bigdir+0xaa>
}
    1008:	60e6                	ld	ra,88(sp)
    100a:	6446                	ld	s0,80(sp)
    100c:	64a6                	ld	s1,72(sp)
    100e:	6906                	ld	s2,64(sp)
    1010:	79e2                	ld	s3,56(sp)
    1012:	7a42                	ld	s4,48(sp)
    1014:	7aa2                	ld	s5,40(sp)
    1016:	7b02                	ld	s6,32(sp)
    1018:	6be2                	ld	s7,24(sp)
    101a:	6125                	addi	sp,sp,96
    101c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	ed050513          	addi	a0,a0,-304 # 5ef0 <malloc+0x874>
    1028:	59c040ef          	jal	55c4 <printf>
    exit(1);
    102c:	4505                	li	a0,1
    102e:	140040ef          	jal	516e <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1032:	fa040693          	addi	a3,s0,-96
    1036:	864a                	mv	a2,s2
    1038:	85de                	mv	a1,s7
    103a:	00005517          	auipc	a0,0x5
    103e:	ed650513          	addi	a0,a0,-298 # 5f10 <malloc+0x894>
    1042:	582040ef          	jal	55c4 <printf>
      exit(1);
    1046:	4505                	li	a0,1
    1048:	126040ef          	jal	516e <exit>
      printf("%s: bigdir unlink failed", s);
    104c:	85de                	mv	a1,s7
    104e:	00005517          	auipc	a0,0x5
    1052:	eea50513          	addi	a0,a0,-278 # 5f38 <malloc+0x8bc>
    1056:	56e040ef          	jal	55c4 <printf>
      exit(1);
    105a:	4505                	li	a0,1
    105c:	112040ef          	jal	516e <exit>

0000000000001060 <pgbug>:
{
    1060:	7179                	addi	sp,sp,-48
    1062:	f406                	sd	ra,40(sp)
    1064:	f022                	sd	s0,32(sp)
    1066:	ec26                	sd	s1,24(sp)
    1068:	1800                	addi	s0,sp,48
  argv[0] = 0;
    106a:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    106e:	00007497          	auipc	s1,0x7
    1072:	f9248493          	addi	s1,s1,-110 # 8000 <big>
    1076:	fd840593          	addi	a1,s0,-40
    107a:	6088                	ld	a0,0(s1)
    107c:	12a040ef          	jal	51a6 <exec>
  pipe(big);
    1080:	6088                	ld	a0,0(s1)
    1082:	0fc040ef          	jal	517e <pipe>
}
    1086:	4501                	li	a0,0
    1088:	70a2                	ld	ra,40(sp)
    108a:	7402                	ld	s0,32(sp)
    108c:	64e2                	ld	s1,24(sp)
    108e:	6145                	addi	sp,sp,48
    1090:	8082                	ret

0000000000001092 <badarg>:
{
    1092:	7139                	addi	sp,sp,-64
    1094:	fc06                	sd	ra,56(sp)
    1096:	f822                	sd	s0,48(sp)
    1098:	f426                	sd	s1,40(sp)
    109a:	f04a                	sd	s2,32(sp)
    109c:	ec4e                	sd	s3,24(sp)
    109e:	e852                	sd	s4,16(sp)
    10a0:	0080                	addi	s0,sp,64
    10a2:	64b1                	lui	s1,0xc
    10a4:	35048493          	addi	s1,s1,848 # c350 <buf+0x698>
    argv[0] = (char*)0xffffffff;
    10a8:	597d                	li	s2,-1
    10aa:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    10ae:	fc040a13          	addi	s4,s0,-64
    10b2:	00004997          	auipc	s3,0x4
    10b6:	6f698993          	addi	s3,s3,1782 # 57a8 <malloc+0x12c>
    argv[0] = (char*)0xffffffff;
    10ba:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    10be:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    10c2:	85d2                	mv	a1,s4
    10c4:	854e                	mv	a0,s3
    10c6:	0e0040ef          	jal	51a6 <exec>
  for(int i = 0; i < 50000; i++){
    10ca:	34fd                	addiw	s1,s1,-1
    10cc:	f4fd                	bnez	s1,10ba <badarg+0x28>
}
    10ce:	4501                	li	a0,0
    10d0:	70e2                	ld	ra,56(sp)
    10d2:	7442                	ld	s0,48(sp)
    10d4:	74a2                	ld	s1,40(sp)
    10d6:	7902                	ld	s2,32(sp)
    10d8:	69e2                	ld	s3,24(sp)
    10da:	6a42                	ld	s4,16(sp)
    10dc:	6121                	addi	sp,sp,64
    10de:	8082                	ret

00000000000010e0 <copyinstr2>:
{
    10e0:	7155                	addi	sp,sp,-208
    10e2:	e586                	sd	ra,200(sp)
    10e4:	e1a2                	sd	s0,192(sp)
    10e6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    10e8:	f6840793          	addi	a5,s0,-152
    10ec:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10f0:	07800713          	li	a4,120
    10f4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10f8:	0785                	addi	a5,a5,1
    10fa:	fed79de3          	bne	a5,a3,10f4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10fe:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1102:	f6840513          	addi	a0,s0,-152
    1106:	0b8040ef          	jal	51be <unlink>
  if(ret != -1){
    110a:	57fd                	li	a5,-1
    110c:	0cf51263          	bne	a0,a5,11d0 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1110:	20100593          	li	a1,513
    1114:	f6840513          	addi	a0,s0,-152
    1118:	096040ef          	jal	51ae <open>
  if(fd != -1){
    111c:	57fd                	li	a5,-1
    111e:	0cf51563          	bne	a0,a5,11e8 <copyinstr2+0x108>
  ret = link(b, b);
    1122:	f6840513          	addi	a0,s0,-152
    1126:	85aa                	mv	a1,a0
    1128:	0a6040ef          	jal	51ce <link>
  if(ret != -1){
    112c:	57fd                	li	a5,-1
    112e:	0cf51963          	bne	a0,a5,1200 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1132:	00006797          	auipc	a5,0x6
    1136:	f5678793          	addi	a5,a5,-170 # 7088 <malloc+0x1a0c>
    113a:	f4f43c23          	sd	a5,-168(s0)
    113e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1142:	f5840593          	addi	a1,s0,-168
    1146:	f6840513          	addi	a0,s0,-152
    114a:	05c040ef          	jal	51a6 <exec>
  if(ret != -1){
    114e:	57fd                	li	a5,-1
    1150:	0cf51563          	bne	a0,a5,121a <copyinstr2+0x13a>
  int pid = fork();
    1154:	012040ef          	jal	5166 <fork>
  if(pid < 0){
    1158:	0c054d63          	bltz	a0,1232 <copyinstr2+0x152>
  if(pid == 0){
    115c:	0e051863          	bnez	a0,124c <copyinstr2+0x16c>
    1160:	00007797          	auipc	a5,0x7
    1164:	44078793          	addi	a5,a5,1088 # 85a0 <big.0>
    1168:	00008697          	auipc	a3,0x8
    116c:	43868693          	addi	a3,a3,1080 # 95a0 <big.0+0x1000>
      big[i] = 'x';
    1170:	07800713          	li	a4,120
    1174:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1178:	0785                	addi	a5,a5,1
    117a:	fed79de3          	bne	a5,a3,1174 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    117e:	00008797          	auipc	a5,0x8
    1182:	42078123          	sb	zero,1058(a5) # 95a0 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1186:	00007797          	auipc	a5,0x7
    118a:	b8a78793          	addi	a5,a5,-1142 # 7d10 <malloc+0x2694>
    118e:	6fb0                	ld	a2,88(a5)
    1190:	73b4                	ld	a3,96(a5)
    1192:	77b8                	ld	a4,104(a5)
    1194:	f2c43823          	sd	a2,-208(s0)
    1198:	f2d43c23          	sd	a3,-200(s0)
    119c:	f4e43023          	sd	a4,-192(s0)
    11a0:	7bbc                	ld	a5,112(a5)
    11a2:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    11a6:	f3040593          	addi	a1,s0,-208
    11aa:	00004517          	auipc	a0,0x4
    11ae:	5fe50513          	addi	a0,a0,1534 # 57a8 <malloc+0x12c>
    11b2:	7f5030ef          	jal	51a6 <exec>
    if(ret != -1){
    11b6:	57fd                	li	a5,-1
    11b8:	08f50663          	beq	a0,a5,1244 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    11bc:	85be                	mv	a1,a5
    11be:	00005517          	auipc	a0,0x5
    11c2:	e2250513          	addi	a0,a0,-478 # 5fe0 <malloc+0x964>
    11c6:	3fe040ef          	jal	55c4 <printf>
      exit(1);
    11ca:	4505                	li	a0,1
    11cc:	7a3030ef          	jal	516e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    11d0:	862a                	mv	a2,a0
    11d2:	f6840593          	addi	a1,s0,-152
    11d6:	00005517          	auipc	a0,0x5
    11da:	d8250513          	addi	a0,a0,-638 # 5f58 <malloc+0x8dc>
    11de:	3e6040ef          	jal	55c4 <printf>
    exit(1);
    11e2:	4505                	li	a0,1
    11e4:	78b030ef          	jal	516e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11e8:	862a                	mv	a2,a0
    11ea:	f6840593          	addi	a1,s0,-152
    11ee:	00005517          	auipc	a0,0x5
    11f2:	d8a50513          	addi	a0,a0,-630 # 5f78 <malloc+0x8fc>
    11f6:	3ce040ef          	jal	55c4 <printf>
    exit(1);
    11fa:	4505                	li	a0,1
    11fc:	773030ef          	jal	516e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1200:	f6840593          	addi	a1,s0,-152
    1204:	86aa                	mv	a3,a0
    1206:	862e                	mv	a2,a1
    1208:	00005517          	auipc	a0,0x5
    120c:	d9050513          	addi	a0,a0,-624 # 5f98 <malloc+0x91c>
    1210:	3b4040ef          	jal	55c4 <printf>
    exit(1);
    1214:	4505                	li	a0,1
    1216:	759030ef          	jal	516e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    121a:	863e                	mv	a2,a5
    121c:	f6840593          	addi	a1,s0,-152
    1220:	00005517          	auipc	a0,0x5
    1224:	da050513          	addi	a0,a0,-608 # 5fc0 <malloc+0x944>
    1228:	39c040ef          	jal	55c4 <printf>
    exit(1);
    122c:	4505                	li	a0,1
    122e:	741030ef          	jal	516e <exit>
    printf("fork failed\n");
    1232:	00006517          	auipc	a0,0x6
    1236:	3ae50513          	addi	a0,a0,942 # 75e0 <malloc+0x1f64>
    123a:	38a040ef          	jal	55c4 <printf>
    exit(1);
    123e:	4505                	li	a0,1
    1240:	72f030ef          	jal	516e <exit>
    exit(747); // OK
    1244:	2eb00513          	li	a0,747
    1248:	727030ef          	jal	516e <exit>
  int st = 0;
    124c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1250:	f5440513          	addi	a0,s0,-172
    1254:	723030ef          	jal	5176 <wait>
  if(st != 747){
    1258:	f5442703          	lw	a4,-172(s0)
    125c:	2eb00793          	li	a5,747
    1260:	00f71763          	bne	a4,a5,126e <copyinstr2+0x18e>
}
    1264:	4501                	li	a0,0
    1266:	60ae                	ld	ra,200(sp)
    1268:	640e                	ld	s0,192(sp)
    126a:	6169                	addi	sp,sp,208
    126c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    126e:	00005517          	auipc	a0,0x5
    1272:	d9a50513          	addi	a0,a0,-614 # 6008 <malloc+0x98c>
    1276:	34e040ef          	jal	55c4 <printf>
    exit(1);
    127a:	4505                	li	a0,1
    127c:	6f3030ef          	jal	516e <exit>

0000000000001280 <truncate3>:
{
    1280:	7175                	addi	sp,sp,-144
    1282:	e506                	sd	ra,136(sp)
    1284:	e122                	sd	s0,128(sp)
    1286:	fc66                	sd	s9,56(sp)
    1288:	0900                	addi	s0,sp,144
    128a:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    128c:	60100593          	li	a1,1537
    1290:	00004517          	auipc	a0,0x4
    1294:	57050513          	addi	a0,a0,1392 # 5800 <malloc+0x184>
    1298:	717030ef          	jal	51ae <open>
    129c:	6fb030ef          	jal	5196 <close>
  pid = fork();
    12a0:	6c7030ef          	jal	5166 <fork>
  if(pid < 0){
    12a4:	06054d63          	bltz	a0,131e <truncate3+0x9e>
  if(pid == 0){
    12a8:	e171                	bnez	a0,136c <truncate3+0xec>
    12aa:	fca6                	sd	s1,120(sp)
    12ac:	f8ca                	sd	s2,112(sp)
    12ae:	f4ce                	sd	s3,104(sp)
    12b0:	f0d2                	sd	s4,96(sp)
    12b2:	ecd6                	sd	s5,88(sp)
    12b4:	e8da                	sd	s6,80(sp)
    12b6:	e4de                	sd	s7,72(sp)
    12b8:	e0e2                	sd	s8,64(sp)
    12ba:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    12be:	4a85                	li	s5,1
    12c0:	00004997          	auipc	s3,0x4
    12c4:	54098993          	addi	s3,s3,1344 # 5800 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    12c8:	4a29                	li	s4,10
    12ca:	00005c17          	auipc	s8,0x5
    12ce:	d9ec0c13          	addi	s8,s8,-610 # 6068 <malloc+0x9ec>
      read(fd, buf, sizeof(buf));
    12d2:	f7840b93          	addi	s7,s0,-136
    12d6:	02000b13          	li	s6,32
      int fd = open("truncfile", O_WRONLY);
    12da:	85d6                	mv	a1,s5
    12dc:	854e                	mv	a0,s3
    12de:	6d1030ef          	jal	51ae <open>
    12e2:	84aa                	mv	s1,a0
      if(fd < 0){
    12e4:	04054f63          	bltz	a0,1342 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12e8:	8652                	mv	a2,s4
    12ea:	85e2                	mv	a1,s8
    12ec:	6a3030ef          	jal	518e <write>
      if(n != 10){
    12f0:	07451363          	bne	a0,s4,1356 <truncate3+0xd6>
      close(fd);
    12f4:	8526                	mv	a0,s1
    12f6:	6a1030ef          	jal	5196 <close>
      fd = open("truncfile", O_RDONLY);
    12fa:	4581                	li	a1,0
    12fc:	854e                	mv	a0,s3
    12fe:	6b1030ef          	jal	51ae <open>
    1302:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1304:	865a                	mv	a2,s6
    1306:	85de                	mv	a1,s7
    1308:	67f030ef          	jal	5186 <read>
      close(fd);
    130c:	8526                	mv	a0,s1
    130e:	689030ef          	jal	5196 <close>
    for(int i = 0; i < 100; i++){
    1312:	397d                	addiw	s2,s2,-1
    1314:	fc0913e3          	bnez	s2,12da <truncate3+0x5a>
    exit(0);
    1318:	4501                	li	a0,0
    131a:	655030ef          	jal	516e <exit>
    131e:	fca6                	sd	s1,120(sp)
    1320:	f8ca                	sd	s2,112(sp)
    1322:	f4ce                	sd	s3,104(sp)
    1324:	f0d2                	sd	s4,96(sp)
    1326:	ecd6                	sd	s5,88(sp)
    1328:	e8da                	sd	s6,80(sp)
    132a:	e4de                	sd	s7,72(sp)
    132c:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    132e:	85e6                	mv	a1,s9
    1330:	00005517          	auipc	a0,0x5
    1334:	d0850513          	addi	a0,a0,-760 # 6038 <malloc+0x9bc>
    1338:	28c040ef          	jal	55c4 <printf>
    exit(1);
    133c:	4505                	li	a0,1
    133e:	631030ef          	jal	516e <exit>
        printf("%s: open failed\n", s);
    1342:	85e6                	mv	a1,s9
    1344:	00005517          	auipc	a0,0x5
    1348:	d0c50513          	addi	a0,a0,-756 # 6050 <malloc+0x9d4>
    134c:	278040ef          	jal	55c4 <printf>
        exit(1);
    1350:	4505                	li	a0,1
    1352:	61d030ef          	jal	516e <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1356:	862a                	mv	a2,a0
    1358:	85e6                	mv	a1,s9
    135a:	00005517          	auipc	a0,0x5
    135e:	d1e50513          	addi	a0,a0,-738 # 6078 <malloc+0x9fc>
    1362:	262040ef          	jal	55c4 <printf>
        exit(1);
    1366:	4505                	li	a0,1
    1368:	607030ef          	jal	516e <exit>
    136c:	fca6                	sd	s1,120(sp)
    136e:	f8ca                	sd	s2,112(sp)
    1370:	f4ce                	sd	s3,104(sp)
    1372:	f0d2                	sd	s4,96(sp)
    1374:	ecd6                	sd	s5,88(sp)
    1376:	e8da                	sd	s6,80(sp)
    1378:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    137c:	60100a93          	li	s5,1537
    1380:	00004a17          	auipc	s4,0x4
    1384:	480a0a13          	addi	s4,s4,1152 # 5800 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    1388:	498d                	li	s3,3
    138a:	00005b17          	auipc	s6,0x5
    138e:	d0eb0b13          	addi	s6,s6,-754 # 6098 <malloc+0xa1c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1392:	85d6                	mv	a1,s5
    1394:	8552                	mv	a0,s4
    1396:	619030ef          	jal	51ae <open>
    139a:	84aa                	mv	s1,a0
    if(fd < 0){
    139c:	04054563          	bltz	a0,13e6 <truncate3+0x166>
    int n = write(fd, "xxx", 3);
    13a0:	864e                	mv	a2,s3
    13a2:	85da                	mv	a1,s6
    13a4:	5eb030ef          	jal	518e <write>
    if(n != 3){
    13a8:	05351b63          	bne	a0,s3,13fe <truncate3+0x17e>
    close(fd);
    13ac:	8526                	mv	a0,s1
    13ae:	5e9030ef          	jal	5196 <close>
  for(int i = 0; i < 150; i++){
    13b2:	397d                	addiw	s2,s2,-1
    13b4:	fc091fe3          	bnez	s2,1392 <truncate3+0x112>
  wait(&xstatus);
    13b8:	f9c40513          	addi	a0,s0,-100
    13bc:	5bb030ef          	jal	5176 <wait>
  unlink("truncfile");
    13c0:	00004517          	auipc	a0,0x4
    13c4:	44050513          	addi	a0,a0,1088 # 5800 <malloc+0x184>
    13c8:	5f7030ef          	jal	51be <unlink>
}
    13cc:	f9c42503          	lw	a0,-100(s0)
    13d0:	74e6                	ld	s1,120(sp)
    13d2:	7946                	ld	s2,112(sp)
    13d4:	79a6                	ld	s3,104(sp)
    13d6:	7a06                	ld	s4,96(sp)
    13d8:	6ae6                	ld	s5,88(sp)
    13da:	6b46                	ld	s6,80(sp)
    13dc:	60aa                	ld	ra,136(sp)
    13de:	640a                	ld	s0,128(sp)
    13e0:	7ce2                	ld	s9,56(sp)
    13e2:	6149                	addi	sp,sp,144
    13e4:	8082                	ret
    13e6:	e4de                	sd	s7,72(sp)
    13e8:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    13ea:	85e6                	mv	a1,s9
    13ec:	00005517          	auipc	a0,0x5
    13f0:	c6450513          	addi	a0,a0,-924 # 6050 <malloc+0x9d4>
    13f4:	1d0040ef          	jal	55c4 <printf>
      exit(1);
    13f8:	4505                	li	a0,1
    13fa:	575030ef          	jal	516e <exit>
    13fe:	e4de                	sd	s7,72(sp)
    1400:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    1402:	862a                	mv	a2,a0
    1404:	85e6                	mv	a1,s9
    1406:	00005517          	auipc	a0,0x5
    140a:	c9a50513          	addi	a0,a0,-870 # 60a0 <malloc+0xa24>
    140e:	1b6040ef          	jal	55c4 <printf>
      exit(1);
    1412:	4505                	li	a0,1
    1414:	55b030ef          	jal	516e <exit>

0000000000001418 <exectest>:
{
    1418:	715d                	addi	sp,sp,-80
    141a:	e486                	sd	ra,72(sp)
    141c:	e0a2                	sd	s0,64(sp)
    141e:	fc26                	sd	s1,56(sp)
    1420:	f84a                	sd	s2,48(sp)
    1422:	0880                	addi	s0,sp,80
    1424:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1426:	00004797          	auipc	a5,0x4
    142a:	38278793          	addi	a5,a5,898 # 57a8 <malloc+0x12c>
    142e:	fcf43023          	sd	a5,-64(s0)
    1432:	00005797          	auipc	a5,0x5
    1436:	c8e78793          	addi	a5,a5,-882 # 60c0 <malloc+0xa44>
    143a:	fcf43423          	sd	a5,-56(s0)
    143e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1442:	00005517          	auipc	a0,0x5
    1446:	c8650513          	addi	a0,a0,-890 # 60c8 <malloc+0xa4c>
    144a:	575030ef          	jal	51be <unlink>
  pid = fork();
    144e:	519030ef          	jal	5166 <fork>
  if(pid < 0) {
    1452:	04054d63          	bltz	a0,14ac <exectest+0x94>
    1456:	84aa                	mv	s1,a0
  if(pid == 0) {
    1458:	e91d                	bnez	a0,148e <exectest+0x76>
    close(1);
    145a:	4505                	li	a0,1
    145c:	53b030ef          	jal	5196 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1460:	20100593          	li	a1,513
    1464:	00005517          	auipc	a0,0x5
    1468:	c6450513          	addi	a0,a0,-924 # 60c8 <malloc+0xa4c>
    146c:	543030ef          	jal	51ae <open>
    if(fd < 0) {
    1470:	04054863          	bltz	a0,14c0 <exectest+0xa8>
    if(fd != 1) {
    1474:	4785                	li	a5,1
    1476:	04f51f63          	bne	a0,a5,14d4 <exectest+0xbc>
    if(exec("echo", echoargv) < 0){
    147a:	fc040593          	addi	a1,s0,-64
    147e:	00004517          	auipc	a0,0x4
    1482:	32a50513          	addi	a0,a0,810 # 57a8 <malloc+0x12c>
    1486:	521030ef          	jal	51a6 <exec>
    148a:	04054f63          	bltz	a0,14e8 <exectest+0xd0>
  if (wait(&xstatus) != pid) {
    148e:	fdc40513          	addi	a0,s0,-36
    1492:	4e5030ef          	jal	5176 <wait>
    1496:	06951363          	bne	a0,s1,14fc <exectest+0xe4>
  if(xstatus != 0)
    149a:	fdc42503          	lw	a0,-36(s0)
    149e:	c53d                	beqz	a0,150c <exectest+0xf4>
}
    14a0:	60a6                	ld	ra,72(sp)
    14a2:	6406                	ld	s0,64(sp)
    14a4:	74e2                	ld	s1,56(sp)
    14a6:	7942                	ld	s2,48(sp)
    14a8:	6161                	addi	sp,sp,80
    14aa:	8082                	ret
     printf("%s: fork failed\n", s);
    14ac:	85ca                	mv	a1,s2
    14ae:	00005517          	auipc	a0,0x5
    14b2:	b8a50513          	addi	a0,a0,-1142 # 6038 <malloc+0x9bc>
    14b6:	10e040ef          	jal	55c4 <printf>
     exit(1);
    14ba:	4505                	li	a0,1
    14bc:	4b3030ef          	jal	516e <exit>
      printf("%s: create failed\n", s);
    14c0:	85ca                	mv	a1,s2
    14c2:	00005517          	auipc	a0,0x5
    14c6:	c0e50513          	addi	a0,a0,-1010 # 60d0 <malloc+0xa54>
    14ca:	0fa040ef          	jal	55c4 <printf>
      exit(1);
    14ce:	4505                	li	a0,1
    14d0:	49f030ef          	jal	516e <exit>
      printf("%s: wrong fd\n", s);
    14d4:	85ca                	mv	a1,s2
    14d6:	00005517          	auipc	a0,0x5
    14da:	c1250513          	addi	a0,a0,-1006 # 60e8 <malloc+0xa6c>
    14de:	0e6040ef          	jal	55c4 <printf>
      exit(1);
    14e2:	4505                	li	a0,1
    14e4:	48b030ef          	jal	516e <exit>
      printf("%s: exec echo failed\n", s);
    14e8:	85ca                	mv	a1,s2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	c0e50513          	addi	a0,a0,-1010 # 60f8 <malloc+0xa7c>
    14f2:	0d2040ef          	jal	55c4 <printf>
      exit(1);
    14f6:	4505                	li	a0,1
    14f8:	477030ef          	jal	516e <exit>
    printf("%s: wait failed!\n", s);
    14fc:	85ca                	mv	a1,s2
    14fe:	00005517          	auipc	a0,0x5
    1502:	c1250513          	addi	a0,a0,-1006 # 6110 <malloc+0xa94>
    1506:	0be040ef          	jal	55c4 <printf>
    150a:	bf41                	j	149a <exectest+0x82>
  fd = open("echo-ok", O_RDONLY);
    150c:	4581                	li	a1,0
    150e:	00005517          	auipc	a0,0x5
    1512:	bba50513          	addi	a0,a0,-1094 # 60c8 <malloc+0xa4c>
    1516:	499030ef          	jal	51ae <open>
  if(fd < 0) {
    151a:	04054663          	bltz	a0,1566 <exectest+0x14e>
  if (read(fd, buf, 2) != 2) {
    151e:	4609                	li	a2,2
    1520:	fb840593          	addi	a1,s0,-72
    1524:	463030ef          	jal	5186 <read>
    1528:	4789                	li	a5,2
    152a:	04f51863          	bne	a0,a5,157a <exectest+0x162>
  unlink("echo-ok");
    152e:	00005517          	auipc	a0,0x5
    1532:	b9a50513          	addi	a0,a0,-1126 # 60c8 <malloc+0xa4c>
    1536:	489030ef          	jal	51be <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    153a:	fb844703          	lbu	a4,-72(s0)
    153e:	04f00793          	li	a5,79
    1542:	00f71863          	bne	a4,a5,1552 <exectest+0x13a>
    1546:	fb944703          	lbu	a4,-71(s0)
    154a:	04b00793          	li	a5,75
    154e:	04f70063          	beq	a4,a5,158e <exectest+0x176>
    printf("%s: wrong output\n", s);
    1552:	85ca                	mv	a1,s2
    1554:	00005517          	auipc	a0,0x5
    1558:	bd450513          	addi	a0,a0,-1068 # 6128 <malloc+0xaac>
    155c:	068040ef          	jal	55c4 <printf>
    exit(1);
    1560:	4505                	li	a0,1
    1562:	40d030ef          	jal	516e <exit>
    printf("%s: open failed\n", s);
    1566:	85ca                	mv	a1,s2
    1568:	00005517          	auipc	a0,0x5
    156c:	ae850513          	addi	a0,a0,-1304 # 6050 <malloc+0x9d4>
    1570:	054040ef          	jal	55c4 <printf>
    exit(1);
    1574:	4505                	li	a0,1
    1576:	3f9030ef          	jal	516e <exit>
    printf("%s: read failed\n", s);
    157a:	85ca                	mv	a1,s2
    157c:	00004517          	auipc	a0,0x4
    1580:	5fc50513          	addi	a0,a0,1532 # 5b78 <malloc+0x4fc>
    1584:	040040ef          	jal	55c4 <printf>
    exit(1);
    1588:	4505                	li	a0,1
    158a:	3e5030ef          	jal	516e <exit>
    exit(0);
    158e:	4501                	li	a0,0
    1590:	3df030ef          	jal	516e <exit>

0000000000001594 <pipe1>:
{
    1594:	715d                	addi	sp,sp,-80
    1596:	e486                	sd	ra,72(sp)
    1598:	e0a2                	sd	s0,64(sp)
    159a:	fc26                	sd	s1,56(sp)
    159c:	f84a                	sd	s2,48(sp)
    159e:	f44e                	sd	s3,40(sp)
    15a0:	f052                	sd	s4,32(sp)
    15a2:	ec56                	sd	s5,24(sp)
    15a4:	e85a                	sd	s6,16(sp)
    15a6:	0880                	addi	s0,sp,80
    15a8:	8b2a                	mv	s6,a0
  if(pipe(fds) != 0){
    15aa:	fb840513          	addi	a0,s0,-72
    15ae:	3d1030ef          	jal	517e <pipe>
    15b2:	e13d                	bnez	a0,1618 <pipe1+0x84>
    15b4:	84aa                	mv	s1,a0
  pid = fork();
    15b6:	3b1030ef          	jal	5166 <fork>
    15ba:	89aa                	mv	s3,a0
  if(pid == 0){
    15bc:	c925                	beqz	a0,162c <pipe1+0x98>
  } else if(pid > 0){
    15be:	14a05263          	blez	a0,1702 <pipe1+0x16e>
    close(fds[1]);
    15c2:	fbc42503          	lw	a0,-68(s0)
    15c6:	3d1030ef          	jal	5196 <close>
    total = 0;
    15ca:	89a6                	mv	s3,s1
    cc = 1;
    15cc:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    15ce:	0000aa97          	auipc	s5,0xa
    15d2:	6eaa8a93          	addi	s5,s5,1770 # bcb8 <buf>
      if(cc > sizeof(buf))
    15d6:	6a0d                	lui	s4,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    15d8:	864a                	mv	a2,s2
    15da:	85d6                	mv	a1,s5
    15dc:	fb842503          	lw	a0,-72(s0)
    15e0:	3a7030ef          	jal	5186 <read>
    15e4:	0ca05b63          	blez	a0,16ba <pipe1+0x126>
    15e8:	0000a797          	auipc	a5,0xa
    15ec:	6d078793          	addi	a5,a5,1744 # bcb8 <buf>
    15f0:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    15f4:	0007c683          	lbu	a3,0(a5)
    15f8:	0ff4f713          	zext.b	a4,s1
    15fc:	0ae69563          	bne	a3,a4,16a6 <pipe1+0x112>
    1600:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    1602:	0785                	addi	a5,a5,1
    1604:	fec498e3          	bne	s1,a2,15f4 <pipe1+0x60>
      total += n;
    1608:	00a989bb          	addw	s3,s3,a0
      cc = cc * 2;
    160c:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    1610:	fd2a74e3          	bgeu	s4,s2,15d8 <pipe1+0x44>
        cc = sizeof(buf);
    1614:	8952                	mv	s2,s4
    1616:	b7c9                	j	15d8 <pipe1+0x44>
    printf("%s: pipe() failed\n", s);
    1618:	85da                	mv	a1,s6
    161a:	00005517          	auipc	a0,0x5
    161e:	b2650513          	addi	a0,a0,-1242 # 6140 <malloc+0xac4>
    1622:	7a3030ef          	jal	55c4 <printf>
    exit(1);
    1626:	4505                	li	a0,1
    1628:	347030ef          	jal	516e <exit>
    close(fds[0]);
    162c:	fb842503          	lw	a0,-72(s0)
    1630:	367030ef          	jal	5196 <close>
    for(n = 0; n < N; n++){
    1634:	0000a797          	auipc	a5,0xa
    1638:	68478793          	addi	a5,a5,1668 # bcb8 <buf>
    163c:	40f004bb          	negw	s1,a5
    1640:	0ff4f493          	zext.b	s1,s1
    1644:	40978913          	addi	s2,a5,1033
      if(write(fds[1], buf, SZ) != SZ){
    1648:	40900a13          	li	s4,1033
    for(n = 0; n < N; n++){
    164c:	6a85                	lui	s5,0x1
    164e:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0x15>
{
    1652:	0000a797          	auipc	a5,0xa
    1656:	66678793          	addi	a5,a5,1638 # bcb8 <buf>
        buf[i] = seq++;
    165a:	0097873b          	addw	a4,a5,s1
    165e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1662:	0785                	addi	a5,a5,1
    1664:	ff279be3          	bne	a5,s2,165a <pipe1+0xc6>
      if(write(fds[1], buf, SZ) != SZ){
    1668:	8652                	mv	a2,s4
    166a:	0000a597          	auipc	a1,0xa
    166e:	64e58593          	addi	a1,a1,1614 # bcb8 <buf>
    1672:	fbc42503          	lw	a0,-68(s0)
    1676:	319030ef          	jal	518e <write>
    167a:	01451c63          	bne	a0,s4,1692 <pipe1+0xfe>
    167e:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    1682:	24a5                	addiw	s1,s1,9
    1684:	0ff4f493          	zext.b	s1,s1
    1688:	fd5995e3          	bne	s3,s5,1652 <pipe1+0xbe>
    exit(0);
    168c:	4501                	li	a0,0
    168e:	2e1030ef          	jal	516e <exit>
        printf("%s: pipe1 oops 1\n", s);
    1692:	85da                	mv	a1,s6
    1694:	00005517          	auipc	a0,0x5
    1698:	ac450513          	addi	a0,a0,-1340 # 6158 <malloc+0xadc>
    169c:	729030ef          	jal	55c4 <printf>
        exit(1);
    16a0:	4505                	li	a0,1
    16a2:	2cd030ef          	jal	516e <exit>
          printf("%s: pipe1 oops 2\n", s);
    16a6:	85da                	mv	a1,s6
    16a8:	00005517          	auipc	a0,0x5
    16ac:	ac850513          	addi	a0,a0,-1336 # 6170 <malloc+0xaf4>
    16b0:	715030ef          	jal	55c4 <printf>
          exit(1);
    16b4:	4505                	li	a0,1
    16b6:	2b9030ef          	jal	516e <exit>
    if(total != N * SZ){
    16ba:	6785                	lui	a5,0x1
    16bc:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x15>
    16c0:	02f99663          	bne	s3,a5,16ec <pipe1+0x158>
    close(fds[0]);
    16c4:	fb842503          	lw	a0,-72(s0)
    16c8:	2cf030ef          	jal	5196 <close>
    wait(&xstatus);
    16cc:	fb440513          	addi	a0,s0,-76
    16d0:	2a7030ef          	jal	5176 <wait>
    return xstatus;
    16d4:	fb442503          	lw	a0,-76(s0)
}
    16d8:	60a6                	ld	ra,72(sp)
    16da:	6406                	ld	s0,64(sp)
    16dc:	74e2                	ld	s1,56(sp)
    16de:	7942                	ld	s2,48(sp)
    16e0:	79a2                	ld	s3,40(sp)
    16e2:	7a02                	ld	s4,32(sp)
    16e4:	6ae2                	ld	s5,24(sp)
    16e6:	6b42                	ld	s6,16(sp)
    16e8:	6161                	addi	sp,sp,80
    16ea:	8082                	ret
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    16ec:	864e                	mv	a2,s3
    16ee:	85da                	mv	a1,s6
    16f0:	00005517          	auipc	a0,0x5
    16f4:	a9850513          	addi	a0,a0,-1384 # 6188 <malloc+0xb0c>
    16f8:	6cd030ef          	jal	55c4 <printf>
      exit(1);
    16fc:	4505                	li	a0,1
    16fe:	271030ef          	jal	516e <exit>
    printf("%s: fork() failed\n", s);
    1702:	85da                	mv	a1,s6
    1704:	00005517          	auipc	a0,0x5
    1708:	aa450513          	addi	a0,a0,-1372 # 61a8 <malloc+0xb2c>
    170c:	6b9030ef          	jal	55c4 <printf>
    exit(1);
    1710:	4505                	li	a0,1
    1712:	25d030ef          	jal	516e <exit>

0000000000001716 <exitwait>:
{
    1716:	715d                	addi	sp,sp,-80
    1718:	e486                	sd	ra,72(sp)
    171a:	e0a2                	sd	s0,64(sp)
    171c:	fc26                	sd	s1,56(sp)
    171e:	f84a                	sd	s2,48(sp)
    1720:	f44e                	sd	s3,40(sp)
    1722:	f052                	sd	s4,32(sp)
    1724:	ec56                	sd	s5,24(sp)
    1726:	0880                	addi	s0,sp,80
    1728:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    172a:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    172c:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    1730:	06400a13          	li	s4,100
    pid = fork();
    1734:	233030ef          	jal	5166 <fork>
    1738:	84aa                	mv	s1,a0
    if(pid < 0){
    173a:	02054963          	bltz	a0,176c <exitwait+0x56>
    if(pid){
    173e:	c52d                	beqz	a0,17a8 <exitwait+0x92>
      if(wait(&xstate) != pid){
    1740:	854e                	mv	a0,s3
    1742:	235030ef          	jal	5176 <wait>
    1746:	02951d63          	bne	a0,s1,1780 <exitwait+0x6a>
      if(i != xstate) {
    174a:	fbc42783          	lw	a5,-68(s0)
    174e:	05279363          	bne	a5,s2,1794 <exitwait+0x7e>
  for(i = 0; i < 100; i++){
    1752:	2905                	addiw	s2,s2,1
    1754:	ff4910e3          	bne	s2,s4,1734 <exitwait+0x1e>
}
    1758:	4501                	li	a0,0
    175a:	60a6                	ld	ra,72(sp)
    175c:	6406                	ld	s0,64(sp)
    175e:	74e2                	ld	s1,56(sp)
    1760:	7942                	ld	s2,48(sp)
    1762:	79a2                	ld	s3,40(sp)
    1764:	7a02                	ld	s4,32(sp)
    1766:	6ae2                	ld	s5,24(sp)
    1768:	6161                	addi	sp,sp,80
    176a:	8082                	ret
      printf("%s: fork failed\n", s);
    176c:	85d6                	mv	a1,s5
    176e:	00005517          	auipc	a0,0x5
    1772:	8ca50513          	addi	a0,a0,-1846 # 6038 <malloc+0x9bc>
    1776:	64f030ef          	jal	55c4 <printf>
      exit(1);
    177a:	4505                	li	a0,1
    177c:	1f3030ef          	jal	516e <exit>
        printf("%s: wait wrong pid\n", s);
    1780:	85d6                	mv	a1,s5
    1782:	00005517          	auipc	a0,0x5
    1786:	a3e50513          	addi	a0,a0,-1474 # 61c0 <malloc+0xb44>
    178a:	63b030ef          	jal	55c4 <printf>
        exit(1);
    178e:	4505                	li	a0,1
    1790:	1df030ef          	jal	516e <exit>
        printf("%s: wait wrong exit status\n", s);
    1794:	85d6                	mv	a1,s5
    1796:	00005517          	auipc	a0,0x5
    179a:	a4250513          	addi	a0,a0,-1470 # 61d8 <malloc+0xb5c>
    179e:	627030ef          	jal	55c4 <printf>
        exit(1);
    17a2:	4505                	li	a0,1
    17a4:	1cb030ef          	jal	516e <exit>
      exit(i);
    17a8:	854a                	mv	a0,s2
    17aa:	1c5030ef          	jal	516e <exit>

00000000000017ae <twochildren>:
{
    17ae:	1101                	addi	sp,sp,-32
    17b0:	ec06                	sd	ra,24(sp)
    17b2:	e822                	sd	s0,16(sp)
    17b4:	e426                	sd	s1,8(sp)
    17b6:	e04a                	sd	s2,0(sp)
    17b8:	1000                	addi	s0,sp,32
    17ba:	892a                	mv	s2,a0
    17bc:	3e800493          	li	s1,1000
    int pid1 = fork();
    17c0:	1a7030ef          	jal	5166 <fork>
    if(pid1 < 0){
    17c4:	02054763          	bltz	a0,17f2 <twochildren+0x44>
    if(pid1 == 0){
    17c8:	cd1d                	beqz	a0,1806 <twochildren+0x58>
      int pid2 = fork();
    17ca:	19d030ef          	jal	5166 <fork>
      if(pid2 < 0){
    17ce:	02054e63          	bltz	a0,180a <twochildren+0x5c>
      if(pid2 == 0){
    17d2:	c531                	beqz	a0,181e <twochildren+0x70>
        wait(0);
    17d4:	4501                	li	a0,0
    17d6:	1a1030ef          	jal	5176 <wait>
        wait(0);
    17da:	4501                	li	a0,0
    17dc:	19b030ef          	jal	5176 <wait>
  for(int i = 0; i < 1000; i++){
    17e0:	34fd                	addiw	s1,s1,-1
    17e2:	fcf9                	bnez	s1,17c0 <twochildren+0x12>
}
    17e4:	4501                	li	a0,0
    17e6:	60e2                	ld	ra,24(sp)
    17e8:	6442                	ld	s0,16(sp)
    17ea:	64a2                	ld	s1,8(sp)
    17ec:	6902                	ld	s2,0(sp)
    17ee:	6105                	addi	sp,sp,32
    17f0:	8082                	ret
      printf("%s: fork failed\n", s);
    17f2:	85ca                	mv	a1,s2
    17f4:	00005517          	auipc	a0,0x5
    17f8:	84450513          	addi	a0,a0,-1980 # 6038 <malloc+0x9bc>
    17fc:	5c9030ef          	jal	55c4 <printf>
      exit(1);
    1800:	4505                	li	a0,1
    1802:	16d030ef          	jal	516e <exit>
      exit(0);
    1806:	169030ef          	jal	516e <exit>
        printf("%s: fork failed\n", s);
    180a:	85ca                	mv	a1,s2
    180c:	00005517          	auipc	a0,0x5
    1810:	82c50513          	addi	a0,a0,-2004 # 6038 <malloc+0x9bc>
    1814:	5b1030ef          	jal	55c4 <printf>
        exit(1);
    1818:	4505                	li	a0,1
    181a:	155030ef          	jal	516e <exit>
        exit(0);
    181e:	151030ef          	jal	516e <exit>

0000000000001822 <forkfork>:
{
    1822:	7179                	addi	sp,sp,-48
    1824:	f406                	sd	ra,40(sp)
    1826:	f022                	sd	s0,32(sp)
    1828:	ec26                	sd	s1,24(sp)
    182a:	1800                	addi	s0,sp,48
    182c:	84aa                	mv	s1,a0
    int pid = fork();
    182e:	139030ef          	jal	5166 <fork>
    if(pid < 0){
    1832:	02054c63          	bltz	a0,186a <forkfork+0x48>
    if(pid == 0){
    1836:	c521                	beqz	a0,187e <forkfork+0x5c>
    int pid = fork();
    1838:	12f030ef          	jal	5166 <fork>
    if(pid < 0){
    183c:	02054763          	bltz	a0,186a <forkfork+0x48>
    if(pid == 0){
    1840:	cd1d                	beqz	a0,187e <forkfork+0x5c>
    wait(&xstatus);
    1842:	fdc40513          	addi	a0,s0,-36
    1846:	131030ef          	jal	5176 <wait>
    if(xstatus != 0) {
    184a:	fdc42783          	lw	a5,-36(s0)
    184e:	efa1                	bnez	a5,18a6 <forkfork+0x84>
    wait(&xstatus);
    1850:	fdc40513          	addi	a0,s0,-36
    1854:	123030ef          	jal	5176 <wait>
    if(xstatus != 0) {
    1858:	fdc42783          	lw	a5,-36(s0)
    185c:	e7a9                	bnez	a5,18a6 <forkfork+0x84>
}
    185e:	4501                	li	a0,0
    1860:	70a2                	ld	ra,40(sp)
    1862:	7402                	ld	s0,32(sp)
    1864:	64e2                	ld	s1,24(sp)
    1866:	6145                	addi	sp,sp,48
    1868:	8082                	ret
      printf("%s: fork failed", s);
    186a:	85a6                	mv	a1,s1
    186c:	00005517          	auipc	a0,0x5
    1870:	98c50513          	addi	a0,a0,-1652 # 61f8 <malloc+0xb7c>
    1874:	551030ef          	jal	55c4 <printf>
      exit(1);
    1878:	4505                	li	a0,1
    187a:	0f5030ef          	jal	516e <exit>
{
    187e:	0c800493          	li	s1,200
        int pid1 = fork();
    1882:	0e5030ef          	jal	5166 <fork>
        if(pid1 < 0){
    1886:	00054b63          	bltz	a0,189c <forkfork+0x7a>
        if(pid1 == 0){
    188a:	cd01                	beqz	a0,18a2 <forkfork+0x80>
        wait(0);
    188c:	4501                	li	a0,0
    188e:	0e9030ef          	jal	5176 <wait>
      for(int j = 0; j < 200; j++){
    1892:	34fd                	addiw	s1,s1,-1
    1894:	f4fd                	bnez	s1,1882 <forkfork+0x60>
      exit(0);
    1896:	4501                	li	a0,0
    1898:	0d7030ef          	jal	516e <exit>
          exit(1);
    189c:	4505                	li	a0,1
    189e:	0d1030ef          	jal	516e <exit>
          exit(0);
    18a2:	0cd030ef          	jal	516e <exit>
      printf("%s: fork in child failed", s);
    18a6:	85a6                	mv	a1,s1
    18a8:	00005517          	auipc	a0,0x5
    18ac:	96050513          	addi	a0,a0,-1696 # 6208 <malloc+0xb8c>
    18b0:	515030ef          	jal	55c4 <printf>
      exit(1);
    18b4:	4505                	li	a0,1
    18b6:	0b9030ef          	jal	516e <exit>

00000000000018ba <reparent2>:
{
    18ba:	1101                	addi	sp,sp,-32
    18bc:	ec06                	sd	ra,24(sp)
    18be:	e822                	sd	s0,16(sp)
    18c0:	e426                	sd	s1,8(sp)
    18c2:	1000                	addi	s0,sp,32
    18c4:	32000493          	li	s1,800
    int pid1 = fork();
    18c8:	09f030ef          	jal	5166 <fork>
    if(pid1 < 0){
    18cc:	00054e63          	bltz	a0,18e8 <reparent2+0x2e>
    if(pid1 == 0){
    18d0:	c50d                	beqz	a0,18fa <reparent2+0x40>
    wait(0);
    18d2:	4501                	li	a0,0
    18d4:	0a3030ef          	jal	5176 <wait>
  for(int i = 0; i < 800; i++){
    18d8:	34fd                	addiw	s1,s1,-1
    18da:	f4fd                	bnez	s1,18c8 <reparent2+0xe>
}
    18dc:	4501                	li	a0,0
    18de:	60e2                	ld	ra,24(sp)
    18e0:	6442                	ld	s0,16(sp)
    18e2:	64a2                	ld	s1,8(sp)
    18e4:	6105                	addi	sp,sp,32
    18e6:	8082                	ret
      printf("fork failed\n");
    18e8:	00006517          	auipc	a0,0x6
    18ec:	cf850513          	addi	a0,a0,-776 # 75e0 <malloc+0x1f64>
    18f0:	4d5030ef          	jal	55c4 <printf>
      exit(1);
    18f4:	4505                	li	a0,1
    18f6:	079030ef          	jal	516e <exit>
      fork();
    18fa:	06d030ef          	jal	5166 <fork>
      fork();
    18fe:	069030ef          	jal	5166 <fork>
      exit(0);
    1902:	4501                	li	a0,0
    1904:	06b030ef          	jal	516e <exit>

0000000000001908 <createdelete>:
{
    1908:	7135                	addi	sp,sp,-160
    190a:	ed06                	sd	ra,152(sp)
    190c:	e922                	sd	s0,144(sp)
    190e:	e526                	sd	s1,136(sp)
    1910:	e14a                	sd	s2,128(sp)
    1912:	fcce                	sd	s3,120(sp)
    1914:	f8d2                	sd	s4,112(sp)
    1916:	f4d6                	sd	s5,104(sp)
    1918:	f0da                	sd	s6,96(sp)
    191a:	ecde                	sd	s7,88(sp)
    191c:	e8e2                	sd	s8,80(sp)
    191e:	e4e6                	sd	s9,72(sp)
    1920:	e0ea                	sd	s10,64(sp)
    1922:	fc6e                	sd	s11,56(sp)
    1924:	1100                	addi	s0,sp,160
    1926:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    1928:	4901                	li	s2,0
    192a:	4991                	li	s3,4
    pid = fork();
    192c:	03b030ef          	jal	5166 <fork>
    1930:	84aa                	mv	s1,a0
    if(pid < 0){
    1932:	04054063          	bltz	a0,1972 <createdelete+0x6a>
    if(pid == 0){
    1936:	c921                	beqz	a0,1986 <createdelete+0x7e>
  for(pi = 0; pi < NCHILD; pi++){
    1938:	2905                	addiw	s2,s2,1
    193a:	ff3919e3          	bne	s2,s3,192c <createdelete+0x24>
    193e:	4491                	li	s1,4
    wait(&xstatus);
    1940:	f6c40913          	addi	s2,s0,-148
    1944:	854a                	mv	a0,s2
    1946:	031030ef          	jal	5176 <wait>
    if(xstatus != 0)
    194a:	f6c42a83          	lw	s5,-148(s0)
    194e:	0c0a9263          	bnez	s5,1a12 <createdelete+0x10a>
  for(pi = 0; pi < NCHILD; pi++){
    1952:	34fd                	addiw	s1,s1,-1
    1954:	f8e5                	bnez	s1,1944 <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    1956:	f6040923          	sb	zero,-142(s0)
    195a:	03000913          	li	s2,48
    195e:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    1960:	4d25                	li	s10,9
    1962:	07000c93          	li	s9,112
      fd = open(name, 0);
    1966:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    196a:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    196c:	07400b13          	li	s6,116
    1970:	aa39                	j	1a8e <createdelete+0x186>
      printf("%s: fork failed\n", s);
    1972:	85ee                	mv	a1,s11
    1974:	00004517          	auipc	a0,0x4
    1978:	6c450513          	addi	a0,a0,1732 # 6038 <malloc+0x9bc>
    197c:	449030ef          	jal	55c4 <printf>
      exit(1);
    1980:	4505                	li	a0,1
    1982:	7ec030ef          	jal	516e <exit>
      name[0] = 'p' + pi;
    1986:	0709091b          	addiw	s2,s2,112
    198a:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    198e:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1992:	f7040913          	addi	s2,s0,-144
    1996:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    199a:	4a51                	li	s4,20
    199c:	a815                	j	19d0 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    199e:	85ee                	mv	a1,s11
    19a0:	00004517          	auipc	a0,0x4
    19a4:	73050513          	addi	a0,a0,1840 # 60d0 <malloc+0xa54>
    19a8:	41d030ef          	jal	55c4 <printf>
          exit(1);
    19ac:	4505                	li	a0,1
    19ae:	7c0030ef          	jal	516e <exit>
          name[1] = '0' + (i / 2);
    19b2:	01f4d79b          	srliw	a5,s1,0x1f
    19b6:	9fa5                	addw	a5,a5,s1
    19b8:	4017d79b          	sraiw	a5,a5,0x1
    19bc:	0307879b          	addiw	a5,a5,48
    19c0:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    19c4:	854a                	mv	a0,s2
    19c6:	7f8030ef          	jal	51be <unlink>
    19ca:	02054a63          	bltz	a0,19fe <createdelete+0xf6>
      for(i = 0; i < N; i++){
    19ce:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    19d0:	0304879b          	addiw	a5,s1,48
    19d4:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    19d8:	85ce                	mv	a1,s3
    19da:	854a                	mv	a0,s2
    19dc:	7d2030ef          	jal	51ae <open>
        if(fd < 0){
    19e0:	fa054fe3          	bltz	a0,199e <createdelete+0x96>
        close(fd);
    19e4:	7b2030ef          	jal	5196 <close>
        if(i > 0 && (i % 2 ) == 0){
    19e8:	fe9053e3          	blez	s1,19ce <createdelete+0xc6>
    19ec:	0014f793          	andi	a5,s1,1
    19f0:	d3e9                	beqz	a5,19b2 <createdelete+0xaa>
      for(i = 0; i < N; i++){
    19f2:	2485                	addiw	s1,s1,1
    19f4:	fd449ee3          	bne	s1,s4,19d0 <createdelete+0xc8>
      exit(0);
    19f8:	4501                	li	a0,0
    19fa:	774030ef          	jal	516e <exit>
            printf("%s: unlink failed\n", s);
    19fe:	85ee                	mv	a1,s11
    1a00:	00005517          	auipc	a0,0x5
    1a04:	82850513          	addi	a0,a0,-2008 # 6228 <malloc+0xbac>
    1a08:	3bd030ef          	jal	55c4 <printf>
            exit(1);
    1a0c:	4505                	li	a0,1
    1a0e:	760030ef          	jal	516e <exit>
      exit(1);
    1a12:	4505                	li	a0,1
    1a14:	75a030ef          	jal	516e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a18:	054bf263          	bgeu	s7,s4,1a5c <createdelete+0x154>
      if(fd >= 0)
    1a1c:	04055e63          	bgez	a0,1a78 <createdelete+0x170>
    for(pi = 0; pi < NCHILD; pi++){
    1a20:	2485                	addiw	s1,s1,1
    1a22:	0ff4f493          	zext.b	s1,s1
    1a26:	05648c63          	beq	s1,s6,1a7e <createdelete+0x176>
      name[0] = 'p' + pi;
    1a2a:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1a2e:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    1a32:	4581                	li	a1,0
    1a34:	8562                	mv	a0,s8
    1a36:	778030ef          	jal	51ae <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1a3a:	01f5579b          	srliw	a5,a0,0x1f
    1a3e:	dfe9                	beqz	a5,1a18 <createdelete+0x110>
    1a40:	fc098ce3          	beqz	s3,1a18 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1a44:	f7040613          	addi	a2,s0,-144
    1a48:	85ee                	mv	a1,s11
    1a4a:	00004517          	auipc	a0,0x4
    1a4e:	7f650513          	addi	a0,a0,2038 # 6240 <malloc+0xbc4>
    1a52:	373030ef          	jal	55c4 <printf>
        exit(1);
    1a56:	4505                	li	a0,1
    1a58:	716030ef          	jal	516e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a5c:	fc0542e3          	bltz	a0,1a20 <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a60:	f7040613          	addi	a2,s0,-144
    1a64:	85ee                	mv	a1,s11
    1a66:	00005517          	auipc	a0,0x5
    1a6a:	80250513          	addi	a0,a0,-2046 # 6268 <malloc+0xbec>
    1a6e:	357030ef          	jal	55c4 <printf>
        exit(1);
    1a72:	4505                	li	a0,1
    1a74:	6fa030ef          	jal	516e <exit>
        close(fd);
    1a78:	71e030ef          	jal	5196 <close>
    1a7c:	b755                	j	1a20 <createdelete+0x118>
  for(i = 0; i < N; i++){
    1a7e:	2a85                	addiw	s5,s5,1
    1a80:	2a05                	addiw	s4,s4,1 # 3001 <subdir+0x29b>
    1a82:	2905                	addiw	s2,s2,1
    1a84:	0ff97913          	zext.b	s2,s2
    1a88:	47d1                	li	a5,20
    1a8a:	00fa8a63          	beq	s5,a5,1a9e <createdelete+0x196>
      if((i == 0 || i >= N/2) && fd < 0){
    1a8e:	001ab993          	seqz	s3,s5
    1a92:	015d27b3          	slt	a5,s10,s5
    1a96:	00f9e9b3          	or	s3,s3,a5
    1a9a:	84e6                	mv	s1,s9
    1a9c:	b779                	j	1a2a <createdelete+0x122>
    1a9e:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1aa2:	07000b13          	li	s6,112
      unlink(name);
    1aa6:	f7040a13          	addi	s4,s0,-144
    for(pi = 0; pi < NCHILD; pi++){
    1aaa:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1aae:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    1ab2:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    1ab4:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1ab8:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1abc:	8552                	mv	a0,s4
    1abe:	700030ef          	jal	51be <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1ac2:	2485                	addiw	s1,s1,1
    1ac4:	0ff4f493          	zext.b	s1,s1
    1ac8:	ff3496e3          	bne	s1,s3,1ab4 <createdelete+0x1ac>
  for(i = 0; i < N; i++){
    1acc:	2905                	addiw	s2,s2,1
    1ace:	0ff97913          	zext.b	s2,s2
    1ad2:	ff5910e3          	bne	s2,s5,1ab2 <createdelete+0x1aa>
}
    1ad6:	4501                	li	a0,0
    1ad8:	60ea                	ld	ra,152(sp)
    1ada:	644a                	ld	s0,144(sp)
    1adc:	64aa                	ld	s1,136(sp)
    1ade:	690a                	ld	s2,128(sp)
    1ae0:	79e6                	ld	s3,120(sp)
    1ae2:	7a46                	ld	s4,112(sp)
    1ae4:	7aa6                	ld	s5,104(sp)
    1ae6:	7b06                	ld	s6,96(sp)
    1ae8:	6be6                	ld	s7,88(sp)
    1aea:	6c46                	ld	s8,80(sp)
    1aec:	6ca6                	ld	s9,72(sp)
    1aee:	6d06                	ld	s10,64(sp)
    1af0:	7de2                	ld	s11,56(sp)
    1af2:	610d                	addi	sp,sp,160
    1af4:	8082                	ret

0000000000001af6 <linkunlink>:
{
    1af6:	711d                	addi	sp,sp,-96
    1af8:	ec86                	sd	ra,88(sp)
    1afa:	e8a2                	sd	s0,80(sp)
    1afc:	e4a6                	sd	s1,72(sp)
    1afe:	e0ca                	sd	s2,64(sp)
    1b00:	fc4e                	sd	s3,56(sp)
    1b02:	f852                	sd	s4,48(sp)
    1b04:	f456                	sd	s5,40(sp)
    1b06:	f05a                	sd	s6,32(sp)
    1b08:	ec5e                	sd	s7,24(sp)
    1b0a:	e862                	sd	s8,16(sp)
    1b0c:	e466                	sd	s9,8(sp)
    1b0e:	e06a                	sd	s10,0(sp)
    1b10:	1080                	addi	s0,sp,96
    1b12:	84aa                	mv	s1,a0
  unlink("x");
    1b14:	00004517          	auipc	a0,0x4
    1b18:	d0450513          	addi	a0,a0,-764 # 5818 <malloc+0x19c>
    1b1c:	6a2030ef          	jal	51be <unlink>
  pid = fork();
    1b20:	646030ef          	jal	5166 <fork>
  if(pid < 0){
    1b24:	04054363          	bltz	a0,1b6a <linkunlink+0x74>
    1b28:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1b2a:	06100913          	li	s2,97
    1b2e:	c111                	beqz	a0,1b32 <linkunlink+0x3c>
    1b30:	4905                	li	s2,1
    1b32:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1b36:	41c65ab7          	lui	s5,0x41c65
    1b3a:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561b5>
    1b3e:	6a0d                	lui	s4,0x3
    1b40:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x2d3>
    if((x % 3) == 0){
    1b44:	000ab9b7          	lui	s3,0xab
    1b48:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9bdf3>
    1b4c:	09b2                	slli	s3,s3,0xc
    1b4e:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b52:	4b85                	li	s7,1
      unlink("x");
    1b54:	00004b17          	auipc	s6,0x4
    1b58:	cc4b0b13          	addi	s6,s6,-828 # 5818 <malloc+0x19c>
      link("cat", "x");
    1b5c:	00004c97          	auipc	s9,0x4
    1b60:	734c8c93          	addi	s9,s9,1844 # 6290 <malloc+0xc14>
      close(open("x", O_RDWR | O_CREATE));
    1b64:	20200c13          	li	s8,514
    1b68:	a03d                	j	1b96 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b6a:	85a6                	mv	a1,s1
    1b6c:	00004517          	auipc	a0,0x4
    1b70:	4cc50513          	addi	a0,a0,1228 # 6038 <malloc+0x9bc>
    1b74:	251030ef          	jal	55c4 <printf>
    exit(1);
    1b78:	4505                	li	a0,1
    1b7a:	5f4030ef          	jal	516e <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b7e:	85e2                	mv	a1,s8
    1b80:	855a                	mv	a0,s6
    1b82:	62c030ef          	jal	51ae <open>
    1b86:	610030ef          	jal	5196 <close>
    1b8a:	a021                	j	1b92 <linkunlink+0x9c>
      unlink("x");
    1b8c:	855a                	mv	a0,s6
    1b8e:	630030ef          	jal	51be <unlink>
  for(i = 0; i < 100; i++){
    1b92:	34fd                	addiw	s1,s1,-1
    1b94:	c885                	beqz	s1,1bc4 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    1b96:	035907bb          	mulw	a5,s2,s5
    1b9a:	00fa07bb          	addw	a5,s4,a5
    1b9e:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1ba0:	02079713          	slli	a4,a5,0x20
    1ba4:	9301                	srli	a4,a4,0x20
    1ba6:	03370733          	mul	a4,a4,s3
    1baa:	9305                	srli	a4,a4,0x21
    1bac:	0017169b          	slliw	a3,a4,0x1
    1bb0:	9f35                	addw	a4,a4,a3
    1bb2:	9f99                	subw	a5,a5,a4
    1bb4:	d7e9                	beqz	a5,1b7e <linkunlink+0x88>
    } else if((x % 3) == 1){
    1bb6:	fd779be3          	bne	a5,s7,1b8c <linkunlink+0x96>
      link("cat", "x");
    1bba:	85da                	mv	a1,s6
    1bbc:	8566                	mv	a0,s9
    1bbe:	610030ef          	jal	51ce <link>
    1bc2:	bfc1                	j	1b92 <linkunlink+0x9c>
  if(pid)
    1bc4:	020d0463          	beqz	s10,1bec <linkunlink+0xf6>
    wait(0);
    1bc8:	4501                	li	a0,0
    1bca:	5ac030ef          	jal	5176 <wait>
}
    1bce:	4501                	li	a0,0
    1bd0:	60e6                	ld	ra,88(sp)
    1bd2:	6446                	ld	s0,80(sp)
    1bd4:	64a6                	ld	s1,72(sp)
    1bd6:	6906                	ld	s2,64(sp)
    1bd8:	79e2                	ld	s3,56(sp)
    1bda:	7a42                	ld	s4,48(sp)
    1bdc:	7aa2                	ld	s5,40(sp)
    1bde:	7b02                	ld	s6,32(sp)
    1be0:	6be2                	ld	s7,24(sp)
    1be2:	6c42                	ld	s8,16(sp)
    1be4:	6ca2                	ld	s9,8(sp)
    1be6:	6d02                	ld	s10,0(sp)
    1be8:	6125                	addi	sp,sp,96
    1bea:	8082                	ret
    exit(0);
    1bec:	4501                	li	a0,0
    1bee:	580030ef          	jal	516e <exit>

0000000000001bf2 <forktest>:
{
    1bf2:	7179                	addi	sp,sp,-48
    1bf4:	f406                	sd	ra,40(sp)
    1bf6:	f022                	sd	s0,32(sp)
    1bf8:	ec26                	sd	s1,24(sp)
    1bfa:	e84a                	sd	s2,16(sp)
    1bfc:	e44e                	sd	s3,8(sp)
    1bfe:	1800                	addi	s0,sp,48
    1c00:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1c02:	4481                	li	s1,0
    1c04:	3e800913          	li	s2,1000
    pid = fork();
    1c08:	55e030ef          	jal	5166 <fork>
    if(pid < 0)
    1c0c:	06054063          	bltz	a0,1c6c <forktest+0x7a>
    if(pid == 0)
    1c10:	cd11                	beqz	a0,1c2c <forktest+0x3a>
  for(n=0; n<N; n++){
    1c12:	2485                	addiw	s1,s1,1
    1c14:	ff249ae3          	bne	s1,s2,1c08 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1c18:	85ce                	mv	a1,s3
    1c1a:	00004517          	auipc	a0,0x4
    1c1e:	6c650513          	addi	a0,a0,1734 # 62e0 <malloc+0xc64>
    1c22:	1a3030ef          	jal	55c4 <printf>
    exit(1);
    1c26:	4505                	li	a0,1
    1c28:	546030ef          	jal	516e <exit>
      exit(0);
    1c2c:	542030ef          	jal	516e <exit>
    printf("%s: no fork at all!\n", s);
    1c30:	85ce                	mv	a1,s3
    1c32:	00004517          	auipc	a0,0x4
    1c36:	66650513          	addi	a0,a0,1638 # 6298 <malloc+0xc1c>
    1c3a:	18b030ef          	jal	55c4 <printf>
    exit(1);
    1c3e:	4505                	li	a0,1
    1c40:	52e030ef          	jal	516e <exit>
      printf("%s: wait stopped early\n", s);
    1c44:	85ce                	mv	a1,s3
    1c46:	00004517          	auipc	a0,0x4
    1c4a:	66a50513          	addi	a0,a0,1642 # 62b0 <malloc+0xc34>
    1c4e:	177030ef          	jal	55c4 <printf>
      exit(1);
    1c52:	4505                	li	a0,1
    1c54:	51a030ef          	jal	516e <exit>
    printf("%s: wait got too many\n", s);
    1c58:	85ce                	mv	a1,s3
    1c5a:	00004517          	auipc	a0,0x4
    1c5e:	66e50513          	addi	a0,a0,1646 # 62c8 <malloc+0xc4c>
    1c62:	163030ef          	jal	55c4 <printf>
    exit(1);
    1c66:	4505                	li	a0,1
    1c68:	506030ef          	jal	516e <exit>
  if (n == 0) {
    1c6c:	d0f1                	beqz	s1,1c30 <forktest+0x3e>
  for(; n > 0; n--){
    1c6e:	00905963          	blez	s1,1c80 <forktest+0x8e>
    if(wait(0) < 0){
    1c72:	4501                	li	a0,0
    1c74:	502030ef          	jal	5176 <wait>
    1c78:	fc0546e3          	bltz	a0,1c44 <forktest+0x52>
  for(; n > 0; n--){
    1c7c:	34fd                	addiw	s1,s1,-1
    1c7e:	f8f5                	bnez	s1,1c72 <forktest+0x80>
  if(wait(0) != -1){
    1c80:	4501                	li	a0,0
    1c82:	4f4030ef          	jal	5176 <wait>
    1c86:	57fd                	li	a5,-1
    1c88:	fcf518e3          	bne	a0,a5,1c58 <forktest+0x66>
}
    1c8c:	4501                	li	a0,0
    1c8e:	70a2                	ld	ra,40(sp)
    1c90:	7402                	ld	s0,32(sp)
    1c92:	64e2                	ld	s1,24(sp)
    1c94:	6942                	ld	s2,16(sp)
    1c96:	69a2                	ld	s3,8(sp)
    1c98:	6145                	addi	sp,sp,48
    1c9a:	8082                	ret

0000000000001c9c <kernmem>:
{
    1c9c:	715d                	addi	sp,sp,-80
    1c9e:	e486                	sd	ra,72(sp)
    1ca0:	e0a2                	sd	s0,64(sp)
    1ca2:	fc26                	sd	s1,56(sp)
    1ca4:	f84a                	sd	s2,48(sp)
    1ca6:	f44e                	sd	s3,40(sp)
    1ca8:	f052                	sd	s4,32(sp)
    1caa:	ec56                	sd	s5,24(sp)
    1cac:	e85a                	sd	s6,16(sp)
    1cae:	0880                	addi	s0,sp,80
    1cb0:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1cb2:	4485                	li	s1,1
    1cb4:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1cb6:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    1cba:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1cbc:	69b1                	lui	s3,0xc
    1cbe:	35098993          	addi	s3,s3,848 # c350 <buf+0x698>
    1cc2:	1003d937          	lui	s2,0x1003d
    1cc6:	090e                	slli	s2,s2,0x3
    1cc8:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7c8>
    pid = fork();
    1ccc:	49a030ef          	jal	5166 <fork>
    if(pid < 0){
    1cd0:	02054863          	bltz	a0,1d00 <kernmem+0x64>
    if(pid == 0){
    1cd4:	c121                	beqz	a0,1d14 <kernmem+0x78>
    wait(&xstatus);
    1cd6:	8556                	mv	a0,s5
    1cd8:	49e030ef          	jal	5176 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1cdc:	fbc42783          	lw	a5,-68(s0)
    1ce0:	05479763          	bne	a5,s4,1d2e <kernmem+0x92>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ce4:	94ce                	add	s1,s1,s3
    1ce6:	ff2493e3          	bne	s1,s2,1ccc <kernmem+0x30>
}
    1cea:	4501                	li	a0,0
    1cec:	60a6                	ld	ra,72(sp)
    1cee:	6406                	ld	s0,64(sp)
    1cf0:	74e2                	ld	s1,56(sp)
    1cf2:	7942                	ld	s2,48(sp)
    1cf4:	79a2                	ld	s3,40(sp)
    1cf6:	7a02                	ld	s4,32(sp)
    1cf8:	6ae2                	ld	s5,24(sp)
    1cfa:	6b42                	ld	s6,16(sp)
    1cfc:	6161                	addi	sp,sp,80
    1cfe:	8082                	ret
      printf("%s: fork failed\n", s);
    1d00:	85da                	mv	a1,s6
    1d02:	00004517          	auipc	a0,0x4
    1d06:	33650513          	addi	a0,a0,822 # 6038 <malloc+0x9bc>
    1d0a:	0bb030ef          	jal	55c4 <printf>
      exit(1);
    1d0e:	4505                	li	a0,1
    1d10:	45e030ef          	jal	516e <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1d14:	0004c683          	lbu	a3,0(s1)
    1d18:	8626                	mv	a2,s1
    1d1a:	85da                	mv	a1,s6
    1d1c:	00004517          	auipc	a0,0x4
    1d20:	5ec50513          	addi	a0,a0,1516 # 6308 <malloc+0xc8c>
    1d24:	0a1030ef          	jal	55c4 <printf>
      exit(1);
    1d28:	4505                	li	a0,1
    1d2a:	444030ef          	jal	516e <exit>
      exit(1);
    1d2e:	4505                	li	a0,1
    1d30:	43e030ef          	jal	516e <exit>

0000000000001d34 <MAXVAplus>:
{
    1d34:	7139                	addi	sp,sp,-64
    1d36:	fc06                	sd	ra,56(sp)
    1d38:	f822                	sd	s0,48(sp)
    1d3a:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1d3c:	4785                	li	a5,1
    1d3e:	179a                	slli	a5,a5,0x26
    1d40:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    1d44:	fc843783          	ld	a5,-56(s0)
    1d48:	cf9d                	beqz	a5,1d86 <MAXVAplus+0x52>
    1d4a:	f426                	sd	s1,40(sp)
    1d4c:	f04a                	sd	s2,32(sp)
    1d4e:	ec4e                	sd	s3,24(sp)
    1d50:	89aa                	mv	s3,a0
    wait(&xstatus);
    1d52:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    1d56:	54fd                	li	s1,-1
    pid = fork();
    1d58:	40e030ef          	jal	5166 <fork>
    if(pid < 0){
    1d5c:	02054a63          	bltz	a0,1d90 <MAXVAplus+0x5c>
    if(pid == 0){
    1d60:	c131                	beqz	a0,1da4 <MAXVAplus+0x70>
    wait(&xstatus);
    1d62:	854a                	mv	a0,s2
    1d64:	412030ef          	jal	5176 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1d68:	fc442783          	lw	a5,-60(s0)
    1d6c:	04979e63          	bne	a5,s1,1dc8 <MAXVAplus+0x94>
  for( ; a != 0; a <<= 1){
    1d70:	fc843783          	ld	a5,-56(s0)
    1d74:	0786                	slli	a5,a5,0x1
    1d76:	fcf43423          	sd	a5,-56(s0)
    1d7a:	fc843783          	ld	a5,-56(s0)
    1d7e:	ffe9                	bnez	a5,1d58 <MAXVAplus+0x24>
    1d80:	74a2                	ld	s1,40(sp)
    1d82:	7902                	ld	s2,32(sp)
    1d84:	69e2                	ld	s3,24(sp)
}
    1d86:	4501                	li	a0,0
    1d88:	70e2                	ld	ra,56(sp)
    1d8a:	7442                	ld	s0,48(sp)
    1d8c:	6121                	addi	sp,sp,64
    1d8e:	8082                	ret
      printf("%s: fork failed\n", s);
    1d90:	85ce                	mv	a1,s3
    1d92:	00004517          	auipc	a0,0x4
    1d96:	2a650513          	addi	a0,a0,678 # 6038 <malloc+0x9bc>
    1d9a:	02b030ef          	jal	55c4 <printf>
      exit(1);
    1d9e:	4505                	li	a0,1
    1da0:	3ce030ef          	jal	516e <exit>
      *(char*)a = 99;
    1da4:	fc843783          	ld	a5,-56(s0)
    1da8:	06300713          	li	a4,99
    1dac:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1db0:	fc843603          	ld	a2,-56(s0)
    1db4:	85ce                	mv	a1,s3
    1db6:	00004517          	auipc	a0,0x4
    1dba:	57250513          	addi	a0,a0,1394 # 6328 <malloc+0xcac>
    1dbe:	007030ef          	jal	55c4 <printf>
      exit(1);
    1dc2:	4505                	li	a0,1
    1dc4:	3aa030ef          	jal	516e <exit>
      exit(1);
    1dc8:	4505                	li	a0,1
    1dca:	3a4030ef          	jal	516e <exit>

0000000000001dce <stacktest>:
{
    1dce:	7179                	addi	sp,sp,-48
    1dd0:	f406                	sd	ra,40(sp)
    1dd2:	f022                	sd	s0,32(sp)
    1dd4:	ec26                	sd	s1,24(sp)
    1dd6:	1800                	addi	s0,sp,48
    1dd8:	84aa                	mv	s1,a0
  pid = fork();
    1dda:	38c030ef          	jal	5166 <fork>
  if(pid == 0) {
    1dde:	c10d                	beqz	a0,1e00 <stacktest+0x32>
  } else if(pid < 0){
    1de0:	02054f63          	bltz	a0,1e1e <stacktest+0x50>
  wait(&xstatus);
    1de4:	fdc40513          	addi	a0,s0,-36
    1de8:	38e030ef          	jal	5176 <wait>
  if(xstatus == -1)  // kernel killed child?
    1dec:	fdc42503          	lw	a0,-36(s0)
    1df0:	57fd                	li	a5,-1
    1df2:	04f50063          	beq	a0,a5,1e32 <stacktest+0x64>
}
    1df6:	70a2                	ld	ra,40(sp)
    1df8:	7402                	ld	s0,32(sp)
    1dfa:	64e2                	ld	s1,24(sp)
    1dfc:	6145                	addi	sp,sp,48
    1dfe:	8082                	ret

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1e00:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1e02:	80078793          	addi	a5,a5,-2048
    1e06:	8007c603          	lbu	a2,-2048(a5)
    1e0a:	85a6                	mv	a1,s1
    1e0c:	00004517          	auipc	a0,0x4
    1e10:	53450513          	addi	a0,a0,1332 # 6340 <malloc+0xcc4>
    1e14:	7b0030ef          	jal	55c4 <printf>
    exit(1);
    1e18:	4505                	li	a0,1
    1e1a:	354030ef          	jal	516e <exit>
    printf("%s: fork failed\n", s);
    1e1e:	85a6                	mv	a1,s1
    1e20:	00004517          	auipc	a0,0x4
    1e24:	21850513          	addi	a0,a0,536 # 6038 <malloc+0x9bc>
    1e28:	79c030ef          	jal	55c4 <printf>
    exit(1);
    1e2c:	4505                	li	a0,1
    1e2e:	340030ef          	jal	516e <exit>
    return 0;
    1e32:	4501                	li	a0,0
    1e34:	b7c9                	j	1df6 <stacktest+0x28>

0000000000001e36 <nowrite>:
{
    1e36:	7159                	addi	sp,sp,-112
    1e38:	f486                	sd	ra,104(sp)
    1e3a:	f0a2                	sd	s0,96(sp)
    1e3c:	eca6                	sd	s1,88(sp)
    1e3e:	e8ca                	sd	s2,80(sp)
    1e40:	e4ce                	sd	s3,72(sp)
    1e42:	e0d2                	sd	s4,64(sp)
    1e44:	1880                	addi	s0,sp,112
    1e46:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1e48:	00006797          	auipc	a5,0x6
    1e4c:	ec878793          	addi	a5,a5,-312 # 7d10 <malloc+0x2694>
    1e50:	7788                	ld	a0,40(a5)
    1e52:	7b8c                	ld	a1,48(a5)
    1e54:	7f90                	ld	a2,56(a5)
    1e56:	63b4                	ld	a3,64(a5)
    1e58:	67b8                	ld	a4,72(a5)
    1e5a:	f8a43c23          	sd	a0,-104(s0)
    1e5e:	fab43023          	sd	a1,-96(s0)
    1e62:	fac43423          	sd	a2,-88(s0)
    1e66:	fad43823          	sd	a3,-80(s0)
    1e6a:	fae43c23          	sd	a4,-72(s0)
    1e6e:	6bbc                	ld	a5,80(a5)
    1e70:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e74:	4481                	li	s1,0
    wait(&xstatus);
    1e76:	fcc40993          	addi	s3,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e7a:	4919                	li	s2,6
    pid = fork();
    1e7c:	2ea030ef          	jal	5166 <fork>
    if(pid == 0) {
    1e80:	c50d                	beqz	a0,1eaa <nowrite+0x74>
    } else if(pid < 0){
    1e82:	04054763          	bltz	a0,1ed0 <nowrite+0x9a>
    wait(&xstatus);
    1e86:	854e                	mv	a0,s3
    1e88:	2ee030ef          	jal	5176 <wait>
    if(xstatus == 0){
    1e8c:	fcc42783          	lw	a5,-52(s0)
    1e90:	cbb1                	beqz	a5,1ee4 <nowrite+0xae>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e92:	2485                	addiw	s1,s1,1
    1e94:	ff2494e3          	bne	s1,s2,1e7c <nowrite+0x46>
}
    1e98:	4501                	li	a0,0
    1e9a:	70a6                	ld	ra,104(sp)
    1e9c:	7406                	ld	s0,96(sp)
    1e9e:	64e6                	ld	s1,88(sp)
    1ea0:	6946                	ld	s2,80(sp)
    1ea2:	69a6                	ld	s3,72(sp)
    1ea4:	6a06                	ld	s4,64(sp)
    1ea6:	6165                	addi	sp,sp,112
    1ea8:	8082                	ret
      volatile int *addr = (int *) addrs[ai];
    1eaa:	00349793          	slli	a5,s1,0x3
    1eae:	fd078793          	addi	a5,a5,-48
    1eb2:	97a2                	add	a5,a5,s0
    1eb4:	fc87b603          	ld	a2,-56(a5)
      *addr = 10;
    1eb8:	47a9                	li	a5,10
    1eba:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1ebc:	85d2                	mv	a1,s4
    1ebe:	00004517          	auipc	a0,0x4
    1ec2:	4aa50513          	addi	a0,a0,1194 # 6368 <malloc+0xcec>
    1ec6:	6fe030ef          	jal	55c4 <printf>
      exit(0);
    1eca:	4501                	li	a0,0
    1ecc:	2a2030ef          	jal	516e <exit>
      printf("%s: fork failed\n", s);
    1ed0:	85d2                	mv	a1,s4
    1ed2:	00004517          	auipc	a0,0x4
    1ed6:	16650513          	addi	a0,a0,358 # 6038 <malloc+0x9bc>
    1eda:	6ea030ef          	jal	55c4 <printf>
      exit(1);
    1ede:	4505                	li	a0,1
    1ee0:	28e030ef          	jal	516e <exit>
      exit(1);
    1ee4:	4505                	li	a0,1
    1ee6:	288030ef          	jal	516e <exit>

0000000000001eea <manywrites>:
{
    1eea:	7159                	addi	sp,sp,-112
    1eec:	f486                	sd	ra,104(sp)
    1eee:	f0a2                	sd	s0,96(sp)
    1ef0:	eca6                	sd	s1,88(sp)
    1ef2:	e0d2                	sd	s4,64(sp)
    1ef4:	f062                	sd	s8,32(sp)
    1ef6:	e86a                	sd	s10,16(sp)
    1ef8:	1880                	addi	s0,sp,112
    1efa:	8d2a                	mv	s10,a0
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	4a01                	li	s4,0
    1efe:	4491                	li	s1,4
    int pid = fork();
    1f00:	266030ef          	jal	5166 <fork>
    1f04:	8c2a                	mv	s8,a0
    if(pid < 0){
    1f06:	02054e63          	bltz	a0,1f42 <manywrites+0x58>
    if(pid == 0){
    1f0a:	c939                	beqz	a0,1f60 <manywrites+0x76>
  for(int ci = 0; ci < nchildren; ci++){
    1f0c:	2a05                	addiw	s4,s4,1
    1f0e:	fe9a19e3          	bne	s4,s1,1f00 <manywrites+0x16>
    1f12:	e8ca                	sd	s2,80(sp)
    1f14:	4491                	li	s1,4
    wait(&st);
    1f16:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1f1a:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1f1e:	854a                	mv	a0,s2
    1f20:	256030ef          	jal	5176 <wait>
    if(st != 0)
    1f24:	f9842503          	lw	a0,-104(s0)
    1f28:	0e051763          	bnez	a0,2016 <manywrites+0x12c>
  for(int ci = 0; ci < nchildren; ci++){
    1f2c:	34fd                	addiw	s1,s1,-1
    1f2e:	f4f5                	bnez	s1,1f1a <manywrites+0x30>
}
    1f30:	6946                	ld	s2,80(sp)
    1f32:	70a6                	ld	ra,104(sp)
    1f34:	7406                	ld	s0,96(sp)
    1f36:	64e6                	ld	s1,88(sp)
    1f38:	6a06                	ld	s4,64(sp)
    1f3a:	7c02                	ld	s8,32(sp)
    1f3c:	6d42                	ld	s10,16(sp)
    1f3e:	6165                	addi	sp,sp,112
    1f40:	8082                	ret
    1f42:	e8ca                	sd	s2,80(sp)
    1f44:	e4ce                	sd	s3,72(sp)
    1f46:	fc56                	sd	s5,56(sp)
    1f48:	f85a                	sd	s6,48(sp)
    1f4a:	f45e                	sd	s7,40(sp)
    1f4c:	ec66                	sd	s9,24(sp)
      printf("fork failed\n");
    1f4e:	00005517          	auipc	a0,0x5
    1f52:	69250513          	addi	a0,a0,1682 # 75e0 <malloc+0x1f64>
    1f56:	66e030ef          	jal	55c4 <printf>
      exit(1);
    1f5a:	4505                	li	a0,1
    1f5c:	212030ef          	jal	516e <exit>
    1f60:	e8ca                	sd	s2,80(sp)
    1f62:	e4ce                	sd	s3,72(sp)
    1f64:	fc56                	sd	s5,56(sp)
    1f66:	f85a                	sd	s6,48(sp)
    1f68:	f45e                	sd	s7,40(sp)
    1f6a:	ec66                	sd	s9,24(sp)
      name[0] = 'b';
    1f6c:	06200793          	li	a5,98
    1f70:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1f74:	061a079b          	addiw	a5,s4,97
    1f78:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1f7c:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1f80:	f9840513          	addi	a0,s0,-104
    1f84:	23a030ef          	jal	51be <unlink>
    1f88:	4cf9                	li	s9,30
          int fd = open(name, O_CREATE | O_RDWR);
    1f8a:	f9840a93          	addi	s5,s0,-104
    1f8e:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
    1f92:	698d                	lui	s3,0x3
    1f94:	0000ab17          	auipc	s6,0xa
    1f98:	d24b0b13          	addi	s6,s6,-732 # bcb8 <buf>
    1f9c:	a83d                	j	1fda <manywrites+0xf0>
            printf("%s: cannot create %s\n", s, name);
    1f9e:	f9840613          	addi	a2,s0,-104
    1fa2:	85ea                	mv	a1,s10
    1fa4:	00004517          	auipc	a0,0x4
    1fa8:	3e450513          	addi	a0,a0,996 # 6388 <malloc+0xd0c>
    1fac:	618030ef          	jal	55c4 <printf>
            exit(1);
    1fb0:	4505                	li	a0,1
    1fb2:	1bc030ef          	jal	516e <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fb6:	86aa                	mv	a3,a0
    1fb8:	660d                	lui	a2,0x3
    1fba:	85ea                	mv	a1,s10
    1fbc:	00004517          	auipc	a0,0x4
    1fc0:	8bc50513          	addi	a0,a0,-1860 # 5878 <malloc+0x1fc>
    1fc4:	600030ef          	jal	55c4 <printf>
            exit(1);
    1fc8:	4505                	li	a0,1
    1fca:	1a4030ef          	jal	516e <exit>
        unlink(name);
    1fce:	8556                	mv	a0,s5
    1fd0:	1ee030ef          	jal	51be <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1fd4:	3cfd                	addiw	s9,s9,-1
    1fd6:	020c8963          	beqz	s9,2008 <manywrites+0x11e>
        for(int i = 0; i < ci+1; i++){
    1fda:	8962                	mv	s2,s8
    1fdc:	fe0a49e3          	bltz	s4,1fce <manywrites+0xe4>
          int fd = open(name, O_CREATE | O_RDWR);
    1fe0:	85de                	mv	a1,s7
    1fe2:	8556                	mv	a0,s5
    1fe4:	1ca030ef          	jal	51ae <open>
    1fe8:	84aa                	mv	s1,a0
          if(fd < 0){
    1fea:	fa054ae3          	bltz	a0,1f9e <manywrites+0xb4>
          int cc = write(fd, buf, sz);
    1fee:	864e                	mv	a2,s3
    1ff0:	85da                	mv	a1,s6
    1ff2:	19c030ef          	jal	518e <write>
          if(cc != sz){
    1ff6:	fd3510e3          	bne	a0,s3,1fb6 <manywrites+0xcc>
          close(fd);
    1ffa:	8526                	mv	a0,s1
    1ffc:	19a030ef          	jal	5196 <close>
        for(int i = 0; i < ci+1; i++){
    2000:	2905                	addiw	s2,s2,1
    2002:	fd2a5fe3          	bge	s4,s2,1fe0 <manywrites+0xf6>
    2006:	b7e1                	j	1fce <manywrites+0xe4>
      unlink(name);
    2008:	f9840513          	addi	a0,s0,-104
    200c:	1b2030ef          	jal	51be <unlink>
      exit(0);
    2010:	4501                	li	a0,0
    2012:	15c030ef          	jal	516e <exit>
    2016:	e4ce                	sd	s3,72(sp)
    2018:	fc56                	sd	s5,56(sp)
    201a:	f85a                	sd	s6,48(sp)
    201c:	f45e                	sd	s7,40(sp)
    201e:	ec66                	sd	s9,24(sp)
      exit(st);
    2020:	14e030ef          	jal	516e <exit>

0000000000002024 <copyinstr3>:
{
    2024:	7179                	addi	sp,sp,-48
    2026:	f406                	sd	ra,40(sp)
    2028:	f022                	sd	s0,32(sp)
    202a:	ec26                	sd	s1,24(sp)
    202c:	1800                	addi	s0,sp,48
  sbrk(8192);
    202e:	6509                	lui	a0,0x2
    2030:	10a030ef          	jal	513a <sbrk>
  uint64 top = (uint64) sbrk(0);
    2034:	4501                	li	a0,0
    2036:	104030ef          	jal	513a <sbrk>
  if((top % PGSIZE) != 0){
    203a:	03451793          	slli	a5,a0,0x34
    203e:	eba5                	bnez	a5,20ae <copyinstr3+0x8a>
  top = (uint64) sbrk(0);
    2040:	4501                	li	a0,0
    2042:	0f8030ef          	jal	513a <sbrk>
  if(top % PGSIZE){
    2046:	03451793          	slli	a5,a0,0x34
    204a:	ebb5                	bnez	a5,20be <copyinstr3+0x9a>
  char *b = (char *) (top - 1);
    204c:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x115>
  *b = 'x';
    2050:	07800793          	li	a5,120
    2054:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2058:	8526                	mv	a0,s1
    205a:	164030ef          	jal	51be <unlink>
  if(ret != -1){
    205e:	57fd                	li	a5,-1
    2060:	06f51863          	bne	a0,a5,20d0 <copyinstr3+0xac>
  int fd = open(b, O_CREATE | O_WRONLY);
    2064:	20100593          	li	a1,513
    2068:	8526                	mv	a0,s1
    206a:	144030ef          	jal	51ae <open>
  if(fd != -1){
    206e:	57fd                	li	a5,-1
    2070:	06f51b63          	bne	a0,a5,20e6 <copyinstr3+0xc2>
  ret = link(b, b);
    2074:	85a6                	mv	a1,s1
    2076:	8526                	mv	a0,s1
    2078:	156030ef          	jal	51ce <link>
  if(ret != -1){
    207c:	57fd                	li	a5,-1
    207e:	06f51f63          	bne	a0,a5,20fc <copyinstr3+0xd8>
  char *args[] = { "xx", 0 };
    2082:	00005797          	auipc	a5,0x5
    2086:	00678793          	addi	a5,a5,6 # 7088 <malloc+0x1a0c>
    208a:	fcf43823          	sd	a5,-48(s0)
    208e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2092:	fd040593          	addi	a1,s0,-48
    2096:	8526                	mv	a0,s1
    2098:	10e030ef          	jal	51a6 <exec>
  if(ret != -1){
    209c:	57fd                	li	a5,-1
    209e:	06f51b63          	bne	a0,a5,2114 <copyinstr3+0xf0>
}
    20a2:	4501                	li	a0,0
    20a4:	70a2                	ld	ra,40(sp)
    20a6:	7402                	ld	s0,32(sp)
    20a8:	64e2                	ld	s1,24(sp)
    20aa:	6145                	addi	sp,sp,48
    20ac:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    20ae:	0347d513          	srli	a0,a5,0x34
    20b2:	6785                	lui	a5,0x1
    20b4:	40a7853b          	subw	a0,a5,a0
    20b8:	082030ef          	jal	513a <sbrk>
    20bc:	b751                	j	2040 <copyinstr3+0x1c>
    printf("oops\n");
    20be:	00004517          	auipc	a0,0x4
    20c2:	2e250513          	addi	a0,a0,738 # 63a0 <malloc+0xd24>
    20c6:	4fe030ef          	jal	55c4 <printf>
    exit(1);
    20ca:	4505                	li	a0,1
    20cc:	0a2030ef          	jal	516e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    20d0:	862a                	mv	a2,a0
    20d2:	85a6                	mv	a1,s1
    20d4:	00004517          	auipc	a0,0x4
    20d8:	e8450513          	addi	a0,a0,-380 # 5f58 <malloc+0x8dc>
    20dc:	4e8030ef          	jal	55c4 <printf>
    exit(1);
    20e0:	4505                	li	a0,1
    20e2:	08c030ef          	jal	516e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    20e6:	862a                	mv	a2,a0
    20e8:	85a6                	mv	a1,s1
    20ea:	00004517          	auipc	a0,0x4
    20ee:	e8e50513          	addi	a0,a0,-370 # 5f78 <malloc+0x8fc>
    20f2:	4d2030ef          	jal	55c4 <printf>
    exit(1);
    20f6:	4505                	li	a0,1
    20f8:	076030ef          	jal	516e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    20fc:	86aa                	mv	a3,a0
    20fe:	8626                	mv	a2,s1
    2100:	85a6                	mv	a1,s1
    2102:	00004517          	auipc	a0,0x4
    2106:	e9650513          	addi	a0,a0,-362 # 5f98 <malloc+0x91c>
    210a:	4ba030ef          	jal	55c4 <printf>
    exit(1);
    210e:	4505                	li	a0,1
    2110:	05e030ef          	jal	516e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2114:	863e                	mv	a2,a5
    2116:	85a6                	mv	a1,s1
    2118:	00004517          	auipc	a0,0x4
    211c:	ea850513          	addi	a0,a0,-344 # 5fc0 <malloc+0x944>
    2120:	4a4030ef          	jal	55c4 <printf>
    exit(1);
    2124:	4505                	li	a0,1
    2126:	048030ef          	jal	516e <exit>

000000000000212a <rwsbrk>:
{
    212a:	1101                	addi	sp,sp,-32
    212c:	ec06                	sd	ra,24(sp)
    212e:	e822                	sd	s0,16(sp)
    2130:	e426                	sd	s1,8(sp)
    2132:	e04a                	sd	s2,0(sp)
    2134:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2136:	6509                	lui	a0,0x2
    2138:	002030ef          	jal	513a <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    213c:	57fd                	li	a5,-1
    213e:	08f50063          	beq	a0,a5,21be <rwsbrk+0x94>
    2142:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    2144:	7579                	lui	a0,0xffffe
    2146:	7f5020ef          	jal	513a <sbrk>
    214a:	57fd                	li	a5,-1
    214c:	08f50263          	beq	a0,a5,21d0 <rwsbrk+0xa6>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2150:	20100593          	li	a1,513
    2154:	00004517          	auipc	a0,0x4
    2158:	28c50513          	addi	a0,a0,652 # 63e0 <malloc+0xd64>
    215c:	052030ef          	jal	51ae <open>
    2160:	892a                	mv	s2,a0
  if(fd < 0){
    2162:	08054063          	bltz	a0,21e2 <rwsbrk+0xb8>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    2166:	6785                	lui	a5,0x1
    2168:	94be                	add	s1,s1,a5
    216a:	40000613          	li	a2,1024
    216e:	85a6                	mv	a1,s1
    2170:	01e030ef          	jal	518e <write>
  if(n >= 0){
    2174:	08055063          	bgez	a0,21f4 <rwsbrk+0xca>
  close(fd);
    2178:	854a                	mv	a0,s2
    217a:	01c030ef          	jal	5196 <close>
  unlink("rwsbrk");
    217e:	00004517          	auipc	a0,0x4
    2182:	26250513          	addi	a0,a0,610 # 63e0 <malloc+0xd64>
    2186:	038030ef          	jal	51be <unlink>
  fd = open("README", O_RDONLY);
    218a:	4581                	li	a1,0
    218c:	00003517          	auipc	a0,0x3
    2190:	7f450513          	addi	a0,a0,2036 # 5980 <malloc+0x304>
    2194:	01a030ef          	jal	51ae <open>
    2198:	892a                	mv	s2,a0
  if(fd < 0){
    219a:	06054863          	bltz	a0,220a <rwsbrk+0xe0>
  n = read(fd, (void*)(a+PGSIZE), 10);
    219e:	4629                	li	a2,10
    21a0:	85a6                	mv	a1,s1
    21a2:	7e5020ef          	jal	5186 <read>
  if(n >= 0){
    21a6:	06055b63          	bgez	a0,221c <rwsbrk+0xf2>
  close(fd);
    21aa:	854a                	mv	a0,s2
    21ac:	7eb020ef          	jal	5196 <close>
}
    21b0:	4501                	li	a0,0
    21b2:	60e2                	ld	ra,24(sp)
    21b4:	6442                	ld	s0,16(sp)
    21b6:	64a2                	ld	s1,8(sp)
    21b8:	6902                	ld	s2,0(sp)
    21ba:	6105                	addi	sp,sp,32
    21bc:	8082                	ret
    printf("sbrk(rwsbrk) failed\n");
    21be:	00004517          	auipc	a0,0x4
    21c2:	1ea50513          	addi	a0,a0,490 # 63a8 <malloc+0xd2c>
    21c6:	3fe030ef          	jal	55c4 <printf>
    exit(1);
    21ca:	4505                	li	a0,1
    21cc:	7a3020ef          	jal	516e <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    21d0:	00004517          	auipc	a0,0x4
    21d4:	1f050513          	addi	a0,a0,496 # 63c0 <malloc+0xd44>
    21d8:	3ec030ef          	jal	55c4 <printf>
    exit(1);
    21dc:	4505                	li	a0,1
    21de:	791020ef          	jal	516e <exit>
    printf("open(rwsbrk) failed\n");
    21e2:	00004517          	auipc	a0,0x4
    21e6:	20650513          	addi	a0,a0,518 # 63e8 <malloc+0xd6c>
    21ea:	3da030ef          	jal	55c4 <printf>
    exit(1);
    21ee:	4505                	li	a0,1
    21f0:	77f020ef          	jal	516e <exit>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    21f4:	862a                	mv	a2,a0
    21f6:	85a6                	mv	a1,s1
    21f8:	00004517          	auipc	a0,0x4
    21fc:	20850513          	addi	a0,a0,520 # 6400 <malloc+0xd84>
    2200:	3c4030ef          	jal	55c4 <printf>
    exit(1);
    2204:	4505                	li	a0,1
    2206:	769020ef          	jal	516e <exit>
    printf("open(README) failed\n");
    220a:	00003517          	auipc	a0,0x3
    220e:	77e50513          	addi	a0,a0,1918 # 5988 <malloc+0x30c>
    2212:	3b2030ef          	jal	55c4 <printf>
    exit(1);
    2216:	4505                	li	a0,1
    2218:	757020ef          	jal	516e <exit>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    221c:	862a                	mv	a2,a0
    221e:	85a6                	mv	a1,s1
    2220:	00004517          	auipc	a0,0x4
    2224:	21050513          	addi	a0,a0,528 # 6430 <malloc+0xdb4>
    2228:	39c030ef          	jal	55c4 <printf>
    exit(1);
    222c:	4505                	li	a0,1
    222e:	741020ef          	jal	516e <exit>

0000000000002232 <sbrkbasic>:
{
    2232:	715d                	addi	sp,sp,-80
    2234:	e486                	sd	ra,72(sp)
    2236:	e0a2                	sd	s0,64(sp)
    2238:	fc26                	sd	s1,56(sp)
    223a:	f84a                	sd	s2,48(sp)
    223c:	f44e                	sd	s3,40(sp)
    223e:	f052                	sd	s4,32(sp)
    2240:	ec56                	sd	s5,24(sp)
    2242:	0880                	addi	s0,sp,80
    2244:	8aaa                	mv	s5,a0
  pid = fork();
    2246:	721020ef          	jal	5166 <fork>
  if(pid < 0){
    224a:	02054863          	bltz	a0,227a <sbrkbasic+0x48>
  if(pid == 0){
    224e:	e131                	bnez	a0,2292 <sbrkbasic+0x60>
    a = sbrk(TOOMUCH);
    2250:	40000537          	lui	a0,0x40000
    2254:	6e7020ef          	jal	513a <sbrk>
    if(a == (char*)SBRK_ERROR){
    2258:	57fd                	li	a5,-1
    225a:	02f50963          	beq	a0,a5,228c <sbrkbasic+0x5a>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    225e:	400007b7          	lui	a5,0x40000
    2262:	97aa                	add	a5,a5,a0
      *b = 99;
    2264:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2268:	6705                	lui	a4,0x1
      *b = 99;
    226a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1348>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    226e:	953a                	add	a0,a0,a4
    2270:	fef51de3          	bne	a0,a5,226a <sbrkbasic+0x38>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	6f9020ef          	jal	516e <exit>
    printf("fork failed in sbrkbasic\n");
    227a:	00004517          	auipc	a0,0x4
    227e:	1de50513          	addi	a0,a0,478 # 6458 <malloc+0xddc>
    2282:	342030ef          	jal	55c4 <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	6e7020ef          	jal	516e <exit>
      exit(0);
    228c:	4501                	li	a0,0
    228e:	6e1020ef          	jal	516e <exit>
  wait(&xstatus);
    2292:	fbc40513          	addi	a0,s0,-68
    2296:	6e1020ef          	jal	5176 <wait>
  if(xstatus == 1){
    229a:	fbc42703          	lw	a4,-68(s0)
    229e:	4785                	li	a5,1
    22a0:	00f70c63          	beq	a4,a5,22b8 <sbrkbasic+0x86>
  a = sbrk(0);
    22a4:	4501                	li	a0,0
    22a6:	695020ef          	jal	513a <sbrk>
    22aa:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    22ac:	4901                	li	s2,0
    b = sbrk(1);
    22ae:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    22b0:	6a05                	lui	s4,0x1
    22b2:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x108>
    22b6:	a821                	j	22ce <sbrkbasic+0x9c>
    printf("%s: too much memory allocated!\n", s);
    22b8:	85d6                	mv	a1,s5
    22ba:	00004517          	auipc	a0,0x4
    22be:	1be50513          	addi	a0,a0,446 # 6478 <malloc+0xdfc>
    22c2:	302030ef          	jal	55c4 <printf>
    exit(1);
    22c6:	4505                	li	a0,1
    22c8:	6a7020ef          	jal	516e <exit>
    22cc:	84be                	mv	s1,a5
    b = sbrk(1);
    22ce:	854e                	mv	a0,s3
    22d0:	66b020ef          	jal	513a <sbrk>
    if(b != a){
    22d4:	04951863          	bne	a0,s1,2324 <sbrkbasic+0xf2>
    *b = 1;
    22d8:	01348023          	sb	s3,0(s1)
    a = b + 1;
    22dc:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    22e0:	2905                	addiw	s2,s2,1
    22e2:	ff4915e3          	bne	s2,s4,22cc <sbrkbasic+0x9a>
  pid = fork();
    22e6:	681020ef          	jal	5166 <fork>
    22ea:	892a                	mv	s2,a0
  if(pid < 0){
    22ec:	04054963          	bltz	a0,233e <sbrkbasic+0x10c>
  c = sbrk(1);
    22f0:	4505                	li	a0,1
    22f2:	649020ef          	jal	513a <sbrk>
  c = sbrk(1);
    22f6:	4505                	li	a0,1
    22f8:	643020ef          	jal	513a <sbrk>
  if(c != a + 1){
    22fc:	0489                	addi	s1,s1,2
    22fe:	04951a63          	bne	a0,s1,2352 <sbrkbasic+0x120>
  if(pid == 0)
    2302:	06090263          	beqz	s2,2366 <sbrkbasic+0x134>
  wait(&xstatus);
    2306:	fbc40513          	addi	a0,s0,-68
    230a:	66d020ef          	jal	5176 <wait>
}
    230e:	fbc42503          	lw	a0,-68(s0)
    2312:	60a6                	ld	ra,72(sp)
    2314:	6406                	ld	s0,64(sp)
    2316:	74e2                	ld	s1,56(sp)
    2318:	7942                	ld	s2,48(sp)
    231a:	79a2                	ld	s3,40(sp)
    231c:	7a02                	ld	s4,32(sp)
    231e:	6ae2                	ld	s5,24(sp)
    2320:	6161                	addi	sp,sp,80
    2322:	8082                	ret
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2324:	872a                	mv	a4,a0
    2326:	86a6                	mv	a3,s1
    2328:	864a                	mv	a2,s2
    232a:	85d6                	mv	a1,s5
    232c:	00004517          	auipc	a0,0x4
    2330:	16c50513          	addi	a0,a0,364 # 6498 <malloc+0xe1c>
    2334:	290030ef          	jal	55c4 <printf>
      exit(1);
    2338:	4505                	li	a0,1
    233a:	635020ef          	jal	516e <exit>
    printf("%s: sbrk test fork failed\n", s);
    233e:	85d6                	mv	a1,s5
    2340:	00004517          	auipc	a0,0x4
    2344:	17850513          	addi	a0,a0,376 # 64b8 <malloc+0xe3c>
    2348:	27c030ef          	jal	55c4 <printf>
    exit(1);
    234c:	4505                	li	a0,1
    234e:	621020ef          	jal	516e <exit>
    printf("%s: sbrk test failed post-fork\n", s);
    2352:	85d6                	mv	a1,s5
    2354:	00004517          	auipc	a0,0x4
    2358:	18450513          	addi	a0,a0,388 # 64d8 <malloc+0xe5c>
    235c:	268030ef          	jal	55c4 <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	60d020ef          	jal	516e <exit>
    exit(0);
    2366:	4501                	li	a0,0
    2368:	607020ef          	jal	516e <exit>

000000000000236c <sbrkmuch>:
{
    236c:	7179                	addi	sp,sp,-48
    236e:	f406                	sd	ra,40(sp)
    2370:	f022                	sd	s0,32(sp)
    2372:	ec26                	sd	s1,24(sp)
    2374:	e84a                	sd	s2,16(sp)
    2376:	e44e                	sd	s3,8(sp)
    2378:	e052                	sd	s4,0(sp)
    237a:	1800                	addi	s0,sp,48
    237c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    237e:	4501                	li	a0,0
    2380:	5bb020ef          	jal	513a <sbrk>
    2384:	892a                	mv	s2,a0
  a = sbrk(0);
    2386:	4501                	li	a0,0
    2388:	5b3020ef          	jal	513a <sbrk>
    238c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    238e:	06400537          	lui	a0,0x6400
    2392:	9d05                	subw	a0,a0,s1
    2394:	5a7020ef          	jal	513a <sbrk>
  if (p != a) {
    2398:	08a49a63          	bne	s1,a0,242c <sbrkmuch+0xc0>
  *lastaddr = 99;
    239c:	064007b7          	lui	a5,0x6400
    23a0:	06300713          	li	a4,99
    23a4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1347>
  a = sbrk(0);
    23a8:	4501                	li	a0,0
    23aa:	591020ef          	jal	513a <sbrk>
    23ae:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    23b0:	757d                	lui	a0,0xfffff
    23b2:	589020ef          	jal	513a <sbrk>
  if(c == (char*)SBRK_ERROR){
    23b6:	57fd                	li	a5,-1
    23b8:	08f50463          	beq	a0,a5,2440 <sbrkmuch+0xd4>
  c = sbrk(0);
    23bc:	4501                	li	a0,0
    23be:	57d020ef          	jal	513a <sbrk>
  if(c != a - PGSIZE){
    23c2:	80048793          	addi	a5,s1,-2048
    23c6:	80078793          	addi	a5,a5,-2048
    23ca:	08f51563          	bne	a0,a5,2454 <sbrkmuch+0xe8>
  a = sbrk(0);
    23ce:	4501                	li	a0,0
    23d0:	56b020ef          	jal	513a <sbrk>
    23d4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    23d6:	6505                	lui	a0,0x1
    23d8:	563020ef          	jal	513a <sbrk>
    23dc:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    23de:	08a49763          	bne	s1,a0,246c <sbrkmuch+0x100>
    23e2:	4501                	li	a0,0
    23e4:	557020ef          	jal	513a <sbrk>
    23e8:	6785                	lui	a5,0x1
    23ea:	97a6                	add	a5,a5,s1
    23ec:	08f51063          	bne	a0,a5,246c <sbrkmuch+0x100>
  if(*lastaddr == 99){
    23f0:	064007b7          	lui	a5,0x6400
    23f4:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1347>
    23f8:	06300793          	li	a5,99
    23fc:	08f70463          	beq	a4,a5,2484 <sbrkmuch+0x118>
  a = sbrk(0);
    2400:	4501                	li	a0,0
    2402:	539020ef          	jal	513a <sbrk>
    2406:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2408:	4501                	li	a0,0
    240a:	531020ef          	jal	513a <sbrk>
    240e:	40a9053b          	subw	a0,s2,a0
    2412:	529020ef          	jal	513a <sbrk>
  if(c != a){
    2416:	08a49163          	bne	s1,a0,2498 <sbrkmuch+0x12c>
}
    241a:	4501                	li	a0,0
    241c:	70a2                	ld	ra,40(sp)
    241e:	7402                	ld	s0,32(sp)
    2420:	64e2                	ld	s1,24(sp)
    2422:	6942                	ld	s2,16(sp)
    2424:	69a2                	ld	s3,8(sp)
    2426:	6a02                	ld	s4,0(sp)
    2428:	6145                	addi	sp,sp,48
    242a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    242c:	85ce                	mv	a1,s3
    242e:	00004517          	auipc	a0,0x4
    2432:	0ca50513          	addi	a0,a0,202 # 64f8 <malloc+0xe7c>
    2436:	18e030ef          	jal	55c4 <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	533020ef          	jal	516e <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2440:	85ce                	mv	a1,s3
    2442:	00004517          	auipc	a0,0x4
    2446:	0fe50513          	addi	a0,a0,254 # 6540 <malloc+0xec4>
    244a:	17a030ef          	jal	55c4 <printf>
    exit(1);
    244e:	4505                	li	a0,1
    2450:	51f020ef          	jal	516e <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2454:	86aa                	mv	a3,a0
    2456:	8626                	mv	a2,s1
    2458:	85ce                	mv	a1,s3
    245a:	00004517          	auipc	a0,0x4
    245e:	10650513          	addi	a0,a0,262 # 6560 <malloc+0xee4>
    2462:	162030ef          	jal	55c4 <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	507020ef          	jal	516e <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    246c:	86d2                	mv	a3,s4
    246e:	8626                	mv	a2,s1
    2470:	85ce                	mv	a1,s3
    2472:	00004517          	auipc	a0,0x4
    2476:	12e50513          	addi	a0,a0,302 # 65a0 <malloc+0xf24>
    247a:	14a030ef          	jal	55c4 <printf>
    exit(1);
    247e:	4505                	li	a0,1
    2480:	4ef020ef          	jal	516e <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2484:	85ce                	mv	a1,s3
    2486:	00004517          	auipc	a0,0x4
    248a:	14a50513          	addi	a0,a0,330 # 65d0 <malloc+0xf54>
    248e:	136030ef          	jal	55c4 <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	4db020ef          	jal	516e <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2498:	86aa                	mv	a3,a0
    249a:	8626                	mv	a2,s1
    249c:	85ce                	mv	a1,s3
    249e:	00004517          	auipc	a0,0x4
    24a2:	16a50513          	addi	a0,a0,362 # 6608 <malloc+0xf8c>
    24a6:	11e030ef          	jal	55c4 <printf>
    exit(1);
    24aa:	4505                	li	a0,1
    24ac:	4c3020ef          	jal	516e <exit>

00000000000024b0 <sbrkarg>:
{
    24b0:	7179                	addi	sp,sp,-48
    24b2:	f406                	sd	ra,40(sp)
    24b4:	f022                	sd	s0,32(sp)
    24b6:	ec26                	sd	s1,24(sp)
    24b8:	e84a                	sd	s2,16(sp)
    24ba:	e44e                	sd	s3,8(sp)
    24bc:	1800                	addi	s0,sp,48
    24be:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	479020ef          	jal	513a <sbrk>
    24c6:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    24c8:	20100593          	li	a1,513
    24cc:	00004517          	auipc	a0,0x4
    24d0:	16450513          	addi	a0,a0,356 # 6630 <malloc+0xfb4>
    24d4:	4db020ef          	jal	51ae <open>
    24d8:	84aa                	mv	s1,a0
  unlink("sbrk");
    24da:	00004517          	auipc	a0,0x4
    24de:	15650513          	addi	a0,a0,342 # 6630 <malloc+0xfb4>
    24e2:	4dd020ef          	jal	51be <unlink>
  if(fd < 0)  {
    24e6:	0204c963          	bltz	s1,2518 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    24ea:	6605                	lui	a2,0x1
    24ec:	85ca                	mv	a1,s2
    24ee:	8526                	mv	a0,s1
    24f0:	49f020ef          	jal	518e <write>
    24f4:	02054c63          	bltz	a0,252c <sbrkarg+0x7c>
  close(fd);
    24f8:	8526                	mv	a0,s1
    24fa:	49d020ef          	jal	5196 <close>
  a = sbrk(PGSIZE);
    24fe:	6505                	lui	a0,0x1
    2500:	43b020ef          	jal	513a <sbrk>
  if(pipe((int *) a) != 0){
    2504:	47b020ef          	jal	517e <pipe>
    2508:	ed05                	bnez	a0,2540 <sbrkarg+0x90>
}
    250a:	70a2                	ld	ra,40(sp)
    250c:	7402                	ld	s0,32(sp)
    250e:	64e2                	ld	s1,24(sp)
    2510:	6942                	ld	s2,16(sp)
    2512:	69a2                	ld	s3,8(sp)
    2514:	6145                	addi	sp,sp,48
    2516:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2518:	85ce                	mv	a1,s3
    251a:	00004517          	auipc	a0,0x4
    251e:	11e50513          	addi	a0,a0,286 # 6638 <malloc+0xfbc>
    2522:	0a2030ef          	jal	55c4 <printf>
    exit(1);
    2526:	4505                	li	a0,1
    2528:	447020ef          	jal	516e <exit>
    printf("%s: write sbrk failed\n", s);
    252c:	85ce                	mv	a1,s3
    252e:	00004517          	auipc	a0,0x4
    2532:	12250513          	addi	a0,a0,290 # 6650 <malloc+0xfd4>
    2536:	08e030ef          	jal	55c4 <printf>
    exit(1);
    253a:	4505                	li	a0,1
    253c:	433020ef          	jal	516e <exit>
    printf("%s: pipe() failed\n", s);
    2540:	85ce                	mv	a1,s3
    2542:	00004517          	auipc	a0,0x4
    2546:	bfe50513          	addi	a0,a0,-1026 # 6140 <malloc+0xac4>
    254a:	07a030ef          	jal	55c4 <printf>
    exit(1);
    254e:	4505                	li	a0,1
    2550:	41f020ef          	jal	516e <exit>

0000000000002554 <argptest>:
{
    2554:	1101                	addi	sp,sp,-32
    2556:	ec06                	sd	ra,24(sp)
    2558:	e822                	sd	s0,16(sp)
    255a:	e426                	sd	s1,8(sp)
    255c:	e04a                	sd	s2,0(sp)
    255e:	1000                	addi	s0,sp,32
    2560:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2562:	4581                	li	a1,0
    2564:	00004517          	auipc	a0,0x4
    2568:	10450513          	addi	a0,a0,260 # 6668 <malloc+0xfec>
    256c:	443020ef          	jal	51ae <open>
  if (fd < 0) {
    2570:	02054663          	bltz	a0,259c <argptest+0x48>
    2574:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2576:	4501                	li	a0,0
    2578:	3c3020ef          	jal	513a <sbrk>
    257c:	567d                	li	a2,-1
    257e:	00c505b3          	add	a1,a0,a2
    2582:	8526                	mv	a0,s1
    2584:	403020ef          	jal	5186 <read>
  close(fd);
    2588:	8526                	mv	a0,s1
    258a:	40d020ef          	jal	5196 <close>
}
    258e:	4501                	li	a0,0
    2590:	60e2                	ld	ra,24(sp)
    2592:	6442                	ld	s0,16(sp)
    2594:	64a2                	ld	s1,8(sp)
    2596:	6902                	ld	s2,0(sp)
    2598:	6105                	addi	sp,sp,32
    259a:	8082                	ret
    printf("%s: open failed\n", s);
    259c:	85ca                	mv	a1,s2
    259e:	00004517          	auipc	a0,0x4
    25a2:	ab250513          	addi	a0,a0,-1358 # 6050 <malloc+0x9d4>
    25a6:	01e030ef          	jal	55c4 <printf>
    exit(1);
    25aa:	4505                	li	a0,1
    25ac:	3c3020ef          	jal	516e <exit>

00000000000025b0 <sbrkbugs>:
{
    25b0:	1141                	addi	sp,sp,-16
    25b2:	e406                	sd	ra,8(sp)
    25b4:	e022                	sd	s0,0(sp)
    25b6:	0800                	addi	s0,sp,16
  int pid = fork();
    25b8:	3af020ef          	jal	5166 <fork>
  if(pid < 0){
    25bc:	02054b63          	bltz	a0,25f2 <sbrkbugs+0x42>
  if(pid == 0){
    25c0:	c131                	beqz	a0,2604 <sbrkbugs+0x54>
  wait(0);
    25c2:	4501                	li	a0,0
    25c4:	3b3020ef          	jal	5176 <wait>
  pid = fork();
    25c8:	39f020ef          	jal	5166 <fork>
  if(pid < 0){
    25cc:	04054563          	bltz	a0,2616 <sbrkbugs+0x66>
  if(pid == 0){
    25d0:	cd21                	beqz	a0,2628 <sbrkbugs+0x78>
  wait(0);
    25d2:	4501                	li	a0,0
    25d4:	3a3020ef          	jal	5176 <wait>
  pid = fork();
    25d8:	38f020ef          	jal	5166 <fork>
  if(pid < 0){
    25dc:	06054263          	bltz	a0,2640 <sbrkbugs+0x90>
  if(pid == 0){
    25e0:	c92d                	beqz	a0,2652 <sbrkbugs+0xa2>
  wait(0);
    25e2:	4501                	li	a0,0
    25e4:	393020ef          	jal	5176 <wait>
}
    25e8:	4501                	li	a0,0
    25ea:	60a2                	ld	ra,8(sp)
    25ec:	6402                	ld	s0,0(sp)
    25ee:	0141                	addi	sp,sp,16
    25f0:	8082                	ret
    printf("fork failed\n");
    25f2:	00005517          	auipc	a0,0x5
    25f6:	fee50513          	addi	a0,a0,-18 # 75e0 <malloc+0x1f64>
    25fa:	7cb020ef          	jal	55c4 <printf>
    exit(1);
    25fe:	4505                	li	a0,1
    2600:	36f020ef          	jal	516e <exit>
    int sz = (uint64) sbrk(0);
    2604:	337020ef          	jal	513a <sbrk>
    sbrk(-sz);
    2608:	40a0053b          	negw	a0,a0
    260c:	32f020ef          	jal	513a <sbrk>
    exit(0);
    2610:	4501                	li	a0,0
    2612:	35d020ef          	jal	516e <exit>
    printf("fork failed\n");
    2616:	00005517          	auipc	a0,0x5
    261a:	fca50513          	addi	a0,a0,-54 # 75e0 <malloc+0x1f64>
    261e:	7a7020ef          	jal	55c4 <printf>
    exit(1);
    2622:	4505                	li	a0,1
    2624:	34b020ef          	jal	516e <exit>
    int sz = (uint64) sbrk(0);
    2628:	313020ef          	jal	513a <sbrk>
    sbrk(-(sz - 3500));
    262c:	6785                	lui	a5,0x1
    262e:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xb8>
    2632:	40a7853b          	subw	a0,a5,a0
    2636:	305020ef          	jal	513a <sbrk>
    exit(0);
    263a:	4501                	li	a0,0
    263c:	333020ef          	jal	516e <exit>
    printf("fork failed\n");
    2640:	00005517          	auipc	a0,0x5
    2644:	fa050513          	addi	a0,a0,-96 # 75e0 <malloc+0x1f64>
    2648:	77d020ef          	jal	55c4 <printf>
    exit(1);
    264c:	4505                	li	a0,1
    264e:	321020ef          	jal	516e <exit>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    2652:	2e9020ef          	jal	513a <sbrk>
    2656:	67ad                	lui	a5,0xb
    2658:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1258>
    265c:	40a7853b          	subw	a0,a5,a0
    2660:	2db020ef          	jal	513a <sbrk>
    sbrk(-10);
    2664:	5559                	li	a0,-10
    2666:	2d5020ef          	jal	513a <sbrk>
    exit(0);
    266a:	4501                	li	a0,0
    266c:	303020ef          	jal	516e <exit>

0000000000002670 <sbrklast>:
{
    2670:	7179                	addi	sp,sp,-48
    2672:	f406                	sd	ra,40(sp)
    2674:	f022                	sd	s0,32(sp)
    2676:	ec26                	sd	s1,24(sp)
    2678:	e84a                	sd	s2,16(sp)
    267a:	e44e                	sd	s3,8(sp)
    267c:	e052                	sd	s4,0(sp)
    267e:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2680:	4501                	li	a0,0
    2682:	2b9020ef          	jal	513a <sbrk>
  if((top % PGSIZE) != 0)
    2686:	03451793          	slli	a5,a0,0x34
    268a:	ebb5                	bnez	a5,26fe <sbrklast+0x8e>
  sbrk(PGSIZE);
    268c:	6505                	lui	a0,0x1
    268e:	2ad020ef          	jal	513a <sbrk>
  sbrk(10);
    2692:	4529                	li	a0,10
    2694:	2a7020ef          	jal	513a <sbrk>
  sbrk(-20);
    2698:	5531                	li	a0,-20
    269a:	2a1020ef          	jal	513a <sbrk>
  top = (uint64) sbrk(0);
    269e:	4501                	li	a0,0
    26a0:	29b020ef          	jal	513a <sbrk>
    26a4:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    26a6:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x9e>
  p[0] = 'x';
    26aa:	07800993          	li	s3,120
    26ae:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    26b2:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    26b6:	20200593          	li	a1,514
    26ba:	854a                	mv	a0,s2
    26bc:	2f3020ef          	jal	51ae <open>
    26c0:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    26c2:	4605                	li	a2,1
    26c4:	85ca                	mv	a1,s2
    26c6:	2c9020ef          	jal	518e <write>
  close(fd);
    26ca:	8552                	mv	a0,s4
    26cc:	2cb020ef          	jal	5196 <close>
  fd = open(p, O_RDWR);
    26d0:	4589                	li	a1,2
    26d2:	854a                	mv	a0,s2
    26d4:	2db020ef          	jal	51ae <open>
  p[0] = '\0';
    26d8:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    26dc:	4605                	li	a2,1
    26de:	85ca                	mv	a1,s2
    26e0:	2a7020ef          	jal	5186 <read>
  if(p[0] != 'x')
    26e4:	fc04c783          	lbu	a5,-64(s1)
    26e8:	03379363          	bne	a5,s3,270e <sbrklast+0x9e>
}
    26ec:	4501                	li	a0,0
    26ee:	70a2                	ld	ra,40(sp)
    26f0:	7402                	ld	s0,32(sp)
    26f2:	64e2                	ld	s1,24(sp)
    26f4:	6942                	ld	s2,16(sp)
    26f6:	69a2                	ld	s3,8(sp)
    26f8:	6a02                	ld	s4,0(sp)
    26fa:	6145                	addi	sp,sp,48
    26fc:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26fe:	0347d513          	srli	a0,a5,0x34
    2702:	6785                	lui	a5,0x1
    2704:	40a7853b          	subw	a0,a5,a0
    2708:	233020ef          	jal	513a <sbrk>
    270c:	b741                	j	268c <sbrklast+0x1c>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	25f020ef          	jal	516e <exit>

0000000000002714 <sbrk8000>:
{
    2714:	1141                	addi	sp,sp,-16
    2716:	e406                	sd	ra,8(sp)
    2718:	e022                	sd	s0,0(sp)
    271a:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    271c:	80000537          	lui	a0,0x80000
    2720:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff134c>
    2722:	219020ef          	jal	513a <sbrk>
  volatile char *top = sbrk(0);
    2726:	4501                	li	a0,0
    2728:	213020ef          	jal	513a <sbrk>
  *(top-1) = *(top-1) + 1;
    272c:	fff54783          	lbu	a5,-1(a0)
    2730:	0785                	addi	a5,a5,1 # 1001 <bigdir+0xdf>
    2732:	0ff7f793          	zext.b	a5,a5
    2736:	fef50fa3          	sb	a5,-1(a0)
}
    273a:	4501                	li	a0,0
    273c:	60a2                	ld	ra,8(sp)
    273e:	6402                	ld	s0,0(sp)
    2740:	0141                	addi	sp,sp,16
    2742:	8082                	ret

0000000000002744 <execout>:
{
    2744:	715d                	addi	sp,sp,-80
    2746:	e486                	sd	ra,72(sp)
    2748:	e0a2                	sd	s0,64(sp)
    274a:	fc26                	sd	s1,56(sp)
    274c:	f84a                	sd	s2,48(sp)
    274e:	f44e                	sd	s3,40(sp)
    2750:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2752:	4901                	li	s2,0
    2754:	49bd                	li	s3,15
    int pid = fork();
    2756:	211020ef          	jal	5166 <fork>
    275a:	84aa                	mv	s1,a0
    if(pid < 0){
    275c:	02054163          	bltz	a0,277e <execout+0x3a>
    } else if(pid == 0){
    2760:	c905                	beqz	a0,2790 <execout+0x4c>
      wait((int*)0);
    2762:	4501                	li	a0,0
    2764:	213020ef          	jal	5176 <wait>
  for(int avail = 0; avail < 15; avail++){
    2768:	2905                	addiw	s2,s2,1
    276a:	ff3916e3          	bne	s2,s3,2756 <execout+0x12>
}
    276e:	4501                	li	a0,0
    2770:	60a6                	ld	ra,72(sp)
    2772:	6406                	ld	s0,64(sp)
    2774:	74e2                	ld	s1,56(sp)
    2776:	7942                	ld	s2,48(sp)
    2778:	79a2                	ld	s3,40(sp)
    277a:	6161                	addi	sp,sp,80
    277c:	8082                	ret
      printf("fork failed\n");
    277e:	00005517          	auipc	a0,0x5
    2782:	e6250513          	addi	a0,a0,-414 # 75e0 <malloc+0x1f64>
    2786:	63f020ef          	jal	55c4 <printf>
      exit(1);
    278a:	4505                	li	a0,1
    278c:	1e3020ef          	jal	516e <exit>
        char *a = sbrk(PGSIZE);
    2790:	6985                	lui	s3,0x1
    2792:	854e                	mv	a0,s3
    2794:	1a7020ef          	jal	513a <sbrk>
        if(a == SBRK_ERROR)
    2798:	57fd                	li	a5,-1
    279a:	00f50763          	beq	a0,a5,27a8 <execout+0x64>
        *(a + PGSIZE - 1) = 1;
    279e:	954e                	add	a0,a0,s3
    27a0:	4785                	li	a5,1
    27a2:	fef50fa3          	sb	a5,-1(a0)
      while(1){
    27a6:	b7f5                	j	2792 <execout+0x4e>
        sbrk(-PGSIZE);
    27a8:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    27aa:	01205863          	blez	s2,27ba <execout+0x76>
        sbrk(-PGSIZE);
    27ae:	854e                	mv	a0,s3
    27b0:	18b020ef          	jal	513a <sbrk>
      for(int i = 0; i < avail; i++)
    27b4:	2485                	addiw	s1,s1,1
    27b6:	ff249ce3          	bne	s1,s2,27ae <execout+0x6a>
      close(1);
    27ba:	4505                	li	a0,1
    27bc:	1db020ef          	jal	5196 <close>
      char *args[] = { "echo", "x", 0 };
    27c0:	00003797          	auipc	a5,0x3
    27c4:	fe878793          	addi	a5,a5,-24 # 57a8 <malloc+0x12c>
    27c8:	faf43c23          	sd	a5,-72(s0)
    27cc:	00003797          	auipc	a5,0x3
    27d0:	04c78793          	addi	a5,a5,76 # 5818 <malloc+0x19c>
    27d4:	fcf43023          	sd	a5,-64(s0)
    27d8:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    27dc:	fb840593          	addi	a1,s0,-72
    27e0:	00003517          	auipc	a0,0x3
    27e4:	fc850513          	addi	a0,a0,-56 # 57a8 <malloc+0x12c>
    27e8:	1bf020ef          	jal	51a6 <exec>
      exit(0);
    27ec:	4501                	li	a0,0
    27ee:	181020ef          	jal	516e <exit>

00000000000027f2 <fourteen>:
{
    27f2:	1101                	addi	sp,sp,-32
    27f4:	ec06                	sd	ra,24(sp)
    27f6:	e822                	sd	s0,16(sp)
    27f8:	e426                	sd	s1,8(sp)
    27fa:	1000                	addi	s0,sp,32
    27fc:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27fe:	00004517          	auipc	a0,0x4
    2802:	04250513          	addi	a0,a0,66 # 6840 <malloc+0x11c4>
    2806:	1d1020ef          	jal	51d6 <mkdir>
    280a:	e55d                	bnez	a0,28b8 <fourteen+0xc6>
  if(mkdir("12345678901234/123456789012345") != 0){
    280c:	00004517          	auipc	a0,0x4
    2810:	e8c50513          	addi	a0,a0,-372 # 6698 <malloc+0x101c>
    2814:	1c3020ef          	jal	51d6 <mkdir>
    2818:	e955                	bnez	a0,28cc <fourteen+0xda>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    281a:	20000593          	li	a1,512
    281e:	00004517          	auipc	a0,0x4
    2822:	ed250513          	addi	a0,a0,-302 # 66f0 <malloc+0x1074>
    2826:	189020ef          	jal	51ae <open>
  if(fd < 0){
    282a:	0a054b63          	bltz	a0,28e0 <fourteen+0xee>
  close(fd);
    282e:	169020ef          	jal	5196 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2832:	4581                	li	a1,0
    2834:	00004517          	auipc	a0,0x4
    2838:	f3450513          	addi	a0,a0,-204 # 6768 <malloc+0x10ec>
    283c:	173020ef          	jal	51ae <open>
  if(fd < 0){
    2840:	0a054a63          	bltz	a0,28f4 <fourteen+0x102>
  close(fd);
    2844:	153020ef          	jal	5196 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2848:	00004517          	auipc	a0,0x4
    284c:	f9050513          	addi	a0,a0,-112 # 67d8 <malloc+0x115c>
    2850:	187020ef          	jal	51d6 <mkdir>
    2854:	c955                	beqz	a0,2908 <fourteen+0x116>
  if(mkdir("123456789012345/12345678901234") == 0){
    2856:	00004517          	auipc	a0,0x4
    285a:	fda50513          	addi	a0,a0,-38 # 6830 <malloc+0x11b4>
    285e:	179020ef          	jal	51d6 <mkdir>
    2862:	cd4d                	beqz	a0,291c <fourteen+0x12a>
  unlink("123456789012345/12345678901234");
    2864:	00004517          	auipc	a0,0x4
    2868:	fcc50513          	addi	a0,a0,-52 # 6830 <malloc+0x11b4>
    286c:	153020ef          	jal	51be <unlink>
  unlink("12345678901234/12345678901234");
    2870:	00004517          	auipc	a0,0x4
    2874:	f6850513          	addi	a0,a0,-152 # 67d8 <malloc+0x115c>
    2878:	147020ef          	jal	51be <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    287c:	00004517          	auipc	a0,0x4
    2880:	eec50513          	addi	a0,a0,-276 # 6768 <malloc+0x10ec>
    2884:	13b020ef          	jal	51be <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2888:	00004517          	auipc	a0,0x4
    288c:	e6850513          	addi	a0,a0,-408 # 66f0 <malloc+0x1074>
    2890:	12f020ef          	jal	51be <unlink>
  unlink("12345678901234/123456789012345");
    2894:	00004517          	auipc	a0,0x4
    2898:	e0450513          	addi	a0,a0,-508 # 6698 <malloc+0x101c>
    289c:	123020ef          	jal	51be <unlink>
  unlink("12345678901234");
    28a0:	00004517          	auipc	a0,0x4
    28a4:	fa050513          	addi	a0,a0,-96 # 6840 <malloc+0x11c4>
    28a8:	117020ef          	jal	51be <unlink>
}
    28ac:	4501                	li	a0,0
    28ae:	60e2                	ld	ra,24(sp)
    28b0:	6442                	ld	s0,16(sp)
    28b2:	64a2                	ld	s1,8(sp)
    28b4:	6105                	addi	sp,sp,32
    28b6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    28b8:	85a6                	mv	a1,s1
    28ba:	00004517          	auipc	a0,0x4
    28be:	db650513          	addi	a0,a0,-586 # 6670 <malloc+0xff4>
    28c2:	503020ef          	jal	55c4 <printf>
    exit(1);
    28c6:	4505                	li	a0,1
    28c8:	0a7020ef          	jal	516e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    28cc:	85a6                	mv	a1,s1
    28ce:	00004517          	auipc	a0,0x4
    28d2:	dea50513          	addi	a0,a0,-534 # 66b8 <malloc+0x103c>
    28d6:	4ef020ef          	jal	55c4 <printf>
    exit(1);
    28da:	4505                	li	a0,1
    28dc:	093020ef          	jal	516e <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    28e0:	85a6                	mv	a1,s1
    28e2:	00004517          	auipc	a0,0x4
    28e6:	e3e50513          	addi	a0,a0,-450 # 6720 <malloc+0x10a4>
    28ea:	4db020ef          	jal	55c4 <printf>
    exit(1);
    28ee:	4505                	li	a0,1
    28f0:	07f020ef          	jal	516e <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    28f4:	85a6                	mv	a1,s1
    28f6:	00004517          	auipc	a0,0x4
    28fa:	ea250513          	addi	a0,a0,-350 # 6798 <malloc+0x111c>
    28fe:	4c7020ef          	jal	55c4 <printf>
    exit(1);
    2902:	4505                	li	a0,1
    2904:	06b020ef          	jal	516e <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2908:	85a6                	mv	a1,s1
    290a:	00004517          	auipc	a0,0x4
    290e:	eee50513          	addi	a0,a0,-274 # 67f8 <malloc+0x117c>
    2912:	4b3020ef          	jal	55c4 <printf>
    exit(1);
    2916:	4505                	li	a0,1
    2918:	057020ef          	jal	516e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    291c:	85a6                	mv	a1,s1
    291e:	00004517          	auipc	a0,0x4
    2922:	f3250513          	addi	a0,a0,-206 # 6850 <malloc+0x11d4>
    2926:	49f020ef          	jal	55c4 <printf>
    exit(1);
    292a:	4505                	li	a0,1
    292c:	043020ef          	jal	516e <exit>

0000000000002930 <diskfull>:
{
    2930:	b6010113          	addi	sp,sp,-1184
    2934:	48113c23          	sd	ra,1176(sp)
    2938:	48813823          	sd	s0,1168(sp)
    293c:	48913423          	sd	s1,1160(sp)
    2940:	49213023          	sd	s2,1152(sp)
    2944:	47313c23          	sd	s3,1144(sp)
    2948:	47413823          	sd	s4,1136(sp)
    294c:	47513423          	sd	s5,1128(sp)
    2950:	47613023          	sd	s6,1120(sp)
    2954:	45713c23          	sd	s7,1112(sp)
    2958:	45813823          	sd	s8,1104(sp)
    295c:	45913423          	sd	s9,1096(sp)
    2960:	45a13023          	sd	s10,1088(sp)
    2964:	43b13c23          	sd	s11,1080(sp)
    2968:	4a010413          	addi	s0,sp,1184
    296c:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2970:	00004517          	auipc	a0,0x4
    2974:	f1850513          	addi	a0,a0,-232 # 6888 <malloc+0x120c>
    2978:	047020ef          	jal	51be <unlink>
    297c:	03000a93          	li	s5,48
    name[0] = 'b';
    2980:	06200d13          	li	s10,98
    name[1] = 'i';
    2984:	06900c93          	li	s9,105
    name[2] = 'g';
    2988:	06700c13          	li	s8,103
    unlink(name);
    298c:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2990:	60200b93          	li	s7,1538
    2994:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    2998:	b9040a13          	addi	s4,s0,-1136
    299c:	aa95                	j	2b10 <diskfull+0x1e0>
      printf("%s: could not create file %s\n", s, name);
    299e:	b7040613          	addi	a2,s0,-1168
    29a2:	b6843583          	ld	a1,-1176(s0)
    29a6:	00004517          	auipc	a0,0x4
    29aa:	ef250513          	addi	a0,a0,-270 # 6898 <malloc+0x121c>
    29ae:	417020ef          	jal	55c4 <printf>
      break;
    29b2:	a039                	j	29c0 <diskfull+0x90>
        close(fd);
    29b4:	854e                	mv	a0,s3
    29b6:	7e0020ef          	jal	5196 <close>
    close(fd);
    29ba:	854e                	mv	a0,s3
    29bc:	7da020ef          	jal	5196 <close>
  for(int i = 0; i < nzz; i++){
    29c0:	4481                	li	s1,0
    name[0] = 'z';
    29c2:	07a00993          	li	s3,122
    unlink(name);
    29c6:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29ca:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    29ce:	08000a93          	li	s5,128
    name[0] = 'z';
    29d2:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    29d6:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    29da:	41f4d71b          	sraiw	a4,s1,0x1f
    29de:	01b7571b          	srliw	a4,a4,0x1b
    29e2:	009707bb          	addw	a5,a4,s1
    29e6:	4057d69b          	sraiw	a3,a5,0x5
    29ea:	0306869b          	addiw	a3,a3,48
    29ee:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    29f2:	8bfd                	andi	a5,a5,31
    29f4:	9f99                	subw	a5,a5,a4
    29f6:	0307879b          	addiw	a5,a5,48
    29fa:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29fe:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a02:	854a                	mv	a0,s2
    2a04:	7ba020ef          	jal	51be <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2a08:	85d2                	mv	a1,s4
    2a0a:	854a                	mv	a0,s2
    2a0c:	7a2020ef          	jal	51ae <open>
    if(fd < 0)
    2a10:	00054763          	bltz	a0,2a1e <diskfull+0xee>
    close(fd);
    2a14:	782020ef          	jal	5196 <close>
  for(int i = 0; i < nzz; i++){
    2a18:	2485                	addiw	s1,s1,1
    2a1a:	fb549ce3          	bne	s1,s5,29d2 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    2a1e:	00004517          	auipc	a0,0x4
    2a22:	e6a50513          	addi	a0,a0,-406 # 6888 <malloc+0x120c>
    2a26:	7b0020ef          	jal	51d6 <mkdir>
    2a2a:	12050463          	beqz	a0,2b52 <diskfull+0x222>
  unlink("diskfulldir");
    2a2e:	00004517          	auipc	a0,0x4
    2a32:	e5a50513          	addi	a0,a0,-422 # 6888 <malloc+0x120c>
    2a36:	788020ef          	jal	51be <unlink>
  for(int i = 0; i < nzz; i++){
    2a3a:	4481                	li	s1,0
    name[0] = 'z';
    2a3c:	07a00913          	li	s2,122
    unlink(name);
    2a40:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    2a44:	08000993          	li	s3,128
    name[0] = 'z';
    2a48:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2a4c:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2a50:	41f4d71b          	sraiw	a4,s1,0x1f
    2a54:	01b7571b          	srliw	a4,a4,0x1b
    2a58:	009707bb          	addw	a5,a4,s1
    2a5c:	4057d69b          	sraiw	a3,a5,0x5
    2a60:	0306869b          	addiw	a3,a3,48
    2a64:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a68:	8bfd                	andi	a5,a5,31
    2a6a:	9f99                	subw	a5,a5,a4
    2a6c:	0307879b          	addiw	a5,a5,48
    2a70:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a74:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a78:	8552                	mv	a0,s4
    2a7a:	744020ef          	jal	51be <unlink>
  for(int i = 0; i < nzz; i++){
    2a7e:	2485                	addiw	s1,s1,1
    2a80:	fd3494e3          	bne	s1,s3,2a48 <diskfull+0x118>
    2a84:	03000493          	li	s1,48
    name[0] = 'b';
    2a88:	06200b13          	li	s6,98
    name[1] = 'i';
    2a8c:	06900a93          	li	s5,105
    name[2] = 'g';
    2a90:	06700a13          	li	s4,103
    unlink(name);
    2a94:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a98:	07f00913          	li	s2,127
    name[0] = 'b';
    2a9c:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2aa0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2aa4:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2aa8:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2aac:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2ab0:	854e                	mv	a0,s3
    2ab2:	70c020ef          	jal	51be <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2ab6:	2485                	addiw	s1,s1,1
    2ab8:	0ff4f493          	zext.b	s1,s1
    2abc:	ff2490e3          	bne	s1,s2,2a9c <diskfull+0x16c>
}
    2ac0:	4501                	li	a0,0
    2ac2:	49813083          	ld	ra,1176(sp)
    2ac6:	49013403          	ld	s0,1168(sp)
    2aca:	48813483          	ld	s1,1160(sp)
    2ace:	48013903          	ld	s2,1152(sp)
    2ad2:	47813983          	ld	s3,1144(sp)
    2ad6:	47013a03          	ld	s4,1136(sp)
    2ada:	46813a83          	ld	s5,1128(sp)
    2ade:	46013b03          	ld	s6,1120(sp)
    2ae2:	45813b83          	ld	s7,1112(sp)
    2ae6:	45013c03          	ld	s8,1104(sp)
    2aea:	44813c83          	ld	s9,1096(sp)
    2aee:	44013d03          	ld	s10,1088(sp)
    2af2:	43813d83          	ld	s11,1080(sp)
    2af6:	4a010113          	addi	sp,sp,1184
    2afa:	8082                	ret
    close(fd);
    2afc:	854e                	mv	a0,s3
    2afe:	698020ef          	jal	5196 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2b02:	2a85                	addiw	s5,s5,1
    2b04:	0ffafa93          	zext.b	s5,s5
    2b08:	07f00793          	li	a5,127
    2b0c:	eafa8ae3          	beq	s5,a5,29c0 <diskfull+0x90>
    name[0] = 'b';
    2b10:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2b14:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2b18:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2b1c:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2b20:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2b24:	855a                	mv	a0,s6
    2b26:	698020ef          	jal	51be <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2b2a:	85de                	mv	a1,s7
    2b2c:	855a                	mv	a0,s6
    2b2e:	680020ef          	jal	51ae <open>
    2b32:	89aa                	mv	s3,a0
    if(fd < 0){
    2b34:	e60545e3          	bltz	a0,299e <diskfull+0x6e>
    2b38:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    2b3a:	40000913          	li	s2,1024
    2b3e:	864a                	mv	a2,s2
    2b40:	85d2                	mv	a1,s4
    2b42:	854e                	mv	a0,s3
    2b44:	64a020ef          	jal	518e <write>
    2b48:	e72516e3          	bne	a0,s2,29b4 <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    2b4c:	34fd                	addiw	s1,s1,-1
    2b4e:	f8e5                	bnez	s1,2b3e <diskfull+0x20e>
    2b50:	b775                	j	2afc <diskfull+0x1cc>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2b52:	b6843583          	ld	a1,-1176(s0)
    2b56:	00004517          	auipc	a0,0x4
    2b5a:	d6250513          	addi	a0,a0,-670 # 68b8 <malloc+0x123c>
    2b5e:	267020ef          	jal	55c4 <printf>
    2b62:	b5f1                	j	2a2e <diskfull+0xfe>

0000000000002b64 <iputtest>:
{
    2b64:	1101                	addi	sp,sp,-32
    2b66:	ec06                	sd	ra,24(sp)
    2b68:	e822                	sd	s0,16(sp)
    2b6a:	e426                	sd	s1,8(sp)
    2b6c:	1000                	addi	s0,sp,32
    2b6e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b70:	00004517          	auipc	a0,0x4
    2b74:	d7850513          	addi	a0,a0,-648 # 68e8 <malloc+0x126c>
    2b78:	65e020ef          	jal	51d6 <mkdir>
    2b7c:	04054063          	bltz	a0,2bbc <iputtest+0x58>
  if(chdir("iputdir") < 0){
    2b80:	00004517          	auipc	a0,0x4
    2b84:	d6850513          	addi	a0,a0,-664 # 68e8 <malloc+0x126c>
    2b88:	656020ef          	jal	51de <chdir>
    2b8c:	04054263          	bltz	a0,2bd0 <iputtest+0x6c>
  if(unlink("../iputdir") < 0){
    2b90:	00004517          	auipc	a0,0x4
    2b94:	d9850513          	addi	a0,a0,-616 # 6928 <malloc+0x12ac>
    2b98:	626020ef          	jal	51be <unlink>
    2b9c:	04054463          	bltz	a0,2be4 <iputtest+0x80>
  if(chdir("/") < 0){
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	db850513          	addi	a0,a0,-584 # 6958 <malloc+0x12dc>
    2ba8:	636020ef          	jal	51de <chdir>
    2bac:	04054663          	bltz	a0,2bf8 <iputtest+0x94>
}
    2bb0:	4501                	li	a0,0
    2bb2:	60e2                	ld	ra,24(sp)
    2bb4:	6442                	ld	s0,16(sp)
    2bb6:	64a2                	ld	s1,8(sp)
    2bb8:	6105                	addi	sp,sp,32
    2bba:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2bbc:	85a6                	mv	a1,s1
    2bbe:	00004517          	auipc	a0,0x4
    2bc2:	d3250513          	addi	a0,a0,-718 # 68f0 <malloc+0x1274>
    2bc6:	1ff020ef          	jal	55c4 <printf>
    exit(1);
    2bca:	4505                	li	a0,1
    2bcc:	5a2020ef          	jal	516e <exit>
    printf("%s: chdir iputdir failed\n", s);
    2bd0:	85a6                	mv	a1,s1
    2bd2:	00004517          	auipc	a0,0x4
    2bd6:	d3650513          	addi	a0,a0,-714 # 6908 <malloc+0x128c>
    2bda:	1eb020ef          	jal	55c4 <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	58e020ef          	jal	516e <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2be4:	85a6                	mv	a1,s1
    2be6:	00004517          	auipc	a0,0x4
    2bea:	d5250513          	addi	a0,a0,-686 # 6938 <malloc+0x12bc>
    2bee:	1d7020ef          	jal	55c4 <printf>
    exit(1);
    2bf2:	4505                	li	a0,1
    2bf4:	57a020ef          	jal	516e <exit>
    printf("%s: chdir / failed\n", s);
    2bf8:	85a6                	mv	a1,s1
    2bfa:	00004517          	auipc	a0,0x4
    2bfe:	d6650513          	addi	a0,a0,-666 # 6960 <malloc+0x12e4>
    2c02:	1c3020ef          	jal	55c4 <printf>
    exit(1);
    2c06:	4505                	li	a0,1
    2c08:	566020ef          	jal	516e <exit>

0000000000002c0c <exitiputtest>:
{
    2c0c:	7179                	addi	sp,sp,-48
    2c0e:	f406                	sd	ra,40(sp)
    2c10:	f022                	sd	s0,32(sp)
    2c12:	ec26                	sd	s1,24(sp)
    2c14:	1800                	addi	s0,sp,48
    2c16:	84aa                	mv	s1,a0
  pid = fork();
    2c18:	54e020ef          	jal	5166 <fork>
  if(pid < 0){
    2c1c:	02054e63          	bltz	a0,2c58 <exitiputtest+0x4c>
  if(pid == 0){
    2c20:	e541                	bnez	a0,2ca8 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2c22:	00004517          	auipc	a0,0x4
    2c26:	cc650513          	addi	a0,a0,-826 # 68e8 <malloc+0x126c>
    2c2a:	5ac020ef          	jal	51d6 <mkdir>
    2c2e:	02054f63          	bltz	a0,2c6c <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2c32:	00004517          	auipc	a0,0x4
    2c36:	cb650513          	addi	a0,a0,-842 # 68e8 <malloc+0x126c>
    2c3a:	5a4020ef          	jal	51de <chdir>
    2c3e:	04054163          	bltz	a0,2c80 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2c42:	00004517          	auipc	a0,0x4
    2c46:	ce650513          	addi	a0,a0,-794 # 6928 <malloc+0x12ac>
    2c4a:	574020ef          	jal	51be <unlink>
    2c4e:	04054363          	bltz	a0,2c94 <exitiputtest+0x88>
    exit(0);
    2c52:	4501                	li	a0,0
    2c54:	51a020ef          	jal	516e <exit>
    printf("%s: fork failed\n", s);
    2c58:	85a6                	mv	a1,s1
    2c5a:	00003517          	auipc	a0,0x3
    2c5e:	3de50513          	addi	a0,a0,990 # 6038 <malloc+0x9bc>
    2c62:	163020ef          	jal	55c4 <printf>
    exit(1);
    2c66:	4505                	li	a0,1
    2c68:	506020ef          	jal	516e <exit>
      printf("%s: mkdir failed\n", s);
    2c6c:	85a6                	mv	a1,s1
    2c6e:	00004517          	auipc	a0,0x4
    2c72:	c8250513          	addi	a0,a0,-894 # 68f0 <malloc+0x1274>
    2c76:	14f020ef          	jal	55c4 <printf>
      exit(1);
    2c7a:	4505                	li	a0,1
    2c7c:	4f2020ef          	jal	516e <exit>
      printf("%s: child chdir failed\n", s);
    2c80:	85a6                	mv	a1,s1
    2c82:	00004517          	auipc	a0,0x4
    2c86:	cf650513          	addi	a0,a0,-778 # 6978 <malloc+0x12fc>
    2c8a:	13b020ef          	jal	55c4 <printf>
      exit(1);
    2c8e:	4505                	li	a0,1
    2c90:	4de020ef          	jal	516e <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c94:	85a6                	mv	a1,s1
    2c96:	00004517          	auipc	a0,0x4
    2c9a:	ca250513          	addi	a0,a0,-862 # 6938 <malloc+0x12bc>
    2c9e:	127020ef          	jal	55c4 <printf>
      exit(1);
    2ca2:	4505                	li	a0,1
    2ca4:	4ca020ef          	jal	516e <exit>
  wait(&xstatus);
    2ca8:	fdc40513          	addi	a0,s0,-36
    2cac:	4ca020ef          	jal	5176 <wait>
}
    2cb0:	fdc42503          	lw	a0,-36(s0)
    2cb4:	70a2                	ld	ra,40(sp)
    2cb6:	7402                	ld	s0,32(sp)
    2cb8:	64e2                	ld	s1,24(sp)
    2cba:	6145                	addi	sp,sp,48
    2cbc:	8082                	ret

0000000000002cbe <dirtest>:
{
    2cbe:	1101                	addi	sp,sp,-32
    2cc0:	ec06                	sd	ra,24(sp)
    2cc2:	e822                	sd	s0,16(sp)
    2cc4:	e426                	sd	s1,8(sp)
    2cc6:	1000                	addi	s0,sp,32
    2cc8:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2cca:	00004517          	auipc	a0,0x4
    2cce:	cc650513          	addi	a0,a0,-826 # 6990 <malloc+0x1314>
    2cd2:	504020ef          	jal	51d6 <mkdir>
    2cd6:	04054063          	bltz	a0,2d16 <dirtest+0x58>
  if(chdir("dir0") < 0){
    2cda:	00004517          	auipc	a0,0x4
    2cde:	cb650513          	addi	a0,a0,-842 # 6990 <malloc+0x1314>
    2ce2:	4fc020ef          	jal	51de <chdir>
    2ce6:	04054263          	bltz	a0,2d2a <dirtest+0x6c>
  if(chdir("..") < 0){
    2cea:	00004517          	auipc	a0,0x4
    2cee:	cc650513          	addi	a0,a0,-826 # 69b0 <malloc+0x1334>
    2cf2:	4ec020ef          	jal	51de <chdir>
    2cf6:	04054463          	bltz	a0,2d3e <dirtest+0x80>
  if(unlink("dir0") < 0){
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	c9650513          	addi	a0,a0,-874 # 6990 <malloc+0x1314>
    2d02:	4bc020ef          	jal	51be <unlink>
    2d06:	04054663          	bltz	a0,2d52 <dirtest+0x94>
}
    2d0a:	4501                	li	a0,0
    2d0c:	60e2                	ld	ra,24(sp)
    2d0e:	6442                	ld	s0,16(sp)
    2d10:	64a2                	ld	s1,8(sp)
    2d12:	6105                	addi	sp,sp,32
    2d14:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2d16:	85a6                	mv	a1,s1
    2d18:	00004517          	auipc	a0,0x4
    2d1c:	bd850513          	addi	a0,a0,-1064 # 68f0 <malloc+0x1274>
    2d20:	0a5020ef          	jal	55c4 <printf>
    exit(1);
    2d24:	4505                	li	a0,1
    2d26:	448020ef          	jal	516e <exit>
    printf("%s: chdir dir0 failed\n", s);
    2d2a:	85a6                	mv	a1,s1
    2d2c:	00004517          	auipc	a0,0x4
    2d30:	c6c50513          	addi	a0,a0,-916 # 6998 <malloc+0x131c>
    2d34:	091020ef          	jal	55c4 <printf>
    exit(1);
    2d38:	4505                	li	a0,1
    2d3a:	434020ef          	jal	516e <exit>
    printf("%s: chdir .. failed\n", s);
    2d3e:	85a6                	mv	a1,s1
    2d40:	00004517          	auipc	a0,0x4
    2d44:	c7850513          	addi	a0,a0,-904 # 69b8 <malloc+0x133c>
    2d48:	07d020ef          	jal	55c4 <printf>
    exit(1);
    2d4c:	4505                	li	a0,1
    2d4e:	420020ef          	jal	516e <exit>
    printf("%s: unlink dir0 failed\n", s);
    2d52:	85a6                	mv	a1,s1
    2d54:	00004517          	auipc	a0,0x4
    2d58:	c7c50513          	addi	a0,a0,-900 # 69d0 <malloc+0x1354>
    2d5c:	069020ef          	jal	55c4 <printf>
    exit(1);
    2d60:	4505                	li	a0,1
    2d62:	40c020ef          	jal	516e <exit>

0000000000002d66 <subdir>:
{
    2d66:	1101                	addi	sp,sp,-32
    2d68:	ec06                	sd	ra,24(sp)
    2d6a:	e822                	sd	s0,16(sp)
    2d6c:	e426                	sd	s1,8(sp)
    2d6e:	e04a                	sd	s2,0(sp)
    2d70:	1000                	addi	s0,sp,32
    2d72:	892a                	mv	s2,a0
  unlink("ff");
    2d74:	00004517          	auipc	a0,0x4
    2d78:	da450513          	addi	a0,a0,-604 # 6b18 <malloc+0x149c>
    2d7c:	442020ef          	jal	51be <unlink>
  if(mkdir("dd") != 0){
    2d80:	00004517          	auipc	a0,0x4
    2d84:	c6850513          	addi	a0,a0,-920 # 69e8 <malloc+0x136c>
    2d88:	44e020ef          	jal	51d6 <mkdir>
    2d8c:	2e051363          	bnez	a0,3072 <subdir+0x30c>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d90:	20200593          	li	a1,514
    2d94:	00004517          	auipc	a0,0x4
    2d98:	c7450513          	addi	a0,a0,-908 # 6a08 <malloc+0x138c>
    2d9c:	412020ef          	jal	51ae <open>
    2da0:	84aa                	mv	s1,a0
  if(fd < 0){
    2da2:	2e054263          	bltz	a0,3086 <subdir+0x320>
  write(fd, "ff", 2);
    2da6:	4609                	li	a2,2
    2da8:	00004597          	auipc	a1,0x4
    2dac:	d7058593          	addi	a1,a1,-656 # 6b18 <malloc+0x149c>
    2db0:	3de020ef          	jal	518e <write>
  close(fd);
    2db4:	8526                	mv	a0,s1
    2db6:	3e0020ef          	jal	5196 <close>
  if(unlink("dd") >= 0){
    2dba:	00004517          	auipc	a0,0x4
    2dbe:	c2e50513          	addi	a0,a0,-978 # 69e8 <malloc+0x136c>
    2dc2:	3fc020ef          	jal	51be <unlink>
    2dc6:	2c055a63          	bgez	a0,309a <subdir+0x334>
  if(mkdir("/dd/dd") != 0){
    2dca:	00004517          	auipc	a0,0x4
    2dce:	c9650513          	addi	a0,a0,-874 # 6a60 <malloc+0x13e4>
    2dd2:	404020ef          	jal	51d6 <mkdir>
    2dd6:	2c051c63          	bnez	a0,30ae <subdir+0x348>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2dda:	20200593          	li	a1,514
    2dde:	00004517          	auipc	a0,0x4
    2de2:	caa50513          	addi	a0,a0,-854 # 6a88 <malloc+0x140c>
    2de6:	3c8020ef          	jal	51ae <open>
    2dea:	84aa                	mv	s1,a0
  if(fd < 0){
    2dec:	2c054b63          	bltz	a0,30c2 <subdir+0x35c>
  write(fd, "FF", 2);
    2df0:	4609                	li	a2,2
    2df2:	00004597          	auipc	a1,0x4
    2df6:	cc658593          	addi	a1,a1,-826 # 6ab8 <malloc+0x143c>
    2dfa:	394020ef          	jal	518e <write>
  close(fd);
    2dfe:	8526                	mv	a0,s1
    2e00:	396020ef          	jal	5196 <close>
  fd = open("dd/dd/../ff", 0);
    2e04:	4581                	li	a1,0
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	cba50513          	addi	a0,a0,-838 # 6ac0 <malloc+0x1444>
    2e0e:	3a0020ef          	jal	51ae <open>
    2e12:	84aa                	mv	s1,a0
  if(fd < 0){
    2e14:	2c054163          	bltz	a0,30d6 <subdir+0x370>
  cc = read(fd, buf, sizeof(buf));
    2e18:	660d                	lui	a2,0x3
    2e1a:	00009597          	auipc	a1,0x9
    2e1e:	e9e58593          	addi	a1,a1,-354 # bcb8 <buf>
    2e22:	364020ef          	jal	5186 <read>
  if(cc != 2 || buf[0] != 'f'){
    2e26:	4789                	li	a5,2
    2e28:	2cf51163          	bne	a0,a5,30ea <subdir+0x384>
    2e2c:	00009717          	auipc	a4,0x9
    2e30:	e8c74703          	lbu	a4,-372(a4) # bcb8 <buf>
    2e34:	06600793          	li	a5,102
    2e38:	2af71963          	bne	a4,a5,30ea <subdir+0x384>
  close(fd);
    2e3c:	8526                	mv	a0,s1
    2e3e:	358020ef          	jal	5196 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2e42:	00004597          	auipc	a1,0x4
    2e46:	cce58593          	addi	a1,a1,-818 # 6b10 <malloc+0x1494>
    2e4a:	00004517          	auipc	a0,0x4
    2e4e:	c3e50513          	addi	a0,a0,-962 # 6a88 <malloc+0x140c>
    2e52:	37c020ef          	jal	51ce <link>
    2e56:	2a051463          	bnez	a0,30fe <subdir+0x398>
  if(unlink("dd/dd/ff") != 0){
    2e5a:	00004517          	auipc	a0,0x4
    2e5e:	c2e50513          	addi	a0,a0,-978 # 6a88 <malloc+0x140c>
    2e62:	35c020ef          	jal	51be <unlink>
    2e66:	2a051663          	bnez	a0,3112 <subdir+0x3ac>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e6a:	4581                	li	a1,0
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	c1c50513          	addi	a0,a0,-996 # 6a88 <malloc+0x140c>
    2e74:	33a020ef          	jal	51ae <open>
    2e78:	2a055763          	bgez	a0,3126 <subdir+0x3c0>
  if(chdir("dd") != 0){
    2e7c:	00004517          	auipc	a0,0x4
    2e80:	b6c50513          	addi	a0,a0,-1172 # 69e8 <malloc+0x136c>
    2e84:	35a020ef          	jal	51de <chdir>
    2e88:	2a051963          	bnez	a0,313a <subdir+0x3d4>
  if(chdir("dd/../../dd") != 0){
    2e8c:	00004517          	auipc	a0,0x4
    2e90:	d1c50513          	addi	a0,a0,-740 # 6ba8 <malloc+0x152c>
    2e94:	34a020ef          	jal	51de <chdir>
    2e98:	2a051b63          	bnez	a0,314e <subdir+0x3e8>
  if(chdir("dd/../../../dd") != 0){
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	d3c50513          	addi	a0,a0,-708 # 6bd8 <malloc+0x155c>
    2ea4:	33a020ef          	jal	51de <chdir>
    2ea8:	2a051d63          	bnez	a0,3162 <subdir+0x3fc>
  if(chdir("./..") != 0){
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	d6450513          	addi	a0,a0,-668 # 6c10 <malloc+0x1594>
    2eb4:	32a020ef          	jal	51de <chdir>
    2eb8:	2a051f63          	bnez	a0,3176 <subdir+0x410>
  fd = open("dd/dd/ffff", 0);
    2ebc:	4581                	li	a1,0
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	c5250513          	addi	a0,a0,-942 # 6b10 <malloc+0x1494>
    2ec6:	2e8020ef          	jal	51ae <open>
    2eca:	84aa                	mv	s1,a0
  if(fd < 0){
    2ecc:	2a054f63          	bltz	a0,318a <subdir+0x424>
  if(read(fd, buf, sizeof(buf)) != 2){
    2ed0:	660d                	lui	a2,0x3
    2ed2:	00009597          	auipc	a1,0x9
    2ed6:	de658593          	addi	a1,a1,-538 # bcb8 <buf>
    2eda:	2ac020ef          	jal	5186 <read>
    2ede:	4789                	li	a5,2
    2ee0:	2af51f63          	bne	a0,a5,319e <subdir+0x438>
  close(fd);
    2ee4:	8526                	mv	a0,s1
    2ee6:	2b0020ef          	jal	5196 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2eea:	4581                	li	a1,0
    2eec:	00004517          	auipc	a0,0x4
    2ef0:	b9c50513          	addi	a0,a0,-1124 # 6a88 <malloc+0x140c>
    2ef4:	2ba020ef          	jal	51ae <open>
    2ef8:	2a055d63          	bgez	a0,31b2 <subdir+0x44c>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2efc:	20200593          	li	a1,514
    2f00:	00004517          	auipc	a0,0x4
    2f04:	da050513          	addi	a0,a0,-608 # 6ca0 <malloc+0x1624>
    2f08:	2a6020ef          	jal	51ae <open>
    2f0c:	2a055d63          	bgez	a0,31c6 <subdir+0x460>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2f10:	20200593          	li	a1,514
    2f14:	00004517          	auipc	a0,0x4
    2f18:	dbc50513          	addi	a0,a0,-580 # 6cd0 <malloc+0x1654>
    2f1c:	292020ef          	jal	51ae <open>
    2f20:	2a055d63          	bgez	a0,31da <subdir+0x474>
  if(open("dd", O_CREATE) >= 0){
    2f24:	20000593          	li	a1,512
    2f28:	00004517          	auipc	a0,0x4
    2f2c:	ac050513          	addi	a0,a0,-1344 # 69e8 <malloc+0x136c>
    2f30:	27e020ef          	jal	51ae <open>
    2f34:	2a055d63          	bgez	a0,31ee <subdir+0x488>
  if(open("dd", O_RDWR) >= 0){
    2f38:	4589                	li	a1,2
    2f3a:	00004517          	auipc	a0,0x4
    2f3e:	aae50513          	addi	a0,a0,-1362 # 69e8 <malloc+0x136c>
    2f42:	26c020ef          	jal	51ae <open>
    2f46:	2a055e63          	bgez	a0,3202 <subdir+0x49c>
  if(open("dd", O_WRONLY) >= 0){
    2f4a:	4585                	li	a1,1
    2f4c:	00004517          	auipc	a0,0x4
    2f50:	a9c50513          	addi	a0,a0,-1380 # 69e8 <malloc+0x136c>
    2f54:	25a020ef          	jal	51ae <open>
    2f58:	2a055f63          	bgez	a0,3216 <subdir+0x4b0>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f5c:	00004597          	auipc	a1,0x4
    2f60:	e0458593          	addi	a1,a1,-508 # 6d60 <malloc+0x16e4>
    2f64:	00004517          	auipc	a0,0x4
    2f68:	d3c50513          	addi	a0,a0,-708 # 6ca0 <malloc+0x1624>
    2f6c:	262020ef          	jal	51ce <link>
    2f70:	2a050d63          	beqz	a0,322a <subdir+0x4c4>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f74:	00004597          	auipc	a1,0x4
    2f78:	dec58593          	addi	a1,a1,-532 # 6d60 <malloc+0x16e4>
    2f7c:	00004517          	auipc	a0,0x4
    2f80:	d5450513          	addi	a0,a0,-684 # 6cd0 <malloc+0x1654>
    2f84:	24a020ef          	jal	51ce <link>
    2f88:	2a050b63          	beqz	a0,323e <subdir+0x4d8>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f8c:	00004597          	auipc	a1,0x4
    2f90:	b8458593          	addi	a1,a1,-1148 # 6b10 <malloc+0x1494>
    2f94:	00004517          	auipc	a0,0x4
    2f98:	a7450513          	addi	a0,a0,-1420 # 6a08 <malloc+0x138c>
    2f9c:	232020ef          	jal	51ce <link>
    2fa0:	2a050963          	beqz	a0,3252 <subdir+0x4ec>
  if(mkdir("dd/ff/ff") == 0){
    2fa4:	00004517          	auipc	a0,0x4
    2fa8:	cfc50513          	addi	a0,a0,-772 # 6ca0 <malloc+0x1624>
    2fac:	22a020ef          	jal	51d6 <mkdir>
    2fb0:	2a050b63          	beqz	a0,3266 <subdir+0x500>
  if(mkdir("dd/xx/ff") == 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	d1c50513          	addi	a0,a0,-740 # 6cd0 <malloc+0x1654>
    2fbc:	21a020ef          	jal	51d6 <mkdir>
    2fc0:	2a050d63          	beqz	a0,327a <subdir+0x514>
  if(mkdir("dd/dd/ffff") == 0){
    2fc4:	00004517          	auipc	a0,0x4
    2fc8:	b4c50513          	addi	a0,a0,-1204 # 6b10 <malloc+0x1494>
    2fcc:	20a020ef          	jal	51d6 <mkdir>
    2fd0:	2a050f63          	beqz	a0,328e <subdir+0x528>
  if(unlink("dd/xx/ff") == 0){
    2fd4:	00004517          	auipc	a0,0x4
    2fd8:	cfc50513          	addi	a0,a0,-772 # 6cd0 <malloc+0x1654>
    2fdc:	1e2020ef          	jal	51be <unlink>
    2fe0:	2c050163          	beqz	a0,32a2 <subdir+0x53c>
  if(unlink("dd/ff/ff") == 0){
    2fe4:	00004517          	auipc	a0,0x4
    2fe8:	cbc50513          	addi	a0,a0,-836 # 6ca0 <malloc+0x1624>
    2fec:	1d2020ef          	jal	51be <unlink>
    2ff0:	2c050363          	beqz	a0,32b6 <subdir+0x550>
  if(chdir("dd/ff") == 0){
    2ff4:	00004517          	auipc	a0,0x4
    2ff8:	a1450513          	addi	a0,a0,-1516 # 6a08 <malloc+0x138c>
    2ffc:	1e2020ef          	jal	51de <chdir>
    3000:	2c050563          	beqz	a0,32ca <subdir+0x564>
  if(chdir("dd/xx") == 0){
    3004:	00004517          	auipc	a0,0x4
    3008:	eac50513          	addi	a0,a0,-340 # 6eb0 <malloc+0x1834>
    300c:	1d2020ef          	jal	51de <chdir>
    3010:	2c050763          	beqz	a0,32de <subdir+0x578>
  if(unlink("dd/dd/ffff") != 0){
    3014:	00004517          	auipc	a0,0x4
    3018:	afc50513          	addi	a0,a0,-1284 # 6b10 <malloc+0x1494>
    301c:	1a2020ef          	jal	51be <unlink>
    3020:	2c051963          	bnez	a0,32f2 <subdir+0x58c>
  if(unlink("dd/ff") != 0){
    3024:	00004517          	auipc	a0,0x4
    3028:	9e450513          	addi	a0,a0,-1564 # 6a08 <malloc+0x138c>
    302c:	192020ef          	jal	51be <unlink>
    3030:	2c051b63          	bnez	a0,3306 <subdir+0x5a0>
  if(unlink("dd") == 0){
    3034:	00004517          	auipc	a0,0x4
    3038:	9b450513          	addi	a0,a0,-1612 # 69e8 <malloc+0x136c>
    303c:	182020ef          	jal	51be <unlink>
    3040:	2c050d63          	beqz	a0,331a <subdir+0x5b4>
  if(unlink("dd/dd") < 0){
    3044:	00004517          	auipc	a0,0x4
    3048:	edc50513          	addi	a0,a0,-292 # 6f20 <malloc+0x18a4>
    304c:	172020ef          	jal	51be <unlink>
    3050:	2c054f63          	bltz	a0,332e <subdir+0x5c8>
  if(unlink("dd") < 0){
    3054:	00004517          	auipc	a0,0x4
    3058:	99450513          	addi	a0,a0,-1644 # 69e8 <malloc+0x136c>
    305c:	162020ef          	jal	51be <unlink>
    3060:	2e054163          	bltz	a0,3342 <subdir+0x5dc>
}
    3064:	4501                	li	a0,0
    3066:	60e2                	ld	ra,24(sp)
    3068:	6442                	ld	s0,16(sp)
    306a:	64a2                	ld	s1,8(sp)
    306c:	6902                	ld	s2,0(sp)
    306e:	6105                	addi	sp,sp,32
    3070:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3072:	85ca                	mv	a1,s2
    3074:	00004517          	auipc	a0,0x4
    3078:	97c50513          	addi	a0,a0,-1668 # 69f0 <malloc+0x1374>
    307c:	548020ef          	jal	55c4 <printf>
    exit(1);
    3080:	4505                	li	a0,1
    3082:	0ec020ef          	jal	516e <exit>
    printf("%s: create dd/ff failed\n", s);
    3086:	85ca                	mv	a1,s2
    3088:	00004517          	auipc	a0,0x4
    308c:	98850513          	addi	a0,a0,-1656 # 6a10 <malloc+0x1394>
    3090:	534020ef          	jal	55c4 <printf>
    exit(1);
    3094:	4505                	li	a0,1
    3096:	0d8020ef          	jal	516e <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    309a:	85ca                	mv	a1,s2
    309c:	00004517          	auipc	a0,0x4
    30a0:	99450513          	addi	a0,a0,-1644 # 6a30 <malloc+0x13b4>
    30a4:	520020ef          	jal	55c4 <printf>
    exit(1);
    30a8:	4505                	li	a0,1
    30aa:	0c4020ef          	jal	516e <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    30ae:	85ca                	mv	a1,s2
    30b0:	00004517          	auipc	a0,0x4
    30b4:	9b850513          	addi	a0,a0,-1608 # 6a68 <malloc+0x13ec>
    30b8:	50c020ef          	jal	55c4 <printf>
    exit(1);
    30bc:	4505                	li	a0,1
    30be:	0b0020ef          	jal	516e <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    30c2:	85ca                	mv	a1,s2
    30c4:	00004517          	auipc	a0,0x4
    30c8:	9d450513          	addi	a0,a0,-1580 # 6a98 <malloc+0x141c>
    30cc:	4f8020ef          	jal	55c4 <printf>
    exit(1);
    30d0:	4505                	li	a0,1
    30d2:	09c020ef          	jal	516e <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    30d6:	85ca                	mv	a1,s2
    30d8:	00004517          	auipc	a0,0x4
    30dc:	9f850513          	addi	a0,a0,-1544 # 6ad0 <malloc+0x1454>
    30e0:	4e4020ef          	jal	55c4 <printf>
    exit(1);
    30e4:	4505                	li	a0,1
    30e6:	088020ef          	jal	516e <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    30ea:	85ca                	mv	a1,s2
    30ec:	00004517          	auipc	a0,0x4
    30f0:	a0450513          	addi	a0,a0,-1532 # 6af0 <malloc+0x1474>
    30f4:	4d0020ef          	jal	55c4 <printf>
    exit(1);
    30f8:	4505                	li	a0,1
    30fa:	074020ef          	jal	516e <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    30fe:	85ca                	mv	a1,s2
    3100:	00004517          	auipc	a0,0x4
    3104:	a2050513          	addi	a0,a0,-1504 # 6b20 <malloc+0x14a4>
    3108:	4bc020ef          	jal	55c4 <printf>
    exit(1);
    310c:	4505                	li	a0,1
    310e:	060020ef          	jal	516e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3112:	85ca                	mv	a1,s2
    3114:	00004517          	auipc	a0,0x4
    3118:	a3450513          	addi	a0,a0,-1484 # 6b48 <malloc+0x14cc>
    311c:	4a8020ef          	jal	55c4 <printf>
    exit(1);
    3120:	4505                	li	a0,1
    3122:	04c020ef          	jal	516e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3126:	85ca                	mv	a1,s2
    3128:	00004517          	auipc	a0,0x4
    312c:	a4050513          	addi	a0,a0,-1472 # 6b68 <malloc+0x14ec>
    3130:	494020ef          	jal	55c4 <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	038020ef          	jal	516e <exit>
    printf("%s: chdir dd failed\n", s);
    313a:	85ca                	mv	a1,s2
    313c:	00004517          	auipc	a0,0x4
    3140:	a5450513          	addi	a0,a0,-1452 # 6b90 <malloc+0x1514>
    3144:	480020ef          	jal	55c4 <printf>
    exit(1);
    3148:	4505                	li	a0,1
    314a:	024020ef          	jal	516e <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    314e:	85ca                	mv	a1,s2
    3150:	00004517          	auipc	a0,0x4
    3154:	a6850513          	addi	a0,a0,-1432 # 6bb8 <malloc+0x153c>
    3158:	46c020ef          	jal	55c4 <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	010020ef          	jal	516e <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    3162:	85ca                	mv	a1,s2
    3164:	00004517          	auipc	a0,0x4
    3168:	a8450513          	addi	a0,a0,-1404 # 6be8 <malloc+0x156c>
    316c:	458020ef          	jal	55c4 <printf>
    exit(1);
    3170:	4505                	li	a0,1
    3172:	7fd010ef          	jal	516e <exit>
    printf("%s: chdir ./.. failed\n", s);
    3176:	85ca                	mv	a1,s2
    3178:	00004517          	auipc	a0,0x4
    317c:	aa050513          	addi	a0,a0,-1376 # 6c18 <malloc+0x159c>
    3180:	444020ef          	jal	55c4 <printf>
    exit(1);
    3184:	4505                	li	a0,1
    3186:	7e9010ef          	jal	516e <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    318a:	85ca                	mv	a1,s2
    318c:	00004517          	auipc	a0,0x4
    3190:	aa450513          	addi	a0,a0,-1372 # 6c30 <malloc+0x15b4>
    3194:	430020ef          	jal	55c4 <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	7d5010ef          	jal	516e <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    319e:	85ca                	mv	a1,s2
    31a0:	00004517          	auipc	a0,0x4
    31a4:	ab050513          	addi	a0,a0,-1360 # 6c50 <malloc+0x15d4>
    31a8:	41c020ef          	jal	55c4 <printf>
    exit(1);
    31ac:	4505                	li	a0,1
    31ae:	7c1010ef          	jal	516e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    31b2:	85ca                	mv	a1,s2
    31b4:	00004517          	auipc	a0,0x4
    31b8:	abc50513          	addi	a0,a0,-1348 # 6c70 <malloc+0x15f4>
    31bc:	408020ef          	jal	55c4 <printf>
    exit(1);
    31c0:	4505                	li	a0,1
    31c2:	7ad010ef          	jal	516e <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    31c6:	85ca                	mv	a1,s2
    31c8:	00004517          	auipc	a0,0x4
    31cc:	ae850513          	addi	a0,a0,-1304 # 6cb0 <malloc+0x1634>
    31d0:	3f4020ef          	jal	55c4 <printf>
    exit(1);
    31d4:	4505                	li	a0,1
    31d6:	799010ef          	jal	516e <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    31da:	85ca                	mv	a1,s2
    31dc:	00004517          	auipc	a0,0x4
    31e0:	b0450513          	addi	a0,a0,-1276 # 6ce0 <malloc+0x1664>
    31e4:	3e0020ef          	jal	55c4 <printf>
    exit(1);
    31e8:	4505                	li	a0,1
    31ea:	785010ef          	jal	516e <exit>
    printf("%s: create dd succeeded!\n", s);
    31ee:	85ca                	mv	a1,s2
    31f0:	00004517          	auipc	a0,0x4
    31f4:	b1050513          	addi	a0,a0,-1264 # 6d00 <malloc+0x1684>
    31f8:	3cc020ef          	jal	55c4 <printf>
    exit(1);
    31fc:	4505                	li	a0,1
    31fe:	771010ef          	jal	516e <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3202:	85ca                	mv	a1,s2
    3204:	00004517          	auipc	a0,0x4
    3208:	b1c50513          	addi	a0,a0,-1252 # 6d20 <malloc+0x16a4>
    320c:	3b8020ef          	jal	55c4 <printf>
    exit(1);
    3210:	4505                	li	a0,1
    3212:	75d010ef          	jal	516e <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3216:	85ca                	mv	a1,s2
    3218:	00004517          	auipc	a0,0x4
    321c:	b2850513          	addi	a0,a0,-1240 # 6d40 <malloc+0x16c4>
    3220:	3a4020ef          	jal	55c4 <printf>
    exit(1);
    3224:	4505                	li	a0,1
    3226:	749010ef          	jal	516e <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    322a:	85ca                	mv	a1,s2
    322c:	00004517          	auipc	a0,0x4
    3230:	b4450513          	addi	a0,a0,-1212 # 6d70 <malloc+0x16f4>
    3234:	390020ef          	jal	55c4 <printf>
    exit(1);
    3238:	4505                	li	a0,1
    323a:	735010ef          	jal	516e <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    323e:	85ca                	mv	a1,s2
    3240:	00004517          	auipc	a0,0x4
    3244:	b5850513          	addi	a0,a0,-1192 # 6d98 <malloc+0x171c>
    3248:	37c020ef          	jal	55c4 <printf>
    exit(1);
    324c:	4505                	li	a0,1
    324e:	721010ef          	jal	516e <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3252:	85ca                	mv	a1,s2
    3254:	00004517          	auipc	a0,0x4
    3258:	b6c50513          	addi	a0,a0,-1172 # 6dc0 <malloc+0x1744>
    325c:	368020ef          	jal	55c4 <printf>
    exit(1);
    3260:	4505                	li	a0,1
    3262:	70d010ef          	jal	516e <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3266:	85ca                	mv	a1,s2
    3268:	00004517          	auipc	a0,0x4
    326c:	b8050513          	addi	a0,a0,-1152 # 6de8 <malloc+0x176c>
    3270:	354020ef          	jal	55c4 <printf>
    exit(1);
    3274:	4505                	li	a0,1
    3276:	6f9010ef          	jal	516e <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    327a:	85ca                	mv	a1,s2
    327c:	00004517          	auipc	a0,0x4
    3280:	b8c50513          	addi	a0,a0,-1140 # 6e08 <malloc+0x178c>
    3284:	340020ef          	jal	55c4 <printf>
    exit(1);
    3288:	4505                	li	a0,1
    328a:	6e5010ef          	jal	516e <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    328e:	85ca                	mv	a1,s2
    3290:	00004517          	auipc	a0,0x4
    3294:	b9850513          	addi	a0,a0,-1128 # 6e28 <malloc+0x17ac>
    3298:	32c020ef          	jal	55c4 <printf>
    exit(1);
    329c:	4505                	li	a0,1
    329e:	6d1010ef          	jal	516e <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    32a2:	85ca                	mv	a1,s2
    32a4:	00004517          	auipc	a0,0x4
    32a8:	bac50513          	addi	a0,a0,-1108 # 6e50 <malloc+0x17d4>
    32ac:	318020ef          	jal	55c4 <printf>
    exit(1);
    32b0:	4505                	li	a0,1
    32b2:	6bd010ef          	jal	516e <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    32b6:	85ca                	mv	a1,s2
    32b8:	00004517          	auipc	a0,0x4
    32bc:	bb850513          	addi	a0,a0,-1096 # 6e70 <malloc+0x17f4>
    32c0:	304020ef          	jal	55c4 <printf>
    exit(1);
    32c4:	4505                	li	a0,1
    32c6:	6a9010ef          	jal	516e <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    32ca:	85ca                	mv	a1,s2
    32cc:	00004517          	auipc	a0,0x4
    32d0:	bc450513          	addi	a0,a0,-1084 # 6e90 <malloc+0x1814>
    32d4:	2f0020ef          	jal	55c4 <printf>
    exit(1);
    32d8:	4505                	li	a0,1
    32da:	695010ef          	jal	516e <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    32de:	85ca                	mv	a1,s2
    32e0:	00004517          	auipc	a0,0x4
    32e4:	bd850513          	addi	a0,a0,-1064 # 6eb8 <malloc+0x183c>
    32e8:	2dc020ef          	jal	55c4 <printf>
    exit(1);
    32ec:	4505                	li	a0,1
    32ee:	681010ef          	jal	516e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    32f2:	85ca                	mv	a1,s2
    32f4:	00004517          	auipc	a0,0x4
    32f8:	85450513          	addi	a0,a0,-1964 # 6b48 <malloc+0x14cc>
    32fc:	2c8020ef          	jal	55c4 <printf>
    exit(1);
    3300:	4505                	li	a0,1
    3302:	66d010ef          	jal	516e <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3306:	85ca                	mv	a1,s2
    3308:	00004517          	auipc	a0,0x4
    330c:	bd050513          	addi	a0,a0,-1072 # 6ed8 <malloc+0x185c>
    3310:	2b4020ef          	jal	55c4 <printf>
    exit(1);
    3314:	4505                	li	a0,1
    3316:	659010ef          	jal	516e <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    331a:	85ca                	mv	a1,s2
    331c:	00004517          	auipc	a0,0x4
    3320:	bdc50513          	addi	a0,a0,-1060 # 6ef8 <malloc+0x187c>
    3324:	2a0020ef          	jal	55c4 <printf>
    exit(1);
    3328:	4505                	li	a0,1
    332a:	645010ef          	jal	516e <exit>
    printf("%s: unlink dd/dd failed\n", s);
    332e:	85ca                	mv	a1,s2
    3330:	00004517          	auipc	a0,0x4
    3334:	bf850513          	addi	a0,a0,-1032 # 6f28 <malloc+0x18ac>
    3338:	28c020ef          	jal	55c4 <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	631010ef          	jal	516e <exit>
    printf("%s: unlink dd failed\n", s);
    3342:	85ca                	mv	a1,s2
    3344:	00004517          	auipc	a0,0x4
    3348:	c0450513          	addi	a0,a0,-1020 # 6f48 <malloc+0x18cc>
    334c:	278020ef          	jal	55c4 <printf>
    exit(1);
    3350:	4505                	li	a0,1
    3352:	61d010ef          	jal	516e <exit>

0000000000003356 <rmdot>:
{
    3356:	1101                	addi	sp,sp,-32
    3358:	ec06                	sd	ra,24(sp)
    335a:	e822                	sd	s0,16(sp)
    335c:	e426                	sd	s1,8(sp)
    335e:	1000                	addi	s0,sp,32
    3360:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3362:	00004517          	auipc	a0,0x4
    3366:	bfe50513          	addi	a0,a0,-1026 # 6f60 <malloc+0x18e4>
    336a:	66d010ef          	jal	51d6 <mkdir>
    336e:	e53d                	bnez	a0,33dc <rmdot+0x86>
  if(chdir("dots") != 0){
    3370:	00004517          	auipc	a0,0x4
    3374:	bf050513          	addi	a0,a0,-1040 # 6f60 <malloc+0x18e4>
    3378:	667010ef          	jal	51de <chdir>
    337c:	e935                	bnez	a0,33f0 <rmdot+0x9a>
  if(unlink(".") == 0){
    337e:	00003517          	auipc	a0,0x3
    3382:	b1250513          	addi	a0,a0,-1262 # 5e90 <malloc+0x814>
    3386:	639010ef          	jal	51be <unlink>
    338a:	cd2d                	beqz	a0,3404 <rmdot+0xae>
  if(unlink("..") == 0){
    338c:	00003517          	auipc	a0,0x3
    3390:	62450513          	addi	a0,a0,1572 # 69b0 <malloc+0x1334>
    3394:	62b010ef          	jal	51be <unlink>
    3398:	c141                	beqz	a0,3418 <rmdot+0xc2>
  if(chdir("/") != 0){
    339a:	00003517          	auipc	a0,0x3
    339e:	5be50513          	addi	a0,a0,1470 # 6958 <malloc+0x12dc>
    33a2:	63d010ef          	jal	51de <chdir>
    33a6:	e159                	bnez	a0,342c <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    33a8:	00004517          	auipc	a0,0x4
    33ac:	c2050513          	addi	a0,a0,-992 # 6fc8 <malloc+0x194c>
    33b0:	60f010ef          	jal	51be <unlink>
    33b4:	c551                	beqz	a0,3440 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    33b6:	00004517          	auipc	a0,0x4
    33ba:	c3a50513          	addi	a0,a0,-966 # 6ff0 <malloc+0x1974>
    33be:	601010ef          	jal	51be <unlink>
    33c2:	c949                	beqz	a0,3454 <rmdot+0xfe>
  if(unlink("dots") != 0){
    33c4:	00004517          	auipc	a0,0x4
    33c8:	b9c50513          	addi	a0,a0,-1124 # 6f60 <malloc+0x18e4>
    33cc:	5f3010ef          	jal	51be <unlink>
    33d0:	ed41                	bnez	a0,3468 <rmdot+0x112>
}
    33d2:	60e2                	ld	ra,24(sp)
    33d4:	6442                	ld	s0,16(sp)
    33d6:	64a2                	ld	s1,8(sp)
    33d8:	6105                	addi	sp,sp,32
    33da:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    33dc:	85a6                	mv	a1,s1
    33de:	00004517          	auipc	a0,0x4
    33e2:	b8a50513          	addi	a0,a0,-1142 # 6f68 <malloc+0x18ec>
    33e6:	1de020ef          	jal	55c4 <printf>
    exit(1);
    33ea:	4505                	li	a0,1
    33ec:	583010ef          	jal	516e <exit>
    printf("%s: chdir dots failed\n", s);
    33f0:	85a6                	mv	a1,s1
    33f2:	00004517          	auipc	a0,0x4
    33f6:	b8e50513          	addi	a0,a0,-1138 # 6f80 <malloc+0x1904>
    33fa:	1ca020ef          	jal	55c4 <printf>
    exit(1);
    33fe:	4505                	li	a0,1
    3400:	56f010ef          	jal	516e <exit>
    printf("%s: rm . worked!\n", s);
    3404:	85a6                	mv	a1,s1
    3406:	00004517          	auipc	a0,0x4
    340a:	b9250513          	addi	a0,a0,-1134 # 6f98 <malloc+0x191c>
    340e:	1b6020ef          	jal	55c4 <printf>
    exit(1);
    3412:	4505                	li	a0,1
    3414:	55b010ef          	jal	516e <exit>
    printf("%s: rm .. worked!\n", s);
    3418:	85a6                	mv	a1,s1
    341a:	00004517          	auipc	a0,0x4
    341e:	b9650513          	addi	a0,a0,-1130 # 6fb0 <malloc+0x1934>
    3422:	1a2020ef          	jal	55c4 <printf>
    exit(1);
    3426:	4505                	li	a0,1
    3428:	547010ef          	jal	516e <exit>
    printf("%s: chdir / failed\n", s);
    342c:	85a6                	mv	a1,s1
    342e:	00003517          	auipc	a0,0x3
    3432:	53250513          	addi	a0,a0,1330 # 6960 <malloc+0x12e4>
    3436:	18e020ef          	jal	55c4 <printf>
    exit(1);
    343a:	4505                	li	a0,1
    343c:	533010ef          	jal	516e <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3440:	85a6                	mv	a1,s1
    3442:	00004517          	auipc	a0,0x4
    3446:	b8e50513          	addi	a0,a0,-1138 # 6fd0 <malloc+0x1954>
    344a:	17a020ef          	jal	55c4 <printf>
    exit(1);
    344e:	4505                	li	a0,1
    3450:	51f010ef          	jal	516e <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3454:	85a6                	mv	a1,s1
    3456:	00004517          	auipc	a0,0x4
    345a:	ba250513          	addi	a0,a0,-1118 # 6ff8 <malloc+0x197c>
    345e:	166020ef          	jal	55c4 <printf>
    exit(1);
    3462:	4505                	li	a0,1
    3464:	50b010ef          	jal	516e <exit>
    printf("%s: unlink dots failed!\n", s);
    3468:	85a6                	mv	a1,s1
    346a:	00004517          	auipc	a0,0x4
    346e:	bae50513          	addi	a0,a0,-1106 # 7018 <malloc+0x199c>
    3472:	152020ef          	jal	55c4 <printf>
    exit(1);
    3476:	4505                	li	a0,1
    3478:	4f7010ef          	jal	516e <exit>

000000000000347c <dirfile>:
{
    347c:	1101                	addi	sp,sp,-32
    347e:	ec06                	sd	ra,24(sp)
    3480:	e822                	sd	s0,16(sp)
    3482:	e426                	sd	s1,8(sp)
    3484:	e04a                	sd	s2,0(sp)
    3486:	1000                	addi	s0,sp,32
    3488:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    348a:	20000593          	li	a1,512
    348e:	00004517          	auipc	a0,0x4
    3492:	baa50513          	addi	a0,a0,-1110 # 7038 <malloc+0x19bc>
    3496:	519010ef          	jal	51ae <open>
  if(fd < 0){
    349a:	0c054663          	bltz	a0,3566 <dirfile+0xea>
  close(fd);
    349e:	4f9010ef          	jal	5196 <close>
  if(chdir("dirfile") == 0){
    34a2:	00004517          	auipc	a0,0x4
    34a6:	b9650513          	addi	a0,a0,-1130 # 7038 <malloc+0x19bc>
    34aa:	535010ef          	jal	51de <chdir>
    34ae:	c571                	beqz	a0,357a <dirfile+0xfe>
  fd = open("dirfile/xx", 0);
    34b0:	4581                	li	a1,0
    34b2:	00004517          	auipc	a0,0x4
    34b6:	bce50513          	addi	a0,a0,-1074 # 7080 <malloc+0x1a04>
    34ba:	4f5010ef          	jal	51ae <open>
  if(fd >= 0){
    34be:	0c055863          	bgez	a0,358e <dirfile+0x112>
  fd = open("dirfile/xx", O_CREATE);
    34c2:	20000593          	li	a1,512
    34c6:	00004517          	auipc	a0,0x4
    34ca:	bba50513          	addi	a0,a0,-1094 # 7080 <malloc+0x1a04>
    34ce:	4e1010ef          	jal	51ae <open>
  if(fd >= 0){
    34d2:	0c055863          	bgez	a0,35a2 <dirfile+0x126>
  if(mkdir("dirfile/xx") == 0){
    34d6:	00004517          	auipc	a0,0x4
    34da:	baa50513          	addi	a0,a0,-1110 # 7080 <malloc+0x1a04>
    34de:	4f9010ef          	jal	51d6 <mkdir>
    34e2:	0c050a63          	beqz	a0,35b6 <dirfile+0x13a>
  if(unlink("dirfile/xx") == 0){
    34e6:	00004517          	auipc	a0,0x4
    34ea:	b9a50513          	addi	a0,a0,-1126 # 7080 <malloc+0x1a04>
    34ee:	4d1010ef          	jal	51be <unlink>
    34f2:	0c050c63          	beqz	a0,35ca <dirfile+0x14e>
  if(link("README", "dirfile/xx") == 0){
    34f6:	00004597          	auipc	a1,0x4
    34fa:	b8a58593          	addi	a1,a1,-1142 # 7080 <malloc+0x1a04>
    34fe:	00002517          	auipc	a0,0x2
    3502:	48250513          	addi	a0,a0,1154 # 5980 <malloc+0x304>
    3506:	4c9010ef          	jal	51ce <link>
    350a:	0c050a63          	beqz	a0,35de <dirfile+0x162>
  if(unlink("dirfile") != 0){
    350e:	00004517          	auipc	a0,0x4
    3512:	b2a50513          	addi	a0,a0,-1238 # 7038 <malloc+0x19bc>
    3516:	4a9010ef          	jal	51be <unlink>
    351a:	0c051c63          	bnez	a0,35f2 <dirfile+0x176>
  fd = open(".", O_RDWR);
    351e:	4589                	li	a1,2
    3520:	00003517          	auipc	a0,0x3
    3524:	97050513          	addi	a0,a0,-1680 # 5e90 <malloc+0x814>
    3528:	487010ef          	jal	51ae <open>
  if(fd >= 0){
    352c:	0c055d63          	bgez	a0,3606 <dirfile+0x18a>
  fd = open(".", 0);
    3530:	4581                	li	a1,0
    3532:	00003517          	auipc	a0,0x3
    3536:	95e50513          	addi	a0,a0,-1698 # 5e90 <malloc+0x814>
    353a:	475010ef          	jal	51ae <open>
    353e:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3540:	4605                	li	a2,1
    3542:	00002597          	auipc	a1,0x2
    3546:	2d658593          	addi	a1,a1,726 # 5818 <malloc+0x19c>
    354a:	445010ef          	jal	518e <write>
    354e:	0ca04663          	bgtz	a0,361a <dirfile+0x19e>
  close(fd);
    3552:	8526                	mv	a0,s1
    3554:	443010ef          	jal	5196 <close>
}
    3558:	4501                	li	a0,0
    355a:	60e2                	ld	ra,24(sp)
    355c:	6442                	ld	s0,16(sp)
    355e:	64a2                	ld	s1,8(sp)
    3560:	6902                	ld	s2,0(sp)
    3562:	6105                	addi	sp,sp,32
    3564:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3566:	85ca                	mv	a1,s2
    3568:	00004517          	auipc	a0,0x4
    356c:	ad850513          	addi	a0,a0,-1320 # 7040 <malloc+0x19c4>
    3570:	054020ef          	jal	55c4 <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	3f9010ef          	jal	516e <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    357a:	85ca                	mv	a1,s2
    357c:	00004517          	auipc	a0,0x4
    3580:	ae450513          	addi	a0,a0,-1308 # 7060 <malloc+0x19e4>
    3584:	040020ef          	jal	55c4 <printf>
    exit(1);
    3588:	4505                	li	a0,1
    358a:	3e5010ef          	jal	516e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    358e:	85ca                	mv	a1,s2
    3590:	00004517          	auipc	a0,0x4
    3594:	b0050513          	addi	a0,a0,-1280 # 7090 <malloc+0x1a14>
    3598:	02c020ef          	jal	55c4 <printf>
    exit(1);
    359c:	4505                	li	a0,1
    359e:	3d1010ef          	jal	516e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    35a2:	85ca                	mv	a1,s2
    35a4:	00004517          	auipc	a0,0x4
    35a8:	aec50513          	addi	a0,a0,-1300 # 7090 <malloc+0x1a14>
    35ac:	018020ef          	jal	55c4 <printf>
    exit(1);
    35b0:	4505                	li	a0,1
    35b2:	3bd010ef          	jal	516e <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	b0050513          	addi	a0,a0,-1280 # 70b8 <malloc+0x1a3c>
    35c0:	004020ef          	jal	55c4 <printf>
    exit(1);
    35c4:	4505                	li	a0,1
    35c6:	3a9010ef          	jal	516e <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    35ca:	85ca                	mv	a1,s2
    35cc:	00004517          	auipc	a0,0x4
    35d0:	b1450513          	addi	a0,a0,-1260 # 70e0 <malloc+0x1a64>
    35d4:	7f1010ef          	jal	55c4 <printf>
    exit(1);
    35d8:	4505                	li	a0,1
    35da:	395010ef          	jal	516e <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    35de:	85ca                	mv	a1,s2
    35e0:	00004517          	auipc	a0,0x4
    35e4:	b2850513          	addi	a0,a0,-1240 # 7108 <malloc+0x1a8c>
    35e8:	7dd010ef          	jal	55c4 <printf>
    exit(1);
    35ec:	4505                	li	a0,1
    35ee:	381010ef          	jal	516e <exit>
    printf("%s: unlink dirfile failed!\n", s);
    35f2:	85ca                	mv	a1,s2
    35f4:	00004517          	auipc	a0,0x4
    35f8:	b3c50513          	addi	a0,a0,-1220 # 7130 <malloc+0x1ab4>
    35fc:	7c9010ef          	jal	55c4 <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	36d010ef          	jal	516e <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3606:	85ca                	mv	a1,s2
    3608:	00004517          	auipc	a0,0x4
    360c:	b4850513          	addi	a0,a0,-1208 # 7150 <malloc+0x1ad4>
    3610:	7b5010ef          	jal	55c4 <printf>
    exit(1);
    3614:	4505                	li	a0,1
    3616:	359010ef          	jal	516e <exit>
    printf("%s: write . succeeded!\n", s);
    361a:	85ca                	mv	a1,s2
    361c:	00004517          	auipc	a0,0x4
    3620:	b5c50513          	addi	a0,a0,-1188 # 7178 <malloc+0x1afc>
    3624:	7a1010ef          	jal	55c4 <printf>
    exit(1);
    3628:	4505                	li	a0,1
    362a:	345010ef          	jal	516e <exit>

000000000000362e <iref>:
{
    362e:	715d                	addi	sp,sp,-80
    3630:	e486                	sd	ra,72(sp)
    3632:	e0a2                	sd	s0,64(sp)
    3634:	fc26                	sd	s1,56(sp)
    3636:	f84a                	sd	s2,48(sp)
    3638:	f44e                	sd	s3,40(sp)
    363a:	f052                	sd	s4,32(sp)
    363c:	ec56                	sd	s5,24(sp)
    363e:	e85a                	sd	s6,16(sp)
    3640:	e45e                	sd	s7,8(sp)
    3642:	0880                	addi	s0,sp,80
    3644:	8baa                	mv	s7,a0
    3646:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    364a:	00004a97          	auipc	s5,0x4
    364e:	b46a8a93          	addi	s5,s5,-1210 # 7190 <malloc+0x1b14>
    mkdir("");
    3652:	00003497          	auipc	s1,0x3
    3656:	64648493          	addi	s1,s1,1606 # 6c98 <malloc+0x161c>
    link("README", "");
    365a:	00002b17          	auipc	s6,0x2
    365e:	326b0b13          	addi	s6,s6,806 # 5980 <malloc+0x304>
    fd = open("", O_CREATE);
    3662:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3666:	00004997          	auipc	s3,0x4
    366a:	a2298993          	addi	s3,s3,-1502 # 7088 <malloc+0x1a0c>
    366e:	a835                	j	36aa <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3670:	85de                	mv	a1,s7
    3672:	00004517          	auipc	a0,0x4
    3676:	b2650513          	addi	a0,a0,-1242 # 7198 <malloc+0x1b1c>
    367a:	74b010ef          	jal	55c4 <printf>
      exit(1);
    367e:	4505                	li	a0,1
    3680:	2ef010ef          	jal	516e <exit>
      printf("%s: chdir irefd failed\n", s);
    3684:	85de                	mv	a1,s7
    3686:	00004517          	auipc	a0,0x4
    368a:	b2a50513          	addi	a0,a0,-1238 # 71b0 <malloc+0x1b34>
    368e:	737010ef          	jal	55c4 <printf>
      exit(1);
    3692:	4505                	li	a0,1
    3694:	2db010ef          	jal	516e <exit>
      close(fd);
    3698:	2ff010ef          	jal	5196 <close>
    369c:	a825                	j	36d4 <iref+0xa6>
    unlink("xx");
    369e:	854e                	mv	a0,s3
    36a0:	31f010ef          	jal	51be <unlink>
  for(i = 0; i < NINODE + 1; i++){
    36a4:	397d                	addiw	s2,s2,-1
    36a6:	04090063          	beqz	s2,36e6 <iref+0xb8>
    if(mkdir("irefd") != 0){
    36aa:	8556                	mv	a0,s5
    36ac:	32b010ef          	jal	51d6 <mkdir>
    36b0:	f161                	bnez	a0,3670 <iref+0x42>
    if(chdir("irefd") != 0){
    36b2:	8556                	mv	a0,s5
    36b4:	32b010ef          	jal	51de <chdir>
    36b8:	f571                	bnez	a0,3684 <iref+0x56>
    mkdir("");
    36ba:	8526                	mv	a0,s1
    36bc:	31b010ef          	jal	51d6 <mkdir>
    link("README", "");
    36c0:	85a6                	mv	a1,s1
    36c2:	855a                	mv	a0,s6
    36c4:	30b010ef          	jal	51ce <link>
    fd = open("", O_CREATE);
    36c8:	85d2                	mv	a1,s4
    36ca:	8526                	mv	a0,s1
    36cc:	2e3010ef          	jal	51ae <open>
    if(fd >= 0)
    36d0:	fc0554e3          	bgez	a0,3698 <iref+0x6a>
    fd = open("xx", O_CREATE);
    36d4:	85d2                	mv	a1,s4
    36d6:	854e                	mv	a0,s3
    36d8:	2d7010ef          	jal	51ae <open>
    if(fd >= 0)
    36dc:	fc0541e3          	bltz	a0,369e <iref+0x70>
      close(fd);
    36e0:	2b7010ef          	jal	5196 <close>
    36e4:	bf6d                	j	369e <iref+0x70>
    36e6:	03300493          	li	s1,51
    chdir("..");
    36ea:	00003997          	auipc	s3,0x3
    36ee:	2c698993          	addi	s3,s3,710 # 69b0 <malloc+0x1334>
    unlink("irefd");
    36f2:	00004917          	auipc	s2,0x4
    36f6:	a9e90913          	addi	s2,s2,-1378 # 7190 <malloc+0x1b14>
    chdir("..");
    36fa:	854e                	mv	a0,s3
    36fc:	2e3010ef          	jal	51de <chdir>
    unlink("irefd");
    3700:	854a                	mv	a0,s2
    3702:	2bd010ef          	jal	51be <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3706:	34fd                	addiw	s1,s1,-1
    3708:	f8ed                	bnez	s1,36fa <iref+0xcc>
  chdir("/");
    370a:	00003517          	auipc	a0,0x3
    370e:	24e50513          	addi	a0,a0,590 # 6958 <malloc+0x12dc>
    3712:	2cd010ef          	jal	51de <chdir>
}
    3716:	4501                	li	a0,0
    3718:	60a6                	ld	ra,72(sp)
    371a:	6406                	ld	s0,64(sp)
    371c:	74e2                	ld	s1,56(sp)
    371e:	7942                	ld	s2,48(sp)
    3720:	79a2                	ld	s3,40(sp)
    3722:	7a02                	ld	s4,32(sp)
    3724:	6ae2                	ld	s5,24(sp)
    3726:	6b42                	ld	s6,16(sp)
    3728:	6ba2                	ld	s7,8(sp)
    372a:	6161                	addi	sp,sp,80
    372c:	8082                	ret

000000000000372e <openiputtest>:
{
    372e:	7179                	addi	sp,sp,-48
    3730:	f406                	sd	ra,40(sp)
    3732:	f022                	sd	s0,32(sp)
    3734:	ec26                	sd	s1,24(sp)
    3736:	1800                	addi	s0,sp,48
    3738:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    373a:	00004517          	auipc	a0,0x4
    373e:	a8e50513          	addi	a0,a0,-1394 # 71c8 <malloc+0x1b4c>
    3742:	295010ef          	jal	51d6 <mkdir>
    3746:	02054a63          	bltz	a0,377a <openiputtest+0x4c>
  pid = fork();
    374a:	21d010ef          	jal	5166 <fork>
  if(pid < 0){
    374e:	04054063          	bltz	a0,378e <openiputtest+0x60>
  if(pid == 0){
    3752:	e939                	bnez	a0,37a8 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3754:	4589                	li	a1,2
    3756:	00004517          	auipc	a0,0x4
    375a:	a7250513          	addi	a0,a0,-1422 # 71c8 <malloc+0x1b4c>
    375e:	251010ef          	jal	51ae <open>
    if(fd >= 0){
    3762:	04054063          	bltz	a0,37a2 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3766:	85a6                	mv	a1,s1
    3768:	00004517          	auipc	a0,0x4
    376c:	a8050513          	addi	a0,a0,-1408 # 71e8 <malloc+0x1b6c>
    3770:	655010ef          	jal	55c4 <printf>
      exit(1);
    3774:	4505                	li	a0,1
    3776:	1f9010ef          	jal	516e <exit>
    printf("%s: mkdir oidir failed\n", s);
    377a:	85a6                	mv	a1,s1
    377c:	00004517          	auipc	a0,0x4
    3780:	a5450513          	addi	a0,a0,-1452 # 71d0 <malloc+0x1b54>
    3784:	641010ef          	jal	55c4 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	1e5010ef          	jal	516e <exit>
    printf("%s: fork failed\n", s);
    378e:	85a6                	mv	a1,s1
    3790:	00003517          	auipc	a0,0x3
    3794:	8a850513          	addi	a0,a0,-1880 # 6038 <malloc+0x9bc>
    3798:	62d010ef          	jal	55c4 <printf>
    exit(1);
    379c:	4505                	li	a0,1
    379e:	1d1010ef          	jal	516e <exit>
    exit(0);
    37a2:	4501                	li	a0,0
    37a4:	1cb010ef          	jal	516e <exit>
  pause(1);
    37a8:	4505                	li	a0,1
    37aa:	255010ef          	jal	51fe <pause>
  if(unlink("oidir") != 0){
    37ae:	00004517          	auipc	a0,0x4
    37b2:	a1a50513          	addi	a0,a0,-1510 # 71c8 <malloc+0x1b4c>
    37b6:	209010ef          	jal	51be <unlink>
    37ba:	ed01                	bnez	a0,37d2 <openiputtest+0xa4>
  wait(&xstatus);
    37bc:	fdc40513          	addi	a0,s0,-36
    37c0:	1b7010ef          	jal	5176 <wait>
}
    37c4:	fdc42503          	lw	a0,-36(s0)
    37c8:	70a2                	ld	ra,40(sp)
    37ca:	7402                	ld	s0,32(sp)
    37cc:	64e2                	ld	s1,24(sp)
    37ce:	6145                	addi	sp,sp,48
    37d0:	8082                	ret
    printf("%s: unlink failed\n", s);
    37d2:	85a6                	mv	a1,s1
    37d4:	00003517          	auipc	a0,0x3
    37d8:	a5450513          	addi	a0,a0,-1452 # 6228 <malloc+0xbac>
    37dc:	5e9010ef          	jal	55c4 <printf>
    exit(1);
    37e0:	4505                	li	a0,1
    37e2:	18d010ef          	jal	516e <exit>

00000000000037e6 <forkforkfork>:
{
    37e6:	1101                	addi	sp,sp,-32
    37e8:	ec06                	sd	ra,24(sp)
    37ea:	e822                	sd	s0,16(sp)
    37ec:	e426                	sd	s1,8(sp)
    37ee:	1000                	addi	s0,sp,32
    37f0:	84aa                	mv	s1,a0
  unlink("stopforking");
    37f2:	00004517          	auipc	a0,0x4
    37f6:	a1e50513          	addi	a0,a0,-1506 # 7210 <malloc+0x1b94>
    37fa:	1c5010ef          	jal	51be <unlink>
  int pid = fork();
    37fe:	169010ef          	jal	5166 <fork>
  if(pid < 0){
    3802:	02054c63          	bltz	a0,383a <forkforkfork+0x54>
  if(pid == 0){
    3806:	c521                	beqz	a0,384e <forkforkfork+0x68>
  pause(20); // two seconds
    3808:	4551                	li	a0,20
    380a:	1f5010ef          	jal	51fe <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    380e:	20200593          	li	a1,514
    3812:	00004517          	auipc	a0,0x4
    3816:	9fe50513          	addi	a0,a0,-1538 # 7210 <malloc+0x1b94>
    381a:	195010ef          	jal	51ae <open>
    381e:	179010ef          	jal	5196 <close>
  wait(0);
    3822:	4501                	li	a0,0
    3824:	153010ef          	jal	5176 <wait>
  pause(10); // one second
    3828:	4529                	li	a0,10
    382a:	1d5010ef          	jal	51fe <pause>
}
    382e:	4501                	li	a0,0
    3830:	60e2                	ld	ra,24(sp)
    3832:	6442                	ld	s0,16(sp)
    3834:	64a2                	ld	s1,8(sp)
    3836:	6105                	addi	sp,sp,32
    3838:	8082                	ret
    printf("%s: fork failed", s);
    383a:	85a6                	mv	a1,s1
    383c:	00003517          	auipc	a0,0x3
    3840:	9bc50513          	addi	a0,a0,-1604 # 61f8 <malloc+0xb7c>
    3844:	581010ef          	jal	55c4 <printf>
    exit(1);
    3848:	4505                	li	a0,1
    384a:	125010ef          	jal	516e <exit>
      int fd = open("stopforking", 0);
    384e:	4581                	li	a1,0
    3850:	00004517          	auipc	a0,0x4
    3854:	9c050513          	addi	a0,a0,-1600 # 7210 <malloc+0x1b94>
    3858:	157010ef          	jal	51ae <open>
      if(fd >= 0){
    385c:	02055163          	bgez	a0,387e <forkforkfork+0x98>
      if(fork() < 0){
    3860:	107010ef          	jal	5166 <fork>
    3864:	fe0555e3          	bgez	a0,384e <forkforkfork+0x68>
        close(open("stopforking", O_CREATE|O_RDWR));
    3868:	20200593          	li	a1,514
    386c:	00004517          	auipc	a0,0x4
    3870:	9a450513          	addi	a0,a0,-1628 # 7210 <malloc+0x1b94>
    3874:	13b010ef          	jal	51ae <open>
    3878:	11f010ef          	jal	5196 <close>
    387c:	bfc9                	j	384e <forkforkfork+0x68>
        exit(0);
    387e:	4501                	li	a0,0
    3880:	0ef010ef          	jal	516e <exit>

0000000000003884 <killstatus>:
{
    3884:	715d                	addi	sp,sp,-80
    3886:	e486                	sd	ra,72(sp)
    3888:	e0a2                	sd	s0,64(sp)
    388a:	fc26                	sd	s1,56(sp)
    388c:	f84a                	sd	s2,48(sp)
    388e:	f44e                	sd	s3,40(sp)
    3890:	f052                	sd	s4,32(sp)
    3892:	ec56                	sd	s5,24(sp)
    3894:	e85a                	sd	s6,16(sp)
    3896:	0880                	addi	s0,sp,80
    3898:	8b2a                	mv	s6,a0
    389a:	06400913          	li	s2,100
    pause(1);
    389e:	4a85                	li	s5,1
    wait(&xst);
    38a0:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    38a4:	59fd                	li	s3,-1
    int pid1 = fork();
    38a6:	0c1010ef          	jal	5166 <fork>
    38aa:	84aa                	mv	s1,a0
    if(pid1 < 0){
    38ac:	02054e63          	bltz	a0,38e8 <killstatus+0x64>
    if(pid1 == 0){
    38b0:	c531                	beqz	a0,38fc <killstatus+0x78>
    pause(1);
    38b2:	8556                	mv	a0,s5
    38b4:	14b010ef          	jal	51fe <pause>
    kill(pid1);
    38b8:	8526                	mv	a0,s1
    38ba:	0e5010ef          	jal	519e <kill>
    wait(&xst);
    38be:	8552                	mv	a0,s4
    38c0:	0b7010ef          	jal	5176 <wait>
    if(xst != -1) {
    38c4:	fbc42783          	lw	a5,-68(s0)
    38c8:	03379d63          	bne	a5,s3,3902 <killstatus+0x7e>
  for(int i = 0; i < 100; i++){
    38cc:	397d                	addiw	s2,s2,-1
    38ce:	fc091ce3          	bnez	s2,38a6 <killstatus+0x22>
}
    38d2:	4501                	li	a0,0
    38d4:	60a6                	ld	ra,72(sp)
    38d6:	6406                	ld	s0,64(sp)
    38d8:	74e2                	ld	s1,56(sp)
    38da:	7942                	ld	s2,48(sp)
    38dc:	79a2                	ld	s3,40(sp)
    38de:	7a02                	ld	s4,32(sp)
    38e0:	6ae2                	ld	s5,24(sp)
    38e2:	6b42                	ld	s6,16(sp)
    38e4:	6161                	addi	sp,sp,80
    38e6:	8082                	ret
      printf("%s: fork failed\n", s);
    38e8:	85da                	mv	a1,s6
    38ea:	00002517          	auipc	a0,0x2
    38ee:	74e50513          	addi	a0,a0,1870 # 6038 <malloc+0x9bc>
    38f2:	4d3010ef          	jal	55c4 <printf>
      exit(1);
    38f6:	4505                	li	a0,1
    38f8:	077010ef          	jal	516e <exit>
        getpid();
    38fc:	0f3010ef          	jal	51ee <getpid>
      while(1) {
    3900:	bff5                	j	38fc <killstatus+0x78>
       printf("%s: status should be -1\n", s);
    3902:	85da                	mv	a1,s6
    3904:	00004517          	auipc	a0,0x4
    3908:	91c50513          	addi	a0,a0,-1764 # 7220 <malloc+0x1ba4>
    390c:	4b9010ef          	jal	55c4 <printf>
       exit(1);
    3910:	4505                	li	a0,1
    3912:	05d010ef          	jal	516e <exit>

0000000000003916 <preempt>:
{
    3916:	7139                	addi	sp,sp,-64
    3918:	fc06                	sd	ra,56(sp)
    391a:	f822                	sd	s0,48(sp)
    391c:	f426                	sd	s1,40(sp)
    391e:	f04a                	sd	s2,32(sp)
    3920:	ec4e                	sd	s3,24(sp)
    3922:	e852                	sd	s4,16(sp)
    3924:	0080                	addi	s0,sp,64
    3926:	892a                	mv	s2,a0
  pid1 = fork();
    3928:	03f010ef          	jal	5166 <fork>
  if(pid1 < 0) {
    392c:	00054563          	bltz	a0,3936 <preempt+0x20>
    3930:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3932:	ed01                	bnez	a0,394a <preempt+0x34>
    for(;;)
    3934:	a001                	j	3934 <preempt+0x1e>
    printf("%s: fork failed", s);
    3936:	85ca                	mv	a1,s2
    3938:	00003517          	auipc	a0,0x3
    393c:	8c050513          	addi	a0,a0,-1856 # 61f8 <malloc+0xb7c>
    3940:	485010ef          	jal	55c4 <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	029010ef          	jal	516e <exit>
  pid2 = fork();
    394a:	01d010ef          	jal	5166 <fork>
    394e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3950:	00054463          	bltz	a0,3958 <preempt+0x42>
  if(pid2 == 0)
    3954:	ed01                	bnez	a0,396c <preempt+0x56>
    for(;;)
    3956:	a001                	j	3956 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3958:	85ca                	mv	a1,s2
    395a:	00002517          	auipc	a0,0x2
    395e:	6de50513          	addi	a0,a0,1758 # 6038 <malloc+0x9bc>
    3962:	463010ef          	jal	55c4 <printf>
    exit(1);
    3966:	4505                	li	a0,1
    3968:	007010ef          	jal	516e <exit>
  pipe(pfds);
    396c:	fc840513          	addi	a0,s0,-56
    3970:	00f010ef          	jal	517e <pipe>
  pid3 = fork();
    3974:	7f2010ef          	jal	5166 <fork>
    3978:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    397a:	02054863          	bltz	a0,39aa <preempt+0x94>
  if(pid3 == 0){
    397e:	e921                	bnez	a0,39ce <preempt+0xb8>
    close(pfds[0]);
    3980:	fc842503          	lw	a0,-56(s0)
    3984:	013010ef          	jal	5196 <close>
    if(write(pfds[1], "x", 1) != 1)
    3988:	4605                	li	a2,1
    398a:	00002597          	auipc	a1,0x2
    398e:	e8e58593          	addi	a1,a1,-370 # 5818 <malloc+0x19c>
    3992:	fcc42503          	lw	a0,-52(s0)
    3996:	7f8010ef          	jal	518e <write>
    399a:	4785                	li	a5,1
    399c:	02f51163          	bne	a0,a5,39be <preempt+0xa8>
    close(pfds[1]);
    39a0:	fcc42503          	lw	a0,-52(s0)
    39a4:	7f2010ef          	jal	5196 <close>
    for(;;)
    39a8:	a001                	j	39a8 <preempt+0x92>
     printf("%s: fork failed\n", s);
    39aa:	85ca                	mv	a1,s2
    39ac:	00002517          	auipc	a0,0x2
    39b0:	68c50513          	addi	a0,a0,1676 # 6038 <malloc+0x9bc>
    39b4:	411010ef          	jal	55c4 <printf>
     exit(1);
    39b8:	4505                	li	a0,1
    39ba:	7b4010ef          	jal	516e <exit>
      printf("%s: preempt write error", s);
    39be:	85ca                	mv	a1,s2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	88050513          	addi	a0,a0,-1920 # 7240 <malloc+0x1bc4>
    39c8:	3fd010ef          	jal	55c4 <printf>
    39cc:	bfd1                	j	39a0 <preempt+0x8a>
  close(pfds[1]);
    39ce:	fcc42503          	lw	a0,-52(s0)
    39d2:	7c4010ef          	jal	5196 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    39d6:	660d                	lui	a2,0x3
    39d8:	00008597          	auipc	a1,0x8
    39dc:	2e058593          	addi	a1,a1,736 # bcb8 <buf>
    39e0:	fc842503          	lw	a0,-56(s0)
    39e4:	7a2010ef          	jal	5186 <read>
    39e8:	4785                	li	a5,1
    39ea:	04f51d63          	bne	a0,a5,3a44 <preempt+0x12e>
  close(pfds[0]);
    39ee:	fc842503          	lw	a0,-56(s0)
    39f2:	7a4010ef          	jal	5196 <close>
  printf("kill... ");
    39f6:	00004517          	auipc	a0,0x4
    39fa:	87a50513          	addi	a0,a0,-1926 # 7270 <malloc+0x1bf4>
    39fe:	3c7010ef          	jal	55c4 <printf>
  kill(pid1);
    3a02:	8526                	mv	a0,s1
    3a04:	79a010ef          	jal	519e <kill>
  kill(pid2);
    3a08:	854e                	mv	a0,s3
    3a0a:	794010ef          	jal	519e <kill>
  kill(pid3);
    3a0e:	8552                	mv	a0,s4
    3a10:	78e010ef          	jal	519e <kill>
  printf("wait... ");
    3a14:	00004517          	auipc	a0,0x4
    3a18:	86c50513          	addi	a0,a0,-1940 # 7280 <malloc+0x1c04>
    3a1c:	3a9010ef          	jal	55c4 <printf>
  wait(0);
    3a20:	4501                	li	a0,0
    3a22:	754010ef          	jal	5176 <wait>
  wait(0);
    3a26:	4501                	li	a0,0
    3a28:	74e010ef          	jal	5176 <wait>
  wait(0);
    3a2c:	4501                	li	a0,0
    3a2e:	748010ef          	jal	5176 <wait>
}
    3a32:	4501                	li	a0,0
    3a34:	70e2                	ld	ra,56(sp)
    3a36:	7442                	ld	s0,48(sp)
    3a38:	74a2                	ld	s1,40(sp)
    3a3a:	7902                	ld	s2,32(sp)
    3a3c:	69e2                	ld	s3,24(sp)
    3a3e:	6a42                	ld	s4,16(sp)
    3a40:	6121                	addi	sp,sp,64
    3a42:	8082                	ret
    printf("%s: preempt read error", s);
    3a44:	85ca                	mv	a1,s2
    3a46:	00004517          	auipc	a0,0x4
    3a4a:	81250513          	addi	a0,a0,-2030 # 7258 <malloc+0x1bdc>
    3a4e:	377010ef          	jal	55c4 <printf>
    exit(1);
    3a52:	4505                	li	a0,1
    3a54:	71a010ef          	jal	516e <exit>

0000000000003a58 <reparent>:
{
    3a58:	7179                	addi	sp,sp,-48
    3a5a:	f406                	sd	ra,40(sp)
    3a5c:	f022                	sd	s0,32(sp)
    3a5e:	ec26                	sd	s1,24(sp)
    3a60:	e84a                	sd	s2,16(sp)
    3a62:	e44e                	sd	s3,8(sp)
    3a64:	e052                	sd	s4,0(sp)
    3a66:	1800                	addi	s0,sp,48
    3a68:	8a2a                	mv	s4,a0
  int master_pid = getpid();
    3a6a:	784010ef          	jal	51ee <getpid>
    3a6e:	89aa                	mv	s3,a0
    3a70:	0c800913          	li	s2,200
    int pid = fork();
    3a74:	6f2010ef          	jal	5166 <fork>
    3a78:	84aa                	mv	s1,a0
    if(pid < 0){
    3a7a:	02054463          	bltz	a0,3aa2 <reparent+0x4a>
    if(pid){
    3a7e:	c531                	beqz	a0,3aca <reparent+0x72>
      if(wait(0) != pid){
    3a80:	4501                	li	a0,0
    3a82:	6f4010ef          	jal	5176 <wait>
    3a86:	02951863          	bne	a0,s1,3ab6 <reparent+0x5e>
  for(int i = 0; i < 200; i++){
    3a8a:	397d                	addiw	s2,s2,-1
    3a8c:	fe0914e3          	bnez	s2,3a74 <reparent+0x1c>
}
    3a90:	4501                	li	a0,0
    3a92:	70a2                	ld	ra,40(sp)
    3a94:	7402                	ld	s0,32(sp)
    3a96:	64e2                	ld	s1,24(sp)
    3a98:	6942                	ld	s2,16(sp)
    3a9a:	69a2                	ld	s3,8(sp)
    3a9c:	6a02                	ld	s4,0(sp)
    3a9e:	6145                	addi	sp,sp,48
    3aa0:	8082                	ret
      printf("%s: fork failed\n", s);
    3aa2:	85d2                	mv	a1,s4
    3aa4:	00002517          	auipc	a0,0x2
    3aa8:	59450513          	addi	a0,a0,1428 # 6038 <malloc+0x9bc>
    3aac:	319010ef          	jal	55c4 <printf>
      exit(1);
    3ab0:	4505                	li	a0,1
    3ab2:	6bc010ef          	jal	516e <exit>
        printf("%s: wait wrong pid\n", s);
    3ab6:	85d2                	mv	a1,s4
    3ab8:	00002517          	auipc	a0,0x2
    3abc:	70850513          	addi	a0,a0,1800 # 61c0 <malloc+0xb44>
    3ac0:	305010ef          	jal	55c4 <printf>
        exit(1);
    3ac4:	4505                	li	a0,1
    3ac6:	6a8010ef          	jal	516e <exit>
      int pid2 = fork();
    3aca:	69c010ef          	jal	5166 <fork>
      if(pid2 < 0){
    3ace:	00054563          	bltz	a0,3ad8 <reparent+0x80>
      exit(0);
    3ad2:	4501                	li	a0,0
    3ad4:	69a010ef          	jal	516e <exit>
        kill(master_pid);
    3ad8:	854e                	mv	a0,s3
    3ada:	6c4010ef          	jal	519e <kill>
        exit(1);
    3ade:	4505                	li	a0,1
    3ae0:	68e010ef          	jal	516e <exit>

0000000000003ae4 <sbrkfail>:
{
    3ae4:	7175                	addi	sp,sp,-144
    3ae6:	e506                	sd	ra,136(sp)
    3ae8:	e122                	sd	s0,128(sp)
    3aea:	fca6                	sd	s1,120(sp)
    3aec:	f8ca                	sd	s2,112(sp)
    3aee:	f4ce                	sd	s3,104(sp)
    3af0:	f0d2                	sd	s4,96(sp)
    3af2:	ecd6                	sd	s5,88(sp)
    3af4:	e8da                	sd	s6,80(sp)
    3af6:	e4de                	sd	s7,72(sp)
    3af8:	e0e2                	sd	s8,64(sp)
    3afa:	0900                	addi	s0,sp,144
    3afc:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    3afe:	fa040513          	addi	a0,s0,-96
    3b02:	67c010ef          	jal	517e <pipe>
    3b06:	ed01                	bnez	a0,3b1e <sbrkfail+0x3a>
    3b08:	8baa                	mv	s7,a0
    3b0a:	f7040493          	addi	s1,s0,-144
    3b0e:	f9840993          	addi	s3,s0,-104
    3b12:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    3b14:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3b16:	f9f40b13          	addi	s6,s0,-97
    3b1a:	4a85                	li	s5,1
    3b1c:	a095                	j	3b80 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3b1e:	85e2                	mv	a1,s8
    3b20:	00002517          	auipc	a0,0x2
    3b24:	62050513          	addi	a0,a0,1568 # 6140 <malloc+0xac4>
    3b28:	29d010ef          	jal	55c4 <printf>
    exit(1);
    3b2c:	4505                	li	a0,1
    3b2e:	640010ef          	jal	516e <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3b32:	608010ef          	jal	513a <sbrk>
    3b36:	064007b7          	lui	a5,0x6400
    3b3a:	40a7853b          	subw	a0,a5,a0
    3b3e:	5fc010ef          	jal	513a <sbrk>
    3b42:	57fd                	li	a5,-1
    3b44:	02f50163          	beq	a0,a5,3b66 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3b48:	4605                	li	a2,1
    3b4a:	00004597          	auipc	a1,0x4
    3b4e:	ede58593          	addi	a1,a1,-290 # 7a28 <malloc+0x23ac>
    3b52:	fa442503          	lw	a0,-92(s0)
    3b56:	638010ef          	jal	518e <write>
      for(;;) pause(1000);
    3b5a:	3e800493          	li	s1,1000
    3b5e:	8526                	mv	a0,s1
    3b60:	69e010ef          	jal	51fe <pause>
    3b64:	bfed                	j	3b5e <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3b66:	4605                	li	a2,1
    3b68:	00003597          	auipc	a1,0x3
    3b6c:	72858593          	addi	a1,a1,1832 # 7290 <malloc+0x1c14>
    3b70:	fa442503          	lw	a0,-92(s0)
    3b74:	61a010ef          	jal	518e <write>
    3b78:	b7cd                	j	3b5a <sbrkfail+0x76>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3b7a:	0911                	addi	s2,s2,4
    3b7c:	03390a63          	beq	s2,s3,3bb0 <sbrkfail+0xcc>
    if((pids[i] = fork()) == 0){
    3b80:	5e6010ef          	jal	5166 <fork>
    3b84:	00a92023          	sw	a0,0(s2)
    3b88:	d54d                	beqz	a0,3b32 <sbrkfail+0x4e>
    if(pids[i] != -1) {
    3b8a:	ff4508e3          	beq	a0,s4,3b7a <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3b8e:	8656                	mv	a2,s5
    3b90:	85da                	mv	a1,s6
    3b92:	fa042503          	lw	a0,-96(s0)
    3b96:	5f0010ef          	jal	5186 <read>
      if(scratch == '0')
    3b9a:	f9f44783          	lbu	a5,-97(s0)
    3b9e:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f1318>
    3ba2:	0017b793          	seqz	a5,a5
    3ba6:	00fbe7b3          	or	a5,s7,a5
    3baa:	00078b9b          	sext.w	s7,a5
    3bae:	b7f1                	j	3b7a <sbrkfail+0x96>
  if(!failed) {
    3bb0:	000b8863          	beqz	s7,3bc0 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3bb4:	6505                	lui	a0,0x1
    3bb6:	584010ef          	jal	513a <sbrk>
    3bba:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3bbc:	597d                	li	s2,-1
    3bbe:	a821                	j	3bd6 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3bc0:	85e2                	mv	a1,s8
    3bc2:	00003517          	auipc	a0,0x3
    3bc6:	6d650513          	addi	a0,a0,1750 # 7298 <malloc+0x1c1c>
    3bca:	1fb010ef          	jal	55c4 <printf>
    3bce:	b7dd                	j	3bb4 <sbrkfail+0xd0>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3bd0:	0491                	addi	s1,s1,4
    3bd2:	01348b63          	beq	s1,s3,3be8 <sbrkfail+0x104>
    if(pids[i] == -1)
    3bd6:	4088                	lw	a0,0(s1)
    3bd8:	ff250ce3          	beq	a0,s2,3bd0 <sbrkfail+0xec>
    kill(pids[i]);
    3bdc:	5c2010ef          	jal	519e <kill>
    wait(0);
    3be0:	4501                	li	a0,0
    3be2:	594010ef          	jal	5176 <wait>
    3be6:	b7ed                	j	3bd0 <sbrkfail+0xec>
  if(c == (char*)SBRK_ERROR){
    3be8:	57fd                	li	a5,-1
    3bea:	02fa0a63          	beq	s4,a5,3c1e <sbrkfail+0x13a>
  pid = fork();
    3bee:	578010ef          	jal	5166 <fork>
  if(pid < 0){
    3bf2:	04054063          	bltz	a0,3c32 <sbrkfail+0x14e>
  if(pid == 0){
    3bf6:	e939                	bnez	a0,3c4c <sbrkfail+0x168>
    a = sbrk(10*BIG);
    3bf8:	3e800537          	lui	a0,0x3e800
    3bfc:	53e010ef          	jal	513a <sbrk>
    if(a == (char*)SBRK_ERROR){
    3c00:	57fd                	li	a5,-1
    3c02:	04f50263          	beq	a0,a5,3c46 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3c06:	3e800637          	lui	a2,0x3e800
    3c0a:	85e2                	mv	a1,s8
    3c0c:	00003517          	auipc	a0,0x3
    3c10:	6dc50513          	addi	a0,a0,1756 # 72e8 <malloc+0x1c6c>
    3c14:	1b1010ef          	jal	55c4 <printf>
    exit(1);
    3c18:	4505                	li	a0,1
    3c1a:	554010ef          	jal	516e <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3c1e:	85e2                	mv	a1,s8
    3c20:	00003517          	auipc	a0,0x3
    3c24:	6a850513          	addi	a0,a0,1704 # 72c8 <malloc+0x1c4c>
    3c28:	19d010ef          	jal	55c4 <printf>
    exit(1);
    3c2c:	4505                	li	a0,1
    3c2e:	540010ef          	jal	516e <exit>
    printf("%s: fork failed\n", s);
    3c32:	85e2                	mv	a1,s8
    3c34:	00002517          	auipc	a0,0x2
    3c38:	40450513          	addi	a0,a0,1028 # 6038 <malloc+0x9bc>
    3c3c:	189010ef          	jal	55c4 <printf>
    exit(1);
    3c40:	4505                	li	a0,1
    3c42:	52c010ef          	jal	516e <exit>
      exit(0);
    3c46:	4501                	li	a0,0
    3c48:	526010ef          	jal	516e <exit>
  wait(&xstatus);
    3c4c:	fac40513          	addi	a0,s0,-84
    3c50:	526010ef          	jal	5176 <wait>
  if(xstatus != 0)
    3c54:	fac42783          	lw	a5,-84(s0)
    3c58:	ef91                	bnez	a5,3c74 <sbrkfail+0x190>
}
    3c5a:	4501                	li	a0,0
    3c5c:	60aa                	ld	ra,136(sp)
    3c5e:	640a                	ld	s0,128(sp)
    3c60:	74e6                	ld	s1,120(sp)
    3c62:	7946                	ld	s2,112(sp)
    3c64:	79a6                	ld	s3,104(sp)
    3c66:	7a06                	ld	s4,96(sp)
    3c68:	6ae6                	ld	s5,88(sp)
    3c6a:	6b46                	ld	s6,80(sp)
    3c6c:	6ba6                	ld	s7,72(sp)
    3c6e:	6c06                	ld	s8,64(sp)
    3c70:	6149                	addi	sp,sp,144
    3c72:	8082                	ret
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	4f8010ef          	jal	516e <exit>

0000000000003c7a <mem>:
{
    3c7a:	7139                	addi	sp,sp,-64
    3c7c:	fc06                	sd	ra,56(sp)
    3c7e:	f822                	sd	s0,48(sp)
    3c80:	f426                	sd	s1,40(sp)
    3c82:	f04a                	sd	s2,32(sp)
    3c84:	ec4e                	sd	s3,24(sp)
    3c86:	0080                	addi	s0,sp,64
    3c88:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3c8a:	4dc010ef          	jal	5166 <fork>
    m1 = 0;
    3c8e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3c90:	6909                	lui	s2,0x2
    3c92:	71190913          	addi	s2,s2,1809 # 2711 <sbrklast+0xa1>
  if((pid = fork()) == 0){
    3c96:	c11d                	beqz	a0,3cbc <mem+0x42>
    wait(&xstatus);
    3c98:	fcc40513          	addi	a0,s0,-52
    3c9c:	4da010ef          	jal	5176 <wait>
    if(xstatus == -1){
    3ca0:	fcc42503          	lw	a0,-52(s0)
    3ca4:	57fd                	li	a5,-1
    3ca6:	04f50863          	beq	a0,a5,3cf6 <mem+0x7c>
}
    3caa:	70e2                	ld	ra,56(sp)
    3cac:	7442                	ld	s0,48(sp)
    3cae:	74a2                	ld	s1,40(sp)
    3cb0:	7902                	ld	s2,32(sp)
    3cb2:	69e2                	ld	s3,24(sp)
    3cb4:	6121                	addi	sp,sp,64
    3cb6:	8082                	ret
      *(char**)m2 = m1;
    3cb8:	e104                	sd	s1,0(a0)
      m1 = m2;
    3cba:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3cbc:	854a                	mv	a0,s2
    3cbe:	1bf010ef          	jal	567c <malloc>
    3cc2:	f97d                	bnez	a0,3cb8 <mem+0x3e>
    while(m1){
    3cc4:	c491                	beqz	s1,3cd0 <mem+0x56>
      m2 = *(char**)m1;
    3cc6:	8526                	mv	a0,s1
    3cc8:	6084                	ld	s1,0(s1)
      free(m1);
    3cca:	12d010ef          	jal	55f6 <free>
    while(m1){
    3cce:	fce5                	bnez	s1,3cc6 <mem+0x4c>
    m1 = malloc(1024*20);
    3cd0:	6515                	lui	a0,0x5
    3cd2:	1ab010ef          	jal	567c <malloc>
    if(m1 == 0){
    3cd6:	c511                	beqz	a0,3ce2 <mem+0x68>
    free(m1);
    3cd8:	11f010ef          	jal	55f6 <free>
    exit(0);
    3cdc:	4501                	li	a0,0
    3cde:	490010ef          	jal	516e <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3ce2:	85ce                	mv	a1,s3
    3ce4:	00003517          	auipc	a0,0x3
    3ce8:	63450513          	addi	a0,a0,1588 # 7318 <malloc+0x1c9c>
    3cec:	0d9010ef          	jal	55c4 <printf>
      exit(1);
    3cf0:	4505                	li	a0,1
    3cf2:	47c010ef          	jal	516e <exit>
      exit(0);
    3cf6:	4501                	li	a0,0
    3cf8:	476010ef          	jal	516e <exit>

0000000000003cfc <sharedfd>:
{
    3cfc:	7119                	addi	sp,sp,-128
    3cfe:	fc86                	sd	ra,120(sp)
    3d00:	f8a2                	sd	s0,112(sp)
    3d02:	f06a                	sd	s10,32(sp)
    3d04:	0100                	addi	s0,sp,128
    3d06:	8d2a                	mv	s10,a0
  unlink("sharedfd");
    3d08:	00003517          	auipc	a0,0x3
    3d0c:	63050513          	addi	a0,a0,1584 # 7338 <malloc+0x1cbc>
    3d10:	4ae010ef          	jal	51be <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3d14:	20200593          	li	a1,514
    3d18:	00003517          	auipc	a0,0x3
    3d1c:	62050513          	addi	a0,a0,1568 # 7338 <malloc+0x1cbc>
    3d20:	48e010ef          	jal	51ae <open>
  if(fd < 0){
    3d24:	06054a63          	bltz	a0,3d98 <sharedfd+0x9c>
    3d28:	f4a6                	sd	s1,104(sp)
    3d2a:	f0ca                	sd	s2,96(sp)
    3d2c:	ecce                	sd	s3,88(sp)
    3d2e:	e8d2                	sd	s4,80(sp)
    3d30:	e4d6                	sd	s5,72(sp)
    3d32:	89aa                	mv	s3,a0
  pid = fork();
    3d34:	432010ef          	jal	5166 <fork>
    3d38:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3d3a:	07000593          	li	a1,112
    3d3e:	e119                	bnez	a0,3d44 <sharedfd+0x48>
    3d40:	06300593          	li	a1,99
    3d44:	4629                	li	a2,10
    3d46:	f9040513          	addi	a0,s0,-112
    3d4a:	1fa010ef          	jal	4f44 <memset>
    3d4e:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3d52:	f9040a13          	addi	s4,s0,-112
    3d56:	4929                	li	s2,10
    3d58:	864a                	mv	a2,s2
    3d5a:	85d2                	mv	a1,s4
    3d5c:	854e                	mv	a0,s3
    3d5e:	430010ef          	jal	518e <write>
    3d62:	05251e63          	bne	a0,s2,3dbe <sharedfd+0xc2>
  for(i = 0; i < N; i++){
    3d66:	34fd                	addiw	s1,s1,-1
    3d68:	f8e5                	bnez	s1,3d58 <sharedfd+0x5c>
  if(pid == 0) {
    3d6a:	060a8863          	beqz	s5,3dda <sharedfd+0xde>
    3d6e:	f466                	sd	s9,40(sp)
    wait(&xstatus);
    3d70:	f8c40513          	addi	a0,s0,-116
    3d74:	402010ef          	jal	5176 <wait>
    if(xstatus != 0)
    3d78:	f8c42c83          	lw	s9,-116(s0)
    3d7c:	060c8663          	beqz	s9,3de8 <sharedfd+0xec>
}
    3d80:	8566                	mv	a0,s9
    3d82:	74a6                	ld	s1,104(sp)
    3d84:	7906                	ld	s2,96(sp)
    3d86:	69e6                	ld	s3,88(sp)
    3d88:	6a46                	ld	s4,80(sp)
    3d8a:	6aa6                	ld	s5,72(sp)
    3d8c:	7ca2                	ld	s9,40(sp)
    3d8e:	70e6                	ld	ra,120(sp)
    3d90:	7446                	ld	s0,112(sp)
    3d92:	7d02                	ld	s10,32(sp)
    3d94:	6109                	addi	sp,sp,128
    3d96:	8082                	ret
    3d98:	f4a6                	sd	s1,104(sp)
    3d9a:	f0ca                	sd	s2,96(sp)
    3d9c:	ecce                	sd	s3,88(sp)
    3d9e:	e8d2                	sd	s4,80(sp)
    3da0:	e4d6                	sd	s5,72(sp)
    3da2:	e0da                	sd	s6,64(sp)
    3da4:	fc5e                	sd	s7,56(sp)
    3da6:	f862                	sd	s8,48(sp)
    3da8:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3daa:	85ea                	mv	a1,s10
    3dac:	00003517          	auipc	a0,0x3
    3db0:	59c50513          	addi	a0,a0,1436 # 7348 <malloc+0x1ccc>
    3db4:	011010ef          	jal	55c4 <printf>
    exit(1);
    3db8:	4505                	li	a0,1
    3dba:	3b4010ef          	jal	516e <exit>
    3dbe:	e0da                	sd	s6,64(sp)
    3dc0:	fc5e                	sd	s7,56(sp)
    3dc2:	f862                	sd	s8,48(sp)
    3dc4:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3dc6:	85ea                	mv	a1,s10
    3dc8:	00003517          	auipc	a0,0x3
    3dcc:	5a850513          	addi	a0,a0,1448 # 7370 <malloc+0x1cf4>
    3dd0:	7f4010ef          	jal	55c4 <printf>
      exit(1);
    3dd4:	4505                	li	a0,1
    3dd6:	398010ef          	jal	516e <exit>
    3dda:	e0da                	sd	s6,64(sp)
    3ddc:	fc5e                	sd	s7,56(sp)
    3dde:	f862                	sd	s8,48(sp)
    3de0:	f466                	sd	s9,40(sp)
    exit(0);
    3de2:	4501                	li	a0,0
    3de4:	38a010ef          	jal	516e <exit>
    3de8:	e0da                	sd	s6,64(sp)
    3dea:	fc5e                	sd	s7,56(sp)
    3dec:	f862                	sd	s8,48(sp)
  close(fd);
    3dee:	854e                	mv	a0,s3
    3df0:	3a6010ef          	jal	5196 <close>
  fd = open("sharedfd", 0);
    3df4:	4581                	li	a1,0
    3df6:	00003517          	auipc	a0,0x3
    3dfa:	54250513          	addi	a0,a0,1346 # 7338 <malloc+0x1cbc>
    3dfe:	3b0010ef          	jal	51ae <open>
    3e02:	8b2a                	mv	s6,a0
  nc = np = 0;
    3e04:	89e6                	mv	s3,s9
    3e06:	8a66                	mv	s4,s9
  if(fd < 0){
    3e08:	02054563          	bltz	a0,3e32 <sharedfd+0x136>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3e0c:	f9040c13          	addi	s8,s0,-112
    3e10:	4ba9                	li	s7,10
    3e12:	f9a40913          	addi	s2,s0,-102
      if(buf[i] == 'c')
    3e16:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3e1a:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3e1e:	865e                	mv	a2,s7
    3e20:	85e2                	mv	a1,s8
    3e22:	855a                	mv	a0,s6
    3e24:	362010ef          	jal	5186 <read>
    3e28:	02a05b63          	blez	a0,3e5e <sharedfd+0x162>
    3e2c:	f9040793          	addi	a5,s0,-112
    3e30:	a839                	j	3e4e <sharedfd+0x152>
    printf("%s: cannot open sharedfd for reading\n", s);
    3e32:	85ea                	mv	a1,s10
    3e34:	00003517          	auipc	a0,0x3
    3e38:	55c50513          	addi	a0,a0,1372 # 7390 <malloc+0x1d14>
    3e3c:	788010ef          	jal	55c4 <printf>
    exit(1);
    3e40:	4505                	li	a0,1
    3e42:	32c010ef          	jal	516e <exit>
        nc++;
    3e46:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3e48:	0785                	addi	a5,a5,1
    3e4a:	fd278ae3          	beq	a5,s2,3e1e <sharedfd+0x122>
      if(buf[i] == 'c')
    3e4e:	0007c703          	lbu	a4,0(a5)
    3e52:	fe970ae3          	beq	a4,s1,3e46 <sharedfd+0x14a>
      if(buf[i] == 'p')
    3e56:	ff5719e3          	bne	a4,s5,3e48 <sharedfd+0x14c>
        np++;
    3e5a:	2985                	addiw	s3,s3,1
    3e5c:	b7f5                	j	3e48 <sharedfd+0x14c>
  close(fd);
    3e5e:	855a                	mv	a0,s6
    3e60:	336010ef          	jal	5196 <close>
  unlink("sharedfd");
    3e64:	00003517          	auipc	a0,0x3
    3e68:	4d450513          	addi	a0,a0,1236 # 7338 <malloc+0x1cbc>
    3e6c:	352010ef          	jal	51be <unlink>
  if(nc == N*SZ && np == N*SZ){
    3e70:	6789                	lui	a5,0x2
    3e72:	71078793          	addi	a5,a5,1808 # 2710 <sbrklast+0xa0>
    3e76:	00fa1863          	bne	s4,a5,3e86 <sharedfd+0x18a>
    3e7a:	01499663          	bne	s3,s4,3e86 <sharedfd+0x18a>
    3e7e:	6b06                	ld	s6,64(sp)
    3e80:	7be2                	ld	s7,56(sp)
    3e82:	7c42                	ld	s8,48(sp)
    3e84:	bdf5                	j	3d80 <sharedfd+0x84>
    printf("%s: nc/np test fails\n", s);
    3e86:	85ea                	mv	a1,s10
    3e88:	00003517          	auipc	a0,0x3
    3e8c:	53050513          	addi	a0,a0,1328 # 73b8 <malloc+0x1d3c>
    3e90:	734010ef          	jal	55c4 <printf>
    exit(1);
    3e94:	4505                	li	a0,1
    3e96:	2d8010ef          	jal	516e <exit>

0000000000003e9a <fourfiles>:
{
    3e9a:	7135                	addi	sp,sp,-160
    3e9c:	ed06                	sd	ra,152(sp)
    3e9e:	e922                	sd	s0,144(sp)
    3ea0:	e526                	sd	s1,136(sp)
    3ea2:	e14a                	sd	s2,128(sp)
    3ea4:	fcce                	sd	s3,120(sp)
    3ea6:	f8d2                	sd	s4,112(sp)
    3ea8:	f0da                	sd	s6,96(sp)
    3eaa:	ecde                	sd	s7,88(sp)
    3eac:	e4e6                	sd	s9,72(sp)
    3eae:	1100                	addi	s0,sp,160
    3eb0:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3eb2:	00003797          	auipc	a5,0x3
    3eb6:	51e78793          	addi	a5,a5,1310 # 73d0 <malloc+0x1d54>
    3eba:	f6f43823          	sd	a5,-144(s0)
    3ebe:	00003797          	auipc	a5,0x3
    3ec2:	51a78793          	addi	a5,a5,1306 # 73d8 <malloc+0x1d5c>
    3ec6:	f6f43c23          	sd	a5,-136(s0)
    3eca:	00003797          	auipc	a5,0x3
    3ece:	51678793          	addi	a5,a5,1302 # 73e0 <malloc+0x1d64>
    3ed2:	f8f43023          	sd	a5,-128(s0)
    3ed6:	00003797          	auipc	a5,0x3
    3eda:	51278793          	addi	a5,a5,1298 # 73e8 <malloc+0x1d6c>
    3ede:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3ee2:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3ee6:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3ee8:	4481                	li	s1,0
    3eea:	4a11                	li	s4,4
    fname = names[pi];
    3eec:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3ef0:	854e                	mv	a0,s3
    3ef2:	2cc010ef          	jal	51be <unlink>
    pid = fork();
    3ef6:	270010ef          	jal	5166 <fork>
    if(pid < 0){
    3efa:	04054463          	bltz	a0,3f42 <fourfiles+0xa8>
    if(pid == 0){
    3efe:	c125                	beqz	a0,3f5e <fourfiles+0xc4>
  for(pi = 0; pi < NCHILD; pi++){
    3f00:	2485                	addiw	s1,s1,1
    3f02:	0921                	addi	s2,s2,8
    3f04:	ff4494e3          	bne	s1,s4,3eec <fourfiles+0x52>
    3f08:	4491                	li	s1,4
    wait(&xstatus);
    3f0a:	f6c40913          	addi	s2,s0,-148
    3f0e:	854a                	mv	a0,s2
    3f10:	266010ef          	jal	5176 <wait>
    if(xstatus != 0)
    3f14:	f6c42b03          	lw	s6,-148(s0)
    3f18:	140b1b63          	bnez	s6,406e <fourfiles+0x1d4>
  for(pi = 0; pi < NCHILD; pi++){
    3f1c:	34fd                	addiw	s1,s1,-1
    3f1e:	f8e5                	bnez	s1,3f0e <fourfiles+0x74>
    3f20:	f4d6                	sd	s5,104(sp)
    3f22:	e8e2                	sd	s8,80(sp)
    3f24:	e0ea                	sd	s10,64(sp)
    3f26:	fc6e                	sd	s11,56(sp)
    3f28:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f2c:	6a8d                	lui	s5,0x3
    3f2e:	00008a17          	auipc	s4,0x8
    3f32:	d8aa0a13          	addi	s4,s4,-630 # bcb8 <buf>
    if(total != N*SZ){
    3f36:	6d05                	lui	s10,0x1
    3f38:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x5a>
  for(i = 0; i < NCHILD; i++){
    3f3c:	03400d93          	li	s11,52
    3f40:	a8d1                	j	4014 <fourfiles+0x17a>
    3f42:	f4d6                	sd	s5,104(sp)
    3f44:	e8e2                	sd	s8,80(sp)
    3f46:	e0ea                	sd	s10,64(sp)
    3f48:	fc6e                	sd	s11,56(sp)
      printf("%s: fork failed\n", s);
    3f4a:	85e6                	mv	a1,s9
    3f4c:	00002517          	auipc	a0,0x2
    3f50:	0ec50513          	addi	a0,a0,236 # 6038 <malloc+0x9bc>
    3f54:	670010ef          	jal	55c4 <printf>
      exit(1);
    3f58:	4505                	li	a0,1
    3f5a:	214010ef          	jal	516e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3f5e:	20200593          	li	a1,514
    3f62:	854e                	mv	a0,s3
    3f64:	24a010ef          	jal	51ae <open>
    3f68:	892a                	mv	s2,a0
      if(fd < 0){
    3f6a:	04054463          	bltz	a0,3fb2 <fourfiles+0x118>
      memset(buf, '0'+pi, SZ);
    3f6e:	1f400613          	li	a2,500
    3f72:	0304859b          	addiw	a1,s1,48
    3f76:	00008517          	auipc	a0,0x8
    3f7a:	d4250513          	addi	a0,a0,-702 # bcb8 <buf>
    3f7e:	7c7000ef          	jal	4f44 <memset>
    3f82:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3f84:	1f400993          	li	s3,500
    3f88:	00008a17          	auipc	s4,0x8
    3f8c:	d30a0a13          	addi	s4,s4,-720 # bcb8 <buf>
    3f90:	864e                	mv	a2,s3
    3f92:	85d2                	mv	a1,s4
    3f94:	854a                	mv	a0,s2
    3f96:	1f8010ef          	jal	518e <write>
    3f9a:	85aa                	mv	a1,a0
    3f9c:	03351963          	bne	a0,s3,3fce <fourfiles+0x134>
      for(i = 0; i < N; i++){
    3fa0:	34fd                	addiw	s1,s1,-1
    3fa2:	f4fd                	bnez	s1,3f90 <fourfiles+0xf6>
    3fa4:	f4d6                	sd	s5,104(sp)
    3fa6:	e8e2                	sd	s8,80(sp)
    3fa8:	e0ea                	sd	s10,64(sp)
    3faa:	fc6e                	sd	s11,56(sp)
      exit(0);
    3fac:	4501                	li	a0,0
    3fae:	1c0010ef          	jal	516e <exit>
    3fb2:	f4d6                	sd	s5,104(sp)
    3fb4:	e8e2                	sd	s8,80(sp)
    3fb6:	e0ea                	sd	s10,64(sp)
    3fb8:	fc6e                	sd	s11,56(sp)
        printf("%s: create failed\n", s);
    3fba:	85e6                	mv	a1,s9
    3fbc:	00002517          	auipc	a0,0x2
    3fc0:	11450513          	addi	a0,a0,276 # 60d0 <malloc+0xa54>
    3fc4:	600010ef          	jal	55c4 <printf>
        exit(1);
    3fc8:	4505                	li	a0,1
    3fca:	1a4010ef          	jal	516e <exit>
    3fce:	f4d6                	sd	s5,104(sp)
    3fd0:	e8e2                	sd	s8,80(sp)
    3fd2:	e0ea                	sd	s10,64(sp)
    3fd4:	fc6e                	sd	s11,56(sp)
          printf("write failed %d\n", n);
    3fd6:	00003517          	auipc	a0,0x3
    3fda:	41a50513          	addi	a0,a0,1050 # 73f0 <malloc+0x1d74>
    3fde:	5e6010ef          	jal	55c4 <printf>
          exit(1);
    3fe2:	4505                	li	a0,1
    3fe4:	18a010ef          	jal	516e <exit>
          printf("%s: wrong char\n", s);
    3fe8:	85e6                	mv	a1,s9
    3fea:	00003517          	auipc	a0,0x3
    3fee:	41e50513          	addi	a0,a0,1054 # 7408 <malloc+0x1d8c>
    3ff2:	5d2010ef          	jal	55c4 <printf>
          exit(1);
    3ff6:	4505                	li	a0,1
    3ff8:	176010ef          	jal	516e <exit>
    close(fd);
    3ffc:	854e                	mv	a0,s3
    3ffe:	198010ef          	jal	5196 <close>
    if(total != N*SZ){
    4002:	05a91863          	bne	s2,s10,4052 <fourfiles+0x1b8>
    unlink(fname);
    4006:	8562                	mv	a0,s8
    4008:	1b6010ef          	jal	51be <unlink>
  for(i = 0; i < NCHILD; i++){
    400c:	0ba1                	addi	s7,s7,8
    400e:	2485                	addiw	s1,s1,1
    4010:	05b48b63          	beq	s1,s11,4066 <fourfiles+0x1cc>
    fname = names[i];
    4014:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4018:	4581                	li	a1,0
    401a:	8562                	mv	a0,s8
    401c:	192010ef          	jal	51ae <open>
    4020:	89aa                	mv	s3,a0
    total = 0;
    4022:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4024:	8656                	mv	a2,s5
    4026:	85d2                	mv	a1,s4
    4028:	854e                	mv	a0,s3
    402a:	15c010ef          	jal	5186 <read>
    402e:	fca057e3          	blez	a0,3ffc <fourfiles+0x162>
    4032:	00008797          	auipc	a5,0x8
    4036:	c8678793          	addi	a5,a5,-890 # bcb8 <buf>
    403a:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    403e:	0007c703          	lbu	a4,0(a5)
    4042:	fa9713e3          	bne	a4,s1,3fe8 <fourfiles+0x14e>
      for(j = 0; j < n; j++){
    4046:	0785                	addi	a5,a5,1
    4048:	fed79be3          	bne	a5,a3,403e <fourfiles+0x1a4>
      total += n;
    404c:	00a9093b          	addw	s2,s2,a0
    4050:	bfd1                	j	4024 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4052:	85ca                	mv	a1,s2
    4054:	00003517          	auipc	a0,0x3
    4058:	3c450513          	addi	a0,a0,964 # 7418 <malloc+0x1d9c>
    405c:	568010ef          	jal	55c4 <printf>
      exit(1);
    4060:	4505                	li	a0,1
    4062:	10c010ef          	jal	516e <exit>
    4066:	7aa6                	ld	s5,104(sp)
    4068:	6c46                	ld	s8,80(sp)
    406a:	6d06                	ld	s10,64(sp)
    406c:	7de2                	ld	s11,56(sp)
}
    406e:	855a                	mv	a0,s6
    4070:	60ea                	ld	ra,152(sp)
    4072:	644a                	ld	s0,144(sp)
    4074:	64aa                	ld	s1,136(sp)
    4076:	690a                	ld	s2,128(sp)
    4078:	79e6                	ld	s3,120(sp)
    407a:	7a46                	ld	s4,112(sp)
    407c:	7b06                	ld	s6,96(sp)
    407e:	6be6                	ld	s7,88(sp)
    4080:	6ca6                	ld	s9,72(sp)
    4082:	610d                	addi	sp,sp,160
    4084:	8082                	ret

0000000000004086 <concreate>:
{
    4086:	7171                	addi	sp,sp,-176
    4088:	f506                	sd	ra,168(sp)
    408a:	f122                	sd	s0,160(sp)
    408c:	ed26                	sd	s1,152(sp)
    408e:	e94a                	sd	s2,144(sp)
    4090:	e54e                	sd	s3,136(sp)
    4092:	e152                	sd	s4,128(sp)
    4094:	fcd6                	sd	s5,120(sp)
    4096:	f8da                	sd	s6,112(sp)
    4098:	f4de                	sd	s7,104(sp)
    409a:	f0e2                	sd	s8,96(sp)
    409c:	ece6                	sd	s9,88(sp)
    409e:	e8ea                	sd	s10,80(sp)
    40a0:	1900                	addi	s0,sp,176
    40a2:	8d2a                	mv	s10,a0
  file[0] = 'C';
    40a4:	04300793          	li	a5,67
    40a8:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    40ac:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    40b0:	4901                	li	s2,0
    unlink(file);
    40b2:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    40b6:	55555b37          	lui	s6,0x55555
    40ba:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554689e>
    40be:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    40c0:	20200c13          	li	s8,514
      link("C0", file);
    40c4:	00003c97          	auipc	s9,0x3
    40c8:	36cc8c93          	addi	s9,s9,876 # 7430 <malloc+0x1db4>
      wait(&xstatus);
    40cc:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    40d0:	02800a13          	li	s4,40
    40d4:	ac25                	j	430c <concreate+0x286>
      link("C0", file);
    40d6:	85ce                	mv	a1,s3
    40d8:	8566                	mv	a0,s9
    40da:	0f4010ef          	jal	51ce <link>
    if(pid == 0) {
    40de:	ac29                	j	42f8 <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    40e0:	666667b7          	lui	a5,0x66666
    40e4:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579af>
    40e8:	02f907b3          	mul	a5,s2,a5
    40ec:	9785                	srai	a5,a5,0x21
    40ee:	41f9571b          	sraiw	a4,s2,0x1f
    40f2:	9f99                	subw	a5,a5,a4
    40f4:	0027971b          	slliw	a4,a5,0x2
    40f8:	9fb9                	addw	a5,a5,a4
    40fa:	40f9093b          	subw	s2,s2,a5
    40fe:	4785                	li	a5,1
    4100:	02f90563          	beq	s2,a5,412a <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4104:	20200593          	li	a1,514
    4108:	f9840513          	addi	a0,s0,-104
    410c:	0a2010ef          	jal	51ae <open>
      if(fd < 0){
    4110:	1c055f63          	bgez	a0,42ee <concreate+0x268>
        printf("concreate create %s failed\n", file);
    4114:	f9840593          	addi	a1,s0,-104
    4118:	00003517          	auipc	a0,0x3
    411c:	32050513          	addi	a0,a0,800 # 7438 <malloc+0x1dbc>
    4120:	4a4010ef          	jal	55c4 <printf>
        exit(1);
    4124:	4505                	li	a0,1
    4126:	048010ef          	jal	516e <exit>
      link("C0", file);
    412a:	f9840593          	addi	a1,s0,-104
    412e:	00003517          	auipc	a0,0x3
    4132:	30250513          	addi	a0,a0,770 # 7430 <malloc+0x1db4>
    4136:	098010ef          	jal	51ce <link>
      exit(0);
    413a:	4501                	li	a0,0
    413c:	032010ef          	jal	516e <exit>
        exit(1);
    4140:	4505                	li	a0,1
    4142:	02c010ef          	jal	516e <exit>
  memset(fa, 0, sizeof(fa));
    4146:	02800613          	li	a2,40
    414a:	4581                	li	a1,0
    414c:	f7040513          	addi	a0,s0,-144
    4150:	5f5000ef          	jal	4f44 <memset>
  fd = open(".", 0);
    4154:	4581                	li	a1,0
    4156:	00002517          	auipc	a0,0x2
    415a:	d3a50513          	addi	a0,a0,-710 # 5e90 <malloc+0x814>
    415e:	050010ef          	jal	51ae <open>
    4162:	892a                	mv	s2,a0
  n = 0;
    4164:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    4166:	f6040a13          	addi	s4,s0,-160
    416a:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    416c:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4170:	02700b93          	li	s7,39
      fa[i] = 1;
    4174:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    4176:	864e                	mv	a2,s3
    4178:	85d2                	mv	a1,s4
    417a:	854a                	mv	a0,s2
    417c:	00a010ef          	jal	5186 <read>
    4180:	06a05763          	blez	a0,41ee <concreate+0x168>
    if(de.inum == 0)
    4184:	f6045783          	lhu	a5,-160(s0)
    4188:	d7fd                	beqz	a5,4176 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    418a:	f6244783          	lbu	a5,-158(s0)
    418e:	ff5794e3          	bne	a5,s5,4176 <concreate+0xf0>
    4192:	f6444783          	lbu	a5,-156(s0)
    4196:	f3e5                	bnez	a5,4176 <concreate+0xf0>
      i = de.name[1] - '0';
    4198:	f6344783          	lbu	a5,-157(s0)
    419c:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    41a0:	00fbef63          	bltu	s7,a5,41be <concreate+0x138>
      if(fa[i]){
    41a4:	fa078713          	addi	a4,a5,-96
    41a8:	9722                	add	a4,a4,s0
    41aa:	fd074703          	lbu	a4,-48(a4)
    41ae:	e705                	bnez	a4,41d6 <concreate+0x150>
      fa[i] = 1;
    41b0:	fa078793          	addi	a5,a5,-96
    41b4:	97a2                	add	a5,a5,s0
    41b6:	fd878823          	sb	s8,-48(a5)
      n++;
    41ba:	2b05                	addiw	s6,s6,1
    41bc:	bf6d                	j	4176 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    41be:	f6240613          	addi	a2,s0,-158
    41c2:	85ea                	mv	a1,s10
    41c4:	00003517          	auipc	a0,0x3
    41c8:	29450513          	addi	a0,a0,660 # 7458 <malloc+0x1ddc>
    41cc:	3f8010ef          	jal	55c4 <printf>
        exit(1);
    41d0:	4505                	li	a0,1
    41d2:	79d000ef          	jal	516e <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    41d6:	f6240613          	addi	a2,s0,-158
    41da:	85ea                	mv	a1,s10
    41dc:	00003517          	auipc	a0,0x3
    41e0:	29c50513          	addi	a0,a0,668 # 7478 <malloc+0x1dfc>
    41e4:	3e0010ef          	jal	55c4 <printf>
        exit(1);
    41e8:	4505                	li	a0,1
    41ea:	785000ef          	jal	516e <exit>
  close(fd);
    41ee:	854a                	mv	a0,s2
    41f0:	7a7000ef          	jal	5196 <close>
  if(n != N){
    41f4:	02800793          	li	a5,40
    41f8:	00fb1a63          	bne	s6,a5,420c <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    41fc:	55555a37          	lui	s4,0x55555
    4200:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554689e>
      close(open(file, 0));
    4204:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    4208:	8ada                	mv	s5,s6
    420a:	a049                	j	428c <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    420c:	85ea                	mv	a1,s10
    420e:	00003517          	auipc	a0,0x3
    4212:	29250513          	addi	a0,a0,658 # 74a0 <malloc+0x1e24>
    4216:	3ae010ef          	jal	55c4 <printf>
    exit(1);
    421a:	4505                	li	a0,1
    421c:	753000ef          	jal	516e <exit>
      printf("%s: fork failed\n", s);
    4220:	85ea                	mv	a1,s10
    4222:	00002517          	auipc	a0,0x2
    4226:	e1650513          	addi	a0,a0,-490 # 6038 <malloc+0x9bc>
    422a:	39a010ef          	jal	55c4 <printf>
      exit(1);
    422e:	4505                	li	a0,1
    4230:	73f000ef          	jal	516e <exit>
      close(open(file, 0));
    4234:	4581                	li	a1,0
    4236:	854e                	mv	a0,s3
    4238:	777000ef          	jal	51ae <open>
    423c:	75b000ef          	jal	5196 <close>
      close(open(file, 0));
    4240:	4581                	li	a1,0
    4242:	854e                	mv	a0,s3
    4244:	76b000ef          	jal	51ae <open>
    4248:	74f000ef          	jal	5196 <close>
      close(open(file, 0));
    424c:	4581                	li	a1,0
    424e:	854e                	mv	a0,s3
    4250:	75f000ef          	jal	51ae <open>
    4254:	743000ef          	jal	5196 <close>
      close(open(file, 0));
    4258:	4581                	li	a1,0
    425a:	854e                	mv	a0,s3
    425c:	753000ef          	jal	51ae <open>
    4260:	737000ef          	jal	5196 <close>
      close(open(file, 0));
    4264:	4581                	li	a1,0
    4266:	854e                	mv	a0,s3
    4268:	747000ef          	jal	51ae <open>
    426c:	72b000ef          	jal	5196 <close>
      close(open(file, 0));
    4270:	4581                	li	a1,0
    4272:	854e                	mv	a0,s3
    4274:	73b000ef          	jal	51ae <open>
    4278:	71f000ef          	jal	5196 <close>
    if(pid == 0)
    427c:	06090663          	beqz	s2,42e8 <concreate+0x262>
      wait(0);
    4280:	4501                	li	a0,0
    4282:	6f5000ef          	jal	5176 <wait>
  for(i = 0; i < N; i++){
    4286:	2485                	addiw	s1,s1,1
    4288:	0d548163          	beq	s1,s5,434a <concreate+0x2c4>
    file[1] = '0' + i;
    428c:	0304879b          	addiw	a5,s1,48
    4290:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    4294:	6d3000ef          	jal	5166 <fork>
    4298:	892a                	mv	s2,a0
    if(pid < 0){
    429a:	f80543e3          	bltz	a0,4220 <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    429e:	03448733          	mul	a4,s1,s4
    42a2:	9301                	srli	a4,a4,0x20
    42a4:	41f4d79b          	sraiw	a5,s1,0x1f
    42a8:	9f1d                	subw	a4,a4,a5
    42aa:	0017179b          	slliw	a5,a4,0x1
    42ae:	9fb9                	addw	a5,a5,a4
    42b0:	40f487bb          	subw	a5,s1,a5
    42b4:	00a7e733          	or	a4,a5,a0
    42b8:	2701                	sext.w	a4,a4
    42ba:	df2d                	beqz	a4,4234 <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    42bc:	c119                	beqz	a0,42c2 <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    42be:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    42c0:	dbb5                	beqz	a5,4234 <concreate+0x1ae>
      unlink(file);
    42c2:	854e                	mv	a0,s3
    42c4:	6fb000ef          	jal	51be <unlink>
      unlink(file);
    42c8:	854e                	mv	a0,s3
    42ca:	6f5000ef          	jal	51be <unlink>
      unlink(file);
    42ce:	854e                	mv	a0,s3
    42d0:	6ef000ef          	jal	51be <unlink>
      unlink(file);
    42d4:	854e                	mv	a0,s3
    42d6:	6e9000ef          	jal	51be <unlink>
      unlink(file);
    42da:	854e                	mv	a0,s3
    42dc:	6e3000ef          	jal	51be <unlink>
      unlink(file);
    42e0:	854e                	mv	a0,s3
    42e2:	6dd000ef          	jal	51be <unlink>
    42e6:	bf59                	j	427c <concreate+0x1f6>
      exit(0);
    42e8:	4501                	li	a0,0
    42ea:	685000ef          	jal	516e <exit>
      close(fd);
    42ee:	6a9000ef          	jal	5196 <close>
    if(pid == 0) {
    42f2:	b5a1                	j	413a <concreate+0xb4>
      close(fd);
    42f4:	6a3000ef          	jal	5196 <close>
      wait(&xstatus);
    42f8:	8556                	mv	a0,s5
    42fa:	67d000ef          	jal	5176 <wait>
      if(xstatus != 0)
    42fe:	f5c42483          	lw	s1,-164(s0)
    4302:	e2049fe3          	bnez	s1,4140 <concreate+0xba>
  for(i = 0; i < N; i++){
    4306:	2905                	addiw	s2,s2,1
    4308:	e3490fe3          	beq	s2,s4,4146 <concreate+0xc0>
    file[1] = '0' + i;
    430c:	0309079b          	addiw	a5,s2,48
    4310:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4314:	854e                	mv	a0,s3
    4316:	6a9000ef          	jal	51be <unlink>
    pid = fork();
    431a:	64d000ef          	jal	5166 <fork>
    if(pid && (i % 3) == 1){
    431e:	dc0501e3          	beqz	a0,40e0 <concreate+0x5a>
    4322:	036907b3          	mul	a5,s2,s6
    4326:	9381                	srli	a5,a5,0x20
    4328:	41f9571b          	sraiw	a4,s2,0x1f
    432c:	9f99                	subw	a5,a5,a4
    432e:	0017971b          	slliw	a4,a5,0x1
    4332:	9fb9                	addw	a5,a5,a4
    4334:	40f907bb          	subw	a5,s2,a5
    4338:	d9778fe3          	beq	a5,s7,40d6 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    433c:	85e2                	mv	a1,s8
    433e:	854e                	mv	a0,s3
    4340:	66f000ef          	jal	51ae <open>
      if(fd < 0){
    4344:	fa0558e3          	bgez	a0,42f4 <concreate+0x26e>
    4348:	b3f1                	j	4114 <concreate+0x8e>
}
    434a:	4501                	li	a0,0
    434c:	70aa                	ld	ra,168(sp)
    434e:	740a                	ld	s0,160(sp)
    4350:	64ea                	ld	s1,152(sp)
    4352:	694a                	ld	s2,144(sp)
    4354:	69aa                	ld	s3,136(sp)
    4356:	6a0a                	ld	s4,128(sp)
    4358:	7ae6                	ld	s5,120(sp)
    435a:	7b46                	ld	s6,112(sp)
    435c:	7ba6                	ld	s7,104(sp)
    435e:	7c06                	ld	s8,96(sp)
    4360:	6ce6                	ld	s9,88(sp)
    4362:	6d46                	ld	s10,80(sp)
    4364:	614d                	addi	sp,sp,176
    4366:	8082                	ret

0000000000004368 <bigfile>:
{
    4368:	7139                	addi	sp,sp,-64
    436a:	fc06                	sd	ra,56(sp)
    436c:	f822                	sd	s0,48(sp)
    436e:	f426                	sd	s1,40(sp)
    4370:	f04a                	sd	s2,32(sp)
    4372:	ec4e                	sd	s3,24(sp)
    4374:	e852                	sd	s4,16(sp)
    4376:	e456                	sd	s5,8(sp)
    4378:	e05a                	sd	s6,0(sp)
    437a:	0080                	addi	s0,sp,64
    437c:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    437e:	00003517          	auipc	a0,0x3
    4382:	15a50513          	addi	a0,a0,346 # 74d8 <malloc+0x1e5c>
    4386:	639000ef          	jal	51be <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    438a:	20200593          	li	a1,514
    438e:	00003517          	auipc	a0,0x3
    4392:	14a50513          	addi	a0,a0,330 # 74d8 <malloc+0x1e5c>
    4396:	619000ef          	jal	51ae <open>
  if(fd < 0){
    439a:	08054a63          	bltz	a0,442e <bigfile+0xc6>
    439e:	8a2a                	mv	s4,a0
    43a0:	4481                	li	s1,0
    memset(buf, i, SZ);
    43a2:	25800913          	li	s2,600
    43a6:	00008997          	auipc	s3,0x8
    43aa:	91298993          	addi	s3,s3,-1774 # bcb8 <buf>
  for(i = 0; i < N; i++){
    43ae:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    43b0:	864a                	mv	a2,s2
    43b2:	85a6                	mv	a1,s1
    43b4:	854e                	mv	a0,s3
    43b6:	38f000ef          	jal	4f44 <memset>
    if(write(fd, buf, SZ) != SZ){
    43ba:	864a                	mv	a2,s2
    43bc:	85ce                	mv	a1,s3
    43be:	8552                	mv	a0,s4
    43c0:	5cf000ef          	jal	518e <write>
    43c4:	07251f63          	bne	a0,s2,4442 <bigfile+0xda>
  for(i = 0; i < N; i++){
    43c8:	2485                	addiw	s1,s1,1
    43ca:	ff5493e3          	bne	s1,s5,43b0 <bigfile+0x48>
  close(fd);
    43ce:	8552                	mv	a0,s4
    43d0:	5c7000ef          	jal	5196 <close>
  fd = open("bigfile.dat", 0);
    43d4:	4581                	li	a1,0
    43d6:	00003517          	auipc	a0,0x3
    43da:	10250513          	addi	a0,a0,258 # 74d8 <malloc+0x1e5c>
    43de:	5d1000ef          	jal	51ae <open>
    43e2:	8aaa                	mv	s5,a0
  total = 0;
    43e4:	4a01                	li	s4,0
  for(i = 0; ; i++){
    43e6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    43e8:	12c00993          	li	s3,300
    43ec:	00008917          	auipc	s2,0x8
    43f0:	8cc90913          	addi	s2,s2,-1844 # bcb8 <buf>
  if(fd < 0){
    43f4:	06054163          	bltz	a0,4456 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    43f8:	864e                	mv	a2,s3
    43fa:	85ca                	mv	a1,s2
    43fc:	8556                	mv	a0,s5
    43fe:	589000ef          	jal	5186 <read>
    if(cc < 0){
    4402:	06054463          	bltz	a0,446a <bigfile+0x102>
    if(cc == 0)
    4406:	c145                	beqz	a0,44a6 <bigfile+0x13e>
    if(cc != SZ/2){
    4408:	07351b63          	bne	a0,s3,447e <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    440c:	01f4d79b          	srliw	a5,s1,0x1f
    4410:	9fa5                	addw	a5,a5,s1
    4412:	4017d79b          	sraiw	a5,a5,0x1
    4416:	00094703          	lbu	a4,0(s2)
    441a:	06f71c63          	bne	a4,a5,4492 <bigfile+0x12a>
    441e:	12b94703          	lbu	a4,299(s2)
    4422:	06f71863          	bne	a4,a5,4492 <bigfile+0x12a>
    total += cc;
    4426:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    442a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    442c:	b7f1                	j	43f8 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    442e:	85da                	mv	a1,s6
    4430:	00003517          	auipc	a0,0x3
    4434:	0b850513          	addi	a0,a0,184 # 74e8 <malloc+0x1e6c>
    4438:	18c010ef          	jal	55c4 <printf>
    exit(1);
    443c:	4505                	li	a0,1
    443e:	531000ef          	jal	516e <exit>
      printf("%s: write bigfile failed\n", s);
    4442:	85da                	mv	a1,s6
    4444:	00003517          	auipc	a0,0x3
    4448:	0c450513          	addi	a0,a0,196 # 7508 <malloc+0x1e8c>
    444c:	178010ef          	jal	55c4 <printf>
      exit(1);
    4450:	4505                	li	a0,1
    4452:	51d000ef          	jal	516e <exit>
    printf("%s: cannot open bigfile\n", s);
    4456:	85da                	mv	a1,s6
    4458:	00003517          	auipc	a0,0x3
    445c:	0d050513          	addi	a0,a0,208 # 7528 <malloc+0x1eac>
    4460:	164010ef          	jal	55c4 <printf>
    exit(1);
    4464:	4505                	li	a0,1
    4466:	509000ef          	jal	516e <exit>
      printf("%s: read bigfile failed\n", s);
    446a:	85da                	mv	a1,s6
    446c:	00003517          	auipc	a0,0x3
    4470:	0dc50513          	addi	a0,a0,220 # 7548 <malloc+0x1ecc>
    4474:	150010ef          	jal	55c4 <printf>
      exit(1);
    4478:	4505                	li	a0,1
    447a:	4f5000ef          	jal	516e <exit>
      printf("%s: short read bigfile\n", s);
    447e:	85da                	mv	a1,s6
    4480:	00003517          	auipc	a0,0x3
    4484:	0e850513          	addi	a0,a0,232 # 7568 <malloc+0x1eec>
    4488:	13c010ef          	jal	55c4 <printf>
      exit(1);
    448c:	4505                	li	a0,1
    448e:	4e1000ef          	jal	516e <exit>
      printf("%s: read bigfile wrong data\n", s);
    4492:	85da                	mv	a1,s6
    4494:	00003517          	auipc	a0,0x3
    4498:	0ec50513          	addi	a0,a0,236 # 7580 <malloc+0x1f04>
    449c:	128010ef          	jal	55c4 <printf>
      exit(1);
    44a0:	4505                	li	a0,1
    44a2:	4cd000ef          	jal	516e <exit>
  close(fd);
    44a6:	8556                	mv	a0,s5
    44a8:	4ef000ef          	jal	5196 <close>
  if(total != N*SZ){
    44ac:	678d                	lui	a5,0x3
    44ae:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x17a>
    44b2:	02fa1363          	bne	s4,a5,44d8 <bigfile+0x170>
  unlink("bigfile.dat");
    44b6:	00003517          	auipc	a0,0x3
    44ba:	02250513          	addi	a0,a0,34 # 74d8 <malloc+0x1e5c>
    44be:	501000ef          	jal	51be <unlink>
}
    44c2:	4501                	li	a0,0
    44c4:	70e2                	ld	ra,56(sp)
    44c6:	7442                	ld	s0,48(sp)
    44c8:	74a2                	ld	s1,40(sp)
    44ca:	7902                	ld	s2,32(sp)
    44cc:	69e2                	ld	s3,24(sp)
    44ce:	6a42                	ld	s4,16(sp)
    44d0:	6aa2                	ld	s5,8(sp)
    44d2:	6b02                	ld	s6,0(sp)
    44d4:	6121                	addi	sp,sp,64
    44d6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    44d8:	85da                	mv	a1,s6
    44da:	00003517          	auipc	a0,0x3
    44de:	0c650513          	addi	a0,a0,198 # 75a0 <malloc+0x1f24>
    44e2:	0e2010ef          	jal	55c4 <printf>
    exit(1);
    44e6:	4505                	li	a0,1
    44e8:	487000ef          	jal	516e <exit>

00000000000044ec <bigargtest>:
{
    44ec:	7121                	addi	sp,sp,-448
    44ee:	ff06                	sd	ra,440(sp)
    44f0:	fb22                	sd	s0,432(sp)
    44f2:	f726                	sd	s1,424(sp)
    44f4:	0380                	addi	s0,sp,448
    44f6:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    44f8:	00003517          	auipc	a0,0x3
    44fc:	0c850513          	addi	a0,a0,200 # 75c0 <malloc+0x1f44>
    4500:	4bf000ef          	jal	51be <unlink>
  pid = fork();
    4504:	463000ef          	jal	5166 <fork>
  if(pid == 0){
    4508:	c91d                	beqz	a0,453e <bigargtest+0x52>
  } else if(pid < 0){
    450a:	08054d63          	bltz	a0,45a4 <bigargtest+0xb8>
  wait(&xstatus);
    450e:	fdc40513          	addi	a0,s0,-36
    4512:	465000ef          	jal	5176 <wait>
  if(xstatus != 0)
    4516:	fdc42503          	lw	a0,-36(s0)
    451a:	ed59                	bnez	a0,45b8 <bigargtest+0xcc>
  fd = open("bigarg-ok", 0);
    451c:	4581                	li	a1,0
    451e:	00003517          	auipc	a0,0x3
    4522:	0a250513          	addi	a0,a0,162 # 75c0 <malloc+0x1f44>
    4526:	489000ef          	jal	51ae <open>
  if(fd < 0){
    452a:	08054963          	bltz	a0,45bc <bigargtest+0xd0>
  close(fd);
    452e:	469000ef          	jal	5196 <close>
}
    4532:	4501                	li	a0,0
    4534:	70fa                	ld	ra,440(sp)
    4536:	745a                	ld	s0,432(sp)
    4538:	74ba                	ld	s1,424(sp)
    453a:	6139                	addi	sp,sp,448
    453c:	8082                	ret
    memset(big, ' ', sizeof(big));
    453e:	19000613          	li	a2,400
    4542:	02000593          	li	a1,32
    4546:	e4840513          	addi	a0,s0,-440
    454a:	1fb000ef          	jal	4f44 <memset>
    big[sizeof(big)-1] = '\0';
    454e:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4552:	00004797          	auipc	a5,0x4
    4556:	f4e78793          	addi	a5,a5,-178 # 84a0 <args.1>
    455a:	00004697          	auipc	a3,0x4
    455e:	03e68693          	addi	a3,a3,62 # 8598 <args.1+0xf8>
      args[i] = big;
    4562:	e4840713          	addi	a4,s0,-440
    4566:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4568:	07a1                	addi	a5,a5,8
    456a:	fed79ee3          	bne	a5,a3,4566 <bigargtest+0x7a>
    args[MAXARG-1] = 0;
    456e:	00004797          	auipc	a5,0x4
    4572:	0207b523          	sd	zero,42(a5) # 8598 <args.1+0xf8>
    exec("echo", args);
    4576:	00004597          	auipc	a1,0x4
    457a:	f2a58593          	addi	a1,a1,-214 # 84a0 <args.1>
    457e:	00001517          	auipc	a0,0x1
    4582:	22a50513          	addi	a0,a0,554 # 57a8 <malloc+0x12c>
    4586:	421000ef          	jal	51a6 <exec>
    fd = open("bigarg-ok", O_CREATE);
    458a:	20000593          	li	a1,512
    458e:	00003517          	auipc	a0,0x3
    4592:	03250513          	addi	a0,a0,50 # 75c0 <malloc+0x1f44>
    4596:	419000ef          	jal	51ae <open>
    close(fd);
    459a:	3fd000ef          	jal	5196 <close>
    exit(0);
    459e:	4501                	li	a0,0
    45a0:	3cf000ef          	jal	516e <exit>
    printf("%s: bigargtest: fork failed\n", s);
    45a4:	85a6                	mv	a1,s1
    45a6:	00003517          	auipc	a0,0x3
    45aa:	02a50513          	addi	a0,a0,42 # 75d0 <malloc+0x1f54>
    45ae:	016010ef          	jal	55c4 <printf>
    exit(1);
    45b2:	4505                	li	a0,1
    45b4:	3bb000ef          	jal	516e <exit>
    exit(xstatus);
    45b8:	3b7000ef          	jal	516e <exit>
    printf("%s: bigarg test failed!\n", s);
    45bc:	85a6                	mv	a1,s1
    45be:	00003517          	auipc	a0,0x3
    45c2:	03250513          	addi	a0,a0,50 # 75f0 <malloc+0x1f74>
    45c6:	7ff000ef          	jal	55c4 <printf>
    exit(1);
    45ca:	4505                	li	a0,1
    45cc:	3a3000ef          	jal	516e <exit>

00000000000045d0 <lazy_alloc>:
{
    45d0:	1141                	addi	sp,sp,-16
    45d2:	e406                	sd	ra,8(sp)
    45d4:	e022                	sd	s0,0(sp)
    45d6:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    45d8:	40000537          	lui	a0,0x40000
    45dc:	375000ef          	jal	5150 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    45e0:	57fd                	li	a5,-1
    45e2:	02f50c63          	beq	a0,a5,461a <lazy_alloc+0x4a>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    45e6:	6705                	lui	a4,0x1
    45e8:	972a                	add	a4,a4,a0
    45ea:	400017b7          	lui	a5,0x40001
    45ee:	00f506b3          	add	a3,a0,a5
    45f2:	87ba                	mv	a5,a4
    45f4:	00040637          	lui	a2,0x40
    *(char **)i = i;
    45f8:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    45fa:	97b2                	add	a5,a5,a2
    45fc:	fed79ee3          	bne	a5,a3,45f8 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4600:	00040637          	lui	a2,0x40
    if (*(char **)i != i) {
    4604:	631c                	ld	a5,0(a4)
    4606:	02e79363          	bne	a5,a4,462c <lazy_alloc+0x5c>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    460a:	9732                	add	a4,a4,a2
    460c:	fed71ce3          	bne	a4,a3,4604 <lazy_alloc+0x34>
}
    4610:	4501                	li	a0,0
    4612:	60a2                	ld	ra,8(sp)
    4614:	6402                	ld	s0,0(sp)
    4616:	0141                	addi	sp,sp,16
    4618:	8082                	ret
    printf("sbrklazy() failed\n");
    461a:	00003517          	auipc	a0,0x3
    461e:	ff650513          	addi	a0,a0,-10 # 7610 <malloc+0x1f94>
    4622:	7a3000ef          	jal	55c4 <printf>
    exit(1);
    4626:	4505                	li	a0,1
    4628:	347000ef          	jal	516e <exit>
      printf("failed to read value from memory\n");
    462c:	00003517          	auipc	a0,0x3
    4630:	ffc50513          	addi	a0,a0,-4 # 7628 <malloc+0x1fac>
    4634:	791000ef          	jal	55c4 <printf>
      exit(1);
    4638:	4505                	li	a0,1
    463a:	335000ef          	jal	516e <exit>

000000000000463e <lazy_unmap>:
{
    463e:	7139                	addi	sp,sp,-64
    4640:	fc06                	sd	ra,56(sp)
    4642:	f822                	sd	s0,48(sp)
    4644:	f426                	sd	s1,40(sp)
    4646:	f04a                	sd	s2,32(sp)
    4648:	ec4e                	sd	s3,24(sp)
    464a:	e852                	sd	s4,16(sp)
    464c:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    464e:	40000537          	lui	a0,0x40000
    4652:	2ff000ef          	jal	5150 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4656:	57fd                	li	a5,-1
    4658:	04f50a63          	beq	a0,a5,46ac <lazy_unmap+0x6e>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    465c:	6485                	lui	s1,0x1
    465e:	94aa                	add	s1,s1,a0
    4660:	400017b7          	lui	a5,0x40001
    4664:	00f50933          	add	s2,a0,a5
    4668:	87a6                	mv	a5,s1
    466a:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    466e:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4670:	97ba                	add	a5,a5,a4
    4672:	ff279ee3          	bne	a5,s2,466e <lazy_unmap+0x30>
      wait(&status);
    4676:	fcc40a13          	addi	s4,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    467a:	010009b7          	lui	s3,0x1000
    pid = fork();
    467e:	2e9000ef          	jal	5166 <fork>
    if (pid < 0) {
    4682:	02054e63          	bltz	a0,46be <lazy_unmap+0x80>
    } else if (pid == 0) {
    4686:	c529                	beqz	a0,46d0 <lazy_unmap+0x92>
      wait(&status);
    4688:	8552                	mv	a0,s4
    468a:	2ed000ef          	jal	5176 <wait>
      if (status == 0) {
    468e:	fcc42783          	lw	a5,-52(s0)
    4692:	c7b9                	beqz	a5,46e0 <lazy_unmap+0xa2>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4694:	94ce                	add	s1,s1,s3
    4696:	ff2494e3          	bne	s1,s2,467e <lazy_unmap+0x40>
}
    469a:	4501                	li	a0,0
    469c:	70e2                	ld	ra,56(sp)
    469e:	7442                	ld	s0,48(sp)
    46a0:	74a2                	ld	s1,40(sp)
    46a2:	7902                	ld	s2,32(sp)
    46a4:	69e2                	ld	s3,24(sp)
    46a6:	6a42                	ld	s4,16(sp)
    46a8:	6121                	addi	sp,sp,64
    46aa:	8082                	ret
    printf("sbrklazy() failed\n");
    46ac:	00003517          	auipc	a0,0x3
    46b0:	f6450513          	addi	a0,a0,-156 # 7610 <malloc+0x1f94>
    46b4:	711000ef          	jal	55c4 <printf>
    exit(1);
    46b8:	4505                	li	a0,1
    46ba:	2b5000ef          	jal	516e <exit>
      printf("error forking\n");
    46be:	00003517          	auipc	a0,0x3
    46c2:	f9250513          	addi	a0,a0,-110 # 7650 <malloc+0x1fd4>
    46c6:	6ff000ef          	jal	55c4 <printf>
      exit(1);
    46ca:	4505                	li	a0,1
    46cc:	2a3000ef          	jal	516e <exit>
      sbrklazy(-1L * REGION_SZ);
    46d0:	c0000537          	lui	a0,0xc0000
    46d4:	27d000ef          	jal	5150 <sbrklazy>
      *(char **)i = i;
    46d8:	e084                	sd	s1,0(s1)
      exit(0);
    46da:	4501                	li	a0,0
    46dc:	293000ef          	jal	516e <exit>
        printf("memory not unmapped\n");
    46e0:	00003517          	auipc	a0,0x3
    46e4:	f8050513          	addi	a0,a0,-128 # 7660 <malloc+0x1fe4>
    46e8:	6dd000ef          	jal	55c4 <printf>
        exit(1);
    46ec:	4505                	li	a0,1
    46ee:	281000ef          	jal	516e <exit>

00000000000046f2 <lazy_copy>:
{
    46f2:	7119                	addi	sp,sp,-128
    46f4:	fc86                	sd	ra,120(sp)
    46f6:	f8a2                	sd	s0,112(sp)
    46f8:	f4a6                	sd	s1,104(sp)
    46fa:	f0ca                	sd	s2,96(sp)
    46fc:	ecce                	sd	s3,88(sp)
    46fe:	e8d2                	sd	s4,80(sp)
    4700:	e4d6                	sd	s5,72(sp)
    4702:	e0da                	sd	s6,64(sp)
    4704:	fc5e                	sd	s7,56(sp)
    4706:	f862                	sd	s8,48(sp)
    4708:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    470a:	4501                	li	a0,0
    470c:	22f000ef          	jal	513a <sbrk>
    4710:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    4712:	6511                	lui	a0,0x4
    4714:	23d000ef          	jal	5150 <sbrklazy>
    open(p + 8192, 0);
    4718:	4581                	li	a1,0
    471a:	6509                	lui	a0,0x2
    471c:	9526                	add	a0,a0,s1
    471e:	291000ef          	jal	51ae <open>
    void *xx = sbrk(0);
    4722:	4501                	li	a0,0
    4724:	217000ef          	jal	513a <sbrk>
    4728:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    472a:	fff54513          	not	a0,a0
    472e:	2501                	sext.w	a0,a0
    4730:	20b000ef          	jal	513a <sbrk>
    if(ret != xx){
    4734:	0aa49a63          	bne	s1,a0,47e8 <lazy_copy+0xf6>
  unsigned long bad[] = {
    4738:	00003797          	auipc	a5,0x3
    473c:	5d878793          	addi	a5,a5,1496 # 7d10 <malloc+0x2694>
    4740:	7fa8                	ld	a0,120(a5)
    4742:	63cc                	ld	a1,128(a5)
    4744:	67d0                	ld	a2,136(a5)
    4746:	6bd4                	ld	a3,144(a5)
    4748:	6fd8                	ld	a4,152(a5)
    474a:	f8a43023          	sd	a0,-128(s0)
    474e:	f8b43423          	sd	a1,-120(s0)
    4752:	f8c43823          	sd	a2,-112(s0)
    4756:	f8d43c23          	sd	a3,-104(s0)
    475a:	fae43023          	sd	a4,-96(s0)
    475e:	73dc                	ld	a5,160(a5)
    4760:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4764:	f8040913          	addi	s2,s0,-128
    4768:	fb040c13          	addi	s8,s0,-80
    int fd = open("README", 0);
    476c:	00001a97          	auipc	s5,0x1
    4770:	214a8a93          	addi	s5,s5,532 # 5980 <malloc+0x304>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4774:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4778:	60200b93          	li	s7,1538
    477c:	00001b17          	auipc	s6,0x1
    4780:	114b0b13          	addi	s6,s6,276 # 5890 <malloc+0x214>
    int fd = open("README", 0);
    4784:	4581                	li	a1,0
    4786:	8556                	mv	a0,s5
    4788:	227000ef          	jal	51ae <open>
    478c:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    478e:	06054763          	bltz	a0,47fc <lazy_copy+0x10a>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4792:	00093983          	ld	s3,0(s2)
    4796:	8652                	mv	a2,s4
    4798:	85ce                	mv	a1,s3
    479a:	1ed000ef          	jal	5186 <read>
    479e:	06055863          	bgez	a0,480e <lazy_copy+0x11c>
    close(fd);
    47a2:	8526                	mv	a0,s1
    47a4:	1f3000ef          	jal	5196 <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    47a8:	85de                	mv	a1,s7
    47aa:	855a                	mv	a0,s6
    47ac:	203000ef          	jal	51ae <open>
    47b0:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    47b2:	06054763          	bltz	a0,4820 <lazy_copy+0x12e>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    47b6:	8652                	mv	a2,s4
    47b8:	85ce                	mv	a1,s3
    47ba:	1d5000ef          	jal	518e <write>
    47be:	06055a63          	bgez	a0,4832 <lazy_copy+0x140>
    close(fd);
    47c2:	8526                	mv	a0,s1
    47c4:	1d3000ef          	jal	5196 <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    47c8:	0921                	addi	s2,s2,8
    47ca:	fb891de3          	bne	s2,s8,4784 <lazy_copy+0x92>
}
    47ce:	4501                	li	a0,0
    47d0:	70e6                	ld	ra,120(sp)
    47d2:	7446                	ld	s0,112(sp)
    47d4:	74a6                	ld	s1,104(sp)
    47d6:	7906                	ld	s2,96(sp)
    47d8:	69e6                	ld	s3,88(sp)
    47da:	6a46                	ld	s4,80(sp)
    47dc:	6aa6                	ld	s5,72(sp)
    47de:	6b06                	ld	s6,64(sp)
    47e0:	7be2                	ld	s7,56(sp)
    47e2:	7c42                	ld	s8,48(sp)
    47e4:	6109                	addi	sp,sp,128
    47e6:	8082                	ret
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    47e8:	85aa                	mv	a1,a0
    47ea:	00003517          	auipc	a0,0x3
    47ee:	e8e50513          	addi	a0,a0,-370 # 7678 <malloc+0x1ffc>
    47f2:	5d3000ef          	jal	55c4 <printf>
      exit(1);
    47f6:	4505                	li	a0,1
    47f8:	177000ef          	jal	516e <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    47fc:	00003517          	auipc	a0,0x3
    4800:	eac50513          	addi	a0,a0,-340 # 76a8 <malloc+0x202c>
    4804:	5c1000ef          	jal	55c4 <printf>
    4808:	4505                	li	a0,1
    480a:	165000ef          	jal	516e <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    480e:	00003517          	auipc	a0,0x3
    4812:	eb250513          	addi	a0,a0,-334 # 76c0 <malloc+0x2044>
    4816:	5af000ef          	jal	55c4 <printf>
    481a:	4505                	li	a0,1
    481c:	153000ef          	jal	516e <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4820:	00003517          	auipc	a0,0x3
    4824:	eb050513          	addi	a0,a0,-336 # 76d0 <malloc+0x2054>
    4828:	59d000ef          	jal	55c4 <printf>
    482c:	4505                	li	a0,1
    482e:	141000ef          	jal	516e <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4832:	00003517          	auipc	a0,0x3
    4836:	eb650513          	addi	a0,a0,-330 # 76e8 <malloc+0x206c>
    483a:	58b000ef          	jal	55c4 <printf>
    483e:	4505                	li	a0,1
    4840:	12f000ef          	jal	516e <exit>

0000000000004844 <lazy_sbrk>:
{
    4844:	7179                	addi	sp,sp,-48
    4846:	f406                	sd	ra,40(sp)
    4848:	f022                	sd	s0,32(sp)
    484a:	ec26                	sd	s1,24(sp)
    484c:	e84a                	sd	s2,16(sp)
    484e:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4850:	4501                	li	a0,0
    4852:	0e9000ef          	jal	513a <sbrk>
    4856:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4858:	0ff00793          	li	a5,255
    485c:	07fa                	slli	a5,a5,0x1e
    485e:	02f57063          	bgeu	a0,a5,487e <lazy_sbrk+0x3a>
    4862:	e44e                	sd	s3,8(sp)
    p = sbrklazy(1<<30);
    4864:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA-(1<<30)) {
    4868:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    486a:	854e                	mv	a0,s3
    486c:	0e5000ef          	jal	5150 <sbrklazy>
    p = sbrklazy(0);
    4870:	4501                	li	a0,0
    4872:	0df000ef          	jal	5150 <sbrklazy>
    4876:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4878:	ff2569e3          	bltu	a0,s2,486a <lazy_sbrk+0x26>
    487c:	69a2                	ld	s3,8(sp)
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    487e:	7975                	lui	s2,0xffffd
    4880:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4884:	854a                	mv	a0,s2
    4886:	0cb000ef          	jal	5150 <sbrklazy>
  if (p1 < 0 || p1 != p) {
    488a:	04951863          	bne	a0,s1,48da <lazy_sbrk+0x96>
  p = sbrk(PGSIZE);
    488e:	6505                	lui	a0,0x1
    4890:	0ab000ef          	jal	513a <sbrk>
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    4894:	040007b7          	lui	a5,0x4000
    4898:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    489a:	07b2                	slli	a5,a5,0xc
    489c:	04f51c63          	bne	a0,a5,48f4 <lazy_sbrk+0xb0>
  p[0] = 1;
    48a0:	040007b7          	lui	a5,0x4000
    48a4:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    48a6:	07b2                	slli	a5,a5,0xc
    48a8:	4705                	li	a4,1
    48aa:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    48ae:	0017c783          	lbu	a5,1(a5)
    48b2:	efa9                	bnez	a5,490c <lazy_sbrk+0xc8>
  p = sbrk(1);
    48b4:	4505                	li	a0,1
    48b6:	085000ef          	jal	513a <sbrk>
  if ((uint64)p != -1) {
    48ba:	57fd                	li	a5,-1
    48bc:	06f51263          	bne	a0,a5,4920 <lazy_sbrk+0xdc>
  p = sbrklazy(1);
    48c0:	4505                	li	a0,1
    48c2:	08f000ef          	jal	5150 <sbrklazy>
  if ((uint64)p != -1) {
    48c6:	57fd                	li	a5,-1
    48c8:	06f51763          	bne	a0,a5,4936 <lazy_sbrk+0xf2>
}
    48cc:	4501                	li	a0,0
    48ce:	70a2                	ld	ra,40(sp)
    48d0:	7402                	ld	s0,32(sp)
    48d2:	64e2                	ld	s1,24(sp)
    48d4:	6942                	ld	s2,16(sp)
    48d6:	6145                	addi	sp,sp,48
    48d8:	8082                	ret
    48da:	e44e                	sd	s3,8(sp)
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    48dc:	86a6                	mv	a3,s1
    48de:	862a                	mv	a2,a0
    48e0:	85ca                	mv	a1,s2
    48e2:	00003517          	auipc	a0,0x3
    48e6:	e1e50513          	addi	a0,a0,-482 # 7700 <malloc+0x2084>
    48ea:	4db000ef          	jal	55c4 <printf>
    exit(1);
    48ee:	4505                	li	a0,1
    48f0:	07f000ef          	jal	516e <exit>
    48f4:	e44e                	sd	s3,8(sp)
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    48f6:	862a                	mv	a2,a0
    48f8:	6585                	lui	a1,0x1
    48fa:	00003517          	auipc	a0,0x3
    48fe:	e3650513          	addi	a0,a0,-458 # 7730 <malloc+0x20b4>
    4902:	4c3000ef          	jal	55c4 <printf>
    exit(1);
    4906:	4505                	li	a0,1
    4908:	067000ef          	jal	516e <exit>
    490c:	e44e                	sd	s3,8(sp)
    printf("sbrk() returned non-zero-filled memory\n");
    490e:	00003517          	auipc	a0,0x3
    4912:	e5a50513          	addi	a0,a0,-422 # 7768 <malloc+0x20ec>
    4916:	4af000ef          	jal	55c4 <printf>
    exit(1);
    491a:	4505                	li	a0,1
    491c:	053000ef          	jal	516e <exit>
    4920:	e44e                	sd	s3,8(sp)
    printf("sbrk(1) returned %p, expected error\n", p);
    4922:	85aa                	mv	a1,a0
    4924:	00003517          	auipc	a0,0x3
    4928:	e6c50513          	addi	a0,a0,-404 # 7790 <malloc+0x2114>
    492c:	499000ef          	jal	55c4 <printf>
    exit(1);
    4930:	4505                	li	a0,1
    4932:	03d000ef          	jal	516e <exit>
    4936:	e44e                	sd	s3,8(sp)
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4938:	85aa                	mv	a1,a0
    493a:	00003517          	auipc	a0,0x3
    493e:	e7e50513          	addi	a0,a0,-386 # 77b8 <malloc+0x213c>
    4942:	483000ef          	jal	55c4 <printf>
    exit(1);
    4946:	4505                	li	a0,1
    4948:	027000ef          	jal	516e <exit>

000000000000494c <fsfull>:
{
    494c:	7171                	addi	sp,sp,-176
    494e:	f506                	sd	ra,168(sp)
    4950:	f122                	sd	s0,160(sp)
    4952:	ed26                	sd	s1,152(sp)
    4954:	e94a                	sd	s2,144(sp)
    4956:	e54e                	sd	s3,136(sp)
    4958:	e152                	sd	s4,128(sp)
    495a:	fcd6                	sd	s5,120(sp)
    495c:	f8da                	sd	s6,112(sp)
    495e:	f4de                	sd	s7,104(sp)
    4960:	f0e2                	sd	s8,96(sp)
    4962:	ece6                	sd	s9,88(sp)
    4964:	e8ea                	sd	s10,80(sp)
    4966:	e4ee                	sd	s11,72(sp)
    4968:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    496a:	00003517          	auipc	a0,0x3
    496e:	e7e50513          	addi	a0,a0,-386 # 77e8 <malloc+0x216c>
    4972:	453000ef          	jal	55c4 <printf>
  for(nfiles = 0; ; nfiles++){
    4976:	4481                	li	s1,0
    name[0] = 'f';
    4978:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    497c:	10625cb7          	lui	s9,0x10625
    4980:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061611b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4984:	51eb8ab7          	lui	s5,0x51eb8
    4988:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea9867>
    name[3] = '0' + (nfiles % 100) / 10;
    498c:	66666a37          	lui	s4,0x66666
    4990:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579af>
    printf("writing %s\n", name);
    4994:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4998:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    499c:	039487b3          	mul	a5,s1,s9
    49a0:	9799                	srai	a5,a5,0x26
    49a2:	41f4d69b          	sraiw	a3,s1,0x1f
    49a6:	9f95                	subw	a5,a5,a3
    49a8:	0307871b          	addiw	a4,a5,48
    49ac:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    49b0:	3e800713          	li	a4,1000
    49b4:	02f707bb          	mulw	a5,a4,a5
    49b8:	40f487bb          	subw	a5,s1,a5
    49bc:	03578733          	mul	a4,a5,s5
    49c0:	9715                	srai	a4,a4,0x25
    49c2:	41f7d79b          	sraiw	a5,a5,0x1f
    49c6:	40f707bb          	subw	a5,a4,a5
    49ca:	0307879b          	addiw	a5,a5,48
    49ce:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    49d2:	035487b3          	mul	a5,s1,s5
    49d6:	9795                	srai	a5,a5,0x25
    49d8:	9f95                	subw	a5,a5,a3
    49da:	06400713          	li	a4,100
    49de:	02f707bb          	mulw	a5,a4,a5
    49e2:	40f487bb          	subw	a5,s1,a5
    49e6:	03478733          	mul	a4,a5,s4
    49ea:	9709                	srai	a4,a4,0x22
    49ec:	41f7d79b          	sraiw	a5,a5,0x1f
    49f0:	40f707bb          	subw	a5,a4,a5
    49f4:	0307879b          	addiw	a5,a5,48
    49f8:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    49fc:	03448733          	mul	a4,s1,s4
    4a00:	9709                	srai	a4,a4,0x22
    4a02:	9f15                	subw	a4,a4,a3
    4a04:	0027179b          	slliw	a5,a4,0x2
    4a08:	9fb9                	addw	a5,a5,a4
    4a0a:	0017979b          	slliw	a5,a5,0x1
    4a0e:	40f487bb          	subw	a5,s1,a5
    4a12:	0307879b          	addiw	a5,a5,48
    4a16:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4a1a:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4a1e:	85ea                	mv	a1,s10
    4a20:	00003517          	auipc	a0,0x3
    4a24:	dd850513          	addi	a0,a0,-552 # 77f8 <malloc+0x217c>
    4a28:	39d000ef          	jal	55c4 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4a2c:	20200593          	li	a1,514
    4a30:	856a                	mv	a0,s10
    4a32:	77c000ef          	jal	51ae <open>
    4a36:	892a                	mv	s2,a0
    if(fd < 0){
    4a38:	0e055c63          	bgez	a0,4b30 <fsfull+0x1e4>
      printf("open %s failed\n", name);
    4a3c:	f5040593          	addi	a1,s0,-176
    4a40:	00003517          	auipc	a0,0x3
    4a44:	dc850513          	addi	a0,a0,-568 # 7808 <malloc+0x218c>
    4a48:	37d000ef          	jal	55c4 <printf>
  while(nfiles >= 0){
    4a4c:	0a04cc63          	bltz	s1,4b04 <fsfull+0x1b8>
    name[0] = 'f';
    4a50:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    4a54:	10625a37          	lui	s4,0x10625
    4a58:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061611b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4a5c:	3e800b93          	li	s7,1000
    4a60:	51eb89b7          	lui	s3,0x51eb8
    4a64:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea9867>
    name[3] = '0' + (nfiles % 100) / 10;
    4a68:	06400b13          	li	s6,100
    4a6c:	66666937          	lui	s2,0x66666
    4a70:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579af>
    unlink(name);
    4a74:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    4a78:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4a7c:	034487b3          	mul	a5,s1,s4
    4a80:	9799                	srai	a5,a5,0x26
    4a82:	41f4d69b          	sraiw	a3,s1,0x1f
    4a86:	9f95                	subw	a5,a5,a3
    4a88:	0307871b          	addiw	a4,a5,48
    4a8c:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a90:	02fb87bb          	mulw	a5,s7,a5
    4a94:	40f487bb          	subw	a5,s1,a5
    4a98:	03378733          	mul	a4,a5,s3
    4a9c:	9715                	srai	a4,a4,0x25
    4a9e:	41f7d79b          	sraiw	a5,a5,0x1f
    4aa2:	40f707bb          	subw	a5,a4,a5
    4aa6:	0307879b          	addiw	a5,a5,48
    4aaa:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4aae:	033487b3          	mul	a5,s1,s3
    4ab2:	9795                	srai	a5,a5,0x25
    4ab4:	9f95                	subw	a5,a5,a3
    4ab6:	02fb07bb          	mulw	a5,s6,a5
    4aba:	40f487bb          	subw	a5,s1,a5
    4abe:	03278733          	mul	a4,a5,s2
    4ac2:	9709                	srai	a4,a4,0x22
    4ac4:	41f7d79b          	sraiw	a5,a5,0x1f
    4ac8:	40f707bb          	subw	a5,a4,a5
    4acc:	0307879b          	addiw	a5,a5,48
    4ad0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ad4:	03248733          	mul	a4,s1,s2
    4ad8:	9709                	srai	a4,a4,0x22
    4ada:	9f15                	subw	a4,a4,a3
    4adc:	0027179b          	slliw	a5,a4,0x2
    4ae0:	9fb9                	addw	a5,a5,a4
    4ae2:	0017979b          	slliw	a5,a5,0x1
    4ae6:	40f487bb          	subw	a5,s1,a5
    4aea:	0307879b          	addiw	a5,a5,48
    4aee:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4af2:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4af6:	8556                	mv	a0,s5
    4af8:	6c6000ef          	jal	51be <unlink>
    nfiles--;
    4afc:	34fd                	addiw	s1,s1,-1 # fff <bigdir+0xdd>
  while(nfiles >= 0){
    4afe:	57fd                	li	a5,-1
    4b00:	f6f49ce3          	bne	s1,a5,4a78 <fsfull+0x12c>
  printf("fsfull test finished\n");
    4b04:	00003517          	auipc	a0,0x3
    4b08:	d2450513          	addi	a0,a0,-732 # 7828 <malloc+0x21ac>
    4b0c:	2b9000ef          	jal	55c4 <printf>
}
    4b10:	4501                	li	a0,0
    4b12:	70aa                	ld	ra,168(sp)
    4b14:	740a                	ld	s0,160(sp)
    4b16:	64ea                	ld	s1,152(sp)
    4b18:	694a                	ld	s2,144(sp)
    4b1a:	69aa                	ld	s3,136(sp)
    4b1c:	6a0a                	ld	s4,128(sp)
    4b1e:	7ae6                	ld	s5,120(sp)
    4b20:	7b46                	ld	s6,112(sp)
    4b22:	7ba6                	ld	s7,104(sp)
    4b24:	7c06                	ld	s8,96(sp)
    4b26:	6ce6                	ld	s9,88(sp)
    4b28:	6d46                	ld	s10,80(sp)
    4b2a:	6da6                	ld	s11,72(sp)
    4b2c:	614d                	addi	sp,sp,176
    4b2e:	8082                	ret
    int total = 0;
    4b30:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4b32:	40000c13          	li	s8,1024
    4b36:	00007b97          	auipc	s7,0x7
    4b3a:	182b8b93          	addi	s7,s7,386 # bcb8 <buf>
      if(cc < BSIZE)
    4b3e:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    4b42:	8662                	mv	a2,s8
    4b44:	85de                	mv	a1,s7
    4b46:	854a                	mv	a0,s2
    4b48:	646000ef          	jal	518e <write>
      if(cc < BSIZE)
    4b4c:	00ab5563          	bge	s6,a0,4b56 <fsfull+0x20a>
      total += cc;
    4b50:	00a989bb          	addw	s3,s3,a0
    while(1){
    4b54:	b7fd                	j	4b42 <fsfull+0x1f6>
    printf("wrote %d bytes\n", total);
    4b56:	85ce                	mv	a1,s3
    4b58:	00003517          	auipc	a0,0x3
    4b5c:	cc050513          	addi	a0,a0,-832 # 7818 <malloc+0x219c>
    4b60:	265000ef          	jal	55c4 <printf>
    close(fd);
    4b64:	854a                	mv	a0,s2
    4b66:	630000ef          	jal	5196 <close>
    if(total == 0)
    4b6a:	ee0981e3          	beqz	s3,4a4c <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    4b6e:	2485                	addiw	s1,s1,1
    4b70:	b525                	j	4998 <fsfull+0x4c>

0000000000004b72 <run>:
//

// run each test in its own process. run returns the child's raw exit status:
//   0 => test passed, 1 => test failed, any other value => unexpected / need review.
int
run(int f(char *), char *s) {
    4b72:	7179                	addi	sp,sp,-48
    4b74:	f406                	sd	ra,40(sp)
    4b76:	f022                	sd	s0,32(sp)
    4b78:	ec26                	sd	s1,24(sp)
    4b7a:	e84a                	sd	s2,16(sp)
    4b7c:	1800                	addi	s0,sp,48
    4b7e:	84aa                	mv	s1,a0
    4b80:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4b82:	00003517          	auipc	a0,0x3
    4b86:	cbe50513          	addi	a0,a0,-834 # 7840 <malloc+0x21c4>
    4b8a:	23b000ef          	jal	55c4 <printf>
  if((pid = fork()) < 0) {
    4b8e:	5d8000ef          	jal	5166 <fork>
    4b92:	02054b63          	bltz	a0,4bc8 <run+0x56>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4b96:	c131                	beqz	a0,4bda <run+0x68>
    int result = f(s);
    exit(result);
  } else {
    wait(&xstatus);
    4b98:	fdc40513          	addi	a0,s0,-36
    4b9c:	5da000ef          	jal	5176 <wait>
    if (xstatus == 0) printf("PASS\n");
    4ba0:	fdc42783          	lw	a5,-36(s0)
    4ba4:	cf9d                	beqz	a5,4be2 <run+0x70>
    else if (xstatus == 1) printf("FAIL\n");
    4ba6:	4705                	li	a4,1
    4ba8:	04e78463          	beq	a5,a4,4bf0 <run+0x7e>
    else printf("NEED REVIEW\n");
    4bac:	00003517          	auipc	a0,0x3
    4bb0:	ccc50513          	addi	a0,a0,-820 # 7878 <malloc+0x21fc>
    4bb4:	211000ef          	jal	55c4 <printf>
    return xstatus;
  }
}
    4bb8:	fdc42503          	lw	a0,-36(s0)
    4bbc:	70a2                	ld	ra,40(sp)
    4bbe:	7402                	ld	s0,32(sp)
    4bc0:	64e2                	ld	s1,24(sp)
    4bc2:	6942                	ld	s2,16(sp)
    4bc4:	6145                	addi	sp,sp,48
    4bc6:	8082                	ret
    printf("runtest: fork error\n");
    4bc8:	00003517          	auipc	a0,0x3
    4bcc:	c8850513          	addi	a0,a0,-888 # 7850 <malloc+0x21d4>
    4bd0:	1f5000ef          	jal	55c4 <printf>
    exit(1);
    4bd4:	4505                	li	a0,1
    4bd6:	598000ef          	jal	516e <exit>
    int result = f(s);
    4bda:	854a                	mv	a0,s2
    4bdc:	9482                	jalr	s1
    exit(result);
    4bde:	590000ef          	jal	516e <exit>
    if (xstatus == 0) printf("PASS\n");
    4be2:	00003517          	auipc	a0,0x3
    4be6:	c8650513          	addi	a0,a0,-890 # 7868 <malloc+0x21ec>
    4bea:	1db000ef          	jal	55c4 <printf>
    4bee:	b7e9                	j	4bb8 <run+0x46>
    else if (xstatus == 1) printf("FAIL\n");
    4bf0:	00003517          	auipc	a0,0x3
    4bf4:	c8050513          	addi	a0,a0,-896 # 7870 <malloc+0x21f4>
    4bf8:	1cd000ef          	jal	55c4 <printf>
    4bfc:	bf75                	j	4bb8 <run+0x46>

0000000000004bfe <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4bfe:	7179                	addi	sp,sp,-48
    4c00:	f406                	sd	ra,40(sp)
    4c02:	f022                	sd	s0,32(sp)
    4c04:	ec26                	sd	s1,24(sp)
    4c06:	e84a                	sd	s2,16(sp)
    4c08:	1800                	addi	s0,sp,48
    4c0a:	84aa                	mv	s1,a0
  int result = -1;
  for (struct test *t = tests; t->s != 0; t++) {
    4c0c:	6508                	ld	a0,8(a0)
    4c0e:	c125                	beqz	a0,4c6e <runtests+0x70>
    4c10:	e44e                	sd	s3,8(sp)
    4c12:	e052                	sd	s4,0(sp)
    4c14:	89ae                	mv	s3,a1
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      int tmp_result = run(t->f, t->s);
      if (tmp_result < 0) tmp_result = 1;
      if (result < tmp_result) result = tmp_result;
      if (result > 0 && continuous != 2) {
    4c16:	1679                	addi	a2,a2,-2 # 3fffe <base+0x31346>
    4c18:	00c03a33          	snez	s4,a2
  int result = -1;
    4c1c:	597d                	li	s2,-1
    4c1e:	a031                	j	4c2a <runtests+0x2c>
      if (tmp_result < 0) tmp_result = 1;
    4c20:	4505                	li	a0,1
    4c22:	a005                	j	4c42 <runtests+0x44>
  for (struct test *t = tests; t->s != 0; t++) {
    4c24:	04c1                	addi	s1,s1,16
    4c26:	6488                	ld	a0,8(s1)
    4c28:	c915                	beqz	a0,4c5c <runtests+0x5e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4c2a:	00098663          	beqz	s3,4c36 <runtests+0x38>
    4c2e:	85ce                	mv	a1,s3
    4c30:	2b8000ef          	jal	4ee8 <strcmp>
    4c34:	f965                	bnez	a0,4c24 <runtests+0x26>
      int tmp_result = run(t->f, t->s);
    4c36:	648c                	ld	a1,8(s1)
    4c38:	6088                	ld	a0,0(s1)
    4c3a:	f39ff0ef          	jal	4b72 <run>
      if (tmp_result < 0) tmp_result = 1;
    4c3e:	fe0541e3          	bltz	a0,4c20 <runtests+0x22>
      if (result < tmp_result) result = tmp_result;
    4c42:	87aa                	mv	a5,a0
    4c44:	01255363          	bge	a0,s2,4c4a <runtests+0x4c>
    4c48:	87ca                	mv	a5,s2
    4c4a:	0007891b          	sext.w	s2,a5
      if (result > 0 && continuous != 2) {
    4c4e:	fd205be3          	blez	s2,4c24 <runtests+0x26>
    4c52:	fc0a09e3          	beqz	s4,4c24 <runtests+0x26>
    4c56:	69a2                	ld	s3,8(sp)
    4c58:	6a02                	ld	s4,0(sp)
    4c5a:	a019                	j	4c60 <runtests+0x62>
    4c5c:	69a2                	ld	s3,8(sp)
    4c5e:	6a02                	ld	s4,0(sp)
        return result;
      }
    }
  }
  return result;
}
    4c60:	854a                	mv	a0,s2
    4c62:	70a2                	ld	ra,40(sp)
    4c64:	7402                	ld	s0,32(sp)
    4c66:	64e2                	ld	s1,24(sp)
    4c68:	6942                	ld	s2,16(sp)
    4c6a:	6145                	addi	sp,sp,48
    4c6c:	8082                	ret
  return result;
    4c6e:	597d                	li	s2,-1
    4c70:	bfc5                	j	4c60 <runtests+0x62>

0000000000004c72 <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4c72:	7179                	addi	sp,sp,-48
    4c74:	f406                	sd	ra,40(sp)
    4c76:	f022                	sd	s0,32(sp)
    4c78:	ec26                	sd	s1,24(sp)
    4c7a:	e84a                	sd	s2,16(sp)
    4c7c:	e44e                	sd	s3,8(sp)
    4c7e:	e052                	sd	s4,0(sp)
    4c80:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4c82:	4501                	li	a0,0
    4c84:	4b6000ef          	jal	513a <sbrk>
    4c88:	8a2a                	mv	s4,a0
  int n = 0;
    4c8a:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    4c8c:	6985                	lui	s3,0x1
    if(a == SBRK_ERROR){
    4c8e:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    4c90:	854e                	mv	a0,s3
    4c92:	4a8000ef          	jal	513a <sbrk>
    if(a == SBRK_ERROR){
    4c96:	01250463          	beq	a0,s2,4c9e <countfree+0x2c>
      break;
    }
    n += 1;
    4c9a:	2485                	addiw	s1,s1,1
  while(1){
    4c9c:	bfd5                	j	4c90 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    4c9e:	4501                	li	a0,0
    4ca0:	49a000ef          	jal	513a <sbrk>
    4ca4:	40aa053b          	subw	a0,s4,a0
    4ca8:	492000ef          	jal	513a <sbrk>
  return n;
}
    4cac:	8526                	mv	a0,s1
    4cae:	70a2                	ld	ra,40(sp)
    4cb0:	7402                	ld	s0,32(sp)
    4cb2:	64e2                	ld	s1,24(sp)
    4cb4:	6942                	ld	s2,16(sp)
    4cb6:	69a2                	ld	s3,8(sp)
    4cb8:	6a02                	ld	s4,0(sp)
    4cba:	6145                	addi	sp,sp,48
    4cbc:	8082                	ret

0000000000004cbe <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4cbe:	7159                	addi	sp,sp,-112
    4cc0:	f486                	sd	ra,104(sp)
    4cc2:	f0a2                	sd	s0,96(sp)
    4cc4:	eca6                	sd	s1,88(sp)
    4cc6:	e8ca                	sd	s2,80(sp)
    4cc8:	e4ce                	sd	s3,72(sp)
    4cca:	e0d2                	sd	s4,64(sp)
    4ccc:	fc56                	sd	s5,56(sp)
    4cce:	f85a                	sd	s6,48(sp)
    4cd0:	f45e                	sd	s7,40(sp)
    4cd2:	f062                	sd	s8,32(sp)
    4cd4:	ec66                	sd	s9,24(sp)
    4cd6:	e86a                	sd	s10,16(sp)
    4cd8:	e46e                	sd	s11,8(sp)
    4cda:	1880                	addi	s0,sp,112
    4cdc:	8aaa                	mv	s5,a0
    4cde:	89ae                	mv	s3,a1
    4ce0:	8a32                	mv	s4,a2
    printf("usertests starting\n");
    int free0 = countfree();
    int free1 = 0;
    int result = runtests(quicktests, justone, continuous);

    if (result > 0 && continuous != 2) return result;
    4ce2:	ffe58b13          	addi	s6,a1,-2 # ffe <bigdir+0xdc>
    4ce6:	01603b33          	snez	s6,s6
      if (result != -1 && result < 2) result = 2;
      if (result > 0 && continuous != 2) {
        return result;
      }
    }
    if (justone != 0 && result == -1) {
    4cea:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4cee:	00003c17          	auipc	s8,0x3
    4cf2:	b9ac0c13          	addi	s8,s8,-1126 # 7888 <malloc+0x220c>
    int result = runtests(quicktests, justone, continuous);
    4cf6:	00003b97          	auipc	s7,0x3
    4cfa:	31ab8b93          	addi	s7,s7,794 # 8010 <quicktests>
      int tmp_result = runtests(slowtests, justone, continuous);
    4cfe:	00003c97          	auipc	s9,0x3
    4d02:	722c8c93          	addi	s9,s9,1826 # 8420 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4d06:	00003d97          	auipc	s11,0x3
    4d0a:	bbad8d93          	addi	s11,s11,-1094 # 78c0 <malloc+0x2244>
    4d0e:	a015                	j	4d32 <drivetests+0x74>
        printf("usertests slow tests starting\n");
    4d10:	00003517          	auipc	a0,0x3
    4d14:	b9050513          	addi	a0,a0,-1136 # 78a0 <malloc+0x2224>
    4d18:	0ad000ef          	jal	55c4 <printf>
    4d1c:	a83d                	j	4d5a <drivetests+0x9c>
    if((free1 = countfree()) < free0) {
    4d1e:	f55ff0ef          	jal	4c72 <countfree>
    4d22:	05254c63          	blt	a0,s2,4d7a <drivetests+0xbc>
    if (justone != 0 && result == -1) {
    4d26:	0485                	addi	s1,s1,1
    4d28:	e099                	bnez	s1,4d2e <drivetests+0x70>
    4d2a:	060d1d63          	bnez	s10,4da4 <drivetests+0xe6>
      printf("NO TESTS EXECUTED\n");
      return -1;
    }
  } while(continuous);
    4d2e:	0a098263          	beqz	s3,4dd2 <drivetests+0x114>
    printf("usertests starting\n");
    4d32:	8562                	mv	a0,s8
    4d34:	091000ef          	jal	55c4 <printf>
    int free0 = countfree();
    4d38:	f3bff0ef          	jal	4c72 <countfree>
    4d3c:	892a                	mv	s2,a0
    int result = runtests(quicktests, justone, continuous);
    4d3e:	864e                	mv	a2,s3
    4d40:	85d2                	mv	a1,s4
    4d42:	855e                	mv	a0,s7
    4d44:	ebbff0ef          	jal	4bfe <runtests>
    4d48:	84aa                	mv	s1,a0
    if (result > 0 && continuous != 2) return result;
    4d4a:	00a05463          	blez	a0,4d52 <drivetests+0x94>
    4d4e:	060b1263          	bnez	s6,4db2 <drivetests+0xf4>
    if(!quick) {
    4d52:	fc0a96e3          	bnez	s5,4d1e <drivetests+0x60>
      if (justone == 0)
    4d56:	fa0a0de3          	beqz	s4,4d10 <drivetests+0x52>
      int tmp_result = runtests(slowtests, justone, continuous);
    4d5a:	864e                	mv	a2,s3
    4d5c:	85d2                	mv	a1,s4
    4d5e:	8566                	mv	a0,s9
    4d60:	e9fff0ef          	jal	4bfe <runtests>
      if (result < tmp_result) result = tmp_result;
    4d64:	87a6                	mv	a5,s1
    4d66:	00a4d363          	bge	s1,a0,4d6c <drivetests+0xae>
    4d6a:	87aa                	mv	a5,a0
    4d6c:	0007849b          	sext.w	s1,a5
      if (result > 0 && continuous != 2) return result;
    4d70:	fa9057e3          	blez	s1,4d1e <drivetests+0x60>
    4d74:	fa0b05e3          	beqz	s6,4d1e <drivetests+0x60>
    4d78:	a82d                	j	4db2 <drivetests+0xf4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4d7a:	864a                	mv	a2,s2
    4d7c:	85aa                	mv	a1,a0
    4d7e:	856e                	mv	a0,s11
    4d80:	045000ef          	jal	55c4 <printf>
      if (result != -1 && result < 2) result = 2;
    4d84:	00148793          	addi	a5,s1,1
    4d88:	cb89                	beqz	a5,4d9a <drivetests+0xdc>
    4d8a:	0024a793          	slti	a5,s1,2
    4d8e:	c791                	beqz	a5,4d9a <drivetests+0xdc>
      if (result > 0 && continuous != 2) {
    4d90:	4789                	li	a5,2
    4d92:	faf980e3          	beq	s3,a5,4d32 <drivetests+0x74>
      if (result != -1 && result < 2) result = 2;
    4d96:	4489                	li	s1,2
    4d98:	a829                	j	4db2 <drivetests+0xf4>
      if (result > 0 && continuous != 2) {
    4d9a:	f89056e3          	blez	s1,4d26 <drivetests+0x68>
    4d9e:	f80b04e3          	beqz	s6,4d26 <drivetests+0x68>
    4da2:	a801                	j	4db2 <drivetests+0xf4>
      printf("NO TESTS EXECUTED\n");
    4da4:	00003517          	auipc	a0,0x3
    4da8:	b4c50513          	addi	a0,a0,-1204 # 78f0 <malloc+0x2274>
    4dac:	019000ef          	jal	55c4 <printf>
      return -1;
    4db0:	54fd                	li	s1,-1
  return 0;
}
    4db2:	8526                	mv	a0,s1
    4db4:	70a6                	ld	ra,104(sp)
    4db6:	7406                	ld	s0,96(sp)
    4db8:	64e6                	ld	s1,88(sp)
    4dba:	6946                	ld	s2,80(sp)
    4dbc:	69a6                	ld	s3,72(sp)
    4dbe:	6a06                	ld	s4,64(sp)
    4dc0:	7ae2                	ld	s5,56(sp)
    4dc2:	7b42                	ld	s6,48(sp)
    4dc4:	7ba2                	ld	s7,40(sp)
    4dc6:	7c02                	ld	s8,32(sp)
    4dc8:	6ce2                	ld	s9,24(sp)
    4dca:	6d42                	ld	s10,16(sp)
    4dcc:	6da2                	ld	s11,8(sp)
    4dce:	6165                	addi	sp,sp,112
    4dd0:	8082                	ret
  return 0;
    4dd2:	84ce                	mv	s1,s3
    4dd4:	bff9                	j	4db2 <drivetests+0xf4>

0000000000004dd6 <main>:

int
main(int argc, char *argv[])
{
    4dd6:	1101                	addi	sp,sp,-32
    4dd8:	ec06                	sd	ra,24(sp)
    4dda:	e822                	sd	s0,16(sp)
    4ddc:	e426                	sd	s1,8(sp)
    4dde:	e04a                	sd	s2,0(sp)
    4de0:	1000                	addi	s0,sp,32
    4de2:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4de4:	4789                	li	a5,2
    4de6:	02f50a63          	beq	a0,a5,4e1a <main+0x44>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4dea:	4785                	li	a5,1
    4dec:	08a7c263          	blt	a5,a0,4e70 <main+0x9a>
  char *justone = 0;
    4df0:	4601                	li	a2,0
  int quick = 0;
    4df2:	4501                	li	a0,0
  int continuous = 0;
    4df4:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  int result = drivetests(quick, continuous, justone);
    4df6:	ec9ff0ef          	jal	4cbe <drivetests>
    4dfa:	84aa                	mv	s1,a0
  if (result < 0) printf("NO TESTS EXECUTED\n");
    4dfc:	08054963          	bltz	a0,4e8e <main+0xb8>
  else if (result == 0) printf("PASS ALL TESTS\n");
    4e00:	cd51                	beqz	a0,4e9c <main+0xc6>
  else if (result == 1) printf("FAIL SOME TESTS\n");
    4e02:	4785                	li	a5,1
    4e04:	0af50363          	beq	a0,a5,4eaa <main+0xd4>
  else printf("SOME TESTS NEED REVIEW\n");
    4e08:	00003517          	auipc	a0,0x3
    4e0c:	b6850513          	addi	a0,a0,-1176 # 7970 <malloc+0x22f4>
    4e10:	7b4000ef          	jal	55c4 <printf>
  exit(result);
    4e14:	8526                	mv	a0,s1
    4e16:	358000ef          	jal	516e <exit>
    4e1a:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4e1c:	00003597          	auipc	a1,0x3
    4e20:	aec58593          	addi	a1,a1,-1300 # 7908 <malloc+0x228c>
    4e24:	00893503          	ld	a0,8(s2)
    4e28:	0c0000ef          	jal	4ee8 <strcmp>
    4e2c:	85aa                	mv	a1,a0
    4e2e:	e501                	bnez	a0,4e36 <main+0x60>
  char *justone = 0;
    4e30:	4601                	li	a2,0
    quick = 1;
    4e32:	4505                	li	a0,1
    4e34:	b7c9                	j	4df6 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4e36:	00003597          	auipc	a1,0x3
    4e3a:	ada58593          	addi	a1,a1,-1318 # 7910 <malloc+0x2294>
    4e3e:	00893503          	ld	a0,8(s2)
    4e42:	0a6000ef          	jal	4ee8 <strcmp>
    4e46:	cd15                	beqz	a0,4e82 <main+0xac>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4e48:	00003597          	auipc	a1,0x3
    4e4c:	b4058593          	addi	a1,a1,-1216 # 7988 <malloc+0x230c>
    4e50:	00893503          	ld	a0,8(s2)
    4e54:	094000ef          	jal	4ee8 <strcmp>
    4e58:	c905                	beqz	a0,4e88 <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    4e5a:	00893603          	ld	a2,8(s2)
    4e5e:	00064703          	lbu	a4,0(a2)
    4e62:	02d00793          	li	a5,45
    4e66:	00f70563          	beq	a4,a5,4e70 <main+0x9a>
  int quick = 0;
    4e6a:	4501                	li	a0,0
  int continuous = 0;
    4e6c:	4581                	li	a1,0
    4e6e:	b761                	j	4df6 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4e70:	00003517          	auipc	a0,0x3
    4e74:	aa850513          	addi	a0,a0,-1368 # 7918 <malloc+0x229c>
    4e78:	74c000ef          	jal	55c4 <printf>
    exit(1);
    4e7c:	4505                	li	a0,1
    4e7e:	2f0000ef          	jal	516e <exit>
  char *justone = 0;
    4e82:	4601                	li	a2,0
    continuous = 1;
    4e84:	4585                	li	a1,1
    4e86:	bf85                	j	4df6 <main+0x20>
    continuous = 2;
    4e88:	85a6                	mv	a1,s1
  char *justone = 0;
    4e8a:	4601                	li	a2,0
    4e8c:	b7ad                	j	4df6 <main+0x20>
  if (result < 0) printf("NO TESTS EXECUTED\n");
    4e8e:	00003517          	auipc	a0,0x3
    4e92:	a6250513          	addi	a0,a0,-1438 # 78f0 <malloc+0x2274>
    4e96:	72e000ef          	jal	55c4 <printf>
    4e9a:	bfad                	j	4e14 <main+0x3e>
  else if (result == 0) printf("PASS ALL TESTS\n");
    4e9c:	00003517          	auipc	a0,0x3
    4ea0:	aac50513          	addi	a0,a0,-1364 # 7948 <malloc+0x22cc>
    4ea4:	720000ef          	jal	55c4 <printf>
    4ea8:	b7b5                	j	4e14 <main+0x3e>
  else if (result == 1) printf("FAIL SOME TESTS\n");
    4eaa:	00003517          	auipc	a0,0x3
    4eae:	aae50513          	addi	a0,a0,-1362 # 7958 <malloc+0x22dc>
    4eb2:	712000ef          	jal	55c4 <printf>
    4eb6:	bfb9                	j	4e14 <main+0x3e>

0000000000004eb8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4eb8:	1141                	addi	sp,sp,-16
    4eba:	e406                	sd	ra,8(sp)
    4ebc:	e022                	sd	s0,0(sp)
    4ebe:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4ec0:	f17ff0ef          	jal	4dd6 <main>
  exit(r);
    4ec4:	2aa000ef          	jal	516e <exit>

0000000000004ec8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4ec8:	1141                	addi	sp,sp,-16
    4eca:	e406                	sd	ra,8(sp)
    4ecc:	e022                	sd	s0,0(sp)
    4ece:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4ed0:	87aa                	mv	a5,a0
    4ed2:	0585                	addi	a1,a1,1
    4ed4:	0785                	addi	a5,a5,1
    4ed6:	fff5c703          	lbu	a4,-1(a1)
    4eda:	fee78fa3          	sb	a4,-1(a5)
    4ede:	fb75                	bnez	a4,4ed2 <strcpy+0xa>
    ;
  return os;
}
    4ee0:	60a2                	ld	ra,8(sp)
    4ee2:	6402                	ld	s0,0(sp)
    4ee4:	0141                	addi	sp,sp,16
    4ee6:	8082                	ret

0000000000004ee8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4ee8:	1141                	addi	sp,sp,-16
    4eea:	e406                	sd	ra,8(sp)
    4eec:	e022                	sd	s0,0(sp)
    4eee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4ef0:	00054783          	lbu	a5,0(a0)
    4ef4:	cb91                	beqz	a5,4f08 <strcmp+0x20>
    4ef6:	0005c703          	lbu	a4,0(a1)
    4efa:	00f71763          	bne	a4,a5,4f08 <strcmp+0x20>
    p++, q++;
    4efe:	0505                	addi	a0,a0,1
    4f00:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4f02:	00054783          	lbu	a5,0(a0)
    4f06:	fbe5                	bnez	a5,4ef6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4f08:	0005c503          	lbu	a0,0(a1)
}
    4f0c:	40a7853b          	subw	a0,a5,a0
    4f10:	60a2                	ld	ra,8(sp)
    4f12:	6402                	ld	s0,0(sp)
    4f14:	0141                	addi	sp,sp,16
    4f16:	8082                	ret

0000000000004f18 <strlen>:

uint
strlen(const char *s)
{
    4f18:	1141                	addi	sp,sp,-16
    4f1a:	e406                	sd	ra,8(sp)
    4f1c:	e022                	sd	s0,0(sp)
    4f1e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4f20:	00054783          	lbu	a5,0(a0)
    4f24:	cf91                	beqz	a5,4f40 <strlen+0x28>
    4f26:	00150793          	addi	a5,a0,1
    4f2a:	86be                	mv	a3,a5
    4f2c:	0785                	addi	a5,a5,1
    4f2e:	fff7c703          	lbu	a4,-1(a5)
    4f32:	ff65                	bnez	a4,4f2a <strlen+0x12>
    4f34:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4f38:	60a2                	ld	ra,8(sp)
    4f3a:	6402                	ld	s0,0(sp)
    4f3c:	0141                	addi	sp,sp,16
    4f3e:	8082                	ret
  for(n = 0; s[n]; n++)
    4f40:	4501                	li	a0,0
    4f42:	bfdd                	j	4f38 <strlen+0x20>

0000000000004f44 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4f44:	1141                	addi	sp,sp,-16
    4f46:	e406                	sd	ra,8(sp)
    4f48:	e022                	sd	s0,0(sp)
    4f4a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4f4c:	ca19                	beqz	a2,4f62 <memset+0x1e>
    4f4e:	87aa                	mv	a5,a0
    4f50:	1602                	slli	a2,a2,0x20
    4f52:	9201                	srli	a2,a2,0x20
    4f54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4f58:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4f5c:	0785                	addi	a5,a5,1
    4f5e:	fee79de3          	bne	a5,a4,4f58 <memset+0x14>
  }
  return dst;
}
    4f62:	60a2                	ld	ra,8(sp)
    4f64:	6402                	ld	s0,0(sp)
    4f66:	0141                	addi	sp,sp,16
    4f68:	8082                	ret

0000000000004f6a <strchr>:

char*
strchr(const char *s, char c)
{
    4f6a:	1141                	addi	sp,sp,-16
    4f6c:	e406                	sd	ra,8(sp)
    4f6e:	e022                	sd	s0,0(sp)
    4f70:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4f72:	00054783          	lbu	a5,0(a0)
    4f76:	cf81                	beqz	a5,4f8e <strchr+0x24>
    if(*s == c)
    4f78:	00f58763          	beq	a1,a5,4f86 <strchr+0x1c>
  for(; *s; s++)
    4f7c:	0505                	addi	a0,a0,1
    4f7e:	00054783          	lbu	a5,0(a0)
    4f82:	fbfd                	bnez	a5,4f78 <strchr+0xe>
      return (char*)s;
  return 0;
    4f84:	4501                	li	a0,0
}
    4f86:	60a2                	ld	ra,8(sp)
    4f88:	6402                	ld	s0,0(sp)
    4f8a:	0141                	addi	sp,sp,16
    4f8c:	8082                	ret
  return 0;
    4f8e:	4501                	li	a0,0
    4f90:	bfdd                	j	4f86 <strchr+0x1c>

0000000000004f92 <gets>:

char*
gets(char *buf, int max)
{
    4f92:	711d                	addi	sp,sp,-96
    4f94:	ec86                	sd	ra,88(sp)
    4f96:	e8a2                	sd	s0,80(sp)
    4f98:	e4a6                	sd	s1,72(sp)
    4f9a:	e0ca                	sd	s2,64(sp)
    4f9c:	fc4e                	sd	s3,56(sp)
    4f9e:	f852                	sd	s4,48(sp)
    4fa0:	f456                	sd	s5,40(sp)
    4fa2:	f05a                	sd	s6,32(sp)
    4fa4:	ec5e                	sd	s7,24(sp)
    4fa6:	e862                	sd	s8,16(sp)
    4fa8:	1080                	addi	s0,sp,96
    4faa:	8baa                	mv	s7,a0
    4fac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4fae:	892a                	mv	s2,a0
    4fb0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4fb2:	faf40b13          	addi	s6,s0,-81
    4fb6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    4fb8:	8c26                	mv	s8,s1
    4fba:	0014899b          	addiw	s3,s1,1
    4fbe:	84ce                	mv	s1,s3
    4fc0:	0349d463          	bge	s3,s4,4fe8 <gets+0x56>
    cc = read(0, &c, 1);
    4fc4:	8656                	mv	a2,s5
    4fc6:	85da                	mv	a1,s6
    4fc8:	4501                	li	a0,0
    4fca:	1bc000ef          	jal	5186 <read>
    if(cc < 1)
    4fce:	00a05d63          	blez	a0,4fe8 <gets+0x56>
      break;
    buf[i++] = c;
    4fd2:	faf44783          	lbu	a5,-81(s0)
    4fd6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4fda:	0905                	addi	s2,s2,1
    4fdc:	ff678713          	addi	a4,a5,-10
    4fe0:	c319                	beqz	a4,4fe6 <gets+0x54>
    4fe2:	17cd                	addi	a5,a5,-13
    4fe4:	fbf1                	bnez	a5,4fb8 <gets+0x26>
    buf[i++] = c;
    4fe6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4fe8:	9c5e                	add	s8,s8,s7
    4fea:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4fee:	855e                	mv	a0,s7
    4ff0:	60e6                	ld	ra,88(sp)
    4ff2:	6446                	ld	s0,80(sp)
    4ff4:	64a6                	ld	s1,72(sp)
    4ff6:	6906                	ld	s2,64(sp)
    4ff8:	79e2                	ld	s3,56(sp)
    4ffa:	7a42                	ld	s4,48(sp)
    4ffc:	7aa2                	ld	s5,40(sp)
    4ffe:	7b02                	ld	s6,32(sp)
    5000:	6be2                	ld	s7,24(sp)
    5002:	6c42                	ld	s8,16(sp)
    5004:	6125                	addi	sp,sp,96
    5006:	8082                	ret

0000000000005008 <stat>:

int
stat(const char *n, struct stat *st)
{
    5008:	1101                	addi	sp,sp,-32
    500a:	ec06                	sd	ra,24(sp)
    500c:	e822                	sd	s0,16(sp)
    500e:	e04a                	sd	s2,0(sp)
    5010:	1000                	addi	s0,sp,32
    5012:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5014:	4581                	li	a1,0
    5016:	198000ef          	jal	51ae <open>
  if(fd < 0)
    501a:	02054263          	bltz	a0,503e <stat+0x36>
    501e:	e426                	sd	s1,8(sp)
    5020:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5022:	85ca                	mv	a1,s2
    5024:	1a2000ef          	jal	51c6 <fstat>
    5028:	892a                	mv	s2,a0
  close(fd);
    502a:	8526                	mv	a0,s1
    502c:	16a000ef          	jal	5196 <close>
  return r;
    5030:	64a2                	ld	s1,8(sp)
}
    5032:	854a                	mv	a0,s2
    5034:	60e2                	ld	ra,24(sp)
    5036:	6442                	ld	s0,16(sp)
    5038:	6902                	ld	s2,0(sp)
    503a:	6105                	addi	sp,sp,32
    503c:	8082                	ret
    return -1;
    503e:	57fd                	li	a5,-1
    5040:	893e                	mv	s2,a5
    5042:	bfc5                	j	5032 <stat+0x2a>

0000000000005044 <atoi>:

int
atoi(const char *s)
{
    5044:	1141                	addi	sp,sp,-16
    5046:	e406                	sd	ra,8(sp)
    5048:	e022                	sd	s0,0(sp)
    504a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    504c:	00054683          	lbu	a3,0(a0)
    5050:	fd06879b          	addiw	a5,a3,-48
    5054:	0ff7f793          	zext.b	a5,a5
    5058:	4625                	li	a2,9
    505a:	02f66963          	bltu	a2,a5,508c <atoi+0x48>
    505e:	872a                	mv	a4,a0
  n = 0;
    5060:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5062:	0705                	addi	a4,a4,1 # 1000001 <base+0xff1349>
    5064:	0025179b          	slliw	a5,a0,0x2
    5068:	9fa9                	addw	a5,a5,a0
    506a:	0017979b          	slliw	a5,a5,0x1
    506e:	9fb5                	addw	a5,a5,a3
    5070:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5074:	00074683          	lbu	a3,0(a4)
    5078:	fd06879b          	addiw	a5,a3,-48
    507c:	0ff7f793          	zext.b	a5,a5
    5080:	fef671e3          	bgeu	a2,a5,5062 <atoi+0x1e>
  return n;
}
    5084:	60a2                	ld	ra,8(sp)
    5086:	6402                	ld	s0,0(sp)
    5088:	0141                	addi	sp,sp,16
    508a:	8082                	ret
  n = 0;
    508c:	4501                	li	a0,0
    508e:	bfdd                	j	5084 <atoi+0x40>

0000000000005090 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5090:	1141                	addi	sp,sp,-16
    5092:	e406                	sd	ra,8(sp)
    5094:	e022                	sd	s0,0(sp)
    5096:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5098:	02b57563          	bgeu	a0,a1,50c2 <memmove+0x32>
    while(n-- > 0)
    509c:	00c05f63          	blez	a2,50ba <memmove+0x2a>
    50a0:	1602                	slli	a2,a2,0x20
    50a2:	9201                	srli	a2,a2,0x20
    50a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    50a8:	872a                	mv	a4,a0
      *dst++ = *src++;
    50aa:	0585                	addi	a1,a1,1
    50ac:	0705                	addi	a4,a4,1
    50ae:	fff5c683          	lbu	a3,-1(a1)
    50b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    50b6:	fee79ae3          	bne	a5,a4,50aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    50ba:	60a2                	ld	ra,8(sp)
    50bc:	6402                	ld	s0,0(sp)
    50be:	0141                	addi	sp,sp,16
    50c0:	8082                	ret
    while(n-- > 0)
    50c2:	fec05ce3          	blez	a2,50ba <memmove+0x2a>
    dst += n;
    50c6:	00c50733          	add	a4,a0,a2
    src += n;
    50ca:	95b2                	add	a1,a1,a2
    50cc:	fff6079b          	addiw	a5,a2,-1
    50d0:	1782                	slli	a5,a5,0x20
    50d2:	9381                	srli	a5,a5,0x20
    50d4:	fff7c793          	not	a5,a5
    50d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    50da:	15fd                	addi	a1,a1,-1
    50dc:	177d                	addi	a4,a4,-1
    50de:	0005c683          	lbu	a3,0(a1)
    50e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    50e6:	fef71ae3          	bne	a4,a5,50da <memmove+0x4a>
    50ea:	bfc1                	j	50ba <memmove+0x2a>

00000000000050ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    50ec:	1141                	addi	sp,sp,-16
    50ee:	e406                	sd	ra,8(sp)
    50f0:	e022                	sd	s0,0(sp)
    50f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    50f4:	c61d                	beqz	a2,5122 <memcmp+0x36>
    50f6:	1602                	slli	a2,a2,0x20
    50f8:	9201                	srli	a2,a2,0x20
    50fa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    50fe:	00054783          	lbu	a5,0(a0)
    5102:	0005c703          	lbu	a4,0(a1)
    5106:	00e79863          	bne	a5,a4,5116 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    510a:	0505                	addi	a0,a0,1
    p2++;
    510c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    510e:	fed518e3          	bne	a0,a3,50fe <memcmp+0x12>
  }
  return 0;
    5112:	4501                	li	a0,0
    5114:	a019                	j	511a <memcmp+0x2e>
      return *p1 - *p2;
    5116:	40e7853b          	subw	a0,a5,a4
}
    511a:	60a2                	ld	ra,8(sp)
    511c:	6402                	ld	s0,0(sp)
    511e:	0141                	addi	sp,sp,16
    5120:	8082                	ret
  return 0;
    5122:	4501                	li	a0,0
    5124:	bfdd                	j	511a <memcmp+0x2e>

0000000000005126 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5126:	1141                	addi	sp,sp,-16
    5128:	e406                	sd	ra,8(sp)
    512a:	e022                	sd	s0,0(sp)
    512c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    512e:	f63ff0ef          	jal	5090 <memmove>
}
    5132:	60a2                	ld	ra,8(sp)
    5134:	6402                	ld	s0,0(sp)
    5136:	0141                	addi	sp,sp,16
    5138:	8082                	ret

000000000000513a <sbrk>:

char *
sbrk(int n) {
    513a:	1141                	addi	sp,sp,-16
    513c:	e406                	sd	ra,8(sp)
    513e:	e022                	sd	s0,0(sp)
    5140:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    5142:	4585                	li	a1,1
    5144:	0b2000ef          	jal	51f6 <sys_sbrk>
}
    5148:	60a2                	ld	ra,8(sp)
    514a:	6402                	ld	s0,0(sp)
    514c:	0141                	addi	sp,sp,16
    514e:	8082                	ret

0000000000005150 <sbrklazy>:

char *
sbrklazy(int n) {
    5150:	1141                	addi	sp,sp,-16
    5152:	e406                	sd	ra,8(sp)
    5154:	e022                	sd	s0,0(sp)
    5156:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    5158:	4589                	li	a1,2
    515a:	09c000ef          	jal	51f6 <sys_sbrk>
}
    515e:	60a2                	ld	ra,8(sp)
    5160:	6402                	ld	s0,0(sp)
    5162:	0141                	addi	sp,sp,16
    5164:	8082                	ret

0000000000005166 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5166:	4885                	li	a7,1
 ecall
    5168:	00000073          	ecall
 ret
    516c:	8082                	ret

000000000000516e <exit>:
.global exit
exit:
 li a7, SYS_exit
    516e:	4889                	li	a7,2
 ecall
    5170:	00000073          	ecall
 ret
    5174:	8082                	ret

0000000000005176 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5176:	488d                	li	a7,3
 ecall
    5178:	00000073          	ecall
 ret
    517c:	8082                	ret

000000000000517e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    517e:	4891                	li	a7,4
 ecall
    5180:	00000073          	ecall
 ret
    5184:	8082                	ret

0000000000005186 <read>:
.global read
read:
 li a7, SYS_read
    5186:	4895                	li	a7,5
 ecall
    5188:	00000073          	ecall
 ret
    518c:	8082                	ret

000000000000518e <write>:
.global write
write:
 li a7, SYS_write
    518e:	48c1                	li	a7,16
 ecall
    5190:	00000073          	ecall
 ret
    5194:	8082                	ret

0000000000005196 <close>:
.global close
close:
 li a7, SYS_close
    5196:	48d5                	li	a7,21
 ecall
    5198:	00000073          	ecall
 ret
    519c:	8082                	ret

000000000000519e <kill>:
.global kill
kill:
 li a7, SYS_kill
    519e:	4899                	li	a7,6
 ecall
    51a0:	00000073          	ecall
 ret
    51a4:	8082                	ret

00000000000051a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    51a6:	489d                	li	a7,7
 ecall
    51a8:	00000073          	ecall
 ret
    51ac:	8082                	ret

00000000000051ae <open>:
.global open
open:
 li a7, SYS_open
    51ae:	48bd                	li	a7,15
 ecall
    51b0:	00000073          	ecall
 ret
    51b4:	8082                	ret

00000000000051b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    51b6:	48c5                	li	a7,17
 ecall
    51b8:	00000073          	ecall
 ret
    51bc:	8082                	ret

00000000000051be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    51be:	48c9                	li	a7,18
 ecall
    51c0:	00000073          	ecall
 ret
    51c4:	8082                	ret

00000000000051c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    51c6:	48a1                	li	a7,8
 ecall
    51c8:	00000073          	ecall
 ret
    51cc:	8082                	ret

00000000000051ce <link>:
.global link
link:
 li a7, SYS_link
    51ce:	48cd                	li	a7,19
 ecall
    51d0:	00000073          	ecall
 ret
    51d4:	8082                	ret

00000000000051d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    51d6:	48d1                	li	a7,20
 ecall
    51d8:	00000073          	ecall
 ret
    51dc:	8082                	ret

00000000000051de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    51de:	48a5                	li	a7,9
 ecall
    51e0:	00000073          	ecall
 ret
    51e4:	8082                	ret

00000000000051e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    51e6:	48a9                	li	a7,10
 ecall
    51e8:	00000073          	ecall
 ret
    51ec:	8082                	ret

00000000000051ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    51ee:	48ad                	li	a7,11
 ecall
    51f0:	00000073          	ecall
 ret
    51f4:	8082                	ret

00000000000051f6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    51f6:	48b1                	li	a7,12
 ecall
    51f8:	00000073          	ecall
 ret
    51fc:	8082                	ret

00000000000051fe <pause>:
.global pause
pause:
 li a7, SYS_pause
    51fe:	48b5                	li	a7,13
 ecall
    5200:	00000073          	ecall
 ret
    5204:	8082                	ret

0000000000005206 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5206:	48b9                	li	a7,14
 ecall
    5208:	00000073          	ecall
 ret
    520c:	8082                	ret

000000000000520e <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    520e:	48d9                	li	a7,22
 ecall
    5210:	00000073          	ecall
 ret
    5214:	8082                	ret

0000000000005216 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    5216:	48dd                	li	a7,23
 ecall
    5218:	00000073          	ecall
 ret
    521c:	8082                	ret

000000000000521e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    521e:	1101                	addi	sp,sp,-32
    5220:	ec06                	sd	ra,24(sp)
    5222:	e822                	sd	s0,16(sp)
    5224:	1000                	addi	s0,sp,32
    5226:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    522a:	4605                	li	a2,1
    522c:	fef40593          	addi	a1,s0,-17
    5230:	f5fff0ef          	jal	518e <write>
}
    5234:	60e2                	ld	ra,24(sp)
    5236:	6442                	ld	s0,16(sp)
    5238:	6105                	addi	sp,sp,32
    523a:	8082                	ret

000000000000523c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    523c:	715d                	addi	sp,sp,-80
    523e:	e486                	sd	ra,72(sp)
    5240:	e0a2                	sd	s0,64(sp)
    5242:	f84a                	sd	s2,48(sp)
    5244:	f44e                	sd	s3,40(sp)
    5246:	0880                	addi	s0,sp,80
    5248:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    524a:	c6d1                	beqz	a3,52d6 <printint+0x9a>
    524c:	0805d563          	bgez	a1,52d6 <printint+0x9a>
    neg = 1;
    x = -xx;
    5250:	40b005b3          	neg	a1,a1
    neg = 1;
    5254:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    5256:	fb840993          	addi	s3,s0,-72
  neg = 0;
    525a:	86ce                	mv	a3,s3
  i = 0;
    525c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    525e:	00003817          	auipc	a6,0x3
    5262:	b5a80813          	addi	a6,a6,-1190 # 7db8 <digits>
    5266:	88ba                	mv	a7,a4
    5268:	0017051b          	addiw	a0,a4,1
    526c:	872a                	mv	a4,a0
    526e:	02c5f7b3          	remu	a5,a1,a2
    5272:	97c2                	add	a5,a5,a6
    5274:	0007c783          	lbu	a5,0(a5)
    5278:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    527c:	87ae                	mv	a5,a1
    527e:	02c5d5b3          	divu	a1,a1,a2
    5282:	0685                	addi	a3,a3,1
    5284:	fec7f1e3          	bgeu	a5,a2,5266 <printint+0x2a>
  if(neg)
    5288:	00030c63          	beqz	t1,52a0 <printint+0x64>
    buf[i++] = '-';
    528c:	fd050793          	addi	a5,a0,-48
    5290:	00878533          	add	a0,a5,s0
    5294:	02d00793          	li	a5,45
    5298:	fef50423          	sb	a5,-24(a0)
    529c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    52a0:	02e05563          	blez	a4,52ca <printint+0x8e>
    52a4:	fc26                	sd	s1,56(sp)
    52a6:	377d                	addiw	a4,a4,-1
    52a8:	00e984b3          	add	s1,s3,a4
    52ac:	19fd                	addi	s3,s3,-1 # fff <bigdir+0xdd>
    52ae:	99ba                	add	s3,s3,a4
    52b0:	1702                	slli	a4,a4,0x20
    52b2:	9301                	srli	a4,a4,0x20
    52b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    52b8:	0004c583          	lbu	a1,0(s1)
    52bc:	854a                	mv	a0,s2
    52be:	f61ff0ef          	jal	521e <putc>
  while(--i >= 0)
    52c2:	14fd                	addi	s1,s1,-1
    52c4:	ff349ae3          	bne	s1,s3,52b8 <printint+0x7c>
    52c8:	74e2                	ld	s1,56(sp)
}
    52ca:	60a6                	ld	ra,72(sp)
    52cc:	6406                	ld	s0,64(sp)
    52ce:	7942                	ld	s2,48(sp)
    52d0:	79a2                	ld	s3,40(sp)
    52d2:	6161                	addi	sp,sp,80
    52d4:	8082                	ret
  neg = 0;
    52d6:	4301                	li	t1,0
    52d8:	bfbd                	j	5256 <printint+0x1a>

00000000000052da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    52da:	711d                	addi	sp,sp,-96
    52dc:	ec86                	sd	ra,88(sp)
    52de:	e8a2                	sd	s0,80(sp)
    52e0:	e4a6                	sd	s1,72(sp)
    52e2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    52e4:	0005c483          	lbu	s1,0(a1)
    52e8:	22048363          	beqz	s1,550e <vprintf+0x234>
    52ec:	e0ca                	sd	s2,64(sp)
    52ee:	fc4e                	sd	s3,56(sp)
    52f0:	f852                	sd	s4,48(sp)
    52f2:	f456                	sd	s5,40(sp)
    52f4:	f05a                	sd	s6,32(sp)
    52f6:	ec5e                	sd	s7,24(sp)
    52f8:	e862                	sd	s8,16(sp)
    52fa:	8b2a                	mv	s6,a0
    52fc:	8a2e                	mv	s4,a1
    52fe:	8bb2                	mv	s7,a2
  state = 0;
    5300:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    5302:	4901                	li	s2,0
    5304:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    5306:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    530a:	06400c13          	li	s8,100
    530e:	a00d                	j	5330 <vprintf+0x56>
        putc(fd, c0);
    5310:	85a6                	mv	a1,s1
    5312:	855a                	mv	a0,s6
    5314:	f0bff0ef          	jal	521e <putc>
    5318:	a019                	j	531e <vprintf+0x44>
    } else if(state == '%'){
    531a:	03598363          	beq	s3,s5,5340 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    531e:	0019079b          	addiw	a5,s2,1
    5322:	893e                	mv	s2,a5
    5324:	873e                	mv	a4,a5
    5326:	97d2                	add	a5,a5,s4
    5328:	0007c483          	lbu	s1,0(a5)
    532c:	1c048a63          	beqz	s1,5500 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    5330:	0004879b          	sext.w	a5,s1
    if(state == 0){
    5334:	fe0993e3          	bnez	s3,531a <vprintf+0x40>
      if(c0 == '%'){
    5338:	fd579ce3          	bne	a5,s5,5310 <vprintf+0x36>
        state = '%';
    533c:	89be                	mv	s3,a5
    533e:	b7c5                	j	531e <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    5340:	00ea06b3          	add	a3,s4,a4
    5344:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    5348:	1c060863          	beqz	a2,5518 <vprintf+0x23e>
      if(c0 == 'd'){
    534c:	03878763          	beq	a5,s8,537a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    5350:	f9478693          	addi	a3,a5,-108
    5354:	0016b693          	seqz	a3,a3
    5358:	f9c60593          	addi	a1,a2,-100
    535c:	e99d                	bnez	a1,5392 <vprintf+0xb8>
    535e:	ca95                	beqz	a3,5392 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5360:	008b8493          	addi	s1,s7,8
    5364:	4685                	li	a3,1
    5366:	4629                	li	a2,10
    5368:	000bb583          	ld	a1,0(s7)
    536c:	855a                	mv	a0,s6
    536e:	ecfff0ef          	jal	523c <printint>
        i += 1;
    5372:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5374:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    5376:	4981                	li	s3,0
    5378:	b75d                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    537a:	008b8493          	addi	s1,s7,8
    537e:	4685                	li	a3,1
    5380:	4629                	li	a2,10
    5382:	000ba583          	lw	a1,0(s7)
    5386:	855a                	mv	a0,s6
    5388:	eb5ff0ef          	jal	523c <printint>
    538c:	8ba6                	mv	s7,s1
      state = 0;
    538e:	4981                	li	s3,0
    5390:	b779                	j	531e <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    5392:	9752                	add	a4,a4,s4
    5394:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5398:	f9460713          	addi	a4,a2,-108
    539c:	00173713          	seqz	a4,a4
    53a0:	8f75                	and	a4,a4,a3
    53a2:	f9c58513          	addi	a0,a1,-100
    53a6:	18051363          	bnez	a0,552c <vprintf+0x252>
    53aa:	18070163          	beqz	a4,552c <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    53ae:	008b8493          	addi	s1,s7,8
    53b2:	4685                	li	a3,1
    53b4:	4629                	li	a2,10
    53b6:	000bb583          	ld	a1,0(s7)
    53ba:	855a                	mv	a0,s6
    53bc:	e81ff0ef          	jal	523c <printint>
        i += 2;
    53c0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    53c2:	8ba6                	mv	s7,s1
      state = 0;
    53c4:	4981                	li	s3,0
        i += 2;
    53c6:	bfa1                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    53c8:	008b8493          	addi	s1,s7,8
    53cc:	4681                	li	a3,0
    53ce:	4629                	li	a2,10
    53d0:	000be583          	lwu	a1,0(s7)
    53d4:	855a                	mv	a0,s6
    53d6:	e67ff0ef          	jal	523c <printint>
    53da:	8ba6                	mv	s7,s1
      state = 0;
    53dc:	4981                	li	s3,0
    53de:	b781                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    53e0:	008b8493          	addi	s1,s7,8
    53e4:	4681                	li	a3,0
    53e6:	4629                	li	a2,10
    53e8:	000bb583          	ld	a1,0(s7)
    53ec:	855a                	mv	a0,s6
    53ee:	e4fff0ef          	jal	523c <printint>
        i += 1;
    53f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    53f4:	8ba6                	mv	s7,s1
      state = 0;
    53f6:	4981                	li	s3,0
    53f8:	b71d                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    53fa:	008b8493          	addi	s1,s7,8
    53fe:	4681                	li	a3,0
    5400:	4629                	li	a2,10
    5402:	000bb583          	ld	a1,0(s7)
    5406:	855a                	mv	a0,s6
    5408:	e35ff0ef          	jal	523c <printint>
        i += 2;
    540c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    540e:	8ba6                	mv	s7,s1
      state = 0;
    5410:	4981                	li	s3,0
        i += 2;
    5412:	b731                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5414:	008b8493          	addi	s1,s7,8
    5418:	4681                	li	a3,0
    541a:	4641                	li	a2,16
    541c:	000be583          	lwu	a1,0(s7)
    5420:	855a                	mv	a0,s6
    5422:	e1bff0ef          	jal	523c <printint>
    5426:	8ba6                	mv	s7,s1
      state = 0;
    5428:	4981                	li	s3,0
    542a:	bdd5                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    542c:	008b8493          	addi	s1,s7,8
    5430:	4681                	li	a3,0
    5432:	4641                	li	a2,16
    5434:	000bb583          	ld	a1,0(s7)
    5438:	855a                	mv	a0,s6
    543a:	e03ff0ef          	jal	523c <printint>
        i += 1;
    543e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5440:	8ba6                	mv	s7,s1
      state = 0;
    5442:	4981                	li	s3,0
    5444:	bde9                	j	531e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5446:	008b8493          	addi	s1,s7,8
    544a:	4681                	li	a3,0
    544c:	4641                	li	a2,16
    544e:	000bb583          	ld	a1,0(s7)
    5452:	855a                	mv	a0,s6
    5454:	de9ff0ef          	jal	523c <printint>
        i += 2;
    5458:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    545a:	8ba6                	mv	s7,s1
      state = 0;
    545c:	4981                	li	s3,0
        i += 2;
    545e:	b5c1                	j	531e <vprintf+0x44>
    5460:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5462:	008b8793          	addi	a5,s7,8
    5466:	8cbe                	mv	s9,a5
    5468:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    546c:	03000593          	li	a1,48
    5470:	855a                	mv	a0,s6
    5472:	dadff0ef          	jal	521e <putc>
  putc(fd, 'x');
    5476:	07800593          	li	a1,120
    547a:	855a                	mv	a0,s6
    547c:	da3ff0ef          	jal	521e <putc>
    5480:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5482:	00003b97          	auipc	s7,0x3
    5486:	936b8b93          	addi	s7,s7,-1738 # 7db8 <digits>
    548a:	03c9d793          	srli	a5,s3,0x3c
    548e:	97de                	add	a5,a5,s7
    5490:	0007c583          	lbu	a1,0(a5)
    5494:	855a                	mv	a0,s6
    5496:	d89ff0ef          	jal	521e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    549a:	0992                	slli	s3,s3,0x4
    549c:	34fd                	addiw	s1,s1,-1
    549e:	f4f5                	bnez	s1,548a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    54a0:	8be6                	mv	s7,s9
      state = 0;
    54a2:	4981                	li	s3,0
    54a4:	6ca2                	ld	s9,8(sp)
    54a6:	bda5                	j	531e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    54a8:	008b8493          	addi	s1,s7,8
    54ac:	000bc583          	lbu	a1,0(s7)
    54b0:	855a                	mv	a0,s6
    54b2:	d6dff0ef          	jal	521e <putc>
    54b6:	8ba6                	mv	s7,s1
      state = 0;
    54b8:	4981                	li	s3,0
    54ba:	b595                	j	531e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    54bc:	008b8993          	addi	s3,s7,8
    54c0:	000bb483          	ld	s1,0(s7)
    54c4:	cc91                	beqz	s1,54e0 <vprintf+0x206>
        for(; *s; s++)
    54c6:	0004c583          	lbu	a1,0(s1)
    54ca:	c985                	beqz	a1,54fa <vprintf+0x220>
          putc(fd, *s);
    54cc:	855a                	mv	a0,s6
    54ce:	d51ff0ef          	jal	521e <putc>
        for(; *s; s++)
    54d2:	0485                	addi	s1,s1,1
    54d4:	0004c583          	lbu	a1,0(s1)
    54d8:	f9f5                	bnez	a1,54cc <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    54da:	8bce                	mv	s7,s3
      state = 0;
    54dc:	4981                	li	s3,0
    54de:	b581                	j	531e <vprintf+0x44>
          s = "(null)";
    54e0:	00003497          	auipc	s1,0x3
    54e4:	82848493          	addi	s1,s1,-2008 # 7d08 <malloc+0x268c>
        for(; *s; s++)
    54e8:	02800593          	li	a1,40
    54ec:	b7c5                	j	54cc <vprintf+0x1f2>
        putc(fd, '%');
    54ee:	85be                	mv	a1,a5
    54f0:	855a                	mv	a0,s6
    54f2:	d2dff0ef          	jal	521e <putc>
      state = 0;
    54f6:	4981                	li	s3,0
    54f8:	b51d                	j	531e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    54fa:	8bce                	mv	s7,s3
      state = 0;
    54fc:	4981                	li	s3,0
    54fe:	b505                	j	531e <vprintf+0x44>
    5500:	6906                	ld	s2,64(sp)
    5502:	79e2                	ld	s3,56(sp)
    5504:	7a42                	ld	s4,48(sp)
    5506:	7aa2                	ld	s5,40(sp)
    5508:	7b02                	ld	s6,32(sp)
    550a:	6be2                	ld	s7,24(sp)
    550c:	6c42                	ld	s8,16(sp)
    }
  }
}
    550e:	60e6                	ld	ra,88(sp)
    5510:	6446                	ld	s0,80(sp)
    5512:	64a6                	ld	s1,72(sp)
    5514:	6125                	addi	sp,sp,96
    5516:	8082                	ret
      if(c0 == 'd'){
    5518:	06400713          	li	a4,100
    551c:	e4e78fe3          	beq	a5,a4,537a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    5520:	f9478693          	addi	a3,a5,-108
    5524:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5528:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    552a:	4701                	li	a4,0
      } else if(c0 == 'u'){
    552c:	07500513          	li	a0,117
    5530:	e8a78ce3          	beq	a5,a0,53c8 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    5534:	f8b60513          	addi	a0,a2,-117
    5538:	e119                	bnez	a0,553e <vprintf+0x264>
    553a:	ea0693e3          	bnez	a3,53e0 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    553e:	f8b58513          	addi	a0,a1,-117
    5542:	e119                	bnez	a0,5548 <vprintf+0x26e>
    5544:	ea071be3          	bnez	a4,53fa <vprintf+0x120>
      } else if(c0 == 'x'){
    5548:	07800513          	li	a0,120
    554c:	eca784e3          	beq	a5,a0,5414 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    5550:	f8860613          	addi	a2,a2,-120
    5554:	e219                	bnez	a2,555a <vprintf+0x280>
    5556:	ec069be3          	bnez	a3,542c <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    555a:	f8858593          	addi	a1,a1,-120
    555e:	e199                	bnez	a1,5564 <vprintf+0x28a>
    5560:	ee0713e3          	bnez	a4,5446 <vprintf+0x16c>
      } else if(c0 == 'p'){
    5564:	07000713          	li	a4,112
    5568:	eee78ce3          	beq	a5,a4,5460 <vprintf+0x186>
      } else if(c0 == 'c'){
    556c:	06300713          	li	a4,99
    5570:	f2e78ce3          	beq	a5,a4,54a8 <vprintf+0x1ce>
      } else if(c0 == 's'){
    5574:	07300713          	li	a4,115
    5578:	f4e782e3          	beq	a5,a4,54bc <vprintf+0x1e2>
      } else if(c0 == '%'){
    557c:	02500713          	li	a4,37
    5580:	f6e787e3          	beq	a5,a4,54ee <vprintf+0x214>
        putc(fd, '%');
    5584:	02500593          	li	a1,37
    5588:	855a                	mv	a0,s6
    558a:	c95ff0ef          	jal	521e <putc>
        putc(fd, c0);
    558e:	85a6                	mv	a1,s1
    5590:	855a                	mv	a0,s6
    5592:	c8dff0ef          	jal	521e <putc>
      state = 0;
    5596:	4981                	li	s3,0
    5598:	b359                	j	531e <vprintf+0x44>

000000000000559a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    559a:	715d                	addi	sp,sp,-80
    559c:	ec06                	sd	ra,24(sp)
    559e:	e822                	sd	s0,16(sp)
    55a0:	1000                	addi	s0,sp,32
    55a2:	e010                	sd	a2,0(s0)
    55a4:	e414                	sd	a3,8(s0)
    55a6:	e818                	sd	a4,16(s0)
    55a8:	ec1c                	sd	a5,24(s0)
    55aa:	03043023          	sd	a6,32(s0)
    55ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    55b2:	8622                	mv	a2,s0
    55b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    55b8:	d23ff0ef          	jal	52da <vprintf>
}
    55bc:	60e2                	ld	ra,24(sp)
    55be:	6442                	ld	s0,16(sp)
    55c0:	6161                	addi	sp,sp,80
    55c2:	8082                	ret

00000000000055c4 <printf>:

void
printf(const char *fmt, ...)
{
    55c4:	711d                	addi	sp,sp,-96
    55c6:	ec06                	sd	ra,24(sp)
    55c8:	e822                	sd	s0,16(sp)
    55ca:	1000                	addi	s0,sp,32
    55cc:	e40c                	sd	a1,8(s0)
    55ce:	e810                	sd	a2,16(s0)
    55d0:	ec14                	sd	a3,24(s0)
    55d2:	f018                	sd	a4,32(s0)
    55d4:	f41c                	sd	a5,40(s0)
    55d6:	03043823          	sd	a6,48(s0)
    55da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    55de:	00840613          	addi	a2,s0,8
    55e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    55e6:	85aa                	mv	a1,a0
    55e8:	4505                	li	a0,1
    55ea:	cf1ff0ef          	jal	52da <vprintf>
}
    55ee:	60e2                	ld	ra,24(sp)
    55f0:	6442                	ld	s0,16(sp)
    55f2:	6125                	addi	sp,sp,96
    55f4:	8082                	ret

00000000000055f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    55f6:	1141                	addi	sp,sp,-16
    55f8:	e406                	sd	ra,8(sp)
    55fa:	e022                	sd	s0,0(sp)
    55fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    55fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5602:	00003797          	auipc	a5,0x3
    5606:	e8e7b783          	ld	a5,-370(a5) # 8490 <freep>
    560a:	a039                	j	5618 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    560c:	6398                	ld	a4,0(a5)
    560e:	00e7e463          	bltu	a5,a4,5616 <free+0x20>
    5612:	00e6ea63          	bltu	a3,a4,5626 <free+0x30>
{
    5616:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5618:	fed7fae3          	bgeu	a5,a3,560c <free+0x16>
    561c:	6398                	ld	a4,0(a5)
    561e:	00e6e463          	bltu	a3,a4,5626 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5622:	fee7eae3          	bltu	a5,a4,5616 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    5626:	ff852583          	lw	a1,-8(a0)
    562a:	6390                	ld	a2,0(a5)
    562c:	02059813          	slli	a6,a1,0x20
    5630:	01c85713          	srli	a4,a6,0x1c
    5634:	9736                	add	a4,a4,a3
    5636:	02e60563          	beq	a2,a4,5660 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    563a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    563e:	4790                	lw	a2,8(a5)
    5640:	02061593          	slli	a1,a2,0x20
    5644:	01c5d713          	srli	a4,a1,0x1c
    5648:	973e                	add	a4,a4,a5
    564a:	02e68263          	beq	a3,a4,566e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    564e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5650:	00003717          	auipc	a4,0x3
    5654:	e4f73023          	sd	a5,-448(a4) # 8490 <freep>
}
    5658:	60a2                	ld	ra,8(sp)
    565a:	6402                	ld	s0,0(sp)
    565c:	0141                	addi	sp,sp,16
    565e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5660:	4618                	lw	a4,8(a2)
    5662:	9f2d                	addw	a4,a4,a1
    5664:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5668:	6398                	ld	a4,0(a5)
    566a:	6310                	ld	a2,0(a4)
    566c:	b7f9                	j	563a <free+0x44>
    p->s.size += bp->s.size;
    566e:	ff852703          	lw	a4,-8(a0)
    5672:	9f31                	addw	a4,a4,a2
    5674:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5676:	ff053683          	ld	a3,-16(a0)
    567a:	bfd1                	j	564e <free+0x58>

000000000000567c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    567c:	7139                	addi	sp,sp,-64
    567e:	fc06                	sd	ra,56(sp)
    5680:	f822                	sd	s0,48(sp)
    5682:	f04a                	sd	s2,32(sp)
    5684:	ec4e                	sd	s3,24(sp)
    5686:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5688:	02051993          	slli	s3,a0,0x20
    568c:	0209d993          	srli	s3,s3,0x20
    5690:	09bd                	addi	s3,s3,15
    5692:	0049d993          	srli	s3,s3,0x4
    5696:	2985                	addiw	s3,s3,1
    5698:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    569a:	00003517          	auipc	a0,0x3
    569e:	df653503          	ld	a0,-522(a0) # 8490 <freep>
    56a2:	c905                	beqz	a0,56d2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    56a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    56a6:	4798                	lw	a4,8(a5)
    56a8:	09377663          	bgeu	a4,s3,5734 <malloc+0xb8>
    56ac:	f426                	sd	s1,40(sp)
    56ae:	e852                	sd	s4,16(sp)
    56b0:	e456                	sd	s5,8(sp)
    56b2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    56b4:	8a4e                	mv	s4,s3
    56b6:	6705                	lui	a4,0x1
    56b8:	00e9f363          	bgeu	s3,a4,56be <malloc+0x42>
    56bc:	6a05                	lui	s4,0x1
    56be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    56c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    56c6:	00003497          	auipc	s1,0x3
    56ca:	dca48493          	addi	s1,s1,-566 # 8490 <freep>
  if(p == SBRK_ERROR)
    56ce:	5afd                	li	s5,-1
    56d0:	a83d                	j	570e <malloc+0x92>
    56d2:	f426                	sd	s1,40(sp)
    56d4:	e852                	sd	s4,16(sp)
    56d6:	e456                	sd	s5,8(sp)
    56d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    56da:	00009797          	auipc	a5,0x9
    56de:	5de78793          	addi	a5,a5,1502 # ecb8 <base>
    56e2:	00003717          	auipc	a4,0x3
    56e6:	daf73723          	sd	a5,-594(a4) # 8490 <freep>
    56ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    56ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    56f0:	b7d1                	j	56b4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    56f2:	6398                	ld	a4,0(a5)
    56f4:	e118                	sd	a4,0(a0)
    56f6:	a899                	j	574c <malloc+0xd0>
  hp->s.size = nu;
    56f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    56fc:	0541                	addi	a0,a0,16
    56fe:	ef9ff0ef          	jal	55f6 <free>
  return freep;
    5702:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5704:	c125                	beqz	a0,5764 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5706:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5708:	4798                	lw	a4,8(a5)
    570a:	03277163          	bgeu	a4,s2,572c <malloc+0xb0>
    if(p == freep)
    570e:	6098                	ld	a4,0(s1)
    5710:	853e                	mv	a0,a5
    5712:	fef71ae3          	bne	a4,a5,5706 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5716:	8552                	mv	a0,s4
    5718:	a23ff0ef          	jal	513a <sbrk>
  if(p == SBRK_ERROR)
    571c:	fd551ee3          	bne	a0,s5,56f8 <malloc+0x7c>
        return 0;
    5720:	4501                	li	a0,0
    5722:	74a2                	ld	s1,40(sp)
    5724:	6a42                	ld	s4,16(sp)
    5726:	6aa2                	ld	s5,8(sp)
    5728:	6b02                	ld	s6,0(sp)
    572a:	a03d                	j	5758 <malloc+0xdc>
    572c:	74a2                	ld	s1,40(sp)
    572e:	6a42                	ld	s4,16(sp)
    5730:	6aa2                	ld	s5,8(sp)
    5732:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5734:	fae90fe3          	beq	s2,a4,56f2 <malloc+0x76>
        p->s.size -= nunits;
    5738:	4137073b          	subw	a4,a4,s3
    573c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    573e:	02071693          	slli	a3,a4,0x20
    5742:	01c6d713          	srli	a4,a3,0x1c
    5746:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5748:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    574c:	00003717          	auipc	a4,0x3
    5750:	d4a73223          	sd	a0,-700(a4) # 8490 <freep>
      return (void*)(p + 1);
    5754:	01078513          	addi	a0,a5,16
  }
}
    5758:	70e2                	ld	ra,56(sp)
    575a:	7442                	ld	s0,48(sp)
    575c:	7902                	ld	s2,32(sp)
    575e:	69e2                	ld	s3,24(sp)
    5760:	6121                	addi	sp,sp,64
    5762:	8082                	ret
    5764:	74a2                	ld	s1,40(sp)
    5766:	6a42                	ld	s4,16(sp)
    5768:	6aa2                	ld	s5,8(sp)
    576a:	6b02                	ld	s6,0(sp)
    576c:	b7f5                	j	5758 <malloc+0xdc>
