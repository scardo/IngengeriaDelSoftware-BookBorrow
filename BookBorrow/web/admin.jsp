<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ADMIN LOGIN</title>
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
        Benvenuto nella pagina di amministrazione di Book Borrow
        <% session.setAttribute ("Operazione", "logout"); %>
        <div>

            <table>
                <tr>					
                    <td> 
                        <button onclick="window.location = 'deleteUser.jsp'">Elimina utente</button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <button onclick="window.location = 'manageBookAdmin.jsp'">Gestisci Libri</button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p>Visualizza statistiche globali di utilizzo<button onclick="window.location = 'stat.jsp'">qui</button>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <button onclick="window.location = 'OperazioniAdmin'">Logout</button>
                    </td>
                </tr>
            </table>

        </div>
    </body>
</html>
