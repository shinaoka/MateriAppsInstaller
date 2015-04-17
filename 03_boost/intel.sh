#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
PREFIX=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_PATCH_VERSION

$SUDO_TOOL /bin/true
sh $SCRIPT_DIR/setup.sh

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_PATCH_VERSION/tools/build
check sh bootstrap.sh -with-toolset=intel-linux
$SUDO_TOOL ./b2 --prefix=$PREFIX install
$SUDO_TOOL rm -rf tools/build

check cd $BUILD_DIR/boost_$BOOST_VERSION-$BOOST_PATCH_VERSION
for m in mpiicpc mpicxx mpic++ mpiCC; do
  mc=$(which $m 2> /dev/null)
  test -n "$mc" && break
done
echo "using mpi : $mc ;" > user-config.jam
check env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=tagged toolset=intel stage
$SUDO_TOOL env BOOST_BUILD_PATH=. $PREFIX/bin/b2 --prefix=$PREFIX --layout=tagged toolset=intel install

cat << EOF > $BUILD_DIR/boostvars.sh
export BOOST_ROOT=$PREFIX_TOOL/boost/boost-$BOOST_VERSION_DOTTED-$BOOST_PATCH_VERSION
export BOOST_VERSION=$BOOST_VERSION
export BOOST_PATCH_VERSION=$BOOST_PATCH_VERSION
export PATH=\$BOOST_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$BOOST_ROOT/lib:\$LD_LIBRARY_PATH
EOF
BOOSTVARS_SH=$PREFIX_TOOL/boost/boostvars-$BOOST_VERSION_DOTTED-$BOOST_PATCH_VERSION.sh
$SUDO_TOOL rm -f $BOOSTVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/boostvars.sh $BOOSTVARS_SH
