<%-- 
    Document   : modificaIndirizzo
    Created on : 14-set-2015, 1.05.41
    Author     : insan3
--%>

<%@page import="it.bookBorrow.dataBase.query.ParamQueryExec"%>
<%@page import="it.bookBorrow.dataBase.query.ExecModIQuery"%>
<%@page import="java.sql.ResultSet"%>
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

        %>
        
        
        <%
            ParamQueryExec exQ = new ExecModIQuery();
            exQ.setParameters(session.getAttribute("userEmail"), request.getParameter("coor").replace('-', ' '));
            ResultSet rs = exQ.getResult();

            if (rs.next()) {
        %>

        <% session.setAttribute("Operazione", "cambiaInd");%>
        <form method="POST" action="OperazioniUser" onsubmit="return confirm('sicuro di voler modificare i dati dell indirizzo?');">
            <center>
                <table border="1" width="30%" cellpadding="5">
                    <thead>
                        <tr>
                            <th colspan="2">
                    <p>Dati indirizzo:</p>
                    </th>
                    </tr>
                    </thead>
                    <tbody>

                        <tr>
                            <td>via:</td>
                            <td><input type="text" name="via" value="<%= rs.getString(3)%>" ></td>
                        </tr>
                        <tr>
                            <td>civico:</td>
                            <td><input type="text" name="civico" value="<%= rs.getString(4)%>" ></td>
                        </tr>
                        <tr>
                            <td>cap:</td>
                            <td><input type="text" name="cap" value="<%= rs.getString(5)%>" ></td>
                        </tr>
                        <tr>
                            <td>citta:</td>
                            <td><input type="text" name="citta" value="<%= rs.getString(6)%>" ></td>
                        </tr>
                        <tr>
                            <td>provincia:</td>
                            <td><input type="text" name="provincia" value="<%= rs.getString(7)%>" ></td>
                        </tr>
                        <tr>
                            <td>paese:</td>
                            <td><input type="text" name="paese" value="<%= rs.getString(8)%>" ></td>
                        </tr>
                        <tr>
                            <td>Principale:</td>
                            <td>
                                <fieldset>
                                    1<input type="radio" <%=(rs.getInt(9) == 1) ? "checked = \"checked\"" : ""%> name="principale" value="1" > 
                                    0<input type="radio" <%=(rs.getInt(9) == 0) ? "checked = \"checked\"" : ""%> <%= (rs.getString(9).equals("1")) ? "disabled=\"true\"" : ""%> name="principale" value="0" >
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td><button type="Submit" name="parametroCoord" value="<%=rs.getString(1)%>" >Modifica</button></td>
                        </tr>
                    </tbody>
                </table>
            </center>
        </form>
        <%}%>
        <a href="manageIndirizzo.jsp">Indietro</a>
    </body>
</html>
