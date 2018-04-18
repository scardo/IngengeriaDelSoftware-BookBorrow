

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration</title>
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
        
       
        
        <SCRIPT TYPE="text/javascript"> 
            var array=[false,false,false,false,false,false,false,false,false,false,false,false];
            function checkEmail(email) { 
                
                
                if(email.length > 0) { 
                    if (email.indexOf(' ') >= 0 || email.indexOf('@') === -1) {
                        alert("email inserita non corretta");
                        
                        array[0]=false;
                        
                        
                    }else{
                        alert("email inserita correttamente");
                        alert("ti è stata inviata una mail di verifica");
                        alert("email verificata");
                        
                        array[0]=true;
                    }
                    
                }else{
                        alert("inserisci una mail");
                        array[0]=false;
                }
                checkAll();
            } 
            function checkVoid(field,index){
                if(field.length===0){
                    array[index]=false;
                }else{
                    array[index]=true;
                }
                checkAll();
            }
            
            function checkAll(){
                
                for(var i=0; i<array.length;i++){
                  
                    if(array[i]===false){
                        document.getElementById('reg').disabled=true;
                        return;
                    }
                }
                document.getElementById('reg').disabled=false;
            }
        </SCRIPT>

        
        <form method="GET" action="LoginAndRegistration" name="form">
            

        
            
            
            <center>
                <table border="1" width="30%" cellpadding="5">
                    <thead>
                        <tr>
                            <th colspan="2">Inserisci le informazioni per iscriverti</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="2"><b>Dati utente</b></td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td><input type="text" name="userEmail" value="" onchange="checkEmail(this.value)"></td>
                        </tr>
                        
                        
                        
                        <tr>
                            <td>Password:</td>
                            <td><input type="password" name="userPwd" value="" onchange="checkVoid(this.value,1)"></td>
                        </tr>
                        <tr>
                            <td>Nome</td>
                            <td><input type="text" name="userName" value="" onchange="checkVoid(this.value,2)"></td>
                        </tr>
                        <tr>
                            <td>Cognome</td>
                            <td><input type="text" name="userSurname" value="" onchange="checkVoid(this.value,3)"></td>
                        </tr>
                        <tr>
                            <td>Sesso:</td>
                            <td>
                                <fieldset>
                                    Maschio <input type="radio" name="sesso" value="m" onchange="checkVoid(this.value,4)"> 
                                    Femmina <input type="radio" name="sesso" value="f" onchange="checkVoid(this.value,4)">
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td>Data di nascita (GG/MM/AAAA)</td>
                            <td><input type="date" name="userBirthDate" value="" onchange="checkVoid(this.value,5)"></td>
                        </tr>
                        <tr>
                            <td colspan="2"><b>Dati indirizzo</b></td>
                        </tr>
                        <tr>
                            <td>Via: </td>
                            <td><input type="text" name="userVia" value="" onchange="checkVoid(this.value,6)"></td>
                            <td>Numero civico: </td>
                            <td><input type="text" name="userNumCiv" value="" onchange="checkVoid(this.value,7)"></td>
                        </tr>
                        <tr>
                            <td>CAP: </td>
                            <td><input type="text" name="userCAP" value="" onchange="checkVoid(this.value,8)"></td>
                        </tr>	
                        <tr>
                            <td>Citt&agrave</td>
                            <td><input type="text" name="userCity" value="" onchange="checkVoid(this.value,9)"></td>
                        </tr>	
                        <tr>
                            <td>Provincia: </td>
                            <td><input type="text" name="userProv" value="" onchange="checkVoid(this.value,10)"></td>
                        </tr>
                        <tr>
                            <td>Paese: </td>
                            <td><input type="text" name="userState" value="" onchange="checkVoid(this.value,11)"></td>
                        </tr>
          
                        <tr>
                            <td><button type="Submit" disabled id="reg" value="Registrati!" >Registrati!</button></td>
                        </tr>
                    </tbody>
                </table>
            </center>
        </form>
        <button onclick="" style="left: 30%; position: relative">Valida form</button><br/>

        <a href="index.jsp">Torna alla pagina di login!</a>
    </body>
</html>