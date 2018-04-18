package it.bookBorrow.dataBase.query;

import it.bookBorrow.dataBase.Connessione;
import java.sql.*;

/**
 *
 * @author alessandro
 */
public class ExecBCUQuery implements ParamQueryExec{
    private String libro;
    private String utente;

    public ExecBCUQuery() {
        this.libro = null;
        this.utente = null;
    }

    @Override
    public void setParameters(Object... obj) {
        this.libro = (String) obj[0];
        this.utente= (String) obj[1]; 
    }

    @Override
    public ResultSet getResult() {
        ResultSet rs = null;

        String datiLibro = "SELECT anno_pubblicazione, n_pagine, "
                    + "nome_autore, cognome_autore, genere, casa_ed, titolo, disponibilita "
                    + "FROM libro l "
                    + "WHERE l.id='" + this.libro 
                    + "' AND l.book_user='"+this.utente+"'";

        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();
            // Verifico che le credenziali inserite siano di un utente "normale"
            rs = stmt.executeQuery(datiLibro);
            con.close();
        } catch (ClassNotFoundException | SQLException ex) {
        }
        return rs;
    }
}
