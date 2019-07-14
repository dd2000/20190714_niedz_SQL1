package sda.kurs;


/*
 *   JDBC  Polczenie do bazy
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

public class App
{
    private static Connection connection = null;
    private static Statement st = null;
    private static ResultSet rs = null;

    public static void main(String[] argv) {

        System.out.println("----Test polaczenia do bazy MySQL --------");

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {

            System.out.println("Nie znaleziono drivera MySQL");
            e.printStackTrace();
            return;

        }

        System.out.println("MySQL JDBC Driver zarejestrowany");

        Connection connection = null;

        try {

            connection = DriverManager.getConnection("jdbc:mysql://localhost/kontrola", "root", "mysql");
            if (connection == null) {
                System.out.println("Polaczenie nieudane");
                return;
            }

            PreparedStatement pst = null;
            String stm = "INSERT INTO straznik(imie,nazwisko,stopien,pensja) VALUES(?, ?,?,?)";
            pst = connection.prepareStatement(stm);

            pst.setString(1, "Jan");
            pst.setString(2, "Jeziorañski");
            pst.setString(3, "Szeregowiec");
            pst.setDouble(4, 2300.32);
            pst.executeUpdate();


        } catch (SQLException e) {

            System.out.println("Blad polaczenia do bazy danych");
            e.printStackTrace();
            return;

        }

    }

}