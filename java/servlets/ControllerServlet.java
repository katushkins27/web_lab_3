package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ControllerServlet", value = "/controller")
public class ControllerServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws  ServletException, IOException{
        String x = request.getParameter("x");
        String y = request.getParameter("y");
        String[] r = request.getParameterValues("r");

        if (x != null && y != null && r != null && r.length>0){
            request.getRequestDispatcher("/areaCheck").forward(request,response);
        } else{
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
