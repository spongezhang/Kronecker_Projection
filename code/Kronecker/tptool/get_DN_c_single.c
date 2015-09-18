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
 *      DN = AT*B (both A and B are block matrices.)
 * This is a MEX-file for MATLAB.
*/

#include "mex.h"
#include "matrix.h"
#include "string.h"


void matmult_c(float* A, float *B, float *D, mwSize block_data_height,
        mwSize block_data_width, mwSize block_feature_width, mwSize block_number);

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* variable declarations here */
    float *A;       /* input scalar */
    float *B;       /* 1xN input matrix */
    mwSize A_height; /* size of matrix */
    mwSize A_width;  /* size of matrix */
    mwSize B_height; /* size of matrix */
    mwSize B_width;  /* size of matrix */
    mwSize block_number;
    float *D;      /* output matrix */
    
    mwSize block_data_height;
    mwSize block_data_width;
    mwSize block_feature_width;
    
    if(nrhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs",
                          "Two inputs required.");
    }
    
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs",
                          "One output required.");
    }
    /* code here */
    /* get the value of the scalar input  */
    A = (float *)mxGetPr(prhs[0]);
    /* get dimensions of the input matrix */
    A_height = mxGetM(prhs[0]);
    A_width = mxGetN(prhs[0]);
    
    /* get the value of the scalar input  */
    B = (float *)mxGetPr(prhs[1]);
    /* get dimensions of the input matrix */
    B_height = mxGetM(prhs[1]);
    B_width = mxGetN(prhs[1]);
    
    block_number = mxGetScalar(prhs[2]);
    block_data_height = A_width/block_number;
    block_feature_width = B_width/block_number;
    block_data_width = A_height;
    
    /* create the output matrix */
    plhs[0] = mxCreateNumericMatrix(block_data_height,
                block_feature_width,mxSINGLE_CLASS,mxREAL);
    
    /* get a pointer to the real data in the output matrix */
    D = (float *)mxGetPr(plhs[0]);
    /* printf("block_data_height: %d  block_data_width: %d, block_feature_width: %d, block_number: %d \n", block_data_height,
        block_data_width, block_feature_width, block_number);*/
    
    matmult_c(A, B, D, block_data_height,
        block_data_width, block_feature_width, block_number);
}


void matmult_c(float* A, float *B, float *D, mwSize block_data_height,
        mwSize block_data_width, mwSize block_feature_width, mwSize block_number)
{
    int index = 0;
    long i;
    long j;
    long k;
    long l;
    for(i = 0;i<block_data_height*block_feature_width;i++)
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
                    D[j*block_data_height+k] = D[j*block_data_height+k] 
                            + A[i*block_data_width*block_data_height+k*block_data_width+l]
                            * B[i*block_feature_width*block_data_width+j*block_data_width+l];
                }
            }
        }
    }
}
