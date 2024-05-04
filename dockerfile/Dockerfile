FROM alpine
MAINTAINER Sander <mail@sandervanvugt.nl>

# Add file
ADD ./countdown /apps

# Install cool software
RUN apk add bash 

ENTRYPOINT ["/apps/countdown"]
CMD ["1"] 
