# pinger
Takes a text file of IPs/hostnames to ping as an argument, and runs ping against all of them. Runs a timer for anything down.


### Use

 1. Clone this repo: `git clone https://github.com/Starttoaster/pinger.git && cd pinger/`

 2. Make a text file to run the tests on. Can be named anything, and store the IPs/hostnames on new lines.

 3. Run the script: `./pinger.sh <filename>`

 
### Example text file:

```
8.8.8.8
google.com
8.8.4.4
example.com
1.1.1.1
cloudflare.com
```
