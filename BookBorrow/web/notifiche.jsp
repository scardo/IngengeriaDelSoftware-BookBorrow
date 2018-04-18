<%-- 
    Document   : notifiche
    Created on : 13-set-2015, 22.12.40
    Author     : alessandro
--%>


<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="it.bookBorrow.dataBase.query.ExecNotQuery"%>
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

        %>
        <%  ParamQueryExec exQ = new ExecNotQuery();
            exQ.setParameters(0, session.getAttribute("userEmail"));
            ResultSet rs = exQ.getResult();

            int col = 0;

        %>
        <form method="get" action="OperazioniPrestito">
            <table>
                <th>RICHIESTE DI PRESTITO RICEVUTE</th>
                    <%while (rs.next()) {%>
                <tr style="background-color: <%if (col % 2 == 0) {
                        out.print("background");
                    } else {
                        out.print("appwoekspase");
                    }%>">
                    <td>In data <%= rs.getInt(7)%>/<%= rs.getInt(6)%>/<%= rs.getInt(5)%>, l'utente <%= rs.getString(1)%> ha chiesto in prestito il libro <%= rs.getString(2)%> di <%= rs.getString(3)%> <%= rs.getString(4)%></td><td></td>
                    <td><button type="submit" name="delete" value="<%= rs.getString(1)%>/<%= rs.getString(8)%>/a">Accetta</button></td>
                    <td><button type="submit" name="delete" value="<%= rs.getString(1)%>/<%= rs.getString(8)%>/r">Rifiuta</button></td>
                </tr>
                <%col++;
                    }%>
            </table>
        </form>
        <%
            exQ.setParameters(1, session.getAttribute("userEmail"));
            ResultSet rs1 = exQ.getResult();
            
            String accettato = "&egrave stata accettata";
            String rifiutato = "&egrave stata rifiutata";
            String pendente = "non ha ancora ricevuto una risposta";
        %>
        <table>
            <th>RICHIESTE DI PRESTITO EFFETTUATE</th>
                <%while (rs1.next()) {%>
            <tr style="background-color:  <%
                switch (rs1.getString(8).charAt(0)) {
                    case 'P':
                    case 'p':
                        out.print("orange");
                        break;
                    case 'A':
                    case 'a':
                        out.print("greenyellow");
                        break;
                    case 'R':
                    case 'r':
                        out.print("coral");
                        break;
                }
                %>">
                <td>Il prestito del libro <%= rs1.getString(2)%> di <%= rs1.getString(3)%> <%= rs1.getString(4)%> richiesto a <%= rs1.getString(1)%> il <%= rs1.getInt(7)%>/<%= rs1.getInt(6)%>/<%= rs1.getInt(5)%> <%
                    switch (rs1.getString(8).charAt(0)) {
                        case 'P':
                        case 'p':
                            out.print(pendente);
                            break;
                        case 'A':
                        case 'a':
                            out.print(accettato);
                            break;
                        case 'R':
                        case 'r':
                            out.print(rifiutato);
                            break;
                    }%></td>
            </tr>
            <%}%>
        </table>
        <a href="main.jsp">Vai al main</a>
    </body>
</html>
