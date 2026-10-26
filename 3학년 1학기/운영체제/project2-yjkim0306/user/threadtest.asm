
user/_threadtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <my_thread>:
// 공유 메모리 테스트를 위한 전역 변수
int shared_val = 0;
int thread_pid = 0;

// 일반 테스트용 스레드 함수
void my_thread(void *arg) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    int val = *(int *)arg;
   a:	4104                	lw	s1,0(a0)
    
    // 1. 메모리가 공유된다면 부모 프로세스에서도 이 변경사항을 볼 수 있어야 함
    shared_val = val;
   c:	00001797          	auipc	a5,0x1
  10:	fe97ac23          	sw	s1,-8(a5) # 1004 <shared_val>
    
    // 2. 본인의 PID를 전역 변수에 저장 (부모의 PID와 달라야 함)
    thread_pid = getpid();
  14:	4f4000ef          	jal	508 <getpid>
  18:	85aa                	mv	a1,a0
  1a:	00001797          	auipc	a5,0x1
  1e:	fea7a323          	sw	a0,-26(a5) # 1000 <thread_pid>
    
    printf("[Thread] Running... My PID: %d, Received Arg: %d\n", thread_pid, val);
  22:	8626                	mv	a2,s1
  24:	00001517          	auipc	a0,0x1
  28:	adc50513          	addi	a0,a0,-1316 # b00 <thread_join+0x32>
  2c:	0a3000ef          	jal	8ce <printf>
    
    exit(0);
  30:	4501                	li	a0,0
  32:	456000ef          	jal	488 <exit>

0000000000000036 <empty_thread>:
}

// 스트레스 테스트(메모리 누수 확인)용 빈 스레드 함수
void empty_thread(void *arg) {
  36:	1141                	addi	sp,sp,-16
  38:	e406                	sd	ra,8(sp)
  3a:	e022                	sd	s0,0(sp)
  3c:	0800                	addi	s0,sp,16
    exit(0);
  3e:	4501                	li	a0,0
  40:	448000ef          	jal	488 <exit>

0000000000000044 <main>:
}

