package it.bookBorrow.dataBase.query;

import it.bookBorrow.dataBase.Connessione;
import java.sql.*;

/**
 *
 * @author alessandro
 */
public class ExecBCAQuery implements ParamQueryExec {

    private String libro;

    public ExecBCAQuery() {
        this.libro = null;
    }

    @Override
    public void setParameters(Object... obj) {
        this.libro = (String) obj[0];
    }

    @Override
    public ResultSet getResult() {
        ResultSet rs = null;

        String datiLibro = "SELECT anno_pubblicazione, n_pagine, "
                + "nome_autore, cognome_autore, genere, casa_ed, titolo "
                + "FROM libro l WHERE l.id='" + libro + "'";

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
