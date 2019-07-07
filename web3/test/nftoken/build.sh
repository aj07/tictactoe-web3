#!/bin/bash
set -e

PROJNAME=nftoken

# cargo clean
# rm Cargo.lock

CARGO_INCREMENTAL=0 &&
cargo build --release --features generate-api-description --target=wasm32-unknown-unknown --verbose
wasm2wat -o target/$nftoken.wat target/wasm32-unknown-unknown/release/$nftoken.wasm
cat target/$nftoken.wat | sed "s/(import \"env\" \"memory\" (memory (;0;) 2))/(import \"env\" \"memory\" (memory (;0;) 2 16))/" > target/$nftoken-fixed.wat
wat2wasm -o target/$nftoken.wasm target/$nftoken-fixed.wat
wasm-prune --exports call,deploy target/$nftoken.wasm target/$nftoken-pruned.wasm
