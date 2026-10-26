#include "kernel/param.h"
#include "kernel/fcntl.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PGSIZE 4096
#define MAP_FAILED ((char *) -1)

char *testname = "???";
char buf[PGSIZE];

void
err(char *why)
{
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
  exit(1);
}

// Make a file with 1.5 pages of 'A' followed by zeros (rest of the page).
static void
make_test_file(const char *name)
{
  int fd;
  unlink(name);
  fd = open(name, O_WRONLY | O_CREATE | O_TRUNC);
  if(fd == -1)
    err("open create");
  memset(buf, 'A', PGSIZE);
  if(write(fd, buf, PGSIZE) != PGSIZE)
    err("write 1");
  memset(buf, 'A', PGSIZE/2);
  if(write(fd, buf, PGSIZE/2) != PGSIZE/2)
    err("write 2");
  if(close(fd) == -1)
    err("close");
}

// Verify 1.5 pages of 'A' then zeros (lazy zero-fill for the rest of the page).
static void
verify_content(char *p)
{
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++){
    if(p[i] != 'A'){
      printf("mismatch at %d: got 0x%x, want 'A'\n", i, p[i]);
      err("content mismatch (A)");
    }
  }
  for(int i = PGSIZE + PGSIZE/2; i < 2*PGSIZE; i++){
    if(p[i] != 0){
      printf("mismatch at %d: got 0x%x, want 0\n", i, p[i]);
      err("content mismatch (zero)");
    }
  }
}

static void
basic_test(void)
{
  testname = "test basic mmap";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDONLY);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
  if(p == MAP_FAILED) err("mmap");
  verify_content(p);
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
  close(fd);
  printf("%s: OK\n", testname);
}

static void
private_test(void)
{
  testname = "test mmap private";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDWR);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
  if(p == MAP_FAILED) err("mmap");
  // modify; should not change file
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++)
    p[i] = 'Z';
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
  close(fd);

  // re-open and check file is unmodified
  fd = open(f, O_RDONLY);
  if(fd == -1) err("re-open");
  char rb[16];
  if(read(fd, rb, 8) != 8) err("read");
  for(int i = 0; i < 8; i++){
    if(rb[i] != 'A') err("private modified file");
  }
  close(fd);
  printf("%s: OK\n", testname);
}

static void
readonly_test(void)
{
  testname = "test mmap read-only";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDONLY);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
  if(p == MAP_FAILED) err("mmap");
  verify_content(p);
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
  close(fd);
  printf("%s: OK\n", testname);
}

static void
readwrite_test(void)
{
  testname = "test mmap read/write";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDWR);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if(p == MAP_FAILED) err("mmap");
  // verify initial content
  verify_content(p);
  // modify content of first byte
  for(int i = 0; i < PGSIZE + PGSIZE/2; i++)
    p[i] = 'B';
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
  close(fd);

  // re-open and verify file has 'B' bytes
  fd = open(f, O_RDONLY);
  if(fd == -1) err("re-open");
  char rb[16];
  if(read(fd, rb, 8) != 8) err("read");
  for(int i = 0; i < 8; i++){
    if(rb[i] != 'B') err("shared write not flushed");
  }
  close(fd);
  printf("%s: OK\n", testname);
}

static void
dirty_test(void)
{
  testname = "test mmap dirty";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDWR);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if(p == MAP_FAILED) err("mmap");
  // do not modify; munmap should not corrupt the file
  if(munmap(p, PGSIZE*2) == -1) err("munmap");
  close(fd);
  // verify file unchanged
  fd = open(f, O_RDONLY);
  if(fd == -1) err("re-open");
  char rb[16];
  if(read(fd, rb, 8) != 8) err("read");
  for(int i = 0; i < 8; i++){
    if(rb[i] != 'A') err("non-dirty corrupted file");
  }
  close(fd);
  printf("%s: OK\n", testname);
}

static void
not_mapped_unmap_test(void)
{
  testname = "test not-mapped unmap";
  printf("%s\n", testname);
  // unmap an address that is not mapped should return -1
  if(munmap((void*)0x10000000UL, PGSIZE) != -1)
    err("unmap of unmapped should fail");
  printf("%s: OK\n", testname);
}

