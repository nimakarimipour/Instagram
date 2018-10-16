import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;

import java.sql.*;
import java.util.ArrayList;

/**
 *  Created by nima on 1/25/17.
 */

class UserScene extends Scene {

    private ScreenManager screenManager;
    private BorderPane root;
    private QueryTable table;
    private Connection c;

    private String username, password;
    private String currentUsername;
    private int currentPostID;

    private boolean followingsIsShown, followersIsShown, commentsIsShown, pageIsShown, othersIsShown, requestIsShown;
    private Button home, viewComments, viewFollowers, viewFollowings, viewPage, like, follow, unfollow, block, comment,
            addPost, removePost, accept, decline, unlike, unblock, viewOthers, viewLikes, viewRequests;
    private ArrayList<Button> buttons;
    private GridPane buttonPanel;

    private TextField field;

    UserScene(ScreenManager screenManager, Parent root, double width, double height) {
        super(root, width, height);
        this.screenManager = screenManager;
        this.root = (BorderPane) root;
        field = new TextField();
        field = new TextField();
        buttons = new ArrayList<>();
        c = screenManager.getConnection();
        setUp();
    }

    private void setUp() {
        setUpButtons();
        setUpPanel();
    }

    private void setUpPanel() {
        table = new QueryTable();
        table.getStyleClass().add("application.css");
        root.setCenter(table);
        StackPane pane = new StackPane(field);
        field.setStyle("-fx-background-color: rgb(24, 159, 237);-fx-text-fill: white;");
        pane.setPadding(new Insets(0, 40, 20, 40));
        pane.setStyle("-fx-background-color: rgb(45, 46, 47);");
        VBox box = new VBox(buttonPanel, pane);
        box.setStyle("\"-fx-background-color: rgb(45, 46, 47);\"");
        root.setTop(box);
    }

    private void setUpButtons() {
        buttonPanel = new GridPane();
        buttonPanel.setAlignment(Pos.CENTER);
        buttonPanel.setPadding(new Insets(20));
        buttonPanel.setStyle("-fx-background-color: rgb(45, 46, 47);");

        int minWidth = 100;

        home = new Button("Home", minWidth, Color.BLUE);
        addButton(home, 0, 0, e -> goHome());

        viewComments = new Button("Comments", minWidth, Color.BLUE);
        addButton(viewComments, 1, 0, e -> viewComments());

        viewFollowers = new Button("Followers", minWidth, Color.BLUE);
        addButton(viewFollowers, 2, 0, e -> viewFollowers());

        viewFollowings = new Button("Following", minWidth, Color.BLUE);
        addButton(viewFollowings, 3, 0, e -> viewFollowing());

        viewPage = new Button("ViewPage", minWidth, Color.BLUE);
        addButton(viewPage, 4, 0, e -> viewPage());

        like = new Button("Like", minWidth, Color.BLUE);
        addButton(like, 5, 0, e -> likePost());

        follow = new Button("Follow", minWidth, Color.BLUE);
        addButton(follow, 6, 0, e -> follow());

        unfollow = new Button("Unfollow", minWidth, Color.BLUE);
        addButton(unfollow, 7, 0, e -> unfollow());

        block = new Button("Block", minWidth, Color.BLUE);
        addButton(block, 8, 0, e -> block());

        comment = new Button("Comment", minWidth, Color.BLUE);
        addButton(comment, 9, 0, e -> comment());

        addPost = new Button("AddPost", minWidth, Color.BLUE);
        addButton(addPost, 10, 0, e -> addPost());

        removePost = new Button("DelPost", minWidth, Color.BLUE);
        addButton(removePost, 0, 1, e -> removePost());

        accept = new Button("Accept", minWidth, Color.BLUE);
        addButton(accept, 1, 1, e -> accept());

        decline = new Button("Decline", minWidth, Color.BLUE);
        addButton(decline, 2, 1, e -> decline());

        unlike = new Button("Unlike", minWidth, Color.BLUE);
        addButton(unlike, 3, 1, e -> unlike());

        unblock = new Button("Unblock", minWidth, Color.BLUE);
        addButton(unblock, 4, 1, e -> unblock());

        viewOthers = new Button("Others", minWidth, Color.BLUE);
        addButton(viewOthers, 5, 1, e -> viewOthers());

        viewLikes = new Button("Likers", minWidth, Color.BLUE);
        addButton(viewLikes, 6, 1, e -> viewLikes());

        viewRequests = new Button("Requests", minWidth, Color.BLUE);
        addButton(viewRequests, 7, 1, e -> viewRequests());

        Button toggle = new Button("Toggle", minWidth, Color.BLUE);
        addButton(toggle, 0, 2, e -> screenManager.showQueryScene());
    }

