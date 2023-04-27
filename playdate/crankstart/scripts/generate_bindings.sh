#!/usr/bin/env zsh
set -e
set -x

crankstart_crate_dir="$(cd "$(dirname "$0")/.." >/dev/null 2>&1 && pwd)"
source "$crankstart_crate_dir/scripts/vars.sh" || exit $?

common_params=("$crankstart_crate_dir/crankstart-sys/wrapper.h"
  "--use-core"
  "--ctypes-prefix"         "ctypes"
  "--with-derive-default"
  "--with-derive-eq"
  "--default-enum-style"    "rust"
  "--allowlist-type"        "PlaydateAPI"
  "--allowlist-type"        "PDSystemEvent"
  "--allowlist-type"        "LCDSolidColor"
  "--allowlist-type"        "LCDColor"
  "--allowlist-type"        "LCDPattern"
  "--allowlist-type"        "PDEventHandler"
  "--allowlist-var"         "LCD_COLUMNS"
  "--allowlist-var"         "LCD_ROWS"
  "--allowlist-var"         "LCD_ROWSIZE"
  "--allowlist-var"         "SEEK_SET"
  "--allowlist-var"         "SEEK_CUR"
  "--allowlist-var"         "SEEK_END"
  "--bitfield-enum"         "FileOptions"
  "--bitfield-enum"         "PDButtons"
)

bindgen $common_params \
  -- \
  -target x86_64 \
  -I"$PLAYDATE_C_API" \
  -DTARGET_EXTENSION > $crankstart_crate_dir/crankstart-sys/src/bindings_x86.rs

bindgen $common_params \
  -- \
  -target aarch64 \
  -I"$PLAYDATE_C_API" \
  -DTARGET_EXTENSION > $crankstart_crate_dir/crankstart-sys/src/bindings_aarch64.rs

bindgen $common_params \
  -- \
  -I"$PLAYDATE_C_API" \
  -I"$(which arm-none-eabi-gcc)/../arm-none-eabi/include" \
  -target thumbv7em-none-eabihf \
  -fshort-enums \
  -DTARGET_EXTENSION > $crankstart_crate_dir/crankstart-sys/src/bindings_playdate.rs
