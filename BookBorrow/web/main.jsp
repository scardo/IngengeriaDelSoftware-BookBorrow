<%-- 
    Document   : main
    Created on : 5-set-2015, 18.42.08
    Author     : insan3
--%>


<%@page import="it.bookBorrow.Ordina"%>
<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="it.bookBorrow.geolocalizzazione.Geolocalizzazione"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="it.bookBorrow.dataBase.query.ExecMainQuery"%>
<%@page import="it.bookBorrow.dataBase.query.QueryExec"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Main Page</title>
    </head>
    <body>
        <%
            // Set to expire far in the past.
            response.setHeader("Expires", "Sat, 6 May 1971 12:00:00 GMT");
            // Set standard HTTP/1.1 no-cache headers.
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            // Set IE extended HTTP/1.1 no-cache headers (use addHeader).
            response.addHeader("Cache-Control", "post-check=0, pre-check=0");
            // Set standard HTTP/1.0 no-cache header.
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0); //prevents caching at the proxy server
        %>
        <%
            if (session.getAttribute("userEmail") == null) {
                response.sendRedirect("index.jsp");
            } else {
                if ((boolean) session.getAttribute("isAdmin")) {
                    response.sendRedirect("admin.jsp");
                }
            }

        %>
        <script type="text/javascript">
            function CercaUser() {
                window.location.replace("main.jsp?uS=" + document.getElementById("utenteSel").value);
            }
        </script>
        <h1>Ciao <%out.print((String) session.getAttribute("userEmail"));%>! Sei nella mainpage di bookborrow!</h1> 
        <% session.setAttribute("Operazione", "logout");%>
        <div style="background-color: aquamarine">
            <table>
                <tr>
                    <td>
                        <button onclick="window.location = 'dataProfileChangeUser.jsp'">Modifica profilo</button>
                    </td>
                    <td>
                        <button onclick="window.location = 'searchBook.jsp'">Cerca libro</button>
                    </td>
                    <td>
                        <button onclick="window.location = 'manageBooks.jsp'">Gestisci libri</button>
                    </td>
                    <td>
                        <button onclick="window.location = 'manageIndirizzo.jsp'">Gestisci i tuoi indirizzi</button>
                    </td>
                    <td>
                        <button onclick="window.location = 'notifiche.jsp'">Prestiti</button>
                    </td>
                    <td>
                        <button onclick="window.location = 'disiscrizione.jsp'">Disiscriviti</button>
                    </td>
                    <td>
                        <button onclick="window.location = 'OperazioniUser'">Logout</button>
                    </td>            
                </tr>
            </table>
        </div>

        <div style="background-color: burlywood">
            <table>
                <tr>
                    <td>Inserisci nome, cognome o mail dell'utente:</td>
                    <td><input type="text" id="utenteSel" value="" ></td>
                    <td><button onclick="CercaUser()">Cerca</button></td>
                </tr>
            </table>
        </div>
        <%  session.setAttribute("trovato", false);
            String cord = null;
            String provincia = null;

            ParamQueryExec exQ = new ExecMainQuery();
            exQ.setParameters(0, session.getAttribute("userEmail"));
            ResultSet rs1 = exQ.getResult();

            if (rs1.next()) {
                cord = rs1.getString(1);
                provincia = rs1.getString(2);
                
            }

            exQ.setParameters(1, session.getAttribute("userEmail"), provincia, request.getParameter("uS"));
            ResultSet rssel1 = exQ.getResult();

            int size = 0;
            if (!rssel1.isLast()) {
                while (rssel1.next()) {
                    size++;
                }
            }

            ArrayList<Object[]> listaUtenti = new ArrayList<Object[]>();
            Object[] utenteCorrente;
            Object[][] distanze = null;

            ResultSet rs = exQ.getResult();

            distanze = new Object[2][size];
            int i = 0;
            while (rs.next()) {
                session.setAttribute("trovato", true);

                utenteCorrente = new Object[8];
                utenteCorrente[0] = rs.getString(2);
                utenteCorrente[1] = rs.getString(3);
                utenteCorrente[2] = rs.getString(4);
                utenteCorrente[3] = rs.getInt(5);
                utenteCorrente[4] = rs.getString(7);
                utenteCorrente[5] = rs.getString(8);
                utenteCorrente[6] = rs.getInt(9);
                utenteCorrente[7] = rs.getInt(10);
                listaUtenti.add(utenteCorrente);
                distanze[0][i] = (int) i;
                distanze[1][i] = Geolocalizzazione.getDistance(cord, rs.getString(6));
                i++;
            }

            if (distanze instanceof Object[][]) {
                distanze = Ordina.order(distanze);

        %>    
        <% if ((Boolean) session.getAttribute("trovato")) {%>
        <TABLE BORDER="1" style="border-color: orangered">
            <TR>
                <TH>Foto Profilo</TH>
                <TH>Dettaglio</TH>
                <TH>Distanza</TH>
            </TR>
            <% int p;
                for (int pos = 0; pos < distanze[0].length; pos++) {
                    p = (int) distanze[0][pos];
                    exQ.setParameters(2, listaUtenti.get(p)[0]);
                    ResultSet nlib = exQ.getResult();
                    nlib.next();
            %>
            <TR>
                <TD><img src="PrintImage?id_img=<%= listaUtenti.get(p)[0]%>&amp;what=utente" 
                         width="200" height="200"
                         alt="Immagine non Disponibile"/></TD>
                <TD> 
                    <table>
                        <tr>
                            <td><a href="profile.jsp?emailSel=<%= listaUtenti.get(p)[0]%>">
                                    <p><%= listaUtenti.get(p)[1]%> <%= listaUtenti.get(p)[2]%> (<%= listaUtenti.get(p)[3]%>)
                                    </p>
                                </a>
                            </td>       
                        </tr>
                        <tr>
                            <td><%= listaUtenti.get(p)[0]%></td>
                        </tr>
                        <tr>
                            <td><%= listaUtenti.get(p)[4]%>(<%= listaUtenti.get(p)[5]%>)</td>
                        </tr>
                        <tr>
                            <td>Libri nel sistema:<%= nlib.getInt(1)%><%
                                int ind = (int) nlib.getInt(2);
                                if (ind - 1 > 0) {
                                %>(Alcuni libri non sono all'indirizzo di residenza)<%}%>
                            </td>
                        </tr>
                    </table> 
                </TD>
                <TD> <%= distanze[1][pos]%> Km</TD>
            </TR>
            <%}%>
        </TABLE>
        <% }
            }%>


    </body>
</html>