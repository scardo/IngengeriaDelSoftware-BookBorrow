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
public class ExecNotQuery implements ParamQueryExec{
    
    private String utente;
    private int operazione;
    
    public ExecNotQuery(){
        this.utente=null;
        this.operazione=-1;
    }
    
    @Override
    public void setParameters(Object... obj) {
        this.operazione=(int)obj[0];
        this.utente=(String)obj[1];
    }

    @Override
    public ResultSet getResult() {
        String query="";
        if(this.operazione==0){
            query = "SELECT p.email_richiedente, l.titolo, l.nome_autore, "
                    + "l.cognome_autore, date_part('Year', p.data_richiesta), date_part('Month', p.data_richiesta), "
                    + "date_part('Day', p.data_richiesta), l.id "
                    + "FROM prestito p JOIN libro l ON (p.id_libro=l.id) "
                    + "WHERE p.stato ilike 'p' and "
                    + "p.email_proprietario = '" + utente + "'";
        }else{
            query = "SELECT p.email_proprietario, l.titolo, l.nome_autore, "
                    + "l.cognome_autore, date_part('Year', p.data_richiesta), date_part('Month', p.data_richiesta), "
                    + "date_part('Day', p.data_richiesta), p.stato "
                    + "FROM prestito p JOIN libro l ON (p.id_libro=l.id) "
                    + "WHERE p.email_richiedente = '" + utente + "'";
        }
        ResultSet rs = null;
        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();    
            //eseguo la query
            rs = stmt.executeQuery(query);    
            
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
        }
        return rs;
    }
    
}
