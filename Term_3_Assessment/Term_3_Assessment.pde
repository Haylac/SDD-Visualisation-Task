void setup() { //<>//
  size(1000, 1000);
  background(255);
  moving = -1;
  // Text Properties
  textSize(26);
  textAlign(CENTER);
}

//Properties of the object array Vertex[]
class Vertex {
  String name;
  int[] colour = new int[3];
  float[] distances = new float[0];
  int x; //mouseX
  int y; //mouseY
}

void mousePressed() {
  moving = -1;
  if (mouseButton == RIGHT) {
    //remove current vertex
    for (int i = 0; i < vertices.length; i++) {
      if (vertices[i].x >= mouseX -int(radius/2) && vertices[i].x <= mouseX + int(radius/2) && vertices[i].y >= mouseY - int(radius/2) && vertices[i].y <= mouseY + int(radius/2)) {
        vertices[i] = vertices[vertices.length - 1]; 
        Vertex[] shortenedArray = (Vertex[])shorten(vertices);
        vertices = shortenedArray;
      }
    }
  }

  if (mouseButton == LEFT) {
    //check if mousepoint is in the area of an array. 
    for (int i = 0; i < vertices.length; i++) {
      if (vertices[i].x >= mouseX -int(radius/2) && vertices[i].x <= mouseX + int(radius/2) && vertices[i].y >= mouseY - int(radius/2) && vertices[i].y <= mouseY + int(radius/2)) {
        moving = i;
      }
    }

    //Export distance data as CSV file, named as distances.txt inside the program directory
    if (mouseX >= 10 && mouseX <= 130 && mouseY >= 10 && mouseY <= 130) {
      String[] store = new String[vertices.length];
      String merge = "";
      for ( int i=0; i<vertices.length; i++) {
        merge = vertices[i].name;
        for (int k=0; k<i; k++) {
          merge = merge + "," + int(vertices[i].distances[k]);
        }
        if (i > 0) {
          merge = merge.substring(0, merge.length()-1);
        }
        store[i] = merge;
      }
      saveStrings("distances.txt", store);
    } else {
      //Import distance data file, named as distances.txt located in the program directory
      if (mouseX >= 870 && mouseX <= 990 && mouseY >= 10 && mouseY <= 130) {
        String[] imports = loadStrings("distances.txt");
        vertices = new Vertex[imports.length];
        for (int i=0; i <imports.length; i++) {
          String[] item = split(imports[i], ',');
          vertices[i] = new Vertex();
          vertices[i].name = item[0];
          vertices[i].distances = expand(vertices[i].distances, imports.length);
          for (int j=0; j<item.length - 1; j++) {
            vertices[i].distances[j] = float(item[j + 1]);
          }
          vertices[i].x = int(width/4+random(width/2));
          vertices[i].y = width/2;
          //Give a random colour to the array
          for (int c = 0; c<3; c++) {
            vertices[i].colour[c] = int(random(180, 240));  //180 to 240 as dark colours made it hard to see the text
          }
        }
        importing = true;
      } else {
        //Clear vertex data 
        if (mouseX >= 10 && mouseX <=130 && mouseY >= 870 && mouseY <= 990) {
          vertices = null;
          vertices = new Vertex[0];
        } else {
          if (moving == -1) {
            //onpress make new array, record x,y values and save it to the newly created array.
            vertices = (Vertex[])append(vertices, new Vertex());
            vertices[vertices.length - 1].x = mouseX;
            vertices[vertices.length - 1].y = mouseY;
            vertices[vertices.length-1].name ="";  //used to prevent NULL
            //Give a random colour to the array
            for (int i = 0; i < 3; i++) {
              vertices[vertices.length - 1].colour[i] = int(random(180, 240));  //180 to 240 as dark colours made it hard to see the text
            }
          }
        }
      }
    }
  }
}

void keyPressed() {
  //Lets the user type a name for the vertex 
  if (key == CODED) {
    //do nothing - used to prevent ASCII keys being entered into the name field
  } else {
    //Deletes latest key if the user hits the backspace key. 
    if (keyCode == BACKSPACE && vertices[vertices.length-1].name.length() > 0) {
      vertices[vertices.length-1].name = vertices[vertices.length-1].name.substring(0, vertices[vertices.length-1].name.length()-1);
    } else {  //Lets the user type a name for the vertex 
      vertices[vertices.length-1].name = vertices[vertices.length-1].name + key;
    }
  }
}

//variable list
boolean importing = false;
int moving;
int radius = 100;
int brad = 120;
Vertex[] vertices = new Vertex[0];

void draw() {
  clear();
  background(255);
  fill(255);

  //draw btn's to export, import and clear.
  fill(255);
  ellipse(70, 70, brad, brad);  //EXPORT
  ellipse(930, 70, brad, brad);  //IMPORT
  ellipse(70, 930, brad, brad); // CLEAR
  fill(60);
  text("Clear", 70, 930);
  text("Export", 70, 70);
  text("Import", 930, 70);

  //draws a circle from the x,y coords of the array...
  for (int i = 0; i < vertices.length; i++) {
    fill(vertices[i].colour[0], vertices[i].colour[1], vertices[i].colour[2]);
    ellipse(vertices[i].x, vertices[i].y, radius, radius);
  } 

  //creates a line from one point to all other points...
  for (int i = 0; i < vertices.length; i++) {
    for (int j = 0; j < vertices.length; j++) {
      line(vertices[i].x, vertices[i].y, vertices[j].x, vertices[j].y);
    }
  }

  //refresh text so it doesnt get wiped during clear
  for (int i=0; i < vertices.length; i++) {
    fill(60);
    textAlign(CENTER);
    text(vertices[i].name, vertices[i].x, vertices[i].y);
  }

  //calculate the distance between each vertex and store it in an array
  for (int i = 0; i < vertices.length; i++) {
    vertices[i].distances = new float[0];
    for (int j = 0; j < vertices.length; j++) {
      vertices[i].distances = (float[])append(vertices[i].distances, dist(vertices[i].x, vertices[i].y, vertices[j].x, vertices[j].y));
    }
  }

  //update vertex and text when moved
  if (moving >= 0 && mousePressed == true) {
    vertices[moving].x = mouseX;
    vertices[moving].y = mouseY;
    fill(60);
    textAlign(CENTER);
    text(vertices[moving].name, vertices[moving].x, vertices[moving].y);
  }
}
