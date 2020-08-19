# legacyssh
A Docker container with a legacy openssh client in it, so that you can access very old systems with very broken ssh servers.

## IMPORTANT!
This is an INSECURE version of ssh. Please only use it, if you have to other chance to access your system.
There are lots of legacy systems out in the wild, which have old ssh daemons runing and the vendor does not provide an update, because they are "EOL". That's where this container can be helpful.
You regard the ssh transfersas NOT encrypted, because some of the algorithms used are substentailly broken. There a reasons why ssh disabled them.

## Build the container
Requirementes: make and docker

```
make docker
```

## Use it
Example usage to connect to a APC 7920 switched powerbar with ssh port shifted to 2222
```
docker run -it legacyssh -p 20022 apc@hostname-or-ip-of-your-apc-7920-cruft
The authenticity of host '[...]:20022 ([....]:2222)' can't be established.
RSA key fingerprint is d3:fe:7d:48:c3:fe:90:43:1a:19:cb:65:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[...]:2222' (RSA) to the list of known hosts.
Authenticated with partial success.
apc@....'s password: 
```

## Shell Alias
To make the use more comfortable, you can set an alias for your shell.

```
make shellalias
```

will render an example for you.

After setting the alias, you can use it then like this:
```
legacyssh -p 20022 apc@hostname-or-ip-of-your-apc-7920-cruft
```

## Automation without sshkey authentication
Many of these legacy devices don't support ssh key authentication. To automate stuff with password, there is sshpass support provided. With that, you don't need to type the password.

```
export SSHPASS=mYPAssWord
legacyssh -p 20022 apc@hostname-or-ip-of-your-apc-7920-cruft
```

Hint: With sshpass enabled, you need to have a correct kownhosts, ssh will not ask to add the fingerprint if sshpass is enabled!

## Troubleshooting
Your .ssh directory will we mounted into the docker container, so you have the same configs like with your OSes normal ssh.
Keep in mind that the old ssh doesn't provide all config options that a modern ssh has, so you might end up with errors like this:

```
/root/.ssh/config: line 1: Bad configuration option: include
```

You can set a different config path in that case like this
```
make shellalias CONFDIR=/tmp/foo
```

Keep in mind, that legacyssh does NOT write into your ssh config or in your known hosts. So, new hosts won't be added and the fingerprint question will appear on each ussage. Either you set -o StrictHostKeyChecking=no or you add that hist manually to your knownhosts file.

## Alternatives
You can always try to allow weak algorithms on your current ssh. I my experience that can help in a lot of cases, but not in all. Usually ssh barks out telling you, which algorithm it is reluctant to use. Here are some exmaples how to convince ssh, to use them:

```
ssh -o KexAlgorithms="+diffie-hellman-group1-sha1,diffie-hellman-group14-sha1" -o HostKeyAlgorithms="+ssh-dss" -o Ciphers="+3des-cbc" your-weak-host.ip
ssh -o KexAlgorithms=diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-dss your-weak-host.ip
```

See: https://www.openssh.com/legacy.html

