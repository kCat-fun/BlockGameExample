abstract class Item {
    PVector pos;
    PVector vec;
    int id;
    public static final float ITEM_SIZE = 30;

    Item() {
    }

    public void draw() {
    }

    private void update() {
        pos.add(vec);
    }

    private boolean isGet(PVector rp, float rw, float rh) {
        return (rp.x < pos.x && pos.x < rp.x+rw &&
            rp.y < pos.y+ITEM_SIZE/2.0 && pos.y-ITEM_SIZE/2.0/2.0 < rp.y + rh);
    }
}

public class CopyBall extends Item {
    CopyBall(PVector pos) {
        this.id = 0;
        this.pos = pos;
        this.vec = new PVector(0, 5);
    }
    
    public void draw() {
         stroke(255, 100, 100);
         strokeWeight(2);
         noFill();
         circle(pos.x, pos.y, Item.ITEM_SIZE);
         fill(200, 200, 100);
         noStroke();
         rect(pos.x-13, pos.y-2, 26, 4);
         rect(pos.x-2, pos.y-13, 4, 26);
    }
}

public class LongBar extends Item {
    LongBar(PVector pos) {
        this.id = 1;
        this.pos = pos;
        this.vec = new PVector(0, 5);
    }
    
    public void draw() {
         stroke(255, 100, 100);
         strokeWeight(2);
         noFill();
         circle(pos.x, pos.y, Item.ITEM_SIZE);
         fill(50, 150, 50);
         noStroke();
         rect(pos.x-ITEM_SIZE/2.0+2, pos.y-2, ITEM_SIZE-2, 4);
         triangle(pos.x-ITEM_SIZE/2.0+2, pos.y, pos.x-ITEM_SIZE/2.0+8, pos.y-10, pos.x-ITEM_SIZE/2.0+8, pos.y+10);
         triangle(pos.x+ITEM_SIZE/2.0-2, pos.y, pos.x+ITEM_SIZE/2.0-8, pos.y-10, pos.x+ITEM_SIZE/2.0-8, pos.y+10);
    }
}
