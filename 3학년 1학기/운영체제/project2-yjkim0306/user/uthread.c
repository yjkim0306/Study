//
// User-space helpers for kernel threads.
//
// thread_create() and thread_join() are thin wrappers over the clone()
// and join() system calls.  They mirror the spirit of pthread_create()
// and pthread_join():

#include "kernel/types.h"
#include "kernel/riscv.h"
#include "user/user.h"
#include "user/uthread.h"

#define CLONE_VM 0x0100

int
thread_create(void (*fn)(void *), void *arg, int n_pages)
{
  void *stack = malloc(n_pages * PGSIZE);
  if(stack == 0) return -1;

  int pid = clone(fn, arg, stack, n_pages, CLONE_VM);

  if(pid < 0) {
    free(stack);
    return -1;
  }
  return pid;
}

int
thread_join(void)
{
  void *stack = 0;
  int pid = join(&stack);

  if(pid > 0 && stack != 0) {
    free(stack);
  }
  return pid;
}
