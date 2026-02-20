# This file is sourced in the middle of tasks.sh, after environment variables
# are setup and before commands are run. It does not get updated by the update
# task so you can use it to plug-in arbitrary extra logic that is specific to
# your local needs and should not be part of the upstream tasks.sh. For example:

# TODO Get all this from an .env file so that working from terminal or this in
# in VS code is synced and uses the same root information

TDX_KCONF_DIR=/home/ernest/tdx/linux/linux-toradex-kconfig
KBUILD_OUTPUT=/home/ernest/tdx/linux/linux-toradex-builds/default

MAKE_VARS="KBUILD_OUTPUT=${KBUILD_OUTPUT} LLVM=1 LLVM_IAS=1 CC='ccache clang'"
SILENT_BUILD_FLAG=""

## Cross-compile/debug/emulate for arm64
TARGET_ARCH=arm64

## Change PATH to use a different QEMU binary
# export PATH=$HOME/qemu/bin/:$PATH

## Generate objects in a subdirectory
# MAKE="$MAKE O=.vscode/build-$TARGET_ARCH/"

#
## Fully override any task by defining task_<command>().
## Hyphens in command names become underscores in function names.
## Example: override "defconfig"
# task_defconfig() {
#   if [ ! -f "${WORKSPACE_DIR}/.config" ]; then
#     eval ${MAKE} ARCH=${TARGET_ARCH} tinyconfig
#     scripts/config --enable DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
#     eval ${MAKE} ARCH=${TARGET_ARCH} olddefconfig
#   fi
# }

task_defconfig() {
  if [ ! -f "${KBUILD_OUTPUT}/.config" ]; then
    CMD="${MAKE_VARS} ARCH=${TARGET_ARCH} scripts/kconfig/merge_config.sh -O ${KBUILD_OUTPUT} \
         ${TDX_KCONF_DIR}/cfg/base/base.cfg \
         ${TDX_KCONF_DIR}/cfg/${TARGET_ARCH}/${TARGET_ARCH}.cfg"
    echo ${CMD}
    eval ${CMD}
  fi
}

## Enable some random kernel CONFIG by default as part of the .config generation
# if [ $COMMAND = "defconfig" ]; then
#   trap "scripts/config -e BPF_SYSCALL" EXIT
# fi

## Run make olddefconfig before a build (a bit slow)
# if [ $COMMAND = "build" ]; then
#   eval ${MAKE} ARCH=${TARGET_ARCH} olddefconfig
# fi

## Make the build verbose
# SILENT_BUILD_FLAG=""

## Disable the build spinner
# SPINNER=0

## Don't clear the screen before each task
# unset CLEAR

## Boot without systemd (use the /sbin/init-minimal shell script instead)
# SKIP_SYSTEMD=1

## Add some args to the kernel cmdline when using the "start" task
## E.g.: Boot straight into a syzbot reproducer
# KERNEL_CMDLINE_EXTRA=init=/root/syzbot-repro

## Only fuzz the /dev/ptmx ioctls
# SYZ_MANAGER_CFG_EXTRA='"enable_syscalls": [ "openat$ptmx", "ioctl$*" ],'

## Fuzz as an unprivileged user
# SYZ_MANAGER_CFG_EXTRA='"sandbox": "setuid",'
