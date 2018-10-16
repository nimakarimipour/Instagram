import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

import java.sql.Connection;

/**
 *  Created by nima on 1/25/17.
 */
class ScreenManager {

    private QueryScene queryScene;
    private UserScene userScene;
    private LoginScene loginScene;
    private Stage stage;

    private Connection c;

    ScreenManager(Instagram instagram, Stage stage, Connection c){
        this.stage = stage;
        this.c = c;
        setUpLoginScene();
        setUpQueryScene();
        setUpUserScene();
    }

    private void setUpUserScene() {
        userScene = new UserScene(this, new BorderPane(), 1000, 700);
    }

    private void setUpQueryScene() {
        queryScene = new QueryScene(this, new BorderPane(), 1000, 700);
    }

    private void setUpLoginScene() {
        loginScene = new LoginScene(this, new BorderPane(), 300, 220);
    }

    void showLogInScene(){
        stage.setScene(loginScene);
        stage.setFullScreen(false);
        stage.show();
    }

    void showQueryScene(){
        stage.setScene(queryScene);
        stage.setFullScreen(true);
        stage.show();
    }

    Connection getConnection() {
        return c;
    }

    void showUserScene() {
        stage.setScene(userScene);
        stage.setFullScreen(true);
        stage.show();
    }

    void userLoggedIn(String username, String password) {
        userScene.logInUser(username, password);
        showQueryScene();
    }
}
