/*
 * kronmult_c.c - example in MATLAB External Interfaces
 *
 * Multiplies an input scalar (multiplier) 
 * times a 1xN matrix (inMatrix)
 * and outputs a 1xN matrix (outMatrix)
 *
 * The calling syntax is:
 *
 *		outMatrix = array_product(multiplier, inMatrix)
 *      DN = A*B (both A and B are block matrices.)
 * This is a MEX-file for MATLAB.
*/

#include "mex.h"
#include "matrix.h"
#include "string.h"


void matmult_c(double* A, double *B, double *D, mwSize block_data_height,
        mwSize block_data_width, mwSize block_feature_width, mwSize block_number);

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* code here */
    double *A;       /* input scalar */
    double *B;       /* 1xN input matrix */
    mwSize A_height; /* size of matrix */
    mwSize A_width;  /* size of matrix */
    mwSize B_height; /* size of matrix */
    mwSize B_width;  /* size of matrix */
    mwSize block_number;
    double *D;      /* output matrix */
    
    mwSize block_data_height;
    mwSize block_data_width;
    mwSize block_feature_width;
    
    /* variable declarations here */
    if(nrhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs",
                          "Two inputs required.");
    }
    
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs",
                          "One output required.");
    }
    

    
    /* get the value of the scalar input  */
    A = mxGetPr(prhs[0]);
    /* get dimensions of the input matrix */
    A_height = mxGetM(prhs[0]);
    A_width = mxGetN(prhs[0]);
    
    /* get the value of the scalar input  */
    B = mxGetPr(prhs[1]);
    /* get dimensions of the input matrix */
    B_height = mxGetM(prhs[1]);
    B_width = mxGetN(prhs[1]);
    
    block_number = mxGetScalar(prhs[2]);
    block_data_height = A_width;
    block_feature_width = B_width;
    block_data_width = A_height/block_number;
    
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(block_data_height,
                block_feature_width*block_number,mxREAL);
    
    /* get a pointer to the real data in the output matrix */
    D = mxGetPr(plhs[0]);
    /*printf("block_data_height: %d  block_data_width: %d, block_feature_width: %d, block_number: %d \n", block_data_height,
        block_data_width, block_feature_width, block_number);*/
    
    matmult_c(A, B, D, block_data_height,
        block_data_width, block_feature_width, block_number);
}


void matmult_c(double* A, double *B, double *D, mwSize block_data_height,
        mwSize block_data_width, mwSize block_feature_width, mwSize block_number)
{
    int index = 0;
    int i;
    int j;
    int k;
    int l;
    for(i = 0;i<block_data_height*block_feature_width*block_number;i++)
    {
        D[i] = 0;
    }
    
    for (i = 0; i<block_number;i++)
    {
        for(j = 0;j<block_feature_width;j++)
        {
            for(k = 0;k<block_data_height;k++)
            {
                for(l = 0;l<block_data_width;l++)
                {
                    D[i*block_data_height*block_feature_width+j*block_data_height+k] =
                            D[i*block_data_height*block_feature_width + j*block_data_height+k]
                            + A[i*block_data_width+k*block_data_width*block_number+l]
                            * B[j*block_data_width+l];
                }
            }
        }
    }
}