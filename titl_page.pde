public class Title implements Page {
    private KButton startButton;
    private KButton exitButton;
    private final int BUTTON_W = 150;
    private final int BUTTON_H = 60;

    Title() {
        startButton = new KButton(this, "start", width/4-BUTTON_W/2, 400, BUTTON_W, BUTTON_H, 15);
        startButton.set
            .buttonColor(color(110), color(50))
            .buttonHoverColor(color(170))
            .label("START", 15)
            .align(CENTER, CENTER)
            .labelColor(color(230, 230, 255));
        exitButton = new KButton(this, "exit", (width*(3.0/4.0))-BUTTON_W/2, 400, BUTTON_W, BUTTON_H, 15);
        exitButton.set
            .buttonColor(color(110), color(50))
            .buttonHoverColor(color(170))
            .label("EXIT", 15)
            .align(CENTER, CENTER)
            .labelColor(color(230, 230, 255));
    }

    void setup() {
        startButton.visible(true);
        exitButton.visible(true);
        bgTriangleEffect.triangleFill(color(100));
    }

    void draw() {
        background(255, 200, 170);
        bgTriangleEffect.draw();
        fill(0, 100);
        rect(50, 50, width-100, 150);
        fill(255, 200);
        textAlign(CENTER, CENTER);
        textSize(50);
        text("Block Game", width/2.0, 125);
    }

    void update() {
    }

    void keyPressed() {
    }

    void mousePressed() {
    }

    void clickButtonEvent(String e) {
        switch(e) {
        case "start":
            app.setPageNum(1);
            startButton.visible(false);
            exitButton.visible(false);
            break;
        case "exit":
            exit();
            break;
        }
    }
}
