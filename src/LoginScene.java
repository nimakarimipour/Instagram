import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;

import java.sql.*;

/**
 *  Created by nima on 1/25/17.
 */

class LoginScene extends Scene {

    private ScreenManager screenManager;
    private BorderPane root;
    private PasswordField password;
    private TextField username;
    private Connection c;

    LoginScene(ScreenManager screenManager, Parent root, double width, double height) {
        super(root, width, height);
        this.screenManager = screenManager;
        c = screenManager.getConnection();
        this.root = (BorderPane) root;
        this.root.setPadding(new Insets(20));
        this.root.setStyle("-fx-background-color: rgb(45, 46, 47);");
        setUp();
    }

    private void setUp() {
        Button logIn = new Button("Log in", 120, Color.GREEN);
        logIn.setOnAction((e) -> getConnection());
        logIn.setStyle("-fx-background-color: rgb(132, 179, 42);");
        Button exit = new Button("Exit", 120, Color.RED);
        exit.setOnAction((e) -> Platform.exit());
        exit.setStyle("-fx-background-color: rgb(214, 24, 24);");
        password = new PasswordField();
        password.setPromptText("Password");
        username = new TextField();
        username.setPromptText("Username");
        HBox buttons = new HBox(logIn, exit);
        buttons.setAlignment(Pos.CENTER);
        buttons.setSpacing(20);
        VBox vBox = new VBox(username, password, buttons);
        vBox.setSpacing(30);
        vBox.setAlignment(Pos.CENTER);
        root.setCenter(vBox);
    }

    private void getConnection() {
        try {
            PreparedStatement s = c.prepareStatement("select * from account_information where username_id = '" +
            username.getText() + "' and password = '" + password.getText() + "';");
            ResultSet rs = s.executeQuery();
            if (rs.next()){
                System.out.println("user: " + username.getText() + " with password: " + password.getText() + " logged in");
                screenManager.userLoggedIn(username.getText(), password.getText());
            }
        } catch (SQLException e) {
            System.out.println("Could'nt connect to server.");
            username.setText("");
            password.setText("");
            username.setPromptText("Wrong username or password");
            e.printStackTrace();
        }
    }
}