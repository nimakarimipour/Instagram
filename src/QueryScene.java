import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.TextArea;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import org.postgresql.util.PSQLException;

import java.sql.*;

/**
 *  Created by nima on 1/25/17.
 */

class QueryScene extends Scene {

    private QueryTable table;
    private BorderPane root;
    private TextArea textField;
    private ScreenManager screenManager;

    QueryScene(ScreenManager screenManager, Parent root, double width, double height) {
        super(root, width, height);
        this.screenManager = screenManager;
        this.root = (BorderPane) root;
        makeButtons();
        makePanel();
    }

    private void makeButtons() {
        HBox box = new HBox();
        box.setSpacing(20);
        Button showButton = new Button("Execute", 650, Color.rgb(132, 179, 42));
        showButton.setOnAction((e) -> execute());
        Button clearButton = new Button("Clear", 400, Color.rgb(24, 159, 237));
        clearButton.setOnAction((e) -> clear());
        Button exitButton = new Button("Exit", 80, Color.RED);
        exitButton.setOnAction((e) -> Platform.exit());
        Button toggleButton = new Button("Toggle", 70, Color.BLUE);
        toggleButton.setOnAction((e) -> screenManager.showUserScene());
        box.getChildren().addAll(showButton, clearButton, exitButton, toggleButton);
        box.setAlignment(Pos.CENTER);
        StackPane pane = new StackPane(box);
        pane.setAlignment(Pos.CENTER);
        pane.setPadding(new Insets(20));
        pane.setStyle("-fx-background-color: rgb(45, 46, 47);");
        root.setTop(pane);
    }

    private void clear() {
        textField.setText("");
        textField.setPromptText("Write your query here.");
        table.clear();

    }

    private void makePanel() {
        VBox box = new VBox();
        box.setAlignment(Pos.BOTTOM_CENTER);
        box.setSpacing(20);
        box.setStyle("-fx-background-color: rgb(45, 46, 47);");
        textField = new TextArea();
        textField.setPromptText("Write your query here.");
        table = new QueryTable();
        box.getChildren().addAll(textField, table);
        box.setPadding(new Insets(0, 20, 10, 20));
        root.setCenter(box);
    }

    private void execute(){
        Connection c = screenManager.getConnection();
        String text = textField.getText().toLowerCase();
        if(text.equals("")) return;
        try{
            if(text.startsWith("select")) {
                PreparedStatement s = c.prepareStatement(textField.getText());
                ResultSet rs = s.executeQuery();
                table.showData(rs);
                textField.setPromptText("Write your query here.");
            }else {
                Statement s = c.createStatement();
                s.execute(text);
                textField.setPromptText("Successfully executed query.");
                textField.setText("");
                table.clear();
            }
        } catch (PSQLException e){
            System.out.println("PSQL Exception");
            System.out.println(e.getServerErrorMessage());
            textField.setPromptText("Syntax Error. Try again.\nError Message from server: \n" + e.getServerErrorMessage());
            textField.setText("");
        }
        catch (SQLException e) {
            System.out.println("Error happened.\nCannot show the datas.");
            textField.setPromptText("Error happened, Can'not show the datas.");
            textField.setText("");
            e.printStackTrace();
        }
    }
}
