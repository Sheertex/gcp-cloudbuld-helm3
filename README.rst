Run Helm 3 from Google CloudBuild
=================================

Based roughly on `cloud-builders-community/helm`__, but dramatically
simplified and based on the lightweight
``gcr.io/google.com/cloudsdktool/cloud-sdk:alpine`` image (~100Mb, versus
~700Mb for ``gcr.io/cloud-builders/gcloud``).

__ https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/helm

Usage:

1. (optional, recommended) Build your own Docker image with a specific Helm
   version and deploy it to your GCR repository::

    $ git clone https://github.com/Sheertex/gcp-cloudbuld-helm3.git
    $ cd gcp-cloudbuld-helm3
    $ export HELM_VERSION=v3.9.0
    $ export GCP_PROEJCT=<your GCP project name>
    $ docker build --build-arg HELM_VERSION=$HELM_VERSION -t gcr.io/$GCP_PROEJCT/helm:$HELM_VERSION .
    $ docker push gcr.io/$GCP_PROEJCT/helm:$HELM_VERSION

2. Ensure the CloudBuild service account has "Kubernetes Engine Admin" (visit
   https://console.cloud.google.com/iam-admin/iam?project=YOUR_PROJECT, edit
   the ``cloudbuild.gserviceaccount.com`` service account, add the "Kubernetes
   Engine Admin" role)

3. Run Helm from your ``cloudbuild.yaml`` file (if you created your own docker
   image in step 1, replace ``sx-ops-dev`` with your project name)::

    - name: 'gcr.io/sx-ops-dev/helm:v3.9.0'
      args: [
         'upgrade',
         '--install',
         'your-helm-release',
         './charts/your-chart/',
         '--set', 'image.tag=$COMMIT_SHA',
     ]
     env: [
         'CLOUDSDK_CONTAINER_PROJECT=${PROJECT_ID}',

         # If your cluster is zonal (ex, in `us-east4-a`), include:
         'CLOUDSDK_CONTAINER_ZONE=<your cluster's zone>',

         # If your cluster is regional (ex, in `us-east4`), include:
         'CLOUDSDK_CONTAINER_REGION=<your cluster's region>',

         'CLOUDSDK_CONTAINER_CLUSTER=<your cluster name>',
     ]

