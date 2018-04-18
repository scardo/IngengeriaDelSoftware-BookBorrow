package it.bookBorrow.dataBase.query;

import it.bookBorrow.dataBase.Connessione;
import java.sql.*;

/**
 *
 * @author alessandro
 */
public class ExecDelUsrQuery implements QueryExec {

    public ExecDelUsrQuery() {
    }

    @Override
    public ResultSet getResult() {
        String selectUsers = "SELECT DISTINCT b.email, b.nome, b.cognome, i.citta, i.provincia "
                + "FROM book_user b JOIN indirizzo i ON (b.email=i.book_user) WHERE i.principale=1";
        ResultSet rs = null;
        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();    
            //eseguo la query
            rs = stmt.executeQuery(selectUsers);    
            
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
        }
        return rs;
    }

}