static void
lazy_test(void)
{
  testname = "test lazy access";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDONLY);
  if(fd == -1) err("open");
  // mmap a large region (3 pages), only touch first byte to verify laziness
  char *p = mmap(PGSIZE*3, PROT_READ, MAP_PRIVATE, fd, 0);
  if(p == MAP_FAILED) err("mmap");
  if(p[0] != 'A') err("read");
  if(munmap(p, PGSIZE*3) == -1) err("munmap");
  close(fd);
  printf("%s: OK\n", testname);
}

static void
two_files_test(void)
{
  testname = "test mmap two files";
  printf("%s\n", testname);
  const char *f1 = "mmap1.dur";
  const char *f2 = "mmap2.dur";

  unlink(f1);
  unlink(f2);

  int fd1 = open(f1, O_RDWR | O_CREATE | O_TRUNC);
  if(fd1 == -1) err("open f1");
  memset(buf, 'X', PGSIZE);
  if(write(fd1, buf, PGSIZE) != PGSIZE) err("write f1");

  int fd2 = open(f2, O_RDWR | O_CREATE | O_TRUNC);
  if(fd2 == -1) err("open f2");
  memset(buf, 'Y', PGSIZE);
  if(write(fd2, buf, PGSIZE) != PGSIZE) err("write f2");

  char *p1 = mmap(PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
  if(p1 == MAP_FAILED) err("mmap f1");
  char *p2 = mmap(PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
  if(p2 == MAP_FAILED) err("mmap f2");

  for(int i = 0; i < PGSIZE; i++){
    if(p1[i] != 'X') err("p1");
    if(p2[i] != 'Y') err("p2");
  }

  if(munmap(p1, PGSIZE) == -1) err("munmap f1");
  if(munmap(p2, PGSIZE) == -1) err("munmap f2");

  close(fd1);
  close(fd2);
  unlink(f1);
  unlink(f2);

  printf("%s: OK\n", testname);
}

static void
fork_test(void)
{
  testname = "test fork";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDONLY);
  if(fd == -1) err("open");

  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
  if(p == MAP_FAILED) err("mmap");

  int pid = fork();
  if(pid < 0) err("fork");
  if(pid == 0){
    // child checks its mapping
    verify_content(p);
    if(munmap(p, PGSIZE*2) == -1) err("munmap child");
    exit(0);
  }
  int status;
  wait(&status);
  if(status != 0) err("child exit");
  // parent still has mapping
  verify_content(p);
  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
  close(fd);

  printf("%s: OK\n", testname);
}

static void
unmap_access_test(void)
{
  testname = "test munmap prevents access";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDONLY);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
  if(p == MAP_FAILED) err("mmap");

  // fault when accessing after unmap (in child to keep parent alive)
  int pid = fork();
  if(pid < 0) err("fork");
  if(pid == 0){
    if(munmap(p, PGSIZE*2) == -1) exit(1);
    volatile char c = p[PGSIZE]; // should fault
    (void)c;
    exit(0);
  }
  int status;
  wait(&status);
  if(status == 0) err("child should have been killed");

  // again, fault at first page
  pid = fork();
  if(pid < 0) err("fork");
  if(pid == 0){
    if(munmap(p, PGSIZE*2) == -1) exit(1);
    volatile char c = p[0]; // should fault
    (void)c;
    exit(0);
  }
  wait(&status);
  if(status == 0) err("child2 should have been killed");

  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
  close(fd);
  printf("%s: OK\n", testname);
}

static void
readonly_writes_test(void)
{
  testname = "test writes to read-only mapped memory";
  printf("%s\n", testname);
  const char *f = "mmap.dur";
  make_test_file(f);

  int fd = open(f, O_RDONLY);
  if(fd == -1) err("open");
  char *p = mmap(PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
  if(p == MAP_FAILED) err("mmap");

  int pid = fork();
  if(pid < 0) err("fork");
  if(pid == 0){
    p[0] = 'B'; // should fault, kill the child
    exit(0);
  }
  int status;
  wait(&status);
  if(status == 0) err("child should have been killed");

  if(munmap(p, PGSIZE*2) == -1) err("munmap parent");
  close(fd);
  printf("%s: OK\n", testname);
}

int
main(int argc, char *argv[])
{
  basic_test();
  private_test();
  readonly_test();
  readwrite_test();
  dirty_test();
  not_mapped_unmap_test();
  lazy_test();
  two_files_test();
  fork_test();
  unmap_access_test();
  readonly_writes_test();

  unlink("mmap.dur");
  printf("mmaptest: all tests succeeded\n");
  exit(0);
}
