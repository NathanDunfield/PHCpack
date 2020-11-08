// The file dbl2_monomials_kernels.cu defines the kernels with prototypes
// in dbl2_monomials_kernels.h.

/* The algorithm to compute forward, backward, and cross products
 * (denoted respectively by arrays f, b, and c)
 * for a monomial cff*x[0]*x[1]* .. *x[n-1] goes as follows:
 *
 * f[0] := cff*x[0]
 * for i from 1 to n-1 do f[i] := f[i-1]*x[i]
 * if n > 2 then
 *    b[0] := x[n-1]*x[n-2]
 *    for i from 1 to n-3 do b[i] := b[i-1]*x[n-2-i]
 *    b[n-3] := b[n-3]*cff
 *    if n = 3 then
 *       c[0] = f[0]*x[2]
 *    else
 *       for i from 0 to n-4 do c[i] := f[i]*b[n-4-i]
 *       c[n-3] := f[n-3]*x[n-1]
 *
 * Compared to the evaluation and differentiation of a product of variables,
 * (without coefficient cff), two extra multiplications must be done,
 * but this is better than n+1 multiplications with cff afterwards. */

#include "double_double_gpufun.cu"
#include "dbl2_convolutions_kernels.h"
#include "dbl2_monomials_kernels.h"

__device__ void dbl2_convolute
 ( double *xhi, double *xlo, double *yhi, double *ylo,
   double *zhi, double *zlo, int dim, int k )
{
   double prdhi,prdlo;

   // zv[k] = xv[0]*yv[k];
   ddg_mul(xhi[0],xlo[0],yhi[k],ylo[k],&zhi[k],&zlo[k]);

   for(int i=1; i<=k; i++) // zv[k] = zv[k] + xv[i]*yv[k-i];
   {
      ddg_mul(xhi[i],xlo[i],yhi[k-i],ylo[k-i],&prdhi,&prdlo);
      ddg_inc(&zhi[k],&zlo[k],prdhi,prdlo);
   }
}

__device__ void cmplx2_convolute
 ( double *xrehi, double *xrelo, double *ximhi, double *ximlo,
   double *yrehi, double *yrelo, double *yimhi, double *yimlo,
   double *zrehi, double *zrelo, double *zimhi, double *zimlo,
   int dim, int k )
{
   double xrhi,xihi,yrhi,yihi,zrhi,zihi,acchi;
   double xrlo,xilo,yrlo,yilo,zrlo,zilo,acclo;

   // z[k] = x[0]*y[k]
   xrhi = xrehi[0]; xrlo = xrelo[0]; xihi = ximhi[0]; xilo = ximlo[0];
   yrhi = yrehi[k]; yrlo = yrelo[k]; yihi = yimhi[k]; yilo = yimlo[k];

   ddg_mul(xrhi,xrlo,yrhi,yrlo,&zrhi,&zrlo);   // zr = xr*yr
   ddg_mul(xihi,xilo,yihi,yilo,&acchi,&acclo); // acc = xi*yi
   ddg_dec(&zrhi,&zrlo,acchi,acclo);           // zr = xr*yr - xi*yi
   ddg_mul(xrhi,xrlo,yihi,yilo,&zihi,&zilo);   // zi = xr*yi
   ddg_mul(xihi,xilo,yrhi,yrlo,&acchi,&acclo); // acc = xi*yr
   ddg_inc(&zihi,&zilo,acchi,acclo);           // zr = xr*yr + xi*yi

   zrehi[k] = zrhi; zrelo[k] = zrlo;
   zimhi[k] = zihi; zimlo[k] = zilo;

   for(int i=1; i<=k; i++) // z[k] = z[k] + x[i]*y[k-i]
   {
      xrhi = xrehi[i]; xrlo = xrelo[i];
      xihi = ximhi[i]; xilo = ximlo[i];
      yrhi = yrehi[k-i]; yrlo = yrelo[k-i];
      yihi = yimhi[k-i]; yilo = yimlo[k-i];

      ddg_mul(xrhi,xrlo,yrhi,yrlo,&zrhi,&zrlo);   // zr = xr*yr
      ddg_mul(xihi,xilo,yihi,yilo,&acchi,&acclo); // acc = xi*yi
      ddg_dec(&zrhi,&zrlo,acchi,acclo);           // zr = xr*yr - xi*yi
      ddg_mul(xrhi,xrlo,yihi,yilo,&zihi,&zilo);   // zi = xr*yi
      ddg_mul(xihi,xilo,yrhi,yrlo,&acchi,&acclo); // acc = xi*yr
      ddg_inc(&zihi,&zilo,acchi,acclo);           // zr = xr*yr + xi*yi

      ddg_inc(&zrehi[k],&zrelo[k],zrhi,zrlo);     // zvre[k] += zr;
      ddg_inc(&zimhi[k],&zimlo[k],zihi,zilo);     // zvim[k] += zi;
   }
}

