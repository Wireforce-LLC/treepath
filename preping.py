import time

param = '-c'
packages = 1
file_name = "/etc/nginx/routes.trp"

def ping(hostname):
    """Ping host and return True if reachable, False otherwise

    This is much faster than using os.system to ping, as it avoids
    starting up a new shell and avoiding the overhead of running
    the ping command.

    """
    from subprocess import Popen, PIPE
    host_only = hostname.replace('https://', '').replace('http://', '')

    if '/' in host_only:
        print("Not a valid hostname")
        exit(1)

    ping_proc = Popen(
        ['ping', '-c', str(packages), host_only],
        
        stdout=PIPE,
        stderr=PIPE
    )
    
    ping_proc.communicate()
    return ping_proc.returncode == 0


def ping2(hostname):
    if not ping(hostname):
        with open('/etc/nginx/host-errors.logs', 'a+') as f:
            f.write(f"[{time.time()}] {hostname} is not reachable\n")

with open(file_name, 'r+') as f:
    for line in f.readlines():
        if " => " in line: 
            host = line.split(" => ")[1]
            print("Ping " + host)
            ping2(host)
