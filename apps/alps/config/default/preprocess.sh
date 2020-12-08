#!/bin/sh

rm -rf build
mkdir build
cd build

. $SCRIPT_DIR/../../tools/python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
    -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
    -DPYTHON_INTERPRETER=${MA_PYTHON3} \
    ..
else
  . $SCRIPT_DIR/../../tools/python/find.sh
  if [ ${MA_HAVE_PYTHON2} = "yes" ]; then
    cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
      -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
      -DPYTHON_INTERPRETER=${MA_PYTHON2} \
      ..
  else
    cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
      -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON \
      ..
  fi
fi