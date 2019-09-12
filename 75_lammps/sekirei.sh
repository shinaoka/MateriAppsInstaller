#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/lammps-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.log
rm -rf $LOG

PREFIX="$PREFIX_APPS/lammps/lammps-$LAMMPS_VERSION-$LAMMPS_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

source /etc/profile.d/modules.sh
module unload intel
module load intel/16.0.8.266
module list

sh $SCRIPT_DIR/setup.sh

cd $BUILD_DIR/lammps-$LAMMPS_VERSION
mkdir -p build
cd build
start_info | tee -a $LOG

echo "[cmake]" | tee -a $LOG
check cmake -C../cmake/presets/all_on.cmake -C../cmake/presets/nolib.cmake \
      -DBUILD_LIB=yes -DBUILD_SHARED_LIBS=yes \
      -DPKG_GPU=yes -DGPU_API=cuda -DCUDA_CUDA_LIBRARY=$CUDA_PATH/lib64/stubs/libcuda.so \
      -DPKG_USER-CGDNA=no \
      -DPC_FFTW3_INCLUDE_DIRS=$FFTW_ROOT/include -DPC_FFTW3_LIBRARY_DIRS=$FFTW_ROOT/lib \
      -DCMAKE_CXX_FLAGS="-DLMP_INTEL_NO_TBB" \
      -DCMAKE_BUILD_TYPE="Release" -DCMAKE_C_COMPILER=icc -DCMAKE_CXX_COMPILER=icpc -DCMAKE_INSTALL_PREFIX=$PREFIX \
      ../cmake 2>&1 | tee -a $LOG

echo "[make & make install]" | tee -a $LOG
check make install 2>&1 | tee -a $LOG
check cp -rp $BUILD_DIR/lammps-$LAMMPS_VERSION/examples $PREFIX/share/lammps/ 2>&1 | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/lammpsvars.sh
# lammps $(basename $0 .sh) $LAMMPS_VERSION $LAMMPS_MA_REVISION $(date +%Y%m%d-%H%M%S)
test -z "\$MA_ROOT_TOOL" && . $PREFIX_TOOL/env.sh
export LAMMPS_ROOT=$PREFIX
export LAMMPS_VERSION=$LAMMPS_VERSION
export LAMMPS_MA_REVISION=$LAMMPS_MA_REVISION
export PATH=\$LAMMPS_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$LAMMPS_ROOT/lib:\$LD_LIBRARY_PATH
export LAMMPS_POTENTIALS=\$LAMMPS_ROOT/share/lammps/potentials
EOF
LAMMPSVARS_SH=$PREFIX_APPS/lammps/lammpsvars-$LAMMPS_VERSION-$LAMMPS_MA_REVISION.sh
rm -f $LAMMPSVARS_SH
cp -f $BUILD_DIR/lammpsvars.sh $LAMMPSVARS_SH
rm -f $BUILD_DIR/lammpsvars.sh
cp -f $LOG $PREFIX_APPS/lammps/

source /etc/profile.d/modules.sh
module unload intel
module load intel/18.0.5.274
module list
