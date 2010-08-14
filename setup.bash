############################################################################
export GAK_WORK_DIR=$(pwd)
export GAK_WORK_SETUP=$(pwd)/../SETUP
. ${GAK_WORK_SETUP}/startup.bash

export GAK_WORK_IDEPS=( \
  $(pwd)/../ghaki_common/lib \
  )
export GAK_WORK_GO_DIRS=( \
  lib:${GAK_WORK_DIR}/lib/ghaki/registry \
)

. ${GAK_WORK_SETUP}/finish.bash
############################################################################
