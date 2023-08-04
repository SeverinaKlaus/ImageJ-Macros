input = getDirectory("Where are the Raw ilastik files - 3");
output = getDirectory("Save reconstructed - 4");

list = getFileList(input);

setBatchMode(true);
for (i = 0; i < list.length; i++)
{
	open (input + list[i]);

  name = getTitle();
  name2 = replace(name, "_big", "");
  filename = replace(name2, ".tiff", "");

  getDimensions(width, height, channels, slices, frames);
  //print(""+slices+"")
  t = slices/17;
  //print(""+t+"");
  run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=17 frames="+t+" display=Color");
  run("Size...", "width=80 height=80 depth=17 time="+t+" constrain average interpolation=None");
  run("Subtract...", "value=254 stack");
  //run("Multiply...", "value=255 stack");
  //run("Invert");
  //run("Subtract...", "value=254 stack");

  saveAs("Tiff", output + filename + "_recon");
  close("*");

}

showMessage("Finished!");
