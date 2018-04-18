<%-- 
    Document   : completeInsertion
    Created on : 12-set-2015, 2.30.36
    Author     : insan3
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inserimento copertina</title>
    </head>
    <body>
        <p>Completa inserendo la foto della copertina:</p>
        <form method="POST" action="ImageUpload" enctype="multipart/form-data">
            <table>
                <tr>					
                    <td>Copertina: </td>
                    <td><input type="file" name="copertina"></td>
                    <td><button type="Submit" name=upload value="book/<%=request.getParameter("id")%>" >Carica</button></td>
                </tr>
                <tr>
                    <td>
                        <p>Al momento non sei interessato? <a href="manageBooks.jsp">pagina amministrazione libri</a></p>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
