import javafx.scene.text.Font;
import javafx.scene.text.Text;

class MaterialText extends Text {

    private void setDefaultFont() {
        setFont(Font.loadFont(getClass().getResourceAsStream("assets/Roboto-Medium.ttf"), (double) 50));
    }

    MaterialText(String text) {
        super(text);
        setDefaultFont();
    }
}
