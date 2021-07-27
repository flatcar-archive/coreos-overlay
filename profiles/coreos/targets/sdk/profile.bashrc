if [[ ${CATEGORY}/${PN} == sys-devel/gcc && ${EBUILD_PHASE} == "configure" ]]; then
  export EXTRA_ECONF="$EXTRA_ECONF --disable-bootstrap"
  export GCC_MAKE_TARGET="all"
fi
