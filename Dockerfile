FROM openjdk:8
LABEL MAINTAINER Sean

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_HOME="/usr/local/android/sdk" \
    ANDROID_VERSION=28 \
    ANDROID_BUILD_TOOLS_VERSION=28.0.3

# Download Android SDK
RUN mkdir -p "${ANDROID_HOME}" .android \
    && cd "${ANDROID_HOME}" \
    && curl -o sdk.zip ${SDK_URL} \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir -p "/root/.android/" \
    && touch "/root/.android/repositories.cfg" \
    && yes | tools/bin/sdkmanager --licenses

# Use machine cache Android SDK
VOLUME $ANDROID_HOME

# Use machine cache gradle
VOLUME /root/.gradle

# Install Android Build Tools and Libraries
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

RUN mkdir /app
WORKDIR /app

