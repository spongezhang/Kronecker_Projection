Kronecker Production Matrix for Approximate Nearest Neighbour Search 

Please cite our ICCV 2015 paper if you use the code in research.

@inproceedings{xu2015FastOrthogonalProjection,
  title={Fast Orthogonal Projection Based on Kronecker Product},
  author={Zhang, Xu and Yu, Felix X. and Guo, Ruiqi and Kumar, Sanjiv and Wang, Shengjin and Chang, Shih-Fu},
  year={2015},
  booktitle={International Conference on Computer Vision}
}

The code is tested on MacOSX 10.10 and Ubuntu 14.10 with Matlab 2014. We have contained the compiled mex file for both platforms. If it does not work, please run compile_all.m to compile all the mex c code.

/*For Windows user, we are so sorry that all the quantization methods cannot run under Windows. However all the binary embedding methods should work.*/

example_fix_bits_ImageNet256.m is an example of how to use the code. 

We would like to thank 

Felix Xinnan Yu, www.felixyu.org/cbe.html

YunChao Gong, http://www.unc.edu/~yunchao/

Mohammad Norouzi, http://www.cs.toronto.edu/~norouzi/

and Hervé Jégou, http://people.rennes.inria.fr/Herve.Jegou/

for offering the implementations of their methods. The baseline methods can also be downloaded at their websites.
  
