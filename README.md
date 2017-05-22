This a set of scrips that generally, use telnet to reboot a modem if a set of
network tests repeatedly fail. In particular watchdog.sh runs an infinite loop 
that, every five minutes:

- Performs three Internet connectivity tests: (1) a DNS resolution on 
  google.com, (2) a reverse DNS resolution on Google’s DNS server (8.8.8.8), and
  (3) a ping on google.com.
- Determines if all three tests resulted in an error (i.e., there is no Internet
  connectivity). If so,
  - It increments a counter, and
  - It determines if the counter has exceeded a threshold (two, meaning that the 
    set of tests failed three times in a row). If so,
    - It issues a modem reboot via telnet (using expect.sh),
    - It waits for three minutes for the modem to come back up, and
    - It increments a “reboot” count.
- If there was no error (i.e., there is Internet connectivity), it determines if
  the count is greater then zero. This means either that (1) the tests 
  previously failed, but fewer then three times in a row, or (2) the tests have
  failed three or more times and a modem reboot was issued at least once. If so,
  - It resets the count to zero (because the Internet is accessible), and
  - Determines if the reboot count is greater than zero (i.e., one or more 
    reboots were issued). If so,
    - It sends e-mail notification(s)–the system needs to be appropriately 
      configured, and
    - It resets the reboot count to zero.
- Finally, it checks if the reboot count has reached a value greater than ten.
  This would mean that there have been ten (or more) reboots issued and the
  Internet is still not back up. This could be because the modem is not
  responding via telnet (e.g., there is a hard lockup), or because there is some
  other connectivity issue. Rather than continuing to issue reboot commands
  every five minutes, it sleeps for an additional hour. This continues until
  connectivity is restored.
  
See more at:
https://www.coombscloud.com/2017/05/19/watchdog-script-to-reboot-my-modem/