//Input: 4_Output_ilastik_reconstructed
input = getDirectory("Where are the Segmentation files - 4");
//Input2: 1_Output_channel_GFP
input2 = getDirectory("Raw images - 1");

//Output: 5.1_Output_Foci
output = getDirectory("Save data - 5-1");

list = getFileList(input);
list2 = getFileList(input2);

setBatchMode(true);
for (i = 0; i < list.length; i++)
{
	open (input + list[i]);

	name = getTitle();
	name2 = replace(name, "_recon", "");
	filename = replace(name2, ".tif", "");
	rename("A");

	open (input2 + list2[i]);
	rename("B");
//Background substraction
	run("Subtract...", "value=2000 stack");

	imageCalculator("Multiply create stack", "B","A");
	selectWindow("Result of B");

//Area determination
	selectWindow("A");
	run("Set Measurements...", "area limit redirect=None decimal=2");
	run("ROI Manager...");
	setThreshold(1, 255);
	run("Select All");
	roiManager("Add");
	roiManager("Multi Measure");

	saveAs("results", output + filename + "_AreaFoci.csv");
	selectWindow("A");
	run("Select None");

//Signal determination
	selectWindow("B");
	run("Select None");
	selectWindow("Result of B");
	run("Z Project...", "projection=[Sum Slices] all");
	rename("Result");
	selectWindow("Result");

	run("Set Measurements...", "mean min integrated limit redirect=None decimal=2");
	run("ROI Manager...");
	roiManager("Delete");

	setAutoThreshold("Default");
	//run("Threshold...");
	selectWindow("Result");
	setThreshold(1.0000, 1000000000000000000000000000000.0000);
	run("Select All");
	roiManager("Add");
	roiManager("Multi Measure");

	saveAs("results", output + filename + "_foci.csv");
	roiManager("Delete");

	selectWindow("Result");
	saveAs("Tiff", output + filename + "_signalinFoci");
	close("*");
	run("Collect Garbage");

}

showMessage("Wonderful!");
