Run Helm 3 from Google CloudBuild
=================================

Based roughly on `cloud-builders-community/helm`__, but dramatically
simplified and based on the lightweight
``gcr.io/google.com/cloudsdktool/cloud-sdk:alpine`` image (~100Mb, versus
~700Mb for ``gcr.io/cloud-builders/gcloud``).

__ https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/helm

Usage:

1. Ensure the CloudBuild service account has "Kubernetes Engine Admin" (visit
   https://console.cloud.google.com/iam-admin/iam?project=YOUR_PROJECT, edit
   the ``cloudbuild.gserviceaccount.com`` service account, add the "Kubernetes
   Engine Admin" role)

2. Run Helm from your ``cloudbuild.yaml`` file (if you created your own docker
   image in step 1)

 .. code-block:: text

   # Create helm docker image if it is missing. This should only need to run once for a project.
   - name: 'gcr.io/cloud-builders/docker'
    entrypoint: 'bash'
    args:
      - '-c'
      - >-
        docker pull gcr.io/${PROJECT_ID}/helm:v3.10.3 || (
        docker build -t gcr.io/${PROJECT_ID}/helm:v3.10.3 https://github.com/Sheertex/gcp-cloudbuld-helm3.git#v3.10.3 &&
        docker push gcr.io/${PROJECT_ID}/helm:v3.10.3)


