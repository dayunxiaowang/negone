# Contributing to NegOne

NegOne is maintained at [dayunxiaowang/negone](https://github.com/dayunxiaowang/negone). Submit pull requests against `rust-dev` in this repository.

Read [AGENTS.md](AGENTS.md), [the Rust guidelines](doc/rust.md), and [the fork compatibility notes](doc/fork.md) before changing code.

## Development and validation

- Keep each change focused and explain its behavior and validation.
- Preserve upstream copyright and license notices.
- Keep dependent crate versions and `Cargo.lock` consistent; do not run `cargo update` as part of unrelated work.
- Run `python make.py check`, both UEFI and Windows builds, and `python make.py test` when evaluating Rust changes, then run `cargo fmt`.
- Report failed or unavailable checks explicitly. The inherited `make.py` check/test actions do not reliably propagate subprocess failures, so inspect their output as well as the script exit code.
- Windows builds may be validated on a separate Linux QEMU machine. State which artifacts and CPU/IOMMU configurations were tested.
- Separate API/ABI changes from product naming changes and document compatibility implications.

## Upstream synchronization

Keep the original repository as the `upstream` remote and this fork as `origin`:

```text
origin    https://github.com/dayunxiaowang/negone.git
upstream  https://github.com/Zero-Tang/NoirVisor.git
```

Track upstream Rust work on `upstream/rust-dev`; upstream `master` is a different development line. Review incoming changes before merging them into NegOne.

## Reports

Use [NegOne issues](https://github.com/dayunxiaowang/negone/issues) for ordinary bugs and proposals. Include the revision, build profile, CPU virtualization backend, and reproduction steps. Use the private reporting channel in [security.md](security.md) for vulnerabilities.

Follow [the code of conduct](code_of_conduct.md). Contributors remain responsible for understanding and reviewing their changes, including changes made with automated assistance.
