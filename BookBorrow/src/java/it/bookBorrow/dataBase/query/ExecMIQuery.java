package it.bookBorrow.dataBase.query;

import it.bookBorrow.dataBase.Connessione;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author alessandro
 */
public class ExecMIQuery implements ParamQueryExec {
    
    private String utente;
    
    public ExecMIQuery(){
        this.utente=null;
    }
    
    @Override
    public void setParameters(Object... obj) {
        this.utente=(String)obj[0];
    }

    @Override
    public ResultSet getResult() {
        String indirizziList= "SELECT * "
                + "FROM indirizzo "
                + "WHERE book_user='"+this.utente+"'";
        
        ResultSet rs = null;
        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();
            //eseguo la query
            rs = stmt.executeQuery(indirizziList);

            con.close();
        } catch (ClassNotFoundException | SQLException e) {
        }
        return rs;
    }

}
