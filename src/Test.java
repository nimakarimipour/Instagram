import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.layout.Border;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.control.Button;

/**
 *  Created by nima on 1/25/17.
 */
public class Test extends Application{

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        Button hello = new Button("hello");
        Button salam = new Button("hello");

        Button b = new Button("Do it");
        b.setOnAction((e) -> System.out.println(hello.equals(salam)));

        HBox box = new HBox(hello, salam, b);

        BorderPane p = new BorderPane(box);

        Scene scene = new Scene(p, 800, 600);
        primaryStage.setScene(scene);
        primaryStage.show();
    }
}