__global__ void GPU_dbl2_speel
 ( int nvr, int deg, int *idx, double *cffhi, double *cfflo, double *inputhi,
   double *inputlo, double *forwardhi, double *forwardlo, double *backwardhi,
   double *backwardlo, double *crosshi, double *crosslo )
{
   const int k = threadIdx.x;
   const int deg1 = deg+1;
   int ix1,ix2;

   __shared__ double xvhi[dd_shmemsize];
   __shared__ double xvlo[dd_shmemsize];
   __shared__ double yvhi[dd_shmemsize];
   __shared__ double yvlo[dd_shmemsize];
   __shared__ double zvhi[dd_shmemsize];
   __shared__ double zvlo[dd_shmemsize];
  
   xvhi[k] = cffhi[k]; xvlo[k] = cfflo[k];
   ix1 = idx[0]*deg1+k;
   yvhi[k] = inputhi[ix1]; yvlo[k] = inputlo[ix1]; 
   __syncthreads(); dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
   forwardhi[k] = zvhi[k];
   forwardlo[k] = zvlo[k];                            // f[0] = cff*x[0]

   for(int i=1; i<nvr; i++)
   {
      xvhi[k] = zvhi[k]; xvlo[k] = zvlo[k];
      ix2 = idx[i]*deg1+k;
      yvhi[k] = inputhi[ix2]; yvlo[k] = inputlo[ix2];
      __syncthreads(); dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
      forwardhi[i*deg1+k] = zvhi[k]; 
      forwardlo[i*deg1+k] = zvlo[k];                  // f[i] = f[i-1]*x[i]
   }
   if(nvr > 2)
   {
      ix1 = idx[nvr-1]*deg1+k;
      xvhi[k] = inputhi[ix1]; xvlo[k] = inputlo[ix1];
      ix2 = idx[nvr-2]*deg1+k;
      yvhi[k] = inputhi[ix2]; yvlo[k] = inputlo[ix2];
      __syncthreads(); dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
      backwardhi[k] = zvhi[k];
      backwardlo[k] = zvlo[k];                       // b[0] = x[n-1]*x[n-2]
      for(int i=1; i<nvr-2; i++)
      {
         xvhi[k] = zvhi[k]; xvlo[k] = zvlo[k];
         ix2 = idx[nvr-2-i]*deg1+k;
         yvhi[k] = inputhi[ix2]; yvlo[k] = inputlo[ix2];
         __syncthreads();
         dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
         backwardhi[i*deg1+k] = zvhi[k];
         backwardlo[i*deg1+k] = zvlo[k];             // b[i] = b[i-1]*x[n-2-i]
      }
      xvhi[k] = zvhi[k];  xvlo[k] = zvlo[k];
      yvhi[k] = cffhi[k]; yvlo[k] = cfflo[k];
      __syncthreads(); dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
      ix2 = (nvr-3)*deg1+k;
      backwardhi[ix2] = zvhi[k];
      backwardlo[ix2] = zvlo[k];                    // b[n-3] = b[n-3]*cff

      if(nvr == 3)
      {
         xvhi[k] = forwardhi[k]; xvlo[k] = forwardlo[k];
         ix2 = idx[2]*deg1+k;
         yvhi[k] = inputhi[ix2]; yvlo[k] = inputlo[ix2];
         __syncthreads(); dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
         crosshi[k] = zvhi[k];
         crosslo[k] = zvlo[k];                      // c[0] = f[0]*x[2]
      }
      else
      {
         for(int i=0; i<nvr-3; i++)
         {
            ix1 = i*deg1+k; 
            xvhi[k] = forwardhi[ix1]; xvlo[k] = forwardlo[ix1];
            ix2 = (nvr-4-i)*deg1+k;
            yvhi[k] = backwardhi[ix2]; yvlo[k] = backwardlo[ix2];
            __syncthreads();
            dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
            crosshi[i*deg1+k] = zvhi[k];
            crosslo[i*deg1+k] = zvlo[k];            // c[i] = f[i]*b[n-4-i]
         }
         ix1 = (nvr-3)*deg1+k;
         xvhi[k] = forwardhi[ix1]; xvlo[k] = forwardlo[ix1];
         ix2 = idx[nvr-1]*deg1+k;
         yvhi[k] = inputhi[ix2]; yvlo[k] = inputlo[ix2];
         __syncthreads();
         dbl2_convolute(xvhi,xvlo,yvhi,yvlo,zvhi,zvlo,deg1,k);
         crosshi[(nvr-3)*deg1+k] = zvhi[k];
         crosslo[(nvr-3)*deg1+k] = zvlo[k];         // c[n-3] = f[n-3]*x[n-1]
      }
   }
}

