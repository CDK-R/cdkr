# Reverse-dependency analysis: rcdklibs 2.14.1

## Result

All 12 direct reverse dependencies completed paired checks. Ten have no new
problems; FastRet and RxnSim introduce one check error each. No installation
failures or timeouts were reported. This is not yet release clearance.

These are the initial run's results, before the hydrogen-hashing fix.
With that fix, a subsequent `R CMD check --no-manual` of rcdk and
`R CMD check --no-manual --no-build-vignettes` of unpatched RxnSim 1.0.4
both report zero errors, warnings, and notes on the same local JDK 27.
The full 12-package matrix has not been repeated after this change.
FastRet remains a downstream coordination item; see
`downstream/FastRet-cache-design.md`.

## Scope and environment

- Run date: 2026-11-24.
- macOS ARM64, R 4.5.2, Homebrew OpenJDK 27.
- Candidate: current rcdk 3.9.0 sources with rebuilt Java 8-targeted helper JAR.
- Candidate rcdklibs: 2.14.1, GitHub commit
  `bf933d76929ab9a5835881a1a099e27eccfe849a`.
- Baseline: CRAN rcdk 3.8.2; per-check baseline dependency library contains
  rcdklibs 2.9. Candidate library precedes that library and supplies 2.14.1.
- Both sides use rJava 1.0-11.
- CRAN plus Bioconductor 3.22 repositories associated with R 4.5.2.
- Direct reverse Depends, Imports, Suggests, LinkingTo. Package selection was
  independently checked against `tools::package_dependencies`.
- Two workers, 30-minute timeout per check.
- Own package: `R CMD check --no-manual`, zero errors, warnings, or notes.
- Revdeps: `R CMD check --no-manual --no-build-vignettes`.

This does not cover transitive-only reverse dependencies, other Bioconductor
releases, other operating systems, or Java 8/17 runtime validation.
Individual package tests may skip optional/CRAN-disabled work.

## Package results

| Package | Version | Repository | New problems | Existing notes |
| --- | --- | --- | --- | --- |
| admetshiny | 1.0.1 | CRAN | None | 0 |
| DeepPINCS | 1.18.0 | Bioconductor | None | 1 |
| FastRet | 1.5.2 | CRAN | Test error | 0 |
| fioRa | 0.3.7 | CRAN | None | 0 |
| InterpretMSSpectrum | 1.5.3 | CRAN | None | 0 |
| LipinskiFilters | 1.0.1 | CRAN | None | 1 |
| pubchem.bio | 1.0.5 | CRAN | None | 0 |
| REFT | 0.1.4 | CRAN | None | 1 |
| RMassBank | 3.20.0 | Bioconductor | None | 2 |
| rQSAR | 1.0.0 | CRAN | None | 0 |
| RxnSim | 1.0.4 | CRAN | Example error | 0 |
| webchem | 2.0.0 | CRAN | None | 0 |

## FastRet: descriptor fixture/cache mismatch

`test-getCDs.R:22` compares cached descriptor values with freshly calculated
ones. Subsequent diagnosis isolated the new numerical changes in the five
fixture molecules to MW and ATSm1 through ATSm5. The cached geomShape NA
versus fresh NaN difference exists on both stacks, not just the candidate.
Descriptor counts and ordering are unchanged. The test summary is 146 passes, one
failure, one warning, five skips. The failure is absent with the baseline.

Upstream mass descriptors switched from getNaturalMass to Isotopes.average.
Do not simply loosen the
downstream assertion without identifying the changed descriptors and checking
the intended numerical and missing-value semantics.

## RxnSim: reaction-similarity runtime failure

A documented `rs.compute(rct1, rct2, verbose = TRUE)` example fails with:

```
Error in if (straight >= cross) { :
  missing value where TRUE/FALSE needed
```

The root cause was CDK's changed default excluding explicit hydrogens from
path fingerprints. `[H+]` therefore became an empty fingerprint, and
empty/empty Tanimoto returned NaN. Explicitly setting
setHashExplicitHydrogens(true) in rcdk restores the historical hydrogen
inclusion for standard, extended, graph, and hybridization fingerprints.
The unpatched downstream package now passes its check; no blanket NA-to-zero
substitution or downstream RxnSim patch is needed for this failure.

## Local evidence

The full run is preserved under:

```
.release/20261124-085613-b76c38ea2457/
  results/
  candidate/revdep/README.md
  candidate/revdep/problems.md
  candidate/revdep/failures.md
  candidate/revdep/checks.noindex/
```

Repository and package inventories are in
`.release/results/revdep-repositories.csv` and `revdep-inventory.csv`.
Artifacts are ignored local files, not included in the source package.
