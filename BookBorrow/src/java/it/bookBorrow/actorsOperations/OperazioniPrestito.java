package it.bookBorrow.actorsOperations;

import it.bookBorrow.dataBase.Connessione;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alessandro
 */
public class OperazioniPrestito extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OperazioniPrestito</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OperazioniPrestito at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String proprietario = (String) request.getSession().getAttribute("userEmail");
        String richiedente = request.getParameter("delete").split("/")[0];
        String libro = request.getParameter("delete").split("/")[1];
        char stato = request.getParameter("delete").split("/")[2].charAt(0);

        String setStatoPr = "Update prestito set stato='" + stato + "' "
                + "WHERE email_proprietario='" + proprietario + "' and email_richiedente='" + richiedente + "' "
                + "and id_libro='" + libro + "' ";
        String disponibile = "Update libro set disponibilita=1 where id='" + libro + "'";

        try {
            Connection con = Connessione.getConnection();
            Statement stmt = con.createStatement();
            stmt.executeUpdate(setStatoPr);

            con.close();

            if (stato == 'r' ||stato == 'R') {
                con = Connessione.getConnection();
                stmt = con.createStatement();
                stmt.executeUpdate(disponibile);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            response.sendRedirect("errorPage.sql");
        }
        response.sendRedirect("notifiche.jsp");

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String proprietario = request.getParameter("prestito").split("/")[0];
        String richiedente = request.getParameter("prestito").split("/")[1];
        String libro = request.getParameter("prestito").split("/")[2];
        Date data = new Date(System.currentTimeMillis());
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String prestito = "Insert into Prestito values ('" + proprietario + "','" + richiedente + "','" + libro + "','p','" + dateFormat.format(data) + "')";
        String disponibile = "Update libro set disponibilita=0 where id='" + libro + "'";

        try {
            Connection con = Connessione.getConnection();
            Statement stmt = con.createStatement();
            stmt.executeUpdate(prestito);

            con.close();
            con = Connessione.getConnection();
            stmt = con.createStatement();
            stmt.executeUpdate(disponibile);

        } catch (ClassNotFoundException | SQLException ex) {
            response.sendRedirect("errorPage.sql");
        }
        response.sendRedirect((String) request.getSession().getAttribute("ritornoPres"));
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
