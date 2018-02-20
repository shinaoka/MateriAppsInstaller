
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. ${PREFIX_TOOL}/env.sh
LOG=${BUILD_DIR}/HPhi-${HPHI_VERSION}-${HPHI_MA_REVISION}.log

PREFIX="${PREFIX_APPS}/HPhi/HPhi-${HPHI_VERSION}-${HPHI_MA_REVISION}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh ${SCRIPT_DIR}/setup.sh
rm -rf $LOG
cd ${BUILD_DIR}/HPhi-${HPHI_VERSION}
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check rm -rf build
check mkdir build
check cd build
check cmake -DCONFIG=fujitsu -DCMAKE_INSTALL_PREFIX=${PREFIX} ../
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
check make install | tee -a $LOG
echo "cp -r samples ${PREFIX}" | tee -a $LOG
cp -r ../samples ${PREFIX}
echo "mkdir -p ${PREFIX}/doc" | tee -a $LOG
mkdir -p $PREFIX/doc | tee -a $LOG
echo "cp ../userguide_jp.pdf ${PREFIX}/doc" | tee -a $LOG
cp ../userguide_jp.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "cp ../userguide_en.pdf ${PREFIX}/doc" | tee -a $LOG
cp ../userguide_en.pdf ${PREFIX}/doc/ | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > ${BUILD_DIR}/HPhivars.sh
. ${PREFIX_TOOL}/env.sh
export HPHI_ROOT=$PREFIX
export PATH=\${HPHI_ROOT}/bin:\$PATH
EOF
HPHIVARS_SH=${PREFIX_APPS}/HPhi/HPhivars-${HPHI_VERSION}-${HPHI_MA_REVISION}.sh
rm -f $HPHIVARS_SH
cp -f ${BUILD_DIR}/HPhivars.sh $HPHIVARS_SH
cp -f $LOG ${PREFIX_APPS}/HPhi/

