#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_clone(void)
{
  uint64 fn, arg, stack;
  int n_pages, flags;

  argaddr(0, &fn);
  argaddr(1, &arg);
  argaddr(2, &stack);
  argint (3, &n_pages);
  argint (4, &flags);

  return kclone(fn, arg, stack, n_pages, flags);
}

uint64
sys_join(void)
{
  uint64 stack_addr;
  argaddr(0, &stack_addr);
  return kjoin(stack_addr);
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;
  struct proc *p = myproc();
  struct mm_struct *mm = p->mm;

  argint(0, &n);
  argint(1, &t);

  if(t == SBRK_EAGER || n < 0) {
    acquire(&mm->lock);
    addr = mm->sz;
    release(&mm->lock);
    if(growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the process uses the
    // memory, vmfault() will allocate it.
    acquire(&mm->lock);
    addr = mm->sz;
    if(addr + n < addr) {
      release(&mm->lock);
      return -1;
    }
    if(addr + n > USERTOP) {
      release(&mm->lock);
      return -1;
    }
    mm->sz += n;
    release(&mm->lock);
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
