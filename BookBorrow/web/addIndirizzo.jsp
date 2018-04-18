<%-- 
    Document   : addIndirizzo
    Created on : 14-set-2015, 9.47.21
    Author     : insan3
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <%
            if (session.getAttribute("userEmail") == null) {
                response.sendRedirect("index.jsp");
            } else {
                if ((boolean) session.getAttribute("isAdmin")) {
                    response.sendRedirect("admin.jsp");
                }
            }

        %>
        
        <% session.setAttribute("Operazione", "addIndirizzo"); %>
        <form method="POST" action="OperazioniUser" onsubmit="return confirm('sicuro di voler modificare i dati dell indirizzo?' );">
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
                            <td><input type="text" name="via" value="" ></td>
                        </tr>
                        <tr>
                            <td>civico:</td>
                            <td><input type="text" name="civico" value="" ></td>
                        </tr>
                        <tr>
                            <td>cap:</td>
                            <td><input type="text" name="cap" value="" ></td>
                        </tr>
                        <tr>
                            <td>citta:</td>
                            <td><input type="text" name="citta" value="" ></td>
                        </tr>
                        <tr>
                            <td>provincia:</td>
                            <td><input type="text" name="provincia" value="" ></td>
                        </tr>
                        <tr>
                            <td>paese:</td>
                            <td><input type="text" name="paese" value="" ></td>
                        </tr>
                        <tr>
                            <td>Principale:</td>
                            <td>
                                <fieldset>
                                    1<input type="radio" name="principale" value="1" > 
                                    0<input type="radio" checked = "checked" name="principale" value="0" >
                                </fieldset>
                        </td>
                        </tr>
                        <tr>
                            <td><button type="Submit" name="inserisciInd" value="inserisciInd" >Inserisci</button></td>
                        </tr>
                    </tbody>
                </table>
            </center>
        </form>
     
        <a href="manageIndirizzo.jsp">Indietro</a>
    </body>
</html>
