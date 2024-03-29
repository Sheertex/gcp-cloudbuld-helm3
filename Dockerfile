FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine

ARG HELM_VERSION=v3.10.3
ENV HELM_VERSION=$HELM_VERSION

RUN mkdir -p /builder/helm && \
  curl -SL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
  tar zxvf helm.tar.gz --strip-components=1 -C /builder/helm linux-amd64 && \
  rm helm.tar.gz && \
  apk add --no-cache openjdk8-jre && \
  gcloud components install gke-gcloud-auth-plugin

ENV PATH=/builder/helm/:$PATH

COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]
