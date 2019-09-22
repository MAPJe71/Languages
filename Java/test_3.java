package org.muermann.gotofile.ui;

public class SearchWindow extends SelectionDialog
{
    private void openSelected()
    {
        try
        {
            int i = 0;
            if (page != null)
                org.eclipse.ui.ide.IDE.openEditor(page, file);
            ((int)i).NoMethod();
        } catch (PartInitException e1)
        {
        }
    }
}
