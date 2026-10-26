#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    printf("pid,state,name\n");
    if(argc == 1){
        ps(0);
    }
    else{
        for(int i = 1; i < argc; i++)
            ps(atoi(argv[i]));
    }
  exit(0);
}