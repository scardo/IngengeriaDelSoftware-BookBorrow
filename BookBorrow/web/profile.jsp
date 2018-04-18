<%-- 
    Document   : profile
    Created on : 12-set-2015, 11.11.26
    Author     : insan3
--%>


<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="it.bookBorrow.Ordina"%>
<%@page import="it.bookBorrow.geolocalizzazione.Geolocalizzazione"%>
<%@page import="java.util.ArrayList"%>
<%@page import="it.bookBorrow.dataBase.query.ExecPrQuery"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="it.bookBorrow.dataBase.query.QueryExec"%>
<%@page import="it.bookBorrow.dataBase.query.QueryExec"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="Resources/css/style.css" rel="stylesheet" type="text/css"/>
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
        <%  String cord = "";
            ParamQueryExec exQ = new ExecPrQuery();
            exQ.setParameters(0, session.getAttribute("userEmail"));
            ResultSet rs = exQ.getResult();

            if (rs.next()) {
                cord = rs.getString(1);
            }
        %>    
        <%
            exQ.setParameters(1, request.getParameter("emailSel"));
            ResultSet rspu = exQ.getResult();

            if (rspu.next()) {
        %>
        <div id="fotoProfilo">
            <img src="PrintImage?id_img=<%=request.getParameter("emailSel")%>&amp;what=utente" 
                 width="200" height="200" 
                 alt="Immagine non Disponibile"/>
        </div>

        <div id="infoProfilo">
            <h1><%= rspu.getString("nome")%> <%= rspu.getString("cognome")%></h1>
            <p>email: <%= request.getParameter("emailSel")%></p>
            <p>Anno di nascita: <%= rspu.getInt("an")%></p>
            <p>Residenza: <%= rspu.getString("citta")%>(<%= rspu.getString("provincia")%>),<%= rspu.getString("paese")%></p>
        </div>
        <%  }
            session.setAttribute("trovato", true);
            exQ.setParameters(2, request.getParameter("emailSel"));
            ResultSet rslu = exQ.getResult();

            int size = 0;
            while (rslu.next()) {
                size++;
            }

            ArrayList<Object[]> listaUtenti = new ArrayList<Object[]>();
            Object[] utenteCorrente;
            Object[][] distanze = null;
            rslu.beforeFirst();
            int i = 0;
            distanze = new Object[2][size];
            while (rslu.next()) {
                session.setAttribute("trovato", true);
                utenteCorrente = new Object[12];
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
                listaUtenti.add(utenteCorrente);
                distanze[0][i] = (int) i;
                distanze[1][i] = Geolocalizzazione.getDistance(cord, rslu.getString(10));
                i++;
            }

            if (distanze instanceof Object[][]) {
                if (distanze[0].length > 1) {
                    distanze = Ordina.order(distanze);
                }
                String link = "profile.jsp?emailSel=" + request.getParameter("emailSel");
        %>

        <%  session.setAttribute("ritornoPres", link);
            if ((Boolean) session.getAttribute("trovato")) {%>
        <div id="infoLibri">
            <form method="POST" action="OperazioniPrestito" onsubmit="window.alert('Richiesta effettata! Controlla le tue notifiche')" >
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
                                         alt="Immagine non Disponibile"/>

                                <td> <p><%= listaUtenti.get(p)[0]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[1]%>,<%= listaUtenti.get(p)[2]%> </p></td>    

                                <td> <p><%= listaUtenti.get(p)[3]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[4]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[5]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[6]%> </p></td>

                                <td> <p><%= listaUtenti.get(p)[7]%>(<%= listaUtenti.get(p)[8]%>),<%= listaUtenti.get(p)[9]%> </p><p
                                        ><%if ((int) listaUtenti.get(p)[10] == 1) {%><p>[Residenza]</p><%}%></td>

                                <td> <p> <%= distanze[1][pos]%> Km </p></td>

                                <td><button type="submit" name="prestito" value="<%= request.getParameter("emailSel")%>/<%= session.getAttribute("userEmail")%>/<%= listaUtenti.get(p)[11]%>">Borrow me!</button></td>
                            </tr>

                            <%}%>

                        </tbody>
                    </table>
                </center>
            </form>
            <%} %>
            <a href="main.jsp">Vai al main</a>
        </div>    

        <%}%>

    </body>
</html>
