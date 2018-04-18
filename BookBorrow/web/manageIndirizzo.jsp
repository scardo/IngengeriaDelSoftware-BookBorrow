<%-- 
    Document   : manageIndirizzo
    Created on : 13-set-2015, 12.23.59
    Author     : insan3
--%>

<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="it.bookBorrow.dataBase.query.ExecMIQuery"%>
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
        <script type="text/javascript">
        
                if("<%=request.getParameter ("cancPrinc")%>"!==null && "<%=request.getParameter ("cancPrinc")%>".equals("1")){
                window.alert("Non puoi eliminare l'indirizzo principale!");
            }
            
        </script>

        <%  
            ParamQueryExec exQ = new ExecMIQuery();
            exQ.setParameters(session.getAttribute("userEmail"));
            ResultSet rs = exQ.getResult();
        
        %>    

        
        <% session.setAttribute("Operazione", "gestisciIndirizzo"); %>
        <button onclick="window.location = 'addIndirizzo.jsp'">Aggiungi indirizzo</button>
        <form method="POST" action="OperazioniUser"  >
            <TABLE BORDER="1">
                
                <TR>
                    <TH>via</TH>
                    <TH>civico</TH>
                    <TH>cap</TH>
                    <TH>citta</TH>    
                    <TH>provincia</TH>
                    <TH>paese</TH>
                    <TH>principale</TH>
                </TR>
                <% while (rs.next()) {%>

                <TR>

                    <TD> <%= rs.getString(3)%> </TD>
                    <TD> <%= rs.getString(4)%> </TD>
                    <TD> <%= rs.getString(5)%> </TD>
                    <TD> <%= rs.getString(6)%> </TD>
                    <TD> <%= rs.getString(7)%> </TD>
                    <TD> <%= rs.getString(8)%> </TD>
                    <TD> <%= rs.getString(9)%> </TD>
                    <TD>
                        
                        <button type="submit" <%= (rs.getString(9).equals("1"))? "disabled=\"true\"": ""%>  onclick="return confirm('sicuro di voler eliminare l indirizzo?');" name="manage" value="elimina/<%= rs.getString(1)%>">Elimina Indirizzo</button>
                        <button type="submit" name="manage" value="modifica/<%= rs.getString(1).replace(' ', '-')%>">Modifica dati indirizzo</button>
                    </TD>
                </TR>

                <%}%>
            </TABLE>
        </form>
        <a href="main.jsp">Indietro</a>
    </body>
</html>