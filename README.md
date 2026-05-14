#####################################################################################
#A small internal Status Dashboard service deployed on a Linux host                 #
#...................................................................................#
#Service deployed by docker,uses flask application and nginx                        #
#####################################################################################
Instruction and Explaining
-------------------------------------------------------------------------------------
Features

- Flask web dashboard
- Versioned status API
- Protected secret endpoint
- Dockerized application
- Host nginx reverse proxy
- Idempotent install script
.....................................................................................
Api
/api/status
Redirects to /api/v1/status

/api/v1/status
Returns JSON

/api/secret
Redirect to /api/v1/secret

/api/v1/secret
Requires header:
Without the correct key, returns 401 Unauthorized.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Full installation
Run:
sudo API_KEY=letmein ./install.sh

Script install 

Deploy nginx
Build and run Docker
Deploy Flask
#####################################################################################
 