    private void viewLikes() {
        if (pageIsShown) {
            resetPageStatus();
            setAbility(true, home, viewPage);
            currentPostID = Integer.parseInt(table.getFocusedString()[1]);
            String query = "select * from like_post where Rec_user = '" + currentUsername + "' and post_id = "
                    + currentPostID + ";";
            table.showData(getQuery(query));
        }
    }

    private void viewOthers() {
        repairField("");
        resetPageStatus();
        othersIsShown = true;
        String query = "select * from userr;";
        table.showData(getQuery(query));
        setAbility(true, viewPage, follow, block, home, unblock);
    }

    private void unblock() {
        if(othersIsShown){
            String target = table.getFocusedString()[0];
            String query = "delete from block where username1_id = '" + username + "' and username2_id = '" + target + "';";
            executeQuery(query);
        }
    }

    private void unlike() {
        if (pageIsShown) {
            currentPostID = Integer.parseInt(table.getFocusedString()[1]);
            String query = "delete from like_post where liker_user = '" + username + "' and " +
                    "rec_user = '" + currentUsername + "' and post_id = " + currentPostID + ";";
            executeQuery(query);
        }
    }

    private void decline() {
        if (requestIsShown) {
            String target = table.getFocusedString()[0];
            String removeQuery = "delete from request where username1 = '" + target + "';";
            executeQuery(removeQuery);
        }
    }

    private void accept() {
        if (requestIsShown) {
            String target = table.getFocusedString()[0];
            String query = "insert into follow (username1, username2, \"date\") values('" + target + "', '" + username + "', now());";
            String removeQuery = "delete from request where username1 = '" + target + "';";
            executeQuery(query);
            executeQuery(removeQuery);
        }
    }

    private void removePost() {
        if (currentUsername.equals(username) && pageIsShown) {
            int post_id = Integer.parseInt(table.getFocusedString()[1]);
            String query = "delete from post where username_id = '" + username + "' and post_id = " + post_id + ";";
            executeQuery(query);
        }
    }

    private void addPost() {
        if (currentUsername.equals(username) && pageIsShown) {
            String[] inputs = field.getText().split("#");
            String query = "insert into post(username_id, \"date\", num_of_cms, \"location\", num_of_likes, caption) values('" + username + "', now(), 0, '" + inputs[1] + "', 0, '" + inputs[0] + "');";
            executeQuery(query);
            field.setText("");
        }
    }

    private void comment() {
        if (commentsIsShown) {
            String query = "insert into comment(sender_user, rec_user, post_id, \"date\",num_of_likes, text ) values('" + username + "', '" + currentUsername + "', " + currentPostID +
                    ", now(), 0, '" + field.getText() + "');";
            executeQuery(query);
            field.setText("");
        }
    }

    private void block() {
        String target = "";
        if (pageIsShown) target = currentUsername;
        if (followersIsShown) target = table.getFocusedString()[0];
        if (followingsIsShown) target = table.getFocusedString()[1];
        if (othersIsShown) target = table.getFocusedString()[0];
        if (requestIsShown) target = table.getFocusedString()[0];
        String query = "insert into block values('" + username + "', '" + target + "');";
        executeQuery(query);
    }

