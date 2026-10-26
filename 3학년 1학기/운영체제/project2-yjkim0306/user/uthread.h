// User-space helpers for kernel threads.
//
// Thin wrappers over the clone() and join() syscalls that handle the
// user-stack lifetime (malloc on create, free on join).
//
// Usage:
//   #include "user/user.h"
//   #include "user/uthread.h"

int thread_create(void (*fn)(void *), void *arg, int n_pages);
int thread_join(void);
