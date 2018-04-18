<%-- 
    Document   : changeImg
    Created on : 10-set-2015, 14.04.15
    Author     : alessandro
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <br/>
        <br/>
        <% session.setAttribute("id", request.getParameter("libro_sel")); %>
        <form method="POST" action="ImageUpload" enctype="multipart/form-data" onsubmit="window.close()">
            <table>
                <tr>					
                    <td>Copertina: </td>
                    <td><input type="file" name="copertina"></td>
                    <td><button type="Submit" name=upload value="book/1" >Carica</button></td>
                </tr>
                <tr>
                    <td>
                        <a href="#" onclick="window.close()">annulla</a>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
