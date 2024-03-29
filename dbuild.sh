# /bin/sh

# build docker from env
echo \
'FROM alpine:3.7
MAINTAINER SHU <free1139@163.com>

RUN apk add --update ca-certificates
RUN mkdir -p /app/var/log/
COPY ./publish/'$PRJ_NAME' /app
COPY ./bin/docker/supd /usr/bin/

CMD ["supd", "-c","/app/etc/supervisord.conf", "-n"]
'>Dockerfile


# build docker image
pwd_dir=`pwd`

go get -v github.com/gwaylib/goget||exit 1
mkdir -p $PRJ_ROOT/bin/docker||exit 1

# build bin data
export CGO_ENABLED=0 GOOS=linux GOARCH=amd64

goget -v -d github.com/gwaypg/supd||exit 1
cd $GOLIB/src/github.com/gwaypg/supd||exit 1
go build||exit 1
mkdir -p $PRJ_ROOT/bin/docker||exit 1
mv ./supd $PRJ_ROOT/bin/docker||exit 1
cd $pwd_dir

# publish build
sup publish all

echo "# Building Dockerfile"
# remove old images
sudo docker rmi -f $PRJ_NAME||exit 1
# build images
sudo docker build -t $PRJ_NAME .||exit 1
# rm tmp data
# rm app

# show images build result
sudo docker images $PRJ_NAME||exit 1

# remove dockerfile
rm Dockerfile||exit 1
