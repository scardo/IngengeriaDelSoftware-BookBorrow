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
public class ExecPrQuery implements ParamQueryExec{
    private String utenteLog;
    private String utenteP;
    private int Operazione;

    public ExecPrQuery() {
        this.utenteLog = null;
        this.utenteP = null;
        this.Operazione = -1;
    }

    @Override
    public void setParameters(Object... obj) {
        this.Operazione = (int) obj[0];
        switch (this.Operazione) {
            case 0:
                this.utenteLog = (String)obj[1];
                break;
            case 1:
            case 2:
                this.utenteP = (String)obj[1];
                break;
        }
    }

    @Override
    public ResultSet getResult() {
        ResultSet rs = null;
        String query = "";
        switch (this.Operazione) {
            case 0:
                query = "SELECT i.coordinate_geografiche FROM "
                    + "Book_user u JOIN Indirizzo i ON (u.email=i.Book_user) "
                    + "WHERE u.email='" + this.utenteLog + "' ";
                break;
            case 1: {
                query = "SELECT u.nome, u.cognome, date_part('Year', u.data_nascita) as an, "
                    + "i.coordinate_geografiche, i.citta, i.provincia, i.paese "
                    + "FROM Book_user u JOIN Indirizzo i ON (u.email=i.Book_user) "
                    + "WHERE u.email='" + this.utenteP + "' AND principale=1 ";
            }
            break;
            case 2: query ="SELECT 1, l.id, l.titolo, l.nome_autore, l.cognome_autore, "
                    + "l.casa_ed, l.n_pagine, l.anno_pubblicazione, l.genere, "
                    + "i.coordinate_geografiche, i.citta, i.provincia, i.paese, i.principale "
                    + "FROM Indirizzo i JOIN libro l "
                    + "on (i.coordinate_geografiche=l.coordinate_geografiche and i.Book_User=l.Book_User) "
                    + "WHERE l.disponibilita=1 and "
                    + "l.Book_User = '" + this.utenteP + "' ";
                break;
        }

        try {
            Connection con = Connessione.getConnection();
            // connessione riuscita, ottengo l'oggetto per l'esecuzione dell'interrogazione.
            Statement stmt;
            if(this.Operazione!=2){
            stmt = con.createStatement();
            }else{
            stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);      
            }
            // Verifico che le credenziali inserite siano di un utente "normale"
            rs = stmt.executeQuery(query);
            con.close();
        } catch (ClassNotFoundException | SQLException ex) {
        }
        return rs;
    }
}
