import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.awt.print.*;

public class PrintExample extends JFrame
                          implements ActionListener {
  public static void main(String[] args) {
    new PrintExample_InValid();  // should not show in FunctionList
  }

  public PrintExample() {
    super("Printing Swing Components");
    WindowUtilities.setNativeLookAndFeel();
    addWindowListener(new ExitListener());
    Container content = getContentPane();
    JButton printButton = new JButton("Print");
    printButton.addActionListener(this);
    JPanel buttonPanel = new JPanel();
    buttonPanel.setBackground(Color.white);
    buttonPanel.add(printButton);
    content.add(buttonPanel, BorderLayout.SOUTH);
    DrawingPanel drawingPanel = new DrawingPanel();
    content.add(drawingPanel, BorderLayout.CENTER);
    pack();
    setVisible(true);
  }

  public void actionPerformed(ActionEvent event) {
    PrintUtilities.printComponent(this);
  }
}

