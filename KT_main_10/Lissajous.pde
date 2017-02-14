class Lissajous {
  ArrayList dataPos;
  int pointCount = 0;
  float zoom = 1;
  float offsetX=133, offsetY=54;                    //offsetX=150, offsetY=60
  float x1=0, y1=0;
  float minDistance = 20;                          //_parr 5-20
  PVector p=new PVector();
  float connectionRadius = 200;
  float PP=80;
  float lineAlpha = 60;
  int i1 = 0;

  Lissajous() {
    dataPos = new ArrayList();
  }

  void render(float P1x, float P1y, float cx, float cy) {
    pushMatrix();
    scale(zoom);
    x1 = P1x/zoom + offsetX;
    y1 = P1y/zoom + offsetY;
    computingPos(cx, cy);
    popMatrix();
  }

  void computingPos(float cx, float cy) {
    //----紀錄點數
    if (pointCount > 0) {
      p = (PVector) dataPos.get(pointCount-1);
      if (dist(x1, y1, p.x, p.y) > (minDistance))  
        dataPos.add(new PVector(x1, y1));
      brushColor1.append(cx);
      brushColor2.append(cy);
    } else {
      dataPos.add(new PVector(x1, y1));
      brushColor1.append(cx);
      brushColor2.append(cy);
    }
    pointCount = dataPos.size();
    //println("總共點數:" + pointCount);
  }

  void drawLine(PVector p1, PVector p2, float cx, float cy) {
    float d = PVector.dist(p1, p2);
    float a = pow(1/(d/connectionRadius+1), 6);

    if (d<PP) {             //_parr 50-80
      stroke(cx-(width/3), cy-(height/3), 77, a*lineAlpha + (i1%2 * 2));
      strokeWeight(2.5);
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
  void reset() {
    dataPos.clear();
    pointCount = 0;
    i1 = 0;
  }
}