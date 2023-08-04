input = getDirectory("Where are the raw files");
output = getDirectory("Save channel 1");

list = getFileList(input);

setBatchMode(true);
for (i = 0; i < list.length; i++)
{
	open (input + list[i]);

  name = getTitle();
  name2 = replace(name, " ", "_");
  filename = replace(name2, ".tif", "");
  run("Duplicate...", "duplicate channels=1");
  saveAs("Tiff", output + filename + "_channel_1");
  close("*");

}

showMessage("Finished!");
