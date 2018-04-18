<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <title>Benvenuto su BookBorrow!</title>
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
        <%  if (session.getAttribute("userEmail") != null) {
                if ((boolean) session.getAttribute("isAdmin")) {
                    response.sendRedirect("admin.jsp");
                } else {
                    response.sendRedirect("main.jsp");
                }
            }

            if (session.getAttribute("alreadyExist") == null) {
                session.setAttribute("alreadyExist", false);
            }
            if (session.getAttribute("isBanned") == null) {
                session.setAttribute("isBanned", false);
            }
            if (session.getAttribute("loginFailed") == null) {
                session.setAttribute("loginFailed", false);
            }
            session.setAttribute("conta", 1);
        %>
        <div id="header">
            <table>
                <tr>
                    <td>
                        <p>BookBorrow</p>
                    </td>
                    <td>
                        <!-- img -->
                    </td>
                    <td>
                        <p>PGS.srl</p>
                    </td>
                </tr>
            </table>
        </div>

        <div id="sidebarLeft"></div>
        <div id="content">
            <form action="LoginAndRegistration" method="POST">
                <% if ((Boolean) session.getAttribute("loginFailed")) { %>
                <p style="color: red">E-mail o password inseriti errati o inesistenti</p>
                <% } %>
                
                <% if ((Boolean) session.getAttribute("alreadyExist")) { %>
                <p style="color: red">L'E-mail inserita per iscriversi &egrave; gi&agrave; utilizzata</p>
                <% } %>

                <% if ((Boolean) session.getAttribute("isBanned")) { %>
                <p style="color: red">Le credenziali inserite corrispondono a un utente espulso dal sistema.</p>
                <% } %>

                <p>User: <input type="text" name="userEmail" ></p>
                <p>Password: <input type="password" name="userPwd" ></p>
                <input type="submit" value="Submit" >
            </form>

            <a href="registration.jsp">Se non sei iscritto, registrati!</a>
        </div>
    </body>
</html>
