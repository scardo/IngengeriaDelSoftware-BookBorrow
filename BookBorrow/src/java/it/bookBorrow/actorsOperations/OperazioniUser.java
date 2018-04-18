/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.bookBorrow.actorsOperations;

import it.bookBorrow.geolocalizzazione.Geolocalizzazione;
import it.bookBorrow.dataBase.Connessione;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author insan3
 */
public class OperazioniUser extends HttpServlet {

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
        this.doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) (request.getSession().getAttribute("userEmail"));
        String manageSet = request.getParameter("manage");

        //processRequest(request, response);
        switch ((String) request.getSession().getAttribute("Operazione")) {

            case "gestisci": {
                String whatToDo = manageSet.split("/")[0];
                String id_libro = manageSet.split("/")[1];
                switch (whatToDo) {
                    case "elimina": {
                        try {
                            eliminaLibro(id_libro);
                            setTipologiaUser(email);
                        } catch (ClassNotFoundException | SQLException ex) {
                            response.sendRedirect("errorPage.jsp");
                        }

                        response.sendRedirect("manageBooks.jsp");
                    }

                    break;

                    case "gestisci": {
                        response.sendRedirect("dataBookChangeUser.jsp?id_l=" + id_libro);
                        break;
                    }

                    default:
                        break;
                }
            }
            break;

            case "gestisciLibro": {
                String id_libro = (String) request.getSession().getAttribute("id_lib");
                try {
                    modificaDatiLibro(id_libro, request);
                } catch (ClassNotFoundException | SQLException ex) {
                    response.sendRedirect("errorPage.jsp");
                }

                response.sendRedirect("dataBookChangeUser.jsp?id_l=" + id_libro);
                break;
            }

            case "inserisciLibro": {
                int id = 1;
                String query = "INSERT INTO libro VALUES(?,?,?,?,?,?,null,1,?,?,?,?)";
                String getId = "SELECT id FROM libro";

                try (Connection con = Connessione.getConnection()) {
                    PreparedStatement pstmt = con.prepareStatement(query);
                    Statement state = con.createStatement();
                    ResultSet res = state.executeQuery(getId);
                    pstmt.clearParameters();

                    while (res.next()) {
                        if (Integer.parseInt(res.getString("id")) > id) {
                            id = Integer.parseInt(res.getString("id"));
                        }
                    }
                    id += 1;

                    pstmt.setString(1, id + "");
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("annoPubblicazione")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("numeroPagine")));
                    pstmt.setString(4, request.getParameter("nomeAutore"));
                    pstmt.setString(5, request.getParameter("cognomeAutore"));
                    pstmt.setString(6, request.getParameter("genere"));
                    pstmt.setString(7, request.getParameter("casaEd"));
                    pstmt.setString(8, request.getParameter("titolo"));

                    //
                    pstmt.setString(9, request.getParameter("mydropdown"));
                    pstmt.setString(10, email);

                    pstmt.executeUpdate();
                    setTipologiaUser(email);
                    con.close();
                    response.sendRedirect("completeInsertion.jsp?id=" + id);
                } catch (ClassNotFoundException | SQLException ex) {
                    Logger.getLogger(OperazioniUser.class.getName()).log(Level.SEVERE, null, ex);
                }

                break;

            }
            case "modificaUser": {
                String query = "UPDATE book_user SET nome=?, cognome=?, sesso=?, data_nascita=? WHERE email='" + email + "'";

                try {
                    try (Connection con = Connessione.getConnection()) {
                        PreparedStatement stmt = con.prepareStatement(query);

                        stmt.clearParameters();

                        SimpleDateFormat formato_data = new SimpleDateFormat("dd/MM/yyyy");
                        java.util.Date parsed = formato_data.parse(request.getParameter("data_nascita"));
                        java.sql.Date data = new java.sql.Date(parsed.getTime());

                        stmt.setString(1, request.getParameter("nome"));
                        stmt.setString(2, request.getParameter("cognome"));
                        stmt.setString(3, request.getParameter("sesso"));
                        stmt.setDate(4, data);

                        stmt.executeUpdate();
                    }

                    response.sendRedirect("main.jsp");
                } catch (SQLException | ClassNotFoundException | ParseException ex) {
                    Logger.getLogger(OperazioniUser.class.getName()).log(Level.SEVERE, null, ex);
                }

                break;
            }

            case "gestisciIndirizzo": {
                String whatToDo = manageSet.split("/")[0];
                String coord = manageSet.split("/")[1];
                switch (whatToDo) {
                    case "elimina": {
                        try {
                            String isPrinc
                                    = "SELECT principale "
                                    + "FROM indirizzo "
                                    + "WHERE coordinate_geografiche='" + coord + "' AND book_user='" + email + "'";
                            String eliminaInd = "DELETE FROM indirizzo WHERE coordinate_geografiche='" + coord + "' AND book_user='" + email + "'";

                            try (Connection con = Connessione.getConnection()) {
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery(isPrinc);

                                if (rs.next()) {
                                    if (rs.getInt(1) == 1) {
                                        con.close();
                                        response.sendRedirect("manageIndirizzo.jsp?cancPrinc=1");
                                        //non si puo' eliminare l indirizzo principale!!
                                    } else {
                                        stmt.executeUpdate(eliminaInd);
                                        con.close();
                                        response.sendRedirect("manageIndirizzo.jsp");
                                    }
                                }
                            }
                            break;
                        } catch (ClassNotFoundException | SQLException ex) {
                            Logger.getLogger(OperazioniUser.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        break;
                    }
                    case "modifica": {
                        response.sendRedirect("modificaIndirizzo.jsp?coor="+coord.replace(' ', '-'));
                        break;
                    }
                }

                break;
            }
            case "cambiaInd":{
            try {
                try (Connection con = Connessione.getConnection()) {
                    String changeInd="UPDATE indirizzo SET coordinate_geografiche=?, via=?, n_civico=?, cap=?, citta=?, "
                            + "provincia=?, paese=?, principale=? WHERE book_user='"+email+"' AND "
                            + "coordinate_geografiche='"+request.getParameter("parametroCoord").replace('-', ' ')+"'";
                    
                    
                    String nuovoInd
                            =request.getParameter("via")+" "
                            +request.getParameter("civico")+" "
                            +request.getParameter("cap")+" "
                            +request.getParameter("citta")+" "
                            +request.getParameter("provincia")+" "
                            +request.getParameter("paese");
                    String nuoveCoordinate=Geolocalizzazione.getCoordinate(nuovoInd);
                    
                    
                    
                    PreparedStatement pstmt=con.prepareStatement(changeInd);
                    pstmt.clearParameters();
                    
                    if(request.getParameter("principale").equals("1")){
                        String mod="UPDATE indirizzo SET principale=0 WHERE principale=1 AND book_user='"+email+"'";
                        Statement stMod=con.createStatement();
                        stMod.executeUpdate(mod);
                    }
                    
                    pstmt.setString(1, nuoveCoordinate);
                    pstmt.setString(2, request.getParameter("via"));
                    pstmt.setString(3, request.getParameter("civico"));
                    pstmt.setString(4, request.getParameter("cap"));
                    pstmt.setString(5, request.getParameter("citta"));
                    pstmt.setString(6, request.getParameter("provincia"));
                    pstmt.setString(7, request.getParameter("paese"));
                    pstmt.setInt(8, Integer.parseInt(request.getParameter("principale")));
                    
                    pstmt.executeUpdate();
                    con.close();
                }
                
                
                
            } catch (ClassNotFoundException | SQLException ex) {
                Logger.getLogger(OperazioniUser.class.getName()).log(Level.SEVERE, null, ex);
            }     
            response.sendRedirect("manageIndirizzo.jsp");
            break;
            }
            case "addIndirizzo":{
            try {
                try (Connection con = Connessione.getConnection()) {
                    if(request.getParameter("principale").equals("1")){
                        String mod="UPDATE indirizzo SET principale=0 WHERE principale=1 AND book_user='"+email+"'";
                        Statement stMod=con.createStatement();
                        stMod.executeUpdate(mod);
                    }
                    String add="INSERT INTO indirizzo VALUES(?,?,?,?,?,?,?,?,?)";
                    
                    PreparedStatement pstmt=con.prepareStatement(add);
                    pstmt.clearParameters();
                    
                    String nuovoInd
                            =request.getParameter("via")+" "
                            +request.getParameter("civico")+" "
                            +request.getParameter("cap")+" "
                            +request.getParameter("citta")+" "
                            +request.getParameter("provincia")+" "
                            +request.getParameter("paese");
                    String nuoveCoordinate=Geolocalizzazione.getCoordinate(nuovoInd);
                    
                    pstmt.setString(1, nuoveCoordinate);
                    pstmt.setString(2, email);
                    pstmt.setString(3, request.getParameter("via"));
                    pstmt.setString(4, request.getParameter("civico"));
                    pstmt.setString(5, request.getParameter("cap"));
                    pstmt.setString(6, request.getParameter("citta"));
                    pstmt.setString(7, request.getParameter("provincia"));
                    pstmt.setString(8, request.getParameter("paese"));
                    pstmt.setInt(9, Integer.parseInt(request.getParameter("principale")));
                    pstmt.executeUpdate();
                }
                
                response.sendRedirect("manageIndirizzo.jsp");
            } catch (ClassNotFoundException | SQLException ex) {
                Logger.getLogger(OperazioniUser.class.getName()).log(Level.SEVERE, null, ex);
            }
                
                break;
            }
            case "logout":{
                request.getSession().removeAttribute("userEmail");
                request.getSession().removeAttribute("isAdmin");
                response.sendRedirect("index.jsp");
                break;
            }
            case "disiscrizione":{
                    
            switch (request.getParameter("confermaDisiscrizione")) {
                case "no":{
                    response.sendRedirect("main.jsp");
                    break;
                }
                case "si":{
                    try{
                    String canc="DELETE FROM book_user WHERE email='"+email+"'";
                        try (Connection con = Connessione.getConnection()) {
                            Statement stm=con.createStatement();
                            stm.executeUpdate(canc);
                            con.close();
                        }
                    request.getSession().removeAttribute("userEmail");
                    response.sendRedirect("index.jsp");
                    
                    }catch(ClassNotFoundException | SQLException | IOException e){}
                    break;
                }
            }
                
            break;
            }
        }
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

    private void eliminaLibro(String id_libro) throws ClassNotFoundException, SQLException {
        String deleteBook = "DELETE FROM libro WHERE id='" + id_libro + "'";
        try (Connection con = Connessione.getConnection()) {
            Statement stmt = con.createStatement();
            stmt.executeUpdate(deleteBook);
            con.close();
        }

    }

    private void modificaDatiLibro(String id_l, HttpServletRequest request) throws ClassNotFoundException, SQLException {
        String updateBook = "UPDATE Libro SET anno_pubblicazione=?, n_pagine=?, "
                + "nome_autore=?, cognome_autore=?, genere=?, casa_ed=?, titolo=?, disponibilita=? "
                + "WHERE id='" + id_l + "'";
        try (Connection con = Connessione.getConnection()) {
            PreparedStatement pstmt = con.prepareStatement(updateBook);
            pstmt.clearParameters();

            // imposto i parametri della query
            pstmt.setInt(1, Integer.parseInt(request.getParameter("annoPub")));
            pstmt.setInt(2, Integer.parseInt(request.getParameter("nPag")));
            pstmt.setString(3, request.getParameter("libroAutore").split(",")[1]);
            pstmt.setString(4, request.getParameter("libroAutore").split(",")[0]);
            pstmt.setString(5, request.getParameter("gen"));
            pstmt.setString(6, request.getParameter("casaEd"));
            pstmt.setString(7, request.getParameter("libroTitolo"));
            pstmt.setInt(8, Integer.parseInt(request.getParameter("disp")));

            pstmt.executeUpdate();
            con.close();
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
        processRequest(request, response);
    }

    private void setTipologiaUser(String user) throws ClassNotFoundException, SQLException {
        String control
                = "SELECT count(libro.id) AS numLibri "
                + "FROM libro "
                + "WHERE libro.book_user='" + user + "'";

        String modifing = "UPDATE book_user SET tipologia= ";
        int numLibri = 0;

        try (Connection con = Connessione.getConnection()) {
            Statement stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery(control);

            if (rs.next()) {
                numLibri = rs.getInt("numLibri");
            }

            if (numLibri > 0) {
                stmt.executeUpdate(modifing + "1 WHERE email='" + user + "'");
            } else {
                stmt.executeUpdate(modifing + "0 WHERE email='" + user + "'");
            }
            con.close();
        }

    }

}
