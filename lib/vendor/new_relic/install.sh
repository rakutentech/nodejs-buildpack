#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_PATH/../../json.sh
BUILD_DIR=$1

if [ ! -z "${VCAP_SERVICES-}" ]; then
  VCAP_SERVICES_NEW_RELIC_LICENSE_KEY=$(echo $VCAP_SERVICES | $JQ --raw-output .newrelic[0].credentials.licenseKey)
  VCAP_APPLICATION_GUID=$(echo $VCAP_APPLICATION | $JQ --raw-output .application_id)
  VCAP_APPLICATION_NAME=$(echo $VCAP_APPLICATION | $JQ --raw-output .application_name)

  if [ ! -z "${VCAP_SERVICES_NEW_RELIC_LICENSE_KEY-}" ];
  then
    mkdir -p $BUILD_DIR/.profile.d
    SETUP_NEW_RELIC=$BUILD_DIR/.profile.d/new-relic-setup.sh

    if [ -z "${NEW_RELIC_LICENSE_KEY-}" ]; then
      echo "export NEW_RELIC_LICENSE_KEY=$VCAP_SERVICES_NEW_RELIC_LICENSE_KEY" >> $SETUP_NEW_RELIC
    fi
    if [ -z "${NEW_RELIC_APP_NAME-}" ]; then
      printf "export NEW_RELIC_APP_NAME=$VCAP_APPLICATION_NAME" >> $SETUP_NEW_RELIC
      printf "_" >> $SETUP_NEW_RELIC
      echo $VCAP_APPLICATION_GUID >> $SETUP_NEW_RELIC
    fi
  fi
fi
