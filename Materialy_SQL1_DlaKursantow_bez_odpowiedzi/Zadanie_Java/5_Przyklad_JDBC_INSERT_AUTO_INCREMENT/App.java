import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

public class App {
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
			if (connection == null) {{
				System.out.println("Polaczenie nieudane");
				return;
			}
			
			String sql = "INSERT INTO straznik(imie, nazwisko, stopien, pensja,skladka_na_ubezpieczenie) VALUE (?,?,?,?,?)";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, "Jan1");
            ps.setString(2, "Jezioranski");
            ps.setString(3, "Szeregowiec");
            ps.setDouble(4, 2300.32);
            ps.setDouble(5, 10);
            ps.executeUpdate();

            int key =-1;
            ResultSet rs = ps.getGeneratedKeys();
            if (rs != null && rs.next()) {
                key = rs.getInt(1);
                System.out.println("Pobrana wartosc auto_incrementa = " + key);
            }

        } catch (SQLException e) {

            System.out.println("Blad polaczenia do bazy danych");
            e.printStackTrace();
            return;

        }

    
    }
}
