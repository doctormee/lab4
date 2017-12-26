#include "mex.h"
#include <iostream>
#include <complex>
#include <vector>
#include <limits>  
using namespace std;
void biquadsolve(vector<complex<double> >& A, vector<complex<double> >& B, vector<complex<double> >& C, double *outMatrix_x1_real, double *outMatrix_x1_imag, double *outMatrix_x2_real, double *outMatrix_x2_imag, double *outMatrix_x3_real, double *outMatrix_x3_imag, double *outMatrix_x4_real, double *outMatrix_x4_imag)
{
    bool two_roots = 0;
    bool no_roots = 0;
    for (size_t i = 0; i < A.size(); i++)
        {
            const complex<double> a = A[i], b = B[i], c = C[i];
            const complex<double> d = b * b - double(4) * a * c;
            complex<double> aux1;
            complex<double> aux2;
            complex<double> x1;
            complex<double> x2;
            complex<double> x3;
            complex<double> x4;
            double moe = 1e-7;
            if (abs(a) > moe)
            {
                aux1 = (-b-sqrt(d))/(double(2)*a);
                aux2 = (-b+sqrt(d))/(double(2)*a);
                x1 = -sqrt(aux1);
                x2 = sqrt(aux1);
                x3 = -sqrt(aux2);
                x4 = sqrt(aux2);

            }
            else if (abs(b) > moe)
            {
                x1 = -sqrt(-c/b);
                x2 = sqrt(-c/b);
                two_roots = 1;
                complex<double> x3 = (0, 0);
                complex<double> x4 = (0, 0);
            }
            else
            {
                no_roots = 1;
                complex<double> x1 = (0, 0);
                complex<double> x2 = (0, 0);
                complex<double> x3 = (0, 0);
                complex<double> x4 = (0, 0);
            }
                
            outMatrix_x1_real[i] = x1.real();
            outMatrix_x1_imag[i] = x1.imag();
            outMatrix_x2_real[i] = x2.real();
            outMatrix_x2_imag[i] = x2.imag();
            outMatrix_x3_real[i] = x3.real();
            outMatrix_x3_imag[i] = x3.imag();
            outMatrix_x4_real[i] = x4.real();
            outMatrix_x4_imag[i] = x4.imag();
        }
        if (two_roots)
            mexPrintf("Only two roots: x1 and x2.\n");
        if (no_roots)
            mexPrintf("No roots.\n");
}


void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs,  const mxArray *prhs[])
{
    size_t nrows, ncols;

    vector<complex<double> > A, B, C;

    double *outMatrix_x1_real, *outMatrix_x1_imag, *outMatrix_x2_real, *outMatrix_x2_imag, *outMatrix_x3_real, *outMatrix_x3_imag, *outMatrix_x4_real, *outMatrix_x4_imag;
    if(nrhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:biquadsolve:nrhs","Three inputs required.");
    }
    if((nlhs<2)||(nlhs>4)) {
        mexErrMsgIdAndTxt("MyToolbox:biquadsolve:nlhs","Two or three outputs required.");
    }
    if( (mxGetM(prhs[0])!= mxGetM(prhs[1])) || (mxGetM(prhs[1])!= mxGetM(prhs[2]))
    ||(mxGetN(prhs[0])!= mxGetN(prhs[1])) || (mxGetN(prhs[1])!= mxGetN(prhs[2])) ) {
        mexErrMsgIdAndTxt("MyToolbox:biquadsolve:nrhs","Input matrices must be the same size.");
    }
    
    nrows = mxGetM(prhs[0]);
    ncols = mxGetN(prhs[0]);
    
    double *real_data_ptr_A = (double *)mxGetPr(prhs[0]);
    double *imag_data_ptr_A = (double *)mxGetPi(prhs[0]);
    double *real_data_ptr_B = (double *)mxGetPr(prhs[1]);
    double *imag_data_ptr_B = (double *)mxGetPi(prhs[1]);
    double *real_data_ptr_C = (double *)mxGetPr(prhs[2]);
    double *imag_data_ptr_C = (double *)mxGetPi(prhs[2]);
    for (size_t i = 0; i < nrows; i++)
      for (size_t j = 0; j < ncols; j++)
        {
            A.push_back(complex<double>(*real_data_ptr_A, *imag_data_ptr_A));
            B.push_back(complex<double>(*real_data_ptr_B, *imag_data_ptr_B));
            C.push_back(complex<double>(*real_data_ptr_C, *imag_data_ptr_C));
             real_data_ptr_A++;
             imag_data_ptr_A++;
             real_data_ptr_B++;
             imag_data_ptr_B++;
             real_data_ptr_C++;
             imag_data_ptr_C++;
        }
    
    plhs[0] = mxCreateDoubleMatrix((mwSize) nrows, (mwSize) ncols, mxCOMPLEX);
    plhs[1] = mxCreateDoubleMatrix((mwSize) nrows, (mwSize) ncols, mxCOMPLEX);
    plhs[2] = mxCreateDoubleMatrix((mwSize) nrows, (mwSize) ncols, mxCOMPLEX);
    plhs[3] = mxCreateDoubleMatrix((mwSize) nrows, (mwSize) ncols, mxCOMPLEX);

    outMatrix_x1_real = mxGetPr(plhs[0]);
    outMatrix_x1_imag = mxGetPi(plhs[0]);
    outMatrix_x2_real = mxGetPr(plhs[1]);
    outMatrix_x2_imag = mxGetPi(plhs[1]);
    outMatrix_x3_real = mxGetPr(plhs[2]);
    outMatrix_x3_imag = mxGetPi(plhs[2]);
    outMatrix_x4_real = mxGetPr(plhs[3]);
    outMatrix_x4_imag = mxGetPi(plhs[3]);
    
    biquadsolve(A, B, C, outMatrix_x1_real, outMatrix_x1_imag, outMatrix_x2_real, outMatrix_x2_imag, outMatrix_x3_real, outMatrix_x3_imag, outMatrix_x4_real, outMatrix_x4_imag);
}