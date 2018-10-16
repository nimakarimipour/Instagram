import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Pos;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.scene.control.TableView;
import javafx.scene.layout.StackPane;

import java.sql.ResultSet;

/**
 *  Created by nima on 1/23/17.
 */

class QueryTable extends StackPane {

    private TableView table;

    QueryTable(){
        table = new TableView();
        table.setEditable(false);
        this.getChildren().add(table);
        this.setAlignment(Pos.CENTER);
        this.setMinHeight(500);
    }

    @SuppressWarnings("unchecked")
    void showData(ResultSet rs) {
        clear();
        ObservableList<ObservableList> data = FXCollections.observableArrayList();
        try {
            for (int i = 0; i < rs.getMetaData().getColumnCount(); i++) {
                final int j = i;
                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i + 1));
                col.setCellValueFactory(param -> new SimpleStringProperty((
                        (CellDataFeatures<ObservableList, String>) param).getValue().get(j).toString()));
                table.getColumns().addAll(col);
            }
            while (rs.next()) {
                ObservableList<String> row = FXCollections.observableArrayList();
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) row.add(rs.getString(i));
                data.add(row);
            }
            table.setItems(data);
        } catch (Exception e) {
            System.out.println("Exception happened in reading data.");
        }
    }

    @SuppressWarnings("unchecked")
    void clear() {
        table.setItems(FXCollections.observableArrayList());
        table.getColumns().clear();
    }

    String[] getFocusedString(){
        String temp = table.getFocusModel().getFocusedItem().toString();
        return filterSpace(temp.substring(1, temp.length() - 1).split(","));
    }

    private String[] filterSpace(String[] raw){
        String[] ans = new String[raw.length];
        for (int i = 0; i < ans.length; i++) {
            int begin = 0;
            int last = raw[i].length() - 1;
            while (begin < raw[i].length() && raw[i].charAt(begin) == ' ') ++begin;
            while (last > -1 && raw[i].charAt(last) == ' ') --last;
            ans[i] = raw[i].substring(begin, last + 1);
        }
        return ans;
    }
}
