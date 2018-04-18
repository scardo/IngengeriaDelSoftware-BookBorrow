package it.bookBorrow.dataBase.query;

import it.bookBorrow.dataBase.Connessione;
import it.bookBorrow.geolocalizzazione.Geolocalizzazione;
import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author alessandro
 */
public class LoginAndRegistration extends HttpServlet {

    /**
     * GET usato per la Registrazione
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String controlloEsistenza = "SELECT 1 FROM Book_user WHERE email = '" + request.getParameter("userEmail") + "'";
        String insertNewUser = "INSERT INTO book_user VALUES (?,?,?,?,?,?,null,0)";
        String insertNewAddress = "INSERT INTO indirizzo VALUES (?,?,?,?,?,?,?,?,1)";
        String isBanned = "SELECT 1 FROM Blacklist WHERE email = '" + request.getParameter("userEmail") + "'";

        Connection con = null;
        try {
            con = Connessione.getConnection();
        } catch (ClassNotFoundException ex) {
            response.sendRedirect("errorPage.jsp");
        }
        try {
            Statement stmt = con.createStatement();

            ResultSet rs;
            rs = stmt.executeQuery(controlloEsistenza);
            int n = 0;
            if (rs.next()) {
                n = rs.getInt(1);
            }
            if (n == 1) {
                session.setAttribute("alreadyExist", true);
                response.sendRedirect("index.jsp");
            } else {

                // Verifico che le credenziali inserite siano di un utente "normale"
                rs = stmt.executeQuery(isBanned);

                if (rs.next()) {
                    n = rs.getInt(1);
                }

                if (n == 1) {

                    session.setAttribute("isBanned", true);
                    response.sendRedirect("index.jsp");

                } else {
                    // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
                    PreparedStatement pstmt = con.prepareStatement(insertNewUser);

                    pstmt.clearParameters();

                    // imposto i parametri della query
                    pstmt.setString(1, request.getParameter("userEmail"));
                    pstmt.setString(2, request.getParameter("userPwd"));
                    pstmt.setString(3, request.getParameter("userName"));
                    pstmt.setString(4, request.getParameter("userSurname"));
                    pstmt.setString(5, request.getParameter("sesso"));
                    // CONVERSIONE STRINGA IN DATA
                    SimpleDateFormat formato_data = new SimpleDateFormat("dd/MM/yyyy");
                    java.util.Date parsed = formato_data.parse(request.getParameter("userBirthDate"));
                    java.sql.Date sql = new java.sql.Date(parsed.getTime());
                    pstmt.setDate(6, sql);

                    pstmt.executeUpdate();

                    // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
                    pstmt = con.prepareStatement(insertNewAddress);
                    pstmt.clearParameters();

                    String indirizzo
                            = request.getParameter("userVia") + " "
                            + request.getParameter("userNumCiv") + " "
                            + request.getParameter("userCAP") + " "
                            + request.getParameter("userCity") + " "
                            + request.getParameter("userProv") + " "
                            + request.getParameter("userState");

                    // imposto i parametri della query
                    String coordinate_geografiche = Geolocalizzazione.getCoordinate(indirizzo);
                    if (!cordinateEsistenti(coordinate_geografiche)) {
                        pstmt.setString(1, coordinate_geografiche);
                        pstmt.setString(2, request.getParameter("userEmail"));
                        pstmt.setString(3, request.getParameter("userVia"));
                        pstmt.setString(4, request.getParameter("userNumCiv"));
                        pstmt.setString(5, request.getParameter("userCAP"));
                        pstmt.setString(6, request.getParameter("userCity"));
                        pstmt.setString(7, request.getParameter("userProv"));
                        pstmt.setString(8, request.getParameter("userState"));

                        pstmt.executeUpdate();
                    }

                    session.setAttribute("userEmail", request.getParameter("userEmail"));
                    session.setAttribute("userName", request.getParameter("userName"));
                    session.setAttribute("userSurname", request.getParameter("userSurname"));
                    session.setAttribute("isBanned", false);
                    session.setAttribute("isAdmin", false);
                    response.sendRedirect("completeRegistration.jsp"); // completata l'iscrizione, l'utente viene reindirizzato alla sua home page

                }
            }
        } catch (SQLException | ParseException | IOException e) {
            response.sendRedirect("errorPage.jsp");
        }
    }

    /**
     * POST usato per login
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = request.getParameter("userEmail");
        String userPwd = request.getParameter("userPwd");
        String loginUser = "SELECT nome, cognome FROM Book_User WHERE email = '" + userEmail + "' AND password = '" + userPwd + "'";
        String loginAdmin = "SELECT 1 FROM Admin WHERE email = '" + userEmail + "' AND password = '" + userPwd + "'";
        String isBanned = "SELECT 1 FROM Blacklist WHERE email = '" + userEmail + "'";

        try {
            Connection con = Connessione.getConnection();

            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();

            ResultSet rs;
            // Verifico che le credenziali inserite siano di un utente "normale"
            rs = stmt.executeQuery(loginUser);

            if (rs.next()) {
                session.setAttribute("loginFailed", false);
                session.setAttribute("userEmail", userEmail);
                session.setAttribute("userName", rs.getString(1));
                session.setAttribute("userSurname", rs.getString(2));
                session.setAttribute("isAdmin", false);
                session.setAttribute("isBanned", false);
                response.sendRedirect("main.jsp"); // home page personale dell'utente
            } else {
                rs = stmt.executeQuery(loginAdmin);
                if (rs.next()) {
                    session.setAttribute("loginFailed", false);
                    session.setAttribute("userEmail", userEmail);
                    session.setAttribute("isAdmin", true);
                    session.setAttribute("isBanned", false);
                    response.sendRedirect("admin.jsp"); // home page dell'amministratore di sistema
                } else {
                    rs = stmt.executeQuery(isBanned);
                    if (rs.next()) {
                        session.setAttribute("isBanned", true);
                    } else {
                        session.setAttribute("loginFailed", true);
                    }
                    response.sendRedirect("index.jsp");
                }
            }
        } catch (ClassNotFoundException | SQLException | IOException e) {
            response.sendRedirect("errorPage.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private boolean cordinateEsistenti(String coordinate_geografiche) {
        String listaIndirizzi = "SELECT coordinate_geografiche FROM Indirizzo";
        try {
            Connection con = Connessione.getConnection();

            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();

            ResultSet rs;
            // Verifico che le credenziali inserite siano di un utente "normale"
            rs = stmt.executeQuery(listaIndirizzi);

            while (rs.next()) {
                if (rs.getString(1).equals(coordinate_geografiche)) {
                    return true;
                }
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
