# ZeroFPR_SVDD
Safety regions research is a well-known task for ML  and the main focus is to avoid false positives, i.e., including in the safe region unsafe points. In this repository, two methods for the research of zero FPR regions are proposed: the first one is based simply on the reduction of the SVDD radius until only safe points are  enclosed in the SVDD shape; the second one instead performs successive iterations of the SVDD on the safe  region until there are no more negative points.

Zero_FPR_exe.m is the example code of the the algorithm, while ZeroFPR_SVDD.m is the code of the main algorithm.

To find out more, refer to {A. Carlevaro and M. Mongelli, "A New SVDD Approach to Reliable and eXplainable AI" in IEEE Intelligent Systems, vol. , no. 01, pp. 1-1, 5555.
doi: 10.1109/MIS.2021.3123669, keywords: {safety;kernel;intelligent systems;support vector machines;training;optimization;task analysis}, url: https://doi.ieeecomputersociety.org/10.1109/MIS.2021.3123669 }

Author ORCID: https://orcid.org/0000-0002-7206-5511
