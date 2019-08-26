function [le]=lee1(I, niterations)
%
%Lee filter for speckle noise reduction
%Authors : Jeny Rajan, Chandrashekar P.S
%Usage - lee(I)
%I is the noisy image (gray level image m x n x 1)
[x y z]=size(I);
I=double(I);
N=zeros(x,y,z);

% Set-up a waitbar
h = waitbar(0, 'Filtering Image...');

%Initialize the picture le (new picture) with zeros
le = I;

%Apply niteration of the algorithm to the image
for k = 1:niterations            
  % fprintf('\rIteration %d',i);
  if k >=2 
      I=le;
  end

    for i=1:x
        % i
        for j=1:y
            % Checking first and last pixel of first row% 
            if (i==1 && j==1)
                mat(1)=0;
                mat(2)=0;
                mat(3)=0;
                mat(4)=0;
                mat(5)=I(i,j);
                mat(6)=I(i,j+1);
                mat(7)=0;
                mat(8)=I(i+1,j);
                mat(9)=I(i+1,j+1);
            end

            if (i==1 && j==y)
                mat(1)=0;
                mat(2)=0;
                mat(3)=0;
                mat(4)=I(i,j-1);
                mat(5)=I(i,j);
                mat(6)=0;
                mat(7)=I(i+1,j-1);
                mat(8)=I(i+1,j);
                mat(9)=0;
            end

            % Checking first and last pixel of last row% 
            if (i==x && j==1)
                mat(1)=0;
                mat(2)=I(i-1,j);
                mat(3)=I(i-1,j+1);
                mat(4)=0;
                mat(5)=I(i,j);
                mat(6)=I(i,j+1);
                mat(7)=0;
                mat(8)=0;
                mat(9)=0; 
            end

            if (i==x && j==y)
                mat(1)=I(i-1,j-1);
                mat(2)=I(i-1,j);
                mat(3)=0;
                mat(4)=I(i,j-1);
                mat(5)=I(i,j);
                mat(6)=0;
                mat(7)=0;
                mat(8)=0;
                mat(9)=0;
            end
            % Checking rest of the image%        
            if (i>1 && i<x && j>1 && j<y)
                mat(1)=I(i-1,j-1);
                mat(2)=I(i-1,j);
                mat(3)=I(i-1,j+1);
                mat(4)=I(i,j-1);
                mat(5)=I(i,j);
                mat(6)=I(i,j+1);
                mat(7)=I(i+1,j-1);
                mat(8)=I(i+1,j);
                mat(9)=I(i+1,j+1);
            end
            y1=I(i,j);
            ybar=mean(mean(mat));
            if ybar~=0
                ystad=std2(mat);
                ENL=(ybar/ystad)^2;
                sx2=((ENL*(ystad)^2)-(ybar)^2)/(ENL+1);
                xcap=ybar+(sx2*(y1-ybar)/(sx2+(ybar^2/ENL)));
                N(i,j)=xcap;
            else
                N(i,j)=y1;
            end
        end

        % Update waitbar
        waitbar(((k-1)*x+i)/(x*niterations), h);
    end
end
le=uint8(N);

close(h)
        



