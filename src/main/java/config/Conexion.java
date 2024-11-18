package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    private static final String username = "sql10745574";
    private static final String password = "4nzk1SMm11";
    private static final String database = "sql10745574";
    private static final String url = "jdbc:mysql://sql10.freemysqlhosting.net/" + database;

    public static Connection getConnection() {
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);
            System.out.println("Conexion establecida");
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return conn;
    }
}
