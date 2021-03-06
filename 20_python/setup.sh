#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

cd $BUILD_DIR
if [ -d Python-$PYTHON_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/python/Python-$PYTHON_VERSION.tgz ]; then
    check tar zxf $SOURCE_DIR/python/Python-$PYTHON_VERSION.tgz
  else
    check wget $WGET_OPTION http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
    check tar zxf Python-$PYTHON_VERSION.tgz
  fi
fi

cd $BUILD_DIR/Python-$PYTHON_VERSION
if [ -f get-pip.py ]; then :; else
  if [ -f $SOURCE_DIR/python/get-pip.py ]; then
    check cp $SOURCE_DIR/python/get-pip.py .
  else
    check wget $WGET_OPTION https://bootstrap.pypa.io/get-pip.py
  fi
fi

cd $BUILD_DIR/Python-$PYTHON_VERSION
if [ -d numpy-$NUMPY_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/python/numpy-$NUMPY_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/python/numpy-$NUMPY_VERSION.tar.gz
  else
    check wget $WGET_OPTION https://github.com/numpy/numpy/releases/download/v$NUMPY_VERSION/numpy-$NUMPY_VERSION.tar.gz
    check tar zxf numpy-$NUMPY_VERSION.tar.gz
  fi
fi

cd $BUILD_DIR/Python-$PYTHON_VERSION
if [ -d scipy-$SCIPY_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/python/scipy-$SCIPY_VERSION.tar.gz ]; then
    check tar zxf $SOURCE_DIR/python/scipy-$SCIPY_VERSION.tar.gz
  else
    check wget $WGET_OPTION https://github.com/scipy/scipy/releases/download/v$SCIPY_VERSION/scipy-$SCIPY_VERSION.tar.gz
    check tar zxf scipy-$SCIPY_VERSION.tar.gz
  fi
fi
