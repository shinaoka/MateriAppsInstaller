#!/bin/sh

. $SCRIPT_DIR/../../scripts/util.sh

. $SCRIPT_DIR/../../tools/python3/find.sh
if [ ${MA_HAVE_PYTHON3} = "yes" ]; then
  check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_Fortran_COMPILER=gfortran \
    -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
    -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
    -DPYTHON_INTERPRETER=${MA_PYTHON3} \
    .. 2>&1 | tee -a $LOG
else
  . $SCRIPT_DIR/../../tools/python/find.sh
  if [ ${MA_HAVE_PYTHON2} = "yes" ]; then
    check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_Fortran_COMPILER=gfortran \
      -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
      -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
      -DPYTHON_INTERPRETER=${MA_PYTHON2} \
      .. 2>&1 | tee -a $LOG
  else
    check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_Fortran_COMPILER=gfortran \
      -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
      -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON \
      .. 2>&1 | tee -a $LOG
  fi
fi
