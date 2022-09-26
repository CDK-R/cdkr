## General Comments

- This is a resubmission of rcdk-3.7. I have fixed a few NOTES relates to R code quality.
- There is an ERROR on the cloud system related to a difference between the primary dependency of this library, rcdklibs. 
- This package should be co-evaluated with rcdklibs



## Submission
rCDK v 3.7.0

## Test environments
* local OS X install, R 4.2
* win-builder (release)

## R CMD check results

0 errors | 0 warnings | 0 note


## Reverse dependencies

Using the latest rcdklibs (2.8) and this version of rcdk (3.7) I obtained the following
results. 

---

```
✔ DeepPINCS 1.4.0                        ── E: 0     | W: 0     | N: 2
✔ Rcpi 1.32.2                            ── E: 0     | W: 0     | N: 2
✔ RMassBank 3.6.1                        ── E: 0     | W: 4     | N: 4
✔ RxnSim 1.0.3                           ── E: 0     | W: 0     | N: 0
✔ webchem 1.1.3                          ── E: 0     | W: 0     | N: 0
```
 
  
