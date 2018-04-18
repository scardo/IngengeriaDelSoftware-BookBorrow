<%-- 
    Document   : serchBook
    Created on : 13-set-2015, 16.38.11
    Author     : alessandro
--%>

<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="it.bookBorrow.Ordina"%>
<%@page import="it.bookBorrow.geolocalizzazione.Geolocalizzazione"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="it.bookBorrow.dataBase.query.ExecSBQuery"%>
<%@page import="it.bookBorrow.dataBase.query.QueryExec"%>
<%@page import="it.bookBorrow.dataBase.query.QueryExec"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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

            ParamQueryExec exQ = new ExecSBQuery();
        %>
        <script type="text/javascript">
            function CercaLibro() {
                window.location.replace("searchBook.jsp?lS=" + document.getElementById("libroSel").value + "&lg=" + document.getElementById("genereSel").value);
            }
        </script>
        <div style="background-color: burlywood">
            <table>
                <tr>
                    <td>Inserisci titolo oppure nome o cognome dell'autore:</td>
                    <td><input type="text" id="libroSel" value="" ></td>
                    <td> </td>
                    <td> </td>
                    <td>Ricerca per Genere:</td>
                    <td><select id="genereSel">
                            <option value=""> 
                                Tutti i generi
                            </option>
                            <%
                                exQ.setParameters(2);
                                ResultSet rsGen = exQ.getResult();

                                while (rsGen.next()) {

                            %>    

                            <option value="<%= rsGen.getString(1)%> "> 
                                <%out.print(rsGen.getString(1));%> 
                            </option>                    
                            <%}%>
                        </select></td>
                    <td><button onclick="CercaLibro()">Cerca</button></td>
                </tr>
            </table>
        </div>
        <%  session.setAttribute("trovato", false);
            String cord = null;
            String provincia = null;

            exQ.setParameters(0, session.getAttribute("userEmail"));
            ResultSet rs1 = exQ.getResult();

            if (rs1.next()) {
                cord = rs1.getString(1);
                provincia = rs1.getString(2);
            }

            exQ.setParameters(1, session.getAttribute("userEmail"), provincia,
                    request.getParameter("lg"), request.getParameter("lS"));

            ResultSet rslu = exQ.getResult();
            int size = 0;
            while (rslu.next()) {
                size++;
            }

            ArrayList<Object[]> listaUtenti = new ArrayList<Object[]>();
            Object[] utenteCorrente;
            Object[][] distanze = null;
            rslu.beforeFirst();
            distanze = new Object[2][size];
            int i = 0;
            while (rslu.next()) {
                session.setAttribute("trovato", true);
                utenteCorrente = new Object[13];
                utenteCorrente[0] = rslu.getString(3);
                utenteCorrente[1] = rslu.getString(4);
                utenteCorrente[2] = rslu.getString(5);
                utenteCorrente[3] = rslu.getString(6);
                utenteCorrente[4] = rslu.getInt(7);
                utenteCorrente[5] = rslu.getInt(8);
                utenteCorrente[6] = rslu.getString(9);
                utenteCorrente[7] = rslu.getString(11);
                utenteCorrente[8] = rslu.getString(12);
                utenteCorrente[9] = rslu.getString(13);
                utenteCorrente[10] = rslu.getInt(14);
                utenteCorrente[11] = rslu.getString(2);
                utenteCorrente[12] = rslu.getString(15);
                listaUtenti.add(utenteCorrente);
                distanze[0][i] = (int) i;
                distanze[1][i] = Geolocalizzazione.getDistance(cord, rslu.getString(10));
                i++;
            }

            if (distanze instanceof Object[][]) {
                if (distanze[0].length > 1) {
                    distanze = Ordina.order(distanze);
                }
            }
        %>
        <% session.setAttribute("ritornoPres", "searchBook.jsp");
            if ((Boolean) session.getAttribute("trovato")) {%>
        <div id="infoLibri">
            <form method="POST" action="OperazioniPrestito" onsubmit="window.alert('Richiesta effettata! Controlla le tue notifiche')">
                <center>
                    <table border="1" width="30%" cellpadding="5">
                        <tbody>
                            <tr>
                                <th>Copertina:</th>
                                <th>Titolo:</th>
                                <th>Autore:</th>
                                <th>Casa editrice:</th>
                                <th>Numero di pagine:</th> 
                                <th>Anno di pubblicazione:</th>
                                <th>Genere:</th>
                                <th>Indirizzo:</th>
                                <th>Distanza:</th>
                            </tr>
                            <% int p;
                                for (int pos = 0; pos < distanze[0].length; pos++) {
                                    p = (int) distanze[0][pos];
                            %>
                            <tr>

                                <td><img src="PrintImage?id_img=<%= listaUtenti.get(p)[11]%>&amp;what=libro" 
                                         width="50" height="50"
                                         alt="Immagine non Disponibile"/></td>

                                <td> <p><%= listaUtenti.get(p)[0]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[1]%>,<%= listaUtenti.get(p)[2]%> </p></td>    

                                <td> <p><%= listaUtenti.get(p)[3]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[4]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[5]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[6]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[7]%>(<%= listaUtenti.get(p)[8]%>),<%= listaUtenti.get(p)[9]%> </p><p
                                        ><%if ((int) listaUtenti.get(p)[10] == 1) {%><p>[Residenza]</p><%}%></td>

                                <td> <p> <%= distanze[1][pos]%> Km </p></td>

                                <td><button type="submit" name="prestito" value="<%= listaUtenti.get(p)[12]%>/<%= session.getAttribute("userEmail")%>/<%= listaUtenti.get(p)[11]%>">Borrow me!</button></td>
                            </tr>

                            <%}%>

                        </tbody>
                    </table>
                </center>
            </form>
            <%}%>

        </div>    


        <a href="main.jsp">Vai al main</a>
    </body>
</html>

