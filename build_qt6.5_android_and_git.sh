#!/bin/bash

set -e

apt-get update
apt-get install -y protobuf-compiler

cd /opt
tar xvfp /root/export/Qt-amd64-$1.tar.xz

cd
git clone https://github.com/KDAB/android_openssl
cd android_openssl
git checkout f5d857ef1d437595f7c3ab0d06e61beae7ca8b99

cd
git clone --verbose --depth 1 --branch v$1 https://code.qt.io/qt/qt5.git qt6
cd qt6
perl init-repository
cd ..
mkdir build

cd build

rm -rf *
../qt6/configure -release -nomake examples -nomake tests -platform android-clang -prefix /opt/Qt-android-$1/android_arm64_v8a -android-ndk $ANDROID_NDK_ROOT -android-sdk $ANDROID_SDK_ROOT -qt-host-path /opt/Qt-amd64-$1 -android-abis arm64-v8a -- -DOPENSSL_ROOT_DIR=/root/android_openssl/ssl_3 -DOPENSSL_CRYPTO_LIBRARY=/root/android_openssl/ssl_3
cmake --build . --parallel $(($(nproc)+4))
cmake --install .
cp config.summary /opt/Qt-android-$1/android_arm64_v8a

cd /opt
tar cvfpJ /root/export/Qt-android-$1.tar.xz Qt-android-$1