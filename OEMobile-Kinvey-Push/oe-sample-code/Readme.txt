1) Install COMODO root certificate as trusted Root Authority.
•	This is because the RA of the <your instance>.kinvey.com is not by default trusted RA in openedge certificate store
•	Unzip the attached zip and put it any where on disk (say c:\openedge\wrk)
•	Open proenv and type certutil -import c:\openedge\wrk\COMODORSACertificationAuthority.crt
•	You should see it imported successfully


2) Update push-notification.p with details of Kinvey's instance, appId and user 
3) call the procedure run.p

Note: You need to make sure the propath is set correctly. (e.g. c:\progress\OpenEdge\gui\netlib\OpenEdge.Net.pl should be in propath.) 
