======================
NethServer Docker Demo
======================

This is a demo of NethServer running on a Docker container.  The only
working part is the web interface. No installed module will work.

To start the container: ::

  docker run -p 8080:980 nethserver:docker-demo
  
The command keeps the process on foreground. Type ^C to stop it.
  
To access the web interface (Server Manager) point your browser to: ::

  http://localhost:8080

If you like to see what is under the hood, start the container
WITH_SSH. For instance: ::

  docker run -p 8080:980 -p 2222:22 -e WITH_SSH=1 nethserver:docker-demo

Then open another terminal and connect on port 2222, using the
well-known password, ``Nethesis,1234``: ::

  ssh -p 2222 localhost

  

