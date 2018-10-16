import java.sql.*;
import java.util.Properties;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.stage.Stage;

public class Instagram extends Application{

    private Connection c;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void init() throws Exception {
        super.init();
        try {
            Class.forName("org.postgresql.Driver");
            Properties properties = new Properties();
            properties.setProperty("user", "postgres");
            properties.setProperty("password", "k");
            c = DriverManager.getConnection("jdbc:postgresql://localhost:5432/Instagram", properties);
        } catch (ClassNotFoundException e) {
            System.out.println("Class Not found exception");
        } catch (SQLException e) {
            System.out.println("Could'nt connect to server.");
            Platform.exit();
            e.printStackTrace();
        }
    }

    @Override
    public void start(Stage stage) throws Exception {
        ScreenManager screenManager = new ScreenManager(this, stage, c);
        screenManager.showLogInScene();
    }

    @Override
    public void stop() throws Exception {
        super.stop();
        if(c != null) c.close();
    }
}