    private void follow() {
        String target = "";
        if (pageIsShown) target = currentUsername;
        if (followersIsShown) target = table.getFocusedString()[0];
        if (followingsIsShown) target = table.getFocusedString()[1];
        if (othersIsShown) target = table.getFocusedString()[0];
        if (requestIsShown) target = table.getFocusedString()[0];
        ResultSet r = getQuery("select privacy from account_information where username_id = '" + target + "';");
        try {
            String query;
            boolean isPublic;
            if (r != null) {
                r.next();
                isPublic = !(r.getBoolean(1));
                if (isPublic)
                    query = "insert into follow (username1, username2, \"date\") values('" + username + "', '" + target + "', now());";
                else
                    query = "insert into request (username1, username2, \"date\") values('" + username + "', '" + target + "', now());";
                executeQuery(query);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void unfollow() {
        String target = "";
        if (pageIsShown) target = currentUsername;
        if (followersIsShown) target = table.getFocusedString()[0];
        if (followingsIsShown) target = table.getFocusedString()[1];
        if (othersIsShown) target = table.getFocusedString()[0];
        String query = "delete from follow where username1 = '" + username + "' and username2 = '" + target + "';";
        executeQuery(query);
    }

    private void likePost() {
        if (pageIsShown) {
            currentPostID = Integer.parseInt(table.getFocusedString()[1]);
            String query = "insert into like_post(liker_user, rec_user, post_id, \"date\") values('" + username + "', '" + currentUsername + "', " + currentPostID + ", now());";
            executeQuery(query);
        }
    }

    private void goHome() {
        repairField("Post With Format: caption#Location.");
        resetPageStatus();
        pageIsShown = true;
        currentUsername = username;
        setAbility(false, comment, accept, decline, unblock, viewPage, follow, unfollow, block);
        showAllPosts(username);
        addPost.setDisable(false);
        removePost.setDisable(false);
    }

    private void viewRequests() {
        resetPageStatus();
        requestIsShown = true;
        setAbility(true, accept, decline, home, viewPage, block);
        String query = "select * from request where username2 = '" + username + "';";
        table.showData(getQuery(query));
    }

    private void viewPage() {
        if (followingsIsShown) currentUsername = table.getFocusedString()[1];
        if (followersIsShown) currentUsername = table.getFocusedString()[0];
        if (commentsIsShown) currentUsername = table.getFocusedString()[0];
        if (othersIsShown) currentUsername = table.getFocusedString()[0];
        setAbility(false, comment, accept, decline, unblock, addPost, removePost);
        if (currentUsername.equals(username)) goHome();
        else {
            ResultSet r = getQuery("select * from account_information where (username_id = '" +
                    currentUsername + "' and privacy = false) or '" + currentUsername + "' in (select username2 from follow " +
                    "where username1 = '" + username + "');");
            repairField("");
            resetPageStatus();
            pageIsShown = true;
            if (isEmpty(r)) table.clear();
            else showAllPosts(currentUsername);
        }
    }

    private void viewFollowing() {
        repairField("");
        resetPageStatus();
        followingsIsShown = true;
        setAbility(true, home, viewPage, follow, unfollow, block, viewOthers, viewFollowers);
        String query = "select * from \"follow\" where username1 = '" + currentUsername + "';";
        table.showData(getQuery(query));
    }

    private void viewFollowers() {
        repairField("");
        resetPageStatus();
        followersIsShown = true;
        setAbility(true, home, viewPage, follow, unfollow, block, viewOthers, viewFollowings);
        String query = "select * from \"follow\" where username2 = '" + currentUsername + "';";
        table.showData(getQuery(query));
    }

    private void viewComments() {
        resetPageStatus();
        commentsIsShown = true;
        repairField("Enter Comment here.");
        int post_id = Integer.parseInt(table.getFocusedString()[1]);
        String query = "select * from \"comment\" where post_id = " + post_id + ";";
        currentPostID = post_id;
        table.showData(getQuery(query));
        setAbility(true, home, viewPage, comment, viewOthers, like);
    }


    void logInUser(String username, String password) {
        this.username = username;
        this.password = password;
        currentUsername = username;
        goHome();
    }


    private void showAllPosts(String username) {
        String query = "select * from post where username_id = '" + username + "';";
        table.showData(getQuery(query));
        currentUsername = username;
    }

    private ResultSet getQuery(String query) {
        try {
            PreparedStatement s = c.prepareStatement(query);
            return s.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void executeQuery(String query) {
        try {
            Statement s = c.createStatement();
            s.execute(query);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private StackPane wrapNode(Node node) {
        StackPane pane = new StackPane(node);
        pane.setAlignment(Pos.CENTER);
        pane.setPadding(new Insets(10, 5, 10, 5));
        pane.setStyle("-fx-background-color: rgb(45, 46, 47);");
        return pane;
    }

    private void addButton(Button button, int columnIndex, int rowIndex, EventHandler<ActionEvent> eventHandler) {
        button.setOnAction(eventHandler);
        buttonPanel.add(wrapNode(button), columnIndex, rowIndex);
        if (!buttons.contains(button)) buttons.add(button);
        button.setStyle("-fx-background-color: rgb(24, 159, 237);");
    }

    private void setAbility(boolean isActive, Button... buttons) {
        for (Button b : this.buttons) {
            if (contains(buttons, b)) b.setDisable(!isActive);
            else b.setDisable(isActive);
        }
    }

    private void resetPageStatus() {
        requestIsShown = othersIsShown = pageIsShown = commentsIsShown = followersIsShown = followingsIsShown = false;
    }

    private void repairField(String s) {
        field.setText("");
        if (s.equals("")) {
            field.setPromptText("nothing to do.");
            field.setDisable(true);
        } else {
            field.setPromptText(s);
            field.setDisable(false);
        }
    }

    private boolean contains(Button[] buttons, Button button) {
        for (Button button1 : buttons) if (button1.equals(button)) return true;
        return false;
    }

    private boolean isEmpty(ResultSet rs){
        try {
            return !rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }
}
