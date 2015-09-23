/* This code was written by Herve Jegou. Contact: herve.jegou@inria.fr  */
/* Last change: June 1st, 2010                                          */
/* This software is governed by the CeCILL license under French law and */
/* abiding by the rules of distribution of free software.               */
/* See http://www.cecill.info/licences.en.html                          */

#include <stdio.h>
#include "mex.h"

#define uint8 unsigned char

void mexFunction (int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray*prhs[])

{
  
  int i, j, maxjk, jk;
  float distmp;
  float * D;  /* tabulated distances */
  uint8 * x;    /* vectors */
  float *dis;
  int offset;
  int k,d,n;
  maxjk = d * k;
  if (nrhs != 2 && nrhs != 3) 
    mexErrMsgTxt ("Invalid number of input arguments");
  
  if (nlhs > 1)
    mexErrMsgTxt ("This function output exactly 1 argument");
  
  if (mxGetM (prhs[1]) != d)
      mexErrMsgTxt("Dimension of tabulated distances are not consistent");

  if (mxGetClassID(prhs[0]) != mxSINGLE_CLASS)
    mexErrMsgTxt ("first argument should double precision array"); 

  if (mxGetClassID(prhs[1]) != mxUINT8_CLASS)
    mexErrMsgTxt ("second argument should uint8 type"); 
  
  k = mxGetM (prhs[0]);
  d = mxGetN (prhs[0]);
  n = mxGetN (prhs[1]);
  maxjk = d * k;
  
  D = (float*) mxGetPr (prhs[0]);  /* tabulated distances */
  x = (uint8*) mxGetPr (prhs[1]);    /* vectors */

  /* ouptut: distances */

  plhs[0] = mxCreateNumericMatrix (n, 1, mxSINGLE_CLASS, mxREAL);
  dis = (float*) mxGetPr (plhs[0]);

  /* Defaut: manage matlab starting with 1: arithmetic pointer. 
     Otherwise use explicit offset parameters.              */
  offset = 0; 
  if (nrhs == 3)
    offset = (int) mxGetScalar(prhs[2]);

  D = D - offset; 
  
  for (i = 0 ; i < n ; i++) {
    distmp = 0;
    for (jk = 0 ; jk < maxjk ; jk += k)
      distmp += D[*(x++) + jk];
    dis[i] = distmp;
  }
}
