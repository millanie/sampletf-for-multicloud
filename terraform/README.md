### prerequisite for aws

* aws cli installation
  check how-to on [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
  
  > sample for linux
  > curl -o https://bootstrap.pypa.io/get-pip.py
  > python get-pip.py --user or python3 get-pip.py --user
  > pip3 install awscli --upgrade --user


* configuration of aws profile
  During this process, you need IAM access key and secret key which have the proper permission to provision. 
  > $ aws configure --profile {profile name}


