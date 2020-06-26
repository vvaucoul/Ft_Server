docker build -t $1 . && docker run -it -p 80:80 -p 443:443 $1
