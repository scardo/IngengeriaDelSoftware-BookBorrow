<%-- 
    Document   : stat
    Created on : 13-set-2015, 23.49.42
    Author     : insan3
--%>

<%@page import="it.bookBorrow.dataBase.query.ExecStatQuery"%>
<%@page import="java.sql.*"%>
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
                    if (!((boolean) session.getAttribute("isAdmin"))) {
                        response.sendRedirect("main.jsp");
                    }
                }

            
        %>
        <%
        ExecStatQuery exQ= ExecStatQuery.getInstance();
      
        %>


        <form>
            <center>
                <table border="1" width="30%" cellpadding="5">
                    <thead>
                        <tr>
                            <th colspan="2">
                    <p>Statistiche globali di utilizzo:</p>
                    </th>
                    </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Numero utenti iscritti:</td>
                            <td><%=exQ.getnUt()%></td>
                        </tr>
                        <tr>
                            <td>Numero libri inseriti:</td>
                            <td><%=exQ.getnLi()%></td>
                    
                        </tr>
                        <tr>
                            <td>Numero di prestiti accettati:</td>
                            <td><%=exQ.getnPA()%></td>
               
                        </tr>
                        <tr>
                            <td>Percentuale utenti di sesso maschile:</td>
                            <td><%=exQ.getnMa()%> </td>

                        </tr>
                        <tr>
                            <td>Percentuale utenti di sesso femminile:</td>
                            <td><%=exQ.getnFe()%> </td>
                        </tr>
                    </tbody>
                </table>
            </center>
        </form>
   
        <a href="admin.jsp">indietro</a>                
    </body>
</html>
