App app;
KBSetup kbSetup;
Particles particles;
BgTriangleEffect bgTriangleEffect;

void setup() {
    size(500, 600);
    kbSetup = new KBSetup(this);
    particles = new Particles(this);
    bgTriangleEffect = new BgTriangleEffect();
    bgTriangleEffect.volume(50);
    frameRate(60);
    app = new App();
}

void draw() {
    app.run();
}

void keyPressed() {
    app.keyPressed();
}

void mousePressed() {
    app.mousePressed();
}
