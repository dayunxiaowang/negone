# NegOne initial fork validation

Validation date: 2026-10-14. This records the initial naming change from NoirVisor's Rust baseline, not a hardware compatibility certification.

## Environment

- Windows x64 build host.
- Rust `1.101.0-nightly (e9bbadf68 2026-10-12)`, nightly channel dated 2026-10-13.
- Windows MSVC and UEFI Rust targets installed.
- AMD/Xilinx LLVM 16.0.6, NASM 2.16.01, MSVC 14.44, Windows SDK/WDK 26100.
- Toolchain downloads, Cargo cache, and compilation temporary files placed on E:; machine-specific setup is outside the repository.

## Passed checks

- `python make.py test`: 4 scheduler tests and 2 handle-table tests passed.
- `python make.py check`: Clippy and format checks passed with no warnings after adding the inherited UEFI shutdown function's safety documentation and a spin-loop hint.
- Dependency audit: 36 dependencies checked against RustSec snapshot `6aed84668c23d7f535077a9fe918bf1fa0f6a5bc`, dated 2026-10-13, with warnings denied. The database snapshot was obtained through GitHub's archive API because Git transport failed. A temporary local audit configuration selected that snapshot for `make.py check`; it was removed after validation.
- Additional Windows user-mode client check: `cargo clippy --target x86_64-pc-windows-msvc --package nvcvm --features user -- -D warnings` passed.
- Additional UEFI check: `cargo clippy --target x86_64-unknown-uefi --package negone-core --package loadefi --package cvsched -- -D warnings` passed.
- `cargo fmt`, `cargo fmt --check`, and `git diff --check` completed successfully.
- License text, test-signing fixture, public C exports, numeric protocol constants, and dependency versions were checked against the upstream baseline. The renamed CPUID vendor identity is exactly 12 bytes.

## Build results and remaining limits

| Artifact or stage | Result |
|---|---|
| `NegOne.efi` | Compiled and linked as an x64 EFI runtime driver |
| `loadefi.efi` / `bootx64.efi` | Loader compiled and linked as an x64 EFI application |
| `cvsched.efi` | Compiled and linked as an x64 EFI boot-service driver |
| `NegOneConfig.bin` | Generated |
| `NegOne-unsigned.sys` | Compiled and linked as an x64 native driver; version resources verified as NegOne |
| Raw UEFI disk image | Not generated: GNU mtools is not installed on the build host |
| VHDX / VMDK conversion | Not run successfully: `qemu-img` is not installed on the build host |
| Windows test signing | Not performed: `osslsigncode` is not installed |
| QEMU / real Windows boot and driver loading | Not performed; runtime testing is assigned to a separate Linux/QEMU machine or target hardware |

Both required build commands were invoked. `python make.py /target uefi` completed binary compilation/linking but failed the image pipeline. `python make.py /target windows` compiled Rust successfully, but the bundled LLVM 16 `llvm-lib` did not accept the inherited `/def` invocation. For the Windows link verification, MSVC `lib.exe` generated the import library and the original `lld-link` command then produced the unsigned driver. The version-controlled pipeline was not changed to hide these environment/tool compatibility limitations.

The inherited check/test Python wrappers do not reliably propagate subprocess failure codes. The validation above checked their output and used separate strict checks where applicable.
