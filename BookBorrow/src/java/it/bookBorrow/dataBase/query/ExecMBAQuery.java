package it.bookBorrow.dataBase.query;

import it.bookBorrow.dataBase.Connessione;
import java.sql.*;

/**
 *
 * @author alessandro
 */
public class ExecMBAQuery implements QueryExec {

    public ExecMBAQuery() {
    }

    @Override
    public ResultSet getResult() {
        String bookList = "SELECT l.id, l.titolo, l.nome_autore, l.cognome_autore, l.casa_ed, b.nome,"
                    + " b.cognome, b.email FROM libro l JOIN book_user b ON (l.book_user=b.email);";
        ResultSet rs = null;
        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();    
            //eseguo la query
            rs = stmt.executeQuery(bookList);    
            
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
        }
        return rs;
    }
}    