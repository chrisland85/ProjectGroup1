# ProjectGroup1.
Web application that displays student information.
There are three enviroments which dev, staging and prod.
This project is highly modularised.
This webserver and the network are in the module folder why the enviroments are in the Project_environment folder.
The network files are placed in the aws_network folder which is also the module folder.
The webserver load balancer, autoscaling, security groups etc files are placed the aws_webservers folder.
In the dev folder contains the network and the webserver folder which are all necessary files to run the dev environment why
the prod folder contains the network and the webserver folder which are all necessary files to run the prod environment and same goes for the staging

---------------execution--------------------
First of all, the backup s3 bucket for storing terraform state is created for each of the enviroment.
Then, the key pair is generated for each enviroment by running the ssh-keygen command in the path provided in the code
Each environment is provision by running terraform init, terraform validate, plan and apply on both the network and webserver.
The dev environment consist provisions two autoscaling virtual machines in two availability zones why staging provisions 3 and the prod provisions 3
The environment also contains load balancers which direct traffic to all healthy nodes and makes sure the workload spread evenly
All codes are save in github.
Note: all the enviroment can be provisioned and running simultaneously

















testing testing testing 
