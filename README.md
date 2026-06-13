# failed-request-trace
Failed Request Trace (FRT) for NGINX and Cloud-Native Architectures

##

docker build -t failed-request-trace:latest -f nginx/Dockerfile .
docker run -p 80:80 failed-request-trace:latest