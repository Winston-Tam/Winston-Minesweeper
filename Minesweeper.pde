import de.bezier.guido.*;
int NUM_ROWS = 28;
int NUM_COLS = 28;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines= new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    setMines();
}
public void setMines()
{
  while (mines.size() < (NUM_ROWS*NUM_COLS)*0.14){
  int r = (int)(Math.random()*NUM_ROWS);
  int c = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[r][c])){
  mines.add(buttons[r][c]);
  }
}
}

public void draw ()
{
    background(0);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
   for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c]) && !buttons[r][c].isClicked()) {
                return false; // A non-mine cell is still hidden
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    if (isWon() == false){
    fill(255);
    buttons[14][14].setLabel("Y");
    buttons[14][15].setLabel("O");
    buttons[14][16].setLabel("U");
    buttons[15][14].setLabel("L");
    buttons[15][15].setLabel("O");
    buttons[15][16].setLabel("S");
    buttons[15][17].setLabel("E");
  }
  for (int r = 0; r < NUM_ROWS;r++){
    for (int c = 0; c < NUM_COLS;c++){
      if (mines.contains(buttons[r][c]) && !buttons[r][c].isClicked())
      buttons[r][c].mousePressed();
    }
  }
}
public void displayWinningMessage()
{
    fill(255);
    buttons[14][14].setLabel("Y");
    buttons[14][15].setLabel("O");
    buttons[14][16].setLabel("U");
    buttons[15][14].setLabel("W");
    buttons[15][15].setLabel("I");
    buttons[15][16].setLabel("N");
    
}
public boolean isValid(int row, int col)
{
    //your code here
    if (row < NUM_ROWS && row >=0 && col < NUM_COLS && col>=0){
    return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int r = row-1; r < row+2; r++){ //rows
      for (int c = col-1; c < col+2; c++){ //columns
        if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines+=1;
      }
    }
    return numMines;
}
public class MSButton
{
      
    public boolean isClicked(){
  return clicked;
}

    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    public MSButton ( int row, int col )
    
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        println(mouseButton);
        if(mouseButton == RIGHT) {
          if (flagged == true){
          flagged = false;
          clicked = false;
          }
          else 
          flagged = true;
        }
        else if (mines.contains(this)){
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol)>0){
         setLabel(""+(countMines(myRow, myCol)));
        }
        else{
          for (int r = myRow-1; r <= myRow+1; r++){ //rows
      for (int c = myCol-1; c <= myCol+1; c++){ //columns
        if (isValid(r, c) && !buttons[r][c].clicked)
        buttons[r][c].mousePressed();
      }
    }
        }
        if (isWon()){
          displayWinningMessage();
        }
    }
        
        
    
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
        fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
