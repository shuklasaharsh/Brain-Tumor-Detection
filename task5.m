% ECE3005 Digital Image Processing
% Task 5: Medical Image Enhancement Using BBHE Processing
%Name:Awadh Vyas Reg.No:18BEC0301 Ph:7698767952 Slot:L45+L46
%Date:03.04.2021
tic,
clear all;
close all;
clc;
%%% Start
PSNR_Value=zeros(1,5);
MSE_Value=zeros(1,5);
results='For the 5 images:';
for i=0:4
%%% Importing image and pre-processing
imname=sprintf('%d.jpg',i); %importing image
 I = imread(imname);
 try
 im = rgb2gray(I); %converting to grayscale image
 catch
 im = I; %taking the image directly if already in grayscale
 end
 bbhe_im=BBHE(im); %Getting BBHE of image
%%% Displaying Output
figure
 s=sprintf('Original Image: p%d',i);
 subplot(2,2,1); imshow(im), title(s); %Displaing input image
 subplot(2,2,3); imshow(bbhe_im), title('BBHE Colored Image'); %Displaying BBHE output
 subplot(2,2,2); imhist(im); %Displaying histogram of input image
 subplot(2,2,4); imhist(bbhe_im) %Displaying histogram of BBHE colored image
 [PSNR_Value(i+1), MSE_Value(i+1)]=psnr((bbhe_im),(im)); 
 %Calculating PSNR and MSE
 s=sprintf('\np%d: PSNR value is %f and MSE value is %f',i,PSNR_Value(i+1), MSE_Value(i+1));
 results=strcat(results,s);
end
%%% Displaying Results
s=sprintf('\n\nAverage PSNR value is %f\nAverage MSE value is %f',mean(PSNR_Value), mean(MSE_Value));
results=strcat(results,s);
msgbox(results,'Results','help');
toc,
%%% BBHE function definition
function equalized_img = BBHE(x)
sz = size(x); %Finding dimentions of image
xmean = round(mean(x(:))); %Finding mean pixel value
%%% Histogram Equalisation
h_l = zeros(256,1);
h_u = zeros(256,1);
for i = 1:sz(1) %%Iteating over all rows and columns
 for j = 1:sz(2)
 g_val = x(i,j); %Store pixel intensity at (i,j)
 if(g_val<=xmean) %Dividing image based on pixel intensity
 h_l(g_val+1) = h_l(g_val+1) + 1; %for values below mean
 else
 h_u(g_val+1) = h_u(g_val+1) + 1; %for values above mean
 end
 end
end
nh_l = zeros(256,1);
nh_u = zeros(256,1);
% Normalised histogram
nh_l = h_l/sum(h_l); %Normalised histogram for <mean image
nh_u = h_u/sum(h_u); %Normalised histogram for >mean image
%%% Calculating CDF
hist_l_cdf = double(zeros(256,1));
hist_u_cdf = double(zeros(256,1));
hist_l_cdf(1) = nh_l(1); %Initialising first element for <mean image cdf
hist_u_cdf(1) = nh_u(1); %Initialising first element for >mean image cdf
for k = 2:256 %Generating CDF for images
 hist_l_cdf(k) = hist_l_cdf(k-1) + nh_l(k);
 hist_u_cdf(k) = hist_u_cdf(k-1) + nh_u(k);
end
%%% Image Remapping
equalized_img = zeros(sz);
range_l = [0 xmean]; %Defining range for <mean image
range_u = [(xmean+1) 255]; %Defining range for >mean image
for i =1:sz(1)
 for j =1:sz(2)
 g_val = x(i,j); %Strong pixel intensity
 if(g_val<=xmean)
 equalized_img(i,j) = range_l(1) + round(((range_l(2)-range_l(1))*hist_l_cdf(g_val+1)));
 %Remapping pixels with values less than mean
 else
 equalized_img(i,j) = range_u(1) + round(((range_u(2)-range_u(1))*hist_u_cdf(g_val+1)));
 %Remapping pixels with values greater than mean
 end
 end
end
equalized_img=uint8(equalized_img); %Convering image to uint8 form
end
%%% Algorithm
%Step 1. Convert input rgb image to gray
%Step 2. Find mean of intensity values of all pixels of image
%Step 3. Do Histogram Equalisation of Pixels with value<=mean and value>mean seperately
%Step 4. Normalise both histograms
%Step 5. Use normalised histograms to find cumulative density functions of 2 seperate images
%Step 6. Using the 2 CDF reconstuct image
%Step 7. Find PSNR and MSE of resultant image
%%% Conclusion
%In this experiment 5 MRIs of brains were taken
%BBHE was run for all images and the corresponding PSNR and MSE was calculated
%The average PSNR was found to be 15.196376
%The average MSE was found to be 5.156204

