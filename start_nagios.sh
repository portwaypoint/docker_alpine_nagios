
nagios /etc/nagios/nagios.cfg &

socat -d -d TCP-LISTEN:30000,fork UNIX-CLIENT:/var/lib/nagios/rw/live
