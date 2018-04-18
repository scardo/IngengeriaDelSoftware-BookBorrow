/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.bookBorrow.dataBase.manageImage;

import it.bookBorrow.dataBase.Connessione;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author alessandro
 */
public class PrintImage extends HttpServlet {

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
            out.println("<title>Servlet PrintImage</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PrintImage at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        String imgLibro = "SELECT l.copertina FROM libro l WHERE l.id = '" + request.getParameter("id_img") + "'";
        String imgUtente = "SELECT u.foto_profilo FROM Book_User u WHERE u.email = '" + request.getParameter("id_img") + "'";
        String query=null;
        if(request.getParameter("what").equalsIgnoreCase("libro")){
            query=imgLibro;
        }else{
            if(request.getParameter("what").equalsIgnoreCase("utente")){
                query=imgUtente;
            }else{
                response.sendRedirect("errorPage.jsp");
            }
        }
        
        try {
            Connection con = Connessione.getConnection();

            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();

            ResultSet rs;
            // Verifico che le credenziali inserite siano di un utente "normale"
            rs = stmt.executeQuery(query);
            
            if(rs.next()){
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buf = new byte[1024];
            InputStream in = rs.getBinaryStream(1);
            int n = 0;
            while ((n = in.read(buf)) >= 0) {
                baos.write(buf, 0, n);
            }
            in.close();
            byte[] bytes = baos.toByteArray();

            if (bytes != null && bytes.length > 0) {
                response.setContentType("image/jpg");
                response.getOutputStream().write(bytes);
                response.getOutputStream().flush();
                response.getOutputStream().close();
            }
            response.sendRedirect("dataBookChangeAdmin.jsp");
            }else{
              response.sendRedirect("errorPage.jsp");  
            }
        } catch (ClassNotFoundException | SQLException | IOException e) {
            response.sendRedirect("errorPage.jsp");
        }
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
        processRequest(request, response);
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
