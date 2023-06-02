/*--------------------------------------------------
 背景三角形エフェクトライブラリ
 制作者：kCat
 制作日：2023/1/20
 バージョン：ver1.1
 --------------------------------------------------*/

class BgTriangleEffect {
    private Triangle[] tri;
    private int tri_len = 50;
    private color bg_effect_color;
    private final float TRI_SIZE = 50;

    BgTriangleEffect() {
        this.tri = new Triangle[tri_len];
        this.create();
    }

    void draw() {
        for (Triangle t : tri) {
            if(t == null) {
                println("Don't create Triangle");
                return;
            }
            t.draw();
        }
    }

    BgTriangleEffect triangleFill(color c) {
        bg_effect_color = c;
        this.create();
        return this;
    }

    BgTriangleEffect volume(int n) {
        tri_len = n;
        this.create();
        return this;
    }

    private void create() {
        for (int i=0; i<tri_len; i++) {
            this.tri[i] = new Triangle(
                i, 
                random(width), random(height), 
                new PVector[]{new PVector(random(-TRI_SIZE, TRI_SIZE), random(-TRI_SIZE, TRI_SIZE)), new PVector(random(-TRI_SIZE, TRI_SIZE), random(-TRI_SIZE, TRI_SIZE)), new PVector(random(-TRI_SIZE, TRI_SIZE), random(-15, 15))}, 
                random(-0.1, 0.1), random(0.5, 2), 
                random(360), random(-0.05, 0.05), 
                bg_effect_color
                );
        }
    }

    private class Triangle {
        PVector pos, vec;
        PVector[] point;
        float rotate, vsp, alpha ;
        color c;
        int id;

        Triangle(int _id, float _x, float _y, PVector[] _point, float _vx, float _vy, float _rotate, float _vsp, color _c) {
            this.pos = new PVector(_x, _y);
            this.vec = new PVector(_vx, _vy);
            this.point = _point;
            this.rotate = _rotate;
            this.vsp = _vsp;
            this.c = _c;
            this.alpha = random(50, 150);
            this.id = _id;
        }

        void draw() {
            pushMatrix();
            translate(pos.x, pos.y);
            rotate(rotate);
            noStroke();
            push();
            fill(c, alpha);
            triangle(point[0].x, point[0].y, point[1].x, point[1].y, point[2].x, point[2].y);
            pop();
            popMatrix();
            update();
        }

        private void update() {
            rotate += (vsp > 360 ? 0 : vsp);
            pos.add(vec);
            if (pos.y > height + 50) {
                tri[id] = new Triangle(
                    id, 
                    random(width), random(-150), 
                    new PVector[]{new PVector(random(-TRI_SIZE, TRI_SIZE), random(-TRI_SIZE, TRI_SIZE)), new PVector(random(-TRI_SIZE, TRI_SIZE), random(-TRI_SIZE, TRI_SIZE)), new PVector(random(-TRI_SIZE, TRI_SIZE), random(-15, 15))}, 
                    random(-0.1, 0.1), random(0.5, 2), 
                    random(360), random(-0.05, 0.05), 
                    bg_effect_color
                    );
            }
        }
    }
}
