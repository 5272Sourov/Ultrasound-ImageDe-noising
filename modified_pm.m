
function diff = anisodiff(im, niterations, kappa, lambda, option)
%
% ANISODIFF Anisotropic diffusion
% srad
% Usage:
%  diff = anisodiff(im, niterations, kappa, lambda, option)
%			= anisodiff(im, 2, 30, 0.20, 1);
%         im  -             input image
%         nititerations -   number of itterative itterations itterations 
%         kappa - conduction coefficient 20-100 ?
%         lambda - max value of .25 for stability
%         option - 1 Perona Malik diffusion equation No 1
%                  2 Perona Malik diffusion equation No 2
%                  3 Speckle Reducing Anisotropic Diffusion No 3
%
%       When filtering with option 3 Anisotropic diffussion
%       K= anisodiff(im, 20, 20, 0.25, 3);  
% Reference: P. Perona and J. Malik. 
% Scale-space and edge detection using ansotropic diffusion.
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 12(7):629-639, July 1990.
       
%********************************************************************************
%Estimate the size of the image
[ma ,na] = size(im);

im = double(im)/255;
[rows,cols] = size(im);
diff = im;
  
h = waitbar(0, 'Filtering Image...');

for i = 1:niterations
  
  % Construct diffl which is the same as diff but
  % has an extra padding of zeros around it.
  diffl = zeros(rows+2, cols+2);
  diffl(2:rows+1, 2:cols+1) = diff;

  % North, South, East and West differences (gradient)
   deltaN = diffl(1:rows,2:cols+1) - diff;
  deltaS = diffl(3:rows+2,2:cols+1) - diff;
  deltaE = diffl(2:rows+1,3:cols+2) - diff;
  deltaW = diffl(2:rows+1,1:cols) - diff;
  
  deltaNE = diffl(1:rows,3:cols+2) - diff;
  deltaSW = diffl(3:rows+2,1:cols) - diff;
  deltaSE = diffl(3:rows+2,3:cols+2) - diff;
  deltaNW = diffl(1:rows,1:cols) - diff;
  
  % North, South, East and West differences (divergence)
  deltaNN = gradient(deltaN);
  deltaSS = gradient(deltaS);
  deltaEE = gradient(deltaE);
  deltaWW = gradient(deltaW);
  deltaNENE=gradient(deltaNE);
  deltaSWSW=gradient(deltaSW);
  deltaSESE=gradient(deltaSE);
  deltaNWNW=gradient(deltaNW);
  
  % Conduction
  if option == 1
    % disp('        Perona & Malik Diffusion Equation No. 1');
    cN = exp(-(deltaN/kappa).^2);
    cS = exp(-(deltaS/kappa).^2);
    cE = exp(-(deltaE/kappa).^2);
    cW = exp(-(deltaW/kappa).^2);
    cNE = exp(-(deltaNE/kappa).^2);
    cSE = exp(-(deltaSE/kappa).^2);
    cNW = exp(-(deltaNW/kappa).^2);
    cSW = exp(-(deltaSW/kappa).^2);

  elseif option == 2
    % disp('         Perona & Malik Diffusion Equation o. 2');
    cN = 1./(1+exp(-(deltaN/kappa).^2));
    cS = 1./(1+exp(-(deltaS/kappa).^2));
    cE = 1./(1+exp(-(deltaE/kappa).^2));
    cW = 1./(1+exp(-(deltaW/kappa).^2));
    cNE = 1./(1+exp(-(deltaNE/kappa).^2));
    cSE = 1./(1+exp(-(deltaSE/kappa).^2));
    cNW = 1./(1+exp(-(deltaNW/kappa).^2));
    cSW = 1./(1+exp(-(deltaSW/kappa).^2));
    
elseif option == 3
    % disp('      Speckle Reducing Anisotropic diffussion'); 
    kappa=kappa/10;
    cN = sqrt(abs(((0.5*deltaNN-(1/2).*deltaNN.^2))*kappa))./((max(0.01,diff+(1/4).*deltaNN)));
    cS = sqrt(abs(((0.5*deltaSS-(1/2).*deltaSS.^2))*kappa))./((max(0.01,diff+(1/4).*deltaSS)));
    cE = sqrt(abs(((0.5*deltaEE-(1/2).*deltaEE.^2))*kappa))./((max(0.01,diff+(1/4).*deltaEE)));
    cW = sqrt(abs(((0.5*deltaWW-(1/2).*deltaWW.^2))*kappa))./((max(0.01,diff+(1/4).*deltaWW)));
     cNE = sqrt(abs(((0.5*deltaNENE-(1/2).*deltaNENE.^2))*kappa))./((max(0.01,diff+(1/4).*deltaNENE)));
    cSE = sqrt(abs(((0.5*deltaSESE-(1/2).*deltaSESE.^2))*kappa))./((max(0.01,diff+(1/4).*deltaSESE)));
    cNW = sqrt(abs(((0.5*deltaNWNW-(1/2).*deltaNWNW.^2))*kappa))./((max(0.01,diff+(1/4).*deltaNWNW)));
    cSW = sqrt(abs(((0.5*deltaSWSW-(1/2).*deltaSWSW.^2))*kappa))./((max(0.01,diff+(1/4).*deltaSWSW)));
   
  end


  diff = diff + lambda*(cN.*deltaN + cS.*deltaS + cE.*deltaE + cW.*deltaW + cNE.*deltaNE + cSE.*deltaSE + cNW.*deltaNW + cSW.*deltaSW);
  
  waitbar(i/niterations, h);
end
close(h)
diff = round(diff.*255);
diff = uint8(diff);
