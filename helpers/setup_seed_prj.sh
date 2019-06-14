#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is derived from the helper scripts of the repository https://github.com/terraform-google-modules/terraform-google-project-factory

set -e
set -u

# Source input variables
. ./setup_seed_prj.env

# Set Locals
SA_ID="$SA_NAME@$SEED_PROJECT.iam.gserviceaccount.com"

# Organization ID
echo "Verifying organization..."
CHECK_ORG_ID="$(gcloud organizations list --format="value(ID)" --filter="$ORG_ID")"

if [[ $CHECK_ORG_ID == "" ]];
then
  echo "The organization id provided does not exist. Exiting."
  exit 1;
fi

 # Seed Project
echo "Verifying project..."
CHECK_SEED_PROJECT="$(gcloud projects list --format="value(projectId)" --filter="$SEED_PROJECT")"

if [[ $CHECK_SEED_PROJECT == "" ]];
then
   echo "The Seed Project does not exist. Creating..."
   gcloud projects create $SEED_PROJECT
else
   echo "The Seed Project exists already. Will not be created."
fi

# Billing account
if [ "x$BILLING_ACCOUNT" != "x"  ]; then
  echo "Verifying billing account..."
  CHECK_BILLING_ACCOUNT="$(gcloud beta billing accounts list --format="value(ACCOUNT_ID)" --filter="$BILLING_ACCOUNT")"

  if [[ $CHECK_BILLING_ACCOUNT == "" ]];
  then
    echo "The billing account does not exist. Exiting."
    exit 1;
  fi
else
  echo "Skipping billing account verification... (parameter not passed)"
fi

 # Seed Service Account creation
echo "Creating Seed Service Account $SA_NAME..."
gcloud iam service-accounts \
    --project "${SEED_PROJECT}" create ${SA_NAME} \
    --display-name ${SA_NAME}

echo "Downloading key to $KEY_FILE..."
gcloud iam service-accounts keys create "${KEY_FILE}" \
    --iam-account "${SA_ID}" \
    --user-output-enabled false

echo "Applying permissions for org $ORG_ID and project $SEED_PROJECT..."
 # Grant roles/resourcemanager.organizationViewer to the Seed Service Account on the organization
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/resourcemanager.organizationViewer" \
  --user-output-enabled false

# Grant roles/resourcemanager.projectCreator to the service account on the organization
echo "Adding role roles/resourcemanager.projectCreator..."
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/resourcemanager.projectCreator" \
  --user-output-enabled false

# Grant roles/billing.user to the service account on the organization
echo "Adding role roles/billing.user..."
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/billing.user" \
  --user-output-enabled false

# Grant roles/compute.networkAdmin to the service account on the organization
echo "Adding role roles/compute.networkAdmin..."
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/compute.networkAdmin" \
  --user-output-enabled false

# Grant roles/iam.serviceAccountAdmin to the service account on the organization
echo "Adding role roles/iam.serviceAccountAdmin..."
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/iam.serviceAccountAdmin" \
  --user-output-enabled false

# Grant roles/compute.instanceAdmin.v1 to the service account on the project
echo "Adding role roles/compute.instanceAdmin.v1..."
gcloud projects add-iam-policy-binding "${SEED_PROJECT}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/compute.instanceAdmin.v1" \
  --user-output-enabled false

# Grant roles/storage.admin to the service account on the project
echo "Adding role roles/storage.admin..."
gcloud projects add-iam-policy-binding "${SEED_PROJECT}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/storage.admin" \
  --user-output-enabled false

# Grant roles/resourcemanager.projectIamAdmin to the Seed Service Account on the Seed Project
echo "Adding role roles/resourcemanager.projectIamAdmin..."
gcloud projects add-iam-policy-binding "${SEED_PROJECT}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/resourcemanager.projectIamAdmin" \
  --user-output-enabled false

# Enable required API's
echo "Enabling APIs..."
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  --project "${SEED_PROJECT}"

gcloud services enable \
  cloudbilling.googleapis.com \
  --project "${SEED_PROJECT}"

gcloud services enable \
  iam.googleapis.com \
  --project "${SEED_PROJECT}"

gcloud services enable \
  admin.googleapis.com \
  --project "${SEED_PROJECT}"

gcloud services enable \
  sourcerepo.googleapis.com \
  --project "${SEED_PROJECT}"

gcloud services enable \
  storage-api.googleapis.com \
  --project "${SEED_PROJECT}"

# enable the billing account
if [[ ${CHECK_BILLING_ACCOUNT:-} != "" ]]; then
  echo "Enabling the billing account..."
  gcloud beta billing accounts get-iam-policy "$BILLING_ACCOUNT" > policy-tmp-$$.yml
  unamestr=$(uname)
  if [ "$unamestr" = 'Darwin' ] || [ "$unamestr" = 'Linux' ]; then
    sed -i.bak -e "/^etag:.*/i \\
- members:\\
\ \ - serviceAccount:${SA_ID}\\
\ \ role: roles/billing.user" policy-tmp-$$.yml && rm policy-tmp-$$.yml.bak
    gcloud beta billing accounts set-iam-policy "$BILLING_ACCOUNT" policy-tmp-$$.yml
  else
    echo "Could not set roles/billing.user on service account $SERVICE_ACCOUNT.\
    Please perform this manually."
  fi
  rm -f policy-tmp-$$.yml
fi


# Create a GCS Bucket for Terraform State
if [ "x$TF_BUCKET_NAME" != "x"  ]; then
  echo "Creating GCS Bucket for Terraform state"
  gsutil mb "gs://${TF_BUCKET_NAME}"

else
  echo "TF_BUCKET_NAME variable not set in input variables file. Exiting..."
  exit 1;
fi

# Create a source repository to store website code and chef cookbooks
if [ "x$CODE_REPO_NAME" != "x"  ]; then
  echo "Creating GSR Repo for source code management..."
  gcloud source repos create "${CODE_REPO_NAME}" --project "${SEED_PROJECT}"

else
  echo "CODE_REPO_NAME variable not set in input variables file. Exiting..."
  exit 1;
fi


echo "All done."