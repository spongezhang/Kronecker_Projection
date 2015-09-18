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
 *
 * This is a MEX-file for MATLAB.
*/

#include "mex.h"
#include "matrix.h"
#include "string.h"

void show_matrix(double *mat, int col, int width);

void kronmult_c(double** Q, double *X, double *Y,
        mwSize sample_dim, mwSize sample_number,
        int* QSize, int QNumber);

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* variable declarations here */
    double **Q;      /* input scalar */
    double *X;       /* 1xN input matrix */
    mwSize sample_dim;           /* size of matrix */
    mwSize sample_number;        /* size of matrix */
    mwSize feature_dim = 1;
    double *Y;      /* output matrix */
    int Q_matrix_number = 0;
    int *Q_size;
    
    /* get the value of the scalar input  */
    const mwSize *dims;
    mwIndex jcell;
    mxArray *ptr;
    
    if(nrhs!=2) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs",
                          "Two inputs required.");
    }
    
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs",
                          "One output required.");
    }
    
    /* code here */
    dims = mxGetDimensions(prhs[0]);
    
    Q_matrix_number = (int) ((dims[0]>dims[1])?dims[0]:dims[1]);
    Q = (double **) malloc(Q_matrix_number*sizeof(double*));
    Q_size = (int *) malloc(Q_matrix_number*2*sizeof(int));
    
    for (jcell=0; jcell<dims[0]; jcell++){
        Q[(int)jcell] = mxGetPr(mxGetCell(prhs[0], jcell));
        Q_size[2*((int)jcell)] = mxGetM(mxGetCell(prhs[0], jcell));
        Q_size[2*((int)jcell)+1] = mxGetN(mxGetCell(prhs[0], jcell));
        feature_dim = feature_dim*Q_size[2*((int)jcell)];
        /*printf("%d, %d\n",Q_size[2*((int)jcell)],Q_size[2*((int)jcell)+1]);*/
    }
    
    /* create a pointer to the real data in the input matrix  */
    X = mxGetPr(prhs[1]);
    /* get dimensions of the input matrix */
    sample_number = mxGetN(prhs[1]);
    sample_dim = mxGetM(prhs[1]);
    /* show_matrix(X, sample_number, sample_dim);*/
    
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(feature_dim,sample_number,mxREAL);
    
    /* get a pointer to the real data in the output matrix */
    Y = mxGetPr(plhs[0]);
    
    
    kronmult_c(Q, X, Y, sample_dim, sample_number,
        Q_size, Q_matrix_number);
        
    free(Q);
    free(Q_size);
}


void kronmult_c(double** Q, double *X, double *Y,
        mwSize sample_dim, mwSize sample_number,
        int* QSize, int QNumber)
{
    bool flag = true;
    int i,j,m,k,n;
    int index,sep;
    double *Y_tmp1 = (double *) malloc(sample_dim*sample_number*sizeof(double));
    double *Y_tmp2 = (double *) malloc(sample_dim*sample_number*sizeof(double));
    memcpy(Y_tmp1,X,sample_dim*sample_number*sizeof(double));
    memcpy(Y_tmp2,X,sample_dim*sample_number*sizeof(double));
    
    
    for(i = 0; i<QNumber; i++)
    {
        index = 0;
        sep = sample_dim/QSize[2*i+1];
        for(j = 0; j<sample_number; j++){
            for(m = 0; m<QSize[2*i]; m++){
                for(k = 0;k<sep;k++){
                    if(flag){
                        Y_tmp1[index] = 0;
                        for(n = 0; n<QSize[2*i+1]; n++){
                            Y_tmp1[index] = Y_tmp1[index]+Y_tmp2[j*sample_dim + n*sep + k]*Q[i][n*QSize[2*i] + m];
                            /*printf("%2.2f, %2.2f    ",Y_tmp2[j*sample_dim + n*sep + k],Q[i][n*QSize[2*i] + m]);*/
                        }                
                        index++;
                        /*printf("\n");*/
                    }
                    else{
                        Y_tmp2[index] = 0;
                        for(n = 0; n<QSize[2*i+1]; n++){
                            Y_tmp2[index] = Y_tmp2[index]+Y_tmp1[j*sample_dim + n*sep + k]*Q[i][n*QSize[2*i] + m];
                            /*printf("%2.2f, %2.2f    ",Y_tmp1[j*sample_dim + n*sep + k],Q[i][n*QSize[2*i] + m]);*/
                        }                
                        index++;
                        /*printf("\n");*/
                    }
                }
            }
        }
        sample_dim = sep;
        sample_number = sample_number*QSize[2*i];
        /*printf("sample dim: %d, sample number: %d \n", sample_dim,sample_number);*/
        if(i!=QNumber - 1){
            flag = !flag;
        }
        else{
            if(flag){
                /*printf("Hi 1\n");*/
                memcpy(Y,Y_tmp1,sample_dim*sample_number*sizeof(double));
            }
            else{
                memcpy(Y,Y_tmp2,sample_dim*sample_number*sizeof(double));
            }
        }
    }
    free(Y_tmp1);
    free(Y_tmp2);
}

void show_matrix(double *mat, int width, int height)
{
    int i,j;
    for(i = 0; i<height; i++) {
        for(j = 0; j<width; j++) {
            printf("%2.2f, ",mat[i*width+j]);
        }
        printf("\n");
    }
}
