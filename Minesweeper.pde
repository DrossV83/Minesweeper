import de.bezier.guido.*;
int NUM_ROWS = 7;
int NUM_COLS = 7;
boolean L = false;
boolean W = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    mines = new ArrayList<MSButton>();

    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++)
        {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    
    
    setMines();
}
public void setMines()
{
    //your code
   int numMines = 5;
   while(mines.size() < numMines)
    {
        int r = (int)(Math.random() * NUM_ROWS);
        int c = (int)(Math.random() * NUM_COLS);

        if(!mines.contains(buttons[r][c]))
        {
            mines.add(buttons[r][c]);
        }
    }
}

public void draw ()
{
    background(0);
    for(int r = 0; r < NUM_ROWS; r++)
    {
        for(int c = 0; c < NUM_COLS; c++)
        {
            buttons[r][c].buttondraw();
        }
    }
    if(!L && isWon())
        W = true;
    if(L)
    {
        displayLosingMessage();
    }
    else if(W)
    {
        noLoop();
        displayWinningMessage();
        //println(isWon());
    }
}
public boolean isWon()
{
    for(int r=0;r<NUM_ROWS;r++)
    {
        for(int c=0; c<NUM_COLS;c++)
        {
            MSButton bleh = buttons[r][c];

            if(!mines.contains(bleh) && !bleh.clicked)
                return false;
}
    }
    return true;
}
public void displayLosingMessage()
{
    fill(255,0,0);
    textSize(67);
    text("LARP", width/2, height/2);
    for(MSButton b : mines)
    {
        b.setLabel("X");
    }
}
public void displayWinningMessage()
{
 fill(0,255,0);
    textSize(50);
    text("YOU WIN", width/2, height/2);
}
public boolean isValid(int r, int c){
  return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);  
}


public int countMines(int row, int col)
{
    int numMines = 0;
   for (int r = row - 1; r < row + 2; r++) {
    for (int c = col - 1; c < col + 2; c++) {
      if (isValid(r, c) == true  &&  mines.contains(buttons[r][c])&& (r!= row || c!= col))
            {
                numMines++;
            }
    }
  }
  return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y,width,height;
    private boolean clicked, flagged;
    private String myLabel;

    public MSButton(int row,int col)
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;

        myRow = row;
        myCol = col;

        x = myCol*width;
        y = myRow*height;

        myLabel = "";
        flagged = false;
        clicked = false;

        Interactive.add(this);
    }

    public void mousePressed()
    {
        if(mouseButton == RIGHT)
        {
            flagged = !flagged;

            if(!flagged)
                clicked = false;
            return;
        }
     if(flagged) return;
     clicked = true;
     if(mines.contains(this))
        {
            L = true;
        }
     else{
    int num = countMines(myRow,myCol);
     if(num > 0)
        {
            setLabel(num);
        }
     else
        {
         for(int r=myRow-1; r<=myRow+1; r++){
            for(int c=myCol-1; c<=myCol+1; c++){
               if(isValid(r,c) && !buttons[r][c].clicked){
                 buttons[r][c].mousePressed();}
                  }
               }
           }
       }  
   }

    public void buttondraw () 
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
        if(myLabel.equals("X")) textSize(67);
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
