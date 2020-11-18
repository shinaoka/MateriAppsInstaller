set -u

rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_CXX_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG" \
  -DCONFIG=gcc \
  ../ 2>&1 | tee -a $LOG
