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
public class ExecMainQuery implements ParamQueryExec {

    private String utente;
    private String ricerca;
    private String provincia;
    private int Operazione;

    public ExecMainQuery() {
        this.utente = null;
        this.ricerca = null;
        this.provincia = null;
        this.Operazione = -1;
    }

    @Override
    public void setParameters(Object... obj) {
        this.Operazione = (int) obj[0];
        this.utente = (String) obj[1];
        if (obj.length > 2) {
            if (obj[2] != null) {
                this.provincia = (String) obj[2];
            }
            if (obj.length > 3) {
                if (obj[3] != null) {
                    this.ricerca = (String) obj[3];
                }
            }
        }

    }

    @Override
    public ResultSet getResult() {
        ResultSet rs = null;
        String query = "";
        switch (this.Operazione) {
            case 0:
                query = "SELECT coordinate_geografiche, provincia FROM indirizzo "
                        + "WHERE BOOK_USER='" + this.utente + "' "
                        + "and Principale=1 ";
                
                break;
            case 1: {
                query = "SELECT distinct 1, u.email, u.nome, u.cognome, date_part('Year', u.data_nascita),i.coordinate_geografiche, i.citta, i.provincia, "
                        + "count(distinct l.id), count(l.coordinate_geografiche) "
                        + "FROM Book_User u JOIN Indirizzo i on (u.email=i.Book_User) "
                        + "JOIN libro l "
                        + "on (i.coordinate_geografiche=l.coordinate_geografiche and i.Book_User=l.Book_User) "
                        + "Where u.tipologia = 1  and u.email!='" + this.utente + "' ";

                if (this.ricerca != null && !(this.ricerca.equals(""))) {
                    query += " and (u.nome ilike '" + this.ricerca + "' or "
                            + "u.cognome ilike '" + this.ricerca + "' or "
                            + "u.email= '" + this.ricerca + "') ";
                } else {
                    query += "and i.provincia ilike '" + this.provincia + "' ";
                }

                query += "group by u.email, i.provincia, i.citta,i.coordinate_geografiche, l.id ";
            }
            break;
            case 2:
                query = "select count(l.id), count(distinct l.coordinate_geografiche) from libro l where l.book_user='" + this.utente + "' and disponibilita=1 ";
                break;
        }

        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt = con.createStatement();
            // Verifico che le credenziali inserite siano di un utente "normale"
            rs = stmt.executeQuery(query);
            con.close();
        } catch (ClassNotFoundException | SQLException ex) {
        }
        return rs;
    }
}
