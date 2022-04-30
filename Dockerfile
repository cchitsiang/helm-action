FROM alpine:3.13

ARG KUBECTL_VERSION="1.21.2"

RUN apk add py-pip curl wget ca-certificates git bash jq gcc alpine-sdk
RUN pip install 'awscli==1.22.26'
RUN curl -L -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl

RUN curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x /usr/bin/aws-iam-authenticator

RUN wget https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm
RUN chmod +x /usr/local/bin/helm

RUN wget -qO- https://github.com/mozilla/sops/releases/download/v3.7.1/sops-v3.7.1.linux > /usr/local/bin/sops
RUN chmod +x /usr/local/bin/sops

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]:
