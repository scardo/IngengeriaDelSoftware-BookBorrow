<%-- 
    Document   : completeRegistration
    Created on : 8-set-2015, 1.11.25
    Author     : alessandro
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Completa registrazione</title>
    </head>
    <body>
        <p>Completa la registrazione inserendo un immagine di profilo:</p>
        <form method="POST" action="ImageUpload" enctype="multipart/form-data">
            <table>
                <tr>					
                    <td>Foto Profilo: </td>
                    <td><input type="file" name="foto_profilo"></td>
                    <td><button type="Submit" name=upload value="user/0" >Carica</button></td>
                </tr>
                <tr>
                    <td>
                        <p>Al momento non sei interessato? <a href="main.jsp">Vai alla Home!</a></p>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
