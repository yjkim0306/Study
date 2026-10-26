#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PNUM 6
int nice_vals[PNUM] = {-3,-2, -1, 0, 1, 2};

#define LOOP_COUNT 1000000000

int main(int argc, char *argv[]) {
  printf("Starting CFS Test...\n");

  for (int i = 0; i < PNUM; i++) {
    int pid = fork();
    
    if (pid < 0) {
      printf("fork failed\n");
      exit(1);
    }

    if (pid == 0) {
      if (set_nice(nice_vals[i]) != 0) {
        printf("set_nice failed for nice %d\n", nice_vals[i]);
        exit(1);
      }

      int start_tick = uptime();

      for (volatile int j = 0; j < LOOP_COUNT; j++) {

      }

      int end_tick = uptime();

      printf("PID: %d, Nice: %d, Ticks: %d\n", getpid(), nice_vals[i], end_tick - start_tick);
      
      exit(0);
    }
  }

  for (int i = 0; i < PNUM; i++) {
    wait(0);
  }

  printf("CFS Test Completed.\n");
  exit(0);
}