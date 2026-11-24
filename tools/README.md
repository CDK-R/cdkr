# Preparing the rcdklibs 2.14.1 release

Run commands from the repository root. Use a JDK and set `JAVA_HOME` and
`PATH` for both Java and R; on this machine the JDK is at
`/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home`.
Build and check artifacts live in the ignored `.release/` directory.
Do not install these development dependencies into the global R library.

## Install the pinned dependency and check tools

```sh
mkdir -p .release/lib .release/results
Rscript -e 'remotes::install_github("CDK-R/rcdklibs@bf933d76929ab9a5835881a1a099e27eccfe849a", lib=".release/lib", upgrade="never", dependencies=FALSE)'
Rscript -e 'remotes::install_github("r-lib/revdepcheck", lib=".release/lib", upgrade="never", dependencies=FALSE)'
```

The latter updates an older revdepcheck that fails to load with current gmailr.
Other check dependencies, including `rcmdcheck`, must be available.

## Rebuild the helper JAR

Do not use the bundled CDK 2.2 snapshot for release validation.
Pass the installed 2.14.1 library explicitly:

```sh
ant -f rcdkjar/build.xml \
  -Dcdk.jars="$PWD/.release/lib/rcdklibs/cont" clean jar
```

This updates `rcdk/inst/cont/rcdk.jar`. No Java source changes were necessary
to compile against CDK 2.14.1. The build uses `--release 8` to enforce Java 8
bytecode and standard-library API compatibility on modern JDKs (use JDK 17
for release builds). A successful build does not replace runtime testing
on Java 8.

If Ant is not installed, its Maven Central `ant` and `ant-launcher` 1.10.15
JARs can be placed in `.release/`, then use
`java -cp .release/ant.jar:.release/ant-launcher.jar org.apache.tools.ant.Main`
in place of `ant`. This is the invocation used for the local rebuild.

## Package and reverse-dependency checks

```sh
R_LIBS_USER="$PWD/.release/lib" Rscript tools/check-release.R \
  > .release/results/release-check.log 2>&1
```

The script checks a fresh staged copy with `R CMD check --no-manual`. Add
`--revdeps` to the Rscript invocation to also run reverse-dependency checks,
only after the package check has no errors or warnings. It then uses
revdepcheck to compare the CRAN baseline with the candidate across CRAN and
the Bioconductor repositories selected for the running R version. It includes
reverse Depends, Imports, Suggests, and LinkingTo, with a 30-minute timeout
per check and two workers. This is not a check of every historical
Bioconductor release or every operating system.

The staged copy adds a pinned `rcdklibs` GitHub remote solely so revdepcheck
can install the unreleased dependency in its candidate library. The package
intended for CRAN does not acquire that remote.

Results:

- `.release/<run-id>/results/`: package-check output, serialized result, session info.
- `.release/<run-id>/candidate/revdep/`: paired check logs and generated reports.

Each invocation creates a fresh staging directory and database so changes to
package sources and the rebuilt JAR are always included.
Inspect installation failures, timeouts, skipped checks, and library versions
alongside reported regressions; incomplete checks are not passing checks.

Before submission, choose a new rcdk version/date, finish resolving check
results, and wait until rcdklibs 2.14.1 is available on CRAN.
