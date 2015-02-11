import de.bezier.guido.*;
public static int NUM_ROWS=20;
public static int NUM_COLS=20;
public static int NUM_BOMBS=60;
public int nBombs=NUM_BOMBS;
public boolean isLost=false;
public boolean noBombs=true;
private MSButton[][] buttons=new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs=new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    stroke(0);
    // make the manager
    Interactive.make( this );
    
    for(int x=0;x<NUM_ROWS;x++)
    {
        for(int y=0;y<NUM_COLS;y++)
        {
            buttons[x][y] = new MSButton(x,y);
        }
    }
}
public void setBombs(int rr, int cc)
{
    if(rr-2 > 0 && cc-2 > 0) {bombs.add(buttons[rr-2][cc-2]);}
    if(rr-2 > 0 && cc+2 < 20) {bombs.add(buttons[rr-2][cc+2]);}
    if(rr+2 < 20 && cc-2 > 0) {bombs.add(buttons[rr+2][cc-2]);}
    if(rr+2 < 20 && cc+2 < 20) {bombs.add(buttons[rr+2][cc+2]);}
    for(int b=NUM_BOMBS-4;b>0;b--)
    {
        int r=(int)(Math.random()*20);
        int c=(int)(Math.random()*20);
        if(!bombs.contains(buttons[r][c]) && (!((r>=rr-1)&&(r<=rr+1)) || !((c>=cc-1)&&(c<=cc+1))) && !((r==rr-2)&&(c>=cc-1 && c<=cc+1)) && !((r==rr+2)&&(c>=cc-1 && c<=cc+1)) && !((c==cc-2)&&(r>=rr-1 && r<=rr+1)) && !((c==cc+2)&&(r>=rr-1 && r<=rr+1)))
        {
            bombs.add(buttons[r][c]);
        }
        else
        {
            b++;
            
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
    {
        displayWinningMessage();
    }
    else if(isLost==true)
    {
        displayLosingMessage();
        for(int x=0;x<NUM_ROWS;x++)
        {
            for(int y=0;y<NUM_COLS;y++)
            {
                buttons[x][y].mousePressed();
            }
        }
    }
}
public boolean isWon()
{
    for(int x=0;x<NUM_ROWS;x++)
    {
        for(int y=0;y<NUM_COLS;y++)
        {
            if(buttons[x][y].isClicked()==false)
            {
                if(!(bombs.contains(buttons[x][y]))) {return false;}
            }
        }
    } 
    return true;
}
public void displayLosingMessage()
{

}
public void displayWinningMessage()
{

}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager 
    
    public void mousePressed () 
    {
        if(mouseButton==LEFT)
        {
            if(noBombs==true)
            {
                noBombs=false;
                setBombs(r,c);
            }
            if(marked==false)
            {
                clicked=true;
            }
            if(clicked==true)
            {
                if(bombs.contains(this))
                {
                    isLost=true;
                }
                else if(countBombs(r,c)>0)
                {
                    if(!bombs.contains(this))
                    {
                        setLabel(""+countBombs(r,c));
                    }
                }
                else
                {
                    for(int row=r-1;row<=r+1;row++)
                    {
                        for(int col=c-1;col<=c+1;col++)
                        {
                            if(isValid(row,col) && !(buttons[row][col].isClicked()) && !(buttons[row][col].isMarked()))
                            {
                                buttons[row][col].mousePressed();
                            }
                        }
                    }
                }
            }  
        }
        if(noBombs==false)
        {
            if(mouseButton==RIGHT)
            {
                if(clicked==false)
                {
                    marked=!marked;

                }
            }
        }
    }

    public void draw () 
    {   
        if (clicked)
        {
            if(bombs.contains(this))
            {
                fill(255,0,0);
            }
            else
                fill(200);
        }
        else if(marked)
        {
            if(isWon() || (isLost && bombs.contains(this)))
            {
                fill(0,255,0);
            }
            else
            {
                fill( 255,255,0 );
            }
        }
        else
        {
            fill( 100 );
        }

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if((r<0 || r>19) || (c<0 || c>19))
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int c=col-1;c<=col+1;c++)
        {
            if(isValid(row-1,c))
            {
                if(bombs.contains(buttons[row-1][c]))
                {
                    numBombs++;
                }
            }
        }
        if(isValid(row,c-1))
        {
            if(bombs.contains(buttons[row][c-1]))
            {
                numBombs++;
            }
        }
        if(isValid(row,c+1))
        {
            if(bombs.contains(buttons[row][c+1]))
            {
                numBombs++;
            }
        }
        for(int c=col-1;c<=col+1;c++)
        {
            if(isValid(row+1,c))
            {
                if(bombs.contains(buttons[row+1][c]))
                {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}