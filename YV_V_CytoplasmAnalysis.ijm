//Input: 4_Output_ilastik_reconstructed
input = getDirectory("Where are the Segmentation files - 4");
//Input2: 1_Output_channel_GFP
input2 = getDirectory("Raw images - 1");

//Output: 5.2_Output_Cell
output = getDirectory("Save the final data - 5.2");

list = getFileList(input);
list2 = getFileList(input2);

setBatchMode(true);
for (i = 0; i < list.length; i++)
{
	
	open (input2 + list2[i]);
	name = getTitle();
	filename = replace(name, ".tif", "");
	rename("T");

//Segmentation
	run("Median...", "radius=1 stack");
	setThreshold(2200, 65535);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Divide...", "value=255 stack");
	rename("Cell");

	open (input + list[i]);
	rename("B");
	run("Invert");
	run("Subtract...", "value=254 stack");

	imageCalculator("Multiply create stack", "Cell","B");
	selectWindow("Result of Cell");
	rename("Cytoplasm");

//Get area cell
	selectWindow("Cell");
	run("Set Measurements...", "area limit redirect=None decimal=2");
	run("ROI Manager...");
	setThreshold(1, 255);
	run("Select All");
	roiManager("Add");
	roiManager("Multi Measure");
	saveAs("results", output + filename + "_AreaCell.csv");
	selectWindow("Cell");
	run("Select None");

//Get area cytoplasm
	selectWindow("Cytoplasm");
	run("Set Measurements...", "area limit redirect=None decimal=2");
	run("ROI Manager...");
	roiManager("Delete");
	setThreshold(1, 255);
	run("Select All");
	roiManager("Add");
	roiManager("Multi Measure");
	saveAs("results", output + filename + "_AreaCytoplasm.csv");
	selectWindow("Cytoplasm");
	run("Select None");

//Get values - Cell
	open (input2 + list2[i]);
	rename("A");
	//(Background substraction)
	run("Subtract...", "value=2000 stack");
	imageCalculator("Multiply create stack", "A","Cell");
	selectWindow("Result of A");
	rename("E");
	run("Z Project...", "projection=[Sum Slices] all");
	rename("Raw1");
	run("Set Measurements...", "mean min integrated redirect=None decimal=2");
	run("ROI Manager...");
	roiManager("Delete");
	selectWindow("Raw1");
	run("Select All");
	roiManager("Add");
	roiManager("Multi Measure");
	saveAs("results", output + filename + "_SignalCell.csv");
	selectWindow("Raw1");
	run("Select None");

//Get values - Cytoplasm
	imageCalculator("Multiply create stack", "A","Cytoplasm");
	selectWindow("Result of A");
	run("Z Project...", "projection=[Sum Slices] all");
	rename("Raw2");
	run("Set Measurements...", "mean min integrated redirect=None decimal=2");
	run("ROI Manager...");
	roiManager("Delete");
	selectWindow("Raw2");
	run("Select All");
	roiManager("Add");
	roiManager("Multi Measure");
	saveAs("results", output + filename + "_SignalCytoplasm.csv");	
	selectWindow("Raw2");
	run("Select None");
	
//Save image files
	selectWindow("Cell");
	saveAs("Tiff", output + filename + "_CellMask");
	selectWindow("Cytoplasm");
	saveAs("Tiff", output + filename + "_CytoplasmMask");
	selectWindow("Raw1");
	saveAs("Tiff", output + filename + "_CellSignalInMask");
	selectWindow("Raw2");
	saveAs("Tiff", output + filename + "_CytoplasmSignalInMask");
	
//clean up
	close("*");
	run("Collect Garbage");
	roiManager("Delete");

}

showMessage("Sexy!");
