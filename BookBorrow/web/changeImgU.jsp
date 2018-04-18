<%-- 
    Document   : changeImgU
    Created on : 13-set-2015, 0.43.22
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
        <br/>
        <br/>
        
        <form method="POST" action="ImageUpload" enctype="multipart/form-data" onsubmit="window.close()">
            <table>
                <tr>					
                    <td>Foto profilo: </td>
                    <td><input type="file" name="foto_profilo"></td>
                    <td><button type="Submit" name=upload value="user/" >Carica</button></td>
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
