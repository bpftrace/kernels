# kernels

This repository holds both infrastructure and assets for bpftrace's CI kernels.

We use a [dummy release][1] as an object store.

## Adding a new kernel

To add a new kernel, update [KERNELS][0] with the upstream tag of the version
you want. Examples:

* `v6.12`
* `v6.12-rc7`

Once the change is checked in, automation will build and upload any kernels not
already present in the [Assets Release][1] to the assets release.

## Doing a local build

Doing a local build is useful for testing an infra or config change. For example:

```sh
$ ./build.sh v6.6
[...]

$ file linux-v6.6.tar.zst
linux-v6.6.tar.zst: Zstandard compressed data (v0.8+), Dictionary ID: None

$ tar --zstd -xvf linux-v6.6.tar.zst
[...]

$ vmtest -k ./assets/bzImage -- uname -r
=> bzImage
===> Booting
===> Setting up VM
===> Running command
6.6.0
```

Note it could take a while to build a kernel.

## Changing already-built kernels

Automation is not yet smart enough to rebuild and reupload existing assets
affected by a config or infra change. If you want to change an already-uploaded
kernel, delete the impacted kernel from the release assets and trigger a new
run.

You can trigger a new run by going to [the workflow page][2] and following
[these docs][3] to trigger a manual run.

[0]: ./KERNELS
[1]: https://github.com/bpftrace/kernels/releases/tag/assets
[2]: https://github.com/bpftrace/kernels/actions/workflows/kernels.yml
[3]: https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow
