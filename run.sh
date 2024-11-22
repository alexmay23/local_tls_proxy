docker stop nginx-proxy-container
docker rm nginx-proxy-container
docker run -d -p 443:443 --name nginx-proxy-container nginx-proxy
