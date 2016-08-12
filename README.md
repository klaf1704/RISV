Matlab Toolbox: Reference Impairment System for Video (RISV)
===
Written by Falk Schiffner M.Sc. (Technische Universität Berlin, Germany) <br />
Collaborator: Gabriel Lucas Sobral de Araujo (artificalEdgeBusyness and GUI) <br />
This toolbox is tested with MATLAB R2015a (64-bit) on a Window 7 machine.
- - -

This toolbox allows to create video impairments to video input files according to the [ITU-T P.930 Rec]( https://www.itu.int/rec/T-REC-P.930-199608-I/en )

- - -
List of impairment types:
+ artifical Blockiness    => 'block' => insert block artefacts into the 
                                         image
+ artifical Blurring      => 'blurr' => blurring filter to reduce the 
                                         sharpness of the image
+ artifical Edge Busyness => 'edgeB' => creates flickering effects on edges in the video
+ artifical Noise (quant) => 'noiseQ'=> simulated Salt'n'Pepper Noise
+ artifical Jerkiness     => 'jerki' => insert "stop'n'go" / jerki motion
                                         in the video file
- - - 		

Note: You can process all your files accordingly to the ITU-T-REC-P.930, but there are some additional adjustments to created even more impairments, such as more intense blurring or heterogeneous block artefacts. (See descriptions for more details!)
									 
All impairments can be further specified. For more details, please have a closer look into the descriptions of the functions.

- - - 	
       
+  The toolbox is build to process one impairment at one time. If you want to include a second impairment to one file, you need to rerun the toolbox and set the parameter and 	paths accordingly.

+  The naming of the output file is set as followed:
      The name of the source file is kept and the impairment with it's "degree" is add. The reason behind that is, that you can see the processing steps directly in the file name.
      e.g.: source file: testfile.avi , 1st impairment: edgeB -10, 2nd impairment jerki 6 --> output filename: testfile_edgeB-10_jerki6.avi
        
+ The source files need to be avi-files 
+ There is NO support for audio, since only video is regarded
+ The output files are stored as motion-jpeg in an avi container 
+ The output files has NO audio
+ To insert audio you need e.g. ffmpeg <br />
    ==> there is an example ("mergeAV_ffmpeg_Host.m" and "mergeAV_ffmpeg.m")
        of merging the impaired video with the audio of the source file, but this is not part of the toolbox, since ffmpeg needs to be setup separately but can be run out of MATLAB.
		

<h3> LIST OF FILES </h3>
<h4> Main functions for the RISV </h4>

1. HOST_RISV_Processing.m ==> Host script to start from. In that script you need to define the path to the source files. Furthermore you choose which impairment you want to process and define the "degree" of the impairment. The selection of the impairment type goes via the command line. You will be ask to define the "degree" of the impairment. 

2. artificalBlockiness.m ==> This function creates block artefacts into the image. You can decide how big your blocks should be (e.g. 8 for 8x8 pixel block or 5 for 5x5 pixel blocks a.s.o). You can further decide, if the impairment should be homogeneous over the whole video as described in the ITU Rec. or you can choose the amount of blocks in a single frame and the amount of frames you want to randomly impaired. Both values are given in percent of the blocks in a frame or number of frames.
<ul>
<li> e.g. (homogeneous) testfile_blocki_5_framesimp_100_blocksimp_100.avi --> 5x5 pixel blocks, 100% of all frames impaired, 100% of all blocks in a single image impaired </li>
<li> e.g. (heterogeneous) testfile_blocki_20_framesimp_35_blocksimp_30.avi --> 20x20 pixel blocks, 35% of all frames impaired, 30% of all blocks in a single image impaired </li>
</ul>
3. artificalBlurring.m ==> This function creates blurring artefacts into the image. You can choose the degree of blurriness on 6 steps. The filters are given in the ITU-T-REC-P930. I created a 7th filter to choose, for even more blurring. If you choose 'blurr' in the host-script, you can first choose if you want to create blurring according to the ITU-T-REC or via a moving average (for more details on the moving average please see bullet-point 7.).
   
4. artificalEdgeBusyness.m ==> This function creates a flickering effect on all edges in the video file. Edges means in this case a border between a light and much darker area. The degree of the impairment can be adjusted as well.

5. artificalJerkiness.m ==> This function creates a stop'n'go like appearance into the video by holding one frame while skipping the following. The number of frames that are skipped is set by the 'jerki_value' which you have to enter.

6. artificalQuantNoise.m ==> This function creates a 'salt'n'pepper' like noise to the video. Only the luminance layer of the frames are regarded. You can set up the amount of noise by setting the 'procent_noise' - value. It give the percent of pixel in each single frame to be replaced the the noise. For every frame, a new noise error pattern is randomly generated.
 
7. Blurring_rowColumnsMovAveage.m ==> This function creates blurring into the image by applying a moving average filter to it. Here you can choose the number of pixels for averaging. E.g. entering '8' means the value of the pixel K will be averaged by the surrounding 8 pixels, aso.

8. convertRGBtoYCBCR_frame.m ==> This function converts the a video file form the colour space RGB to the colour space YCbCR.

9. convertYCBCRtoRGB_frame.m ==> This function converts the a video file from the colour space YCbCr to the Colour space RGB.

10. readVideoInput.m ==> This function is analysing the video file and gives information about the number of frames in a video file, as well as the number of rows and columns.

- - -
<h4> Additional functions: </h4>
<p> Impairment of the Luminance and example for merging Audio with Video </p>

11. HOST_LuminanzImpairment.m ==> This is the host-script for changing the luminance of a video file, there you set up the paths and if you want to make the video lighter or darker. It will call the function 'lumianz_impairment.m' and process all files that are stored in the source folder you give the path to. 

12. luminanz_impairment.m ==> this function changes the luminance of the video file. You can choose between 'light' and 'dark', which means the luminance value of the Y-layer will be change accordingly. The value is set to +90 or -90 and can be manually changed to the needed value.

13. mergeAV_ffmpeg_Host.m ==>  This is the host-script for merging audio and video via ffmpeg out of MATLAB. It will call the function 'mergeAV_ffmpeg.m' where the actual merge happens.  

14. mergeAV_ffmpeg.m ==> This function is responsible for merging the original audio form a source file to a impaired video file, that you have impaired via that toolbox. It sets up the string for ffmpeg and runs it out of MATLAB. Note: Therefore ffmpeg needs to be installed separately and it have to be set as a system command. By using ffmpeg, as a last step (if needed), you can choose all options ffmpeg has (e.g. an other container for video like *.mp4 aso.).  

- - -
<h4> Short description of the additional GUI: </h4>
+ RISV.m ==> This script starts the GUI written for the toolbox. See for further details the short documentation in the pdf file. Note: It works fine on apple machines but need some adjustment for windows machines (ongoing). 





































