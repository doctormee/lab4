#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
const double moe = 0.0000000000001;
double Norm(int n, double *x) 
{
    int i;
	double sum = 0;
	for(i = 0; i < n; ++i) 
		sum += x[i] * x[i];
	return sqrt(sum);
}

void InitMatrix(int n, double *x) {
    int i, j;
	for(i = 0; i < n; ++i) {
		for(j = 0; j < n; ++j) {
			x[i*n + j] = 0;
		}
	}
}

double MultiplyVectors(int n, double *x, double *y) 
{
    int i;
	double sum = 0;
	for(i = 0; i < n; ++i) {
		sum += x[i] * y[i];
	}
	return sum;
}

void MultiplyMatrix(int n, double *x, double *y, double *res) {
	InitMatrix(n, res);
    int i, j, k;
	for(i = 0; i < n; ++i) {
		for(j = 0; j < n; ++j) {
			

			for(k = 0; k < n; ++k) {
				res[i * n + j] += x[i * n + k] * y[k * n + j]; 
			}
		}
	}
}

void QRDecomposition(int n, double *A, double * Q, double *R)
{
	double *bufq = malloc(n * sizeof(*bufq));
	double *bufa = malloc(n * sizeof(*bufa));
    int i, j, k;
	for(j = 0; j < n; ++j) {
		for(k = 0; k < n; ++k) {
            Q[j * n + k] = A[j * n + k];
		}

		for(i = 0; i < j; ++i) {
			for(k = 0; k < n; ++k) {
                bufq[k] = Q[i * n + k];
				bufa[k] = A[j * n + k];
			}
            R[j * n + i] = MultiplyVectors(n, bufq, bufa);
			for(k = 0; k < n; ++k) {
                Q[j * n + k] -= R[j * n + i] * Q[i * n + k];
			}
		}
		for(k = 0; k < n; ++k) {
            bufq[k] = Q[j * n + k];
		}
		R[j * n + j] = Norm(n, bufq);
		if ( fabs(R[j * n + j]) < moe ) {
			printf("Bad matrix\n\n\n\n");
			return;
		}
		for(k = 0; k < n; ++k) {
            Q[j * n + k] /= R[j * n + j];
		}
	}
    
	free(bufq);
	free(bufa);
}


void gr_c(double *A, double *Q, double *R, int n)
{
	InitMatrix(n, Q);
	InitMatrix(n, R);
	QRDecomposition(n, A, Q, R);
    
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs,  const mxArray *prhs[])
{
    double *Q, *R;
    if(nrhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:gr_c:nrhs","One matrix required.");
    }
    
    if(mxGetM(prhs[0])!= mxGetN(prhs[0])) {
        mexErrMsgIdAndTxt("MyToolbox:gr_c:nrhs","Input matrix must be square.");
    }
    
    int n = mxGetM(prhs[0]);
    double *A = malloc(n * n * sizeof(*A));
    double *ptr_A = (double *)mxGetPr(prhs[0]);
    size_t i, j;
    for (i = 0; i < n; i++)
      for (j = 0; j < n; j++)
        {
            A[i * n + j] = *ptr_A;
            
            ptr_A++;
        }
    plhs[0] = mxCreateDoubleMatrix((mwSize) n, (mwSize) n, mxREAL);
    plhs[1] = mxCreateDoubleMatrix((mwSize) n, (mwSize) n, mxREAL);

    Q = mxGetPr(plhs[0]);
    R = mxGetPr(plhs[1]);
    
    gr_c(A, Q, R, n);
}
