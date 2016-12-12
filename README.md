# Graph Matching

This is a graph matching algorithm implmentation of a graduated assignment algorithm for graph matching using OOP scheme in MATLAB.

To generalize and recognize spatial pattern, a probabilistic parametric model is built. To register a sample ARG or check a test ARG, a graph matching probelm is presetend. However, graph matching is a long-known NP problem, so a lot of algorithms are derived to get an approximated solution in a reasonable time. In this project, we mean to use one of this algorithm to help us handle graph matching problem efficiently.

According to Gold and Rangarajan, a graduated assignment algorithm is developed to solve the problem efficiently and the code here is an attemp to implment and improve their algorithm mentioned in their paper: https://www.cise.ufl.edu/~anand/pdf/pamigm3.pdf

The improved algorithm allows null matching to propagate which in terms improve the precision of matching result while maintain the recall and the additional noise prevent matching to local optimal.

### Test Result

```
No Null Propagation (old algo - red):

Recall: 0.75
Precision: 0.72
F: 0.73
Size: 40
Connected Rate: 0.2
Noise Rate: 0.1
```

```
Null Propagation + Stochastic (new algo - blue):

Recall: 0.98
Precision: 0.92
F: 0.95
Size: 40
Connected Rate: 0.2
Noise Rate: 0.1
```

```
Comparison

round: 100
p_recall: <10^-6
p_precision: <10^-6
p_F: <10^-6
```

![Result]
(https://github.com/WesleyyC/Graph-Matching/blob/master/Dev/Result/result.jpg)

