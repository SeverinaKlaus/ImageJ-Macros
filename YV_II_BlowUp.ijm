input = getDirectory("Where are the channel1 files - 1");
output = getDirectory("Save enlarged - 2");

list = getFileList(input);

setBatchMode(true);
for (i = 0; i < list.length; i++)
{
	open (input + list[i]);

  name = getTitle();
  filename = replace(name, ".tif", "");

  getDimensions(width, height, channels, slices, frames);
  run("Size...", "width=320 height=320 depth="+slices+" time="+frames+" constrain interpolation=None");
  saveAs("Tiff", output + filename + "_big");
  close("*");

}

showMessage("Finished!");
