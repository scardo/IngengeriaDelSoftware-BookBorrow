/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package it.bookBorrow.geolocalizzazione;

import it.elbuild.jcoord.LatLng;
import it.elbuild.jcoord.resolver.GeoCodeResolver;
import java.math.BigDecimal;

/**
 *
 * @author insan3
 */
public class Geolocalizzazione {

    public static String getCoordinate(String indirizzo) {
        LatLng coord = null;
        BigDecimal lat = null;
        BigDecimal lon = null;
        int count = 0;
        do {
            try {
                count++;

                coord = GeoCodeResolver.findCoordForAddress(indirizzo);

                lat = coord.getLat();
                lon = coord.getLng();

            } catch (NullPointerException e) {
                count++;
            }
        } while (!(coord instanceof LatLng) || count <= 10);

        return lat + " " + lon;
    }

    public static double getDistance(String coord1, String coord2) {
        //spiegazione matematica--> http://www.robertobigoni.it/Matematica/Sferica/sferica.html
        
        LatLng c1 = new LatLng(new BigDecimal(coord1.split(" ")[0]), new BigDecimal(coord1.split(" ")[1]));
        LatLng c2 = new LatLng(new BigDecimal(coord2.split(" ")[0]), new BigDecimal(coord2.split(" ")[1]));

        double out;
        
        double R = 6371; //raggio terrestre medio

        double lat_c1, lat_c2, lon_c1, lon_c2;
        
        double fi;
      
       
        //converto coordinate in radianti double così da poter applicare la formula
        lat_c1 = Math.PI * c1.getLat().doubleValue() / 180;
        lat_c2 = Math.PI * c2.getLat().doubleValue() / 180;
        lon_c1 = Math.PI * c1.getLng().doubleValue() / 180;
        lon_c2 = Math.PI * c2.getLng().doubleValue() / 180;

       
        fi = Math.abs(lon_c1 - lon_c2); //calcolo angolo tra due punti
      
        out =R* (Math.acos(Math.sin(lat_c2) * Math.sin(lat_c1)+ Math.cos(lat_c2) * Math.cos(lat_c1) * Math.cos(fi)));
           
        out=((double)((int)(out*10)))/10;
        return out;
    }

}
