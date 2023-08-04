//Input: 4_Output_ilastik_reconstructed
input = getDirectory("Segmentation files - 4");

//Output: 5.3_Foci_Number
output = getDirectory("Save data - 5.3");

list = getFileList(input);

//SET SIZE FOCI
x=2

setBatchMode(true);
for (i = 0; i < list.length; i++)
{
	open (input + list[i]);

	name = getTitle();
	name2 = replace(name, "_recon", "");
	filename = replace(name2, ".tif", "");
	rename("A");

	run("Z Project...", "projection=[Sum Slices] all");
	rename("B");
	setThreshold(1.0000, 1000000000000000000000000000000.0000);
	run("Analyze Particles...", "size="+x+"-Infinity show=Nothing clear summarize stack");

	saveAs("results", output + filename + "_NumberFoci.csv");
	close("*");
	run("Collect Garbage");
}

showMessage("Great Success!");
