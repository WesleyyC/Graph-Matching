# Graph Matching

This is a graph matching algorithm implmentation of a graduated assignment algorithm for graph matching using OOP scheme in MATLAB.

To generalize and recognize spatial pattern, a probabilistic parametric model is built. To register a sample ARG or check a test ARG, a graph matching probelm is presetend. However, graph matching is a long-known NP problem, so a lot of algorithms are derived to get an approximated solution in a reasonable time. In this project, we mean to use one of this algorithm to help us handle graph matching problem efficiently.

According to Gold and Rangarajan, a graduated assignment algorithm is developed to solve the problem efficiently and the code here is an attemp to implment and improve their algorithm mentioned in their paper: https://www.cise.ufl.edu/~anand/pdf/pamigm3.pdf

The improved algorithm allows null matching to propagate which in terms improve the recall of matching result.

### Test Result

```
No Null Propagation:

Final Recall: 0.93824
Final Precision: 0.81815
Size: 30
Connected Rate: 0.2
Noise Rate: 0.2
Elapsed time is 192.448153 seconds.
```

```
Null Propagation:

Final Recall: 0.94936
Final Precision: 0.88015
Size: 30
Connected Rate: 0.2
Noise Rate: 0.2
Elapsed time is 300.107886 seconds.
```
