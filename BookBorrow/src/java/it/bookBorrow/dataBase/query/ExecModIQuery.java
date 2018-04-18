/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
public class ExecModIQuery implements ParamQueryExec {

    private String utente;
    private String indirizzo;

    public ExecModIQuery() {
        this.utente = null;
        this.indirizzo = null;
    }

    @Override
    public void setParameters(Object... obj) {
        this.utente = (String) obj[0];
        this.indirizzo = (String) obj[1];
    }

    @Override
    public ResultSet getResult() {
        String getInd = "SELECT * "
                + "FROM indirizzo "
                + "WHERE book_user='" + this.utente + "' "
                + "AND coordinate_geografiche='" + this.indirizzo + "'";
        ResultSet rs = null;
        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();
            //eseguo la query
            rs = stmt.executeQuery(getInd);

            con.close();
        } catch (ClassNotFoundException | SQLException e) {
        }
        return rs;
    }
}
