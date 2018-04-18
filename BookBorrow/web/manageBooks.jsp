
<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="it.bookBorrow.dataBase.query.ExecMBQuery"%>
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
        <%  ParamQueryExec exQ = new ExecMBQuery();
            exQ.setParameters(session.getAttribute("userEmail"));
            ResultSet rs = exQ.getResult();
      
        %>    

        
        <% session.setAttribute("Operazione", "gestisci"); %>
        

        <button onclick="window.location = 'addLibro.jsp'">Aggiungi libro</button>
        <form method="POST" action="OperazioniUser"  >
            <TABLE BORDER="1">
                
                <TR>
                    <TH>Copertina</TH>
                    <TH>Titolo</TH>
                    <TH>Autore</TH>
                    <TH>Casa Editrice</TH>
                    <TH>Proprietario</TH>            
                </TR>
                <% while (rs.next()) {%>

                <TR>
                    <td><img src="PrintImage?id_img=<%= rs.getString(1)%>&amp;what=libro" 
                                         width="50" height="50"
                                         alt="Immagine non Disponibile"/></td>
                    <TD> <%= rs.getString(2)%> </TD>
                    <TD> <%= rs.getString(3)%> <%= rs.getString(4)%> </TD>
                    <TD> <%= rs.getString(5)%> </TD>
                    <TD> <%= rs.getString(6)%> <%= rs.getString(7)%> (<%= rs.getString(8)%>)</TD>
                    <TD>
                        <button type="submit" onclick="return confirm('sicuro di voler eliminare il libro?');" name="manage" value="elimina/<%= rs.getString(1)%>">Elimina Libro</button>
                        <button type="submit" name="manage" value="gestisci/<%= rs.getString(1)%>">Modifica dati libro</button>
                    </TD>
                </TR>

                <% }%>
            </TABLE>
        </form>
        <a href="main.jsp">Indietro</a>
    </body>
</html>