set -u

rm -rf build
mkdir build
cd build

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_C_COMPILER=`which icc` \
  -DCMAKE_Fortran_COMPILER=`which ifort` \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG -DHAVE_SSE2" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS_RELEASE="-O3 -DNDEBUG -DHAVE_SSE2" \
  -DUSE_SCALAPACK=ON \
  -DSCALAPACK_LIBRARIES="-mkl=cluster" \
  ../