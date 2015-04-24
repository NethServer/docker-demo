======================
NethServer Docker Demo
======================

This is a demo of NethServer running on a Docker container.  The only
working part is the web interface. No installed module will work.

To start the container: ::

  docker run -p 8080:980 nethserver/docker-demo
  
The command keeps the process on foreground. Type ^C to stop it.
  
To access the web interface (Server Manager) point your browser to: ::

  http://localhost:8080

Use ``root`` as user name and the well-known password, ``Nethesis,1234``.
  
If you like to see what is under the hood, run Bash: ::

  docker run -i -t --entrypoint='/bin/bash' nethserver/docker-demo


