#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <windows.h>

void usage(FILE *out)
{
    fprintf(out, "Usage:\n");
    fprintf(out, "    [MessageBox Text]\n");
    fprintf(out, "    [MessageBox Caption]\n");
    exit(8);
}

int WinMain(int argc, char *argv[])
{
    if (argc > 2) {
      usage(stdout);
    }
    int retval = MessageBox(
                           NULL,
                           argv[0],
                           argv[1],
                           0
                           );
    return 0;
}
