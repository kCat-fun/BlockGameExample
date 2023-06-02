public class App {
    private Page pages[];
    private int pageNum;

    App() {
        pageNum = 0;
        pages = new Page[] {
            new Title(),
            new Game()
        };
    }

    public void run() {
        pages[pageNum].draw();
    }
    
    public int getPageNum() {
        return pageNum;
    }
    
    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
        pages[pageNum].setup();
    }

    public void keyPressed() {
    }

    public void mousePressed() {
    }
}
