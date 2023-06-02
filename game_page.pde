public class Game implements Page {
    private int[][] blocks;
    private final color[] BLOCK_COLOR = new color[] {
        color(200),
        color(100),
    };
    private final int BLOCKS_ROW = 5;
    private final int BLOCKS_COL = 10;
    private PVector BALL_VEC = new PVector(3, 3);
    private int block_w;
    private int block_h;
    private ArrayList<Ball> balls;
    private Racket racket;
    private int situation;
    private boolean pressFlag;
    private ArrayList<Item> items;

    private class Situation {
        static final int Waiting = 1;
        static final int Playing = 2;
        static final int Clear = 3;
        static final int Over = 4;
    };

    Game() {
    }

    void setup() {
        items = new ArrayList<Item>();
        pressFlag = false;
        situation = Situation.Waiting;
        bgTriangleEffect.triangleFill(color(255));
        balls = new ArrayList<Ball>();
        balls.add(new Ball(width/2, 550-Ball.SIZE/2.0, BALL_VEC.x*(random(1) < 0.5 ? 1 : -1), -BALL_VEC.y));
        racket = new Racket(width/2, 550, 100, 5);
        block_w = (width-50)/BLOCKS_COL;
        block_h = 25;
        blocks = new int[BLOCKS_ROW][BLOCKS_COL];
        for (int i=0; i<blocks.length; i++) {
            for (int j=0; j<blocks[i].length; j++) {
                blocks[i][j] = 2;
            }
        }
    }

    void draw() {
        background(180, 220, 255);
        bgTriangleEffect.draw();

        textAlign(CENTER, CENTER);
        fill(255, 100, 100);
        textSize(30);

        switch(situation) {
        case Situation.Waiting:
            if (mousePressed) situation = Situation.Playing;
            text("Click to Start", width/2, height/2);
            break;
        case Situation.Playing:
            update();
            if (isClear())
                situation = Situation.Clear;
            if (isOver())
                situation = Situation.Over;
            break;
        case Situation.Clear:
            text("Game Clear", width/2, height/2);
            restart();
            break;
        case Situation.Over:
            text("Game Over", width/2, height/2);
            restart();
            break;
        }

        drawBlocks();
        if (balls.size() > 0) {
            for (Ball b : balls) {
                b.draw(situation);
            }
        }
        racket.draw(situation);
    }

    void update() {
        drawItem();
        reflectionRacketBall();
        reflectionBlocksBall();
    }

    private void drawItem() {
        if (items.size() <= 0) return;
        for (Item i : items) {
            i.draw();
            i.update();
        }
        int i = 0;
        while (i < items.size()) {
            if (items.get(i).isGet(racket.getPos(), racket.getSize().x, racket.getSize().y)) {
                switch(items.get(i).id) {
                case 0:
                    balls.add(new Ball(racket.getPos().x+racket.getSize().x/2.0, 550-Ball.SIZE/2.0, BALL_VEC.x*(random(1) < 0.5 ? 1 : -1), -BALL_VEC.y));
                    break;
                case 1:
                    racket.longItem();
                    break;
                }
                items.remove(i);
                i--;
            }
            i++;
        }
    }

    private void restart() {
        textSize(20);
        text("Click to Restart", width/2, height/2+50);
        text("Q Press to Title", width/2, height/2+70);
        if (keyCode == 'Q' && keyPressed) app.setPageNum(0);
        if (mousePressed) pressFlag = true;
        if (pressFlag && !mousePressed) setup();
    }

    private void drawBlocks() {
        strokeWeight(1);
        stroke(0);
        for (int i=0; i<blocks.length; i++) {
            for (int j=0; j<blocks[i].length; j++) {
                if (0 < blocks[i][j]) {
                    fill(BLOCK_COLOR[blocks[i][j]-1]);
                    rect(25+j*block_w, 25+i*block_h, block_w, block_h);
                }
            }
        }
    }

    void keyPressed() {
    }

    void mousePressed() {
    }

    private boolean isClear() {
        for (int i=0; i<blocks.length; i++) {
            for (int j=0; j<blocks[i].length; j++) {
                if (blocks[i][j] > 0)
                    return false;
            }
        }
        return true;
    }

    private boolean isOver() {
        int i=0;
        while (i < balls.size()) {
            if (balls.get(i).getPos().y-Ball.SIZE > height) {
                balls.remove(i);
                i--;
            }
            i++;
        }
        return balls.size() <= 0;
    }

    private void reflectionRacketBall() {
        for (Ball ball : balls) {
            PVector rp = racket.getPos(); // ravket pos = rp
            PVector bp = ball.getPos();   // ball pos = bp
            float rw = racket.getSize().x;
            float rh = racket.getSize().y;
            if (rp.x < bp.x && bp.x < rp.x+rw &&
                rp.y < bp.y+Ball.SIZE/2.0 && bp.y-Ball.SIZE/2.0 < rp.y + rh) {
                if (bp.x < rp.x+rw/3.0)
                    ball.setVec(new PVector(-abs(BALL_VEC.x), -(ball.getVec().y < 0 ? -1 : 1)*BALL_VEC.y));
                else if (bp.x < rp.x+rw*(2.0/3.0))
                    ball.setVec(new PVector(0, -(ball.getVec().y < 0 ? -1 : 1)*BALL_VEC.y*sqrt(2)));
                else
                    ball.setVec(new PVector(abs(BALL_VEC.x), -(ball.getVec().y < 0 ? -1 : 1)*BALL_VEC.y));
            }
        }
    }

    private void reflectionBlocksBall() {
        for (Ball ball : balls) {
            PVector bp = ball.getPos();   // ball pos = bp
            for (int i=0; i<blocks.length; i++) {
                for (int j=0; j<blocks[i].length; j++) {
                    float bx = 25+j*block_w; // bx = block_x
                    float by = 25+i*block_h; // by = block_y
                    if (0 < blocks[i][j] && bx < bp.x && bp.x <= bx+block_w &&
                        by < bp.y+Ball.SIZE/2.0 && bp.y-Ball.SIZE/2.0 <= by+block_h) {
                        ball.setVec(new PVector(ball.getVec().x, -ball.getVec().y));
                        ball.update();
                        blocks[i][j]--;
                        particles.drawing(bx + block_w/2.0, by + block_h/2.0);
                        if (random(1) > 0.2) continue;
                        if (blocks[i][j] == 0) {
                            switch(floor(random(2))) {
                            case 0:
                                items.add(new CopyBall(new PVector(bx + block_w/2.0, by + block_h/2.0)));
                                break;
                            case 1:
                                items.add(new LongBar(new PVector(bx + block_w/2.0, by + block_h/2.0)));
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    private class Ball {
        private PVector pos;
        private PVector[] shadow = new PVector[10];
        private PVector vec;
        private static final float SIZE = 20;
        private final color COLOR = color(240, 210, 50);

        private Ball(float x, float y, float vx, float vy) {
            for (int i=0; i<shadow.length; i++) {
                this.shadow[i] = new PVector(x, y);
            }
            this.pos = new PVector(x, y);
            this.vec = new PVector(vx, vy);
        }

        public PVector getPos() {
            return pos;
        }

        public PVector getVec() {
            return vec;
        }

        public void setVec(PVector vec) {
            this.vec = vec;
        }

        private void draw(int situ) {
            if (situ == Situation.Playing)
                update();
            float i = 1;
            noStroke();
            for (PVector s : shadow) {
                fill(COLOR, map(i, 1, shadow.length, 200, 10));
                circle(s.x, s.y, SIZE / map(i, 1, shadow.length, 1.5, 3));
                i+=1;
            }
            fill(COLOR, 255);
            circle(pos.x, pos.y, SIZE);
        }

        private void update() {
            pos.add(vec);
            if (pos.x < SIZE/2.0 || width-SIZE/2.0 < pos.x) {
                vec.x *= -1;
                pos.add(vec);
            }
            if (pos.y < SIZE/2.0) {
                vec.y *= -1;
                pos.add(vec);
            }

            for (int i=shadow.length-1; i>0; i--) {
                shadow[i] = shadow[i-1];
            }
            shadow[0] = new PVector(pos.x, pos.y);
        }
    }

    private class Racket {
        private PVector pos;
        private float w;
        private float initW;
        private float h;
        private final color COLOR = color(50, 200, 100);
        private final long ITEM_TIME = 4000;
        private long itemGetTime = -ITEM_TIME;

        private Racket(float x, float y, float w, float h) {
            this.pos = new PVector(x-w/2.0, y);
            this.w = w;
            this.initW = w;
            this.h = h;
        }

        public PVector getPos() {
            return pos;
        }

        public PVector getSize() {
            return new PVector(w, h);
        }

        private void draw(int situ) {
            if (situ == Situation.Playing)
                update();
            noStroke();
            fill(COLOR);
            rect(pos.x, pos.y, w, h);
        }

        private void update() {
            if (ITEM_TIME < millis() - itemGetTime)
                w = initW;
            pos.x = constrain(mouseX-w/2.0, 0, width-w);
        }

        private void longItem() {
            itemGetTime = millis();
            w = initW*1.5;
        }
    }
}
