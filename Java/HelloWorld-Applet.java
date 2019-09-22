// Hello.java
import javax.swing.JApplet;
import java.awt.Graphics;

public class Hello extends JApplet {
    public void paintComponent(final Graphics g) {
        g.drawString("Hello, world!", 65, 95);
    }
}
