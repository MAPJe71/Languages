using System;
using System.IO;
using System.Windows.Forms;

namespace MBExtensions
{
	class MBExtensionsDlgs
	{
		public static string OpenMultipleFilesDlg(string sPath, string sFileType, string sPrompt)
		{
			string mbSelectedFiles;
			OpenFileDialog ofd = new OpenFileDialog();

			mbSelectedFiles = "";
			
			ofd.InitialDirectory = sPath;
			ofd.Filter = sFileType;
			ofd.Title = sPrompt;
			ofd.Multiselect = true;

			if(ofd.ShowDialog() == DialogResult.OK)
			{
				foreach (String file in ofd.FileNames) 
				{
					if (mbSelectedFiles == "")
					{
						mbSelectedFiles = file;
					}
					else
					{
						mbSelectedFiles = mbSelectedFiles + ";" + file;
					}
				}
			}
			return mbSelectedFiles;
		}
	}
}