int main(int argc, char *argv[]) {
  44:	715d                	addi	sp,sp,-80
  46:	e486                	sd	ra,72(sp)
  48:	e0a2                	sd	s0,64(sp)
  4a:	fc26                	sd	s1,56(sp)
  4c:	0880                	addi	s0,sp,80
    printf("=== Thread Project 2 Test Start ===\n");
  4e:	00001517          	auipc	a0,0x1
  52:	aea50513          	addi	a0,a0,-1302 # b38 <thread_join+0x6a>
  56:	079000ef          	jal	8ce <printf>

    int parent_pid = getpid();
  5a:	4ae000ef          	jal	508 <getpid>
  5e:	84aa                	mv	s1,a0
    printf("[Parent] My PID: %d\n", parent_pid);
  60:	85aa                	mv	a1,a0
  62:	00001517          	auipc	a0,0x1
  66:	afe50513          	addi	a0,a0,-1282 # b60 <thread_join+0x92>
  6a:	065000ef          	jal	8ce <printf>

    int arg = 100;
  6e:	06400793          	li	a5,100
  72:	faf42e23          	sw	a5,-68(s0)
    
    // 스레드 생성 (스택 1페이지)
    int tpid = thread_create(my_thread, (void *)&arg, 1);
  76:	4605                	li	a2,1
  78:	fbc40593          	addi	a1,s0,-68
  7c:	00000517          	auipc	a0,0x0
  80:	f8450513          	addi	a0,a0,-124 # 0 <my_thread>
  84:	1f5000ef          	jal	a78 <thread_create>

    if(tpid < 0){
  88:	0a054663          	bltz	a0,134 <main+0xf0>
        printf("[FAIL] thread_create failed!\n");
        exit(1);
    }

    // 스레드 합류 대기
    int joined_pid = thread_join();
  8c:	243000ef          	jal	ace <thread_join>
    
    if(joined_pid < 0){
  90:	0a054f63          	bltz	a0,14e <main+0x10a>
  94:	f84a                	sd	s2,48(sp)
  96:	f44e                	sd	s3,40(sp)
  98:	f052                	sd	s4,32(sp)
  9a:	ec56                	sd	s5,24(sp)
        printf("[FAIL] thread_join failed!\n");
        exit(1);
    }

    printf("\n--- Validation Results ---\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	b1c50513          	addi	a0,a0,-1252 # bb8 <thread_join+0xea>
  a4:	02b000ef          	jal	8ce <printf>
    int success = 1;

    // [검증 1] 메모리 공유 (CLONE_VM) 확인
    if (shared_val == 100) {
  a8:	00001597          	auipc	a1,0x1
  ac:	f5c5a583          	lw	a1,-164(a1) # 1004 <shared_val>
  b0:	06400793          	li	a5,100
  b4:	0af58a63          	beq	a1,a5,168 <main+0x124>
        printf("[PASS] Memory is properly shared between parent and thread.\n");
    } else {
        printf("[FAIL] Memory is NOT shared. shared_val = %d\n", shared_val);
  b8:	00001517          	auipc	a0,0x1
  bc:	b6050513          	addi	a0,a0,-1184 # c18 <thread_join+0x14a>
  c0:	00f000ef          	jal	8ce <printf>
        success = 0;
  c4:	4a81                	li	s5,0
    }

    // [검증 2] 스레드 고유 PID 확인
    // 과제 명세에 따르면, 스레드 내부에서 호출한 getpid()는 그룹 리더(부모)와 다른 고유한 값을 가져야 합니다.
    if (thread_pid != 0 && thread_pid != parent_pid) {
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a5a583          	lw	a1,-198(a1) # 1000 <thread_pid>
  ce:	00958363          	beq	a1,s1,d4 <main+0x90>
  d2:	e5c5                	bnez	a1,17a <main+0x136>
        printf("[PASS] Thread has an independent PID (Parent: %d, Thread: %d).\n", parent_pid, thread_pid);
    } else {
        printf("[FAIL] Thread PID is incorrect or identical to parent. thread_pid = %d\n", thread_pid);
  d4:	00001517          	auipc	a0,0x1
  d8:	bb450513          	addi	a0,a0,-1100 # c88 <thread_join+0x1ba>
  dc:	7f2000ef          	jal	8ce <printf>
        success = 0;
  e0:	4a81                	li	s5,0
    }

    // [검증 3] 스트레스 테스트 (메모리 누수 검사)
    printf("\n--- Stress Test (Checking for Memory Leaks) ---\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	bee50513          	addi	a0,a0,-1042 # cd0 <thread_join+0x202>
  ea:	7e4000ef          	jal	8ce <printf>
    // 메모리 반환이 제대로 안 된다면 500번을 돌기 전에 xv6 메모리가 고갈되어 실패합니다.
    for(int i = 0; i < 500; i++) {
  ee:	4481                	li	s1,0
        if (thread_create(empty_thread, 0, 1) < 0) {
  f0:	4985                	li	s3,1
  f2:	00000917          	auipc	s2,0x0
  f6:	f4490913          	addi	s2,s2,-188 # 36 <empty_thread>
    for(int i = 0; i < 500; i++) {
  fa:	1f400a13          	li	s4,500
        if (thread_create(empty_thread, 0, 1) < 0) {
  fe:	864e                	mv	a2,s3
 100:	4581                	li	a1,0
 102:	854a                	mv	a0,s2
 104:	175000ef          	jal	a78 <thread_create>
 108:	08054263          	bltz	a0,18c <main+0x148>
            printf("[FAIL] Failed to create thread at iteration %d. Possible memory leak.\n", i);
            success = 0;
            break;
        }
        thread_join();
 10c:	1c3000ef          	jal	ace <thread_join>
    for(int i = 0; i < 500; i++) {
 110:	2485                	addiw	s1,s1,1
 112:	ff4496e3          	bne	s1,s4,fe <main+0xba>
    }
    
    if (success) {
 116:	080a8263          	beqz	s5,19a <main+0x156>
        printf("[PASS] Successfully created and joined 500 threads. Memory deallocation looks good!\n");
 11a:	00001517          	auipc	a0,0x1
 11e:	c3650513          	addi	a0,a0,-970 # d50 <thread_join+0x282>
 122:	7ac000ef          	jal	8ce <printf>
        printf("\n=== ALL CUSTOM TESTS PASSED ===\n");
 126:	00001517          	auipc	a0,0x1
 12a:	c8250513          	addi	a0,a0,-894 # da8 <thread_join+0x2da>
 12e:	7a0000ef          	jal	8ce <printf>
 132:	a895                	j	1a6 <main+0x162>
 134:	f84a                	sd	s2,48(sp)
 136:	f44e                	sd	s3,40(sp)
 138:	f052                	sd	s4,32(sp)
 13a:	ec56                	sd	s5,24(sp)
        printf("[FAIL] thread_create failed!\n");
 13c:	00001517          	auipc	a0,0x1
 140:	a3c50513          	addi	a0,a0,-1476 # b78 <thread_join+0xaa>
 144:	78a000ef          	jal	8ce <printf>
        exit(1);
 148:	4505                	li	a0,1
 14a:	33e000ef          	jal	488 <exit>
 14e:	f84a                	sd	s2,48(sp)
 150:	f44e                	sd	s3,40(sp)
 152:	f052                	sd	s4,32(sp)
 154:	ec56                	sd	s5,24(sp)
        printf("[FAIL] thread_join failed!\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a4250513          	addi	a0,a0,-1470 # b98 <thread_join+0xca>
 15e:	770000ef          	jal	8ce <printf>
        exit(1);
 162:	4505                	li	a0,1
 164:	324000ef          	jal	488 <exit>
        printf("[PASS] Memory is properly shared between parent and thread.\n");
 168:	00001517          	auipc	a0,0x1
 16c:	a7050513          	addi	a0,a0,-1424 # bd8 <thread_join+0x10a>
 170:	75e000ef          	jal	8ce <printf>
    int success = 1;
 174:	4785                	li	a5,1
 176:	8abe                	mv	s5,a5
 178:	b7b9                	j	c6 <main+0x82>
        printf("[PASS] Thread has an independent PID (Parent: %d, Thread: %d).\n", parent_pid, thread_pid);
 17a:	862e                	mv	a2,a1
 17c:	85a6                	mv	a1,s1
 17e:	00001517          	auipc	a0,0x1
 182:	aca50513          	addi	a0,a0,-1334 # c48 <thread_join+0x17a>
 186:	748000ef          	jal	8ce <printf>
 18a:	bfa1                	j	e2 <main+0x9e>
            printf("[FAIL] Failed to create thread at iteration %d. Possible memory leak.\n", i);
 18c:	85a6                	mv	a1,s1
 18e:	00001517          	auipc	a0,0x1
 192:	b7a50513          	addi	a0,a0,-1158 # d08 <thread_join+0x23a>
 196:	738000ef          	jal	8ce <printf>
    } else {
        printf("\n=== SOME TESTS FAILED ===\n");
 19a:	00001517          	auipc	a0,0x1
 19e:	c3650513          	addi	a0,a0,-970 # dd0 <thread_join+0x302>
 1a2:	72c000ef          	jal	8ce <printf>
    }
    
    exit(0);
 1a6:	4501                	li	a0,0
 1a8:	2e0000ef          	jal	488 <exit>

00000000000001ac <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1b4:	e91ff0ef          	jal	44 <main>
  exit(r);
 1b8:	2d0000ef          	jal	488 <exit>

00000000000001bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c4:	87aa                	mv	a5,a0
 1c6:	0585                	addi	a1,a1,1
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff5c703          	lbu	a4,-1(a1)
 1ce:	fee78fa3          	sb	a4,-1(a5)
 1d2:	fb75                	bnez	a4,1c6 <strcpy+0xa>
    ;
  return os;
}
 1d4:	60a2                	ld	ra,8(sp)
 1d6:	6402                	ld	s0,0(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret

00000000000001dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cb91                	beqz	a5,1fc <strcmp+0x20>
 1ea:	0005c703          	lbu	a4,0(a1)
 1ee:	00f71763          	bne	a4,a5,1fc <strcmp+0x20>
    p++, q++;
 1f2:	0505                	addi	a0,a0,1
 1f4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	fbe5                	bnez	a5,1ea <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1fc:	0005c503          	lbu	a0,0(a1)
}
 200:	40a7853b          	subw	a0,a5,a0
 204:	60a2                	ld	ra,8(sp)
 206:	6402                	ld	s0,0(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strlen>:

uint
strlen(const char *s)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 214:	00054783          	lbu	a5,0(a0)
 218:	cf91                	beqz	a5,234 <strlen+0x28>
 21a:	00150793          	addi	a5,a0,1
 21e:	86be                	mv	a3,a5
 220:	0785                	addi	a5,a5,1
 222:	fff7c703          	lbu	a4,-1(a5)
 226:	ff65                	bnez	a4,21e <strlen+0x12>
 228:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  for(n = 0; s[n]; n++)
 234:	4501                	li	a0,0
 236:	bfdd                	j	22c <strlen+0x20>

0000000000000238 <memset>:

void*
memset(void *dst, int c, uint n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e406                	sd	ra,8(sp)
 23c:	e022                	sd	s0,0(sp)
 23e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 240:	ca19                	beqz	a2,256 <memset+0x1e>
 242:	87aa                	mv	a5,a0
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 24c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 250:	0785                	addi	a5,a5,1
 252:	fee79de3          	bne	a5,a4,24c <memset+0x14>
  }
  return dst;
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strchr>:

char*
strchr(const char *s, char c)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  for(; *s; s++)
 266:	00054783          	lbu	a5,0(a0)
 26a:	cf81                	beqz	a5,282 <strchr+0x24>
    if(*s == c)
 26c:	00f58763          	beq	a1,a5,27a <strchr+0x1c>
  for(; *s; s++)
 270:	0505                	addi	a0,a0,1
 272:	00054783          	lbu	a5,0(a0)
 276:	fbfd                	bnez	a5,26c <strchr+0xe>
      return (char*)s;
  return 0;
 278:	4501                	li	a0,0
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret
  return 0;
 282:	4501                	li	a0,0
 284:	bfdd                	j	27a <strchr+0x1c>

0000000000000286 <gets>:

char*
gets(char *buf, int max)
{
 286:	711d                	addi	sp,sp,-96
 288:	ec86                	sd	ra,88(sp)
 28a:	e8a2                	sd	s0,80(sp)
 28c:	e4a6                	sd	s1,72(sp)
 28e:	e0ca                	sd	s2,64(sp)
 290:	fc4e                	sd	s3,56(sp)
 292:	f852                	sd	s4,48(sp)
 294:	f456                	sd	s5,40(sp)
 296:	f05a                	sd	s6,32(sp)
 298:	ec5e                	sd	s7,24(sp)
 29a:	e862                	sd	s8,16(sp)
 29c:	1080                	addi	s0,sp,96
 29e:	8baa                	mv	s7,a0
 2a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a2:	892a                	mv	s2,a0
 2a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2a6:	faf40b13          	addi	s6,s0,-81
 2aa:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 2ac:	8c26                	mv	s8,s1
 2ae:	0014899b          	addiw	s3,s1,1
 2b2:	84ce                	mv	s1,s3
 2b4:	0349d463          	bge	s3,s4,2dc <gets+0x56>
    cc = read(0, &c, 1);
 2b8:	8656                	mv	a2,s5
 2ba:	85da                	mv	a1,s6
 2bc:	4501                	li	a0,0
 2be:	1e2000ef          	jal	4a0 <read>
    if(cc < 1)
 2c2:	00a05d63          	blez	a0,2dc <gets+0x56>
      break;
    buf[i++] = c;
 2c6:	faf44783          	lbu	a5,-81(s0)
 2ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ce:	0905                	addi	s2,s2,1
 2d0:	ff678713          	addi	a4,a5,-10
 2d4:	c319                	beqz	a4,2da <gets+0x54>
 2d6:	17cd                	addi	a5,a5,-13
 2d8:	fbf1                	bnez	a5,2ac <gets+0x26>
    buf[i++] = c;
 2da:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2dc:	9c5e                	add	s8,s8,s7
 2de:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2e2:	855e                	mv	a0,s7
 2e4:	60e6                	ld	ra,88(sp)
 2e6:	6446                	ld	s0,80(sp)
 2e8:	64a6                	ld	s1,72(sp)
 2ea:	6906                	ld	s2,64(sp)
 2ec:	79e2                	ld	s3,56(sp)
 2ee:	7a42                	ld	s4,48(sp)
 2f0:	7aa2                	ld	s5,40(sp)
 2f2:	7b02                	ld	s6,32(sp)
 2f4:	6be2                	ld	s7,24(sp)
 2f6:	6c42                	ld	s8,16(sp)
 2f8:	6125                	addi	sp,sp,96
 2fa:	8082                	ret

00000000000002fc <stat>:

int
stat(const char *n, struct stat *st)
{
 2fc:	1101                	addi	sp,sp,-32
 2fe:	ec06                	sd	ra,24(sp)
 300:	e822                	sd	s0,16(sp)
 302:	e04a                	sd	s2,0(sp)
 304:	1000                	addi	s0,sp,32
 306:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 308:	4581                	li	a1,0
 30a:	1be000ef          	jal	4c8 <open>
  if(fd < 0)
 30e:	02054263          	bltz	a0,332 <stat+0x36>
 312:	e426                	sd	s1,8(sp)
 314:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 316:	85ca                	mv	a1,s2
 318:	1c8000ef          	jal	4e0 <fstat>
 31c:	892a                	mv	s2,a0
  close(fd);
 31e:	8526                	mv	a0,s1
 320:	190000ef          	jal	4b0 <close>
  return r;
 324:	64a2                	ld	s1,8(sp)
}
 326:	854a                	mv	a0,s2
 328:	60e2                	ld	ra,24(sp)
 32a:	6442                	ld	s0,16(sp)
 32c:	6902                	ld	s2,0(sp)
 32e:	6105                	addi	sp,sp,32
 330:	8082                	ret
    return -1;
 332:	57fd                	li	a5,-1
 334:	893e                	mv	s2,a5
 336:	bfc5                	j	326 <stat+0x2a>

0000000000000338 <atoi>:

int
atoi(const char *s)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 340:	00054683          	lbu	a3,0(a0)
 344:	fd06879b          	addiw	a5,a3,-48
 348:	0ff7f793          	zext.b	a5,a5
 34c:	4625                	li	a2,9
 34e:	02f66963          	bltu	a2,a5,380 <atoi+0x48>
 352:	872a                	mv	a4,a0
  n = 0;
 354:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 356:	0705                	addi	a4,a4,1
 358:	0025179b          	slliw	a5,a0,0x2
 35c:	9fa9                	addw	a5,a5,a0
 35e:	0017979b          	slliw	a5,a5,0x1
 362:	9fb5                	addw	a5,a5,a3
 364:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 368:	00074683          	lbu	a3,0(a4)
 36c:	fd06879b          	addiw	a5,a3,-48
 370:	0ff7f793          	zext.b	a5,a5
 374:	fef671e3          	bgeu	a2,a5,356 <atoi+0x1e>
  return n;
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  n = 0;
 380:	4501                	li	a0,0
 382:	bfdd                	j	378 <atoi+0x40>

0000000000000384 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 38c:	02b57563          	bgeu	a0,a1,3b6 <memmove+0x32>
    while(n-- > 0)
 390:	00c05f63          	blez	a2,3ae <memmove+0x2a>
 394:	1602                	slli	a2,a2,0x20
 396:	9201                	srli	a2,a2,0x20
 398:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 39c:	872a                	mv	a4,a0
      *dst++ = *src++;
 39e:	0585                	addi	a1,a1,1
 3a0:	0705                	addi	a4,a4,1
 3a2:	fff5c683          	lbu	a3,-1(a1)
 3a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3aa:	fee79ae3          	bne	a5,a4,39e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ae:	60a2                	ld	ra,8(sp)
 3b0:	6402                	ld	s0,0(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
    while(n-- > 0)
 3b6:	fec05ce3          	blez	a2,3ae <memmove+0x2a>
    dst += n;
 3ba:	00c50733          	add	a4,a0,a2
    src += n;
 3be:	95b2                	add	a1,a1,a2
 3c0:	fff6079b          	addiw	a5,a2,-1
 3c4:	1782                	slli	a5,a5,0x20
 3c6:	9381                	srli	a5,a5,0x20
 3c8:	fff7c793          	not	a5,a5
 3cc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ce:	15fd                	addi	a1,a1,-1
 3d0:	177d                	addi	a4,a4,-1
 3d2:	0005c683          	lbu	a3,0(a1)
 3d6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3da:	fef71ae3          	bne	a4,a5,3ce <memmove+0x4a>
 3de:	bfc1                	j	3ae <memmove+0x2a>

00000000000003e0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e406                	sd	ra,8(sp)
 3e4:	e022                	sd	s0,0(sp)
 3e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e8:	c61d                	beqz	a2,416 <memcmp+0x36>
 3ea:	1602                	slli	a2,a2,0x20
 3ec:	9201                	srli	a2,a2,0x20
 3ee:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3f2:	00054783          	lbu	a5,0(a0)
 3f6:	0005c703          	lbu	a4,0(a1)
 3fa:	00e79863          	bne	a5,a4,40a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3fe:	0505                	addi	a0,a0,1
    p2++;
 400:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 402:	fed518e3          	bne	a0,a3,3f2 <memcmp+0x12>
  }
  return 0;
 406:	4501                	li	a0,0
 408:	a019                	j	40e <memcmp+0x2e>
      return *p1 - *p2;
 40a:	40e7853b          	subw	a0,a5,a4
}
 40e:	60a2                	ld	ra,8(sp)
 410:	6402                	ld	s0,0(sp)
 412:	0141                	addi	sp,sp,16
 414:	8082                	ret
  return 0;
 416:	4501                	li	a0,0
 418:	bfdd                	j	40e <memcmp+0x2e>

000000000000041a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 41a:	1141                	addi	sp,sp,-16
 41c:	e406                	sd	ra,8(sp)
 41e:	e022                	sd	s0,0(sp)
 420:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 422:	f63ff0ef          	jal	384 <memmove>
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <sbrk>:

char *
sbrk(int n) {
 42e:	1141                	addi	sp,sp,-16
 430:	e406                	sd	ra,8(sp)
 432:	e022                	sd	s0,0(sp)
 434:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 436:	4585                	li	a1,1
 438:	0d8000ef          	jal	510 <sys_sbrk>
}
 43c:	60a2                	ld	ra,8(sp)
 43e:	6402                	ld	s0,0(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret

0000000000000444 <sbrklazy>:

char *
sbrklazy(int n) {
 444:	1141                	addi	sp,sp,-16
 446:	e406                	sd	ra,8(sp)
 448:	e022                	sd	s0,0(sp)
 44a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 44c:	4589                	li	a1,2
 44e:	0c2000ef          	jal	510 <sys_sbrk>
}
 452:	60a2                	ld	ra,8(sp)
 454:	6402                	ld	s0,0(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret

000000000000045a <fork>:

int
fork(void)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e406                	sd	ra,8(sp)
 45e:	e022                	sd	s0,0(sp)
 460:	0800                	addi	s0,sp,16
  return clone(0, 0, 0, 0, 0);
 462:	4701                	li	a4,0
 464:	4681                	li	a3,0
 466:	4601                	li	a2,0
 468:	4581                	li	a1,0
 46a:	4501                	li	a0,0
 46c:	00c000ef          	jal	478 <clone>
}
 470:	60a2                	ld	ra,8(sp)
 472:	6402                	ld	s0,0(sp)
 474:	0141                	addi	sp,sp,16
 476:	8082                	ret

0000000000000478 <clone>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global clone
clone:
 li a7, SYS_clone
 478:	4885                	li	a7,1
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <join>:
.global join
join:
 li a7, SYS_join
 480:	48d9                	li	a7,22
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <exit>:
.global exit
exit:
 li a7, SYS_exit
 488:	4889                	li	a7,2
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <wait>:
.global wait
wait:
 li a7, SYS_wait
 490:	488d                	li	a7,3
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 498:	4891                	li	a7,4
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <read>:
.global read
read:
 li a7, SYS_read
 4a0:	4895                	li	a7,5
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <write>:
.global write
write:
 li a7, SYS_write
 4a8:	48c1                	li	a7,16
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <close>:
.global close
close:
 li a7, SYS_close
 4b0:	48d5                	li	a7,21
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b8:	4899                	li	a7,6
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c0:	489d                	li	a7,7
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <open>:
.global open
open:
 li a7, SYS_open
 4c8:	48bd                	li	a7,15
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d0:	48c5                	li	a7,17
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d8:	48c9                	li	a7,18
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e0:	48a1                	li	a7,8
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <link>:
.global link
link:
 li a7, SYS_link
 4e8:	48cd                	li	a7,19
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f0:	48d1                	li	a7,20
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f8:	48a5                	li	a7,9
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <dup>:
.global dup
dup:
 li a7, SYS_dup
 500:	48a9                	li	a7,10
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 508:	48ad                	li	a7,11
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 510:	48b1                	li	a7,12
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <pause>:
.global pause
pause:
 li a7, SYS_pause
 518:	48b5                	li	a7,13
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 520:	48b9                	li	a7,14
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 528:	1101                	addi	sp,sp,-32
 52a:	ec06                	sd	ra,24(sp)
 52c:	e822                	sd	s0,16(sp)
 52e:	1000                	addi	s0,sp,32
 530:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 534:	4605                	li	a2,1
 536:	fef40593          	addi	a1,s0,-17
 53a:	f6fff0ef          	jal	4a8 <write>
}
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	6105                	addi	sp,sp,32
 544:	8082                	ret

0000000000000546 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 546:	715d                	addi	sp,sp,-80
 548:	e486                	sd	ra,72(sp)
 54a:	e0a2                	sd	s0,64(sp)
 54c:	f84a                	sd	s2,48(sp)
 54e:	f44e                	sd	s3,40(sp)
 550:	0880                	addi	s0,sp,80
 552:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 554:	c6d1                	beqz	a3,5e0 <printint+0x9a>
 556:	0805d563          	bgez	a1,5e0 <printint+0x9a>
    neg = 1;
    x = -xx;
 55a:	40b005b3          	neg	a1,a1
    neg = 1;
 55e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 560:	fb840993          	addi	s3,s0,-72
  neg = 0;
 564:	86ce                	mv	a3,s3
  i = 0;
 566:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 568:	00001817          	auipc	a6,0x1
 56c:	89080813          	addi	a6,a6,-1904 # df8 <digits>
 570:	88ba                	mv	a7,a4
 572:	0017051b          	addiw	a0,a4,1
 576:	872a                	mv	a4,a0
 578:	02c5f7b3          	remu	a5,a1,a2
 57c:	97c2                	add	a5,a5,a6
 57e:	0007c783          	lbu	a5,0(a5)
 582:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 586:	87ae                	mv	a5,a1
 588:	02c5d5b3          	divu	a1,a1,a2
 58c:	0685                	addi	a3,a3,1
 58e:	fec7f1e3          	bgeu	a5,a2,570 <printint+0x2a>
  if(neg)
 592:	00030c63          	beqz	t1,5aa <printint+0x64>
    buf[i++] = '-';
 596:	fd050793          	addi	a5,a0,-48
 59a:	00878533          	add	a0,a5,s0
 59e:	02d00793          	li	a5,45
 5a2:	fef50423          	sb	a5,-24(a0)
 5a6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 5aa:	02e05563          	blez	a4,5d4 <printint+0x8e>
 5ae:	fc26                	sd	s1,56(sp)
 5b0:	377d                	addiw	a4,a4,-1
 5b2:	00e984b3          	add	s1,s3,a4
 5b6:	19fd                	addi	s3,s3,-1
 5b8:	99ba                	add	s3,s3,a4
 5ba:	1702                	slli	a4,a4,0x20
 5bc:	9301                	srli	a4,a4,0x20
 5be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c2:	0004c583          	lbu	a1,0(s1)
 5c6:	854a                	mv	a0,s2
 5c8:	f61ff0ef          	jal	528 <putc>
  while(--i >= 0)
 5cc:	14fd                	addi	s1,s1,-1
 5ce:	ff349ae3          	bne	s1,s3,5c2 <printint+0x7c>
 5d2:	74e2                	ld	s1,56(sp)
}
 5d4:	60a6                	ld	ra,72(sp)
 5d6:	6406                	ld	s0,64(sp)
 5d8:	7942                	ld	s2,48(sp)
 5da:	79a2                	ld	s3,40(sp)
 5dc:	6161                	addi	sp,sp,80
 5de:	8082                	ret
  neg = 0;
 5e0:	4301                	li	t1,0
 5e2:	bfbd                	j	560 <printint+0x1a>

00000000000005e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e4:	711d                	addi	sp,sp,-96
 5e6:	ec86                	sd	ra,88(sp)
 5e8:	e8a2                	sd	s0,80(sp)
 5ea:	e4a6                	sd	s1,72(sp)
 5ec:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ee:	0005c483          	lbu	s1,0(a1)
 5f2:	22048363          	beqz	s1,818 <vprintf+0x234>
 5f6:	e0ca                	sd	s2,64(sp)
 5f8:	fc4e                	sd	s3,56(sp)
 5fa:	f852                	sd	s4,48(sp)
 5fc:	f456                	sd	s5,40(sp)
 5fe:	f05a                	sd	s6,32(sp)
 600:	ec5e                	sd	s7,24(sp)
 602:	e862                	sd	s8,16(sp)
 604:	8b2a                	mv	s6,a0
 606:	8a2e                	mv	s4,a1
 608:	8bb2                	mv	s7,a2
  state = 0;
 60a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 60c:	4901                	li	s2,0
 60e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 610:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 614:	06400c13          	li	s8,100
 618:	a00d                	j	63a <vprintf+0x56>
        putc(fd, c0);
 61a:	85a6                	mv	a1,s1
 61c:	855a                	mv	a0,s6
 61e:	f0bff0ef          	jal	528 <putc>
 622:	a019                	j	628 <vprintf+0x44>
    } else if(state == '%'){
 624:	03598363          	beq	s3,s5,64a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 628:	0019079b          	addiw	a5,s2,1
 62c:	893e                	mv	s2,a5
 62e:	873e                	mv	a4,a5
 630:	97d2                	add	a5,a5,s4
 632:	0007c483          	lbu	s1,0(a5)
 636:	1c048a63          	beqz	s1,80a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 63a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 63e:	fe0993e3          	bnez	s3,624 <vprintf+0x40>
      if(c0 == '%'){
 642:	fd579ce3          	bne	a5,s5,61a <vprintf+0x36>
        state = '%';
 646:	89be                	mv	s3,a5
 648:	b7c5                	j	628 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 64a:	00ea06b3          	add	a3,s4,a4
 64e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 652:	1c060863          	beqz	a2,822 <vprintf+0x23e>
      if(c0 == 'd'){
 656:	03878763          	beq	a5,s8,684 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 65a:	f9478693          	addi	a3,a5,-108
 65e:	0016b693          	seqz	a3,a3
 662:	f9c60593          	addi	a1,a2,-100
 666:	e99d                	bnez	a1,69c <vprintf+0xb8>
 668:	ca95                	beqz	a3,69c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66a:	008b8493          	addi	s1,s7,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	ecfff0ef          	jal	546 <printint>
        i += 1;
 67c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 67e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 680:	4981                	li	s3,0
 682:	b75d                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b8493          	addi	s1,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	eb5ff0ef          	jal	546 <printint>
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
 69a:	b779                	j	628 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 69c:	9752                	add	a4,a4,s4
 69e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a2:	f9460713          	addi	a4,a2,-108
 6a6:	00173713          	seqz	a4,a4
 6aa:	8f75                	and	a4,a4,a3
 6ac:	f9c58513          	addi	a0,a1,-100
 6b0:	18051363          	bnez	a0,836 <vprintf+0x252>
 6b4:	18070163          	beqz	a4,836 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	008b8493          	addi	s1,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e81ff0ef          	jal	546 <printint>
        i += 2;
 6ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	8ba6                	mv	s7,s1
      state = 0;
 6ce:	4981                	li	s3,0
        i += 2;
 6d0:	bfa1                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4629                	li	a2,10
 6da:	000be583          	lwu	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	e67ff0ef          	jal	546 <printint>
 6e4:	8ba6                	mv	s7,s1
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b781                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4629                	li	a2,10
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e4fff0ef          	jal	546 <printint>
        i += 1;
 6fc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
 702:	b71d                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 704:	008b8493          	addi	s1,s7,8
 708:	4681                	li	a3,0
 70a:	4629                	li	a2,10
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	e35ff0ef          	jal	546 <printint>
        i += 2;
 716:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	b731                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 71e:	008b8493          	addi	s1,s7,8
 722:	4681                	li	a3,0
 724:	4641                	li	a2,16
 726:	000be583          	lwu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	e1bff0ef          	jal	546 <printint>
 730:	8ba6                	mv	s7,s1
      state = 0;
 732:	4981                	li	s3,0
 734:	bdd5                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 736:	008b8493          	addi	s1,s7,8
 73a:	4681                	li	a3,0
 73c:	4641                	li	a2,16
 73e:	000bb583          	ld	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	e03ff0ef          	jal	546 <printint>
        i += 1;
 748:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bde9                	j	628 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 750:	008b8493          	addi	s1,s7,8
 754:	4681                	li	a3,0
 756:	4641                	li	a2,16
 758:	000bb583          	ld	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	de9ff0ef          	jal	546 <printint>
        i += 2;
 762:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 764:	8ba6                	mv	s7,s1
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	b5c1                	j	628 <vprintf+0x44>
 76a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 76c:	008b8793          	addi	a5,s7,8
 770:	8cbe                	mv	s9,a5
 772:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 776:	03000593          	li	a1,48
 77a:	855a                	mv	a0,s6
 77c:	dadff0ef          	jal	528 <putc>
  putc(fd, 'x');
 780:	07800593          	li	a1,120
 784:	855a                	mv	a0,s6
 786:	da3ff0ef          	jal	528 <putc>
 78a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78c:	00000b97          	auipc	s7,0x0
 790:	66cb8b93          	addi	s7,s7,1644 # df8 <digits>
 794:	03c9d793          	srli	a5,s3,0x3c
 798:	97de                	add	a5,a5,s7
 79a:	0007c583          	lbu	a1,0(a5)
 79e:	855a                	mv	a0,s6
 7a0:	d89ff0ef          	jal	528 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a4:	0992                	slli	s3,s3,0x4
 7a6:	34fd                	addiw	s1,s1,-1
 7a8:	f4f5                	bnez	s1,794 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7aa:	8be6                	mv	s7,s9
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	6ca2                	ld	s9,8(sp)
 7b0:	bda5                	j	628 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7b2:	008b8493          	addi	s1,s7,8
 7b6:	000bc583          	lbu	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	d6dff0ef          	jal	528 <putc>
 7c0:	8ba6                	mv	s7,s1
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b595                	j	628 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	008b8993          	addi	s3,s7,8
 7ca:	000bb483          	ld	s1,0(s7)
 7ce:	cc91                	beqz	s1,7ea <vprintf+0x206>
        for(; *s; s++)
 7d0:	0004c583          	lbu	a1,0(s1)
 7d4:	c985                	beqz	a1,804 <vprintf+0x220>
          putc(fd, *s);
 7d6:	855a                	mv	a0,s6
 7d8:	d51ff0ef          	jal	528 <putc>
        for(; *s; s++)
 7dc:	0485                	addi	s1,s1,1
 7de:	0004c583          	lbu	a1,0(s1)
 7e2:	f9f5                	bnez	a1,7d6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7e4:	8bce                	mv	s7,s3
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b581                	j	628 <vprintf+0x44>
          s = "(null)";
 7ea:	00000497          	auipc	s1,0x0
 7ee:	60648493          	addi	s1,s1,1542 # df0 <thread_join+0x322>
        for(; *s; s++)
 7f2:	02800593          	li	a1,40
 7f6:	b7c5                	j	7d6 <vprintf+0x1f2>
        putc(fd, '%');
 7f8:	85be                	mv	a1,a5
 7fa:	855a                	mv	a0,s6
 7fc:	d2dff0ef          	jal	528 <putc>
      state = 0;
 800:	4981                	li	s3,0
 802:	b51d                	j	628 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	b505                	j	628 <vprintf+0x44>
 80a:	6906                	ld	s2,64(sp)
 80c:	79e2                	ld	s3,56(sp)
 80e:	7a42                	ld	s4,48(sp)
 810:	7aa2                	ld	s5,40(sp)
 812:	7b02                	ld	s6,32(sp)
 814:	6be2                	ld	s7,24(sp)
 816:	6c42                	ld	s8,16(sp)
    }
  }
}
 818:	60e6                	ld	ra,88(sp)
 81a:	6446                	ld	s0,80(sp)
 81c:	64a6                	ld	s1,72(sp)
 81e:	6125                	addi	sp,sp,96
 820:	8082                	ret
      if(c0 == 'd'){
 822:	06400713          	li	a4,100
 826:	e4e78fe3          	beq	a5,a4,684 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 82a:	f9478693          	addi	a3,a5,-108
 82e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 832:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 834:	4701                	li	a4,0
      } else if(c0 == 'u'){
 836:	07500513          	li	a0,117
 83a:	e8a78ce3          	beq	a5,a0,6d2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 83e:	f8b60513          	addi	a0,a2,-117
 842:	e119                	bnez	a0,848 <vprintf+0x264>
 844:	ea0693e3          	bnez	a3,6ea <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 848:	f8b58513          	addi	a0,a1,-117
 84c:	e119                	bnez	a0,852 <vprintf+0x26e>
 84e:	ea071be3          	bnez	a4,704 <vprintf+0x120>
      } else if(c0 == 'x'){
 852:	07800513          	li	a0,120
 856:	eca784e3          	beq	a5,a0,71e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 85a:	f8860613          	addi	a2,a2,-120
 85e:	e219                	bnez	a2,864 <vprintf+0x280>
 860:	ec069be3          	bnez	a3,736 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 864:	f8858593          	addi	a1,a1,-120
 868:	e199                	bnez	a1,86e <vprintf+0x28a>
 86a:	ee0713e3          	bnez	a4,750 <vprintf+0x16c>
      } else if(c0 == 'p'){
 86e:	07000713          	li	a4,112
 872:	eee78ce3          	beq	a5,a4,76a <vprintf+0x186>
      } else if(c0 == 'c'){
 876:	06300713          	li	a4,99
 87a:	f2e78ce3          	beq	a5,a4,7b2 <vprintf+0x1ce>
      } else if(c0 == 's'){
 87e:	07300713          	li	a4,115
 882:	f4e782e3          	beq	a5,a4,7c6 <vprintf+0x1e2>
      } else if(c0 == '%'){
 886:	02500713          	li	a4,37
 88a:	f6e787e3          	beq	a5,a4,7f8 <vprintf+0x214>
        putc(fd, '%');
 88e:	02500593          	li	a1,37
 892:	855a                	mv	a0,s6
 894:	c95ff0ef          	jal	528 <putc>
        putc(fd, c0);
 898:	85a6                	mv	a1,s1
 89a:	855a                	mv	a0,s6
 89c:	c8dff0ef          	jal	528 <putc>
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	b359                	j	628 <vprintf+0x44>

00000000000008a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a4:	715d                	addi	sp,sp,-80
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e010                	sd	a2,0(s0)
 8ae:	e414                	sd	a3,8(s0)
 8b0:	e818                	sd	a4,16(s0)
 8b2:	ec1c                	sd	a5,24(s0)
 8b4:	03043023          	sd	a6,32(s0)
 8b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	8622                	mv	a2,s0
 8be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c2:	d23ff0ef          	jal	5e4 <vprintf>
}
 8c6:	60e2                	ld	ra,24(sp)
 8c8:	6442                	ld	s0,16(sp)
 8ca:	6161                	addi	sp,sp,80
 8cc:	8082                	ret

00000000000008ce <printf>:

void
printf(const char *fmt, ...)
{
 8ce:	711d                	addi	sp,sp,-96
 8d0:	ec06                	sd	ra,24(sp)
 8d2:	e822                	sd	s0,16(sp)
 8d4:	1000                	addi	s0,sp,32
 8d6:	e40c                	sd	a1,8(s0)
 8d8:	e810                	sd	a2,16(s0)
 8da:	ec14                	sd	a3,24(s0)
 8dc:	f018                	sd	a4,32(s0)
 8de:	f41c                	sd	a5,40(s0)
 8e0:	03043823          	sd	a6,48(s0)
 8e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e8:	00840613          	addi	a2,s0,8
 8ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f0:	85aa                	mv	a1,a0
 8f2:	4505                	li	a0,1
 8f4:	cf1ff0ef          	jal	5e4 <vprintf>
}
 8f8:	60e2                	ld	ra,24(sp)
 8fa:	6442                	ld	s0,16(sp)
 8fc:	6125                	addi	sp,sp,96
 8fe:	8082                	ret

0000000000000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	1141                	addi	sp,sp,-16
 902:	e406                	sd	ra,8(sp)
 904:	e022                	sd	s0,0(sp)
 906:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 908:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90c:	00000797          	auipc	a5,0x0
 910:	6fc7b783          	ld	a5,1788(a5) # 1008 <freep>
 914:	a039                	j	922 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 916:	6398                	ld	a4,0(a5)
 918:	00e7e463          	bltu	a5,a4,920 <free+0x20>
 91c:	00e6ea63          	bltu	a3,a4,930 <free+0x30>
{
 920:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 922:	fed7fae3          	bgeu	a5,a3,916 <free+0x16>
 926:	6398                	ld	a4,0(a5)
 928:	00e6e463          	bltu	a3,a4,930 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	fee7eae3          	bltu	a5,a4,920 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 930:	ff852583          	lw	a1,-8(a0)
 934:	6390                	ld	a2,0(a5)
 936:	02059813          	slli	a6,a1,0x20
 93a:	01c85713          	srli	a4,a6,0x1c
 93e:	9736                	add	a4,a4,a3
 940:	02e60563          	beq	a2,a4,96a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 944:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 948:	4790                	lw	a2,8(a5)
 94a:	02061593          	slli	a1,a2,0x20
 94e:	01c5d713          	srli	a4,a1,0x1c
 952:	973e                	add	a4,a4,a5
 954:	02e68263          	beq	a3,a4,978 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 958:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95a:	00000717          	auipc	a4,0x0
 95e:	6af73723          	sd	a5,1710(a4) # 1008 <freep>
}
 962:	60a2                	ld	ra,8(sp)
 964:	6402                	ld	s0,0(sp)
 966:	0141                	addi	sp,sp,16
 968:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 96a:	4618                	lw	a4,8(a2)
 96c:	9f2d                	addw	a4,a4,a1
 96e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	6310                	ld	a2,0(a4)
 976:	b7f9                	j	944 <free+0x44>
    p->s.size += bp->s.size;
 978:	ff852703          	lw	a4,-8(a0)
 97c:	9f31                	addw	a4,a4,a2
 97e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 980:	ff053683          	ld	a3,-16(a0)
 984:	bfd1                	j	958 <free+0x58>

0000000000000986 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 986:	7139                	addi	sp,sp,-64
 988:	fc06                	sd	ra,56(sp)
 98a:	f822                	sd	s0,48(sp)
 98c:	f04a                	sd	s2,32(sp)
 98e:	ec4e                	sd	s3,24(sp)
 990:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 992:	02051993          	slli	s3,a0,0x20
 996:	0209d993          	srli	s3,s3,0x20
 99a:	09bd                	addi	s3,s3,15
 99c:	0049d993          	srli	s3,s3,0x4
 9a0:	2985                	addiw	s3,s3,1
 9a2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9a4:	00000517          	auipc	a0,0x0
 9a8:	66453503          	ld	a0,1636(a0) # 1008 <freep>
 9ac:	c905                	beqz	a0,9dc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	09377663          	bgeu	a4,s3,a3e <malloc+0xb8>
 9b6:	f426                	sd	s1,40(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9be:	8a4e                	mv	s4,s3
 9c0:	6705                	lui	a4,0x1
 9c2:	00e9f363          	bgeu	s3,a4,9c8 <malloc+0x42>
 9c6:	6a05                	lui	s4,0x1
 9c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d0:	00000497          	auipc	s1,0x0
 9d4:	63848493          	addi	s1,s1,1592 # 1008 <freep>
  if(p == SBRK_ERROR)
 9d8:	5afd                	li	s5,-1
 9da:	a83d                	j	a18 <malloc+0x92>
 9dc:	f426                	sd	s1,40(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e4:	00000797          	auipc	a5,0x0
 9e8:	62c78793          	addi	a5,a5,1580 # 1010 <base>
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60f73e23          	sd	a5,1564(a4) # 1008 <freep>
 9f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fa:	b7d1                	j	9be <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9fc:	6398                	ld	a4,0(a5)
 9fe:	e118                	sd	a4,0(a0)
 a00:	a899                	j	a56 <malloc+0xd0>
  hp->s.size = nu;
 a02:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a06:	0541                	addi	a0,a0,16
 a08:	ef9ff0ef          	jal	900 <free>
  return freep;
 a0c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a0e:	c125                	beqz	a0,a6e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a12:	4798                	lw	a4,8(a5)
 a14:	03277163          	bgeu	a4,s2,a36 <malloc+0xb0>
    if(p == freep)
 a18:	6098                	ld	a4,0(s1)
 a1a:	853e                	mv	a0,a5
 a1c:	fef71ae3          	bne	a4,a5,a10 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a20:	8552                	mv	a0,s4
 a22:	a0dff0ef          	jal	42e <sbrk>
  if(p == SBRK_ERROR)
 a26:	fd551ee3          	bne	a0,s5,a02 <malloc+0x7c>
        return 0;
 a2a:	4501                	li	a0,0
 a2c:	74a2                	ld	s1,40(sp)
 a2e:	6a42                	ld	s4,16(sp)
 a30:	6aa2                	ld	s5,8(sp)
 a32:	6b02                	ld	s6,0(sp)
 a34:	a03d                	j	a62 <malloc+0xdc>
 a36:	74a2                	ld	s1,40(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a3e:	fae90fe3          	beq	s2,a4,9fc <malloc+0x76>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	02071693          	slli	a3,a4,0x20
 a4c:	01c6d713          	srli	a4,a3,0x1c
 a50:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a52:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a56:	00000717          	auipc	a4,0x0
 a5a:	5aa73923          	sd	a0,1458(a4) # 1008 <freep>
      return (void*)(p + 1);
 a5e:	01078513          	addi	a0,a5,16
  }
}
 a62:	70e2                	ld	ra,56(sp)
 a64:	7442                	ld	s0,48(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6121                	addi	sp,sp,64
 a6c:	8082                	ret
 a6e:	74a2                	ld	s1,40(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	b7f5                	j	a62 <malloc+0xdc>

0000000000000a78 <thread_create>:

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
 a78:	7179                	addi	sp,sp,-48
 a7a:	f406                	sd	ra,40(sp)
 a7c:	f022                	sd	s0,32(sp)
 a7e:	ec26                	sd	s1,24(sp)
 a80:	e84a                	sd	s2,16(sp)
 a82:	e44e                	sd	s3,8(sp)
 a84:	1800                	addi	s0,sp,48
 a86:	89aa                	mv	s3,a0
 a88:	892e                	mv	s2,a1
 a8a:	84b2                	mv	s1,a2
  void *stack = malloc(n_pages * PGSIZE);
 a8c:	00c6151b          	slliw	a0,a2,0xc
 a90:	ef7ff0ef          	jal	986 <malloc>
  if(stack == 0) return -1;
 a94:	c91d                	beqz	a0,aca <thread_create+0x52>
 a96:	e052                	sd	s4,0(sp)
 a98:	862a                	mv	a2,a0
 a9a:	8a2a                	mv	s4,a0

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);
 a9c:	10000713          	li	a4,256
 aa0:	86a6                	mv	a3,s1
 aa2:	85ca                	mv	a1,s2
 aa4:	854e                	mv	a0,s3
 aa6:	9d3ff0ef          	jal	478 <clone>

  if(pid < 0) {
 aaa:	00054a63          	bltz	a0,abe <thread_create+0x46>
 aae:	6a02                	ld	s4,0(sp)
    free(stack);
    return -1;
  }
  return pid;
}
 ab0:	70a2                	ld	ra,40(sp)
 ab2:	7402                	ld	s0,32(sp)
 ab4:	64e2                	ld	s1,24(sp)
 ab6:	6942                	ld	s2,16(sp)
 ab8:	69a2                	ld	s3,8(sp)
 aba:	6145                	addi	sp,sp,48
 abc:	8082                	ret
    free(stack);
 abe:	8552                	mv	a0,s4
 ac0:	e41ff0ef          	jal	900 <free>
    return -1;
 ac4:	557d                	li	a0,-1
 ac6:	6a02                	ld	s4,0(sp)
 ac8:	b7e5                	j	ab0 <thread_create+0x38>
  if(stack == 0) return -1;
 aca:	557d                	li	a0,-1
 acc:	b7d5                	j	ab0 <thread_create+0x38>

0000000000000ace <thread_join>:

int
thread_join(void)
{
 ace:	7179                	addi	sp,sp,-48
 ad0:	f406                	sd	ra,40(sp)
 ad2:	f022                	sd	s0,32(sp)
 ad4:	ec26                	sd	s1,24(sp)
 ad6:	1800                	addi	s0,sp,48
  void *stack = 0;
 ad8:	fc043c23          	sd	zero,-40(s0)
  int pid = join(&stack);
 adc:	fd840513          	addi	a0,s0,-40
 ae0:	9a1ff0ef          	jal	480 <join>
 ae4:	84aa                	mv	s1,a0

  if(pid > 0 && stack != 0) {
 ae6:	00a05763          	blez	a0,af4 <thread_join+0x26>
 aea:	fd843503          	ld	a0,-40(s0)
 aee:	c119                	beqz	a0,af4 <thread_join+0x26>
    free(stack);
 af0:	e11ff0ef          	jal	900 <free>
  }
  return pid;
}
 af4:	8526                	mv	a0,s1
 af6:	70a2                	ld	ra,40(sp)
 af8:	7402                	ld	s0,32(sp)
 afa:	64e2                	ld	s1,24(sp)
 afc:	6145                	addi	sp,sp,48
 afe:	8082                	ret
