# pinger
Takes a text file of IPs/hostnames to ping as an argument, and runs ping against all of them. Alternatively, uses cURL in the case of URLs. Runs timers for anything that is 'down'.


### Use

 1. Clone this repo: `git clone https://github.com/Starttoaster/pinger.git && cd pinger/`

 2. Make a text file to run the tests on. Can be named anything, and store the IPs/hostnames/URLs on new lines.

 3. Run the script: `./pinger.sh <filename>`

 
### Example text file and output:

```
8.8.8.8
1.1.1.1
8.8.4.4
https://google.com
https://example.com
https://cloudflare.com
network-switch1
network-switch2
corerouter01
```

In order we have a few examples of valid IP addresses, a few valid URLs (for best results please use the full URL including http/https), and some network hosts if configured on your private network. 
Here is the output after running the script against this example document:

```
Hostname              : Status    : Method    : Timer
8.8.8.8               : ONLINE    : ping      :
1.1.1.1               : ONLINE    : ping      :
8.8.4.4               : ONLINE    : ping      :
https://google.com    : ONLINE    : cURL      :
https://example.com   : ONLINE    : cURL      :
https://cloudflare.com: ONLINE    : cURL      :
network-switch1       : OFFLINE   : ping      : 00:00:16
network-switch2       : OFFLINE   : ping      : 00:00:16
corerouter01          : OFFLINE   : ping      : 00:00:16
```

Obviously, the internal hostnames show as "OFFLINE" because they don't exist in my local network. But if I had something named "corerouter01" specified in my /etc/hosts file then it would return ping. 

