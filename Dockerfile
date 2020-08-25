FROM alpine:3.1
RUN apk update \
  && apk add openssh-client sshpass ca-certificates bash
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]

