
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	347000ef          	jal	bfe <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	21050513          	addi	a0,a0,528 # 12d0 <thread_join+0x32>
      c8:	3f9000ef          	jal	cc0 <mkdir>
  if(chdir("grindir") != 0){
      cc:	00001517          	auipc	a0,0x1
      d0:	20450513          	addi	a0,a0,516 # 12d0 <thread_join+0x32>
      d4:	3f5000ef          	jal	cc8 <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	1ea50513          	addi	a0,a0,490 # 12d8 <thread_join+0x3a>
      f6:	7a9000ef          	jal	109e <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	35d000ef          	jal	c58 <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	1ec50513          	addi	a0,a0,492 # 1300 <thread_join+0x62>
     11c:	3ad000ef          	jal	cc8 <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	1f0c0c13          	addi	s8,s8,496 # 1310 <thread_join+0x72>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	1dec0c13          	addi	s8,s8,478 # 1308 <thread_join+0x6a>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1

  while(1){
    iters++;
    if((iters % 500) == 0)
     136:	106259b7          	lui	s3,0x10625
     13a:	dd398993          	addi	s3,s3,-557 # 10624dd3 <base+0x106229cb>
     13e:	09be                	slli	s3,s3,0xf
     140:	8d598993          	addi	s3,s3,-1835
     144:	09ca                	slli	s3,s3,0x12
     146:	80098993          	addi	s3,s3,-2048
     14a:	fcf98993          	addi	s3,s3,-49
     14e:	1f400b93          	li	s7,500
      write(1, which_child?"B":"A", 1);
     152:	4a05                	li	s4,1
    int what = rand() % 23;
     154:	b2164ab7          	lui	s5,0xb2164
     158:	2c9a8a93          	addi	s5,s5,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     15c:	4b59                	li	s6,22
     15e:	00001917          	auipc	s2,0x1
     162:	48290913          	addi	s2,s2,1154 # 15e0 <thread_join+0x342>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     166:	f6840d93          	addi	s11,s0,-152
     16a:	a819                	j	180 <go+0xd6>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	1a850513          	addi	a0,a0,424 # 1318 <thread_join+0x7a>
     178:	321000ef          	jal	c98 <open>
     17c:	305000ef          	jal	c80 <close>
    iters++;
     180:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     182:	0024d793          	srli	a5,s1,0x2
     186:	0337b7b3          	mulhu	a5,a5,s3
     18a:	8391                	srli	a5,a5,0x4
     18c:	037787b3          	mul	a5,a5,s7
     190:	00f49763          	bne	s1,a5,19e <go+0xf4>
      write(1, which_child?"B":"A", 1);
     194:	8652                	mv	a2,s4
     196:	85e2                	mv	a1,s8
     198:	8552                	mv	a0,s4
     19a:	2df000ef          	jal	c78 <write>
    int what = rand() % 23;
     19e:	ef1ff0ef          	jal	8e <rand>
     1a2:	035507b3          	mul	a5,a0,s5
     1a6:	9381                	srli	a5,a5,0x20
     1a8:	9fa9                	addw	a5,a5,a0
     1aa:	4047d79b          	sraiw	a5,a5,0x4
     1ae:	41f5571b          	sraiw	a4,a0,0x1f
     1b2:	9f99                	subw	a5,a5,a4
     1b4:	0017971b          	slliw	a4,a5,0x1
     1b8:	9f3d                	addw	a4,a4,a5
     1ba:	0037171b          	slliw	a4,a4,0x3
     1be:	40f707bb          	subw	a5,a4,a5
     1c2:	9d1d                	subw	a0,a0,a5
     1c4:	faab6ee3          	bltu	s6,a0,180 <go+0xd6>
     1c8:	02051793          	slli	a5,a0,0x20
     1cc:	01e7d513          	srli	a0,a5,0x1e
     1d0:	954a                	add	a0,a0,s2
     1d2:	411c                	lw	a5,0(a0)
     1d4:	97ca                	add	a5,a5,s2
     1d6:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     1d8:	20200593          	li	a1,514
     1dc:	00001517          	auipc	a0,0x1
     1e0:	14c50513          	addi	a0,a0,332 # 1328 <thread_join+0x8a>
     1e4:	2b5000ef          	jal	c98 <open>
     1e8:	299000ef          	jal	c80 <close>
     1ec:	bf51                	j	180 <go+0xd6>
      unlink("grindir/../a");
     1ee:	00001517          	auipc	a0,0x1
     1f2:	12a50513          	addi	a0,a0,298 # 1318 <thread_join+0x7a>
     1f6:	2b3000ef          	jal	ca8 <unlink>
     1fa:	b759                	j	180 <go+0xd6>
      if(chdir("grindir") != 0){
     1fc:	00001517          	auipc	a0,0x1
     200:	0d450513          	addi	a0,a0,212 # 12d0 <thread_join+0x32>
     204:	2c5000ef          	jal	cc8 <chdir>
     208:	ed11                	bnez	a0,224 <go+0x17a>
      unlink("../b");
     20a:	00001517          	auipc	a0,0x1
     20e:	13650513          	addi	a0,a0,310 # 1340 <thread_join+0xa2>
     212:	297000ef          	jal	ca8 <unlink>
      chdir("/");
     216:	00001517          	auipc	a0,0x1
     21a:	0ea50513          	addi	a0,a0,234 # 1300 <thread_join+0x62>
     21e:	2ab000ef          	jal	cc8 <chdir>
     222:	bfb9                	j	180 <go+0xd6>
        printf("grind: chdir grindir failed\n");
     224:	00001517          	auipc	a0,0x1
     228:	0b450513          	addi	a0,a0,180 # 12d8 <thread_join+0x3a>
     22c:	673000ef          	jal	109e <printf>
        exit(1);
     230:	4505                	li	a0,1
     232:	227000ef          	jal	c58 <exit>
      close(fd);
     236:	8566                	mv	a0,s9
     238:	249000ef          	jal	c80 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     23c:	20200593          	li	a1,514
     240:	00001517          	auipc	a0,0x1
     244:	10850513          	addi	a0,a0,264 # 1348 <thread_join+0xaa>
     248:	251000ef          	jal	c98 <open>
     24c:	8caa                	mv	s9,a0
     24e:	bf0d                	j	180 <go+0xd6>
      close(fd);
     250:	8566                	mv	a0,s9
     252:	22f000ef          	jal	c80 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     256:	20200593          	li	a1,514
     25a:	00001517          	auipc	a0,0x1
     25e:	0fe50513          	addi	a0,a0,254 # 1358 <thread_join+0xba>
     262:	237000ef          	jal	c98 <open>
     266:	8caa                	mv	s9,a0
     268:	bf21                	j	180 <go+0xd6>
      write(fd, buf, sizeof(buf));
     26a:	3e700613          	li	a2,999
     26e:	00002597          	auipc	a1,0x2
     272:	db258593          	addi	a1,a1,-590 # 2020 <buf.0>
     276:	8566                	mv	a0,s9
     278:	201000ef          	jal	c78 <write>
     27c:	b711                	j	180 <go+0xd6>
      read(fd, buf, sizeof(buf));
     27e:	3e700613          	li	a2,999
     282:	00002597          	auipc	a1,0x2
     286:	d9e58593          	addi	a1,a1,-610 # 2020 <buf.0>
     28a:	8566                	mv	a0,s9
     28c:	1e5000ef          	jal	c70 <read>
     290:	bdc5                	j	180 <go+0xd6>
      mkdir("grindir/../a");
     292:	00001517          	auipc	a0,0x1
     296:	08650513          	addi	a0,a0,134 # 1318 <thread_join+0x7a>
     29a:	227000ef          	jal	cc0 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     29e:	20200593          	li	a1,514
     2a2:	00001517          	auipc	a0,0x1
     2a6:	0ce50513          	addi	a0,a0,206 # 1370 <thread_join+0xd2>
     2aa:	1ef000ef          	jal	c98 <open>
     2ae:	1d3000ef          	jal	c80 <close>
      unlink("a/a");
     2b2:	00001517          	auipc	a0,0x1
     2b6:	0ce50513          	addi	a0,a0,206 # 1380 <thread_join+0xe2>
     2ba:	1ef000ef          	jal	ca8 <unlink>
     2be:	b5c9                	j	180 <go+0xd6>
      mkdir("/../b");
     2c0:	00001517          	auipc	a0,0x1
     2c4:	0c850513          	addi	a0,a0,200 # 1388 <thread_join+0xea>
     2c8:	1f9000ef          	jal	cc0 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2cc:	20200593          	li	a1,514
     2d0:	00001517          	auipc	a0,0x1
     2d4:	0c050513          	addi	a0,a0,192 # 1390 <thread_join+0xf2>
     2d8:	1c1000ef          	jal	c98 <open>
     2dc:	1a5000ef          	jal	c80 <close>
      unlink("b/b");
     2e0:	00001517          	auipc	a0,0x1
     2e4:	0c050513          	addi	a0,a0,192 # 13a0 <thread_join+0x102>
     2e8:	1c1000ef          	jal	ca8 <unlink>
     2ec:	bd51                	j	180 <go+0xd6>
      unlink("b");
     2ee:	00001517          	auipc	a0,0x1
     2f2:	0ba50513          	addi	a0,a0,186 # 13a8 <thread_join+0x10a>
     2f6:	1b3000ef          	jal	ca8 <unlink>
      link("../grindir/./../a", "../b");
     2fa:	00001597          	auipc	a1,0x1
     2fe:	04658593          	addi	a1,a1,70 # 1340 <thread_join+0xa2>
     302:	00001517          	auipc	a0,0x1
     306:	0ae50513          	addi	a0,a0,174 # 13b0 <thread_join+0x112>
     30a:	1af000ef          	jal	cb8 <link>
     30e:	bd8d                	j	180 <go+0xd6>
      unlink("../grindir/../a");
     310:	00001517          	auipc	a0,0x1
     314:	0b850513          	addi	a0,a0,184 # 13c8 <thread_join+0x12a>
     318:	191000ef          	jal	ca8 <unlink>
      link(".././b", "/grindir/../a");
     31c:	00001597          	auipc	a1,0x1
     320:	02c58593          	addi	a1,a1,44 # 1348 <thread_join+0xaa>
     324:	00001517          	auipc	a0,0x1
     328:	0b450513          	addi	a0,a0,180 # 13d8 <thread_join+0x13a>
     32c:	18d000ef          	jal	cb8 <link>
     330:	bd81                	j	180 <go+0xd6>
      int pid = fork();
     332:	0f9000ef          	jal	c2a <fork>
      if(pid == 0){
     336:	c519                	beqz	a0,344 <go+0x29a>
      } else if(pid < 0){
     338:	00054863          	bltz	a0,348 <go+0x29e>
      wait(0);
     33c:	4501                	li	a0,0
     33e:	123000ef          	jal	c60 <wait>
     342:	bd3d                	j	180 <go+0xd6>
        exit(0);
     344:	115000ef          	jal	c58 <exit>
        printf("grind: fork failed\n");
     348:	00001517          	auipc	a0,0x1
     34c:	09850513          	addi	a0,a0,152 # 13e0 <thread_join+0x142>
     350:	54f000ef          	jal	109e <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	103000ef          	jal	c58 <exit>
      int pid = fork();
     35a:	0d1000ef          	jal	c2a <fork>
      if(pid == 0){
     35e:	c519                	beqz	a0,36c <go+0x2c2>
      } else if(pid < 0){
     360:	00054d63          	bltz	a0,37a <go+0x2d0>
      wait(0);
     364:	4501                	li	a0,0
     366:	0fb000ef          	jal	c60 <wait>
     36a:	bd19                	j	180 <go+0xd6>
        fork();
     36c:	0bf000ef          	jal	c2a <fork>
        fork();
     370:	0bb000ef          	jal	c2a <fork>
        exit(0);
     374:	4501                	li	a0,0
     376:	0e3000ef          	jal	c58 <exit>
        printf("grind: fork failed\n");
     37a:	00001517          	auipc	a0,0x1
     37e:	06650513          	addi	a0,a0,102 # 13e0 <thread_join+0x142>
     382:	51d000ef          	jal	109e <printf>
        exit(1);
     386:	4505                	li	a0,1
     388:	0d1000ef          	jal	c58 <exit>
      sbrk(6011);
     38c:	6505                	lui	a0,0x1
     38e:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x13b>
     392:	06d000ef          	jal	bfe <sbrk>
     396:	b3ed                	j	180 <go+0xd6>
      if(sbrk(0) > break0)
     398:	4501                	li	a0,0
     39a:	065000ef          	jal	bfe <sbrk>
     39e:	f5843783          	ld	a5,-168(s0)
     3a2:	dca7ffe3          	bgeu	a5,a0,180 <go+0xd6>
        sbrk(-(sbrk(0) - break0));
     3a6:	4501                	li	a0,0
     3a8:	057000ef          	jal	bfe <sbrk>
     3ac:	f5843783          	ld	a5,-168(s0)
     3b0:	40a7853b          	subw	a0,a5,a0
     3b4:	04b000ef          	jal	bfe <sbrk>
     3b8:	b3e1                	j	180 <go+0xd6>
      int pid = fork();
     3ba:	071000ef          	jal	c2a <fork>
     3be:	8d2a                	mv	s10,a0
      if(pid == 0){
     3c0:	c10d                	beqz	a0,3e2 <go+0x338>
      } else if(pid < 0){
     3c2:	02054d63          	bltz	a0,3fc <go+0x352>
      if(chdir("../grindir/..") != 0){
     3c6:	00001517          	auipc	a0,0x1
     3ca:	03a50513          	addi	a0,a0,58 # 1400 <thread_join+0x162>
     3ce:	0fb000ef          	jal	cc8 <chdir>
     3d2:	ed15                	bnez	a0,40e <go+0x364>
      kill(pid);
     3d4:	856a                	mv	a0,s10
     3d6:	0b3000ef          	jal	c88 <kill>
      wait(0);
     3da:	4501                	li	a0,0
     3dc:	085000ef          	jal	c60 <wait>
     3e0:	b345                	j	180 <go+0xd6>
        close(open("a", O_CREATE|O_RDWR));
     3e2:	20200593          	li	a1,514
     3e6:	00001517          	auipc	a0,0x1
     3ea:	01250513          	addi	a0,a0,18 # 13f8 <thread_join+0x15a>
     3ee:	0ab000ef          	jal	c98 <open>
     3f2:	08f000ef          	jal	c80 <close>
        exit(0);
     3f6:	4501                	li	a0,0
     3f8:	061000ef          	jal	c58 <exit>
        printf("grind: fork failed\n");
     3fc:	00001517          	auipc	a0,0x1
     400:	fe450513          	addi	a0,a0,-28 # 13e0 <thread_join+0x142>
     404:	49b000ef          	jal	109e <printf>
        exit(1);
     408:	4505                	li	a0,1
     40a:	04f000ef          	jal	c58 <exit>
        printf("grind: chdir failed\n");
     40e:	00001517          	auipc	a0,0x1
     412:	00250513          	addi	a0,a0,2 # 1410 <thread_join+0x172>
     416:	489000ef          	jal	109e <printf>
        exit(1);
     41a:	4505                	li	a0,1
     41c:	03d000ef          	jal	c58 <exit>
      int pid = fork();
     420:	00b000ef          	jal	c2a <fork>
      if(pid == 0){
     424:	c519                	beqz	a0,432 <go+0x388>
      } else if(pid < 0){
     426:	00054d63          	bltz	a0,440 <go+0x396>
      wait(0);
     42a:	4501                	li	a0,0
     42c:	035000ef          	jal	c60 <wait>
     430:	bb81                	j	180 <go+0xd6>
        kill(getpid());
     432:	0a7000ef          	jal	cd8 <getpid>
     436:	053000ef          	jal	c88 <kill>
        exit(0);
     43a:	4501                	li	a0,0
     43c:	01d000ef          	jal	c58 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	fa050513          	addi	a0,a0,-96 # 13e0 <thread_join+0x142>
     448:	457000ef          	jal	109e <printf>
        exit(1);
     44c:	4505                	li	a0,1
     44e:	00b000ef          	jal	c58 <exit>
      if(pipe(fds) < 0){
     452:	f7840513          	addi	a0,s0,-136
     456:	013000ef          	jal	c68 <pipe>
     45a:	02054363          	bltz	a0,480 <go+0x3d6>
      int pid = fork();
     45e:	7cc000ef          	jal	c2a <fork>
      if(pid == 0){
     462:	c905                	beqz	a0,492 <go+0x3e8>
      } else if(pid < 0){
     464:	08054263          	bltz	a0,4e8 <go+0x43e>
      close(fds[0]);
     468:	f7842503          	lw	a0,-136(s0)
     46c:	015000ef          	jal	c80 <close>
      close(fds[1]);
     470:	f7c42503          	lw	a0,-132(s0)
     474:	00d000ef          	jal	c80 <close>
      wait(0);
     478:	4501                	li	a0,0
     47a:	7e6000ef          	jal	c60 <wait>
     47e:	b309                	j	180 <go+0xd6>
        printf("grind: pipe failed\n");
     480:	00001517          	auipc	a0,0x1
     484:	fa850513          	addi	a0,a0,-88 # 1428 <thread_join+0x18a>
     488:	417000ef          	jal	109e <printf>
        exit(1);
     48c:	4505                	li	a0,1
     48e:	7ca000ef          	jal	c58 <exit>
        fork();
     492:	798000ef          	jal	c2a <fork>
        fork();
     496:	794000ef          	jal	c2a <fork>
        if(write(fds[1], "x", 1) != 1)
     49a:	4605                	li	a2,1
     49c:	00001597          	auipc	a1,0x1
     4a0:	fa458593          	addi	a1,a1,-92 # 1440 <thread_join+0x1a2>
     4a4:	f7c42503          	lw	a0,-132(s0)
     4a8:	7d0000ef          	jal	c78 <write>
     4ac:	4785                	li	a5,1
     4ae:	00f51f63          	bne	a0,a5,4cc <go+0x422>
        if(read(fds[0], &c, 1) != 1)
     4b2:	4605                	li	a2,1
     4b4:	f7040593          	addi	a1,s0,-144
     4b8:	f7842503          	lw	a0,-136(s0)
     4bc:	7b4000ef          	jal	c70 <read>
     4c0:	4785                	li	a5,1
     4c2:	00f51c63          	bne	a0,a5,4da <go+0x430>
        exit(0);
     4c6:	4501                	li	a0,0
     4c8:	790000ef          	jal	c58 <exit>
          printf("grind: pipe write failed\n");
     4cc:	00001517          	auipc	a0,0x1
     4d0:	f7c50513          	addi	a0,a0,-132 # 1448 <thread_join+0x1aa>
     4d4:	3cb000ef          	jal	109e <printf>
     4d8:	bfe9                	j	4b2 <go+0x408>
          printf("grind: pipe read failed\n");
     4da:	00001517          	auipc	a0,0x1
     4de:	f8e50513          	addi	a0,a0,-114 # 1468 <thread_join+0x1ca>
     4e2:	3bd000ef          	jal	109e <printf>
     4e6:	b7c5                	j	4c6 <go+0x41c>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	ef850513          	addi	a0,a0,-264 # 13e0 <thread_join+0x142>
     4f0:	3af000ef          	jal	109e <printf>
        exit(1);
     4f4:	4505                	li	a0,1
     4f6:	762000ef          	jal	c58 <exit>
      int pid = fork();
     4fa:	730000ef          	jal	c2a <fork>
      if(pid == 0){
     4fe:	c519                	beqz	a0,50c <go+0x462>
      } else if(pid < 0){
     500:	04054f63          	bltz	a0,55e <go+0x4b4>
      wait(0);
     504:	4501                	li	a0,0
     506:	75a000ef          	jal	c60 <wait>
     50a:	b99d                	j	180 <go+0xd6>
        unlink("a");
     50c:	00001517          	auipc	a0,0x1
     510:	eec50513          	addi	a0,a0,-276 # 13f8 <thread_join+0x15a>
     514:	794000ef          	jal	ca8 <unlink>
        mkdir("a");
     518:	00001517          	auipc	a0,0x1
     51c:	ee050513          	addi	a0,a0,-288 # 13f8 <thread_join+0x15a>
     520:	7a0000ef          	jal	cc0 <mkdir>
        chdir("a");
     524:	00001517          	auipc	a0,0x1
     528:	ed450513          	addi	a0,a0,-300 # 13f8 <thread_join+0x15a>
     52c:	79c000ef          	jal	cc8 <chdir>
        unlink("../a");
     530:	00001517          	auipc	a0,0x1
     534:	f5850513          	addi	a0,a0,-168 # 1488 <thread_join+0x1ea>
     538:	770000ef          	jal	ca8 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     53c:	20200593          	li	a1,514
     540:	00001517          	auipc	a0,0x1
     544:	f0050513          	addi	a0,a0,-256 # 1440 <thread_join+0x1a2>
     548:	750000ef          	jal	c98 <open>
        unlink("x");
     54c:	00001517          	auipc	a0,0x1
     550:	ef450513          	addi	a0,a0,-268 # 1440 <thread_join+0x1a2>
     554:	754000ef          	jal	ca8 <unlink>
        exit(0);
     558:	4501                	li	a0,0
     55a:	6fe000ef          	jal	c58 <exit>
        printf("grind: fork failed\n");
     55e:	00001517          	auipc	a0,0x1
     562:	e8250513          	addi	a0,a0,-382 # 13e0 <thread_join+0x142>
     566:	339000ef          	jal	109e <printf>
        exit(1);
     56a:	4505                	li	a0,1
     56c:	6ec000ef          	jal	c58 <exit>
      unlink("c");
     570:	00001517          	auipc	a0,0x1
     574:	f2050513          	addi	a0,a0,-224 # 1490 <thread_join+0x1f2>
     578:	730000ef          	jal	ca8 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     57c:	20200593          	li	a1,514
     580:	00001517          	auipc	a0,0x1
     584:	f1050513          	addi	a0,a0,-240 # 1490 <thread_join+0x1f2>
     588:	710000ef          	jal	c98 <open>
     58c:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     58e:	04054563          	bltz	a0,5d8 <go+0x52e>
      if(write(fd1, "x", 1) != 1){
     592:	8652                	mv	a2,s4
     594:	00001597          	auipc	a1,0x1
     598:	eac58593          	addi	a1,a1,-340 # 1440 <thread_join+0x1a2>
     59c:	6dc000ef          	jal	c78 <write>
     5a0:	05451563          	bne	a0,s4,5ea <go+0x540>
      if(fstat(fd1, &st) != 0){
     5a4:	f7840593          	addi	a1,s0,-136
     5a8:	856a                	mv	a0,s10
     5aa:	706000ef          	jal	cb0 <fstat>
     5ae:	e539                	bnez	a0,5fc <go+0x552>
      if(st.size != 1){
     5b0:	f8843583          	ld	a1,-120(s0)
     5b4:	05459d63          	bne	a1,s4,60e <go+0x564>
      if(st.ino > 200){
     5b8:	f7c42583          	lw	a1,-132(s0)
     5bc:	0c800793          	li	a5,200
     5c0:	06b7e163          	bltu	a5,a1,622 <go+0x578>
      close(fd1);
     5c4:	856a                	mv	a0,s10
     5c6:	6ba000ef          	jal	c80 <close>
      unlink("c");
     5ca:	00001517          	auipc	a0,0x1
     5ce:	ec650513          	addi	a0,a0,-314 # 1490 <thread_join+0x1f2>
     5d2:	6d6000ef          	jal	ca8 <unlink>
     5d6:	b66d                	j	180 <go+0xd6>
        printf("grind: create c failed\n");
     5d8:	00001517          	auipc	a0,0x1
     5dc:	ec050513          	addi	a0,a0,-320 # 1498 <thread_join+0x1fa>
     5e0:	2bf000ef          	jal	109e <printf>
        exit(1);
     5e4:	4505                	li	a0,1
     5e6:	672000ef          	jal	c58 <exit>
        printf("grind: write c failed\n");
     5ea:	00001517          	auipc	a0,0x1
     5ee:	ec650513          	addi	a0,a0,-314 # 14b0 <thread_join+0x212>
     5f2:	2ad000ef          	jal	109e <printf>
        exit(1);
     5f6:	4505                	li	a0,1
     5f8:	660000ef          	jal	c58 <exit>
        printf("grind: fstat failed\n");
     5fc:	00001517          	auipc	a0,0x1
     600:	ecc50513          	addi	a0,a0,-308 # 14c8 <thread_join+0x22a>
     604:	29b000ef          	jal	109e <printf>
        exit(1);
     608:	4505                	li	a0,1
     60a:	64e000ef          	jal	c58 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60e:	2581                	sext.w	a1,a1
     610:	00001517          	auipc	a0,0x1
     614:	ed050513          	addi	a0,a0,-304 # 14e0 <thread_join+0x242>
     618:	287000ef          	jal	109e <printf>
        exit(1);
     61c:	4505                	li	a0,1
     61e:	63a000ef          	jal	c58 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     622:	00001517          	auipc	a0,0x1
     626:	ee650513          	addi	a0,a0,-282 # 1508 <thread_join+0x26a>
     62a:	275000ef          	jal	109e <printf>
        exit(1);
     62e:	4505                	li	a0,1
     630:	628000ef          	jal	c58 <exit>
      if(pipe(aa) < 0){
     634:	856e                	mv	a0,s11
     636:	632000ef          	jal	c68 <pipe>
     63a:	0c054263          	bltz	a0,6fe <go+0x654>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     63e:	f7040513          	addi	a0,s0,-144
     642:	626000ef          	jal	c68 <pipe>
     646:	0c054663          	bltz	a0,712 <go+0x668>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     64a:	5e0000ef          	jal	c2a <fork>
      if(pid1 == 0){
     64e:	0c050c63          	beqz	a0,726 <go+0x67c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     652:	14054e63          	bltz	a0,7ae <go+0x704>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     656:	5d4000ef          	jal	c2a <fork>
      if(pid2 == 0){
     65a:	16050463          	beqz	a0,7c2 <go+0x718>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     65e:	20054263          	bltz	a0,862 <go+0x7b8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     662:	f6842503          	lw	a0,-152(s0)
     666:	61a000ef          	jal	c80 <close>
      close(aa[1]);
     66a:	f6c42503          	lw	a0,-148(s0)
     66e:	612000ef          	jal	c80 <close>
      close(bb[1]);
     672:	f7442503          	lw	a0,-140(s0)
     676:	60a000ef          	jal	c80 <close>
      char buf[4] = { 0, 0, 0, 0 };
     67a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     67e:	8652                	mv	a2,s4
     680:	f6040593          	addi	a1,s0,-160
     684:	f7042503          	lw	a0,-144(s0)
     688:	5e8000ef          	jal	c70 <read>
      read(bb[0], buf+1, 1);
     68c:	8652                	mv	a2,s4
     68e:	f6140593          	addi	a1,s0,-159
     692:	f7042503          	lw	a0,-144(s0)
     696:	5da000ef          	jal	c70 <read>
      read(bb[0], buf+2, 1);
     69a:	8652                	mv	a2,s4
     69c:	f6240593          	addi	a1,s0,-158
     6a0:	f7042503          	lw	a0,-144(s0)
     6a4:	5cc000ef          	jal	c70 <read>
      close(bb[0]);
     6a8:	f7042503          	lw	a0,-144(s0)
     6ac:	5d4000ef          	jal	c80 <close>
      int st1, st2;
      wait(&st1);
     6b0:	f6440513          	addi	a0,s0,-156
     6b4:	5ac000ef          	jal	c60 <wait>
      wait(&st2);
     6b8:	f7840513          	addi	a0,s0,-136
     6bc:	5a4000ef          	jal	c60 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     6c0:	f6442783          	lw	a5,-156(s0)
     6c4:	f7842703          	lw	a4,-136(s0)
     6c8:	8fd9                	or	a5,a5,a4
     6ca:	eb99                	bnez	a5,6e0 <go+0x636>
     6cc:	00001597          	auipc	a1,0x1
     6d0:	edc58593          	addi	a1,a1,-292 # 15a8 <thread_join+0x30a>
     6d4:	f6040513          	addi	a0,s0,-160
     6d8:	2d4000ef          	jal	9ac <strcmp>
     6dc:	aa0502e3          	beqz	a0,180 <go+0xd6>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     6e0:	f6040693          	addi	a3,s0,-160
     6e4:	f7842603          	lw	a2,-136(s0)
     6e8:	f6442583          	lw	a1,-156(s0)
     6ec:	00001517          	auipc	a0,0x1
     6f0:	ec450513          	addi	a0,a0,-316 # 15b0 <thread_join+0x312>
     6f4:	1ab000ef          	jal	109e <printf>
        exit(1);
     6f8:	4505                	li	a0,1
     6fa:	55e000ef          	jal	c58 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fe:	00001597          	auipc	a1,0x1
     702:	d2a58593          	addi	a1,a1,-726 # 1428 <thread_join+0x18a>
     706:	4509                	li	a0,2
     708:	16d000ef          	jal	1074 <fprintf>
        exit(1);
     70c:	4505                	li	a0,1
     70e:	54a000ef          	jal	c58 <exit>
        fprintf(2, "grind: pipe failed\n");
     712:	00001597          	auipc	a1,0x1
     716:	d1658593          	addi	a1,a1,-746 # 1428 <thread_join+0x18a>
     71a:	4509                	li	a0,2
     71c:	159000ef          	jal	1074 <fprintf>
        exit(1);
     720:	4505                	li	a0,1
     722:	536000ef          	jal	c58 <exit>
        close(bb[0]);
     726:	f7042503          	lw	a0,-144(s0)
     72a:	556000ef          	jal	c80 <close>
        close(bb[1]);
     72e:	f7442503          	lw	a0,-140(s0)
     732:	54e000ef          	jal	c80 <close>
        close(aa[0]);
     736:	f6842503          	lw	a0,-152(s0)
     73a:	546000ef          	jal	c80 <close>
        close(1);
     73e:	4505                	li	a0,1
     740:	540000ef          	jal	c80 <close>
        if(dup(aa[1]) != 1){
     744:	f6c42503          	lw	a0,-148(s0)
     748:	588000ef          	jal	cd0 <dup>
     74c:	4785                	li	a5,1
     74e:	00f50c63          	beq	a0,a5,766 <go+0x6bc>
          fprintf(2, "grind: dup failed\n");
     752:	00001597          	auipc	a1,0x1
     756:	dde58593          	addi	a1,a1,-546 # 1530 <thread_join+0x292>
     75a:	4509                	li	a0,2
     75c:	119000ef          	jal	1074 <fprintf>
          exit(1);
     760:	4505                	li	a0,1
     762:	4f6000ef          	jal	c58 <exit>
        close(aa[1]);
     766:	f6c42503          	lw	a0,-148(s0)
     76a:	516000ef          	jal	c80 <close>
        char *args[3] = { "echo", "hi", 0 };
     76e:	00001797          	auipc	a5,0x1
     772:	dda78793          	addi	a5,a5,-550 # 1548 <thread_join+0x2aa>
     776:	f6f43c23          	sd	a5,-136(s0)
     77a:	00001797          	auipc	a5,0x1
     77e:	dd678793          	addi	a5,a5,-554 # 1550 <thread_join+0x2b2>
     782:	f8f43023          	sd	a5,-128(s0)
     786:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     78a:	f7840593          	addi	a1,s0,-136
     78e:	00001517          	auipc	a0,0x1
     792:	dca50513          	addi	a0,a0,-566 # 1558 <thread_join+0x2ba>
     796:	4fa000ef          	jal	c90 <exec>
        fprintf(2, "grind: echo: not found\n");
     79a:	00001597          	auipc	a1,0x1
     79e:	dce58593          	addi	a1,a1,-562 # 1568 <thread_join+0x2ca>
     7a2:	4509                	li	a0,2
     7a4:	0d1000ef          	jal	1074 <fprintf>
        exit(2);
     7a8:	4509                	li	a0,2
     7aa:	4ae000ef          	jal	c58 <exit>
        fprintf(2, "grind: fork failed\n");
     7ae:	00001597          	auipc	a1,0x1
     7b2:	c3258593          	addi	a1,a1,-974 # 13e0 <thread_join+0x142>
     7b6:	4509                	li	a0,2
     7b8:	0bd000ef          	jal	1074 <fprintf>
        exit(3);
     7bc:	450d                	li	a0,3
     7be:	49a000ef          	jal	c58 <exit>
        close(aa[1]);
     7c2:	f6c42503          	lw	a0,-148(s0)
     7c6:	4ba000ef          	jal	c80 <close>
        close(bb[0]);
     7ca:	f7042503          	lw	a0,-144(s0)
     7ce:	4b2000ef          	jal	c80 <close>
        close(0);
     7d2:	4501                	li	a0,0
     7d4:	4ac000ef          	jal	c80 <close>
        if(dup(aa[0]) != 0){
     7d8:	f6842503          	lw	a0,-152(s0)
     7dc:	4f4000ef          	jal	cd0 <dup>
     7e0:	c919                	beqz	a0,7f6 <go+0x74c>
          fprintf(2, "grind: dup failed\n");
     7e2:	00001597          	auipc	a1,0x1
     7e6:	d4e58593          	addi	a1,a1,-690 # 1530 <thread_join+0x292>
     7ea:	4509                	li	a0,2
     7ec:	089000ef          	jal	1074 <fprintf>
          exit(4);
     7f0:	4511                	li	a0,4
     7f2:	466000ef          	jal	c58 <exit>
        close(aa[0]);
     7f6:	f6842503          	lw	a0,-152(s0)
     7fa:	486000ef          	jal	c80 <close>
        close(1);
     7fe:	4505                	li	a0,1
     800:	480000ef          	jal	c80 <close>
        if(dup(bb[1]) != 1){
     804:	f7442503          	lw	a0,-140(s0)
     808:	4c8000ef          	jal	cd0 <dup>
     80c:	4785                	li	a5,1
     80e:	00f50c63          	beq	a0,a5,826 <go+0x77c>
          fprintf(2, "grind: dup failed\n");
     812:	00001597          	auipc	a1,0x1
     816:	d1e58593          	addi	a1,a1,-738 # 1530 <thread_join+0x292>
     81a:	4509                	li	a0,2
     81c:	059000ef          	jal	1074 <fprintf>
          exit(5);
     820:	4515                	li	a0,5
     822:	436000ef          	jal	c58 <exit>
        close(bb[1]);
     826:	f7442503          	lw	a0,-140(s0)
     82a:	456000ef          	jal	c80 <close>
        char *args[2] = { "cat", 0 };
     82e:	00001797          	auipc	a5,0x1
     832:	d5278793          	addi	a5,a5,-686 # 1580 <thread_join+0x2e2>
     836:	f6f43c23          	sd	a5,-136(s0)
     83a:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     83e:	f7840593          	addi	a1,s0,-136
     842:	00001517          	auipc	a0,0x1
     846:	d4650513          	addi	a0,a0,-698 # 1588 <thread_join+0x2ea>
     84a:	446000ef          	jal	c90 <exec>
        fprintf(2, "grind: cat: not found\n");
     84e:	00001597          	auipc	a1,0x1
     852:	d4258593          	addi	a1,a1,-702 # 1590 <thread_join+0x2f2>
     856:	4509                	li	a0,2
     858:	01d000ef          	jal	1074 <fprintf>
        exit(6);
     85c:	4519                	li	a0,6
     85e:	3fa000ef          	jal	c58 <exit>
        fprintf(2, "grind: fork failed\n");
     862:	00001597          	auipc	a1,0x1
     866:	b7e58593          	addi	a1,a1,-1154 # 13e0 <thread_join+0x142>
     86a:	4509                	li	a0,2
     86c:	009000ef          	jal	1074 <fprintf>
        exit(7);
     870:	451d                	li	a0,7
     872:	3e6000ef          	jal	c58 <exit>

0000000000000876 <iter>:
  }
}

void
iter()
{
     876:	7179                	addi	sp,sp,-48
     878:	f406                	sd	ra,40(sp)
     87a:	f022                	sd	s0,32(sp)
     87c:	1800                	addi	s0,sp,48
  unlink("a");
     87e:	00001517          	auipc	a0,0x1
     882:	b7a50513          	addi	a0,a0,-1158 # 13f8 <thread_join+0x15a>
     886:	422000ef          	jal	ca8 <unlink>
  unlink("b");
     88a:	00001517          	auipc	a0,0x1
     88e:	b1e50513          	addi	a0,a0,-1250 # 13a8 <thread_join+0x10a>
     892:	416000ef          	jal	ca8 <unlink>

  int pid1 = fork();
     896:	394000ef          	jal	c2a <fork>
  if(pid1 < 0){
     89a:	02054163          	bltz	a0,8bc <iter+0x46>
     89e:	ec26                	sd	s1,24(sp)
     8a0:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     8a2:	e905                	bnez	a0,8d2 <iter+0x5c>
     8a4:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8a6:	00001717          	auipc	a4,0x1
     8aa:	75a70713          	addi	a4,a4,1882 # 2000 <rand_next>
     8ae:	631c                	ld	a5,0(a4)
     8b0:	01f7c793          	xori	a5,a5,31
     8b4:	e31c                	sd	a5,0(a4)
    go(0);
     8b6:	4501                	li	a0,0
     8b8:	ff2ff0ef          	jal	aa <go>
     8bc:	ec26                	sd	s1,24(sp)
     8be:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8c0:	00001517          	auipc	a0,0x1
     8c4:	b2050513          	addi	a0,a0,-1248 # 13e0 <thread_join+0x142>
     8c8:	7d6000ef          	jal	109e <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	38a000ef          	jal	c58 <exit>
     8d2:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8d4:	356000ef          	jal	c2a <fork>
     8d8:	892a                	mv	s2,a0
  if(pid2 < 0){
     8da:	02054063          	bltz	a0,8fa <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     8de:	e51d                	bnez	a0,90c <iter+0x96>
    rand_next ^= 7177;
     8e0:	00001697          	auipc	a3,0x1
     8e4:	72068693          	addi	a3,a3,1824 # 2000 <rand_next>
     8e8:	629c                	ld	a5,0(a3)
     8ea:	6709                	lui	a4,0x2
     8ec:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x5c9>
     8f0:	8fb9                	xor	a5,a5,a4
     8f2:	e29c                	sd	a5,0(a3)
    go(1);
     8f4:	4505                	li	a0,1
     8f6:	fb4ff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     8fa:	00001517          	auipc	a0,0x1
     8fe:	ae650513          	addi	a0,a0,-1306 # 13e0 <thread_join+0x142>
     902:	79c000ef          	jal	109e <printf>
    exit(1);
     906:	4505                	li	a0,1
     908:	350000ef          	jal	c58 <exit>
    exit(0);
  }

  int st1 = -1;
     90c:	57fd                	li	a5,-1
     90e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     912:	fdc40513          	addi	a0,s0,-36
     916:	34a000ef          	jal	c60 <wait>
  if(st1 != 0){
     91a:	fdc42783          	lw	a5,-36(s0)
     91e:	eb99                	bnez	a5,934 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     920:	57fd                	li	a5,-1
     922:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     926:	fd840513          	addi	a0,s0,-40
     92a:	336000ef          	jal	c60 <wait>

  exit(0);
     92e:	4501                	li	a0,0
     930:	328000ef          	jal	c58 <exit>
    kill(pid1);
     934:	8526                	mv	a0,s1
     936:	352000ef          	jal	c88 <kill>
    kill(pid2);
     93a:	854a                	mv	a0,s2
     93c:	34c000ef          	jal	c88 <kill>
     940:	b7c5                	j	920 <iter+0xaa>

0000000000000942 <main>:
}

int
main()
{
     942:	1101                	addi	sp,sp,-32
     944:	ec06                	sd	ra,24(sp)
     946:	e822                	sd	s0,16(sp)
     948:	e426                	sd	s1,8(sp)
     94a:	e04a                	sd	s2,0(sp)
     94c:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    pause(20);
     94e:	4951                	li	s2,20
    rand_next += 1;
     950:	00001497          	auipc	s1,0x1
     954:	6b048493          	addi	s1,s1,1712 # 2000 <rand_next>
     958:	a809                	j	96a <main+0x28>
      iter();
     95a:	f1dff0ef          	jal	876 <iter>
    pause(20);
     95e:	854a                	mv	a0,s2
     960:	388000ef          	jal	ce8 <pause>
    rand_next += 1;
     964:	609c                	ld	a5,0(s1)
     966:	0785                	addi	a5,a5,1
     968:	e09c                	sd	a5,0(s1)
    int pid = fork();
     96a:	2c0000ef          	jal	c2a <fork>
    if(pid == 0){
     96e:	d575                	beqz	a0,95a <main+0x18>
    if(pid > 0){
     970:	fea057e3          	blez	a0,95e <main+0x1c>
      wait(0);
     974:	4501                	li	a0,0
     976:	2ea000ef          	jal	c60 <wait>
     97a:	b7d5                	j	95e <main+0x1c>

000000000000097c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     97c:	1141                	addi	sp,sp,-16
     97e:	e406                	sd	ra,8(sp)
     980:	e022                	sd	s0,0(sp)
     982:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     984:	fbfff0ef          	jal	942 <main>
  exit(r);
     988:	2d0000ef          	jal	c58 <exit>

000000000000098c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     98c:	1141                	addi	sp,sp,-16
     98e:	e406                	sd	ra,8(sp)
     990:	e022                	sd	s0,0(sp)
     992:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     994:	87aa                	mv	a5,a0
     996:	0585                	addi	a1,a1,1
     998:	0785                	addi	a5,a5,1
     99a:	fff5c703          	lbu	a4,-1(a1)
     99e:	fee78fa3          	sb	a4,-1(a5)
     9a2:	fb75                	bnez	a4,996 <strcpy+0xa>
    ;
  return os;
}
     9a4:	60a2                	ld	ra,8(sp)
     9a6:	6402                	ld	s0,0(sp)
     9a8:	0141                	addi	sp,sp,16
     9aa:	8082                	ret

00000000000009ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9ac:	1141                	addi	sp,sp,-16
     9ae:	e406                	sd	ra,8(sp)
     9b0:	e022                	sd	s0,0(sp)
     9b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9b4:	00054783          	lbu	a5,0(a0)
     9b8:	cb91                	beqz	a5,9cc <strcmp+0x20>
     9ba:	0005c703          	lbu	a4,0(a1)
     9be:	00f71763          	bne	a4,a5,9cc <strcmp+0x20>
    p++, q++;
     9c2:	0505                	addi	a0,a0,1
     9c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9c6:	00054783          	lbu	a5,0(a0)
     9ca:	fbe5                	bnez	a5,9ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9cc:	0005c503          	lbu	a0,0(a1)
}
     9d0:	40a7853b          	subw	a0,a5,a0
     9d4:	60a2                	ld	ra,8(sp)
     9d6:	6402                	ld	s0,0(sp)
     9d8:	0141                	addi	sp,sp,16
     9da:	8082                	ret

00000000000009dc <strlen>:

uint
strlen(const char *s)
{
     9dc:	1141                	addi	sp,sp,-16
     9de:	e406                	sd	ra,8(sp)
     9e0:	e022                	sd	s0,0(sp)
     9e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9e4:	00054783          	lbu	a5,0(a0)
     9e8:	cf91                	beqz	a5,a04 <strlen+0x28>
     9ea:	00150793          	addi	a5,a0,1
     9ee:	86be                	mv	a3,a5
     9f0:	0785                	addi	a5,a5,1
     9f2:	fff7c703          	lbu	a4,-1(a5)
     9f6:	ff65                	bnez	a4,9ee <strlen+0x12>
     9f8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     9fc:	60a2                	ld	ra,8(sp)
     9fe:	6402                	ld	s0,0(sp)
     a00:	0141                	addi	sp,sp,16
     a02:	8082                	ret
  for(n = 0; s[n]; n++)
     a04:	4501                	li	a0,0
     a06:	bfdd                	j	9fc <strlen+0x20>

0000000000000a08 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a08:	1141                	addi	sp,sp,-16
     a0a:	e406                	sd	ra,8(sp)
     a0c:	e022                	sd	s0,0(sp)
     a0e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a10:	ca19                	beqz	a2,a26 <memset+0x1e>
     a12:	87aa                	mv	a5,a0
     a14:	1602                	slli	a2,a2,0x20
     a16:	9201                	srli	a2,a2,0x20
     a18:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a1c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a20:	0785                	addi	a5,a5,1
     a22:	fee79de3          	bne	a5,a4,a1c <memset+0x14>
  }
  return dst;
}
     a26:	60a2                	ld	ra,8(sp)
     a28:	6402                	ld	s0,0(sp)
     a2a:	0141                	addi	sp,sp,16
     a2c:	8082                	ret

0000000000000a2e <strchr>:

char*
strchr(const char *s, char c)
{
     a2e:	1141                	addi	sp,sp,-16
     a30:	e406                	sd	ra,8(sp)
     a32:	e022                	sd	s0,0(sp)
     a34:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a36:	00054783          	lbu	a5,0(a0)
     a3a:	cf81                	beqz	a5,a52 <strchr+0x24>
    if(*s == c)
     a3c:	00f58763          	beq	a1,a5,a4a <strchr+0x1c>
  for(; *s; s++)
     a40:	0505                	addi	a0,a0,1
     a42:	00054783          	lbu	a5,0(a0)
     a46:	fbfd                	bnez	a5,a3c <strchr+0xe>
      return (char*)s;
  return 0;
     a48:	4501                	li	a0,0
}
     a4a:	60a2                	ld	ra,8(sp)
     a4c:	6402                	ld	s0,0(sp)
     a4e:	0141                	addi	sp,sp,16
     a50:	8082                	ret
  return 0;
     a52:	4501                	li	a0,0
     a54:	bfdd                	j	a4a <strchr+0x1c>

0000000000000a56 <gets>:

char*
gets(char *buf, int max)
{
     a56:	711d                	addi	sp,sp,-96
     a58:	ec86                	sd	ra,88(sp)
     a5a:	e8a2                	sd	s0,80(sp)
     a5c:	e4a6                	sd	s1,72(sp)
     a5e:	e0ca                	sd	s2,64(sp)
     a60:	fc4e                	sd	s3,56(sp)
     a62:	f852                	sd	s4,48(sp)
     a64:	f456                	sd	s5,40(sp)
     a66:	f05a                	sd	s6,32(sp)
     a68:	ec5e                	sd	s7,24(sp)
     a6a:	e862                	sd	s8,16(sp)
     a6c:	1080                	addi	s0,sp,96
     a6e:	8baa                	mv	s7,a0
     a70:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a72:	892a                	mv	s2,a0
     a74:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a76:	faf40b13          	addi	s6,s0,-81
     a7a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     a7c:	8c26                	mv	s8,s1
     a7e:	0014899b          	addiw	s3,s1,1
     a82:	84ce                	mv	s1,s3
     a84:	0349d463          	bge	s3,s4,aac <gets+0x56>
    cc = read(0, &c, 1);
     a88:	8656                	mv	a2,s5
     a8a:	85da                	mv	a1,s6
     a8c:	4501                	li	a0,0
     a8e:	1e2000ef          	jal	c70 <read>
    if(cc < 1)
     a92:	00a05d63          	blez	a0,aac <gets+0x56>
      break;
    buf[i++] = c;
     a96:	faf44783          	lbu	a5,-81(s0)
     a9a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a9e:	0905                	addi	s2,s2,1
     aa0:	ff678713          	addi	a4,a5,-10
     aa4:	c319                	beqz	a4,aaa <gets+0x54>
     aa6:	17cd                	addi	a5,a5,-13
     aa8:	fbf1                	bnez	a5,a7c <gets+0x26>
    buf[i++] = c;
     aaa:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     aac:	9c5e                	add	s8,s8,s7
     aae:	000c0023          	sb	zero,0(s8)
  return buf;
}
     ab2:	855e                	mv	a0,s7
     ab4:	60e6                	ld	ra,88(sp)
     ab6:	6446                	ld	s0,80(sp)
     ab8:	64a6                	ld	s1,72(sp)
     aba:	6906                	ld	s2,64(sp)
     abc:	79e2                	ld	s3,56(sp)
     abe:	7a42                	ld	s4,48(sp)
     ac0:	7aa2                	ld	s5,40(sp)
     ac2:	7b02                	ld	s6,32(sp)
     ac4:	6be2                	ld	s7,24(sp)
     ac6:	6c42                	ld	s8,16(sp)
     ac8:	6125                	addi	sp,sp,96
     aca:	8082                	ret

0000000000000acc <stat>:

int
stat(const char *n, struct stat *st)
{
     acc:	1101                	addi	sp,sp,-32
     ace:	ec06                	sd	ra,24(sp)
     ad0:	e822                	sd	s0,16(sp)
     ad2:	e04a                	sd	s2,0(sp)
     ad4:	1000                	addi	s0,sp,32
     ad6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ad8:	4581                	li	a1,0
     ada:	1be000ef          	jal	c98 <open>
  if(fd < 0)
     ade:	02054263          	bltz	a0,b02 <stat+0x36>
     ae2:	e426                	sd	s1,8(sp)
     ae4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ae6:	85ca                	mv	a1,s2
     ae8:	1c8000ef          	jal	cb0 <fstat>
     aec:	892a                	mv	s2,a0
  close(fd);
     aee:	8526                	mv	a0,s1
     af0:	190000ef          	jal	c80 <close>
  return r;
     af4:	64a2                	ld	s1,8(sp)
}
     af6:	854a                	mv	a0,s2
     af8:	60e2                	ld	ra,24(sp)
     afa:	6442                	ld	s0,16(sp)
     afc:	6902                	ld	s2,0(sp)
     afe:	6105                	addi	sp,sp,32
     b00:	8082                	ret
    return -1;
     b02:	57fd                	li	a5,-1
     b04:	893e                	mv	s2,a5
     b06:	bfc5                	j	af6 <stat+0x2a>

0000000000000b08 <atoi>:

int
atoi(const char *s)
{
     b08:	1141                	addi	sp,sp,-16
     b0a:	e406                	sd	ra,8(sp)
     b0c:	e022                	sd	s0,0(sp)
     b0e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b10:	00054683          	lbu	a3,0(a0)
     b14:	fd06879b          	addiw	a5,a3,-48
     b18:	0ff7f793          	zext.b	a5,a5
     b1c:	4625                	li	a2,9
     b1e:	02f66963          	bltu	a2,a5,b50 <atoi+0x48>
     b22:	872a                	mv	a4,a0
  n = 0;
     b24:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b26:	0705                	addi	a4,a4,1
     b28:	0025179b          	slliw	a5,a0,0x2
     b2c:	9fa9                	addw	a5,a5,a0
     b2e:	0017979b          	slliw	a5,a5,0x1
     b32:	9fb5                	addw	a5,a5,a3
     b34:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b38:	00074683          	lbu	a3,0(a4)
     b3c:	fd06879b          	addiw	a5,a3,-48
     b40:	0ff7f793          	zext.b	a5,a5
     b44:	fef671e3          	bgeu	a2,a5,b26 <atoi+0x1e>
  return n;
}
     b48:	60a2                	ld	ra,8(sp)
     b4a:	6402                	ld	s0,0(sp)
     b4c:	0141                	addi	sp,sp,16
     b4e:	8082                	ret
  n = 0;
     b50:	4501                	li	a0,0
     b52:	bfdd                	j	b48 <atoi+0x40>

0000000000000b54 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b54:	1141                	addi	sp,sp,-16
     b56:	e406                	sd	ra,8(sp)
     b58:	e022                	sd	s0,0(sp)
     b5a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b5c:	02b57563          	bgeu	a0,a1,b86 <memmove+0x32>
    while(n-- > 0)
     b60:	00c05f63          	blez	a2,b7e <memmove+0x2a>
     b64:	1602                	slli	a2,a2,0x20
     b66:	9201                	srli	a2,a2,0x20
     b68:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b6c:	872a                	mv	a4,a0
      *dst++ = *src++;
     b6e:	0585                	addi	a1,a1,1
     b70:	0705                	addi	a4,a4,1
     b72:	fff5c683          	lbu	a3,-1(a1)
     b76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b7a:	fee79ae3          	bne	a5,a4,b6e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b7e:	60a2                	ld	ra,8(sp)
     b80:	6402                	ld	s0,0(sp)
     b82:	0141                	addi	sp,sp,16
     b84:	8082                	ret
    while(n-- > 0)
     b86:	fec05ce3          	blez	a2,b7e <memmove+0x2a>
    dst += n;
     b8a:	00c50733          	add	a4,a0,a2
    src += n;
     b8e:	95b2                	add	a1,a1,a2
     b90:	fff6079b          	addiw	a5,a2,-1
     b94:	1782                	slli	a5,a5,0x20
     b96:	9381                	srli	a5,a5,0x20
     b98:	fff7c793          	not	a5,a5
     b9c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b9e:	15fd                	addi	a1,a1,-1
     ba0:	177d                	addi	a4,a4,-1
     ba2:	0005c683          	lbu	a3,0(a1)
     ba6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     baa:	fef71ae3          	bne	a4,a5,b9e <memmove+0x4a>
     bae:	bfc1                	j	b7e <memmove+0x2a>

0000000000000bb0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bb0:	1141                	addi	sp,sp,-16
     bb2:	e406                	sd	ra,8(sp)
     bb4:	e022                	sd	s0,0(sp)
     bb6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bb8:	c61d                	beqz	a2,be6 <memcmp+0x36>
     bba:	1602                	slli	a2,a2,0x20
     bbc:	9201                	srli	a2,a2,0x20
     bbe:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     bc2:	00054783          	lbu	a5,0(a0)
     bc6:	0005c703          	lbu	a4,0(a1)
     bca:	00e79863          	bne	a5,a4,bda <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     bce:	0505                	addi	a0,a0,1
    p2++;
     bd0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bd2:	fed518e3          	bne	a0,a3,bc2 <memcmp+0x12>
  }
  return 0;
     bd6:	4501                	li	a0,0
     bd8:	a019                	j	bde <memcmp+0x2e>
      return *p1 - *p2;
     bda:	40e7853b          	subw	a0,a5,a4
}
     bde:	60a2                	ld	ra,8(sp)
     be0:	6402                	ld	s0,0(sp)
     be2:	0141                	addi	sp,sp,16
     be4:	8082                	ret
  return 0;
     be6:	4501                	li	a0,0
     be8:	bfdd                	j	bde <memcmp+0x2e>

0000000000000bea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bea:	1141                	addi	sp,sp,-16
     bec:	e406                	sd	ra,8(sp)
     bee:	e022                	sd	s0,0(sp)
     bf0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bf2:	f63ff0ef          	jal	b54 <memmove>
}
     bf6:	60a2                	ld	ra,8(sp)
     bf8:	6402                	ld	s0,0(sp)
     bfa:	0141                	addi	sp,sp,16
     bfc:	8082                	ret

0000000000000bfe <sbrk>:

char *
sbrk(int n) {
     bfe:	1141                	addi	sp,sp,-16
     c00:	e406                	sd	ra,8(sp)
     c02:	e022                	sd	s0,0(sp)
     c04:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c06:	4585                	li	a1,1
     c08:	0d8000ef          	jal	ce0 <sys_sbrk>
}
     c0c:	60a2                	ld	ra,8(sp)
     c0e:	6402                	ld	s0,0(sp)
     c10:	0141                	addi	sp,sp,16
     c12:	8082                	ret

0000000000000c14 <sbrklazy>:

char *
sbrklazy(int n) {
     c14:	1141                	addi	sp,sp,-16
     c16:	e406                	sd	ra,8(sp)
     c18:	e022                	sd	s0,0(sp)
     c1a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c1c:	4589                	li	a1,2
     c1e:	0c2000ef          	jal	ce0 <sys_sbrk>
}
     c22:	60a2                	ld	ra,8(sp)
     c24:	6402                	ld	s0,0(sp)
     c26:	0141                	addi	sp,sp,16
     c28:	8082                	ret

0000000000000c2a <fork>:

int
fork(void)
{
     c2a:	1141                	addi	sp,sp,-16
     c2c:	e406                	sd	ra,8(sp)
     c2e:	e022                	sd	s0,0(sp)
     c30:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
     c32:	4701                	li	a4,0
     c34:	4681                	li	a3,0
     c36:	4601                	li	a2,0
     c38:	4581                	li	a1,0
     c3a:	4501                	li	a0,0
     c3c:	00c000ef          	jal	c48 <clone>
}
     c40:	60a2                	ld	ra,8(sp)
     c42:	6402                	ld	s0,0(sp)
     c44:	0141                	addi	sp,sp,16
     c46:	8082                	ret

0000000000000c48 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
     c48:	4885                	li	a7,1
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <join>:
.global join
join:
 li a7, SYS_join
     c50:	48d9                	li	a7,22
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c58:	4889                	li	a7,2
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c60:	488d                	li	a7,3
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c68:	4891                	li	a7,4
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <read>:
.global read
read:
 li a7, SYS_read
     c70:	4895                	li	a7,5
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <write>:
.global write
write:
 li a7, SYS_write
     c78:	48c1                	li	a7,16
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <close>:
.global close
close:
 li a7, SYS_close
     c80:	48d5                	li	a7,21
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c88:	4899                	li	a7,6
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c90:	489d                	li	a7,7
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <open>:
.global open
open:
 li a7, SYS_open
     c98:	48bd                	li	a7,15
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ca0:	48c5                	li	a7,17
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ca8:	48c9                	li	a7,18
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cb0:	48a1                	li	a7,8
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <link>:
.global link
link:
 li a7, SYS_link
     cb8:	48cd                	li	a7,19
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cc0:	48d1                	li	a7,20
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cc8:	48a5                	li	a7,9
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cd0:	48a9                	li	a7,10
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cd8:	48ad                	li	a7,11
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     ce0:	48b1                	li	a7,12
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <pause>:
.global pause
pause:
 li a7, SYS_pause
     ce8:	48b5                	li	a7,13
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cf0:	48b9                	li	a7,14
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cf8:	1101                	addi	sp,sp,-32
     cfa:	ec06                	sd	ra,24(sp)
     cfc:	e822                	sd	s0,16(sp)
     cfe:	1000                	addi	s0,sp,32
     d00:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d04:	4605                	li	a2,1
     d06:	fef40593          	addi	a1,s0,-17
     d0a:	f6fff0ef          	jal	c78 <write>
}
     d0e:	60e2                	ld	ra,24(sp)
     d10:	6442                	ld	s0,16(sp)
     d12:	6105                	addi	sp,sp,32
     d14:	8082                	ret

0000000000000d16 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d16:	715d                	addi	sp,sp,-80
     d18:	e486                	sd	ra,72(sp)
     d1a:	e0a2                	sd	s0,64(sp)
     d1c:	f84a                	sd	s2,48(sp)
     d1e:	f44e                	sd	s3,40(sp)
     d20:	0880                	addi	s0,sp,80
     d22:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     d24:	c6d1                	beqz	a3,db0 <printint+0x9a>
     d26:	0805d563          	bgez	a1,db0 <printint+0x9a>
    neg = 1;
    x = -xx;
     d2a:	40b005b3          	neg	a1,a1
    neg = 1;
     d2e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d30:	fb840993          	addi	s3,s0,-72
  neg = 0;
     d34:	86ce                	mv	a3,s3
  i = 0;
     d36:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d38:	00001817          	auipc	a6,0x1
     d3c:	90880813          	addi	a6,a6,-1784 # 1640 <digits>
     d40:	88ba                	mv	a7,a4
     d42:	0017051b          	addiw	a0,a4,1
     d46:	872a                	mv	a4,a0
     d48:	02c5f7b3          	remu	a5,a1,a2
     d4c:	97c2                	add	a5,a5,a6
     d4e:	0007c783          	lbu	a5,0(a5)
     d52:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d56:	87ae                	mv	a5,a1
     d58:	02c5d5b3          	divu	a1,a1,a2
     d5c:	0685                	addi	a3,a3,1
     d5e:	fec7f1e3          	bgeu	a5,a2,d40 <printint+0x2a>
  if(neg)
     d62:	00030c63          	beqz	t1,d7a <printint+0x64>
    buf[i++] = '-';
     d66:	fd050793          	addi	a5,a0,-48
     d6a:	00878533          	add	a0,a5,s0
     d6e:	02d00793          	li	a5,45
     d72:	fef50423          	sb	a5,-24(a0)
     d76:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d7a:	02e05563          	blez	a4,da4 <printint+0x8e>
     d7e:	fc26                	sd	s1,56(sp)
     d80:	377d                	addiw	a4,a4,-1
     d82:	00e984b3          	add	s1,s3,a4
     d86:	19fd                	addi	s3,s3,-1
     d88:	99ba                	add	s3,s3,a4
     d8a:	1702                	slli	a4,a4,0x20
     d8c:	9301                	srli	a4,a4,0x20
     d8e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d92:	0004c583          	lbu	a1,0(s1)
     d96:	854a                	mv	a0,s2
     d98:	f61ff0ef          	jal	cf8 <putc>
  while(--i >= 0)
     d9c:	14fd                	addi	s1,s1,-1
     d9e:	ff349ae3          	bne	s1,s3,d92 <printint+0x7c>
     da2:	74e2                	ld	s1,56(sp)
}
     da4:	60a6                	ld	ra,72(sp)
     da6:	6406                	ld	s0,64(sp)
     da8:	7942                	ld	s2,48(sp)
     daa:	79a2                	ld	s3,40(sp)
     dac:	6161                	addi	sp,sp,80
     dae:	8082                	ret
  neg = 0;
     db0:	4301                	li	t1,0
     db2:	bfbd                	j	d30 <printint+0x1a>

0000000000000db4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     db4:	711d                	addi	sp,sp,-96
     db6:	ec86                	sd	ra,88(sp)
     db8:	e8a2                	sd	s0,80(sp)
     dba:	e4a6                	sd	s1,72(sp)
     dbc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dbe:	0005c483          	lbu	s1,0(a1)
     dc2:	22048363          	beqz	s1,fe8 <vprintf+0x234>
     dc6:	e0ca                	sd	s2,64(sp)
     dc8:	fc4e                	sd	s3,56(sp)
     dca:	f852                	sd	s4,48(sp)
     dcc:	f456                	sd	s5,40(sp)
     dce:	f05a                	sd	s6,32(sp)
     dd0:	ec5e                	sd	s7,24(sp)
     dd2:	e862                	sd	s8,16(sp)
     dd4:	8b2a                	mv	s6,a0
     dd6:	8a2e                	mv	s4,a1
     dd8:	8bb2                	mv	s7,a2
  state = 0;
     dda:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     ddc:	4901                	li	s2,0
     dde:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     de0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     de4:	06400c13          	li	s8,100
     de8:	a00d                	j	e0a <vprintf+0x56>
        putc(fd, c0);
     dea:	85a6                	mv	a1,s1
     dec:	855a                	mv	a0,s6
     dee:	f0bff0ef          	jal	cf8 <putc>
     df2:	a019                	j	df8 <vprintf+0x44>
    } else if(state == '%'){
     df4:	03598363          	beq	s3,s5,e1a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     df8:	0019079b          	addiw	a5,s2,1
     dfc:	893e                	mv	s2,a5
     dfe:	873e                	mv	a4,a5
     e00:	97d2                	add	a5,a5,s4
     e02:	0007c483          	lbu	s1,0(a5)
     e06:	1c048a63          	beqz	s1,fda <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     e0a:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e0e:	fe0993e3          	bnez	s3,df4 <vprintf+0x40>
      if(c0 == '%'){
     e12:	fd579ce3          	bne	a5,s5,dea <vprintf+0x36>
        state = '%';
     e16:	89be                	mv	s3,a5
     e18:	b7c5                	j	df8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     e1a:	00ea06b3          	add	a3,s4,a4
     e1e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     e22:	1c060863          	beqz	a2,ff2 <vprintf+0x23e>
      if(c0 == 'd'){
     e26:	03878763          	beq	a5,s8,e54 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e2a:	f9478693          	addi	a3,a5,-108
     e2e:	0016b693          	seqz	a3,a3
     e32:	f9c60593          	addi	a1,a2,-100
     e36:	e99d                	bnez	a1,e6c <vprintf+0xb8>
     e38:	ca95                	beqz	a3,e6c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e3a:	008b8493          	addi	s1,s7,8
     e3e:	4685                	li	a3,1
     e40:	4629                	li	a2,10
     e42:	000bb583          	ld	a1,0(s7)
     e46:	855a                	mv	a0,s6
     e48:	ecfff0ef          	jal	d16 <printint>
        i += 1;
     e4c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e4e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e50:	4981                	li	s3,0
     e52:	b75d                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     e54:	008b8493          	addi	s1,s7,8
     e58:	4685                	li	a3,1
     e5a:	4629                	li	a2,10
     e5c:	000ba583          	lw	a1,0(s7)
     e60:	855a                	mv	a0,s6
     e62:	eb5ff0ef          	jal	d16 <printint>
     e66:	8ba6                	mv	s7,s1
      state = 0;
     e68:	4981                	li	s3,0
     e6a:	b779                	j	df8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e6c:	9752                	add	a4,a4,s4
     e6e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e72:	f9460713          	addi	a4,a2,-108
     e76:	00173713          	seqz	a4,a4
     e7a:	8f75                	and	a4,a4,a3
     e7c:	f9c58513          	addi	a0,a1,-100
     e80:	18051363          	bnez	a0,1006 <vprintf+0x252>
     e84:	18070163          	beqz	a4,1006 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e88:	008b8493          	addi	s1,s7,8
     e8c:	4685                	li	a3,1
     e8e:	4629                	li	a2,10
     e90:	000bb583          	ld	a1,0(s7)
     e94:	855a                	mv	a0,s6
     e96:	e81ff0ef          	jal	d16 <printint>
        i += 2;
     e9a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e9c:	8ba6                	mv	s7,s1
      state = 0;
     e9e:	4981                	li	s3,0
        i += 2;
     ea0:	bfa1                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ea2:	008b8493          	addi	s1,s7,8
     ea6:	4681                	li	a3,0
     ea8:	4629                	li	a2,10
     eaa:	000be583          	lwu	a1,0(s7)
     eae:	855a                	mv	a0,s6
     eb0:	e67ff0ef          	jal	d16 <printint>
     eb4:	8ba6                	mv	s7,s1
      state = 0;
     eb6:	4981                	li	s3,0
     eb8:	b781                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eba:	008b8493          	addi	s1,s7,8
     ebe:	4681                	li	a3,0
     ec0:	4629                	li	a2,10
     ec2:	000bb583          	ld	a1,0(s7)
     ec6:	855a                	mv	a0,s6
     ec8:	e4fff0ef          	jal	d16 <printint>
        i += 1;
     ecc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ece:	8ba6                	mv	s7,s1
      state = 0;
     ed0:	4981                	li	s3,0
     ed2:	b71d                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ed4:	008b8493          	addi	s1,s7,8
     ed8:	4681                	li	a3,0
     eda:	4629                	li	a2,10
     edc:	000bb583          	ld	a1,0(s7)
     ee0:	855a                	mv	a0,s6
     ee2:	e35ff0ef          	jal	d16 <printint>
        i += 2;
     ee6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee8:	8ba6                	mv	s7,s1
      state = 0;
     eea:	4981                	li	s3,0
        i += 2;
     eec:	b731                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     eee:	008b8493          	addi	s1,s7,8
     ef2:	4681                	li	a3,0
     ef4:	4641                	li	a2,16
     ef6:	000be583          	lwu	a1,0(s7)
     efa:	855a                	mv	a0,s6
     efc:	e1bff0ef          	jal	d16 <printint>
     f00:	8ba6                	mv	s7,s1
      state = 0;
     f02:	4981                	li	s3,0
     f04:	bdd5                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f06:	008b8493          	addi	s1,s7,8
     f0a:	4681                	li	a3,0
     f0c:	4641                	li	a2,16
     f0e:	000bb583          	ld	a1,0(s7)
     f12:	855a                	mv	a0,s6
     f14:	e03ff0ef          	jal	d16 <printint>
        i += 1;
     f18:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f1a:	8ba6                	mv	s7,s1
      state = 0;
     f1c:	4981                	li	s3,0
     f1e:	bde9                	j	df8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f20:	008b8493          	addi	s1,s7,8
     f24:	4681                	li	a3,0
     f26:	4641                	li	a2,16
     f28:	000bb583          	ld	a1,0(s7)
     f2c:	855a                	mv	a0,s6
     f2e:	de9ff0ef          	jal	d16 <printint>
        i += 2;
     f32:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f34:	8ba6                	mv	s7,s1
      state = 0;
     f36:	4981                	li	s3,0
        i += 2;
     f38:	b5c1                	j	df8 <vprintf+0x44>
     f3a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f3c:	008b8793          	addi	a5,s7,8
     f40:	8cbe                	mv	s9,a5
     f42:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f46:	03000593          	li	a1,48
     f4a:	855a                	mv	a0,s6
     f4c:	dadff0ef          	jal	cf8 <putc>
  putc(fd, 'x');
     f50:	07800593          	li	a1,120
     f54:	855a                	mv	a0,s6
     f56:	da3ff0ef          	jal	cf8 <putc>
     f5a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f5c:	00000b97          	auipc	s7,0x0
     f60:	6e4b8b93          	addi	s7,s7,1764 # 1640 <digits>
     f64:	03c9d793          	srli	a5,s3,0x3c
     f68:	97de                	add	a5,a5,s7
     f6a:	0007c583          	lbu	a1,0(a5)
     f6e:	855a                	mv	a0,s6
     f70:	d89ff0ef          	jal	cf8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f74:	0992                	slli	s3,s3,0x4
     f76:	34fd                	addiw	s1,s1,-1
     f78:	f4f5                	bnez	s1,f64 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     f7a:	8be6                	mv	s7,s9
      state = 0;
     f7c:	4981                	li	s3,0
     f7e:	6ca2                	ld	s9,8(sp)
     f80:	bda5                	j	df8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     f82:	008b8493          	addi	s1,s7,8
     f86:	000bc583          	lbu	a1,0(s7)
     f8a:	855a                	mv	a0,s6
     f8c:	d6dff0ef          	jal	cf8 <putc>
     f90:	8ba6                	mv	s7,s1
      state = 0;
     f92:	4981                	li	s3,0
     f94:	b595                	j	df8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f96:	008b8993          	addi	s3,s7,8
     f9a:	000bb483          	ld	s1,0(s7)
     f9e:	cc91                	beqz	s1,fba <vprintf+0x206>
        for(; *s; s++)
     fa0:	0004c583          	lbu	a1,0(s1)
     fa4:	c985                	beqz	a1,fd4 <vprintf+0x220>
          putc(fd, *s);
     fa6:	855a                	mv	a0,s6
     fa8:	d51ff0ef          	jal	cf8 <putc>
        for(; *s; s++)
     fac:	0485                	addi	s1,s1,1
     fae:	0004c583          	lbu	a1,0(s1)
     fb2:	f9f5                	bnez	a1,fa6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     fb4:	8bce                	mv	s7,s3
      state = 0;
     fb6:	4981                	li	s3,0
     fb8:	b581                	j	df8 <vprintf+0x44>
          s = "(null)";
     fba:	00000497          	auipc	s1,0x0
     fbe:	61e48493          	addi	s1,s1,1566 # 15d8 <thread_join+0x33a>
        for(; *s; s++)
     fc2:	02800593          	li	a1,40
     fc6:	b7c5                	j	fa6 <vprintf+0x1f2>
        putc(fd, '%');
     fc8:	85be                	mv	a1,a5
     fca:	855a                	mv	a0,s6
     fcc:	d2dff0ef          	jal	cf8 <putc>
      state = 0;
     fd0:	4981                	li	s3,0
     fd2:	b51d                	j	df8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fd4:	8bce                	mv	s7,s3
      state = 0;
     fd6:	4981                	li	s3,0
     fd8:	b505                	j	df8 <vprintf+0x44>
     fda:	6906                	ld	s2,64(sp)
     fdc:	79e2                	ld	s3,56(sp)
     fde:	7a42                	ld	s4,48(sp)
     fe0:	7aa2                	ld	s5,40(sp)
     fe2:	7b02                	ld	s6,32(sp)
     fe4:	6be2                	ld	s7,24(sp)
     fe6:	6c42                	ld	s8,16(sp)
    }
  }
}
     fe8:	60e6                	ld	ra,88(sp)
     fea:	6446                	ld	s0,80(sp)
     fec:	64a6                	ld	s1,72(sp)
     fee:	6125                	addi	sp,sp,96
     ff0:	8082                	ret
      if(c0 == 'd'){
     ff2:	06400713          	li	a4,100
     ff6:	e4e78fe3          	beq	a5,a4,e54 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     ffa:	f9478693          	addi	a3,a5,-108
     ffe:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1002:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1004:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1006:	07500513          	li	a0,117
    100a:	e8a78ce3          	beq	a5,a0,ea2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    100e:	f8b60513          	addi	a0,a2,-117
    1012:	e119                	bnez	a0,1018 <vprintf+0x264>
    1014:	ea0693e3          	bnez	a3,eba <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1018:	f8b58513          	addi	a0,a1,-117
    101c:	e119                	bnez	a0,1022 <vprintf+0x26e>
    101e:	ea071be3          	bnez	a4,ed4 <vprintf+0x120>
      } else if(c0 == 'x'){
    1022:	07800513          	li	a0,120
    1026:	eca784e3          	beq	a5,a0,eee <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    102a:	f8860613          	addi	a2,a2,-120
    102e:	e219                	bnez	a2,1034 <vprintf+0x280>
    1030:	ec069be3          	bnez	a3,f06 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1034:	f8858593          	addi	a1,a1,-120
    1038:	e199                	bnez	a1,103e <vprintf+0x28a>
    103a:	ee0713e3          	bnez	a4,f20 <vprintf+0x16c>
      } else if(c0 == 'p'){
    103e:	07000713          	li	a4,112
    1042:	eee78ce3          	beq	a5,a4,f3a <vprintf+0x186>
      } else if(c0 == 'c'){
    1046:	06300713          	li	a4,99
    104a:	f2e78ce3          	beq	a5,a4,f82 <vprintf+0x1ce>
      } else if(c0 == 's'){
    104e:	07300713          	li	a4,115
    1052:	f4e782e3          	beq	a5,a4,f96 <vprintf+0x1e2>
      } else if(c0 == '%'){
    1056:	02500713          	li	a4,37
    105a:	f6e787e3          	beq	a5,a4,fc8 <vprintf+0x214>
        putc(fd, '%');
    105e:	02500593          	li	a1,37
    1062:	855a                	mv	a0,s6
    1064:	c95ff0ef          	jal	cf8 <putc>
        putc(fd, c0);
    1068:	85a6                	mv	a1,s1
    106a:	855a                	mv	a0,s6
    106c:	c8dff0ef          	jal	cf8 <putc>
      state = 0;
    1070:	4981                	li	s3,0
    1072:	b359                	j	df8 <vprintf+0x44>

0000000000001074 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1074:	715d                	addi	sp,sp,-80
    1076:	ec06                	sd	ra,24(sp)
    1078:	e822                	sd	s0,16(sp)
    107a:	1000                	addi	s0,sp,32
    107c:	e010                	sd	a2,0(s0)
    107e:	e414                	sd	a3,8(s0)
    1080:	e818                	sd	a4,16(s0)
    1082:	ec1c                	sd	a5,24(s0)
    1084:	03043023          	sd	a6,32(s0)
    1088:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    108c:	8622                	mv	a2,s0
    108e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1092:	d23ff0ef          	jal	db4 <vprintf>
}
    1096:	60e2                	ld	ra,24(sp)
    1098:	6442                	ld	s0,16(sp)
    109a:	6161                	addi	sp,sp,80
    109c:	8082                	ret

000000000000109e <printf>:

void
printf(const char *fmt, ...)
{
    109e:	711d                	addi	sp,sp,-96
    10a0:	ec06                	sd	ra,24(sp)
    10a2:	e822                	sd	s0,16(sp)
    10a4:	1000                	addi	s0,sp,32
    10a6:	e40c                	sd	a1,8(s0)
    10a8:	e810                	sd	a2,16(s0)
    10aa:	ec14                	sd	a3,24(s0)
    10ac:	f018                	sd	a4,32(s0)
    10ae:	f41c                	sd	a5,40(s0)
    10b0:	03043823          	sd	a6,48(s0)
    10b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10b8:	00840613          	addi	a2,s0,8
    10bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10c0:	85aa                	mv	a1,a0
    10c2:	4505                	li	a0,1
    10c4:	cf1ff0ef          	jal	db4 <vprintf>
}
    10c8:	60e2                	ld	ra,24(sp)
    10ca:	6442                	ld	s0,16(sp)
    10cc:	6125                	addi	sp,sp,96
    10ce:	8082                	ret

00000000000010d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10d0:	1141                	addi	sp,sp,-16
    10d2:	e406                	sd	ra,8(sp)
    10d4:	e022                	sd	s0,0(sp)
    10d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10dc:	00001797          	auipc	a5,0x1
    10e0:	f347b783          	ld	a5,-204(a5) # 2010 <freep>
    10e4:	a039                	j	10f2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10e6:	6398                	ld	a4,0(a5)
    10e8:	00e7e463          	bltu	a5,a4,10f0 <free+0x20>
    10ec:	00e6ea63          	bltu	a3,a4,1100 <free+0x30>
{
    10f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10f2:	fed7fae3          	bgeu	a5,a3,10e6 <free+0x16>
    10f6:	6398                	ld	a4,0(a5)
    10f8:	00e6e463          	bltu	a3,a4,1100 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10fc:	fee7eae3          	bltu	a5,a4,10f0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1100:	ff852583          	lw	a1,-8(a0)
    1104:	6390                	ld	a2,0(a5)
    1106:	02059813          	slli	a6,a1,0x20
    110a:	01c85713          	srli	a4,a6,0x1c
    110e:	9736                	add	a4,a4,a3
    1110:	02e60563          	beq	a2,a4,113a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1114:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1118:	4790                	lw	a2,8(a5)
    111a:	02061593          	slli	a1,a2,0x20
    111e:	01c5d713          	srli	a4,a1,0x1c
    1122:	973e                	add	a4,a4,a5
    1124:	02e68263          	beq	a3,a4,1148 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1128:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    112a:	00001717          	auipc	a4,0x1
    112e:	eef73323          	sd	a5,-282(a4) # 2010 <freep>
}
    1132:	60a2                	ld	ra,8(sp)
    1134:	6402                	ld	s0,0(sp)
    1136:	0141                	addi	sp,sp,16
    1138:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    113a:	4618                	lw	a4,8(a2)
    113c:	9f2d                	addw	a4,a4,a1
    113e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1142:	6398                	ld	a4,0(a5)
    1144:	6310                	ld	a2,0(a4)
    1146:	b7f9                	j	1114 <free+0x44>
    p->s.size += bp->s.size;
    1148:	ff852703          	lw	a4,-8(a0)
    114c:	9f31                	addw	a4,a4,a2
    114e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1150:	ff053683          	ld	a3,-16(a0)
    1154:	bfd1                	j	1128 <free+0x58>

0000000000001156 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1156:	7139                	addi	sp,sp,-64
    1158:	fc06                	sd	ra,56(sp)
    115a:	f822                	sd	s0,48(sp)
    115c:	f04a                	sd	s2,32(sp)
    115e:	ec4e                	sd	s3,24(sp)
    1160:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1162:	02051993          	slli	s3,a0,0x20
    1166:	0209d993          	srli	s3,s3,0x20
    116a:	09bd                	addi	s3,s3,15
    116c:	0049d993          	srli	s3,s3,0x4
    1170:	2985                	addiw	s3,s3,1
    1172:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1174:	00001517          	auipc	a0,0x1
    1178:	e9c53503          	ld	a0,-356(a0) # 2010 <freep>
    117c:	c905                	beqz	a0,11ac <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    117e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1180:	4798                	lw	a4,8(a5)
    1182:	09377663          	bgeu	a4,s3,120e <malloc+0xb8>
    1186:	f426                	sd	s1,40(sp)
    1188:	e852                	sd	s4,16(sp)
    118a:	e456                	sd	s5,8(sp)
    118c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    118e:	8a4e                	mv	s4,s3
    1190:	6705                	lui	a4,0x1
    1192:	00e9f363          	bgeu	s3,a4,1198 <malloc+0x42>
    1196:	6a05                	lui	s4,0x1
    1198:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    119c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11a0:	00001497          	auipc	s1,0x1
    11a4:	e7048493          	addi	s1,s1,-400 # 2010 <freep>
  if(p == SBRK_ERROR)
    11a8:	5afd                	li	s5,-1
    11aa:	a83d                	j	11e8 <malloc+0x92>
    11ac:	f426                	sd	s1,40(sp)
    11ae:	e852                	sd	s4,16(sp)
    11b0:	e456                	sd	s5,8(sp)
    11b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11b4:	00001797          	auipc	a5,0x1
    11b8:	25478793          	addi	a5,a5,596 # 2408 <base>
    11bc:	00001717          	auipc	a4,0x1
    11c0:	e4f73a23          	sd	a5,-428(a4) # 2010 <freep>
    11c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11ca:	b7d1                	j	118e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11cc:	6398                	ld	a4,0(a5)
    11ce:	e118                	sd	a4,0(a0)
    11d0:	a899                	j	1226 <malloc+0xd0>
  hp->s.size = nu;
    11d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11d6:	0541                	addi	a0,a0,16
    11d8:	ef9ff0ef          	jal	10d0 <free>
  return freep;
    11dc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11de:	c125                	beqz	a0,123e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11e2:	4798                	lw	a4,8(a5)
    11e4:	03277163          	bgeu	a4,s2,1206 <malloc+0xb0>
    if(p == freep)
    11e8:	6098                	ld	a4,0(s1)
    11ea:	853e                	mv	a0,a5
    11ec:	fef71ae3          	bne	a4,a5,11e0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11f0:	8552                	mv	a0,s4
    11f2:	a0dff0ef          	jal	bfe <sbrk>
  if(p == SBRK_ERROR)
    11f6:	fd551ee3          	bne	a0,s5,11d2 <malloc+0x7c>
        return 0;
    11fa:	4501                	li	a0,0
    11fc:	74a2                	ld	s1,40(sp)
    11fe:	6a42                	ld	s4,16(sp)
    1200:	6aa2                	ld	s5,8(sp)
    1202:	6b02                	ld	s6,0(sp)
    1204:	a03d                	j	1232 <malloc+0xdc>
    1206:	74a2                	ld	s1,40(sp)
    1208:	6a42                	ld	s4,16(sp)
    120a:	6aa2                	ld	s5,8(sp)
    120c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    120e:	fae90fe3          	beq	s2,a4,11cc <malloc+0x76>
        p->s.size -= nunits;
    1212:	4137073b          	subw	a4,a4,s3
    1216:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1218:	02071693          	slli	a3,a4,0x20
    121c:	01c6d713          	srli	a4,a3,0x1c
    1220:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1222:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1226:	00001717          	auipc	a4,0x1
    122a:	dea73523          	sd	a0,-534(a4) # 2010 <freep>
      return (void*)(p + 1);
    122e:	01078513          	addi	a0,a5,16
  }
}
    1232:	70e2                	ld	ra,56(sp)
    1234:	7442                	ld	s0,48(sp)
    1236:	7902                	ld	s2,32(sp)
    1238:	69e2                	ld	s3,24(sp)
    123a:	6121                	addi	sp,sp,64
    123c:	8082                	ret
    123e:	74a2                	ld	s1,40(sp)
    1240:	6a42                	ld	s4,16(sp)
    1242:	6aa2                	ld	s5,8(sp)
    1244:	6b02                	ld	s6,0(sp)
    1246:	b7f5                	j	1232 <malloc+0xdc>

0000000000001248 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
    1248:	7179                	addi	sp,sp,-48
    124a:	f406                	sd	ra,40(sp)
    124c:	f022                	sd	s0,32(sp)
    124e:	ec26                	sd	s1,24(sp)
    1250:	e84a                	sd	s2,16(sp)
    1252:	e44e                	sd	s3,8(sp)
    1254:	1800                	addi	s0,sp,48
    1256:	89aa                	mv	s3,a0
    1258:	892e                	mv	s2,a1
    125a:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
    125c:	00c6151b          	slliw	a0,a2,0xc
    1260:	ef7ff0ef          	jal	1156 <malloc>
  if(stack == 0) return -1;
    1264:	c91d                	beqz	a0,129a <thread_create+0x52>
    1266:	e052                	sd	s4,0(sp)
    1268:	862a                	mv	a2,a0
    126a:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
    126c:	10000713          	li	a4,256
    1270:	86a6                	mv	a3,s1
    1272:	85ca                	mv	a1,s2
    1274:	854e                	mv	a0,s3
    1276:	9d3ff0ef          	jal	c48 <clone>

  if(pid < 0) {
    127a:	00054a63          	bltz	a0,128e <thread_create+0x46>
    127e:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
    1280:	70a2                	ld	ra,40(sp)
    1282:	7402                	ld	s0,32(sp)
    1284:	64e2                	ld	s1,24(sp)
    1286:	6942                	ld	s2,16(sp)
    1288:	69a2                	ld	s3,8(sp)
    128a:	6145                	addi	sp,sp,48
    128c:	8082                	ret
    free(stack);
    128e:	8552                	mv	a0,s4
    1290:	e41ff0ef          	jal	10d0 <free>
    return -1;
    1294:	557d                	li	a0,-1
    1296:	6a02                	ld	s4,0(sp)
    1298:	b7e5                	j	1280 <thread_create+0x38>
  if(stack == 0) return -1;
    129a:	557d                	li	a0,-1
    129c:	b7d5                	j	1280 <thread_create+0x38>

000000000000129e <thread_join>:

int
thread_join(void)
{
    129e:	7179                	addi	sp,sp,-48
    12a0:	f406                	sd	ra,40(sp)
    12a2:	f022                	sd	s0,32(sp)
    12a4:	ec26                	sd	s1,24(sp)
    12a6:	1800                	addi	s0,sp,48
  void *stack = 0;
    12a8:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
    12ac:	fd840513          	addi	a0,s0,-40
    12b0:	9a1ff0ef          	jal	c50 <join>
    12b4:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
    12b6:	00a05763          	blez	a0,12c4 <thread_join+0x26>
    12ba:	fd843503          	ld	a0,-40(s0)
    12be:	c119                	beqz	a0,12c4 <thread_join+0x26>
    free(stack);
    12c0:	e11ff0ef          	jal	10d0 <free>
  }
  return pid;
}
    12c4:	8526                	mv	a0,s1
    12c6:	70a2                	ld	ra,40(sp)
    12c8:	7402                	ld	s0,32(sp)
    12ca:	64e2                	ld	s1,24(sp)
    12cc:	6145                	addi	sp,sp,48
    12ce:	8082                	ret
