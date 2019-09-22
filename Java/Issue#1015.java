
public class SomeClass extends javax.servlet.http.HttpServlet
{
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {
        doPost(req, res);
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException {
        doPost(req, res);
    }
}
