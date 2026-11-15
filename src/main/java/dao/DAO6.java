package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO6 implements AutoCloseable {
	private Connection con;

	public DAO6() {
		java.util.Properties config = new java.util.Properties();
		try (java.io.InputStream input = DAO6.class.getResourceAsStream("/database.properties")) {
			if (input != null) {
				config.load(input);
			}
			String dbUrl = System.getenv().getOrDefault("DB_URL", config.getProperty("db.url",
					"jdbc:mysql://localhost:3306/restaurant_db?useUnicode=true&characterEncoding=UTF-8"));
			String dbUser = System.getenv().getOrDefault("DB_USER", config.getProperty("db.user", "root"));
			String dbPassword = System.getenv().getOrDefault("DB_PASSWORD", config.getProperty("db.password", ""));
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected Connection getConnection() {
		return con;
	}

	@Override
	public void close() throws java.sql.SQLException {
		if (con != null) {
			con.close();
		}
	}
}
