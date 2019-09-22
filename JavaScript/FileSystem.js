function GetDriveList() 
{ 
    var fso, s, n, e, x; 
    fso = new ActiveXObject("Scripting.FileSystemObject"); 
    e = new Enumerator(fso.Drives); 
    s = ""; 
    do 
    { 
        x = e.item(); 
        s = s + x.DriveLetter; 
        s += ":-    "; 
        if (x.DriveType == 3)
            n = x.ShareName; 
        else if (x.IsReady)
            n = x.VolumeName; 
        else
            n = "[Drive not ready]"; 
        s += n; 
        e.moveNext(); 
    }  while (!e.atEnd()); 

    return(s); 
}

function WriteFile() 
{
    var fso  = new ActiveXObject("Scripting.FileSystemObject"); 
    var fh = fso.CreateTextFile(".\\Test.txt", true); 
    fh.WriteLine("Some text goes here..."); 
    fh.Close(); 
}