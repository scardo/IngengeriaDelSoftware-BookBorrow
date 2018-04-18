<%-- 
    Document   : disiscrizione
    Created on : 14-set-2015, 23.58.58
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
        <% session.setAttribute("Operazione", "disiscrizione"); %>
        <form method="POST" action="OperazioniUser">
            <table>
                <tr>
                    <td>
                        <button type="Submit" name="confermaDisiscrizione" value="si">SI</button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <button type="Submit" name="confermaDisiscrizione" value="no">NO</button>
                    </td>       
                </tr>
            </table>
        </form>
    </body>
</html>
