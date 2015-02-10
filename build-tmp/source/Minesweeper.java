import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.bezier.guido.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Minesweeper extends PApplet {


public static int NUM_ROWS=20;
public static int NUM_COLS=20;
public static int NUM_BOMBS=40;
public int nBombs=NUM_BOMBS;
private MSButton[][] buttons=new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs=new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
public int nB=0;

public void setup ()
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

    //declare and initialize buttons
    setBombs();
    println("nB: "+nB);
}
public void setBombs()
{
    for(int b=NUM_BOMBS;b>0;b--)
    {
        int r=(int)(Math.random()*20);
        int c=(int)(Math.random()*20);
        if(!bombs.contains(buttons[r][c]))
        {
            bombs.add(buttons[r][c]);
            nB++;
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
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
    println("Losing Message");
}
public void displayWinningMessage()
{
    //your code here
    println("Winning Message");
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
            if(marked==false)
            {
                clicked=true;
            }
            if(bombs.contains(this))
            {
                displayLosingMessage();
            }
            else if(countBombs(r,c)>0)
            {
                setLabel(""+countBombs(r,c));
            }
            else
            {
                for(int row=r-1;row<=r+1;row++)
                {
                    for(int col=c-1;col<=c+1;col++)
                    {
                        if(isValid(row,col))
                        {
                            buttons[row][col].mousePressed();
                        }
                    } 
                }
            }
        }
        if(mouseButton==RIGHT)
        {
            if(clicked==false)
            {
                marked=!marked;
            }
        }
        //your code here 
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
            fill( 255,255,0 );
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
        //your code here
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
        //your code here
        for(int r=row-1;r<=row+1;r++)
        {
            for(int c=col-1;c<=col+1;c++)
            {
                if(isValid(r,c))
                {
                    if(bombs.contains(buttons[r][c]))
                    {
                        numBombs++;
                    }
                } 
            }
        }
        return numBombs;
    }
}



  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Minesweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
