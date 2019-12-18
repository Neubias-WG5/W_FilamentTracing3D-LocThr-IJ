// Author: Sébastien Tosi (IRB Barcelona)
// Version: 1.0
// Date: 18/12/2019

// Path to input and output images
inputDir = "/dockershare/667/in/";
outputDir = "/dockershare/667/out/";

// Functional parameters
gblur = 0.75;
rad = 15;
thr = -15;

arg = getArgument();
parts = split(arg, ",");

setBatchMode(true);

for(i=0; i<parts.length; i++) {
	nameAndValue = split(parts[i], "=");
	if (indexOf(nameAndValue[0], "input")>-1) inputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "output")>-1) outputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "glur")>-1) gblur=nameAndValue[1];
	if (indexOf(nameAndValue[0], "rad")>-1) rad=nameAndValue[1];
	if (indexOf(nameAndValue[0], "thr")>-1) thr=nameAndValue[1];
}

images = getFileList(inputDir);

for(i=0; i<images.length; i++) {
	image = images[i];
	if (endsWith(image, ".tif")) {
		// Workflow
		open(inputDir + "/" + image);
		run("Gaussian Blur 3D...", "x="+d2s(gblur,2)+" y="+d2s(gblur,2)+" z="+d2s(gblur,2));
		run("Auto Local Threshold", "method=Mean radius="+d2s(rad,0)+" parameter_1="+d2s(thr,0)+" parameter_2=0 white stack");
		run("Invert LUT");
		run("Skeletonize (2D/3D)");
		run("Invert LUT");
		// Save output image
		save(outputDir + "/" + image);		
		// Cleanup
		run("Close All");
	}
}

run("Quit");
