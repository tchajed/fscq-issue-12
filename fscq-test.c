#include <sys/types.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
  chdir("/tmp/fscqmnt");

  unsigned char buf[8192] = { 1, };
  int fd_root = syscall(SYS_open, ".", O_DIRECTORY, 0);
  int fd_foo = syscall(SYS_open, "./foo", O_CREAT | O_RDWR, 0777);
  syscall(SYS_fsync, fd_foo);
  syscall(SYS_mkdir, "./A", 0777);
  syscall(SYS_ftruncate, fd_foo, 5595);
  syscall(SYS_pwrite64, fd_foo, buf, 4000, 1303);
  syscall(SYS_fsync, fd_root);

  system("killall -9 fscq"); // crash fscq
  return 0;
}
