import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.geometry.Pos;
import javafx.scene.input.MouseEvent;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.util.Duration;

/**
 *  Created by tareq on 7/13/15.
 */
class Button extends javafx.scene.control.Button {
    private double radiusSize = 0;
    private double rippleSpeed = 3;
    private String label;

    Button(String text, int minWidth, Color color) {
        super("", new MaterialText(text));
        this.label = text;
        setAlignment(Pos.CENTER);
        setUp(minWidth, color);
    }

    private void setUp(int minWidth, Color color) {
        sceneProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                if (!getScene().getStylesheets().contains(getClass().getResource("application.css").toExternalForm()))
                    getScene().getStylesheets().add(getClass().getResource("application.css").toExternalForm());
            }
        });
        getStyleClass().add("material-button");
        addEventHandler(MouseEvent.MOUSE_CLICKED, e -> {

            Rectangle r = new Rectangle(getWidth(), getHeight());
            prefHeightProperty().addListener(ev -> r.setHeight(getHeight()));
            Circle ripple = new Circle(7.5);
            ripple.setClip(r);
            ripple.setFill(color);
            ripple.setCenterX(e.getX());
            ripple.setCenterY(e.getY());
            ripple.setOpacity(0.2);
            ripple.setVisible(false);
            animateRipple(ripple, color);
            getChildren().add(0, ripple);
        });
        setMinWidth(minWidth);
        setMinHeight(50);
    }

    private void animateRipple(Circle ripple, Color color) {
        ripple.setVisible(true);
        ripple.setFill(color);
        Timeline anim = new Timeline(new KeyFrame(Duration.millis(10), ev -> ripple.setRadius(radiusSize += rippleSpeed)));
        anim.setCycleCount(50);
        anim.setOnFinished(ev2 -> {
            radiusSize = 7.5;
            ripple.setRadius(radiusSize);
            ripple.setVisible(false);
        });
        anim.play();
    }

    private String getLabel(){
        return label;
    }

    public boolean equals(Object o){
        if(o == null) return false;
        if(! o.getClass().equals(this.getClass())) return false;
        Button other = (Button) o;
        return this.getLabel().equals(other.getLabel());
    }
}
