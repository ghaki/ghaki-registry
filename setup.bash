export GK_PROJECT_IDEPS=( \
  "$(pwd)/../ghaki-app/lib" \
  )
export GK_PROJECT_GO_DIRS=( \
   "bin:${GK_PROJECT_DIR}/scripts" \
   "lib:${GK_PROJECT_DIR}/lib/ghaki/registry" \
  "spec:${GK_PROJECT_DIR}/spec/ghaki/registry" \
)

rvm use '1.9.2@ghaki-registry'
