1- run without cache to capture the latest changes in main branch 
2- copy my own creds to the container to be able to access the github repo
docker build --no-cache -t my-test-image --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" .