__global__ void GPU_cmplx2_speel
 ( int nvr, int deg, int *idx,
   double *cffrehi, double *cffrelo, double *cffimhi, double *cffimlo,
   double *inputrehi, double *inputrelo, double *inputimhi, double *inputimlo,
   double *forwardrehi, double *forwardrelo, double *forwardimhi,
   double *forwardimlo, double *backwardrehi, double *backwardrelo,
   double *backwardimhi, double *backwardimlo, double *crossrehi,
   double *crossrelo, double *crossimhi, double *crossimlo )
{
}

void GPU_dbl2_evaldiff
 ( int BS, int dim, int nvr, int deg, int *idx, double *cffhi, double *cfflo,
   double **inputhi, double **inputlo, double **outputhi, double **outputlo )
{
   const int deg1 = deg+1;            // length of all vectors
   double *inputhi_d;                 // inputhi_d is input on the device
   double *inputlo_d;                 // inputlo_d is input on the device
   double *forwardhi_d;               // high forward products on the device
   double *forwardlo_d;               // low forward products on the device
   double *backwardhi_d;              // high backward products on the device
   double *backwardlo_d;              // low backward products on the device
   double *crosshi_d;                 // high cross products on the device
   double *crosslo_d;                 // low cross products on the device
   double *cffhi_d;                   // cffhi_d is cffhi on device
   double *cfflo_d;                   // cfflo_d is cfflo on device
   int *idx_d;                        // idx_d is idx on device

   size_t szcff = deg1*sizeof(double);
   size_t szdim = dim*(deg1)*sizeof(double);
   size_t sznvr = nvr*(deg1)*sizeof(double);
   size_t sznvr2 = (nvr-2)*(deg1)*sizeof(double);
   size_t szidx = nvr*sizeof(int);

   cudaMalloc((void**)&idx_d,szidx);
   cudaMalloc((void**)&cffhi_d,szcff);
   cudaMalloc((void**)&cfflo_d,szcff);
   cudaMalloc((void**)&inputhi_d,szdim);
   cudaMalloc((void**)&inputlo_d,szdim);
   cudaMalloc((void**)&forwardhi_d,sznvr);
   cudaMalloc((void**)&forwardlo_d,sznvr);
   cudaMalloc((void**)&backwardhi_d,sznvr2);
   cudaMalloc((void**)&backwardlo_d,sznvr2);
   cudaMalloc((void**)&crosshi_d,sznvr2);
   cudaMalloc((void**)&crosslo_d,sznvr2);

   double *inputhi_h = new double[dim*(deg1)];
   double *inputlo_h = new double[dim*(deg1)];
   int ix = 0;
   for(int i=0; i<dim; i++)
      for(int j=0; j<deg1; j++)
      {
         inputhi_h[ix] = inputhi[i][j];
         inputlo_h[ix++] = inputlo[i][j];
      }

   cudaMemcpy(idx_d,idx,szidx,cudaMemcpyHostToDevice);
   cudaMemcpy(cffhi_d,cffhi,szcff,cudaMemcpyHostToDevice);
   cudaMemcpy(cfflo_d,cfflo,szcff,cudaMemcpyHostToDevice);
   cudaMemcpy(inputhi_d,inputhi_h,szdim,cudaMemcpyHostToDevice);
   cudaMemcpy(inputlo_d,inputlo_h,szdim,cudaMemcpyHostToDevice);

   if(BS = deg1)
   {
      GPU_dbl2_speel<<<1,BS>>>
         (nvr,deg,idx_d,cffhi_d,cfflo_d,inputhi_d,inputlo_d,forwardhi_d,
          forwardlo_d,backwardhi_d,backwardlo_d,crosshi_d,crosslo_d);
   }
   double *forwardhi_h = new double[(deg1)*nvr];
   double *forwardlo_h = new double[(deg1)*nvr];
   double *backwardhi_h = new double[(deg1)*(nvr-2)];
   double *backwardlo_h = new double[(deg1)*(nvr-2)];
   double *crosshi_h = new double[(deg1)*(nvr-2)];
   double *crosslo_h = new double[(deg1)*(nvr-2)];
  
   cudaMemcpy(forwardhi_h,forwardhi_d,sznvr,cudaMemcpyDeviceToHost);
   cudaMemcpy(forwardlo_h,forwardlo_d,sznvr,cudaMemcpyDeviceToHost);
   cudaMemcpy(backwardhi_h,backwardhi_d,sznvr2,cudaMemcpyDeviceToHost);
   cudaMemcpy(backwardlo_h,backwardlo_d,sznvr2,cudaMemcpyDeviceToHost);
   cudaMemcpy(crosshi_h,crosshi_d,sznvr2,cudaMemcpyDeviceToHost);
   cudaMemcpy(crosslo_h,crosslo_d,sznvr2,cudaMemcpyDeviceToHost);

   int offset = (nvr-1)*deg1;            // assign value of the monomial
   for(int i=0; i<deg1; i++)
   {
      outputhi[dim][i] = forwardhi_h[offset+i];
      outputlo[dim][i] = forwardlo_h[offset+i];
   }
   ix = idx[nvr-1];                      // derivative with respect to x[n-1]
   offset = (nvr-2)*deg1;
   for(int i=0; i<deg1; i++)
   {
      outputhi[ix][i] = forwardhi_h[offset+i];
      outputlo[ix][i] = forwardlo_h[offset+i];
   }
   ix = idx[0];                          // derivative with respect to x[0]
   offset = (nvr-3)*deg1;
   for(int i=0; i<deg1; i++)
   {
      outputhi[ix][i] = backwardhi_h[offset+i];
      outputlo[ix][i] = backwardlo_h[offset+i];
   }
   for(int k=1; k<nvr-1; k++)            // derivative with respect to x[k]
   {
      ix = idx[k]; offset = (k-1)*deg1;
      for(int i=0; i<deg1; i++)
      {
         outputhi[ix][i] = crosshi_h[offset+i];
         outputlo[ix][i] = crosslo_h[offset+i];
      }
   }
}

void GPU_cmplx2_evaldiff
 ( int BS, int dim, int nvr, int deg, int *idx,
   double *cffrehi, double *cffrelo, double *cffimhi, double *cffimlo,
   double **inputrehi, double **inputrelo, double **inputimhi,
   double **inputimlo, double **outputrehi, double **outputrelo,
   double **outputimhi, double **outputimlo )
{
}